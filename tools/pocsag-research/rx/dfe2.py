"""POCSAG through the radio audio, take 2: proper alignment (channel fit with precursor room, realign on the main
tap), only transmitted bits scored. Compares plain / linear EQ / DFE.  usage: dfe2.py rx.wav tx.wav"""
import sys, wave, numpy as np

def load(p):
    w = wave.open(p); fs = w.getframerate(); x = np.frombuffer(w.readframes(w.getnframes()), dtype='<i2').astype(float)
    if w.getnchannels() == 2: x = x[::2]
    return x, fs

rx, fr = load(sys.argv[1]); tx, ft = load(sys.argv[2])
BAUD = 1200; spb_t = ft / BAUD; nb = int(len(tx) / spb_t)
cent = [(k + 0.5) * spb_t for k in range(nb)]
tbits = np.array([1 if tx[int(c)] > 0 else 0 for c in cent]); active = np.array([abs(tx[int(c)]) > 100 for c in cent])
up = 6; rx48 = np.interp(np.arange(len(rx) * up) / up, np.arange(len(rx)), rx); fs = fr * up; spb = fs / BAUD
ref = tx - tx.mean(); r = rx48 - rx48.mean()
N = 1 << int(np.ceil(np.log2(len(r) + len(ref))))
cc = np.fft.irfft(np.fft.rfft(r, N) * np.conj(np.fft.rfft(ref, N)))[:len(r)]
lag0 = int(np.argmax(np.abs(cc)))

def symbols(lag, ph):
    y = rx48[lag:]; K = min(nb, int((len(y) - ph) / spb) - 1)
    return y[(np.arange(K) * spb + ph).astype(int)], K

def fit(s, K, P=12, L=150):
    sym = 2.0 * tbits[:K] - 1; ks = [k for k in range(L, K - P) if active[k - L:k + P + 1].all()]
    A = np.array([[sym[k - j] for j in range(-P, L + 1)] for k in ks]); g = np.linalg.lstsq(A, s[ks], rcond=None)[0]
    pred = A @ g; snr = np.var(pred) / np.var(s[ks] - pred)
    return g, snr

# search sampling phase; realign on the main tap
best = None
for ph in np.linspace(0, spb, 12, endpoint=False):
    s, K = symbols(lag0, ph); g, snr = fit(s, K, 12, 60)
    if best is None or snr > best[0]: best = (snr, ph, g)
snr, ph, g = best
m = int(np.argmax(np.abs(g))) - 12; pol = np.sign(g[12 + m])
lag = lag0 + int(round(m * spb))
s, K = symbols(lag, ph); s = pol * s
g, snr = fit(s, K)
P = 12; g0 = g[P]
print("lag %.3f s, phase %.1f/%.1f, polarity %+d, model SNR %.1f dB" % (lag / fs, ph, spb, pol, 10 * np.log10(snr)))
print("taps / main: precursor", np.round(g[P - 3:P] / g0, 2), "postcursor 1..6", np.round(g[P + 1:P + 7] / g0, 2), "tail sum", round(g[P + 1:].sum() / g0, 2))
b = tbits[:K]; act = active[:K]; sym = 2.0 * b - 1
def ber(dec): return np.mean(dec[act] != b[act]), int((dec[act] != b[act]).sum())
print("bits scored %d" % act.sum())
print("plain slicer          BER %.4f (%d)" % ber((s - np.median(s) > 0).astype(int)))
T = 61; c = T // 2; ks = [k for k in range(c, K - c) if act[k]]
X = np.array([s[k - c:k + c + 1] for k in ks]); w = np.linalg.lstsq(X, sym[ks], rcond=None)[0]
lin = np.zeros(K); lin[ks] = X @ w
print("linear EQ 61          BER %.4f (%d)" % ber((lin > 0).astype(int)))
def dfe(gpost, gpre=None, train=0):
    dec = np.zeros(K, int)
    for k in range(K):
        isi = sum(gpost[j - 1] * (2 * dec[k - j] - 1) for j in range(1, min(len(gpost), k) + 1))
        z = s[k] - isi
        dec[k] = b[k] if k < train else (1 if z > 0 else 0)
    return dec
for Lp in (10, 40, 150):
    print("DFE post %3d          BER %.4f (%d)" % ((Lp,) + ber(dfe(g[P + 1:P + 1 + Lp]))))
# precursor ISI also matters: a DFE can't cancel precursors; a short feed-forward filter + DFE (MMSE-ish) does
F = 7; fc = F // 2; Lp = 150
ks = [k for k in range(Lp + fc, K - fc) if act[k - Lp:k + fc + 1].all()]
X = np.array([np.concatenate([s[k - fc:k + fc + 1], -(2.0 * b[k - Lp:k][::-1] - 1)]) for k in ks])   # feedforward + feedback on known past
wv = np.linalg.lstsq(X, sym[ks], rcond=None)[0]; ff, fb = wv[:F], wv[F:]
dec = np.zeros(K, int)
for k in range(K):
    if k < fc or k + fc >= K: continue
    past = np.array([2 * dec[k - j] - 1 for j in range(1, Lp + 1)]) if k >= Lp else np.concatenate([2 * dec[k - 1::-1] - 1, np.zeros(Lp - k)])
    z = s[k - fc:k + fc + 1] @ ff - past @ fb
    dec[k] = 1 if z > 0 else 0
print("FF7 + DFE150 (fitted)  BER %.4f (%d)" % ber(dec))
np.save('fb.npy', np.concatenate([[P], g]))
