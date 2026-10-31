# Speaker-gate check. FW57, HackRF replay at VGA 30, scaled talkgroup files.
# The hotspot is not used. Amp off, primer first, no -R.
#
# python tools/fw-bench/fw_gate_rows.py --grant
import re
import sys
import time
from pathlib import Path

HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))
sys.path.insert(0, str(HERE / "runner"))
import fw58_gaps as gaps  # noqa: E402
import fw_full_rows as fr  # noqa: E402
import fw_replay_rows as rr  # noqa: E402
import hackrf  # noqa: E402
from common import Config  # noqa: E402
from hackrf import running as hackrf_running  # noqa: E402
from phone import Phone  # noqa: E402

CMDS = ("cmd=0x2F", "cmd=0x22", "cmd=0x23", "cmd=0x24", "cmd=0x25", "cmd=0x02")
VGA = 30


def tx_lines(text):
    out = []
    for line in text.splitlines():
        if not any(c in line for c in CMDS):
            continue
        if "cmd=0x22" in line or "cmd=0x23" in line:
            line = re.sub(r"\[[0-9A-F ]*\]", "[omitted]", line)
        line = re.sub(r"\d{6,}", "#", line)
        out.append(line.strip()[-200:])
    return out


def note(cfg, phone, doc, label):
    found = tx_lines(phone.logcat(80))
    for line in found:
        doc["tx"].append({"at": label, "line": line})
    fr.say(cfg, "tx %s %s" % (label, len(found)))


def row(cfg, phone, web, doc, image, kind, mon):
    web.monitor(mon)
    time.sleep(0.6)
    note(cfg, phone, doc, "before " + image)
    got = rr.replay(cfg, phone, web, doc, image, kind, VGA, mon)
    note(cfg, phone, doc, "during " + image)
    return got


def analog_open(cfg, web):
    web.call("/api/vfo", {
        "type": 1, "rxMHz": 467.625, "txMHz": 467.625, "power": 0,
        "sq": 0, "band": 1, "lat": "", "lon": "",
    })
    time.sleep(5.0)
    doc = web.call("/api/vfo")
    ch = doc.get("channel") or {}
    fr.say(cfg, "analog vfo sq %s digital %s" % (ch.get("sq"), ch.get("digital")))
    return ch.get("sq")


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
    (cfg.out / "fw_gate_rows.json").write_text(__import__("json").dumps(doc, indent=1), encoding="utf-8")
    fr.say(cfg, "end %s transmitting %s" % (doc["end_tag"], doc["transmitting"]))


def main():
    if "--grant" not in sys.argv:
        raise SystemExit("refusing without --grant")
    cfg = Config()
    for path in rr.FILES.values():
        if not path.is_file():
            rr.scale_files(cfg)
            break
    fr.BUSY.parent.mkdir(parents=True, exist_ok=True)
    fr.BUSY.write_text("gate rows\n", encoding="ascii")
    phone = None
    doc = {"rows": [], "tx": [], "vga": VGA}
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
        rr.on_channel_49(cfg, web)
        a = row(cfg, phone, web, doc, "mon", "tg9", True)
        b = row(cfg, phone, web, doc, "off", "tg9", False)
        doc["analog_sq"] = analog_open(cfg, web)
        note(cfg, phone, doc, "after analog")
        rr.on_channel_49(cfg, web)
        c = row(cfg, phone, web, doc, "aftersq", "tg9", False)
        doc["a_plays"] = bool(a["plays"])
        doc["b_plays"] = bool(b["plays"])
        doc["c_plays"] = bool(c["plays"])
        fr.say(cfg, "gate a %s b %s c %s" % (doc["a_plays"], doc["b_plays"], doc["c_plays"]))
        if doc["a_plays"] and doc["c_plays"] and not doc["b_plays"]:
            web.monitor(True)
            row(cfg, phone, web, doc, "openmon", "tg99", True)
            row(cfg, phone, web, doc, "openmon", "allcall", True)
            doc["analog_sq_again"] = analog_open(cfg, web)
            rr.on_channel_49(cfg, web)
            row(cfg, phone, web, doc, "opensq", "tg99", False)
            row(cfg, phone, web, doc, "opensq", "allcall", False)
        close_out(cfg, phone, web, doc)
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
