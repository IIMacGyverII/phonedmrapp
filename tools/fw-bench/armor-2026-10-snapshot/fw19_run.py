# FW19: one 45 s symbol stream, last chunk op 7, host does not unkey.
# Then, after a cool-down, the 0x58-after-PTT key. Low power, 467.625 MHz.
# HackRF receive only. Does not call vfo_off. Does not restore factory unless boot radiates.
import hashlib
import json
import struct
import sys
import time
from pathlib import Path

import numpy as np

sys.path.insert(0, r"C:\Users\Joshua\AppData\Local\Temp\fw1718")
sys.path.insert(0, r"D:\Documents\code\personal\phonedmrapp\tools\fw-patch")
sys.path.insert(0, r"D:\Documents\code\personal\phonedmrapp\tools\m17-research")
import camp
import factory_boot
import m17
import m17_rrc
import m17_stream_table as tab
import r3a3_run
import r3a3_silence

IMAGE = camp.BUILD / "DMR003.FW19.V022.bin"
TAG = "DMR003.FW19.V022"
EXPECT = "555b0128f62116a28496c8e8e3ef8d4277b4fa81d6420a23b4d033102070e52a"
HERE = Path(r"C:\Users\Joshua\AppData\Local\Temp\fw1718")
CAP = camp.CAP
NFRAMES = 1125


def symbols(nframes):
    pre = [3, -3] * 54
    lsf_b = m17.lsf_bytes(tab.BENCH_CALL, tab.BENCH_CALL)
    syms = pre + list(m17.encode_lsf(lsf_b))
    for i in range(nframes):
        syms += list(m17.encode_stream(lsf_b, i, bytes(range(16)), i % 6))
    return syms


def install_sym(raw):
    path = HERE / "fw19_stream.sym"
    path.write_bytes(raw)
    remote = "/data/local/tmp/m17.sym"
    rc, out = camp.adb("push", str(path), remote, timeout=60)
    if rc != 0:
        raise RuntimeError("push " + out)
    cmd = (
        "cp %s /data/data/com.macdmr.radio/cache/m17.sym && "
        "chown %s:%s /data/data/com.macdmr.radio/cache/m17.sym && "
        "chmod 600 /data/data/com.macdmr.radio/cache/m17.sym"
    ) % (remote, camp.UID, camp.UID)
    rc, out = camp.adb("shell", "su --mount-master --context u:r:magisk:s0 -c '%s'" % cmd, timeout=30)
    if rc != 0:
        raise RuntimeError("cache " + out)
    return "/data/data/com.macdmr.radio/cache/m17.sym"


def wav_of(samples, name):
    x = np.asarray(samples, dtype=np.int16)
    data = x.tobytes()
    hdr = struct.pack(
        "<4sI4s4sIHHIIHH4sI",
        b"RIFF", 36 + len(data), b"WAVE", b"fmt ", 16, 1, 1, 8000, 16000, 2, 16, b"data", len(data))
    path = HERE / "wav" / name
    path.parent.mkdir(exist_ok=True)
    path.write_bytes(hdr + data)
    return path


def p99(x):
    return float(np.percentile(np.abs(x), 99)) if len(x) else float("nan")


def slices(dev, i0, seconds):
    fs = camp.FS_A
    rows = []
    for ms in range(0, int(seconds * 1000), 20):
        a = i0 + int(ms / 1000 * fs)
        b = i0 + int((ms + 20) / 1000 * fs)
        sl = dev[a:b]
        if len(sl) < 10:
            break
        rows.append((ms, p99(sl)))
    return rows


def judge_stream(dev, info):
    i0 = int(info["i0"])
    fs = camp.FS_A
    rows = slices(dev, i0, info["keyed_s"] + 0.2)
    modulated = [ms for ms, val in rows if ms >= 80 and val > 1500]
    mod_end = modulated[-1] / 1000 if modulated else None
    gap = None if mod_end is None else info["keyed_s"] - mod_end
    windows = {}
    for name, t0, t1 in (("start", 1.0, 3.0), ("mid", 20.0, 22.0), ("end", 42.0, 44.5)):
        a = i0 + int(t0 * fs)
        b = i0 + int(t1 * fs)
        res = m17.decode_transmission(dev[a:b], fs, verbose=False)
        lsf = res.get("lsf")
        good = sum(1 for fn, pay, err in res["frames"] if bytes(pay) == bytes(range(16)) and err == 0)
        windows[name] = {
            "lsf": bool(lsf) and bool(lsf[2]),
            "frames": len(res["frames"]),
            "good": good,
        }
        camp.say("window %s frames %d good %d lsf %s" % (name, len(res["frames"]), good, windows[name]["lsf"]))
    whole = m17.decode_transmission(dev[i0 + int(0.08 * fs):i0 + int(info["keyed_s"] * fs)], fs, verbose=False)
    good = sum(1 for fn, pay, err in whole["frames"] if bytes(pay) == bytes(range(16)) and err == 0)
    camp.say("whole frames %d good %d keyed %.2f gap %s" % (
        len(whole["frames"]), good, info["keyed_s"], "none" if gap is None else "%.3f" % gap))
    over = any(val >= camp.STOP_HZ and ms >= 60 for ms, val in rows)
    return {
        "keyed_s": info["keyed_s"], "snr_db": info["snr_db"], "clip": info["clip_frac"],
        "offset_hz": info["offset_hz"], "mod_end_s": mod_end, "gap_s": gap,
        "windows": windows, "frames": len(whole["frames"]), "good": good, "over": over,
        "steady": [rows[i] for i in range(0, len(rows), 50)],
    }


