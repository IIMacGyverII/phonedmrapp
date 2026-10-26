#!/usr/bin/env python3
"""Quick level check on a hackrf int8 interleaved-IQ capture.

    python3 iqpeek.py clip.iq

Prints peak and RMS magnitude (0..1) and a verdict. Redo a capture that clips
(peak ~1.0, flat-topped) or is near-silent (peak < ~0.05). Pure stdlib; samples
the file so it is fast on large clips.
"""
import sys, os, math

def main():
    if len(sys.argv) != 2:
        print("usage: iqpeek.py <clip.iq>"); return 2
    path = sys.argv[1]
    n = os.path.getsize(path)
    if n < 4:
        print("empty / too small"); return 1
    # int8 I,Q interleaved. Sample up to ~200k complex points spread over the file.
    want = 200_000
    step = max(1, (n // 2) // want)
    peak = 0.0; sumsq = 0.0; cnt = 0
    with open(path, "rb") as f:
        buf = f.read()
    for i in range(0, (len(buf) // 2) * 2 - 1, 2 * step):
        iq_i = buf[i] - 256 if buf[i] > 127 else buf[i]
        iq_q = buf[i+1] - 256 if buf[i+1] > 127 else buf[i+1]
        mag = math.hypot(iq_i, iq_q) / 127.0
        if mag > peak: peak = mag
        sumsq += mag * mag; cnt += 1
    rms = math.sqrt(sumsq / cnt) if cnt else 0.0
    print(f"file   : {path} ({n:,} bytes, ~{n//2:,} IQ samples)")
    print(f"peak   : {peak:.3f}")
    print(f"rms    : {rms:.3f}")
    if peak >= 0.98:
        print("verdict: CLIPPING — lower DMR_CAP_LNA/DMR_CAP_VGA and recapture.")
    elif peak < 0.05:
        print("verdict: NEAR-SILENT — source not keyed in window, or gain too low.")
    else:
        print("verdict: OK.")
    return 0

if __name__ == "__main__":
    raise SystemExit(main())
