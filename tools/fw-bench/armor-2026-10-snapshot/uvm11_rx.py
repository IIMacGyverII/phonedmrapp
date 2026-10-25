"""UVm11 receive check only. No transmission and no HackRF.

The quiet channel is already parked on channel 36. This loads UVm10, records
10 s of open-squelch audio, loads the factory image, records the same, then
puts channel 36 back to NOAA WX4 (162.425 MHz, squelch 5, rxOnly 0).
"""
import hashlib
import json
import sys
import time
from pathlib import Path

sys.path.insert(0, r"C:\Users\Joshua\AppData\Local\Temp\fw1718")
import camp
import uvm11_bench as b

HERE = Path(r"C:\Users\Joshua\AppData\Local\Temp\fw1718")
STATUS = HERE / "uvm11_rx_status.txt"
OUT = HERE / "uvm11_rx_result.json"
b.STATUS = STATUS

ORIGINAL = {
    "sq": 5,
    "rxFreq": 162425000,
    "txFreq": 162425000,
    "rxOnly": 0,
}
PARKED = {
    "sq": 0,
    "rxFreq": 467625000,
    "txFreq": 162425000,
    "rxOnly": 1,
    "power": 0,
    "active": 1,
}
VM10_MD5 = "bf8a842d3497b9e520f350c9af258a15"

rec = {}
stay_saved = "0"
factory_verified = False


def status(msg):
    b.status(msg)


def rm_sd(*names):
    camp.adb("shell", "rm", "-f", *names)


def read_row():
    camp.adb("shell", "am", "force-stop", "com.macdmr.radio")
    time.sleep(1)
    con, local = b.pull_db("rxpre")
    row = con.execute("SELECT * FROM channels WHERE _id=36").fetchone()
    if row is None:
        con.close()
        raise RuntimeError("no channel _id 36")
    data = {k: row[k] for k in row.keys()}
    con.close()
    local.unlink(missing_ok=True)
    for suf in ("-wal", "-shm"):
        Path(str(local) + suf).unlink(missing_ok=True)
    rm_sd("/sdcard/uvm11_rxpre.db", "/sdcard/uvm11_rxpre.db-wal", "/sdcard/uvm11_rxpre.db-shm")
    brief = {k: data.get(k) for k in ("rxFreq", "txFreq", "sq", "rxOnly", "power", "active", "band")}
    status("channel 36 now %s" % brief)
    return data


def is_parked(row):
    return all(row.get(k) == v for k, v in PARKED.items())


def is_noaa(row):
    return (
        row.get("sq") == ORIGINAL["sq"]
        and row.get("rxFreq") == ORIGINAL["rxFreq"]
        and row.get("txFreq") == ORIGINAL["txFreq"]
        and row.get("rxOnly") == ORIGINAL["rxOnly"]
        and row.get("power") == 0
        and row.get("active") == 1
    )


def write_park():
    camp.adb("shell", "am", "force-stop", "com.macdmr.radio")
    time.sleep(1)
    con, local = b.pull_db("park")
    row = con.execute(
        "SELECT txFreq, power, active FROM channels WHERE _id=36"
    ).fetchone()
    if row["txFreq"] != 162425000 or row["power"] != 0 or row["active"] != 1:
        con.close()
        local.unlink(missing_ok=True)
        raise RuntimeError("refusing to park channel 36: tx/power/active changed")
    con.execute("UPDATE channels SET sq=0, rxFreq=467625000, rxOnly=1 WHERE _id=36")
    con.commit()
    con.execute("PRAGMA wal_checkpoint(TRUNCATE)")
    con.commit()
    check = con.execute(
        "SELECT sq, rxFreq, txFreq, rxOnly, power FROM channels WHERE _id=36"
    ).fetchone()
    con.close()
    for suf in ("-wal", "-shm"):
        Path(str(local) + suf).unlink(missing_ok=True)
    if (check["sq"], check["rxFreq"], check["txFreq"], check["rxOnly"], check["power"]) != (
        0, 467625000, 162425000, 1, 0
    ):
        local.unlink(missing_ok=True)
        raise RuntimeError("park did not stick")
    b.install_db(local)
    local.unlink(missing_ok=True)
    rm_sd("/sdcard/uvm11_park.db", "/sdcard/uvm11_park.db-wal", "/sdcard/uvm11_park.db-shm")
    status("channel 36 parked rx 467.625 sq 0 rxOnly 1")


