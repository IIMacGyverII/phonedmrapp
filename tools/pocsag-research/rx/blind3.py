"""Blind POCSAG decode with error correction inside the feedback loop: the DFE decides a codeword's 32 bits, BCH
corrects them, and the corrected bits (not the raw decisions) are what the feedback filter subtracts afterwards,
so one bit error cannot spread into the following codewords.  usage: blind3.py rx.wav eq.npy [ric msg]"""
import sys, numpy as np
argv = sys.argv[:]
sys.argv = ['blind.py', argv[1], argv[2]]
exec(open('blind.py', encoding='utf-8').read().split('best = None')[0])

def feats(pol, ph):
    K = int((len(y48) - ph) / spb) - 1
    X = np.zeros((K, 2 * F + 1))
    for m in range(-F, F + 1):
        idx = (np.arange(K) * spb + ph + m * spb / 2).astype(int); ok = (idx >= 0) & (idx < len(y48)); X[ok, m + F] = pol * y48[idx[ok]] / 10000.0
    if not NL: return X
    parts = [X, X ** 3]
    if NL in (2, 3): parts += [X * np.abs(X), X ** 5]
    if NL == 3: parts += [X[:, :-1] * X[:, 1:]]
    return np.concatenate(parts, axis=1)

def word(bits, p):
    v = 0
    for b in bits[p:p + 32]: v = (v << 1) | int(b)
    return v

def ecc_dfe(X):
    """DFE whose feedback history is rewritten with corrected bits whenever a sync word or codeword is recognised."""
    K = len(X); dec = np.zeros(K, int); hist = np.zeros(K)          # hist: the symbols the feedback filter sees
    Lf = len(fb); nxt = -1; batch_end = -1; good = 0; cws = []      # nxt: start of the next expected codeword
    for k in range(K):
        lo = max(0, k - Lf); past = hist[lo:k][::-1]
        z = X[k] @ ff - past @ fb[:len(past)]
        d = 1 if z > 0 else 0; dec[k] = d; hist[k] = 2 * d - 1
        if k >= 31:
            p = k - 31
            if p == nxt and p < batch_end:                            # a codeword just completed
                c2, err = corr(word(dec, p))
                if c2 is not None:
                    good += 1; cws.append((p, c2, err))
                    for t in range(32): b = (c2 >> (31 - t)) & 1; dec[p + t] = b; hist[p + t] = 2 * b - 1
                nxt = p + 32
            elif nxt < 0 or p >= batch_end:                           # looking for a sync word
                if bin(word(dec, p) ^ pc.SYNC).count('1') <= 2:
                    for t in range(32): b = (pc.SYNC >> (31 - t)) & 1; dec[p + t] = b; hist[p + t] = 2 * b - 1
                    nxt = p + 32; batch_end = p + 32 + 16 * 32
    return dec, good, cws

best = None
for pol in (1, -1):
    for ph in np.linspace(0, spb, 16, endpoint=False):
        X = feats(pol, ph); d, good, cws = ecc_dfe(X)
        if best is None or good > best[0]: best = (good, pol, ph, d, cws)
good, pol, ph, d, cws = best
print("valid codewords %d (polarity %+d, phase %.1f)" % (good, pol, ph))
bat = []; p = 0
while p + 32 <= len(d):
    if word(d, p) == pc.SYNC:
        bat.append([corr(word(d, p + 32 + 32 * k))[0] or 0 for k in range(16) if p + 32 + 32 * k + 32 <= len(d)]); p += 32 * 17
    else: p += 1
for ric, func, txt in pc.messages(bat): print("  page RIC %d func %d: %r" % (ric, func, txt[:90]))
if len(argv) > 4:
    ref = np.array(pc.transmission(int(argv[3]), 3, argv[4]))
    c = np.correlate((2 * d - 1).astype(float), (2 * ref - 1).astype(float), 'valid'); picks = []
    for st in np.argsort(-np.abs(c)):
        if all(abs(st - q) > len(ref) // 2 for q in picks): picks.append(int(st))
        if len(picks) == 3: break
    print("  bit errors per transmission after correction:", [int((d[st:st + len(ref)] != ref).sum()) for st in sorted(picks)])
