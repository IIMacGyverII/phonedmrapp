# R4s: one symbol stream, then three 90-frame transmissions if the short one passes.
# 467.625 MHz, low power. HackRF receive only. A loud boot restores factory.
import hashlib
import struct
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
import m17_rrc
import m17_stream_table as tab
import r3a3_run
import r3a3_silence
import r4p0_run as r

IMAGE = camp.BUILD / "DMR003.R4s0.V022.bin"
TAG = "DMR003.R4s0.V022"
EXPECT = "2c8866bcf1a8696d8f0383cc86c11a674b56d764f2b171581d52922d969dd70f"
HERE = Path(r"C:\Users\Joshua\AppData\Local\Temp\fw1718")
SYM = HERE / "r4s_stream.sym"


def symbols(nframes):
    pre = [3, -3] * 54
    lsf_b = m17.lsf_bytes(tab.BENCH_CALL, tab.BENCH_CALL)
    syms = pre + list(m17.encode_lsf(lsf_b))
    for i in range(nframes):
        fn = i | (0x8000 if i == nframes - 1 else 0)
        syms += list(m17.encode_stream(lsf_b, fn, bytes(range(16)), i % 6))
    return syms


def install_sym(raw):
    SYM.write_bytes(raw)
    remote = "/data/local/tmp/m17.sym"
    rc, out = camp.adb("push", str(SYM), remote, timeout=60)
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


def silence_wav(seconds, name):
    n = int(round(8000 * seconds))
    data = b"\x00\x00" * n
    hdr = struct.pack(
        "<4sI4s4sIHHIIHH4sI",
        b"RIFF", 36 + len(data), b"WAVE", b"fmt ", 16, 1, 1, 8000, 16000, 2, 16, b"data", len(data))
    path = HERE / "wav" / name
    path.parent.mkdir(exist_ok=True)
    path.write_bytes(hdr + data)
    return path


def wait_log(needle, seconds):
    t0 = time.time()
    while time.time() - t0 < seconds:
        text = camp.adb("shell", "logcat", "-d", "-s", "RadioService:I", timeout=20)[1]
        if needle in text:
            return text
        time.sleep(0.3)
    return ""


def p99(x):
    return float(np.percentile(np.abs(x), 99)) if len(x) else float("nan")


def judge(dev, info, nframes, seconds):
    i0 = int(info["i0"])
    fs = camp.FS_A
    rows = []
    over = False
    modulated = []
    for ms in range(0, int(seconds * 1000), 20):
        sl = dev[i0 + int(ms / 1000 * fs):i0 + int((ms + 20) / 1000 * fs)]
        if len(sl) < 10:
            break
        val = p99(sl)
        if ms <= 200 or ms % 200 == 0:
            rows.append((ms, val))
        if ms >= 60 and val >= camp.STOP_HZ:
            over = True
        if ms >= 60 and 1000 < val < 8000:
            modulated.append(val)
    seg = dev[i0 + int(0.05 * fs):i0 + int((seconds + 0.4) * fs)]
    res = m17.decode_transmission(seg, fs, verbose=False)
    lsf = res.get("lsf")
    ok = bool(lsf) and bool(lsf[2])
    same = bool(lsf) and lsf[0] == tab.BENCH_CALL and lsf[1] == tab.BENCH_CALL
    good = 0
    shown = []
    for fn, pay, err in res["frames"]:
        hit = bytes(pay) == bytes(range(16)) and err == 0
        good += int(hit)
        if len(shown) < 8 or hit is False:
            shown.append("%d/%d" % (fn, err))
    camp.say("key snr %.1f clip %.3f offset %+.0f keyed %.2f" % (
        info["snr_db"], info["clip_frac"], info["offset_hz"], info["keyed_s"]))
    for ms, val in rows:
        camp.say("slice %4d ms p99 %6.0f" % (ms, val))
    if modulated:
        camp.say("modulated p99 min %.0f max %.0f n %d" % (min(modulated), max(modulated), len(modulated)))
    camp.say("decode lsf_ok %s both_match %s frames %d good %d [%s]" % (
        ok, same, len(res["frames"]), good, " ".join(shown[:12])))
    band = bool(modulated) and min(modulated) >= 2800 and max(modulated) <= 3100
    return {"lsf": ok, "good": good, "frames": len(res["frames"]), "over": over, "band": band,
            "mod_min": min(modulated) if modulated else None, "mod_max": max(modulated) if modulated else None}


