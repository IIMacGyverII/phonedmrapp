# F58D gaps from the 17:32 grant. Does not load firmware.
#
# (1) Digital VFO at 467.625 MHz, low power, colour code 1, slot field 1
#     (the field channel 49 used when it heard the hotspot's slot 2),
#     receive list exactly 1 and 9. Replay dmr_tg99.bin with MON on, then
#     MON off. The 0x2B body is taken from the RadioService "RX cmd=0x2B"
#     line. Caller bytes are not printed.
# (2) DIAG raw40 bodies [6,3,1], [6,3,1], [6,3,0], with opcode 14 reads of
#     0x4B000 (saved WORK_MODE and the hold word). Then one DMR key on
#     channel 49 under a HackRF receive capture.
#
# python tools/fw-bench/fw58_gaps.py --plan
# python tools/fw-bench/fw58_gaps.py --self-check
# python tools/fw-bench/fw58_gaps.py --grant
import argparse
import math
import re
import subprocess
import sys
import time
import wave
from array import array
from pathlib import Path

HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))
sys.path.insert(0, str(HERE / "runner"))
import fw58_steps as base  # noqa: E402
from common import Config  # noqa: E402
from hackrf import Capture  # noqa: E402
from phone import Phone  # noqa: E402

TAG = base.TAG
HOLD = 0x484F4C44
HZ = 467625000
CLIP_MS = 20000
KEY_MS = 3000
CAP_S = 4.2
IQAN = HERE.parents[1] / "tools" / "dmr-replay" / "iqan_tx.py"


def say(cfg, text):
    cfg.say(base.redact(text))


def plan_text():
    return "\n".join([
        "F58D gaps. Tag must already be " + TAG + ". This script does not load.",
        "1. VFO digital 467.625 MHz, low power, colour code 1, slot field 1,",
        "   call 9, receive list 1,9. Refuse to replay if 99 is in that list.",
        "2. Talkgroup 99 file, MON on: 20 s clip, op 14 of 0x4C59C and 0x4C7A0,",
        "   and every RX cmd=0x2B with the caller bytes hidden. Expect target 99 and voice.",
        "3. The same file, MON off. Expect a quiet clip.",
        "4. Exit the VFO. Channel 49. raw40 [6,3,1], [6,3,1], [6,3,0].",
        "   After each, read 16 bytes at 0x4B000. If the hold word was already",
        "   set, run that triple once more after the release clears it.",
        "5. Channel 49, DIAG testtone %d ms: engine.ptt on that digital channel," % KEY_MS,
        "   then a 1 kHz PCM buffer. HackRF receive only, %g s. Not 434.000." % CAP_S,
        "Replay file: %s" % base.TG99,
    ])


def self_check():
    rows = (
        (0x4C59C, 20, "0e9cc504001400"),
        (0x4C7A0, 16, "0ea0c704001000"),
        (0x4B000, 16, "0e00b004001000"),
    )
    for addr, n, expect in rows:
        got = base.op14(addr, n)
        if got != bytes.fromhex(expect) or len(got) != 7:
            raise SystemExit("op 14 body %X" % addr)
    bodies = (bytes([6, 3, 1]), bytes([6, 3, 1]), bytes([6, 3, 0]))
    if bodies[0] == bodies[2] or bodies[0] != bytes.fromhex("060301"):
        raise SystemExit("op 6 body")
    if not base.TG99.is_file():
        raise SystemExit("replay file missing")
    groups = [1, 9]
    if 99 in groups:
        raise SystemExit("list")
    print("op 14 and op 6 bodies ok")
    print("present %s %d" % (base.TG99, base.TG99.stat().st_size))
    print("self-check ok")


def dump_log(phone):
    _, out = phone.adb("shell", "logcat", "-d", "-t", "2500", "-s", "RadioService:I", "DiagReceiver:I", timeout=40)
    return out


def frames_2b(text):
    """One dict per 0x2B. Caller bytes are replaced before anything is stored."""
    out = []
    for m in re.finditer(r"cmd=0x2B rw=(\d+) sr=(\d+) len=(\d+) \[([0-9A-F ]*)\]", text):
        raw = bytes.fromhex(m.group(4))
        if len(raw) < 9:
            continue
        target = int.from_bytes(raw[5:9], "little")
        caller = int.from_bytes(raw[1:5], "little") & 0xFFFFFF
        shown = []
        for i, x in enumerate(raw[:12]):
            shown.append("xx" if 1 <= i <= 4 else "%02X" % x)
        out.append({
            "len": int(m.group(3)),
            "type": raw[0],
            "target": base.show_word(target),
            "caller": base.show_word(caller),
            "body": " ".join(shown),
        })
    return out


