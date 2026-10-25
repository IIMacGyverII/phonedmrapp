"""UVm11 bench. Imports camp helpers. Does not run the old campaign.

Transmits only 467.625 MHz, low power, and only the -36 dBFS probe pair and one
1 kHz tone at -12 dBFS. HackRF is receive-only. Then a no-transmit receive clip
on UVm10 and on the factory image. Restores the factory image, channel 36, and
the screen-timeout setting on the way out.
"""
import hashlib
import json
import os
import sqlite3
import subprocess
import sys
import time
import wave
import xml.etree.ElementTree as ET
from pathlib import Path

sys.path.insert(0, r"C:\Users\Joshua\AppData\Local\Temp\fw1718")
import camp

HERE = Path(r"C:\Users\Joshua\AppData\Local\Temp\fw1718")
IMG = camp.BUILD / "DMR003.Vm11.V022.bin"
VM10 = camp.BUILD / "DMR003.Vm10.V022.bin"
OUT = HERE / "uvm11_result.json"
STATUS = HERE / "uvm11_status.txt"
ROW = HERE / "ch36_original.json"
BASH = camp.BASH
REPO = camp.REPO
FACTORY_115 = 115.0
FACTORY_3500 = 250.0
FACTORY_LIM = 1827.0
DB = "/data/data/com.macdmr.radio/databases/radio.db"
TABLE = bytes.fromhex("86008e0088008200bd00ba00b600b400b000ae00")

rec = {}
stay_saved = None
edited = False
channel_restored = False
factory_verified = False
pushed_any = False


def status(msg):
    camp.say(msg)
    with STATUS.open("a", encoding="utf-8") as f:
        f.write(msg + "\n")


def db_of(byte):
    godl = byte & 0x3F
    return (32 - (godl & 0x1F)) if godl & 0x20 else -godl


def check_vm11():
    data = IMG.read_bytes()
    factory = camp.FACTORY.read_bytes()
    if len(data) != 378620 or len(data) != len(factory):
        raise SystemExit("image length %d" % len(data))
    ver = data[0x38464:0x38474].decode()
    if ver != "DMR003.Vm11.V022":
        raise SystemExit("version field %r" % ver)
    if data[0x36ED0:0x36EE4] != TABLE:
        raise SystemExit("dac table %s" % data[0x36ED0:0x36EE4].hex())
    fac = factory[0x36ED0:0x36EE4]
    for i in range(10):
        if db_of(data[0x36ED0 + 2 * i]) != db_of(fac[2 * i]) - 6:
            raise SystemExit("slot %d is not 6 dB down" % i)
        if data[0x36ED0 + 2 * i + 1] != 0 or not (data[0x36ED0 + 2 * i] & 0x80):
            raise SystemExit("slot %d shape" % i)
    if data[0x3074:0x3078] != factory[0x3074:0x3078]:
        raise SystemExit("stub redirect was touched")
    if data[0x5B000:0x5B030] != factory[0x5B000:0x5B030]:
        raise SystemExit("stub tail was touched")
    for off in (0xADE, 0xE16, 0x61E8):
        if data[off:off + 2].hex() != "8874":
            raise SystemExit("zextb changed at 0x%X" % off)
    if data[0x6538:0x653A].hex() != "542b":
        raise SystemExit("init immediate changed")
    for off in (0x2C90, 0x3054, 0x344E, 0x34F2, 0x3640):
        if data[off:off + 2].hex() != "0584":
            raise SystemExit("0x58 site 0x%X" % off)
    for off in (0x61FE, 0x620C, 0x6228, 0x6238):
        if data[off:off + 2] != factory[off:off + 2]:
            raise SystemExit("adc site 0x%X" % off)
    md5 = hashlib.md5(data).hexdigest()
    sha = hashlib.sha256(data).hexdigest()
    status("image ok %s md5 %s sha256 %s" % (ver, md5, sha))
    return {"version": ver, "md5": md5, "sha256": sha, "bytes": len(data)}


