"""Scale sweep and symbol levels on one held phone clip, plus the RAM symbol map."""
import sys
from pathlib import Path

import numpy as np

sys.path.insert(0, r"D:\Documents\code\personal\phonedmrapp\tools\m17-research")
import m17  # noqa: E402

RD = Path(r"C:\Users\Joshua\AppData\Local\Temp\fw1718\rd10")
RE = Path(r"C:\Users\Joshua\AppData\Local\Temp\fw1718\re")
FS = 8000.0
BODY = 514


def pcm(path):
    blob = path.read_bytes()
    i = blob.find(b"data")
    n = int.from_bytes(blob[i + 4:i + 8], "little")
    return np.frombuffer(blob[i + 8:i + 8 + n], dtype="<i2").astype(np.float64)


def onset(x):
    win = 400
    for i in range(0, x.size - win, 80):
        sl = x[i:i + win]
        if np.sqrt(np.mean((sl - sl.mean()) ** 2)) >= 800:
            return i
    return 0


def be(raw):
    x = np.empty(len(raw) // 2, np.float64)
    for i in range(x.size):
        v = (raw[2 * i] << 8) | raw[2 * i + 1]
        if v >= 32768:
            v -= 65536
        x[i] = v
    return x


def load_bin(path):
    raw = path.read_bytes()
    parts = []
    for i in range(0, len(raw) - BODY + 1, BODY):
        b = raw[i:i + BODY]
        parts.append((int(b[512]), int(b[513]), be(b[:512])))
    parts.sort()
    return parts


x = pcm(RD / "re_phone_m17_1.wav")
i = onset(x)
seg = x[i + int(0.25 * FS):]  # drop the unmute edge
print("seg", seg.size, "from", (i + int(0.25 * FS)) / FS)

# symbol level histogram at the R-D scale
scale0 = 2500.0 / 6366.0
dev = -seg * scale0  # inverted was the polarity that saw fn 0,1
y, sps = m17.demod(dev, FS)
# take a steady middle
ys = y[len(y) // 5: 4 * len(y) // 5]
# resampled to 48 kHz, sps 10. Pick samples at a grid and see 4 clusters via the best offset
best = None
for off in range(sps):
    sl = ys[off::sps]
    sl = sl[np.abs(sl) > 200]
    if sl.size < 50:
        continue
    # cluster by sign and magnitude
    a = np.abs(sl)
    # two-means-ish: inner vs outer split at midpoint of percentiles
    lo, hi = np.percentile(a, [30, 80])
    score = hi - lo
    if best is None or sl.size > best[0]:
        best = (sl.size, off, float(np.median(a[a < (lo + hi) / 2])) if np.any(a < (lo + hi) / 2) else 0,
                float(np.median(a[a >= (lo + hi) / 2])) if np.any(a >= (lo + hi) / 2) else 0)
print("level guess off", best[1] if best else None, "inner", best[2] if best else None, "outer", best[3] if best else None, "n", best[0] if best else None)

print("scale sweep (skip 0.25 s, inverted)")
for scale in np.linspace(0.25, 0.70, 19):
    dev = -seg * float(scale)
    res = m17.decode_transmission(dev, FS, verbose=False)
    lsf = res["lsf"]
    frames = res["frames"]
    g0 = sum(1 for fn, p, e in frames if e == 0)
    fns = [int(fn) & 0xFFFF for fn, p, e in frames[:8]]
    print("  %.3f crc=%s src=%s dst=%s n=%d g0=%d fn=%s g=%s" % (
        scale, lsf[2] if lsf else None, lsf[0] if lsf else None, lsf[1] if lsf else None,
        len(frames), g0, fns, [int(e) for fn, p, e in frames[:6]]))

# known symbols
lsf = m17.lsf_bytes("N0CALL", "@ALL")
known = np.array(list(m17.encode_lsf(lsf)) + list(m17.encode_stream(lsf, 0, bytes(16), 0))
                 + list(m17.encode_stream(lsf, 1, bytes(range(16)), 1)), float)
print("known", known.size)

ram_scale = 2500.0 / 7698.794358749383
print("== RAM symbol map scale", ram_scale)
for name in ("re_m17ram_0", "re_m17ram_1", "re_m17ram_2"):
    parts = load_bin(RE / (name + ".bin"))
    x = np.concatenate([p[2] for p in parts])
    print(name, "halves", [p[1] for p in parts], "n", x.size, "rms", float(np.sqrt(np.mean((x - x.mean()) ** 2))))
    best = None
    for sign in (1.0, -1.0):
        dev = x * ram_scale * sign
        y, sps = m17.demod(dev, FS)
        period = known.size
        span = period * sps
        if y.size < span:
            print("  short", y.size, sps)
            continue
        # one period search, plus a half-skip (drop first 256 samples of the 8 kHz capture)
        for drop in (0, 256):
            dev2 = x[drop:] * ram_scale * sign
            y2, sps = m17.demod(dev2, FS)
            if y2.size < span:
                continue
            for off in range(0, span, 1):
                sl = y2[off:off + span:sps]
                if sl.size < period:
                    continue
                # gain fit against known * 800
                ref = known * 800.0
                g = float(np.dot(sl, ref) / (np.dot(ref, ref) + 1e-9))
                q = np.array([-3, -1, 1, 3], float)[np.argmin(np.abs(sl[:, None] - g * 800.0 * np.array([-3, -1, 1, 3])[None, :]), axis=1)]
                err = q != known
                nerr = int(err.sum())
                if best is None or nerr < best[0]:
                    best = (nerr, sign, drop, off, g, err, sl)
    nerr, sign, drop, off, g, err, sl = best
    # where
    near = 0
    by_frame = [0, 0, 0]
    # map symbol index to sample in the 8 kHz capture: demod resamples 8k -> 48k
    for i in np.flatnonzero(err):
        by_frame[int(i) // 192] += 1
        sample_8k = drop + (off + i * sps) * FS / 48000.0
        dist = min(abs(sample_8k - 256.0 * k) for k in range(0, 8))
        if dist < 8:
            near += 1
    print("  best err %d/%d rate %.3f sign %s drop %d off %d gain %.3f by_frame %s near_boundary %d" % (
        nerr, known.size, nerr / known.size, sign, drop, off, g, by_frame, near))
    # sync score
    dev = x * ram_scale * sign
    y, sps = m17.demod(dev, FS)
    sc = -1
    if len(y) > 8 * sps:
        idx = np.arange(0, len(y) - 8 * sps, sps)
        for kind in ("lsf", "str"):
            s = m17.SYNC_SYMS[kind]
            V = np.stack([y[idx + m * sps] for m in range(8)], 1)
            c = V @ s / (np.sqrt(np.dot(s, s) * np.sum(V * V, 1)) + 1e-12)
            sc = max(sc, float(np.max(c)))
    print("  best sync", round(sc, 3))
