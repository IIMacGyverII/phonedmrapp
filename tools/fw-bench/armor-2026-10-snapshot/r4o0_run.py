# R4o: store a 1 kHz sine with command 0x40, then one low-power key.
# Boot is recorded. A loud boot restores the factory image and does not key.
# The sine command does not key. The key is 467.625 MHz, low power, silence wav.
import hashlib
import struct
import subprocess
import sys
import threading
import time
from pathlib import Path

import numpy as np

sys.path.insert(0, r"C:\Users\Joshua\AppData\Local\Temp\fw1718")
import camp
import factory_boot
import r3a3_run
import r3a3_silence

IMAGE = camp.BUILD / "DMR003.R4o0.V022.bin"
TAG = "DMR003.R4o0.V022"
EXPECT = "2b37af7a4fad24e2d3873cacc88d532842d3081dc2be8c7ab8a07f4b1bbfb291"
HERE = Path(r"C:\Users\Joshua\AppData\Local\Temp\fw1718")
BOOT_IQ = camp.CAP / "r4o0_boot.iq"
KEY_IQ = camp.CAP / "r4o0_key.iq"


def recv(path, seconds):
    if camp.hackrf_running():
        raise RuntimeError("hackrf_transfer already running")
    n = int(camp.FS_IQ * seconds)
    if path.exists():
        path.unlink()
    hlog = open(str(path) + ".log", "w", encoding="utf-8")
    proc = subprocess.Popen(
        [camp.HACKRF, "-r", str(path), "-f", "467385000", "-s", "2400000",
         "-l", "24", "-g", "38", "-n", str(n)],
        stdout=hlog, stderr=subprocess.STDOUT)
    t0 = time.time()
    while time.time() - t0 < 3:
        if proc.poll() is not None:
            hlog.close()
            raise RuntimeError("hackrf exited early")
        if camp.hackrf_running():
            return proc, hlog
        time.sleep(0.05)
    proc.kill()
    hlog.close()
    raise RuntimeError("hackrf did not start")


def finish_recv(proc, hlog, path, seconds):
    try:
        proc.wait(timeout=seconds + 20)
    except subprocess.TimeoutExpired:
        proc.kill()
        camp.kill_hackrf()
        raise RuntimeError("hackrf stalled")
    hlog.close()
    if camp.hackrf_running():
        camp.kill_hackrf()
        raise RuntimeError("hackrf still running")
    if not path.exists() or path.stat().st_size < camp.FS_IQ * seconds * 2 * 0.8:
        raise RuntimeError("capture short")


def silence_wav():
    n = 8000 * 3
    data = b"\x00\x00" * n
    hdr = struct.pack(
        "<4sI4s4sIHHIIHH4sI",
        b"RIFF", 36 + len(data), b"WAVE", b"fmt ", 16, 1, 1, 8000, 16000, 2, 16, b"data", len(data))
    path = HERE / "wav" / "r4o_silence.wav"
    path.parent.mkdir(exist_ok=True)
    path.write_bytes(hdr + data)
    return path


