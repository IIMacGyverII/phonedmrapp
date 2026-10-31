# Scaled HackRF replays. The hotspot is not used.
# Originals stay in tools/dmr-replay/library/full_<kind>.iq.
# The x55 copies are peak about 0.9. Amp off, primer first, no -R, 2400000.
#
# python tools/fw-bench/fw_replay_rows.py --grant
import json
import subprocess
import sys
import time
from pathlib import Path

import numpy as np

HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))
sys.path.insert(0, str(HERE / "runner"))
import fw58_bisect as bisect  # noqa: E402
import fw58_gaps as gaps  # noqa: E402
import fw_full_rows as fr  # noqa: E402
import hackrf  # noqa: E402
from common import Config  # noqa: E402
from hackrf import running as hackrf_running  # noqa: E402
from phone import Phone  # noqa: E402

LIB = HERE.parents[1] / "tools" / "dmr-replay" / "library"
IQAN = HERE.parents[1] / "tools" / "dmr-replay" / "iqan_tx.py"
IQPEEK = HERE.parents[1] / "tools" / "dmr-replay" / "iqpeek.py"
ORIG = {"tg9": LIB / "full_tg9.iq", "tg99": LIB / "full_tg99.iq", "allcall": LIB / "full_allcall.iq"}
FILES = {k: LIB / ("full_%s_x55.iq" % k) for k in ORIG}
WANT = {"tg9": "9", "tg99": "99", "allcall": "16777215"}
FS = 2_400_000
SCALE = 5.5


def rssi_bytes(text):
    import re
    found = []
    for m in re.finditer(r"RX cmd=0x32 rw=\d+ sr=\d+ len=\d+ \[([0-9A-F ]*)\]", text):
        raw = bytes.fromhex(m.group(1))
        if raw:
            found.append(raw[0])
    return found


