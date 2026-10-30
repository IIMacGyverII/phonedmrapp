# Bench steps 1 and 2 for F58D. Reviews.md, 2026-10-30 16:58.
#
# Does not load an image and does not call DIAG fwload. F58D has to be on the
# module already (tag DMR003.F58D.V022), loaded through the page or the FW5x
# loader, with the factory image as the restore.
#
# Step 1, on the slot-2 DMR channel already selected (not channel 49; that
# one is slot 1 and the hotspot is slot 2):
#   All-Call replay, MON off, then op 14 of 0x4C59C and 0x4C7A0.
#   Talkgroup 99, MON on, then the same reads.
#   Talkgroup 99, MON off.
#   In-list talkgroup 9, MON off. The 99 file is the in-list row only when
#   the listen channel's group list contains 9; the script records the 0x2B
#   target the radio reports.
# Step 2, op 6: M17 receive on channel 56, apply, apply again while held,
# release, apply, release. Then a 2 s low-power tone on channel 49 under a
# HackRF capture. Then M17 receive on 56 once more.
#
# python tools/fw-bench/fw58_steps.py --plan
# python tools/fw-bench/fw58_steps.py --self-check
# python tools/fw-bench/fw58_steps.py --grant     # only after the handoff grant
import argparse
import json
import math
import os
import re
import socket
import struct
import subprocess
import sys
import time
import wave
from array import array
from pathlib import Path

HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE / "runner"))
from common import Config, HEAT_BAT_STOP_C, HEAT_ZONE_STOP_C  # noqa: E402
from hackrf import Capture  # noqa: E402
from phone import Phone  # noqa: E402

TAG = "DMR003.F58D.V022"
TG99 = Path(os.environ.get("FW58_TG99", r"C:\Users\Joshua\AppData\Local\Temp\fw1718\fw30\dmr_tg99.bin"))
ALLCALL = Path(os.environ.get("FW58_ALLCALL", r"C:\Users\Joshua\AppData\Local\Temp\fw1718\fw30\dmr_allcall.bin"))
TG9 = Path(os.environ.get("FW58_TG9", r"C:\Users\Joshua\AppData\Local\Temp\fw1718\fw30\dmr_last.bin"))
IMAGE = Path(__file__).resolve().parents[2] / "radio_firmware" / "build" / "DMR003.F58D.V022.bin"
SSH_KEY = Path(os.environ.get("USERPROFILE", "")) / ".ssh" / "id_ed25519_wpsd"
PI = "pi-star@192.168.1.194"
RELAY = "~/claude-bench"
BUSY = Path(os.environ.get("TEMP", "")) / "fw1718" / "handoff_busy"
CH56 = 56
CH49 = 49
SETTLE_S = 4.5
CLIP_MS = 20000
CARRIER_MS = 30.0


def say(cfg, text):
    cfg.say(redact(text))


def redact(text):
    def one(m):
        t = m.group(0)
        if t == "16777215" or len(t) < 6:
            return t
        return "#"
    return re.sub(r"\d+", one, text)


def op14(addr, n):
    """Opcode 14 body: opcode, address little-endian, length little-endian. Length 1..240."""
    if not 1 <= n <= 240:
        raise SystemExit("op 14 length")
    return bytes([14]) + int(addr).to_bytes(4, "little") + int(n).to_bytes(2, "little")


def plan_text():
    return "\n".join([
        "F58D steps 1-2. No load in this script. Tag must already be " + TAG + ".",
        "1. All-Call file, MON off, clip, op 14 of 0x4C59C (20) and 0x4C7A0 (16).",
        "2. Talkgroup 99 file, MON on, same reads. Expect target 99.",
        "3. Talkgroup 99 file, MON off. Expect the clip to stay quiet.",
        "4. In-list talkgroup 9, MON off, only when FW58_TG9 points at a stored call.",
        "   The 99 file is not reused under that name. The listen channel is slot 2.",
        "5. Channel 56: M17 on, on again, off, on, off. Log every data-hold line.",
        "6. Channel 49: 2 s low-power tone, HackRF receive only. Then channel 56, M17 on and off.",
        "Replay files: %s and %s." % (TG99, ALLCALL),
    ])


