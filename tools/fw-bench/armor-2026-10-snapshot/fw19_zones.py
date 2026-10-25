"""Read battery temperature and every thermal zone over su. No radio commands."""
import os
import subprocess

ADB = os.path.join(os.environ["LOCALAPPDATA"], "Android", "Sdk", "platform-tools", "adb.exe")
SER = "192.168.1.125:5555"
SCRIPT = r"""i=0
while [ "$i" -le 25 ]; do
  z=/sys/class/thermal/thermal_zone$i
  ty=$(cat "$z/type")
  te=$(cat "$z/temp")
  echo "zone$i $ty $te"
  i=$((i + 1))
done
"""


def main():
    path = r"C:\Users\Joshua\AppData\Local\Temp\fw1718\fw19_zones.sh"
    with open(path, "w", newline="\n") as f:
        f.write(SCRIPT)
    subprocess.run([ADB, "-s", SER, "push", path, "/data/local/tmp/fw19_zones.sh"], check=True)
    r = subprocess.run(
        [ADB, "-s", SER, "shell", "su", "-c", "sh /data/local/tmp/fw19_zones.sh"],
        capture_output=True, text=True)
    print(r.stdout)
    print(r.stderr)


if __name__ == "__main__":
    main()
