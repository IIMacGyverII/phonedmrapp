"""Honest test: fractionally spaced feed-forward + decision feedback equalizer trained on the first transmitted page

only, frozen (optionally LMS-adapted on its own decisions), judged on the later pages; then POCSAG decode with

BCH(31,21) correction (up to 2 bit errors per codeword).  usage: dfe3.py rx.wav tx.wav [--lms]"""

import sys, wave, numpy as np

sys.path.insert(0, '..')

import pocsag as pc



def load(p):

    w = wave.open(p); x = np.frombuffer(w.readframes(w.getnframes()), dtype='<i2').astype(float)

    return (x[::2] if w.getnchannels() == 2 else x), w.getframerate()



rx, fr = load(sys.argv[1]); tx, ft = load(sys.argv[2]); LMS = '--lms' in sys.argv

BAUD = 1200; spb_t = ft / BAUD; nb = int(len(tx) / spb_t)

cent = [(k + 0.5) * spb_t for k in range(nb)]

tbits = np.array([1 if tx[int(c)] < 0 else 0 for c in cent]); active = np.array([abs(tx[int(c)]) > 100 for c in cent])   # POCSAG: a 1 is the lower frequency (negative)

# transmissions = runs of active bits

runs = []; k = 0

while k < nb:

    if active[k]:

        j = k

        while j < nb and active[j]: j += 1

        runs.append((k, j)); k = j

    else: k += 1

TXLEN = len(pc.transmission(1234567, 3, 'DAPNET BENCH TEST 123'))

