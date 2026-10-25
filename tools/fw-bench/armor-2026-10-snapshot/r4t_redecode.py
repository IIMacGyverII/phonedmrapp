"""Re-read the 50-frame capture with a window that includes the end. No key."""
import sys
import numpy as np

sys.path.insert(0, r"C:\Users\Joshua\AppData\Local\Temp\fw1718")
sys.path.insert(0, r"D:\Documents\code\personal\phonedmrapp\tools\fw-patch")
sys.path.insert(0, r"D:\Documents\code\personal\phonedmrapp\tools\m17-research")
import camp
import m17
import m17_stream_table as tab

dev, info = camp.demod(str(camp.CAP / "r4s0_t50.iq"))
fs = camp.FS_A
i0 = int(info["i0"])
seg = dev[i0 + int(0.05 * fs):i0 + int(2.45 * fs)]
res = m17.decode_transmission(seg, fs, verbose=False)
lsf = res.get("lsf")
ok = bool(lsf) and bool(lsf[2])
same = bool(lsf) and lsf[0] == tab.BENCH_CALL and lsf[1] == tab.BENCH_CALL
good = 0
errs = []
for fn, pay, err in res["frames"]:
    hit = bytes(pay) == bytes(range(16)) and err == 0
    good += int(hit)
    if not hit:
        errs.append("%d/%d" % (fn, err))
print("lsf", ok, "both", same, "frames", len(res["frames"]), "good", good, "bad", " ".join(errs[:8]))
print("keyed", round(info["keyed_s"], 2), "snr", round(info["snr_db"], 1))
