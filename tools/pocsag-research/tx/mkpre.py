"""Pre-distorted POCSAG pages for the phone's transmitter: NRZ -> inverse filter (pre_*.npy, fitted on the drive-12000
calibration where 1.0 = PCM 12000) scaled for a target deviation.  mkpre.py <pre.npy> <target Hz> <out.wav>"""
import sys, wave, numpy as np
sys.path.insert(0, '..'); import pocsag as pc
g = np.load(sys.argv[1]); target = float(sys.argv[2]); out = sys.argv[3]
bits = []
for ric, msg in ((1234567, 'SIGNALDECK TX TEST ONE'), (200001, 'Second page from the phone'), (777777, 'Third page 0123456789')): bits += pc.transmission(ric, 3, msg)
spb = 8000 / 1200
nrz = np.concatenate([np.full(int(round((i + 1) * spb)) - int(round(i * spb)), -1.0 if b else 1.0) for i, b in enumerate(bits)])
nrz = np.concatenate([np.zeros(2000), nrz, np.zeros(2000)])
pre = np.convolve(nrz, g)[:len(nrz)] * target                             # in units where 1.0 = PCM 12000
pcm = pre * 12000.0
print('PCM peak %.0f (p99.5 %.0f), clipped %.2f%%' % (np.abs(pcm).max(), np.percentile(np.abs(pcm), 99.5), 100 * np.mean(np.abs(pcm) > 30000)))
pcm = np.clip(pcm, -30000, 30000)
w = wave.open(out, 'wb'); w.setnchannels(1); w.setsampwidth(2); w.setframerate(8000); w.writeframes(pcm.astype('<i2').tobytes()); w.close()
