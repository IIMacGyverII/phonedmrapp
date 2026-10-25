# Steady-window FFT of the R3a3 key. Reads the capture only.
import json, sys
from pathlib import Path

import numpy as np

sys.path.insert(0, r"C:\Users\Joshua\AppData\Local\Temp\fw1718")
import camp
import r3_capture

dev, info = r3_capture.wide_demod(camp.CAP / "r3a3.iq")
fs = r3_capture.FS
i0, i1 = int(info["i0"]), int(info["i1"])
# Drop the key-up second (the 18 kHz p99 lives there) and the unkey edge.
a = i0 + int(1.0 * fs)
b = i1 - int(0.3 * fs)
seg = dev[a:b] - np.median(dev[a:b])
w = np.hanning(len(seg))
spec = np.fft.rfft(seg * w)
freqs = np.fft.rfftfreq(len(seg), 1 / fs)
amp = 2 * np.abs(spec) / np.sum(w)

def near(f):
    i = int(np.argmin(np.abs(freqs - f)))
    return float(freqs[i]), float(amp[i])

lines = [15.625, 31.25, 46.875, 62.5, 78.125, 93.75, 250, 500, 1000, 2000, 3000]
# noise: 5–40 Hz, excluding 14–18 Hz
band = (freqs >= 5) & (freqs <= 40) & ~((freqs >= 14) & (freqs <= 18))
noise = float(np.median(amp[band]))
out = {
    "steady_s": round(len(seg) / fs, 3),
    "rms_hz": round(float(np.sqrt(np.mean(seg ** 2))), 2),
    "p99_hz": round(float(np.percentile(np.abs(seg), 99)), 2),
    "noise_5_40_hz": round(noise, 3),
    "lines": [{"f": f, "bin_hz": round(near(f)[0], 3), "amp_hz": round(near(f)[1], 2)} for f in lines],
}
# 100 ms slices from the start of the carrier, f15 and f1k
slices = []
for k in range(0, int(3.2 * fs), int(0.1 * fs)):
    s0, s1 = i0 + k, i0 + k + int(0.1 * fs)
    if s1 > i1:
        break
    x = dev[s0:s1] - np.median(dev[s0:s1])
    slices.append({
        "t": round(k / fs, 2),
        "rms": round(float(np.sqrt(np.mean(x ** 2))), 1),
        "p99": round(float(np.percentile(np.abs(x), 99)), 1),
        "f15": round(r3_capture.goertzel(x, fs, 15.625), 1),
        "f1k": round(r3_capture.goertzel(x, fs, 1000), 1),
    })
out["slices_100ms"] = slices
Path(r"C:\Users\Joshua\AppData\Local\Temp\fw1718\r3a3_fft.json").write_text(
    json.dumps(out, indent=2), encoding="utf-8")
print(json.dumps({k: out[k] for k in ("steady_s", "rms_hz", "p99_hz", "noise_5_40_hz", "lines")}, indent=2))
print("slices", json.dumps(slices))
