import subprocess, os
from pathlib import Path
adb = str(Path(os.environ["LOCALAPPDATA"]) / "Android" / "Sdk" / "platform-tools" / "adb.exe")
ser = "5006AF1020002922"
cmd = "ls /system/bin/tiny* /vendor/bin/tiny* /system/bin/mixer* /vendor/bin/mixer* 2>/dev/null; echo ---; find /system /vendor /odm -name 'tinymix' -o -name 'tinypcminfo' -o -name 'mixer_paths*.xml' 2>/dev/null"
r = subprocess.run([adb, "-s", ser, "shell", "su", "--mount-master", "--context", "u:r:magisk:s0", "-c", cmd],
                   capture_output=True, timeout=60)
out = (r.stdout or b"") + (r.stderr or b"")
Path(r"C:\Users\Joshua\AppData\Local\Temp\fw1718\tinypath.txt").write_bytes(out)
print("rc", r.returncode)
print(out.decode("utf-8", "replace")[:4000])