def main():
    raw = IMAGE.read_bytes()
    digest = hashlib.sha256(raw).hexdigest()
    if digest != EXPECT or raw[0x38464:0x38474] != TAG.encode():
        raise SystemExit("image is not R4o0")
    camp.say("image sha256 " + digest)
    r3a3_run.devices_ok()
    if camp.hackrf_running():
        raise SystemExit("hackrf_transfer already running")
    camp.install_wav(silence_wav(), "silence")
    camp.adb("shell", "input", "keyevent", "224")
    camp.adb("shell", "am", "start", "-n", "com.macdmr.radio/.MainActivity")
    time.sleep(4)
    camp.tune()
    box = {}

    def load():
        try:
            box["loaded"] = camp.load_image(IMAGE)
        except Exception as exc:
            box["error"] = exc

    thr = threading.Thread(target=load)
    thr.start()
    t0 = time.time()
    while time.time() - t0 < 200 and "loaded" not in box and "error" not in box:
        text = camp.adb("shell", "logcat", "-d", "-s", "YModemManager:D", timeout=20)[1]
        if "onSuccess" in text:
            break
        time.sleep(1)
    if "error" in box and "onSuccess" not in camp.adb("shell", "logcat", "-d", "-s", "YModemManager:D", timeout=20)[1]:
        thr.join(30)
        raise box["error"]
    camp.say("onSuccess seen, recording the boot")
    proc, hlog = recv(BOOT_IQ, 30)
    boot_t = time.time()
    thr.join(90)
    finish_recv(proc, hlog, BOOT_IQ, 30)
    if "error" in box:
        r3a3_silence.restore_factory()
        raise box["error"]
    loaded = box.get("loaded", "")
    camp.say("loaded " + str(loaded))
    if loaded != TAG:
        r3a3_silence.restore_factory()
        raise SystemExit("version %s" % loaded)
    text = camp.adb("shell", "logcat", "-d", "-s", "RadioService:I", timeout=40)[1]
    if "开机初始化完成" not in text and "module booted" not in text:
        r3a3_silence.restore_factory()
        raise SystemExit("banner missing")
    info = factory_boot.analyze(8.0, str(BOOT_IQ))
    camp.say("boot floor %.2f peak %.2f runs %d above10 %.2f" % (
        info["floor_db"], info["peak_db"], len(info["runs"]), info["above_10db_s"]))
    loud = [r for r in info["runs"] if r["peak_db"] >= 10]
    if loud:
        camp.say("boot radiation, restoring factory")
        r3a3_silence.restore_factory()
        raise SystemExit("boot radiated")
    camp.tune()
    camp.adb("shell", "logcat", "-c")
    rc, out = camp.broadcast(["--es", "cmd", "cmdsine", "--ei", "n", "64", "--ei", "amp", "2048", "--ei", "hz", "1000"])
    camp.say("cmdsine rc=%d %s" % (rc, out.strip().replace("\n", " ")[:120]))
    time.sleep(2)
    text = camp.adb("shell", "logcat", "-d", "-s", "RadioService:I", "DiagReceiver:I", timeout=40)[1]
    hits = [ln.strip() for ln in text.splitlines() if "0x40" in ln or "sine " in ln or "cmdsine" in ln]
    camp.say("store " + " | ".join(h[-180:] for h in hits[-8:]))
    if not any("len=2 [40 00]" in ln for ln in hits):
        camp.tune()
        camp.say("store did not echo 64; not keying; R4o0 stays loaded")
        return
    if any("cmd=0x26" in ln or "cmd=0x36" in ln for ln in text.splitlines()):
        camp.say("store keyed; not sending another key")
        return
    proc, hlog = recv(KEY_IQ, 8)
    time.sleep(0.8)
    rc, out = camp.broadcast(["--es", "cmd", "txwav", "--es", "name", "silence"])
    camp.say("txwav rc=%d %s" % (rc, out.strip().replace("\n", " ")[:140]))
    finish_recv(proc, hlog, KEY_IQ, 8)
    dev, kinfo = camp.demod(str(KEY_IQ))
    i0 = int(kinfo["i0"])
    fs = camp.FS_A
    click = dev[i0:i0 + int(0.02 * fs)]
    burst = dev[i0 + int(0.03 * fs):i0 + int(0.12 * fs)]
    tail = dev[i0 + int(0.6 * fs):i0 + int(2.4 * fs)]
    def p99(x):
        return float(np.percentile(np.abs(x), 99)) if len(x) else float("nan")
    tone = camp.goertzel_peak(burst, fs, 1000) if len(burst) else float("nan")
    camp.say("key snr %.1f clip %.3f offset %+.0f keyed %.2f click_p99 %.0f burst_p99 %.0f tone1k %.0f tail_p99 %.0f" % (
        kinfo["snr_db"], kinfo["clip_frac"], kinfo["offset_hz"], kinfo["keyed_s"],
        p99(click), p99(burst), tone, p99(tail)))
    if p99(burst) > camp.STOP_HZ:
        camp.say("STOP burst p99 above 5 kHz; not keying again")
    camp.tune()
    camp.say("R4o0 stays loaded")
    camp.say("boot_t %.1f" % (boot_t - t0))


if __name__ == "__main__":
    main()
