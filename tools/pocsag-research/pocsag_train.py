"""Fit an equalizer for the radio's audio path from a recording of a known POCSAG page.
python -P pocsag_train.py <rec.wav> [taps] [--test other.wav]"""
import sys, wave, numpy as np, importlib.util
spec = importlib.util.spec_from_file_location('p', 'pocsag.py'); p = importlib.util.module_from_spec(spec); spec.loader.exec_module(p)
fs = 8000; baud = 1200; spb = fs / baud

def load(path):
    w = wave.open(path); return np.frombuffer(w.readframes(w.getnframes()), '<i2').astype(float) / 32768

bits = p.transmission(1234567, 3, 'DAPNET BENCH TEST 123')
bits = bits + bits                                                  # gen --repeat 2
ideal = np.concatenate([np.full(int(round((i + 1) * spb)) - int(round(i * spb)), -1.0 if b else 1.0) for i, b in enumerate(bits)])

def align(x):
    # coarse: correlate with the ideal at a few clock rates; return (offset, rate, sign)
    best = (0, 0, 1, 1.0)
    for rate in np.linspace(0.998, 1.002, 81):
        t = np.arange(len(ideal)) * rate
        ii = np.interp(np.arange(0, len(ideal) * rate), t, ideal)
        c = np.correlate(x, ii[:len(x)] if len(ii) > len(x) else ii, mode='valid') if len(x) > len(ii) else np.correlate(ii, x, mode='valid')
        k = np.argmax(np.abs(c)); v = abs(c[k])
        if v > best[0]: best = (v, k if len(x) > len(ii) else -k, np.sign(c[k]), rate)
    return best

def design(x, y, taps):
    n = len(y); half = taps // 2
    rows = []
    X = np.zeros((n, taps + 1))
    xp = np.concatenate([np.zeros(half), x, np.zeros(half)])
    for k in range(taps): X[:, k] = xp[k:k + n]
    X[:, taps] = np.cumsum(x)[:n] / fs                              # an integrator term restores the low end the high-pass removed
    w, *_ = np.linalg.lstsq(X, y, rcond=None)
    return w, X @ w

x = load(sys.argv[1]); taps = int(sys.argv[2]) if len(sys.argv) > 2 and sys.argv[2].isdigit() else 41
v, off, sign, rate = align(x)
print("align offset", off, "sign", sign, "clock", rate)
t = np.arange(len(x)) - off
y = np.interp(t / rate, np.arange(len(ideal)), ideal, left=0, right=0) * sign
w, z = design(x, y, taps)
idx = (off + (np.arange(len(bits)) + 0.5) * spb * rate).astype(int); idx = idx[idx < len(z)]
got = [1 if sign * z[k] < 0 else 0 for k in idx]
err = sum(1 for a, b in zip(got, bits) if a != b)
print("taps", taps, "bit errors after the equalizer: %d of %d" % (err, len(got)))
raw = [1 if sign * x[k] < 0 else 0 for k in idx]
print("bit errors without it: %d" % sum(1 for a, b in zip(raw, bits) if a != b))
np.save('pocsag_eq.npy', w)
print("weights:", np.round(w[:taps], 4).tolist(), "integrator", w[taps])
