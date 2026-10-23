"""HackRF capture (int8 IQ, 2.4 MS/s, signal at +240 kHz) -> flat FM discriminator audio at 48 kHz (a pager's view).  cap2wav.py in.iq out.wav"""
import sys, wave, numpy as np
fs = 2_400_000; off = 240_000; dec = 50
iq = np.fromfile(sys.argv[1], dtype=np.int8).astype(np.float32); z = iq[0::2] + 1j * iq[1::2]
z = z * np.exp(-2j * np.pi * off * np.arange(len(z)) / fs)
n = len(z) // dec; zd = z[:n * dec].reshape(n, dec).mean(axis=1)
a = np.angle(zd[1:] * np.conj(zd[:-1])) * (fs / dec) / (2 * np.pi)       # Hz of deviation
a = a - np.median(a)
print('deviation p99 %.0f Hz' % np.percentile(np.abs(a), 99))
w = wave.open(sys.argv[2], 'wb'); w.setnchannels(1); w.setsampwidth(2); w.setframerate(fs // dec); w.writeframes(np.clip(a * 5, -32767, 32767).astype('<i2').tobytes()); w.close()
