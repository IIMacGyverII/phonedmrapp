"""Phase sweep: is +/-3.3 kHz the tight eye, or a transition?"""
import json
from pathlib import Path

import numpy as np

import importlib.util
spec = importlib.util.spec_from_file_location("lv", r"C:\Users\Joshua\AppData\Local\Temp\fw1718\r1b_levels.py")
lv = importlib.util.module_from_spec(spec)
spec.loader.exec_module(lv)

z = lv.load_iq()
zd = lv.lpf(lv.decimate(z, 30), 80_000, 20000)
fs = 80_000
runs, _ = lv.bursts(zd, fs)
dev = lv.inst(zd, fs)
# Carrier = OBW midpoint, not the centroid.
spec_obw = lv.obw(zd, runs, fs)
carrier = spec_obw["midpoint_hz"]
dev = dev - carrier
sps = fs / lv.SYMS
rows = []
for ph in np.linspace(0, sps, 40, endpoint=False):
    x, _ = lv.gather(dev, runs, fs, float(ph))
    if len(x) < 200:
        continue
    fit = lv.four_means(x)
    if fit is None:
        continue
    lev, _, counts, _, rms = fit
    mid = 0.5 * (lev[0] + lev[3])
    c = lev - mid
    outer = 0.5 * (abs(c[0]) + abs(c[3]))
    inner = 0.5 * (abs(c[1]) + abs(c[2]))
    rows.append({
        "phase": round(float(ph), 3),
        "rms": round(rms, 1),
        "outer": round(float(outer), 1),
        "inner": round(float(inner), 1),
        "ratio": round(float(inner / outer), 3),
        "counts": counts,
    })
rows.sort(key=lambda r: r["rms"])
Path(r"C:\Users\Joshua\AppData\Local\Temp\fw1718\r1b_phase.json").write_text(json.dumps(rows, indent=2), encoding="utf-8")
print("carrier_mid", round(carrier, 1), "obw", spec_obw["obw_99_hz"])
for r in rows[:8]:
    print(r)
print("--- worst ---")
for r in rows[-3:]:
    print(r)
