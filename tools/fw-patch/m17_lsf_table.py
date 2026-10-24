"""R4b TX-RAM table: one M17 link-setup frame in the 512-sample loop.

Host only. The R4a copy stub is unchanged and still runs only on a host
key. Samples are 16-bit PCM, high byte at the low address. R4a measured
-0.54 Hz per count on this path, so each stored count is minus the
rounded Hz/0.54. A long run of symbol +3 is aimed at +2400 Hz; the RRC
overshoot of the 0x77 preamble sits higher and is what the deviation
prediction uses.

The buffer holds 108 preamble symbols (the 0x77 pattern, +3 -3), the
192-symbol link-setup frame, and 6 zero symbols of filter tail: 510
samples. The last two samples are zero. 192 symbols do not fit an integer
number of times in 512 samples, so this loop is not a stream. It is one
frame per 64 ms.
"""
import sys
from pathlib import Path

import numpy as np

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "m17-research"))
import m17  # noqa: E402

FS = 8000
HZ_PER_COUNT = 0.54
STOP_SLOPE = 0.55
PREAMBLE = 108
TAIL = 6
BENCH_CALL = "N0CALL"


def symbols():
    pre = np.array([3.0, -3.0] * (PREAMBLE // 2))
    lsf = np.array(m17.encode_lsf(m17.lsf_bytes(BENCH_CALL, BENCH_CALL)), float)
    if len(lsf) != 192:
        raise RuntimeError("LSF is %d symbols" % len(lsf))
    return np.concatenate([pre, lsf, np.zeros(TAIL)])


def waveform_hz():
    syms = symbols()
    if len(syms) % 3:
        raise RuntimeError("symbol count must be a multiple of 3")
    y = m17.deviation(syms, FS)
    expect = len(syms) * FS // m17.SYM_RATE
    if len(y) != expect:
        raise RuntimeError("got %d samples, expected %d" % (len(y), expect))
    if len(y) > 512:
        raise RuntimeError("frame does not fit in 512 samples")
    return y


def counts():
    """Signed PCM counts as the TX RAM hardware reads them."""
    y = waveform_hz()
    body = np.rint(-y / HZ_PER_COUNT).astype(np.int32)
    if np.max(np.abs(body)) > 32767:
        raise RuntimeError("sample does not fit in 16 bits")
    buf = np.zeros(512, np.int32)
    buf[:len(body)] = body
    return buf


def table_bytes(pcm=None):
    """1024 file bytes. Low address holds the high byte of the sample."""
    pcm = counts() if pcm is None else pcm
    out = bytearray()
    for s in pcm:
        u = int(s) & 0xFFFF
        out.append((u >> 8) & 0xFF)
        out.append(u & 0xFF)
    if len(out) != 1024:
        raise RuntimeError("table is %d bytes" % len(out))
    return bytes(out)


def prediction(pcm=None):
    pcm = counts() if pcm is None else pcm
    peak = int(np.max(np.abs(pcm)))
    return {
        "peak_count": peak,
        "aimed_hz": round(peak * HZ_PER_COUNT, 1),
        "stop_hz": round(peak * STOP_SLOPE, 1),
    }


def main():
    pcm = counts()
    y = waveform_hz()
    pred = prediction(pcm)
    air = np.tile(-HZ_PER_COUNT * pcm.astype(float), 4)
    res = m17.decode_transmission(air, FS, verbose=False)
    print("peak_count", pred["peak_count"], "aimed", pred["aimed_hz"], "stop_check", pred["stop_hz"])
    print("float_peak", round(float(np.max(np.abs(y))), 1), "lsf", res["lsf"])
    if res["lsf"] is None or not res["lsf"][2]:
        raise SystemExit("LSF did not decode")
    if pred["stop_hz"] >= 5000:
        raise SystemExit("prediction reaches the stop")


if __name__ == "__main__":
    main()
