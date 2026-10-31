# (i) VFO list 1/9 with monitor on and nothing after that command.
# (ii) Analog squelch 0 while a tone is on the air, then the digital VFO, no 0x2F.
# FW57, replay VGA 30. The hotspot is not used.
#
# python tools/fw-bench/fw_gate3.py --grant
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
FS = 2_000_000


def tx_2f(text):
    out = []
    for line in text.splitlines():
        if "cmd=0x2F" not in line and "MON off" not in line:
            continue
        line = re.sub(r"\d{6,}", "#", line)
        out.append(line.strip()[-160:])
    return out


def note(cfg, phone, doc, label):
    found = tx_2f(phone.logcat(40))
    for line in found:
        doc["mon"].append({"at": label, "line": line})
    fr.say(cfg, "mon %s %s" % (label, len(found)))


def tone(cfg, seconds):
    if hackrf_running():
        raise SystemExit("hackrf already running")
    hackrf.dummy(cfg, FS, VGA)
    blob, n = hackrf.fm_iq(FS, seconds, 2500.0, tone=1000.0)
    path = cfg.cap("gate_tone.cs8")
    path.write_bytes(blob)
    proc, log = rr.start_tx(cfg, path, n, VGA)
    rr.finish_tx(proc, log, seconds)


def close_out(cfg, phone, web, doc):
    try:
        web.call("/api/vfo/exit", {})
    except Exception:
        pass
    time.sleep(1.0)
    st = web.call("/api/status")
    doc["transmitting"] = bool(st.get("transmitting"))
    doc["end_tag"] = phone.tag()
    (cfg.out / "fw_gate3.json").write_text(__import__("json").dumps(doc, indent=1), encoding="utf-8")
    fr.say(cfg, "end %s transmitting %s" % (doc["end_tag"], doc["transmitting"]))


def main():
    if "--grant" not in sys.argv:
        raise SystemExit("refusing without --grant")
    cfg = Config()
    for path in rr.FILES.values():
        if not path.is_file():
            raise SystemExit("missing " + path.name)
    fr.BUSY.parent.mkdir(parents=True, exist_ok=True)
    fr.BUSY.write_text("gate 3\n", encoding="ascii")
    phone = None
    doc = {"rows": [], "mon": []}
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
        time.sleep(0.5)
        rr.enter_vfo(cfg, web)
        web.monitor(True)
        time.sleep(0.8)
        note(cfg, phone, doc, "mon on")
        for kind, image in (("tg99", "mon99"), ("allcall", "monall"), ("tg9", "mon9")):
            rr.replay(cfg, phone, web, doc, image, kind, VGA, True, set_mon=False)
        web.monitor(False)
        time.sleep(0.4)
        web.call("/api/vfo", {
            "type": 1, "rxMHz": 467.625, "txMHz": 467.625, "power": 0,
            "sq": 0, "band": 1, "lat": "", "lon": "",
        })
        time.sleep(0.6)
        tone(cfg, 4.5)
        if hackrf_running():
            hackrf.kill()
        ch = (web.call("/api/vfo").get("channel") or {})
        fr.say(cfg, "analog during tone sq %s" % ch.get("sq"))
        note(cfg, phone, doc, "after tone")
        rr.enter_vfo(cfg, web)
        note(cfg, phone, doc, "digital vfo")
        rr.replay(cfg, phone, web, doc, "tonethen", "tg9", VGA, False, set_mon=False)
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
