# F62D drop-counter bench. Factory image and one key before F62D, and again
# before FW57 at the end. No hotspot writes. The Armor is not keyed except
# the factory-image key on channel 49. W6Plus keying is key.sh only.
#
# Step 0 reads 0x4F200-0x4F3FF twice before any call. A change outside the
# nine counter bytes stops the rows. The W6Plus rows then read the nine
# bytes before and after each call.
#
# python tools/fw-bench/fw_f62d_rows.py --self-check
# python tools/fw-bench/fw_f62d_rows.py --grant
import hashlib
import json
import re
import subprocess
import sys
import time
from pathlib import Path

HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))
sys.path.insert(0, str(HERE / "runner"))
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
F62D = ROOT / "radio_firmware" / "build" / "DMR003.F62D.V022.bin"
F62D_TAG = "DMR003.F62D.V022"
F62D_SHA = "30cc5367c1c69117f141429edc6e5c0d81c59dfc31d28e6cfa1521b7b2167a93"
WIN = ((0x4F200, 240), (0x4F2F0, 240), (0x4F3E0, 32))
WIN_BASE = 0x4F200
COUNTER = 0x4F2C0
COUNTER_N = 9
KEY_WIN = Path(r"C:\Users\Joshua\AppData\Local\Temp\claude\D--Documents-code-personal-phonedmrapp\5950190b-2f56-47ee-ae7d-d56c8c611e78\scratchpad\v69\dmrkey\key.sh")
CLIP_S = 16


def redact(text):
    return re.sub(r"\d{6,}", "#", text)


def sha256(path):
    h = hashlib.sha256()
    with path.open("rb") as handle:
        for chunk in iter(lambda: handle.read(1 << 20), b""):
            h.update(chunk)
    return h.hexdigest()


def self_check():
    if not F62D.is_file():
        raise SystemExit("F62D missing")
    got = sha256(F62D)
    if got != F62D_SHA:
        raise SystemExit("F62D sha")
    body = base.op14(COUNTER, COUNTER_N)
    if body != bytes.fromhex("0ec0f204000900"):
        raise SystemExit("counter body")
    total = 0
    for addr, n in WIN:
        raw = base.op14(addr, n)
        if len(raw) != 7 or raw[0] != 14:
            raise SystemExit("window body")
        total += n
    if total != 0x200:
        raise SystemExit("window length")
    if not KEY_WIN.is_file():
        raise SystemExit("key.sh missing")
    if not fr.FACTORY.is_file() or not fr.FW57.is_file():
        raise SystemExit("restore image missing")
    print("self-check ok", F62D_TAG, got[:16])


def read_exact(cfg, phone, addr, n):
    last = b""
    want = "len=%d" % n
    for _ in range(2):
        blob, hits = base.read_ram(cfg, phone, addr, n)
        last = blob
        if len(blob) >= n and any(want in hit and "none" not in hit for hit in hits):
            return blob[:n]
        time.sleep(0.5)
    raise SystemExit("op 14 no reply %X got %d" % (addr, len(last)))


def read_window(cfg, phone):
    return b"".join(read_exact(cfg, phone, addr, n) for addr, n in WIN)


def counters_of(window):
    off = COUNTER - WIN_BASE
    return list(window[off:off + COUNTER_N])


def idle_diff(first, second):
    rows = []
    for i, (a, b) in enumerate(zip(first, second)):
        if a == b:
            continue
        addr = WIN_BASE + i
        rows.append({
            "addr": addr,
            "was": a,
            "now": b,
            "counter": COUNTER <= addr < COUNTER + COUNTER_N,
        })
    return rows


def read_counters(cfg, phone):
    blob = read_exact(cfg, phone, COUNTER, COUNTER_N)
    return list(blob)


def delta(before, after):
    return [((after[i] - before[i]) & 0xFF) for i in range(COUNTER_N)]


def lease_open():
    now = time.localtime()
    return (now.tm_hour, now.tm_min) < (10, 5)


def phone_tx(phone):
    try:
        return bool(fr.open_web(phone).call("/api/status").get("transmitting"))
    except Exception:
        return False


def w6_call(cfg, phone, label, key_name):
    if phone_tx(phone):
        raise SystemExit("armor is transmitting")
    if hackrf_running():
        raise SystemExit("hackrf already running")
    base.heat_ok(cfg, phone)
    before = read_counters(cfg, phone)
    phone.adb("shell", "logcat", "-c")
    log_path = cfg.out / (label + ".log")
    handle = open(log_path, "w", encoding="utf-8", errors="replace")
    log_proc = subprocess.Popen(
        [cfg.adb, "-s", cfg.serial, "logcat", "-v", "time", "-s", "RadioService:I", "DiagReceiver:I"],
        stdout=handle, stderr=subprocess.STDOUT)
    t0 = time.time()
    phone.rx_clip(label, CLIP_S * 1000)
    proc = subprocess.run(
        [listen.BASH, listen.KEY, listen.NAMES[key_name]],
        capture_output=True, text=True, timeout=40)
    lines = redact(proc.stdout or proc.stderr or "").strip().splitlines()
    tail = lines[-1] if lines else ""
    fr.say(cfg, "key %s rc %s %s" % (key_name, proc.returncode, tail[-160:]))
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
    wav = cfg.out / (label + ".wav")
    phone.pull_app("/data/data/%s/cache/rxclip_%s.wav" % (phone.cfg.package, label), wav)
    try:
        rms, peak = gaps.clip_levels(wav)
        rms = round(rms, 1)
    except Exception:
        rms, peak = None, None
    after = read_counters(cfg, phone)
    reports = []
    for row in gaps.frames_2b(text):
        reports.append({"len": row["len"], "type": row["type"], "target": row["target"]})
    return {
        "label": label,
        "key": key_name,
        "rc": proc.returncode,
        "before": before,
        "after": after,
        "delta": delta(before, after),
        "status": prom.rx_status(text),
        "reports": reports[:16],
        "rms": rms,
        "peak": peak,
    }


