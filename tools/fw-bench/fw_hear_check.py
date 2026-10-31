# Is the Armor hearing 467.625, and how strong is the hotspot there.
# No image load. The hotspot configuration is only read.
#
# python tools/fw-bench/fw_hear_check.py --grant
import re
import subprocess
import sys
import time
from pathlib import Path

import numpy as np

HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))
sys.path.insert(0, str(HERE / "runner"))
import fm  # noqa: E402
import fw58_air  # noqa: E402
import fw58_gaps as gaps  # noqa: E402
import fw59_rows as rows  # noqa: E402
import hackrf  # noqa: E402
from common import Config  # noqa: E402
from hackrf import running as hackrf_running  # noqa: E402
from phone import Phone  # noqa: E402

HZ = 467625000
FW57 = "DMR003.FW57.V022"
FS = 2_000_000
RF_PY = r"""
import re
lines = open("/etc/mmdvmhost", errors="replace").read().splitlines()
want = ("rxfrequency", "txfrequency", "power", "rxoffset", "txoffset", "txlevel", "rxlevel", "rflevel", "duplex", "colorcode", "txinvert", "rxinvert")
sec = ""
for ln in lines:
    s = ln.strip()
    if s.startswith("[") and s.endswith("]"):
        sec = s
        continue
    if not s or s.startswith("#") or "=" not in s:
        continue
    k, v = s.split("=", 1)
    key = k.strip().lower()
    if key not in want:
        continue
    val = v.strip()
    if "freq" in key:
        try:
            val = "%.3f MHz" % (int(val) / 1e6)
        except ValueError:
            val = re.sub(r"\d{6,}", "#", val)
    else:
        val = re.sub(r"\d{6,}", "#", val)
    print("%s %s=%s" % (sec, k.strip(), val))
"""


def rssi_bytes(text):
    found = []
    for m in re.finditer(r"RX cmd=0x32 rw=\d+ sr=\d+ len=\d+ \[([0-9A-F ]*)\]", text):
        raw = bytes.fromhex(m.group(1))
        if raw:
            found.append(raw[0])
    return found


