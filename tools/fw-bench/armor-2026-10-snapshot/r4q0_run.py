# R4q: the R4o sine again, after the TX-RAM byte swap.
# One cmdsine (2048, 64 samples, 1000 Hz) and one 3 s silence key.
# 467.625 MHz, low power. HackRF receive only. Does not send an M17 body.
# A loud boot restores the factory image and does not key.
# A tone-window miss is a stop: no second key, and the image stays loaded.
import hashlib
import json
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

IMAGE = camp.BUILD / "DMR003.R4q0.V022.bin"
TAG = "DMR003.R4q0.V022"
EXPECT = "26730d4b611ae14807c5c99396f6ffeed6c59d210005c1b52847daa06f598a66"
HERE = Path(r"C:\Users\Joshua\AppData\Local\Temp\fw1718")
BOOT_IQ = camp.CAP / "r4q0_boot.iq"
KEY_IQ = camp.CAP / "r4q0_key.iq"
LINE_LO, LINE_HI = 923 * 0.85, 923 * 1.15
P99_LO, P99_HI = 1217 * 0.85, 1217 * 1.15


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


def silence_wav():
    n = 8000 * 3
    data = b"\x00\x00" * n
    hdr = struct.pack(
        "<4sI4s4sIHHIIHH4sI",
        b"RIFF", 36 + len(data), b"WAVE", b"fmt ", 16, 1, 1, 8000, 16000, 2, 16, b"data", len(data))
    path = HERE / "wav" / "r4q_silence.wav"
    path.parent.mkdir(exist_ok=True)
    path.write_bytes(hdr + data)
    return path


def p99(x):
    return float(np.percentile(np.abs(x), 99)) if len(x) else float("nan")


def tone_window(dev, i0):
    """20 ms slice with the strongest 1 kHz line whose p99 stays under 8 kHz."""
    fs = camp.FS_A
    rows = []
    best = None
    for ms in range(0, 400, 20):
        a = i0 + int(ms / 1000 * fs)
        b = a + int(0.02 * fs)
        if b > len(dev):
            break
        sl = dev[a:b]
        row = {"ms": ms, "p99": p99(sl), "line": camp.goertzel_peak(sl, fs, 1000)}
        rows.append(row)
        if row["p99"] < 8000 and (best is None or row["line"] > best["line"]):
            best = row
    return rows, best


