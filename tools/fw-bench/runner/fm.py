"""FM analysis of a HackRF capture, as the Armor bench judged every key.

`demod` mixes the carrier down from the capture offset, decimates to 48 kHz, filters to 9 kHz, and returns the
instantaneous frequency (Hz) with the keyed interval found from the power envelope. `key_report` gives the
numbers every results entry carries: carrier length, clip fraction, SNR, body p99 of |deviation| with the first
and last 50 ms dropped, per-0.5 s slice p99 (the 5 kHz stop), the loudest spectral peaks and the 1 kHz line.
`boot_report` is the silent-boot judge: 100 ms power bins against the pre-restart floor, runs at or over 10 dB.
"""
import numpy as np


def demod(cfg, iq_path):
    iq = np.fromfile(str(iq_path), dtype=np.int8)
    fs, off, dec, fa = cfg.fs_iq, cfg.offset_hz, cfg.dec, cfg.fs_a
    if len(iq) < fs:
        raise RuntimeError("capture too short: %d bytes" % len(iq))
    z = iq[0::2].astype(np.float32) + 1j * iq[1::2].astype(np.float32)
    clip = float(np.mean(np.abs(iq) >= 126))
    del iq
    # A low-power carrier is ~30 dB above the noise inside ±6 kHz and still
    # invisible to the wideband RMS. A continuous carrier also fills the
    # quietest second, so that second is not a noise reference. Compare the
    # loudest second of the offset ±6 kHz band with a same-width band 100 kHz
    # away. 10 dB is the carrier; noise-only stays near 0 dB.
    present, carrier_db = in_channel_carrier(z, fs, off)
    out = []
    for s0 in range(0, len(z) - dec, fs):
        seg = z[s0:s0 + fs]
        m = len(seg) // dec * dec
        ph = np.exp((-2j * np.pi * off / fs) * np.arange(s0, s0 + m)).astype(np.complex64)
        out.append((seg[:m] * ph).reshape(-1, dec).mean(axis=1))
    zd = np.concatenate(out)
    k = np.sinc(np.arange(-64, 65) * 2 * 9000 / fa) * np.blackman(129); k /= k.sum()
    zd = np.convolve(zd, k, "same")
    dev = np.angle(zd[1:] * np.conj(zd[:-1])) * fa / (2 * np.pi)
    pw = np.convolve(np.abs(zd) ** 2, np.ones(4800) / 4800, "same")
    # The noise floor: the quietest one-second window, not a percentile of the whole capture. A capture that is
    # mostly carrier (a 118 s picture in a 128 s capture) puts the carrier itself at the 10th percentile.
    win = fa
    mins = [float(np.median(pw[i:i + win])) for i in range(0, max(1, len(pw) - win + 1), win)]
    floor = min(mins) if mins else float(np.percentile(pw, 10))
    on = pw > max(floor * 20, 1e-6)
    if not present or not on.any():
        i0, i1 = 0, 0
    else:
        i0 = int(np.argmax(on)); i1 = int(len(on) - np.argmax(on[::-1]))
    snr = 10 * np.log10((np.median(pw[i0:i1]) + 1e-12) / (floor + 1e-12)) if i1 > i0 else 0.0
    offset = float(np.median(dev[i0:i1])) if i1 > i0 + 100 else float("nan")
    dev = dev - (0 if np.isnan(offset) else offset)
    info = {"clip_frac": clip, "snr_db": float(snr), "offset_hz": offset,
            "keyed_s": 0.0 if i1 <= i0 else (i1 - i0) / fa,
            "i0": i0, "i1": i1, "fs": fa, "no_carrier": (not present),
            "carrier_db": round(carrier_db, 1)}
    return dev, info


