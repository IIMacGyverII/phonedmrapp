"""Transmit path: HackRF capture (2.4 MS/s, signal +240 kHz) -> FM discriminator (Hz, 48 kHz) -> align with the
8 kHz PCM sent -> deviation per PCM unit vs frequency (chirp) -> plain M17 decode of each level, as a real M17 radio."""
import sys, json, numpy as np, m17
iq = np.fromfile(sys.argv[1], dtype=np.int8); FS = 2_400_000; OFF = 240_000; DEC = 50
z = iq[0::2].astype(np.float32) + 1j * iq[1::2].astype(np.float32); del iq
out = []
for s0 in range(0, len(z) - DEC, FS):
    seg = z[s0:s0 + FS]; m = len(seg) // DEC * DEC
    ph = np.exp((-2j * np.pi * OFF / FS) * np.arange(s0, s0 + m)).astype(np.complex64)
    out.append((seg[:m] * ph).reshape(-1, DEC).mean(axis=1))
zd = np.concatenate(out); del z
k = np.sinc(np.arange(-64, 65) * 2 * 9000 / 48000) * np.blackman(129); k /= k.sum(); zd = np.convolve(zd, k, 'same')
dev = np.angle(zd[1:] * np.conj(zd[:-1])) * 48000 / (2 * np.pi)
pw = np.convolve(np.abs(zd) ** 2, np.ones(4800) / 4800, 'same'); on = pw > np.percentile(pw, 5) * 30
i0 = np.argmax(on); i1 = len(on) - np.argmax(on[::-1])
print('carrier %.2f-%.2f s (%.2f s keyed), level %.1f dB above the floor' % (i0 / 48000, i1 / 48000, (i1 - i0) / 48000, 10 * np.log10(np.median(pw[on]) / np.percentile(pw, 5))))
dev = dev - np.median(dev[i0:i1])                                  # carrier offset (crystals)
import os; base = os.environ.get('TXB', 'tx_m17snd'); tx = np.load(base + '.npy'); meta = json.load(open(base + '.json')); parts = meta['parts']
tx48 = np.repeat(tx, 6)                                            # zero-order hold is fine for alignment
k2 = np.sinc(np.arange(-120, 121) * 7200 / 48000) * np.blackman(241); k2 /= k2.sum(); tx48 = np.convolve(tx48, k2, 'same')
env = lambda x: np.convolve(np.abs(x), np.ones(480) / 480, 'same')
a = env(dev[i0:i0 + len(tx48) + 96000]); b = env(tx48)
c = np.correlate(a - a.mean(), b - b.mean(), 'full'); lag = int(np.argmax(c)) - (len(b) - 1) + i0
bestr = (0, lag)
for L in range(lag - 300, lag + 301, 2):
    x = dev[L:L + len(tx48)]; n = min(len(x), len(tx48)); r = np.dot(x[:n], tx48[:n]) / (np.linalg.norm(x[:n]) * np.linalg.norm(tx48[:n]) + 1e-9)
    if abs(r) > abs(bestr[0]): bestr = (r, L)
r, lag = bestr; pol = np.sign(r)
print('PCM start at %.3f s in the capture (correlation %.2f, polarity %+d): key-up to audio %.0f ms' % (lag / 48000, abs(r), pol, (lag - i0) / 48))
da = pol * dev[lag:lag + len(tx48)]
c0 = int(parts.get('chirp', 0) * 48000); c1 = c0 + 6 * 48000
X = np.fft.rfft(tx48[c0:c1] * np.hanning(c1 - c0)); Y = np.fft.rfft(da[c0:c1] * np.hanning(c1 - c0)); f = np.fft.rfftfreq(c1 - c0, 1 / 48000)
H = np.abs(Y) / (np.abs(X) + 1e-9)
if 'chirp' in parts:
  print('transmit path: deviation per PCM unit (Hz per 1000 PCM)')
  for fc in (30, 50, 100, 150, 200, 300, 400, 600, 800, 1000, 1500, 2000, 2400, 2800, 3200, 3600):
    m = (f > fc * 0.93) & (f < fc * 1.07); print('  %5d Hz  %7.1f Hz/1000' % (fc, 1000 * np.median(H[m])))
rng = np.random.RandomState(meta['seed']); pay = [bytes(rng.randint(0, 256, 16, dtype=np.uint8)) for _ in range(meta['frames'])]
for name in parts:
    if name == 'chirp': continue
    s0 = int(parts[name] * 48000) - 2400; seg = -da[s0:s0 + int(4.2 * 48000)] if base != 'tx_m17snd' else da[s0:s0 + int(4.2 * 48000)]
    print('%s: peak deviation %.0f Hz (99.9th pct %.0f)' % (name, np.abs(seg).max(), np.percentile(np.abs(seg), 99.9)), end='  ')
    r = m17.decode_transmission(seg, 48000, verbose=False)
    good = sum(1 for (fn, p, le) in r['frames'] if (fn & 0x7FFF) < len(pay) and p == pay[fn & 0x7FFF])
    print('plain decode: LSF %s, frames found %d, exact %d of %d' % (r['lsf'], len(r['frames']), good, len(pay)))
np.save(base + '_dev48.npy', da)
