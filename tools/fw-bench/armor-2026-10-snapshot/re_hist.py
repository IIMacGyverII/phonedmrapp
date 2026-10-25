"""Where the RAM symbol errors fall. Uses the gain-fitted alignment from re_scale."""
import sys
from pathlib import Path

import numpy as np

sys.path.insert(0, r"D:\Documents\code\personal\phonedmrapp\tools\m17-research")
import m17  # noqa: E402

RE = Path(r"C:\Users\Joshua\AppData\Local\Temp\fw1718\re")
FS = 8000.0
BODY = 514
# best alignments from the scale sweep
BEST = {
    "re_m17ram_0": (1.0, 0, 860, 3.080),
    "re_m17ram_1": (1.0, 0, 1892, 0.635),
    "re_m17ram_2": (1.0, 0, 2563, 3.330),
}


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


lsf = m17.lsf_bytes("N0CALL", "@ALL")
known = np.array(list(m17.encode_lsf(lsf)) + list(m17.encode_stream(lsf, 0, bytes(16), 0))
                 + list(m17.encode_stream(lsf, 1, bytes(range(16)), 1)), float)
scale = 2500.0 / 7698.794358749383
for name, (sign, drop, off, g) in BEST.items():
    x = np.concatenate([p[2] for p in load_bin(RE / (name + ".bin"))])
    y, sps = m17.demod(x[drop:] * scale * sign, FS)
    sl = y[off:off + known.size * sps:sps]
    q = np.array([-3.0, -1, 1, 3])[np.argmin(np.abs(sl[:, None] - g * 800.0 * np.array([-3.0, -1, 1, 3])[None, :]), axis=1)]
    err = np.flatnonzero(q != known)
    bins = [0] * 8
    near = 0
    dists = []
    for i in err:
        bins[int(i) % 192 // 24] += 1
        sample = drop + (off + int(i) * sps) * FS / 48000.0
        dist = min(abs(sample - 256.0 * k) for k in range(8))
        dists.append(dist)
        if dist < 8:
            near += 1
    print(name, "err", len(err), "bins24", bins, "near8", near,
          "median_dist", float(np.median(dists)) if len(dists) else None)
