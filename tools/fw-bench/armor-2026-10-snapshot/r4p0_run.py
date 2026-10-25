# R4p: store a short M17 waveform in pieces, then one low-power key.
# The store does not key. A loud boot restores the factory image and does not key.
# Phone TX is 467.625 MHz, low power. HackRF is receive only.
import hashlib
import struct
import subprocess
import sys
import threading
import time
from pathlib import Path

import numpy as np

sys.path.insert(0, r"C:\Users\Joshua\AppData\Local\Temp\fw1718")
sys.path.insert(0, r"D:\Documents\code\personal\phonedmrapp\tools\fw-patch")
sys.path.insert(0, r"D:\Documents\code\personal\phonedmrapp\tools\m17-research")
import camp
import factory_boot
import m17
import m17_stream_table as tab
import r3a3_run
import r3a3_silence

IMAGE = camp.BUILD / "DMR003.R4p0.V022.bin"
TAG = "DMR003.R4p0.V022"
HERE = Path(r"C:\Users\Joshua\AppData\Local\Temp\fw1718")
PCM = HERE / "r4p_m17.pcm"
BOOT_IQ = camp.CAP / "r4p0_boot.iq"
KEY_IQ = camp.CAP / "r4p0_key.iq"
CHUNK = 398
NSAMP = 1470


def waveform():
    pre = np.array([3.0, -3.0] * 54)
    lsf_b = m17.lsf_bytes(tab.BENCH_CALL, tab.BENCH_CALL)
    lsf = np.array(m17.encode_lsf(lsf_b), float)
    frames = []
    for i in range(3):
        fn = i | (0x8000 if i == 2 else 0)
        frames.extend(m17.encode_stream(lsf_b, fn, bytes(range(16)), i % 6))
    syms = np.concatenate([pre, lsf, np.array(frames, float), np.zeros(6)])
    if len(syms) != 882 or len(syms) % 3:
        raise SystemExit("symbol count %d" % len(syms))
    y = m17.deviation(syms, 8000)
    body = np.rint(-y / tab.HZ_PER_COUNT).astype(np.int32)
    peak = int(np.max(np.abs(body)))
    if peak > tab.PEAK_CAP:
        body = np.rint(body.astype(float) * (tab.PEAK_CAP / peak)).astype(np.int32)
    peak = int(np.max(np.abs(body)))
    if len(body) != NSAMP or peak > tab.PEAK_CAP or peak * tab.STOP_SLOPE >= 5000:
        raise SystemExit("waveform samples %d peak %d" % (len(body), peak))
    raw = b"".join(struct.pack("<h", int(s)) for s in body)
    PCM.write_bytes(raw)
    return peak


def install_pcm():
    remote = "/data/local/tmp/m17.pcm"
    rc, out = camp.adb("push", str(PCM), remote, timeout=60)
    if rc != 0:
        raise RuntimeError("push " + out)
    cmd = (
        "cp %s /data/data/com.macdmr.radio/cache/m17.pcm && "
        "chown %s:%s /data/data/com.macdmr.radio/cache/m17.pcm && "
        "chmod 600 /data/data/com.macdmr.radio/cache/m17.pcm && "
        "ls -l /data/data/com.macdmr.radio/cache/m17.pcm"
    ) % (remote, camp.UID, camp.UID)
    rc, out = camp.adb("shell", "su --mount-master --context u:r:magisk:s0 -c '%s'" % cmd, timeout=30)
    camp.say("pcm " + (out.strip().splitlines()[-1] if out.strip() else "rc %d" % rc))
    if rc != 0 or "m17.pcm" not in out:
        raise RuntimeError("cache copy failed: " + out)


