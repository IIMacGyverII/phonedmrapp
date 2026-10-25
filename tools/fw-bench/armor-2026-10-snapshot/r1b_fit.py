"""Fit the two deviation hypotheses to symbol centres of the existing R1 capture."""
import json
from pathlib import Path

import numpy as np

IQ = Path(r"C:\Users\Joshua\AppData\Local\Temp\fw1718\caps\r1_dmr.iq")
FS, OFF, DEC = 2_400_000, 240_000, 30
FS_D = FS // DEC
SYMS = 4800.0


def baseband():
    iq = np.fromfile(IQ, dtype=np.int8)
    z = iq[0::2].astype(np.float32) + 1j * iq[1::2].astype(np.float32)
    del iq
    parts = []
    for s0 in range(0, len(z) - DEC, FS):
        seg = z[s0:s0 + FS]
        m = len(seg) // DEC * DEC
        n = np.arange(s0, s0 + m, dtype=np.float64)
        ph = np.exp(-2j * np.pi * OFF / FS * n).astype(np.complex64)
        parts.append((seg[:m] * ph).reshape(-1, DEC).mean(axis=1))
    zd = np.concatenate(parts)
    ntap = 161
    t = np.arange(-(ntap // 2), ntap // 2)
    k = np.sinc(t * 2 * 20000 / FS_D) * np.blackman(ntap)
    k /= np.sum(k)
    return np.convolve(zd, k.astype(np.float32), "same")


def runs_of(zd):
    pw = np.convolve(np.abs(zd) ** 2, np.ones(160) / 160, "same")
    floor = np.percentile(pw, 20)
    on = pw > floor * 8
    # split on gaps >= 4 ms
    runs, i = [], 0
    while i < len(on):
        if not on[i]:
            i += 1
            continue
        j = i
        while j < len(on) and on[j]:
            j += 1
        if j - i > int(0.012 * FS_D):
            runs.append((i, j))
        i = j
    return runs


def centers(dev, runs, phase, sps):
    out = []
    for a, b in runs:
        a2, b2 = a + 80, b - 80  # 1 ms trim at 80 kHz
        n = int((b2 - a2 - phase) / sps)
        if n < 16:
            continue
        idx = (a2 + phase + sps * np.arange(n)).astype(int)
        idx = idx[(idx >= 0) & (idx < len(dev))]
        out.append(dev[idx])
    return np.concatenate(out) if out else np.array([])


def inertia(x, levels):
    lev = np.asarray(levels, dtype=np.float64)
    d = np.abs(x[:, None] - lev[None, :])
    return float(np.mean(np.min(d, axis=1) ** 2))


def main():
    zd = baseband()
    runs = runs_of(zd)
    dev = np.angle(zd[1:] * np.conj(zd[:-1])) * FS_D / (2 * np.pi)
    mask = np.zeros(len(dev), dtype=bool)
    for a, b in runs:
        mask[a:min(b, len(dev))] = True
    # Crystal + any fixed bias: use the midpoint of the burst spectrum later.
    # Here, subtract the median so both hypotheses are compared on the same trace,
    # and also search a residual offset.
    med = float(np.median(dev[mask]))
    dev = dev - med
    sps = FS_D / SYMS
    hypotheses = {
        "1944": [-1944, -648, 648, 1944],
        "7346": [-7346, -2449, 2449, 7346],
    }
    best = {}
    for name, levels in hypotheses.items():
        winner = None
        for phase in np.linspace(0, sps, 20, endpoint=False):
            x0 = centers(dev, runs, phase, sps)
            if len(x0) < 100:
                continue
            for off in np.linspace(-2500, 2500, 21):
                err = inertia(x0 - off, levels)
                if winner is None or err < winner[0]:
                    winner = (err, float(phase), float(off), x0)
        err, phase, off, x0 = winner
        x = x0 - off
        # cluster counts
        lev = np.array(levels, dtype=np.float64)
        assign = np.argmin(np.abs(x[:, None] - lev[None, :]), axis=1)
        counts = [int(np.sum(assign == i)) for i in range(4)]
        means = [float(np.median(x[assign == i])) if counts[i] else None for i in range(4)]
        rms = float(np.sqrt(err))
        best[name] = {
            "rms_hz": rms,
            "phase": phase,
            "residual_offset_hz": off,
            "median_removed_hz": med,
            "n": int(len(x)),
            "counts": counts,
            "cluster_medians_hz": means,
            "inner_over_outer": None,
        }
        if all(counts):
            outer = 0.5 * (abs(means[0]) + abs(means[3]))
            inner = 0.5 * (abs(means[1]) + abs(means[2]))
            best[name]["inner_over_outer"] = inner / outer if outer else None
            # flatness of samples assigned to the two outer levels
            thirds = []
            for a, b in runs:
                a2, b2 = a + 80, b - 80
                n = int((b2 - a2 - phase) / sps)
                if n < 16:
                    continue
                idx = (a2 + phase + sps * np.arange(n)).astype(int)
                idx = idx[(idx >= 1) & (idx < len(dev))]
                vals = dev[idx] - off
                which = np.argmin(np.abs(vals[:, None] - lev[None, :]), axis=1)
                outer_s = np.abs(vals[(which == 0) | (which == 3)])
                if len(outer_s) < 9:
                    continue
                k = len(outer_s) // 3
                thirds.append([np.median(outer_s[:k]), np.median(outer_s[k:2 * k]), np.median(outer_s[2 * k:])])
            if thirds:
                m = np.mean(thirds, axis=0)
                best[name]["outer_early_mid_late_hz"] = [float(v) for v in m]
                best[name]["outer_late_over_early"] = float(m[2] / m[0]) if m[0] else None
    # Which hypothesis wins, and by how much.
    print(json.dumps({"n_runs": len(runs), "sps": sps, "fit": best}, indent=2))


if __name__ == "__main__":
    main()
