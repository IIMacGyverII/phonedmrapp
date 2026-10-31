# FW60 bench rows. F60D first, after a factory key. Keying is key.sh.
# The hotspot is not used. HackRF receives only.
#
# python tools/fw-bench/fw_fw60_rows.py --grant
import json
import subprocess
import sys
import time

HERE = __import__("pathlib").Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))
sys.path.insert(0, str(HERE / "runner"))
import fw_full_rows as fr  # noqa: E402
import fw_replay_rows as rr  # noqa: E402
import fw_w6_listen as listen  # noqa: E402
import fw58_gaps as gaps  # noqa: E402
import hackrf  # noqa: E402
from common import Config  # noqa: E402
from hackrf import running as hackrf_running  # noqa: E402
from phone import Phone  # noqa: E402

ROOT = HERE.parents[1]
BUILD = ROOT / "radio_firmware" / "build"
F60D = BUILD / "DMR003.F60D.V022.bin"
F60D_TAG = "DMR003.F60D.V022"
LNA = "32"
VGA = "24"
TONE_DB = 6.0


def read_ram(cfg, phone, addr, n):
    remote = gaps.base.push_body(phone, gaps.base.op14(addr, n), "op14_%X.bin" % addr)
    phone.broadcast("raw40", "--es", "path", remote)
    time.sleep(0.7)
    local = cfg.out / ("ram_%X.bin" % addr)
    phone.pull_app("/data/data/%s/cache/raw40.bin" % (phone.cfg.package), local)
    return local.read_bytes() if local.is_file() else b""


def slot_view(gate, table):
    """The bytes the stub reads. Words other than 9, 99 and 16777215 stay hidden."""
    if len(gate) < 20 or len(table) < 40:
        return {"gate_len": len(gate), "table_len": len(table)}
    slot = gate[2]
    word_off = (slot + 7) * 4
    word = int.from_bytes(table[word_off:word_off + 4], "little") if word_off + 4 <= len(table) else None
    return {
        "slot": slot,
        "gate13": gate[0x13],
        "match14": table[slot + 14] if slot + 14 < len(table) else None,
        "match16": table[slot + 16] if slot + 16 < len(table) else None,
        "word": gaps.base.show_word(word),
    }


def rx_capture(cfg, phone, label, seconds, key_name, with_ram):
    if hackrf_running():
        raise SystemExit("hackrf already running")
    gaps.base.heat_ok(cfg, phone)
    phone.adb("shell", "logcat", "-c")
    iq = cfg.out / ("w6_%s.iq" % label)
    wav = cfg.out / ("w6_%s.wav" % label)
    log_path = cfg.out / ("w6_%s.log" % label)
    log_handle = open(log_path, "w", encoding="utf-8", errors="replace")
    log_proc = subprocess.Popen(
        [cfg.adb, "-s", cfg.serial, "logcat", "-v", "time", "-s", "RadioService:I", "DiagReceiver:I"],
        stdout=log_handle, stderr=subprocess.STDOUT)
    phone.rx_clip(label, int(seconds * 1000))
    n = int(2_400_000 * seconds)
    hlog = open(str(iq) + ".log", "w", encoding="utf-8")
    hf = subprocess.Popen(
        [cfg.hackrf, "-r", str(iq), "-f", "467625000", "-s", "2400000",
         "-l", LNA, "-g", VGA, "-n", str(n)],
        stdout=hlog, stderr=subprocess.STDOUT)
    ram = None
    try:
        proc = subprocess.Popen(
            [listen.BASH, listen.KEY, listen.NAMES[key_name]],
            stdout=subprocess.PIPE, stderr=subprocess.STDOUT, text=True)
        time.sleep(5.4)
        if with_ram and proc.poll() is None:
            gate = read_ram(cfg, phone, 0x4C7BC, 16)
            table = read_ram(cfg, phone, 0x4D318, 64)
            ram = slot_view(gate, table)
        try:
            proc.communicate(timeout=40)
        finally:
            if proc.poll() is None:
                proc.kill()
        fr.say(cfg, "key %s rc %s" % (key_name, proc.returncode))
        hf.wait(timeout=seconds + 15)
    finally:
        if hf.poll() is None:
            hf.kill()
        hlog.close()
        if hackrf_running():
            hackrf.kill()
    time.sleep(0.4)
    log_proc.terminate()
    try:
        log_proc.wait(timeout=3)
    except Exception:
        log_proc.kill()
    log_handle.close()
    phone.pull_app("/data/data/%s/cache/rxclip_%s.wav" % (phone.cfg.package, label), wav)
    text = log_path.read_text(encoding="utf-8", errors="replace")
    row = {
        "label": label, "key": key_name,
        "audio": listen.tone_line(wav) if wav.is_file() else {"rms": 0, "line_db": None},
        "ram": ram,
    }
    row.update(listen.targets(text))
    row["lc"] = listen.lc_of(iq)
    fr.say(cfg, "%s audio %s status %s ram %s" % (label, row["audio"], row["status"], ram))
    return row


def tone_present(row):
    db = (row.get("audio") or {}).get("line_db")
    return db is not None and db >= TONE_DB


def started(row):
    return 1 in (row.get("status") or [])


