"""Try equalizers on a radio recording of a POCSAG page: undo a first-order high-pass at fc (add fc*integral)."""
import sys, wave, numpy as np, importlib.util
spec = importlib.util.spec_from_file_location('p', 'pocsag.py'); p = importlib.util.module_from_spec(spec); spec.loader.exec_module(p)
w = wave.open(sys.argv[1]); fs = w.getframerate(); x = np.frombuffer(w.readframes(w.getnframes()), '<i2').astype(float) / 32768
baud = 1200; spb = fs / baud

def try_bits(z, label):
    best = (0, None)
    for pol in (1, -1):
        for ph in np.linspace(0, spb, 12, endpoint=False):
            idx = np.arange(ph + spb / 2, len(z) - 1, spb).astype(int)
            bits = [1 if pol * z[k] < 0 else 0 for k in idx]
            batches = p.decode_bits(bits)
            good = sum(p.check(c) for b in batches for c in b); tot = sum(len(b) for b in batches)
            if good > best[0]: best = (good, (pol, ph, len(batches), tot))
    print(label, "valid", best[0], best[1])
    return best[0]

for fc in [0, 100, 200, 300, 400, 600, 800]:
    z = x.copy()
    if fc > 0:
        a = 2 * np.pi * fc / fs
        integ = np.cumsum(x) * a
        z = x + integ
    # remove what drifts slower than 20 Hz
    k = int(fs / 20); z = z - np.convolve(z, np.ones(k) / k, mode='same')
    try_bits(z, "fc %4d" % fc)
# de-emphasis undo too: pre-emphasis (differentiate a little) then high-pass undo
for fc in [200, 300, 400]:
    for tau_us in [75, 150, 300]:
        d = np.diff(x, prepend=x[0]) * (tau_us * 1e-6 * fs)
        y = x + d
        a = 2 * np.pi * fc / fs
        z = y + np.cumsum(y) * a
        k = int(fs / 20); z = z - np.convolve(z, np.ones(k) / k, mode='same')
        try_bits(z, "fc %d preemph %dus" % (fc, tau_us))
