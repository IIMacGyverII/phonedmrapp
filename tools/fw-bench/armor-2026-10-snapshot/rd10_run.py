"""R-D. Receive only. Wi-Fi adb only. Does not key the phone and does not call vfo_off."""
import hashlib
import json
import sys
import threading
import time
from pathlib import Path

import numpy as np

sys.path.insert(0, r"D:\Documents\code\personal\phonedmrapp\tools\m17-research")
import m17  # noqa: E402

import camp
import factory_boot
import r3a3_run
import r3a3_silence
import r4p0_run as rx
import rc20_run as old

TAG = "DMR003.RD10.V022"
IMAGE = camp.REPO / "radio_firmware" / "build" / (TAG + ".bin")
DIR = camp.HERE / "rd10"
DIR.mkdir(parents=True, exist_ok=True)
OUT = DIR / "result.json"
FS = 8000
VGA = 20
BODY = 514
HOLD = None


def save(doc):
    OUT.write_text(json.dumps(doc, indent=2), encoding="utf-8")


def line(x, freq, fs=FS):
    x = np.asarray(x, np.float64)
    x = x - np.mean(x)
    n = x.size
    if n < 8:
        return 0.0
    k = np.arange(n)
    w = np.exp(-2j * np.pi * freq * k / fs)
    return float(np.abs(np.dot(x, w)) * 2.0 / n)


def db(a, ref):
    if a is None or ref is None or a <= 0 or ref <= 0:
        return None
    return float(20.0 * np.log10(a / ref))


def wait_for(needle, timeout):
    text = ""
    t0 = time.time()
    while time.time() - t0 < timeout:
        text = camp.adb("shell", "logcat", "-d", "-s", "RadioService:I", "DiagReceiver:I", timeout=20)[1]
        if needle in text:
            return text
    return text


def hit_line(text, needle):
    hit = ""
    for ln in text.splitlines():
        if needle in ln:
            hit = ln.strip()
    return hit


def pull_cache(remote_name, dest):
    cmd = (
        "cp /data/data/com.macdmr.radio/cache/%s /data/local/tmp/%s && "
        "chmod 644 /data/local/tmp/%s" % (remote_name, remote_name, remote_name)
    )
    rc, out = camp.adb("shell", "su --mount-master --context u:r:magisk:s0 -c '%s'" % cmd, timeout=30)
    if rc != 0:
        camp.say("no cache file %s: %s" % (remote_name, out.strip().replace("\n", " ")[:160]))
        return b""
    rc, out = camp.adb("pull", "/data/local/tmp/" + remote_name, str(dest), timeout=60)
    if rc != 0:
        raise RuntimeError("pull " + out)
    return dest.read_bytes()


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
        out.append({"seq": int(b[512]), "half": int(b[513]), "samples": be(b[:512])})
    out.sort(key=lambda p: p["seq"])
    return out


def ask_rx(mode, n=4):
    old.clear_cache()
    camp.adb("shell", "logcat", "-c")
    extra = ["--es", "cmd", "cmdsym", "--es", "op", "rxram", "--ei", "mode", str(mode), "--ei", "n", str(n)]
    camp.broadcast(extra)
    text = wait_for("rxram ", 8)
    hit = hit_line(text, "rxram ")
    camp.say(hit[-180:] if hit else "rxram log missing")
    if "missing" in hit or "bad" in hit or not hit:
        return hit, []
    raw = pull_cache("rxram.bin", DIR / ("rx_m%d_n%d.bin" % (mode, n)))
    return hit, parts(raw)


def hold(mode, action):
    global HOLD
    camp.adb("shell", "logcat", "-c")
    camp.broadcast(["--es", "cmd", "cmdsym", "--es", "op", "hold", "--ei", "mode", str(mode), "--ei", "action", str(action)])
    text = wait_for("hold ", 6)
    hit = hit_line(text, "hold ")
    camp.say(hit[-180:] if hit else "hold log missing")
    if "sr=0" not in hit:
        raise RuntimeError("hold failed: " + hit)
    HOLD = mode if action == 1 else None
    return hit