def main():
    raw = IMAGE.read_bytes()
    digest = hashlib.sha256(raw).hexdigest()
    if digest != EXPECT or raw[0x38464:0x38474] != TAG.encode():
        raise SystemExit("image is not R4q0")
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
    while time.time() - t0 < 240 and "loaded" not in box and "error" not in box:
        text = camp.adb("shell", "logcat", "-d", "-s", "YModemManager:D", timeout=20)[1]
        if "onSuccess" in text:
            break
        time.sleep(1)
    ym = camp.adb("shell", "logcat", "-d", "-s", "YModemManager:D", timeout=20)[1]
    if "error" in box and "onSuccess" not in ym:
        thr.join(30)
        raise box["error"]
    camp.say("onSuccess seen, recording the boot")
    proc, hlog = recv(BOOT_IQ, 30, 24, 38)
    thr.join(120)
    finish_recv(proc, hlog, BOOT_IQ, 30)
    if "error" in box:
        r3a3_silence.restore_factory()
        raise box["error"]
    loaded = box.get("loaded", "")
    camp.say("loaded " + str(loaded))
    if loaded != TAG:
        r3a3_silence.restore_factory()
        raise SystemExit("version %s" % loaded)
    text = camp.adb("shell", "logcat", "-d", "-s", "RadioService:I", "YModemManager:D", timeout=40)[1]
    (HERE / "r4q_load.log").write_text(text, encoding="utf-8", errors="replace")
    banner = [ln.strip() for ln in text.splitlines()
              if "开机初始化完成" in ln or "module booted" in ln or "module DMR" in ln or "onSuccess" in ln]
    camp.say("boot lines " + " | ".join(b[-180:] for b in banner[-8:]))
    if "开机初始化完成" not in text and "module booted" not in text:
        r3a3_silence.restore_factory()
        raise SystemExit("banner missing")
    info = factory_boot.analyze(8.0, str(BOOT_IQ))
    camp.say("boot floor %.2f peak %.2f runs %d above10 %.2f" % (
        info["floor_db"], info["peak_db"], len(info["runs"]), info["above_10db_s"]))
    loud = [r for r in info["runs"] if r["peak_db"] >= 10]
    if loud or info["peak_db"] >= 10:
        camp.say("boot radiation, restoring factory")
        r3a3_silence.restore_factory()
        raise SystemExit("boot radiated")
    camp.tune()
    camp.adb("shell", "logcat", "-c")
    rc, out = camp.broadcast(
        ["--es", "cmd", "cmdsine", "--ei", "n", "64", "--ei", "amp", "2048", "--ei", "hz", "1000"])
    camp.say("cmdsine rc=%d %s" % (rc, out.strip().replace("\n", " ")[:120]))
    time.sleep(2)
    text = camp.adb("shell", "logcat", "-d", "-s", "RadioService:I", "DiagReceiver:I", timeout=40)[1]
    hits = [ln.strip() for ln in text.splitlines() if "0x40" in ln or "sine " in ln or "cmdsine" in ln]
    camp.say("store " + " | ".join(h[-200:] for h in hits[-8:]))
    if not any("len=2 [40 00]" in ln for ln in hits):
        camp.tune()
        camp.say("store did not echo 64; not keying; R4q0 stays loaded")
        (HERE / "r4q_radio.log").write_text(text, encoding="utf-8", errors="replace")
        return
    if any("cmd=0x26" in ln or "cmd=0x36" in ln for ln in text.splitlines()):
        camp.say("store keyed; not sending another key")
        (HERE / "r4q_radio.log").write_text(text, encoding="utf-8", errors="replace")
        return
    proc, hlog = recv(KEY_IQ, 8, 16, 16)
    time.sleep(0.8)
    rc, out = camp.broadcast(["--es", "cmd", "txwav", "--es", "name", "silence"])
    camp.say("txwav rc=%d %s" % (rc, out.strip().replace("\n", " ")[:140]))
    finish_recv(proc, hlog, KEY_IQ, 8)
    dev, kinfo = camp.demod(str(KEY_IQ))
    i0 = int(kinfo["i0"])
    fs = camp.FS_A
    click = dev[i0:i0 + int(0.04 * fs)]
    tail = dev[i0 + int(0.20 * fs):i0 + int(2.4 * fs)]
    rows, best = tone_window(dev, i0)
    camp.say("key snr %.1f clip %.3f offset %+.0f keyed %.2f click_p99 %.0f tail_p99 %.0f" % (
        kinfo["snr_db"], kinfo["clip_frac"], kinfo["offset_hz"], kinfo["keyed_s"],
        p99(click), p99(tail)))
    for row in rows:
        if row["ms"] <= 200:
            camp.say("slice %3d ms line %6.0f p99 %6.0f" % (row["ms"], row["line"], row["p99"]))
    passed = False
    if best is None:
        camp.say("STOP no tone slice under 8 kHz; not keying again; no M17 body")
    else:
        camp.say("best %d ms line %.0f p99 %.0f" % (best["ms"], best["line"], best["p99"]))
        passed = LINE_LO <= best["line"] <= LINE_HI and P99_LO <= best["p99"] <= P99_HI
        if passed:
            camp.say("PASS line %.0f in %.0f-%.0f and p99 %.0f in %.0f-%.0f" % (
                best["line"], LINE_LO, LINE_HI, best["p99"], P99_LO, P99_HI))
        else:
            camp.say("STOP line %.0f p99 %.0f outside 923/1217 plus or minus 15 percent; not keying again; no M17 body" % (
                best["line"], best["p99"]))
    (HERE / "r4q0_silence.json").write_text(json.dumps({
        "carrier": {k: kinfo[k] for k in ("snr_db", "clip_frac", "offset_hz", "keyed_s", "i0")},
        "click_p99": p99(click), "tail_p99": p99(tail), "slices": rows, "best": best, "pass": passed,
    }, indent=2), encoding="utf-8")
    camp.tune()
    rc, dbg = camp.adb("shell", "ls", "/sdcard/DMR/DMRDEBUG.bin")
    camp.say("DMRDEBUG rc=%s %s" % (rc, dbg.strip().replace("\n", " ")[:160]))
    text = camp.adb("shell", "logcat", "-d", "-s", "RadioService:I", "DiagReceiver:I", timeout=40)[1]
    (HERE / "r4q_radio.log").write_text(text, encoding="utf-8", errors="replace")
    camp.say("R4q0 stays loaded")


if __name__ == "__main__":
    main()
