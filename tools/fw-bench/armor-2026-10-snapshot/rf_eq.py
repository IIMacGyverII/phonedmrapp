"""Fit the R-E held-path taps once, then decode a clip from sync only.

Training uses the known N0CALL loop. A test clip is decoded with the fixed taps and the
sync symbols only: no known payload is used to place or scale the frame.
"""
import json
import sys
from pathlib import Path

import numpy as np

sys.path.insert(0, r"D:\Documents\code\personal\phonedmrapp\tools\m17-research")
import m17  # noqa: E402

FS = 8000.0
L = 20
SIGN = -1.0
HERE = Path(r"C:\Users\Joshua\AppData\Local\Temp\fw1718")
TAPS = HERE / "rf" / "taps.json"


def pcm(path):
    blob = Path(path).read_bytes()
    i = blob.find(b"data")
    n = int.from_bytes(blob[i + 4:i + 8], "little")
    return np.frombuffer(blob[i + 8:i + 8 + n], dtype="<i2").astype(np.float64)


def loud(x):
    w = 400
    rms = [np.sqrt(np.mean((x[i:i + w] - x[i:i + w].mean()) ** 2)) for i in range(0, x.size - w, 80)]
    on = np.flatnonzero(np.array(rms) > 800)
    i0 = int(on[0] * 80 + 0.25 * FS) if on.size else 0
    x = x[i0:]
    return x - x.mean()


def train(path):
    lsf = m17.lsf_bytes("N0CALL", "@ALL")
    known = [np.array(list(m17.encode_lsf(lsf)), float),
             np.array(list(m17.encode_stream(lsf, 0, bytes(16), 0)), float),
             np.array(list(m17.encode_stream(lsf, 1, bytes(range(16)), 1)), float)]
    y, sps = m17.demod(SIGN * loud(pcm(path)), FS)
    segs = []
    for start, kind, score, j in m17.find_frames(y, sps, thresh=0.85):
        lo = j - L * sps
        if lo < 0 or j + (192 + L) * sps > y.size:
            continue
        seg = y[lo:j + (192 + L) * sps:sps]
        core = seg[L:L + 192]
        c = [np.dot(core, k) / (np.linalg.norm(core) * np.linalg.norm(k) + 1e-12) for k in known]
        if max(c) < 0.5:
            continue
        segs.append((seg, known[int(np.argmax(c))]))
    S = np.concatenate([s[L:L + 192] for s, k in segs])
    K = np.concatenate([k for s, k in segs])
    g, off = np.linalg.lstsq(np.vstack([K, np.ones_like(K)]).T, S, rcond=None)[0]
    rows, tgt = [], []
    for seg, k in segs:
        z = (seg - off) / g
        for n in range(192):
            rows.append(z[n:n + 2 * L + 1][::-1])
            tgt.append(k[n])
    w = np.linalg.lstsq(np.array(rows), np.array(tgt), rcond=None)[0]
    return w, int(len(segs)), int(sps)


def equalise_frame(y, sps, j, kind, w):
    lo = j - L * sps
    if lo < 0 or j + (192 + L) * sps > y.size:
        return None
    seg = y[lo:j + (192 + L) * sps:sps]
    if seg.size < 192 + 2 * L:
        return None
    sync = m17.SYNC_SYMS[kind]
    obs = seg[L:L + 8]
    A = np.vstack([sync, np.ones(8)]).T
    g, off = np.linalg.lstsq(A, obs, rcond=None)[0]
    if abs(g) < 1e-6:
        return None
    z = (seg - off) / g
    eq = np.array([np.dot(w, z[i:i + 2 * L + 1][::-1]) for i in range(192)])
    return eq


def decode_wav(path, w):
    y, sps = m17.demod(SIGN * loud(pcm(path)), FS)
    frames = m17.find_frames(y, sps, thresh=0.85)
    lsf_ok = lsf_n = g0 = ns = 0
    rows = []
    for start, kind, score, j in frames:
        eq = equalise_frame(y, sps, j, kind, w)
        if eq is None:
            continue
        if kind == "lsf":
            b, ok = m17.decode_lsf(eq[8:])
            lsf_n += 1
            lsf_ok += int(ok)
            src = m17.decode_callsign(b[6:12])
            dst = m17.decode_callsign(b[0:6])
            rows.append({"kind": "lsf", "crc": bool(ok), "src": src, "dst": dst, "score": float(score)})
        else:
            fn, payload, lich, lerr = m17.decode_stream(eq[8:])
            ns += 1
            g0 += int(lerr == 0)
            rows.append({"kind": "str", "fn": int(fn), "golay": int(lerr), "payload": payload.hex(), "score": float(score)})
    return {"lsf_crc": lsf_ok, "lsf": lsf_n, "golay0": g0, "stream": ns, "rows": rows}


def main():
    train_path = Path(sys.argv[1])
    w, nframes, sps = train(train_path)
    TAPS.parent.mkdir(parents=True, exist_ok=True)
    TAPS.write_text(json.dumps({"L": L, "sign": SIGN, "taps": [float(v) for v in w],
                                "train": str(train_path), "frames": nframes}), encoding="utf-8")
    print("trained", nframes, "frames taps", " ".join("%+.3f" % v for v in w[::-1]))
    for f in sys.argv[2:]:
        d = decode_wav(f, w)
        print("%s LSF %d/%d Golay0 %d/%d" % (Path(f).name, d["lsf_crc"], d["lsf"], d["golay0"], d["stream"]))


if __name__ == "__main__":
    main()
