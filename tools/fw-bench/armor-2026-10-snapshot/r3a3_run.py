# R3a3 bench. Phone TX only on 467.625 MHz, low power. HackRF receive only.
# Tune before the load. One 3 s key. Restore the factory image and leave the
# VFO on 467.625. Does not call vfo_off.
import json, subprocess, sys, time
from pathlib import Path

import numpy as np

sys.path.insert(0, r"C:\Users\Joshua\AppData\Local\Temp\fw1718")
import camp
import factory_boot
import r3_capture

IMAGE = camp.BUILD / "DMR003.R3a3.V022.bin"
TAG = "DMR003.R3a3.V022"
FACTORY = "DMR003.UV4T.V022"
LNA, VGA = 24, 38
BOOT_S = 260.0
KEY_S = 8.0
TONE_MS = 3000
HERE = camp.HERE
CAP = camp.CAP


def devices_ok():
    r = subprocess.run([camp.ADB, "devices"], capture_output=True, text=True)
    if camp.SER + "\tdevice" not in r.stdout:
        raise SystemExit("Wi-Fi phone not ready:\n" + r.stdout)
    if "5006AF1020002922\tdevice" in r.stdout:
        camp.say("USB serial is also listed; commands go to " + camp.SER)


def hackrf_recv(path, seconds):
    if path.exists():
        path.unlink()
    n = int(camp.FS_IQ * seconds)
    hlog_path = Path(str(path) + ".hackrf.log")
    hlog = open(hlog_path, "w", encoding="utf-8")
    proc = subprocess.Popen(
        [camp.HACKRF, "-r", str(path), "-f", "467385000", "-s", "2400000",
         "-l", str(LNA), "-g", str(VGA), "-n", str(n)],
        stdout=hlog, stderr=subprocess.STDOUT)
    t0 = time.time()
    while time.time() - t0 < 4:
        if proc.poll() is not None:
            hlog.close()
            raise RuntimeError("hackrf exited early: " + hlog_path.read_text(encoding="utf-8", errors="replace")[-400:])
        if camp.hackrf_running():
            return proc, hlog, n
        time.sleep(0.05)
    proc.kill()
    hlog.close()
    raise RuntimeError("hackrf did not start")


def stop_hackrf(proc, hlog):
    if proc.poll() is None:
        camp.kill_hackrf()
        try:
            proc.wait(timeout=15)
        except subprocess.TimeoutExpired:
            proc.kill()
    hlog.close()
    if camp.hackrf_running():
        camp.kill_hackrf()


def log_now():
    _, out = camp.adb("shell", "date +%m-%dT%H:%M:%S")
    return out.strip().splitlines()[-1]


def version_lines():
    _, out = camp.adb("shell", "logcat", "-d", "-t", "250", "-s", "RadioService:I", "YModemManager:I", "DiagReceiver:I")
    return out


def confirm_factory():
    ver = camp.read_version(power_cycle=False)
    camp.expect_version(ver, FACTORY)
    rc, out = camp.adb("shell", "ls", "/sdcard/DMR/DMRDEBUG.bin")
    camp.say("DMRDEBUG check rc=%s %s" % (rc, out.strip().replace("\n", " ")[:160]))
    if "DMRDEBUG.bin" in out and "No such" not in out:
        raise RuntimeError("DMRDEBUG.bin still present: " + out.strip())
    camp.tune()
    return ver


def analyze_key(path):
    dev, info = r3_capture.wide_demod(path)
    shape = r3_capture.square_shape(dev, info)
    fs = r3_capture.FS
    i0, i1 = int(info["i0"]), int(info["i1"])
    a = i0 + int(0.4 * fs)
    b = i1 - int(0.3 * fs)
    out = {"carrier": info, "square": shape}
    if b - a < int(0.5 * fs):
        out["steady"] = None
        return out
    seg = dev[a:b] - np.median(dev[a:b])
    w = np.hanning(len(seg))
    sp = np.abs(np.fft.rfft(seg * w))
    sp = 2 * sp / np.sum(w)
    freqs = np.fft.rfftfreq(len(seg), 1 / fs)
    sp[0] = 0
    peaks = []
    last = -100.0
    for k in np.argsort(sp)[::-1]:
        f = float(freqs[k])
        if f < 5 or f > 4000:
            continue
        if abs(f - last) < 8:
            continue
        peaks.append({"hz": round(f, 2), "amp_hz": round(float(sp[k]), 2)})
        last = f
        if len(peaks) >= 8:
            break
    # 0.5 s slices across the carrier, so a square that the task then
    # overwrites is not averaged away.
    slices = []
    t = i0
    while t + int(0.5 * fs) <= i1:
        sl = dev[t:t + int(0.5 * fs)]
        sl = sl - np.median(sl)
        slices.append({
            "t_s": round((t - i0) / fs, 2),
            "rms_hz": round(float(np.sqrt(np.mean(sl ** 2))), 2),
            "p99_hz": round(float(np.percentile(np.abs(sl), 99)), 2),
            "f15_hz": round(r3_capture.goertzel(sl, fs, r3_capture.SQ_HZ), 2),
            "f1k_hz": round(r3_capture.goertzel(sl, fs, 1000.0), 2),
        })
        t += int(0.5 * fs)
    p99 = float(np.percentile(np.abs(seg), 99))
    slice_p99 = max((s["p99_hz"] for s in slices), default=0.0)
    worst = max(p99, slice_p99)
    out["steady"] = {
        "span_s": round((b - a) / fs, 3),
        "rms_hz": round(float(np.sqrt(np.mean(seg ** 2))), 2),
        "p99_hz": round(p99, 2),
        "slice_p99_hz": round(slice_p99, 2),
        "f15_hz": round(r3_capture.goertzel(seg, fs, r3_capture.SQ_HZ), 2),
        "f1k_hz": round(r3_capture.goertzel(seg, fs, 1000.0), 2),
        "peaks": peaks,
        "slices": slices,
        "STOP": worst >= camp.STOP_HZ,
    }
    return out


