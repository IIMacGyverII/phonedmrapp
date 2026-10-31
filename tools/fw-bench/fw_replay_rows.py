# HackRF replays of the prepared full-file calls. The hotspot is not used.
# VGA 18 then VGA 8. Amp off, a zero primer first, one-shot, sample rate 2400000.
#
# python tools/fw-bench/fw_replay_rows.py --grant
import json
import sys
import time
from pathlib import Path

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
FILES = {"tg9": LIB / "full_tg9.iq", "tg99": LIB / "full_tg99.iq", "allcall": LIB / "full_allcall.iq"}
WANT = {"tg9": "9", "tg99": "99", "allcall": "16777215"}
FS = 2_400_000
VGAS = (18, 8)


def rssi_bytes(text):
    import re
    found = []
    for m in re.finditer(r"RX cmd=0x32 rw=\d+ sr=\d+ len=\d+ \[([0-9A-F ]*)\]", text):
        raw = bytes.fromhex(m.group(1))
        if raw:
            found.append(raw[0])
    return found


def report_ok(kind, reports):
    want = WANT[kind]
    types = (1, 2) if kind == "allcall" else (1,)
    return any(r.get("type") in types and r.get("target") == want for r in reports)


def start_tx(cfg, path, n, vga):
    if hackrf_running():
        raise RuntimeError("hackrf already running")
    log = open(str(path) + ".tx.log", "w", encoding="utf-8")
    proc = __import__("subprocess").Popen(
        [cfg.hackrf, "-t", str(path), "-f", str(cfg.freq_hz), "-s", str(FS), "-a", "0", "-x", str(vga), "-n", str(n)],
        stdout=log, stderr=__import__("subprocess").STDOUT)
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


def on_channel_49(cfg, web):
    try:
        web.call("/api/vfo/exit", {})
    except Exception:
        pass
    time.sleep(2.0)
    web.select(49)
    time.sleep(gaps.base.SETTLE_S)
    web.monitor(False)
    time.sleep(0.5)
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
    time.sleep(0.4)
    st = web.call("/api/status")
    if bool(st.get("monitor")) != bool(mon):
        raise SystemExit("monitor did not take")
    name = "%s_%s_%s_%s" % (image, kind, "on" if mon else "off", vga)
    gaps.base.heat_ok(cfg, phone)
    phone.adb("shell", "logcat", "-c")
    t0 = time.time()
    phone.rx_clip(name, 14000)
    time.sleep(0.3)
    pp, np_ = primer(cfg)
    proc, log = start_tx(cfg, pp, np_, vga)
    finish_tx(proc, log, 1.0)
    time.sleep(0.3)
    path = FILES[kind]
    n = path.stat().st_size // 2
    proc, log = start_tx(cfg, path, n, vga)
    api = []
    hearing = []
    try:
        while proc.poll() is None and time.time() - t0 < 20:
            st = web.call("/api/status")
            api.append(st.get("rssi"))
            hearing.append(bool(st.get("hearing")))
            time.sleep(0.6)
    finally:
        finish_tx(proc, log, n / FS)
    remain = 15.0 - (time.time() - t0)
    if remain > 0:
        time.sleep(remain)
    text = phone.logcat(30)
    wav = cfg.out / (name + ".wav")
    phone.pull_app("/data/data/%s/cache/rxclip_%s.wav" % (phone.cfg.package, name), wav)
    rms, peak = gaps.clip_levels(wav)
    loud_s = bisect.loud_seconds(wav) if wav.is_file() else 0.0
    reports = gaps.frames_2b(text)
    row = {
        "name": name, "image": image, "kind": kind, "mon": mon, "vga": vga,
        "rms": round(rms, 1), "peak": peak, "loud_s": loud_s,
        "plays": rms >= 400 or loud_s >= 1.0,
        "reports": reports, "report_ok": report_ok(kind, reports),
        "rssi": rssi_bytes(text), "api": api, "hearing": hearing,
    }
    doc["rows"].append(row)
    (cfg.out / "fw_replay_rows.json").write_text(json.dumps(doc, indent=1), encoding="utf-8")
    fr.say(cfg, "%s vga %s plays %s 0x2B %s rms %.1f loud %.2f rssi %s" % (
        name, vga, row["plays"], row["report_ok"], row["rms"], loud_s, row["rssi"][:8]))
    return row


def both(cfg, phone, web, doc, image, kind, mon):
    out = []
    for vga in VGAS:
        out.append(replay(cfg, phone, web, doc, image, kind, vga, mon))
        time.sleep(1.0)
    return out


def vfo_set(cfg, phone, web, doc, image):
    enter_vfo(cfg, web)
    rows = []
    for kind in ("tg9", "tg99", "allcall"):
        rows.extend(both(cfg, phone, web, doc, image, kind, False))
    web.monitor(True)
    rows.extend(both(cfg, phone, web, doc, image, "allcall", True))
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
    for path in FILES.values():
        if not path.is_file():
            raise SystemExit("missing " + path.name)
    cfg = Config()
    fr.BUSY.parent.mkdir(parents=True, exist_ok=True)
    fr.BUSY.write_text("replay rows\n", encoding="ascii")
    phone = None
    doc = {"rows": []}
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
        step1 = both(cfg, phone, web, doc, "fw57", "tg9", False)
        if not all(r["plays"] and r["report_ok"] for r in step1):
            fr.say(cfg, "channel 49 talkgroup 9 did not play at both levels; stopped")
            close_out(cfg, phone, web, doc)
            finished = True
            return
        vfo_set(cfg, phone, web, doc, "fw57")
        web = fr.factory_then(cfg, phone, fr.F59D, fr.F59D_TAG)
        if phone.tag() != fr.F59D_TAG:
            raise SystemExit("tag is not F59D")
        vfo_set(cfg, phone, web, doc, "f59d")
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
