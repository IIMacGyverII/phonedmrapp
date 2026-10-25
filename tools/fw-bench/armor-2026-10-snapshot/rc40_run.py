# R-C step 4. Four halves, line levels. The phone is not keyed. Wi-Fi adb only.
import hashlib
import json
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
import r4p0_run as rx
import rc20_run as old

IMAGE = camp.BUILD / "DMR003.RC40.V022.bin"
TAG = "DMR003.RC40.V022"
DIR = Path(r"C:\Users\Joshua\AppData\Local\Temp\fw1718\rc40")
DIR.mkdir(exist_ok=True)
OUT = DIR / "result.json"
BODY = 514
TONES = (1000.0, 300.0, 100.0, 50.0)
VARIANTS = (0, 2, 3, 4)
FS = 8000.0


def save(doc):
    OUT.write_text(json.dumps(doc, indent=2), encoding="utf-8")


def be(raw):
    x = np.empty(len(raw) // 2, np.float64)
    for i in range(x.size):
        v = (raw[2 * i] << 8) | raw[2 * i + 1]
        if v >= 32768:
            v -= 65536
        x[i] = v
    return x


def parts(raw):
    out = []
    for i in range(0, len(raw) - BODY + 1, BODY):
        b = raw[i:i + BODY]
        samples = be(b[:512])
        groups = sum(1 for k in range(0, 512, 4) if b[k + 1] == 0 and b[k + 2] == 0 and b[k + 3] == 0)
        out.append({"seq": int(b[512]), "half": int(b[513]), "groups": groups, "samples": samples})
    out.sort(key=lambda p: p["seq"])
    return out


def line(x, freq):
    x = np.asarray(x, np.float64)
    x = x - np.mean(x)
    n = x.size
    k = np.arange(n)
    w = np.exp(-2j * np.pi * freq * k / FS)
    return float(np.abs(np.dot(x, w)) * 2.0 / n)


def boundaries(x):
    d = np.abs(np.diff(x))
    med = float(np.median(d)) + 1e-9
    steps = []
    for b in (256, 512, 768):
        step = float(abs(x[b] - x[b - 1]))
        steps.append({"at": b, "step": step, "over_median": step / med})
    return steps


def capture(name, seconds, vga, mode, tone):
    blob, n = old.fm_bytes(seconds, tone=tone)
    path = DIR / (name + ".cs8")
    path.write_bytes(blob)
    proc, hlog = old.start_tx(path, n, vga)
    try:
        time.sleep(0.4)
        hit, _text = old.ask_rx(mode)
        raw = old.pull_rx(name + ".bin")
    finally:
        old.finish_tx(proc, hlog, seconds)
    got = parts(raw)
    if len(got) != 4 or [p["seq"] for p in got] != [0, 1, 2, 3]:
        camp.say("%s frames %s" % (name, [p["seq"] for p in got]))
        return {"log": hit[-160:], "ok": False, "n": len(got)}
    x = np.concatenate([p["samples"] for p in got])
    levels = {str(int(f)): line(x, f) for f in TONES}
    bounds = boundaries(x)
    camp.say("%s halves %s lines %s steps %s" % (
        name, [p["half"] for p in got],
        " ".join("%s:%.0f" % (k, v) for k, v in levels.items()),
        " ".join("%.1f" % s["over_median"] for s in bounds)))
    return {
        "log": hit[-160:], "ok": True,
        "halves": [p["half"] for p in got],
        "groups": [p["groups"] for p in got],
        "lines": levels, "bounds": bounds,
        "rms": float(np.sqrt(np.mean((x - np.mean(x)) ** 2))),
    }


def median_db(reps):
    out = {}
    ref = np.median([r["lines"]["1000"] for r in reps if r.get("ok")])
    for f in TONES:
        key = str(int(f))
        vals = [r["lines"][key] for r in reps if r.get("ok")]
        med = float(np.median(vals)) if vals else 0.0
        db = 20 * np.log10((med + 1e-12) / (ref + 1e-12)) if ref else None
        out[key] = {"median": med, "db_vs_1k": None if db is None else float(db), "n": len(vals)}
    return out


def end_state(doc):
    try:
        camp.tune()
    except Exception as exc:
        doc["tune_after"] = str(exc)
        camp.say("tune after the run failed: %s" % exc)
    rc, dbg = camp.adb("shell", "ls", "/sdcard/DMR/DMRDEBUG.bin")
    doc["dmrdebug"] = dbg.strip()
    camp.say("DMRDEBUG rc=%s %s" % (rc, dbg.strip().replace("\n", " ")[:120]))
    save(doc)


def main():
    if camp.SER != "192.168.1.125:5555":
        raise SystemExit("refusing USB target " + camp.SER)
    raw = IMAGE.read_bytes()
    digest = hashlib.sha256(raw).hexdigest()
    if raw[0x38464:0x38474] != TAG.encode():
        raise SystemExit("image is not RC40")
    global EXPECT
    camp.say("image sha256 " + digest)
    r3a3_run.devices_ok()
    if camp.hackrf_running():
        raise SystemExit("hackrf running")
    camp.adb("shell", "input", "keyevent", "224")
    camp.adb("shell", "am", "start", "-n", "com.macdmr.radio/.MainActivity")
    time.sleep(4)
    camp.tune()
    doc = {"sha256": digest, "tag": TAG, "dev_hz": old.DEV, "vga": 20, "adb": camp.SER}
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
    boot = camp.CAP / "rc40_boot.iq"
    proc, hlog = rx.recv(boot, 30, 24, 38)
    thr.join(180)
    rx.finish_recv(proc, hlog, boot, 30)
    if box.get("error"):
        r3a3_silence.restore_factory()
        raise box["error"]
    loaded = box.get("loaded", "")
    doc["loaded"] = loaded
    if loaded != TAG:
        r3a3_silence.restore_factory()
        raise SystemExit("version %s" % loaded)
    text = camp.adb("shell", "logcat", "-d", "-s", "RadioService:I", "YModemManager:D", timeout=40)[1]
    (DIR / "load.log").write_text(text, encoding="utf-8", errors="replace")
    if "开机初始化完成" not in text and "module booted" not in text:
        r3a3_silence.restore_factory()
        raise SystemExit("banner missing")
    info = factory_boot.analyze(8.0, str(boot))
    doc["boot"] = {"peak_db": info["peak_db"], "above_10db_s": info["above_10db_s"]}
    camp.say("boot peak %.2f" % info["peak_db"])
    save(doc)
    if old.radiated(info):
        r3a3_silence.restore_factory()
        raise SystemExit("boot radiated")
    camp.tune()
    doc["variants"] = []
    for mode in VARIANTS:
        hit, body, qinfo = old.quiet(mode, "rc40_q%d.iq" % mode, 8)
        got = parts(body)
        camp.say("quiet v%d peak %.2f frames %d" % (mode, qinfo["peak_db"], len(got)))
        entry = {"mode": mode, "quiet_peak_db": qinfo["peak_db"], "quiet_log": hit[-160:],
                 "quiet_n": len(got), "tones": {}}
        if got:
            x = np.concatenate([p["samples"] for p in got]) if len(got) == 4 else got[0]["samples"]
            entry["quiet_rms"] = float(np.sqrt(np.mean((x - np.mean(x)) ** 2)))
            entry["quiet_groups"] = [p["groups"] for p in got]
            entry["quiet_halves"] = [p["half"] for p in got]
        doc["variants"].append(entry)
        save(doc)
        if old.radiated(qinfo) or len(got) != 4:
            camp.say("STOP variant %d" % mode)
            break
        old.dummy(20)
        for freq in TONES:
            reps = []
            for nrep in range(3):
                reps.append(capture("v%d_%d_%d" % (mode, int(freq), nrep), 4.0, 20, mode, freq))
            entry["tones"][str(int(freq))] = reps
            save(doc)
        entry["median"] = median_db([r for f in entry["tones"].values() for r in f if f])
        # median_db expects a list of captures for one tone set; rebuild per tone properly
        med = {}
        ok1 = [r for r in entry["tones"]["1000"] if r.get("ok")]
        ref = float(np.median([r["lines"]["1000"] for r in ok1])) if ok1 else 0.0
        for freq in TONES:
            key = str(int(freq))
            oks = [r for r in entry["tones"][key] if r.get("ok")]
            vals = [r["lines"][key] for r in oks]
            m = float(np.median(vals)) if vals else 0.0
            db = 20 * np.log10((m + 1e-12) / (ref + 1e-12)) if ref else None
            steps = [max(s["over_median"] for s in r["bounds"]) for r in oks if r.get("bounds")]
            med[key] = {"median": m, "db_vs_1k": None if db is None else float(db), "n": len(vals),
                        "max_boundary": max(steps) if steps else None}
            camp.say("v%d %s Hz %+s dB n=%d boundary %s" % (
                mode, key, "nan" if db is None else "%.1f" % db, len(vals),
                None if not steps else "%.1f" % max(steps)))
        entry["median"] = med
        save(doc)
    best = None
    for entry in doc["variants"]:
        cell = (entry.get("median") or {}).get("100")
        if cell and cell.get("db_vs_1k") is not None and (best is None or cell["db_vs_1k"] > best[0]):
            best = (cell["db_vs_1k"], entry["mode"])
    doc["best_100"] = {"db": best[0], "mode": best[1]} if best else None
    camp.say("best 100 Hz %s" % doc["best_100"])
    end_state(doc)
    camp.say("END RC40")


def finish():
    """RC40 is already loaded. Power-cycle the module for the boot capture, then the tones."""
    if camp.SER != "192.168.1.125:5555":
        raise SystemExit("refusing USB target " + camp.SER)
    raw = IMAGE.read_bytes()
    digest = hashlib.sha256(raw).hexdigest()
    if raw[0x38464:0x38474] != TAG.encode():
        raise SystemExit("image file is not RC40")
    camp.say("finish sha256 " + digest + " adb " + camp.SER)
    r3a3_run.devices_ok()
    if camp.hackrf_running():
        raise SystemExit("hackrf running")
    camp.adb("shell", "input", "keyevent", "224")
    camp.adb("shell", "am", "start", "-n", "com.macdmr.radio/.MainActivity")
    time.sleep(4)
    camp.adb("shell", "logcat", "-c")
    boot = camp.CAP / "rc40_boot.iq"
    proc, hlog = rx.recv(boot, 30, 24, 38)
    time.sleep(2.0)
    camp.broadcast(["--es", "cmd", "restartmodule"])
    camp.say("restartmodule sent")
    rx.finish_recv(proc, hlog, boot, 30)
    text = camp.adb("shell", "logcat", "-d", "-s", "RadioService:I", timeout=40)[1]
    (DIR / "boot.log").write_text(text, encoding="utf-8", errors="replace")
    if "DMR003.RC40.V022" not in text:
        raise SystemExit("RC40 tag missing after the restart")
    if "开机初始化完成" not in text and "module booted" not in text:
        raise SystemExit("banner missing")
    info = factory_boot.analyze(2.0, str(boot))
    doc = {"sha256": digest, "tag": TAG, "dev_hz": old.DEV, "vga": 20, "adb": camp.SER,
           "boot": {"peak_db": info["peak_db"], "above_10db_s": info["above_10db_s"]},
           "loaded": TAG}
    camp.say("boot peak %.2f above10 %.2f" % (info["peak_db"], info["above_10db_s"]))
    save(doc)
    if old.radiated(info):
        r3a3_silence.restore_factory()
        raise SystemExit("boot radiated")
    camp.tune()
    doc["variants"] = []
    for mode in VARIANTS:
        hit, body, qinfo = old.quiet(mode, "rc40_q%d.iq" % mode, 8)
        got = parts(body)
        camp.say("quiet v%d peak %.2f frames %d" % (mode, qinfo["peak_db"], len(got)))
        entry = {"mode": mode, "quiet_peak_db": qinfo["peak_db"], "quiet_log": hit[-160:],
                 "quiet_n": len(got), "tones": {}}
        if got:
            x = np.concatenate([p["samples"] for p in got]) if len(got) == 4 else got[0]["samples"]
            entry["quiet_rms"] = float(np.sqrt(np.mean((x - np.mean(x)) ** 2)))
            entry["quiet_groups"] = [p["groups"] for p in got]
            entry["quiet_halves"] = [p["half"] for p in got]
        doc["variants"].append(entry)
        save(doc)
        if old.radiated(qinfo) or len(got) != 4:
            camp.say("STOP variant %d" % mode)
            break
        old.dummy(20)
        for freq in TONES:
            reps = []
            for nrep in range(3):
                reps.append(capture("v%d_%d_%d" % (mode, int(freq), nrep), 4.0, 20, mode, freq))
            entry["tones"][str(int(freq))] = reps
            save(doc)
        med = {}
        ok1 = [r for r in entry["tones"]["1000"] if r.get("ok")]
        ref = float(np.median([r["lines"]["1000"] for r in ok1])) if ok1 else 0.0
        for freq in TONES:
            key = str(int(freq))
            oks = [r for r in entry["tones"][key] if r.get("ok")]
            vals = [r["lines"][key] for r in oks]
            m = float(np.median(vals)) if vals else 0.0
            db = 20 * np.log10((m + 1e-12) / (ref + 1e-12)) if ref else None
            steps = [max(s["over_median"] for s in r["bounds"]) for r in oks if r.get("bounds")]
            med[key] = {"median": m, "db_vs_1k": None if db is None else float(db), "n": len(vals),
                        "max_boundary": max(steps) if steps else None}
            camp.say("v%d %s Hz %+s dB n=%d boundary %s" % (
                mode, key, "nan" if db is None else "%.1f" % db, len(vals),
                None if not steps else "%.1f" % max(steps)))
        entry["median"] = med
        save(doc)
    best = None
    for entry in doc["variants"]:
        cell = (entry.get("median") or {}).get("100")
        if cell and cell.get("db_vs_1k") is not None and (best is None or cell["db_vs_1k"] > best[0]):
            best = (cell["db_vs_1k"], entry["mode"])
    doc["best_100"] = {"db": best[0], "mode": best[1]} if best else None
    camp.say("best 100 Hz %s" % doc["best_100"])
    end_state(doc)
    camp.say("END RC40")


if __name__ == "__main__":
    if len(sys.argv) > 1 and sys.argv[1] == "finish":
        finish()
    else:
        main()
