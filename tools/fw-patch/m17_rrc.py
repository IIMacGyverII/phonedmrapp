"""Five-phase RRC for the module wake.

Host only. Output sample n is the 48 kHz RRC at sample 6n, which is symbol
time 0.6 n. A long run of +3 is +2400 Hz, then the table-generator scale
(minus Hz / 0.54, capped at 6451) makes the stored count. The integer
model is what the firmware runs: Q15 taps, 32-bit accumulate, arithmetic
shift. OUTER_SCALE stays 1: R4r was already at the count cap.
"""
import sys
from pathlib import Path

import numpy as np

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "m17-research"))
import m17  # noqa: E402
import m17_stream_table as tab  # noqa: E402

TAPS = 9
PHASES = 5
Q = 15


def float_hz(syms):
    """Same samples deviation() returns at 8 kHz."""
    return m17.deviation(np.asarray(syms, float), tab.FS)


def _kernel():
    sps = 10
    h = m17.rrc(0.5, 8, sps)
    run = np.zeros(400 * sps)
    run[::sps] = 3
    yr = np.convolve(run, h, "full")[len(h) // 2:][:len(run)]
    return h * (3 * m17.DEV_PER_UNIT / yr[len(yr) // 2])


def coeff_hz():
    """phases by 9 taps. Tap i multiplies the symbol at floor(0.6 n) - 4 + i."""
    h = _kernel()
    center = len(h) // 2
    out = np.zeros((PHASES, TAPS))
    # Sample 6n of the 48 kHz stream. Phase is (3*n) % 5, and the symbol
    # under the cursor is (3*n) // 5. The tap at symbol (base - 4 + i)
    # hits filter index center + 6*n - 10*symbol.
    for rem in range(PHASES):
        # Pick an n with this phase and a base far from the edge.
        n = rem  # (3*0)%5=0, so search
        while (3 * n) % 5 != rem:
            n += 1
        base = (3 * n) // 5
        for i in range(TAPS):
            sym = base - 4 + i
            j = center + 6 * n - 10 * sym
            if 0 <= j < len(h):
                out[rem, i] = h[j]
    return out


def q15_coeffs():
    """Integer taps. count ~= sum(symbol * q15) >> 15, then the minus sign."""
    c = coeff_hz()
    # count = -hz / HZ_PER_COUNT = sum(sym * (-tap_hz / HZ_PER_COUNT))
    scaled = -c / tab.HZ_PER_COUNT
    peak = np.max(np.abs(scaled))
    if peak <= 0:
        raise RuntimeError("empty kernel")
    q = np.rint(scaled / peak * 32767.0).astype(np.int32)
    # gain puts the Q15 sum back into counts: (acc * gain) >> 15
    gain = int(np.rint(peak * 32768.0 / 32767.0))
    return q, gain


def coeff_bytes():
    q, gain = q15_coeffs()
    raw = bytearray()
    for v in q.reshape(-1):
        u = int(v) & 0xFFFF
        raw.append(u & 0xFF)
        raw.append((u >> 8) & 0xFF)
    g = gain & 0xFFFF
    raw.append(g & 0xFF)
    raw.append((g >> 8) & 0xFF)
    return bytes(raw)


def integer_counts(syms):
    """Bit model of the wake: Q15 taps, 32-bit mac, shift, clamp."""
    q, gain = q15_coeffs()
    syms = [0] * 8 + [int(s) for s in syms] + [0] * 8
    # The float stream starts at symbol 0. Eight leading zeros keep the
    # first taps inside the list; the caller compares after the same pad
    # only on the integer side, and the float comparison uses the unpadded
    # symbols. The index math below uses the unpadded timeline.
    src = [int(s) for s in syms[8:-8]]
    n_out = len(src) * tab.FS // m17.SYM_RATE
    out = np.zeros(n_out, np.int32)
    for n in range(n_out):
        base = (3 * n) // 5
        rem = (3 * n) % 5
        acc = 0
        for i in range(TAPS):
            s = base - 4 + i
            if 0 <= s < len(src):
                acc += src[s] * int(q[rem, i])
        val = (acc * gain) >> Q
        if val > tab.PEAK_CAP:
            val = tab.PEAK_CAP
        elif val < -tab.PEAK_CAP:
            val = -tab.PEAK_CAP
        out[n] = val
    return out


def float_counts(syms):
    y = float_hz(syms)
    body = np.rint(-y / tab.HZ_PER_COUNT).astype(np.int32)
    peak = int(np.max(np.abs(body)))
    if peak > tab.PEAK_CAP:
        body = np.rint(body.astype(float) * (tab.PEAK_CAP / peak)).astype(np.int32)
    return body


DIBIT = {1: 0, 3: 1, -1: 2, -3: 3}


def pack_symbols(syms):
    """Four symbols per byte, first symbol in bits 7:6. 01=+3, 00=+1, 10=-1, 11=-3."""
    syms = [int(s) for s in syms]
    if len(syms) % 4:
        raise ValueError("symbol count %d" % len(syms))
    out = bytearray()
    for i in range(0, len(syms), 4):
        b = 0
        for k in range(4):
            b = (b << 2) | DIBIT[syms[i + k]]
        out.append(b)
    return bytes(out)


def match(syms):
    a = integer_counts(syms).astype(float)
    b = float_counts(syms).astype(float)
    n = min(len(a), len(b))
    a, b = a[:n], b[:n]
    # Drop the filter tails, where the two edge conventions differ.
    sl = slice(40, n - 40) if n > 80 else slice(0, n)
    aa, bb = a[sl], b[sl]
    if not np.any(bb):
        return 0.0, 0
    r = np.corrcoef(aa, bb)[0, 1]
    return float(r * r), int(np.max(np.abs(aa - bb)))


if __name__ == "__main__":
    pre = [3, -3] * 54
    lsf_b = m17.lsf_bytes(tab.BENCH_CALL, tab.BENCH_CALL)
    syms = pre + m17.encode_lsf(lsf_b)
    for i in range(3):
        fn = i | (0x8000 if i == 2 else 0)
        syms += m17.encode_stream(lsf_b, fn, bytes(range(16)), i % 6)
    r2, err = match(syms)
    unc = np.max(np.abs(np.rint(-float_hz(syms) / tab.HZ_PER_COUNT)))
    print("r2", round(r2, 4), "maxabs", err, "uncapped", int(unc), "q", q15_coeffs()[0].shape, "gain", q15_coeffs()[1])
