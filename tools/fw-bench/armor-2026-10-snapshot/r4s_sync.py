"""Best M17 sync score in the short burst. No transmission."""
import sys
import numpy as np

sys.path.insert(0, r"C:\Users\Joshua\AppData\Local\Temp\fw1718")
sys.path.insert(0, r"D:\Documents\code\personal\phonedmrapp\tools\m17-research")
import camp
import m17

dev, info = camp.demod(str(camp.CAP / "r4s0_s50.iq"))
fs = camp.FS_A
i0 = int(info["i0"])
seg = dev[i0:i0 + int(2.20 * fs)]
y, sps = m17.demod(seg, fs)
n = len(y)
idx = np.arange(0, n - 8 * sps)
def report(tag, yy):
    rows = []
    for kind in ("lsf", "str"):
        s = m17.SYNC_SYMS[kind]
        V = np.stack([yy[idx + m * sps] for m in range(8)], 1)
        sc = V @ s / (np.sqrt(np.dot(s, s) * np.sum(V * V, 1)) + 1e-12)
        times = idx / (sps * m17.SYM_RATE)
        for lo in (0.0, 0.05, 0.08):
            msk = times >= lo
            k = int(np.argmax(np.where(msk, sc, -2)))
            rows.append((tag, kind, lo, float(sc[k]), float(times[k])))
    for tag, kind, lo, sc, t in rows:
        print("%s %s after %.2f  %.3f at %.3f s" % (tag, kind, lo, sc, t))

report("pos", y)
y2, _ = m17.demod(-seg, fs)
report("inv", y2)
found = m17.find_frames(y, sps, thresh=0.9)
print("find_frames", len(found), "first", None if not found else (round(found[0][2], 3), found[0][1]))
loose = m17.find_frames(y, sps, thresh=0.8)
print("find 0.8", len(loose))
