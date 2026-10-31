# Channel 49 talkgroup 9, then the branch in the 23:12 grant.
# Does not write the hotspot configuration.
#
# python tools/fw-bench/fw_ch49_now.py --grant
import re
import sys
import time
from pathlib import Path

HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))
sys.path.insert(0, str(HERE / "runner"))
import fw58_gaps as gaps  # noqa: E402
import fw_full_rows as fr  # noqa: E402
from common import Config  # noqa: E402
from hackrf import running as hackrf_running  # noqa: E402
from phone import Phone  # noqa: E402

fr.OUT_NAME = "fw_ch49_now.json"
HZ = 467625000


def rssi_bytes(text):
    found = []
    for m in re.finditer(r"RX cmd=0x32 rw=\d+ sr=\d+ len=\d+ \[([0-9A-F ]*)\]", text):
        raw = bytes.fromhex(m.group(1))
        if raw:
            found.append(raw[0])
    return found


def real_tg9(reports):
    return any(r.get("type") == 1 and r.get("target") == "9" for r in reports)


def row(cfg, phone, web, doc, kind, tag, suffix):
    fr.run_row(cfg, phone, web, doc, kind, False, None, tag, suffix, skip_done=False)
    text = phone.logcat(20)
    got = doc["rows"][-1]
    got["reports_late"] = gaps.frames_2b(text)
    got["rssi"] = rssi_bytes(text)
    got["plays"] = got.get("verdict") == "loud"
    got["tg9_report"] = real_tg9(got["reports_late"])
    fr.save(cfg, doc)
    fr.say(cfg, "%s plays %s 0x2B %s rssi %s" % (
        got.get("name"), got["plays"], len(got["reports_late"]), got["rssi"][:6]))
    return got


def main():
    if "--grant" not in sys.argv:
        raise SystemExit("refusing without --grant")
    cfg = Config()
    fr.BUSY.parent.mkdir(parents=True, exist_ok=True)
    fr.BUSY.write_text("channel 49 tg9\n", encoding="ascii")
    phone = None
    doc = {"rows": [], "before_header": ""}
    try:
        phone = Phone(cfg)
        if not phone.ok() or phone.cfg.serial != "192.168.1.125:5555":
            raise SystemExit("no phone")
        if hackrf_running():
            raise SystemExit("hackrf already running")
        phone.wake()
        phone.adb("shell", "am", "start", "-n", "com.macdmr.radio/.MainActivity")
        time.sleep(2)
        web = fr.open_web(phone)
        ch = web.call("/api/channel?number=49").get("channel") or {}
        if int(ch.get("rxFreq") or 0) != HZ or ch.get("power") != 0 or not ch.get("digital"):
            raise SystemExit("channel 49 is not 467.625 low-power digital")
        fr.say(cfg, "channel 49 slot %s cc %s" % (ch.get("slot"), ch.get("cc")))
        gaps.base.heat_ok(cfg, phone)
        web = fr.factory_then(cfg, phone, fr.FW57, fr.FW57_TAG)
        doc["tag"] = phone.tag()
        web.call("/api/vfo/exit", {})
        time.sleep(2)
        web.select(49)
        time.sleep(gaps.base.SETTLE_S)
        doc["before_header"] = fr.rows.last_header(cfg)
        state = fr.rows.modem_state(cfg)
        if not state.get("open"):
            fr.rows.restart_modem(cfg)
        first = row(cfg, phone, web, doc, "tg9", "ch49", "1")
        if first["plays"]:
            row(cfg, phone, web, doc, "tg99", "ch49", "1")
            row(cfg, phone, web, doc, "allcall", "ch49", "1")
            web.call("/api/vfo", gaps.vfo_body())
            time.sleep(gaps.base.SETTLE_S)
            problems = gaps.vfo_ok(web.call("/api/vfo"))
            fr.say(cfg, "vfo " + ("; ".join(problems) if problems else "list 1,9"))
            row(cfg, phone, web, doc, "tg9", "vfoA", "1")
        else:
            web.call("/api/vfo", gaps.vfo_body())
            time.sleep(gaps.base.SETTLE_S)
            fr.say(cfg, "vfo " + ("; ".join(gaps.vfo_ok(web.call("/api/vfo"))) or "list 1,9"))
            row(cfg, phone, web, doc, "tg9", "vfoA", "1")
            # The full file is the same bytes as the old control. Run it under its own name.
            fr.rows.FILES["tg9"] = fr.TG9
            row(cfg, phone, web, doc, "tg9", "last", "1")
        tx = bool(fr.open_web(phone).call("/api/status").get("transmitting"))
        doc["transmitting"] = tx
        doc["end_tag"] = phone.tag()
        doc["heat"] = gaps.base.heat_ok(cfg, phone)
        fr.save(cfg, doc)
        if tx or phone.tag() != fr.FW57_TAG:
            raise SystemExit("end state")
    finally:
        if phone is not None:
            try:
                web = fr.open_web(phone)
                if web.call("/api/status").get("transmitting"):
                    web.call("/api/ptt", {"down": False})
            except Exception as exc:
                fr.say(cfg, "unkey failed %s" % type(exc).__name__)
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
