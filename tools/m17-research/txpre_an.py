"""Pre-compensated transmit test: align the captured deviation with the intended M17 deviation, then (a) plain M17
decode, (b) genie fit of a DFE (how much is recoverable), (c) DFE trained on one level, decision-fed on the others."""
import json, numpy as np, m17
iq = np.fromfile('m17pre.iq', dtype=np.int8); FS = 2_400_000; OFF = 240_000; DEC = 50
z = iq[0::2].astype(np.float32) + 1j * iq[1::2].astype(np.float32); del iq
out = []
for s0 in range(0, len(z) - DEC, FS):
    seg = z[s0:s0 + FS]; m = len(seg) // DEC * DEC
    out.append((seg[:m] * np.exp((-2j * np.pi * OFF / FS) * np.arange(s0, s0 + m)).astype(np.complex64)).reshape(-1, DEC).mean(axis=1))
zd = np.concatenate(out); del z
k = np.sinc(np.arange(-64, 65) * 2 * 9000 / 48000) * np.blackman(129); k /= k.sum(); zd = np.convolve(zd, k, 'same')
dev = np.angle(zd[1:] * np.conj(zd[:-1])) * 48000 / (2 * np.pi)
pw = np.convolve(np.abs(zd) ** 2, np.ones(4800) / 4800, 'same'); on = pw > np.percentile(pw, 5) * 30; i0 = int(np.argmax(on)); dev = dev - np.median(dev[on[1:]])
meta = json.load(open('tx_m17pre.json')); parts = meta['parts']
rng = np.random.RandomState(meta['seed']); pay = [bytes(rng.randint(0, 256, 16, dtype=np.uint8)) for _ in range(meta['frames'])]
syms, _ = m17.transmission('N0CALL', '@ALL', pay); syms = np.asarray(syms); n = len(syms)
base = m17.deviation(syms, 48000)
lv = {'p1200': 0.5, 'p1800': 0.75, 'p2400': 1.0}
tgt = np.zeros(int((max(parts.values()) + 5) * 48000))
for nm, t0 in parts.items(): s0 = int(t0 * 48000); tgt[s0:s0 + len(base)] = base * lv[nm]
band = lambda x: np.fft.irfft(np.fft.rfft(x) * (lambda f: np.clip((f - 220) / 80, 0, 1) * np.clip((3000 - f) / 300, 0, 1))(np.fft.rfftfreq(len(x), 1 / 48000)), len(x))
tb = band(tgt)
env = lambda x: np.convolve(np.abs(x), np.ones(480) / 480, 'same')
a = env(dev[i0:i0 + len(tb) + 96000]); b = env(tb); c = np.correlate(a - a.mean(), b - b.mean(), 'full'); lag = int(np.argmax(c)) - (len(b) - 1) + i0
best = (0, lag)
for L in range(lag - 400, lag + 401, 2):
    x = dev[L:L + len(tb)]; nn = min(len(x), len(tb)); r = np.dot(x[:nn], tb[:nn]) / (np.linalg.norm(x[:nn]) * np.linalg.norm(tb[:nn]) + 1e-9)
    if abs(r) > abs(best[0]): best = (r, L)
r, lag = best; print('aligned: correlation with the intended (band-limited) deviation %.2f, polarity %+d' % (abs(r), np.sign(r)))
da = np.sign(r) * dev[lag:lag + len(tgt)]
lev = np.array([-3, -1, 1, 3]); L, FB = 8, 32
k2 = np.sinc(np.arange(-64, 65) * 2 * 3600 / 48000) * np.blackman(129); k2 /= k2.sum()
def seg(nm):
    s0 = int(parts[nm] * 48000) - 4800; x = da[s0:s0 + n * 10 + 9600]
    return x
def taps(u, d): idx = 4800 + d + np.arange(n) * 10; return np.stack([u[idx + 5 * m] for m in range(-L, L + 1)], 1)
nl = lambda X: [X, X ** 3, np.abs(X) * X]
fits = {}
for nm in parts:
    x = seg(nm); print('%s: peak deviation %.0f Hz (99.9 %% %.0f)' % (nm, np.abs(x).max(), np.percentile(np.abs(x), 99.9)), end='  ')
    rr = m17.decode_transmission(x[2400:], 48000, verbose=False); good = sum(1 for (fn, p, le) in rr['frames'] if (fn & 0x7FFF) < len(pay) and p == pay[fn & 0x7FFF])
    u = np.convolve(x, k2, 'same'); u = u / np.std(u[4800:4800 + n * 10]); bb = None
    for d in range(-30, 61, 2):
        X = taps(u, d); P = np.stack([np.r_[np.zeros(j), syms[:-j]] for j in range(1, FB + 1)], 1)
        A = np.concatenate(nl(X) + [P, np.ones((n, 1))], 1); cc, *_ = np.linalg.lstsq(A, syms, rcond=None); e = np.mean((A @ cc - syms) ** 2)
        if bb is None or e < bb[0]: bb = (e, d, cc)
    fits[nm] = (u, bb)
    print('plain decode: LSF %s, exact %d/%d;  DFE genie fit MSE %.3f (SER %.2f %%)' % (rr['lsf'], good, len(pay), bb[0], 100 * np.mean(lev[np.argmin(np.abs((np.concatenate(nl(taps(u, bb[1])) + [np.stack([np.r_[np.zeros(j), syms[:-j]] for j in range(1, FB + 1)], 1), np.ones((n, 1))], 1) @ bb[2])[:, None] - lev[None, :]), 1)] != syms)))
for trn in parts:
    c_ = fits[trn][1][2]; line = 'train %s:' % trn
    for te in parts:
        if te == trn: continue
        u = fits[te][0]; feats = {}
        def F(d):
            if d not in feats: feats[d] = np.concatenate(nl(taps(u, d)), 1)
            return feats[d]
        def run(F2, k0, k1, past):
            ys = np.zeros(k1 - k0); err = 0.0; past = list(past)
            for kk in range(k0, k1):
                y = np.concatenate([F2[kk], past, [1.0]]) @ c_; dd = float(lev[np.argmin(np.abs(lev - y))]); ys[kk - k0] = y; err += (y - dd) ** 2; past = [dd] + past[:-1]
            return ys, err, past
        known = [float(v) for v in syms[:192][::-1][:FB]]
        cur = min(range(-30, 61), key=lambda dd: run(F(dd), 192, 384, known)[1])
        ys = np.zeros(n); ys[:192] = syms[:192]; past = known; kk = 192
        while kk < n:
            k1 = min(n, kk + 192); rr = min((run(F(dd), kk, k1, past) + (dd,) for dd in (cur - 2, cur - 1, cur, cur + 1, cur + 2)), key=lambda r_: r_[1])
            ys[kk:k1] = rr[0]; past = rr[2]; cur = rr[3]; kk = k1
        ser = np.mean(lev[np.argmin(np.abs(ys[:, None] - lev[None, :]), 1)] != syms)
        lb, lok = m17.decode_lsf(ys[200:384]); good = 0
        for i in range(len(pay)):
            s = 384 + 192 * i; fn, p, lich, le = m17.decode_stream(ys[s + 8:s + 192]); good += (fn & 0x7FFF) == i and p == pay[i]
        line += '  %s: SER %.2f %%, LSF %s, %d/%d' % (te, 100 * ser, 'ok' if lok else 'BAD', good, len(pay))
    print(line)
