# R4b: one M17 link-setup frame in the TX-RAM loop. Tag R4b0.
# Phone TX only on 467.625 MHz, low power. HackRF receive only.
# One 3 s silence key. Does not call vfo_off. Does not raise the peak.
# A steady |deviation| at or above 5 kHz restores the factory image and stops.
import hashlib
import json
import sys
import time

import numpy as np

sys.path.insert(0, r"C:\Users\Joshua\AppData\Local\Temp\fw1718")
sys.path.insert(0, r"D:\Documents\code\personal\phonedmrapp\tools\fw-patch")
sys.path.insert(0, r"D:\Documents\code\personal\phonedmrapp\tools\m17-research")
import camp
import factory_boot
import m17
import m17_lsf_table
import r3_capture
import r3a3_run
import r3a3_silence

IMAGE = camp.BUILD / "DMR003.R4b0.V022.bin"
TAG = "DMR003.R4b0.V022"
BOOT_S = 240.0
KEY_S = 12.0
CAP = camp.CAP
HERE = camp.HERE


def finish_capture(proc, hlog, seconds):
    try:
        proc.wait(timeout=seconds + 30)
    finally:
        if proc.poll() is None:
            proc.wait(timeout=seconds + 30)
        hlog.close()


def lsf_on_air(path):
    dev, info = r3_capture.wide_demod(path)
    fs = r3_capture.FS
    i0, i1 = int(info["i0"]), int(info["i1"])
    a = i0 + int(0.35 * fs)
    b = i1 - int(0.25 * fs)
    if b - a < int(0.5 * fs):
        return {"error": "steady window too short"}
    seg = dev[a:b] - np.median(dev[a:b])
    pcm = m17_lsf_table.counts().astype(np.float64)
    y = np.zeros(512, np.float64)
    wave = m17_lsf_table.waveform_hz()
    y[:len(wave)] = wave
    # 8000 Hz table, 48000 Hz demod.
    tmpl = np.repeat(y, 6)
    counts = np.repeat(pcm, 6)
    per = len(tmpl)
    use = seg[: len(seg) // per * per]
    best = None
    for sign in (1.0, -1.0):
        ref = sign * tmpl
        ref = ref - ref.mean()
        corr = np.correlate(use[: per * 4], ref, mode="valid")
        lag = int(np.argmax(corr)) % per
        phase = (np.arange(len(use)) - lag) % per
        aligned = ref[phase]
        denom = float(np.dot(aligned, aligned))
        gain = float(np.dot(use, aligned) / denom) if denom else 0.0
        pred = gain * aligned
        ss = float(np.dot(use - use.mean(), use - use.mean()))
        resid = float(np.dot(use - pred, use - pred))
        r2 = 1.0 - resid / ss if ss else 0.0
        row = (r2, sign, lag, gain)
        if best is None or row[0] > best[0]:
            best = row
    r2, sign, lag, gain = best
    # Hz per stored count, same alignment, sign that matched the aimed waveform.
    cref = (sign * counts)
    cref = cref - cref.mean()
    cphase = (np.arange(len(use)) - lag) % per
    caligned = cref[cphase]
    cden = float(np.dot(caligned, caligned))
    cgain = float(np.dot(use, caligned) / cden) if cden else 0.0
    got = m17.decode_transmission(seg, fs, verbose=False)
    lsf = got["lsf"]
    ydem, sps = m17.demod(seg, fs)
    hits = 0
    best_sc = -1.0
    step = max(1, sps // 2)
    limit = len(ydem) - 8 * sps
    for i in range(0, limit, step):
        sc = m17.sync_score(ydem, sps, "lsf", i)
        if sc > best_sc:
            best_sc = sc
        if sc >= 0.85:
            hits += 1
    return {
        "window_s": round(len(use) / fs, 3),
        "polarity": int(sign),
        "lag_samples": int(lag),
        "r2": round(r2, 3),
        "shape_gain": round(gain, 3),
        "hz_per_count": round(cgain, 4),
        "follows_pattern": bool(r2 >= 0.7),
        "lsf_crc": bool(lsf and lsf[2]),
        "lsf_match": bool(lsf and lsf[0] == m17_lsf_table.BENCH_CALL and lsf[1] == m17_lsf_table.BENCH_CALL and lsf[2]),
        "sync_best": round(float(best_sc), 3),
        "sync_hits_0_85": int(hits),
        "stream_frames": len(got["frames"]),
    }


def main():
    if not IMAGE.exists() or IMAGE.stat().st_size != 378620:
        raise SystemExit("R4b0 image missing or wrong size")
    digest = hashlib.sha256(IMAGE.read_bytes()).hexdigest()
    camp.say("image sha256 %s" % digest)
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
        boot_iq = CAP / "r4b0_boot.iq"
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
            text = camp.adb("shell", "logcat", "-d", "-s", "RadioService:I", "YModemManager:I", timeout=40)[1]
            (HERE / "r4b0_load.logcat.txt").write_text(text, encoding="utf-8")
        finally:
            finish_capture(proc, hlog, BOOT_S)
        info = factory_boot.analyze(1.5, boot_iq)
        (HERE / "r4b0_boot.json").write_text(json.dumps(info, indent=2), encoding="utf-8")
        camp.say("boot peak_db %.2f above_10db_s %.2f clip %.6f" % (
            info["peak_db"], info["above_10db_s"], info["clip_frac"]))
        if info["peak_db"] >= 6.0 or info["above_10db_s"] >= 0.2:
            raise RuntimeError("boot radiated; not keying")
        time.sleep(3)
        camp.tune()
        iq = CAP / "r4b0_silence.iq"
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
        (HERE / "r4b0_silence.logcat.txt").write_text(text, encoding="utf-8")
        hits = [ln.strip() for ln in text.splitlines()
                if "bench wav" in ln or "module DMR" in ln or "cmd=0x26" in ln or "cmd=0x36" in ln
                or "does not answer" in ln or "stopped answering" in ln]
        camp.say("tx log: " + " | ".join(h[-160:] for h in hits[-8:]))
        if any("does not answer" in h or "stopped answering" in h for h in hits):
            raise RuntimeError("module stopped answering during the key")
        result = r3a3_silence.steady_fft(iq)
        try:
            result["lsf"] = lsf_on_air(iq)
        except Exception as exc:
            result["lsf"] = {"error": str(exc)}
        result["sha256"] = digest
        (HERE / "r4b0_silence.json").write_text(json.dumps(result, indent=2), encoding="utf-8")
        st = result.get("steady") or {}
        camp.say("silence keyed %.2f s snr %.1f clip %.4f offset %+.0f steady_p99 %s click_p99 %s STOP %s" % (
            result["carrier"].get("keyed_s", 0), result["carrier"].get("snr_db", 0),
            result["carrier"].get("clip_frac", 0), result["carrier"].get("offset_hz", 0),
            st.get("p99_hz"), st.get("click_p99_hz"), result.get("STOP")))
        camp.say("lsf " + json.dumps(result.get("lsf")))
        stop = bool(result.get("STOP"))
    finally:
        if camp.hackrf_running():
            camp.kill_hackrf()
        if started:
            r3a3_silence.restore_factory()
            camp.say("R4b0 finished, factory image, VFO 467.625")
    if stop:
        raise SystemExit(2)


if __name__ == "__main__":
    main()
