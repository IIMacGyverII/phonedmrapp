"""Is the phone's transmitted M17 recoverable by an equalizing receiver? DFE trained on one level of the captured
deviation (txdev48.npy, 48 kHz), tested decision-fed with timing tracking on the others, full M17 decode."""
import sys, json, numpy as np, m17
L, FB, NL = 8, 32, 2
da = np.load('txdev48.npy'); meta = json.load(open('tx_m17snd.json')); parts = meta['parts']
rng = np.random.RandomState(meta['seed']); pay = [bytes(rng.randint(0, 256, 16, dtype=np.uint8)) for _ in range(meta['frames'])]
syms, _ = m17.transmission('N0CALL', '@ALL', pay); syms = np.asarray(syms); n = len(syms)
lev = np.array([-3, -1, 1, 3])
k = np.sinc(np.arange(-64, 65) * 2 * 3600 / 48000) * np.blackman(129); k /= k.sum()
def seg(name):
    s0 = int(parts[name] * 48000) - 4800; x = np.convolve(da[s0:s0 + n * 10 + 9600], k, 'same')
    return x / np.std(x[4800:4800 + n * 10])
def taps(u, d): idx = 4800 + d + np.arange(n) * 10; return np.stack([u[idx + 5 * m] for m in range(-L, L + 1)], 1)
def nl(X): return [X] + ([X ** 3] if NL >= 1 else []) + ([np.abs(X) * X, X ** 5] if NL >= 2 else [])
names = ['m17_6000', 'm17_12000', 'm17_20000']
for trn in names:
    u = seg(trn); best = None
    for d in range(-30, 61, 2):
        X = taps(u, d); P = np.stack([np.r_[np.zeros(j), syms[:-j]] for j in range(1, FB + 1)], 1)
        A = np.concatenate(nl(X) + [P, np.ones((n, 1))], 1); c, *_ = np.linalg.lstsq(A, syms, rcond=None); e = np.mean((A @ c - syms) ** 2)
        if best is None or e < best[0]: best = (e, d, c)
    e, d0, c = best
    line = 'train %s (fit MSE %.3f):' % (trn, e)
    for te in names:
        if te == trn: continue
        u = seg(te); feats = {}
        def F(d):
            if d not in feats: feats[d] = np.concatenate(nl(taps(u, d)), 1)
            return feats[d]
        def run(F2, k0, k1, past):
            ys = np.zeros(k1 - k0); err = 0.0; past = list(past)
            for kk in range(k0, k1):
                y = np.concatenate([F2[kk], past, [1.0]]) @ c; dd = float(lev[np.argmin(np.abs(lev - y))]); ys[kk - k0] = y; err += (y - dd) ** 2; past = [dd] + past[:-1]
            return ys, err, past
        known = [float(v) for v in syms[:192][::-1][:FB]]
        cur = min(range(-30, 61), key=lambda dd: run(F(dd), 192, 384, known)[1])
        ys = np.zeros(n); ys[:192] = syms[:192]; past = known; kk = 192
        while kk < n:
            k1 = min(n, kk + 192); r = min((run(F(dd), kk, k1, past) + (dd,) for dd in (cur - 2, cur - 1, cur, cur + 1, cur + 2)), key=lambda r: r[1])
            ys[kk:k1] = r[0]; past = r[2]; cur = r[3]; kk = k1
        ser = np.mean(lev[np.argmin(np.abs(ys[:, None] - lev[None, :]), 1)] != syms)
        lb, lok = m17.decode_lsf(ys[200:384]); good = 0
        for i in range(len(pay)):
            s = 384 + 192 * i; fn, p, lich, le = m17.decode_stream(ys[s + 8:s + 192]); good += (fn & 0x7FFF) == i and p == pay[i]
        line += '  %s: SER %.2f %%, LSF %s, %d/%d' % (te, 100 * ser, 'ok' if lok else 'BAD', good, len(pay))
    print(line)
