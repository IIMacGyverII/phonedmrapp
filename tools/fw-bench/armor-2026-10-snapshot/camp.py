# FW17/FW18 bench campaign. Receive-only HackRF. Phone TX only on 467.625 MHz, low power.
# One capture at a time, in the foreground: start hackrf_transfer, then key, then wait until it exits.
import json, math, os, struct, subprocess, sys, time, wave
from pathlib import Path

import numpy as np

REPO = Path(r"D:\Documents\code\personal\phonedmrapp")
sys.path.insert(0, str(REPO / "tools" / "m17-research"))
sys.path.insert(0, str(REPO / "tools" / "pocsag-research"))
import m17
import pocsag as pc

HERE = Path(r"C:\Users\Joshua\AppData\Local\Temp\fw1718")
CAP = HERE / "caps"
WAV = HERE / "wav"
CAP.mkdir(exist_ok=True)
WAV.mkdir(exist_ok=True)
ADB = str(Path(os.environ["LOCALAPPDATA"]) / "Android" / "Sdk" / "platform-tools" / "adb.exe")
HACKRF = r"C:\Users\Joshua\tools\hackrf\hackrf_transfer.exe"
BASH = r"C:\Program Files\Git\bin\bash.exe"
# Wi-Fi only. The USB port is for a second device. Do not fall back to 5006AF1020002922.
SER = "192.168.1.125:5555"
UID = "10200"
FACTORY = REPO / "radio_firmware" / "DMR003.UV4T.V022-ORIGINAL.bin"
BUILD = REPO / "radio_firmware" / "build"
STATE = HERE / "state.json"
LOG = HERE / "camp.log"

FS_IQ, OFF, DEC, FS_A = 2_400_000, 240_000, 50, 48_000
LEAD = 2.0          # seconds of silence: the radio passes audio only ~1.5 s after key-up
TONE_S, GAP_S = 1.0, 0.15
FREQS = [50, 100, 150, 200, 300, 500, 1000, 2000, 3000, 3500]
LIM_DB = [30, 24, 18, 12, 6, 0]
STOP_HZ = 5000.0
M17_FRAMES = 90
PAGES = [(1234567, "BENCH PAGE ONE"), (200001, "BENCH PAGE TWO"), (777777, "BENCH PAGE THREE")]

gain_l, gain_g = 16, 16
logf = open(LOG, "a", encoding="utf-8", buffering=1)


def say(m):
    line = time.strftime("%H:%M:%S ") + str(m)
    print(line, flush=True)
    logf.write(line + "\n")


def load_state():
    if STATE.exists():
        return json.loads(STATE.read_text(encoding="utf-8"))
    return {"image": "unknown", "results": {}, "gain": [16, 16]}


def save_state(st):
    STATE.write_text(json.dumps(st, indent=2), encoding="utf-8")


def adb(*args, timeout=60):
    r = subprocess.run([ADB, "-s", SER, *args], capture_output=True, timeout=timeout)
    out = (r.stdout or b"").decode("utf-8", "replace") + (r.stderr or b"").decode("utf-8", "replace")
    return r.returncode, out


def broadcast(extra):
    return adb("shell", "am", "broadcast", "-a", "com.macdmr.radio.DIAG", *extra)


def logcat_since(seconds=30):
    _, out = adb("shell", "logcat", "-d", "-t", str(seconds * 40), "-s", "RadioService:I", "DiagReceiver:I", "YModemManager:I")
    return out


def hackrf_running():
    r = subprocess.run(["tasklist", "/FI", "IMAGENAME eq hackrf_transfer.exe", "/NH"], capture_output=True, text=True)
    return "hackrf_transfer" in r.stdout.lower()


def kill_hackrf():
    subprocess.run(["taskkill", "/F", "/IM", "hackrf_transfer.exe"], capture_output=True)
    time.sleep(1)
    return hackrf_running()


def write_wav(path, samples):
    x = np.clip(np.round(samples), -32767, 32767).astype("<i2")
    data = x.tobytes()
    hdr = struct.pack("<4sI4s4sIHHIIHH4sI", b"RIFF", 36 + len(data), b"WAVE", b"fmt ", 16, 1, 1, 8000, 16000, 2, 16, b"data", len(data))
    assert len(hdr) == 44
    path.write_bytes(hdr + data)
    return len(x) / 8000


def db_amp(db):
    return int(round(32767 * 10 ** (-db / 20)))


def tone_pcm(freq, seconds, amp, fade=0.008):
    n = int(round(8000 * seconds))
    t = np.arange(n) / 8000
    y = amp * np.sin(2 * np.pi * freq * t)
    nf = int(8000 * fade)
    if 0 < nf < n // 4:
        r = np.linspace(0, 1, nf)
        y[:nf] *= r
        y[-nf:] *= r[::-1]
    return y


def build_sweep(db):
    amp = db_amp(db)
    parts = []
    t = LEAD
    chunks = [np.zeros(int(8000 * LEAD))]
    for f in FREQS:
        parts.append({"hz": f, "t0": t, "t1": t + TONE_S})
        chunks.append(tone_pcm(f, TONE_S, amp))
        chunks.append(np.zeros(int(8000 * GAP_S)))
        t += TONE_S + GAP_S
    x = np.concatenate(chunks)
    meta = {"kind": "sweep", "db": db, "amp": amp, "parts": parts}
    return x, meta


def build_edge(db):
    """50/100/200/300 Hz only, for the three-level check near the cut."""
    amp = db_amp(db)
    parts = []
    t = LEAD
    chunks = [np.zeros(int(8000 * LEAD))]
    for f in (50, 100, 200, 300):
        parts.append({"hz": f, "t0": t, "t1": t + TONE_S})
        chunks.append(tone_pcm(f, TONE_S, amp))
        chunks.append(np.zeros(int(8000 * GAP_S)))
        t += TONE_S + GAP_S
    x = np.concatenate(chunks)
    meta = {"kind": "edge", "db": db, "amp": amp, "parts": parts}
    return x, meta


def build_limiter(db):
    amp = db_amp(db)
    x = np.concatenate([np.zeros(int(8000 * LEAD)), tone_pcm(1000, TONE_S, amp)])
    meta = {"kind": "limiter", "db": db, "amp": amp, "parts": [{"hz": 1000, "t0": LEAD, "t1": LEAD + TONE_S}]}
    return x, meta


def build_probe():
    amp = db_amp(36)
    x = np.concatenate([
        np.zeros(int(8000 * LEAD)),
        tone_pcm(1000, 0.8, amp),
        np.zeros(int(8000 * 0.2)),
        tone_pcm(3500, 0.8, amp),
    ])
    meta = {"kind": "probe", "db": 36, "amp": amp, "parts": [
        {"hz": 1000, "t0": LEAD, "t1": LEAD + 0.8},
        {"hz": 3500, "t0": LEAD + 1.0, "t1": LEAD + 1.8},
    ]}
    return x, meta


def build_m17(amp):
    rng = np.random.RandomState(1718)
    pay = [bytes(rng.randint(0, 256, 16, dtype=np.uint8)) for _ in range(M17_FRAMES)]
    syms, _lsf = m17.transmission("N0CALL", "N0CALL", pay, eot=True)
    dev = m17.deviation(syms, 8000)          # Hz; a long run of +3 is +2400 Hz
    # amp is the PCM peak that should become +2400 Hz on a path with the factory 1 kHz gain
    scale = amp / 2400.0
    pcm = dev * scale
    peak = float(np.max(np.abs(pcm)))
    if peak > 30000:
        raise SystemExit("M17 PCM peak %.0f is too hot to send" % peak)
    x = np.concatenate([np.zeros(int(8000 * LEAD)), pcm])
    meta = {"kind": "m17", "amp_per_2400": amp, "pcm_peak": peak, "frames": M17_FRAMES, "seed": 1718,
            "audio_t0": LEAD, "audio_s": len(pcm) / 8000}
    np.save(WAV / "m17_dev.npy", dev.astype(np.float32))
    (WAV / "m17_pay.json").write_text(json.dumps([p.hex() for p in pay]), encoding="utf-8")
    return x, meta


def build_pocsag(baud, amp):
    bits = []
    for ric, msg in PAGES:
        bits += pc.transmission(ric, 3, msg)
    spb = 8000 / baud
    nrz = np.concatenate([np.full(int(round((i + 1) * spb)) - int(round(i * spb)), -1.0 if b else 1.0) for i, b in enumerate(bits)])
    x = np.concatenate([np.zeros(int(8000 * LEAD)), nrz * amp])
    if len(x) > 8000 * 27:
        raise RuntimeError("POCSAG file is %.1f s; the firmware cuts at 30 s" % (len(x) / 8000))
    meta = {"kind": "pocsag", "baud": baud, "amp": amp, "bits": len(bits), "audio_t0": LEAD, "audio_s": len(nrz) / 8000,
            "pages": [{"ric": r, "msg": m} for r, m in PAGES]}
    (WAV / ("poc%d.bits" % baud)).write_text("".join(map(str, bits)), encoding="utf-8")
    return x, meta


