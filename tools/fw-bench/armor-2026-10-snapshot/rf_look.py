"""Where the independent-data Golay misses are, and POCSAG behind the M17 taps."""
import json
import sys
from collections import Counter
from pathlib import Path

import numpy as np

sys.path.insert(0, r"D:\Documents\code\personal\phonedmrapp\tools\m17-research")
sys.path.insert(0, r"D:\Documents\code\personal\phonedmrapp\tools\pocsag-research")
import m17  # noqa: E402
import pocsag  # noqa: E402

sys.path.insert(0, r"C:\Users\Joshua\AppData\Local\Temp\fw1718")
import rf_eq
import rf_run

DIR = Path(r"C:\Users\Joshua\AppData\Local\Temp\fw1718\rf")
w = rf_eq.load_taps() if False else np.array(json.loads((DIR / "taps.json").read_text())["taps"], float)

def inspect(name):
    path = DIR / (name + ".wav")
    x = rf_eq.pcm(path)
    y = rf_eq.loud(x)
    print(name, "rms", round(float(np.sqrt(np.mean(y ** 2))), 1), "dur", round(y.size / 8000, 2))
    d = rf_eq.decode_wav(path, w)
    fns = []
    bad = []
    for row in d["rows"]:
        if row["kind"] != "str":
            continue
        fn = row["fn"] & 0x7FFF
        end = bool(row["fn"] & 0x8000)
        fns.append(fn)
        if row["golay"]:
            bad.append((fn, end, row["golay"]))
    print("  fn span", min(fns) if fns else None, max(fns) if fns else None, "unique", len(set(fns)), "dup", len(fns) - len(set(fns)))
    print("  bad", len(bad), "golay hist", dict(Counter(g for _, _, g in bad)))
    print("  bad fn", [fn for fn, _, _ in bad[:20]])

for name in ("m17_d2400_v20_0", "m17_d2400_v20_1", "m17_d2400_v20_2"):
    inspect(name)

# POCSAG through the M17 matched filter and the 41 taps, then slice at 1200.
bits = json.loads((DIR / "pocsag_bits.json").read_text())
x = rf_eq.loud(rf_eq.pcm(DIR / "pocsag.wav"))
# scale does not matter for a sign slice after a linear filter
y, sps = m17.demod(x, 8000.0)
sym = y[::sps]
# same reversal the trainer uses
eq = np.array([np.dot(w, sym[i:i + w.size][::-1]) for i in range(0, sym.size - w.size)])
print("eq", eq.size, "sps", sps)

def ber(series, fs):
    best = None
    sync = np.array([(pocsag.SYNC >> (31 - k)) & 1 for k in range(32)], np.uint8)
    known = np.array(bits, np.uint8)
    kpos = next(i for i in range(known.size - 32) if np.array_equal(known[i:i + 32], sync))
    for pol in (1.0, -1.0):
        spb = fs / 1200.0
        for phase in np.linspace(0, spb, 8, endpoint=False):
            idx = np.arange(phase + spb / 2, series.size - 1, spb).astype(int)
            got = (pol * series[idx] < 0).astype(np.uint8)
            hit = None
            for i in range(0, min(got.size - 32, 6000)):
                if np.array_equal(got[i:i + 32], sync):
                    hit = i
                    break
            if hit is None:
                continue
            n = min(got.size - hit, known.size - kpos)
            err = int(np.sum(got[hit:hit + n] != known[kpos:kpos + n]))
            words = n // 32
            per = [int(np.sum(got[hit + 32 * t:hit + 32 * (t + 1)] != known[kpos + 32 * t:kpos + 32 * (t + 1)])) for t in range(words)]
            if best is None or err < best[0]:
                best = (err, n, per)
    return best

plain = ber(x, 8000.0)
tapped = ber(eq, 4800.0)
for label, b in (("plain8k", plain), ("taps4800", tapped)):
    if b is None:
        print(label, "no sync")
        continue
    err, n, per = b
    nz = sum(1 for v in per if v)
    print(label, "biterr", err, "/", n, "words", len(per), "dirty", nz, "mean", round(float(np.mean(per)), 3))