def restore_hold():
    global HOLD
    if HOLD is None:
        return
    mode = HOLD
    try:
        hold(mode, 0)
    except Exception as exc:
        camp.say("hold restore failed: " + str(exc))
        HOLD = None


def wav_pcm(blob):
    i = blob.find(b"data")
    if i < 0 or i + 8 > len(blob):
        raise RuntimeError("wav has no data chunk")
    n = int.from_bytes(blob[i + 4:i + 8], "little")
    return np.frombuffer(blob[i + 8:i + 8 + n], dtype="<i2").astype(np.float64)


def play_and_clip(name, iq, n, ms):
    path = DIR / (name + ".cs8")
    path.write_bytes(iq)
    proc, hlog = old.start_tx(path, n, VGA)
    time.sleep(0.3)
    camp.adb("shell", "logcat", "-c")
    camp.broadcast(["--es", "cmd", "rxclip", "--ei", "ms", str(ms), "--es", "name", name])
    text = wait_for("rxclip done", ms / 1000.0 + 8)
    hit = hit_line(text, "rxclip done")
    camp.say(hit[-160:] if hit else "rxclip missing " + name)
    old.finish_tx(proc, hlog, ms / 1000.0 + 2)
    blob = pull_cache("rxclip_%s.wav" % name, DIR / (name + ".wav"))
    if not blob:
        return None, hit
    return wav_pcm(blob), hit


def tone_iq(seconds, tone):
    return old.fm_bytes(seconds, tone=tone)


def log_chirp_iq(seconds, f0=20.0, f1=3800.0):
    n = int(old.FS_TX * seconds)
    t = np.arange(n) / old.FS_TX
    k = np.log(f1 / f0) / seconds
    phase = 2 * np.pi * f0 / k * (np.exp(k * t) - 1.0)
    audio = np.sin(phase)
    fm = 2 * np.pi * old.DEV * np.cumsum(audio) / old.FS_TX
    z = np.exp(1j * fm)
    iq = np.empty(2 * n, np.int8)
    iq[0::2] = np.clip(np.round(z.real * 110), -127, 127).astype(np.int8)
    iq[1::2] = np.clip(np.round(z.imag * 110), -127, 127).astype(np.int8)
    return iq.tobytes(), n