def check_vm10():
    data = VM10.read_bytes()
    if data[0x38464:0x38474] != b"DMR003.Vm10.V022":
        raise SystemExit("UVm10 image missing or wrong")
    md5 = hashlib.md5(data).hexdigest()
    status("uvm10 image md5 %s" % md5)
    return md5


class LoadFail(RuntimeError):
    def __init__(self, rc, pushed, stdout, stderr):
        super().__init__("load failed rc %s pushed %s" % (rc, pushed))
        self.rc = rc
        self.pushed = pushed
        self.stdout = stdout or ""
        self.stderr = stderr or ""


def wake():
    camp.adb("shell", "input", "keyevent", "224")
    time.sleep(0.4)
    camp.adb("shell", "wm", "dismiss-keyguard")
    camp.adb("shell", "input", "keyevent", "82")
    time.sleep(0.8)


def load_once(bin_path, expect):
    global pushed_any
    gitp = str(bin_path).replace("\\", "/")
    status("loading %s" % bin_path.name)
    env = os.environ.copy()
    env["DEV"] = camp.SER
    env["MSYS_NO_PATHCONV"] = "1"
    r = subprocess.run(
        [BASH, "tools/fw-patch/bench/fwload_stock.sh", gitp],
        cwd=str(REPO), env=env, capture_output=True, text=True, timeout=420)
    out = r.stdout or ""
    err = r.stderr or ""
    pushed = "pushed md5" in out
    if pushed:
        pushed_any = True
    status(out.strip()[-500:])
    if r.returncode != 0:
        raise LoadFail(r.returncode, pushed, out, err)
    import re
    m = re.search(r"DMR003\.[A-Za-z0-9]{4}\.V022", out)
    if not m:
        raise LoadFail(r.returncode, pushed, out, "no version token")
    camp.expect_version(m.group(0), expect)
    status("loaded " + m.group(0))
    return m.group(0)


def load_fw(bin_path, expect):
    last = None
    for attempt in range(2):
        wake()
        try:
            return load_once(bin_path, expect)
        except LoadFail as e:
            last = e
            status("LOAD FAIL %s" % e)
            if e.pushed or "hand back failed" not in e.stdout:
                raise
            status("hand back failed before any flash write; waking and retrying once")
            camp.adb("shell", "input", "swipe", "540", "400", "540", "1500", "300")
            time.sleep(0.6)
    raise last


def latest_version(timeout=8):
    deadline = time.time() + timeout
    last = ""
    while time.time() < deadline:
        _, out = camp.adb("shell", "logcat", "-d", "-s", "RadioService:I", timeout=40)
        hits = [ln for ln in out.splitlines() if "module DMR" in ln]
        if hits:
            last = hits[-1]
            ver = last.split("module ")[-1].strip()
            status("0x34 " + ver)
            return ver
        time.sleep(1)
    raise RuntimeError("no 0x34 answer (%s)" % last[-180:])


def version_before_key(expect):
    try:
        ver = latest_version(timeout=5)
    except RuntimeError:
        status("0x34 line not in the buffer; restarting SignalDeck so it asks again")
        camp.adb("shell", "am", "force-stop", "com.macdmr.radio")
        time.sleep(1)
        wake()
        camp.adb("shell", "am", "start", "-n", "com.macdmr.radio/.MainActivity")
        ver = latest_version(timeout=25)
        camp.tune()
    camp.expect_version(ver, expect)
    return ver


def one(name, samples, meta, expect):
    version_before_key(expect)
    if not camp.hackrf_running():
        pass
    else:
        raise RuntimeError("hackrf_transfer already running")
    camp.tune()
    result, info = camp.send_checked(name, samples, meta, camp.analyze_tones)
    packed = {
        "rows": result.get("rows"),
        "worst_hz": result.get("worst_hz"),
        "lag_s": result.get("lag_s"),
        "amp": result.get("amp"),
        "db": result.get("db"),
        "offset_hz": info.get("offset_hz"),
        "mean_mag": info.get("mean_mag"),
        "clip_frac": info.get("clip_frac"),
        "snr_db": info.get("snr_db"),
        "keyed_s": info.get("keyed_s"),
        "gain": [camp.gain_l, camp.gain_g],
    }
    return packed