def self_check():
    rows = (
        (0x4C59C, 20, bytes.fromhex("0e9cc504001400")),
        (0x4C7A0, 16, bytes.fromhex("0ea0c704001000")),
    )
    for addr, n, expect in rows:
        got = op14(addr, n)
        if got != expect or len(got) != 7:
            raise SystemExit("op 14 body %X" % addr)
    print("op 14 bodies 7 bytes, ranges 20 and 16")
    for p in (TG99, ALLCALL):
        print(("present " if p.is_file() else "missing ") + str(p) + (" %d" % p.stat().st_size if p.is_file() else ""))
    if not TG99.is_file() or not ALLCALL.is_file():
        raise SystemExit("replay file missing")
    print("self-check ok")


class Web:
    """SignalDeck's local web API. The pin is read and dropped. It is never printed."""

    def __init__(self, phone):
        import urllib.request
        self.req = urllib.request
        self.phone = phone
        rc, xml = phone.adb("shell", "su -c cat /data/data/%s/shared_prefs/web.xml" % phone.cfg.package, timeout=20)
        i = xml.find('<string name="pin">')
        if i < 0:
            raise SystemExit("web pin missing")
        secret = xml[i + len('<string name="pin">'):xml.find("</string>", i)].strip()
        phone.adb("forward", "tcp:18080", "tcp:8080")
        phone.broadcast("web", "--ez", "on", "true")
        req = self.req.Request("http://127.0.0.1:18080/api/login", data=json.dumps({"pin": secret}).encode(), method="POST")
        req.add_header("Content-Type", "application/json")
        del secret
        with self.req.urlopen(req, timeout=8) as resp:
            self.cookie = (resp.headers.get("Set-Cookie") or "").split(";")[0]

    def call(self, path, doc=None):
        data = None if doc is None else json.dumps(doc).encode()
        req = self.req.Request("http://127.0.0.1:18080" + path, data=data, method="GET" if doc is None else "POST")
        req.add_header("Content-Type", "application/json")
        if self.cookie:
            req.add_header("Cookie", self.cookie)
        with self.req.urlopen(req, timeout=15) as resp:
            return json.loads(resp.read().decode())

    def select(self, number):
        self.call("/api/channel/select", {"number": int(number)})

    def monitor(self, on):
        self.call("/api/monitor", {"on": bool(on)})

    def history(self):
        doc = self.call("/api/history?limit=40")
        return [redact(str(x)) for x in doc.get("lines", [])]


def ssh(cfg, remote):
    cmd = ["ssh", "-i", str(SSH_KEY), "-o", "IdentitiesOnly=yes", "-o", "StrictHostKeyChecking=accept-new", PI, remote]
    r = subprocess.run(cmd, capture_output=True, timeout=40)
    text = redact((r.stdout or b"").decode("utf-8", "replace") + (r.stderr or b"").decode("utf-8", "replace"))
    say(cfg, "ssh %s" % text[-240:].replace("\n", " "))
    if r.returncode != 0:
        raise SystemExit("ssh rc %s" % r.returncode)
    return text


def replay(cfg, local):
    """Copy one stored call into the relay and ask it to send that call. Does not write hotspot config."""
    dest = "%s:~/claude-bench/dmr_last.bin" % PI
    r = subprocess.run(["scp", "-i", str(SSH_KEY), "-o", "IdentitiesOnly=yes", str(local), dest], capture_output=True, timeout=60)
    if r.returncode != 0:
        raise SystemExit("scp " + redact((r.stderr or b"").decode()[-200:]))
    # The relay is a service: stopping that one process makes it start again
    # and read dmr_last.bin. The service owns relay.log, so this does not
    # open that file. mmdvmhost is not signaled.
    ssh(cfg, r"""python3 -c 'import os,signal,time
me=os.getpid()
for name in os.listdir("/proc"):
    if not name.isdigit() or int(name)==me: continue
    try: cmd=open("/proc/"+name+"/cmdline","rb").read()
    except OSError: continue
    if b"m17relay.py" in cmd: os.kill(int(name), signal.SIGTERM)
time.sleep(2)
print("relay restarted")'""")
    s = socket.create_connection((PI.split("@")[1], 8080), 8)
    try:
        s.sendall(b"Q" + struct.pack(">I", 0))
    finally:
        s.close()
    say(cfg, "replay queued %s" % local.name)


def push_body(phone, body, name):
    local = phone.cfg.out / name
    local.write_bytes(body)
    return phone.push_to_cache(local, name)


