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
                   'Q' replay the last DMR call the hotspot heard (the hotspot transmits it again)
                   'G' JSON {"ric": 1234, "func": 3, "text": "...", "numeric": false}: a POCSAG page via DAPNETGateway
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

def hotspot_can():
    """The channel access number in /etc/mmdvmhost [M17]: M17 receivers drop a transmission with another CAN."""
    try:
        sec = None
        for line in open("/etc/mmdvmhost"):
            line = line.strip()
            if line.startswith("["): sec = line
            elif sec == "[M17]" and line.startswith("CAN="): return max(0, min(15, int(line[4:])))
    except (OSError, ValueError): pass
    return 0

class DapnetCore:
    """A stand-in for the DAPNET core on 127.0.0.1:14343 (outside the ephemeral port range: on 43434 the gateway once connected to itself), so the hotspot's own DAPNETGateway transmits our pages.
    Implements the legacy transmitter protocol: the gateway logs in with "[type vX CALL KEY]", the core runs a few
    time-sync rounds ("2:TTTT", answered "2:TTTT:CCCC" then "+"), sends the time adjust ("3:+0000") and the time slots
    ("4:0123456789ABCDEF", all slots), then pages as "#NN 6:1:<RIC hex>:<function>:<text>" (6 = alphanumeric,
    5 = numeric; 1 = 1200 baud), each acknowledged "#NN +". Written from the protocol, for the bench only."""
    def __init__(self, relay, port=14343):
        self.relay = relay; self.port = port; self.q = []; self.cv = threading.Condition(); self.seq = 0; self.online = False
        threading.Thread(target=self.serve, daemon=True).start()

    def page(self, ric, func, text, numeric=False):
        with self.cv:
            self.seq = (self.seq + 1) % 256
            self.q.append((self.seq, ric, func, text, numeric)); self.cv.notify()
        return self.seq

    def serve(self):
        while True:                                       # a restart can find the port still held for a moment: retry
            try:
                srv = socket.socket(); srv.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1); srv.bind(("127.0.0.1", self.port)); srv.listen(1); break
            except OSError:
                srv.close(); time.sleep(2)
        while True:
            c, _ = srv.accept()
            try: self.session(c)
            except Exception as e: self.relay.event(event="info", text="dapnet session ended: %s" % e)
            finally:
                self.online = False
                try: c.close()
                except OSError: pass

    def session(self, c):
        f = c.makefile("rwb", buffering=0)
        def line():
            b = f.readline()
            if not b: raise EOFError("gateway closed")
            return b.decode(errors="replace").strip()
        def send(t): f.write((t + chr(10)).encode())
        login = line()
        self.relay.event(event="info", text="dapnet gateway logged in: %s" % login.split(" ")[0])
        for _ in range(2):
            t = "%04X" % (int(time.time() * 10) & 0xFFFF)
            send("2:" + t); line(); line()
        send("3:+0000"); line()
        send("4:0123456789ABCDEF"); line()
        self.online = True; self.relay.event(event="info", text="dapnet link online")
        c.settimeout(0.5)
        while True:
            with self.cv:
                while not self.q:
                    if not self.cv.wait(timeout=20): break
                item = self.q.pop(0) if self.q else None
            if item is None:
                continue
            seq, ric, func, text, numeric = item
            send("#%02X %d:1:%X:%d:%s" % (seq, 5 if numeric else 6, ric, func, text))
            ack = ""
            t0 = time.time()
            while time.time() - t0 < 10:
                try: ack = line(); break
                except socket.timeout: continue
            self.relay.event(event="page", seq=seq, ric=ric, func=func, text=text, ack=ack)

DMR_HOST = ("127.0.0.1", 62032)

def dmr_fields(d):
    """A DMRD packet: "DMRD", seq, source 3, destination 3, repeater 4, flags, stream 4, 33-byte burst."""
    f = d[15]
    return {"seq": d[4], "src": int.from_bytes(d[5:8], "big"), "dst": int.from_bytes(d[8:11], "big"),
            "slot": 2 if f & 0x80 else 1, "private": bool(f & 0x40), "ftype": (f >> 4) & 3, "dtype": f & 0x0F,
            "stream": d[16:20]}

