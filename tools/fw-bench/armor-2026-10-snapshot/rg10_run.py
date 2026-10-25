"""RG10. Boot, a no-key render, a 1 kHz receive capture, then one 90-frame low-power key.

Wi-Fi adb only. Does not call vfo_off. The key is the existing host path (opcode 1).
"""
import hashlib
import sys
import time
from pathlib import Path

import numpy as np

sys.path.insert(0, r"C:\Users\Joshua\AppData\Local\Temp\fw1718")
sys.path.insert(0, r"D:\Documents\code\personal\phonedmrapp\tools\fw-patch")
sys.path.insert(0, r"D:\Documents\code\personal\phonedmrapp\tools\m17-research")
import camp
import factory_boot
import m17_rrc
import r3a3_run
import r3a3_silence
import r4p0_run as rx
import r4s0_run as s
import rd10_run as rd
import rc20_run as old

TAG = "DMR003.RG10.V022"
IMAGE = camp.REPO / "radio_firmware" / "build" / (TAG + ".bin")
DIR = camp.HERE / "rg10"
DIR.mkdir(parents=True, exist_ok=True)
FS = 8000.0


def say_boot(doc):
    text = camp.adb("shell", "logcat", "-d", "-t", "4000", "-s", "RadioService:I", "YModemManager:D", timeout=40)[1]
    (DIR / "load.log").write_text(text, encoding="utf-8", errors="replace")
    doc["banner"] = "seen" if ("开机初始化完成" in text or "module booted" in text) else "not in retained log"
    return text


def phase(x, freq):
    t = np.arange(x.size) / FS
    A = np.column_stack([np.sin(2 * np.pi * freq * t), np.cos(2 * np.pi * freq * t), np.ones_like(t)])
    c, *_ = np.linalg.lstsq(A, x, rcond=None)
    return float(np.degrees(np.arctan2(c[1], c[0])))


def main():
    if camp.SER != "192.168.1.125:5555":
        raise SystemExit("refusing " + camp.SER)
    raw = IMAGE.read_bytes()
    if raw[0x38464:0x38474] != TAG.encode():
        raise SystemExit("image is not RG10")
    digest = hashlib.sha256(raw).hexdigest()
    camp.say("sha256 " + digest)
    r3a3_run.devices_ok()
    if camp.hackrf_running():
        raise SystemExit("hackrf running")
    camp.adb("shell", "input", "keyevent", "224")
    camp.adb("shell", "am", "start", "-n", "com.macdmr.radio/.MainActivity")
    time.sleep(3)
    doc = {"tag": TAG, "sha256": digest}
    boot = camp.CAP / "rg10_boot.iq"
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
            camp.say("version " + str(exc))
    doc["loaded"] = loaded
    if loaded != TAG:
        raise SystemExit("version %s" % loaded)
    say_boot(doc)
    info = factory_boot.analyze(8.0, str(boot))
    doc["boot_peak"] = info["peak_db"]
    camp.say("boot peak %.3f banner %s" % (info["peak_db"], doc["banner"]))
    if old.radiated(info):
        r3a3_silence.restore_factory()
        raise SystemExit("boot radiated")
    camp.tune()

    sym = m17_rrc.pack_symbols([3, -3, 1, -1, 3, 1, -3, -1] * 6)
    s.install_sym(sym[:48])
    camp.adb("shell", "logcat", "-c")
    camp.broadcast(["--es", "cmd", "cmdsym", "--es", "op", "render",
                    "--es", "path", "/data/data/com.macdmr.radio/cache/m17.sym",
                    "--ei", "n", "64"])
    text = s.wait_log("render ", 8)
    hit = ""
    for ln in text.splitlines():
        if "render " in ln:
            hit = ln.strip()
    doc["render"] = hit[-180:]
    camp.say("render " + hit[-160:])
    if "sr=0" not in hit:
        camp.tune()
        raise SystemExit("render did not return sr=0")

    old.dummy(20)
    iq, n = rd.tone_iq(2.6, 1000.0)
    path = DIR / "ram1k.cs8"
    path.write_bytes(iq)
    proc, hlog = old.start_tx(path, n, 20)
    time.sleep(0.8)
    hit, got = rd.ask_rx(4, 6)
    old.finish_tx(proc, hlog, 2.6)
    halves = [p["half"] for p in got]
    jumps = []
    if len(got) == 6:
        phases = [phase(p["samples"], 1000.0) for p in got]
        jumps = [round(((phases[i + 1] - phases[i] + 180) % 360) - 180, 2) for i in range(5)]
        x = np.concatenate([p["samples"] for p in got])
        doc["ram_line"] = rd.line(x, 1000.0)
    doc["ram"] = {"halves": halves, "jumps": jumps, "log": (hit or "")[-160:]}
    camp.say("ram halves %s jumps %s" % (halves, jumps))
    rawbin = rd.DIR / "rx_m4_n6.bin"
    if rawbin.exists():
        (DIR / "ram1k.bin").write_bytes(rawbin.read_bytes())

    camp.tune()
    result = s.one_key(90, 3.8, 8, "rg90")
    doc["key"] = None if result is None else {
        "lsf": result["lsf"], "good": result["good"], "frames": result["frames"],
        "over": result["over"], "band": result["band"],
        "mod_min": result["mod_min"], "mod_max": result["mod_max"],
        "und": result["underrun_line"],
    }
    camp.say("key %s" % doc["key"])
    rc, dbg = camp.adb("shell", "ls", "/sdcard/DMRDEBUG.bin")
    doc["dmrdebug_rc"] = rc
    camp.tune()
    (DIR / "result.json").write_text(__import__("json").dumps(doc, indent=2), encoding="utf-8")
    camp.say("RG10 done")


if __name__ == "__main__":
    try:
        main()
    finally:
        if camp.hackrf_running():
            camp.kill_hackrf()
