"""Blind POCSAG decode, two passes: pass 1 with the frozen per-phone equalizer; then everything the code itself makes
certain (preamble, sync words, idle words, codewords that check or are corrected) becomes training data for an
equalizer fitted to THIS reception; pass 2 decodes with it.  usage: blind2.py rx.wav eq.npy [ric msg]  (ric/msg only
to score bit errors)"""
import sys, numpy as np
argv = sys.argv[:]
sys.argv = ['blind.py', argv[1], argv[2]]
exec(open('blind.py', encoding='utf-8').read().split('best = None')[0])

def feats(pol, ph):
    K = int((len(y48) - ph) / spb) - 1
    X = np.zeros((K, 2 * F + 1))
    for m in range(-F, F + 1):
        idx = (np.arange(K) * spb + ph + m * spb / 2).astype(int); ok = (idx >= 0) & (idx < len(y48)); X[ok, m + F] = pol * y48[idx[ok]] / 10000.0
    return X

def dfe_run(X, ff, fb):
    K = len(X); Lf = len(fb); dec = np.zeros(K, int); past = np.zeros(Lf)
    for k in range(K):
        d = 1 if X[k] @ ff - past @ fb > 0 else 0; dec[k] = d; past = np.roll(past, 1); past[0] = 2 * d - 1
    return dec

def certain(bits):
    """Bits the code makes certain: preamble before each sync, sync words, checked/corrected codewords. -1 = unknown."""
    n = len(bits); known = -np.ones(n, int); p = 0; good = 0
    while p + 32 <= n:
        v = 0
        for b in bits[p:p + 32]: v = (v << 1) | int(b)
        if bin(v ^ pc.SYNC).count('1') <= 2:
            for t in range(32): known[p + t] = (pc.SYNC >> (31 - t)) & 1
            if p >= 64 and known[p - 1] < 0:                                   # a preamble (1010...) ends with 0 right before the first sync
                pre_ok = sum(1 for t in range(1, 65) if bits[p - t] == (0 if t % 2 == 1 else 1)) >= 56
                if pre_ok:
                    t = 1
                    while p - t >= 0 and t <= 576: known[p - t] = 0 if t % 2 == 1 else 1; t += 1
            q = p + 32
            for k in range(16):
                if q + 32 > n: break
                c = 0
                for b in bits[q:q + 32]: c = (c << 1) | int(b)
                c2, err = corr(c)
                if c2 is not None:
                    good += 1
                    for t in range(32): known[q + t] = (c2 >> (31 - t)) & 1
                q += 32
            p = q
        else: p += 1
    return known, good

def fit(X, known, Lf):
    sym = 2.0 * known - 1; K = len(X)
    rows = [k for k in range(Lf, K) if known[k] >= 0 and (known[k - Lf:k] >= 0).all()]
    if len(rows) < 400: return None
    A = np.array([np.concatenate([X[k], -sym[k - Lf:k][::-1]]) for k in rows])
    lam = float(__import__('os').environ.get('LAM', '50')); w0 = np.concatenate([ff, fb])          # stay near the per-phone equalizer
    w = np.linalg.solve(A.T @ A + lam * np.eye(A.shape[1]), A.T @ sym[rows] + lam * w0)
    return w[:X.shape[1]], w[X.shape[1]:], len(rows)

best = None
for pol in (1, -1):
    for ph in np.linspace(0, spb, 16, endpoint=False):
        X = feats(pol, ph); d = dfe_run(X, ff, fb); kn, good = certain(d)
        if best is None or good > best[0]: best = (good, pol, ph, X, d, kn)
good1, pol, ph, X, d1, kn = best
print("pass 1 (frozen per-phone equalizer): %d valid codewords" % good1)
r = fit(X, kn, L)
d2 = d1
if r:
    ff2, fb2, nrows = r; d2 = dfe_run(X, ff2, fb2); kn2, good2 = certain(d2)
    print("pass 2 (fitted to this reception on %d certain bits): %d valid codewords" % (nrows, good2))
_, pages = decode(d2)
for pg in pages: print("  page RIC %d func %d: %r (%d bits corrected)" % (pg['ric'], pg['func'], pg['text'], pg['fixed']))
if len(argv) > 4:
    ref = np.array(pc.transmission(int(argv[3]), 3, argv[4]))
    for name, d in (('pass 1', d1), ('pass 2', d2)):
        c = np.correlate((2 * d - 1).astype(float), (2 * ref - 1).astype(float), 'valid')
        sts = sorted(np.argsort(-np.abs(c))[:40]); picks = []
        for st in np.argsort(-np.abs(c)):
            if all(abs(st - q) > len(ref) // 2 for q in picks): picks.append(int(st))
            if len(picks) == 3: break
        errs = [min(int((d[st:st + len(ref)] != ref).sum()), int((d[st:st + len(ref)] == ref).sum())) for st in sorted(picks)]
        print("  %s bit errors per transmission:" % name, errs)
