# F60D replay rows. HackRF only, no W6Plus, no hotspot.
# Amp off, primer first, no -R, 2400000, VGA 30, 467.625.
#
# python tools/fw-bench/fw_fw60_replay.py --grant
import json
import subprocess
import sys
import time
import wave
from array import array

import numpy as np

HERE = __import__("pathlib").Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))
sys.path.insert(0, str(HERE / "runner"))
import fw_full_rows as fr  # noqa: E402
import fw_fw60_rows as rows  # noqa: E402
import fw_replay_rows as rr  # noqa: E402
import fw58_gaps as gaps  # noqa: E402
import hackrf  # noqa: E402
from common import Config  # noqa: E402
from hackrf import running as hackrf_running  # noqa: E402
from phone import Phone  # noqa: E402

F60D = rows.F60D
F60D_TAG = rows.F60D_TAG
VGA = 30


def samples(path):
    w = wave.open(str(path), "rb")
    raw = w.readframes(w.getnframes())
    rate = w.getframerate() or 8000
    w.close()
    s = array("h")
    s.frombytes(raw[: len(raw) - (len(raw) % 2)])
    return np.asarray(s, dtype=np.float64), rate


def loud_window(sig, rate, seconds=2.0):
    n = int(rate * seconds)
    if len(sig) <= n:
        return sig
    step = rate // 4
    best_i, best_p = 0, -1.0
    for i in range(0, len(sig) - n, step):
        chunk = sig[i:i + n]
        p = float(np.dot(chunk, chunk))
        if p > best_p:
            best_i, best_p = i, p
    return sig[best_i:best_i + n]


def ncc(a, b, rate):
    a = loud_window(a, rate)[::4]
    b = loud_window(b, rate)[::4]
    a = a - a.mean()
    b = b - b.mean()
    a = a / (np.linalg.norm(a) + 1e-9)
    b = b / (np.linalg.norm(b) + 1e-9)
    if len(a) < 20 or len(b) < 20:
        return 0.0
    return round(float(np.max(np.abs(np.correlate(a, b, "full")))), 3)


def spectrum(sig, rate):
    w = loud_window(sig, rate)
    w = w * np.hanning(len(w))
    sp = np.abs(np.fft.rfft(w))
    fr = np.fft.rfftfreq(len(w), 1 / rate)
    bins = []
    for lo in range(200, 3400, 200):
        m = (fr >= lo) & (fr < lo + 200)
        bins.append(float(np.mean(sp[m])) if m.any() else 0.0)
    v = np.asarray(bins)
    v = v / (np.linalg.norm(v) + 1e-9)
    return v


def spec_corr(a, b, rate):
    x, y = spectrum(a, rate), spectrum(b, rate)
    return round(float(np.dot(x, y)), 3)


def ram_view(gate, table):
    if len(gate) < 32 or len(table) < 40:
        return {"gate_len": len(gate), "table_len": len(table)}
    slot = gate[2]
    off = (slot + 7) * 4
    word = int.from_bytes(table[off:off + 4], "little") if off + 4 <= len(table) else None
    return {
        "slot": slot,
        "gate13": gate[0x13],
        "match14": table[slot + 14] if slot + 14 < len(table) else None,
        "match16": table[slot + 16] if slot + 16 < len(table) else None,
        "word": gaps.base.show_word(word),
    }


def one(cfg, phone, label, kind, with_ram):
    if hackrf_running():
        raise SystemExit("hackrf already running")
    if fr.open_web(phone).call("/api/status").get("transmitting"):
        raise SystemExit("phone is transmitting")
    gaps.base.heat_ok(cfg, phone)
    phone.adb("shell", "logcat", "-c")
    log_path = cfg.out / (label + ".log")
    handle = open(log_path, "w", encoding="utf-8", errors="replace")
    log_proc = subprocess.Popen(
        [cfg.adb, "-s", cfg.serial, "logcat", "-v", "time", "-s", "RadioService:I"],
        stdout=handle, stderr=subprocess.STDOUT)
    ms = 16000 if kind else 6000
    t0 = time.time()
    phone.rx_clip(label, ms)
    ram = None
    try:
        if kind:
            pp, np_ = rr.primer(cfg)
            proc, txlog = rr.start_tx(cfg, pp, np_, VGA)
            rr.finish_tx(proc, txlog, 1.0)
            time.sleep(0.15)
            path = rr.FILES[kind]
            n = path.stat().st_size // 2
            proc, txlog = rr.start_tx(cfg, path, n, VGA)
            time.sleep(2.0)
            if with_ram and proc.poll() is None:
                gate = rows.read_ram(cfg, phone, 0x4C7BC, 32)
                table = rows.read_ram(cfg, phone, 0x4D318, 64)
                ram = ram_view(gate, table)
            rr.finish_tx(proc, txlog, n / rr.FS + 5)
        else:
            time.sleep(6.0)
    finally:
        if hackrf_running():
            hackrf.kill()
    remain = (ms / 1000.0 + 0.8) - (time.time() - t0)
    if remain > 0:
        time.sleep(remain)
    log_proc.terminate()
    try:
        log_proc.wait(timeout=3)
    except Exception:
        log_proc.kill()
    handle.close()
    wav = cfg.out / (label + ".wav")
    phone.pull_app("/data/data/%s/cache/rxclip_%s.wav" % (phone.cfg.package, label), wav)
    text = log_path.read_text(encoding="utf-8", errors="replace")
    reports = gaps.frames_2b(text)
    status = gaps.status_bytes(text)
    try:
        rms, peak = gaps.clip_levels(wav)
    except Exception:
        rms, peak = 0.0, 0
    row = {
        "label": label, "kind": kind, "status": status,
        "reports": reports, "rms": round(rms, 1), "peak": peak, "ram": ram,
        "wav": str(wav),
    }
    fr.say(cfg, "%s status %s rms %.1f ram %s" % (label, status, rms, ram))
    return row


