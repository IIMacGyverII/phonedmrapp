"""Blind POCSAG decode of a radio recording with a frozen equalizer (eq*.npy from dfe3.py): no reference bits.
Searches sampling phase and polarity, runs FF+DFE over the whole recording, finds sync words, corrects codewords
(BCH(31,21)+parity, up to 2 bits), prints the pages.   usage: blind.py rx.wav eq.npy"""
import sys, wave, numpy as np
sys.path.insert(0, '..')
import pocsag as pc

w = wave.open(sys.argv[1]); x = np.frombuffer(w.readframes(w.getnframes()), dtype='<i2').astype(float); fr = w.getframerate()
e = np.load(sys.argv[2]); F, L, NL = int(e[0]), int(e[1]), int(e[2]); wv = e[3:]; n0 = 2 * F + 1; NF = {0: n0, 1: 2 * n0, 2: 4 * n0, 3: 5 * n0 - 1}[NL]; ff, fb = wv[:NF], wv[NF:]

def _sigrms(v, fs):
    """RMS over the stretches where a signal is present (envelope above half its high percentile): AGC for the equalizer."""
    n = int(fs * 0.05); env = np.sqrt(np.convolve(v * v, np.ones(n) / n, 'same')); hi = np.percentile(env, 95)
    return float(np.sqrt(np.mean(v[env > 0.5 * hi] ** 2)))
up = 6; y48 = np.interp(np.arange(len(x) * up) / up, np.arange(len(x)), x); spb = fr * up / 1200.0
y48 = y48 / _sigrms(y48, fr * up) * 10000.0

def corr(cw):
    if pc.check(cw): return cw, 0
    for i1 in range(32):
        if pc.check(cw ^ (1 << i1)): return cw ^ (1 << i1), 1
    for i1 in range(32):
        for i2 in range(i1 + 1, 32):
            if pc.check(cw ^ (1 << i1) ^ (1 << i2)): return cw ^ (1 << i1) ^ (1 << i2), 2
    return None, 3

def run(pol, ph):
    K = int((len(y48) - ph) / spb) - 1
    X = np.zeros((K, 2 * F + 1))
    for m in range(-F, F + 1):
        idx = (np.arange(K) * spb + ph + m * spb / 2).astype(int); ok = (idx >= 0) & (idx < len(y48)); X[ok, m + F] = pol * y48[idx[ok]] / 10000.0
    dec = np.zeros(K, int); past = np.zeros(L)
    for k in range(K):
        z = X[k] @ ff - past @ fb
        d = 1 if z > 0 else 0; dec[k] = d
        past = np.roll(past, 1); past[0] = 2 * d - 1
    return dec

def decode(bits):
    pages = []; p = 0; good = 0; n = len(bits); cur = None
    while p + 32 <= n:
        v = 0
        for b in bits[p:p + 32]: v = (v << 1) | int(b)
        if bin(v ^ pc.SYNC).count('1') <= 2:
            q = p + 32
            for k in range(16):
                if q + 32 > n: break
                c = 0
                for b in bits[q:q + 32]: c = (c << 1) | int(b)
                c2, err = corr(c); q += 32
                if c2 is None: cur = None; continue
                good += 1
                if c2 == pc.IDLE: cur = None; continue
                if (c2 >> 31) == 0: cur = {'ric': (((c2 >> 13) & 0x3FFFF) << 3) | (k // 2), 'func': (c2 >> 11) & 3, 'bits': [], 'fixed': err}; pages.append(cur)
                elif cur is not None: cur['bits'] += [((c2 >> 11) >> (19 - t)) & 1 for t in range(20)]; cur['fixed'] += err
            p = q
        else: p += 1
    for pg in pages:
        b = pg['bits']; pg['text'] = ''.join(chr(sum(b[t + u] << u for u in range(7))) for t in range(0, len(b) - 6, 7)).rstrip(chr(0))
    return good, pages

best = None
for pol in (1, -1):
    for ph in np.linspace(0, spb, 16, endpoint=False):
        good, pages = decode(run(pol, ph))
        if best is None or good > best[0]: best = (good, pol, ph, pages)
good, pol, ph, pages = best
print("best: polarity %+d, phase %.1f/%.1f, valid codewords %d" % (pol, ph, spb, good))
for pg in pages: print("  page RIC %d func %d: %r (%d bits corrected)" % (pg['ric'], pg['func'], pg['text'], pg['fixed']))