def measured(name, samples, meta, expect):
    last = None
    for attempt in range(3):
        last = one(name, samples, meta, expect)
        info = {"clip_frac": last["clip_frac"], "mean_mag": last["mean_mag"]}
        if attempt < 2 and camp.adjust_gain(info):
            status("retry %s after gain change" % name)
            continue
        break
    if last["clip_frac"] > 0.0005:
        raise RuntimeError("%s still clipping (%.4f)" % (name, last["clip_frac"]))
    if last["keyed_s"] < 0.4 or last["snr_db"] < 8:
        raise RuntimeError("%s weak carrier" % name)
    return last


def su(cmd, timeout=40):
    rc, out = camp.adb(
        "shell",
        'su --mount-master --context u:r:magisk:s0 -c "%s"' % cmd,
        timeout=timeout)
    status("su rc=%s %s" % (rc, out.strip().replace("\n", " ")[:180]))
    return rc, out


def copy_opt(src, dst):
    rc, out = camp.adb(
        "shell", "su --mount-master --context u:r:magisk:s0 -c cp %s %s" % (src, dst),
        timeout=30)
    return rc == 0, out


def pull_db(tag):
    local = HERE / ("radio_%s.db" % tag)
    wal = HERE / ("radio_%s.db-wal" % tag)
    shm = HERE / ("radio_%s.db-shm" % tag)
    for p in (local, wal, shm):
        if p.exists():
            p.unlink()
    ok, out = copy_opt(DB, "/sdcard/uvm11_%s.db" % tag)
    if not ok:
        raise RuntimeError("db copy failed " + out)
    copy_opt(DB + "-wal", "/sdcard/uvm11_%s.db-wal" % tag)
    copy_opt(DB + "-shm", "/sdcard/uvm11_%s.db-shm" % tag)
    camp.adb("pull", "/sdcard/uvm11_%s.db" % tag, str(local), timeout=60)
    camp.adb("pull", "/sdcard/uvm11_%s.db-wal" % tag, str(wal), timeout=60)
    if not local.exists() or local.stat().st_size < 1000:
        raise RuntimeError("pulled db missing")
    con = sqlite3.connect(str(local))
    con.row_factory = sqlite3.Row
    try:
        con.execute("PRAGMA wal_checkpoint(FULL)")
    except sqlite3.DatabaseError as e:
        status("checkpoint %s" % e)
    return con, local


def close_pulled(con, local):
    con.close()
    local.unlink(missing_ok=True)
    for suf in ("-wal", "-shm"):
        p = Path(str(local) + suf)
        p.unlink(missing_ok=True)
    camp.adb("shell", "rm", "-f",
             "/sdcard/uvm11_edit.db", "/sdcard/uvm11_read.db", "/sdcard/uvm11_orig.db",
             "/sdcard/uvm11_edit.db-wal", "/sdcard/uvm11_read.db-wal", "/sdcard/uvm11_orig.db-wal",
             "/sdcard/uvm11_edit.db-shm", "/sdcard/uvm11_read.db-shm", "/sdcard/uvm11_orig.db-shm")


def row_brief(row):
    keys = ("_id", "number", "name", "rxFreq", "txFreq", "power", "band", "sq", "active", "rxOnly", "softSq")
    out = {}
    for k in keys:
        if k in row.keys():
            v = row[k]
            out[k] = v if k != "name" else ("NOAA WX4" if v == "NOAA WX4" else "(other)")
    return out


