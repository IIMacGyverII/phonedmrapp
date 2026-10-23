import sys, wave, numpy as np, importlib.util
spec = importlib.util.spec_from_file_location('p', 'pocsag.py'); p = importlib.util.module_from_spec(spec); spec.loader.exec_module(p)
w = wave.open(sys.argv[1]); fs = w.getframerate(); x = np.frombuffer(w.readframes(w.getnframes()), '<i2').astype(float)
fc = float(sys.argv[2]) if len(sys.argv) > 2 else 0
if fc > 0: x = x + np.cumsum(x) * 2 * np.pi * fc / fs
k = int(fs / 30); x = x - np.convolve(x, np.ones(k) / k, mode='same')
baud = 1200; spb = fs / baud
for pol in (1, -1):
    bits = []; phase = 0.0; prev = x[0]; gain = 0.15
    for n in range(1, len(x)):
        v = x[n]
        if (v > 0) != (prev > 0):                                  # a crossing: should fall on a bit boundary
            frac = prev / (prev - v)                              # sub-sample position
            err = (phase - 1) + frac / spb if phase > 0.5 else phase + frac / spb
            phase -= gain * (err if phase <= 0.5 else (phase - 1 + frac / spb))
        phase += 1 / spb
        if phase >= 0.5 and (phase - 1 / spb) < 0.5: bits.append(1 if pol * v < 0 else 0)
        if phase >= 1: phase -= 1
        prev = v
    batches = p.decode_bits(bits)
    good = sum(p.check(c) for b in batches for c in b); tot = sum(len(b) for b in batches)
    print("fc", fc, "pol", pol, "bits", len(bits), "batches", len(batches), "valid", good, "/", tot)
    S = [(p.SYNC >> (31 - i)) & 1 for i in range(32)]
    best = (99, -1)
    for i in range(len(bits) - 32):
        d = sum(1 for j in range(32) if bits[i + j] != S[j])
        if d < best[0]: best = (d, i)
    print("   closest sync: %d bit errors at bit %d" % best, "context:", ''.join(map(str, bits[max(0, best[1] - 16):best[1] + 48])))
