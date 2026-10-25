"""Re-score the saved R-E clips. The runner's 0.8 s window sat in the squelch mute."""
import sys
from pathlib import Path

import numpy as np

sys.path.insert(0, r"D:\Documents\code\personal\phonedmrapp\tools\m17-research")
import m17  # noqa: E402

RD = Path(r"C:\Users\Joshua\AppData\Local\Temp\fw1718\rd10")
RE = Path(r"C:\Users\Joshua\AppData\Local\Temp\fw1718\re")
FS = 8000.0
BODY = 514


def pcm(path):
    blob = path.read_bytes()
    i = blob.find(b"data")
    n = int.from_bytes(blob[i + 4:i + 8], "little")
    return np.frombuffer(blob[i + 8:i + 8 + n], dtype="<i2").astype(np.float64)


def line(x, freq, fs=FS):
    x = np.asarray(x, np.float64)
    x = x - np.mean(x)
    k = np.arange(x.size)
    w = np.exp(-2j * np.pi * freq * k / fs)
    return float(np.abs(np.dot(x, w)) * 2.0 / x.size)


def onset(x, rms_min=800.0):
    win = 400
    for i in range(0, x.size - win, 80):
        sl = x[i:i + win]
        rms = float(np.sqrt(np.mean((sl - np.mean(sl)) ** 2)))
        if rms >= rms_min:
            return i
    return 0


def report_tone(name, freq):
    x = pcm(RD / (name + ".wav"))
    i = onset(x)
    tail = x[i:]
    # last 0.4 s, and the whole loud region
    last = x[-int(0.4 * FS):]
    print("%s onset %.3f s  loud_n=%d  %d Hz line loud %.1f  last0.4 %.1f  rms loud %.1f" % (
        name, i / FS, tail.size, freq, line(tail, freq) if tail.size > 400 else -1,
        line(last, freq), float(np.sqrt(np.mean((tail - np.mean(tail)) ** 2)))))


def decode_one(name, scale, x0=None):
    x = pcm(RD / (name + ".wav")) if x0 is None else x0
    i = onset(x)
    seg = x[i:]
    print("---", name, "onset %.3f s dur %.3f scale %.4f" % (i / FS, seg.size / FS, scale))
    for sign, pol in ((1.0, "as_captured"), (-1.0, "inverted")):
        dev = seg * scale * sign
        res = m17.decode_transmission(dev, FS, verbose=False)
        y, sps = m17.demod(dev, FS)
        # best sync anywhere
        best = -1.0
        n = len(y)
        if n > 8 * sps:
            idx = np.arange(0, n - 8 * sps, sps)  # coarse, one per symbol
            for kind in ("lsf", "str"):
                s = m17.SYNC_SYMS[kind]
                V = np.stack([y[idx + m * sps] for m in range(8)], 1)
                sc = V @ s / (np.sqrt(np.dot(s, s) * np.sum(V * V, 1)) + 1e-12)
                best = max(best, float(np.max(sc)))
        lsf = res["lsf"]
        frames = res["frames"]
        golay0 = sum(1 for fn, p, e in frames if e == 0)
        print("  %s best_sync %.3f crc=%s src=%s dst=%s frames=%d golay0=%d fn=%s golay=%s" % (
            pol, best,
            lsf[2] if lsf else None,
            lsf[0] if lsf else None,
            lsf[1] if lsf else None,
            len(frames), golay0,
            [int(fn) & 0xFFFF for fn, p, e in frames[:12]],
            [int(e) for fn, p, e in frames[:12]]))


def be(raw):
    x = np.empty(len(raw) // 2, np.float64)
    for i in range(x.size):
        v = (raw[2 * i] << 8) | raw[2 * i + 1]
        if v >= 32768:
            v -= 65536
        x[i] = v
    return x


def load_bin(path):
    raw = path.read_bytes()
    parts = []
    for i in range(0, len(raw) - BODY + 1, BODY):
        b = raw[i:i + BODY]
        parts.append((int(b[512]), int(b[513]), be(b[:512])))
    parts.sort()
    return parts


def fit_sine(x, freq):
    t = np.arange(x.size) / FS
    A = np.column_stack([np.sin(2 * np.pi * freq * t), np.cos(2 * np.pi * freq * t), np.ones_like(t)])
    coef, *_ = np.linalg.lstsq(A, x, rcond=None)
    resid = x - A @ coef
    return coef, resid


print("== phone tones, loud region ==")
report_tone("re_h3_before", 100)
report_tone("re_h3_1k", 1000)
report_tone("re_h3_after", 100)
report_tone("re_h3_tuned", 100)
report_tone("re_h3_reheld", 100)
report_tone("h3_100", 100)
report_tone("h3_1000", 1000)

x1 = pcm(RD / "re_h3_1k.wav")
i1 = onset(x1)
ref = line(x1[i1:], 1000)
scale = 2500.0 / ref
print("held 1 kHz loud line %.1f scale %.4f" % (ref, scale))
# also last 0.4 s scale
scale_tail = 2500.0 / line(x1[-int(0.4 * FS):], 1000)
print("held 1 kHz last 0.4 line %.1f scale %.4f" % (2500.0 / scale_tail, scale_tail))

print("== phone M17, loud region, scale from loud 1 kHz ==")
for name in ("re_phone_m17_0", "re_phone_m17_1", "re_phone_m17_2"):
    decode_one(name, scale)
print("== plain control, R-D plain scale and measured ==")
xp = pcm(RD / "re_phone_plain.wav")
decode_one("re_phone_plain", 2500.0 / 6529.7, xp)

print("== 310 Hz phase across halves ==")
for name in ("re_310_0", "re_310_1", "re_310_2"):
    parts = load_bin(RE / (name + ".bin"))
    x = np.concatenate([p[2] for p in parts])
    coef, resid = fit_sine(x, 310.0)
    per = [float(np.sqrt(np.mean(resid[h * 256:(h + 1) * 256] ** 2))) for h in range(6)]
    # independent phase per half
    phases = []
    for h in range(6):
        sl = x[h * 256:(h + 1) * 256]
        c, r = fit_sine(sl, 310.0)
        phases.append(float(np.degrees(np.arctan2(c[1], c[0]))))
        per_h = float(np.sqrt(np.mean(r ** 2)))
        if h == 0:
            per0 = per_h
    d = np.abs(np.diff(x))
    # boundary diffs
    bounds = [int(d[256 * k - 1]) for k in range(1, 6)]
    print(name, "halves", [p[1] for p in parts], "global resid", [round(v, 1) for v in per],
          "half0 own resid %.1f" % per0, "phases", [round(p, 1) for p in phases],
          "boundary |diff|", bounds, "max step", int(np.argmax(d)), float(d[int(np.argmax(d))]))

print("== RAM 1 kHz continuity ==")
lines = []
for name in ("re_1k_0", "re_1k_1", "re_1k_2", "re_1k_3", "re_1k_4"):
    parts = load_bin(RE / (name + ".bin"))
    x = np.concatenate([p[2] for p in parts])
    ln = line(x, 1000)
    lines.append(ln)
    # phase per half
    phases = []
    for h in range(6):
        c, _ = fit_sine(x[h * 256:(h + 1) * 256], 1000.0)
        phases.append(float(np.degrees(np.arctan2(c[1], c[0]))))
    jumps = [((phases[h + 1] - phases[h] + 180) % 360) - 180 for h in range(5)]
    print(name, "line %.1f" % ln, "phase jumps deg", [round(j, 1) for j in jumps])
print("median line", float(np.median(lines)))
