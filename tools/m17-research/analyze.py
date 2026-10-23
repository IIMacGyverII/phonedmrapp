"""Analyse a received sounding (8 kHz radio audio): align with the transmitted deviation, frequency response from the
chirp, then M17: plain decode of each level, and symbol error rates before / after a least-squares equalizer."""
import sys, json, wave, numpy as np, m17
rx_path = sys.argv[1]
w = wave.open(rx_path); rx = np.frombuffer(w.readframes(w.getnframes()), '<i2').astype(float)
d48 = np.load('sounding_dev.npy'); meta = json.load(open('sounding_parts.json')); parts = meta['parts']
# transmitted deviation at 8 kHz (low-passed 3.6 kHz before decimating)
k = np.sinc(np.arange(-120, 121) * 7200 / 48000) * np.blackman(241); k /= k.sum()
tx8 = np.convolve(d48, k, 'same')[::6]
# coarse alignment on the envelope of the chirp + M17 (cross-correlation of |x|)
env = lambda x: np.convolve(np.abs(x), np.ones(80) / 80, 'same')
c = np.correlate(env(rx) - env(rx).mean(), env(tx8) - env(tx8).mean(), 'full'); lag0 = int(np.argmax(c)) - (len(tx8) - 1)
# fine alignment and polarity on the waveform
best = (0, 0, 1)
for lag in range(lag0 - 40, lag0 + 41):
    a = rx[max(0, lag):]; b = tx8[max(0, -lag):]; n = min(len(a), len(b))
    r = np.dot(a[:n], b[:n]) / (np.linalg.norm(a[:n]) * np.linalg.norm(b[:n]) + 1e-9)
    if abs(r) > abs(best[0]): best = (r, lag, np.sign(r))
r0, lag, pol = best
print('alignment: tx starts at %.3f s in the recording, correlation %.2f, polarity %+d' % (lag / 8000, r0, pol))
rxa = pol * rx[lag:lag + len(tx8)] if lag >= 0 else pol * np.r_[np.zeros(-lag), rx][:len(tx8)]
rxa = np.r_[rxa, np.zeros(len(tx8) - len(rxa))]
# ---- frequency response from the chirp (H = Rx/Tx over the chirp's band)
c0 = int(parts['chirp'] * 8000); c1 = c0 + 6 * 8000
X = np.fft.rfft(tx8[c0:c1] * np.hanning(c1 - c0)); Y = np.fft.rfft(rxa[c0:c1] * np.hanning(c1 - c0)); f = np.fft.rfftfreq(c1 - c0, 1 / 8000)
H = Y / (X + 1e-9)
ref = np.median(np.abs(H[(f > 900) & (f < 1100)]))
print('receive path response (dB relative to 1 kHz):')
for fc in (30, 50, 100, 150, 200, 300, 400, 600, 800, 1000, 1500, 2000, 2400, 2800, 3000, 3200, 3500, 3700):
    m = (f > fc * 0.93) & (f < fc * 1.07)
    print('  %5d Hz %+6.1f dB' % (fc, 20 * np.log10(np.median(np.abs(H[m])) / ref + 1e-9)))
gain = ref                                                         # audio units per Hz of deviation near 1 kHz
# ---- M17 at each level
syms, _ = m17.transmission('N0CALL', '@ALL', [bytes(np.random.RandomState(1).randint(0, 256, 16, dtype=np.uint8)) for _ in range(100)])
rng = np.random.RandomState(1); pay = [bytes(rng.randint(0, 256, 16, dtype=np.uint8)) for _ in range(100)]
for name in ('m17_100', 'm17_60', 'm17_40'):
    s0 = int(parts[name] * 8000); seg = rxa[s0 - 400:s0 + int(len(syms) / 4800 * 8000) + 800] / gain   # back to Hz of deviation
    lvl = int(name.split('_')[1]) / 100
    r = m17.decode_transmission(seg / lvl, 8000, verbose=False)
    ok = sum(1 for (fn, p, le) in r['frames'] if 0 <= (fn & 0x7FFF) < 100 and p == pay[fn & 0x7FFF])
    print('%s: LSF %s, %d stream frames found, %d of 100 payloads correct, LICH bit errors %s' % (name, r['lsf'], len(r['frames']), ok, [f[2] for f in r['frames'][:8]]))
np.save('rx_aligned.npy', rxa); np.save('tx8.npy', tx8)