def band_powers(z, fs, freq, half_bw=6000.0):
    """Per-second mean power in [freq − half_bw, freq + half_bw].

    A boxcar of length fs / (2·half_bw) is a ±half_bw low-pass after the mix.
    """
    dec = max(1, int(round(fs / (2.0 * half_bw))))
    sec = int(fs)
    out = []
    for s0 in range(0, len(z) - sec + 1, sec):
        m = (sec // dec) * dec
        ph = np.exp((-2j * np.pi * freq / fs) * np.arange(s0, s0 + m)).astype(np.complex64)
        mixed = (z[s0:s0 + m] * ph).reshape(-1, dec).mean(axis=1)
        out.append(float(np.mean(np.abs(mixed) ** 2)))
    return out


def in_channel_carrier(z, fs, offset_hz, half_bw=6000.0):
    """True when the offset ±6 kHz band is at least 10 dB above a band 100 kHz away."""
    inn = band_powers(z, fs, offset_hz, half_bw)
    ref = band_powers(z, fs, offset_hz + 100000.0, half_bw)
    if not inn or not ref:
        return False, 0.0
    floor = float(np.median(ref))
    if floor <= 0:
        return False, 0.0
    db = 10.0 * np.log10(max(inn) / floor)
    return bool(db >= 10.0), float(db)


def goertzel(x, fs, f0):
    n = np.arange(len(x)); w = np.hanning(len(x))
    c = np.sum(w * x * np.exp(-2j * np.pi * f0 * n / fs))
    return float(2 * np.abs(c) / (np.sum(w) + 1e-12))


def key_report(cfg, iq_path, tone_hz=1000.0):
    dev, info = demod(cfg, iq_path)
    fs = info["fs"]; i0, i1 = info["i0"], info["i1"]
    rep = {"carrier_s": round(info["keyed_s"], 3), "clip": round(info["clip_frac"], 6), "snr_db": round(info["snr_db"], 1), "offset_hz": round(info["offset_hz"], 1) if not np.isnan(info["offset_hz"]) else None}
    if info.get("no_carrier"):
        rep["NO_CARRIER"] = True
        rep["body"] = None
        return rep
    a = i0 + int(0.05 * fs); b = i1 - int(0.05 * fs)
    if b - a < int(0.2 * fs):
        rep["body"] = None
        return rep
    seg = dev[a:b] - np.median(dev[a:b])
    slices = []
    for t in range(a, b - int(0.5 * fs) + 1, int(0.5 * fs)):
        sl = dev[t:t + int(0.5 * fs)]; sl = sl - np.median(sl)
        slices.append(round(float(np.percentile(np.abs(sl), 99)), 1))
    w = np.hanning(len(seg)); sp = 2 * np.abs(np.fft.rfft(seg * w)) / np.sum(w); sp[0] = 0
    freqs = np.fft.rfftfreq(len(seg), 1 / fs)
    peaks = []; last = -100.0
    for k in np.argsort(sp)[::-1]:
        f = float(freqs[k])
        if f < 5 or f > 4000 or abs(f - last) < 8:
            continue
        peaks.append({"hz": round(f, 1), "amp_hz": round(float(sp[k]), 1)}); last = f
        if len(peaks) >= 6:
            break
    p99 = float(np.percentile(np.abs(seg), 99))
    rep["body"] = {"p99_hz": round(p99, 1), "rms_hz": round(float(np.sqrt(np.mean(seg ** 2))), 1), "slice_p99_max_hz": max(slices) if slices else None,
                   "tone_hz": tone_hz, "tone_line_hz": round(goertzel(seg, fs, tone_hz), 1), "peaks": peaks, "slices": slices,
                   "STOP": bool(max([p99] + slices) >= cfg.stop_hz)}
    return rep


def boot_report(cfg, iq_path, t_restart_s):
    """Silent-boot judge: floor from the bins before the restart, peak dB above it, runs at or over 10 dB."""
    iq = np.memmap(str(iq_path), dtype=np.int8, mode="r")
    fs, off, dec = cfg.fs_iq, cfg.offset_hz, cfg.dec
    n = (len(iq) // 2 // dec) * dec
    clip = float(np.mean(np.abs(iq[: n * 2]) >= 126))
    chunk = fs // 10
    powers = []
    for i in range(0, n, chunk):
        c = min(chunk, n - i); c = (c // dec) * dec
        if c < dec:
            break
        raw = np.asarray(iq[2 * i: 2 * (i + c)])
        z = raw[0::2].astype(np.float32) + 1j * raw[1::2].astype(np.float32)
        powers.append(float(np.mean(z.real ** 2 + z.imag ** 2)))
    p = np.array(powers)
    n_lead = max(1, int(t_restart_s * 10))
    floor = float(np.median(p[:n_lead])) or float(np.percentile(p, 20))
    db = 10 * np.log10((p + 1e-12) / (floor + 1e-12))
    on = db >= 10.0
    runs = []; i = 0
    while i < len(on):
        if not on[i]:
            i += 1; continue
        j = i
        while j < len(on) and on[j]:
            j += 1
        runs.append({"t0": round(i * 0.1, 1), "t1": round(j * 0.1, 1), "peak_db": round(float(np.max(db[i:j])), 2)})
        i = j
    return {"floor_db": 0.0, "peak_db": round(float(np.max(db)), 3), "peak_t_s": round(float(np.argmax(db)) * 0.1, 1),
            "above_10db_s": round(float(np.sum(on)) * 0.1, 1), "clip": round(clip, 6), "runs": runs, "SILENT": len(runs) == 0}