def recv(path, seconds, lna, vga):
    if camp.hackrf_running():
        raise RuntimeError("hackrf_transfer already running")
    n = int(camp.FS_IQ * seconds)
    if path.exists():
        path.unlink()
    hlog = open(str(path) + ".log", "w", encoding="utf-8")
    proc = subprocess.Popen(
        [camp.HACKRF, "-r", str(path), "-f", "467385000", "-s", "2400000",
         "-l", str(lna), "-g", str(vga), "-n", str(n)],
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
        proc.wait(timeout=seconds + 25)
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


def count_back(n):
    return "len=2 [%02X %02X]" % (n & 0xFF, (n >> 8) & 0xFF)


def send_chunks():
    path = "/data/data/com.macdmr.radio/cache/m17.pcm"
    off = 0
    while off < NSAMP:
        n = min(CHUNK, NSAMP - off)
        camp.adb("shell", "logcat", "-c")
        rc, out = camp.broadcast(["--es", "cmd", "cmdpcm", "--es", "path", path, "--ei", "off", str(off), "--ei", "n", str(n)])
        camp.say("chunk off=%d n=%d rc=%d" % (off, n, rc))
        time.sleep(1.5)
        text = camp.adb("shell", "logcat", "-d", "-s", "RadioService:I", "DiagReceiver:I", timeout=40)[1]
        want = count_back(off + n)
        hit = [ln.strip() for ln in text.splitlines() if "0x40" in ln or "pcm " in ln]
        camp.say("ack " + " | ".join(h[-160:] for h in hit[-4:]))
        if any("cmd=0x26" in ln or "cmd=0x36" in ln for ln in text.splitlines()):
            raise RuntimeError("store keyed")
        if not any(want in ln for ln in hit):
            raise RuntimeError("wanted %s" % want)
        off += n


def report_key():
    dev, info = camp.demod(str(KEY_IQ))
    fs = camp.FS_A
    i0 = int(info["i0"])
    click = dev[i0:i0 + int(0.02 * fs)]
    tone = dev[i0 + int(0.05 * fs):i0 + int(0.22 * fs)]
    tail = dev[i0 + int(0.40 * fs):i0 + int(2.2 * fs)]

    def p99(x):
        return float(np.percentile(np.abs(x), 99)) if len(x) else float("nan")

    sl = dev[i0 + int(0.04 * fs):i0 + int(0.32 * fs)]
    res = m17.decode_transmission(sl, fs, verbose=False)
    lsf = res.get("lsf")
    match = bool(lsf) and lsf[2] and lsf[0] == tab.BENCH_CALL and lsf[1] == tab.BENCH_CALL
    rows = []
    good = 0
    for fn, pay, err in res["frames"]:
        ok = bytes(pay) == bytes(range(16)) and err == 0
        good += int(ok)
        rows.append("%d/%d" % (fn, err))
    camp.say("key snr %.1f clip %.3f offset %+.0f keyed %.2f click_p99 %.0f tone_p99 %.0f tail_p99 %.0f" % (
        info["snr_db"], info["clip_frac"], info["offset_hz"], info["keyed_s"], p99(click), p99(tone), p99(tail)))
    camp.say("decode lsf_ok %s call_match %s frames %d good %d [%s]" % (
        bool(lsf) and bool(lsf[2]), match, len(res["frames"]), good, " ".join(rows)))
    if p99(tone) > camp.STOP_HZ:
        camp.say("STOP tone p99 above 5 kHz")
    return p99(tone)


def main():
    raw = IMAGE.read_bytes()
    digest = hashlib.sha256(raw).hexdigest()
    if raw[0x38464:0x38474] != TAG.encode():
        raise SystemExit("image is not R4p0")
    peak = waveform()
    camp.say("image sha256 %s peak %d" % (digest, peak))
    r3a3_run.devices_ok()
    if camp.hackrf_running():
        raise SystemExit("hackrf_transfer already running")
    install_pcm()
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
    while time.time() - t0 < 220 and "loaded" not in box and "error" not in box:
        text = camp.adb("shell", "logcat", "-d", "-s", "YModemManager:D", timeout=20)[1]
        if "onSuccess" in text:
            break
        time.sleep(1)
    camp.say("recording the boot")
    proc, hlog = recv(BOOT_IQ, 30, 24, 38)
    thr.join(120)
    finish_recv(proc, hlog, BOOT_IQ, 30)
    if box.get("error"):
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
    if any(r["peak_db"] >= 10 for r in info["runs"]):
        r3a3_silence.restore_factory()
        raise SystemExit("boot radiated")
    camp.tune()
    try:
        send_chunks()
    except Exception as exc:
        camp.tune()
        camp.say("store failed (%s); not keying; R4p0 stays loaded" % exc)
        return
    proc, hlog = recv(KEY_IQ, 8, 16, 16)
    time.sleep(0.8)
    rc, out = camp.broadcast(["--es", "cmd", "txwav", "--es", "name", "silence"])
    camp.say("txwav rc=%d %s" % (rc, out.strip().replace("\n", " ")[:120]))
    finish_recv(proc, hlog, KEY_IQ, 8)
    report_key()
    camp.tune()
    camp.say("R4p0 stays loaded")


def silence_wav():
    n = 8000 * 3
    data = b"\x00\x00" * n
    hdr = struct.pack(
        "<4sI4s4sIHHIIHH4sI",
        b"RIFF", 36 + len(data), b"WAVE", b"fmt ", 16, 1, 1, 8000, 16000, 2, 16, b"data", len(data))
    path = HERE / "wav" / "r4p_silence.wav"
    path.parent.mkdir(exist_ok=True)
    path.write_bytes(hdr + data)
    return path


if __name__ == "__main__":
    main()
