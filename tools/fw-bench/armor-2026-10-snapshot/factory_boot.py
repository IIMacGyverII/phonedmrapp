# Factory boot-radiation check. Receive only. No key, no --ei power 1.
# Tune the VFO to 467.625, record HackRF at that frequency, then DIAG restartmodule.
import json, subprocess, sys, time
from pathlib import Path

import numpy as np

sys.path.insert(0, r"C:\Users\Joshua\AppData\Local\Temp\fw1718")
import camp

FS, OFF, DEC = camp.FS_IQ, camp.OFF, camp.DEC
LNA, VGA = 24, 38
CAP_S = 24.0
LEAD_S = 1.5
N = int(CAP_S * FS)
IQ = camp.CAP / "factory_boot.iq"
HLOG = camp.CAP / "factory_boot.hackrf.log"
OUT = camp.HERE / "factory_boot.json"


def devices_ok():
    r = subprocess.run([camp.ADB, "devices"], capture_output=True, text=True)
    line = camp.SER + "\tdevice"
    if line not in r.stdout:
        raise SystemExit("USB phone not ready:\n" + r.stdout)


def main():
    if camp.hackrf_running():
        raise SystemExit("hackrf_transfer already running; not starting a second capture")
    devices_ok()
    camp.adb("shell", "input", "keyevent", "224")
    time.sleep(0.3)
    _, devdate = camp.adb("shell", "date +%m-%dT%H:%M:%S")
    camp.say("device " + devdate.strip().splitlines()[-1])
    camp.tune()
    if IQ.exists():
        IQ.unlink()
    t0 = time.time()
    hlog = open(HLOG, "w", encoding="utf-8")
    proc = subprocess.Popen(
        [camp.HACKRF, "-r", str(IQ), "-f", "467385000", "-s", str(FS),
         "-l", str(LNA), "-g", str(VGA), "-n", str(N)],
        stdout=hlog, stderr=subprocess.STDOUT)
    started = False
    while time.time() - t0 < 3:
        if proc.poll() is not None:
            hlog.close()
            tail = HLOG.read_text(encoding="utf-8", errors="replace")[-400:]
            raise SystemExit("hackrf exited early rc=%s %s" % (proc.returncode, tail))
        if camp.hackrf_running():
            started = True
            break
        time.sleep(0.05)
    if not started:
        proc.kill()
        hlog.close()
        raise SystemExit("hackrf did not start")
    wait = LEAD_S - (time.time() - t0)
    if wait > 0:
        time.sleep(wait)
    t_restart = time.time() - t0
    _, d_restart = camp.adb("shell", "date +%m-%dT%H:%M:%S")
    rc, bout = camp.broadcast(["--es", "cmd", "restartmodule"])
    camp.say("restartmodule at +%.3f s rc=%s %s" % (t_restart, rc, bout.strip().replace("\n", " ")[:180]))
    camp.say("device at restart " + d_restart.strip().splitlines()[-1])
    try:
        proc.wait(timeout=CAP_S + 20)
    except subprocess.TimeoutExpired:
        proc.kill()
        camp.kill_hackrf()
        raise SystemExit("hackrf stalled")
    hlog.close()
    if camp.hackrf_running():
        camp.kill_hackrf()
        raise SystemExit("hackrf still running after the capture")
    if not IQ.exists() or IQ.stat().st_size < N * 2 * 0.9:
        raise SystemExit("capture short: %s" % (IQ.stat().st_size if IQ.exists() else 0))
    tail = HLOG.read_text(encoding="utf-8", errors="replace")[-300:]
    camp.say("hackrf rc %s bytes %d" % (proc.returncode, IQ.stat().st_size))
    if proc.returncode not in (0, None):
        camp.say(tail)
    # device clock for the logcat window: a few seconds before the capture
    stamp = devdate.strip().splitlines()[-1]
    text = ""
    try:
        mmdd, hms = stamp.split("T", 1)
        log_since = "%s %s.000" % (mmdd, hms)
        _, text = camp.adb("shell", "logcat -d -T '%s' -s RadioService:I DiagReceiver:I" % log_since, timeout=30)
    except Exception as exc:
        text = "logcat failed: %s" % exc
        camp.say(text)
    (camp.HERE / "factory_boot.logcat.txt").write_text(text, encoding="utf-8")
    info = analyze(t_restart)
    info["hackrf_rc"] = proc.returncode
    info["hackrf_tail"] = tail.strip()
    info["restart_at_s"] = t_restart
    info["device_start"] = stamp
    info["device_restart"] = d_restart.strip().splitlines()[-1]
    info["logcat"] = [ln.strip() for ln in text.splitlines() if "RadioService" in ln or "DiagReceiver" in ln][-40:]
    OUT.write_text(json.dumps(info, indent=2), encoding="utf-8")
    camp.say("DONE floor_db %.1f peak_db %.1f above_10db_s %.2f clip %.6f runs %d" % (
        info["floor_db"], info["peak_db"], info["above_10db_s"], info["clip_frac"], len(info["runs"])))
    for run in info["runs"]:
        camp.say("  run %.2f–%.2f s  dur %.2f  peak %.1f dB  dev_rms %.0f Hz  p01/p99 %.0f/%.0f" % (
            run["t0"], run["t1"], run["dur"], run["peak_db"], run["dev_rms"], run["p01"], run["p99"]))