def status_bytes(text):
    found = []
    for m in re.finditer(r"cmd=0x36 rw=\d+ sr=\d+ len=\d+ \[([0-9A-F ]*)\]", text):
        raw = bytes.fromhex(m.group(1))
        if raw:
            found.append(raw[0])
    return found


def clip_levels(path):
    if not path.is_file():
        return 0.0, 0
    w = wave.open(str(path), "rb")
    raw = w.readframes(w.getnframes())
    w.close()
    s = array("h")
    s.frombytes(raw[:len(raw) - (len(raw) % 2)])
    if not s:
        return 0.0, 0
    peak = max(abs(x) for x in s)
    return math.sqrt(sum(x * x for x in s) / len(s)), peak


def iq_levels(path):
    b = Path(path).read_bytes()
    s = array("b")
    s.frombytes(b[:len(b) - (len(b) % 2)])
    if not s:
        return 0.0, 0.0
    whole = sum(x * x for x in s) / len(s)
    # Loudest 2.5 s, 0.5 s steps, int8 mean square. 2.4e6 complex samples/s = 4.8e6 bytes/s.
    win = int(2.5 * 4_800_000)
    step = int(0.5 * 4_800_000)
    best = 0.0
    if len(s) > win:
        for i in range(0, len(s) - win, step):
            chunk = s[i:i + win]
            v = sum(x * x for x in chunk) / len(chunk)
            if v > best:
                best = v
    else:
        best = whole
    return whole, best


def sync_lines(path):
    if not IQAN.is_file():
        return ["iqan missing"]
    r = subprocess.run(
        [sys.executable, str(IQAN), str(path), "--fs", "2400000", "--off", "240000", "--dmr"],
        capture_output=True, timeout=180)
    text = (r.stdout or b"").decode("utf-8", "replace")
    kept = []
    for ln in text.splitlines():
        if ln.startswith(("samples ", "carrier ", "best sync ", "sync bursts:", "burst spacing")):
            kept.append(ln)
    return kept or ["no sync line rc %s" % r.returncode]


def vfo_body():
    return {
        "type": 0,
        "rxMHz": 467.625,
        "txMHz": 467.625,
        "power": 0,
        "cc": 1,
        "slot": 1,
        "contactType": 1,
        "txContact": "9",
        "groups": "1,9",
        "lat": "",
        "lon": "",
    }


def vfo_ok(doc):
    ch = doc.get("channel") or {}
    groups = ch.get("groups") or []
    problems = []
    if not doc.get("active"):
        problems.append("not active")
    if not ch.get("digital"):
        problems.append("not digital")
    if int(ch.get("rxFreq") or 0) != HZ or int(ch.get("txFreq") or 0) != HZ:
        problems.append("frequency")
    if ch.get("power") != 0:
        problems.append("power")
    if int(ch.get("cc") or -1) != 1:
        problems.append("cc")
    if int(ch.get("slot") or -1) != 1:
        problems.append("slot")
    if sorted(int(x) for x in groups) != [1, 9]:
        problems.append("groups %s" % [base.show_word(int(x)) for x in groups])
    if 99 in [int(x) for x in groups]:
        problems.append("99 is in the list")
    call = ch.get("txContact")
    if call is not None and int(call) != 9:
        problems.append("call %s" % base.show_word(int(call)))
    return problems


RELOAD = r"""
import os, signal, struct, time
path = os.path.expanduser("~/claude-bench/dmr_last.bin")
blob = open(path, "rb").read()
ms, n = struct.unpack(">IH", blob[:6])
d = blob[6:6 + n]
dst = int.from_bytes(d[8:11], "big") if d[:4] == b"DMRD" else -1
print("file_dst", "99" if dst == 99 else "not99")
if dst != 99:
    raise SystemExit("file is not talkgroup 99")
def pids():
    out = []
    for name in os.listdir("/proc"):
        if not name.isdigit():
            continue
        try:
            cmd = open("/proc/" + name + "/cmdline", "rb").read()
        except OSError:
            continue
        if b"m17relay.py" in cmd:
            out.append(int(name))
    return out
old = pids()
print("old", len(old))
for p in old:
    try:
        os.kill(p, signal.SIGTERM)
    except OSError as e:
        print("kill", type(e).__name__)
deadline = time.time() + 8
fresh = []
while time.time() < deadline:
    time.sleep(0.4)
    now = pids()
    fresh = [p for p in now if p not in old]
    if fresh and not (set(now) & set(old)):
        break
if not fresh:
    rc = os.system("systemctl restart m17relay >/dev/null 2>&1")
    print("systemctl", rc)
    time.sleep(4)
    fresh = pids()
print("fresh", len(fresh))
if not fresh:
    raise SystemExit("relay did not reload")
"""


