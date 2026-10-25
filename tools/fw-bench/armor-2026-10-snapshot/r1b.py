"""R1b: 99% occupied bandwidth and 4FSK symbol histogram from the existing capture.

No radio, no HackRF. The capture is r1_dmr.iq (HackRF int8, 2.4 MHz, tuned
240 kHz below 467.625).
"""
import json
from pathlib import Path

import numpy as np

IQ = Path(r"C:\Users\Joshua\AppData\Local\Temp\fw1718\caps\r1_dmr.iq")
OUT = Path(r"C:\Users\Joshua\AppData\Local\Temp\fw1718\r1b.json")
FS = 2_400_000
OFF = 240_000
# Complex baseband at 80 kHz: wide enough for a ±7 kHz 4FSK and for a ±2 kHz one.
DEC = 30
FS_D = FS // DEC  # 80000
SYMS = 4800
# FM demod at 80 kHz, LPF 20 kHz, so a real ±7 kHz rail is inside the filter.
LPF_HZ = 20000


def load_baseband():
    iq = np.fromfile(IQ, dtype=np.int8)
    z = iq[0::2].astype(np.float32) + 1j * iq[1::2].astype(np.float32)
    del iq
    parts = []
    step = FS  # one second
    for s0 in range(0, len(z) - DEC, step):
        seg = z[s0:s0 + step]
        m = len(seg) // DEC * DEC
        n = np.arange(s0, s0 + m, dtype=np.float64)
        ph = np.exp(-2j * np.pi * OFF / FS * n).astype(np.complex64)
        parts.append((seg[:m] * ph).reshape(-1, DEC).mean(axis=1))
    zd = np.concatenate(parts)
    # 20 kHz complex LPF at 80 kHz.
    ntap = 161
    t = np.arange(-ntap // 2, ntap // 2)
    k = np.sinc(t * 2 * LPF_HZ / FS_D) * np.blackman(ntap)
    k /= k.sum()
    return np.convolve(zd, k.astype(np.float32), "same")


def bursts(zd):
    pw = np.convolve(np.abs(zd) ** 2, np.ones(int(0.002 * FS_D)) / int(0.002 * FS_D), "same")
    floor = np.percentile(pw, 20)
    on = pw > max(floor * 8, 1e-8)
    # close gaps shorter than 4 ms, drop runs shorter than 8 ms
    gap = int(0.004 * FS_D)
    i = 0
    closed = on.copy()
    while i < len(on):
        if on[i]:
            i += 1
            continue
        j = i
        while j < len(on) and not on[j]:
            j += 1
        if j - i < gap and i > 0 and j < len(on):
            closed[i:j] = True
        i = j
    runs = []
    i = 0
    minrun = int(0.008 * FS_D)
    while i < len(closed):
        if not closed[i]:
            i += 1
            continue
        j = i
        while j < len(closed) and closed[j]:
            j += 1
        if j - i >= minrun:
            runs.append((i, j))
        i = j
    return runs, pw, float(floor)


def obw_99(zd, runs):
    """99% power bandwidth of the burst spectrum, noise floor removed."""
    # 2048-point Hann periodograms, ~39 Hz bins at 80 kHz.
    nfft = 2048
    win = np.hanning(nfft).astype(np.float32)
    acc = np.zeros(nfft, dtype=np.float64)
    nspec = 0
    hop = nfft // 2
    for a, b in runs:
        seg = zd[a:b]
        for s in range(0, len(seg) - nfft, hop):
            acc += np.abs(np.fft.fft(seg[s:s + nfft] * win)) ** 2
            nspec += 1
    if nspec == 0:
        return None
    psd = np.fft.fftshift(acc / nspec)
    # Noise from the outer 10% of bins on each side (well outside ±8 kHz at this zoom
    # the edges are ±40 kHz). Use the median of |f| > 25 kHz.
    freqs = np.fft.fftshift(np.fft.fftfreq(nfft, 1 / FS_D))
    noise = np.median(psd[np.abs(freqs) > 25000])
    sig = np.clip(psd - noise, 0, None)
    # Restrict the integral to ±30 kHz so a residual DC spur or image cannot set the edges.
    band = np.abs(freqs) <= 30000
    sig = sig * band
    total = sig.sum()
    if total <= 0:
        return None
    c = np.cumsum(sig)
    lo = int(np.searchsorted(c, 0.005 * total))
    hi = int(np.searchsorted(c, 0.995 * total))
    lo = min(lo, len(freqs) - 1)
    hi = min(max(hi, lo), len(freqs) - 1)
    # Peak and the -3/-6 dB widths, for context.
    peak = int(np.argmax(sig))
    half = sig[peak] / 2
    return {
        "n_spectra": nspec,
        "n_bursts": len(runs),
        "obw_99_hz": float(freqs[hi] - freqs[lo]),
        "f_lo_hz": float(freqs[lo]),
        "f_hi_hz": float(freqs[hi]),
        "noise_bin": float(noise),
        "peak_hz": float(freqs[peak]),
        "bin_hz": float(freqs[1] - freqs[0]),
    }


def symbol_histogram(zd, runs):
    dev = np.angle(zd[1:] * np.conj(zd[:-1])) * FS_D / (2 * np.pi)
    # Carrier offset from the median of in-burst samples.
    mask = np.zeros(len(dev), dtype=bool)
    for a, b in runs:
        mask[a:min(b, len(dev))] = True
    offset = float(np.median(dev[mask])) if mask.any() else 0.0
    dev = dev - offset
    sps = FS_D / SYMS  # 80000/4800 = 16.666...
    # Phase search over one symbol, 1/8 symbol steps.
    best = None
    for phase in np.linspace(0, sps, 16, endpoint=False):
        centers = []
        for a, b in runs:
            # Drop 1 ms at each end (ramp).
            a2 = a + int(0.001 * FS_D)
            b2 = b - int(0.001 * FS_D)
            if b2 - a2 < sps * 8:
                continue
            idx = a2 + phase + sps * np.arange(0, int((b2 - a2 - phase) / sps))
            idx = idx.astype(int)
            idx = idx[(idx >= 0) & (idx < len(dev))]
            if len(idx):
                centers.append(dev[idx])
        if not centers:
            continue
        c = np.concatenate(centers)
        # Peakiness: variance of a coarse histogram. A locked phase piles into 4 bins.
        hist, edges = np.histogram(c, bins=80, range=(-10000, 10000))
        score = float(np.sum(hist.astype(np.float64) ** 2))
        if best is None or score > best[0]:
            best = (score, float(phase), c)
    score, phase, c = best
    hist, edges = np.histogram(c, bins=200, range=(-12000, 12000))
    # Four largest local peaks, separated by at least 400 Hz.
    peaks = []
    order = np.argsort(hist)[::-1]
    for i in order:
        f = float(0.5 * (edges[i] + edges[i + 1]))
        if hist[i] < max(8, 0.02 * hist.max()):
            break
        if any(abs(f - p[0]) < 400 for p in peaks):
            continue
        peaks.append((f, int(hist[i])))
        if len(peaks) == 4:
            break
    peaks.sort()
    # Also the median of samples within 300 Hz of each peak, once peaks exist.
    refined = []
    for f, n in peaks:
        sel = c[np.abs(c - f) < 300]
        refined.append({
            "peak_hz": f,
            "n": n,
            "median_hz": float(np.median(sel)) if len(sel) else f,
            "n_near": int(len(sel)),
        })
    outers = [r["median_hz"] for r in refined]
    inners = outers[1:-1] if len(outers) == 4 else []
    ratio = None
    if len(outers) == 4 and abs(outers[0]) + abs(outers[-1]) > 0:
        outer = 0.5 * (abs(outers[0]) + abs(outers[-1]))
        inner = 0.5 * (abs(outers[1]) + abs(outers[2]))
        ratio = inner / outer if outer else None
    # Flatness of the true outer symbols: early/mid/late of each burst.
    flat = None
    if len(outers) == 4:
        outer = 0.5 * (abs(outers[0]) + abs(outers[-1]))
        thirds = []
        for a, b in runs:
            a2 = a + int(0.001 * FS_D)
            b2 = b - int(0.001 * FS_D)
            if b2 - a2 < sps * 8:
                continue
            idx = (a2 + phase + sps * np.arange(0, int((b2 - a2 - phase) / sps))).astype(int)
            idx = idx[(idx >= 0) & (idx < len(dev))]
            vals = np.abs(dev[idx])
            # keep samples near the outer rail (within 25% of the outer level, above the inner)
            keep = vals > outer * 0.75
            vals = vals[keep]
            if len(vals) < 9:
                continue
            k = len(vals) // 3
            thirds.append((float(np.median(vals[:k])), float(np.median(vals[k:2 * k])), float(np.median(vals[2 * k:]))))
        if thirds:
            arr = np.array(thirds)
            med = arr.mean(axis=0)
            flat = {
                "n_bursts": len(thirds),
                "early_hz": float(med[0]),
                "mid_hz": float(med[1]),
                "late_hz": float(med[2]),
                "ratio": float(med[2] / med[0]) if med[0] else None,
            }
    return {
        "offset_hz": offset,
        "phase_samples": phase,
        "n_centers": int(len(c)),
        "score": score,
        "peaks": refined,
        "inner_over_outer": ratio,
        "p50_abs": float(np.percentile(np.abs(c), 50)),
        "p99_abs": float(np.percentile(np.abs(c), 99)),
        "flat": flat,
    }


def main():
    zd = load_baseband()
    runs, pw, floor = bursts(zd)
    lengths = [(b - a) / FS_D for a, b in runs]
    info = {
        "capture_bytes": IQ.stat().st_size,
        "fs_baseband": FS_D,
        "lpf_hz": LPF_HZ,
        "n_runs": len(runs),
        "run_ms_median": float(np.median(lengths) * 1000) if lengths else None,
        "run_ms_min": float(min(lengths) * 1000) if lengths else None,
        "run_ms_max": float(max(lengths) * 1000) if lengths else None,
        "floor": floor,
    }
    # Period from run starts.
    if len(runs) > 3:
        starts = np.array([a for a, _ in runs], dtype=float) / FS_D
        d = np.diff(starts)
        d = d[(d > 0.02) & (d < 0.12)]
        info["period_ms"] = float(np.median(d) * 1000) if len(d) else None
    info["obw"] = obw_99(zd, runs)
    info["symbols"] = symbol_histogram(zd, runs)
    OUT.write_text(json.dumps(info, indent=2), encoding="utf-8")
    print(json.dumps(info, indent=2))


if __name__ == "__main__":
    main()
