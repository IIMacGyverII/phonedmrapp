# R-C step 3. Byte copy of both FM receive halves. The phone is not keyed.
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

IMAGE = camp.BUILD / "DMR003.RC30.V022.bin"
TAG = "DMR003.RC30.V022"
EXPECT = "6b0d873bc5526d24495d801f86f2b800b6cc62a2ac71c7ca495411c863a58ade"
DIR = Path(r"C:\Users\Joshua\AppData\Local\Temp\fw1718\rc30")
DIR.mkdir(exist_ok=True)
OUT = DIR / "result.json"
BODY = 518
TONES = (1000, 300, 100, 50)
VARIANTS = (0, 2, 3, 4)


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


def parse(raw):
    out = []
    for i in range(0, len(raw) - BODY + 1, BODY):
        b = raw[i:i + BODY]
        groups = sum(1 for k in range(0, 512, 4) if b[k + 1] == 0 and b[k + 2] == 0 and b[k + 3] == 0)
        samples = be(b[:512])
        out.append({
            "half": int(b[516]),
            "switch": int(b[517]),
            "sql": int.from_bytes(b[512:516], "little"),
            "groups_xx000000": groups,
            "samples": samples,
        })
    return out


def metrics(samples, target):
    x = samples - np.mean(samples)
    rms = float(np.sqrt(np.mean(x * x))) if x.size else 0.0
    info = {"n": int(samples.size), "mean": float(np.mean(samples)) if samples.size else 0.0, "rms": rms}
    if x.size < 32:
        return info
    w = np.hanning(x.size)
    amp = 2 * np.abs(np.fft.rfft(x * w)) / np.sum(w)
    freqs = np.fft.rfftfreq(x.size, 1 / 8000.0)
    use = freqs >= 20.0
    med = float(np.median(amp[use])) + 1e-12
    k = int(np.argmax(np.where(use, amp, 0.0)))
    i = int(np.argmin(np.abs(freqs - target)))
    step = np.abs(np.diff(samples))
    jump = int(np.argmax(step)) if step.size else 0
    meds = float(np.median(step)) + 1.0 if step.size else 1.0
    info.update({
        "peak_hz": float(freqs[k]),
        "peak_db": float(20 * np.log10((amp[k] + 1e-12) / med)),
        "target_hz": float(freqs[i]),
        "target_db": float(20 * np.log10((amp[i] + 1e-12) / med)),
        "seam_at": jump,
        "seam_step": float(step[jump]) if step.size else 0.0,
        "seam": bool(step.size and step[jump] > max(8 * meds, 2000)),
    })
    return info


def slim(half, target):
    m = metrics(half["samples"], target)
    m.pop("samples", None)
    return {
        "half": half["half"], "switch": half["switch"], "sql": half["sql"],
        "groups_xx000000": half["groups_xx000000"], **m,
    }


def capture(name, seconds, vga, mode, target):
    blob, n = old.fm_bytes(seconds, tone=target)
    path = DIR / (name + ".cs8")
    path.write_bytes(blob)
    proc, hlog = old.start_tx(path, n, vga)
    try:
        time.sleep(0.45)
        hit, _text = old.ask_rx(mode)
        raw = old.pull_rx(name + ".bin")
    finally:
        old.finish_tx(proc, hlog, seconds)
    halves = parse(raw)
    rows = [slim(h, target) for h in halves]
    camp.say("%s %s" % (name, " | ".join(
        "h%d rms %.0f peak %.0f db %.1f groups %d" % (
            r["half"], r["rms"], r.get("peak_hz", -1), r.get("target_db", -1), r["groups_xx000000"])
        for r in rows) or hit[-80:]))
    return {"log": hit[-180:], "rows": rows}


