# FW19 heat runs. Logs battery temperature and every thermal zone
# before a key, every 5 s during it, and every 15 s for 3 min after.
# Unkeys (0x26 body 2) if the battery passes 45 C or any live zone
# rises more than 1 C in 10 s. Low power first: 30 s carrier, then
# the 45 s op-7 stream. High power only if those stay inside the stop
# and the HackRF stays out of clipping at the lowest gain that shows
# the carrier. Does not call vfo_off. Does not restore unless a
# transmitted bin, other than the click, is at or over 5 kHz.
import json
import os
import re
import subprocess
import sys
import time
from pathlib import Path

import numpy as np

sys.path.insert(0, r"C:\Users\Joshua\AppData\Local\Temp\fw1718")
import camp
import fw19_run
import r3a3_run
import r3a3_silence

HERE = fw19_run.HERE
RUNLOG = HERE / "fw19_heat_run.log"
JSONL = HERE / "fw19_heat.jsonl"
TAG = "DMR003.FW19.V022"
EXCLUDED = set()
RESTORED = {"yes": False}
PROC = {"p": None, "h": None}

runlog = open(RUNLOG, "w", encoding="utf-8", buffering=1)


def note(m):
    camp.say(m)
    runlog.write(str(m) + "\n")
    runlog.flush()


def adb_quick(args, timeout=12):
    r = subprocess.run(
        [camp.ADB, "-s", camp.SER, *args], capture_output=True, timeout=timeout)
    out = (r.stdout or b"").decode("utf-8", "replace") + (r.stderr or b"").decode("utf-8", "replace")
    return r.returncode, out


def read_zones():
    rc, out = adb_quick(["shell", "su", "-c", "sh /data/local/tmp/fw19_zones.sh"])
    zones = {}
    if rc != 0 and "zone0" not in out:
        raise RuntimeError("thermal zones failed: " + out[-200:])
    for ln in out.splitlines():
        parts = ln.split()
        if len(parts) != 3 or not parts[0].startswith("zone"):
            continue
        try:
            zones[parts[1]] = int(parts[2])
        except ValueError:
            continue
    if "mtktsbattery" not in zones or "mtktspa" not in zones:
        raise RuntimeError("thermal zones missing battery or PA: " + out[-200:])
    return zones


def read_bat():
    rc, out = adb_quick(["shell", "dumpsys", "battery"])
    m = re.search(r"temperature:\s*(\d+)", out)
    if not m:
        raise RuntimeError("no battery temperature: " + out[-200:])
    return int(m.group(1))


def snap(phase, mark):
    rec = {
        "t": time.time(),
        "iso": time.strftime("%H:%M:%S"),
        "phase": phase,
        "mark": mark,
        "bat": read_bat(),
        "zones": read_zones(),
    }
    with JSONL.open("a", encoding="utf-8") as f:
        f.write(json.dumps(rec) + "\n")
    pa = rec["zones"].get("mtktspa")
    note("%s %s bat %.1f pa %.1f" % (
        phase, mark, rec["bat"] / 10.0, (pa or 0) / 1000.0))
    return rec


def live(name, temp):
    if name in EXCLUDED:
        return False
    # mtktspa alternates with a 25.0 C reading while the radio is unkeyed.
    if name == "mtktspa" and temp == 25000:
        return False
    return 0 < temp < 120000


def hot(history):
    cur = history[-1]
    if cur["bat"] > 450:
        return "battery %.1f C" % (cur["bat"] / 10.0)
    hits = []
    for prev in history[:-1]:
        dt = cur["t"] - prev["t"]
        if dt < 4:
            continue
        if dt > 10.5:
            continue
        for name, te in cur["zones"].items():
            old = prev["zones"].get(name)
            if old is None or not live(name, te) or not live(name, old):
                continue
            delta = te - old
            # "more than 1 C in 10 s": a 1.0 C step inside the window stays.
            if delta > 1000:
                hits.append("%s +%.2f C in %.1f s" % (name, delta / 1000.0, dt))
    return "; ".join(hits[:6]) if hits else None


def unkey():
    rc, out = camp.broadcast(["--es", "cmd", "cmdbyte", "--ei", "b", "38", "--ei", "d", "2"])
    note("unkey rc=%s %s" % (rc, out.strip().replace("\n", " ")[:80]))


