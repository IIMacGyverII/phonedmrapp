# Match the R3a4 40 Hz low-pass so R3a5 uses the same tops.
import sys
from pathlib import Path
import numpy as np

sys.path.insert(0, r"C:\Users\Joshua\AppData\Local\Temp\fw1718")
import r3_capture

def window(path):
    dev, info = r3_capture.wide_demod(path)
    fs = r3_capture.FS
    a = int(info["i0"]) + int(1.0 * fs)
    b = int(info["i1"]) - int(0.3 * fs)
    seg = dev[a:b] - np.median(dev[a:b])
    return seg, fs

def report(name, y):
    a = np.abs(y)
    print("%s rms %.2f med %.2f p90 %.2f" % (
        name,
        float(np.sqrt(np.mean(y * y))),
        float(np.median(a)),
        float(np.percentile(a, 90))))

def main():
    path = Path(sys.argv[1])
    seg, fs = window(path)
    print("seg", len(seg), "fs", fs)
    report("raw", seg)
    spec = np.fft.rfft(seg)
    freqs = np.fft.rfftfreq(len(seg), 1 / fs)
    cut = spec.copy()
    cut[freqs > 40] = 0
    y = np.fft.irfft(cut, n=len(seg))
    report("fft40", y)
    try:
        from scipy.signal import butter, sosfiltfilt
    except Exception as exc:
        print("no scipy", exc)
        return
    for order in (2, 3, 4, 6, 8):
        sos = butter(order, 40, fs=fs, btype="low", output="sos")
        y = sosfiltfilt(sos, seg)
        report("butter%d" % order, y)

if __name__ == "__main__":
    main()
