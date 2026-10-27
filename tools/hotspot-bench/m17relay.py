#!/usr/bin/env python3
"""M17 bench relay for an MMDVMHost hotspot with no network (runs on the hotspot, stands in for M17Gateway).

MMDVMHost [M17 Network] talks UDP to 127.0.0.1:17010 from 17011 in the M17 network packet format (54 bytes: "M17 ",
stream id, 28-byte link setup data, frame number, 16 bytes of Codec 2 3200, CRC-16). This relay:
  * decodes every transmission the hotspot hears over RF (c2tool dec) and streams the audio to a connected PC client;
  * takes audio from the PC client, encodes it (c2tool enc) and sends it to MMDVMHost, so the hotspot transmits it;
  * optional parrot: replays each heard transmission back through the hotspot.
PC protocol on TCP port 8080 (already open in the WPSD firewall), one client at a time. Every message is 1 type byte, 4-byte big-endian length, payload:
  client -> relay  'T' JSON {"src": "N0CALL", "dst": "@ALL"} then 'P' s16le 8 kHz mono PCM chunks, then 'E' (send it)
                   'R' JSON {"parrot": true|false}
                   'S' stop: ends a transmission in progress with an end frame
  relay -> client  'H' JSON {"event": "start"|"end"|"sent"|"info", ...}  'A' s16le 8 kHz mono PCM of what was heard
No internet and no reflector are involved. Written for the SignalDeck bench.
"""
import json, os, socket, struct, subprocess, threading, time

HERE = os.path.dirname(os.path.abspath(__file__))
C2 = os.path.join(HERE, "c2", "c2tool")
MMDVM = ("127.0.0.1", 17011)
CHARS = " ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-/."

def crc16(b):
    c = 0xFFFF
    for x in b:
        c ^= x << 8
        for _ in range(8):
            c = ((c << 1) ^ 0x5935) & 0xFFFF if c & 0x8000 else (c << 1) & 0xFFFF
    return c

def call_enc(cs):
    cs = cs.strip().upper()
    if cs in ("@ALL", "ALL", ""): return b"\xff" * 6
    v = 0
    for ch in reversed(cs[:9]):
        i = CHARS.find(ch); v = v * 40 + (i if i > 0 else 0)
    return v.to_bytes(6, "big")

def call_dec(b):
    v = int.from_bytes(b, "big")
    if v == 0xFFFFFFFFFFFF: return "@ALL"
    if v >= 262144000000000: return "#%012x" % v
    s = ""
    while v: s += CHARS[v % 40]; v //= 40
    return s.strip()