def key_carrier():
    camp.adb("shell", "logcat", "-c")
    rc, out = camp.broadcast(["--es", "cmd", "cmdbyte", "--ei", "b", "64", "--ei", "d", "3"])
    note("ring reset rc=%s" % rc)
    time.sleep(0.4)
    rc, out = camp.broadcast(["--es", "cmd", "cmdbyte", "--ei", "b", "38", "--ei", "d", "1"])
    note("key rc=%s %s" % (rc, out.strip().replace("\n", " ")[:60]))


def confirm_fw19():
    camp.adb("shell", "logcat", "-c")
    camp.broadcast(["--es", "cmd", "cmdbyte", "--ei", "b", "52", "--ei", "d", "1"])
    time.sleep(1.2)
    ver = camp.read_version(False)
    camp.expect_version(ver, TAG)
    note("0x34 " + ver.strip().replace("\n", " ")[-80:])


def power_byte(text):
    hits = re.findall(r"TX cmd=0x23.*?\[([0-9A-Fa-f ]+)\]", text)
    if not hits:
        return None
    body = [int(x, 16) for x in hits[-1].split()]
    return body[9] if len(body) > 9 else None


def tune_power(power):
    camp.adb("shell", "logcat", "-c")
    camp.broadcast([
        "--es", "cmd", "vfo", "--ei", "hz", "467625000", "--ei", "power", str(power)])
    t0 = time.time()
    seen, raw = None, ""
    while time.time() - t0 < 8:
        raw = camp.logcat_since(20)
        if "stopped answering" in raw or "does not answer" in raw:
            raise RuntimeError("module stopped answering after tune")
        hits = [ln for ln in raw.splitlines() if "VFO" in ln and "467.625" in ln]
        if hits:
            seen = hits[-1].strip()
            break
        time.sleep(0.4)
    remain = 4.0 - (time.time() - t0)
    if remain > 0:
        time.sleep(remain)
    if not seen:
        raise RuntimeError("VFO 467.625 was not confirmed; not keying")
    pb = power_byte(raw)
    note("tuned power %d byte %s" % (power, pb))
    if power == 1 and pb != 1:
        raise RuntimeError("high power not confirmed in the 0x23 body (%s)" % pb)
    if power == 0 and pb not in (0, None):
        raise RuntimeError("low power not confirmed in the 0x23 body (%s)" % pb)
    return pb


def iq_peak(path, info):
    iq = np.memmap(path, dtype=np.int8, mode="r")
    a = (int(info["i0"]) * camp.DEC + int(0.4 * camp.FS_IQ)) * 2
    n = int(max(0.2, info["keyed_s"] - 0.8) * camp.FS_IQ)
    b = min(len(iq), a + n * 2)
    if b - a < 1000:
        return None
    return int(np.max(np.abs(iq[a:b])))


def rf_stats(dev, info):
    rows = fw19_run.slices(dev, int(info["i0"]), info["keyed_s"] + 0.25)
    keyed_ms = info["keyed_s"] * 1000
    body = [v for ms, v in rows if 500 <= ms <= keyed_ms - 400]
    over = [ms for ms, v in rows if 80 <= ms <= keyed_ms - 400 and v >= camp.STOP_HZ]
    return {
        "keyed_s": info["keyed_s"], "snr_db": info["snr_db"], "clip_frac": info["clip_frac"],
        "offset_hz": info["offset_hz"], "mean_mag": info["mean_mag"],
        "body_max": max(body) if body else None, "body_over_n": len(over),
        "body_over_ms": over[:8],
    }


def judge_capture(name, info_path):
    dev, info = camp.demod(str(info_path))
    stats = rf_stats(dev, info)
    stats["iq_peak"] = iq_peak(info_path, info)
    (HERE / ("fw19_heat_%s.json" % name)).write_text(json.dumps(stats, indent=2), encoding="utf-8")
    note("%s keyed %.2f s snr %.1f clip %.6f peak %s body_max %s over %d" % (
        name, stats["keyed_s"], stats["snr_db"], stats["clip_frac"], stats["iq_peak"],
        None if stats["body_max"] is None else round(stats["body_max"], 1), stats["body_over_n"]))
    return stats


def sample_after(phase, t_unkey, proc, until_s):
    nxt = 0
    while True:
        now = time.time() - t_unkey
        if now >= nxt and nxt <= until_s:
            try:
                snap(phase, "after")
            except Exception as exc:
                note("after sample failed " + repr(exc))
            nxt += 15
        if proc is not None and proc.poll() is not None:
            proc = None
        if now >= until_s and proc is None:
            break
        if now > until_s + 40 and proc is not None:
            camp.kill_hackrf()
            proc = None
        time.sleep(0.4)


