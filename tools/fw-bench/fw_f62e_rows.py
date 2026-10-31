# F62E counter rows. Factory image and one key before F62E, and again
# before FW57. The Armor is not keyed except that factory key.
# W6Plus keying is key.sh for 3000 ms. Stop if the UART goes quiet.
#
# python tools/fw-bench/fw_f62e_rows.py --self-check
# python tools/fw-bench/fw_f62e_rows.py --grant
import hashlib
import json
import subprocess
import sys
import time
from pathlib import Path

HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))
sys.path.insert(0, str(HERE / "runner"))
import fw_f62d_rows as prev  # noqa: E402
import fw_full_rows as fr  # noqa: E402
import fw_promisc_rows as prom  # noqa: E402
import fw_replay_rows as rr  # noqa: E402
import fw_w6_listen as listen  # noqa: E402
import fw58_gaps as gaps  # noqa: E402
import fw58_steps as base  # noqa: E402
from common import Config  # noqa: E402
from hackrf import running as hackrf_running  # noqa: E402
from phone import Phone  # noqa: E402

ROOT = HERE.parents[1]
F62E = ROOT / "radio_firmware" / "build" / "DMR003.F62E.V022.bin"
F62E_TAG = "DMR003.F62E.V022"
F62E_SHA = "d94c73e7087a6be45046afc981d28112312e6ed2a45ac25f61e0ab28ca78cac4"
CLIP_S = 14


def self_check():
    if not F62E.is_file():
        raise SystemExit("F62E missing")
    h = hashlib.sha256(F62E.read_bytes()).hexdigest()
    if h != F62E_SHA:
        raise SystemExit("F62E sha")
    if not prev.KEY_WIN.is_file():
        raise SystemExit("key.sh missing")
    print("self-check ok", h[:16])


def lease_open():
    now = time.localtime()
    return (now.tm_hour, now.tm_min) < (11, 20)


def uart_quiet(text):
    last_tx = last_rx = None
    for i, line in enumerate(text.splitlines()):
        if "TX cmd=0x32" in line:
            last_tx = i
        if "RX cmd=0x32" in line or "RX cmd=0x2B" in line or "RX cmd=0x36" in line:
            last_rx = i
    return last_tx is not None and (last_rx is None or last_tx > last_rx)


def w6_call(cfg, phone, label, key_name):
    if prev.phone_tx(phone):
        raise SystemExit("armor is transmitting")
    if hackrf_running():
        raise SystemExit("hackrf already running")
    base.heat_ok(cfg, phone)
    before = prev.read_counters(cfg, phone)
    phone.adb("shell", "logcat", "-c")
    log_path = cfg.out / (label + ".log")
    handle = open(log_path, "w", encoding="utf-8", errors="replace")
    log_proc = subprocess.Popen(
        [cfg.adb, "-s", cfg.serial, "logcat", "-v", "time", "-s", "RadioService:I", "DiagReceiver:I"],
        stdout=handle, stderr=subprocess.STDOUT)
    t0 = time.time()
    phone.rx_clip(label, CLIP_S * 1000)
    proc = subprocess.run(
        [listen.BASH, listen.KEY, listen.NAMES[key_name], "3000"],
        capture_output=True, text=True, timeout=40)
    lines = prev.redact(proc.stdout or proc.stderr or "").strip().splitlines()
    fr.say(cfg, "key %s rc %s %s" % (key_name, proc.returncode, (lines[-1] if lines else "")[-120:]))
    remain = CLIP_S - (time.time() - t0)
    if remain > 0:
        time.sleep(remain)
    log_proc.terminate()
    try:
        log_proc.wait(timeout=3)
    except Exception:
        log_proc.kill()
    handle.close()
    text = log_path.read_text(encoding="utf-8", errors="replace")
    quiet = uart_quiet(text)
    after = None
    if not quiet:
        after = prev.read_counters(cfg, phone)
    return {
        "label": label,
        "key": key_name,
        "rc": proc.returncode,
        "before": before,
        "after": after,
        "delta": prev.delta(before, after) if after else None,
        "status": prom.rx_status(text),
        "reports": prom.reports(text)[:16],
        "quiet": quiet,
    }