def replay_tg99(cfg):
    """Copy the talkgroup 99 file and wait until a new relay process has loaded it."""
    dest = "%s:~/claude-bench/dmr_last.bin" % base.PI
    r = subprocess.run(
        ["scp", "-i", str(base.SSH_KEY), "-o", "IdentitiesOnly=yes", str(base.TG99), dest],
        capture_output=True, timeout=60)
    if r.returncode != 0:
        raise SystemExit("scp " + base.redact((r.stderr or b"").decode()[-200:]))
    local = cfg.out / "reload_relay.py"
    local.write_text(RELOAD, encoding="ascii")
    remote = "%s:/tmp/reload_relay.py" % base.PI
    r = subprocess.run(
        ["scp", "-i", str(base.SSH_KEY), "-o", "IdentitiesOnly=yes", str(local), remote],
        capture_output=True, timeout=60)
    if r.returncode != 0:
        raise SystemExit("scp reload")
    base.ssh(cfg, "python3 /tmp/reload_relay.py")
    s = __import__("socket").create_connection((base.PI.split("@")[1], 8080), 8)
    try:
        s.sendall(b"Q" + __import__("struct").pack(">I", 0))
    finally:
        s.close()
    say(cfg, "replay queued dmr_tg99.bin")


def one_row(cfg, phone, web, name, mon):
    phone.adb("shell", "logcat", "-c")
    web.monitor(mon)
    time.sleep(0.8)
    phone.broadcast("rxclip", "--ei", "ms", str(CLIP_MS), "--es", "name", name)
    time.sleep(0.4)
    replay_tg99(cfg)
    time.sleep(6.0)
    early = dump_log(phone)
    a, _ = base.read_ram(cfg, phone, 0x4C59C, 20)
    b, _ = base.read_ram(cfg, phone, 0x4C7A0, 16)
    remain = CLIP_MS / 1000.0 - 8.0
    if remain > 0:
        time.sleep(remain)
    late = dump_log(phone)
    wav = cfg.out / (name + ".wav")
    phone.pull_app("/data/data/%s/cache/rxclip_%s.wav" % (phone.cfg.package, name), wav)
    rms, peak = clip_levels(wav)
    text = early + "\n" + late
    row = {
        "name": name,
        "mon": mon,
        "rms": round(rms, 1),
        "peak": peak,
        "c59c_plus_c": base.show_word(base.word_at(a, 0xC)),
        "c7a0_target": base.show_word(base.word_at(b, 4)),
        "caller_reports": frames_2b(text),
        "status36": status_bytes(text),
        "history": web.history()[-8:],
        "promiscuous": "promiscuous on" in text,
    }
    say(cfg, "%s MON %s rms %.1f peak %d +0xC %s target %s reports %d status %s" % (
        name, "on" if mon else "off", rms, peak, row["c59c_plus_c"], row["c7a0_target"],
        len(row["caller_reports"]), row["status36"]))
    for rep in row["caller_reports"][:6]:
        say(cfg, "0x2B len %d type %d target %s caller %s [%s]" % (
            rep["len"], rep["type"], rep["target"], rep["caller"], rep["body"]))
    return row


def hold_words(blob):
    saved = base.word_at(blob, 0)
    mark = base.word_at(blob, 8)
    return {
        "saved": base.show_word(saved) if saved is not None else "missing",
        "saved_raw": saved,
        "hold": mark == HOLD,
        "mark": "HOLD" if mark == HOLD else (base.show_word(mark) if mark is not None else "missing"),
    }


def raw_op6(cfg, phone, body, label):
    remote = base.push_body(phone, body, "op6_%s.bin" % label)
    phone.adb("shell", "logcat", "-c")
    phone.broadcast("raw40", "--es", "path", remote)
    time.sleep(1.2)
    log = dump_log(phone)
    hit = [ln.strip() for ln in log.splitlines() if "raw40" in ln]
    say(cfg, "op6 %s %s" % (label, " | ".join(hit)[-180:] if hit else "raw40 missing"))
    blob, _ = base.read_ram(cfg, phone, 0x4B000, 16)
    words = hold_words(blob)
    say(cfg, "op6 %s saved %s mark %s" % (label, words["saved"], words["mark"]))
    words["log"] = hit[-4:]
    words["body"] = label
    return words


def op6_triple(cfg, phone, tag):
    rows = [raw_op6(cfg, phone, bytes([6, 3, 1]), tag + "a")]
    rows.append(raw_op6(cfg, phone, bytes([6, 3, 1]), tag + "b"))
    rows.append(raw_op6(cfg, phone, bytes([6, 3, 0]), tag + "c"))
    return rows


