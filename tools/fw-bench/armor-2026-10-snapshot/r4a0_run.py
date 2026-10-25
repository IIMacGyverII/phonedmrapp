# R4a: RRC alpha=0.5 4FSK in TX RAM, peak count 5120. Tag R4a0.
# Phone TX only on 467.625 MHz, low power. HackRF receive only.
# One 3 s silence key. Does not call vfo_off. Does not raise the peak.
# Does not send an M17 frame. A steady |deviation| at or above 5 kHz
# restores the factory image and stops.
import json, sys, time

import numpy as np

sys.path.insert(0, r"C:\Users\Joshua\AppData\Local\Temp\fw1718")
import camp
import factory_boot
import r3_capture
import r3a3_run
import r3a3_silence

IMAGE = camp.BUILD / "DMR003.R4a0.V022.bin"
TAG = "DMR003.R4a0.V022"
BOOT_S = 180.0
KEY_S = 12.0
CAP = camp.CAP
HERE = camp.HERE
# One 10-sample period of the stored pattern. 6 symbols = 10 samples.
PERIOD = np.array([19, 12, 2, -2, -12, -20, 7, 20, -7, 1], dtype=np.float64)


def finish_capture(proc, hlog, seconds):
    try:
        proc.wait(timeout=seconds + 30)
    finally:
        if proc.poll() is None:
            proc.wait(timeout=seconds + 30)
        hlog.close()