def factory_key_retry(cfg, phone, web):
    """One repeat. The first log sometimes keeps status 4 and drops status 3."""
    try:
        return fr.factory_key(cfg, phone, web)
    except SystemExit:
        fr.say(cfg, "factory key retry")
        time.sleep(1.0)
        if phone_tx(phone):
            web.call("/api/ptt", {"down": False})
            time.sleep(0.6)
        return fr.factory_key(cfg, phone, web)


def load_after_factory(cfg, phone, image, tag):
    fr.load_image(cfg, phone, fr.FACTORY, fr.FACTORY_TAG)
    phone.wake()
    phone.adb("shell", "am", "start", "-n", "com.macdmr.radio/.MainActivity")
    time.sleep(2)
    web = fr.open_web(phone)
    factory_key_retry(cfg, phone, web)
    fr.load_image(cfg, phone, image, tag)
    phone.wake()
    phone.adb("shell", "am", "start", "-n", "com.macdmr.radio/.MainActivity")
    time.sleep(2)
    return fr.open_web(phone)


def restore(cfg, phone):
    if phone.tag() == fr.FW57_TAG:
        fr.say(cfg, "already FW57")
        return fr.FW57_TAG
    load_after_factory(cfg, phone, fr.FW57, fr.FW57_TAG)
    got = phone.tag()
    fr.say(cfg, "restored %s" % (got or "no tag"))
    return got


def main():
    if "--self-check" in sys.argv:
        self_check()
        return
    if "--grant" not in sys.argv:
        raise SystemExit("refusing without --grant")
    self_check()
    cfg = Config()
    if cfg.serial != "192.168.1.125:5555":
        raise SystemExit("serial")
    if cfg.freq_hz != 467625000:
        raise SystemExit("frequency")
    fr.BUSY.parent.mkdir(parents=True, exist_ok=True)
    fr.BUSY.write_text("f62d rows\n", encoding="ascii")
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
        web = load_after_factory(cfg, phone, F62D, F62D_TAG)
        if phone.tag() != F62D_TAG:
            raise SystemExit("tag is not F62D")
        if web.call("/api/status").get("transmitting"):
            web.call("/api/ptt", {"down": False})
            time.sleep(0.5)
        base.heat_ok(cfg, phone)
        first = read_window(cfg, phone)
        time.sleep(4.0)
        second = read_window(cfg, phone)
        changed = idle_diff(first, second)
        others = [row for row in changed if not row["counter"]]
        doc["idle"] = {
            "counters": counters_of(second),
            "changed": len(changed),
            "outside": len(others),
            "outside_addrs": [row["addr"] for row in others[:12]],
        }
        fr.say(cfg, "idle changed %d outside %d counters %s" % (
            len(changed), len(others), doc["idle"]["counters"]))
        if others:
            doc["stopped"] = "idle ram outside the counters changed"
        elif not lease_open():
            doc["stopped"] = "lease clock before the rows"
        else:
            prom.cmdbyte(cfg, phone, 0x2F, 2)
            doc["flag_off"] = prom.raw40(cfg, phone, [15, 0], "off")
            rr.enter_vfo(cfg, web)
            third = read_window(cfg, phone)
            moved = [row for row in idle_diff(second, third) if not row["counter"]]
            doc["after_vfo_outside"] = len(moved)
            if moved:
                doc["stopped"] = "vfo write changed ram outside the counters"
                doc["after_vfo_addrs"] = [row["addr"] for row in moved[:12]]
            else:
                plan = (
                    ("f62d_off_tg9", "tg9", None),
                    ("f62d_off_tg99", "tg99", None),
                    ("f62d_on_tg99", "tg99", 1),
                    ("f62d_on_tg9", "tg9", None),
                )
                for label, key_name, flag in plan:
                    if not lease_open():
                        doc["stopped"] = "lease clock"
                        break
                    if flag is not None:
                        doc["flag_on"] = prom.raw40(cfg, phone, [15, flag], "on")
                    row = w6_call(cfg, phone, label, key_name)
                    doc["rows"].append(row)
                    fr.say(cfg, "%s delta %s status %s" % (
                        label, row["delta"], [s["body"] for s in row["status"]]))
                doc["flag_off_end"] = prom.raw40(cfg, phone, [15, 0], "off2")
        got = restore(cfg, phone)
        tx = phone_tx(phone)
        doc["end"] = {"tag": got, "transmitting": tx, "heat": base.heat_ok(cfg, phone)}
    finally:
        if hackrf_running():
            import hackrf
            hackrf.kill()
        if phone is not None and loaded and doc.get("end") is None:
            try:
                got = restore(cfg, phone)
                doc["end"] = {"tag": got, "transmitting": phone_tx(phone), "cleanup": True}
            except BaseException as exc:
                fr.say(cfg, "cleanup failed %s" % type(exc).__name__)
        try:
            (cfg.out / "fw_f62d_rows.json").write_text(json.dumps(doc, indent=1), encoding="utf-8")
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
