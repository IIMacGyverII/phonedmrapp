"""R1b symbol levels from the existing capture. No radio, no HackRF.

99% occupied bandwidth of the complex baseband, plus the four symbol-centre
frequencies. Also repeats the 9 kHz demod the earlier +/-7.3 kHz reading used,
so the two can be compared on the same IQ.
"""
import json
from pathlib import Path

import numpy as np

IQ = Path(r"C:\Users\Joshua\AppData\Local\Temp\fw1718\caps\r1_dmr.iq")
FS = 2_400_000
OFF = 240_000
SYMS = 4800.0


def load_iq():
    iq = np.fromfile(IQ, dtype=np.int8)
    return iq[0::2].astype(np.float32) + 1j * iq[1::2].astype(np.float32)


def decimate(z, dec):
    parts = []
    for s0 in range(0, len(z) - dec, FS):
        seg = z[s0:s0 + FS]
        m = len(seg) // dec * dec
        n = np.arange(s0, s0 + m, dtype=np.float64)
        ph = np.exp(-2j * np.pi * OFF / FS * n).astype(np.complex64)
        parts.append((seg[:m] * ph).reshape(-1, dec).mean(axis=1))
    return np.concatenate(parts)


def lpf(zd, fs, fc):
    ntap = 161
    t = np.arange(-(ntap // 2), ntap // 2 + 1)
    k = np.sinc(t * (2 * fc / fs)) * np.blackman(len(t))
    k /= k.sum()
    return np.convolve(zd, k.astype(np.float64), "same")


def bursts(zd, fs):
    win = max(8, int(0.002 * fs))
    pw = np.convolve(np.abs(zd) ** 2, np.ones(win) / win, "same")
    floor = float(np.percentile(pw, 20))
    on = pw > max(floor * 8, 1e-12)
    gap = int(0.004 * fs)
    closed = on.copy()
    i = 0
    while i < len(on):
        if on[i]:
            i += 1
            continue
        j = i
        while j < len(on) and not on[j]:
            j += 1
        if 0 < i and j < len(on) and j - i < gap:
            closed[i:j] = True
        i = j
    runs, i = [], 0
    minrun = int(0.012 * fs)
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
    return runs, floor


def obw(zd, runs, fs):
    # A burst is ~31 ms: 2048 bins fit at 80 kHz, not at 48 kHz.
    nfft = 1024 if fs <= 50_000 else 2048
    win = np.hanning(nfft)
    acc = np.zeros(nfft, dtype=np.float64)
    nspec = 0
    hop = nfft // 2
    for a, b in runs:
        seg = zd[a:b]
        for s in range(0, len(seg) - nfft, hop):
            acc += np.abs(np.fft.fft(seg[s:s + nfft] * win)) ** 2
            nspec += 1
    psd = np.fft.fftshift(acc / max(nspec, 1))
    freqs = np.fft.fftshift(np.fft.fftfreq(nfft, 1 / fs))
    noise = float(np.median(psd[np.abs(freqs) > 25000])) if fs > 50000 else float(np.median(psd[np.abs(freqs) > 15000]))
    sig = np.clip(psd - noise, 0, None)
    band = np.abs(freqs) <= min(30000, fs * 0.45)
    sig = sig * band
    total = float(sig.sum())
    if total <= 0 or nspec == 0:
        return {
            "obw_99_hz": None, "f_lo_hz": None, "f_hi_hz": None,
            "centroid_hz": 0.0, "midpoint_hz": None, "peak_hz": None,
            "n_spectra": nspec, "bin_hz": float(freqs[1] - freqs[0]),
        }
    c = np.cumsum(sig)
    lo = int(np.searchsorted(c, 0.005 * total))
    hi = int(np.searchsorted(c, 0.995 * total))
    hi = min(max(hi, lo), len(freqs) - 1)
    # Power-weighted centroid inside the 99% band, the carrier estimate.
    sl = sig[lo:hi + 1]
    fr = freqs[lo:hi + 1]
    cen = float(np.sum(fr * sl) / np.sum(sl))
    return {
        "obw_99_hz": float(freqs[hi] - freqs[lo]),
        "f_lo_hz": float(freqs[lo]),
        "f_hi_hz": float(freqs[hi]),
        "centroid_hz": cen,
        "midpoint_hz": float(0.5 * (freqs[lo] + freqs[hi])),
        "peak_hz": float(freqs[int(np.argmax(sig))]),
        "n_spectra": nspec,
        "bin_hz": float(freqs[1] - freqs[0]),
    }


def inst(zd, fs):
    return np.angle(zd[1:] * np.conj(zd[:-1])) * fs / (2 * np.pi)


def gather(dev, runs, fs, phase, trim_s=0.001):
    sps = fs / SYMS
    trim = int(trim_s * fs)
    out = []
    spans = []
    for a, b in runs:
        a2, b2 = a + trim, b - trim
        n = int((b2 - a2 - phase) / sps)
        if n < 16:
            continue
        idx = (a2 + phase + sps * np.arange(n)).astype(int)
        idx = idx[(idx >= 0) & (idx < len(dev))]
        if len(idx) < 16:
            continue
        out.append(dev[idx])
        spans.append((len(out) - 1, len(idx)))
    if not out:
        return np.array([]), []
    return np.concatenate(out), spans


def clock_phase(dev, runs, fs):
    """Symbol-centre phase from the 4800 Hz line of |d(freq)/dt| inside bursts."""
    sps = fs / SYMS
    sl = np.abs(np.diff(dev, prepend=dev[:1]))
    mask = np.zeros(len(sl), dtype=bool)
    trim = int(0.002 * fs)
    for a, b in runs:
        if b - a > 2 * trim:
            mask[a + trim:b - trim] = True
    n = np.arange(len(sl))
    ph = np.sum(sl[mask] * np.exp(-2j * np.pi * SYMS / fs * n[mask]))
    # angle is the transition-peak time. Centres sit half a symbol later.
    tau = float(np.angle(ph) / (2 * np.pi) * sps)
    return float((tau + 0.5 * sps) % sps)


def four_means(x):
    lev = np.percentile(x, [12.5, 37.5, 62.5, 87.5]).astype(np.float64)
    assign = None
    for _ in range(12):
        assign = np.argmin(np.abs(x[:, None] - lev[None, :]), axis=1)
        nxt = lev.copy()
        for i in range(4):
            sel = x[assign == i]
            if len(sel) < 8:
                return None
            nxt[i] = np.median(sel)
        if np.max(np.abs(nxt - lev)) < 1:
            lev = nxt
            break
        lev = nxt
    order = np.argsort(lev)
    lev = lev[order]
    assign = np.argsort(order)[assign] if False else np.array([int(np.where(order == a)[0][0]) for a in assign])
    # remap assign through order: new index of old cluster
    remap = np.empty(4, dtype=int)
    remap[order] = np.arange(4)
    assign = remap[np.argmin(np.abs(x[:, None] - lev[None, :]), axis=1)]
    counts = [int(np.sum(assign == i)) for i in range(4)]
    stds = [float(np.std(x[assign == i])) for i in range(4)]
    rms = float(np.sqrt(np.mean((x - lev[assign]) ** 2)))
    return lev, assign, counts, stds, rms


def peaks_of(x, lo=-10000, hi=10000, step=40):
    bins = np.arange(lo, hi + step, step)
    hist, edges = np.histogram(x, bins=bins)
    sm = np.convolve(hist.astype(float), np.array([1, 2, 3, 2, 1]) / 9, "same")
    found = []
    for i in range(2, len(sm) - 2):
        if sm[i] >= sm[i - 1] and sm[i] >= sm[i + 1] and sm[i] > sm[i - 2] and sm[i] >= 0.15 * sm.max():
            f = 0.5 * (edges[i] + edges[i + 1])
            if any(abs(f - p[0]) < 350 for p in found):
                continue
            found.append((float(f), float(sm[i])))
    found.sort(key=lambda p: -p[1])
    top = sorted(found[:4])
    return [{"hz": p[0], "weight": p[1]} for p in top]


def analyze(name, zd, fs):
    runs, floor = bursts(zd, fs)
    spec = obw(zd, runs, fs)
    dev = inst(zd, fs)
    phase = clock_phase(dev, runs, fs)
    # Also search a few phases around the clock, and a full grid, keep the tightest fit.
    sps = fs / SYMS
    trials = [phase]
    trials += list(np.linspace(0, sps, 24, endpoint=False))
    best = None
    carrier = spec["centroid_hz"]
    for ph in trials:
        x, spans = gather(dev - carrier, runs, fs, ph)
        if len(x) < 200:
            continue
        fit = four_means(x)
        if fit is None:
            continue
        lev, assign, counts, stds, rms = fit
        if best is None or rms < best["rms_hz"]:
            best = {
                "phase_samples": float(ph),
                "n": int(len(x)),
                "levels_hz": [float(v) for v in lev],
                "counts": counts,
                "std_hz": [round(s, 1) for s in stds],
                "rms_hz": rms,
                "assign": assign,
                "x": x,
                "spans": spans,
            }
    if best is None:
        return {"n_runs": len(runs), "fit": None, "obw": spec, "carrier_hz": carrier}
    x = best.pop("x")
    assign = best.pop("assign")
    spans = best.pop("spans")
    lev = np.array(best["levels_hz"])
    mid = 0.5 * (lev[0] + lev[3])
    centered = lev - mid
    outer = 0.5 * (abs(centered[0]) + abs(centered[3]))
    inner = 0.5 * (abs(centered[1]) + abs(centered[2]))
    best["centered_hz"] = [float(v) for v in centered]
    best["center_of_levels_hz"] = float(mid)
    best["inner_over_outer"] = float(inner / outer) if outer else None
    best["outer_hz"] = float(outer)
    best["inner_hz"] = float(inner)
    # Flatness of the outer-symbol samples across each burst.
    thirds = []
    pos = 0
    for _, n in spans:
        sl = x[pos:pos + n]
        asn = assign[pos:pos + n]
        pos += n
        outer_s = np.abs(sl[(asn == 0) | (asn == 3)] - mid)
        if len(outer_s) < 9:
            continue
        k = len(outer_s) // 3
        thirds.append([np.median(outer_s[:k]), np.median(outer_s[k:2 * k]), np.median(outer_s[2 * k:])])
    if thirds:
        m = np.mean(thirds, axis=0)
        best["outer_early_mid_late_hz"] = [float(v) for v in m]
        best["outer_late_over_early"] = float(m[2] / m[0]) if m[0] else None
        best["n_bursts_flat"] = len(thirds)
    # All-sample modes, to show the four peaks without trusting one phase.
    mask = np.zeros(len(dev), dtype=bool)
    trim = int(0.001 * fs)
    for a, b in runs:
        if b - a > 2 * trim:
            mask[a + trim:min(b - trim, len(dev))] = True
    samp = dev[mask] - carrier
    best["all_sample_peaks"] = peaks_of(samp)
    best["all_sample_p50_abs"] = float(np.percentile(np.abs(samp), 50))
    best["all_sample_p99_abs"] = float(np.percentile(np.abs(samp), 99))
    # Spectrum of the deviation waveform: fraction of 0-4 kHz power below 250 Hz.
    piece = samp - np.mean(samp)
    if len(piece) > 256:
        spec_if = np.abs(np.fft.rfft(piece * np.hanning(len(piece)))) ** 2
        freqs = np.fft.rfftfreq(len(piece), 1 / fs)
        def band(f0, f1):
            m = (freqs >= f0) & (freqs < f1)
            return float(spec_if[m].sum())
        low, mid = band(0, 250), band(250, 4000)
        best["if_power_below_250_over_0_4k"] = low / (low + mid) if (low + mid) else None
    best["clock_phase_samples"] = phase
    best["n_runs"] = len(runs)
    best["run_ms_median"] = float(np.median([(b - a) / fs * 1e3 for a, b in runs]))
    best["carrier_hz"] = carrier
    best["obw"] = spec
    best["floor"] = floor
    # Distance of the centred levels to the two hypotheses.
    h1944 = np.array([-1944, -648, 648, 1944], dtype=float)
    h7346 = np.array([-7346, -2449, 2449, 7346], dtype=float)
    best["rms_to_1944"] = float(np.sqrt(np.mean((centered - h1944) ** 2)))
    best["rms_to_7346"] = float(np.sqrt(np.mean((centered - h7346) ** 2)))
    return best


def main():
    z = load_iq()
    zd80 = decimate(z, 30)
    wide = analyze("80k_boxcar", zd80, 80_000)
    wide_f = analyze("80k_lpf20k", lpf(zd80, 80_000, 20000), 80_000)
    zd48 = decimate(z, 50)
    narrow = analyze("48k_lpf9k", lpf(zd48, 48_000, 9000), 48_000)
    out = {"wide_boxcar": wide, "wide_lpf20": wide_f, "narrow_lpf9": narrow}
    text = json.dumps(out, indent=2)
    Path(r"C:\Users\Joshua\AppData\Local\Temp\fw1718\r1b_levels.json").write_text(text, encoding="utf-8")
    print(text)


if __name__ == "__main__":
    main()
