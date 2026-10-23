"""Several POCSAG pages (valid RICs, different texts), optional Gaussian pre-modulation filter, as 48 kHz wav + FM IQ.
usage: make_pages.py <prefix> <deviation> <BT or 0>"""
import sys, wave, numpy as np, importlib.util
sys.path.insert(0, '..'); import pocsag as pc
pre, dev, bt = sys.argv[1], float(sys.argv[2]), float(sys.argv[3])
PAGES = [(1234567, 'FIRST PAGE: WEATHER WARNING'), (200001, 'Net tonight at 1900 local'), (1500003, 'SECOND SESSION 456 ABC'),
         (99999, 'Test 4 lower case and digits 0123'), (2000005, 'DAPNET BENCH TEST 123'), (777777, 'Last page of the bench run')]
fs = 48000; spb = fs / 1200; segs = [np.zeros(fs // 2)]
for ric, msg in PAGES:
    bits = pc.transmission(ric, 3, msg)
    segs.append(np.concatenate([np.full(int(round((i + 1) * spb)) - int(round(i * spb)), -1.0 if b else 1.0) for i, b in enumerate(bits)]))
    segs.append(np.zeros(int(fs * 0.4)))                                   # a short gap between pages
x = np.concatenate(segs + [np.zeros(fs // 2)])
if bt > 0:
    sig = np.sqrt(np.log(2)) / (2 * np.pi * bt) * spb; t = np.arange(-int(4 * sig), int(4 * sig) + 1); gk = np.exp(-t ** 2 / (2 * sig ** 2)); x = np.convolve(x, gk / gk.sum(), 'same')
w = wave.open(pre + '.wav', 'wb'); w.setnchannels(1); w.setsampwidth(2); w.setframerate(fs); w.writeframes((x * 20000).astype('<i2').tobytes()); w.close()
spec = importlib.util.spec_from_file_location('g', '../apt_gen.py'); g = importlib.util.module_from_spec(spec); spec.loader.exec_module(g)
g.fm_iq(pre + '.iq', x, fs, 2000000, dev)
print('wrote', pre, round(len(x) / fs, 1), 's')