def one_key(nframes, wav_s, cap_s, label):
    install_sym(m17_rrc.pack_symbols(symbols(nframes)))
    camp.install_wav(silence_wav(wav_s, "r4s_%s.wav" % label), "silence")
    camp.adb("shell", "logcat", "-c")
    rc, out = camp.broadcast(["--es", "cmd", "cmdsym", "--es", "path",
                              "/data/data/com.macdmr.radio/cache/m17.sym"])
    camp.say("cmdsym rc=%d" % rc)
    if not wait_log("sym ready", 8):
        camp.say("sym did not become ready; not keying")
        return None
    iq = camp.CAP / ("r4s0_%s.iq" % label)
    proc, hlog = r.recv(iq, cap_s, 16, 16)
    time.sleep(0.4)
    rc, out = camp.broadcast(["--es", "cmd", "txwav", "--es", "name", "silence"])
    camp.say("txwav rc=%d %s" % (rc, out.strip().replace("\n", " ")[:100]))
    r.finish_recv(proc, hlog, iq, cap_s)
    wait_log("sym done", 8)
    camp.broadcast(["--es", "cmd", "cmdsym", "--es", "op", "status"])
    time.sleep(0.6)
    text = camp.adb("shell", "logcat", "-d", "-s", "RadioService:I", timeout=30)[1]
    (HERE / ("r4s_%s.log" % label)).write_text(text, encoding="utf-8", errors="replace")
    und = [ln.strip() for ln in text.splitlines() if "underrun=" in ln or "sym ready" in ln or "sym done" in ln or "sym refused" in ln]
    camp.say("symlog " + " | ".join(u[-160:] for u in und[-6:]))
    dev, info = camp.demod(str(iq))
    result = judge(dev, info, nframes, wav_s)
    result["underrun_line"] = " | ".join(u[-120:] for u in und[-4:])
    if result["over"]:
        camp.say("STOP a modulated slice is at or over 5 kHz")
    return result


def main():
    raw = IMAGE.read_bytes()
    digest = hashlib.sha256(raw).hexdigest()
    if digest != EXPECT or raw[0x38464:0x38474] != TAG.encode():
        raise SystemExit("image is not R4s0")
    camp.say("image sha256 " + digest)
    if "--no-load" in sys.argv:
        r3a3_run.devices_ok()
        if camp.hackrf_running():
            raise SystemExit("hackrf running")
        camp.adb("shell", "input", "keyevent", "224")
        camp.adb("shell", "am", "start", "-n", "com.macdmr.radio/.MainActivity")
        time.sleep(4)
        camp.tune()
        short = one_key(50, 4, 8, "s50b")
        if short is None or short["over"]:
            camp.tune()
            camp.say("R4s0 stays loaded; no 90-frame run")
            return
        passed = short["lsf"] and short["good"] >= 45 and short["band"] and "underrun=0" in short["underrun_line"]
        camp.say("short pass %s" % passed)
        if not passed:
            camp.tune()
            camp.say("R4s0 stays loaded; short stream did not pass")
            return
        for i in range(3):
            camp.tune()
            result = one_key(90, 6, 10, "f90_%d" % i)
            if result is None or result["over"]:
                camp.say("stopped during 90-frame run %d" % i)
                break
        camp.tune()
        rc, dbg = camp.adb("shell", "ls", "/sdcard/DMR/DMRDEBUG.bin")
        camp.say("DMRDEBUG rc=%s %s" % (rc, dbg.strip().replace("\n", " ")[:120]))
        camp.say("R4s0 stays loaded")
        return
    r3a3_run.devices_ok()
    if camp.hackrf_running():
        raise SystemExit("hackrf running")
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
    boot = camp.CAP / "r4s0_boot.iq"
    proc, hlog = r.recv(boot, 30, 24, 38)
    thr.join(120)
    r.finish_recv(proc, hlog, boot, 30)
    if box.get("error"):
        r3a3_silence.restore_factory()
        raise box["error"]
    loaded = box.get("loaded", "")
    camp.say("loaded " + str(loaded))
    if loaded != TAG:
        r3a3_silence.restore_factory()
        raise SystemExit("version %s" % loaded)
    text = camp.adb("shell", "logcat", "-d", "-s", "RadioService:I", "YModemManager:D", timeout=40)[1]
    (HERE / "r4s_load.log").write_text(text, encoding="utf-8", errors="replace")
    if "开机初始化完成" not in text and "module booted" not in text:
        r3a3_silence.restore_factory()
        raise SystemExit("banner missing")
    info = factory_boot.analyze(8.0, str(boot))
    camp.say("boot floor %.2f peak %.2f runs %d above10 %.2f" % (
        info["floor_db"], info["peak_db"], len(info["runs"]), info["above_10db_s"]))
    if info["peak_db"] >= 10 or any(run["peak_db"] >= 10 for run in info["runs"]):
        r3a3_silence.restore_factory()
        raise SystemExit("boot radiated")
    camp.tune()
    short = one_key(50, 4, 8, "s50")
    if short is None or short["over"]:
        camp.tune()
        camp.say("R4s0 stays loaded; no 90-frame run")
        return
    passed = short["lsf"] and short["good"] >= 45 and short["band"] and "underrun=0" in short["underrun_line"]
    camp.say("short pass %s" % passed)
    if not passed:
        camp.tune()
        camp.say("R4s0 stays loaded; short stream did not pass")
        return
    for i in range(3):
        camp.tune()
        result = one_key(90, 6, 10, "f90_%d" % i)
        if result is None or result["over"]:
            camp.say("stopped during 90-frame run %d" % i)
            break
    camp.tune()
    rc, dbg = camp.adb("shell", "ls", "/sdcard/DMR/DMRDEBUG.bin")
    camp.say("DMRDEBUG rc=%s %s" % (rc, dbg.strip().replace("\n", " ")[:120]))
    camp.say("R4s0 stays loaded")


if __name__ == "__main__":
    main()
