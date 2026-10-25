import os, sqlite3, subprocess
from pathlib import Path
adb = os.path.join(os.environ["LOCALAPPDATA"], "Android", "Sdk", "platform-tools", "adb.exe")
ser = "5006AF1020002922"
remote = "/sdcard/radio_db_check.db"
local = Path(r"C:\Users\Joshua\AppData\Local\Temp\fw1718\radio_db_check.db")
inner = "cp /data/data/com.macdmr.radio/databases/radio.db %s && chmod 644 %s" % (remote, remote)
r = subprocess.run([adb, "-s", ser, "shell",
                    "su --mount-master --context u:r:magisk:s0 -c '%s'" % inner],
                   capture_output=True, text=True)
print("copy", r.returncode, r.stderr.strip())
r = subprocess.run([adb, "-s", ser, "pull", remote, str(local)], capture_output=True, text=True)
print("pull", r.returncode, r.stdout.strip(), r.stderr.strip())
subprocess.run([adb, "-s", ser, "shell", "rm", "-f", remote], capture_output=True)
con = sqlite3.connect(local)
cur = con.cursor()
tables = [t[0] for t in cur.execute("SELECT name FROM sqlite_master WHERE type='table'")]
print("tables", tables)
for t in tables:
    cols = [c[1] for c in cur.execute("PRAGMA table_info(%s)" % t)]
    if "rxFreq" in cols or "rx_freq" in cols or any("req" in c.lower() for c in cols):
        print(t, cols)
con.close()
