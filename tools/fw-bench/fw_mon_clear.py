# Does a channel write clear monitor, and does a restart open the gate.
# FW57, VGA 30. The hotspot is not used.
#
# python tools/fw-bench/fw_mon_clear.py --grant
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
PWD = "/sys/devices/platform/dmr009/pwd"
CMDS = ("cmd=0x2F", "cmd=0x22", "cmd=0x23", "cmd=0x24", "cmd=0x25", "cmd=0x02", "promiscuous", "MON off")


def keep(text):
    out = []
    for line in text.splitlines():
        if not any(c in line for c in CMDS):
            continue
        if "cmd=0x22" in line or "cmd=0x23" in line:
            line = re.sub(r"\[[^\]]*\]", "[omitted]", line)
            line = re.sub(r"<[^>]*>", "", line)
        line = re.sub(r"\d{6,}", "#", line)
        out.append(line.strip()[-170:])
    return out


def note(cfg, phone, doc, label):
    found = keep(phone.logcat(50))
    for line in found:
        doc["tx"].append({"at": label, "line": line})
    fr.say(cfg, "tx %s %s" % (label, len(found)))


def select_49(cfg, web):
    try:
        web.call("/api/vfo/exit", {})
    except Exception:
        pass
    time.sleep(1.0)
    web.select(49)
    time.sleep(gaps.base.SETTLE_S)
    fr.say(cfg, "channel 49 selected, monitor left alone")


def play(cfg, phone, web, doc, image, kind):
    note(cfg, phone, doc, "before " + image)
    return rr.replay(cfg, phone, web, doc, image, kind, VGA, False, set_mon=False)


def restart(cfg, phone):
    phone.adb("shell", "am", "force-stop", phone.cfg.package)
    time.sleep(2.0)
    phone.wake()
    phone.adb("shell", "am", "start", "-n", "com.macdmr.radio/.MainActivity")
    web = None
    for _ in range(15):
        time.sleep(2.0)
        try:
            web = fr.open_web(phone)
            if web.call("/api/status").get("ready"):
                break
        except Exception as exc:
            fr.say(cfg, "web %s" % type(exc).__name__)
    if web is None:
        raise SystemExit("web did not return")
    return web


def power_cycle(cfg, phone):
    phone.adb("shell", "su -c 'echo 0 > %s'" % PWD, timeout=20)
    _, off = phone.adb("shell", "su -c cat %s" % PWD, timeout=20)
    fr.say(cfg, "pwd off %s" % off.strip().replace("\n", " ")[:30])
    time.sleep(15.0)
    phone.adb("shell", "su -c 'echo 1 > %s'" % PWD, timeout=20)
    time.sleep(2.0)
    _, on = phone.adb("shell", "su -c cat %s" % PWD, timeout=20)
    fr.say(cfg, "pwd on %s" % on.strip().replace("\n", " ")[:30])


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
    (cfg.out / "fw_mon_clear.json").write_text(__import__("json").dumps(doc, indent=1), encoding="utf-8")
    fr.say(cfg, "end %s transmitting %s" % (doc["end_tag"], doc["transmitting"]))


def main():
    if "--grant" not in sys.argv:
        raise SystemExit("refusing without --grant")
    cfg = Config()
    for path in rr.FILES.values():
        if not path.is_file():
            raise SystemExit("missing " + path.name)
    fr.BUSY.parent.mkdir(parents=True, exist_ok=True)
    fr.BUSY.write_text("mon clear\n", encoding="ascii")
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
        rr.on_channel_49(cfg, web)
        web.monitor(True)
        time.sleep(0.7)
        note(cfg, phone, doc, "mon on")
        web.select(49)
        time.sleep(gaps.base.SETTLE_S)
        note(cfg, phone, doc, "reselect 49")
        rr.enter_vfo(cfg, web)
        note(cfg, phone, doc, "vfo")
        play(cfg, phone, web, doc, "clear99", "tg99")
        play(cfg, phone, web, doc, "clear9", "tg9")
        rr.on_channel_49(cfg, web)
        web.monitor(True)
        time.sleep(0.4)
        web.monitor(False)
        time.sleep(0.5)
        closed = play(cfg, phone, web, doc, "closed", "tg9")
        doc["closed_plays"] = bool(closed["plays"])
        doc["closed_report"] = bool(closed["report_ok"])
        web = restart(cfg, phone)
        note(cfg, phone, doc, "after restart")
        select_49(cfg, web)
        play(cfg, phone, web, doc, "restart", "tg9")
        power_cycle(cfg, phone)
        web = restart(cfg, phone)
        if phone.tag() != fr.FW57_TAG:
            raise SystemExit("tag after power cycle is not FW57")
        note(cfg, phone, doc, "after power")
        select_49(cfg, web)
        play(cfg, phone, web, doc, "power", "tg9")
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
