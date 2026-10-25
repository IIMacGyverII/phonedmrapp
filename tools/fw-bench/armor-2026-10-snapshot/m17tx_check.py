"""One short M17 voice tone on FW19. Low power. HackRF receive only.

The sender keys after eight symbol chunks, then paces. Capture is 8 s at
LNA 16 / VGA 16. No extra carrier pad: the product path ends on op 7.
Does not call vfo_off. Does not restore the factory image.
"""
import re
import sys
import time
from pathlib import Path

import numpy as np

sys.path.insert(0, r"C:\Users\Joshua\AppData\Local\Temp\fw1718")
sys.path.insert(0, r"D:\Documents\code\personal\phonedmrapp\tools\m17-research")
import camp
import fw19_run
import m17
import r3a3_run

APK = r"D:\Documents\code\personal\SignalDeck\app\build\outputs\apk\release\app-release.apk"
HERE = Path(r"C:\Users\Joshua\AppData\Local\Temp\fw1718")


def zones():
    rc, out = camp.adb("shell", "su", "-c", "sh /data/local/tmp/fw19_zones.sh", timeout=15)
    got = {}
    for ln in out.splitlines():
        p = ln.split()
        if len(p) == 3 and p[1] in ("mtktsAP", "mtktsbtsmdpa", "mtktsbattery"):
            try:
                got[p[1]] = int(p[2])
            except ValueError:
                pass
    return got


def cache_put(local, name):
    remote = "/data/local/tmp/" + name
    rc, out = camp.adb("push", str(local), remote, timeout=60)
    if rc != 0:
        raise RuntimeError("push " + out)
    cmd = (
        "cp %s /data/data/com.macdmr.radio/cache/%s && "
        "chown %s:%s /data/data/com.macdmr.radio/cache/%s && "
        "chmod 600 /data/data/com.macdmr.radio/cache/%s"
    ) % (remote, name, camp.UID, camp.UID, name, name)
    rc, out = camp.adb("shell", "su --mount-master --context u:r:magisk:s0 -c '%s'" % cmd, timeout=30)
    if rc != 0:
        raise RuntimeError("cache " + out)


def cache_get(name, local):
    cmd = (
        "cp /data/data/com.macdmr.radio/cache/%s /data/local/tmp/%s && "
        "chmod 644 /data/local/tmp/%s"
    ) % (name, name, name)
    rc, out = camp.adb("shell", "su --mount-master --context u:r:magisk:s0 -c '%s'" % cmd, timeout=30)
    if rc != 0:
        raise RuntimeError("cache get " + out)
    rc, out = camp.adb("pull", "/data/local/tmp/" + name, str(local), timeout=30)
    if rc != 0 or not Path(local).exists():
        raise RuntimeError("pull " + out)


def body_peak(iq_path, info):
    iq = np.fromfile(iq_path, dtype=np.int8)
    n = len(iq) // 2
    i0 = int(info["i0"]) * camp.DEC
    i1 = i0 + int(info["keyed_s"] * camp.FS_IQ)
    skip0 = int(0.08 * camp.FS_IQ)
    skip1 = int(0.40 * camp.FS_IQ)
    a = max(0, min(n, i0 + skip0))
    b = max(a + 1, min(n, i1 - skip1))
    sl = iq[2 * a:2 * b]
    if len(sl) < 100:
        return 0, 0.0
    peak = int(np.max(np.abs(sl)))
    clip = float(np.mean(np.abs(sl) >= 126))
    return peak, clip


def tone_of(wav_path):
    raw = Path(wav_path).read_bytes()
    pcm = np.frombuffer(raw[44:], dtype="<i2").astype(np.float64)
    if len(pcm) < 1600:
        return {"n": len(pcm), "rms": 0.0, "peak_hz": 0.0, "ratio": 0.0}
    body = pcm[320:-160] if len(pcm) > 800 else pcm
    rms = float(np.sqrt(np.mean(body ** 2)))
    w = body * np.hanning(len(body))
    spec = np.abs(np.fft.rfft(w))
    freqs = np.fft.rfftfreq(len(body), 1.0 / 8000.0)
    band = (freqs >= 200) & (freqs <= 3000)
    k = int(np.argmax(spec[band]))
    peak_hz = float(freqs[band][k])
    ratio = float(spec[band][k] / (np.median(spec[band]) + 1e-9))
    return {"n": int(len(pcm)), "rms": rms, "peak_hz": peak_hz, "ratio": ratio}


