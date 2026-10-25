"""R-H host device run. HackRF transmits, the phone receives. Does not key the phone.
Wi-Fi adb only. Does not call vfo_off or restore the factory image.
Three 30-frame transmissions with a 1.6 s +3/-3 lead, hold on, then one plain-state
control with the same lead.
"""
import json
import sys
import time
from pathlib import Path

import numpy as np

sys.path.insert(0, r"D:\Documents\code\personal\phonedmrapp\tools\m17-research")
import m17  # noqa: E402

import camp
import r3a3_run
import rd10_run as r
import rc20_run as old
import rf_run

DIR = camp.HERE / "rhhost"
DIR.mkdir(parents=True, exist_ok=True)
OUT = DIR / "result.json"


def say(m):
    camp.say(m)


def heard_lines(text):
    return [ln.strip() for ln in text.splitlines() if "m17 heard " in ln]


def dump_m17():
    camp.adb("shell", "logcat", "-c")
    camp.broadcast(["--es", "cmd", "m17"])
    text = r.wait_for("m17: running", 6)
    return heard_lines(text), text


def one_tx(label, src, dst):
    payloads = [bytes([(i + k) & 0xFF for k in range(16)]) for i in range(30)]
    syms, _lsf = m17.transmission(src, dst, payloads, eot=True)
    lead = np.tile(np.array([3.0, -3.0]), int(1.6 * 4800) // 2)
    packed = np.concatenate([lead, syms])
    blob, n = rf_run.iq_syms(packed, 2400)
    path = DIR / (label + ".cs8")
    path.write_bytes(blob)
    seconds = n / old.FS_TX
    proc, hlog = old.start_tx(path, n, 20)
    time.sleep(0.8)
    reading = None
    try:
        camp.broadcast(["--es", "cmd", "cmdbyte", "--ei", "b", "50", "--ei", "d", "1"])
        text = r.wait_for("cmd=0x32", 3)
        reading = r.hit_line(text, "cmd=0x32")[-180:]
    except Exception as e:
        reading = str(e)
    old.finish_tx(proc, hlog, seconds)
    time.sleep(3.0)
    say(label + " tx %.2fs rssi %s" % (seconds, reading))
    return {"src": src, "dst": dst, "seconds": round(seconds, 2), "rssi": reading}


def main():
    r3a3_run.devices_ok()
    if camp.hackrf_running():
        say("hackrf was already running; stopping it")
        camp.kill_hackrf()
        if camp.hackrf_running():
            raise SystemExit("hackrf still held")
    doc = {"txs": []}
    try:
        camp.adb("shell", "am", "force-stop", "com.macdmr.radio")
        time.sleep(1)
        camp.adb("shell", "am", "start", "-n", "com.macdmr.radio/.MainActivity")
        time.sleep(3)
        camp.tune()
        camp.adb("shell", "logcat", "-c")
        camp.broadcast(["--es", "cmd", "cmdbyte", "--ei", "b", "52", "--ei", "d", "1"])
        ver = r.wait_for("module DMR", 8)
        doc["version"] = r.hit_line(ver, "module DMR")[-120:]
        say("version " + doc["version"])
        if "RG10" not in doc["version"]:
            raise SystemExit("RG10 is not the loaded image")
        camp.adb("shell", "logcat", "-c")
        camp.broadcast(["--es", "cmd", "m17", "--ez", "on", "true"])
        hold = r.wait_for("data hold action=1", 8)
        doc["hold"] = r.hit_line(hold, "data hold")[-160:]
        say(doc["hold"])
        if "sr=0" not in doc["hold"]:
            raise SystemExit("hold was not accepted")
        old.dummy(20)
        pairs = [("held1", "K6M17", "W9LAB"), ("held2", "W5RF", "N6EQ"), ("held3", "N5TST", "K6DEC")]
        for label, src, dst in pairs:
            doc["txs"].append(one_tx(label, src, dst))
        heard, _text = dump_m17()
        doc["held_heard"] = heard
        say("held list " + " | ".join(heard))
        camp.adb("shell", "logcat", "-c")
        camp.broadcast(["--es", "cmd", "m17", "--ez", "on", "false"])
        off = r.wait_for("data hold action=0", 8)
        doc["release"] = r.hit_line(off, "data hold")[-160:]
        say(doc["release"])
        camp.adb("shell", "logcat", "-c")
        camp.broadcast(["--es", "cmd", "m17", "--ez", "on", "true", "--ez", "hold", "false"])
        plain = r.wait_for("m17: running", 8)
        doc["plain_start"] = r.hit_line(plain, "m17: running")[-200:]
        say(doc["plain_start"])
        time.sleep(0.8)
        doc["plain_tx"] = one_tx("plain", "W1RF", "N2EQ")
        heard2, _text = dump_m17()
        doc["plain_heard"] = heard2
        say("plain list " + " | ".join(heard2))
        camp.broadcast(["--es", "cmd", "m17", "--ez", "on", "false"])
        camp.tune()
        doc["ok"] = True
    finally:
        camp.kill_hackrf()
        OUT.write_text(json.dumps(doc, indent=2), encoding="utf-8")
        say("wrote " + str(OUT))


if __name__ == "__main__":
    main()
