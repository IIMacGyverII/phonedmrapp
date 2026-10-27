#!/usr/bin/env python3
"""M17 hotspot bench: send audio files through the hotspot and hear what it receives.

Talks to m17relay.py on the hotspot (TCP 8080). Needs Python 3 and ffmpeg/ffplay on the PATH or next to ffmpeg.
  python m17bench.py                       the window: Connect, Send audio file, Listen, Save last heard, Parrot
  python m17bench.py --send song.mp3       command line: send one file and exit
  python m17bench.py --listen 30 --save heard.wav   command line: listen for 30 s, save what was heard
Options: --host 192.168.1.194  --src N0CALL  --dst @ALL  --max 120 (seconds of a file to send)
"""
import argparse, json, os, queue, shutil, socket, struct, subprocess, sys, threading, time, wave

def find_tool(name):
    p = shutil.which(name)
    if p: return p
    ff = shutil.which("ffmpeg")
    if ff:
        cand = os.path.join(os.path.dirname(ff), name + (".exe" if os.name == "nt" else ""))
        if os.path.exists(cand): return cand
    return None

def load_audio(path, max_s):
    ff = find_tool("ffmpeg")
    if not ff: raise RuntimeError("ffmpeg not found")
    r = subprocess.run([ff, "-v", "error", "-i", path, "-t", str(max_s), "-ac", "1", "-ar", "8000", "-f", "s16le", "-"],
                       stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    if r.returncode != 0: raise RuntimeError(r.stderr.decode(errors="replace")[-300:])
    return r.stdout

class Link:
    def __init__(self, host, port=8080, on_event=None, on_audio=None):
        self.s = socket.create_connection((host, port), timeout=5); self.s.settimeout(None)
        self.on_event = on_event or (lambda e: None); self.on_audio = on_audio or (lambda b: None)
        threading.Thread(target=self.loop, daemon=True).start()

    def msg(self, kind, payload=b""):
        self.s.sendall(kind + struct.pack(">I", len(payload)) + payload)

    def send_pcm(self, pcm, src, dst):
        self.msg(b"T", json.dumps({"src": src, "dst": dst}).encode())
        for i in range(0, len(pcm), 32000): self.msg(b"P", pcm[i:i + 32000])
        self.msg(b"E")

    def parrot(self, on): self.msg(b"R", json.dumps({"parrot": bool(on)}).encode())

    def stop(self): self.msg(b"S")

    def loop(self):
        def rd(n):
            b = b""
            while len(b) < n:
                x = self.s.recv(n - len(b))
                if not x: raise EOFError
                b += x
            return b
        try:
            while True:
                kind = rd(1); n = struct.unpack(">I", rd(4))[0]; data = rd(n) if n else b""
                if kind == b"H": self.on_event(json.loads(data))
                elif kind == b"A": self.on_audio(data)
        except (EOFError, OSError):
            self.on_event({"event": "info", "text": "disconnected"})

class Player:
    """Live playback of 8 kHz mono PCM through ffplay."""
    def __init__(self):
        fp = find_tool("ffplay")
        self.p = subprocess.Popen([fp, "-nodisp", "-loglevel", "quiet", "-f", "s16le", "-ar", "8000", "-ch_layout", "mono", "-i", "-"],
                                  stdin=subprocess.PIPE) if fp else None
    def write(self, b):
        if self.p:
            try: self.p.stdin.write(b); self.p.stdin.flush()
            except OSError: self.p = None
    def close(self):
        if self.p:
            try: self.p.stdin.close(); self.p.terminate()
            except OSError: pass

def save_wav(path, pcm):
    with wave.open(path, "wb") as w:
        w.setnchannels(1); w.setsampwidth(2); w.setframerate(8000); w.writeframes(pcm)

def cli(a):
    heard = bytearray(); done = threading.Event()
    def ev(e):
        print(time.strftime("%H:%M:%S"), e, flush=True)
        if e.get("event") == "sent": done.set()
    link = Link(a.host, on_event=ev, on_audio=lambda b: heard.extend(b))
    if a.send:
        pcm = load_audio(a.send, a.max)
        print("sending %.1f s from %s as %s to %s" % (len(pcm) / 16000, a.send, a.src, a.dst), flush=True)
        link.send_pcm(pcm, a.src, a.dst)
        done.wait(len(pcm) / 16000 + 20)
    if a.listen:
        print("listening %d s" % a.listen, flush=True); time.sleep(a.listen)
        if a.save: save_wav(a.save, bytes(heard)); print("saved %.1f s to %s" % (len(heard) / 16000, a.save))

def gui(a):
    import tkinter as tk
    from tkinter import filedialog, ttk
    root = tk.Tk(); root.title("M17 Hotspot Bench"); root.geometry("620x460")
    q = queue.Queue(); st = {"link": None, "player": None, "heard": bytearray(), "last": bytearray(), "mute": False}
    top = ttk.Frame(root, padding=8); top.pack(fill="x")
    host = tk.StringVar(value=a.host); src = tk.StringVar(value=a.src); dst = tk.StringVar(value=a.dst)
    listen = tk.BooleanVar(value=True); parrot = tk.BooleanVar(value=False)
    for i, (lab, var, w) in enumerate((("Hotspot", host, 16), ("Source", src, 10), ("Destination", dst, 10))):
        ttk.Label(top, text=lab).grid(row=0, column=2 * i, sticky="w", padx=(0, 4))
        ttk.Entry(top, textvariable=var, width=w).grid(row=0, column=2 * i + 1, padx=(0, 10))
    bar = ttk.Frame(root, padding=(8, 0)); bar.pack(fill="x")
    log = tk.Text(root, height=18, wrap="word"); log.pack(fill="both", expand=True, padx=8, pady=8)
    def say(t): log.insert("end", time.strftime("%H:%M:%S ") + t + "\n"); log.see("end")
    def on_event(e): q.put(("ev", e))
    def on_audio(b): q.put(("au", b))
    def connect():
        try:
            st["link"] = Link(host.get().strip(), on_event=on_event, on_audio=on_audio); say("connected to " + host.get())
            st["link"].parrot(parrot.get())
        except OSError as e: say("connect failed: %s" % e)
    def send():
        if not st["link"]: say("connect first"); return
        f = filedialog.askopenfilename(filetypes=[("Audio", "*.wav *.mp3 *.flac *.ogg *.m4a"), ("All", "*.*")])
        if not f: return
        def work():
            try:
                pcm = load_audio(f, a.max); q.put(("say", "sending %.1f s of %s" % (len(pcm) / 16000, os.path.basename(f))))
                st["link"].send_pcm(pcm, src.get().strip() or "N0CALL", dst.get().strip() or "@ALL")
            except Exception as e: q.put(("say", "send failed: %s" % e))
        threading.Thread(target=work, daemon=True).start()
    def save():
        if not st["last"]: say("nothing heard yet"); return
        f = filedialog.asksaveasfilename(defaultextension=".wav", filetypes=[("WAV", "*.wav")])
        if f: save_wav(f, bytes(st["last"])); say("saved " + f)
    def stop():
        if st["link"]:
            try: st["link"].stop()
            except OSError: pass
        if st["player"]: st["player"].close(); st["player"] = None
        st["mute"] = True
        say("stopped: sending ended, playback cut (the next transmission plays again)")
    def set_parrot():
        if st["link"]: st["link"].parrot(parrot.get())
    ttk.Button(bar, text="Connect", command=connect).pack(side="left")
    ttk.Button(bar, text="Send audio file…", command=send).pack(side="left", padx=6)
    ttk.Button(bar, text="Stop", command=stop).pack(side="left", padx=6)
    ttk.Checkbutton(bar, text="Listen", variable=listen).pack(side="left", padx=6)
    ttk.Checkbutton(bar, text="Parrot", variable=parrot, command=set_parrot).pack(side="left", padx=6)
    ttk.Button(bar, text="Save last heard…", command=save).pack(side="left", padx=6)
    def tick():
        while not q.empty():
            k, v = q.get()
            if k == "say": say(v)
            elif k == "ev":
                e = v.get("event")
                if e == "start":
                    st["heard"] = bytearray(); st["mute"] = False; say("hearing %s -> %s" % (v.get("src"), v.get("dst")))
                    if listen.get() and not st["player"]: st["player"] = Player()
                elif e == "end":
                    st["last"] = st["heard"]; say("end %s -> %s, %s s, %s frames" % (v.get("src"), v.get("dst"), v.get("seconds"), v.get("frames")))
                elif e == "sent": say("hotspot sent %s s as %s -> %s%s" % (v.get("seconds"), v.get("src"), v.get("dst"), " (stopped)" if v.get("stopped") else ""))
                else: say(v.get("text", json.dumps(v)))
            elif k == "au":
                st["heard"].extend(v)
                if listen.get() and not st["mute"]:
                    if not st["player"]: st["player"] = Player()
                    st["player"].write(v)
        root.after(50, tick)
    root.after(50, tick)
    root.protocol("WM_DELETE_WINDOW", lambda: (st["player"] and st["player"].close(), root.destroy()))
    root.mainloop()

if __name__ == "__main__":
    ap = argparse.ArgumentParser()
    ap.add_argument("--host", default="192.168.1.194"); ap.add_argument("--src", default="N0CALL"); ap.add_argument("--dst", default="@ALL")
    ap.add_argument("--max", type=int, default=120); ap.add_argument("--send"); ap.add_argument("--listen", type=int, default=0); ap.add_argument("--save")
    a = ap.parse_args()
    (cli if (a.send or a.listen) else gui)(a)
