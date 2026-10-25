"""R-E. Receive only. Wi-Fi adb only. Does not key the phone."""
import json
import shutil
import sys
import time
from pathlib import Path

import numpy as np

sys.path.insert(0, r"D:\Documents\code\personal\phonedmrapp\tools\m17-research")
import m17  # noqa: E402

import camp
import r3a3_run
import rd10_run as r

DIR = camp.HERE / "re"
DIR.mkdir(parents=True, exist_ok=True)
OUT = DIR / "result.json"
FS = 8000


def save(doc):
    OUT.write_text(json.dumps(doc, indent=2), encoding="utf-8")


def keep(src, name):
    dest = DIR / name
    shutil.copyfile(src, dest)
    return str(dest)


def tone_clip(name, freq, ms=1600):
    iq, n = r.tone_iq(ms / 1000.0 + 0.8, float(freq))
    pcm, hit = r.play_and_clip(name, iq, n, ms)
    level = r.tone_level(pcm, freq) if pcm is not None else {"line": 0.0, "rms": 0.0}
    wav = DIR / (name + ".wav")
    camp.say("%s %d Hz line %.1f rms %.1f" % (name, freq, level["line"], level["rms"]))
    return {"line": level["line"], "rms": level["rms"], "wav": str(r.DIR / (name + ".wav")), "log": (hit or "")[-140:]}


def decode_pcm(pcm, scale):
    out = []
    if pcm is None or pcm.size < 400:
        return out
    for sign, name in ((1.0, "as_captured"), (-1.0, "inverted")):
        res = m17.decode_transmission(pcm * scale * sign, FS, verbose=False)
        lsf = res["lsf"]
        frames = res["frames"]
        golay0 = [i for i, (fn, payload, err) in enumerate(frames) if err == 0]
        out.append({
            "polarity": name,
            "lsf_crc": bool(lsf[2]) if lsf else False,
            "src": lsf[0] if lsf else None,
            "dst": lsf[1] if lsf else None,
            "frames": len(frames),
            "golay0": len(golay0),
            "all_golay0": bool(frames) and len(golay0) == len(frames),
            "frame_fn": [int(fn) & 0xFFFF for fn, payload, err in frames],
            "frame_golay": [int(err) for fn, payload, err in frames],
        })
    return out


def m17_symbols():
    lsf = m17.lsf_bytes("N0CALL", "@ALL")
    syms = list(m17.encode_lsf(lsf))
    syms += list(m17.encode_stream(lsf, 0, bytes(16), 0))
    syms += list(m17.encode_stream(lsf, 1, bytes(range(16)), 1))
    return np.array(syms, float)


def m17_iq(syms, loops=40):
    dev = m17.deviation(np.tile(syms, loops), r.old.FS_TX)
    phase = 2 * np.pi * np.cumsum(dev) / r.old.FS_TX
    z = np.exp(1j * phase)
    iq = np.empty(2 * z.size, np.int8)
    iq[0::2] = np.clip(np.round(z.real * 110), -127, 127).astype(np.int8)
    iq[1::2] = np.clip(np.round(z.imag * 110), -127, 127).astype(np.int8)
    return iq.tobytes(), z.size


def phone_m17(name, iq, n, scale):
    pcm, hit = r.play_and_clip(name, iq, n, 3000)
    dec = decode_pcm(pcm, scale)
    camp.say(name + " " + " | ".join(
        "%s crc=%s frames=%s golay0=%s" % (d["polarity"], d["lsf_crc"], d["frames"], d["golay0"]) for d in dec))
    return {"wav": str(r.DIR / (name + ".wav")), "log": (hit or "")[-140:], "decode": dec}


def peak_freq(x, expect, fs=FS):
    x = np.asarray(x, np.float64)
    x = x - np.mean(x)
    spec = np.abs(np.fft.rfft(x * np.hanning(x.size)))
    freqs = np.fft.rfftfreq(x.size, 1.0 / fs)
    band = (freqs > expect * 0.8) & (freqs < expect * 1.2)
    idx = np.flatnonzero(band)
    k = idx[int(np.argmax(spec[band]))]
    if 0 < k < spec.size - 1:
        a, b, c = spec[k - 1], spec[k], spec[k + 1]
        den = a - 2 * b + c
        delta = 0.5 * (a - c) / den if den != 0 else 0.0
    else:
        delta = 0.0
    return float(freqs[k] + delta * (freqs[1] - freqs[0]))


def capture_six(name, freq=None, iq=None, n=None):
    if iq is None:
        iq, n = r.tone_iq(2.6, float(freq))
    path = DIR / (name + ".cs8")
    path.write_bytes(iq)
    proc, hlog = r.old.start_tx(path, n, r.VGA)
    time.sleep(0.45)
    hit, got = r.ask_rx(4, 6)
    r.old.finish_tx(proc, hlog, n / r.old.FS_TX)
    src = r.DIR / "rx_m4_n6.bin"
    named = keep(src, name + ".bin") if src.exists() else ""
    halves = [p["half"] for p in got]
    seqs = [p["seq"] for p in got]
    camp.say("%s halves %s seq %s" % (name, halves, seqs))
    return {"log": hit[-160:], "bin": named, "halves": halves, "seqs": seqs, "parts": got}


def tone_stats(got, freq):
    if len(got) != 6:
        return {"n": len(got)}
    x = np.concatenate([p["samples"] for p in got])
    x = x - np.mean(x)
    ln = r.line(x, freq)
    rms = float(np.sqrt(np.mean(x ** 2)))
    return {"n": 6, "line": ln, "rms": rms, "rms_over_line": rms / ln if ln else None,
            "peak_hz": peak_freq(x, freq)}