def rose(idle, hot):
    if not idle or not hot:
        return False
    idle_m = sorted(idle)[len(idle) // 2]
    hot_m = sorted(hot)[len(hot) // 2]
    return hot_m >= idle_m + 8 or max(hot) >= 40


def read_rf(cfg):
    local = cfg.out / "rf_read.py"
    local.write_text(RF_PY, encoding="ascii")
    r = subprocess.run(
        ["scp", "-i", str(gaps.base.SSH_KEY), "-o", "IdentitiesOnly=yes", str(local),
         "pi-star@192.168.1.194:/tmp/rf_read.py"],
        capture_output=True, timeout=40)
    if r.returncode != 0:
        return "scp failed"
    return rows.ssh("python3 /tmp/rf_read.py")


def start_tx(cfg, path, n, fs, vga):
    if hackrf_running():
        raise RuntimeError("hackrf already running")
    log = open(str(path) + ".log", "w", encoding="utf-8")
    proc = subprocess.Popen(
        [cfg.hackrf, "-t", str(path), "-f", str(cfg.freq_hz), "-s", str(fs), "-a", "0", "-x", str(vga), "-n", str(n)],
        stdout=log, stderr=subprocess.STDOUT)
    t0 = time.time()
    while time.time() - t0 < 3:
        if proc.poll() is not None:
            log.close()
            raise RuntimeError("hackrf tx exited early")
        if hackrf_running():
            return proc, log
        time.sleep(0.05)
    proc.kill()
    log.close()
    raise RuntimeError("hackrf tx did not start")


def finish_tx(proc, log, seconds):
    try:
        proc.wait(timeout=seconds + 20)
    except subprocess.TimeoutExpired:
        proc.kill()
        hackrf.kill()
        raise RuntimeError("hackrf tx stalled")
    finally:
        log.close()
    if hackrf_running():
        hackrf.kill()
        raise RuntimeError("hackrf tx still running")


def sample_carrier(cfg, phone, web, seconds, vga):
    if web.call("/api/status").get("transmitting"):
        raise SystemExit("phone is transmitting")
    hackrf.dummy(cfg, FS, vga)
    phone.adb("shell", "logcat", "-c")
    blob, n = hackrf.fm_iq(FS, seconds, 0.0, tone=None)
    path = cfg.cap("hear_carrier.cs8")
    path.write_bytes(blob)
    proc, log = start_tx(cfg, path, n, FS, vga)
    api = []
    try:
        time.sleep(1.0)
        t0 = time.time()
        while time.time() - t0 < seconds - 1.5:
            api.append(web.call("/api/status").get("rssi"))
            time.sleep(0.7)
    finally:
        finish_tx(proc, log, seconds)
    raw = rssi_bytes(phone.logcat(12))
    rows.say(cfg, "carrier vga %s raw %s api %s" % (vga, raw, api))
    return {"vga": vga, "raw": raw, "api": api}


def idle_raw(cfg, phone, web):
    phone.adb("shell", "logcat", "-c")
    time.sleep(2.5)
    raw = rssi_bytes(phone.logcat(8))
    api = web.call("/api/status").get("rssi")
    rows.say(cfg, "idle raw %s api %s" % (raw, api))
    return {"raw": raw, "api": api}


def tone(cfg, phone, web):
    if web.call("/api/status").get("transmitting"):
        raise SystemExit("phone is transmitting")
    phone.adb("shell", "logcat", "-c")
    name = "hear_tone"
    phone.rx_clip(name, 9000)
    time.sleep(0.4)
    hackrf.dummy(cfg, FS, 20)
    blob, n = hackrf.fm_iq(FS, 5.0, 2500.0, tone=1000.0)
    path = cfg.cap("hear_tone.cs8")
    path.write_bytes(blob)
    proc, log = start_tx(cfg, path, n, FS, 20)
    hearing = []
    try:
        time.sleep(1.0)
        t0 = time.time()
        while time.time() - t0 < 3.5:
            hearing.append(bool(web.call("/api/status").get("hearing")))
            time.sleep(0.6)
    finally:
        finish_tx(proc, log, 5.0)
    time.sleep(2.0)
    text = phone.logcat(20)
    raw = rssi_bytes(text)
    opened = "RECEIVE_START" in text or any(hearing)
    local = cfg.cap(name + ".wav")
    got = phone.pull_app("/data/data/%s/cache/rxclip_%s.wav" % (cfg.package, name), local)
    line = None
    dbfs = None
    if got and local.exists():
        blob = local.read_bytes()
        at = blob.find(b"data")
        pcm = np.frombuffer(blob[at + 8:], dtype="<i2").astype(np.float64) if at >= 0 else np.array([])
        if len(pcm) >= 8000:
            dbfs = round(float(20 * np.log10(np.sqrt(np.mean(pcm ** 2)) / 32768 + 1e-12)), 1)
            noise = float(np.sqrt(np.mean(pcm ** 2)) / 32768 + 1e-12)
            line = round(float(fm.goertzel(pcm, 8000, 1000.0) / 32768 / noise), 2)
    rows.say(cfg, "tone raw %s hearing %s opened %s dbfs %s line %s" % (raw, hearing, opened, dbfs, line))
    return {"raw": raw, "hearing": hearing, "opened": opened, "dbfs": dbfs, "line": line}


def on_channel_49(cfg, web):
    try:
        web.call("/api/vfo/exit", {})
    except Exception:
        pass
    time.sleep(2.0)
    web.select(49)
    time.sleep(gaps.base.SETTLE_S)
    ch = web.call("/api/channel?number=49").get("channel") or {}
    if int(ch.get("rxFreq") or 0) != HZ or ch.get("power") != 0 or not ch.get("digital"):
        raise SystemExit("channel 49 is not 467.625 low-power digital")
    rows.say(cfg, "channel 49 slot %s cc %s" % (ch.get("slot"), ch.get("cc")))


def hotspot_level(cfg, phone, web):
    on_channel_49(cfg, web)
    rows.arm(cfg, "tg9")
    if web.call("/api/status").get("transmitting"):
        raise SystemExit("phone is transmitting")
    phone.adb("shell", "logcat", "-c")
    cap = hackrf.Capture(cfg, "hear_hotspot", 8, 24, 24)
    time.sleep(0.4)
    fw58_air.queue()
    api = []
    t0 = time.time()
    while time.time() - t0 < 6:
        api.append(web.call("/api/status").get("rssi"))
        time.sleep(0.8)
    iq = cap.wait()
    raw = rssi_bytes(phone.logcat(12))
    dev, info = fm.demod(cfg, iq)
    del dev
    out = {
        "raw": raw,
        "api": api,
        "carrier_db": info.get("carrier_db"),
        "offset_hz": None if info.get("offset_hz") != info.get("offset_hz") else round(float(info.get("offset_hz")), 1),
        "keyed_s": round(float(info.get("keyed_s") or 0), 2),
        "no_carrier": bool(info.get("no_carrier")),
    }
    rows.say(cfg, "hotspot %s" % out)
    return out


def main():
    if "--grant" not in sys.argv:
        raise SystemExit("refusing without --grant")
    cfg = Config()
    gaps.base.BUSY.parent.mkdir(parents=True, exist_ok=True)
    gaps.base.BUSY.write_text("hear check\n", encoding="ascii")
    phone = None
    doc = {}
    try:
        phone = Phone(cfg)
        if not phone.ok() or phone.cfg.serial != "192.168.1.125:5555":
            raise SystemExit("no phone")
        if hackrf_running():
            raise SystemExit("hackrf already running")
        if phone.tag() != FW57:
            raise SystemExit("not on FW57; this run does not load an image")
        phone.wake()
        phone.adb("shell", "am", "start", "-n", "com.macdmr.radio/.MainActivity")
        time.sleep(2.0)
        web = rows.open_web(phone) if hasattr(rows, "open_web") else None
        if web is None:
            import fw_full_rows as fr
            web = fr.open_web(phone)
        if web.call("/api/status").get("transmitting"):
            web.call("/api/ptt", {"down": False})
            time.sleep(1.0)
        doc["rf"] = read_rf(cfg)
        rows.say(cfg, "rf " + doc["rf"].replace("\n", " | "))
        gaps.base.heat_ok(cfg, phone)
        on_channel_49(cfg, web)
        doc["ch49_idle"] = idle_raw(cfg, phone, web)
        doc["ch49_carrier"] = sample_carrier(cfg, phone, web, 5.0, 0)
        phone.tune(HZ, 0)
        time.sleep(1.0)
        doc["vfo_idle"] = idle_raw(cfg, phone, web)
        doc["vfo_carrier"] = sample_carrier(cfg, phone, web, 5.0, 0)
        doc["tone"] = tone(cfg, phone, web)
        ch49_ok = rose(doc["ch49_idle"]["raw"], doc["ch49_carrier"]["raw"])
        vfo_ok = rose(doc["vfo_idle"]["raw"], doc["vfo_carrier"]["raw"])
        tone_ok = bool(doc["tone"]["opened"]) or (doc["tone"]["line"] or 0) >= 0.3
        doc["receiver_ok"] = bool(ch49_ok or vfo_ok or tone_ok)
        rows.say(cfg, "receiver ch49 %s vfo %s tone %s" % (ch49_ok, vfo_ok, tone_ok))
        if doc["receiver_ok"]:
            doc["hotspot"] = hotspot_level(cfg, phone, web)
            off = doc["hotspot"].get("offset_hz")
            weak = bool(doc["hotspot"].get("no_carrier")) or (doc["hotspot"].get("carrier_db") or 0) < 20
            off_freq = off is None or abs(off) > 5000
            doc["hotspot_weak"] = weak
            doc["hotspot_off_freq"] = off_freq
            rows.say(cfg, "stop hotspot side %s" % (weak or off_freq))
        else:
            rows.say(cfg, "receiver failed; hotspot replay not run")
        on_channel_49(cfg, web)
        st = web.call("/api/status")
        doc["end_tag"] = phone.tag()
        doc["transmitting"] = bool(st.get("transmitting"))
        doc["vfo"] = bool(st.get("vfo"))
        doc["heat"] = gaps.base.heat_ok(cfg, phone)
        (cfg.out / "fw_hear_check.json").write_text(
            __import__("json").dumps(doc, indent=1, default=str), encoding="utf-8")
        rows.say(cfg, "end %s transmitting %s" % (doc["end_tag"], doc["transmitting"]))
        if doc["transmitting"] or doc["end_tag"] != FW57:
            raise SystemExit("end state")
    finally:
        if phone is not None:
            try:
                import fw_full_rows as fr
                web = fr.open_web(phone)
                if web.call("/api/status").get("transmitting"):
                    web.call("/api/ptt", {"down": False})
            except Exception as exc:
                rows.say(cfg, "unkey failed %s" % type(exc).__name__)
            if hackrf_running():
                hackrf.kill()
        try:
            if gaps.base.BUSY.exists():
                gaps.base.BUSY.unlink()
        except Exception as exc:
            rows.say(cfg, "busy clear failed %s" % type(exc).__name__)


if __name__ == "__main__":
    main()
