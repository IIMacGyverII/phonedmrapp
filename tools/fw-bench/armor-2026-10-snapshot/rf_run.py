"""R-F. Receive only. Wi-Fi adb only. Does not key the phone and does not call vfo_off.

New M17 transmissions (not the N0CALL loop), held phone path, fixed taps from rf_eq.py.
"""
import json
import sys
import time
from pathlib import Path

import numpy as np

sys.path.insert(0, r"D:\Documents\code\personal\phonedmrapp\tools\m17-research")
sys.path.insert(0, r"D:\Documents\code\personal\phonedmrapp\tools\pocsag-research")
import m17  # noqa: E402
import pocsag  # noqa: E402

import camp
import r3a3_run
import rd10_run as r
import rc20_run as old
import rf_eq

DIR = camp.HERE / "rf"
DIR.mkdir(parents=True, exist_ok=True)
OUT = DIR / "result.json"
FS = 8000.0
NFRAMES = 80
PAIRS = [
    ("W1RF", "N2EQ"), ("K3M17", "W4LAB"), ("N5TST", "K6DEC"),
    ("W7RF", "N8EQ"), ("K9M17", "W2LAB"), ("N3TST", "K4DEC"),
    ("W5RF", "N6EQ"), ("K7M17", "W8LAB"), ("N9TST", "K2DEC"),
    ("W3RF", "N4EQ"), ("K5M17", "W6LAB"), ("N7TST", "K8DEC"),
    ("W9RF", "N1EQ"), ("K1M17", "W3LAB"), ("N4TST", "K5DEC"),
    ("W2RF", "N3EQ"), ("K6M17", "W9LAB"), ("N8TST", "K3DEC"),
]


def save(doc):
    OUT.write_text(json.dumps(doc, indent=2), encoding="utf-8")


def load_taps():
    spec = json.loads((DIR / "taps.json").read_text(encoding="utf-8"))
    return np.array(spec["taps"], float)


def iq_syms(syms, dev_hz):
    dev = m17.deviation(np.asarray(syms, float), old.FS_TX) * (float(dev_hz) / 2400.0)
    phase = 2 * np.pi * np.cumsum(dev) / old.FS_TX
    z = np.exp(1j * phase)
    iq = np.empty(2 * z.size, np.int8)
    iq[0::2] = np.clip(np.round(z.real * 110), -127, 127).astype(np.int8)
    iq[1::2] = np.clip(np.round(z.imag * 110), -127, 127).astype(np.int8)
    return iq.tobytes(), int(z.size)


