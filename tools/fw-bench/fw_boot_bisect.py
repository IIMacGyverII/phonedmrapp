# Which take-over command closes the speaker gate.
# Open with monitor on, then one DIAG command at a time.
# FW57, VGA 30. The hotspot is not used.
#
# python tools/fw-bench/fw_boot_bisect.py --grant
import re
import sys
import time

HERE = __import__("pathlib").Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))
sys.path.insert(0, str(HERE / "runner"))
import fw_full_rows as fr  # noqa: E402
import fw_replay_rows as rr  # noqa: E402
import hackrf  # noqa: E402
from common import Config  # noqa: E402
from hackrf import running as hackrf_running  # noqa: E402
from phone import Phone  # noqa: E402

VGA = 30
CMDS = ("cmd=0x3B", "cmd=0x35", "cmd=0x34", "cmd=0x22", "cmd=0x2F", "cmd=0x2A", "promiscuous", "MON off", "boot handshake")


def keep(text):
    out = []
    for line in text.splitlines():
        if "TX cmd=" not in line and "cmd 0x" not in line and "MON off" not in line and "boot handshake" not in line and "promiscuous" not in line:
            continue
        if not any(c in line for c in CMDS) and "cmd 0x" not in line:
            continue
        if "cmd=0x22" in line or "cmd=0x23" in line:
            line = re.sub(r"\[[^\]]*\]", "[omitted]", line)
            line = re.sub(r"<[^>]*>", "", line)
        line = re.sub(r"\d{6,}", "#", line)
        out.append(line.strip()[-170:])
    return out


def note(cfg, phone, doc, label):
    found = keep(phone.logcat(60))
    for line in found:
        doc["tx"].append({"at": label, "line": line})
    fr.say(cfg, "tx %s %s" % (label, len(found)))


def diag(phone, cmd, data):
    phone.adb(
        "shell", "am", "broadcast", "-a", "com.macdmr.radio.DIAG",
        "--es", "cmd", "cmdbyte", "--ei", "b", str(cmd), "--ei", "d", str(data))
    time.sleep(0.6)


def play(cfg, phone, web, doc, image, kind):
    return rr.replay(cfg, phone, web, doc, image, kind, VGA, False, set_mon=False)


def pair(cfg, phone, web, doc, tag):
    note(cfg, phone, doc, "after " + tag)
    nine = play(cfg, phone, web, doc, tag + "9", "tg9")
    ninety = play(cfg, phone, web, doc, tag + "99", "tg99")
    fr.say(cfg, "%s tg9 %s report %s tg99 %s report %s" % (
        tag, nine["plays"], nine["report_ok"], ninety["plays"], ninety["report_ok"]))
    return nine, ninety


def close_out(cfg, phone, web, doc):
    try:
        web.call("/api/vfo/exit", {})
    except Exception:
        pass
    time.sleep(1.0)
    st = web.call("/api/status")
    doc["transmitting"] = bool(st.get("transmitting"))
    doc["end_tag"] = phone.tag()
    (cfg.out / "fw_boot_bisect.json").write_text(__import__("json").dumps(doc, indent=1), encoding="utf-8")
    fr.say(cfg, "end %s transmitting %s" % (doc["end_tag"], doc["transmitting"]))


def main():
    if "--grant" not in sys.argv:
        raise SystemExit("refusing without --grant")
    cfg = Config()
    for path in rr.FILES.values():
        if not path.is_file():
            raise SystemExit("missing " + path.name)
    fr.BUSY.parent.mkdir(parents=True, exist_ok=True)
    fr.BUSY.write_text("boot bisect\n", encoding="ascii")
    phone = None
    doc = {"rows": [], "tx": [], "startup": []}
    try:
        phone = Phone(cfg)
        if not phone.ok() or phone.cfg.serial != "192.168.1.125:5555":
            raise SystemExit("no phone")
        if hackrf_running():
            raise SystemExit("hackrf already running")
        if phone.tag() != fr.FW57_TAG:
            raise SystemExit("not on FW57")
        doc["startup"] = keep(phone.logcat(200))
        fr.say(cfg, "startup lines %s" % len(doc["startup"]))
        phone.wake()
        phone.adb("shell", "am", "start", "-n", "com.macdmr.radio/.MainActivity")
        time.sleep(2.0)
        web = fr.open_web(phone)
        if web.call("/api/status").get("transmitting"):
            web.call("/api/ptt", {"down": False})
            time.sleep(1.0)
        web.monitor(False)
        time.sleep(0.4)
        rr.enter_vfo(cfg, web)
        web.monitor(True)
        time.sleep(0.7)
        note(cfg, phone, doc, "opened")
        pair(cfg, phone, web, doc, "open")
        diag(phone, 0x3B, 122)
        pair(cfg, phone, web, doc, "tot122")
        diag(phone, 0x3B, 0)
        pair(cfg, phone, web, doc, "tot0")
        diag(phone, 0x35, 2)
        pair(cfg, phone, web, doc, "intoff")
        diag(phone, 0x35, 1)
        pair(cfg, phone, web, doc, "inton")
        diag(phone, 0x34, 1)
        pair(cfg, phone, web, doc, "ver")
        web.select(49)
        time.sleep(gaps_settle())
        pair(cfg, phone, web, doc, "ch49")
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


def gaps_settle():
    import fw58_gaps as gaps
    return gaps.base.SETTLE_S


if __name__ == "__main__":
    main()