def watch_key(phase, seconds, history):
    """Sample every 5 s until seconds. Return a stop reason, or None."""
    t0 = time.time()
    nxt = 5
    while True:
        elapsed = time.time() - t0
        if elapsed >= seconds:
            return None
        if elapsed >= nxt:
            rec = snap(phase, "during")
            history.append(rec)
            why = hot(history)
            if why:
                return why
            nxt += 5
        time.sleep(0.2)


def run_capture(name, seconds, lna, vga):
    if camp.hackrf_running():
        raise RuntimeError("hackrf already running")
    proc, hlog, path = fw19_run.capture(name, seconds, lna, vga)
    PROC["p"], PROC["h"] = proc, hlog
    return proc, hlog, path


def finish_proc():
    proc, hlog = PROC["p"], PROC["h"]
    PROC["p"] = PROC["h"] = None
    if proc is not None and proc.poll() is None:
        try:
            proc.wait(timeout=20)
        except Exception:
            camp.kill_hackrf()
            proc.wait(timeout=15)
    if hlog is not None:
        hlog.close()
    if camp.hackrf_running():
        camp.kill_hackrf()


def carrier(phase, seconds, lna, vga):
    before = snap(phase, "before")
    history = [before]
    proc, hlog, path = run_capture("fw19_" + phase, seconds + 8, lna, vga)
    time.sleep(0.6)
    why = None
    try:
        key_carrier()
        why = watch_key(phase, seconds, history)
        if why is None:
            history.append(snap(phase, "during"))
            why = hot(history)
    except Exception as exc:
        why = "sample failed " + repr(exc)
    finally:
        try:
            unkey()
        except Exception as exc:
            note("unkey failed " + repr(exc))
    t_unkey = time.time()
    if why:
        note("HEAT STOP %s %s" % (phase, why))
    try:
        sample_after(phase, t_unkey, proc, 180)
    finally:
        finish_proc()
    stats = judge_capture(phase, path)
    if (stats["iq_peak"] or 0) >= 120 or stats["clip_frac"] >= 0.01:
        note("HEAT STOP %s clip peak %s" % (phase, stats["iq_peak"]))
        return "clip"
    if stats["body_over_n"]:
        note("HEAT STOP %s deviation body" % phase)
        r3a3_silence.restore_factory()
        RESTORED["yes"] = True
        return "deviation"
    if why:
        return "heat"
    if stats["keyed_s"] < seconds - 6:
        note("HEAT STOP %s short carrier %.2f s" % (phase, stats["keyed_s"]))
        return "short"
    return "ok"


def stream45(lna, vga):
    phase = "low45"
    before = snap(phase, "before")
    history = [before]
    remote = fw19_run.install_sym(fw19_run.m17_rrc.pack_symbols(fw19_run.symbols(fw19_run.NFRAMES)))
    camp.adb("shell", "logcat", "-c")
    proc, hlog, path = run_capture("fw19_low45", 56, lna, vga)
    time.sleep(0.6)
    rc, out = camp.broadcast(["--es", "cmd", "cmdsym", "--es", "path", remote, "--ez", "eot", "true"])
    note("cmdsym eot rc=%s" % rc)
    why = None
    try:
        why = watch_key(phase, 48, history)
    except Exception as exc:
        why = "sample failed " + repr(exc)
    finally:
        if why:
            try:
                unkey()
            except Exception as exc:
                note("unkey failed " + repr(exc))
    t_unkey = time.time()
    if why:
        note("HEAT STOP %s %s" % (phase, why))
    try:
        sample_after(phase, t_unkey, proc, 180)
    finally:
        finish_proc()
    text = fw19_run.log_text()
    (HERE / "fw19_low45.log").write_text(text, encoding="utf-8", errors="replace")
    dev, info = camp.demod(str(path))
    stats = rf_stats(dev, info)
    stats["iq_peak"] = iq_peak(path, info)
    stats["status4"] = bool(re.search(r"cmd=0x36[^\n]*\[04\]", text))
    stats["op7"] = "sym last op 7" in text
    (HERE / "fw19_heat_low45.json").write_text(json.dumps(stats, indent=2), encoding="utf-8")
    note("low45 keyed %.2f s snr %.1f clip %.6f peak %s body_max %s over %d op7 %s status4 %s" % (
        stats["keyed_s"], stats["snr_db"], stats["clip_frac"], stats["iq_peak"],
        None if stats["body_max"] is None else round(stats["body_max"], 1),
        stats["body_over_n"], stats["op7"], stats["status4"]))
    if stats["clip_frac"] >= 1e-4 or (stats["iq_peak"] or 0) >= 120:
        note("HEAT STOP low45 clip peak %s" % stats["iq_peak"])
        return "clip"
    if stats["body_over_n"]:
        note("HEAT STOP low45 deviation body")
        r3a3_silence.restore_factory()
        RESTORED["yes"] = True
        return "deviation"
    if why:
        return "heat"
    return "ok"


