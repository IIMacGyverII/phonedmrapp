"""Flat-top 4FSK levels from the existing capture. No radio, no HackRF."""
import json
import sys
from pathlib import Path

import numpy as np

sys.path.insert(0, r"C:\Users\Joshua\AppData\Local\Temp\fw1718")
import camp

IQ = Path(r"C:\Users\Joshua\AppData\Local\Temp\fw1718\caps\r1_dmr.iq")


def main():
    dev, info = camp.demod(IQ)
    fs = camp.FS_A
    i0, i1 = camp.carrier_bounds(info, len(dev))
    seg = dev[i0:i1]
    # same 60 ms fold as the first pass
    w = int(0.001 * fs)
    sm = np.convolve(np.abs(seg), np.ones(w) / w, "same")
    p = int(0.060 * fs)
    fold = np.zeros(p)
    nper = 0
    for off in range(0, len(sm) - p, p):
        fold += sm[off:off + p]
        nper += 1
    fold /= max(nper, 1)
    thr = 0.45 * np.percentile(fold, 90) + 0.55 * np.percentile(fold, 10)
    on = fold > thr
    # longest run
    best = (0, 0)
    i = 0
    doubled = np.concatenate([on, on])
    while i < len(on):
        if not doubled[i]:
            i += 1
            continue
        j = i
        while j < len(doubled) and doubled[j] and (j - i) < p:
            j += 1
        if j - i > best[0]:
            best = (j - i, i % p)
        i = j if j > i else i + 1
    win, at = best
    trim = int(0.001 * fs)
    flats = []
    thirds = [[], [], []]
    slopes = []
    specs = []
    for off in range(0, len(seg) - p, p):
        a = off + at + trim
        b = off + at + win - trim
        if b - a < int(0.012 * fs) or b > len(seg):
            continue
        piece = seg[a:b]
        if np.percentile(np.abs(piece), 80) < 400:
            continue
        d = np.abs(np.diff(piece, prepend=piece[0]))
        # a held symbol moves far less than a transition
        flat = d < 800.0
        # require the sample and its two neighbours quiet
        quiet = flat.copy()
        quiet[1:] &= flat[:-1]
        quiet[:-1] &= flat[1:]
        vals = piece[quiet]
        if len(vals) < 20:
            continue
        flats.append(vals)
        span = b - a
        for t, name_i in ((0, 0), (1, 1), (2, 2)):
            x0 = a + int(span * t / 3) - (off + at)  # unused
        # thirds of this interior
        n = len(piece)
        for t in range(3):
            sl = piece[int(n * t / 3):int(n * (t + 1) / 3)]
            dd = np.abs(np.diff(sl, prepend=sl[0]))
            q = dd < 800.0
            q[1:] &= (dd[:-1] < 800)
            q[:-1] &= (dd[1:] < 800) if False else q[:-1]
            got = sl[q]
            if len(got):
                thirds[t].append(got)
        specs.append(piece - np.mean(piece))
    cat = np.concatenate(flats)
    # histogram
    bins = np.arange(-12000, 12001, 150)
    hist, edges = np.histogram(cat, bins=bins)
    # four strongest peaks, separated by at least 600 Hz
    order = np.argsort(hist)[::-1]
    peaks = []
    for idx in order:
        center = 0.5 * (edges[idx] + edges[idx + 1])
        if hist[idx] < 30:
            break
        if any(abs(center - p0) < 700 for p0, _ in peaks):
            continue
        peaks.append((float(center), int(hist[idx])))
        if len(peaks) == 6:
            break
    peaks.sort()
    # outer = the two peaks farthest from zero among the four largest
    by_count = sorted(peaks, key=lambda t: -t[1])[:4]
    by_count_sorted = sorted(by_count)
    def side(xs, sign):
        s = [v for v in xs if v * sign > 2500]
        return float(np.median(s)) if s else None
    pos = side(cat, 1)
    neg = side(cat, -1)
    # early/mid/late using the same |dev|>2500 flat samples
    def med_abs(chunks):
        if not chunks:
            return None
        v = np.concatenate(chunks)
        v = v[np.abs(v) > 2500]
        return float(np.median(np.abs(v))) if len(v) else None
    early, mid, late = med_abs(thirds[0]), med_abs(thirds[1]), med_abs(thirds[2])
    levels = [v for v in (early, mid, late) if v]
    ratio = min(levels) / max(levels) if len(levels) >= 2 else None
    # long flat runs: consecutive quiet samples of the same sign, >= 0.6 ms
    run_deltas = []
    for off in range(0, len(seg) - p, p):
        a = off + at + trim
        b = off + at + win - trim
        if b > len(seg) or b - a < int(0.012 * fs):
            continue
        piece = seg[a:b]
        d = np.abs(np.diff(piece, prepend=piece[0]))
        quiet = d < 800.0
        k = 0
        while k < len(piece):
            if not quiet[k] or abs(piece[k]) < 2500:
                k += 1
                continue
            j = k
            sign = np.sign(piece[k])
            while j < len(piece) and quiet[j] and np.sign(piece[j]) == sign and abs(piece[j]) > 2500:
                j += 1
            if j - k >= int(0.0006 * fs):
                run_deltas.append(float(piece[j - 1] - piece[k]))
            k = j if j > k else k + 1
    audio = np.concatenate(specs)
    audio = audio - np.mean(audio)
    spec = np.abs(np.fft.rfft(audio * np.hanning(len(audio)))) ** 2
    freqs = np.fft.rfftfreq(len(audio), 1 / fs)
    def band(f0, f1):
        m = (freqs >= f0) & (freqs < f1)
        return float(spec[m].sum())
    low, midp = band(0, 250), band(250, 4000)
    out = {
        "n_flat_samples": int(len(cat)),
        "n_bursts_used": len(flats),
        "peaks_hz_count": peaks,
        "four_largest": by_count_sorted,
        "outer_pos_hz": pos,
        "outer_neg_hz": neg,
        "early_hz": early,
        "mid_hz": mid,
        "late_hz": late,
        "flat_ratio": ratio,
        "run_n": len(run_deltas),
        "run_delta_median_hz": float(np.median(run_deltas)) if run_deltas else None,
        "run_delta_p90_abs_hz": float(np.percentile(np.abs(run_deltas), 90)) if run_deltas else None,
        "fraction_below_250": low / (low + midp + 1e-12),
        "flat_p99_hz": float(np.percentile(np.abs(cat), 99)),
        "window_ms": win / fs * 1000,
        "interior_ms": (win - 2 * trim) / fs * 1000,
    }
    Path(r"C:\Users\Joshua\AppData\Local\Temp\fw1718\r1_flattop.json").write_text(
        json.dumps(out, indent=2), encoding="utf-8")
    print(json.dumps(out, indent=2))


if __name__ == "__main__":
    main()