def dmr_key(cfg, phone, web):
    base.heat_ok(cfg, phone)
    base.BUSY.parent.mkdir(parents=True, exist_ok=True)
    base.BUSY.write_text("fw58 gaps key\n", encoding="ascii")
    try:
        cap = Capture(cfg, "fw58_gap_ch49", CAP_S, cfg.lna_key, cfg.vga_key)
        time.sleep(0.35)
        phone.broadcast("testtone", "--ei", "ms", str(KEY_MS))
        say(cfg, "keyed channel 49 DIAG testtone %d ms: engine.ptt on the digital channel, then 1 kHz PCM, low power, 467.625 MHz" % KEY_MS)
        iq = cap.wait()
    finally:
        if base.BUSY.exists():
            base.BUSY.unlink()
    whole, loud = iq_levels(iq)
    lines = sync_lines(iq)
    for ln in lines:
        say(cfg, ln)
    say(cfg, "channel 49 mean square whole %.1f loudest 2.5 s %.1f" % (whole, loud))
    time.sleep(1.0)
    st = web.call("/api/status")
    tx = bool(st.get("transmitting"))
    say(cfg, "transmitting %s" % tx)
    if tx:
        web.call("/api/ptt", {"down": False})
        time.sleep(1.0)
        st = web.call("/api/status")
        tx = bool(st.get("transmitting"))
        say(cfg, "transmitting after unkey %s" % tx)
    return {
        "keyed": "channel 49 DIAG testtone %d ms, digital group path, 1 kHz PCM, low power, 467.625 MHz" % KEY_MS,
        "mean_square": round(whole, 1),
        "loud_2_5s": round(loud, 1),
        "sync": lines,
        "transmitting": tx,
        "heat": base.heat_ok(cfg, phone),
    }


def main():
    p = argparse.ArgumentParser()
    p.add_argument("--plan", action="store_true")
    p.add_argument("--self-check", action="store_true")
    p.add_argument("--grant", action="store_true")
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
        raise SystemExit("tag is not F58D; not loading")
    base.heat_ok(cfg, phone)
    web = base.Web(phone)
    say(cfg, web.call("/api/vfo", vfo_body()).get("message", "vfo posted"))
    time.sleep(base.SETTLE_S)
    got = web.call("/api/vfo")
    problems = vfo_ok(got)
    say(cfg, "vfo " + ("; ".join(problems) if problems else "467.625 digital list 1,9 slot 1 call 9"))
    if problems:
        raise SystemExit("vfo refused")
    doc = {"tag": tag, "rows": []}
    doc["rows"].append(one_row(cfg, phone, web, "vfo99_on", True))
    doc["rows"].append(one_row(cfg, phone, web, "vfo99_off", False))
    web.call("/api/vfo/exit", {})
    time.sleep(2.0)
    web.select(base.CH49)
    time.sleep(base.SETTLE_S)
    ch = web.call("/api/channel?number=%d" % base.CH49).get("channel") or {}
    groups = [base.show_word(int(x)) for x in (ch.get("groups") or [])]
    say(cfg, "channel 49 digital %s slot %s cc %s power %s call %s groups %s" % (
        ch.get("digital"), ch.get("slot"), ch.get("cc"), ch.get("power"),
        base.show_word(int(ch.get("txContact") or 0)), groups))
    doc["channel49"] = {
        "digital": ch.get("digital"), "slot": ch.get("slot"), "cc": ch.get("cc"),
        "power": ch.get("power"), "call": base.show_word(int(ch.get("txContact") or 0)),
        "contactType": ch.get("contactType"), "groups": groups,
    }
    before, _ = base.read_ram(cfg, phone, 0x4B000, 16)
    doc["hold_before"] = hold_words(before)
    say(cfg, "hold before saved %s mark %s" % (doc["hold_before"]["saved"], doc["hold_before"]["mark"]))
    doc["op6"] = op6_triple(cfg, phone, "1")
    if doc["hold_before"]["hold"]:
        say(cfg, "first triple started already held; running it again after the release")
        doc["op6_again"] = op6_triple(cfg, phone, "2")
    doc["key"] = dmr_key(cfg, phone, web)
    out = cfg.out / "fw58_gaps.json"
    # Drop the integer saved_raw so a later print of the file cannot grow an id-sized word.
    def scrub(o):
        if isinstance(o, dict):
            return {k: scrub(v) for k, v in o.items() if k != "saved_raw"}
        if isinstance(o, list):
            return [scrub(v) for v in o]
        return o
    out.write_text(__import__("json").dumps(scrub(doc), indent=1), encoding="utf-8")
    say(cfg, "wrote %s" % out)
    if doc["key"]["transmitting"]:
        raise SystemExit("still transmitting")


if __name__ == "__main__":
    main()
