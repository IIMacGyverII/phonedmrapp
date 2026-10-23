"""Equalizer study on a received M17 transmission: symbol error rates for a linear equalizer and a decision-feedback
equalizer (DFE), trained by least squares on the first half of the known symbols, tested on the second half.
usage: eq.py <part name: m17_100 | m17_60 | m17_40> [FF half-symbol taps each side] [FB symbols] [nonlinear 0/1]"""
import sys, json, numpy as np, m17
name = sys.argv[1]; L = int(sys.argv[2]) if len(sys.argv) > 2 else 8; FB = int(sys.argv[3]) if len(sys.argv) > 3 else 0; NL = int(sys.argv[4]) if len(sys.argv) > 4 else 0
rxa = np.load('rx_aligned.npy'); meta = json.load(open('sounding_parts.json')); t0 = meta['parts'][name]
rng = np.random.RandomState(1); pay = [bytes(rng.randint(0, 256, 16, dtype=np.uint8)) for _ in range(100)]
syms, _ = m17.transmission('N0CALL', '@ALL', pay); syms = np.asarray(syms)
# the received segment, band-limited resampled to 48 kHz (10 samples per symbol)
s0 = int(t0 * 8000) - 800; n8 = int(len(syms) / 4800 * 8000) + 1600; seg = rxa[s0:s0 + n8]
F = np.fft.rfft(seg); up = np.fft.irfft(np.r_[F, np.zeros(len(seg) * 6 // 2 + 1 - len(F))], len(seg) * 6) * 6
off48 = 800 * 6                                                   # where the transmission starts in `up`
best = None
for dly in range(-20, 41, 2):                                       # find the overall delay (filters) by a quick linear fit
    idx = off48 + dly + np.arange(len(syms)) * 10
    if idx[-1] + 10 * L >= len(up): continue
    X = np.stack([up[idx + 5 * m] for m in range(-L, L + 1)], 1)
    h = len(syms) // 2; c, *_ = np.linalg.lstsq(np.c_[X[:h], np.ones(h)], syms[:h], rcond=None)
    e = np.mean((np.c_[X[h:], np.ones(len(syms) - h)] @ c - syms[h:]) ** 2)
    if best is None or e < best[0]: best = (e, dly)
dly = best[1]; idx = off48 + dly + np.arange(len(syms)) * 10
X = np.stack([up[idx + 5 * m] for m in range(-L, L + 1)], 1)
X = X / np.std(X)
def feats(Xr, past):
    cols = [Xr]
    if NL: cols += [Xr ** 3]
    if FB: cols.append(past)
    cols.append(np.ones((len(Xr), 1)))
    return np.concatenate(cols, 1)
P = np.stack([np.r_[np.zeros(j), syms[:-j]] for j in range(1, FB + 1)], 1) if FB else np.zeros((len(syms), 0))
h = len(syms) // 2
A = feats(X, P); c, *_ = np.linalg.lstsq(A[:h], syms[:h], rcond=None)
lev = np.array([-3, -1, 1, 3]); dec = lambda v: lev[np.argmin(np.abs(v[:, None] - lev[None, :]), 1)]
yg = A[h:] @ c                                                      # genie: true past symbols
ser_g = np.mean(dec(yg) != syms[h:]); mse_g = np.mean((yg - syms[h:]) ** 2)
out = 'L=%d FB=%d NL=%d delay %d: genie SER %.3f (MSE %.2f, SNR %.1f dB)' % (L, FB, NL, dly, ser_g, mse_g, 10 * np.log10(5 / mse_g))
if FB:                                                              # real DFE: own decisions fed back
    past = list(syms[h - FB:h][::-1]); errs = 0; ys = []
    for k in range(h, len(syms)):
        a = np.concatenate([X[k]] + ([X[k] ** 3] if NL else []) + [np.array(past[:FB]), [1.0]])
        y = a @ c; d = lev[np.argmin(np.abs(lev - y))]; ys.append(y)
        errs += d != syms[k]; past.insert(0, d)
    out += ', decision-fed SER %.3f' % (errs / (len(syms) - h))
print(out)
np.save('eq_%s.npy' % name, c)