class Relay:
    def __init__(self):
        self.udp = socket.socket(socket.AF_INET, socket.SOCK_DGRAM); self.udp.bind(("127.0.0.1", 17010))
        self.client = None; self.lock = threading.Lock(); self.parrot = False; self.sending = False; self.abort = False
        self.rx = None   # current RF transmission: dict with dec process, packets, ids
        threading.Thread(target=self.udp_loop, daemon=True).start()

    def to_client(self, kind, payload):
        with self.lock:
            c = self.client
            if not c: return
            try: c.sendall(kind + struct.pack(">I", len(payload)) + payload)
            except OSError: self.client = None

    def event(self, **kv):
        print(time.strftime("%H:%M:%S"), kv, flush=True)
        self.to_client(b"H", json.dumps(kv).encode())

    # ---- what the hotspot hears ----
    def udp_loop(self):
        self.udp.settimeout(0.3)
        while True:
            try:
                d, _ = self.udp.recvfrom(2048)
            except socket.timeout:
                if self.rx and time.time() - self.rx["last"] > 0.6: self.rx_end("timeout")
                continue
            if d[:4] != b"M17 " or len(d) != 54: continue
            if self.sending: continue                      # our own transmission looped back: ignore
            sid = d[4:6]; fn = int.from_bytes(d[34:36], "big")
            if not self.rx or self.rx["sid"] != sid:
                if self.rx: self.rx_end("new stream")
                p = subprocess.Popen([C2, "dec"], stdin=subprocess.PIPE, stdout=subprocess.PIPE)
                self.rx = {"sid": sid, "proc": p, "pkts": [], "t0": time.time(), "last": time.time(),
                           "dst": call_dec(d[6:12]), "src": call_dec(d[12:18]), "type": d[18:20].hex()}
                threading.Thread(target=self.pump, args=(p,), daemon=True).start()
                self.event(event="start", src=self.rx["src"], dst=self.rx["dst"], type=self.rx["type"])
            self.rx["pkts"].append(d); self.rx["last"] = time.time()
            try: self.rx["proc"].stdin.write(d[36:52]); self.rx["proc"].stdin.flush()
            except OSError: pass
            if fn & 0x8000: self.rx_end("end bit")

    def pump(self, p):
        while True:
            b = p.stdout.read(640)                         # two Codec 2 frames = 40 ms
            if not b: break
            self.to_client(b"A", b)

    def rx_end(self, why):
        r, self.rx = self.rx, None
        if not r: return
        try: r["proc"].stdin.close()
        except OSError: pass
        self.event(event="end", src=r["src"], dst=r["dst"], frames=len(r["pkts"]), seconds=round(len(r["pkts"]) * 0.04, 2), why=why)
        if self.parrot and r["pkts"]:
            threading.Thread(target=self.replay, args=(r["pkts"],), daemon=True).start()

    def replay(self, pkts):
        time.sleep(1.5); self.sending = True
        try:
            t0 = time.time()
            for i, d in enumerate(pkts):
                w = t0 + i * 0.04 - time.time()
                if w > 0: time.sleep(w)
                self.udp.sendto(d, MMDVM)
        finally:
            time.sleep(0.3); self.sending = False
        self.event(event="info", text="parrot replayed %d frames" % len(pkts))

    # ---- what the PC sends ----
    def transmit(self, pcm, src, dst):
        enc = subprocess.run([C2, "enc"], input=pcm, stdout=subprocess.PIPE).stdout
        n = len(enc) // 16
        if n == 0: self.event(event="info", text="nothing to send"); return
        sid = os.urandom(2)
        lsd = call_enc(dst) + call_enc(src) + bytes.fromhex("0005") + bytes(14)
        self.sending = True; self.abort = False; stopped = False
        try:
            t0 = time.time()
            for i in range(n):
                if self.abort:
                    n = i + 1; stopped = True
                fn = i | (0x8000 if i == n - 1 else 0)
                body = b"M17 " + sid + lsd + fn.to_bytes(2, "big") + enc[i * 16:(i + 1) * 16]
                pkt = body + crc16(body).to_bytes(2, "big")
                w = t0 + i * 0.04 - time.time()
                if w > 0: time.sleep(w)
                self.udp.sendto(pkt, MMDVM)
                if stopped: break
        finally:
            time.sleep(0.3); self.sending = False; self.abort = False
        self.event(event="sent", src=src, dst=dst, frames=n, seconds=round(n * 0.04, 2), stopped=stopped)

    def serve(self, port=8080):
        srv = socket.socket(); srv.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1); srv.bind(("0.0.0.0", port)); srv.listen(1)
        print("relay ready on tcp %d" % port, flush=True)
        while True:
            c, addr = srv.accept()
            with self.lock: self.client = c
            self.event(event="info", text="connected from %s" % addr[0])
            threading.Thread(target=self.client_loop, args=(c,), daemon=True).start()

    def client_loop(self, c):
        hdr, pcm = {}, bytearray()
        def rd(n):
            b = b""
            while len(b) < n:
                x = c.recv(n - len(b))
                if not x: raise EOFError
                b += x
            return b
        try:
            while True:
                kind = rd(1); n = struct.unpack(">I", rd(4))[0]; data = rd(n) if n else b""
                if kind == b"T": hdr = json.loads(data or b"{}"); pcm = bytearray()
                elif kind == b"P": pcm += data
                elif kind == b"E":
                    src = (hdr.get("src") or "N0CALL"); dst = (hdr.get("dst") or "@ALL")
                    threading.Thread(target=self.transmit, args=(bytes(pcm), src, dst), daemon=True).start(); pcm = bytearray()
                elif kind == b"S":
                    if self.sending: self.abort = True
                elif kind == b"R":
                    self.parrot = bool(json.loads(data or b"{}").get("parrot")); self.event(event="info", text="parrot %s" % ("on" if self.parrot else "off"))
        except (EOFError, OSError):
            with self.lock:
                if self.client is c: self.client = None
            print(time.strftime("%H:%M:%S"), "client gone", flush=True)

if __name__ == "__main__":
    import sys
    r = Relay(); r.parrot = "--parrot" in sys.argv
    r.serve()
