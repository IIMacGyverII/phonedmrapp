"""Host-only RRC 4FSK fill for R4a. Does not transmit.

4800 symbols/s, 8000 Hz, alpha 0.5. Six symbols are exactly 10 samples.
306 symbols are 510 samples. Two extra samples repeat the first two so the
512-halfword TX RAM buffer has one 2-sample stitch per 64 ms.
The largest absolute aired count is capped at 5120.
"""
import numpy as np

FS = 8000.0
SYM = 4800.0
ALPHA = 0.5
T = 1.0 / SYM
SPAN = 8
CAP = 5120

BASE = np.array([3, 1, -1, -3, 3, -1], dtype=float)


def rrc(t):
    a = ALPHA
    t = float(t)
    at = abs(t)
    if at < 1e-12:
        return (1.0 - a + 4.0 * a / np.pi) / T
    if abs(at - T / (4.0 * a)) < 1e-9:
        return (a / (T * np.sqrt(2.0))) * (
            (1.0 + 2.0 / np.pi) * np.sin(np.pi / (4.0 * a))
            + (1.0 - 2.0 / np.pi) * np.cos(np.pi / (4.0 * a))
        )
    x = np.pi * t / T
    num = np.sin(x * (1.0 - a)) + 4.0 * a * (t / T) * np.cos(x * (1.0 + a))
    den = x * (1.0 - (4.0 * a * t / T) ** 2)
    return float(num / (den * T))


def synthesize(n_sym, n_samples):
    half = SPAN / 2.0 * T
    y = np.zeros(n_samples)
    for i in range(n_sym):
        t0 = i * T
        n0 = int(np.floor((t0 - half) * FS)) - 1
        n1 = int(np.ceil((t0 + half) * FS)) + 1
        for s in range(max(0, n0), min(n_samples, n1)):
            y[s] += BASE[i % len(BASE)] * rrc(s / FS - t0)
    return y


def main():
    # Warmup symbols on each side, then 306 steady symbols (510 samples).
    pad = 12  # multiple of 3, so the body starts on a sample
    body = 306
    total = pad + body + pad
    n_samples = int(np.ceil(total / SYM * FS)) + 8
    y = synthesize(total, n_samples)
    # Body starts at symbol `pad`. Its first sample index is pad/SYM*FS.
    start = int(round(pad / SYM * FS))
    # 6 symbols = 10 samples, and pad is 10, so start is exact.
    assert abs(pad / SYM * FS - start) < 1e-9
    period = y[start:start + 510]
    assert len(period) == 510
    peak = np.max(np.abs(period))
    grid = np.rint(period * (CAP / peak) / 256.0).astype(int)
    # If rounding pushed a sample to 21, step the scale down and round again.
    while np.max(np.abs(grid)) > 20:
        peak *= 1.01
        grid = np.rint(period * (CAP / peak) / 256.0).astype(int)
    buf = np.concatenate([grid, grid[:2]])
    assert len(buf) == 512
    assert int(np.max(np.abs(buf))) <= 20
    wrapped = [int(v) + 256 if v < 0 else int(v) for v in buf]
    print("float peak before scale", float(np.max(np.abs(period))))
    print("peak immediate", int(np.max(np.abs(buf))))
    print("aired peak", int(np.max(np.abs(buf))) * 256)
    print("unique signed", sorted(set(int(v) for v in buf)))
    print("first 20", wrapped[:20])
    print("join", [int(v) for v in buf[506:512]], "then", int(buf[0]))
    path = r"C:\Users\Joshua\AppData\Local\Temp\fw1718\rrc_immediates.txt"
    with open(path, "w", encoding="utf-8") as f:
        f.write(" ".join(str(v) for v in wrapped))
        f.write("\n")
    print("wrote", path, "n", len(wrapped))


if __name__ == "__main__":
    main()
