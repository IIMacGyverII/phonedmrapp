"""Sounding 2 (four M17 transmissions, own seeds): align, train a DFE on one, test decision-fed on the others with the
full M17 decode.  usage: eq2.py <rx.wav> <train part> [L] [FB] [NL 0|1|2]"""
import sys, json, wave, numpy as np, m17
w = wave.open(sys.argv[1]); rx = np.frombuffer(w.readframes(w.getnframes()), '<i2').astype(float)
trn = sys.argv[2]; L = int(sys.argv[3]) if len(sys.argv) > 3 else 8; FB = int(sys.argv[4]) if len(sys.argv) > 4 else 24; NL = int(sys.argv[5]) if len(sys.argv) > 5 else 0
d48 = np.load('sounding2_dev.npy'); parts = json.load(open('sounding2_parts.json'))['parts']
k = np.sinc(np.arange(-120, 121) * 7200 / 48000) * np.blackman(241); k /= k.sum(); tx8 = np.convolve(d48, k, 'same')[::6]
env = lambda x: np.convolve(np.abs(x), np.ones(80) / 80, 'same')
c = np.correlate(env(rx) - env(rx).mean(), env(tx8) - env(tx8).mean(), 'full'); lag0 = int(np.argmax(c)) - (len(tx8) - 1)
best = (0, 0)
for lag in range(lag0 - 40, lag0 + 41):
    a = rx[max(0, lag):]; b = tx8[max(0, -lag):]; n = min(len(a), len(b)); r = np.dot(a[:n], b[:n]) / (np.linalg.norm(a[:n]) * np.linalg.norm(b[:n]) + 1e-9)
    if abs(r) > abs(best[0]): best = (r, lag)
lag = best[1]; rxa = np.sign(best[0]) * np.r_[rx, np.zeros(len(tx8))][lag:lag + len(tx8)] if lag >= 0 else np.sign(best[0]) * np.r_[np.zeros(-lag), rx][:len(tx8)]
seeds = {'a100': 1, 'b100': 2, 'c80': 3, 'd100': 4}
lev = np.array([-3, -1, 1, 3])
def data(name):
    rng = np.random.RandomState(seeds[name]); pay = [bytes(rng.randint(0, 256, 16, dtype=np.uint8)) for _ in range(100)]
    syms, _ = m17.transmission('N0CALL', '@ALL', pay); syms = np.asarray(syms)
    s0 = int(parts[name] * 8000) - 800; n8 = int(len(syms) / 4800 * 8000) + 1600; seg = rxa[s0:s0 + n8]
    F = np.fft.rfft(seg); up = np.fft.irfft(np.r_[F, np.zeros(len(seg) * 6 // 2 + 1 - len(F))], len(seg) * 6) * 6
    up = up / np.std(up[4800:4800 + len(syms) * 10])
    return syms, pay, up
def taps(up, dly, n): idx = 4800 + dly + np.arange(n) * 10; return np.stack([up[idx + 5 * m] for m in range(-L, L + 1)], 1)
def nl(X): return [X] + ([X ** 3] if NL >= 1 else []) + ([np.abs(X) * X, X ** 5] if NL >= 2 else [])
def train_set(names):
    rows = []; ys_ = []; ref = None
    for nm in names:
        sy, _, u = data(nm); best_e = None
        for dly in (range(-20, 41, 2) if ref is None else range(ref - 10, ref + 11)):   # one timing reference for all
            X = taps(u, dly, len(sy)); P = np.stack([np.r_[np.zeros(j), sy[:-j]] for j in range(1, FB + 1)], 1)
            A = np.concatenate(nl(X) + [P, np.ones((len(sy), 1))], 1); c1, *_ = np.linalg.lstsq(A, sy, rcond=None); e = np.mean((A @ c1 - sy) ** 2)
            if best_e is None or e < best_e[0]: best_e = (e, A, dly)
        rows.append(best_e[1]); ys_.append(sy)
        if ref is None: ref = best_e[2]
    A = np.concatenate(rows); Y = np.concatenate(ys_); c1, *_ = np.linalg.lstsq(A, Y, rcond=None)
    return c1, float(np.mean((A @ c1 - Y) ** 2))
tests = list(seeds) if trn == 'loo' else [t for t in seeds if t not in trn.split(',')]
print('aligned (corr %.2f), L=%d FB=%d NL=%d' % (abs(best[0]), L, FB, NL))
for te in tests:
    cf, mse = train_set([t for t in seeds if t != te] if trn == 'loo' else trn.split(','))
    syms, pay, up = data(te); n = len(syms)
    # timing tracking: each 192-symbol frame chooses the sampling offset (48 kHz steps) with the cleanest decisions,
    # starting from a coarse search over the preamble; the DFE history carries over
    cands = range(-30, 51)
    def run(F2, k0, k1, past):
        ys = np.zeros(k1 - k0); err = 0.0; past = list(past)
        for kk in range(k0, k1):
            y = np.concatenate([F2[kk], past, [1.0]]) @ cf; d = float(lev[np.argmin(np.abs(lev - y))]); ys[kk - k0] = y; err += (y - d) ** 2; past = [d] + past[:-1]
        return ys, err, past
    feats = {}
    def F(d):
        if d not in feats: feats[d] = np.concatenate(nl(taps(up, d, n)), 1)
        return feats[d]
    known = [float(v) for v in syms[:192][::-1][:FB]]                  # the preamble is known: it seeds the DFE
    cur = min(cands, key=lambda d: run(F(d), 192, 384, known)[1])
    ys = np.zeros(n); ys[:192] = syms[:192]; past = known; k = 192
    while k < n:
        k1 = min(n, k + 192)
        best_r = min((run(F(d), k, k1, past) + (d,) for d in (cur - 2, cur - 1, cur, cur + 1, cur + 2)), key=lambda r: r[1])
        ys[k:k1] = best_r[0]; past = best_r[2]; cur = best_r[3]; k = k1
    ser = np.mean(lev[np.argmin(np.abs(ys[:, None] - lev[None, :]), 1)] != syms)
    lb, lok = m17.decode_lsf(ys[200:384]); good = 0
    for i in range(100):
        s = 384 + 192 * i; fn, p, lich, le = m17.decode_stream(ys[s + 8:s + 192]); good += (fn & 0x7FFF) == i and p == pay[i]
    print('  train %s -> test %s (fit MSE %.3f):' % ('all others' if trn == 'loo' else trn, te, mse), end=''); print(' symbol errors %5.2f %%, LSF %s, stream frames exact %3d of 100' % (100 * ser, 'ok' if lok else 'BAD', good))
