# R3: one 3 s low-power key on the 467.625 VFO, HackRF receive only.
# Wide boxcar demod so a 15.6 Hz square's tops are not filtered off.
# Does not transmit until camp.tune confirms the VFO line.
import json, subprocess, sys, time
from pathlib import Path

import numpy as np

sys.path.insert(0, r"C:\Users\Joshua\AppData\Local\Temp\fw1718")
import camp

FS_IQ, OFF, DEC, FS = camp.FS_IQ, camp.OFF, camp.DEC, camp.FS_A
LNA, VGA = 24, 38
CAP_S = 8.0
TONE_MS = 3000
SQ_HZ = 8000.0 / 512.0  # 15.625 Hz, 2 x 256 samples at 8 kHz


def wide_demod(iq_path):
    iq = np.fromfile(iq_path, dtype=np.int8)
    z = iq[0::2].astype(np.float32) + 1j * iq[1::2].astype(np.float32)
    del iq
    out = []
    for s0 in range(0, len(z) - DEC, FS_IQ):
        seg = z[s0:s0 + FS_IQ]
        m = len(seg) // DEC * DEC
        ph = np.exp((-2j * np.pi * OFF / FS_IQ) * np.arange(s0, s0 + m)).astype(np.complex64)
        out.append((seg[:m] * ph).reshape(-1, DEC).mean(axis=1))
    zd = np.concatenate(out)
    dev = np.angle(zd[1:] * np.conj(zd[:-1])) * FS / (2 * np.pi)
    pw = np.convolve(np.abs(zd) ** 2, np.ones(int(0.05 * FS)) / int(0.05 * FS), "same")
    floor = float(np.percentile(pw, 10))
    on = pw > max(floor * 20, 1e-6)
    if on.any():
        i0 = int(np.argmax(on))
        i1 = int(len(on) - np.argmax(on[::-1]))
    else:
        i0, i1 = 0, len(dev)
    mag = np.abs(zd)
    keyed = mag[i0:i1] if i1 > i0 + 100 else mag
    snr = 10 * np.log10((np.median(pw[i0:i1]) + 1e-12) / (floor + 1e-12)) if i1 > i0 else 0.0
    offset = float(np.median(dev[i0:i1])) if i1 > i0 + 100 else float("nan")
    clip = float(np.mean(np.abs(z) >= 126))
    info = {
        "mean_mag": float(np.mean(keyed)),
        "clip_frac": clip,
        "snr_db": float(snr),
        "offset_hz": offset,
        "keyed_s": (i1 - i0) / FS,
        "i0": i0,
        "i1": i1,
        "n": int(len(z)),
    }
    return dev - offset, info


def goertzel(x, fs, f0):
    n = np.arange(len(x))
    w = np.hanning(len(x))
    c = np.sum(w * x * np.exp(-2j * np.pi * f0 * n / fs))
    return float(2 * np.abs(c) / (np.sum(w) + 1e-12))