def read_ram(cfg, phone, addr, n):
    remote = push_body(phone, op14(addr, n), "op14_%X.bin" % addr)
    phone.adb("shell", "logcat", "-c")
    phone.broadcast("raw40", "--es", "path", remote)
    time.sleep(1.5)
    log = phone.logcat(8)
    hit = [redact(ln) for ln in log.splitlines() if "raw40" in ln]
    say(cfg, " ".join(hit)[-300:] if hit else "raw40 missing")
    local = cfg.out / ("ram_%X.bin" % addr)
    phone.pull_app("/data/data/%s/cache/raw40.bin" % phone.cfg.package, local)
    blob = local.read_bytes() if local.is_file() else b""
    return blob, hit


def word_at(blob, off):
    if off + 4 > len(blob):
        return None
    return int.from_bytes(blob[off:off + 4], "little")


def show_word(n):
    if n is None:
        return "missing"
    if n in (0, 9, 99, 0xFFFFFF) or n < 100000:
        return "%d" % n
    return "other"


def clip_levels(path):
    w = wave.open(str(path), "rb")
    raw = w.readframes(w.getnframes())
    w.close()
    s = array("h")
    s.frombytes(raw[:len(raw) - (len(raw) % 2)])
    if not s:
        return 0.0, 0
    peak = max(abs(x) for x in s)
    return math.sqrt(sum(x * x for x in s) / len(s)), peak


def one_row(cfg, phone, web, name, mon, replay_file):
    phone.adb("shell", "logcat", "-c")
    web.monitor(mon)
    time.sleep(0.5)
    phone.broadcast("rxclip", "--ei", "ms", str(CLIP_MS), "--es", "name", name)
    time.sleep(0.4)
    replay(cfg, replay_file)
    time.sleep(6.0)
    a, a_log = read_ram(cfg, phone, 0x4C59C, 20)
    b, b_log = read_ram(cfg, phone, 0x4C7A0, 16)
    time.sleep(CLIP_MS / 1000.0)
    wav = cfg.out / (name + ".wav")
    phone.pull_app("/data/data/%s/cache/rxclip_%s.wav" % (phone.cfg.package, name), wav)
    rms, peak = clip_levels(wav) if wav.is_file() else (0.0, 0)
    log = phone.logcat(20)
    kept = [redact(ln) for ln in log.splitlines() if any(k in ln for k in ("status ", "Voice RX", "data hold", "raw40", "m17"))]
    row = {
        "name": name, "mon": mon, "rms": round(rms, 1), "peak": peak,
        "c59c_plus_c": show_word(word_at(a, 0xC)),
        "c7a0_target": show_word(word_at(b, 4)),
        "history": web.history()[-8:],
        "log": kept[-40:],
    }
    say(cfg, "%s MON %s rms %.1f peak %d +0xC %s target %s" % (name, "on" if mon else "off", rms, peak, row["c59c_plus_c"], row["c7a0_target"]))
    return row


def load_f58d(cfg, phone):
    """SignalDeck's YModem loader. The file has to sit in Download/DMR/Firmware. No page tap."""
    if not IMAGE.is_file():
        raise SystemExit("F58D image missing")
    remote = "/sdcard/Download/DMR/Firmware/DMR003.F58D.V022.bin"
    rc, out = phone.adb("push", str(IMAGE), remote, timeout=180)
    if rc != 0:
        raise SystemExit("push image")
    phone.adb("shell", "logcat", "-c")
    phone.broadcast("fwload", "--es", "file", remote)
    t0 = time.time()
    while time.time() - t0 < 360:
        time.sleep(15)
        tag = phone.tag(wait_s=5)
        say(cfg, "loading %s" % (tag or "no tag yet"))
        if tag == TAG:
            return
        log = phone.logcat(6)
        if "fwload refused" in log or "fwload io-error" in log or "fwload bad" in log:
            raise SystemExit("fwload failed")
    raise SystemExit("fwload timed out")


def heat_ok(cfg, phone):
    z = phone.zones()
    bat = z.get("bat_c")
    zones = z.get("zones") or {}
    say(cfg, "heat bat %s ap %s pa %s" % (bat, zones.get("mtktsAP"), zones.get("mtktsbtsmdpa")))
    if bat is not None and bat > HEAT_BAT_STOP_C:
        raise SystemExit("heat")
    for name in ("mtktsAP", "mtktsbtsmdpa"):
        v = zones.get(name)
        if v is not None and v > HEAT_ZONE_STOP_C:
            raise SystemExit("heat")
    return z


