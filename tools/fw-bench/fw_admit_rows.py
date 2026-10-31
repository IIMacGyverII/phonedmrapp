# Admission plan A-D. Does not run without --grant, and does not write the
# hotspot configuration.
#
# A  clean FW57, after factory + one key: TG 9, TG 9, TG 99, All-Call, TG 9.
#    MON off. 60 s between calls. Each row needs a new header, a carrier, and
#    the capture's embedded LC.
# B  hold applied the way the M17 page does it: analog VFO, M17 receive on
#    (data hold action 1), then the digital VFO, no release. The same five calls.
# C  M17 receive off, data hold action 0 logged. The same five calls.
# D  only if the first TG 9 in A is quiet: the five on channel 49, then on a
#    VFO stored as slot 0 (the editor's TS1). The A setup is stored slot 1,
#    which the editor labels TS2. applyChannel keeps only 0 or 1, so a
#    requested 2 would be stored as 0; this script asks for 0 and records the
#    readback.
#
# python tools/fw-bench/fw_admit_rows.py --grant
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

fr.OUT_NAME = "fw_admit_rows.json"
CALLS = [("tg9", "1"), ("tg9", "2"), ("tg99", "1"), ("allcall", "1"), ("tg9", "3")]
GAP_S = 60


def hold_lines(text):
    return [ln.strip()[-160:] for ln in text.splitlines() if "data hold" in ln][-8:]


def phase(cfg, phone, web, doc, tag):
    for kind, suffix in CALLS:
        fr.run_row(cfg, phone, web, doc, kind, False, None, tag, suffix, skip_done=False)
        row = doc["rows"][-1]
        late = phone.logcat(12)
        row["reports_late"] = gaps.frames_2b(late)
        row["hold_lines"] = hold_lines(late)
        fr.save(cfg, doc)
        fr.say(cfg, "%s %s 0x2B %s" % (tag, row.get("name"), len(row["reports_late"])))
        if (kind, suffix) != CALLS[-1]:
            time.sleep(GAP_S)


def m17(cfg, phone, web, on, already_off_ok=False):
    phone.adb("shell", "logcat", "-c")
    try:
        web.call("/api/m17", {"on": on})
    except Exception as exc:
        raise SystemExit("m17 %s refused %s" % ("on" if on else "off", type(exc).__name__))
    time.sleep(1.5)
    text = phone.logcat(8)
    lines = hold_lines(text)
    for ln in lines:
        fr.say(cfg, ln)
    if on:
        if not any("action=1" in ln for ln in lines):
            raise SystemExit("data hold action=1 was not logged")
    elif any("action=0" in ln for ln in lines):
        return lines
    elif already_off_ok and any("nothing held" in ln for ln in lines):
        return lines
    else:
        raise SystemExit("data hold action=0 was not logged")
    return lines


def enter(cfg, web, slot):
    body = dict(gaps.vfo_body())
    body["slot"] = slot
    web.call("/api/vfo", body)
    time.sleep(gaps.base.SETTLE_S)
    got = web.call("/api/vfo")
    ch = got.get("channel") or {}
    fr.say(cfg, "vfo requested %s readback %s" % (slot, ch.get("slot")))
    problems = [p for p in gaps.vfo_ok(got) if p != "slot"]
    if problems:
        raise SystemExit("vfo refused: " + "; ".join(problems))
    return ch.get("slot")


def first_tg9_quiet(doc):
    for row in doc["rows"]:
        if row.get("image") == "A" and row.get("kind") == "tg9" and str(row.get("name", "")).endswith("tg9_off1"):
            return row.get("verdict") == "muted"
    return False


def channel49(cfg, web):
    try:
        web.call("/api/vfo/exit", {})
    except Exception:
        pass
    time.sleep(2.0)
    web.select(gaps.base.CH49)
    time.sleep(gaps.base.SETTLE_S)
    ch = web.call("/api/channel?number=%d" % gaps.base.CH49).get("channel") or {}
    groups = [int(x) for x in (ch.get("groups") or [])]
    fr.say(cfg, "channel 49 digital %s power %s slot %s cc %s" % (
        ch.get("digital"), ch.get("power"), ch.get("slot"), ch.get("cc")))
    if not ch.get("digital") or ch.get("power") != 0 or 9 not in groups:
        raise SystemExit("channel 49 is not the in-list listener")


def main():
    if "--grant" not in sys.argv:
        print("plan A-D is ready: factory+FW57, then hold on, then release, then D if TG 9 is quiet")
        raise SystemExit("refusing without --grant")
    cfg = Config()
    fr.BUSY.parent.mkdir(parents=True, exist_ok=True)
    fr.BUSY.write_text("admit plan\n", encoding="ascii")
    phone = None
    doc = {"rows": [], "before_header": ""}
    try:
        phone = Phone(cfg)
        if not phone.ok() or phone.cfg.serial != "192.168.1.125:5555":
            raise SystemExit("no phone")
        if hackrf_running():
            raise SystemExit("hackrf already running")
        gaps.base.heat_ok(cfg, phone)
        if "--resume" in sys.argv and phone.tag() == fr.FW57_TAG:
            fr.say(cfg, "resume on %s, factory key already done this session" % phone.tag())
            phone.wake()
            phone.adb("shell", "am", "start", "-n", "com.macdmr.radio/.MainActivity")
            time.sleep(2)
            web = fr.open_web(phone)
        else:
            web = fr.factory_then(cfg, phone, fr.FW57, fr.FW57_TAG)
        doc["tag"] = phone.tag()
        enter(cfg, web, 1)
        doc["hold_A"] = m17(cfg, phone, web, False, already_off_ok=True)
        doc["before_header"] = fr.rows.last_header(cfg)
        phase(cfg, phone, web, doc, "A")
        time.sleep(GAP_S)
        phone.tune(cfg.freq_hz, 0)
        doc["hold_B"] = m17(cfg, phone, web, True)
        enter(cfg, web, 1)
        doc["hold_B_after_vfo"] = hold_lines(phone.logcat(8))
        if any("action=0" in ln for ln in doc["hold_B_after_vfo"]):
            raise SystemExit("the VFO write released the hold")
        phase(cfg, phone, web, doc, "B")
        time.sleep(GAP_S)
        doc["hold_C"] = m17(cfg, phone, web, False)
        enter(cfg, web, 1)
        phase(cfg, phone, web, doc, "C")
        if first_tg9_quiet(doc):
            fr.say(cfg, "TG 9 was quiet in A; running channel 49 and the other slot")
            time.sleep(GAP_S)
            channel49(cfg, web)
            phase(cfg, phone, web, doc, "D49")
            time.sleep(GAP_S)
            enter(cfg, web, 0)
            phase(cfg, phone, web, doc, "Dts1")
        else:
            fr.say(cfg, "TG 9 played in A; D skipped")
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
                    fr.say(cfg, "unkeyed in cleanup")
            except Exception as exc:
                fr.say(cfg, "unkey failed %s" % type(exc).__name__)
            try:
                if phone.tag() not in ("", fr.FW57_TAG):
                    fr.say(cfg, "restoring FW57 after a stop")
                    fr.factory_then(cfg, phone, fr.FW57, fr.FW57_TAG)
            except Exception as exc:
                fr.say(cfg, "restore failed %s" % type(exc).__name__)


if __name__ == "__main__":
    main()
