# Stock app admission rows. Hands the radio back, replays three calls, then
# SignalDeck takes it again. FW57 stays in the module. VGA 30.
#
# python tools/fw-bench/fw_oem_rows.py --grant
import json
import re
import subprocess
import sys
import time

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
STOCK = "com.pri.prizeinterphone/.InterPhoneHomeActivity"


def play(cfg, kind):
    pp, np_ = rr.primer(cfg)
    proc, log = rr.start_tx(cfg, pp, np_, VGA)
    rr.finish_tx(proc, log, 1.0)
    path = rr.FILES[kind]
    proc, log = rr.start_tx(cfg, path, path.stat().st_size // 2, VGA)
    rr.finish_tx(proc, log, 12)


def stock_enabled(phone):
    rc, out = phone.adb("shell", "pm", "list", "packages", "-d")
    return "com.pri.prizeinterphone" not in out


def take_back(cfg, phone):
    phone.adb("shell", "am", "start", "-n", "com.macdmr.radio/.MainActivity")
    time.sleep(8)
    web = fr.open_web(phone)
    st = web.call("/api/status")
    disabled = not stock_enabled(phone)
    fr.say(cfg, "back tag %s tx %s stock-disabled %s" % (phone.tag(), st.get("transmitting"), disabled))
    return web, st, disabled


def main():
    if "--grant" not in sys.argv:
        raise SystemExit("refusing without --grant")
    cfg = Config()
    fr.BUSY.parent.mkdir(parents=True, exist_ok=True)
    fr.BUSY.write_text("oem rows\n", encoding="ascii")
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
        gaps.base.heat_ok(cfg, phone)
        web.select(49)
        time.sleep(gaps.base.SETTLE_S)
        ch = web.call("/api/channel?number=49").get("channel") or {}
        doc["channel49"] = {"sq": ch.get("sq"), "groups": ch.get("groups"), "rxFreq": ch.get("rxFreq")}
        fr.say(cfg, "handing back")
        web.call("/api/radio", {"action": "handback"})
        time.sleep(4)
        phone.adb("shell", "am", "start", "-n", STOCK)
        time.sleep(8)
        phone.adb("shell", "uiautomator", "dump", "/sdcard/Download/oem_ui.xml")
        ui = cfg.out / "oem_ui.xml"
        phone.adb("pull", "/sdcard/Download/oem_ui.xml", str(ui))
        phone.adb("shell", "rm", "/sdcard/Download/oem_ui.xml")
        if ui.is_file():
            text = ui.read_text(encoding="utf-8", errors="replace")
            bits = []
            for m in re.finditer(r'text="([^"]{0,40})"', text):
                t = m.group(1)
                if re.search(r"SQ|MON|MHz|squelch|467", t, re.I):
                    bits.append(t)
            doc["ui"] = bits[:30]
            fr.say(cfg, "ui %s" % bits[:12])
        for kind in ("tg9", "tg99", "allcall"):
            phone.adb("shell", "logcat", "-c")
            log_path = cfg.out / ("oem_%s.log" % kind)
            handle = open(log_path, "w", encoding="utf-8", errors="replace")
            proc = subprocess.Popen(
                [cfg.adb, "-s", cfg.serial, "logcat", "-v", "time"],
                stdout=handle, stderr=subprocess.DEVNULL)
            try:
                play(cfg, kind)
                time.sleep(1.0)
            finally:
                proc.terminate()
                try:
                    proc.wait(timeout=3)
                except Exception:
                    proc.kill()
                handle.close()
            raw = log_path.read_text(encoding="utf-8", errors="replace")
            keep = []
            for line in raw.splitlines():
                if not re.search(r"0x36|0x2B|RECEIVE|squelch|MON|AudioTrack|DMRMod", line, re.I):
                    continue
                line = re.sub(r"\[[0-9A-Fa-f][0-9A-Fa-f ]{8,}\]", "[body]", line)
                line = re.sub(r"\d{6,}", "#", line)
                keep.append(line.strip()[-160:])
            doc["rows"].append({"kind": kind, "lines": keep[:40]})
            fr.say(cfg, "oem %s lines %s" % (kind, len(keep)))
        web, st, disabled = take_back(cfg, phone)
        doc["end_tag"] = phone.tag()
        doc["transmitting"] = bool(st.get("transmitting"))
        doc["stock_disabled"] = disabled
        doc["heat"] = gaps.base.heat_ok(cfg, phone)
        (cfg.out / "fw_oem_rows.json").write_text(json.dumps(doc, indent=1), encoding="utf-8")
        if doc["transmitting"] or doc["end_tag"] != fr.FW57_TAG or not disabled:
            raise SystemExit("end state")
    finally:
        if hackrf_running():
            hackrf.kill()
        if phone is not None:
            try:
                phone.adb("shell", "am", "start", "-n", "com.macdmr.radio/.MainActivity")
                time.sleep(6)
                web = fr.open_web(phone)
                if web.call("/api/status").get("transmitting"):
                    web.call("/api/ptt", {"down": False})
            except Exception as exc:
                fr.say(cfg, "restore failed %s" % type(exc).__name__)
        try:
            if fr.BUSY.exists():
                fr.BUSY.unlink()
        except Exception as exc:
            fr.say(cfg, "busy clear failed %s" % type(exc).__name__)


if __name__ == "__main__":
    main()
