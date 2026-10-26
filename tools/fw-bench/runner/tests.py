"""The regression tests, each returning a record for report.record(): verdict, numbers, and the raw figures.

Every test is the Armor procedure distilled (radio_firmware/results.md names the entry it reproduces):
  boot     silent-boot capture across restartmodule (factory_boot.py)
  tone     one 1 kHz test tone at low power under a capture, FM-judged (r3a3_run.py)
  stream   the 1125-frame M17 stream through command 0x40 under a capture, decoded with the research decoder (fw19_run.py)
  heat     battery and thermal zones before, during and after a key, with the stops (fw19_heat.py)
  receive  a HackRF FM tone into the radio: the squelch opens and the phone's clip carries the line (rc20_run.py)
The tests that key the radio or transmit from the HackRF run only with --arm.
"""
import struct
import sys
import time
from pathlib import Path

import numpy as np

import fm
import hackrf
from common import REPO, HEAT_BAT_STOP_C, HEAT_ZONE_STOP_C, HEAT_RISE_STOP_C

sys.path.insert(0, str(REPO / "tools" / "m17-research"))


def _numbers(d):
    return ", ".join("%s %s" % (k, v) for k, v in d.items())


# ---- boot ----

def boot(cfg, phone, lead_s=3.0, capture_s=20.0):
    """Capture across a module restart; the module must stay under 10 dB above the floor the whole time."""
    cap = hackrf.Capture(cfg, "boot", capture_s, cfg.lna_boot, cfg.vga_boot)
    time.sleep(lead_s)
    t_restart = time.time() - cap.t0
    phone.restart_module()
    path = cap.wait()
    rep = fm.boot_report(cfg, path, t_restart)
    tag = phone.tag(25)
    verdict = "PASS silent" if rep["SILENT"] else "FAIL radiated %d run(s)" % len(rep["runs"])
    return {"verdict": verdict, "numbers": _numbers({"peak_dB": rep["peak_db"], "above10_s": rep["above_10db_s"], "clip": rep["clip"], "tag_after": tag}), "boot": rep, "restart_at_s": round(t_restart, 2)}


# ---- tone ----

def tone(cfg, phone, ms=10000, power=0):
    """One 1 kHz tone at low power on the bench frequency: carrier length, deviation, the 1 kHz line, the 5 kHz stop."""
    phone.tune(cfg.freq_hz, power)
    cap = hackrf.Capture(cfg, "tone", ms / 1000.0 + 6, cfg.lna_key, cfg.vga_key)
    time.sleep(1.5)
    # SignalDeck clamps a test tone at 5 s unless --ez lift is set (the bench tone is 10 s).
    phone.test_tone(ms, lift=ms > 5000)
    path = cap.wait()
    rep = fm.key_report(cfg, path, 1000.0)
    body = rep.get("body")
    ok = body is not None and not body["STOP"] and abs(rep["carrier_s"] - ms / 1000.0) < 1.5 and body["tone_line_hz"] > 0.5 * body["p99_hz"]
    verdict = "PASS" if ok else ("STOP deviation" if body and body["STOP"] else "FAIL")
    nums = {"carrier_s": rep["carrier_s"], "clip": rep["clip"]}
    if body:
        nums.update({"p99_Hz": body["p99_hz"], "line1k_dev_Hz": body["tone_line_hz"], "slice_max_Hz": body["slice_p99_max_hz"]})
    return {"verdict": verdict, "numbers": _numbers(nums), "key": rep}


# ---- M17 stream ----

DIBIT = {3: 1, 1: 0, -1: 2, -3: 3}


def pack_symbols(syms):
    out = bytearray()
    for i in range(0, len(syms), 4):
        b = 0
        for k in range(4):
            s = syms[i + k] if i + k < len(syms) else 3
            b = (b << 2) | DIBIT[s]
        out.append(b)
    return bytes(out)


def stream_symbols(nframes, call):
    import m17
    pre = [3, -3] * 96
    lsf_b = m17.lsf_bytes(call, call)
    syms = pre + list(m17.encode_lsf(lsf_b))
    for i in range(nframes):
        fn = i | (0x8000 if i == nframes - 1 else 0)
        syms += list(m17.encode_stream(lsf_b, fn, bytes(range(16)), i % 6))
    syms += [3, 3, 3, 3, 3, 3, -3, 3] * 24      # one EOT marker
    return syms