def main():
    if "--grant" not in sys.argv:
        raise SystemExit("refusing without --grant")
    cfg = Config()
    fr.BUSY.parent.mkdir(parents=True, exist_ok=True)
    fr.BUSY.write_text("fw60 replay\n", encoding="ascii")
    phone = None
    doc = {"image": F60D_TAG, "vga": VGA, "rows": []}
    try:
        phone = Phone(cfg)
        if not phone.ok() or phone.cfg.serial != "192.168.1.125:5555":
            raise SystemExit("no phone")
        if hackrf_running():
            raise SystemExit("hackrf already running")
        rr.scale_files(cfg)
        gaps.base.heat_ok(cfg, phone)
        if phone.tag() != F60D_TAG:
            fr.load_image(cfg, phone, fr.FACTORY, fr.FACTORY_TAG)
            phone.wake()
            phone.adb("shell", "am", "start", "-n", "com.macdmr.radio/.MainActivity")
            time.sleep(2)
            web = fr.open_web(phone)
            rows.confirmed_key(cfg, phone, web)
            fr.load_image(cfg, phone, F60D, F60D_TAG)
            phone.wake()
            phone.adb("shell", "am", "start", "-n", "com.macdmr.radio/.MainActivity")
            time.sleep(2)
            web = fr.open_web(phone)
        else:
            fr.say(cfg, "already F60D, factory key already done")
            phone.wake()
            phone.adb("shell", "am", "start", "-n", "com.macdmr.radio/.MainActivity")
            time.sleep(2)
            web = fr.open_web(phone)
        if phone.tag() != F60D_TAG:
            raise SystemExit("tag")
        doc["tag"] = phone.tag()
        rr.on_channel_49(cfg, web)
        rr.enter_vfo(cfg, web)
        web.monitor(False)
        time.sleep(0.4)
        doc["rows"].append(one(cfg, phone, "F60D_idle", None, False))
        doc["rows"].append(one(cfg, phone, "F60D_tg9", "tg9", False))
        doc["rows"].append(one(cfg, phone, "F60D_allcall", "allcall", True))
        doc["rows"].append(one(cfg, phone, "F60D_tg99", "tg99", False))
        by = {r["label"]: r for r in doc["rows"]}
        clips = {}
        for label, row in by.items():
            clips[label] = samples(row["wav"])
        rate = clips["F60D_tg9"][1]
        doc["ncc_all_tg9"] = ncc(clips["F60D_allcall"][0], clips["F60D_tg9"][0], rate)
        doc["ncc_all_idle"] = ncc(clips["F60D_allcall"][0], clips["F60D_idle"][0], rate)
        doc["ncc_tg9_idle"] = ncc(clips["F60D_tg9"][0], clips["F60D_idle"][0], rate)
        doc["spec_all_tg9"] = spec_corr(clips["F60D_allcall"][0], clips["F60D_tg9"][0], rate)
        doc["spec_all_idle"] = spec_corr(clips["F60D_allcall"][0], clips["F60D_idle"][0], rate)
        tg9_reports = any(r.get("target") == "9" and r.get("type") == 1 for r in by["F60D_tg9"]["reports"])
        tg99_started = 1 in by["F60D_tg99"]["status"]
        doc["tg9_reported"] = tg9_reports
        doc["tg99_started"] = tg99_started
        doc["allcall_plays"] = (
            doc["ncc_all_tg9"] >= 0.5 and doc["ncc_all_idle"] <= 0.35 and doc["ncc_tg9_idle"] <= 0.35
        )
        fr.say(cfg, "ncc all/tg9 %s all/idle %s tg9/idle %s plays %s tg99 %s" % (
            doc["ncc_all_tg9"], doc["ncc_all_idle"], doc["ncc_tg9_idle"],
            doc["allcall_plays"], tg99_started))
    finally:
        if phone is not None:
            try:
                web = fr.open_web(phone)
                if web.call("/api/status").get("transmitting"):
                    web.call("/api/ptt", {"down": False})
            except Exception as exc:
                fr.say(cfg, "unkey %s" % type(exc).__name__)
            try:
                doc["end_tag"] = phone.tag()
                doc["heat"] = gaps.base.heat_ok(cfg, phone)
            except Exception as exc:
                doc["end_note"] = type(exc).__name__
        (cfg.out / "fw_fw60_replay.json").write_text(
            json.dumps(doc, indent=1, default=str), encoding="utf-8")
        if hackrf_running():
            hackrf.kill()
        try:
            if fr.BUSY.exists():
                fr.BUSY.unlink()
        except Exception:
            pass


if __name__ == "__main__":
    main()
