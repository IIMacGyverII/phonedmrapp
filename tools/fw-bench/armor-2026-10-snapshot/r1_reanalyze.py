"""Reanalyze the existing R1 capture. No radio, no HackRF."""
import json
import sys
from pathlib import Path

import numpy as np

sys.path.insert(0, r"C:\Users\Joshua\AppData\Local\Temp\fw1718")
import camp

IQ = Path(r"C:\Users\Joshua\AppData\Local\Temp\fw1718\caps\r1_dmr.iq")
OUT = Path(r"C:\Users\Joshua\AppData\Local\Temp\fw1718\r1_reanalyze.json")


def burst_windows(seg, fs):
    w = max(8, int(0.001 * fs))
    sm = np.convolve(np.abs(seg), np.ones(w) / w, "same")
    step = 4
    s = sm[::step]
    s = s - s.mean()
    best = (0.0, int(0.030 * fs))
    lo = int(0.020 * fs) // step
    hi = int(0.070 * fs) // step
    n = min(len(s), int(2.0 * fs) // step)
    a = s[:n]
    for lag in range(lo, hi):
        m = n - lag
        if m < 100:
            break
        c = float(np.dot(a[:m], a[lag:lag + m]) / (m * (np.std(a) + 1e-9) ** 2))
        if c > best[0]:
            best = (c, lag * step)
    p = int(best[1])
    fold = np.zeros(p)
    counts = np.zeros(p)
    for off in range(0, len(sm) - p, p):
        fold += sm[off:off + p]
        counts += 1
    fold /= np.maximum(counts, 1)
    thr = 0.45 * np.percentile(fold, 90) + 0.55 * np.percentile(fold, 10)
    on = fold > thr
    doubled = np.concatenate([on, on])
    best_run = (0, 0)
    i = 0
    while i < len(on):
        if not doubled[i]:
            i += 1
            continue
        j = i
        while j < len(doubled) and doubled[j] and j - i < p:
            j += 1
        if j - i > best_run[0]:
            best_run = (j - i, i % p)
        i = j if j > i else i + 1
    return p, best_run[0], best_run[1], best[0]


def main():
    dev, info = camp.demod(IQ)
    fs = camp.FS_A
    i0, i1 = camp.carrier_bounds(info, len(dev))
    seg = dev[i0:i1]
    p, win, run_at, corr = burst_windows(seg, fs)
    trim = int(0.001 * fs)
    bursts = []
    for off in range(0, len(seg) - p, p):
        a = off + run_at + trim
        b = off + run_at + win - trim
        if b - a < int(0.015 * fs) or b > len(seg):
            continue
        piece = seg[a:b]
        if np.percentile(np.abs(piece), 80) < 400:
            continue
        bursts.append(piece)
    sym = fs / 4800.0
    outer_pos, outer_neg = [], []
    thirds = [[], [], []]
    slopes = []
    center_abs = []
    used = 0
    cluster = []
    for piece in bursts:
        best = None
        for ph in range(int(sym)):
            idx = (ph + np.arange(0, int((len(piece) - ph) / sym)) * sym).astype(int)
            idx = idx[idx < len(piece)]
            if len(idx) < 70:
                continue
            samples = piece[idx]
            qs = np.percentile(samples, [12.5, 37.5, 62.5, 87.5])
            dist = np.min(np.abs(samples[:, None] - qs[None, :]), axis=1).mean()
            if best is None or dist < best[0]:
                best = (dist, samples, qs)
        if best is None:
            continue
        samples, qs = best[1], best[2]
        used += 1
        cluster.append([float(x) for x in qs])
        span = max(abs(qs[0]), abs(qs[3]), 1.0)
        cut = 0.62 * span
        outer = []
        for k, s in enumerate(samples):
            center_abs.append(abs(float(s)))
            if abs(s) < cut:
                continue
            third = min(2, int(k * 3 / len(samples)))
            thirds[third].append(abs(float(s)))
            outer.append((k, float(s)))
            if s > 0:
                outer_pos.append(float(s))
            else:
                outer_neg.append(float(s))
        signs = np.where(np.abs(samples) >= cut, np.sign(samples), 0)
        k = 0
        while k < len(signs):
            if signs[k] == 0:
                k += 1
                continue
            j = k
            while j < len(signs) and signs[j] == signs[k]:
                j += 1
            if j - k >= 4:
                run = samples[k:j]
                slopes.append(float(run[-1] - run[0]))
            k = j
        if len(outer) >= 8:
            xs = np.array([t[0] for t in outer], dtype=float)
            ys = np.abs(np.array([t[1] for t in outer]))
            slope = float(np.polyfit(xs, ys, 1)[0])
            slopes.append(slope * len(samples))  # Hz across this burst's outer symbols
    cat = np.concatenate(bursts)
    cat = cat - np.mean(cat)
    spec = np.abs(np.fft.rfft(cat * np.hanning(len(cat)))) ** 2
    freqs = np.fft.rfftfreq(len(cat), 1 / fs)

    def band(f0, f1):
        m = (freqs >= f0) & (freqs < f1)
        return float(spec[m].sum())

    p_low, p_mid = band(0, 250), band(250, 4000)
    # raw window including the ramps, for the old worst-sample figure
    raw = []
    for off in range(0, len(seg) - p, p):
        a = off + run_at
        b = a + win
        if b <= len(seg):
            raw.append(seg[a:b])
    raw = np.concatenate(raw) if raw else cat
    med = lambda xs: float(np.median(xs)) if len(xs) else None
    early, mid, late = med(thirds[0]), med(thirds[1]), med(thirds[2])
    levels = [v for v in (early, mid, late) if v]
    ratio = (min(levels) / max(levels)) if len(levels) >= 2 else None
    # slope list mixed run-end deltas and burst-span slopes; split them
    run_deltas = [s for s in slopes if abs(s) < 8000]
    out = {
        "keyed_s": info["keyed_s"],
        "snr_db": info["snr_db"],
        "offset_hz": info["offset_hz"],
        "clip_frac": info["clip_frac"],
        "mean_mag": info["mean_mag"],
        "period_ms": p / fs * 1000,
        "window_ms": win / fs * 1000,
        "interior_ms": (win - 2 * trim) / fs * 1000,
        "corr": corr,
        "n_bursts": len(bursts),
        "n_measured": used,
        "outer_pos_hz": med(outer_pos),
        "outer_neg_hz": med(outer_neg),
        "outer_early_hz": early,
        "outer_mid_hz": mid,
        "outer_late_hz": late,
        "flat_ratio": ratio,
        "run_delta_median_hz": med(run_deltas),
        "run_delta_n": len(run_deltas),
        "symbol_center_p99_hz": float(np.percentile(center_abs, 99)) if center_abs else None,
        "symbol_center_p50_hz": float(np.percentile(center_abs, 50)) if center_abs else None,
        "interior_raw_p99_hz": float(np.percentile(np.abs(cat), 99)),
        "window_raw_p995_hz": float(np.percentile(np.abs(raw), 99.5)),
        "fraction_below_250": p_low / (p_low + p_mid + 1e-12),
        "cluster_median": [float(np.median([c[i] for c in cluster])) for i in range(4)] if cluster else [],
        "n_outer_pos": len(outer_pos),
        "n_outer_neg": len(outer_neg),
    }
    OUT.write_text(json.dumps(out, indent=2), encoding="utf-8")
    print(json.dumps(out, indent=2))


if __name__ == "__main__":
    main()