def signal_raw(raws):
    hot = [x for x in raws if x >= 40]
    use = hot or list(raws)
    if not use:
        return 0
    return sorted(use)[len(use) // 2]


def report_ok(kind, reports):
    want = WANT[kind]
    types = (1, 2) if kind == "allcall" else (1,)
    return any(r.get("type") in types and r.get("target") == want for r in reports)


def scale_files(cfg):
    for kind, src in ORIG.items():
        if not src.is_file():
            raise SystemExit("missing " + src.name)
        iq = np.fromfile(src, dtype=np.int8).astype(np.float32)
        out = np.clip(np.round(iq * SCALE), -127, 127).astype(np.int8)
        FILES[kind].write_bytes(out.tobytes())
        peek = subprocess.run([sys.executable, str(IQPEEK), str(FILES[kind])], capture_output=True, text=True)
        if "CLIPPING" in peek.stdout or "NEAR-SILENT" in peek.stdout:
            raise SystemExit(kind + " " + peek.stdout.strip())
        iqan = subprocess.run(
            [sys.executable, str(IQAN), str(FILES[kind]), "--fs", str(FS), "--off", "0", "--dmr"],
            capture_output=True, text=True)
        dests = []
        for line in iqan.stdout.splitlines():
            if "voice LC header" not in line or "FLCO 0" not in line:
                continue
            parts = line.split()
            dests.append(int(parts[parts.index("dst") + 1].rstrip(",")))
        if sorted(set(dests)) != [int(WANT[kind]) if kind != "allcall" else 16777215]:
            raise SystemExit("%s dests %s" % (kind, sorted(set(dests))))
        peak = ""
        for line in peek.stdout.splitlines():
            if line.startswith("peak"):
                peak = line.strip()
        fr.say(cfg, "scaled %s %s voice %s" % (kind, peak, sorted(set(dests))))


def start_tx(cfg, path, n, vga):
    if hackrf_running():
        raise RuntimeError("hackrf already running")
    log = open(str(path) + ".tx.log", "w", encoding="utf-8")
    proc = subprocess.Popen(
        [cfg.hackrf, "-t", str(path), "-f", str(cfg.freq_hz), "-s", str(FS), "-a", "0", "-x", str(vga), "-n", str(n)],
        stdout=log, stderr=subprocess.STDOUT)
    t0 = time.time()
    while time.time() - t0 < 4:
        if proc.poll() is not None:
            log.close()
            raise RuntimeError("hackrf tx exited early")
        if hackrf_running():
            return proc, log
        time.sleep(0.05)
    proc.kill()
    log.close()
    raise RuntimeError("hackrf tx did not start")


def finish_tx(proc, log, seconds):
    try:
        proc.wait(timeout=seconds + 25)
    except Exception:
        proc.kill()
        hackrf.kill()
        raise
    finally:
        log.close()
    if hackrf_running():
        hackrf.kill()
        raise RuntimeError("hackrf tx still running")


def primer(cfg):
    path = cfg.cap("replay_primer.iq")
    n = int(FS * 0.2)
    if not path.is_file() or path.stat().st_size != n * 2:
        path.write_bytes(bytes(n * 2))
    return path, n


def poll_rssi(phone):
    phone.adb(
        "shell", "am", "broadcast", "-a", "com.macdmr.radio.DIAG",
        "--es", "cmd", "cmdbyte", "--ei", "b", "50", "--ei", "d", "1")


def on_channel_49(cfg, web):
    try:
        web.call("/api/vfo/exit", {})
    except Exception:
        pass
    time.sleep(2.0)
    web.select(49)
    time.sleep(gaps.base.SETTLE_S)
    web.monitor(False)
    time.sleep(0.4)
    ch = web.call("/api/channel?number=49").get("channel") or {}
    if int(ch.get("rxFreq") or 0) != 467625000 or ch.get("power") != 0 or not ch.get("digital"):
        raise SystemExit("channel 49 is not 467.625 low-power digital")
    fr.say(cfg, "channel 49 slot %s cc %s" % (ch.get("slot"), ch.get("cc")))


def enter_vfo(cfg, web):
    web.call("/api/vfo", gaps.vfo_body())
    time.sleep(gaps.base.SETTLE_S)
    problems = gaps.vfo_ok(web.call("/api/vfo"))
    fr.say(cfg, "vfo " + ("; ".join(problems) if problems else "list 1,9"))
    if problems:
        raise SystemExit("vfo refused")


def replay(cfg, phone, web, doc, image, kind, vga, mon):
    if web.call("/api/status").get("transmitting"):
        raise SystemExit("phone is transmitting")
    if hackrf_running():
        raise SystemExit("hackrf already running")
    web.monitor(mon)
    time.sleep(0.3)
    if bool(web.call("/api/status").get("monitor")) != bool(mon):
        raise SystemExit("monitor did not take")
    name = "%s_%s_%s_%s" % (image, kind, "on" if mon else "off", vga)
    gaps.base.heat_ok(cfg, phone)
    phone.adb("shell", "logcat", "-c")
    t0 = time.time()
    phone.rx_clip(name, 14000)
    time.sleep(0.2)
    pp, np_ = primer(cfg)
    proc, log = start_tx(cfg, pp, np_, vga)
    finish_tx(proc, log, 1.0)
    time.sleep(0.2)
    path = FILES[kind]
    n = path.stat().st_size // 2
    proc, log = start_tx(cfg, path, n, vga)
    try:
        while proc.poll() is None and time.time() - t0 < 20:
            poll_rssi(phone)
            time.sleep(0.25)
    finally:
        finish_tx(proc, log, n / FS)
    remain = 15.0 - (time.time() - t0)
    if remain > 0:
        time.sleep(remain)
    text = phone.logcat(40)
    wav = cfg.out / (name + ".wav")
    phone.pull_app("/data/data/%s/cache/rxclip_%s.wav" % (phone.cfg.package, name), wav)
    rms, peak = gaps.clip_levels(wav)
    loud_s = bisect.loud_seconds(wav) if wav.is_file() else 0.0
    reports = gaps.frames_2b(text)
    raw = rssi_bytes(text)
    row = {
        "name": name, "image": image, "kind": kind, "mon": mon, "vga": vga,
        "rms": round(rms, 1), "peak": peak, "loud_s": loud_s,
        "plays": rms >= 400 or loud_s >= 1.0,
        "reports": reports, "report_ok": report_ok(kind, reports),
        "rssi": raw, "level": signal_raw(raw),
    }
    doc["rows"].append(row)
    (cfg.out / "fw_replay_rows.json").write_text(json.dumps(doc, indent=1), encoding="utf-8")
    fr.say(cfg, "%s vga %s plays %s 0x2B %s rms %.1f loud %.2f level %s rssi %s" % (
        name, vga, row["plays"], row["report_ok"], row["rms"], loud_s, row["level"], raw[:10]))
    return row


def choose_vga(cfg, phone, web, doc):
    vga = 18
    seen = {}
    for _ in range(3):
        if vga in seen:
            break
        row = replay(cfg, phone, web, doc, "cal", "tg9", vga, False)
        seen[vga] = row["level"]
        level = row["level"]
        fr.say(cfg, "level vga %s raw %s" % (vga, level))
        if 60 <= level <= 75 or vga >= 30:
            break
        step = int(round((67 - level) / 2.0))
        if step == 0:
            step = 1 if level < 60 else -1
        vga = max(0, min(30, vga + step))
    doc["vga_hi"] = vga
    doc["vga_lo"] = max(0, vga - 10)
    doc["level_tries"] = seen
    fr.say(cfg, "using vga %s and %s" % (doc["vga_hi"], doc["vga_lo"]))
    return doc["vga_hi"], doc["vga_lo"]


def pair(cfg, phone, web, doc, image, kind, mon, hi, lo):
    out = []
    for vga in (hi, lo):
        out.append(replay(cfg, phone, web, doc, image, kind, vga, mon))
        time.sleep(1.0)
    return out


def vfo_set(cfg, phone, web, doc, image, hi, lo):
    enter_vfo(cfg, web)
    rows = []
    for kind in ("tg9", "tg99", "allcall"):
        rows.extend(pair(cfg, phone, web, doc, image, kind, False, hi, lo))
    web.monitor(True)
    rows.extend(pair(cfg, phone, web, doc, image, "allcall", True, hi, lo))
    return rows


def close_out(cfg, phone, web, doc):
    try:
        web.call("/api/vfo/exit", {})
    except Exception:
        pass
    time.sleep(1.0)
    st = web.call("/api/status")
    doc["transmitting"] = bool(st.get("transmitting"))
    doc["end_tag"] = phone.tag()
    doc["heat"] = gaps.base.heat_ok(cfg, phone)
    (cfg.out / "fw_replay_rows.json").write_text(json.dumps(doc, indent=1), encoding="utf-8")
    fr.say(cfg, "end %s transmitting %s" % (doc["end_tag"], doc["transmitting"]))
    if doc["transmitting"] or doc["end_tag"] != fr.FW57_TAG:
        raise SystemExit("end state")


def main():
    if "--grant" not in sys.argv:
        raise SystemExit("refusing without --grant")
    cfg = Config()
    scale_files(cfg)
    fr.BUSY.parent.mkdir(parents=True, exist_ok=True)
    fr.BUSY.write_text("replay rows\n", encoding="ascii")
    phone = None
    doc = {"rows": [], "scale": SCALE}
    finished = False
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
        on_channel_49(cfg, web)
        hi, lo = choose_vga(cfg, phone, web, doc)
        step1 = pair(cfg, phone, web, doc, "fw57", "tg9", False, hi, lo)
        loud = [r for r in step1 if r["vga"] == hi]
        if not loud or not (loud[0]["plays"] and loud[0]["report_ok"]):
            fr.say(cfg, "channel 49 talkgroup 9 did not play at vga %s; stopped" % hi)
            close_out(cfg, phone, web, doc)
            finished = True
            return
        vfo_set(cfg, phone, web, doc, "fw57", hi, lo)
        web = fr.factory_then(cfg, phone, fr.F59D, fr.F59D_TAG)
        if phone.tag() != fr.F59D_TAG:
            raise SystemExit("tag is not F59D")
        vfo_set(cfg, phone, web, doc, "f59d", hi, lo)
        web = fr.factory_then(cfg, phone, fr.FW57, fr.FW57_TAG)
        close_out(cfg, phone, web, doc)
        finished = True
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
            if not finished:
                try:
                    if phone.tag() not in ("", fr.FW57_TAG):
                        fr.factory_then(cfg, phone, fr.FW57, fr.FW57_TAG)
                except Exception as exc:
                    fr.say(cfg, "restore failed %s" % type(exc).__name__)
        try:
            if fr.BUSY.exists():
                fr.BUSY.unlink()
        except Exception as exc:
            fr.say(cfg, "busy clear failed %s" % type(exc).__name__)


if __name__ == "__main__":
    main()
