# R4d: return from the key at once and refill from the service-task wake.
# Tag R4d0. Phone TX only on 467.625 MHz, low power. HackRF receive only.
# One 3 s silence key. Does not call vfo_off. Does not raise the peak.
# A steady or burst |deviation| at or above 5 kHz restores the factory image and stops.
# The click (first 100 ms) is not a stop.
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
import m17_stream_table
import r3_capture
import r3a3_run
import r3a3_silence

IMAGE = camp.BUILD / "DMR003.R4d0.V022.bin"
TAG = "DMR003.R4d0.V022"
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


def _attempt(seg, fs):
    seg = seg - np.median(seg)
    got = m17.decode_transmission(seg, fs, verbose=False)
    lsf = got["lsf"]
    fns = [int(f[0]) for f in got["frames"]]
    return {
        "lsf_crc": bool(lsf and lsf[2]),
        "lsf_match": bool(lsf and lsf[0] == m17_stream_table.BENCH_CALL
                          and lsf[1] == m17_stream_table.BENCH_CALL and lsf[2]),
        "fn": fns,
        "n_frames": len(fns),
    }


def stream_on_air(path):
    dev, info = r3_capture.wide_demod(path)
    fs = r3_capture.FS
    i0, i1 = int(info["i0"]), int(info["i1"])
    if i1 - i0 < int(0.4 * fs):
        return {"error": "keyed span too short", "keyed_samples": int(i1 - i0)}
    # The table is 0.304 s and starts at key-up. The steady window begins at 1.0 s.
    windows = {
        "keyed": (i0, i1),
        "after_click": (i0 + int(0.10 * fs), min(i1, i0 + int(1.2 * fs))),
    }
    best = None
    attempts = {}
    for name, (a, b) in windows.items():
        if b - a < int(0.2 * fs):
            continue
        row = _attempt(dev[a:b], fs)
        attempts[name] = row
        rank = (row["n_frames"], row["lsf_crc"])
        if best is None or rank > best[0]:
            best = (rank, name, row)
    # Burst after the click, while the table is still playing.
    c0 = i0 + int(0.15 * fs)
    c1 = min(i1, i0 + int(0.70 * fs))
    burst = dev[c0:c1] - np.median(dev[c0:c1])
    burst_p99 = float(np.percentile(np.abs(burst), 99)) if len(burst) else 0.0
    # A failed poll repeats the first 512 samples every 64 ms.
    lag = 512 * (fs // 8000)
    h0 = i0 + int(0.15 * fs)
    h1 = min(i1, h0 + int(1.0 * fs))
    h = dev[h0:h1] - np.median(dev[h0:h1])
    loop_r = None
    if len(h) > lag + 200:
        a, b = h[:-lag], h[lag:]
        na, nb = float(np.linalg.norm(a)), float(np.linalg.norm(b))
        loop_r = float(np.dot(a, b) / (na * nb)) if na and nb else 0.0
    pcm = m17_stream_table.counts().astype(np.float64)
    wave = -m17_stream_table.HZ_PER_COUNT * pcm
    tmpl = np.repeat(wave, fs // 8000)
    fit = None
    use = dev[i0:min(i1, i0 + int(1.2 * fs))]
    use = use - np.median(use)
    if len(use) > len(tmpl):
        best_fit = None
        for sign in (1.0, -1.0):
            ref = sign * tmpl
            ref = ref - ref.mean()
            corr = np.correlate(use, ref, mode="valid")
            lag_i = int(np.argmax(np.abs(corr)))
            aligned = np.zeros(len(use))
            aligned[lag_i:lag_i + len(ref)] = ref
            denom = float(np.dot(aligned, aligned))
            gain = float(np.dot(use, aligned) / denom) if denom else 0.0
            pred = gain * aligned
            ss = float(np.dot(use - use.mean(), use - use.mean()))
            resid = float(np.dot(use - pred, use - pred))
            r2 = 1.0 - resid / ss if ss else 0.0
            row = (r2, sign, lag_i, gain)
            if best_fit is None or row[0] > best_fit[0]:
                best_fit = row
        r2, sign, lag_i, gain = best_fit
        fit = {
            "r2": round(float(r2), 3),
            "polarity": int(sign),
            "lag_samples": int(lag_i),
            "shape_gain": round(float(gain), 3),
        }
    chosen = best[2] if best else {"lsf_crc": False, "lsf_match": False, "fn": [], "n_frames": 0}
    return {
        "window": None if best is None else best[1],
        "lsf_crc": chosen["lsf_crc"],
        "lsf_match": chosen["lsf_match"],
        "fn": chosen["fn"],
        "n_frames": chosen["n_frames"],
        "attempts": attempts,
        "burst_p99_hz": round(burst_p99, 1),
        "loop64_r": None if loop_r is None else round(loop_r, 3),
        "fit": fit,
        "burst_stop": bool(burst_p99 >= camp.STOP_HZ),
    }


def main():
    if not IMAGE.exists() or IMAGE.stat().st_size != 378620:
        raise SystemExit("R4d0 image missing or wrong size")
    raw = IMAGE.read_bytes()
    digest = hashlib.sha256(raw).hexdigest()
    md5 = hashlib.md5(raw).hexdigest()
    camp.say("image sha256 %s md5 %s" % (digest, md5))
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
        boot_iq = CAP / "r4d0_boot.iq"
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
            (HERE / "r4d0_load.logcat.txt").write_text(text, encoding="utf-8")
        finally:
            finish_capture(proc, hlog, BOOT_S)
        info = factory_boot.analyze(1.5, boot_iq)
        (HERE / "r4d0_boot.json").write_text(json.dumps(info, indent=2), encoding="utf-8")
        camp.say("boot peak_db %.2f above_10db_s %.2f clip %.6f" % (
            info["peak_db"], info["above_10db_s"], info["clip_frac"]))
        if info["peak_db"] >= 6.0 or info["above_10db_s"] >= 0.2:
            raise RuntimeError("boot radiated; not keying")
        time.sleep(3)
        camp.tune()
        iq = CAP / "r4d0_silence.iq"
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
        (HERE / "r4d0_silence.logcat.txt").write_text(text, encoding="utf-8")
        hits = [ln.strip() for ln in text.splitlines()
                if "bench wav" in ln or "module DMR" in ln or "cmd=0x26" in ln or "cmd=0x36" in ln
                or "does not answer" in ln or "stopped answering" in ln]
        camp.say("tx log: " + " | ".join(h[-160:] for h in hits[-8:]))
        if any("does not answer" in h or "stopped answering" in h for h in hits):
            raise RuntimeError("module stopped answering during the key")
        result = r3a3_silence.steady_fft(iq)
        try:
            result["stream"] = stream_on_air(iq)
        except Exception as exc:
            result["stream"] = {"error": str(exc)}
        result["sha256"] = digest
        result["md5"] = md5
        (HERE / "r4d0_silence.json").write_text(json.dumps(result, indent=2), encoding="utf-8")
        st = result.get("steady") or {}
        stream = result.get("stream") or {}
        camp.say("silence keyed %.2f s snr %.1f clip %.4f offset %+.0f steady_p99 %s click_p99 %s STOP %s" % (
            result["carrier"].get("keyed_s", 0), result["carrier"].get("snr_db", 0),
            result["carrier"].get("clip_frac", 0), result["carrier"].get("offset_hz", 0),
            st.get("p99_hz"), st.get("click_p99_hz"), result.get("STOP")))
        camp.say("stream " + json.dumps(stream))
        stop = bool(result.get("STOP")) or bool(stream.get("burst_stop"))
        if stream.get("burst_stop"):
            camp.say("STOP burst_p99 %s" % stream.get("burst_p99_hz"))
    finally:
        if camp.hackrf_running():
            camp.kill_hackrf()
        if started:
            r3a3_silence.restore_factory()
            camp.say("R4d0 finished, factory image, VFO 467.625")
    if stop:
        raise SystemExit(2)


if __name__ == "__main__":
    main()