def main():
    if "--self-check" in sys.argv:
        self_check()
        return
    if "--grant" not in sys.argv:
        raise SystemExit("refusing without --grant")
    self_check()
    cfg = Config()
    if cfg.serial != "192.168.1.125:5555" or cfg.freq_hz != 467625000:
        raise SystemExit("bench target")
    fr.BUSY.parent.mkdir(parents=True, exist_ok=True)
    fr.BUSY.write_text("f62e rows\n", encoding="ascii")
    phone = None
    loaded = False
    doc = {"rows": []}
    try:
        phone = Phone(cfg)
        if not phone.ok():
            raise SystemExit("no phone")
        if hackrf_running():
            raise SystemExit("hackrf already running")
        if phone.tag() != fr.FW57_TAG:
            raise SystemExit("not on FW57")
        phone.wake()
        phone.adb("shell", "am", "start", "-n", "com.macdmr.radio/.MainActivity")
        time.sleep(2)
        loaded = True
        web = prev.load_after_factory(cfg, phone, F62E, F62E_TAG)
        if phone.tag() != F62E_TAG:
            raise SystemExit("tag is not F62E")
        if web.call("/api/status").get("transmitting"):
            web.call("/api/ptt", {"down": False})
            time.sleep(0.5)
        base.heat_ok(cfg, phone)
        prom.cmdbyte(cfg, phone, 0x2F, 2)
        doc["flag_off"] = prom.raw40(cfg, phone, [15, 0], "off")
        rr.enter_vfo(cfg, web)
        plan = (
            ("e_off_tg9", "tg9", None),
            ("e_off_tg99", "tg99", None),
            ("e_on_tg99", "tg99", 1),
            ("e_on_tg9", "tg9", None),
            ("e_off2_tg9", "tg9", 0),
        )
        for label, key_name, flag in plan:
            if not lease_open():
                doc["stopped"] = "lease clock"
                break
            if flag is not None:
                doc["flag_%s" % label] = prom.raw40(cfg, phone, [15, flag], label)
            try:
                row = w6_call(cfg, phone, label, key_name)
            except SystemExit:
                doc["stopped"] = "op 14 no reply"
                fr.say(cfg, "stop: op 14 no reply")
                break
            doc["rows"].append(row)
            fr.say(cfg, "%s delta %s status %s quiet %s" % (
                label, row["delta"], [s["body"] for s in row["status"]], row["quiet"]))
            if row["quiet"]:
                doc["stopped"] = "uart quiet during " + label
                fr.say(cfg, "stop: uart quiet")
                break
        got = prev.restore(cfg, phone)
        doc["end"] = {"tag": got, "transmitting": prev.phone_tx(phone), "heat": base.heat_ok(cfg, phone)}
    finally:
        if hackrf_running():
            import hackrf
            hackrf.kill()
        if phone is not None and loaded and doc.get("end") is None:
            try:
                got = prev.restore(cfg, phone)
                doc["end"] = {"tag": got, "transmitting": prev.phone_tx(phone), "cleanup": True}
            except BaseException as exc:
                fr.say(cfg, "cleanup failed %s" % type(exc).__name__)
        try:
            (cfg.out / "fw_f62e_rows.json").write_text(json.dumps(doc, indent=1), encoding="utf-8")
        except Exception:
            pass
        try:
            if fr.BUSY.exists():
                fr.BUSY.unlink()
        except Exception:
            pass
    end = doc.get("end") or {}
    if end.get("transmitting") or end.get("tag") not in (None, fr.FW57_TAG):
        raise SystemExit("end state")


if __name__ == "__main__":
    main()
