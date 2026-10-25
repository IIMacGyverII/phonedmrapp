# R4r: the R4p M17 body, stored with the TX-RAM byte swap. One host key.
# 467.625 MHz, low power. HackRF receive only. A loud boot restores factory.
import hashlib
import sys
import threading
import time
from pathlib import Path

import numpy as np

sys.path.insert(0, r"C:\Users\Joshua\AppData\Local\Temp\fw1718")
sys.path.insert(0, r"D:\Documents\code\personal\phonedmrapp\tools\m17-research")
import camp
import factory_boot
import m17
import r3a3_run
import r3a3_silence
import r4p0_run as r

IMAGE = camp.BUILD / "DMR003.R4r0.V022.bin"
TAG = "DMR003.R4r0.V022"
EXPECT = "8ce6cd45f9872dbc525d77dbaf912a40b499498aacd1bc18563954bd6348d2d2"
HERE = Path(r"C:\Users\Joshua\AppData\Local\Temp\fw1718")
r.IMAGE = IMAGE
r.TAG = TAG
r.PCM = HERE / "r4r_m17.pcm"
r.BOOT_IQ = camp.CAP / "r4r0_boot.iq"
r.KEY_IQ = camp.CAP / "r4r0_key.iq"


def p99(x):
    return float(np.percentile(np.abs(x), 99)) if len(x) else float("nan")


def main():
    raw = IMAGE.read_bytes()
    digest = hashlib.sha256(raw).hexdigest()
    if digest != EXPECT or raw[0x38464:0x38474] != TAG.encode():
        raise SystemExit("image is not R4r0")
    peak = r.waveform()
    camp.say("image sha256 %s peak %d stop %.1f" % (digest, peak, peak * 0.55))
    if peak > 6451 or peak * 0.55 >= 5000:
        raise SystemExit("peak")
    r3a3_run.devices_ok()
    if camp.hackrf_running():
        raise SystemExit("hackrf_transfer already running")
    r.install_pcm()
    camp.install_wav(r.silence_wav(), "silence")
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
    proc, hlog = r.recv(r.BOOT_IQ, 30, 24, 38)
    thr.join(120)
    r.finish_recv(proc, hlog, r.BOOT_IQ, 30)
    if box.get("error"):
        r3a3_silence.restore_factory()
        raise box["error"]
    loaded = box.get("loaded", "")
    camp.say("loaded " + str(loaded))
    if loaded != TAG:
        r3a3_silence.restore_factory()
        raise SystemExit("version %s" % loaded)
    text = camp.adb("shell", "logcat", "-d", "-s", "RadioService:I", "YModemManager:D", timeout=40)[1]
    (HERE / "r4r_load.log").write_text(text, encoding="utf-8", errors="replace")
    banner = [ln.strip() for ln in text.splitlines()
              if "开机初始化完成" in ln or "module booted" in ln or "module DMR" in ln or "onSuccess" in ln]
    camp.say("boot lines " + " | ".join(b[-180:] for b in banner[-6:]))
    if "开机初始化完成" not in text and "module booted" not in text:
        r3a3_silence.restore_factory()
        raise SystemExit("banner missing")
    info = factory_boot.analyze(8.0, str(r.BOOT_IQ))
    camp.say("boot floor %.2f peak %.2f runs %d above10 %.2f" % (
        info["floor_db"], info["peak_db"], len(info["runs"]), info["above_10db_s"]))
    if info["peak_db"] >= 10 or any(run["peak_db"] >= 10 for run in info["runs"]):
        camp.say("boot radiation, restoring factory")
        r3a3_silence.restore_factory()
        raise SystemExit("boot radiated")
    camp.tune()
    try:
        r.send_chunks()
    except Exception as exc:
        camp.tune()
        camp.say("store failed (%s); not keying; R4r0 stays loaded" % exc)
        return
    proc, hlog = r.recv(r.KEY_IQ, 8, 16, 16)
    time.sleep(0.8)
    rc, out = camp.broadcast(["--es", "cmd", "txwav", "--es", "name", "silence"])
    camp.say("txwav rc=%d %s" % (rc, out.strip().replace("\n", " ")[:140]))
    r.finish_recv(proc, hlog, r.KEY_IQ, 8)
    dev, kinfo = camp.demod(str(r.KEY_IQ))
    i0 = int(kinfo["i0"])
    fs = camp.FS_A
    click = dev[i0:i0 + int(0.04 * fs)]
    tail = dev[i0 + int(0.40 * fs):i0 + int(2.2 * fs)]
    camp.say("key snr %.1f clip %.3f offset %+.0f keyed %.2f click_p99 %.0f tail_p99 %.0f" % (
        kinfo["snr_db"], kinfo["clip_frac"], kinfo["offset_hz"], kinfo["keyed_s"], p99(click), p99(tail)))
    over = False
    for ms in range(0, 400, 20):
        sl = dev[i0 + int(ms / 1000 * fs):i0 + int((ms + 20) / 1000 * fs)]
        if len(sl) < 10:
            break
        val = p99(sl)
        if ms <= 240:
            camp.say("slice %3d ms p99 %6.0f" % (ms, val))
        if ms >= 60 and 500 < val <= 8000 and val > camp.STOP_HZ:
            over = True
    if over:
        camp.say("STOP modulated p99 above 5 kHz; not keying again")
    else:
        for name, a_s, b_s in (("early", 0.04, 0.32), ("body", 0.08, 0.28)):
            sl = dev[i0 + int(a_s * fs):i0 + int(b_s * fs)]
            res = m17.decode_transmission(sl, fs, verbose=False)
            lsf = res.get("lsf")
            good = 0
            rows = []
            for fn, pay, err in res["frames"]:
                ok = bytes(pay) == bytes(range(16)) and err == 0
                good += int(ok)
                rows.append("%d/%d" % (fn, err))
            camp.say("decode %s lsf_ok %s frames %d good %d [%s]" % (
                name, bool(lsf) and bool(lsf[2]), len(res["frames"]), good, " ".join(rows[:12])))
    camp.tune()
    rc, dbg = camp.adb("shell", "ls", "/sdcard/DMR/DMRDEBUG.bin")
    camp.say("DMRDEBUG rc=%s %s" % (rc, dbg.strip().replace("\n", " ")[:160]))
    text = camp.adb("shell", "logcat", "-d", "-s", "RadioService:I", "DiagReceiver:I", timeout=40)[1]
    (HERE / "r4r_radio.log").write_text(text, encoding="utf-8", errors="replace")
    camp.say("R4r0 stays loaded; no second key")


if __name__ == "__main__":
    main()