def check_images():
    data = b.VM10.read_bytes()
    if data[0x38464:0x38474] != b"DMR003.Vm10.V022":
        raise SystemExit("UVm10 version string is wrong")
    md5 = hashlib.md5(data).hexdigest()
    if md5 != VM10_MD5:
        raise SystemExit("UVm10 md5 %s" % md5)
    fac = camp.FACTORY.read_bytes()
    if fac[0x38464:0x38474] != b"DMR003.UV4T.V022":
        raise SystemExit("factory image version string is wrong")
    status("images ok uvm10 %s factory %s" % (md5, hashlib.md5(fac).hexdigest()))


def clip_one(image, expect, name):
    if camp.hackrf_running():
        raise RuntimeError("hackrf running; not recording")
    b.load_fw(image, expect)
    ver = b.latest_version(timeout=15)
    camp.expect_version(ver, expect)
    time.sleep(2)
    b.confirm_quiet(PARKED)
    ver = b.latest_version(timeout=8)
    camp.expect_version(ver, expect)
    level = b.rxclip(name)
    status(
        "%s clip rms %.1f  %.2f dBFS  zeros %.3f  peak/med %.1f  ver %s"
        % (name, level["rms"], level["dbfs"], level["zero_frac"], level["peak_to_median"], ver)
    )
    if level["samples"] < 8000 * 8:
        raise RuntimeError("%s clip is short (%s samples)" % (name, level["samples"]))
    return {"version": ver, "level": level}


def confirm_noaa():
    b.wake()
    b.ui(["tap", "Intercom"])
    time.sleep(2.0)
    _, text = b.ui(["dump"])
    shows = "162.425" in text
    stuck = "467.625" in text
    status("restored ui 162.425=%s 467.625=%s" % (shows, stuck))
    return shows and not stuck


def final_row():
    con, local = b.pull_db("final")
    row = con.execute(
        "SELECT sq, rxFreq, txFreq, rxOnly, power, active FROM channels WHERE _id=36"
    ).fetchone()
    data = {k: row[k] for k in row.keys()}
    con.close()
    local.unlink(missing_ok=True)
    for suf in ("-wal", "-shm"):
        Path(str(local) + suf).unlink(missing_ok=True)
    rm_sd("/sdcard/uvm11_final.db", "/sdcard/uvm11_final.db-wal", "/sdcard/uvm11_final.db-shm")
    status("channel 36 final %s" % data)
    return data


