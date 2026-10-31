# Caller-info query timing, and a talkgroup 9 then 99 handover.
# Gate open (squelch 0, monitor off), VFO list 1/9, FW57, VGA 30.
#
# python tools/fw-bench/fw_gate_query.py --grant
import json
import queue
import re
import subprocess
import sys
import threading
import time
import wave
from array import array

HERE = __import__("pathlib").Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))
sys.path.insert(0, str(HERE / "runner"))
import fw_full_rows as fr  # noqa: E402
import fw_replay_rows as rr  # noqa: E402
import fw58_gaps as gaps  # noqa: E402
import hackrf  # noqa: E402
from common import Config  # noqa: E402
from hackrf import running as hackrf_running  # noqa: E402
from phone import Phone  # noqa: E402

VGA = 30
STAMP = re.compile(r"(\d{2}-\d{2} \d{2}:\d{2}:\d{2}\.\d{3})")
BODY = re.compile(r"\[([0-9A-F ]*)\]")


def ms_of(stamp):
    hh, mm, rest = stamp.split(" ")[1].split(":")
    sec, frac = rest.split(".")
    return ((int(hh) * 60 + int(mm)) * 60 + int(sec)) * 1000 + int(frac)


def target_of(line):
    m = BODY.search(line)
    if not m or "cmd=0x2B" not in line:
        return None
    raw = bytes.fromhex(m.group(1))
    if len(raw) < 9:
        return {"len": len(raw), "type": None, "target": None}
    return {"len": len(raw), "type": raw[0], "target": int.from_bytes(raw[5:9], "little")}


class Log:
    def __init__(self, cfg, phone):
        phone.adb("shell", "logcat", "-c")
        self.q = queue.Queue()
        self.lines = []
        self.proc = subprocess.Popen(
            [cfg.adb, "-s", cfg.serial, "logcat", "-v", "time", "-s", "RadioService:I", "DiagReceiver:I"],
            stdout=subprocess.PIPE, stderr=subprocess.STDOUT, text=True, errors="replace")
        self.th = threading.Thread(target=self._read, daemon=True)
        self.th.start()

    def _read(self):
        for line in self.proc.stdout:
            self.lines.append(line.rstrip())
            self.q.put(line.rstrip())

    def stop(self):
        self.proc.terminate()
        try:
            self.proc.wait(timeout=3)
        except Exception:
            self.proc.kill()


def diag(phone, cmd, data):
    phone.adb(
        "shell", "am", "broadcast", "-a", "com.macdmr.radio.DIAG",
        "--es", "cmd", "cmdbyte", "--ei", "b", str(cmd), "--ei", "d", str(data))


