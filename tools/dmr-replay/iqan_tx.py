"""Transmit capture analysis (written for the W6Plus DMR TX test, 2026-10-29; works for any FM or DMR key captured by the HackRF): carrier on/off, offset, FM deviation, audio spectrum; and DMR framing (sync bursts,
slot type colour code / data type, voice LC header source and destination via BPTC(196,96), no error correction).
usage: python iqan_tx.py capture.iq [--fs 2400000] [--off 240000] [--dmr]
HackRF int8 interleaved IQ; the carrier sits --off Hz above the capture's centre."""
import sys, numpy as np

args = sys.argv[1:]
path = args[0]
fs = float(args[args.index('--fs') + 1]) if '--fs' in args else 2.4e6
off = float(args[args.index('--off') + 1]) if '--off' in args else 240e3
x = np.fromfile(path, dtype=np.int8).astype(np.float32)
iq = (x[0::2] + 1j * x[1::2]) / 128.0
n = len(iq)
print('samples %d (%.2f s), clip share %.4f' % (n, n / fs, np.mean(np.abs(x) >= 127)))
iq = iq * np.exp(-2j * np.pi * off * np.arange(n) / fs)            # carrier to 0 Hz
dec = int(fs // 48000)
k = np.ones(dec) / dec
bb = np.convolve(iq, k, 'same')[::dec]                               # crude low-pass + decimate to 48 kHz
f2 = fs / dec
pw = np.abs(bb) ** 2
win = int(f2 * 0.05)
pws = np.convolve(pw, np.ones(win) / win, 'same')
floor = np.percentile(pws, 10)
on = pws > floor * 100                                               # 20 dB above the floor
if not on.any():
    if np.percentile(pws, 10) > 1e-3: on[:] = True; print('carrier throughout the capture (no quiet part to measure a floor)')
    else: print('no carrier found (peak %.1f dB over the floor)' % (10 * np.log10(pws.max() / floor))); sys.exit()
idx = np.where(on)[0]
t0, t1 = idx[0] / f2, idx[-1] / f2
print('carrier %.2f s to %.2f s (%.2f s), %.1f dB over the floor' % (t0, t1, t1 - t0, 10 * np.log10(np.median(pws[on]) / floor)))
inst = np.angle(bb[1:] * np.conj(bb[:-1])) * f2 / (2 * np.pi)
seg = inst[idx[0] + int(0.2 * f2): idx[-1] - int(0.2 * f2)]
seg = seg[np.abs(seg) < 15000]
mean = np.mean(seg)
print('carrier offset %+.0f Hz; deviation p50 %.0f, p99 %.0f, max %.0f Hz' % (mean, np.percentile(np.abs(seg - mean), 50), np.percentile(np.abs(seg - mean), 99), np.abs(seg - mean).max()))
a = seg - mean
sp = np.abs(np.fft.rfft(a[:int(f2 * 2)] * np.hanning(min(len(a), int(f2 * 2))))) if len(a) > 2000 else None
if sp is not None:
    fr = np.fft.rfftfreq(min(len(a), int(f2 * 2)), 1 / f2)
    band = (fr > 50) & (fr < 6000)
    top = fr[band][np.argsort(sp[band])[-3:][::-1]]
    print('strongest demodulated tones (Hz):', ', '.join('%.0f' % v for v in top))

if '--dmr' not in args:
    sys.exit()

# ---- DMR: 4800 baud 4FSK, +-1944 / +-648 Hz -------------------------------------------------------------------------
SYNCS = {'BS voice': 0x755FD7DF75F7, 'BS data': 0xDFF57D75DF5D, 'MS voice': 0x7F7D5DD57DFD, 'MS data': 0xD5D7F77FD757,
         'RC': 0x77D55F7DFD77, 'DM TS1 voice': 0x5D577F7775D7, 'DM TS1 data': 0xF7FDD5DDFD55,
         'DM TS2 voice': 0x7DFFD5F55D5F, 'DM TS2 data': 0xD7557F5FF7F5}
def sym_of(bits48):
    s = []
    for i in range(23, -1, -1):
        d = (bits48 >> (2 * i)) & 3
        s.append({1: 3, 0: 1, 2: -1, 3: -3}[d])
    return np.array(s, float)
ref = {k: sym_of(v) for k, v in SYNCS.items()}
sps = f2 / 4800.0
L = int(round(sps))
fm = np.convolve(inst, np.ones(L) / L, 'same')[idx[0]:idx[-1]] - mean   # integrate over a symbol, carrier offset removed
def ncc(sym, r):
    num = np.correlate(sym, r, 'valid')
    e = np.convolve(sym * sym, np.ones(len(r)), 'valid')
    return num / (np.sqrt(e) * np.linalg.norm(r) + 1e-9)
best = None
for pol in (1, -1):
    for ph in range(L):
        sym = pol * fm[ph::L]
        for name, r in ref.items():
            c = ncc(sym, r); m = c.max()
            if best is None or m > best[0]: best = (m, pol, ph, name)
m, pol, ph, name = best
s = pol * fm[ph::L]
print('best sync %s, normalised correlation %.3f, polarity %+d, phase %d/%d' % (name, m, pol, ph, L))
hits = []
for nm, r in ref.items():
    c = ncc(s, r)
    for i in np.where(c > 0.85)[0]:
        hits.append((i, nm, c[i]))
hits.sort()
merged = []
for h in hits:
    if merged and h[0] - merged[-1][0] < 60:
        if h[2] > merged[-1][2]: merged[-1] = h
    else: merged.append(h)
hits = merged
from collections import Counter
print('sync bursts: %d  %s' % (len(hits), dict(Counter(h[1] for h in hits))))
if len(hits) > 1:
    gaps = np.diff([h[0] for h in hits]) / 4.8
    print('burst spacing ms: median %.1f (min %.1f, max %.1f)' % (np.median(gaps), gaps.min(), gaps.max()))
def tobits(a):
    v = 0
    for b in a: v = (v << 1) | b
    return v
def slice_(seq, ab):
    out = []
    for v in seq:
        u = (v - ab[1]) / ab[0]                          # this burst's own scale and offset, fitted on its sync
        q = 3 if u > 2 else 1 if u > 0 else -1 if u > -2 else -3
        out += {3: [0, 1], 1: [0, 0], -1: [1, 0], -3: [1, 1]}[q]
    return out
names = {0: 'PI header', 1: 'voice LC header', 2: 'terminator with LC', 3: 'CSBK', 6: 'data header', 9: 'idle'}
rows = []
for i, nm, c in hits:
    r = ref[nm]; A = np.vstack([r, np.ones(24)]).T; lvl = np.linalg.lstsq(A, s[i:i + 24], rcond=None)[0]   # s = a*ref + b
    if 'data' not in nm or i - 54 < 0 or i + 78 > len(s): continue
    b1 = slice_(s[i - 54:i], lvl); b2 = slice_(s[i + 24:i + 78], lvl)
    slot = b1[98:108] + b2[0:10]
    cc, dtype = tobits(slot[0:4]), tobits(slot[4:8])
    info = b1[0:98] + b2[10:108]
    de = [info[(a * 181) % 196] for a in range(196)]
    data = []
    for lo, hi in [(4, 11), (16, 26), (31, 41), (46, 56), (61, 71), (76, 86), (91, 101), (106, 116), (121, 131)]: data += de[lo:hi + 1]
    by = [tobits(data[j:j + 8]) for j in range(0, 96, 8)]
    flco = by[0] & 0x3F; dst = (by[3] << 16) | (by[4] << 8) | by[5]; src = (by[6] << 16) | (by[7] << 8) | by[8]
    rows.append((round(i / 4.8), nm, cc, names.get(dtype, 'type %d' % dtype), flco, dst, src))
for r in rows[:8]: print('t+%5d ms %-12s colour code %d, %-18s FLCO %d, dst %d, src %d' % r)
