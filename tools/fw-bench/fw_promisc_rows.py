# Promiscuous-receive rows on FW57. No image load. Op 14 is not used.
# Flag is raw40 [15, v]. MON is 0x2F body 1 or 2, sent on its own so the
# app's monitor button does not also change the flag.
# W6Plus keying is key.sh. The replay is scaled TG 99, VGA 30, amp off,
# primer first, 2400000, 467.625, no -R. The hotspot is not used.
#
# python tools/fw-bench/fw_promisc_rows.py --self-check
# python tools/fw-bench/fw_promisc_rows.py --grant
import json
import math
import os
import re
import subprocess
import sys
import time
import wave
from array import array
from pathlib import Path

import numpy as np

HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))
sys.path.insert(0, str(HERE / "runner"))
import fw_full_rows as fr  # noqa: E402
import fw_replay_rows as rr  # noqa: E402
import fw_w6_listen as listen  # noqa: E402
import fw58_gaps as gaps  # noqa: E402
import hackrf  # noqa: E402
from common import Config  # noqa: E402
from hackrf import running as hackrf_running  # noqa: E402
from phone import Phone  # noqa: E402

VGA = 30
CLIP_S = 18
REF_TG9 = Path(os.environ.get("TEMP", "")) / "fw-bench" / "F60D_tg9.wav"
REF_IDLE = Path(os.environ.get("TEMP", "")) / "fw-bench" / "F60D_idle.wav"


def redact(line):
    return re.sub(r"\d{6,}", "#", line).strip()[:220]


def load_wav(path):
    w = wave.open(str(path), "rb")
    raw = w.readframes(w.getnframes())
    rate = w.getframerate() or 8000
    ch = w.getnchannels() or 1
    w.close()
    s = array("h")
    s.frombytes(raw[: len(raw) - (len(raw) % 2)])
    sig = np.asarray(s, dtype=np.float64)
    if ch > 1:
        sig = sig[::ch]
    return sig, rate


def pearson(ref, sig, rate, lo_s, hi_s, span_s):
    """Sample-by-sample Pearson of ref[lo:hi] against sig, lags within ±span."""
    i0, i1 = int(lo_s * rate), int(hi_s * rate)
    if i1 > len(ref) or i1 - i0 < rate:
        return None
    window = ref[i0:i1]
    window = window - window.mean()
    rn = float(np.dot(window, window))
    if rn <= 0:
        return None
    n = len(window)
    span_n = int(span_s * rate)
    j0 = max(0, i0 - span_n)
    j1 = min(len(sig), i1 + span_n)
    seg = sig[j0:j1]
    if len(seg) < n + 8:
        return None
    dots = np.correlate(seg, window, mode="valid")
    cs = np.cumsum(np.insert(seg, 0, 0.0))
    cq = np.cumsum(np.insert(seg * seg, 0, 0.0))
    sums = cs[n:] - cs[:-n]
    energy = cq[n:] - cq[:-n] - (sums * sums) / n
    energy = np.maximum(energy, 1e-12)
    score = dots / np.sqrt(energy * rn)
    lags = np.arange(len(score)) + j0 - i0
    keep = (lags >= -span_n) & (lags <= span_n)
    if not np.any(keep):
        return None
    use = np.where(keep)[0]
    k = use[int(np.argmax(score[use]))]
    return {
        "wave": round(float(score[k]), 3),
        "lag_ms": round(1000.0 * float(lags[k]) / rate, 1),
        "i0": int(j0 + k),
        "n": n,
    }


def spectrum(sig, rate):
    if len(sig) < 32:
        return None
    w = sig * np.hanning(len(sig))
    sp = np.abs(np.fft.rfft(w))
    fr = np.fft.rfftfreq(len(w), 1.0 / rate)
    bins = []
    for lo in range(200, 3400, 200):
        m = (fr >= lo) & (fr < lo + 200)
        bins.append(float(np.mean(sp[m])) if np.any(m) else 0.0)
    v = np.asarray(bins, dtype=np.float64)
    return v / (np.linalg.norm(v) + 1e-9)


