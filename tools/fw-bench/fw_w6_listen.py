# W6Plus 1 kHz DMR calls into the Armor on the PR 182 build.
# Keying is key.sh. HackRF receives. The hotspot is not used.
#
# python tools/fw-bench/fw_w6_listen.py --grant
import json
import math
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

BASH = r"C:\Program Files\Git\bin\bash.exe"
KEY = "/c/Users/Joshua/AppData/Local/Temp/claude/D--Documents-code-personal-phonedmrapp/5950190b-2f56-47ee-ae7d-d56c8c611e78/scratchpad/v69/dmrkey/key.sh"
IQAN = HERE.parent / "dmr-replay" / "iqan_tx.py"
NAMES = {"tg9": "Bench TG9", "tg99": "Bench TG99", "allcall": "Bench AllCall"}
BODY = re.compile(r"\[([0-9A-F ]*)\]")


def tone_line(path):
    w = wave.open(str(path), "rb")
    raw = w.readframes(w.getnframes())
    rate = w.getframerate() or 8000
    w.close()
    s = array("h")
    s.frombytes(raw[: len(raw) - (len(raw) % 2)])
    if len(s) < rate:
        return {"rms": 0.0, "line_db": None}
    rms = math.sqrt(sum(x * x for x in s) / len(s))
    # the loudest second
    best = 0
    buf = s[:rate]
    for off in range(0, len(s) - rate, rate // 2):
        chunk = s[off : off + rate]
        p = sum(x * x for x in chunk)
        if p > best:
            best = p
            buf = chunk

    def bin_power(freq):
        re = im = 0.0
        step = 2 * math.pi * freq / rate
        ang = 0.0
        for x in buf:
            re += x * math.cos(ang)
            im -= x * math.sin(ang)
            ang += step
        return re * re + im * im

    line = bin_power(1000)
    others = [bin_power(f) for f in (400, 700, 1300, 1600, 2200)]
    med = sorted(others)[len(others) // 2] or 1.0
    return {"rms": round(rms, 1), "line_db": round(10 * math.log10(line / med), 1)}


def targets(text):
    out = []
    status = []
    notes = []
    for line in text.splitlines():
        if "RX cmd=0x36" in line and "[01]" in line:
            status.append(1)
        elif "RX cmd=0x36" in line and "[02]" in line:
            status.append(2)
        elif "RX cmd=0x2B" in line:
            m = BODY.search(line)
            raw = bytes.fromhex(m.group(1)) if m else b""
            if len(raw) >= 9:
                tgt = int.from_bytes(raw[5:9], "little")
                if tgt not in (9, 99, 16777215) and tgt > 99999:
                    tgt = "other"
                out.append((raw[0], tgt))
            else:
                out.append(("short", len(raw)))
        elif re.search(r"admit|speaker|gate|DMR voice|Voice RX", line, re.I):
            clean = re.sub(r"\d{6,}", "#", line)
            notes.append(clean.strip()[-140:])
    return {"status": status, "reports": out[:8], "notes": notes[:8]}


def lc_of(path):
    if not path.is_file() or path.stat().st_size < 1000:
        return ["no capture"]
    found = None
    for off in (0, 800, -800, 1600, -1600):
        r = subprocess.run(
            [sys.executable, str(IQAN), str(path), "--fs", "2400000", "--off", str(off), "--dmr"],
            capture_output=True, text=True)
        text = (r.stdout or "") + (r.stderr or "")
        if "voice LC header" in text or "FLCO" in text:
            found = text
            break
        found = text
    rows = []
    for line in (found or "").splitlines():
        if "FLCO" in line or line.startswith("sync") or line.startswith("carrier") or line.startswith("no carrier") or line.startswith("best sync"):
            line = re.sub(r"src (\d+)", lambda m: "src bench" if m.group(1) == "1234567" else "src other", line)
            rows.append(line.strip()[:160])
    return rows[:8]


def rx_capture(cfg, phone, label, seconds, key_name):
    if hackrf_running():
        raise SystemExit("hackrf already running")
    gaps.base.heat_ok(cfg, phone)
    phone.adb("shell", "logcat", "-c")
    iq = cfg.out / ("w6_%s.iq" % label)
    wav = cfg.out / ("w6_%s.wav" % label)
    log_path = cfg.out / ("w6_%s.log" % label)
    log_handle = open(log_path, "w", encoding="utf-8", errors="replace")
    log_proc = subprocess.Popen(
        [cfg.adb, "-s", cfg.serial, "logcat", "-v", "time", "-s", "RadioService:I", "DiagReceiver:I"],
        stdout=log_handle, stderr=subprocess.STDOUT)
    phone.rx_clip(label, int(seconds * 1000))
    n = int(2_400_000 * seconds)
    hlog = open(str(iq) + ".log", "w", encoding="utf-8")
    hf = subprocess.Popen(
        [cfg.hackrf, "-r", str(iq), "-f", "467625000", "-s", "2400000", "-l", "16", "-g", "16", "-n", str(n)],
        stdout=hlog, stderr=subprocess.STDOUT)
    try:
        if key_name:
            r = subprocess.run([BASH, KEY, NAMES[key_name]], capture_output=True, text=True, timeout=40)
            fr.say(cfg, "key %s rc %s %s" % (key_name, r.returncode, (r.stdout or r.stderr or "").strip().splitlines()[-1:]))
        else:
            time.sleep(seconds)
        hf.wait(timeout=seconds + 15)
    finally:
        if hf.poll() is None:
            hf.kill()
        hlog.close()
        if hackrf_running():
            hackrf.kill()
    time.sleep(0.4)
    log_proc.terminate()
    try:
        log_proc.wait(timeout=3)
    except Exception:
        log_proc.kill()
    log_handle.close()
    phone.pull_app("/data/data/%s/cache/rxclip_%s.wav" % (phone.cfg.package, label), wav)
    text = log_path.read_text(encoding="utf-8", errors="replace")
    row = {"label": label, "key": key_name, "audio": tone_line(wav) if wav.is_file() else {"rms": 0, "line_db": None}}
    row.update(targets(text))
    row["lc"] = lc_of(iq)
    fr.say(cfg, "%s audio %s status %s reports %s" % (label, row["audio"], row["status"], row["reports"]))
    return row


def main():
    if "--grant" not in sys.argv:
        raise SystemExit("refusing without --grant")
    cfg = Config()
    fr.BUSY.parent.mkdir(parents=True, exist_ok=True)
    fr.BUSY.write_text("w6 listen\n", encoding="ascii")
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
        time.sleep(2)
        web = fr.open_web(phone)
        if web.call("/api/status").get("transmitting"):
            web.call("/api/ptt", {"down": False})
            time.sleep(1)
        doc["version"] = (web.call("/api/settings").get("version"))
        fr.say(cfg, "app %s" % doc["version"])

        def begin():
            web.select(49)
            time.sleep(gaps.base.SETTLE_S)
            rr.enter_vfo(cfg, web)
            web.monitor(False)
            time.sleep(0.4)

        begin()
        for kind in ("tg9", "tg99", "allcall"):
            doc["rows"].append(rx_capture(cfg, phone, "A_" + kind, 12, kind))
        begin()
        web.monitor(True)
        time.sleep(0.6)
        doc["rows"].append(rx_capture(cfg, phone, "B_tg99_mon", 12, "tg99"))
        web.monitor(False)
        time.sleep(0.6)
        doc["rows"].append(rx_capture(cfg, phone, "B_tg9_off", 12, "tg9"))
        web.select(49)
        time.sleep(gaps.base.SETTLE_S)
        rr.enter_vfo(cfg, web)
        time.sleep(0.4)
        doc["rows"].append(rx_capture(cfg, phone, "C_tg9", 12, "tg9"))
        begin()
        doc["rows"].append(rx_capture(cfg, phone, "D_idle", 10, None))
        try:
            web.call("/api/vfo/exit", {})
        except Exception:
            pass
        time.sleep(1)
        st = web.call("/api/status")
        doc["transmitting"] = bool(st.get("transmitting"))
        doc["end_tag"] = phone.tag()
        doc["heat"] = gaps.base.heat_ok(cfg, phone)
        (cfg.out / "fw_w6_listen.json").write_text(json.dumps(doc, indent=1), encoding="utf-8")
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
        except Exception:
            pass


if __name__ == "__main__":
    main()