def square_shape(dev, info):
    i0, i1 = int(info["i0"]), int(info["i1"])
    # skip the key-up edge and the unkey edge
    a = i0 + int(0.35 * FS)
    b = i1 - int(0.25 * FS)
    if b - a < int(0.8 * FS):
        return {"class": "no-key", "span": (b - a) / FS}
    seg = dev[a:b]
    per = int(round(FS / SQ_HZ))  # 3072
    half = per // 2
    # align on one period
    tmpl = np.concatenate([np.ones(half), -np.ones(half)]).astype(np.float32)
    best, blag = -1.0, 0
    step = 16
    # one period of lags is enough; score a few periods
    use = seg[: min(len(seg), per * 8)]
    for lag in range(0, per, step):
        m = (len(use) - lag) // per * per
        if m < per * 2:
            continue
        x = use[lag:lag + m].reshape(-1, per)
        score = float(np.mean(x * tmpl))
        if score > best:
            best, blag = score, lag
    # refine ±step
    for lag in range(max(0, blag - step), min(per, blag + step + 1)):
        m = (len(use) - lag) // per * per
        if m < per * 2:
            continue
        x = use[lag:lag + m].reshape(-1, per)
        score = float(np.mean(x * tmpl))
        if score > best:
            best, blag = score, lag
    m = (len(seg) - blag) // per * per
    folded = seg[blag:blag + m].reshape(-1, per)
    # flip so the first half is the positive top
    if np.mean(folded[:, :half]) < 0:
        folded = -folded
    avg = folded.mean(axis=0)
    pos, neg = avg[:half], avg[half:]
    # tops: drop the first and last 2 ms of each half (edges)
    trim = int(0.002 * FS)
    p = pos[trim:-trim]
    n = neg[trim:-trim]
    p_start, p_end = float(np.mean(p[: int(0.004 * FS)])), float(np.mean(p[-int(0.004 * FS):]))
    n_start, n_end = float(np.mean(n[: int(0.004 * FS)])), float(np.mean(n[-int(0.004 * FS):]))
    outer = 0.5 * (abs(p_start) + abs(n_start))
    # exponential fit on the positive half, y = A*exp(-t/tau) + C
    t = np.arange(len(p)) / FS
    # if nearly flat, tau is huge; report the end/start ratio
    ratio = p_end / p_start if abs(p_start) > 20 else float("nan")
    tau = None
    corner = None
    if np.isfinite(ratio) and 0.05 < ratio < 0.92 and abs(p_start) > 30:
        # log fit after removing the late floor
        y = p - p_end
        ok = y > max(5.0, 0.05 * abs(p_start))
        if ok.sum() > 10:
            tt, yy = t[ok], np.log(y[ok])
            slope = float(np.polyfit(tt, yy, 1)[0])
            if slope < -1:
                tau = -1.0 / slope
                corner = 1.0 / (2 * np.pi * tau)
    f15 = goertzel(seg, FS, SQ_HZ)
    f1k = goertzel(seg, FS, 1000.0)
    rms = float(np.sqrt(np.mean(seg ** 2)))
    p99 = float(np.percentile(np.abs(seg), 99))
    # 8 samples across the averaged period, for the write-up
    idx = np.linspace(0, per - 1, 8).astype(int)
    shape = [round(float(avg[i]), 1) for i in idx]
    kind = "bare"
    if f1k > 3 * max(f15, 30) and f1k > 80:
        kind = "codec-1kHz"
    elif f15 > 40 and f15 > 2 * f1k and outer > 40:
        if tau is not None:
            kind = "droop"
        elif np.isfinite(ratio) and ratio > 0.85:
            kind = "flat"
        else:
            kind = "square-odd"
    elif rms < 80 and f15 < 40 and f1k < 80:
        kind = "bare"
    else:
        kind = "weak"
    return {
        "class": kind,
        "periods": int(folded.shape[0]),
        "align_score_hz": round(best, 1),
        "f15_hz": round(f15, 1),
        "f1k_hz": round(f1k, 1),
        "rms_hz": round(rms, 1),
        "p99_hz": round(p99, 1),
        "pos_start_hz": round(p_start, 1),
        "pos_end_hz": round(p_end, 1),
        "neg_start_hz": round(n_start, 1),
        "neg_end_hz": round(n_end, 1),
        "end_over_start": None if not np.isfinite(ratio) else round(ratio, 3),
        "tau_s": None if tau is None else round(tau, 4),
        "corner_hz": None if corner is None else round(corner, 2),
        "outer_hz": round(outer, 1),
        "shape_hz": shape,
    }


def capture(name):
    if camp.hackrf_running():
        raise SystemExit("hackrf already running")
    camp.tune()
    n = int(FS_IQ * CAP_S)
    path = camp.CAP / ("%s.iq" % name)
    if path.exists():
        path.unlink()
    camp.say("capture %s n=%d l=%d g=%d" % (name, n, LNA, VGA))
    hlog = open(camp.CAP / (name + ".hackrf.log"), "w", encoding="utf-8", errors="replace")
    proc = subprocess.Popen(
        [camp.HACKRF, "-r", str(path), "-f", "467385000", "-s", "2400000",
         "-l", str(LNA), "-g", str(VGA), "-n", str(n)],
        stdout=hlog, stderr=subprocess.STDOUT)
    time.sleep(0.8)
    if proc.poll() is not None:
        hlog.close()
        raise SystemExit("hackrf exited early: " + (camp.CAP / (name + ".hackrf.log")).read_text(errors="replace")[-400:])
    rc, bout = camp.broadcast(["--es", "cmd", "testtone", "--ei", "ms", str(TONE_MS)])
    camp.say("testtone rc=%d %s" % (rc, bout.strip().replace("\n", " ")[:180]))
    proc.wait(timeout=CAP_S + 20)
    hlog.close()
    text = camp.logcat_since(20)
    hits = [ln.strip() for ln in text.splitlines() if "test tone" in ln or "testtone" in ln or "TX " in ln]
    camp.say("tx log: " + " | ".join(h[-140:] for h in hits[-4:]))
    camp.vfo_off()
    return path


def main():
    name = sys.argv[1] if len(sys.argv) > 1 else "r3a0"
    path = capture(name)
    dev, info = wide_demod(path)
    shape = square_shape(dev, info)
    out = {"file": str(path), "bytes": path.stat().st_size, "carrier": info, "square": shape}
    dest = camp.HERE / (name + ".json")
    dest.write_text(json.dumps(out, indent=2), encoding="utf-8")
    print(json.dumps(out, indent=2))


if __name__ == "__main__":
    main()
