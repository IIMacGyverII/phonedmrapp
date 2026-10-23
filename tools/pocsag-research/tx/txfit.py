"""Fit the phone's transmit path (8 kHz audio in -> deviation out) from the calibration, design a regularised
pre-distortion filter, predict the plain-slicer bit error rate.  txfit.py cap_cal.wav tx_cal.wav"""
import sys, wave, numpy as np
def load(p):
    w = wave.open(p); return np.frombuffer(w.readframes(w.getnframes()), dtype='<i2').astype(float), w.getframerate()
y48, fy = load(sys.argv[1]); x8, fx = load(sys.argv[2])
y8 = y48[::6] / 5.0                                                       # deviation in Hz at 8 kHz
N = 1 << int(np.ceil(np.log2(len(y8) + len(x8))))
cc = np.fft.irfft(np.fft.rfft(y8, N) * np.conj(np.fft.rfft(x8, N)))[:len(y8)]; lag = int(np.argmax(np.abs(cc)))
P, Lh = 40, 600                                                           # taps before / after the main delay
y = y8[lag - P:lag - P + len(x8)]
xs = x8 / float(__import__('os').environ.get('AMP', '12000'))
rows = np.arange(Lh, len(xs) - 1, 3)
A = np.array([xs[r - Lh:r + 1][::-1] for r in rows]); h = np.linalg.lstsq(A, y[rows + P - P], rcond=None)[0]
res = y[rows] - A @ h; print('transmit path model: residual %.1f%% of the signal' % (100 * res.std() / y[rows].std()))
H = np.fft.rfft(h, 4096); f = np.fft.rfftfreq(4096, 1 / 8000)
for fr in (50, 100, 200, 300, 600, 1200, 2000, 3000):
    print('  gain at %4d Hz: %6.1f dB' % (fr, 20 * np.log10(abs(H[np.argmin(abs(f - fr))]) + 1e-9)))
# regularised inverse at delay d: minimise |h*g - delta_d|^2 + lam |g|^2
Lg = 600
for lam_db in (-30, -20, -10):
    lam = 10 ** (lam_db / 10) * np.sum(h ** 2)
    best = None
    for d in (40, 80, 160, 300):
        C = np.zeros((len(h) + Lg - 1, Lg))
        for k in range(Lg): C[k:k + len(h), k] = h
        t = np.zeros(len(h) + Lg - 1); t[d] = 1.0
        g = np.linalg.solve(C.T @ C + lam * np.eye(Lg), C.T @ t)
        err = np.linalg.norm(C @ g - t) ** 2
        if best is None or err < best[0]: best = (err, d, g)
    err, d, g = best
    # predicted: NRZ pages -> g -> h -> plain slicer
    sys.path.insert(0, '../'); import pocsag as pc
    bits = []
    for ric, msg in ((1234567, 'SIGNALDECK TX TEST ONE'), (200001, 'Second page from the phone')): bits += pc.transmission(ric, 3, msg)
    spb = 8000 / 1200
    nrz = np.concatenate([np.full(int(round((i + 1) * spb)) - int(round(i * spb)), -1.0 if b else 1.0) for i, b in enumerate(bits)])
    pre = np.convolve(nrz, g)[:len(nrz)]; gain = np.percentile(np.abs(pre), 99.5)
    out = np.convolve(pre, h)[:len(nrz)]
    lagd = d + P
    out = np.concatenate([out, np.zeros(2000)]); errs = None
    for o in range(-8, 9):
        e = sum(1 for k in range(len(bits)) if ((out[int((k + 0.5) * spb) + d + o] < 0) != bits[k]))
        errs = e if errs is None else min(errs, e)
    print('regularisation %d dB: delay %d, inverse error %.3f, drive peak x%.1f of plain NRZ, predicted plain-slicer errors %d of %d' % (lam_db, d, err, gain, errs, len(bits)))
    np.save('pre_%d.npy' % lam_db, g)