def make_tx(name, dev_hz):
    rng = np.random.default_rng(10007 + sum(ord(c) for c in name) * 17)
    src, dst = PAIRS[sum(ord(c) for c in name) % len(PAIRS)]
    payloads = [bytes(int(v) for v in row) for row in rng.integers(0, 256, size=(NFRAMES, 16))]
    syms, lsf = m17.transmission(src, dst, payloads, eot=True)
    lead = np.tile(np.array([3.0, -3.0]), int(1.6 * 4800) // 2)
    packed = np.concatenate([lead, syms])
    blob, n = iq_syms(packed, dev_hz)
    expect = [{"fn": i | (0x8000 if i == NFRAMES - 1 else 0), "payload": p.hex()} for i, p in enumerate(payloads)]
    return blob, n, {"src": src, "dst": dst, "dev_hz": dev_hz, "frames": expect}


def rssi_query():
    camp.adb("shell", "logcat", "-c")
    camp.broadcast(["--es", "cmd", "cmdbyte", "--ei", "b", "50", "--ei", "d", "1"])
    text = r.wait_for("cmd=0x32", 4)
    hit = ""
    for ln in text.splitlines():
        if "cmd=0x32" in ln and "rw=" in ln:
            hit = ln.strip()
    raw = None
    if "[" in hit and "]" in hit:
        inside = hit.split("[", 1)[1].split("]", 1)[0].strip().split()
        if inside:
            try:
                raw = int(inside[0], 16)
            except ValueError:
                raw = None
    dbm = None
    if raw is not None and raw > 0:
        dbm = -(120 - raw / 2.0)
        if dbm > -20:
            dbm = None
    return {"raw": raw, "dbm": dbm, "log": hit[-160:]}


def clip(name, blob, n, ms, vga, want_rssi):
    path = DIR / (name + ".cs8")
    path.write_bytes(blob)
    proc, hlog = old.start_tx(path, n, vga)
    time.sleep(0.3)
    camp.adb("shell", "logcat", "-c")
    camp.broadcast(["--es", "cmd", "rxclip", "--ei", "ms", str(ms), "--es", "name", name])
    reading = None
    if want_rssi:
        time.sleep(1.8)
        reading = rssi_query()
    text = r.wait_for("rxclip done", ms / 1000.0 + 8)
    hit = r.hit_line(text, "rxclip done")
    old.finish_tx(proc, hlog, ms / 1000.0 + 2)
    dest = DIR / (name + ".wav")
    blob_w = r.pull_cache("rxclip_%s.wav" % name, dest)
    return dest if blob_w else None, reading, (hit or "")[-140:]


def score(path, w, meta):
    d = rf_eq.decode_wav(path, w)
    lsf = [row for row in d["rows"] if row["kind"] == "lsf" and row["crc"]]
    crc_ok = any(row["src"].strip() == meta["src"] and row["dst"].strip() == meta["dst"] for row in lsf)
    streams = [row for row in d["rows"] if row["kind"] == "str"]
    g0 = sum(1 for row in streams if row["golay"] == 0)
    payload_ok = 0
    wanted = {e["fn"]: e["payload"] for e in meta["frames"]}
    for row in streams:
        if row["golay"] == 0 and wanted.get(row["fn"]) == row["payload"]:
            payload_ok += 1
    camp.say("%s crc=%s golay0 %d/%d payload %d" % (path.name, crc_ok, g0, len(streams), payload_ok))
    return {
        "lsf_crc": crc_ok,
        "lsf_seen": d["lsf"],
        "lsf_crc_n": d["lsf_crc"],
        "stream": len(streams),
        "golay0": g0,
        "payload_ok": payload_ok,
        "src_seen": lsf[0]["src"] if lsf else None,
        "dst_seen": lsf[0]["dst"] if lsf else None,
    }


def tone_phone(name, freq):
    iq, n = r.tone_iq(2.6, float(freq))
    wav, reading, hit = clip(name, iq, n, 1600, 20, False)
    if wav is None:
        return {"line": 0.0}
    x = rf_eq.pcm(wav)
    last = x[-int(0.4 * FS):]
    ln = r.line(last, freq)
    camp.say("%s %d Hz %.1f" % (name, freq, ln))
    return {"hz": freq, "line": ln, "wav": str(wav)}


def tone_ram(name, freq):
    iq, n = r.tone_iq(2.6, float(freq))
    path = DIR / (name + ".cs8")
    path.write_bytes(iq)
    proc, hlog = old.start_tx(path, n, 20)
    time.sleep(0.7)
    hit, got = r.ask_rx(4, 6)
    old.finish_tx(proc, hlog, 2.6)
    if len(got) != 6:
        camp.say(name + " ram short " + str(len(got)))
        return {"n": len(got), "log": (hit or "")[-140:]}
    x = np.concatenate([p["samples"] for p in got[1:]])
    ln = r.line(x, freq)
    camp.say("%s ram %d Hz %.1f halves %s" % (name, freq, ln, [p["half"] for p in got]))
    raw = r.DIR / "rx_m4_n6.bin"
    if raw.exists():
        (DIR / (name + ".bin")).write_bytes(raw.read_bytes())
    return {"hz": freq, "line": ln, "halves": [p["half"] for p in got], "seqs": [p["seq"] for p in got],
            "log": (hit or "")[-140:], "bin": str(DIR / (name + ".bin"))}


def pocsag_iq(bits, dev_hz):
    spb = old.FS_TX / 1200.0
    chunks = []
    for i, b in enumerate(bits):
        n0 = int(round(i * spb))
        n1 = int(round((i + 1) * spb))
        chunks.append(np.full(n1 - n0, -1.0 if b else 1.0))
    audio = np.concatenate(chunks)
    phase = 2 * np.pi * dev_hz * np.cumsum(audio) / old.FS_TX
    z = np.exp(1j * phase)
    iq = np.empty(2 * z.size, np.int8)
    iq[0::2] = np.clip(np.round(z.real * 110), -127, 127).astype(np.int8)
    iq[1::2] = np.clip(np.round(z.imag * 110), -127, 127).astype(np.int8)
    return iq.tobytes(), int(z.size)


def pocsag_errors(wav, bits):
    x = rf_eq.loud(rf_eq.pcm(wav))
    best = None
    for pol in (1.0, -1.0):
        for phase in np.linspace(0, 8000 / 1200.0, 8, endpoint=False):
            spb = 8000 / 1200.0
            idx = np.arange(phase + spb / 2, x.size - 1, spb).astype(int)
            got = (pol * x[idx] < 0).astype(np.uint8)
            # find the 32-bit sync
            sync = [(pocsag.SYNC >> (31 - k)) & 1 for k in range(32)]
            sync = np.array(sync, np.uint8)
            if got.size < 64:
                continue
            hits = []
            # step by 1 is fine: a page is a few thousand bits
            for i in range(0, min(got.size - 32, 8000)):
                if np.array_equal(got[i:i + 32], sync):
                    hits.append(i)
                    break
            if not hits:
                continue
            i0 = hits[0]
            # known stream: preamble then batches. Search known sync in `bits`.
            known = np.array(bits, np.uint8)
            kpos = None
            for i in range(0, known.size - 32):
                if np.array_equal(known[i:i + 32], sync):
                    kpos = i
                    break
            if kpos is None:
                continue
            n = min(got.size - i0, known.size - kpos)
            err = int(np.sum(got[i0:i0 + n] != known[kpos:kpos + n]))
            # per codeword, 32 bits, skipping nothing: from sync inclusive
            words = n // 32
            per = []
            for w in range(words):
                a = got[i0 + 32 * w:i0 + 32 * (w + 1)]
                b = known[kpos + 32 * w:kpos + 32 * (w + 1)]
                per.append(int(np.sum(a != b)))
            if best is None or err < best[0]:
                best = (err, n, pol, per)
    if best is None:
        return {"aligned": False}
    err, n, pol, per = best
    return {"aligned": True, "bit_errors": err, "bits": n, "polarity": pol,
            "codewords": len(per), "errors_per_codeword": per,
            "mean_errors": float(np.mean(per)) if per else None}


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
    camp.adb("shell", "logcat", "-c")
    camp.broadcast(["--es", "cmd", "cmdbyte", "--ei", "b", "52", "--ei", "d", "1"])
    text = r.wait_for("module DMR", 8)
    hit = r.hit_line(text, "module DMR")
    ver = hit.split("module ")[-1].strip() if "module " in hit else ""
    camp.say("version " + (ver or "missing"))
    if "RE10" not in ver:
        raise SystemExit("wanted RE10, got " + (ver or hit[-80:]))
    w = load_taps()
    doc = {"version": ver, "adb": camp.SER, "taps": [float(v) for v in w]}
    doc["hold"] = r.hold(3, 1)
    old.dummy(20)
    doc["m17"] = []
    save(doc)
    for dev in (2400, 1900):
        for vga in (20, 10, 0):
            for rep in range(3):
                name = "m17_d%d_v%d_%d" % (dev, vga, rep)
                blob, n, meta = make_tx(name, dev)
                wav, reading, hit = clip(name, blob, n, 4500, vga, True)
                row = {"name": name, "dev_hz": dev, "vga": vga, "src": meta["src"], "dst": meta["dst"],
                       "rssi": reading, "log": hit, "wav": str(wav) if wav else ""}
                if wav:
                    row["decode"] = score(wav, w, meta)
                doc["m17"].append(row)
                save(doc)
                camp.say("saved " + name)
    doc["tones"] = [tone_phone("ph_%d" % hz, hz) for hz in (1000, 400, 500, 600, 700, 800)]
    ref = next(t["line"] for t in doc["tones"] if t["hz"] == 1000)
    for t in doc["tones"]:
        t["db"] = None if not ref or not t.get("line") else float(20 * np.log10(t["line"] / ref))
    save(doc)
    bits = [1, 0] * 960
    for _ in range(4):
        bits += pocsag.transmission(1234567, 3, "RF HELD PATH")
    (DIR / "pocsag_bits.json").write_text(json.dumps(bits), encoding="utf-8")
    blob, n = pocsag_iq(bits, 3500.0)
    wav, reading, hit = clip("pocsag", blob, n, 6000, 20, True)
    doc["pocsag"] = {"wav": str(wav) if wav else "", "rssi": reading, "log": hit, "dev_hz": 3500, "baud": 1200}
    if wav:
        doc["pocsag"]["plain"] = pocsag_errors(wav, bits)
    save(doc)
    doc["restore"] = r.hold(3, 0)
    doc["ram"] = [tone_ram("ram_%d" % hz, hz) for hz in (1000, 400, 500, 600, 700, 800)]
    rref = next((t.get("line") or 0) for t in doc["ram"] if t.get("hz") == 1000)
    for t in doc["ram"]:
        t["db"] = None if not rref or not t.get("line") else float(20 * np.log10(t["line"] / rref))
    save(doc)
    camp.tune()
    camp.say("R-F capture done")


if __name__ == "__main__":
    try:
        main()
    finally:
        r.restore_hold()
        if camp.hackrf_running():
            camp.kill_hackrf()
