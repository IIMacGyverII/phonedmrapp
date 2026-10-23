"""Build the receive-path sounding transmission for the HackRF (2 MS/s int8 FM IQ), as a deviation signal in Hz:
1 s carrier, a 6 s log chirp 20 Hz -> 3.8 kHz at +-1.5 kHz, then M17 transmissions (LSF + 100 stream frames, known
random payload, seed 1) at 100 %, 60 % and 40 % of the standard +-2.4 kHz, 0.5 s carrier between them.
Writes sounding.iq, sounding_dev.npy (the deviation at 48 kHz) and sounding_parts.json (where each part starts)."""
import numpy as np, json, m17
FS = 48000
parts = {}; dev = [np.zeros(FS)]; t = FS
def add(name, x, gap=0.5):
    global t
    parts[name] = t / FS; dev.append(x); t += len(x)
    g = np.zeros(int(gap * FS)); dev.append(g); t += len(g)
for name, seed, lvl in (('a100', 1, 1.0), ('b100', 2, 1.0), ('c80', 3, 0.8), ('d100', 4, 1.0)):
    rng = np.random.RandomState(seed); pay = [bytes(rng.randint(0, 256, 16, dtype=np.uint8)) for _ in range(100)]
    syms, lsf = m17.transmission('N0CALL', '@ALL', pay); add(name, m17.deviation(syms, FS) * lvl)
d = np.concatenate(dev)
np.save('sounding2_dev.npy', d); json.dump({'parts': parts, 'symbols': len(syms)}, open('sounding2_parts.json', 'w'))
RATE = 2_000_000; phase = 0.0
with open('sounding2.iq', 'wb') as f:
    for s in range(0, len(d), FS):
        seg = d[s:s + FS]; n_out = len(seg) * RATE // FS
        a = np.interp(np.arange(n_out) / RATE, np.arange(len(seg)) / FS, seg)
        p = phase + np.cumsum(2 * np.pi * a / RATE); phase = p[-1] % (2 * np.pi)
        iq = np.empty(2 * n_out, np.int8); iq[0::2] = np.round(110 * np.cos(p)); iq[1::2] = np.round(110 * np.sin(p)); f.write(iq.tobytes())
print('%.1f s, parts %s' % (len(d) / FS, {k: round(v, 2) for k, v in parts.items()}))