def install_db(local):
    rc, out = camp.adb("push", str(local), "/sdcard/uvm11_edit.db", timeout=60)
    if rc != 0:
        raise RuntimeError("push db failed " + out)
    for extra in ("-wal", "-shm", "-journal"):
        su("rm -f %s%s" % (DB, extra))
    rc, out = su("cp /sdcard/uvm11_edit.db %s" % DB)
    if rc != 0:
        raise RuntimeError("install db failed " + out)
    su("chown 10200:10200 %s" % DB)
    su("chmod 660 %s" % DB)
    su("restorecon %s" % DB)
    rc, out = su("ls -l %s" % DB)
    if "u0_a200" not in out and "10200" not in out:
        raise RuntimeError("db is not owned by the app: " + out)


def edit_quiet_channel():
    global edited
    camp.adb("shell", "am", "force-stop", "com.macdmr.radio")
    time.sleep(1)
    con, local = pull_db("orig")
    cols = [r[1] for r in con.execute("PRAGMA table_info(channels)")]
    row = con.execute("SELECT * FROM channels WHERE _id=36").fetchone()
    if row is None:
        close_pulled(con, local)
        raise RuntimeError("no channel _id 36")
    original = {k: row[k] for k in row.keys()}
    brief = row_brief(row)
    if not (162_400_000 <= original["txFreq"] <= 162_550_000):
        close_pulled(con, local)
        raise RuntimeError("channel 36 tx %s is not receive-only; not editing" % original["txFreq"])
    sets = ["sq=0", "rxFreq=467625000"]
    if "rxOnly" in cols:
        sets.append("rxOnly=1")
    con.execute("UPDATE channels SET %s WHERE _id=36" % ", ".join(sets))
    con.commit()
    check = con.execute("SELECT sq, rxFreq, txFreq, power FROM channels WHERE _id=36").fetchone()
    if check["sq"] != 0 or check["rxFreq"] != 467625000 or check["txFreq"] != original["txFreq"]:
        close_pulled(con, local)
        raise RuntimeError("quiet edit did not stick")
    if check["power"] != 0:
        status("channel 36 power is %s" % check["power"])
    if original.get("active") != 1:
        con.close()
        local.unlink(missing_ok=True)
        raise RuntimeError("channel 36 is not the active channel; not editing")
    con.execute("PRAGMA wal_checkpoint(TRUNCATE)")
    con.commit()
    con.close()
    for suf in ("-wal", "-shm"):
        Path(str(local) + suf).unlink(missing_ok=True)
    again = sqlite3.connect(str(local))
    got = again.execute("SELECT sq, rxFreq, txFreq FROM channels WHERE _id=36").fetchone()
    again.close()
    if got[0] != 0 or got[1] != 467625000 or got[2] != original["txFreq"]:
        local.unlink(missing_ok=True)
        raise RuntimeError("checkpoint lost the quiet edit")
    edited = True
    install_db(local)
    local.unlink(missing_ok=True)
    ROW.write_text(json.dumps(brief), encoding="utf-8")
    status("channel 36 parked for the clip: rx 467.625 sq 0, tx left at %s" % original["txFreq"])
    return brief


def restore_channel(original):
    global channel_restored
    if not original:
        return
    camp.adb("shell", "am", "force-stop", "com.macdmr.radio")
    time.sleep(1)
    con, local = pull_db("restore")
    cols = [r[1] for r in con.execute("PRAGMA table_info(channels)")]
    assigns = ["sq=?", "rxFreq=?"]
    vals = [original["sq"], original["rxFreq"]]
    if "rxOnly" in cols and "rxOnly" in original:
        assigns.append("rxOnly=?")
        vals.append(original["rxOnly"])
    vals.append(36)
    con.execute("UPDATE channels SET %s WHERE _id=36" % ", ".join(assigns), vals)
    con.commit()
    con.execute("PRAGMA wal_checkpoint(TRUNCATE)")
    con.commit()
    check = con.execute("SELECT sq, rxFreq, txFreq FROM channels WHERE _id=36").fetchone()
    con.close()
    for suf in ("-wal", "-shm"):
        Path(str(local) + suf).unlink(missing_ok=True)
    if check["sq"] != original["sq"] or check["rxFreq"] != original["rxFreq"]:
        local.unlink(missing_ok=True)
        raise RuntimeError("channel restore mismatch")
    if check["txFreq"] != original["txFreq"]:
        local.unlink(missing_ok=True)
        raise RuntimeError("txFreq changed during the clip")
    install_db(local)
    local.unlink(missing_ok=True)
    channel_restored = True
    status("channel 36 restored sq=%s rx=%s" % (original["sq"], original["rxFreq"]))


