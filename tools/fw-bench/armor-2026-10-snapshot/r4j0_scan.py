# Read-only scan of the R4j0 capture. Does not key. verbose stays off.
import sys

import numpy as np

sys.path.insert(0, r"C:\Users\Joshua\AppData\Local\Temp\fw1718")
sys.path.insert(0, r"D:\Documents\code\personal\phonedmrapp\tools\m17-research")
import m17
import r3_capture

path = r"C:\Users\Joshua\AppData\Local\Temp\fw1718\caps\r4k0_silence.iq"
dev, info = r3_capture.wide_demod(path)
fs = r3_capture.FS
i0, i1 = int(info["i0"]), int(info["i1"])
seg = dev[i0:i1] - np.median(dev[i0:i1])
print("fs", fs, "keyed_s", round((i1 - i0) / fs, 3))

y, sps = m17.demod(seg, fs)
s = m17.SYNC_SYMS["str"]
s_l = m17.SYNC_SYMS["lsf"]
n = len(y)
idx = np.arange(0, n - 8 * sps)
V = np.stack([y[idx + m * sps] for m in range(8)], 1)
sc = V @ s / (np.sqrt(np.dot(s, s) * np.sum(V * V, 1)) + 1e-12)
sc_l = V @ s_l / (np.sqrt(np.dot(s_l, s_l) * np.sum(V * V, 1)) + 1e-12)
pay = bytes(range(16))
hits = []
for kind, scores in (("str", sc), ("lsf", sc_l)):
    above = np.nonzero(scores > 0.95)[0]
    # keep a local maximum inside one symbol
    keep = []
    for a in above:
        w0 = max(0, a - sps // 2)
        w1 = min(len(scores), a + sps // 2 + 1)
        if a == w0 + int(np.argmax(scores[w0:w1])):
            keep.append(a)
    for a in keep:
        if kind != "str":
            hits.append((a / (sps * m17.SYM_RATE), kind, float(scores[a]), None, None, None))
            continue
        start = a + 8 * sps
        chunk = y[a:a + 192 * sps:sps]
        if len(chunk) < 192:
            continue
        ref = m17.SYNC_SYMS["str"]
        A = np.vstack([ref, np.ones(8)]).T
        g, off = np.linalg.lstsq(A, chunk[:8], rcond=None)[0]
        symbols = (chunk[8:] - off) / g
        fn, payload, _lich, lerr = m17.decode_stream(symbols)
        hits.append((a / (sps * m17.SYM_RATE), kind, float(scores[a]), int(fn), int(lerr), bytes(payload) == pay))

hits.sort()
# drop duplicates within 5 ms
slim = []
for h in hits:
    if slim and h[0] - slim[-1][0] < 0.005 and h[1] == slim[-1][1]:
        if h[2] > slim[-1][2]:
            slim[-1] = h
        continue
    slim.append(h)
print("syncs", len(slim))
eot = [h for h in slim if h[3] == 0x8005]
print("eot", len(eot), "golay0", sum(1 for h in eot if h[4] == 0), "pay", sum(1 for h in eot if h[5]))
print("last15")
for h in slim[-15:]:
    print("  t %.3f %s score %.3f fn %s lerr %s pay %s" % h)
# 50 ms deviation slices over the last second of carrier
print("slices")
for t in np.arange(2.8, (i1 - i0) / fs, 0.05):
    a = int(t * fs)
    b = a + int(0.05 * fs)
    if b > len(seg):
        break
    x = seg[a:b] - np.median(seg[a:b])
    print("  t %.2f p99 %.0f rms %.0f" % (t, np.percentile(np.abs(x), 99), np.sqrt(np.mean(x ** 2))))
