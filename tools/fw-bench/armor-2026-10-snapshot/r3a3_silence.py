# One 3 s silence key of the already-built R3a3 image.
# Phone TX only on 467.625 MHz, low power. HackRF receive only.
# The codec path plays zeros (txwav), so a real TX-RAM square stays and the
# 1 kHz tone should not. Does not raise A. Does not call vfo_off.
# Does not overwrite the tone-key capture r3a3.iq.
# A steady |deviation| at or above 5 kHz is a stop. The key-up click is not.
import json, struct, sys, time
from pathlib import Path

import numpy as np

sys.path.insert(0, r"C:\Users\Joshua\AppData\Local\Temp\fw1718")
import camp
import r3_capture
import r3a3_run

IMAGE = camp.BUILD / "DMR003.R3a3.V022.bin"
TAG = "DMR003.R3a3.V022"
FACTORY = "DMR003.UV4T.V022"
KEY_S = 12.0
WAV_S = 3
CAP = camp.CAP
HERE = camp.HERE


def write_silence():
    n = 8000 * WAV_S
    data = b"\x00\x00" * n
    hdr = struct.pack(
        "<4sI4s4sIHHIIHH4sI",
        b"RIFF", 36 + len(data), b"WAVE", b"fmt ", 16, 1, 1, 8000, 16000, 2, 16, b"data", len(data))
    path = HERE / "wav" / "silence.wav"
    path.parent.mkdir(exist_ok=True)
    path.write_bytes(hdr + data)
    if len(hdr) != 44 or path.stat().st_size != 44 + 2 * n:
        raise SystemExit("silence wav header is not 44 bytes")
    return path


def probe():
    path = CAP / "r3a3_silence_probe.iq"
    proc, hlog, _ = r3a3_run.hackrf_recv(path, 2.0)
    try:
        proc.wait(timeout=20)
    finally:
        hlog.close()
    size = path.stat().st_size if path.exists() else 0
    camp.say("hackrf probe %d bytes" % size)
    return size > 1_000_000


def patient_version():
    """Wait through a post-key module restart. Dump logcat without -t."""
    for attempt in range(2):
        deadline = time.time() + 90
        while time.time() < deadline:
            _, text = camp.adb("shell", "logcat", "-d", "-s", "RadioService:I", timeout=40)
            hits = [ln for ln in text.splitlines() if "module DMR003." in ln]
            if hits:
                ver = hits[-1].split("module ")[-1].strip()
                camp.say("0x34 %s" % ver)
                return ver
            time.sleep(2)
        camp.say("no 0x34 yet; starting MainActivity again")
        camp.adb("shell", "input", "keyevent", "224")
        camp.adb("shell", "am", "start", "-n", "com.macdmr.radio/.MainActivity")
        time.sleep(4)
    raise RuntimeError("no 0x34 after the module restart")


def restore_factory():
    camp.say("restoring factory image")
    try:
        ver = camp.load_image(camp.FACTORY)
    except Exception as exc:
        camp.say("loader did not return a version (%s)" % exc)
        ver = ""
    if "UV4T" not in ver:
        ver = patient_version()
    camp.expect_version(ver, FACTORY)
    rc, out = camp.adb("shell", "ls", "/sdcard/DMR/DMRDEBUG.bin")
    camp.say("DMRDEBUG check rc=%s %s" % (rc, out.strip().replace("\n", " ")[:160]))
    if "DMRDEBUG.bin" in out and "No such" not in out:
        raise RuntimeError("DMRDEBUG.bin still present: " + out.strip())
    camp.tune()
    return ver


def steady_fft(path):
    dev, info = r3_capture.wide_demod(path)
    fs = r3_capture.FS
    i0, i1 = int(info["i0"]), int(info["i1"])
    a = i0 + int(1.0 * fs)
    b = i1 - int(0.3 * fs)
    out = {"carrier": {k: info[k] for k in info if k in (
        "keyed_s", "snr_db", "clip_frac", "offset_hz", "mean_mag", "i0", "i1")}}
    if b - a < int(0.5 * fs):
        out["steady"] = None
        out["STOP"] = False
        return out
    seg = dev[a:b] - np.median(dev[a:b])
    w = np.hanning(len(seg))
    amp = 2 * np.abs(np.fft.rfft(seg * w)) / np.sum(w)
    freqs = np.fft.rfftfreq(len(seg), 1 / fs)

    def near(f):
        i = int(np.argmin(np.abs(freqs - f)))
        return round(float(freqs[i]), 3), round(float(amp[i]), 2)

    lines = [15.625, 31.25, 46.875, 62.5, 78.125, 93.75, 250, 500, 1000, 2000, 3000]
    band = (freqs >= 5) & (freqs <= 40) & ~((freqs >= 14) & (freqs <= 18))
    p99 = float(np.percentile(np.abs(seg), 99))
    slices = []
    for k in range(0, int(3.4 * fs), int(0.1 * fs)):
        s0, s1 = i0 + k, i0 + k + int(0.1 * fs)
        if s1 > i1:
            break
        x = dev[s0:s1] - np.median(dev[s0:s1])
        slices.append({
            "t": round(k / fs, 2),
            "rms": round(float(np.sqrt(np.mean(x ** 2))), 1),
            "p99": round(float(np.percentile(np.abs(x), 99)), 1),
            "f15": round(r3_capture.goertzel(x, fs, 15.625), 1),
            "f1k": round(r3_capture.goertzel(x, fs, 1000.0), 1),
        })
    click = slices[0]["p99"] if slices else 0
    out["steady"] = {
        "steady_s": round(len(seg) / fs, 3),
        "rms_hz": round(float(np.sqrt(np.mean(seg ** 2))), 2),
        "p99_hz": round(p99, 2),
        "click_p99_hz": click,
        "noise_5_40_hz": round(float(np.median(amp[band])), 3),
        "lines": [{"f": f, "bin_hz": near(f)[0], "amp_hz": near(f)[1]} for f in lines],
        "slices_100ms": slices,
    }
    # The stop is the stimulus after the key-up click, not the click itself.
    out["STOP"] = p99 >= camp.STOP_HZ
    return out


