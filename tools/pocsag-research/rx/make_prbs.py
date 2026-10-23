"""Calibration signal: 576-bit preamble + N pseudo-random bits, 1200 baud NRZ (a 1 = lower frequency), as 48 kHz wav
and 2 MS/s FM IQ.  usage: make_prbs.py <prefix> <deviation Hz> <nbits>"""
import sys, wave, numpy as np, importlib.util
pre, dev, n = sys.argv[1], float(sys.argv[2]), int(sys.argv[3])
rng = np.random.default_rng(12345)
bits = [1, 0] * 288 + list(rng.integers(0, 2, n))
fs = 48000; spb = fs / 1200
x = np.concatenate([np.zeros(fs // 2)] + [np.full(int(round((i + 1) * spb)) - int(round(i * spb)), -1.0 if b else 1.0) for i, b in enumerate(bits)] + [np.zeros(fs // 2)])
if len(sys.argv) > 4:                                                     # pre-modulation filter (Gaussian, BT given), as pager transmitters do
    bt = float(sys.argv[4]); sig = np.sqrt(np.log(2)) / (2 * np.pi * bt) * spb; t = np.arange(-int(4 * sig), int(4 * sig) + 1)
    gk = np.exp(-t ** 2 / (2 * sig ** 2)); gk /= gk.sum(); x = np.convolve(x, gk, 'same')
w = wave.open(pre + '.wav', 'wb'); w.setnchannels(1); w.setsampwidth(2); w.setframerate(fs); w.writeframes((x * 20000).astype('<i2').tobytes()); w.close()
spec = importlib.util.spec_from_file_location('g', 'apt_gen.py'); g = importlib.util.module_from_spec(spec); spec.loader.exec_module(g)
g.fm_iq(pre + '.iq', x, fs, 2000000, dev)
print('wrote', pre, len(bits), 'bits', round(len(x) / fs, 1), 's')
