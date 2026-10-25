# R4k: same as R4j, and drop_ptt posts status byte 4.
# Tag R4k0. Phone TX only on 467.625 MHz, low power. HackRF receive only.
# One 3 s silence key. Does not call vfo_off. Does not raise the peak.
# The factory image is restored only for a bad tag, an unknown image,
# boot radiation, or a steady/burst deviation at or above 5 kHz.
# The key-up click is not a stop. A stuck carrier is not a stop: this run
# waits out the 30 s firmware cap and does not key again.
# A decode miss leaves the test image loaded and exits 0.
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
import m17_stream_table
import m17
import r3_capture
import r3a3_run
import r3a3_silence

IMAGE = camp.BUILD / "DMR003.R4k0.V022.bin"
TAG = "DMR003.R4k0.V022"
EXPECT_SHA = "c71ee7d89973048408e58112b1abe72d89ec18b0b0f86ec72356b6b445c02745"
BOOT_S = 240.0
KEY_S = 12.0
CAP = camp.CAP
HERE = camp.HERE
FRAME_OK = {0, 1, 2, 3, 4, 5}
# Samples 500..2419 repeat. 1920 samples at 8 kHz is 240 ms.
LOOP_SAMPLES = 1920


def finish_capture(proc, hlog, seconds):
    try:
        proc.wait(timeout=seconds + 30)
    finally:
        if proc.poll() is None:
            proc.wait(timeout=seconds + 30)
        hlog.close()


def wait_cap(tx_t0):
    """Let the 30 s firmware cap drop a carrier that outlived the capture."""
    if tx_t0 is None:
        return
    remain = 36.0 - (time.time() - tx_t0)
    if remain > 0:
        camp.say("PTT may still be up; waiting %.0f s for the 30 s cap" % remain)
        time.sleep(remain)


def looped_pcm(n_samples):
    """Prefill samples 0..511, then wrap from sample 2420 back to 500."""
    pcm = m17_stream_table.counts_lich5()
    idx = list(range(min(512, n_samples)))
    cursor = 512
    while len(idx) < n_samples:
        if cursor >= 2420:
            cursor = 500
        idx.append(cursor)
        cursor += 1
    return pcm[idx]


def _attempt(seg, fs):
    seg = seg - np.median(seg)
    y, sps = m17.demod(seg, fs)
    found = m17.find_frames(y, sps)
    got = m17.decode_transmission(seg, fs, verbose=False)
    lsf = got["lsf"]
    fns = [int(f[0]) for f in got["frames"]]
    lerr = [int(f[2]) for f in got["frames"]]
    pay = bytes(range(16))
    payloads_seq = bool(got["frames"]) and all(bytes(f[1]) == pay for f in got["frames"])
    return {
        "lsf_crc": bool(lsf and lsf[2]),
        "lsf_match": bool(lsf and lsf[0] == m17_stream_table.BENCH_CALL
                          and lsf[1] == m17_stream_table.BENCH_CALL and lsf[2]),
        "fn": fns,
        "lerr": lerr,
        "n_frames": len(fns),
        "fn_ok": bool(fns) and set(fns) <= FRAME_OK and 0x8005 not in fns,
        "has_eot": 0x8005 in fns,
        "eot_count": fns.count(0x8005),
        "last_fn": fns[-1] if fns else None,
        "has_fn5": 5 in fns,
        "payloads_seq": payloads_seq,
        "syncs": [
            {"kind": kind, "score": round(float(score), 3)}
            for _start, kind, score, _pos in found[:8]
        ],
    }


