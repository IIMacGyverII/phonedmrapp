"""Compare the short R4s capture with the integer RRC model. No transmission."""
import sys
from pathlib import Path

import numpy as np

sys.path.insert(0, r"C:\Users\Joshua\AppData\Local\Temp\fw1718")
sys.path.insert(0, r"D:\Documents\code\personal\phonedmrapp\tools\fw-patch")
sys.path.insert(0, r"D:\Documents\code\personal\phonedmrapp\tools\m17-research")
import camp
import m17
import m17_rrc
import m17_stream_table as tab

pre = [3, -3] * 54
lsf_b = m17.lsf_bytes(tab.BENCH_CALL, tab.BENCH_CALL)
syms = pre + list(m17.encode_lsf(lsf_b))
for i in range(8):
    syms += list(m17.encode_stream(lsf_b, i, bytes(range(16)), i % 6))
counts = m17_rrc.integer_counts(syms).astype(np.float64)
hz = -counts * tab.HZ_PER_COUNT
dev, info = camp.demod(str(camp.CAP / "r4s0_s50.iq"))
fs = camp.FS_A
ref = np.repeat(hz, 6)
i0 = int(info["i0"])
print("keyed %.2f snr %.1f offset %+.0f" % (info["keyed_s"], info["snr_db"], info["offset_hz"]))
x = dev[i0:i0 + int(2.30 * fs)].astype(np.float64)
x -= np.mean(x)
y = ref[:int(1.80 * fs)].astype(np.float64)
y -= np.mean(y)
n = 1 << int(np.ceil(np.log2(len(x) + len(y))))
c = np.fft.irfft(np.fft.rfft(x, n) * np.conj(np.fft.rfft(y, n)), n)
k = int(np.argmax(np.abs(c[:len(x)])))
peak = float(c[k])
den = np.linalg.norm(x[k:k + len(y)]) * np.linalg.norm(y)
print("fft r %+.3f lag %.2f ms" % (peak / den, k / fs * 1000))
# Also the raw 8 kHz counts against every 6th demod sample, sample lag.
air = dev[i0:i0 + int(0.45 * fs):6].astype(np.float64)
mdl = hz[:int(0.22 * 8000)].astype(np.float64)
air -= np.mean(air)
mdl -= np.mean(mdl)
n2 = 1 << int(np.ceil(np.log2(len(air) + len(mdl))))
c2 = np.fft.irfft(np.fft.rfft(air, n2) * np.conj(np.fft.rfft(mdl, n2)), n2)
k2 = int(np.argmax(np.abs(c2[:len(air)])))
den2 = np.linalg.norm(air[k2:k2 + len(mdl)]) * np.linalg.norm(mdl)
print("8k r %+.3f lag %.2f ms" % (float(c2[k2]) / den2, k2 / 8000 * 1000))
