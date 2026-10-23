"""Train a DFE on one received M17 transmission (known symbols), apply it to another (decision-fed, no reference),
then run the M17 decoder: LSF CRC and how many of the 100 stream payloads come out exact.
usage: eqdecode.py <train part> <test part> [FF L] [FB]"""
import sys, json, numpy as np, m17
tr, te = sys.argv[1], sys.argv[2]; L = int(sys.argv[3]) if len(sys.argv) > 3 else 8; FB = int(sys.argv[4]) if len(sys.argv) > 4 else 24
rxa = np.load('rx_aligned.npy'); parts = json.load(open('sounding_parts.json'))['parts']
rng = np.random.RandomState(1); pay = [bytes(rng.randint(0, 256, 16, dtype=np.uint8)) for _ in range(100)]
syms, _ = m17.transmission('N0CALL', '@ALL', pay); syms = np.asarray(syms)
lev = np.array([-3, -1, 1, 3])

def upsampled(name):
    s0 = int(parts[name] * 8000) - 800; n8 = int(len(syms) / 4800 * 8000) + 1600; seg = rxa[s0:s0 + n8]
    F = np.fft.rfft(seg); up = np.fft.irfft(np.r_[F, np.zeros(len(seg) * 6 // 2 + 1 - len(F))], len(seg) * 6) * 6
    return up / np.std(up)

def taps(up, dly):
    idx = 800 * 6 + dly + np.arange(len(syms)) * 10
    return np.stack([up[idx + 5 * m] for m in range(-L, L + 1)], 1)

# train (delay search as in eq.py)
up = upsampled(tr); best = None
for dly in range(-20, 41, 2):
    X = taps(up, dly); P = np.stack([np.r_[np.zeros(j), syms[:-j]] for j in range(1, FB + 1)], 1)
    A = np.c_[X, P, np.ones(len(syms))]; c, *_ = np.linalg.lstsq(A, syms, rcond=None); e = np.mean((A @ c - syms) ** 2)
    if best is None or e < best[0]: best = (e, dly, c)
_, dly, c = best
# apply to the test transmission with its own decisions, timing searched over +-1 half-symbol (the same radio: same delay)
up2 = upsampled(te); X2 = taps(up2, dly)
past = [0.0] * FB; ys = np.zeros(len(syms))
for k in range(len(syms)):
    y = np.concatenate([X2[k], past, [1.0]]) @ c; ys[k] = y
    past = [float(lev[np.argmin(np.abs(lev - y))])] + past[:-1]
ser = np.mean(lev[np.argmin(np.abs(ys[:, None] - lev[None, :]), 1)] != syms)
# M17 decode from the equalized symbols: preamble 192, LSF frame, then 100 stream frames
lsf_b, lsf_ok = m17.decode_lsf(ys[192 + 8:192 + 192])
good = 0; lich_e = []
for i in range(100):
    s = 384 + 192 * i
    fn, p, lich, le = m17.decode_stream(ys[s + 8:s + 192]); lich_e.append(le)
    good += (fn & 0x7FFF) == i and p == pay[i]
print('train %s -> test %s (L=%d FB=%d): symbol errors %.2f %%, LSF %s (%s -> %s), stream frames exact %d of 100, LICH bit errors mean %.2f'
      % (tr, te, L, FB, 100 * ser, 'ok' if lsf_ok else 'BAD', m17.decode_callsign(lsf_b[6:12]), m17.decode_callsign(lsf_b[0:6]), good, np.mean(lich_e)))
