"""Put channel 36 back to NOAA WX4. No transmission and no firmware load unless 0x34 is not the factory image."""
import json
import sys
import time
from pathlib import Path

sys.path.insert(0, r"C:\Users\Joshua\AppData\Local\Temp\fw1718")
import camp
import uvm11_bench as b

HERE = Path(r"C:\Users\Joshua\AppData\Local\Temp\fw1718")
STATUS = HERE / "uvm11_restore_status.txt"
OUT = HERE / "uvm11_restore_result.json"
b.STATUS = STATUS
rec = {}


def status(msg):
    b.status(msg)


def main():
    if STATUS.exists():
        STATUS.unlink()
    status("restore channel 36")
    if camp.hackrf_running():
        status("RESTORE_FAILED hackrf running")
        return
    camp.adb("shell", "am", "force-stop", "com.macdmr.radio")
    time.sleep(1)
    con, local = b.pull_db("restore2")
    row = con.execute("SELECT * FROM channels WHERE _id=36").fetchone()
    before = {k: row[k] for k in ("sq", "rxFreq", "txFreq", "rxOnly", "power", "active")}
    status("before %s" % before)
    if before["txFreq"] != 162425000 or before["power"] != 0 or before["active"] != 1:
        con.close()
        local.unlink(missing_ok=True)
        status("RESTORE_FAILED tx/power/active is not the NOAA row")
        return
    con.execute(
        "UPDATE channels SET sq=?, rxFreq=?, rxOnly=? WHERE _id=36",
        (5, 162425000, 0),
    )
    con.commit()
    con.execute("PRAGMA wal_checkpoint(TRUNCATE)")
    con.commit()
    check = con.execute(
        "SELECT sq, rxFreq, txFreq, rxOnly, power, active FROM channels WHERE _id=36"
    ).fetchone()
    got = {k: check[k] for k in check.keys()}
    con.close()
    for suf in ("-wal", "-shm"):
        Path(str(local) + suf).unlink(missing_ok=True)
    status("checkpoint %s" % got)
    if got != {"sq": 5, "rxFreq": 162425000, "txFreq": 162425000, "rxOnly": 0, "power": 0, "active": 1}:
        local.unlink(missing_ok=True)
        status("RESTORE_FAILED checkpoint mismatch")
        return
    b.install_db(local)
    local.unlink(missing_ok=True)
    camp.adb("shell", "rm", "-f", "/sdcard/uvm11_restore2.db", "/sdcard/uvm11_restore2.db-wal", "/sdcard/uvm11_restore2.db-shm")
    ver = b.fresh_version(30)
    rec["version"] = ver
    if "DMR003.UV4T.V022" not in ver:
        status("factory not confirmed; loading the factory image")
        camp.adb("shell", "settings", "put", "global", "stay_on_while_plugged_in", "7")
        ver = b.load_fw(camp.FACTORY, "DMR003.UV4T.V022")
        ver = b.fresh_version(30)
        rec["version"] = ver
        camp.adb("shell", "settings", "put", "global", "stay_on_while_plugged_in", "0")
    b.wake()
    b.ui(["tap", "Intercom"])
    time.sleep(2.0)
    _, text = b.ui(["dump"])
    rec["ui_162"] = "162.425" in text
    rec["ui_467"] = "467.625" in text
    status("ui 162.425=%s 467.625=%s" % (rec["ui_162"], rec["ui_467"]))
    con, local = b.pull_db("after")
    row = con.execute(
        "SELECT sq, rxFreq, txFreq, rxOnly, power, active FROM channels WHERE _id=36"
    ).fetchone()
    rec["row"] = {k: row[k] for k in row.keys()}
    con.close()
    local.unlink(missing_ok=True)
    for suf in ("-wal", "-shm"):
        Path(str(local) + suf).unlink(missing_ok=True)
    camp.adb("shell", "rm", "-f", "/sdcard/uvm11_after.db", "/sdcard/uvm11_after.db-wal", "/sdcard/uvm11_after.db-shm")
    status("after %s" % rec["row"])
    _, stay = camp.adb("shell", "settings", "get", "global", "stay_on_while_plugged_in")
    if stay.strip() != "0":
        camp.adb("shell", "settings", "put", "global", "stay_on_while_plugged_in", "0")
        _, stay = camp.adb("shell", "settings", "get", "global", "stay_on_while_plugged_in")
    rec["stay_on"] = stay.strip()
    try:
        camp.vfo_off()
    except Exception as e:
        status("vfooff %s" % e)
    rec["end"] = b.end_state()
    OUT.write_text(json.dumps(rec, indent=2), encoding="utf-8")
    row_ok = rec["row"] == {"sq": 5, "rxFreq": 162425000, "txFreq": 162425000, "rxOnly": 0, "power": 0, "active": 1}
    ok = (
        row_ok and rec["ui_162"] and not rec["ui_467"]
        and "DMR003.UV4T.V022" in rec["version"] and rec["stay_on"] == "0"
        and rec["end"].get("signaldeck_owns") and not rec["end"].get("dmrdebug")
    )
    status("RESTORE_DONE" if ok else "RESTORE_FAILED")


if __name__ == "__main__":
    main()