def stream_on_air(path):
    dev, info = r3_capture.wide_demod(path)
    fs = r3_capture.FS
    i0, i1 = int(info["i0"]), int(info["i1"])
    if i1 - i0 < int(0.4 * fs):
        return {"error": "keyed span too short", "keyed_samples": int(i1 - i0)}
    # The click owns the first ~40 ms. The end frame is in the last 0.8 s.
    windows = {
        "after_click": (i0 + int(0.04 * fs), min(i1, i0 + int(1.20 * fs))),
        "steady": (i0 + int(1.00 * fs), i1 - int(0.30 * fs)),
        "tail": (max(i0 + int(0.04 * fs), i1 - int(0.80 * fs)), i1),
    }
    attempts = {}
    for name, (a, b) in windows.items():
        if b - a < int(0.40 * fs):
            continue
        attempts[name] = _attempt(dev[a:b], fs)
    c0 = i0 + int(0.15 * fs)
    c1 = min(i1, i0 + int(0.70 * fs))
    burst = dev[c0:c1] - np.median(dev[c0:c1])
    burst_p99 = float(np.percentile(np.abs(burst), 99)) if len(burst) else 0.0
    period = LOOP_SAMPLES * (fs // 8000)
    h0 = i0 + int(1.00 * fs)
    h1 = min(i1 - int(0.30 * fs), h0 + int(2.0 * fs))
    h = dev[h0:h1] - np.median(dev[h0:h1]) if h1 > h0 else np.zeros(0)
    loop_r = None
    if len(h) > period + 200:
        a, b = h[:-period], h[period:]
        na, nb = float(np.linalg.norm(a)), float(np.linalg.norm(b))
        loop_r = float(np.dot(a, b) / (na * nb)) if na and nb else 0.0
    fit = None
    a0 = i0 + int(0.04 * fs)
    a1 = min(i1, i0 + int(1.20 * fs))
    use = dev[a0:a1] - np.median(dev[a0:a1])
    n8 = max(1, int(round(len(use) / (fs // 8000))))
    wave = -m17_stream_table.HZ_PER_COUNT * looped_pcm(n8).astype(np.float64)
    tmpl = np.repeat(wave, fs // 8000)
    n = min(len(use), len(tmpl))
    if n > int(0.30 * fs):
        use = use[:n]
        ref = tmpl[:n]
        ref = ref - ref.mean()
        u = use - use.mean()
        corr = np.correlate(u, ref, mode="full")
        mid = len(ref) - 1
        span = int(0.03 * fs)
        sl = corr[mid - span:mid + span + 1]
        lag_i = int(np.argmax(np.abs(sl))) - span
        if lag_i >= 0:
            uu, rr = u[lag_i:], ref[:n - lag_i]
        else:
            uu, rr = u[:n + lag_i], ref[-lag_i:]
        denom = float(np.dot(rr, rr))
        gain = float(np.dot(uu, rr) / denom) if denom else 0.0
        pred = gain * rr
        ss = float(np.dot(uu - uu.mean(), uu - uu.mean()))
        resid = float(np.dot(uu - pred, uu - pred))
        r2 = 1.0 - resid / ss if ss else 0.0
        sign = 1 if gain >= 0 else -1
        fit = {
            "r2": round(float(r2), 3),
            "polarity": int(sign),
            "lag_samples": int(lag_i),
            "shape_gain": round(abs(float(gain)), 3),
        }
    return {
        "attempts": attempts,
        "burst_p99_hz": round(burst_p99, 1),
        "loop240_r": None if loop_r is None else round(loop_r, 3),
        "fit": fit,
        "burst_stop": bool(burst_p99 >= camp.STOP_HZ),
    }


def _lerr0(row):
    vals = row.get("lerr") or []
    return bool(vals) and all(x == 0 for x in vals)


def eot_ok(stream):
    attempts = stream.get("attempts") or {}
    ac = attempts.get("after_click") or {}
    sd = attempts.get("steady") or {}
    tail = attempts.get("tail") or {}
    tfn = tail.get("fn") or []
    body_ok = (
        bool(ac.get("fn_ok")) and bool(ac.get("lsf_match")) and bool(ac.get("has_fn5"))
        and bool(ac.get("payloads_seq")) and _lerr0(ac) and not ac.get("has_eot")
        and bool(sd.get("fn_ok")) and bool(sd.get("has_fn5")) and not sd.get("has_eot")
        and bool(sd.get("payloads_seq")) and _lerr0(sd)
    )
    return bool(
        tfn and tfn[-1] == 0x8005 and tfn.count(0x8005) == 1
        and set(tfn[:-1]) <= FRAME_OK
        and bool(tail.get("payloads_seq")) and _lerr0(tail)
        and body_ok
    )


def main():
    if not IMAGE.exists() or IMAGE.stat().st_size != 378620:
        raise SystemExit("R4k0 image missing or wrong size")
    raw = IMAGE.read_bytes()
    if raw[0x38464:0x38474] != TAG.encode():
        raise SystemExit("image version is not R4k0")
    digest = hashlib.sha256(raw).hexdigest()
    md5 = hashlib.md5(raw).hexdigest()
    if digest != EXPECT_SHA:
        raise SystemExit("sha256 %s is not the built image" % digest)
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
    restore = False
    stop = False
    tx_t0 = None
    cap_waited = False
    try:
        boot_iq = CAP / "r4k0_boot.iq"
        proc, hlog, _ = r3a3_run.hackrf_recv(boot_iq, BOOT_S)
        try:
            time.sleep(1.5)
            size = boot_iq.stat().st_size if boot_iq.exists() else 0
            camp.say("boot capture growing %d bytes" % size)
            if size < 1_000_000:
                raise RuntimeError("hackrf stalled before the load; not loading")
            started = True
            try:
                loaded = camp.load_image(IMAGE)
            except Exception:
                restore = True
                raise
            camp.say("loaded %s" % loaded)
            if loaded != TAG:
                restore = True
                raise RuntimeError("version %s is not %s" % (loaded, TAG))
            text = camp.adb("shell", "logcat", "-d", "-s", "RadioService:I", "YModemManager:I", timeout=40)[1]
            (HERE / "r4k0_load.logcat.txt").write_text(text, encoding="utf-8")
            if "开机初始化完成" not in text and "module booted" not in text:
                restore = True
                raise RuntimeError("banner missing after the load")
        finally:
            finish_capture(proc, hlog, BOOT_S)
        info = factory_boot.analyze(1.5, boot_iq)
        (HERE / "r4k0_boot.json").write_text(json.dumps(info, indent=2), encoding="utf-8")
        camp.say("boot peak_db %.2f above_10db_s %.2f clip %.6f" % (
            info["peak_db"], info["above_10db_s"], info["clip_frac"]))
        if info["peak_db"] >= 6.0 or info["above_10db_s"] >= 0.2:
            restore = True
            raise RuntimeError("boot radiated; not keying")
        time.sleep(3)
        camp.tune()
        iq = CAP / "r4k0_silence.iq"
        proc, hlog, _ = r3a3_run.hackrf_recv(iq, KEY_S)
        try:
            time.sleep(1.5)
            size = iq.stat().st_size if iq.exists() else 0
            camp.say("key capture growing %d bytes" % size)
            if size < 1_000_000:
                raise RuntimeError("hackrf stalled before the key; not transmitting")
            tx_t0 = time.time()
            rc, bout = camp.broadcast(["--es", "cmd", "txwav", "--es", "name", "silence"])
            camp.say("txwav rc=%d %s" % (rc, bout.strip().replace("\n", " ")[:180]))
            finish_capture(proc, hlog, KEY_S)
        except Exception:
            if proc.poll() is None:
                finish_capture(proc, hlog, KEY_S)
            raise
        text = camp.adb("shell", "logcat", "-d", "-s", "RadioService:I", "DiagReceiver:I", timeout=40)[1]
        (HERE / "r4k0_silence.logcat.txt").write_text(text, encoding="utf-8")
        hits = [ln.strip() for ln in text.splitlines()
                if "bench wav" in ln or "module DMR" in ln or "cmd=0x26" in ln or "cmd=0x36" in ln
                or "does not answer" in ln or "stopped answering" in ln]
        camp.say("tx log: " + " | ".join(h[-160:] for h in hits[-8:]))
        answered = not any("does not answer" in h or "stopped answering" in h for h in hits)
        if not answered:
            camp.say("module stopped answering during the key; image stays loaded")
        result = r3a3_silence.steady_fft(iq)
        try:
            result["stream"] = stream_on_air(iq)
        except Exception as exc:
            result["stream"] = {"error": str(exc)}
        result["sha256"] = digest
        result["md5"] = md5
        result["module_answered"] = answered
        result["send_stop"] = any("cmd=0x36" in h and "[04]" in h for h in hits)
        camp.say("send_stop %s" % result["send_stop"])
        result["eot_ok"] = eot_ok(result.get("stream") or {})
        keyed = float((result.get("carrier") or {}).get("keyed_s") or 0)
        if keyed > 8.0:
            result["stuck_carrier"] = True
            camp.say("carrier still up at the end of the capture, keyed_s %.2f" % keyed)
            wait_cap(tx_t0)
            cap_waited = True
        else:
            result["stuck_carrier"] = False
        (HERE / "r4k0_silence.json").write_text(json.dumps(result, indent=2), encoding="utf-8")
        st = result.get("steady") or {}
        stream = result.get("stream") or {}
        camp.say("silence keyed %.2f s snr %.1f clip %.4f offset %+.0f steady_p99 %s click_p99 %s STOP %s" % (
            result["carrier"].get("keyed_s", 0), result["carrier"].get("snr_db", 0),
            result["carrier"].get("clip_frac", 0), result["carrier"].get("offset_hz", 0),
            st.get("p99_hz"), st.get("click_p99_hz"), result.get("STOP")))
        brief = {}
        for name, row in (stream.get("attempts") or {}).items():
            brief[name] = {
                "n": row.get("n_frames"),
                "crc": row.get("lsf_crc"),
                "match": row.get("lsf_match"),
                "fn_ok": row.get("fn_ok"),
                "pay": row.get("payloads_seq"),
                "fn5": row.get("has_fn5"),
                "eot": row.get("has_eot"),
                "eot_n": row.get("eot_count"),
                "last": row.get("last_fn"),
                "lerr0": all(x == 0 for x in row.get("lerr") or []),
                "fn": row.get("fn"),
            }
        camp.say("stream " + json.dumps({
            "burst_p99_hz": stream.get("burst_p99_hz"),
            "loop240_r": stream.get("loop240_r"),
            "fit": stream.get("fit"),
            "attempts": brief,
            "error": stream.get("error"),
        }))
        camp.say("R4k0 eot_ok %s" % result["eot_ok"])
        stop = bool(result.get("STOP")) or bool(stream.get("burst_stop"))
        if stream.get("burst_stop"):
            camp.say("STOP burst_p99 %s" % stream.get("burst_p99_hz"))
        if stop:
            restore = True
    except Exception:
        if tx_t0 is not None and not cap_waited:
            wait_cap(tx_t0)
        raise
    finally:
        try:
            if camp.hackrf_running():
                camp.kill_hackrf()
        except Exception as exc:
            camp.say("kill hackrf failed: %s" % exc)
        if started and restore:
            try:
                r3a3_silence.restore_factory()
                camp.say("R4k0 finished, factory image, VFO 467.625")
            except Exception as exc:
                camp.say("factory restore failed: %s" % exc)
                raise
        elif started:
            try:
                camp.tune()
            except Exception as exc:
                camp.say("tune after the run failed (%s); R4k0 stays loaded" % exc)
            else:
                camp.say("R4k0 stays loaded, VFO 467.625")
    if stop:
        raise SystemExit(2)


if __name__ == "__main__":
    main()