def build_voice(amp_peak):
    src = WAV / "speech_src.wav"
    if not src.exists():
        ps = (
            "Add-Type -AssemblyName System.Speech; "
            "$s = New-Object System.Speech.Synthesis.SpeechSynthesizer; "
            "$s.Rate = -1; $s.SetOutputToWaveFile('%s'); "
            "$s.Speak('Testing the transmit audio path. One. Two. Three. Four. Five.'); $s.Dispose()"
        ) % str(src)
        subprocess.run(["powershell", "-NoProfile", "-Command", ps], check=True)
    w = wave.open(str(src))
    raw = np.frombuffer(w.readframes(w.getnframes()), dtype="<i2").astype(np.float64)
    ch, fs = w.getnchannels(), w.getframerate()
    w.close()
    if ch > 1:
        raw = raw.reshape(-1, ch).mean(axis=1)
    # trim silence
    nz = np.nonzero(np.abs(raw) > 200)[0]
    raw = raw[max(0, nz[0] - int(0.05 * fs)): nz[-1] + int(0.1 * fs)]
    n = int(len(raw) * 8000 / fs)
    y = np.interp(np.linspace(0, len(raw) - 1, n), np.arange(len(raw)), raw)
    y *= amp_peak / (np.max(np.abs(y)) + 1e-9)
    x = np.concatenate([np.zeros(int(8000 * LEAD)), y])
    meta = {"kind": "voice", "amp_peak": amp_peak, "audio_t0": LEAD, "audio_s": len(y) / 8000}
    return x, meta


def save_stimulus(name, samples, meta):
    path = WAV / (name + ".wav")
    dur = write_wav(path, samples)
    meta["seconds"] = dur
    meta["name"] = name
    (WAV / (name + ".json")).write_text(json.dumps(meta), encoding="utf-8")
    np.save(WAV / (name + ".npy"), np.clip(np.round(samples), -32767, 32767).astype(np.int16))
    return path, dur, meta


def install_wav(path, name):
    remote = "/data/local/tmp/tx_%s.wav" % name
    rc, out = adb("push", str(path), remote, timeout=60)
    if rc != 0:
        raise RuntimeError("push failed " + out)
    cmd = (
        "cp %s /data/data/com.macdmr.radio/cache/tx_%s.wav && "
        "chown %s:%s /data/data/com.macdmr.radio/cache/tx_%s.wav && "
        "chmod 600 /data/data/com.macdmr.radio/cache/tx_%s.wav && "
        "ls -l /data/data/com.macdmr.radio/cache/tx_%s.wav"
    ) % (remote, name, UID, UID, name, name, name)
    rc, out = adb("shell", "su --mount-master --context u:r:magisk:s0 -c '%s'" % cmd, timeout=30)
    say("install %s -> %s" % (name, out.strip().splitlines()[-1] if out.strip() else "rc %d" % rc))
    if rc != 0 or "tx_%s.wav" % name not in out:
        raise RuntimeError("cache copy failed: " + out)


def demod(iq_path):
    iq = np.fromfile(iq_path, dtype=np.int8)
    if len(iq) < FS_IQ:
        raise RuntimeError("capture too short: %d bytes" % len(iq))
    z = iq[0::2].astype(np.float32) + 1j * iq[1::2].astype(np.float32)
    del iq
    out = []
    for s0 in range(0, len(z) - DEC, FS_IQ):
        seg = z[s0:s0 + FS_IQ]
        m = len(seg) // DEC * DEC
        ph = np.exp((-2j * np.pi * OFF / FS_IQ) * np.arange(s0, s0 + m)).astype(np.complex64)
        out.append((seg[:m] * ph).reshape(-1, DEC).mean(axis=1))
    zd = np.concatenate(out)
    k = np.sinc(np.arange(-64, 65) * 2 * 9000 / FS_A) * np.blackman(129)
    k /= k.sum()
    zd = np.convolve(zd, k, "same")
    dev = np.angle(zd[1:] * np.conj(zd[:-1])) * FS_A / (2 * np.pi)
    pw = np.convolve(np.abs(zd) ** 2, np.ones(4800) / 4800, "same")
    floor = np.percentile(pw, 10)
    on = pw > max(floor * 20, 1e-6)
    if on.any():
        i0 = int(np.argmax(on))
        i1 = int(len(on) - np.argmax(on[::-1]))
    else:
        i0, i1 = 0, len(dev)
    # raw magnitude on the keyed samples (before the 9 kHz filter, at 48 kHz)
    mag = np.abs(zd)
    keyed = mag[i0:i1] if i1 > i0 + 100 else mag
    mean_mag = float(np.mean(keyed))
    clip = float(np.mean(np.abs(z) >= 126))
    snr = 10 * np.log10((np.median(pw[i0:i1]) + 1e-12) / (floor + 1e-12)) if i1 > i0 else 0
    offset = float(np.median(dev[i0:i1])) if i1 > i0 + 100 else float("nan")
    dev = dev - offset
    info = {"mean_mag": mean_mag, "clip_frac": clip, "snr_db": float(snr), "offset_hz": offset,
            "keyed_s": (i1 - i0) / FS_A, "i0": i0, "n": int(len(z))}
    return dev, info


def goertzel_peak(x, fs, f0):
    n = np.arange(len(x))
    w = np.hanning(len(x))
    c = np.sum(w * x * np.exp(-2j * np.pi * f0 * n / fs))
    return float(2 * np.abs(c) / (np.sum(w) + 1e-12))


def carrier_bounds(info, n):
    i0 = int(info.get("i0", 0))
    i1 = i0 + int(float(info.get("keyed_s", 0)) * FS_A)
    return max(0, i0), min(n, max(i1, i0 + 1))