def phase_before(phase):
    bat, pa = None, None
    for ln in JSONL.read_text(encoding="utf-8").splitlines():
        if not ln.strip():
            continue
        rec = json.loads(ln)
        if rec["phase"] == phase and rec["mark"] == "before":
            bat = rec["bat"]
            p = rec["zones"].get("mtktspa")
            if p and p != 25000:
                pa = p
    return bat, pa


def cool_to(target_bat, target_pa, phase, limit_s):
    t0 = time.time()
    while time.time() - t0 < limit_s:
        rec = snap(phase, "cool")
        pa = rec["zones"].get("mtktspa")
        if target_pa not in (None, 25000) and pa == 25000:
            time.sleep(15)
            continue
        bat_ok = abs(rec["bat"] - target_bat) <= 2
        if target_pa in (None, 25000):
            pa_ok = True
        else:
            pa_ok = pa is not None and abs(pa - target_pa) <= 1000
        if bat_ok and pa_ok:
            note("%s cooled" % phase)
            return True
        time.sleep(15)
    note("%s not back to the baseline in %d s" % (phase, limit_s))
    return False


def quiet():
    samples = [snap("quiet", "a")]
    for mark in ("b", "c"):
        time.sleep(10)
        samples.append(snap("quiet", mark))
    names = set()
    for s in samples:
        names.update(s["zones"])
    for name in names:
        good = []
        for s in samples:
            te = s["zones"].get(name)
            if te is None or te <= 0 or te >= 120000:
                continue
            if name == "mtktspa" and te == 25000:
                continue
            good.append(te)
        if len(good) < 2:
            EXCLUDED.add(name)
            note("exclude %s no stable idle reading" % name)
            continue
        if max(good) - min(good) > 1000:
            EXCLUDED.add(name)
            note("exclude %s idle swing %.2f C" % (name, (max(good) - min(good)) / 1000.0))
    note("excluded " + ",".join(sorted(EXCLUDED)))
    return samples[-1]


def probe(lna, vga):
    phase = "hiprobe"
    snap(phase, "before")
    proc, hlog, path = run_capture("fw19_hiprobe", 8, lna, vga)
    time.sleep(0.5)
    try:
        key_carrier()
        time.sleep(2.0)
    finally:
        try:
            unkey()
        except Exception as exc:
            note("unkey failed " + repr(exc))
    t_unkey = time.time()
    try:
        sample_after(phase, t_unkey, proc, 15)
    finally:
        finish_proc()
    stats = judge_capture(phase, path)
    if stats["body_over_n"]:
        note("HEAT STOP hiprobe deviation body")
        r3a3_silence.restore_factory()
        RESTORED["yes"] = True
        return "deviation", stats
    peak = stats["iq_peak"] or 0
    if peak >= 120 or stats["clip_frac"] >= 0.01:
        note("HEAT STOP hiprobe clip peak %s frac %.6f" % (peak, stats["clip_frac"]))
        return "clip", stats
    if peak < 8 or stats["snr_db"] < 20:
        note("hiprobe weak peak %s snr %.1f" % (peak, stats["snr_db"]))
        return "weak", stats
    return "ok", stats


def safe_idle():
    try:
        unkey()
    except Exception as exc:
        note("idle unkey failed " + repr(exc))
    if camp.hackrf_running():
        camp.kill_hackrf()
    finish_proc()
    if not RESTORED["yes"]:
        try:
            tune_power(0)
        except Exception as exc:
            note("idle tune failed " + repr(exc))


