"""RE10. Receive only. Wi-Fi adb only. Does not key the phone and does not call vfo_off."""
import json
import time
from pathlib import Path

import numpy as np

import camp
import factory_boot
import r3a3_run
import r3a3_silence
import r4p0_run as rx
import rc20_run as old
import rd10_run as r

TAG = "DMR003.RE10.V022"
IMAGE = camp.REPO / "radio_firmware" / "build" / (TAG + ".bin")
DIR = camp.HERE / "re10"
DIR.mkdir(parents=True, exist_ok=True)
OUT = DIR / "result.json"
FS = 8000.0


def save(doc):
    OUT.write_text(json.dumps(doc, indent=2), encoding="utf-8")


def line(x, freq):
    x = np.asarray(x, np.float64)
    x = x - np.mean(x)
    k = np.arange(x.size)
    w = np.exp(-2j * np.pi * freq * k / FS)
    return float(np.abs(np.dot(x, w)) * 2.0 / x.size)


def loud_line(name, freq):
    iq, n = r.tone_iq(2.4, float(freq))
    pcm, hit = r.play_and_clip(name, iq, n, 1600)
    if pcm is None or pcm.size < 400:
        camp.say(name + " no pcm")
        return {"line_last": 0.0, "rms_last": 0.0, "log": (hit or "")[-160:]}
    last = pcm[-int(0.4 * FS):]
    # first 100 ms window at rms >= 800
    onset = 0
    for i in range(0, pcm.size - 400, 80):
        sl = pcm[i:i + 400]
        if np.sqrt(np.mean((sl - sl.mean()) ** 2)) >= 800:
            onset = i
            break
    camp.say("%s onset %.2f last100 %.1f" % (name, onset / FS, line(last, freq)))
    return {
        "onset_s": onset / FS,
        "line_last": line(last, freq),
        "rms_last": float(np.sqrt(np.mean((last - last.mean()) ** 2))),
        "line_full": line(pcm, freq),
        "log": (hit or "")[-160:],
    }


def main():
    if camp.SER != "192.168.1.125:5555":
        raise SystemExit("refusing " + camp.SER)
    raw = IMAGE.read_bytes()
    if raw[0x38464:0x38474] != TAG.encode():
        raise SystemExit("image is not RE10")
    r3a3_run.devices_ok()
    if camp.hackrf_running():
        raise SystemExit("hackrf running")
    camp.adb("shell", "input", "keyevent", "224")
    camp.adb("shell", "am", "start", "-n", "com.macdmr.radio/.MainActivity")
    time.sleep(3)
    doc = {"tag": TAG, "adb": camp.SER}
    boot = camp.CAP / "re10_boot.iq"
    proc, hlog = rx.recv(boot, 220, 24, 38)
    try:
        loaded = camp.load_image(IMAGE)
    except Exception as exc:
        camp.say("loader returned: " + str(exc))
        loaded = ""
    rx.finish_recv(proc, hlog, boot, 220)
    if loaded != TAG:
        try:
            loaded = camp.read_version(power_cycle=False)
        except Exception as exc:
            camp.say("version read: " + str(exc))
    doc["loaded"] = loaded
    save(doc)
    if loaded != TAG:
        raise SystemExit("version %s" % loaded)
    text = camp.adb("shell", "logcat", "-d", "-t", "4000", "-s", "RadioService:I", "YModemManager:D", timeout=40)[1]
    (DIR / "load.log").write_text(text, encoding="utf-8", errors="replace")
    doc["banner"] = "seen" if ("开机初始化完成" in text or "module booted" in text) else "not in retained log"
    info = factory_boot.analyze(8.0, str(boot))
    doc["boot"] = {"peak_db": info["peak_db"], "above_10db_s": info["above_10db_s"],
                   "floor_db": info["floor_db"]}
    camp.say("boot peak %.3f above10 %.3f banner %s" % (info["peak_db"], info["above_10db_s"], doc["banner"]))
    save(doc)
    if old.radiated(info):
        r3a3_silence.restore_factory()
        raise SystemExit("boot radiated")
    camp.tune()
    rc, dbg = camp.adb("shell", "ls", "/sdcard/DMRDEBUG.bin")
    doc["dmrdebug_rc"] = rc
    camp.say("DMRDEBUG rc %s" % rc)

    doc["hold"] = r.hold(3, 1)
    path = camp.CAP / "re10_refuse.iq"
    proc, hlog = rx.recv(path, 6, 24, 38)
    time.sleep(0.4)
    hit, got = r.ask_rx(4, 4)
    rx.finish_recv(proc, hlog, path, 6)
    qinfo = factory_boot.analyze(1.0, str(path))
    doc["refuse"] = {"log": (hit or "")[-180:], "parts": len(got), "peak_db": qinfo["peak_db"]}
    camp.say("refuse parts %d peak %.2f %s" % (len(got), qinfo["peak_db"], (hit or "")[-120:]))
    save(doc)
    if old.radiated(qinfo):
        r3a3_silence.restore_factory()
        raise SystemExit("refuse radiated")

    old.dummy(r.VGA)
    doc["held_100"] = loud_line("re10_held_100", 100)
    doc["restore"] = r.hold(3, 0)
    doc["plain_100"] = loud_line("re10_plain_100", 100)
    camp.tune()
    doc["tuned_100"] = loud_line("re10_tuned_100", 100)
    save(doc)
    camp.tune()
    camp.say("RE10 done")


if __name__ == "__main__":
    try:
        main()
    finally:
        r.restore_hold()
        if camp.hackrf_running():
            camp.kill_hackrf()
