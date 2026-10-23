"""Clock drift between the phone's audio clock and the transmitted bit clock: best sampling offset per block of
known bits (fine linear fit per block).  usage: drift.py rx.wav tx.wav"""
import sys, wave, numpy as np
def load(p):
    w = wave.open(p); x = np.frombuffer(w.readframes(w.getnframes()), dtype='<i2').astype(float); return x, w.getframerate()
rx, fr = load(sys.argv[1]); tx, ft = load(sys.argv[2])
spb_t = ft / 1200; nb = int(len(tx) / spb_t)
cent = [(k + 0.5) * spb_t for k in range(nb)]
tb = np.array([1 if tx[int(c)] < 0 else 0 for c in cent]); act = np.array([abs(tx[int(c)]) > 100 for c in cent])
up = 6; y = np.interp(np.arange(len(rx) * up) / up, np.arange(len(rx)), rx); fs = fr * up; spb = fs / 1200
ref = tx - tx.mean(); r = y - y.mean(); N = 1 << int(np.ceil(np.log2(len(r) + len(ref))))
lag = int(np.argmax(np.abs(np.fft.irfft(np.fft.rfft(r, N) * np.conj(np.fft.rfft(ref, N)))[:len(r)])))
sym = 2.0 * tb - 1
print("block  best offset (samples at 48 kHz, of %.0f per bit)  fit residual" % spb)
offs = []
for blk in range(0, nb - 1200, 1500):
    best = None
    for off in np.arange(-60, 60, 2.0):
        K = range(blk + 30, blk + 1400)
        idx = [int(lag + k * spb + off + m * spb / 2) for k in K for m in range(-6, 7)]
        if max(idx) >= len(y) or min(idx) < 0: continue
        X = np.array([[y[int(lag + k * spb + off + m * spb / 2)] for m in range(-6, 7)] + list(sym[k - 30:k][::-1]) for k in K])
        t = sym[list(K)]; w = np.linalg.lstsq(X, t, rcond=None)[0]; e = np.mean((X @ w - t) ** 2)
        if best is None or e < best[0]: best = (e, off)
    if best: offs.append((blk, best[1])); print("%5d  %6.1f  %.3f" % (blk, best[1], best[0]))
if len(offs) > 2:
    a = np.polyfit([o[0] for o in offs], [o[1] for o in offs], 1)
    print("drift %.4f samples per bit = %.0f ppm" % (a[0], 1e6 * a[0] / spb))