def fit_310(got):
    if len(got) != 6:
        return {"n": len(got)}
    x = np.concatenate([p["samples"] for p in got]).astype(np.float64)
    t = np.arange(x.size) / FS
    s = np.sin(2 * np.pi * 310.0 * t)
    c = np.cos(2 * np.pi * 310.0 * t)
    A = np.column_stack([s, c, np.ones_like(t)])
    coef, *_ = np.linalg.lstsq(A, x, rcond=None)
    resid = x - A @ coef
    per = []
    for h in range(6):
        sl = resid[h * 256:(h + 1) * 256]
        per.append(float(np.sqrt(np.mean(sl ** 2))))
    d = np.abs(np.diff(x))
    step_at = int(np.argmax(d))
    return {"residual_rms": per, "step_index": step_at, "step": float(d[step_at]),
            "median_step": float(np.median(d)), "amp": float(np.hypot(coef[0], coef[1]))}


def symbol_map(got, known, scale):
    if len(got) != 6:
        return {"n": len(got)}
    x = np.concatenate([p["samples"] for p in got])
    dev = x * scale
    y, sps = m17.demod(dev, FS, eq=None)
    levels = np.array([-3, -1, 1, 3], float) * 800.0
    best = None
    period = len(known)
    span = period * sps
    if y.size < span + sps:
        return {"n": 6, "short": int(y.size), "sps": int(sps)}
    for off in range(span):
        sl = y[off:off + span:sps]
        if sl.size < period:
            continue
        q = levels[np.argmin(np.abs(sl[:period, None] - levels), axis=1)] / 800.0
        err = np.round(q).astype(int) != np.round(known).astype(int)
        nerr = int(np.sum(err))
        if best is None or nerr < best[0]:
            best = (nerr, off, err, q)
    nerr, off, err, q = best
    where = []
    for i in np.flatnonzero(err):
        sample = (off + i * sps) * FS / 48000.0
        half_at = 256.0
        dist_samples = min(abs(sample - half_at * k) for k in range(0, 7))
        where.append({"i": int(i % 192), "frame_i": int(i // 192),
                      "dist_samples": float(dist_samples)})
    return {"n": 6, "errors": nerr, "symbols": period, "rate": nerr / period,
            "offset": int(off), "sps": int(sps), "where": where[:80],
            "where_n": len(where)}


def main():
    if camp.SER != "192.168.1.125:5555":
        raise SystemExit("refusing " + camp.SER)
    r3a3_run.devices_ok()
    if camp.hackrf_running():
        raise SystemExit("hackrf running")
    camp.adb("shell", "input", "keyevent", "224")
    camp.adb("shell", "am", "start", "-n", "com.macdmr.radio/.MainActivity")
    time.sleep(3)
    camp.tune()
    doc = {"adb": camp.SER}
    r.old.dummy(r.VGA)
    syms = m17_symbols()
    iq, n = m17_iq(syms)
    doc["hold"] = r.hold(3, 1)
    doc["hz100_before"] = tone_clip("re_h3_before", 100)
    doc["hz1k_held"] = tone_clip("re_h3_1k", 1000)
    scale = 2500.0 / doc["hz1k_held"]["line"] if doc["hz1k_held"]["line"] else 0.4
    doc["phone_scale"] = scale
    doc["phone_m17"] = []
    for i in range(3):
        doc["phone_m17"].append(phone_m17("re_phone_m17_%d" % i, iq, n, scale))
        save(doc)
    doc["hz100_after_m17"] = tone_clip("re_h3_after", 100)
    save(doc)
    camp.tune()
    doc["hz100_after_tune"] = tone_clip("re_h3_tuned", 100)
    doc["hold_again"] = r.hold(3, 1)
    doc["hz100_reheld"] = tone_clip("re_h3_reheld", 100)
    r.hold(3, 0)
    doc["phone_plain"] = phone_m17("re_phone_plain", iq, n, 2500.0 / 6529.7)
    save(doc)

    doc["khz"] = []
    for i in range(5):
        cap = capture_six("re_1k_%d" % i, freq=1000)
        st = tone_stats(cap.pop("parts"), 1000)
        cap.update(st)
        doc["khz"].append(cap)
        camp.say("1k %d line %.1f rms %.1f peak %.2f" % (i, st.get("line", 0), st.get("rms", 0), st.get("peak_hz", 0)))
        save(doc)
    lines = [c["line"] for c in doc["khz"] if c.get("line")]
    ram_scale = 2500.0 / float(np.median(lines)) if lines else 0.5
    doc["ram_scale"] = ram_scale

    doc["hz310"] = []
    for i in range(3):
        cap = capture_six("re_310_%d" % i, freq=310)
        cap.update(fit_310(cap.pop("parts")))
        doc["hz310"].append(cap)
        camp.say("310 %d step %s at %s" % (i, cap.get("step"), cap.get("step_index")))
        save(doc)

    doc["ram_m17"] = []
    miq, mn = m17_iq(syms, loops=20)
    for i in range(3):
        cap = capture_six("re_m17ram_%d" % i, iq=miq, n=mn)
        parts = cap.pop("parts")
        cap["symbols"] = symbol_map(parts, syms, ram_scale)
        doc["ram_m17"].append(cap)
        camp.say("m17ram %d rate %s" % (i, cap["symbols"].get("rate")))
        save(doc)
    camp.tune()
    doc["end"] = time.strftime("%H:%M:%S")
    save(doc)
    camp.say("R-E capture done")


if __name__ == "__main__":
    try:
        main()
    finally:
        r.restore_hold()
        if camp.hackrf_running():
            camp.kill_hackrf()