def ui(args):
    env = os.environ.copy()
    env["DEV"] = camp.SER
    env["MSYS_NO_PATHCONV"] = "1"
    r = subprocess.run(
        [BASH, "tools/fw-patch/bench/ui.sh", *args],
        cwd=str(REPO), env=env, capture_output=True, text=True, timeout=70)
    return r.returncode, r.stdout or ""


def confirm_quiet(original):
    wake()
    ui(["tap", "Intercom"])
    time.sleep(1.2)
    rc, text = ui(["dump"])
    keep = []
    for ln in text.splitlines():
        if any(s in ln for s in ("467.625", "162.425", "NOAA", "Squelch", "LOW PWR", "UHF")):
            keep.append(ln.strip()[:120])
    _, log = camp.adb("shell", "logcat", "-d", "-s", "RadioService:I", timeout=40)
    vfo = "VFO 467" in log
    refused = "MCU rejected 0x23" in log or "The radio refused" in log
    status("quiet ui %s" % " | ".join(keep[:8]))
    status("quiet flags vfo=%s refused=%s" % (vfo, refused))
    if vfo or refused or "467.625" not in text:
        raise RuntimeError("quiet channel was not applied")
    if "162.425" not in text:
        status("tx frequency was not on screen; the database row is the check")
    con, local = pull_db("read")
    row = con.execute("SELECT sq, rxFreq, txFreq, power, active FROM channels WHERE _id=36").fetchone()
    brief = row_brief(row) if row else {}
    close_pulled(con, local)
    status("quiet db %s" % brief)
    if not row or row["sq"] != 0 or row["rxFreq"] != 467625000 or row["txFreq"] != original["txFreq"]:
        raise RuntimeError("database row is not the quiet channel")
    if row["power"] != 0:
        raise RuntimeError("channel 36 power is not low")
    return brief


def rxclip(name):
    if camp.hackrf_running():
        raise RuntimeError("hackrf running; not recording")
    rc, out = camp.broadcast(["--es", "cmd", "rxclip", "--ei", "ms", "10000", "--es", "name", name])
    status("rxclip %s rc=%s %s" % (name, rc, out.strip().replace("\n", " ")[:140]))
    deadline = time.time() + 20
    seen = ""
    while time.time() < deadline:
        _, log = camp.adb("shell", "logcat", "-d", "-s", "DiagReceiver:I", timeout=30)
        hits = [ln for ln in log.splitlines() if "rxclip" in ln and name in ln]
        if any("rxclip done" in h for h in hits):
            seen = hits[-1]
            break
        time.sleep(1)
    status("rxclip log %s" % (seen.strip()[-180:] if seen else "no done line"))
    time.sleep(0.6)
    remote = "/data/data/com.macdmr.radio/cache/rxclip_%s.wav" % name
    ok, cout = copy_opt(remote, "/sdcard/rxclip_%s.wav" % name)
    if not ok:
        raise RuntimeError("clip copy failed " + cout)
    local = HERE / ("rxclip_%s.wav" % name)
    camp.adb("pull", "/sdcard/rxclip_%s.wav" % name, str(local), timeout=60)
    camp.adb("shell", "rm", "-f", "/sdcard/rxclip_%s.wav" % name)
    if not local.exists():
        raise RuntimeError("clip missing")
    return wav_level(local)


