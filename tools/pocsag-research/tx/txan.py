"""Transmit-path analysis: demodulated capture (48 kHz, flat) vs the bits given to the phone.  txan.py cap.wav bits"""
import sys, wave, numpy as np
w = wave.open(sys.argv[1]); y = np.frombuffer(w.readframes(w.getnframes()), dtype='<i2').astype(float) / 5.0; fs = w.getframerate()
bits = np.array([int(c) for c in open(sys.argv[2]).read().strip()]); spb = fs / 1200
ref = np.concatenate([np.full(int(round((i + 1) * spb)) - int(round(i * spb)), -1.0 if b else 1.0) for i, b in enumerate(bits)])
env = np.sqrt(np.convolve(y * y, np.ones(2400) / 2400, 'same'))
yy = y.copy()
N = 1 << int(np.ceil(np.log2(len(yy) + len(ref))))
cc = np.fft.irfft(np.fft.rfft(yy, N) * np.conj(np.fft.rfft(ref, N)))[:len(yy)]; lag = int(np.argmax(np.abs(cc))); pol = np.sign(cc[lag])
seg = pol * y[lag:lag + len(ref)]
print('deviation during the data: rms %.0f Hz, p99 %.0f Hz' % (seg.std(), np.percentile(np.abs(seg), 99)))
best = None
for ph in np.linspace(0, spb, 20, endpoint=False):
    idx = (np.arange(len(bits) - 1) * spb + ph).astype(int); s = seg[idx]
    dec = (s < 0).astype(int)                                               # a 1 = negative (lower frequency)
    e = int((dec != bits[:len(dec)]).sum())
    if best is None or e < best[0]: best = (e, ph, s)
print('plain slicer (what a pager does): %d bit errors of %d (%.1f%%)' % (best[0], len(bits) - 1, 100.0 * best[0] / (len(bits) - 1)))
s = best[2]; b = bits[:len(s)]
for run in (1, 2, 4, 8, 16):
    # mean level after a run of `run` equal bits: shows the low-frequency loss (droop)
    v = [s[k] * (1 if b[k] == 0 else -1) for k in range(run, len(s)) if (b[k - run:k + 1] == b[k]).all()]
    if v: print('  level after %2d equal bits: %5.0f Hz' % (run, np.mean(v)))
