# Owner request: load the factory image. No key. Leaves the VFO on 467.625.
import sys

sys.path.insert(0, r"C:\Users\Joshua\AppData\Local\Temp\fw1718")
import camp
import r3a3_run
import r3a3_silence

if not camp.FACTORY.exists() or camp.FACTORY.stat().st_size != 378620:
    raise SystemExit("factory image missing or wrong size")
r3a3_run.devices_ok()
camp.adb("shell", "input", "keyevent", "224")
camp.tune()
ver = r3a3_silence.restore_factory()
text = camp.adb("shell", "logcat", "-d", "-s", "RadioService:I", timeout=40)[1]
hits = [ln.strip() for ln in text.splitlines()
        if "module DMR" in ln or "module booted" in ln or "VFO 467.625" in ln]
camp.say("tail " + " | ".join(h[-180:] for h in hits[-6:]))
camp.say("factory restore done: " + ver)
