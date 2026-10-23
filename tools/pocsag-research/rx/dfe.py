"""POCSAG through the radio's audio path: align a recording to the known transmitted bits, measure the symbol-rate
channel, and compare slicers: plain, linear equalizer, decision-feedback equalizer (DFE). Bench analysis only.
usage: python -P dfe.py <rx.wav (8 kHz)> <tx.wav (48 kHz NRZ baseband from pocsag.py gen)>"""
import sys, wave, numpy as np

def load(p):
    w = wave.open(p); fs = w.getframerate(); x = np.frombuffer(w.readframes(w.getnframes()), dtype='<i2').astype(float)
    if w.getnchannels() == 2: x = x[::2]
    return x, fs

rx, fr = load(sys.argv[1]); tx, ft = load(sys.argv[2])
BAUD = 1200
# transmitted bits from the NRZ baseband: sample at bit centres
spb_t = ft / BAUD
nb = int(len(tx) / spb_t)
tbits = np.array([1 if tx[int((k + 0.5) * spb_t)] > 0 else 0 for k in range(nb)])
# resample rx to 48 kHz for fine timing
up = 6; rx48 = np.interp(np.arange(len(rx) * up) / up, np.arange(len(rx)), rx); fs = fr * up
spb = fs / BAUD
# coarse alignment: correlate rx with the tx waveform (both mean-removed), any polarity
ref = tx - tx.mean(); r = rx48 - np.convolve(rx48, np.ones(4801) / 4801, 'same')
n = len(r) + len(ref); F = np.fft.rfft(r, 1 << int(np.ceil(np.log2(n)))) * np.conj(np.fft.rfft(ref, 1 << int(np.ceil(np.log2(n)))))
cc = np.fft.irfft(F)[:len(r)]
lag = int(np.argmax(np.abs(cc))); pol = 1 if cc[lag] > 0 else -1
print("lag %.3f s, polarity %+d" % (lag / fs, pol))
y = pol * rx48[lag:]
# fine timing: pick the sampling phase with the largest eye on the preamble (first 500 bits)
best = None
for ph in np.linspace(0, spb, 24, endpoint=False):
    idx = (np.arange(500) * spb + ph).astype(int); idx = idx[idx < len(y)]
    s = y[idx]; b = tbits[:len(s)]
    m = abs(s[b == 1].mean() - s[b == 0].mean()) / (s.std() + 1e-9)
    if best is None or m > best[0]: best = (m, ph)
ph = best[1]
K = min(nb, int((len(y) - ph) / spb) - 1)
idx = (np.arange(K) * spb + ph).astype(int); s = y[idx]; b = tbits[:K]; sym = 2.0 * b - 1
def ber(dec): return np.mean(dec != b)
print("bits compared: %d" % K)
# 1) plain slicer (mean removed)
print("plain slicer           BER %.4f" % ber((s - s.mean() > 0).astype(int)))
# channel at symbol rate: s_k = sum_j g_j sym_{k-j}, j = -P..L (least squares, known bits)
P, L = 3, 120
rows = range(L, K - P)
A = np.array([[sym[k - j] for j in range(-P, L + 1)] for k in rows]); g = np.linalg.lstsq(A, s[L:K - P], rcond=None)[0]
g0 = g[P]
print("channel: main tap %.0f, sum of postcursor taps %.0f (%.0f%% of the main), precursor %s" % (g0, g[P + 1:].sum(), 100 * g[P + 1:].sum() / g0, np.round(g[:P] / g0, 2)))
# 2) linear equalizer (LS, symbol rate, 61 taps around the bit) trained on known bits
T = 61; c = T // 2
X = np.array([s[k - c:k + c + 1] for k in range(c, K - c)]); w = np.linalg.lstsq(X, sym[c:K - c], rcond=None)[0]
lin = np.concatenate([np.zeros(c), X @ w, np.zeros(c)])
print("linear equalizer (61)  BER %.4f" % ber((lin > 0).astype(int)))
# 3) DFE: subtract postcursor ISI of past decisions (and the known precursor shape is small)
def dfe(gpost, train=0):
    dec = np.zeros(K, int); Lp = len(gpost)
    for k in range(K):
        isi = 0.0
        for j in range(1, min(Lp, k) + 1): isi += gpost[j - 1] * (2 * dec[k - j] - 1)
        z = s[k] - isi
        dec[k] = b[k] if k < train else (1 if z > 0 else 0)
    return dec
for Lp in (20, 60, 120):
    print("DFE %3d taps (channel from known bits)  BER %.4f" % (Lp, ber(dfe(g[P + 1:P + 1 + Lp]))))
# 4) blind-ish: fit the channel only on the preamble + first sync word (what a receiver knows), then decide
Ktr = 576 + 32
A2 = np.array([[sym[k - j] for j in range(0, L + 1)] for k in range(L, Ktr)]); g2 = np.linalg.lstsq(A2, s[L:Ktr], rcond=None)[0]
print("DFE trained on preamble+sync only        BER %.4f" % ber(dfe(g2[1:])))
np.save('chan.npy', g)
