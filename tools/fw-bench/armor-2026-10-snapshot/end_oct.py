import os, sqlite3, subprocess, xml.etree.ElementTree as ET
from pathlib import Path

adb = os.path.join(os.environ["LOCALAPPDATA"], "Android", "Sdk", "platform-tools", "adb.exe")
ser = "5006AF1020002922"
tmp = Path(r"C:\Users\Joshua\AppData\Local\Temp\fw1718")
db_local = tmp / "radio_db_check.db"
xml_local = tmp / "radio_prefs_check.xml"

def sh(args):
    r = subprocess.run([adb, "-s", ser, *args], capture_output=True, text=True)
    return r.returncode, (r.stdout or "") + (r.stderr or "")

su = "su --mount-master --context u:r:magisk:s0 -c"
rc, out = sh(["shell", su, "cp /data/data/com.macdmr.radio/databases/radio.db /sdcard/radio_db_check.db; cp /data/data/com.macdmr.radio/shared_prefs/radio.xml /sdcard/radio_prefs_check.xml; chmod 644 /sdcard/radio_db_check.db /sdcard/radio_prefs_check.xml"])
print("copy", rc, out.strip())
rc, out = sh(["pull", "/sdcard/radio_db_check.db", str(db_local)])
print("pull-db", rc, out.strip().splitlines()[-1] if out.strip() else "")
rc, out = sh(["pull", "/sdcard/radio_prefs_check.xml", str(xml_local)])
print("pull-xml", rc, out.strip().splitlines()[-1] if out.strip() else "")
sh(["shell", "rm", "-f", "/sdcard/radio_db_check.db", "/sdcard/radio_prefs_check.xml"])

root = ET.parse(xml_local).getroot()
wanted = {}
for el in root:
    name = el.attrib.get("name", "")
    if name in ("zone", "zoneLast_4"):
        wanted[name] = el.attrib.get("value", el.text)
print("prefs", wanted)

con = sqlite3.connect(db_local)
cur = con.cursor()
# Channel 36 only. Print the name only when it is the weather channel.
rows = cur.execute(
    "SELECT _id, number, name, rxFreq, power, active FROM channels WHERE _id=36 OR number=36"
).fetchall()
for _id, number, name, rx, power, active in rows:
    shown = name if name == "NOAA WX4" else "(not NOAA WX4)"
    print("channel", _id, number, shown, rx, "power", power, "active", active)
z = cur.execute("SELECT _id, name FROM zones WHERE _id=4").fetchone()
if z:
    print("zone4", z[0], "Weather" if z[1] == "Weather" else "(not Weather)")
else:
    print("zone4 missing")
con.close()
db_local.unlink(missing_ok=True)
xml_local.unlink(missing_ok=True)
print("local copies deleted")