def capture(name, seconds, lna, vga):
    if camp.hackrf_running():
        raise RuntimeError("hackrf already running")
    path = CAP / (name + ".iq")
    if path.exists():
        path.unlink()
    n = int(camp.FS_IQ * seconds)
    hlog = open(CAP / (name + ".hackrf.log"), "w", encoding="utf-8")
    proc = camp  # placate linters
    proc = __import__("subprocess").Popen(
        [camp.HACKRF, "-r", str(path), "-f", "467385000", "-s", "2400000",
         "-l", str(lna), "-g", str(vga), "-n", str(n)],
        stdout=hlog, stderr=__import__("subprocess").STDOUT)
    t0 = time.time()
    while time.time() - t0 < 4:
        if proc.poll() is not None:
            hlog.close()
            raise RuntimeError("hackrf exited early")
        if camp.hackrf_running():
            return proc, hlog, path
        time.sleep(0.05)
    proc.kill()
    hlog.close()
    raise RuntimeError("hackrf did not start")


def finish(proc, hlog, seconds):
    try:
        proc.wait(timeout=seconds + 30)
    except Exception:
        camp.kill_hackrf()
        proc.wait(timeout=15)
    hlog.close()
    if camp.hackrf_running():
        camp.kill_hackrf()


def log_text():
    return camp.adb("shell", "logcat", "-d", "-s", "RadioService:I", "DiagReceiver:I", "YModemManager:I", timeout=40)[1]