def content(ref_path, sig, rate):
    if not ref_path.is_file():
        return {"ref": "missing"}
    ref, ref_rate = load_wav(ref_path)
    if ref_rate != rate:
        return {"ref": ref_path.name, "rate": "differs"}
    dur = len(ref) / rate
    if dur >= 8.0:
        lo, hi = 3.0, 8.0
    elif dur >= 4.0:
        lo, hi = 1.0, min(5.0, dur - 0.2)
    else:
        return {"ref": ref_path.name, "wave": None}
    hit = pearson(ref, sig, rate, lo, hi, 1.0)
    if hit is None:
        return {"ref": ref_path.name, "wave": None}
    a = ref[int(lo * rate): int(hi * rate)]
    b0 = hit["i0"]
    b = sig[b0: b0 + hit["n"]]
    sa, sb = spectrum(a, rate), spectrum(b, rate)
    spec = round(float(np.dot(sa, sb)), 3) if sa is not None and sb is not None else None
    return {"ref": ref_path.name, "wave": hit["wave"], "lag_ms": hit["lag_ms"], "spectrum": spec}


def tone_seconds(path):
    if not path.is_file():
        return []
    sig, rate = load_wav(path)
    rows = []
    step = 2 * math.pi * 1000.0 / rate

    def line_db(chunk):
        re = im = 0.0
        ang = 0.0
        for x in chunk:
            re += x * math.cos(ang)
            im -= x * math.sin(ang)
            ang += step
        line = re * re + im * im
        others = []
        for freq in (400, 700, 1300, 1600, 2200):
            st = 2 * math.pi * freq / rate
            re = im = 0.0
            ang = 0.0
            for x in chunk:
                re += x * math.cos(ang)
                im -= x * math.sin(ang)
                ang += st
            others.append(re * re + im * im)
        med = sorted(others)[len(others) // 2] or 1.0
        return round(10 * math.log10(line / med), 1)

    for i in range(0, len(sig) - rate, rate):
        rows.append(line_db(sig[i: i + rate]))
    return rows


def rx_status(text):
    rows = []
    for line in text.splitlines():
        if "RX cmd=0x36" not in line:
            continue
        m = re.search(r"(\d{2}:\d{2}:\d{2}\.\d+).*\[([0-9A-F ]+)\]", line)
        if m:
            rows.append({"t": m.group(1), "body": m.group(2).strip()})
    return rows


def reports(text):
    out = []
    for row in gaps.frames_2b(text):
        out.append({"len": row["len"], "type": row["type"], "target": row["target"]})
    return out


def raw40(cfg, phone, body, label):
    remote = gaps.base.push_body(phone, bytes(body), "op15_%s.bin" % label)
    phone.adb("shell", "logcat", "-c")
    phone.broadcast("raw40", "--es", "path", remote)
    time.sleep(1.2)
    log = phone.logcat(8)
    hits = [redact(ln) for ln in log.splitlines() if "raw40" in ln or "promiscuous" in ln]
    local = cfg.out / ("raw40_%s.bin" % label)
    phone.pull_app("/data/data/%s/cache/raw40.bin" % phone.cfg.package, local)
    reply = list(local.read_bytes()[:8]) if local.is_file() else []
    fr.say(cfg, "raw40 %s reply %s %s" % (list(body), reply, " | ".join(hits)[-180:]))
    return {"body": list(body), "reply": reply, "log": hits[-4:]}


def cmdbyte(cfg, phone, cmd, data):
    phone.adb("shell", "logcat", "-c")
    phone.broadcast("cmdbyte", "--ei", "b", str(cmd), "--ei", "d", str(data))
    time.sleep(0.8)
    log = phone.logcat(6)
    token = "cmd=0x%X" % cmd
    hits = [redact(ln) for ln in log.splitlines() if token in ln]
    fr.say(cfg, "cmd %s body %s %s" % (token, data, " | ".join(hits)[-180:] if hits else "no ack line"))
    return hits[-4:]


def capture_log(cfg, phone, label, seconds, work):
    """work() runs while logcat and the rxclip are open. It must not transmit from the Armor."""
    if phone_tx(phone):
        raise SystemExit("armor is transmitting")
    if hackrf_running():
        raise SystemExit("hackrf already running")
    gaps.base.heat_ok(cfg, phone)
    phone.adb("shell", "logcat", "-c")
    log_path = cfg.out / (label + ".log")
    handle = open(log_path, "w", encoding="utf-8", errors="replace")
    log_proc = subprocess.Popen(
        [cfg.adb, "-s", cfg.serial, "logcat", "-v", "time", "-s", "RadioService:I", "DiagReceiver:I"],
        stdout=handle, stderr=subprocess.STDOUT)
    t0 = time.time()
    phone.rx_clip(label, int(seconds * 1000))
    try:
        work()
    finally:
        if hackrf_running():
            hackrf.kill()
    remain = seconds - (time.time() - t0)
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
    tones = tone_seconds(wav)
    row = {
        "label": label,
        "status": rx_status(text),
        "reports": reports(text)[:12],
        "tone_db": tones,
        "tone_peak_db": max(tones) if tones else None,
    }
    fr.say(cfg, "%s status %s tone %s" % (label, [s["body"] for s in row["status"]], row["tone_peak_db"]))
    return row


def phone_tx(phone):
    try:
        web = fr.open_web(phone)
        return bool(web.call("/api/status").get("transmitting"))
    except Exception:
        return False


def w6_row(cfg, phone, label, key_name):
    iq = cfg.out / (label + ".iq")

    def work():
        n = int(2_400_000 * CLIP_S)
        hlog = open(str(iq) + ".log", "w", encoding="utf-8")
        hf = subprocess.Popen(
            [cfg.hackrf, "-r", str(iq), "-f", "467625000", "-s", "2400000",
             "-l", "16", "-g", "16", "-n", str(n)],
            stdout=hlog, stderr=subprocess.STDOUT)
        try:
            proc = subprocess.run(
                [listen.BASH, listen.KEY, listen.NAMES[key_name]],
                capture_output=True, text=True, timeout=40)
            tail = (proc.stdout or proc.stderr or "").strip().splitlines()
            fr.say(cfg, "key %s rc %s %s" % (key_name, proc.returncode, tail[-1] if tail else ""))
            hf.wait(timeout=CLIP_S + 15)
        finally:
            if hf.poll() is None:
                hf.kill()
            hlog.close()

    row = capture_log(cfg, phone, label, CLIP_S, work)
    row["key"] = key_name
    return row


def replay_row(cfg, phone, label):
    if cfg.freq_hz != 467625000:
        raise SystemExit("replay frequency")

    def work():
        pp, np_ = rr.primer(cfg)
        proc, txlog = rr.start_tx(cfg, pp, np_, VGA)
        rr.finish_tx(proc, txlog, 1.0)
        time.sleep(0.15)
        path = rr.FILES["tg99"]
        n = path.stat().st_size // 2
        proc, txlog = rr.start_tx(cfg, path, n, VGA)
        rr.finish_tx(proc, txlog, n / rr.FS + 5)

    row = capture_log(cfg, phone, label, 16, work)
    wav = cfg.out / (label + ".wav")
    if wav.is_file():
        sig, rate = load_wav(wav)
        row["vs_tg9"] = content(REF_TG9, sig, rate)
        row["vs_idle"] = content(REF_IDLE, sig, rate)
        fr.say(cfg, "%s vs tg9 %s vs idle %s" % (label, row["vs_tg9"], row["vs_idle"]))
    return row


def finish_quiet(cfg, phone):
    raw40(cfg, phone, [15, 0], "end")
    cmdbyte(cfg, phone, 0x2F, 2)
    tx = phone_tx(phone)
    if tx:
        fr.open_web(phone).call("/api/ptt", {"down": False})
        time.sleep(0.5)
        tx = phone_tx(phone)
    return {"tag": phone.tag(), "transmitting": tx, "heat": gaps.base.heat_ok(cfg, phone)}


def self_check():
    if not REF_TG9.is_file() or not (REF_TG9.parent / "F60D_allcall.wav").is_file():
        raise SystemExit("reference wavs missing")
    sig, rate = load_wav(REF_TG9.parent / "F60D_allcall.wav")
    hit = content(REF_TG9, sig, rate)
    idle = content(REF_IDLE, sig, rate) if REF_IDLE.is_file() else {}
    print("allcall vs tg9", hit)
    print("allcall vs idle", idle)
    wave_ok = hit.get("wave") is not None and hit["wave"] >= 0.85
    lag_ok = hit.get("lag_ms") is not None and abs(hit["lag_ms"]) < 40
    if not (wave_ok and lag_ok):
        raise SystemExit("self-check")
    print("self-check ok")


def main():
    if "--self-check" in sys.argv:
        self_check()
        return
    if "--grant" not in sys.argv:
        raise SystemExit("refusing without --grant")
    key_win = Path(r"C:\Users\Joshua\AppData\Local\Temp\claude\D--Documents-code-personal-phonedmrapp\5950190b-2f56-47ee-ae7d-d56c8c611e78\scratchpad\v69\dmrkey\key.sh")
    if not key_win.is_file():
        raise SystemExit("key.sh missing")
    cfg = Config()
    if cfg.serial != "192.168.1.125:5555":
        raise SystemExit("serial")
    if cfg.freq_hz != 467625000:
        raise SystemExit("frequency")
    fr.BUSY.parent.mkdir(parents=True, exist_ok=True)
    fr.BUSY.write_text("promisc rows\n", encoding="ascii")
    phone = None
    doc = {"rows": []}
    try:
        phone = Phone(cfg)
        if not phone.ok():
            raise SystemExit("no phone")
        if hackrf_running():
            raise SystemExit("hackrf already running")
        if phone.tag() != fr.FW57_TAG:
            raise SystemExit("not on FW57")
        phone.wake()
        phone.adb("shell", "am", "start", "-n", "com.macdmr.radio/.MainActivity")
        time.sleep(2)
        web = fr.open_web(phone)
        if web.call("/api/status").get("transmitting"):
            web.call("/api/ptt", {"down": False})
            time.sleep(0.5)
        rr.scale_files(cfg)
        rr.enter_vfo(cfg, web)
        web.monitor(False)
        time.sleep(2.0)
        doc["flag_off"] = raw40(cfg, phone, [15, 0], "off")
        doc["mon_off"] = cmdbyte(cfg, phone, 0x2F, 2)
        doc["rows"].append(w6_row(cfg, phone, "p_off_tg9", "tg9"))
        doc["rows"].append(w6_row(cfg, phone, "p_off_tg99", "tg99"))
        doc["flag_on"] = raw40(cfg, phone, [15, 1], "on")
        doc["rows"].append(w6_row(cfg, phone, "p_on_tg99", "tg99"))
        doc["rows"].append(replay_row(cfg, phone, "p_on_replay99"))
        doc["mon_on"] = cmdbyte(cfg, phone, 0x2F, 1)
        doc["rows"].append(w6_row(cfg, phone, "p_on_mon_tg99", "tg99"))
        doc["flag_off_again"] = raw40(cfg, phone, [15, 0], "off2")
        doc["rows"].append(w6_row(cfg, phone, "p_off_mon_tg9", "tg9"))
        doc["end"] = finish_quiet(cfg, phone)
    finally:
        if hackrf_running():
            hackrf.kill()
        if phone is not None and doc.get("end") is None:
            try:
                doc["end"] = finish_quiet(cfg, phone)
            except BaseException as exc:
                fr.say(cfg, "cleanup failed %s" % type(exc).__name__)
        try:
            (cfg.out / "fw_promisc_rows.json").write_text(json.dumps(doc, indent=1), encoding="utf-8")
        except Exception:
            pass
        try:
            if fr.BUSY.exists():
                fr.BUSY.unlink()
        except Exception:
            pass
    end = doc.get("end") or {}
    if end.get("transmitting") or end.get("tag") not in (None, fr.FW57_TAG):
        raise SystemExit("end state")


if __name__ == "__main__":
    main()
