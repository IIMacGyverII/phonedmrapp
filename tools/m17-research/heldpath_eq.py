"""Fixed linear equaliser for the held receive path (AT1846S 0x58 = 0xBCFD, op 6 variant 3), 2026-10-24.

The held phone path is linear (symbol means at +-1.00/+-3.01, no cubic term) but carries a long linear distortion
(a ~9 dB dip around 400-600 Hz and the low-end group delay of the AC coupling): plain slicing gives ~19 % symbol
errors. A +-L-symbol feed-forward equaliser at symbol rate, fitted by least squares on one recording of a known
transmission, decodes other recordings at zero symbol errors (R-E clips: LSF CRC 13/13, Golay 0 25/25).

usage: python heldpath_eq.py <train.wav> <test.wav>... [--sign +1|-1] [--taps L]
  The recordings are DIAG `rxclip` 8 kHz mono of the HackRF loop used in R-D/R-E (LSF N0CALL->@ALL, stream frames
  0 and 1 with payloads 16 x 0x00 and bytes 0..15); --sign -1 (default) is the phone path's polarity.
  Prints raw and equalised symbol error rates, LSF CRCs and Golay-0 frame counts per recording and the tap vector.
"""
import sys
from pathlib import Path
import numpy as np
import m17

FS = 8000.0
args = [a for a in sys.argv[1:] if not a.startswith('--')]
sign = -1.0; L = 20
for i, a in enumerate(sys.argv):
    if a == '--sign': sign = float(sys.argv[i + 1])
    if a == '--taps': L = int(sys.argv[i + 1])

lsf = m17.lsf_bytes("N0CALL", "@ALL")
KNOWN = [np.array(list(m17.encode_lsf(lsf)), float),
         np.array(list(m17.encode_stream(lsf, 0, bytes(16), 0)), float),
         np.array(list(m17.encode_stream(lsf, 1, bytes(range(16)), 1)), float)]
LV = np.array([-3, -1, 1, 3], float)

def pcm(p):
    blob = p.read_bytes(); i = blob.find(b"data"); n = int.from_bytes(blob[i + 4:i + 8], "little")
    return np.frombuffer(blob[i + 8:i + 8 + n], dtype="<i2").astype(np.float64)

def loud(x):
    """Skip the module's squelch mute at the start of a clip (plus 0.25 s of the unmute edge)."""
    w = 400; r = np.array([np.sqrt(np.mean((x[i:i + w] - x[i:i + w].mean()) ** 2)) for i in range(0, x.size - w, 80)])
    on = np.flatnonzero(r > 800); i0 = on[0] * 80 + int(0.25 * FS) if on.size else 0
    x = x[i0:]; return x - x.mean()

def frames(path):
    """Per frame found by the sync search: the 192 + 2L symbol-rate samples around it, the known symbols, the kind."""
    y, sps = m17.demod(sign * loud(pcm(path)), FS)
    out = []
    for start, kind, score, j in m17.find_frames(y, sps, thresh=0.85):
        lo = j - L * sps
        if lo < 0 or j + (192 + L) * sps > y.size: continue
        seg = y[lo:j + (192 + L) * sps:sps]; core = seg[L:L + 192]
        c = [np.dot(core, k) / (np.linalg.norm(core) * np.linalg.norm(k)) for k in KNOWN]
        if max(c) < 0.5: continue
        out.append((seg, KNOWN[int(np.argmax(c))], kind))
    return out

def gain_offset(fr):
    S = np.concatenate([s[L:L + 192] for s, k, _ in fr]); K = np.concatenate([k for s, k, _ in fr])
    return np.linalg.lstsq(np.vstack([K, np.ones_like(K)]).T, S, rcond=None)[0]

def slice_err(z, k): return int((LV[np.argmin(np.abs(z[:, None] - LV), 1)] != k).sum())

train = frames(Path(args[0])); g, off = gain_offset(train)
rows, tgt = [], []
for seg, k, _ in train:
    z = (seg - off) / g
    for n in range(192): rows.append(z[n:n + 2 * L + 1][::-1]); tgt.append(k[n])
w = np.linalg.lstsq(np.array(rows), np.array(tgt), rcond=None)[0]
print("trained on %s: %d frames, %d taps (k = -%d..+%d)" % (Path(args[0]).name, len(train), w.size, L, L))
print("taps:", " ".join("%+.3f" % v for v in w[::-1]))

for f in args:
    fr = frames(Path(f)); g, off = gain_offset(fr)
    e_raw = e_eq = n = crc = nl = g0 = ns = 0; fns = []
    for seg, k, kind in fr:
        z = (seg - off) / g; raw = z[L:L + 192]
        eq = np.array([np.dot(w, z[i:i + 2 * L + 1][::-1]) for i in range(192)])
        e_raw += slice_err(raw, k); e_eq += slice_err(eq, k); n += 192
        if kind == 'lsf':
            b, ok = m17.decode_lsf(eq[8:]); nl += 1; crc += ok
        else:
            fn, p, lich, lerr = m17.decode_stream(eq[8:]); ns += 1; g0 += (lerr == 0); fns.append(int(fn))
    print("%-24s frames %2d  symbol errors raw %.3f -> equalised %.4f | LSF CRC %d/%d  Golay-0 frames %d/%d  fn %s" % (
        Path(f).name, len(fr), e_raw / max(n, 1), e_eq / max(n, 1), crc, nl, g0, ns, fns[:8]))