def run():
    (HERE / "fw19_heat.pid").write_text(str(os.getpid()), encoding="utf-8")
    JSONL.write_text("", encoding="utf-8")
    r3a3_run.devices_ok()
    if camp.hackrf_running():
        raise RuntimeError("hackrf already running")
    camp.adb("shell", "input", "keyevent", "224")
    camp.adb("shell", "am", "start", "-n", "com.macdmr.radio/.MainActivity")
    time.sleep(2)
    confirm_fw19()
    tune_power(0)
    base = quiet()
    status = carrier("low30", 30, 16, 16)
    if status != "ok":
        return "stopped"
    cool_to(base["bat"], base["zones"].get("mtktspa"), "low30cool", 360)
    status = stream45(16, 16)
    if status != "ok":
        return "stopped"
    if not cool_to(base["bat"], base["zones"].get("mtktspa"), "prehigh", 360):
        note("HEAT STOP not cooled before high power")
        return "stopped"
    tune_power(1)
    gain = (0, 0)
    kind, _stats = probe(*gain)
    if kind == "deviation":
        return "stopped"
    if kind == "clip":
        note("HEAT STOP high power clips at LNA 0 VGA 0")
        return "stopped"
    if kind == "weak":
        gain = (8, 0)
        kind, _stats = probe(*gain)
        if kind != "ok":
            note("HEAT STOP high power gain %s result %s" % (gain, kind))
            return "stopped"
    note("high gain lna %d vga %d" % gain)
    if not cool_to(base["bat"], base["zones"].get("mtktspa"), "prehigh30", 180):
        note("HEAT STOP not cooled before the high 30 s key")
        return "stopped"
    status = carrier("hi30", 30, *gain)
    if status != "ok":
        return "stopped"
    target_bat, target_pa = phase_before("hi30")
    if not cool_to(target_bat, target_pa, "hi30cool", 720):
        note("HEAT STOP not cooled before the high 45 s key")
        return "stopped"
    status = carrier("hi45", 45, *gain)
    if status != "ok":
        return "stopped"
    if not cool_to(target_bat, target_pa, "hi45cool", 720):
        note("HEAT STOP not cooled before the high 120 s key")
        return "stopped"
    status = carrier("hi120", 120, *gain)
    if status != "ok":
        return "stopped"
    return "done"


def run_high():
    (HERE / "fw19_heat.pid").write_text(str(os.getpid()), encoding="utf-8")
    JSONL.write_text("", encoding="utf-8")
    r3a3_run.devices_ok()
    if camp.hackrf_running():
        raise RuntimeError("hackrf already running")
    camp.adb("shell", "input", "keyevent", "224")
    camp.adb("shell", "am", "start", "-n", "com.macdmr.radio/.MainActivity")
    time.sleep(2)
    confirm_fw19()
    tune_power(0)
    quiet()
    tune_power(1)
    gain = (0, 0)
    kind, _stats = probe(*gain)
    if kind == "deviation":
        return "stopped"
    if kind == "clip":
        note("HEAT STOP high power clips at LNA 0 VGA 0")
        return "stopped"
    if kind == "weak":
        gain = (8, 0)
        kind, _stats = probe(*gain)
        if kind != "ok":
            note("HEAT STOP high power gain %s result %s" % (gain, kind))
            return "stopped"
    note("high gain lna %d vga %d" % gain)
    status = carrier("hi30", 30, *gain)
    if status != "ok":
        return "stopped"
    target_bat, target_pa = phase_before("hi30")
    if not cool_to(target_bat, target_pa, "hi30cool", 720):
        note("HEAT STOP not cooled before the high 45 s key")
        return "stopped"
    status = carrier("hi45", 45, *gain)
    if status != "ok":
        return "stopped"
    if not cool_to(target_bat, target_pa, "hi45cool", 720):
        note("HEAT STOP not cooled before the high 120 s key")
        return "stopped"
    status = carrier("hi120", 120, *gain)
    if status != "ok":
        return "stopped"
    return "done"


def main():
    try:
        ended = run_high() if "--high-only" in sys.argv else run()
        if ended == "done":
            note("HEAT DONE")
        else:
            note("HEAT STOP series ended")
    except Exception as exc:
        note("HEAT FAIL " + repr(exc))
        raise
    finally:
        try:
            safe_idle()
        except Exception as exc:
            note("idle failed " + repr(exc))
        runlog.close()


if __name__ == "__main__":
    main()
