# Gate-open timing: status 1, first loud audio, and 0x2B.
# VFO list 1/9, squelch 0, monitor off. FW57. The hotspot is not used.
#
# python tools/fw-bench/fw_gate_time.py --grant
import json
import re
import subprocess
import sys
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

PLAN = [("tg9", 30), ("tg9", 30), ("tg9", 30), ("tg9", 20), ("tg9", 20), ("allcall", 30), ("tg99", 30)]
STAMP = re.compile(r"(\d{2}-\d{2} \d{2}:\d{2}:\d{2}\.\d{3})")
RX36 = re.compile(r"RX cmd=0x36 rw=\d+ sr=\d+ len=\d+ \[([0-9A-F ]*)\]")
RX2B = re.compile(r"RX cmd=0x2B rw=\d+ sr=\d+ len=\d+ \[([0-9A-F ]*)\]")
TX2B = re.compile(r"TX cmd=0x2B ")


def ms_of(stamp):
    hh, mm, rest = stamp.split(" ")[1].split(":")
    sec, frac = rest.split(".")
    return ((int(hh) * 60 + int(mm)) * 60 + int(sec)) * 1000 + int(frac)


def onset_ms(path):
    w = wave.open(str(path), "rb")
    raw = w.readframes(w.getnframes())
    rate = w.getframerate() or 8000
    w.close()
    s = array("h")
    s.frombytes(raw[: len(raw) - (len(raw) % 2)])
    win = max(1, rate // 50)
    for i in range(0, len(s) - win, win):
        chunk = s[i : i + win]
        rms = (sum(x * x for x in chunk) / len(chunk)) ** 0.5
        if rms >= 200:
            return round(i * 1000 / rate, 1), round(rms, 1)
    return None, 0.0


def events(text):
    clip = None
    status = []
    reports = []
    queries = []
    for line in text.splitlines():
        m = STAMP.search(line)
        if not m:
            continue
        t = ms_of(m.group(1))
        if "rxclip start" in line and clip is None:
            clip = t
        hit = RX36.search(line)
        if hit:
            raw = bytes.fromhex(hit.group(1))
            if raw:
                status.append({"t": t, "code": raw[0]})
        hit = RX2B.search(line)
        if hit:
            raw = bytes.fromhex(hit.group(1))
            kind = raw[0] if raw else None
            target = int.from_bytes(raw[5:9], "little") if len(raw) >= 9 else None
            reports.append({"t": t, "type": kind, "target": target, "len": len(raw)})
        if TX2B.search(line):
            queries.append(t)
    return clip, status, reports, queries


def start_log(cfg, phone, name):
    phone.adb("shell", "logcat", "-c")
    path = cfg.out / (name + ".log")
    handle = open(path, "w", encoding="utf-8", errors="replace")
    proc = subprocess.Popen(
        [cfg.adb, "-s", cfg.serial, "logcat", "-v", "time", "-s", "RadioService:I", "DiagReceiver:I"],
        stdout=handle, stderr=subprocess.STDOUT)
    return proc, handle, path


def stop_log(proc, handle):
    proc.terminate()
    try:
        proc.wait(timeout=3)
    except Exception:
        proc.kill()
    handle.close()


def one(cfg, phone, doc, kind, vga, n):
    if web_tx(phone):
        raise SystemExit("phone is transmitting")
    name = "time_%s_%s_%s" % (kind, vga, n)
    log_proc, log_handle, log_path = start_log(cfg, phone, name)
    t0 = time.time()
    phone.rx_clip(name, 16000)
    time.sleep(0.3)
    pp, np_ = rr.primer(cfg)
    proc, log = rr.start_tx(cfg, pp, np_, vga)
    rr.finish_tx(proc, log, 1.0)
    path = rr.FILES[kind]
    samples = path.stat().st_size // 2
    proc, log = rr.start_tx(cfg, path, samples, vga)
    rr.finish_tx(proc, log, samples / rr.FS)
    remain = 16.5 - (time.time() - t0)
    if remain > 0:
        time.sleep(remain)
    time.sleep(0.4)
    stop_log(log_proc, log_handle)
    text = log_path.read_text(encoding="utf-8", errors="replace")
    wav = cfg.out / (name + ".wav")
    phone.pull_app("/data/data/%s/cache/rxclip_%s.wav" % (phone.cfg.package, name), wav)
    clip, status, reports, queries = events(text)
    audio, audio_rms = onset_ms(wav) if wav.is_file() else (None, 0.0)
    start = next((s for s in status if s["code"] == 1), None)
    base = start["t"] if start else None

    def rel(t):
        if t is None or base is None:
            return None
        return t - base

    row = {
        "name": name, "kind": kind, "vga": vga,
        "status1": rel(clip) is not None and start is not None,
        "audio_after_status_ms": None if audio is None or clip is None else round((clip + audio) - base, 1) if base is not None else None,
        "audio_rms": audio_rms,
        "reports_after_status_ms": [rel(r["t"]) for r in reports],
        "report_type": [r["type"] for r in reports],
        "report_target": [r["target"] for r in reports],
        "queries_after_status_ms": [rel(t) for t in queries],
        "status": [{"code": s["code"], "ms": rel(s["t"])} for s in status],
        "plays": audio is not None,
    }
    doc["rows"].append(row)
    (cfg.out / "fw_gate_time.json").write_text(json.dumps(doc, indent=1), encoding="utf-8")
    fr.say(cfg, "%s audio %s reports %s status %s" % (
        name, row["audio_after_status_ms"], row["reports_after_status_ms"], [s["code"] for s in status]))
    return row


def web_tx(phone):
    try:
        return bool(fr.open_web(phone).call("/api/status").get("transmitting"))
    except Exception:
        return False


def main():
    if "--grant" not in sys.argv:
        raise SystemExit("refusing without --grant")
    cfg = Config()
    for path in rr.FILES.values():
        if not path.is_file():
            raise SystemExit("missing " + path.name)
    fr.BUSY.parent.mkdir(parents=True, exist_ok=True)
    fr.BUSY.write_text("gate time\n", encoding="ascii")
    phone = None
    doc = {"rows": []}
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
        web.monitor(False)
        time.sleep(0.4)
        rr.enter_vfo(cfg, web)
        phone.adb(
            "shell", "am", "broadcast", "-a", "com.macdmr.radio.DIAG",
            "--es", "cmd", "cmdbyte", "--ei", "b", "48", "--ei", "d", "0")
        time.sleep(0.8)
        phone.adb(
            "shell", "am", "broadcast", "-a", "com.macdmr.radio.DIAG",
            "--es", "cmd", "cmdbyte", "--ei", "b", "47", "--ei", "d", "2")
        time.sleep(0.8)
        counts = {}
        for kind, vga in PLAN:
            counts[kind] = counts.get(kind, 0) + 1
            one(cfg, phone, doc, kind, vga, counts[kind])
            time.sleep(1.0)
        try:
            web.call("/api/vfo/exit", {})
        except Exception:
            pass
        time.sleep(1.0)
        st = web.call("/api/status")
        doc["transmitting"] = bool(st.get("transmitting"))
        doc["end_tag"] = phone.tag()
        doc["heat"] = gaps.base.heat_ok(cfg, phone)
        (cfg.out / "fw_gate_time.json").write_text(json.dumps(doc, indent=1), encoding="utf-8")
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
