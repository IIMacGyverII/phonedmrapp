"""The phone over adb: SignalDeck's diagnostics receiver, logcat, the module's version tag, thermal zones, files.

Every bench action goes through SignalDeck's `com.macdmr.radio.DIAG` broadcast (the Diagnostics flag must be on),
exactly as the Armor scripts did. Nothing here keys the radio by itself except `testtone` and `cmdsym`, and the
runner calls those only when `--arm` was given.
"""
import re
import subprocess
import time
from pathlib import Path

from common import HEAT_ZONES


class Phone:
    def __init__(self, cfg):
        self.cfg = cfg

    # ---- adb ----
    def adb(self, *args, timeout=60):
        r = subprocess.run([self.cfg.adb, "-s", self.cfg.serial, *args], capture_output=True, timeout=timeout)
        return r.returncode, (r.stdout or b"").decode("utf-8", "replace") + (r.stderr or b"").decode("utf-8", "replace")

    def ok(self):
        rc, out = self.adb("get-state", timeout=15)
        return rc == 0 and "device" in out

    def broadcast(self, cmd, *extras):
        rc, out = self.adb("shell", "am", "broadcast", "-a", "com.macdmr.radio.DIAG", "--es", "cmd", cmd, *extras)
        self.cfg.say("diag %s %s rc=%s" % (cmd, " ".join(extras), rc))
        return rc, out

    def logcat(self, seconds=30, tags=("RadioService:I", "DiagReceiver:I", "YModemManager:I")):
        _, out = self.adb("shell", "logcat", "-d", "-t", str(seconds * 40), "-s", *tags, timeout=40)
        return out

    def device_time(self):
        _, out = self.adb("shell", "date", "+%m-%dT%H:%M:%S")
        return out.strip().splitlines()[-1] if out.strip() else ""

    def wake(self):
        self.adb("shell", "input", "keyevent", "224")

    # ---- the module ----
    def tag(self, wait_s=20):
        """The module's version string as RadioService last logged it (the `0x34` reply), e.g. DMR003.FW22.V022."""
        t0 = time.time()
        while time.time() - t0 < wait_s:
            text = self.logcat(600)
            m = re.findall(r"DMR003\.[A-Za-z0-9]{4}\.V0\d\d", text)
            if m:
                return m[-1]
            time.sleep(1)
        return ""

    def restart_module(self):
        return self.broadcast("restartmodule")

    def tune(self, hz=None, power=0):
        """VFO analog at the bench frequency (low power unless power=1); waits for the channel write to settle."""
        hz = hz or self.cfg.freq_hz
        rc, out = self.broadcast("vfo", "--ei", "hz", str(hz), "--ei", "power", str(power))
        time.sleep(4.0)       # RETUNE_SETTLE_MS plus margin: the OEM channel change completes ~3 s later
        return rc, out

    def test_tone(self, ms, lift=False):
        return self.broadcast("testtone", "--ei", "ms", str(ms), *(["--ez", "lift", "true"] if lift else []))

    def fw_load(self, image_on_phone):
        return self.broadcast("fwload", "--es", "file", image_on_phone)

    def rx_clip(self, name, ms):
        return self.broadcast("rxclip", "--ei", "ms", str(ms), "--es", "name", name)

    def cmdsym_file(self, remote_path, eot=True):
        return self.broadcast("cmdsym", "--es", "path", remote_path, "--ez", "eot", "true" if eot else "false")

    # ---- files ----
    def push_to_cache(self, local, name):
        """A file into SignalDeck's cache (owned by the app), the way the Armor scripts delivered symbol files."""
        remote = "/data/local/tmp/" + name
        rc, out = self.adb("push", str(local), remote, timeout=120)
        if rc != 0:
            raise RuntimeError("push: " + out[-300:])
        uid = self.uid()
        dst = "/data/data/%s/cache/%s" % (self.cfg.package, name)
        cmd = "cp %s %s && chown %s:%s %s && chmod 600 %s" % (remote, dst, uid, uid, dst, dst)
        rc, out = self.adb("shell", "su --mount-master --context u:r:magisk:s0 -c '%s'" % cmd, timeout=60)
        if rc != 0:
            raise RuntimeError("cache: " + out[-300:])
        return dst

    def push_download(self, local, name):
        rc, out = self.adb("push", str(local), "/sdcard/Download/DMR/Firmware/" + name, timeout=300)
        if rc != 0:
            raise RuntimeError("push: " + out[-300:])
        return "/sdcard/Download/DMR/Firmware/" + name

    def pull(self, remote, local):
        rc, out = self.adb("pull", remote, str(local), timeout=120)
        return rc == 0

    def uid(self):
        _, out = self.adb("shell", "dumpsys", "package", self.cfg.package)
        m = re.search(r"userId=(\d+)", out)
        return m.group(1) if m else "10200"

    # ---- heat ----
    def zones(self):
        """Thermal zones in C by type name (root), and the battery in C from dumpsys."""
        rc, out = self.adb("shell", "su -c 'for z in /sys/class/thermal/thermal_zone*; do echo $(cat $z/type) $(cat $z/temp); done'", timeout=20)
        zones = {}
        for ln in out.splitlines():
            p = ln.split()
            if len(p) == 2:
                try:
                    v = int(p[1]); zones[p[0]] = v / 1000.0 if v > 1000 else float(v)
                except ValueError:
                    pass
        _, bat = self.adb("shell", "dumpsys", "battery")
        m = re.search(r"temperature:\s*(\d+)", bat)
        return {"bat_c": int(m.group(1)) / 10.0 if m else None, "zones": {k: zones.get(k) for k in HEAT_ZONES if k in zones}, "all": zones}