def stream(cfg, phone, frames=1125, lna=8, vga=8):
    """The long M17 stream from a symbol file through command 0x40; decoded from the capture, payload-exact."""
    import m17
    syms = stream_symbols(frames, cfg.bench_call)
    local = cfg.cap("stream.sym"); local.write_bytes(pack_symbols(syms))
    remote = phone.push_to_cache(local, "m17.sym")
    seconds = frames * 0.04 + 8
    phone.tune(cfg.freq_hz, 0)
    cap = hackrf.Capture(cfg, "stream", seconds, lna, vga)
    time.sleep(1.5)
    phone.cmdsym_file(remote, eot=True)
    path = cap.wait()
    dev, info = fm.demod(cfg, path)
    fs = info["fs"]; i0 = info["i0"]
    whole = m17.decode_transmission(dev[i0 + int(0.08 * fs): i0 + int(info["keyed_s"] * fs)], fs, verbose=False)
    fr = whole["frames"]
    good = sum(1 for fn, pay, err in fr if bytes(pay) == bytes(range(16)) and err == 0)
    last_fn = fr[-1][0] if fr else None
    end_bit = bool(last_fn is not None and (last_fn & 0x8000))
    seg = dev[i0 + int(0.05 * fs): i0 + int(info["keyed_s"] * fs) - int(0.05 * fs)]
    p99 = float(np.percentile(np.abs(seg - np.median(seg)), 99)) if len(seg) > fs else None
    ok = good >= frames - 1 and end_bit and info["clip_frac"] == 0 and (p99 is None or p99 < cfg.stop_hz)
    verdict = "PASS %d/%d" % (good, frames) if ok else "FAIL %d/%d good, end bit %s" % (good, frames, end_bit)
    return {"verdict": verdict, "numbers": _numbers({"frames": len(fr), "good": good, "carrier_s": round(info["keyed_s"], 2), "p99_Hz": None if p99 is None else round(p99, 1), "clip": round(info["clip_frac"], 6), "end_bit": end_bit}),
            "lsf": bool(whole.get("lsf")), "last_fn": last_fn}


# ---- heat ----

def heat(cfg, phone, seconds=45, power=0, after_s=180):
    """Zones and battery before, every 5 s during, and after a key of `seconds` (a test tone); stops on the rules."""
    before = phone.zones()
    phone.tune(cfg.freq_hz, power)
    rows = [dict(t=0, **before)]
    phone.test_tone(seconds * 1000, lift=seconds > 28)
    t0 = time.time(); stop = None
    last = before
    while time.time() - t0 < seconds + after_s:
        time.sleep(5)
        cur = phone.zones(); cur["t"] = round(time.time() - t0, 1); rows.append(cur)
        bat = cur.get("bat_c") or 0; zones = cur.get("zones", {})
        hot = max([v for v in zones.values() if v is not None] or [0])
        rise = max([(zones.get(k) or 0) - (last.get("zones", {}).get(k) or 0) for k in zones] or [0])
        if time.time() - t0 < seconds and (bat > HEAT_BAT_STOP_C or hot > HEAT_ZONE_STOP_C or rise > HEAT_RISE_STOP_C):
            stop = {"at_s": cur["t"], "bat_c": bat, "hot_c": hot, "rise_c": rise}
            phone.broadcast("cmdbyte", "--ei", "b", "0x26", "--ei", "d", "2")   # unkey: 0x26 body 2
            break
        last = cur
    ap0 = before["zones"].get("mtktsAP"); ap_peak = max([(r.get("zones", {}).get("mtktsAP") or 0) for r in rows])
    ap_end = rows[-1].get("zones", {}).get("mtktsAP")
    verdict = "STOP %s" % stop if stop else "PASS no stop"
    return {"verdict": verdict, "numbers": _numbers({"key_s": seconds, "power": power, "AP_before_C": ap0, "AP_peak_C": ap_peak, "AP_after_C": ap_end, "bat_before_C": before["bat_c"], "bat_after_C": rows[-1]["bat_c"]}), "rows": rows, "stop": stop}


# ---- receive ----

def receive(cfg, phone, seconds=6.0, vga=20, fs=2_000_000, dev_hz=2500.0):
    """A 1 kHz FM tone from the HackRF at the bench frequency while the phone records a clip: the 1 kHz line must be in it."""
    phone.tune(cfg.freq_hz, 0)
    hackrf.dummy(cfg, fs, vga)
    blob, n = hackrf.fm_iq(fs, seconds, dev_hz, tone=1000.0)
    p = cfg.cap("rx_tone.cs8"); p.write_bytes(blob)
    name = "bench_rx_%d" % int(time.time())
    phone.rx_clip(name, int(seconds * 1000) + 4000)
    time.sleep(0.8)
    hackrf.transmit(cfg, p, n, fs, vga, seconds)
    time.sleep(seconds + 3)
    local = cfg.cap(name + ".wav")
    remote = "/data/data/%s/cache/rxclip_%s.wav" % (cfg.package, name)
    got = phone.pull_app(remote, local)
    if not got or not local.exists():
        return {"verdict": "FAIL no clip pulled", "numbers": "clip %s not found" % name}
    raw = np.fromfile(str(local), dtype="<i2")
    # The clip is a WAV. Skip the header (the "data" marker, then the length).
    blob = local.read_bytes()
    at = blob.find(b"data")
    pcm = np.frombuffer(blob[at + 8:], dtype="<i2").astype(np.float64) if at >= 0 else raw.astype(np.float64)
    if len(pcm) < 8000:
        return {"verdict": "FAIL clip short", "numbers": "%d samples" % len(pcm)}
    dbfs = 20 * np.log10(np.sqrt(np.mean(pcm ** 2)) / 32768 + 1e-12)
    line = fm.goertzel(pcm, 8000, 1000.0) / 32768
    noise = np.sqrt(np.mean(pcm ** 2)) / 32768 + 1e-12
    ok = line > 0.3 * noise and dbfs > -40
    return {"verdict": "PASS line" if ok else "FAIL no 1 kHz line", "numbers": _numbers({"clip_dBFS": round(dbfs, 1), "line_rel": round(line / noise, 2), "samples": len(pcm)})}