if len(runs) == 1:

    a1, z1 = runs[0]; runs = [(a1 + i * TXLEN, min(z1, a1 + (i + 1) * TXLEN)) for i in range((z1 - a1 + TXLEN - 1) // TXLEN)]


def _sigrms(v, fs):
    """RMS over the stretches where a signal is present (envelope above half its high percentile): AGC for the equalizer."""
    n = int(fs * 0.05); env = np.sqrt(np.convolve(v * v, np.ones(n) / n, 'same')); hi = np.percentile(env, 95)
    return float(np.sqrt(np.mean(v[env > 0.5 * hi] ** 2)))
up = 6; rx48 = np.interp(np.arange(len(rx) * up) / up, np.arange(len(rx)), rx); fs = fr * up; spb = fs / BAUD
rx48 = rx48 / _sigrms(rx48, fs) * 10000.0

ref = tx - tx.mean(); r = rx48 - rx48.mean(); N = 1 << int(np.ceil(np.log2(len(r) + len(ref))))

lag0 = int(np.argmax(np.abs(np.fft.irfft(np.fft.rfft(r, N) * np.conj(np.fft.rfft(ref, N)))[:len(r)])))



F, L = int(__import__('os').environ.get('FF','5')), int(__import__('os').environ.get('FB','120'))          # feed-forward taps each side at T/2 spacing, feedback length in bits

def feats(y, ph, K):

    out = np.zeros((K, 2 * F + 1))

    for m in range(-F, F + 1):

        idx = (np.arange(K) * spb + ph + m * spb / 2).astype(int); ok = (idx >= 0) & (idx < len(y))

        out[ok, m + F] = y[idx[ok]]

    out = out / 10000.0
    nl = __import__('os').environ.get('NL', '')
    if nl:
        parts = [out, out ** 3]
        if nl in ('2', '3'): parts += [out * np.abs(out), out ** 5]
        if nl == '3': parts += [out[:, :-1] * out[:, 1:]]
        out = np.concatenate(parts, axis=1)
    return out



def train(y, ph, K, a, z):

    sym = 2.0 * tbits - 1; X = feats(y, ph, K)

    rows = [k for k in range(max(a, L), min(z, K))]

    A = np.array([np.concatenate([X[k], -sym[k - L:k][::-1]]) for k in rows]); w = np.linalg.lstsq(A, sym[rows], rcond=None)[0]

    res = sym[rows] - A @ w

    return w, np.var(res), X



# alignment search over lag (±2 bits) and phase, training on the first transmission

a0, z0 = runs[0][0], runs[int(__import__('os').environ.get('TRAIN','1')) - 1][1]

print('transmissions:', len(runs))

best = None

for dl in range(-2, 3):

    lag = lag0 + int(round(dl * spb)); y = rx48[lag:]; K = min(nb, int((len(y)) / spb) - 2)

    for ph in np.linspace(0, spb, 8, endpoint=False):

        for pol in (1, -1):

            w, e, X = train(pol * y, ph, K, a0, z0)

            if best is None or e < best[0]: best = (e, lag, ph, pol, w, K)

e, lag, ph, pol, w, K = best

y = pol * rx48[lag:]; X = feats(y, ph, K)

print("trained on transmission 1 (%d bits): residual %.3f; lag %.3f s" % (z0 - a0, e, lag / fs))

NF = X.shape[1]; ff, fb = w[:NF].copy(), w[NF:].copy()
import os
if os.environ.get('SAVE'): np.save(os.environ['SAVE'], np.concatenate([[F, L, int(os.environ.get('NL') or 0)], w])); print('saved', os.environ['SAVE'])

dec = np.zeros(K, int); mu = 0.002

for k in range(K):

    src = tbits if __import__('os').environ.get('GENIE') else dec
    past = np.array([2 * src[k - j] - 1 if k - j >= 0 else 0 for j in range(1, L + 1)])

    zk = X[k] @ ff - past @ fb

    dec[k] = 1 if zk > 0 else 0

    if k < z0: dec[k] = tbits[k]                                        # training region: known

    elif LMS and active[k]:

        err = (2 * dec[k] - 1) - zk; ff += mu * err * X[k]; fb -= mu * err * past

for i, (a, z) in enumerate(runs):

    zz = min(z, K); errs = int((dec[a:zz] != tbits[a:zz]).sum())

    bits = list(dec[a:zz]); cws = ok = fixed = 0; words = []

    def corr(cw):

        if pc.check(cw): return cw, 0

        for i1 in range(32):

            c1 = cw ^ (1 << i1)

            if pc.check(c1): return c1, 1

        for i1 in range(32):

            for i2 in range(i1 + 1, 32):

                c2 = cw ^ (1 << i1) ^ (1 << i2)

                if pc.check(c2): return c2, 2

        return None, 3

    p = 0

    while p + 32 <= len(bits):

        wv = 0

        for bb in bits[p:p + 32]: wv = (wv << 1) | bb

        if bin(wv ^ pc.SYNC).count('1') <= 2:

            q = p + 32

            for n in range(16):

                if q + 32 > len(bits): break

                cw = 0

                for bb in bits[q:q + 32]: cw = (cw << 1) | bb

                c2, e2 = corr(cw); cws += 1

                if e2 == 0: ok += 1

                elif e2 <= 2: fixed += 1

                words.append(c2); q += 32

            p = q

        else: p += 1

    errpos = [int(x) - a for x in np.nonzero(dec[a:zz] != tbits[a:zz])[0] + a]
    if i > 0: print('   error bit positions in the page:', errpos[:20], '| lost codeword slots:', [n for n, c in enumerate(words) if c is None])
    lost = any(c is None for c in words)
    mb = []; addr = None

    for c in words:

        if c is None or c == pc.IDLE: continue

        if (c >> 31) == 0: addr = (((c >> 13) & 0x3FFFF) << 3)

        else: mb += [((c >> 11) >> (19 - t)) & 1 for t in range(20)]

    txt = ''.join(chr(sum(mb[t + u] << u for u in range(7))) for t in range(0, len(mb) - 6, 7)).rstrip(chr(0))

    print("page %d%s: %4d bits, %3d bit errors (%.2f%%); codewords %d: %d clean, %d corrected, %d lost -> %s" % (i + 1, " (training)" if i == 0 else "", zz - a, errs, 100.0 * errs / max(1, zz - a), cws, ok, fixed, cws - ok - fixed, ("DECODED " + repr(txt)) if (not lost and "DAPNET BENCH TEST 123" in txt) else "not decoded"))

