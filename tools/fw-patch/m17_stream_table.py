"""R4c TX-RAM table: one M17 link setup plus six stream frames.

Host only. The poll stub copies this table out of the zero tail during a
host key. 108 preamble symbols, the link-setup frame, six stream frames
with a zero payload, and 6 symbols of filter tail: 1458 symbols, 2430
samples, the whole run from file +0x5B400 to the end of the image.

Samples are 16-bit PCM, high byte at the low address. The stored count is
minus the rounded Hz/0.54, the same flip as R4b. If the peak would exceed
R4b's 6451, the counts are scaled down. They are not scaled up.
"""
import sys
from pathlib import Path

import numpy as np

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "m17-research"))
import m17  # noqa: E402

FS = 8000
HZ_PER_COUNT = 0.54
STOP_SLOPE = 0.55
PEAK_CAP = 6451
PREAMBLE = 108
TAIL = 6
N_STREAM = 6
N_SAMPLES = 2430
BENCH_CALL = "N0CALL"


def symbols():
    pre = np.array([3.0, -3.0] * (PREAMBLE // 2))
    lsf_b = m17.lsf_bytes(BENCH_CALL, BENCH_CALL)
    lsf = np.array(m17.encode_lsf(lsf_b), float)
    frames = []
    for i in range(N_STREAM):
        fn = i | (0x8000 if i == N_STREAM - 1 else 0)
        frames.extend(m17.encode_stream(lsf_b, fn, bytes(16), i % 6))
    syms = np.concatenate([pre, lsf, np.array(frames, float), np.zeros(TAIL)])
    expect = PREAMBLE + 192 * (1 + N_STREAM) + TAIL
    if len(syms) != expect:
        raise RuntimeError("got %d symbols, expected %d" % (len(syms), expect))
    if len(syms) % 3:
        raise RuntimeError("symbol count must be a multiple of 3")
    return syms


def waveform_hz():
    syms = symbols()
    y = m17.deviation(syms, FS)
    expect = len(syms) * FS // m17.SYM_RATE
    if len(y) != expect or len(y) != N_SAMPLES:
        raise RuntimeError("got %d samples, expected %d" % (len(y), N_SAMPLES))
    return y


def counts():
    """Signed PCM counts as the TX RAM hardware reads them."""
    y = waveform_hz()
    body = np.rint(-y / HZ_PER_COUNT).astype(np.int32)
    peak = int(np.max(np.abs(body)))
    if peak > PEAK_CAP:
        body = np.rint(body.astype(float) * (PEAK_CAP / peak)).astype(np.int32)
    if np.max(np.abs(body)) > PEAK_CAP:
        raise RuntimeError("peak %d still over the cap" % int(np.max(np.abs(body))))
    if np.max(np.abs(body)) > 32767:
        raise RuntimeError("sample does not fit in 16 bits")
    if len(body) != N_SAMPLES:
        raise RuntimeError("count buffer is %d" % len(body))
    return body


def table_bytes(pcm=None):
    """File bytes. Low address holds the high byte of the sample."""
    pcm = counts() if pcm is None else pcm
    out = bytearray()
    for s in pcm:
        u = int(s) & 0xFFFF
        out.append((u >> 8) & 0xFF)
        out.append(u & 0xFF)
    if len(out) != N_SAMPLES * 2:
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


# R4f. Frames 0-4 only. The end-of-transmission bit is not set. The
# defaults above stay the six-frame table. 1266 symbols, 2110 samples.
# Sample 500 is still the first stream frame. Sample 2100 is the tail.
LOOP5_STREAM = 5
LOOP5_SAMPLES = 2110
LOOP5_TAIL = 2100


def symbols_loop5():
    pre = np.array([3.0, -3.0] * (PREAMBLE // 2))
    lsf_b = m17.lsf_bytes(BENCH_CALL, BENCH_CALL)
    lsf = np.array(m17.encode_lsf(lsf_b), float)
    frames = []
    for i in range(LOOP5_STREAM):
        frames.extend(m17.encode_stream(lsf_b, i, bytes(16), i % 6))
    syms = np.concatenate([pre, lsf, np.array(frames, float), np.zeros(TAIL)])
    expect = PREAMBLE + 192 * (1 + LOOP5_STREAM) + TAIL
    if len(syms) != expect:
        raise RuntimeError("got %d symbols, expected %d" % (len(syms), expect))
    if len(syms) % 3:
        raise RuntimeError("symbol count must be a multiple of 3")
    return syms


def waveform_hz_loop5():
    syms = symbols_loop5()
    y = m17.deviation(syms, FS)
    expect = len(syms) * FS // m17.SYM_RATE
    if len(y) != expect or len(y) != LOOP5_SAMPLES:
        raise RuntimeError("got %d samples, expected %d" % (len(y), LOOP5_SAMPLES))
    return y


def counts_loop5():
    """Same sign and the same cap as counts(). Not scaled up."""
    y = waveform_hz_loop5()
    body = np.rint(-y / HZ_PER_COUNT).astype(np.int32)
    peak = int(np.max(np.abs(body)))
    if peak > PEAK_CAP:
        body = np.rint(body.astype(float) * (PEAK_CAP / peak)).astype(np.int32)
    if np.max(np.abs(body)) > PEAK_CAP:
        raise RuntimeError("peak %d still over the cap" % int(np.max(np.abs(body))))
    if np.max(np.abs(body)) > 32767:
        raise RuntimeError("sample does not fit in 16 bits")
    if len(body) != LOOP5_SAMPLES:
        raise RuntimeError("count buffer is %d" % len(body))
    return body


def table_bytes_loop5(pcm=None):
    pcm = counts_loop5() if pcm is None else pcm
    out = bytearray()
    for s in pcm:
        u = int(s) & 0xFFFF
        out.append((u >> 8) & 0xFF)
        out.append(u & 0xFF)
    if len(out) != LOOP5_SAMPLES * 2:
        raise RuntimeError("table is %d bytes" % len(out))
    return bytes(out)


def main():
    pcm = counts()
    y = waveform_hz()
    pred = prediction(pcm)
    air = -HZ_PER_COUNT * pcm.astype(float)
    res = m17.decode_transmission(air, FS, verbose=False)
    fns = [f[0] for f in res["frames"]]
    print("samples", len(pcm), "peak_count", pred["peak_count"],
          "aimed", pred["aimed_hz"], "stop_check", pred["stop_hz"])
    print("float_peak", round(float(np.max(np.abs(y))), 1), "lsf", res["lsf"], "fn", fns)
    if res["lsf"] is None or not res["lsf"][2]:
        raise SystemExit("LSF did not decode")
    if fns != [0, 1, 2, 3, 4, 0x8005]:
        raise SystemExit("stream frames did not decode")
    if pred["stop_hz"] >= 5000 or pred["peak_count"] > PEAK_CAP:
        raise SystemExit("prediction reaches the stop")


if __name__ == "__main__":
    main()
