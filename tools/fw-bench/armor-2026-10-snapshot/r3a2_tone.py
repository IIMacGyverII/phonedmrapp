import json, sys
import numpy as np
sys.path.insert(0, r"C:\Users\Joshua\AppData\Local\Temp\fw1718")
import r3_capture

dev, info = r3_capture.wide_demod(r"C:\Users\Joshua\AppData\Local\Temp\fw1718\caps\r3a2.iq")
fs = r3_capture.FS
i0, i1 = info["i0"], info["i1"]
# steady middle: drop 0.4 s at each end of the carrier
a = i0 + int(0.4 * fs)
b = i1 - int(0.4 * fs)
seg = dev[a:b]
seg = seg - np.median(seg)
print("steady %.3f s  rms %.1f  p99 %.1f  clip %s" % ((b - a) / fs, np.sqrt(np.mean(seg ** 2)), np.percentile(np.abs(seg), 99), info["clip_frac"]))
# zero crossings
s = np.sign(seg)
s[s == 0] = 1
zc = int(np.sum(s[1:] * s[:-1] < 0))
print("zero_cross_per_s %.1f" % (zc / ((b - a) / fs)))
w = np.hanning(len(seg))
sp = np.abs(np.fft.rfft(seg * w))
sp = 2 * sp / np.sum(w)
freqs = np.fft.rfftfreq(len(seg), 1 / fs)
# ignore DC
sp[0] = 0
order = np.argsort(sp)[::-1]
print("top peaks Hz / amp")
shown = 0
last = -100.0
for k in order:
    f = float(freqs[k])
    if f < 5 or f > 4000:
        continue
    if abs(f - last) < 8:
        continue
    print("  %8.1f  %7.1f" % (f, sp[k]))
    last = f
    shown += 1
    if shown >= 15:
        break
# band powers
def band(f0, f1):
    m = (freqs >= f0) & (freqs < f1)
    return float(np.sqrt(np.sum(sp[m] ** 2) / 2))
print("band_rms 0-100 %.1f  100-400 %.1f  800-1200 %.1f  1200-2500 %.1f  2500-4000 %.1f" % (
    band(0, 100), band(100, 400), band(800, 1200), band(1200, 2500), band(2500, 4000)))
# 1 kHz neighborhood peak
m = (freqs >= 900) & (freqs <= 1100)
k = int(np.argmax(np.where(m, sp, 0)))
print("near_1k %.1f Hz amp %.1f" % (freqs[k], sp[k]))
json.dump({"zc_per_s": zc / ((b - a) / fs), "rms": float(np.sqrt(np.mean(seg ** 2)))}, open(r"C:\Users\Joshua\AppData\Local\Temp\fw1718\r3a2_tone.json", "w"))
