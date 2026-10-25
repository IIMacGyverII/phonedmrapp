"""Envelope of the R-E phone clips. Read only."""
import numpy as np
from pathlib import Path

DIR = Path(r"C:\Users\Joshua\AppData\Local\Temp\fw1718\rd10")
NAMES = [
    "re_h3_before", "re_h3_1k", "re_phone_m17_0", "re_phone_m17_1",
    "re_phone_m17_2", "re_h3_after", "re_h3_tuned", "re_h3_reheld",
    "re_phone_plain", "h3_100", "h3_1000",
]


def pcm(path):
    blob = path.read_bytes()
    i = blob.find(b"data")
    n = int.from_bytes(blob[i + 4:i + 8], "little")
    return np.frombuffer(blob[i + 8:i + 8 + n], dtype="<i2").astype(np.float64)


def goertzel(x, freq, fs=8000.0):
    x = x - np.mean(x)
    k = np.arange(x.size)
    w = np.exp(-2j * np.pi * freq * k / fs)
    return float(np.abs(np.dot(x, w)) * 2.0 / x.size)


for name in NAMES:
    p = DIR / (name + ".wav")
    if not p.exists():
        print(name, "MISSING")
        continue
    x = pcm(p)
    win = 800  # 100 ms
    rows = []
    for i in range(0, x.size - win + 1, win):
        sl = x[i:i + win]
        rms = float(np.sqrt(np.mean((sl - np.mean(sl)) ** 2)))
        peak = float(np.max(np.abs(sl)))
        rows.append((i / 8000.0, rms, peak))
    nz = int(np.count_nonzero(x))
    print("%s n=%d dur=%.2f peak=%.0f rms=%.1f nonzero=%d" % (
        name, x.size, x.size / 8000.0, np.max(np.abs(x)),
        np.sqrt(np.mean((x - np.mean(x)) ** 2)), nz))
    # print windows that are loud or the first/last
    loud = [r for r in rows if r[1] > 200]
    print("  windows", len(rows), "loud", len(loud),
          "first3", [(round(t, 2), round(r, 1), round(pk, 0)) for t, r, pk in rows[:3]],
          "last2", [(round(t, 2), round(r, 1), round(pk, 0)) for t, r, pk in rows[-2:]])
    if name.endswith("before") or name in ("h3_100", "re_h3_tuned", "re_h3_reheld", "re_h3_after"):
        print("  100 Hz line full %.1f" % goertzel(x, 100))
    if "1k" in name or name == "h3_1000":
        print("  1000 Hz line full %.1f" % goertzel(x, 1000))
    # IQ peak of the matching cs8
    cs = DIR / (name + ".cs8")
    if cs.exists():
        iq = np.frombuffer(cs.read_bytes(), dtype=np.int8)
        print("  iq n=%d max=%d" % (iq.size, int(np.max(np.abs(iq)))))