def main():
    global stay_saved, factory_verified
    if STATUS.exists():
        STATUS.unlink()
    status("UVm11 receive check start")
    try:
        if camp.hackrf_running():
            raise RuntimeError("hackrf_transfer is running")
        rc, out = camp.adb("get-state")
        if rc != 0 or "device" not in out:
            raise RuntimeError("phone not ready")
        check_images()
        _, stay = camp.adb("shell", "settings", "get", "global", "stay_on_while_plugged_in")
        stay_saved = stay.strip() or "0"
        status("stay_on was %s" % stay_saved)
        camp.adb("shell", "settings", "put", "global", "stay_on_while_plugged_in", "7")
        camp.adb("shell", "logcat", "-G", "16M")
        row = read_row()
        if row.get("txFreq") != 162425000 or row.get("power") != 0 or row.get("active") != 1:
            raise RuntimeError("channel 36 is not the receive-only NOAA row")
        if is_parked(row):
            status("quiet channel already parked")
        elif is_noaa(row):
            write_park()
        else:
            raise RuntimeError("channel 36 is neither parked nor the original NOAA row")
        rec["uvm10"] = clip_one(b.VM10, "DMR003.Vm10.V022", "uvm10")
        rec["factory_clip"] = clip_one(camp.FACTORY, "DMR003.UV4T.V022", "factory")
        a = rec["uvm10"]["level"]
        f = rec["factory_clip"]["level"]
        silent = a["zero_frac"] > 0.90 or f["zero_frac"] > 0.90 or a["rms"] < 1.0 or f["rms"] < 1.0
        if silent:
            rec["silence"] = True
            status("BENCH ERROR clip is silence; receive path not concluded")
        elif a["rms"] > 0 and f["rms"] > 0:
            rec["delta_db"] = float(a["dbfs"] - f["dbfs"])
            status("receive delta UVm10 minus factory = %+.2f dB" % rec["delta_db"])
    except Exception as e:
        rec["error"] = str(e)
        status("BENCH ERROR %s" % e)
    finally:
        if camp.hackrf_running():
            rec["hackrf"] = True
            status("BENCH ERROR hackrf appeared during the receive check")
        try:
            b.restore_channel(ORIGINAL)
        except Exception as e:
            rec["channel_restore_error"] = str(e)
            status("BENCH ERROR channel restore: %s" % e)
        try:
            ver = b.fresh_version(30)
            rec["final_version"] = ver
            factory_verified = "DMR003.UV4T.V022" in ver
        except Exception as e:
            rec["final_version_error"] = str(e)
            status("final 0x34: %s" % e)
        if not factory_verified:
            status("factory not confirmed; loading the factory image")
            try:
                ver = b.load_fw(camp.FACTORY, "DMR003.UV4T.V022")
                ver = b.fresh_version(30)
                rec["final_version"] = ver
                factory_verified = "DMR003.UV4T.V022" in ver
            except Exception as e:
                rec["factory_restore_error"] = str(e)
                status("FACTORY RESTORE FAILED: %s" % e)
        try:
            rec["ui_noaa"] = confirm_noaa()
        except Exception as e:
            rec["ui_error"] = str(e)
            status("restored ui: %s" % e)
        camp.adb("shell", "settings", "put", "global", "stay_on_while_plugged_in", "0")
        _, now = camp.adb("shell", "settings", "get", "global", "stay_on_while_plugged_in")
        rec["stay_on"] = now.strip()
        status("stay_on restored to %s" % now.strip())
        try:
            camp.vfo_off()
        except Exception:
            pass
        rm_sd(
            "/sdcard/uvm11_edit.db", "/sdcard/uvm11_read.db", "/sdcard/uvm11_orig.db",
            "/sdcard/uvm11_restore.db", "/sdcard/uvm11_park.db", "/sdcard/uvm11_rxpre.db",
        )
        try:
            b.su(
                "rm -f /data/data/com.macdmr.radio/cache/rxclip_uvm10.wav "
                "/data/data/com.macdmr.radio/cache/rxclip_factory.wav"
            )
        except Exception:
            pass
        time.sleep(1)
        try:
            rec["final_row"] = final_row()
        except Exception as e:
            rec["final_row_error"] = str(e)
            status("BENCH ERROR final row: %s" % e)
        try:
            rec["end"] = b.end_state()
        except Exception as e:
            rec["end_error"] = str(e)
            status("END STATE ERROR: %s" % e)
        rec["factory_verified"] = factory_verified
        rec["channel_restored"] = b.channel_restored
        OUT.write_text(json.dumps(rec, indent=2), encoding="utf-8")
        row = rec.get("final_row") or {}
        row_ok = (
            row.get("sq") == 5 and row.get("rxFreq") == 162425000
            and row.get("txFreq") == 162425000 and row.get("rxOnly") == 0
            and row.get("power") == 0 and row.get("active") == 1
        )
        ok = (
            factory_verified
            and b.channel_restored
            and row_ok
            and not rec.get("error")
            and not rec.get("silence")
            and not rec.get("hackrf")
            and not rec.get("channel_restore_error")
            and rec.get("delta_db") is not None
            and rec.get("stay_on") == "0"
        )
        status("RXCLIP_DONE" if ok else "RXCLIP_FAILED")


if __name__ == "__main__":
    main()
