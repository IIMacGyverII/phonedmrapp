"""What the short R4s burst actually looks like. No transmission."""
import sys
import numpy as np

sys.path.insert(0, r"C:\Users\Joshua\AppData\Local\Temp\fw1718")
import camp

dev, info = camp.demod(str(camp.CAP / "r4s0_s50.iq"))
fs = camp.FS_A
i0 = int(info["i0"])
print("i0", i0, "keyed", round(info["keyed_s"], 2))
for ms in range(0, 500, 20):
    sl = dev[i0 + int(ms / 1000 * fs):i0 + int((ms + 20) / 1000 * fs)]
    if len(sl) < 10:
        break
    print("ms %3d mean %+6.0f std %5.0f p99 %5.0f" % (
        ms, np.mean(sl), np.std(sl), np.percentile(np.abs(sl), 99)))
seg = dev[i0 + int(0.08 * fs):i0 + int(0.22 * fs)].astype(np.float64)
seg -= np.mean(seg)
w = np.hanning(len(seg))
spec = np.abs(np.fft.rfft(seg * w))
freqs = np.fft.rfftfreq(len(seg), 1 / fs)
# The deviation's own spectrum: a 4FSK eye is not a tone. A stuck rail is DC.
order = np.argsort(spec)[-6:][::-1]
print("top Hz", " ".join("%d:%d" % (freqs[i], spec[i]) for i in order if freqs[i] < 6000))
# Autocorrelation peak between 0.15 and 0.5 ms (symbol clock).
ac = np.correlate(seg, seg, "full")
ac = ac[len(ac) // 2:]
lo, hi = int(0.00012 * fs), int(0.0006 * fs)
k = lo + int(np.argmax(ac[lo:hi]))
print("ac peak %.3f ms ratio %.2f" % (k / fs * 1000, ac[k] / ac[0]))