def main():
    raw = IMAGE.read_bytes()
    digest = hashlib.sha256(raw).hexdigest()
    if digest != EXPECT or raw[0x38464:0x38474] != TAG.encode():
        raise SystemExit("image is not FW19")
    if raw[0x382B8:0x382BC] != bytes.fromhex("fc4e0703"):
        raise SystemExit("0x40 slot is not the symbol stub")
    camp.say("image sha256 " + digest)
    r3a3_run.devices_ok()
    if camp.hackrf_running():
        raise SystemExit("hackrf running")
    camp.adb("shell", "input", "keyevent", "224")
    camp.adb("shell", "am", "start", "-n", "com.macdmr.radio/.MainActivity")
    time.sleep(3)
    if "--no-load" not in sys.argv:
        camp.tune()
        proc, hlog, iq = capture("fw19_boot", 200, 24, 38)
        time.sleep(1.5)
        try:
            loaded = camp.load_image(IMAGE)
            camp.say("loader returned %s" % loaded)
        finally:
            finish(proc, hlog, 5)
        if TAG not in loaded:
            raise SystemExit("loaded %s" % loaded)
        info = factory_boot.analyze(1.5, iq)
        camp.say("boot peak_db %.2f above_10db_s %.2f clip %.6f" % (
            info["peak_db"], info["above_10db_s"], info["clip_frac"]))
        (HERE / "fw19_boot.json").write_text(json.dumps({
            "peak_db": info["peak_db"], "above_10db_s": info["above_10db_s"], "clip_frac": info["clip_frac"],
        }, indent=2), encoding="utf-8")
        if info["peak_db"] >= 10.0:
            r3a3_silence.restore_factory()
            raise SystemExit("boot radiated")
    camp.adb("shell", "logcat", "-c")
    camp.broadcast(["--es", "cmd", "cmdbyte", "--ei", "b", "52", "--ei", "d", "1"])
    time.sleep(1.2)
    ver = camp.read_version(False)
    camp.expect_version(ver, TAG)
    camp.tune()
    remote = install_sym(m17_rrc.pack_symbols(symbols(NFRAMES)))
    camp.adb("shell", "logcat", "-c")
    proc, hlog, iq = capture("fw19_45", 56, 16, 16)
    time.sleep(0.6)
    rc, out = camp.broadcast(["--es", "cmd", "cmdsym", "--es", "path", remote, "--ez", "eot", "true"])
    camp.say("cmdsym eot rc=%d %s" % (rc, out.strip().replace("\n", " ")[:160]))
    finish(proc, hlog, 56)
    text = log_text()
    (HERE / "fw19_45.log").write_text(text, encoding="utf-8", errors="replace")
    interesting = [ln.strip() for ln in text.splitlines()
                   if "sym " in ln or "SEND_" in ln or "cmd 0x26" in ln or "does not answer" in ln or "stopped answering" in ln]
    camp.say("stream log " + " | ".join(x[-140:] for x in interesting[-12:]))
    dev, dinfo = camp.demod(str(iq))
    camp.say("carrier %.2f s snr %.1f clip %.4f offset %+.0f" % (
        dinfo["keyed_s"], dinfo["snr_db"], dinfo["clip_frac"], dinfo["offset_hz"]))
    result = judge_stream(dev, dinfo)
    result["log"] = interesting[-20:]
    (HERE / "fw19_45.json").write_text(json.dumps(result, indent=2), encoding="utf-8")
    if result["over"]:
        camp.say("STOP a modulated slice is at or over 5 kHz")
    camp.tune()
    camp.say("cooling 90 s")
    time.sleep(90)
    # 0x58 after a normal unkey. Hold on, 1 s silence, unkey, then 100 Hz and 1 kHz.
    camp.adb("shell", "logcat", "-c")
    rc, out = camp.broadcast(["--es", "cmd", "cmdsym", "--es", "op", "hold", "--ei", "mode", "3", "--ei", "action", "1"])
    camp.say("hold rc=%d %s" % (rc, out.strip().replace("\n", " ")[:120]))
    time.sleep(0.8)
    camp.install_wav(wav_of(np.zeros(8000, dtype=np.int16), "fw19_sil.wav"), "fw19_sil")
    proc, hlog, iq = capture("fw19_sil", 8, 16, 16)
    time.sleep(0.4)
    camp.broadcast(["--es", "cmd", "txwav", "--es", "name", "fw19_sil"])
    finish(proc, hlog, 8)
    amp = int(round(32767 * 10 ** (-24 / 20)))
    tone = np.concatenate([
        camp.tone_pcm(100, 1.0, amp),
        np.zeros(int(8000 * 0.25)),
        camp.tone_pcm(1000, 1.0, amp),
    ])
    camp.install_wav(wav_of(tone, "fw19_100.wav"), "fw19_100")
    time.sleep(1.0)
    proc, hlog, iq = capture("fw19_100", 8, 16, 16)
    time.sleep(0.4)
    camp.broadcast(["--es", "cmd", "txwav", "--es", "name", "fw19_100"])
    finish(proc, hlog, 8)
    dev, dinfo = camp.demod(str(iq))
    i0 = int(dinfo["i0"])
    fs = camp.FS_A
    # txwav leads with its own settle; measure two 0.6 s windows inside the keyed carrier.
    def line(t0, hz):
        a = i0 + int(t0 * fs)
        b = a + int(0.6 * fs)
        return camp.goertzel_peak(dev[a:b], fs, hz)
    h100 = line(0.4, 100)
    h1k = line(1.7, 1000)
    ratio = h100 / h1k if h1k else None
    tone_info = {
        "keyed_s": dinfo["keyed_s"], "snr_db": dinfo["snr_db"], "clip": dinfo["clip_frac"],
        "p99_100": p99(dev[i0 + int(0.3 * fs):i0 + int(1.1 * fs)]),
        "p99_1k": p99(dev[i0 + int(1.6 * fs):i0 + int(2.4 * fs)]),
        "line_100": h100, "line_1k": h1k, "ratio": ratio,
    }
    camp.say("tone keyed %.2f p99_100 %.0f p99_1k %.0f ratio %s clip %.4f" % (
        tone_info["keyed_s"], tone_info["p99_100"], tone_info["p99_1k"],
        "none" if ratio is None else "%.4f" % ratio, tone_info["clip"]))
    (HERE / "fw19_100.json").write_text(json.dumps(tone_info, indent=2), encoding="utf-8")
    text = log_text()
    (HERE / "fw19_100.log").write_text(text, encoding="utf-8", errors="replace")
    camp.tune()
    ver = camp.read_version(False)
    camp.say("end version " + ver)
    camp.say("FW19 run done")


if __name__ == "__main__":
    main()