def m17(cfg, phone, on):
    phone.adb("shell", "logcat", "-c")
    phone.broadcast("m17", "--ez", "on", "true" if on else "false", "--ez", "hold", "true")
    time.sleep(1.5)
    log = phone.logcat(12)
    hit = [redact(ln) for ln in log.splitlines() if "data hold" in ln or "m17:" in ln]
    say(cfg, "m17 %s %s" % ("on" if on else "off", " | ".join(hit)[-240:]))
    return hit


def iq_mean_square(path):
    b = Path(path).read_bytes()
    if len(b) < 1000:
        return 0.0
    s = array("b")
    s.frombytes(b[:len(b) - (len(b) % 2)])
    return sum(x * x for x in s) / len(s)


def step2(cfg, phone, web):
    rows = []
    web.select(CH56)
    time.sleep(SETTLE_S)
    for on in (True, True, False, True, False):
        rows.append({"ch": CH56, "on": on, "log": m17(cfg, phone, on)})
    heat_ok(cfg, phone)
    web.select(CH49)
    time.sleep(SETTLE_S)
    BUSY.parent.mkdir(parents=True, exist_ok=True)
    BUSY.write_text("fw58 step2\n", encoding="ascii")
    try:
        cap = Capture(cfg, "fw58_ch49", 6, cfg.lna_key, cfg.vga_key)
        time.sleep(0.3)
        phone.broadcast("testtone", "--ei", "ms", "2000")
        iq = cap.wait()
    finally:
        if BUSY.exists():
            BUSY.unlink()
    ms = iq_mean_square(iq)
    say(cfg, "channel 49 tone mean square %.1f" % ms)
    web.select(CH56)
    time.sleep(SETTLE_S)
    back = m17(cfg, phone, True)
    m17(cfg, phone, False)
    return {"holds": rows, "tone_ms": round(ms, 1), "radiated": ms >= CARRIER_MS, "m17_after": back, "heat": heat_ok(cfg, phone)}


def main():
    p = argparse.ArgumentParser()
    p.add_argument("--plan", action="store_true")
    p.add_argument("--self-check", action="store_true")
    p.add_argument("--grant", action="store_true")
    p.add_argument("--listen", type=int, default=49, help="slot-2 DMR channel for the replays")
    args = p.parse_args()
    if args.plan:
        print(plan_text())
        return
    if args.self_check:
        self_check()
        return
    if not args.grant:
        raise SystemExit("refusing: the handoff grant is not on this command (see --plan)")
    cfg = Config()
    phone = Phone(cfg)
    if not phone.ok():
        raise SystemExit("no phone")
    phone.adb("shell", "am", "start", "-n", "com.macdmr.radio/.MainActivity")
    time.sleep(2)
    tag = phone.tag()
    say(cfg, "tag %s" % (tag or "none"))
    if tag != TAG:
        load_f58d(cfg, phone)
        tag = phone.tag()
    if tag != TAG:
        raise SystemExit("tag is not F58D")
    heat_ok(cfg, phone)
    web = Web(phone)
    if args.listen:
        web.select(args.listen)
        time.sleep(SETTLE_S)
    doc = {"tag": tag, "rows": []}
    doc["rows"].append(one_row(cfg, phone, web, "all_off", False, ALLCALL))
    doc["rows"].append(one_row(cfg, phone, web, "tg99_on", True, TG99))
    doc["rows"].append(one_row(cfg, phone, web, "tg99_off", False, TG99))
    if TG9.is_file():
        doc["rows"].append(one_row(cfg, phone, web, "tg9_off", False, TG9))
    else:
        doc["rows"].append({"name": "tg9_off", "skipped": "no talkgroup 9 file"})
        say(cfg, "talkgroup 9 row skipped")
    doc["step2"] = step2(cfg, phone, web)
    out = cfg.out / "fw58_steps.json"
    out.write_text(json.dumps(doc, indent=1), encoding="utf-8")
    say(cfg, "wrote %s" % out)
    if not doc["step2"]["radiated"]:
        raise SystemExit("channel 49 did not radiate")


if __name__ == "__main__":
    main()
