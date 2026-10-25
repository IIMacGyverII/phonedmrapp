# R-C step 2. Op 5 returns one FM receive half. The phone is not keyed.
# HackRF transmits the tones. HackRF receive is only the boot and the quiet checks.
import hashlib
import json
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
import r4p0_run as rx

IMAGE = camp.BUILD / "DMR003.RC20.V022.bin"
TAG = "DMR003.RC20.V022"
EXPECT = "ad941d8a46b64aabbb57ee441698a85991559b1770ed7ee939e595890c7c40ef"
HERE = Path(r"C:\Users\Joshua\AppData\Local\Temp\fw1718")
DIR = HERE / "rc20"
DIR.mkdir(exist_ok=True)
FS_TX = 2_000_000
DEV = 2500.0
GAINS = (0, 6, 12, 20)
OUT = DIR / "result.json"


def be_samples(raw):
    out = np.empty(len(raw) // 2, np.float64)
    for i in range(out.size):
        v = (raw[2 * i] << 8) | raw[2 * i + 1]
        if v >= 32768:
            v -= 65536
        out[i] = v
    return out


def judge(raw, target_hz):
    x = be_samples(raw)
    info = {
        "n": int(x.size),
        "rms": float(np.sqrt(np.mean(x * x))) if x.size else 0.0,
        "peak_abs": float(np.max(np.abs(x))) if x.size else 0.0,
        "clip": float(np.mean(np.abs(x) >= 30000)) if x.size else 0.0,
        "head": [int(v) for v in x[:8]],
        "standout": False,
    }
    if x.size < 32:
        info["why"] = "short"
        return info
    x = x - np.mean(x)
    w = np.hanning(x.size)
    amp = 2 * np.abs(np.fft.rfft(x * w)) / np.sum(w)
    freqs = np.fft.rfftfreq(x.size, 1 / 8000.0)
    use = freqs >= 20.0
    med = float(np.median(amp[use])) + 1e-12
    k = int(np.argmax(np.where(use, amp, 0.0)))
    i = int(np.argmin(np.abs(freqs - target_hz)))
    info.update({
        "peak_hz": float(freqs[k]),
        "peak_db": float(20 * np.log10((amp[k] + 1e-12) / med)),
        "target_hz": float(freqs[i]),
        "target_db": float(20 * np.log10((amp[i] + 1e-12) / med)),
        "bin_hz": 8000.0 / x.size,
    })
    info["standout"] = info["target_db"] >= 12.0 and abs(info["peak_hz"] - target_hz) <= 50.0
    return info


def save(doc):
    OUT.write_text(json.dumps(doc, indent=2), encoding="utf-8")


def clear_cache():
    cmd = "rm -f /data/data/com.macdmr.radio/cache/rxram.bin /data/local/tmp/rxram.bin"
    rc, out = camp.adb("shell", "su --mount-master --context u:r:magisk:s0 -c '%s'" % cmd, timeout=30)
    if rc != 0:
        raise RuntimeError("clear " + out)


def pull_rx(name):
    cmd = (
        "cp /data/data/com.macdmr.radio/cache/rxram.bin /data/local/tmp/rxram.bin && "
        "chmod 644 /data/local/tmp/rxram.bin"
    )
    rc, out = camp.adb("shell", "su --mount-master --context u:r:magisk:s0 -c '%s'" % cmd, timeout=30)
    if rc != 0:
        camp.say("no rxram file: " + out.strip().replace("\n", " ")[:180])
        return b""
    dest = DIR / name
    rc, out = camp.adb("pull", "/data/local/tmp/rxram.bin", str(dest), timeout=60)
    if rc != 0:
        raise RuntimeError("pull " + out)
    return dest.read_bytes()


def wait_log(timeout=6.0):
    text = ""
    t0 = time.time()
    while time.time() - t0 < timeout:
        text = camp.adb("shell", "logcat", "-d", "-s", "RadioService:I", timeout=20)[1]
        if "rxram " in text:
            return text
        time.sleep(0.25)
    return text


def ask_rx(mode):
    clear_cache()
    camp.adb("shell", "logcat", "-c")
    rc, out = camp.broadcast(["--es", "cmd", "cmdsym", "--es", "op", "rxram", "--ei", "mode", str(mode)])
    camp.say("rxram mode %d rc=%d" % (mode, rc))
    text = wait_log()
    hit = ""
    for ln in text.splitlines():
        if "rxram " in ln:
            hit = ln.strip()
    camp.say(hit[-180:] if hit else "rxram log missing")
    (DIR / ("rxram_m%d.log" % mode)).write_text(text, encoding="utf-8", errors="replace")
    return hit, text


def rssi_dbm(line):
    import re
    m = re.search(r"\[([0-9A-Fa-f]{2})\]", line or "")
    if not m:
        return None
    raw = int(m.group(1), 16)
    if raw <= 0:
        return None
    dbm = -(120 - raw / 2.0)
    if dbm > -20:
        return None
    return dbm


def read_rssi():
    camp.adb("shell", "logcat", "-c")
    camp.broadcast(["--es", "cmd", "cmdbyte", "--ei", "b", "50", "--ei", "d", "1"])
    t0 = time.time()
    while time.time() - t0 < 3:
        text = camp.logcat_since(8)
        hits = [ln for ln in text.splitlines() if "cmd=0x32" in ln]
        if hits:
            line = hits[-1].strip()
            camp.say("rssi " + line[-140:])
            return line
        time.sleep(0.2)
    camp.say("rssi missing")
    return ""


def fm_bytes(seconds, tone=None, f0=None, f1=None):
    n = int(FS_TX * seconds)
    t = np.arange(n) / FS_TX
    if tone is not None:
        audio = np.sin(2 * np.pi * tone * t)
    else:
        f = f0 + (f1 - f0) * (t / max(seconds, 1e-6))
        audio = np.sin(2 * np.pi * np.cumsum(f) / FS_TX)
    phase = 2 * np.pi * DEV * np.cumsum(audio) / FS_TX
    z = np.exp(1j * phase)
    iq = np.empty(2 * n, np.int8)
    iq[0::2] = np.clip(np.round(z.real * 110), -127, 127).astype(np.int8)
    iq[1::2] = np.clip(np.round(z.imag * 110), -127, 127).astype(np.int8)
    return iq.tobytes(), n


def start_tx(path, nsamp, vga):
    if camp.hackrf_running():
        raise RuntimeError("hackrf already running")
    hlog = open(str(path) + ".log", "w", encoding="utf-8")
    proc = subprocess.Popen(
        [camp.HACKRF, "-t", str(path), "-f", "467625000", "-s", str(FS_TX),
         "-a", "0", "-x", str(vga), "-n", str(nsamp)],
        stdout=hlog, stderr=subprocess.STDOUT)
    t0 = time.time()
    while time.time() - t0 < 3:
        if proc.poll() is not None:
            hlog.close()
            tail = Path(str(path) + ".log").read_text(encoding="utf-8", errors="replace")[-300:]
            raise RuntimeError("hackrf tx exited early " + tail)
        if camp.hackrf_running():
            return proc, hlog
        time.sleep(0.05)
    proc.kill()
    hlog.close()
    raise RuntimeError("hackrf tx did not start")


def finish_tx(proc, hlog, seconds):
    try:
        proc.wait(timeout=seconds + 20)
    except subprocess.TimeoutExpired:
        proc.kill()
        hlog.close()
        if camp.hackrf_running():
            camp.kill_hackrf()
        raise RuntimeError("hackrf tx stalled")
    hlog.close()
    if camp.hackrf_running():
        camp.kill_hackrf()
        raise RuntimeError("hackrf tx still running")


def dummy(vga):
    blob, n = fm_bytes(0.4, tone=1000.0)
    path = DIR / "dummy.cs8"
    path.write_bytes(blob)
    proc, hlog = start_tx(path, n, vga)
    finish_tx(proc, hlog, 0.4)
    camp.say("dummy vga %d done" % vga)
    time.sleep(0.3)


def radiated(info):
    return info["peak_db"] >= 10 or any(run["peak_db"] >= 10 for run in info["runs"])


def quiet(mode, name, seconds=8):
    if camp.hackrf_running():
        raise RuntimeError("hackrf running before quiet " + name)
    path = camp.CAP / name
    proc, hlog = rx.recv(path, seconds, 24, 38)
    time.sleep(1.2)
    hit, _text = ask_rx(mode)
    raw = pull_rx(name + ".bin")
    rx.finish_recv(proc, hlog, path, seconds)
    info = factory_boot.analyze(1.0, str(path))
    camp.say("quiet %s floor %.2f peak %.2f at %.1f s above10 %.2f" % (
        name, info["floor_db"], info["peak_db"], info["peak_t"], info["above_10db_s"]))
    return hit, raw, info


def one_tone(name, seconds, vga, mode, target_hz, tone=None, f0=None, f1=None, marks=None):
    dummy(vga)
    blob, n = fm_bytes(seconds, tone=tone, f0=f0, f1=f1)
    path = DIR / (name + ".cs8")
    path.write_bytes(blob)
    proc, hlog = start_tx(path, n, vga)
    t0 = time.time()
    rows = []
    try:
        time.sleep(0.4)
        if marks is None:
            rssi = read_rssi()
            hit, _text = ask_rx(mode)
            raw = pull_rx(name + ".bin")
            row = judge(raw, target_hz) if raw else {"n": 0, "standout": False, "why": "no file"}
            row["log"] = hit[-160:]
            row["rssi"] = rssi[-140:]
            row["t"] = round(time.time() - t0, 3)
            rows.append(row)
            camp.say("%s n=%s rms=%.0f peak_hz=%s target_db=%s standout=%s" % (
                name, row.get("n"), row.get("rms", 0), row.get("peak_hz"), row.get("target_db"), row.get("standout")))
        else:
            span = (f1 - f0) / seconds
            for mark in marks:
                delay = mark - (time.time() - t0)
                if delay > 0.05:
                    time.sleep(delay)
                if time.time() - t0 > seconds - 0.8:
                    camp.say("sweep mark %.1f skipped, tx ending" % mark)
                    break
                at = time.time() - t0
                hit, _text = ask_rx(mode)
                raw = pull_rx("%s_%.1f.bin" % (name, mark))
                expect = f0 + span * (at + 0.08)
                row = judge(raw, expect) if raw else {"n": 0, "standout": False, "why": "no file"}
                row["log"] = hit[-160:]
                row["t"] = round(at, 3)
                row["expect_hz"] = round(expect, 1)
                rows.append(row)
                camp.say("sweep t=%.2f expect %.0f peak %s db %s" % (
                    at, expect, row.get("peak_hz"), row.get("target_db")))
    finally:
        finish_tx(proc, hlog, seconds)
    return rows


def end_state(doc):
    try:
        camp.tune()
    except Exception as exc:
        camp.say("tune after the run failed: %s" % exc)
        doc["tune_after"] = str(exc)
    rc, dbg = camp.adb("shell", "ls", "/sdcard/DMR/DMRDEBUG.bin")
    camp.say("DMRDEBUG rc=%s %s" % (rc, dbg.strip().replace("\n", " ")[:120]))
    doc["dmrdebug"] = dbg.strip()
    save(doc)


def main():
    raw = IMAGE.read_bytes()
    digest = hashlib.sha256(raw).hexdigest()
    if digest != EXPECT or raw[0x38464:0x38474] != TAG.encode():
        raise SystemExit("image is not RC20")
    camp.say("image sha256 " + digest)
    r3a3_run.devices_ok()
    if camp.hackrf_running():
        raise SystemExit("hackrf running")
    camp.adb("shell", "input", "keyevent", "224")
    camp.adb("shell", "am", "start", "-n", "com.macdmr.radio/.MainActivity")
    time.sleep(4)
    camp.tune()
    doc = {"sha256": digest, "tag": TAG, "dev_hz": DEV, "fs_tx": FS_TX, "amp": 0}
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
    boot = camp.CAP / "rc20_boot.iq"
    proc, hlog = rx.recv(boot, 30, 24, 38)
    thr.join(180)
    rx.finish_recv(proc, hlog, boot, 30)
    if box.get("error"):
        r3a3_silence.restore_factory()
        raise box["error"]
    loaded = box.get("loaded", "")
    camp.say("loaded " + str(loaded))
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
    doc["boot"] = {"peak_db": info["peak_db"], "floor_db": info["floor_db"], "above_10db_s": info["above_10db_s"]}
    camp.say("boot floor %.2f peak %.2f above10 %.2f" % (info["floor_db"], info["peak_db"], info["above_10db_s"]))
    save(doc)
    if radiated(info):
        r3a3_silence.restore_factory()
        raise SystemExit("boot radiated")
    camp.tune()
    hit, body, qinfo = quiet(0, "rc20_quiet0.iq")
    doc["quiet0"] = {
        "log": hit[-180:], "n": len(body),
        "peak_db": qinfo["peak_db"], "peak_t": qinfo["peak_t"], "above_10db_s": qinfo["above_10db_s"],
    }
    if body:
        doc["quiet0"]["samples"] = judge(body, 1000.0)
    save(doc)
    if radiated(qinfo):
        camp.say("STOP op 5 mode 0 radiated peak %.1f dB; no HackRF transmit" % qinfo["peak_db"])
        end_state(doc)
        return
    found = None
    for vga in GAINS:
        rows = one_tone("m0_g%d" % vga, 5.0, vga, 0, 1000.0, tone=1000.0)
        doc.setdefault("tones", []).append({"name": "m0_g%d" % vga, "vga": vga, "mode": 0, "rows": rows})
        save(doc)
        row = rows[0] if rows else {}
        if row.get("standout"):
            found = (0, vga, row)
            break
        heard = rssi_dbm(row.get("rssi", ""))
        if row.get("n") == 256 and heard is not None and heard > -90 and row.get("target_db", 0) < 6:
            camp.say("mode 0 hears %.0f dBm and has no 1 kHz line at vga %d" % (heard, vga))
            break
        if "sr=1" in row.get("log", "") or row.get("n", 0) == 0:
            camp.say("mode 0 returned no half at vga %d" % vga)
            break
    if found is None:
        hit, body, qinfo = quiet(1, "rc20_quiet1.iq", 6)
        doc["quiet1"] = {
            "log": hit[-180:], "n": len(body),
            "peak_db": qinfo["peak_db"], "peak_t": qinfo["peak_t"], "above_10db_s": qinfo["above_10db_s"],
        }
        save(doc)
        if radiated(qinfo):
            camp.say("STOP op 5 mode 1 radiated peak %.1f dB; no further HackRF transmit" % qinfo["peak_db"])
            end_state(doc)
            return
        vga = GAINS[min(2, len(doc.get("tones", [])))] if doc.get("tones") else 0
        # Use the last gain that was actually transmitted, else 0.
        if doc.get("tones"):
            vga = doc["tones"][-1]["vga"]
        rows = one_tone("m1_g%d" % vga, 5.0, vga, 1, 1000.0, tone=1000.0)
        doc.setdefault("tones", []).append({"name": "m1_g%d" % vga, "vga": vga, "mode": 1, "rows": rows})
        save(doc)
        if rows and rows[0].get("standout"):
            found = (1, vga, rows[0])
        elif rows and rows[0].get("n") == 256 and not rows[0].get("standout") and vga < GAINS[-1]:
            vga2 = GAINS[GAINS.index(vga) + 1] if vga in GAINS else GAINS[-1]
            rows = one_tone("m1_g%d" % vga2, 5.0, vga2, 1, 1000.0, tone=1000.0)
            doc["tones"].append({"name": "m1_g%d" % vga2, "vga": vga2, "mode": 1, "rows": rows})
            save(doc)
            if rows and rows[0].get("standout"):
                found = (1, vga2, rows[0])
    if found is None:
        camp.say("STOP neither mode showed a 1 kHz line")
        end_state(doc)
        camp.say("END RC20")
        return
    mode, vga, _row = found
    camp.say("1 kHz stands out on mode %d vga %d" % (mode, vga))
    low = one_tone("low_m%d_g%d" % (mode, vga), 4.0, vga, mode, 100.0, tone=100.0)
    doc["low"] = {"mode": mode, "vga": vga, "rows": low}
    save(doc)
    marks = [1.2, 3.5, 6.0, 8.5, 11.0, 13.0]
    sweep = one_tone("sweep_m%d_g%d" % (mode, vga), 16.0, vga, mode, 0.0, f0=40.0, f1=3200.0, marks=marks)
    doc["sweep"] = {"mode": mode, "vga": vga, "f0": 40, "f1": 3200, "rows": sweep}
    save(doc)
    end_state(doc)
    camp.say("END RC20")


if __name__ == "__main__":
    main()
