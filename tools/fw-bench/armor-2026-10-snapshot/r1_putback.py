"""Put the pre-edit radio.db back. Does not transmit."""
import json
import sqlite3
import subprocess
import sys
import time
import xml.etree.ElementTree as ET
from pathlib import Path

sys.path.insert(0, r"C:\Users\Joshua\AppData\Local\Temp\fw1718")
import camp

HERE = Path(r"C:\Users\Joshua\AppData\Local\Temp\fw1718")
SRC = HERE / "radio_sd_before.db"
DB = "/data/data/com.macdmr.radio/databases/radio.db"
PREFS = "/data/data/com.macdmr.radio/shared_prefs/radio.xml"
STATUS = HERE / "r1_putback_status.txt"


def status(msg):
    line = time.strftime("%H:%M:%S ") + str(msg)
    print(line, flush=True)
    with STATUS.open("a", encoding="utf-8") as f:
        f.write(line + "\n")


def su(cmd):
    rc, out = camp.adb(
        "shell", 'su --mount-master --context u:r:magisk:s0 -c "%s"' % cmd, timeout=40)
    status("su %s -> %s" % (cmd[:70], out.strip().replace("\n", " ")[:140]))
    return rc, out


def main():
    con = sqlite3.connect(str(SRC))
    con.row_factory = sqlite3.Row
    row = con.execute("SELECT name, rxFreq, txFreq, sq, power, active, rxOnly FROM channels WHERE _id=36").fetchone()
    bench = con.execute("SELECT COUNT(*) FROM channels WHERE name='R1 BENCH'").fetchone()[0]
    con.close()
    if dict(row) != {
        "name": "NOAA WX4", "rxFreq": 162425000, "txFreq": 162425000,
        "sq": 5, "power": 0, "active": 1, "rxOnly": 0,
    } or bench:
        raise SystemExit("source db is not the pre-edit NOAA database")
    if camp.hackrf_running():
        raise SystemExit("hackrf running; not touching the phone")
    camp.adb("shell", "am", "force-stop", "com.macdmr.radio")
    time.sleep(1)
    rc, out = camp.adb("push", str(SRC), "/sdcard/r1_putback.db", timeout=60)
    if rc != 0:
        raise SystemExit("push failed " + out)
    for extra in ("-wal", "-shm", "-journal"):
        su("rm -f %s%s" % (DB, extra))
    rc, out = su("cp /sdcard/r1_putback.db %s" % DB)
    if rc != 0:
        raise SystemExit("cp failed")
    su("chown 10200:10200 %s" % DB)
    su("chmod 660 %s" % DB)
    su("restorecon %s" % DB)
    rc, out = su("ls -l %s" % DB)
    if "u0_a200" not in out and "10200" not in out:
        raise SystemExit("owner " + out)
    camp.adb("shell", "logcat", "-c")
    camp.adb("shell", "input", "keyevent", "224")
    camp.adb("shell", "wm", "dismiss-keyguard")
    camp.adb("shell", "am", "start", "-n", "com.macdmr.radio/.MainActivity")
    ver = ""
    for _ in range(25):
        _, log = camp.adb("shell", "logcat", "-d", "-s", "RadioService:I", timeout=30)
        hits = [ln for ln in log.splitlines() if "module DMR" in ln]
        if hits:
            ver = hits[-1].split("module ")[-1].strip()
            break
        time.sleep(1)
    status("0x34 " + ver)
    if not ver.startswith("DMR003.UV4T.V022"):
        raise SystemExit("version " + ver)
    time.sleep(2)
    env = __import__("os").environ.copy()
    env["DEV"] = camp.SER
    env["MSYS_NO_PATHCONV"] = "1"
    subprocess.run([camp.BASH, "tools/fw-patch/bench/ui.sh", "tap", "Intercom"], cwd=str(camp.REPO), env=env, timeout=70)
    time.sleep(1)
    r = subprocess.run([camp.BASH, "tools/fw-patch/bench/ui.sh", "dump"], cwd=str(camp.REPO), env=env, capture_output=True, text=True, timeout=70)
    text = r.stdout or ""
    keep = [ln.strip()[:120] for ln in text.splitlines() if any(s in ln for s in ("162.425", "467.625", "NOAA", "R1", "WX"))]
    status("ui " + " | ".join(keep[:8]))
    if "162.425" not in text or "467.625" in text or "R1 BENCH" in text:
        raise SystemExit("intercom is not back on 162.425")
    camp.adb("shell", "am", "force-stop", "com.macdmr.radio")
    time.sleep(1)
    su("cp %s /sdcard/r1_final.db" % DB)
    camp.adb("pull", "/sdcard/r1_final.db", str(HERE / "radio_r1_final.db"), timeout=60)
    con = sqlite3.connect(str(HERE / "radio_r1_final.db"))
    con.row_factory = sqlite3.Row
    try:
        con.execute("PRAGMA wal_checkpoint(FULL)")
    except sqlite3.DatabaseError:
        pass
    got = dict(con.execute("SELECT name, rxFreq, txFreq, sq, power, active, rxOnly FROM channels WHERE _id=36").fetchone())
    bench = con.execute("SELECT COUNT(*) FROM channels WHERE name='R1 BENCH'").fetchone()[0]
    con.close()
    status("row " + json.dumps(got) + " bench " + str(bench))
    if got["name"] != "NOAA WX4" or got["rxFreq"] != 162425000 or got["active"] != 1 or bench:
        raise SystemExit("final db mismatch")
    rc, out = su("cp %s /sdcard/r1_prefs.xml" % PREFS)
    camp.adb("pull", "/sdcard/r1_prefs.xml", str(HERE / "r1_prefs_now.xml"), timeout=30)
    prefs = {}
    if (HERE / "r1_prefs_now.xml").exists():
        for el in ET.parse(str(HERE / "r1_prefs_now.xml")).getroot():
            if el.attrib.get("name") in ("zone", "zoneLast_4", "issRepeat"):
                prefs[el.attrib["name"]] = el.attrib.get("value")
    status("prefs " + json.dumps(prefs))
    camp.adb("shell", "rm", "-f", "/sdcard/r1_before.db", "/sdcard/r1_edit.db", "/sdcard/r1_restore.db",
             "/sdcard/r1_putback.db", "/sdcard/r1_final.db", "/sdcard/r1_prefs.xml", "/sdcard/r1_radio.xml")
    camp.adb("shell", "input", "keyevent", "224")
    camp.adb("shell", "am", "start", "-n", "com.macdmr.radio/.MainActivity")
    status("PUTBACK_DONE")


if __name__ == "__main__":
    try:
        main()
    except SystemExit as e:
        status("PUTBACK_FAILED " + str(e))
        raise