def wav_level(path):
    w = wave.open(str(path), "rb")
    fs, ch = w.getframerate(), w.getnchannels()
    raw = w.readframes(w.getnframes())
    w.close()
    import numpy as np
    x = np.frombuffer(raw, dtype="<i2").astype(np.float64)
    if ch > 1:
        x = x.reshape(-1, ch)[:, 0]
    n = len(x)
    if n == 0:
        return {"file": path.name, "samples": 0, "rms": 0.0, "dbfs": -99.0, "zero_frac": 1.0}
    rms = float(np.sqrt(np.mean(x * x)))
    dbfs = float(20 * np.log10(rms / 32768.0)) if rms > 0 else -99.0
    spec = np.abs(np.fft.rfft(x * np.hanning(n)))
    spec[0] = 0
    med = float(np.median(spec)) + 1e-12
    return {
        "file": path.name,
        "samples": n,
        "seconds": n / fs,
        "fs": fs,
        "rms": rms,
        "dbfs": dbfs,
        "zero_frac": float(np.mean(x == 0)),
        "peak_to_median": float(spec.max() / med),
    }


def start_app():
    wake()
    camp.adb("shell", "am", "start", "-n", "com.macdmr.radio/.MainActivity")


def fresh_version(timeout=25):
    camp.adb("shell", "logcat", "-c")
    camp.adb("shell", "am", "force-stop", "com.macdmr.radio")
    time.sleep(1)
    start_app()
    return latest_version(timeout)


def end_state():
    rc, out = camp.adb("shell", "ls", "/sdcard/DMR/DMRDEBUG.bin")
    present = rc == 0 and "DMRDEBUG.bin" in out and "No such" not in out
    if present:
        camp.adb("shell", "rm", "-f", "/sdcard/DMR/DMRDEBUG.bin")
        rc, out = camp.adb("shell", "ls", "/sdcard/DMR/DMRDEBUG.bin")
        present = rc == 0 and "DMRDEBUG.bin" in out and "No such" not in out
    status("DMRDEBUG present=%s" % present)
    copy_opt(DB, "/sdcard/radio_db_check.db")
    copy_opt("/data/data/com.macdmr.radio/shared_prefs/radio.xml", "/sdcard/radio_prefs_check.xml")
    db_local = HERE / "radio_db_check.db"
    xml_local = HERE / "radio_prefs_check.xml"
    camp.adb("pull", "/sdcard/radio_db_check.db", str(db_local))
    camp.adb("pull", "/sdcard/radio_prefs_check.xml", str(xml_local))
    camp.adb("shell", "rm", "-f", "/sdcard/radio_db_check.db", "/sdcard/radio_prefs_check.xml")
    prefs = {}
    if xml_local.exists():
        root = ET.parse(xml_local).getroot()
        for el in root:
            name = el.attrib.get("name", "")
            if name in ("zone", "zoneLast_4"):
                prefs[name] = el.attrib.get("value", el.text)
    shown = []
    zone = None
    if db_local.exists():
        con = sqlite3.connect(db_local)
        rows = con.execute(
            "SELECT _id, number, name, rxFreq, txFreq, sq, power, active FROM channels WHERE _id=36 OR active=1"
        ).fetchall()
        for _id, number, name, rx, tx, sq, power, active in rows:
            label = name if name == "NOAA WX4" else "(other)"
            shown.append({
                "id": _id, "number": number, "name": label, "rxFreq": rx, "txFreq": tx,
                "sq": sq, "power": power, "active": active,
            })
        z = con.execute("SELECT _id, name FROM zones WHERE _id=4").fetchone()
        if z:
            zone = {"id": z[0], "name": "Weather" if z[1] == "Weather" else "(other)"}
        con.close()
    db_local.unlink(missing_ok=True)
    xml_local.unlink(missing_ok=True)
    ui(["tap", "Device"])
    time.sleep(1)
    _, dump = ui(["dump"])
    owns = "This app owns the radio" in dump
    stock = "The stock app owns the radio" in dump
    status("owns_signaldeck=%s stock=%s prefs=%s zone=%s channels=%s" % (owns, stock, prefs, zone, shown))
    return {
        "dmrdebug": present,
        "prefs": prefs,
        "zone4": zone,
        "channels": shown,
        "signaldeck_owns": owns,
        "stock_owns": stock,
    }


