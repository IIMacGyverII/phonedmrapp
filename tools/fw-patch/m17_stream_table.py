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
# Outer-symbol scale, decided 2026-10-24 from the R4r air measurement.
# A stored long +3 is 2400/0.54 = 4444 counts. R4r's matched-filter gain on
# that body was 2233 Hz against the standard 2400 Hz, about 7% low, and the
# waveform was already at PEAK_CAP, so multiplying the counts by 1.07 would
# clip at the same 6451 and would not raise the air level. The stream decoded
# (sync 0.998, link-setup CRC, Golay 0). Keep 0.54 and do not scale up.
HZ_PER_COUNT = 0.54
OUTER_SCALE = 1.0
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


# R4g. Same five frames and the same wrap as R4f. The 16 payload
# bytes are 0 through 15. Scale down only if the peak exceeds 6451.
PAY16 = bytes(range(16))


def symbols_pay16():
    pre = np.array([3.0, -3.0] * (PREAMBLE // 2))
    lsf_b = m17.lsf_bytes(BENCH_CALL, BENCH_CALL)
    lsf = np.array(m17.encode_lsf(lsf_b), float)
    frames = []
    for i in range(LOOP5_STREAM):
        frames.extend(m17.encode_stream(lsf_b, i, PAY16, i % 6))
    syms = np.concatenate([pre, lsf, np.array(frames, float), np.zeros(TAIL)])
    expect = PREAMBLE + 192 * (1 + LOOP5_STREAM) + TAIL
    if len(syms) != expect:
        raise RuntimeError("got %d symbols, expected %d" % (len(syms), expect))
    if len(syms) % 3:
        raise RuntimeError("symbol count must be a multiple of 3")
    return syms


def waveform_hz_pay16():
    syms = symbols_pay16()
    y = m17.deviation(syms, FS)
    expect = len(syms) * FS // m17.SYM_RATE
    if len(y) != expect or len(y) != LOOP5_SAMPLES:
        raise RuntimeError("got %d samples, expected %d" % (len(y), LOOP5_SAMPLES))
    return y


def counts_pay16():
    """Same sign and the same cap as counts_loop5(). Not scaled up."""
    y = waveform_hz_pay16()
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


def table_bytes_pay16(pcm=None):
    pcm = counts_pay16() if pcm is None else pcm
    out = bytearray()
    for s in pcm:
        u = int(s) & 0xFFFF
        out.append((u >> 8) & 0xFF)
        out.append(u & 0xFF)
    if len(out) != LOOP5_SAMPLES * 2:
        raise RuntimeError("table is %d bytes" % len(out))
    return bytes(out)


# R4h. Same payload as R4g, plus frame 5 with the end bit clear.
# The wrap moves to sample 2420. Scale down only if the peak exceeds 6451.
LICH5_STREAM = 6
LICH5_SAMPLES = 2430
LICH5_TAIL = 2420


def symbols_lich5():
    pre = np.array([3.0, -3.0] * (PREAMBLE // 2))
    lsf_b = m17.lsf_bytes(BENCH_CALL, BENCH_CALL)
    lsf = np.array(m17.encode_lsf(lsf_b), float)
    frames = []
    for i in range(LICH5_STREAM):
        frames.extend(m17.encode_stream(lsf_b, i, PAY16, i % 6))
    syms = np.concatenate([pre, lsf, np.array(frames, float), np.zeros(TAIL)])
    expect = PREAMBLE + 192 * (1 + LICH5_STREAM) + TAIL
    if len(syms) != expect:
        raise RuntimeError("got %d symbols, expected %d" % (len(syms), expect))
    if len(syms) % 3:
        raise RuntimeError("symbol count must be a multiple of 3")
    return syms


def waveform_hz_lich5():
    syms = symbols_lich5()
    y = m17.deviation(syms, FS)
    expect = len(syms) * FS // m17.SYM_RATE
    if len(y) != expect or len(y) != LICH5_SAMPLES:
        raise RuntimeError("got %d samples, expected %d" % (len(y), LICH5_SAMPLES))
    return y


def counts_lich5():
    """Same sign and the same cap as counts_pay16(). Not scaled up."""
    y = waveform_hz_lich5()
    body = np.rint(-y / HZ_PER_COUNT).astype(np.int32)
    peak = int(np.max(np.abs(body)))
    if peak > PEAK_CAP:
        body = np.rint(body.astype(float) * (PEAK_CAP / peak)).astype(np.int32)
    if np.max(np.abs(body)) > PEAK_CAP:
        raise RuntimeError("peak %d still over the cap" % int(np.max(np.abs(body))))
    if np.max(np.abs(body)) > 32767:
        raise RuntimeError("sample does not fit in 16 bits")
    if len(body) != LICH5_SAMPLES:
        raise RuntimeError("count buffer is %d" % len(body))
    return body


def table_bytes_lich5(pcm=None):
    pcm = counts_lich5() if pcm is None else pcm
    out = bytearray()
    for s in pcm:
        u = int(s) & 0xFFFF
        out.append((u >> 8) & 0xFF)
        out.append(u & 0xFF)
    if len(out) != LICH5_SAMPLES * 2:
        raise RuntimeError("table is %d bytes" % len(out))
    return bytes(out)


# R4i. One stream frame, frame number 5 with the end bit set. Not part of
# the loop. The 320 samples are the tail of one deviation that already
# contains frames 0-5 with the end bit clear, so the filter state continues
# frame 5. Same sign and the same cap as counts_lich5(). Not scaled up.
# A 6-symbol zero tail is filtered and then dropped: the 16 spare bytes
# after the stored frame are not samples.
EOT_SAMPLES = 320
EOT_FN = 5 | 0x8000


def symbols_eot1():
    lsf_b = m17.lsf_bytes(BENCH_CALL, BENCH_CALL)
    syms = np.array(m17.encode_stream(lsf_b, EOT_FN, PAY16, 5), float)
    if len(syms) != 192:
        raise RuntimeError("got %d symbols, expected 192" % len(syms))
    return syms


def waveform_hz_eot1():
    """320 Hz samples that continue frame 5. Not an independently filtered frame."""
    pre = np.array([3.0, -3.0] * (PREAMBLE // 2))
    lsf_b = m17.lsf_bytes(BENCH_CALL, BENCH_CALL)
    lsf = np.array(m17.encode_lsf(lsf_b), float)
    frames = []
    for i in range(LICH5_STREAM):
        frames.extend(m17.encode_stream(lsf_b, i, PAY16, i))
    frames.extend(m17.encode_stream(lsf_b, EOT_FN, PAY16, 5))
    syms = np.concatenate([pre, lsf, np.array(frames, float), np.zeros(TAIL)])
    y = m17.deviation(syms, FS)
    expect = len(syms) * FS // m17.SYM_RATE
    if len(y) != expect:
        raise RuntimeError("got %d samples, expected %d" % (len(y), expect))
    eot = y[LICH5_TAIL:LICH5_TAIL + EOT_SAMPLES]
    if len(eot) != EOT_SAMPLES:
        raise RuntimeError("end frame is %d samples" % len(eot))
    return eot


def counts_eot1():
    """Same sign and the same cap as counts_lich5(). Not scaled up."""
    y = waveform_hz_eot1()
    body = np.rint(-y / HZ_PER_COUNT).astype(np.int32)
    peak = int(np.max(np.abs(body)))
    if peak > PEAK_CAP:
        body = np.rint(body.astype(float) * (PEAK_CAP / peak)).astype(np.int32)
    if np.max(np.abs(body)) > PEAK_CAP:
        raise RuntimeError("peak %d still over the cap" % int(np.max(np.abs(body))))
    if np.max(np.abs(body)) > 32767:
        raise RuntimeError("sample does not fit in 16 bits")
    if len(body) != EOT_SAMPLES:
        raise RuntimeError("count buffer is %d" % len(body))
    return body


def table_bytes_eot1(pcm=None):
    pcm = counts_eot1() if pcm is None else pcm
    out = bytearray()
    for s in pcm:
        u = int(s) & 0xFFFF
        out.append((u >> 8) & 0xFF)
        out.append(u & 0xFF)
    if len(out) != EOT_SAMPLES * 2:
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