def main():
    r3a3_run.devices_ok()
    if camp.hackrf_running():
        raise SystemExit("hackrf already running")
    camp.broadcast(["--es", "cmd", "cmdbyte", "--ei", "b", "38", "--ei", "d", "2"])
    time.sleep(0.4)
    rc, out = camp.adb("install", "-r", APK, timeout=180)
    camp.say("install rc=%s %s" % (rc, out.strip().replace("\n", " ")[-180:]))
    if rc != 0:
        raise SystemExit("install failed")
    time.sleep(2)
    camp.adb("shell", "input", "keyevent", "224")
    camp.adb("shell", "am", "start", "-n", "com.macdmr.radio/.MainActivity")
    time.sleep(4)
    camp.adb("shell", "logcat", "-c")
    camp.broadcast(["--es", "cmd", "cmdbyte", "--ei", "b", "52", "--ei", "d", "1"])
    time.sleep(1.2)
    ver = camp.read_version(False)
    camp.expect_version(ver, "DMR003.FW19.V022")
    camp.tune()
    z0 = zones()
    ap0 = z0.get("mtktsAP", 0) / 1000.0
    bat0 = z0.get("mtktsbattery", 0) / 1000.0
    camp.say("before AP %.1f C battery %.1f C" % (ap0, bat0))
    if bat0 > 45 or ap0 > 60:
        raise SystemExit("too hot to key")
    camp.adb("shell", "logcat", "-c")
    proc, hlog, iq = fw19_run.capture("m17tx", 8, 16, 16)
    time.sleep(0.6)
    camp.broadcast(["--es", "cmd", "m17", "--ei", "tx", "1500"])
    camp.say("m17tx sent")
    proc.wait(timeout=20)
    hlog.close()
    text = camp.logcat_since(40)
    (HERE / "m17tx.log").write_text(text, encoding="utf-8", errors="replace")
    interesting = [
        ln.strip() for ln in text.splitlines()
        if any(s in ln for s in ("m17 voice", "m17 pay", "sym unkey", "cmd=0x26", "cmd=0x36"))
    ]
    camp.say("log lines %d" % len(interesting))
    for ln in interesting:
        if "m17 pay" in ln:
            continue
        camp.say("  " + ln[-160:])
    pays = {}
    for ln in text.splitlines():
        m = re.search(r"m17 pay (\d+) ([0-9A-F]+)", ln)
        if m:
            pays[int(m.group(1))] = bytes.fromhex(m.group(2))
    camp.say("logged payloads %d" % len(pays))
    dev, info = camp.demod(str(iq))
    camp.say("carrier %.2f snr %.1f clip %.6f offset %+.0f" % (
        info["keyed_s"], info["snr_db"], info["clip_frac"], info["offset_hz"]))
    peak, body_clip = body_peak(iq, info)
    camp.say("body peak %d body clip %.6f" % (peak, body_clip))
    rows = fw19_run.slices(dev, int(info["i0"]), info["keyed_s"])
    steady = [val for ms, val in rows if ms >= 80 and ms <= info["keyed_s"] * 1000 - 400]
    body_p99 = max(steady) if steady else float("nan")
    camp.say("body p99 %.0f Hz" % body_p99)
    if body_p99 >= camp.STOP_HZ or peak >= 120:
        camp.broadcast(["--es", "cmd", "cmdbyte", "--ei", "b", "38", "--ei", "d", "2"])
        camp.tune()
        raise SystemExit("STOP deviation or clip")
    i0 = int(info["i0"])
    fs = camp.FS_A
    res = m17.decode_transmission(dev[i0:i0 + int(info["keyed_s"] * fs)], fs, verbose=False)
    lsf = res.get("lsf")
    frames = res.get("frames") or []
    good = [(fn, pay, err) for fn, pay, err in frames if err == 0]
    camp.say("lsf %s frames %d lich0 %d" % (lsf, len(frames), len(good)))
    matched = 0
    compared = 0
    for fn, pay, err in good:
        want = pays.get(int(fn))
        if want is None:
            continue
        compared += 1
        if bytes(pay) == want:
            matched += 1
    camp.say("payload match %d/%d" % (matched, compared))
    ordered = []
    for fn, pay, err in frames:
        if err == 0 and pays.get(int(fn)) == bytes(pay):
            ordered.append(bytes(pay))
    if ordered:
        raw = b"".join(ordered)
        c2 = HERE / "m17air.c2"
        c2.write_bytes(raw)
        cache_put(c2, "m17air.c2")
        camp.adb("shell", "logcat", "-c")
        camp.broadcast(["--es", "cmd", "m17", "--es", "dec", "m17air"])
        time.sleep(1.5)
        dec_log = camp.logcat_since(15)
        camp.say("dec " + " | ".join(ln.strip()[-80:] for ln in dec_log.splitlines() if "m17 dec" in ln)[-200:])
        wav = HERE / "m17air.wav"
        cache_get("m17air.wav", wav)
        tone = tone_of(wav)
        camp.say("codec2 rms %.0f peak %.0f Hz ratio %.1f samples %d" % (
            tone["rms"], tone["peak_hz"], tone["ratio"], tone["n"]))
    z1 = zones()
    camp.say("after AP %.1f C" % (z1.get("mtktsAP", 0) / 1000.0))
    camp.broadcast(["--es", "cmd", "cmdbyte", "--ei", "b", "38", "--ei", "d", "2"])
    camp.tune()


if __name__ == "__main__":
    main()