def sweep_cap(name, vga, mode):
    seconds, f0, f1 = 16.0, 40.0, 3200.0
    blob, n = old.fm_bytes(seconds, f0=f0, f1=f1)
    path = DIR / (name + ".cs8")
    path.write_bytes(blob)
    proc, hlog = old.start_tx(path, n, vga)
    t0 = time.time()
    rows = []
    try:
        for mark in (1.2, 3.5, 6.0, 8.5, 11.0, 13.0):
            delay = mark - (time.time() - t0)
            if delay > 0.05:
                time.sleep(delay)
            if time.time() - t0 > seconds - 1.0:
                break
            at = time.time() - t0
            expect = f0 + (f1 - f0) * (at + 0.08) / seconds
            hit, _text = old.ask_rx(mode)
            raw = old.pull_rx("%s_%.1f.bin" % (name, mark))
            halves = parse(raw)
            item = {"t": round(at, 3), "expect_hz": round(expect, 1), "log": hit[-120:],
                    "rows": [slim(h, expect) for h in halves]}
            rows.append(item)
            camp.say("sweep v%d t=%.2f expect %.0f %s" % (mode, at, expect, " ".join(
                "h%d:%.0f" % (r["half"], r.get("peak_hz", -1)) for r in item["rows"])))
    finally:
        old.finish_tx(proc, hlog, seconds)
    return rows


def rel_db(variant_rows):
    ref = None
    for tone in variant_rows:
        if tone["hz"] != 1000:
            continue
        if tone["rows"]:
            ref = max(tone["rows"], key=lambda r: r["rms"])
    if not ref or ref["rms"] <= 1:
        return []
    out = []
    half = ref["half"]
    for tone in variant_rows:
        same = [r for r in tone["rows"] if r["half"] == half]
        use = same[0] if same else (tone["rows"][0] if tone["rows"] else None)
        if not use:
            continue
        db = 20 * np.log10((use["rms"] + 1e-12) / ref["rms"])
        out.append({"hz": tone["hz"], "half": use["half"], "rms": use["rms"], "db_vs_1k": float(db),
                    "peak_hz": use.get("peak_hz")})
        camp.say("v rel %g Hz half %s %+.1f dB" % (tone["hz"], use["half"], db))
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
    raw = IMAGE.read_bytes()
    digest = hashlib.sha256(raw).hexdigest()
    if digest != EXPECT or raw[0x38464:0x38474] != TAG.encode():
        raise SystemExit("image is not RC30")
    camp.say("image sha256 " + digest)
    r3a3_run.devices_ok()
    if camp.hackrf_running():
        raise SystemExit("hackrf running")
    camp.adb("shell", "input", "keyevent", "224")
    camp.adb("shell", "am", "start", "-n", "com.macdmr.radio/.MainActivity")
    time.sleep(4)
    camp.tune()
    doc = {"sha256": digest, "tag": TAG, "dev_hz": old.DEV, "vga": 20}
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
    boot = camp.CAP / "rc30_boot.iq"
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
    stop = False
    for mode in VARIANTS:
        hit, body, qinfo = old.quiet(mode, "rc30_q%d.iq" % mode, 8)
        halves = parse(body)
        qrows = [slim(h, 0) for h in halves]
        camp.say("quiet v%d peak %.2f %s" % (mode, qinfo["peak_db"], " ".join(
            "h%d mean %.0f rms %.0f groups %d" % (r["half"], r["mean"], r["rms"], r["groups_xx000000"])
            for r in qrows)))
        entry = {"mode": mode, "quiet": {"log": hit[-180:], "peak_db": qinfo["peak_db"],
                                          "peak_t": qinfo["peak_t"], "rows": qrows}, "tones": []}
        doc["variants"].append(entry)
        save(doc)
        if old.radiated(qinfo):
            camp.say("STOP variant %d radiated" % mode)
            stop = True
            break
        if any(r["groups_xx000000"] > 40 for r in qrows) or len(qrows) < 2:
            camp.say("STOP variant %d read is not 256 int16 per half" % mode)
            stop = True
            break
        old.dummy(20)
        for hz in TONES:
            entry["tones"].append({"hz": hz, **capture("v%d_%d" % (mode, hz), 6.0, 20, mode, float(hz))})
            save(doc)
        entry["rel"] = rel_db(entry["tones"])
        entry["sweep"] = sweep_cap("v%d_sweep" % mode, 20, mode)
        save(doc)
        hundred = [r for r in entry["rel"] if r["hz"] == 100]
        if hundred and hundred[0]["db_vs_1k"] >= -6:
            camp.say("PASS low end on variant %d" % mode)
    if not stop:
        best = None
        for entry in doc["variants"]:
            for r in entry.get("rel") or []:
                if r["hz"] == 100 and (best is None or r["db_vs_1k"] > best):
                    best = r["db_vs_1k"]
        doc["best_100_db"] = best
        camp.say("best 100 Hz vs 1 kHz: %s" % best)
    end_state(doc)
    camp.say("END RC30")


if __name__ == "__main__":
    main()