def play_file(cfg, kind):
    path = rr.FILES[kind]
    proc, log = rr.start_tx(cfg, path, path.stat().st_size // 2, VGA)
    return proc, log


def arm(cfg, phone, web):
    web.monitor(False)
    time.sleep(0.3)
    rr.enter_vfo(cfg, web)
    diag(phone, 0x30, 0)
    time.sleep(0.6)
    diag(phone, 0x2F, 2)
    time.sleep(0.6)


def one_query(cfg, phone, delay_ms):
    log = Log(cfg, phone)
    pp, np_ = rr.primer(cfg)
    proc, txlog = rr.start_tx(cfg, pp, np_, VGA)
    rr.finish_tx(proc, txlog, 1.0)
    proc, txlog = play_file(cfg, "tg9")
    status_at = None
    asked = None
    deadline = time.time() + 12
    try:
        while time.time() < deadline:
            try:
                line = log.q.get(timeout=0.05)
            except queue.Empty:
                if proc.poll() is not None and status_at and asked:
                    break
                continue
            if "RX cmd=0x36" in line and "[01]" in line and status_at is None:
                m = STAMP.search(line)
                status_at = ms_of(m.group(1)) if m else None
                time.sleep(delay_ms / 1000.0)
                asked_wall = time.time()
                diag(phone, 0x2B, 1)
                asked = asked_wall
            if "RX cmd=0x36" in line and "[02]" in line and asked:
                break
    finally:
        rr.finish_tx(proc, txlog, 3)
        time.sleep(0.4)
        log.stop()
    base = status_at
    replies = []
    asks = []
    statuses = []
    for line in log.lines:
        m = STAMP.search(line)
        if not m or base is None:
            continue
        rel = ms_of(m.group(1)) - base
        if "RX cmd=0x36" in line and "[01]" in line:
            statuses.append({"code": 1, "ms": rel})
        elif "RX cmd=0x36" in line and "[02]" in line:
            statuses.append({"code": 2, "ms": rel})
        elif "TX cmd=0x2B" in line:
            asks.append(rel)
        elif "RX cmd=0x2B" in line:
            info = target_of(line)
            if info:
                info["ms"] = rel
                replies.append(info)
    row = {"delay_ms": delay_ms, "asks": asks, "replies": replies, "status": statuses}
    fr.say(cfg, "query %s ms asks %s replies %s" % (
        delay_ms, asks, [(r.get("type"), r.get("target"), r.get("ms")) for r in replies]))
    return row


def envelope(path):
    w = wave.open(str(path), "rb")
    raw = w.readframes(w.getnframes())
    w.close()
    s = array("h")
    s.frombytes(raw[:len(raw) - (len(raw) % 2)])
    out = []
    for i in range(0, len(s) - 800, 800):
        chunk = s[i:i + 800]
        out.append(round((sum(x * x for x in chunk) / len(chunk)) ** 0.5))
    return out


def handover(cfg, phone):
    log = Log(cfg, phone)
    phone.rx_clip("handover", 20000)
    time.sleep(0.2)
    pp, np_ = rr.primer(cfg)
    proc, txlog = rr.start_tx(cfg, pp, np_, VGA)
    rr.finish_tx(proc, txlog, 1.0)
    proc, txlog = play_file(cfg, "tg9")
    next_q = time.time() + 1.0
    while proc.poll() is None:
        if time.time() >= next_q:
            diag(phone, 0x2B, 1)
            next_q = time.time() + 1.0
        time.sleep(0.05)
    rr.finish_tx(proc, txlog, 2)
    gap_t = time.time()
    pp, np_ = rr.primer(cfg)
    proc, txlog = rr.start_tx(cfg, pp, np_, VGA)
    rr.finish_tx(proc, txlog, 1.0)
    gap_s = time.time() - gap_t
    proc, txlog = play_file(cfg, "tg99")
    deadline = time.time() + 12
    try:
        while time.time() < deadline:
            if time.time() >= next_q:
                diag(phone, 0x2B, 1)
                next_q = time.time() + 1.0
            try:
                log.q.get(timeout=0.05)
            except queue.Empty:
                if proc.poll() is not None:
                    break
    finally:
        rr.finish_tx(proc, txlog, 3)
        time.sleep(0.5)
        log.stop()
    wav = cfg.out / "handover.wav"
    phone.pull_app("/data/data/%s/cache/rxclip_handover.wav" % phone.cfg.package, wav)
    # first status 1 is the time base
    base = None
    statuses = []
    asks = []
    replies = []
    for line in log.lines:
        m = STAMP.search(line)
        if not m:
            continue
        t = ms_of(m.group(1))
        if base is None and "RX cmd=0x36" in line and "[01]" in line:
            base = t
        if base is None:
            continue
        rel = t - base
        if "RX cmd=0x36" in line and "[01]" in line:
            statuses.append({"code": 1, "ms": rel})
        elif "RX cmd=0x36" in line and "[02]" in line:
            statuses.append({"code": 2, "ms": rel})
        elif "TX cmd=0x2B" in line:
            asks.append(rel)
        elif "RX cmd=0x2B" in line:
            info = target_of(line)
            if info:
                info["ms"] = rel
                replies.append(info)
    levels = envelope(wav) if wav.is_file() else []
    low = [i for i, rms in enumerate(levels) if rms < 400]
    row = {
        "gap_s": round(gap_s, 3),
        "status": statuses,
        "asks": asks,
        "replies": replies,
        "audio_100ms_rms": levels,
        "quiet_100ms": low[:20],
        "quiet_count": len(low),
    }
    fr.say(cfg, "handover gap %.2f s status %s replies %s quiet %s" % (
        gap_s, statuses, [(r.get("type"), r.get("target"), r.get("ms")) for r in replies], len(low)))
    return row


def main():
    if "--grant" not in sys.argv:
        raise SystemExit("refusing without --grant")
    cfg = Config()
    for path in rr.FILES.values():
        if not path.is_file():
            raise SystemExit("missing " + path.name)
    fr.BUSY.parent.mkdir(parents=True, exist_ok=True)
    fr.BUSY.write_text("gate query\n", encoding="ascii")
    phone = None
    doc = {"queries": []}
    try:
        phone = Phone(cfg)
        if not phone.ok() or phone.cfg.serial != "192.168.1.125:5555":
            raise SystemExit("no phone")
        if hackrf_running():
            raise SystemExit("hackrf already running")
        if phone.tag() != fr.FW57_TAG:
            raise SystemExit("not on FW57")
        phone.wake()
        phone.adb("shell", "am", "start", "-n", "com.macdmr.radio/.MainActivity")
        time.sleep(2.0)
        web = fr.open_web(phone)
        if web.call("/api/status").get("transmitting"):
            web.call("/api/ptt", {"down": False})
            time.sleep(1.0)
        gaps.base.heat_ok(cfg, phone)
        arm(cfg, phone, web)
        phone.rx_clip("idleopen", 2000)
        time.sleep(2.4)
        idle = cfg.out / "idleopen.wav"
        phone.pull_app("/data/data/%s/cache/rxclip_idleopen.wav" % phone.cfg.package, idle)
        doc["idle_100ms_rms"] = envelope(idle) if idle.is_file() else []
        fr.say(cfg, "idle rms %s" % doc["idle_100ms_rms"][:10])
        for delay in (40, 80, 150, 300):
            doc["queries"].append(one_query(cfg, phone, delay))
            time.sleep(1.0)
        doc["handover"] = handover(cfg, phone)
        try:
            web.call("/api/vfo/exit", {})
        except Exception:
            pass
        time.sleep(1.0)
        st = web.call("/api/status")
        doc["transmitting"] = bool(st.get("transmitting"))
        doc["end_tag"] = phone.tag()
        doc["heat"] = gaps.base.heat_ok(cfg, phone)
        (cfg.out / "fw_gate_query.json").write_text(json.dumps(doc, indent=1), encoding="utf-8")
        fr.say(cfg, "end %s transmitting %s" % (doc["end_tag"], doc["transmitting"]))
        if doc["transmitting"] or doc["end_tag"] != fr.FW57_TAG:
            raise SystemExit("end state")
    finally:
        if hackrf_running():
            hackrf.kill()
        if phone is not None:
            try:
                web = fr.open_web(phone)
                if web.call("/api/status").get("transmitting"):
                    web.call("/api/ptt", {"down": False})
            except Exception as exc:
                fr.say(cfg, "unkey failed %s" % type(exc).__name__)
        try:
            if fr.BUSY.exists():
                fr.BUSY.unlink()
        except Exception as exc:
            fr.say(cfg, "busy clear failed %s" % type(exc).__name__)


if __name__ == "__main__":
    main()
