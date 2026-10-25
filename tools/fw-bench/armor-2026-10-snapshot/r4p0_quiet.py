# Second key of the loaded R4p0 image. Peak count 4096. Does not reload.
# 467.625 MHz, low power. HackRF receive only.
import struct
import sys
import time

import numpy as np

sys.path.insert(0, r"C:\Users\Joshua\AppData\Local\Temp\fw1718")
sys.path.insert(0, r"D:\Documents\code\personal\phonedmrapp\tools\fw-patch")
sys.path.insert(0, r"D:\Documents\code\personal\phonedmrapp\tools\m17-research")
import camp
import m17
import m17_stream_table as tab
import r4p0_run as r

PEAK = 4096


def main():
    pre = np.array([3.0, -3.0] * 54)
    lsf_b = m17.lsf_bytes(tab.BENCH_CALL, tab.BENCH_CALL)
    lsf = np.array(m17.encode_lsf(lsf_b), float)
    frames = []
    for i in range(3):
        fn = i | (0x8000 if i == 2 else 0)
        frames.extend(m17.encode_stream(lsf_b, fn, bytes(range(16)), i % 6))
    syms = np.concatenate([pre, lsf, np.array(frames, float), np.zeros(6)])
    y = m17.deviation(syms, 8000)
    body = np.rint(-y / tab.HZ_PER_COUNT).astype(np.float64)
    body *= PEAK / max(1, np.max(np.abs(body)))
    body = np.rint(body).astype(np.int32)
    peak = int(np.max(np.abs(body)))
    if peak > PEAK or len(body) != r.NSAMP:
        raise SystemExit("peak %d n %d" % (peak, len(body)))
    r.PCM.write_bytes(b"".join(struct.pack("<h", int(s)) for s in body))
    camp.say("quiet peak %d stop %.1f" % (peak, peak * tab.STOP_SLOPE))
    if camp.hackrf_running():
        raise SystemExit("hackrf running")
    camp.adb("shell", "input", "keyevent", "224")
    camp.adb("shell", "am", "start", "-n", "com.macdmr.radio/.MainActivity")
    time.sleep(3)
    camp.tune()
    r.install_pcm()
    r.send_chunks()
    proc, hlog = r.recv(r.KEY_IQ, 8, 16, 16)
    time.sleep(0.8)
    rc, out = camp.broadcast(["--es", "cmd", "txwav", "--es", "name", "silence"])
    camp.say("txwav rc=%d" % rc)
    r.finish_recv(proc, hlog, r.KEY_IQ, 8)
    r.report_key()
    camp.tune()
    camp.say("R4p0 stays loaded")


if __name__ == "__main__":
    main()