def pattern_levels(path):
    """Match the steady deviation to the 10-sample RRC pattern.

    Four flat symbol levels are not what this buffer stores. The 5/3
    sampling misses the symbol centers, so the check is whether the
    aired deviation follows these ten counts.
    """
    dev, info = r3_capture.wide_demod(path)
    fs = r3_capture.FS
    i0, i1 = int(info["i0"]), int(info["i1"])
    a = i0 + int(1.0 * fs)
    b = i1 - int(0.3 * fs)
    if b - a < int(0.5 * fs):
        return {"error": "steady window too short"}
    # Half a second keeps the phone and HackRF clocks from walking a bin.
    seg = dev[a:a + int(0.5 * fs)]
    seg = seg - np.median(seg)
    # 8000 Hz stored samples, 48000 Hz demod: six demod samples per count.
    tmpl = np.repeat(PERIOD * 256.0, 6)
    per = len(tmpl)
    use = seg[: len(seg) // per * per]
    best = None
    for sign in (1.0, -1.0):
        ref = sign * tmpl
        ref = ref - ref.mean()
        # corr[k] peaks when use[k:k+per] matches ref. use[n] is ref[(n-k) % per].
        corr = np.correlate(use[: per * 8], ref, mode="valid")
        lag = int(np.argmax(corr)) % per
        phase = (np.arange(len(use)) - lag) % per
        aligned = ref[phase]
        denom = float(np.dot(aligned, aligned))
        gain = float(np.dot(use, aligned) / denom) if denom else 0.0
        pred = gain * aligned
        ss = float(np.dot(use - use.mean(), use - use.mean()))
        resid = float(np.dot(use - pred, use - pred))
        r2 = 1.0 - resid / ss if ss else 0.0
        row = (r2, sign, lag, gain, phase)
        if best is None or row[0] > best[0]:
            best = row
    r2, sign, lag, gain, phase = best
    bins = []
    for k, sample in enumerate(PERIOD):
        sel = (phase // 6) == k
        x = use[sel]
        bins.append({
            "sample": int(sample),
            "count": int(sample * 256),
            "n": int(sel.sum()),
            "median_hz": round(float(np.median(x)), 1),
        })
    med = np.array([b["median_hz"] for b in bins])
    counts = PERIOD * 256.0 * sign
    # Positive correlation of the ten medians with the stored counts.
    if np.std(med) and np.std(counts):
        shape = float(np.corrcoef(med, counts)[0, 1])
    else:
        shape = 0.0
    outer = [b for b in bins if abs(b["sample"]) >= 19]
    inner = [b for b in bins if abs(b["sample"]) <= 2]
    return {
        "window_s": round(len(use) / fs, 3),
        "polarity": int(sign),
        "lag_samples": int(lag),
        "r2": round(r2, 3),
        "shape_corr": round(shape, 3),
        "hz_per_count": round(abs(gain), 4),
        "outer_median_hz": [b["median_hz"] for b in outer],
        "inner_median_hz": [b["median_hz"] for b in inner],
        "bins": bins,
        "follows_pattern": bool(r2 >= 0.7 and shape >= 0.8),
    }


def main():
    if not IMAGE.exists() or IMAGE.stat().st_size != 378620:
        raise SystemExit("R4a0 image missing or wrong size")
    if camp.hackrf_running():
        raise SystemExit("hackrf already running")
    r3a3_run.devices_ok()
    wav = r3a3_silence.write_silence()
    camp.install_wav(wav, "silence")
    if not r3a3_silence.probe():
        time.sleep(3)
        if camp.hackrf_running() or not r3a3_silence.probe():
            raise SystemExit("hackrf is not transferring; not loading and not keying")
    camp.adb("shell", "input", "keyevent", "224")
    camp.tune()
    started = False
    stop = False
    try:
        boot_iq = CAP / "r4a0_boot.iq"
        proc, hlog, _ = r3a3_run.hackrf_recv(boot_iq, BOOT_S)
        try:
            time.sleep(1.5)
            size = boot_iq.stat().st_size if boot_iq.exists() else 0
            camp.say("boot capture growing %d bytes" % size)
            if size < 1_000_000:
                raise RuntimeError("hackrf stalled before the load; not loading")
            started = True
            loaded = camp.load_image(IMAGE)
            camp.say("loaded %s" % loaded)
            if loaded != TAG:
                raise RuntimeError("version %s is not %s" % (loaded, TAG))
        finally:
            finish_capture(proc, hlog, BOOT_S)
        info = factory_boot.analyze(1.5, boot_iq)
        (HERE / "r4a0_boot.json").write_text(json.dumps(info, indent=2), encoding="utf-8")
        camp.say("boot peak_db %.2f above_10db_s %.2f clip %.6f" % (
            info["peak_db"], info["above_10db_s"], info["clip_frac"]))
        if info["peak_db"] >= 6.0 or info["above_10db_s"] >= 0.2:
            raise RuntimeError("boot radiated; not keying")
        time.sleep(3)
        camp.tune()
        iq = CAP / "r4a0_silence.iq"
        proc, hlog, _ = r3a3_run.hackrf_recv(iq, KEY_S)
        try:
            time.sleep(1.5)
            size = iq.stat().st_size if iq.exists() else 0
            camp.say("key capture growing %d bytes" % size)
            if size < 1_000_000:
                raise RuntimeError("hackrf stalled before the key; not transmitting")
            rc, bout = camp.broadcast(["--es", "cmd", "txwav", "--es", "name", "silence"])
            camp.say("txwav rc=%d %s" % (rc, bout.strip().replace("\n", " ")[:180]))
            finish_capture(proc, hlog, KEY_S)
        except Exception:
            if proc.poll() is None:
                finish_capture(proc, hlog, KEY_S)
            raise
        text = camp.adb("shell", "logcat", "-d", "-s", "RadioService:I", "DiagReceiver:I", timeout=40)[1]
        (HERE / "r4a0_silence.logcat.txt").write_text(text, encoding="utf-8")
        hits = [ln.strip() for ln in text.splitlines()
                if "bench wav" in ln or "module DMR" in ln or "cmd=0x26" in ln or "cmd=0x36" in ln
                or "does not answer" in ln or "stopped answering" in ln]
        camp.say("tx log: " + " | ".join(h[-160:] for h in hits[-8:]))
        if any("does not answer" in h or "stopped answering" in h for h in hits):
            raise RuntimeError("module stopped answering during the key")
        result = r3a3_silence.steady_fft(iq)
        try:
            result["pattern"] = pattern_levels(iq)
        except Exception as exc:
            result["pattern"] = {"error": str(exc)}
        (HERE / "r4a0_silence.json").write_text(json.dumps(result, indent=2), encoding="utf-8")
        st = result.get("steady") or {}
        camp.say("silence keyed %.2f s snr %.1f clip %.4f offset %+.0f steady_p99 %s click_p99 %s STOP %s" % (
            result["carrier"].get("keyed_s", 0), result["carrier"].get("snr_db", 0),
            result["carrier"].get("clip_frac", 0), result["carrier"].get("offset_hz", 0),
            st.get("p99_hz"), st.get("click_p99_hz"), result.get("STOP")))
        camp.say("lines " + json.dumps(st.get("lines")))
        camp.say("pattern " + json.dumps(result.get("pattern")))
        stop = bool(result.get("STOP"))
    finally:
        if camp.hackrf_running():
            camp.kill_hackrf()
        if started:
            r3a3_silence.restore_factory()
            camp.say("R4a0 finished, factory image, VFO 467.625")
    if stop:
        raise SystemExit(2)


if __name__ == "__main__":
    main()
