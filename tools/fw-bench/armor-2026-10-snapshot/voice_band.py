"""Compare speech energy below 250 Hz in the source and in each demod. No transmission."""
import numpy as np
from pathlib import Path

caps = Path(r"C:\Users\Joshua\AppData\Local\Temp\fw1718\caps")
wav = Path(r"C:\Users\Joshua\AppData\Local\Temp\fw1718\wav")

def pcm(path):
    b = path.read_bytes()
    return np.frombuffer(b[44:], dtype="<i2").astype(np.float64)

def low_frac(x, fs, cut=250):
    if len(x) < fs // 5:
        return float("nan")
    w = np.hanning(len(x))
    spec = np.fft.rfft(x * w)
    p = np.abs(spec) ** 2
    f = np.fft.rfftfreq(len(x), 1 / fs)
    return float(p[f < cut].sum() / (p.sum() + 1e-12))

src = pcm(wav / "speech_src.wav") if (wav / "speech_src.wav").exists() else None
print("source", None if src is None else (len(src), round(low_frac(src, 8000), 3)))
for name in ("UV4T", "UVm2", "UVm3", "UVm4"):
    y = pcm(caps / ("%s_voice_demod.wav" % name))
    # demod is deviation scaled so ±5000 Hz is full scale
    print(name, "n", len(y), "low250", round(low_frac(y, 48000), 3),
          "rms_counts", round(float(np.sqrt(np.mean(y * y)))))