def align_tones(dev, info, meta):
    """Lag of PCM[0] inside the deviation, from the tone schedule.

    The search stays inside the keyed carrier. Off-air discriminator noise is
    tens of kHz and must not be treated as deviation. Score is the sum of the
    tone fundamentals, so a click after unkey cannot win.
    """
    i0, i1 = carrier_bounds(info, len(dev))
    lo = max(0, i0 - int(0.5 * FS_A))
    hi = min(len(dev) - int(0.4 * FS_A), i0 + int(2.4 * FS_A))
    parts = meta["parts"]
    step = int(0.02 * FS_A)
    best = None
    for L in range(lo, max(lo + 1, hi), step):
        score = 0.0
        ok = True
        for part in parts:
            a = L + int((part["t0"] + 0.2) * FS_A)
            b = L + int((part["t1"] - 0.2) * FS_A)
            if b - a < int(0.2 * FS_A) or a < i0 or b > i1:
                ok = False
                break
            mid = (a + b) // 2
            w = min(int(0.25 * FS_A), (b - a) // 2)
            weight = 3.0 if part["hz"] == 1000 else 1.0
            score += weight * goertzel_peak(dev[mid - w:mid + w], FS_A, part["hz"])
        if ok and (best is None or score > best[0]):
            best = (score, L)
    if best is None:
        return lo, 0.0
    return best[1], best[0]


def align_corr(dev, pcm, info):
    """Signed correlation, lags limited to just after key-up."""
    ref = np.repeat(pcm.astype(np.float32), 6)
    i0, i1 = carrier_bounds(info, len(dev))
    lo = max(0, i0 - int(0.5 * FS_A))
    hi = min(len(dev) - min(len(ref), int(0.5 * FS_A)), i0 + int(2.4 * FS_A))
    # decimate 6x so the search is cheap, then refine
    d6 = dev[::6]
    r6 = ref[::6]
    best = (0.0, lo)
    for L in range(lo, max(lo + 1, hi), int(0.01 * FS_A)):
        k = L // 6
        m = min(len(r6), len(d6) - k)
        if m < 100:
            continue
        x = d6[k:k + m]
        y = r6[:m]
        r = float(np.dot(x, y) / (np.linalg.norm(x) * np.linalg.norm(y) + 1e-9))
        if abs(r) > abs(best[0]):
            best = (r, L)
    return best[1], best[0]


def window_dev(dev, lag, t0, t1, f0, info):
    i0, i1 = carrier_bounds(info, len(dev))
    a = lag + int((t0 + 0.12) * FS_A)
    b = lag + int((t1 - 0.08) * FS_A)
    a = max(i0, min(a, len(dev) - 10))
    b = max(a + 10, min(b, i1, len(dev)))
    seg = dev[a:b]
    peak = goertzel_peak(seg, FS_A, f0) if len(seg) > 20 else 0.0
    p = float(np.percentile(np.abs(seg), 99.5)) if len(seg) else 0.0
    return peak, p, seg


def analyze_tones(dev, info, meta, pcm):
    lag, score = align_tones(dev, info, meta)
    rows = []
    worst = 0.0
    for part in meta["parts"]:
        peak, p99, _seg = window_dev(dev, lag, part["t0"], part["t1"], part["hz"], info)
        # The stop uses the tone fundamental. p99 of a weak carrier is discriminator
        # noise, and p99 outside the carrier is the off-air ±24 kHz hash.
        worst = max(worst, peak)
        rows.append({"hz": part["hz"], "peak_hz": round(peak, 1), "p99_hz": round(p99, 1)})
    ref_rows = [r for r in rows if r["hz"] == 1000]
    ref = ref_rows[0]["peak_hz"] if ref_rows else 0
    for r in rows:
        r["db"] = None if ref < 5 else round(20 * np.log10((r["peak_hz"] + 0.1) / ref), 2)
    return {"lag_s": lag / FS_A, "corr": score, "rows": rows, "worst_hz": worst, "carrier": info}


def align_energy(dev, info, lead_s, audio_s):
    """Lag of PCM[0]. The radio's filters wipe the waveform shape, so line up the
    loud part with the audio and the quiet part with the lead-in. Key-up and
    unkey clicks sit outside both windows and are not counted as deviation."""
    i0, i1 = carrier_bounds(info, len(dev))
    i0e, i1e = i0 + int(0.15 * FS_A), i1 - int(0.12 * FS_A)
    lead, audio = int(lead_s * FS_A), int(audio_s * FS_A)
    lo = max(0, i0 - int(0.4 * FS_A))
    hi = min(len(dev) - lead - int(0.3 * FS_A), i0 + int(2.6 * FS_A))
    best = None
    for L in range(lo, max(lo + 1, hi), int(0.01 * FS_A)):
        s0, s1 = L + lead, L + lead + audio
        if s0 < i0e or s1 > i1e or s1 - s0 < int(0.3 * FS_A):
            continue
        z0 = max(i0e, s0 - int(0.4 * FS_A))
        if s0 - z0 < int(0.15 * FS_A):
            continue
        quiet = float(np.sqrt(np.mean(dev[z0:s0] ** 2)))
        loud = float(np.sqrt(np.mean(dev[s0:s1] ** 2)))
        score = loud - quiet
        if best is None or score > best[0]:
            best = (score, L)
    if best is None:
        return lo, 0.0
    return best[1], best[0]


def analyze_m17(dev, info, meta, pcm):
    ref = np.load(WAV / "m17_dev.npy")
    audio_s = len(ref) / 8000
    lag, corr = align_energy(dev, info, LEAD, audio_s)
    ref48 = np.repeat(ref.astype(np.float32), 6)
    a = lag + int(LEAD * FS_A)
    _i0, i1 = carrier_bounds(info, len(dev))
    seg = dev[a:min(a + len(ref48), i1 - int(0.05 * FS_A))]
    if len(seg) < len(ref48) * 0.8:
        return {"error": "short", "corr": corr, "worst_hz": 0, "lag_s": lag / FS_A, "carrier": info}
    n = min(len(seg), len(ref48))
    slope = float(np.dot(seg[:n], ref48[:n]) / (np.dot(ref48[:n], ref48[:n]) + 1e-9))
    outer = abs(slope) * 2400
    body = seg[:n]
    # p99.5 of the aligned audio. The key-up click is outside this window.
    worst = float(np.percentile(np.abs(body), 99.5))
    p95 = float(np.percentile(np.abs(body), 95))
    pay = [bytes.fromhex(h) for h in json.loads((WAV / "m17_pay.json").read_text())]
    def score(sig):
        # decode a bit of margin before the audio
        s0 = max(0, a - int(0.25 * FS_A))
        r = m17.decode_transmission(sig[s0:a + len(ref48) + int(0.3 * FS_A)], FS_A, verbose=False)
        good = sum(1 for (fn, p, _le) in r["frames"] if (fn & 0x7FFF) < len(pay) and p == pay[fn & 0x7FFF])
        lsf = r["lsf"]
        return {"found": len(r["frames"]), "exact": good, "sent": len(pay),
                "lsf": None if lsf is None else {"src": lsf[0], "dst": lsf[1], "crc": bool(lsf[2])}}
    plain = score(dev)
    flipped = score(-dev)
    return {"lag_s": lag / FS_A, "corr": corr, "outer_hz": outer, "slope": slope,
            "p95_hz": p95, "p995_hz": worst, "worst_hz": worst,
            "plain": plain, "inverted": flipped, "carrier": info}


def analyze_pocsag(dev, info, meta, pcm):
    lag, corr = align_energy(dev, info, meta["audio_t0"], meta["audio_s"])
    baud = meta["baud"]
    bits = np.array([int(c) for c in (WAV / ("poc%d.bits" % baud)).read_text().strip()])
    spb = FS_A / baud
    a = lag + int(LEAD * FS_A)
    n = int(len(bits) * spb)
    _i0, i1 = carrier_bounds(info, len(dev))
    seg = dev[a:min(len(dev), i1 - int(0.08 * FS_A), a + n + int(spb))]
    worst = float(np.percentile(np.abs(seg), 99.5)) if len(seg) else 0
    def decode(sig):
        best = None
        for ph in np.linspace(0, spb, 16, endpoint=False):
            idx = (np.arange(len(bits)) * spb + ph).astype(int)
            idx = idx[idx < len(sig)]
            got = [1 if sig[k] < 0 else 0 for k in idx]     # lower frequency is a 1
            # compare as a bit string against the sent bits, and also run the pager decoder
            m = min(len(got), len(bits))
            err = int((np.array(got[:m]) != bits[:m]).sum())
            batches = pc.decode_bits(got)
            msgs = pc.messages(batches)
            if best is None or err < best[0]:
                best = (err, m, msgs, ph)
        return best
    if len(seg) < n * 0.5:
        return {"error": "short", "corr": corr, "worst_hz": worst, "carrier": info}
    e1, m1, msgs1, ph1 = decode(seg)
    e2, m2, msgs2, ph2 = decode(-seg)
    want = {(r, t) for r, t in PAGES}
    def hits(msgs):
        got = {(ric, txt) for ric, _fn, txt in msgs}
        return sorted(got & want), sorted(got)
    h1, g1 = hits(msgs1)
    h2, g2 = hits(msgs2)
    return {"lag_s": lag / FS_A, "corr": corr, "p995_hz": worst, "worst_hz": worst,
            "plain": {"bit_errors": e1, "bits": m1, "pages": h1, "decoded": g1, "phase": ph1},
            "inverted": {"bit_errors": e2, "bits": m2, "pages": h2, "decoded": g2, "phase": ph2},
            "carrier": info}


def analyze_voice(dev, info, meta, pcm):
    lag, corr = align_energy(dev, info, meta["audio_t0"], meta["audio_s"])
    a = lag + int(meta["audio_t0"] * FS_A)
    b = a + int(meta["audio_s"] * FS_A)
    i0, i1 = carrier_bounds(info, len(dev))
    seg = dev[max(i0 + int(0.05 * FS_A), a):min(len(dev), i1 - int(0.08 * FS_A), b)]
    worst = float(np.percentile(np.abs(seg), 99.5)) if len(seg) else 0
    # keep the demodulated audio: ±5000 Hz -> full scale
    y = np.clip(seg * (32767 / 5000), -32767, 32767).astype("<i2")
    return {"lag_s": lag / FS_A, "corr": corr, "p995_hz": worst, "worst_hz": worst,
            "rms_hz": float(np.sqrt(np.mean(seg ** 2))) if len(seg) else 0,
            "audio": y, "carrier": info}


def capture_and_key(name, seconds):
    """Start a finite receive, then key the phone. Never uses -R or -t."""
    global gain_l, gain_g
    if hackrf_running():
        raise RuntimeError("hackrf_transfer already running; not starting another")
    n = int(FS_IQ * (seconds + 3.2))
    path = CAP / ("%s.iq" % name)
    if path.exists():
        path.unlink()
    say("capture %s  n=%d  l=%d g=%d  (%.1f s)" % (name, n, gain_l, gain_g, n / FS_IQ))
    hlog = open(CAP / (name + ".hackrf.log"), "w", encoding="utf-8", errors="replace")
    proc = subprocess.Popen(
        [HACKRF, "-r", str(path), "-f", "467385000", "-s", "2400000", "-l", str(gain_l), "-g", str(gain_g), "-n", str(n)],
        stdout=hlog, stderr=subprocess.STDOUT)
    time.sleep(0.8)
    if proc.poll() is not None:
        hlog.close()
        out = (CAP / (name + ".hackrf.log")).read_text(encoding="utf-8", errors="replace")
        raise RuntimeError("hackrf exited before key-up: " + out[-500:])
    rc, bout = broadcast(["--es", "cmd", "txwav", "--es", "name", name])
    say("txwav %s broadcast rc=%d %s" % (name, rc, bout.strip().replace("\n", " ")[:180]))
    try:
        proc.wait(timeout=seconds + 25)
    except subprocess.TimeoutExpired:
        proc.kill()
        hlog.close()
        still = kill_hackrf()
        raise RuntimeError("hackrf stalled (still running: %s)" % still)
    hlog.close()
    tail = (CAP / (name + ".hackrf.log")).read_text(encoding="utf-8", errors="replace")[-300:]
    if proc.returncode not in (0, None):
        say("hackrf rc %s %s" % (proc.returncode, tail))
    if hackrf_running():
        raise RuntimeError("hackrf_transfer still running after the capture")
    if not path.exists() or path.stat().st_size < n * 2 * 0.8:
        raise RuntimeError("capture short or missing (%s)" % (path.stat().st_size if path.exists() else 0))
    time.sleep(0.6)   # let the radio finish unkeying before the next command
    text = logcat_since(15)
    hits = [ln for ln in text.splitlines() if "bench wav" in ln or "txwav" in ln or "does not answer" in ln or "stopped answering" in ln]
    say("tx log: " + " | ".join(h.strip()[-140:] for h in hits[-4:]))
    if any("does not answer" in h or "stopped answering" in h for h in hits[-4:]):
        raise RuntimeError("module stopped answering")
    return path


def tune():
    t0 = time.time()
    rc, out = broadcast(["--es", "cmd", "vfo", "--ei", "hz", "467625000"])
    say("vfo %s %s" % (rc, out.strip().replace("\n", " ")[:160]))
    seen = None
    while time.time() - t0 < 8:
        text = logcat_since(15)
        if "stopped answering" in text or "does not answer" in text:
            raise RuntimeError("module stopped answering after tune")
        hits = [ln for ln in text.splitlines() if "VFO" in ln and "467.625" in ln]
        if hits:
            seen = hits[-1].strip()
            break
        time.sleep(0.4)
    remain = 4.0 - (time.time() - t0)
    if remain > 0:
        time.sleep(remain)
    if not seen:
        raise RuntimeError("VFO 467.625 was not confirmed; not keying")
    say("tuned " + seen[-140:])


def vfo_off():
    broadcast(["--es", "cmd", "vfooff"])
    time.sleep(1.5)
    say("vfooff")


def read_version(power_cycle=False):
    if power_cycle:
        broadcast(["--es", "cmd", "restartmodule"])
        say("restartmodule sent, waiting for 0x34")
        time.sleep(8)
    deadline = time.time() + (25 if power_cycle else 8)
    last = ""
    while time.time() < deadline:
        text = logcat_since(40)
        hits = [ln for ln in text.splitlines() if "module DMR" in ln]
        if hits:
            last = hits[-1]
            if "DMR003." in last:
                ver = last.split("module ")[-1].strip()
                say("0x34 %s" % ver)
                return ver
        time.sleep(1)
    raise RuntimeError("no 0x34 answer (%s)" % last)


def load_image(bin_path):
    # fwload_stock.sh sets MSYS_NO_PATHCONV, so adb.exe must see a Windows path.
    gitp = str(bin_path).replace("\\", "/")
    say("loading %s" % bin_path.name)
    env = os.environ.copy()
    env["DEV"] = SER
    env["MSYS_NO_PATHCONV"] = "1"
    r = subprocess.run([BASH, "tools/fw-patch/bench/fwload_stock.sh", gitp], cwd=str(REPO), env=env,
                       capture_output=True, text=True, timeout=420)
    say(r.stdout.strip())
    if r.returncode != 0:
        say(r.stderr[-500:])
        raise RuntimeError("load failed rc %d" % r.returncode)
    ver = ""
    for ln in r.stdout.splitlines():
        if "0x34:" in ln and "DMR003." in ln:
            ver = ln.split("module ")[-1].strip() if "module " in ln else ln.split("0x34:")[-1].strip()
    if "DMR003." not in ver:
        ver = read_version(power_cycle=False)
    # the loader's grep line is "0x34: <log line>". Pull the version token.
    import re
    m = re.search(r"DMR003\.[A-Za-z0-9]{4}\.V022", r.stdout + " " + ver)
    if not m:
        raise RuntimeError("load finished but no version token in: " + r.stdout[-400:])
    say("loaded tag read as %s" % m.group(0))
    return m.group(0)


def expect_version(got, want):
    if want not in got:
        raise RuntimeError("version %s, wanted %s" % (got, want))


def send_one(name, samples, meta, analyze):
    path, dur, meta = save_stimulus(name, samples, meta)
    install_wav(path, name)
    iq = capture_and_key(name, dur)
    dev, info = demod(iq)
    say("carrier %.2f s  mag %.1f  clip %.4f  snr %.1f dB  offset %+.0f Hz" % (
        info["keyed_s"], info["mean_mag"], info["clip_frac"], info["snr_db"], info["offset_hz"]))
    if info["keyed_s"] < 0.4 or info["snr_db"] < 8:
        raise RuntimeError("no carrier at the HackRF (keyed %.2f s, snr %.1f dB)" % (info["keyed_s"], info["snr_db"]))
    pcm = np.load(WAV / (name + ".npy")).astype(np.float32)
    result = analyze(dev, info, meta, pcm)
    if "amp" in meta:
        result["amp"] = meta["amp"]
    if "db" in meta:
        result["db"] = meta["db"]
    worst = float(result.get("worst_hz", 0))
    say("%s worst deviation %.0f Hz  lag %.2f s" % (name, worst, result.get("lag_s", -1)))
    if "rows" in result:
        say("  tones " + " ".join("%g:%.0f" % (r["hz"], r["peak_hz"]) for r in result["rows"]))
    if worst > STOP_HZ:
        result["STOP"] = True
    # drop bulky arrays before returning
    audio = result.pop("audio", None)
    if audio is not None:
        outp = CAP / (name + "_demod.wav")
        write_wav_48(outp, audio)
        result["demod"] = str(outp)
    result["capture"] = str(iq)
    return result, info


def write_wav_48(path, samples):
    x = np.asarray(samples).astype("<i2")
    data = x.tobytes()
    hdr = struct.pack("<4sI4s4sIHHIIHH4sI", b"RIFF", 36 + len(data), b"WAVE", b"fmt ", 16, 1, 1, 48000, 96000, 2, 16, b"data", len(data))
    path.write_bytes(hdr + data)


def adjust_gain(info):
    """Return True if the probe should be repeated."""
    global gain_l, gain_g
    if info["clip_frac"] > 0.0005 or info["mean_mag"] > 55:
        if gain_l > 0:
            gain_l = max(0, gain_l - 8)
        elif gain_g > 4:
            gain_g = max(0, gain_g - 6)
        else:
            raise RuntimeError("still clipping at lna 0 vga %d; move the phone further from the HackRF" % gain_g)
        say("gain down to lna %d vga %d" % (gain_l, gain_g))
        return True
    # Spectral SNR can look fine while the carrier is only a couple of counts.
    # Discriminator noise then swamps a decode, so keep the baseband magnitude up.
    if info["mean_mag"] < 12 and gain_g < 46:
        gain_g = min(46, gain_g + 6)
        say("gain up to lna %d vga %d (mag %.1f)" % (gain_l, gain_g, info["mean_mag"]))
        return True
    if info["mean_mag"] < 12 and gain_l < 40:
        gain_l = min(40, gain_l + 8)
        say("gain up to lna %d vga %d (mag %.1f)" % (gain_l, gain_g, info["mean_mag"]))
        return True
    return False


def restore_factory(st):
    say("restoring factory image")
    try:
        ver = load_image(FACTORY)
        expect_version(ver, "DMR003.UV4T.V022")
        st["image"] = "DMR003.UV4T.V022"
        save_state(st)
        vfo_off()
        say("factory restored and verified")
        return True
    except Exception as e:
        say("FACTORY RESTORE FAILED: %s" % e)
        st["restore_error"] = str(e)
        save_state(st)
        return False


def finish_radio():
    vfo_off()
    rc, out = adb("shell", "ls", "/sdcard/DMR/DMRDEBUG.bin")
    say("DMRDEBUG check: %s" % out.strip())
    # back on the channel the VFO was opened from (Weather / 36)
    adb("shell", "input", "keyevent", "224")


def measure(tag, st):
    """Full measurement set for the image that is already running. tag is UV4T or UVm2/3/4."""
    global gain_l, gain_g
    gain_l, gain_g = st.get("gain", [16, 16])
    rec = {"tag": tag}
    tune()
    # probe, repeating if the HackRF gain is wrong. This is the first transmission.
    for attempt in range(3):
        samples, meta = build_probe()
        name = "%s_probe" % tag
        result, info = send_one(name, samples, meta, lambda d, i, m, p: analyze_tones(d, i, m, p))
        if result.get("STOP"):
            rec["probe"] = result
            st["results"][tag] = rec
            save_state(st)
            raise RuntimeError("probe deviation %.0f Hz exceeds ±5 kHz" % result["worst_hz"])
        if attempt < 2 and adjust_gain(info):
            continue
        break
    st["gain"] = [gain_l, gain_g]
    rec["probe"] = result
    st["results"][tag] = rec
    save_state(st)
    p1 = next(r for r in result["rows"] if r["hz"] == 1000)
    p3 = next(r for r in result["rows"] if r["hz"] == 3500)
    hz_per = p1["peak_hz"] / meta["amp"] if meta["amp"] else 0
    say("probe 1 kHz %.0f Hz (%.3f Hz/PCM), 3.5 kHz %.0f Hz" % (p1["peak_hz"], hz_per, p3["peak_hz"]))
    if tag == "UV4T":
        st["factory_hz_per_pcm"] = hz_per
        st["factory_emph"] = (p3["peak_hz"] / p1["peak_hz"]) if p1["peak_hz"] > 5 else None
    # frequency response. Start at -30 dBFS; raise to -20 only if the probe says -20 stays under 4 kHz.
    scale20 = 10 ** ((36 - 20) / 20)
    pred20 = max(p1["peak_hz"], p3["peak_hz"]) * scale20
    levels = [30]
    if pred20 < 4000:
        levels = [20]
    elif pred20 < 8000:
        levels = [30]   # -20 would be too close to or over the stop; keep the lower level
    pred30 = max(p1["peak_hz"], p3["peak_hz"]) * 10 ** ((36 - 30) / 20.0)
    say("sweep: probe predicts %.0f Hz at -30 dBFS and %.0f Hz at -20 (linear)" % (pred30, pred20))
    rec["sweep"] = []
    samples, meta = build_sweep(30)
    result, _info = send_one("%s_sweep30" % tag, samples, meta, lambda d, i, m, p: analyze_tones(d, i, m, p))
    rec["sweep"].append(result)
    st["results"][tag] = rec
    save_state(st)
    if result.get("STOP"):
        raise RuntimeError("sweep deviation %.0f Hz exceeds ±5 kHz" % result["worst_hz"])
    measured = result["worst_hz"]
    pred_at_20 = measured * 10 ** (10 / 20.0)
    limited = pred30 > 50 and measured < 0.65 * pred30 and measured < 4500
    if pred_at_20 < 4200 or limited:
        say("raising the sweep to -20 dBFS (linear prediction %.0f Hz, limiter holding: %s)" % (pred_at_20, limited))
        samples, meta = build_sweep(20)
        result, _info = send_one("%s_sweep20" % tag, samples, meta, lambda d, i, m, p: analyze_tones(d, i, m, p))
        rec["sweep"].append(result)
        st["results"][tag] = rec
        save_state(st)
        if result.get("STOP"):
            raise RuntimeError("sweep deviation %.0f Hz exceeds ±5 kHz" % result["worst_hz"])
    else:
        say("keeping the sweep at -30 dBFS; -20 dBFS would be about %.0f Hz" % pred_at_20)
        rec["sweep_note"] = "−20 dBFS not sent; linear prediction %.0f Hz" % pred_at_20
    # limiter, low to high. A hotter step is sent only when it should stay under ±5 kHz,
    # including when the previous step already shows the limiter holding the deviation down.
    rec["limiter"] = []
    prev_meas, prev_amp, prev_pred = None, None, None
    for db in LIM_DB:
        amp = db_amp(db)
        if prev_meas is not None and prev_amp:
            pred = prev_meas * (amp / prev_amp)
            was_linear = prev_pred is None or prev_meas > 0.75 * prev_pred
            if prev_meas > 4900 or (pred > 4700 and was_linear):
                say("limiter: not sending -%d dBFS (previous %.0f Hz, linear prediction %.0f Hz)" % (db, prev_meas, pred))
                rec["limiter"].append({"db": -db, "skipped": "predicted %.0f Hz" % pred})
                break
        else:
            pred = None
        samples, meta = build_limiter(db)
        result, _info = send_one("%s_lim%d" % (tag, db), samples, meta, lambda d, i, m, p: analyze_tones(d, i, m, p))
        row = result["rows"][0]
        result["db"] = -db
        rec["limiter"].append(result)
        st["results"][tag] = rec
        save_state(st)
        if result.get("STOP"):
            raise RuntimeError("limiter deviation %.0f Hz exceeds ±5 kHz" % result["worst_hz"])
        prev_pred = pred if pred is not None else row["peak_hz"]
        prev_meas = row["peak_hz"]
        prev_amp = amp
    # M17 and POCSAG amplitudes from the factory 1 kHz gain, so ±2.4 / ±4.5 kHz is one stimulus for every image.
    hz_per = st.get("factory_hz_per_pcm") or hz_per
    if hz_per < 0.01:
        raise RuntimeError("factory gain is %.4f Hz/PCM; not scaling M17 from that" % hz_per)
    m17_amp = 2400 / hz_per
    poc_amp = 4500 / hz_per
    # Hottest tone on THIS image (pre-emphasis), not the 1 kHz gain. A flat sine at 1 kHz
    # under-predicts a pre-emphasized path.
    hot = p3["peak_hz"] / db_amp(36)
    for sw in rec["sweep"]:
        if sw.get("amp"):
            hot = max(hot, max(r["peak_hz"] for r in sw["rows"]) / sw["amp"])
    say("hottest tone on this image %.3f Hz/PCM" % hot)
    def safe_amp(standard, design_hz, margin=1.25):
        pred = standard * hot * margin
        if pred <= 4600:
            return standard, "standard"
        reduced = standard * (4200 / pred)
        say("holding %s at %.0f PCM (standard %.0f predicts %.0f Hz)" % (design_hz, reduced, standard, pred))
        return reduced, "reduced"
    a_m17, how_m = safe_amp(m17_amp, "m17")
    samples, meta = build_m17(a_m17)
    meta["level"] = how_m
    result, _info = send_one("%s_m17" % tag, samples, meta, lambda d, i, m, p: analyze_m17(d, i, m, p))
    rec["m17"] = result
    st["results"][tag] = rec
    save_state(st)
    if result.get("STOP"):
        raise RuntimeError("M17 deviation %.0f Hz exceeds ±5 kHz" % result["worst_hz"])
    for baud in (1200, 512):
        a_p, how = safe_amp(poc_amp, "pocsag %d" % baud, 1.0)
        samples, meta = build_pocsag(baud, a_p)
        meta["level"] = how
        result, _info = send_one("%s_poc%d" % (tag, baud), samples, meta, lambda d, i, m, p: analyze_pocsag(d, i, m, p))
        rec.setdefault("pocsag", []).append(result)
        st["results"][tag] = rec
        save_state(st)
        if result.get("STOP"):
            raise RuntimeError("POCSAG deviation %.0f Hz exceeds ±5 kHz" % result["worst_hz"])
    # speech, peak about -14 dBFS, lowered if this image's gain is high
    voice_amp = db_amp(14)
    pred_v = voice_amp * hot * 1.2
    if pred_v > 4200:
        voice_amp *= 3400 / pred_v
        say("voice peak held to %.0f PCM (%.0f Hz predicted)" % (voice_amp, 3400))
    samples, meta = build_voice(voice_amp)
    result, _info = send_one("%s_voice" % tag, samples, meta, lambda d, i, m, p: analyze_voice(d, i, m, p))
    rec["voice"] = result
    st["results"][tag] = rec
    save_state(st)
    if result.get("STOP"):
        raise RuntimeError("voice deviation %.0f Hz exceeds ±5 kHz" % result["worst_hz"])
    vfo_off()
    return rec


def self_test():
    say("self-test: synthetic 1 kHz at 1500 Hz deviation, +1600 Hz carrier offset")
    fs = FS_IQ
    dur = 2.0
    t = np.arange(int(fs * dur)) / fs
    inst = OFF + 1600 + 1500 * np.sin(2 * np.pi * 1000 * t)
    phase = 2 * np.pi * np.cumsum(inst) / fs
    z = 30 * np.exp(1j * phase)
    iq = np.empty(2 * len(z), np.int8)
    iq[0::2] = np.clip(np.round(np.real(z)), -127, 127)
    iq[1::2] = np.clip(np.round(np.imag(z)), -127, 127)
    p = CAP / "selftest.iq"
    iq.tofile(p)
    dev, info = demod(p)
    # the tone fills the capture, so measure the middle second
    mid = dev[len(dev) // 3: 2 * len(dev) // 3]
    peak = goertzel_peak(mid, FS_A, 1000)
    say("self-test peak %.0f Hz (want 1500), offset %+.0f Hz (want +1600), mag %.1f" % (peak, info["offset_hz"], info["mean_mag"]))
    if abs(peak - 1500) > 40 or abs(info["offset_hz"] - 1600) > 40:
        raise SystemExit("self-test failed")
    # flat M17 loopback at exactly ±2.4 kHz must plain-decode
    rng = np.random.RandomState(1718)
    pay = [bytes(rng.randint(0, 256, 16, dtype=np.uint8)) for _ in range(20)]
    syms, _ = m17.transmission("N0CALL", "N0CALL", pay)
    devm = m17.deviation(syms, 48000)
    r = m17.decode_transmission(devm, 48000, verbose=False)
    good = sum(1 for (fn, pl, _le) in r["frames"] if (fn & 0x7FFF) < len(pay) and pl == pay[fn & 0x7FFF])
    say("self-test M17 loopback %d/%d" % (good, len(pay)))
    if good < len(pay) - 1:
        raise SystemExit("M17 loopback failed")
    say("self-test ok")


def smoke_hackrf():
    if hackrf_running():
        raise SystemExit("hackrf_transfer is already running; not touching it")
    n = int(FS_IQ * 0.4)
    p = CAP / "smoke.iq"
    if p.exists():
        p.unlink()
    say("HackRF receive-only smoke test, 0.4 s, no phone transmission")
    r = subprocess.run([HACKRF, "-r", str(p), "-f", "467385000", "-s", "2400000", "-l", "16", "-g", "16", "-n", str(n)],
                       capture_output=True, text=True, timeout=20)
    if r.returncode != 0 or not p.exists() or p.stat().st_size < n:
        raise SystemExit("HackRF smoke failed rc %s %s" % (r.returncode, (r.stderr or r.stdout)[-300:]))
    say("HackRF streams (%d bytes)" % p.stat().st_size)


def reanalyze_m17(st):
    """The first M17 pass measured the key-up click. Score the aligned audio instead."""
    dev, info = demod(CAP / "UV4T_m17.iq")
    pcm = np.load(WAV / "UV4T_m17.npy")
    meta = json.loads((WAV / "UV4T_m17.json").read_text(encoding="utf-8"))
    result = analyze_m17(dev, info, meta, pcm)
    result.pop("audio", None)
    say("m17 aligned: lag %.2f s, p95 %.0f Hz, p99.5 %.0f Hz, plain %s/%s, inverted %s/%s" % (
        result.get("lag_s", -1), result.get("p95_hz", -1), result.get("p995_hz", -1),
        result.get("plain", {}).get("exact"), result.get("plain", {}).get("sent"),
        result.get("inverted", {}).get("exact"), result.get("inverted", {}).get("sent")))
    if result.get("worst_hz", 0) > STOP_HZ:
        st["results"]["UV4T"]["m17"] = result
        save_state(st)
        raise RuntimeError("M17 audio deviation %.0f Hz exceeds ±5 kHz" % result["worst_hz"])
    result["note"] = "aligned audio; an earlier figure of 14 kHz was the key-up click"
    st["results"]["UV4T"]["m17"] = result
    save_state(st)


def rest_factory(st):
    """POCSAG and voice for the factory image. Sweep, limiter and M17 are already stored."""
    global gain_l, gain_g
    tag = "UV4T"
    rec = st["results"][tag]
    gain_l, gain_g = st.get("gain", [32, 20])
    say("resume gain lna %d vga %d" % (gain_l, gain_g))
    if "DMR003.UV4T.V022" not in str(st.get("image")):
        raise RuntimeError("state image is %s; not transmitting" % st.get("image"))
    tune()
    hz_per = st["factory_hz_per_pcm"]
    hot = 0.0
    for sw in rec["sweep"]:
        if sw.get("amp"):
            hot = max(hot, max(r["peak_hz"] for r in sw["rows"]) / sw["amp"])
    say("resume hottest %.3f Hz/PCM" % hot)
    poc_amp = 4500 / hz_per
    rec["pocsag"] = []
    for baud in (1200, 512):
        pred = poc_amp * hot * 2.0
        if pred <= 4200:
            a_p, how = poc_amp, "standard"
        else:
            a_p = poc_amp * (3400 / pred)
            how = "reduced"
            say("holding pocsag %d at %.0f PCM (standard %.0f predicts %.0f Hz)" % (baud, a_p, poc_amp, pred))
        samples, meta = build_pocsag(baud, a_p)
        meta["level"] = how
        result, _info = send_one("%s_poc%d" % (tag, baud), samples, meta, lambda d, i, m, p: analyze_pocsag(d, i, m, p))
        rec["pocsag"].append(result)
        st["results"][tag] = rec
        save_state(st)
        if result.get("STOP"):
            raise RuntimeError("POCSAG deviation %.0f Hz exceeds ±5 kHz" % result["worst_hz"])
    voice_amp = db_amp(14)
    pred_v = voice_amp * hot * 1.2
    if pred_v > 4200:
        voice_amp *= 3400 / pred_v
        say("voice peak held to %.0f PCM" % voice_amp)
    samples, meta = build_voice(voice_amp)
    result, _info = send_one("%s_voice" % tag, samples, meta, lambda d, i, m, p: analyze_voice(d, i, m, p))
    rec["voice"] = result
    st["results"][tag] = rec
    save_state(st)
    if result.get("STOP"):
        raise RuntimeError("voice deviation %.0f Hz exceeds ±5 kHz" % result["worst_hz"])
    vfo_off()


def low_end_db(rows):
    got = {r["hz"]: r["peak_hz"] for r in rows}
    ref = got.get(1000, 0.0)
    out = {}
    for f in (50, 100, 150, 200):
        pk = got.get(f, 0.0)
        out[f] = 20 * math.log10(pk / ref) if pk > 1 and ref > 1 else -99.0
    return out


def flat_to_50(rows):
    """Open low end: 50, 100, 150 and 200 Hz each within 3 dB of this sweep's 1 kHz tone.
    Section 6's acceptance window is ±2 dB; 3 dB is only the trigger for the extra steps."""
    return all(abs(v) <= 3.0 for v in low_end_db(rows).values())


def edge_peak(rows):
    vals = [r["peak_hz"] for r in rows if r["hz"] in (50, 100, 200, 300)]
    return max(vals) if vals else 0.0


def guard_len(samples, label):
    sec = len(samples) / 8000.0
    if sec > 27.0:
        raise RuntimeError("%s is %.1f s; not keying" % (label, sec))


def take_gain(st):
    global gain_l, gain_g
    g = st.get("gain") or [24, 32]
    if list(g) == [16, 16]:
        g = [24, 32]
        say("refusing the default 16/16 gain; using lna 24 vga 32")
    gain_l, gain_g = int(g[0]), int(g[1])
    say("gain lna %d vga %d" % (gain_l, gain_g))


def send_checked(name, samples, meta, analyze):
    guard_len(samples, name)
    result, info = send_one(name, samples, meta, analyze)
    if result.get("error"):
        raise RuntimeError("%s analyze failed: %s" % (name, result.get("error")))
    if result.get("STOP"):
        raise RuntimeError("%s deviation %.0f Hz exceeds ±5 kHz" % (name, result["worst_hz"]))
    return result, info


def measure_uv(tag, st):
    """UVm5 or UVm6. Sweep at -30, low tones at -24 and -18, then M17 and POCSAG.
    The -3 dBFS limiter, two further M17 transmissions and the voice clip run only
    when 50 Hz is open."""
    take_gain(st)
    rec = {"tag": tag}
    tune()
    result, info = None, None
    for attempt in range(3):
        samples, meta = build_probe()
        result, info = send_checked("%s_probe" % tag, samples, meta,
                                     lambda d, i, m, p: analyze_tones(d, i, m, p))
        if attempt < 2 and adjust_gain(info):
            continue
        break
    st["gain"] = [gain_l, gain_g]
    rec["probe"] = result
    st["results"][tag] = rec
    save_state(st)
    pred30 = result["worst_hz"] * 10 ** ((36 - 30) / 20.0)
    if pred30 > 4900:
        raise RuntimeError("sweep at -30 dBFS predicts %.0f Hz; not sending" % pred30)
    samples, meta = build_sweep(30)
    sweep, _info = send_checked("%s_sweep30" % tag, samples, meta,
                                 lambda d, i, m, p: analyze_tones(d, i, m, p))
    rec["sweep"] = sweep
    low = low_end_db(sweep["rows"])
    rec["low_end_db"] = low
    flat = flat_to_50(sweep["rows"])
    rec["flat_to_50"] = flat
    say("low end vs 1 kHz (dB): " + " ".join("%g:%+.1f" % (f, low[f]) for f in (50, 100, 150, 200))
        + ("  FLAT to 50 Hz" if flat else "  not flat to 50 Hz"))
    st["results"][tag] = rec
    save_state(st)
    prev_peak = edge_peak(sweep["rows"])
    prev_amp = sweep["amp"]
    rec["edge"] = []
    for db in (24, 18):
        amp = db_amp(db)
        pred = prev_peak * (amp / prev_amp) if prev_amp else 99999
        if pred > 4900:
            say("edge -%d dBFS not sent; linear prediction %.0f Hz" % (db, pred))
            rec["edge"].append({"db": -db, "skipped": "predicted %.0f Hz" % pred})
            st["results"][tag] = rec
            save_state(st)
            break
        samples, meta = build_edge(db)
        result, _info = send_checked("%s_edge%d" % (tag, db), samples, meta,
                                      lambda d, i, m, p: analyze_tones(d, i, m, p))
        rec["edge"].append(result)
        st["results"][tag] = rec
        save_state(st)
        prev_peak = edge_peak(result["rows"])
        prev_amp = amp
    if flat:
        p1 = next(r["peak_hz"] for r in sweep["rows"] if r["hz"] == 1000)
        pred3 = p1 * (db_amp(3) / sweep["amp"])
        say("limiter -3 dBFS predicts %.0f Hz from the -30 dBFS 1 kHz tone" % pred3)
        if pred3 > 4900:
            rec["limiter3"] = {"skipped": "predicted %.0f Hz" % pred3}
            say("limiter -3 dBFS not sent")
        else:
            samples, meta = build_limiter(3)
            result, _info = send_checked("%s_lim3" % tag, samples, meta,
                                          lambda d, i, m, p: analyze_tones(d, i, m, p))
            rec["limiter3"] = result
        st["results"][tag] = rec
        save_state(st)
    hz_per = st.get("factory_hz_per_pcm") or 0
    if hz_per < 0.01:
        raise RuntimeError("factory gain missing; not scaling M17")
    m17_amp = 2400 / hz_per
    poc_amp = 4500 / hz_per
    hot = max(r["peak_hz"] for r in sweep["rows"]) / sweep["amp"]
    for e in rec["edge"]:
        if e.get("rows") and e.get("amp"):
            hot = max(hot, max(r["peak_hz"] for r in e["rows"]) / e["amp"])
    say("hottest tone on this image %.3f Hz/PCM" % hot)

    def safe_amp(standard, design_hz, margin=1.25):
        pred = standard * hot * margin
        if pred <= 4600:
            return standard, "standard"
        reduced = standard * (4200 / pred)
        say("holding %s at %.0f PCM (standard %.0f predicts %.0f Hz)" % (design_hz, reduced, standard, pred))
        return reduced, "reduced"

    a_m17, how_m = safe_amp(m17_amp, "m17")
    m17s = []
    samples, meta = build_m17(a_m17)
    meta["level"] = how_m
    result, _info = send_checked("%s_m17" % tag, samples, meta,
                                  lambda d, i, m, p: analyze_m17(d, i, m, p))
    m17s.append(result)
    exact = (result.get("plain") or {}).get("exact") or 0
    sent = (result.get("plain") or {}).get("sent") or 0
    say("M17 plain %s/%s" % (exact, sent))
    if exact > 80:
        for suf in ("b", "c"):
            samples, meta = build_m17(a_m17)
            meta["level"] = how_m
            result, _info = send_checked("%s_m17%s" % (tag, suf), samples, meta,
                                          lambda d, i, m, p: analyze_m17(d, i, m, p))
            m17s.append(result)
            ex = (result.get("plain") or {}).get("exact")
            say("M17 extra %s plain %s/%s" % (suf, ex, sent))
    else:
        say("M17 plain %s/90; not repeating" % exact)
    rec["m17"] = m17s
    st["results"][tag] = rec
    save_state(st)
    rec["pocsag"] = []
    for baud in (1200, 512):
        a_p, how = safe_amp(poc_amp, "pocsag %d" % baud, 1.0)
        samples, meta = build_pocsag(baud, a_p)
        meta["level"] = how
        result, _info = send_checked("%s_poc%d" % (tag, baud), samples, meta,
                                      lambda d, i, m, p: analyze_pocsag(d, i, m, p))
        rec["pocsag"].append(result)
        st["results"][tag] = rec
        save_state(st)
        plain = result.get("plain") or {}
        say("POCSAG %d errors %s/%s pages %s" % (baud, plain.get("bit_errors"), plain.get("bits"), plain.get("pages")))
    if flat:
        voice_amp = float(db_amp(14))
        pred_v = voice_amp * hot * 1.2
        if pred_v > 4200:
            voice_amp *= 3400 / pred_v
            say("voice peak held to %.0f PCM" % voice_amp)
        samples, meta = build_voice(voice_amp)
        result, _info = send_checked("%s_voice" % tag, samples, meta,
                                      lambda d, i, m, p: analyze_voice(d, i, m, p))
        rec["voice"] = result
        st["results"][tag] = rec
        save_state(st)
    else:
        say("voice not sent; the low end is not flat")
    vfo_off()
    return rec


def measure_canary(tag, st):
    """UVm7. One 1 kHz tone at -12 dBFS, against the factory reading of 1827 Hz."""
    take_gain(st)
    rec = {"tag": tag, "factory_ref_hz": 1827, "uvm3_ref_hz": 1876}
    tune()
    result = None
    for attempt in range(2):
        samples, meta = build_limiter(12)
        result, info = send_checked("%s_lim12" % tag, samples, meta,
                                     lambda d, i, m, p: analyze_tones(d, i, m, p))
        if attempt == 0 and adjust_gain(info):
            say("canary gain adjusted; repeating the one tone")
            continue
        break
    st["gain"] = [gain_l, gain_g]
    row = result["rows"][0]
    rec["limiter12"] = result
    rec["peak_hz"] = row["peak_hz"]
    say("canary 1 kHz at -12 dBFS: %.0f Hz (factory 1827 Hz, UVm3 1876 Hz)" % row["peak_hz"])
    st["results"][tag] = rec
    save_state(st)
    vfo_off()
    return rec


def measure_proof(tag, st):
    """UVm8. The -36 dBFS 1 kHz / 3.5 kHz probe only. No sweep, M17 or POCSAG."""
    take_gain(st)
    rec = {"tag": tag}
    tune()
    result = None
    for attempt in range(3):
        samples, meta = build_probe()
        result, info = send_checked("%s_probe" % tag, samples, meta,
                                     lambda d, i, m, p: analyze_tones(d, i, m, p))
        if attempt < 2 and adjust_gain(info):
            continue
        break
    st["gain"] = [gain_l, gain_g]
    rows = {r["hz"]: r["peak_hz"] for r in result["rows"]}
    p1, p3 = rows.get(1000, 0.0), rows.get(3500, 0.0)
    boost = 20 * math.log10(p3 / p1) if p1 > 1 and p3 > 1 else -99.0
    rec["probe"] = result
    rec["boost_db"] = boost
    say("probe 1 kHz %.1f Hz  3.5 kHz %.1f Hz  boost %+.1f dB (factory was +6.8)" % (p1, p3, boost))
    if boost > 4.0:
        say("pre-emphasis still present; the stub's 0x58 write did not hold")
    elif boost < 2.0:
        say("pre-emphasis gone; the stub's 0x58 write held")
    else:
        say("boost is between the factory curve and a flat one")
    st["results"][tag] = rec
    save_state(st)
    vfo_off()
    return rec


def _scaled_low(rows, ref_hz):
    out = []
    for r in rows:
        if r["hz"] not in (50, 100, 200) or ref_hz <= 1:
            continue
        pk = r["peak_hz"]
        dbv = 20 * math.log10(pk / ref_hz) if pk > 1 else -99.0
        out.append((r["hz"], dbv, pk))
    return out


def measure_bcfd(tag, st):
    """UVm9. Probe, then 50/100/200/300 at -30/-24/-18. Full sweep, M17 and POCSAG
    only when the -30 dBFS sub-250 tones are off the noise floor."""
    take_gain(st)
    rec = {"tag": tag}
    tune()
    result = None
    for attempt in range(3):
        samples, meta = build_probe()
        result, info = send_checked("%s_probe" % tag, samples, meta,
                                     lambda d, i, m, p: analyze_tones(d, i, m, p))
        if attempt < 2 and adjust_gain(info):
            continue
        break
    st["gain"] = [gain_l, gain_g]
    rec["probe"] = result
    st["results"][tag] = rec
    save_state(st)
    rows = {r["hz"]: r["peak_hz"] for r in result["rows"]}
    ref36 = rows.get(1000, 0.0)
    pred30 = result["worst_hz"] * 10 ** ((36 - 30) / 20.0)
    if pred30 > 4900:
        raise RuntimeError("edge at -30 dBFS predicts %.0f Hz; not sending" % pred30)
    prev_peak = result["worst_hz"]
    prev_amp = result["amp"]
    rec["edge"] = []
    opened = False
    for db in (30, 24, 18):
        amp = db_amp(db)
        pred = prev_peak * (amp / prev_amp) if prev_amp else 99999
        if pred > 4900:
            say("edge -%d dBFS not sent; linear prediction %.0f Hz" % (db, pred))
            rec["edge"].append({"db": -db, "skipped": "predicted %.0f Hz" % pred})
            break
        samples, meta = build_edge(db)
        result, _info = send_checked("%s_edge%d" % (tag, db), samples, meta,
                                      lambda d, i, m, p: analyze_tones(d, i, m, p))
        rec["edge"].append(result)
        ref = ref36 * 10 ** ((36 - db) / 20.0)
        lows = _scaled_low(result["rows"], ref)
        say("edge -%d vs scaled 1 kHz: " % db + " ".join("%g:%+.1f" % (f, d) for f, d, _p in lows))
        if db == 30 and lows:
            best = max(d for _f, d, _p in lows)
            # The closed low end sat near -40 dB. Clear of that floor, still short of flat.
            opened = best > -25.0
            rec["low_best_db"] = best
            rec["opened"] = opened
            say("low end %s (best %+.1f dB)" % ("OPEN" if opened else "still down", best))
        st["results"][tag] = rec
        save_state(st)
        prev_peak = edge_peak(result["rows"])
        prev_amp = amp
    if not opened:
        say("low end did not open; not sending the sweep, M17 or POCSAG")
        st["results"][tag] = rec
        save_state(st)
        vfo_off()
        return rec
    samples, meta = build_sweep(30)
    sweep, _info = send_checked("%s_sweep30" % tag, samples, meta,
                                 lambda d, i, m, p: analyze_tones(d, i, m, p))
    rec["sweep"] = sweep
    st["results"][tag] = rec
    save_state(st)
    hz_per = st.get("factory_hz_per_pcm") or 0
    if hz_per < 0.01:
        raise RuntimeError("factory gain missing; not scaling M17")
    hot = max(r["peak_hz"] for r in sweep["rows"]) / sweep["amp"]
    say("hottest tone on this image %.3f Hz/PCM" % hot)

    def safe_amp(standard, design_hz, margin=1.25):
        pred = standard * hot * margin
        if pred <= 4600:
            return standard, "standard"
        reduced = standard * (4200 / pred)
        say("holding %s at %.0f PCM (standard %.0f predicts %.0f Hz)" % (design_hz, reduced, standard, pred))
        return reduced, "reduced"

    a_m17, how_m = safe_amp(2400 / hz_per, "m17")
    samples, meta = build_m17(a_m17)
    meta["level"] = how_m
    m17, _info = send_checked("%s_m17" % tag, samples, meta,
                               lambda d, i, m, p: analyze_m17(d, i, m, p))
    rec["m17"] = [m17]
    exact = (m17.get("plain") or {}).get("exact") or 0
    say("M17 plain %s/90" % exact)
    st["results"][tag] = rec
    save_state(st)
    rec["pocsag"] = []
    for baud in (1200, 512):
        a_p, how = safe_amp(4500 / hz_per, "pocsag %d" % baud, 1.0)
        samples, meta = build_pocsag(baud, a_p)
        meta["level"] = how
        result, _info = send_checked("%s_poc%d" % (tag, baud), samples, meta,
                                      lambda d, i, m, p: analyze_pocsag(d, i, m, p))
        rec["pocsag"].append(result)
        st["results"][tag] = rec
        save_state(st)
    vfo_off()
    return rec


def main():
    phase = sys.argv[1] if len(sys.argv) > 1 else "factory"
    if phase == "next":
        (HERE / "next.pid").write_text(str(os.getpid()), encoding="utf-8")
    st = load_state()
    if phase == "self":
        self_test()
        return
    if phase == "rest":
        try:
            reanalyze_m17(st)
            rest_factory(st)
            finish_radio()
            say("FACTORY PHASE DONE")
        except Exception as e:
            say("STOP: %s" % e)
            try:
                vfo_off()
            except Exception:
                pass
            finish_radio()
            raise
        return
    self_test()
    smoke_hackrf()
    try:
        if phase == "factory":
            ver = read_version(power_cycle=True)
            st["image"] = ver
            save_state(st)
            if "DMR003.UV4T.V022" not in ver:
                say("radio answered %s; loading the factory image before the baseline" % ver)
                ver = load_image(FACTORY)
                expect_version(ver, "DMR003.UV4T.V022")
                st["image"] = ver
                save_state(st)
            measure("UV4T", st)
            finish_radio()
            say("FACTORY PHASE DONE")
        elif phase == "images":
            if "UV4T" not in st.get("results", {}):
                raise SystemExit("factory results missing; not loading a patch")
            for tag, patches in (("UVm2", "fm-flat-58"), ("UVm3", "c7000-fm-flat"), ("UVm4", "fm-flat-58 c7000-fm-flat")):
                img = BUILD / ("DMR003.%s.V022.bin" % tag)
                st["image"] = "loading " + tag
                save_state(st)
                ver = load_image(img)
                expect_version(ver, "DMR003.%s.V022" % tag)
                st["image"] = ver
                save_state(st)
                measure(tag, st)
            restore_factory(st)
            finish_radio()
            say("IMAGES PHASE DONE")
        elif phase == "next":
            # UVm5, UVm6, then the C7000 canary. Does not repeat the factory / UVm2-4 set.
            say("NEXT PHASE START")
            if hackrf_running():
                raise RuntimeError("hackrf_transfer is already running")
            ver = read_version(power_cycle=True)
            st["image"] = ver
            save_state(st)
            if "DMR003.UV4T.V022" not in ver:
                say("radio answered %s; loading the factory image before any patch" % ver)
                ver = load_image(FACTORY)
                expect_version(ver, "DMR003.UV4T.V022")
                st["image"] = ver
                save_state(st)
            say("0x34 is %s before the first load" % ver)
            for tag, kind in (("UVm5", "uv"), ("UVm6", "uv"), ("UVm7", "canary")):
                img = BUILD / ("DMR003.%s.V022.bin" % tag)
                if not img.exists():
                    raise RuntimeError("missing image %s" % img)
                st["image"] = "loading " + tag
                save_state(st)
                ver = load_image(img)
                expect_version(ver, "DMR003.%s.V022" % tag)
                st["image"] = ver
                save_state(st)
                say("0x34 %s confirmed before measurement" % ver)
                if kind == "canary":
                    measure_canary(tag, st)
                else:
                    measure_uv(tag, st)
            if not restore_factory(st):
                raise RuntimeError("factory image did not restore")
            finish_radio()
            say("NEXT PHASE DONE")
        elif phase == "oct":
            # UVm8 stub self-proof, then UVm9 (0xBCFD). Does not repeat UVm2-UVm7.
            say("OCT PHASE START")
            if hackrf_running():
                raise RuntimeError("hackrf_transfer is already running")
            ver = read_version(power_cycle=True)
            st["image"] = ver
            save_state(st)
            if "DMR003.UV4T.V022" not in ver:
                say("radio answered %s; loading the factory image before any patch" % ver)
                ver = load_image(FACTORY)
                expect_version(ver, "DMR003.UV4T.V022")
                st["image"] = ver
                save_state(st)
            say("0x34 is %s before the first load" % ver)
            for tag, kind in (("UVm8", "proof"), ("UVm9", "bcfd")):
                img = BUILD / ("DMR003.%s.V022.bin" % tag)
                if not img.exists():
                    raise RuntimeError("missing image %s" % img)
                st["image"] = "loading " + tag
                save_state(st)
                ver = load_image(img)
                expect_version(ver, "DMR003.%s.V022" % tag)
                st["image"] = ver
                save_state(st)
                say("0x34 %s confirmed before measurement" % ver)
                if kind == "proof":
                    measure_proof(tag, st)
                else:
                    measure_bcfd(tag, st)
            if not restore_factory(st):
                raise RuntimeError("factory image did not restore")
            finish_radio()
            say("OCT PHASE DONE")
        else:
            raise SystemExit("unknown phase " + phase)
    except Exception as e:
        say("STOP: %s" % e)
        if st.get("image") and "UV4T" not in str(st.get("image")) and "unknown" not in str(st.get("image")):
            restore_factory(st)
        else:
            try:
                vfo_off()
            except Exception:
                pass
        finish_radio()
        raise


if __name__ == "__main__":
    main()