def tx_measure():
    samples, meta = camp.build_probe()
    if meta["amp"] != 519 or meta["db"] != 36:
        raise RuntimeError("probe amp %s db %s" % (meta["amp"], meta["db"]))
    probe = measured("Vm11_probe", samples, meta, "DMR003.Vm11.V022")
    samples, meta = camp.build_limiter(12)
    if meta["amp"] != 8231 or meta["db"] != 12:
        raise RuntimeError("limiter amp %s db %s" % (meta["amp"], meta["db"]))
    lim = measured("Vm11_lim12", samples, meta, "DMR003.Vm11.V022")
    p1 = next(r["peak_hz"] for r in probe["rows"] if r["hz"] == 1000)
    p35 = next(r["peak_hz"] for r in probe["rows"] if r["hz"] == 3500)
    peak = lim["rows"][0]["peak_hz"]
    ratios = {"probe_1k": p1 / FACTORY_115, "probe_3k5": p35 / FACTORY_3500, "lim12": peak / FACTORY_LIM}
    status("peaks 1k=%.1f (x%.3f of 115)  3.5k=%.1f (x%.3f of 250)  lim=%.1f (x%.3f of 1827)" % (
        p1, ratios["probe_1k"], p35, ratios["probe_3k5"], peak, ratios["lim12"]))
    return {"probe": probe, "lim12": lim, "peaks": {"probe_1k": p1, "probe_3k5": p35, "lim12": peak},
            "ratios_vs_factory": ratios}


def receive_pair(original):
    load_fw(VM10, "DMR003.Vm10.V022")
    ver = latest_version(timeout=15)
    camp.expect_version(ver, "DMR003.Vm10.V022")
    time.sleep(2)
    confirm_quiet(original)
    a = rxclip("uvm10")
    status("uvm10 clip rms %.1f  %.1f dBFS  zeros %.3f" % (a["rms"], a["dbfs"], a["zero_frac"]))
    load_fw(camp.FACTORY, "DMR003.UV4T.V022")
    ver = latest_version(timeout=15)
    camp.expect_version(ver, "DMR003.UV4T.V022")
    time.sleep(2)
    confirm_quiet(original)
    b = rxclip("factory")
    status("factory clip rms %.1f  %.1f dBFS  zeros %.3f" % (b["rms"], b["dbfs"], b["zero_frac"]))
    delta = None
    if a["rms"] > 0 and b["rms"] > 0:
        delta = float(a["dbfs"] - b["dbfs"])
        status("receive delta UVm10 minus factory = %+.2f dB" % delta)
    return {"uvm10_version": "DMR003.Vm10.V022", "uvm10": a, "factory": b, "delta_db": delta}


