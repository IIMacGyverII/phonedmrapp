"""UVm10 bench driver. Imports camp helpers. Does not run the old campaign.

Transmits only 467.625 MHz, low power (DiagReceiver default; no power extra).
HackRF is receive-only. Restores the factory image on every exit after a load starts.
"""
import hashlib
import json
import os
import sqlite3
import subprocess
import sys
import xml.etree.ElementTree as ET
from pathlib import Path

sys.path.insert(0, r"C:\Users\Joshua\AppData\Local\Temp\fw1718")
import camp

HERE = Path(r"C:\Users\Joshua\AppData\Local\Temp\fw1718")
IMG = camp.BUILD / "DMR003.Vm10.V022.bin"
OUT = HERE / "uvm10_result.json"
BASH = camp.BASH
REPO = camp.REPO
FACTORY_115 = 115.0
FACTORY_3500 = 250.0
FACTORY_LIM = 1827.0


def check_image():
    data = IMG.read_bytes()
    factory = camp.FACTORY.read_bytes()
    if len(data) != 378620 or len(data) != len(factory):
        raise SystemExit("image length %d" % len(data))
    ver = data[0x38464:0x38474].decode()
    if ver != "DMR003.Vm10.V022":
        raise SystemExit("version field %r" % ver)
    stub = data[0x5B000:0x5B030].hex()
    want = (
        "d0147de20fb167100f3240b36610471040b3671000327c2a43dce5009014"
        "0000000500110405001110100f0000090016"
    )
    if stub != want:
        raise SystemExit("stub mismatch")
    if b"\xc5\x84" in data[0x5B000:0x5B030]:
        raise SystemExit("stub contains 0x84C5")
    for off, repl in ((0x3074, "02e0c6bf"), (0x61FE, "7a2b"), (0x620C, "7d2b"), (0x6228, "7c2b")):
        if data[off:off + len(repl) // 2].hex() != repl:
            raise SystemExit("site 0x%X" % off)
    if data[0x6238:0x623A] != factory[0x6238:0x623A] or data[0x6238:0x623A].hex() != "7f2b":
        raise SystemExit("0 dB floor was changed")
    if data[0x6540:0x6542].hex() != "742a":
        raise SystemExit("codec init subi was changed")
    for off in (0x2C90, 0x3054, 0x344E, 0x34F2, 0x3640):
        if data[off:off + 2].hex() != "0584":
            raise SystemExit("factory 0x58 site 0x%X changed" % off)
    md5 = hashlib.md5(data).hexdigest()
    sha = hashlib.sha256(data).hexdigest()
    camp.say("image ok %s md5 %s sha256 %s" % (ver, md5, sha))
    return {"version": ver, "md5": md5, "sha256": sha, "bytes": len(data)}


def one(name, samples, meta):
    camp.say("0x34 before %s" % name)
    got = camp.read_version()
    camp.expect_version(got, "DMR003.Vm10.V022")
    camp.tune()
    result, info = camp.send_checked(name, samples, meta, camp.analyze_tones)
    packed = {
        "version": got,
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
    if packed["clip_frac"] > 0.0005:
        camp.say("clip %.4f on %s" % (packed["clip_frac"], name))
    return packed


def measured(name, samples, meta):
    last = None
    for attempt in range(3):
        last = one(name, samples, meta)
        info = {"clip_frac": last["clip_frac"], "mean_mag": last["mean_mag"]}
        if attempt < 2 and camp.adjust_gain(info):
            camp.say("retry %s after gain change" % name)
            continue
        break
    if last["clip_frac"] > 0.0005:
        raise RuntimeError("%s still clipping (%.4f)" % (name, last["clip_frac"]))
    if last["keyed_s"] < 0.4 or last["snr_db"] < 8:
        raise RuntimeError("%s weak carrier" % name)
    return last


def copy_one(src, dst):
    rc, out = camp.adb(
        "shell", "su --mount-master --context u:r:magisk:s0 -c cp %s %s" % (src, dst),
        timeout=30)
    camp.say("cp %s rc=%s %s" % (Path(src).name, rc, out.strip()[:120]))
    if rc != 0:
        raise RuntimeError("cp failed " + out)
    rc, out = camp.adb(
        "shell", "su --mount-master --context u:r:magisk:s0 -c chmod 644 %s" % dst,
        timeout=30)
    if rc != 0:
        raise RuntimeError("chmod failed " + out)


def end_state():
    rc, out = camp.adb("shell", "ls", "/sdcard/DMR/DMRDEBUG.bin")
    present = rc == 0 and "DMRDEBUG.bin" in out and "No such" not in out
    camp.say("DMRDEBUG present=%s %s" % (present, out.strip()[:80]))
    copy_one(
        "/data/data/com.macdmr.radio/databases/radio.db",
        "/sdcard/radio_db_check.db")
    copy_one(
        "/data/data/com.macdmr.radio/shared_prefs/radio.xml",
        "/sdcard/radio_prefs_check.xml")
    db_local = HERE / "radio_db_check.db"
    xml_local = HERE / "radio_prefs_check.xml"
    camp.adb("pull", "/sdcard/radio_db_check.db", str(db_local))
    camp.adb("pull", "/sdcard/radio_prefs_check.xml", str(xml_local))
    camp.adb("shell", "rm", "-f", "/sdcard/radio_db_check.db", "/sdcard/radio_prefs_check.xml")
    root = ET.parse(xml_local).getroot()
    prefs = {}
    for el in root:
        name = el.attrib.get("name", "")
        if name in ("zone", "zoneLast_4"):
            prefs[name] = el.attrib.get("value", el.text)
    con = sqlite3.connect(db_local)
    cur = con.cursor()
    rows = cur.execute(
        "SELECT _id, number, name, rxFreq, power, active FROM channels WHERE _id=36 OR number=36 OR active=1"
    ).fetchall()
    shown = []
    for _id, number, name, rx, power, active in rows:
        label = name if name == "NOAA WX4" else "(other)"
        shown.append({"id": _id, "number": number, "name": label, "rxFreq": rx, "power": power, "active": active})
    z = cur.execute("SELECT _id, name FROM zones WHERE _id=4").fetchone()
    zone = None
    if z:
        zone = {"id": z[0], "name": "Weather" if z[1] == "Weather" else "(other)"}
    con.close()
    db_local.unlink(missing_ok=True)
    xml_local.unlink(missing_ok=True)
    env = os.environ.copy()
    env["DEV"] = camp.SER
    env["MSYS_NO_PATHCONV"] = "1"
    r = subprocess.run(
        [BASH, "tools/fw-patch/bench/ui.sh", "dump"],
        cwd=str(REPO), env=env, capture_output=True, text=True, timeout=60)
    owns = "This app owns the radio" in (r.stdout or "")
    stock = "The stock app owns the radio" in (r.stdout or "")
    camp.say("owns_signaldeck=%s stock=%s prefs=%s zone=%s channels=%s" % (
        owns, stock, prefs, zone, shown))
    return {
        "dmrdebug": present,
        "prefs": prefs,
        "zone4": zone,
        "channels": shown,
        "signaldeck_owns": owns,
        "stock_owns": stock,
    }


def main():
    if camp.hackrf_running():
        raise SystemExit("hackrf_transfer already running; not starting")
    rc, out = camp.adb("get-state")
    if rc != 0 or "device" not in out:
        raise SystemExit("phone not ready: " + out.strip())
    meta_img = check_image()
    st = camp.load_state()
    st["gain"] = [24, 38]
    camp.take_gain(st)
    if [camp.gain_l, camp.gain_g] != [24, 38]:
        raise SystemExit("gain is not 24/38")
    try:
        before = camp.read_version()
        camp.say("0x34 before load: " + before)
    except Exception as e:
        before = "unavailable: " + str(e)
        camp.say("0x34 before load not in logcat: " + str(e))
    rec = {"image": meta_img, "before": before, "probe": None, "lim12": None, "error": None}
    attempted = False
    try:
        attempted = True
        ver = camp.load_image(IMG)
        camp.expect_version(ver, "DMR003.Vm10.V022")
        rec["loaded"] = ver
        samples, meta = camp.build_probe()
        if meta["amp"] != 519 or meta["db"] != 36:
            raise RuntimeError("probe stimulus amp %s db %s" % (meta["amp"], meta["db"]))
        rec["probe"] = measured("Vm10_probe", samples, meta)
        samples, meta = camp.build_limiter(12)
        if meta["amp"] != 8231 or meta["db"] != 12:
            raise RuntimeError("limiter stimulus amp %s db %s" % (meta["amp"], meta["db"]))
        rec["lim12"] = measured("Vm10_lim12", samples, meta)
        p1 = next(r["peak_hz"] for r in rec["probe"]["rows"] if r["hz"] == 1000)
        p35 = next(r["peak_hz"] for r in rec["probe"]["rows"] if r["hz"] == 3500)
        lim = rec["lim12"]["rows"][0]["peak_hz"]
        ratios = {
            "probe_1k": p1 / FACTORY_115,
            "probe_3k5": p35 / FACTORY_3500,
            "lim12": lim / FACTORY_LIM,
        }
        rec["peaks"] = {"probe_1k": p1, "probe_3k5": p35, "lim12": lim}
        rec["ratios_vs_factory"] = ratios
        camp.say("peaks 1k=%.1f (x%.3f of 115)  3.5k=%.1f (x%.3f of 250)  lim=%.1f (x%.3f of 1827)" % (
            p1, ratios["probe_1k"], p35, ratios["probe_3k5"], lim, ratios["lim12"]))
    except Exception as e:
        rec["error"] = str(e)
        camp.say("BENCH ERROR: %s" % e)
        raise
    finally:
        if camp.hackrf_running():
            camp.say("killing leftover hackrf_transfer")
            camp.kill_hackrf()
        if attempted:
            ok = camp.restore_factory(st)
            rec["factory_restored"] = ok
            try:
                rec["end"] = end_state()
            except Exception as e:
                rec["end_error"] = str(e)
                camp.say("END STATE ERROR: %s" % e)
        OUT.write_text(json.dumps(rec, indent=2), encoding="utf-8")
        camp.say("wrote %s" % OUT)
        if camp.hackrf_running():
            camp.say("HACKRF STILL RUNNING")


if __name__ == "__main__":
    main()
