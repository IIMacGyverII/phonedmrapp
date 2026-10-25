import os, subprocess
from pathlib import Path
adb = os.path.join(os.environ["LOCALAPPDATA"], "Android", "Sdk", "platform-tools", "adb.exe")
ser = "5006AF1020002922"
remote = "/sdcard/radio_prefs_check.xml"
local = Path(r"C:\Users\Joshua\AppData\Local\Temp\fw1718\radio_prefs_check.xml")
inner = "cp /data/data/com.macdmr.radio/shared_prefs/radio.xml %s && chmod 644 %s" % (remote, remote)
r = subprocess.run([adb, "-s", ser, "shell",
                    "su --mount-master --context u:r:magisk:s0 -c '%s'" % inner],
                   capture_output=True, text=True)
print("copy", r.returncode, r.stdout, r.stderr)
r = subprocess.run([adb, "-s", ser, "pull", remote, str(local)], capture_output=True, text=True)
print("pull", r.returncode, r.stdout, r.stderr)
subprocess.run([adb, "-s", ser, "shell", "rm", "-f", remote], capture_output=True)
text = local.read_text(encoding="utf-8", errors="replace")
for line in text.splitlines():
    if "zoneLast_4" in line or 'name="zone"' in line or "vfo" in line.lower() and "name=" in line:
        print(line.strip()[:200])
