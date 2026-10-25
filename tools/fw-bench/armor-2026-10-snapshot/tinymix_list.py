import subprocess, os
from pathlib import Path
adb = str(Path(os.environ["LOCALAPPDATA"]) / "Android" / "Sdk" / "platform-tools" / "adb.exe")
ser = "5006AF1020002922"
# list only. Do not pass any set arguments.
r = subprocess.run([adb, "-s", ser, "shell", "su", "--mount-master", "--context", "u:r:magisk:s0", "-c", "tinymix"],
                   capture_output=True, timeout=40)
out = (r.stdout or b"") + (r.stderr or b"")
Path(r"C:\Users\Joshua\AppData\Local\Temp\fw1718\tinymix.txt").write_bytes(out)
print("rc", r.returncode, "bytes", len(out))
print(out[:1500].decode("utf-8", "replace"))