def main():
    global stay_saved, factory_verified
    if STATUS.exists():
        STATUS.unlink()
    status("UVm11 bench start")
    if camp.hackrf_running():
        raise SystemExit("hackrf_transfer already running; not starting")
    rc, out = camp.adb("get-state")
    if rc != 0 or "device" not in out:
        raise SystemExit("phone not ready: " + out.strip())
    meta = check_vm11()
    vm10_md5 = check_vm10()
    rec["image"] = meta
    rec["uvm10_md5"] = vm10_md5
    st = camp.load_state()
    st["gain"] = [24, 38]
    camp.take_gain(st)
    if [camp.gain_l, camp.gain_g] != [24, 38]:
        raise SystemExit("gain is not 24/38")
    _, stay = camp.adb("shell", "settings", "get", "global", "stay_on_while_plugged_in")
    stay_saved = stay.strip() or "0"
    status("stay_on was %s" % stay_saved)
    camp.adb("shell", "settings", "put", "global", "stay_on_while_plugged_in", "7")
    camp.adb("shell", "logcat", "-G", "16M")
    original = None
    try:
        try:
            load_fw(IMG, "DMR003.Vm11.V022")
            rec["tx"] = tx_measure()
        except Exception as e:
            rec["tx_error"] = str(e)
            status("BENCH ERROR tx: %s" % e)
        finally:
            if camp.hackrf_running():
                status("killing leftover hackrf_transfer")
                camp.kill_hackrf()
            try:
                camp.vfo_off()
            except Exception as e:
                status("vfooff: %s" % e)
        if camp.hackrf_running():
            raise RuntimeError("hackrf still running after transmit")
        try:
            original = edit_quiet_channel()
            rec["channel_parked"] = original
            rec["rx"] = receive_pair(original)
        except Exception as e:
            rec["rx_error"] = str(e)
            status("BENCH ERROR rx: %s" % e)
    finally:
        if camp.hackrf_running():
            camp.kill_hackrf()
        if edited and not channel_restored:
            try:
                restore_channel(original)
            except Exception as e:
                rec["channel_restore_error"] = str(e)
                status("BENCH ERROR channel restore: %s" % e)
        try:
            ver = fresh_version(30)
            rec["final_version"] = ver
            factory_verified = "DMR003.UV4T.V022" in ver
        except Exception as e:
            rec["final_version_error"] = str(e)
            status("final 0x34: %s" % e)
        if not factory_verified:
            status("factory not confirmed; loading the factory image")
            try:
                ver = load_fw(camp.FACTORY, "DMR003.UV4T.V022")
                factory_verified = True
                rec["final_version"] = ver
                # The load applies whatever channel 36 is now. Restore again if the
                # park is still in the database, then ask for the version once more.
                if edited and channel_restored:
                    ver = fresh_version(30)
                    rec["final_version"] = ver
                    factory_verified = "DMR003.UV4T.V022" in ver
            except Exception as e:
                rec["factory_restore_error"] = str(e)
                status("FACTORY RESTORE FAILED: %s" % e)
        if stay_saved is not None:
            camp.adb("shell", "settings", "put", "global", "stay_on_while_plugged_in", stay_saved)
            _, now = camp.adb("shell", "settings", "get", "global", "stay_on_while_plugged_in")
            rec["stay_on"] = now.strip()
            status("stay_on restored to %s" % now.strip())
        try:
            camp.vfo_off()
        except Exception:
            pass
        camp.adb("shell", "rm", "-f",
                 "/sdcard/uvm11_edit.db", "/sdcard/uvm11_read.db", "/sdcard/uvm11_orig.db",
                 "/sdcard/uvm11_restore.db", "/sdcard/uvm11_edit.db-wal", "/sdcard/uvm11_read.db-wal",
                 "/sdcard/uvm11_orig.db-wal", "/sdcard/uvm11_restore.db-wal",
                 "/sdcard/uvm11_edit.db-shm", "/sdcard/uvm11_read.db-shm",
                 "/sdcard/uvm11_orig.db-shm", "/sdcard/uvm11_restore.db-shm")
        time.sleep(2)
        try:
            rec["end"] = end_state()
        except Exception as e:
            rec["end_error"] = str(e)
            status("END STATE ERROR: %s" % e)
        rec["factory_verified"] = factory_verified
        rec["channel_restored"] = channel_restored or not edited
        OUT.write_text(json.dumps(rec, indent=2), encoding="utf-8")
        status("wrote %s" % OUT)
        if camp.hackrf_running():
            status("HACKRF STILL RUNNING")
        ok = factory_verified and rec["channel_restored"] and not rec.get("channel_restore_error")
        status("UVM11_DONE" if ok else "UVM11_FAILED")


if __name__ == "__main__":
    main()