def restore_factory():
    camp.say("restoring factory image")
    ver = camp.load_image(camp.FACTORY)
    camp.expect_version(ver, FACTORY)
    return confirm_factory()


def main():
    if not IMAGE.exists() or IMAGE.stat().st_size != 378620:
        raise SystemExit("R3a3 image missing or wrong size")
    if camp.hackrf_running():
        raise SystemExit("hackrf already running")
    devices_ok()
    camp.adb("shell", "input", "keyevent", "224")
    time.sleep(0.4)
    camp.say("device " + log_now())
    started_load = False
    try:
        camp.tune()
        iq = CAP / "r3a3_boot.iq"
        boot_proc, boot_hlog, _ = hackrf_recv(iq, BOOT_S)
        try:
            camp.say("hackrf recording boot, loader starting")
            started_load = True
            loaded = camp.load_image(IMAGE)
            camp.say("loader returned %s" % loaded)
            text = version_lines()
            (HERE / "r3a3_load.logcat.txt").write_text(text, encoding="utf-8")
            camp.say("post-load log tail: " + " | ".join(
                ln.strip()[-140:] for ln in text.splitlines()
                if "module " in ln or "booted" in ln or "onSuccess" in ln)[-8:])
        finally:
            stop_hackrf(boot_proc, boot_hlog)
        if loaded != TAG:
            raise RuntimeError("version %s is not %s" % (loaded, TAG))
        info = factory_boot.analyze(1.5, CAP / "r3a3_boot.iq")
        (HERE / "r3a3_boot.json").write_text(json.dumps(info, indent=2), encoding="utf-8")
        camp.say("boot peak_db %.2f above_10db_s %.2f clip %.6f" % (
            info["peak_db"], info["above_10db_s"], info["clip_frac"]))
        if info["peak_db"] >= 6.0 or info["above_10db_s"] >= 0.2:
            raise RuntimeError("boot radiated; not keying")
        # Takeover programs channel 36. Tune back before the key.
        camp.tune()
        iq = CAP / "r3a3.iq"
        proc, hlog, _ = hackrf_recv(iq, KEY_S)
        try:
            time.sleep(0.6)
            rc, bout = camp.broadcast(["--es", "cmd", "testtone", "--ei", "ms", str(TONE_MS)])
            camp.say("testtone rc=%d %s" % (rc, bout.strip().replace("\n", " ")[:180]))
            proc.wait(timeout=KEY_S + 20)
        finally:
            stop_hackrf(proc, hlog)
        text = version_lines()
        (HERE / "r3a3_key.logcat.txt").write_text(text, encoding="utf-8")
        hits = [ln.strip() for ln in text.splitlines()
                if "test tone" in ln or "testtone" in ln or "TX " in ln
                or "does not answer" in ln or "stopped answering" in ln]
        camp.say("tx log: " + " | ".join(h[-160:] for h in hits[-6:]))
        if any("does not answer" in h or "stopped answering" in h for h in hits):
            raise RuntimeError("module stopped answering during the key")
        result = analyze_key(iq)
        (HERE / "r3a3.json").write_text(json.dumps(result, indent=2), encoding="utf-8")
        st = result.get("steady") or {}
        camp.say("key class %s keyed %.2f s snr %.1f clip %.4f offset %+.0f p99 %s f15 %s f1k %s STOP %s" % (
            result["square"].get("class"), result["carrier"].get("keyed_s", 0),
            result["carrier"].get("snr_db", 0), result["carrier"].get("clip_frac", 0),
            result["carrier"].get("offset_hz", 0),
            st.get("p99_hz"), st.get("f15_hz"), st.get("f1k_hz"), st.get("STOP")))
        camp.say("peaks " + json.dumps(st.get("peaks")))
        camp.say("slices " + json.dumps(st.get("slices")))
    finally:
        if camp.hackrf_running():
            camp.kill_hackrf()
        if started_load:
            try:
                restore_factory()
                camp.say("R3a3 run finished, factory image, VFO 467.625")
            except Exception as exc:
                camp.say("FACTORY RESTORE FAILED: %s" % exc)
                raise


if __name__ == "__main__":
    try:
        main()
    except Exception:
        if camp.hackrf_running():
            camp.kill_hackrf()
        raise
