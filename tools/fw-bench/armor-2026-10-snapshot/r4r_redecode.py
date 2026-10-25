# Re-read the kept R4r capture with the fixed link-setup flag. No transmission.
import sys
from pathlib import Path

import numpy as np

sys.path.insert(0, r"C:\Users\Joshua\AppData\Local\Temp\fw1718")
sys.path.insert(0, r"D:\Documents\code\personal\phonedmrapp\tools\m17-research")
sys.path.insert(0, r"D:\Documents\code\personal\phonedmrapp\tools\fw-patch")
import camp
import m17
import m17_stream_table as tab

IQ = Path(r"C:\Users\Joshua\AppData\Local\Temp\fw1718\caps\r4r0_key.iq")


def main():
    dev, info = camp.demod(str(IQ))
    i0 = int(info["i0"])
    fs = camp.FS_A
    seg = dev[i0 + int(0.02 * fs):i0 + int(0.40 * fs)]
    res = m17.decode_transmission(seg, fs, verbose=False)
    lsf = res.get("lsf")
    ok = bool(lsf) and bool(lsf[2])
    same = bool(lsf) and lsf[0] == tab.BENCH_CALL and lsf[1] == tab.BENCH_CALL
    good = 0
    rows = []
    for fn, pay, err in res["frames"]:
        hit = bytes(pay) == bytes(range(16)) and err == 0
        good += int(hit)
        rows.append("%d/%d" % (fn, err))
    print("lsf_ok", ok, "both_match", same, "frames", len(res["frames"]), "good", good, rows)
    if not ok:
        raise SystemExit("flag still false")


if __name__ == "__main__":
    main()