class Relay:
    def __init__(self):
        self.udp = socket.socket(socket.AF_INET, socket.SOCK_DGRAM); self.udp.bind(("127.0.0.1", 17010))
        self.client = None; self.lock = threading.Lock(); self.parrot = False; self.sending = False; self.abort = False
        self.rx = None   # current RF transmission: dict with dec process, packets, ids
        threading.Thread(target=self.udp_loop, daemon=True).start()
        # DMR: MMDVMHost's [DMR Network] Type=Gateway talks to 127.0.0.1:62031 from 62032 (DMRC config every 10 s, DMRD bursts)
        self.dmr = socket.socket(socket.AF_INET, socket.SOCK_DGRAM); self.dmr.bind(("127.0.0.1", 62031))
        self.dmr_rx = None; self.dmr_last = self.load_dmr(); self.dmr_sending = False
        threading.Thread(target=self.dmr_loop, daemon=True).start()

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

    # ---- DMR: record, parrot, replay ----
    def dmr_loop(self):
        self.dmr.settimeout(0.3)
        while True:
            try:
                d, _ = self.dmr.recvfrom(2048)
            except socket.timeout:
                if self.dmr_rx and time.time() - self.dmr_rx["last"] > 1.0: self.dmr_end("timeout")
                continue
            if d[:4] != b"DMRD" or len(d) < 53 or self.dmr_sending: continue
            f = dmr_fields(d); now = time.time()
            if not self.dmr_rx or self.dmr_rx["stream"] != f["stream"]:
                if self.dmr_rx: self.dmr_end("new stream")
                self.dmr_rx = dict(f, pkts=[], t0=now, last=now)
                self.event(event="dmr_start", src=f["src"], dst=f["dst"], slot=f["slot"], private=f["private"])
            self.dmr_rx["pkts"].append((now, d)); self.dmr_rx["last"] = now
            if f["ftype"] == 2 and f["dtype"] == 2: self.dmr_end("terminator")

    DMR_FILE = os.path.join(HERE, "dmr_last.bin")

    def save_dmr(self, pkts):
        """The last DMR call on disk (relative time in ms, 4 bytes; packet length, 2 bytes; packet), so a restart keeps it."""
        try:
            t0 = pkts[0][0]
            with open(self.DMR_FILE, "wb") as f:
                for t, d in pkts: f.write(struct.pack(">IH", int((t - t0) * 1000), len(d)) + d)
        except (OSError, IndexError): pass

    def load_dmr(self):
        out = []
        try:
            b = open(self.DMR_FILE, "rb").read(); i = 0
            while i + 6 <= len(b):
                ms, n = struct.unpack(">IH", b[i:i + 6]); out.append((ms / 1000.0, b[i + 6:i + 6 + n])); i += 6 + n
        except OSError: pass
        return out

    def dmr_end(self, why):
        r, self.dmr_rx = self.dmr_rx, None
        if not r: return
        self.dmr_last = r["pkts"]; self.save_dmr(r["pkts"])
        secs = round(r["pkts"][-1][0] - r["pkts"][0][0], 2) if r["pkts"] else 0
        self.event(event="dmr_end", src=r["src"], dst=r["dst"], slot=r["slot"], private=r["private"], frames=len(r["pkts"]), seconds=secs, why=why)
        if self.parrot and r["pkts"]:
            threading.Thread(target=self.dmr_replay, args=(r["pkts"],), daemon=True).start()

    def dmr_replay(self, pkts=None):
        pkts = pkts or self.dmr_last
        if not pkts: self.event(event="info", text="no DMR call recorded yet"); return
        time.sleep(3.0); self.dmr_sending = True          # a radio that just unkeyed needs a moment before it hears again
        try:
            sid = os.urandom(4); t0 = pkts[0][0]; r0 = time.time()
            for t, d in pkts:
                w = (t - t0) - (time.time() - r0)
                if w > 0: time.sleep(w)
                self.dmr.sendto(d[:16] + sid + d[20:], DMR_HOST)    # same call, a new stream id
        finally:
            time.sleep(0.3); self.dmr_sending = False
        f = dmr_fields(pkts[0][1])
        self.event(event="info", text="DMR replay sent: %d bursts, %s %d -> %d, slot %d" % (len(pkts), "private" if f["private"] else "group", f["src"], f["dst"], f["slot"]))

    # ---- what the PC sends ----
    def transmit(self, pcm, src, dst):
        enc = subprocess.run([C2, "enc"], input=pcm, stdout=subprocess.PIPE).stdout
        n = len(enc) // 16
        if n == 0: self.event(event="info", text="nothing to send"); return
        sid = os.urandom(2)
        lsd = call_enc(dst) + call_enc(src) + (0x0005 | (hotspot_can() << 7)).to_bytes(2, "big") + bytes(14)   # stream, voice 3200, the hotspot's CAN
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
                elif kind == b"G":
                    g = json.loads(data or b"{}")
                    if not self.dapnet.online: self.event(event="info", text="dapnet link not online; page queued")
                    seq = self.dapnet.page(int(g.get("ric", 0)), int(g.get("func", 3)), str(g.get("text", ""))[:80], bool(g.get("numeric")))
                    self.event(event="info", text="page #%02X queued for RIC %s" % (seq, g.get("ric")))
                elif kind == b"Q":
                    threading.Thread(target=self.dmr_replay, daemon=True).start()
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
    r = Relay(); r.parrot = "--parrot" in sys.argv; r.dapnet = DapnetCore(r)
    r.serve()
