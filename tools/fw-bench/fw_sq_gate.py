# Squelch byte versus the speaker gate, after monitor off.
# VFO list 1/9, FW57, VGA 30. The hotspot is not used.
#
# python tools/fw-bench/fw_sq_gate.py --grant
import json
import re
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
CMDS = ("cmd=0x30", "cmd=0x2F", "cmd=0x22", "cmd=0x23", "MON off", "promiscuous")


def keep(text):
    out = []
    for line in text.splitlines():
        if "TX cmd=" not in line and "cmd 0x" not in line and "MON off" not in line and "promiscuous" not in line:
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
    found = keep(phone.logcat(40))
    for line in found:
        doc["tx"].append({"at": label, "line": line})
    fr.say(cfg, "tx %s %s" % (label, len(found)))


def diag(phone, cmd, data):
    phone.adb(
        "shell", "am", "broadcast", "-a", "com.macdmr.radio.DIAG",
        "--es", "cmd", "cmdbyte", "--ei", "b", str(cmd), "--ei", "d", str(data))
    time.sleep(0.8)


def play(cfg, phone, web, doc, image, kind):
    return rr.replay(cfg, phone, web, doc, image, kind, VGA, False, set_mon=False)


def three(cfg, phone, web, doc, tag):
    out = []
    for kind in ("tg9", "tg99", "allcall"):
        row = play(cfg, phone, web, doc, tag + kind, kind)
        out.append(row)
        fr.say(cfg, "%s %s plays %s report %s rms %.1f" % (
            tag, kind, row["plays"], row["report_ok"], row["rms"]))
    return out


def arm(cfg, phone, web, doc, label, sq):
    phone.adb("shell", "logcat", "-c")
    diag(phone, 0x30, sq)
    diag(phone, 0x2F, 2)
    note(cfg, phone, doc, label)
    st = web.call("/api/status")
    doc["flags"].append({"at": label, "monitor": bool(st.get("monitor")), "vfo": bool(st.get("vfo"))})


def close_out(cfg, phone, web, doc, name="fw_sq_gate.json"):
    try:
        web.call("/api/vfo/exit", {})
    except Exception:
        pass
    time.sleep(1.0)
    st = web.call("/api/status")
    doc["transmitting"] = bool(st.get("transmitting"))
    doc["end_tag"] = phone.tag()
    doc["heat"] = gaps.base.heat_ok(cfg, phone)
    (cfg.out / name).write_text(json.dumps(doc, indent=1), encoding="utf-8")
    fr.say(cfg, "end %s transmitting %s" % (doc["end_tag"], doc["transmitting"]))


def main():
    if "--grant" not in sys.argv:
        raise SystemExit("refusing without --grant")
    cfg = Config()
    for path in rr.FILES.values():
        if not path.is_file():
            raise SystemExit("missing " + path.name)
    fr.BUSY.parent.mkdir(parents=True, exist_ok=True)
    fr.BUSY.write_text("sq gate\n", encoding="ascii")
    phone = None
    doc = {"rows": [], "tx": [], "flags": []}
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
        phone.adb("shell", "logcat", "-c")
        web.monitor(False)
        time.sleep(0.5)
        note(cfg, phone, doc, "app monitor off")
        rr.enter_vfo(cfg, web)
        note(cfg, phone, doc, "vfo")
        arm(cfg, phone, web, doc, "sq0", 0)
        three(cfg, phone, web, doc, "sq0")
        arm(cfg, phone, web, doc, "sq3", 3)
        three(cfg, phone, web, doc, "sq3")
        arm(cfg, phone, web, doc, "sq0 again", 0)
        phone.adb("shell", "logcat", "-c")
        rr.enter_vfo(cfg, web)
        note(cfg, phone, doc, "fresh vfo")
        play(cfg, phone, web, doc, "aftervfo", "tg9")
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


def row3():
    """The fresh-VFO clip only. The first pass saved it under a name with a space."""
    if "--grant" not in sys.argv:
        raise SystemExit("refusing without --grant")
    cfg = Config()
    fr.BUSY.parent.mkdir(parents=True, exist_ok=True)
    fr.BUSY.write_text("sq gate row3\n", encoding="ascii")
    phone = None
    doc = {"rows": [], "tx": [], "flags": []}
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
        arm(cfg, phone, web, doc, "sq0 again", 0)
        phone.adb("shell", "logcat", "-c")
        rr.enter_vfo(cfg, web)
        note(cfg, phone, doc, "fresh vfo")
        play(cfg, phone, web, doc, "aftervfo", "tg9")
        close_out(cfg, phone, web, doc, "fw_sq_gate_row3.json")
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
    if "--row3" in sys.argv:
        row3()
    else:
        main()
