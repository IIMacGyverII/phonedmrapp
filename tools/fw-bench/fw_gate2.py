# Gate open on the VFO, then what opens or closes it. FW57, VGA 30.
# The hotspot is not used.
#
# python tools/fw-bench/fw_gate2.py --grant
import re
import sys
import time

HERE = __import__("pathlib").Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))
sys.path.insert(0, str(HERE / "runner"))
import fw58_gaps as gaps  # noqa: E402
import fw_full_rows as fr  # noqa: E402
import fw_replay_rows as rr  # noqa: E402
import hackrf  # noqa: E402
from common import Config  # noqa: E402
from hackrf import running as hackrf_running  # noqa: E402
from phone import Phone  # noqa: E402

VGA = 30
CMDS = ("cmd=0x2F", "cmd=0x22", "cmd=0x23", "cmd=0x24", "cmd=0x25", "cmd=0x02")


def tx_lines(text):
    out = []
    for line in text.splitlines():
        if not any(c in line for c in CMDS):
            continue
        if "cmd=0x22" in line or "cmd=0x23" in line:
            line = re.sub(r"\[[^\]]*\]", "[omitted]", line)
            line = re.sub(r"<[^>]*>", "", line)
        line = re.sub(r"\d{6,}", "#", line)
        out.append(line.strip()[-180:])
    return out


def note(cfg, phone, doc, label):
    found = tx_lines(phone.logcat(80))
    for line in found:
        doc["tx"].append({"at": label, "line": line})
    fr.say(cfg, "tx %s %s" % (label, len(found)))


def play(cfg, phone, web, doc, image, kind):
    note(cfg, phone, doc, "before " + image)
    got = rr.replay(cfg, phone, web, doc, image, kind, VGA, False, set_mon=False)
    note(cfg, phone, doc, "during " + image)
    return got


def analog(cfg, web, sq):
    web.call("/api/vfo", {
        "type": 1, "rxMHz": 467.625, "txMHz": 467.625, "power": 0,
        "sq": sq, "band": 1, "lat": "", "lon": "",
    })
    time.sleep(5.0 if sq == 0 else 3.0)
    ch = (web.call("/api/vfo").get("channel") or {})
    fr.say(cfg, "analog sq read %s" % ch.get("sq"))
    return ch.get("sq")


def back_to_49(cfg, web):
    try:
        web.call("/api/vfo/exit", {})
    except Exception:
        pass
    time.sleep(1.0)
    web.select(49)
    time.sleep(gaps.base.SETTLE_S)


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
    (cfg.out / "fw_gate2.json").write_text(__import__("json").dumps(doc, indent=1), encoding="utf-8")
    fr.say(cfg, "end %s transmitting %s" % (doc["end_tag"], doc["transmitting"]))


def main():
    if "--grant" not in sys.argv:
        raise SystemExit("refusing without --grant")
    cfg = Config()
    for path in rr.FILES.values():
        if not path.is_file():
            raise SystemExit("missing " + path.name)
    fr.BUSY.parent.mkdir(parents=True, exist_ok=True)
    fr.BUSY.write_text("gate 2\n", encoding="ascii")
    phone = None
    doc = {"rows": [], "tx": []}
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
        web.monitor(False)
        time.sleep(0.4)
        doc["sq0"] = analog(cfg, web, 0)
        note(cfg, phone, doc, "analog0")
        rr.enter_vfo(cfg, web)
        note(cfg, phone, doc, "vfo")
        for kind, image in (("tg99", "vfo99"), ("allcall", "vfoall"), ("tg9", "vfo9")):
            play(cfg, phone, web, doc, image, kind)
        web.monitor(False)
        time.sleep(0.6)
        note(cfg, phone, doc, "mon off")
        rr.enter_vfo(cfg, web)
        time.sleep(1.0)
        back_to_49(cfg, web)
        note(cfg, phone, doc, "2a")
        play(cfg, phone, web, doc, "a22", "tg9")
        rr.enter_vfo(cfg, web)
        web.monitor(True)
        time.sleep(0.6)
        back_to_49(cfg, web)
        note(cfg, phone, doc, "2b")
        play(cfg, phone, web, doc, "b2f", "tg9")
        doc["sq0b"] = analog(cfg, web, 0)
        back_to_49(cfg, web)
        note(cfg, phone, doc, "2c")
        play(cfg, phone, web, doc, "c22", "tg9")
        doc["sq2"] = analog(cfg, web, 2)
        note(cfg, phone, doc, "sq2")
        back_to_49(cfg, web)
        note(cfg, phone, doc, "after sq2")
        play(cfg, phone, web, doc, "sq2", "tg9")
        web.monitor(False)
        time.sleep(0.6)
        if web.call("/api/status").get("transmitting"):
            web.call("/api/ptt", {"down": False})
            time.sleep(0.5)
        web.call("/api/ptt", {"down": True})
        time.sleep(2.0)
        web.call("/api/ptt", {"down": False})
        time.sleep(1.0)
        note(cfg, phone, doc, "after key")
        play(cfg, phone, web, doc, "key", "tg9")
        close_out(cfg, phone, web, doc)
        if doc.get("transmitting") or doc.get("end_tag") != fr.FW57_TAG:
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