def main():
    if not IMAGE.exists() or IMAGE.stat().st_size != 378620:
        raise SystemExit("R3a3 image missing or wrong size")
    if camp.hackrf_running():
        raise SystemExit("hackrf already running")
    r3a3_run.devices_ok()
    wav = write_silence()
    camp.install_wav(wav, "silence")
    if not probe():
        time.sleep(3)
        if camp.hackrf_running():
            raise SystemExit("hackrf still running after the probe; not loading")
        if not probe():
            raise SystemExit("hackrf is not transferring; not loading and not keying")
    camp.adb("shell", "input", "keyevent", "224")
    camp.tune()
    started = False
    stop = False
    try:
        started = True
        loaded = camp.load_image(IMAGE)
        camp.say("loaded %s" % loaded)
        if loaded != TAG:
            raise RuntimeError("version %s is not %s" % (loaded, TAG))
        camp.tune()
        iq = CAP / "r3a3_silence.iq"
        proc, hlog, _ = r3a3_run.hackrf_recv(iq, KEY_S)
        try:
            time.sleep(1.5)
            size = iq.stat().st_size if iq.exists() else 0
            camp.say("key capture growing %d bytes" % size)
            if size < 1_000_000:
                raise RuntimeError("hackrf stalled before the key; not transmitting")
            rc, bout = camp.broadcast(["--es", "cmd", "txwav", "--es", "name", "silence"])
            camp.say("txwav rc=%d %s" % (rc, bout.strip().replace("\n", " ")[:180]))
            proc.wait(timeout=KEY_S + 25)
        finally:
            if proc.poll() is None:
                proc.wait(timeout=KEY_S + 25)
            hlog.close()
        text = camp.adb("shell", "logcat", "-d", "-s", "RadioService:I", "DiagReceiver:I", timeout=40)[1]
        (HERE / "r3a3_silence.logcat.txt").write_text(text, encoding="utf-8")
        hits = [ln.strip() for ln in text.splitlines()
                if "bench wav" in ln or "txwav" in ln or "TX " in ln
                or "does not answer" in ln or "stopped answering" in ln or "module DMR" in ln]
        camp.say("tx log: " + " | ".join(h[-180:] for h in hits[-10:]))
        if any("does not answer" in h or "stopped answering" in h for h in hits):
            raise RuntimeError("module stopped answering during the key")
        if iq.stat().st_size < 1_000_000:
            raise RuntimeError("key capture too small: %d" % iq.stat().st_size)
        result = steady_fft(iq)
        (HERE / "r3a3_silence.json").write_text(json.dumps(result, indent=2), encoding="utf-8")
        st = result.get("steady") or {}
        camp.say("silence keyed %.2f s snr %.1f clip %.4f offset %+.0f steady_p99 %s click_p99 %s STOP %s" % (
            result["carrier"].get("keyed_s", 0), result["carrier"].get("snr_db", 0),
            result["carrier"].get("clip_frac", 0), result["carrier"].get("offset_hz", 0),
            st.get("p99_hz"), st.get("click_p99_hz"), result.get("STOP")))
        camp.say("lines " + json.dumps(st.get("lines")))
        camp.say("slices " + json.dumps(st.get("slices_100ms")))
        stop = bool(result.get("STOP"))
    finally:
        if camp.hackrf_running():
            # The capture is supposed to finish on -n. Killing here is only the
            # failure path, and the next open is the factory load, minutes later.
            camp.kill_hackrf()
        if started:
            restore_factory()
            camp.say("R3a3 silence finished, factory image, VFO 467.625")
    if stop:
        raise SystemExit(2)


if __name__ == "__main__":
    main()