def analyze(t_restart, iq_path=None):
    iq = np.memmap(iq_path or IQ, dtype=np.int8, mode="r")
    n = (len(iq) // 2 // DEC) * DEC
    clip = float(np.mean(np.abs(iq[: n * 2]) >= 126))
    chunk = FS // 10  # 100 ms
    dphi = -2 * np.pi * OFF / FS
    phase = 0.0
    powers = []
    dev_chunks = []
    base = []
    for i in range(0, n, chunk):
        c = min(chunk, n - i)
        c = (c // DEC) * DEC
        if c < DEC:
            break
        raw = np.asarray(iq[2 * i: 2 * (i + c)])
        z = raw[0::2].astype(np.float32) + 1j * raw[1::2].astype(np.float32)
        ph = np.exp(1j * (phase + dphi * np.arange(c))).astype(np.complex64)
        phase += dphi * c
        m = z * ph
        powers.append(float(np.mean(z.real ** 2 + z.imag ** 2)))
        zd = m.reshape(-1, DEC).mean(axis=1)
        base.append(zd)
        if len(zd) > 8:
            d = np.angle(zd[1:] * np.conj(zd[:-1])) * (FS / DEC) / (2 * np.pi)
            dev_chunks.append(d.astype(np.float32))
        else:
            dev_chunks.append(np.zeros(1, np.float32))
    p = np.array(powers)
    # Noise floor: median of the pre-restart 100 ms bins. Fall back to the quietest fifth.
    n_lead = max(1, int(t_restart * 10))
    floor = float(np.median(p[:n_lead]))
    quiet = float(np.percentile(p, 20))
    use = floor if floor > 0 else quiet
    db = 10 * np.log10((p + 1e-12) / (use + 1e-12))
    on = db >= 10.0
    runs = []
    i = 0
    while i < len(on):
        if not on[i]:
            i += 1
            continue
        j = i
        while j < len(on) and on[j]:
            j += 1
        seg = np.concatenate(dev_chunks[i:j])
        seg = seg - np.median(seg)
        runs.append({
            "t0": i * 0.1,
            "t1": j * 0.1,
            "dur": (j - i) * 0.1,
            "peak_db": float(np.max(db[i:j])),
            "dev_rms": float(np.sqrt(np.mean(seg ** 2))),
            "p01": float(np.percentile(seg, 1)),
            "p99": float(np.percentile(seg, 99)),
        })
        i = j
    # Strongest half-second, for a carrier-vs-modulated note.
    k = int(np.argmax(p))
    a = max(0, k - 2)
    b = min(len(base), k + 3)
    blob = np.concatenate(base[a:b])
    spec = None
    if len(blob) > 256:
        w = np.hanning(len(blob))
        sp = np.abs(np.fft.fft(blob.astype(np.complex128) * w)) ** 2
        freqs = np.fft.fftfreq(len(blob), 1 / (FS / DEC))
        sp[0] = 0
        tot = float(sp.sum()) + 1e-12
        order = np.argsort(sp)[::-1]
        csum = np.cumsum(sp[order])
        k99 = int(np.searchsorted(csum, 0.99 * tot))
        band = freqs[order[: k99 + 1]]
        spec = {
            "t0": a * 0.1,
            "t1": b * 0.1,
            "peak_hz": float(freqs[int(np.argmax(sp))]),
            "obw99_lo": float(band.min()) if len(band) else 0.0,
            "obw99_hi": float(band.max()) if len(band) else 0.0,
        }
    return {
        "n_s": n / FS,
        "clip_frac": clip,
        "floor_power": use,
        "floor_db": 0.0,
        "pre_restart_median_power": floor,
        "quiet_p20_power": quiet,
        "peak_db": float(np.max(db)),
        "peak_t": float(np.argmax(db) * 0.1),
        "above_10db_s": float(np.sum(on) * 0.1),
        "above_6db_s": float(np.sum(db >= 6.0) * 0.1),
        "runs": runs,
        "spectrum": spec,
        "db_100ms": [round(float(x), 2) for x in db],
    }


if __name__ == "__main__":
    if len(sys.argv) > 1 and sys.argv[1] == "analyze":
        t_restart = float(sys.argv[2]) if len(sys.argv) > 2 else 1.5
        iq_path = sys.argv[3] if len(sys.argv) > 3 else None
        info = analyze(t_restart, iq_path)
        # Keep the capture record; only refresh the measurement fields.
        prev = {}
        if OUT.exists():
            prev = json.loads(OUT.read_text(encoding="utf-8"))
        prev.update(info)
        OUT.write_text(json.dumps(prev, indent=2), encoding="utf-8")
        print("floor_power %.4f peak_db %.2f at %.1f s  above_10db %.2f s  above_6db %.2f s  clip %.6f" % (
            info["floor_power"], info["peak_db"], info["peak_t"], info["above_10db_s"], info["above_6db_s"], info["clip_frac"]))
        for run in info["runs"]:
            print("run %.2f-%.2f dur %.2f peak %.1f dB rms %.0f p01 %.0f p99 %.0f" % (
                run["t0"], run["t1"], run["dur"], run["peak_db"], run["dev_rms"], run["p01"], run["p99"]))
        print("spectrum", info["spectrum"])
        db = info["db_100ms"]
        hot = [(i * 0.1, db[i]) for i in range(len(db)) if db[i] >= 3]
        print("bins>=3dB", hot[:40], "count", len(hot))
    else:
        main()
