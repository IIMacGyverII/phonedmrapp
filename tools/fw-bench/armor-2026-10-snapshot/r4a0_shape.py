"""Offline shape check of the saved R4a0 silence capture. Does not transmit."""
import json
import sys
from pathlib import Path

import numpy as np

sys.path.insert(0, r"C:\Users\Joshua\AppData\Local\Temp\fw1718")
import r3_capture

IQ = Path(r"C:\Users\Joshua\AppData\Local\Temp\fw1718\caps\r4a0_silence.iq")
BIN = Path(r"D:\Documents\code\personal\phonedmrapp\radio_firmware\build\DMR003.R4a0.V022.bin")
FS = 48000
# signed immediates of one 10-sample period; aired count = immediate << 8
PERIOD = np.array([19, 12, 2, -2, -12, -20, 7, 20, -7, 1], dtype=np.float64)
COUNTS = PERIOD * 256.0
REV = COUNTS[::-1].copy()


def goertzel(x, fs, f0):
    n = np.arange(len(x))
    w = np.hanning(len(x))
    c = np.sum(w * x * np.exp(-2j * np.pi * f0 * n / fs))
    return float(2 * np.abs(c) / (np.sum(w) + 1e-12))


def lin_of(counts, n, lag):
    """Linear interpolation of 10 stored counts, 6 demod samples each."""
    t = (np.arange(n) - lag) / 6.0
    i0 = np.floor(t).astype(np.int64)
    frac = t - i0
    a = counts[i0 % 10]
    b = counts[(i0 + 1) % 10]
    return (1.0 - frac) * a + frac * b


def r2(y, yhat):
    ss_res = np.sum((y - yhat) ** 2)
    ss_tot = np.sum((y - np.mean(y)) ** 2)
    return float(1 - ss_res / (ss_tot + 1e-12))


def main():
    import hashlib
    data = BIN.read_bytes()
    print("sha256", hashlib.sha256(data).hexdigest())
    print("md5", hashlib.md5(data).hexdigest())
    print("len", len(data))

    dev, info = r3_capture.wide_demod(str(IQ))
    i0 = int(info["i0"])
    i1 = int(info["i1"])
    print("carrier", {k: info[k] for k in ("keyed_s", "snr_db", "offset_hz", "clip_frac", "i0", "i1")})
    a = i0 + int(1.0 * FS)
    b = i1 - int(0.3 * FS)
    steady = dev[a:b]
    print("steady_n", len(steady), "rms", float(np.sqrt(np.mean(steady ** 2))),
          "p99", float(np.percentile(np.abs(steady), 99)))
    click = dev[i0:i0 + int(0.1 * FS)]
    print("click_p99", float(np.percentile(np.abs(click), 99)))

    # first 0.25 s of the steady window
    head = steady[: int(0.25 * FS)]
    head = head - np.mean(head)
    ac = np.correlate(head, head, mode="full")
    ac = ac[len(head) - 1:]
    ac = ac / ac[0]
    for lag in (60, 120, 180):
        print("ac", lag, float(ac[lag]))

    for f in (796.875, 800.0, 1000.0, 15.625, 1593.75, 2390.625):
        print("line", f, round(goertzel(steady, FS, f), 2))

    # short stretches: 8 periods = 480 samples, step 50 ms
    per = 60
    win = per * 8
    step = int(0.05 * FS)
    rows = []
    for s in range(0, len(steady) - win, step):
        y = steady[s:s + win]
        best = None
        best_pos = None
        best_rev = None
        best_z = None
        y0 = y - np.mean(y)
        for lag in range(0, per):
            for counts, slot in ((COUNTS, "fwd"), (REV, "rev")):
                tmpl = lin_of(counts, win, lag)
                tmpl = tmpl - np.mean(tmpl)
                denom = float(np.dot(tmpl, tmpl)) + 1e-12
                scale = float(np.dot(y0, tmpl) / denom)
                score = r2(y0, scale * tmpl)
                if slot == "fwd":
                    if best is None or score > best[0]:
                        best = (score, lag, scale)
                    if scale > 0 and (best_pos is None or score > best_pos[0]):
                        best_pos = (score, lag, scale)
                elif best_rev is None or score > best_rev[0]:
                    best_rev = (score, lag, scale)
            idx = np.floor((np.arange(win) - lag) / 6.0).astype(np.int64)
            zoh = COUNTS[idx % 10]
            zoh = zoh - np.mean(zoh)
            zdenom = float(np.dot(zoh, zoh)) + 1e-12
            zscale = float(np.dot(y0, zoh) / zdenom)
            zscore = r2(y0, zscale * zoh)
            if best_z is None or zscore > best_z[0]:
                best_z = (zscore, lag, zscale)
        rows.append((
            best[0], best[1], best[2], best_z[0],
            best_pos[0] if best_pos else float("nan"),
            best_rev[0], best_rev[2],
        ))
    arr = np.array(rows)
    good = arr[:, 0] >= 0.95
    print("n", len(rows))
    print("lin_r2 median", float(np.median(arr[:, 0])), "p10", float(np.percentile(arr[:, 0], 10)),
          "min", float(np.min(arr[:, 0])))
    print("lin_r2_ge_0.95", int(np.sum(good)))
    print("hz_per_count good median", float(np.median(arr[good, 2])))
    print("pos_r2 median", float(np.median(arr[:, 4])), "ge_0.95", int(np.sum(arr[:, 4] >= 0.95)))
    print("rev_r2 median", float(np.median(arr[:, 5])), "ge_0.95", int(np.sum(arr[:, 5] >= 0.95)),
          "scale", float(np.median(arr[:, 6])))
    print("zoh_r2 median", float(np.median(arr[:, 3])), "ge_0.95", int(np.sum(arr[:, 3] >= 0.95)))
    out = Path(r"C:\Users\Joshua\AppData\Local\Temp\fw1718\r4a0_shape.json")
    out.write_text(json.dumps({
        "n": len(rows),
        "lin_r2_median": float(np.median(arr[:, 0])),
        "lin_r2_p10": float(np.percentile(arr[:, 0], 10)),
        "lin_r2_min": float(np.min(arr[:, 0])),
        "n_ge_095": int(np.sum(arr[:, 0] >= 0.95)),
        "hz_per_count_median": float(np.median(arr[:, 2])),
        "zoh_r2_median": float(np.median(arr[:, 3])),
    }, indent=2), encoding="utf-8")


if __name__ == "__main__":
    main()