def confirmed_key(cfg, phone, web):
    """3 s on channel 49. The streamed log has to show transmit start."""
    try:
        web.call("/api/vfo/exit", {})
    except Exception:
        pass
    time.sleep(1.0)
    web.select(49)
    time.sleep(gaps.base.SETTLE_S)
    ch = web.call("/api/channel?number=49").get("channel") or {}
    if not ch.get("digital") or ch.get("power") != 0:
        raise SystemExit("channel 49 is not a low-power digital channel")
    gaps.base.heat_ok(cfg, phone)
    log_path = cfg.out / "factory_key.log"
    handle = open(log_path, "w", encoding="utf-8", errors="replace")
    proc = subprocess.Popen(
        [cfg.adb, "-s", cfg.serial, "logcat", "-v", "time", "-s", "RadioService:I"],
        stdout=handle, stderr=subprocess.STDOUT)
    web.call("/api/ptt", {"down": True})
    time.sleep(0.6)
    held = bool(web.call("/api/status").get("transmitting"))
    time.sleep(2.4)
    web.call("/api/ptt", {"down": False})
    time.sleep(0.8)
    proc.terminate()
    try:
        proc.wait(timeout=3)
    except Exception:
        proc.kill()
    handle.close()
    text = log_path.read_text(encoding="utf-8", errors="replace")
    statuses = gaps.status_bytes(text)
    tx = bool(web.call("/api/status").get("transmitting"))
    fr.say(cfg, "factory key statuses %s held %s transmitting %s" % (statuses, held, tx))
    if tx:
        web.call("/api/ptt", {"down": False})
        time.sleep(1.0)
        tx = bool(web.call("/api/status").get("transmitting"))
    if 3 not in statuses or not held or tx:
        raise SystemExit("factory key did not show status 3")
    return statuses


def main():
    if "--grant" not in sys.argv:
        raise SystemExit("refusing without --grant")
    cfg = Config()
    fr.BUSY.parent.mkdir(parents=True, exist_ok=True)
    fr.BUSY.write_text("fw60 rows\n", encoding="ascii")
    phone = None
    doc = {"image": F60D_TAG, "lna": int(LNA), "vga": int(VGA), "rows": [], "stopped": None}
    try:
        phone = Phone(cfg)
        if not phone.ok() or phone.cfg.serial != "192.168.1.125:5555":
            raise SystemExit("no phone")
        if hackrf_running():
            raise SystemExit("hackrf already running")
        if not F60D.is_file():
            raise SystemExit("missing F60D")
        gaps.base.heat_ok(cfg, phone)
        if phone.tag() != fr.FACTORY_TAG:
            fr.load_image(cfg, phone, fr.FACTORY, fr.FACTORY_TAG)
        phone.wake()
        phone.adb("shell", "am", "start", "-n", "com.macdmr.radio/.MainActivity")
        time.sleep(2)
        web = fr.open_web(phone)
        confirmed_key(cfg, phone, web)
        fr.load_image(cfg, phone, F60D, F60D_TAG)
        phone.wake()
        phone.adb("shell", "am", "start", "-n", "com.macdmr.radio/.MainActivity")
        time.sleep(2)
        web = fr.open_web(phone)
        if phone.tag() != F60D_TAG:
            raise SystemExit("tag")
        doc["tag"] = phone.tag()
        ver = web.call("/api/settings").get("version")
        doc["version"] = ver
        fr.say(cfg, "app %s tag %s" % (ver, doc["tag"]))
        web.select(49)
        time.sleep(gaps.base.SETTLE_S)
        rr.enter_vfo(cfg, web)
        web.monitor(False)
        time.sleep(0.5)
        if web.call("/api/status").get("monitor"):
            raise SystemExit("monitor stayed on")

        allcall = rx_capture(cfg, phone, "F60D_allcall", 16, "allcall", True)
        doc["rows"].append(allcall)
        if not tone_present(allcall):
            doc["stopped"] = "allcall tone absent"
            return
        tg9 = rx_capture(cfg, phone, "F60D_tg9", 16, "tg9", False)
        doc["rows"].append(tg9)
        if not tone_present(tg9) or not started(tg9):
            doc["stopped"] = "tg9 did not play"
            return
        tg99 = rx_capture(cfg, phone, "F60D_tg99", 16, "tg99", False)
        doc["rows"].append(tg99)
        if started(tg99) or tone_present(tg99):
            doc["stopped"] = "tg99 started or played"
            return
        doc["stopped"] = None
    finally:
        if phone is not None:
            try:
                web = fr.open_web(phone)
                if web.call("/api/status").get("transmitting"):
                    web.call("/api/ptt", {"down": False})
            except Exception as exc:
                fr.say(cfg, "unkey failed %s" % type(exc).__name__)
            doc["end_tag"] = phone.tag()
            try:
                doc["heat"] = gaps.base.heat_ok(cfg, phone)
            except SystemExit as exc:
                doc["heat"] = str(exc)
            doc["transmitting"] = False
            try:
                doc["transmitting"] = bool(fr.open_web(phone).call("/api/status").get("transmitting"))
            except Exception:
                pass
        (cfg.out / "fw_fw60_f60d.json").write_text(json.dumps(doc, indent=1, default=str), encoding="utf-8")
        fr.say(cfg, "f60d stopped=%s tag=%s" % (doc.get("stopped"), doc.get("end_tag")))
        if hackrf_running():
            hackrf.kill()
        try:
            if fr.BUSY.exists():
                fr.BUSY.unlink()
        except Exception:
            pass
        if doc.get("stopped"):
            raise SystemExit(doc["stopped"])


if __name__ == "__main__":
    main()