def tone_level(pcm, freq):
    if pcm is None or pcm.size < 400:
        return {"line": 0.0, "rms": 0.0}
    n = min(pcm.size, int(0.8 * FS))
    a = max(0, (pcm.size - n) // 2)
    x = pcm[a:a + n]
    return {"line": line(x, freq), "rms": float(np.sqrt(np.mean((x - np.mean(x)) ** 2)))}


def chirp_report(pcm, seconds=8.0, f0=20.0, f1=3800.0):
    """Peak-track the log sweep and report line levels against the 1 kHz moment."""
    if pcm is None or pcm.size < FS:
        return {"silent": True}
    win = int(0.08 * FS)
    hop = win // 2
    times, peaks, amps = [], [], []
    window = np.hanning(win)
    for i in range(0, pcm.size - win, hop):
        x = pcm[i:i + win]
        x = x - np.mean(x)
        spec = np.abs(np.fft.rfft(x * window))
        freqs = np.fft.rfftfreq(win, 1.0 / FS)
        band = (freqs >= 15) & (freqs <= 4200)
        sl = spec[band]
        fr = freqs[band]
        k = int(np.argmax(sl))
        times.append(i / FS)
        peaks.append(float(fr[k]))
        amps.append(float(sl[k]))
    times = np.array(times)
    peaks = np.array(peaks)
    # The clip starts after the transmitter. Fit a delay so the log law matches the peaks.
    best = None
    for delay in np.linspace(-1.0, 2.0, 61):
        expect = f0 * (f1 / f0) ** (np.clip(times + delay, 0, seconds - 1e-3) / seconds)
        err = np.median(np.abs(np.log(np.maximum(peaks, 1)) - np.log(expect)))
        if best is None or err < best[0]:
            best = (err, delay, expect)
    delay = best[1]
    expect = best[2]
    ref_i = int(np.argmin(np.abs(expect - 1000)))
    ref = amps[ref_i] if amps else 0
    rows = []
    for target in (50, 100, 300, 1000, 2000, 3000, 3500, 3800):
        j = int(np.argmin(np.abs(expect - target)))
        rows.append({"hz": target, "seen_hz": peaks[j], "db": db(amps[j], ref)})
    rms = float(np.sqrt(np.mean((pcm - np.mean(pcm)) ** 2)))
    return {"delay_s": float(delay), "fit_log_err": float(best[0]), "rms": rms, "rows": rows,
            "silent": rms < 30}


def one_set(label, tones):
    """Tones plus one 8 s log chirp. Returns levels relative to the 1 kHz tone."""
    out = {"tones": {}, "chirp": None}
    ref = None
    for freq in tones:
        iq, n = tone_iq(2.2, float(freq))
        pcm, hit = play_and_clip("%s_%d" % (label, freq), iq, n, 1600)
        level = tone_level(pcm, freq)
        level["log"] = hit[-120:]
        out["tones"][str(freq)] = level
        camp.say("%s %d Hz line %.1f rms %.1f" % (label, freq, level["line"], level["rms"]))
        if freq == 1000:
            ref = level["line"]
    for freq, level in out["tones"].items():
        level["db"] = db(level["line"], ref)
    iq, n = log_chirp_iq(9.0)
    pcm, hit = play_and_clip(label + "_chirp", iq, n, 8000)
    out["chirp"] = chirp_report(pcm)
    out["chirp_log"] = hit[-120:]
    camp.say("%s chirp rms %.1f silent %s" % (label, out["chirp"].get("rms", 0), out["chirp"].get("silent")))
    return out


def ram_tone(freq):
    iq, n = tone_iq(2.4, float(freq))
    path = DIR / ("ram_%d.cs8" % freq)
    path.write_bytes(iq)
    proc, hlog = old.start_tx(path, n, VGA)
    time.sleep(0.4)
    hit, got = ask_rx(4, 4)
    old.finish_tx(proc, hlog, 2.4)
    if len(got) != 4:
        return {"n": len(got), "log": hit[-160:]}
    x = np.concatenate([p["samples"] for p in got])
    return {"n": 4, "line": line(x, freq), "rms": float(np.sqrt(np.mean((x - np.mean(x)) ** 2))),
            "log": hit[-160:], "samples": x}


def m17_iq():
    lsf = m17.lsf_bytes("N0CALL", "@ALL")
    syms = list(m17.encode_lsf(lsf))
    syms += m17.encode_stream(lsf, 0, bytes(16), 0)
    syms += m17.encode_stream(lsf, 1, bytes(range(16)), 1)
    syms = np.tile(np.array(syms, float), 26)
    dev = m17.deviation(syms, old.FS_TX)
    phase = 2 * np.pi * np.cumsum(dev) / old.FS_TX
    z = np.exp(1j * phase)
    n = z.size
    iq = np.empty(2 * n, np.int8)
    iq[0::2] = np.clip(np.round(z.real * 110), -127, 127).astype(np.int8)
    iq[1::2] = np.clip(np.round(z.imag * 110), -127, 127).astype(np.int8)
    return iq.tobytes(), n


def decode_halves(got, scale):
    if len(got) != 6:
        return {"n": len(got)}
    x = np.concatenate([p["samples"] for p in got])
    attempts = []
    for sign, name in ((1.0, "as_captured"), (-1.0, "inverted")):
        dev = x * scale * sign
        res = m17.decode_transmission(dev, FS, verbose=False)
        lsf = res["lsf"]
        frames = res["frames"]
        golay0 = sum(1 for fn, payload, err in frames if err == 0)
        attempts.append({
            "polarity": name,
            "lsf_crc": bool(lsf[2]) if lsf else False,
            "lsf": list(lsf) if lsf else None,
            "frames": len(frames),
            "golay0": golay0,
            "frame_fn": [int(fn) & 0xFFFF for fn, payload, err in frames[:6]],
            "frame_golay": [int(err) for fn, payload, err in frames[:6]],
        })
    passed = any(a["lsf_crc"] and a["golay0"] >= 1 for a in attempts)
    return {"n": 6, "passed": passed, "attempts": attempts}


def main():
    if camp.SER != "192.168.1.125:5555":
        raise SystemExit("refusing " + camp.SER)
    raw = IMAGE.read_bytes()
    digest = hashlib.sha256(raw).hexdigest()
    if raw[0x38464:0x38474] != TAG.encode():
        raise SystemExit("image is not RD10")
    camp.say("image sha256 " + digest)
    r3a3_run.devices_ok()
    if camp.hackrf_running():
        raise SystemExit("hackrf running")
    camp.adb("shell", "input", "keyevent", "224")
    camp.adb("shell", "am", "start", "-n", "com.macdmr.radio/.MainActivity")
    time.sleep(4)
    doc = {"sha256": digest, "tag": TAG, "dev_hz": old.DEV, "vga": VGA, "adb": camp.SER}
    boot = camp.CAP / "rd10_boot.iq"
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
    if loaded != TAG:
        raise SystemExit("version %s; factory stays if the updater did not run" % loaded)
    text = camp.adb("shell", "logcat", "-d", "-t", "5000", "-s", "RadioService:I", "YModemManager:D", timeout=40)[1]
    (DIR / "load.log").write_text(text, encoding="utf-8", errors="replace")
    banner = [ln.strip() for ln in text.splitlines() if "开机初始化完成" in ln or "module booted" in ln or "module DMR" in ln]
    doc["banner_lines"] = banner[-8:]
    doc["banner"] = "seen" if ("开机初始化完成" in text or "module booted" in text) else "not in retained log"
    info = factory_boot.analyze(8.0, str(boot))
    doc["boot"] = {"peak_db": info["peak_db"], "above_10db_s": info["above_10db_s"],
                   "floor_db": info["floor_db"]}
    camp.say("boot peak %.2f above10 %.2f" % (info["peak_db"], info["above_10db_s"]))
    save(doc)
    if old.radiated(info):
        r3a3_silence.restore_factory()
        raise SystemExit("boot radiated")
    camp.tune()
    doc["vfo"] = "467.625"

    doc["quiet"] = []
    for mode, n in ((0, 4), (4, 4)):
        path = camp.CAP / ("rd10_q%d.iq" % mode)
        proc, hlog = rx.recv(path, 8, 24, 38)
        time.sleep(1.0)
        hit, got = ask_rx(mode, n)
        rx.finish_recv(proc, hlog, path, 8)
        qinfo = factory_boot.analyze(1.0, str(path))
        entry = {"mode": mode, "n": len(got), "peak_db": qinfo["peak_db"], "log": hit[-160:]}
        if got:
            x = np.concatenate([p["samples"] for p in got])
            entry["rms"] = float(np.sqrt(np.mean((x - np.mean(x)) ** 2)))
        doc["quiet"].append(entry)
        save(doc)
        camp.say("quiet m%d peak %.2f frames %d" % (mode, qinfo["peak_db"], len(got)))
        if old.radiated(qinfo) or len(got) != n:
            raise SystemExit("stop quiet mode %d" % mode)

    old.dummy(VGA)
    tones = (50, 100, 300, 1000, 2000, 3500, 3800)
    doc["phone"] = {}
    doc["phone"]["plain"] = one_set("plain", tones)
    save(doc)

    doc["phone"]["hold4_log"] = hold(4, 1)
    doc["phone"]["hold4"] = one_set("h4", tones)
    save(doc)
    camp.tune()
    doc["phone"]["hold4_after_tune"] = {}
    for freq in (100, 1000):
        iq, n = tone_iq(2.2, float(freq))
        pcm, hit = play_and_clip("h4t_%d" % freq, iq, n, 1600)
        level = tone_level(pcm, freq)
        level["log"] = hit[-120:]
        doc["phone"]["hold4_after_tune"][str(freq)] = level
        camp.say("hold4 after tune %d line %.1f" % (freq, level["line"]))
    ref = doc["phone"]["hold4_after_tune"]["1000"]["line"]
    for freq, level in doc["phone"]["hold4_after_tune"].items():
        level["db"] = db(level["line"], ref)
    restore_hold()
    save(doc)

    doc["phone"]["hold3_log"] = hold(3, 1)
    doc["phone"]["hold3"] = one_set("h3", tones)
    save(doc)
    camp.tune()
    doc["phone"]["hold3_after_tune"] = {}
    for freq in (100, 1000):
        iq, n = tone_iq(2.2, float(freq))
        pcm, hit = play_and_clip("h3t_%d" % freq, iq, n, 1600)
        level = tone_level(pcm, freq)
        level["log"] = hit[-120:]
        doc["phone"]["hold3_after_tune"][str(freq)] = level
        camp.say("hold3 after tune %d line %.1f" % (freq, level["line"]))
    ref = doc["phone"]["hold3_after_tune"]["1000"]["line"]
    for freq, level in doc["phone"]["hold3_after_tune"].items():
        level["db"] = db(level["line"], ref)
    restore_hold()
    save(doc)

    doc["ram"] = {}
    cal = None
    for freq in (1000, 2000, 3000, 3500, 3800):
        entry = ram_tone(freq)
        samples = entry.pop("samples", None)
        if freq == 1000 and samples is not None and entry.get("line", 0) > 0:
            cal = (samples, entry["line"])
        doc["ram"][str(freq)] = {k: v for k, v in entry.items()}
        camp.say("ram %d line %s n %s" % (freq, entry.get("line"), entry.get("n")))
        save(doc)
        if entry.get("n") != 4:
            raise SystemExit("ram tone frames")
    ref = doc["ram"]["1000"]["line"]
    for freq, entry in doc["ram"].items():
        entry["db"] = db(entry.get("line"), ref)

    path = camp.CAP / "rd10_q6.iq"
    proc, hlog = rx.recv(path, 8, 24, 38)
    time.sleep(1.0)
    hit, got = ask_rx(4, 6)
    rx.finish_recv(proc, hlog, path, 8)
    qinfo = factory_boot.analyze(1.0, str(path))
    doc["quiet6"] = {"n": len(got), "peak_db": qinfo["peak_db"], "log": hit[-160:]}
    save(doc)
    camp.say("quiet n6 peak %.2f frames %d" % (qinfo["peak_db"], len(got)))
    if old.radiated(qinfo) or len(got) != 6:
        raise SystemExit("stop six-half quiet")
    if cal is None:
        raise SystemExit("no 1 kHz calibration")
    scale = 2500.0 / cal[1]
    doc["scale_hz_per_count"] = scale
    camp.say("scale %.4f Hz/count" % scale)

    iq, n = m17_iq()
    path = DIR / "m17loop.cs8"
    path.write_bytes(iq)
    doc["m17"] = []
    passed = False
    for attempt in range(8):
        proc, hlog = old.start_tx(path, n, VGA)
        time.sleep(0.5)
        hit, got = ask_rx(4, 6)
        # leave the transmitter running for the capture window; the command already returned
        old.finish_tx(proc, hlog, n / old.FS_TX)
        decoded = decode_halves(got, scale)
        decoded["log"] = hit[-140:]
        doc["m17"].append(decoded)
        save(doc)
        camp.say("m17 try %d n %s pass %s" % (attempt, decoded.get("n"), decoded.get("passed")))
        if decoded.get("passed"):
            passed = True
            break
    doc["m17_passed"] = passed
    doc["end"] = time.strftime("%H:%M:%S")
    save(doc)
    camp.tune()
    camp.say("RD10 left loaded, VFO 467.625, m17 pass %s" % passed)


if __name__ == "__main__":
    try:
        main()
    finally:
        restore_hold()
        if camp.hackrf_running():
            camp.kill_hackrf()
