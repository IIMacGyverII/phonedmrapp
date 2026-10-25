# R4m: command 0x40 acks from the unused gap. Does not key.
# Restores the factory image only when the tag is missing or wrong.
import hashlib
import sys
import time

sys.path.insert(0, r"C:\Users\Joshua\AppData\Local\Temp\fw1718")
import camp
import r3a3_run
import r3a3_silence

IMAGE = camp.BUILD / "DMR003.R4m0.V022.bin"
TAG = "DMR003.R4m0.V022"
EXPECT = "673884b2ce0d77bc0f2e089775b1f127a742b5bae982b2f95d3a85fc9fec92a8"


def main():
    raw = IMAGE.read_bytes()
    digest = hashlib.sha256(raw).hexdigest()
    if digest != EXPECT or raw[0x38464:0x38474] != TAG.encode():
        raise SystemExit("image is not R4m0")
    camp.say("image sha256 " + digest)
    r3a3_run.devices_ok()
    camp.adb("shell", "input", "keyevent", "224")
    camp.adb("shell", "am", "start", "-n", "com.macdmr.radio/.MainActivity")
    time.sleep(4)
    camp.tune()
    restore = False
    try:
        try:
            loaded = camp.load_image(IMAGE)
        except Exception:
            restore = True
            raise
        camp.say("loaded " + str(loaded))
        if loaded != TAG:
            restore = True
            raise SystemExit("version %s is not %s" % (loaded, TAG))
        text = camp.adb("shell", "logcat", "-d", "-s", "RadioService:I", timeout=40)[1]
        if "开机初始化完成" not in text and "module booted" not in text:
            restore = True
            raise SystemExit("banner missing")
        camp.tune()
        rc, out = camp.broadcast(["--es", "cmd", "cmdbyte", "--ei", "b", "64"])
        camp.say("cmdbyte rc=%d %s" % (rc, out.strip().replace("\n", " ")[:160]))
        time.sleep(2)
        text = camp.adb("shell", "logcat", "-d", "-s", "RadioService:I", "DiagReceiver:I", timeout=40)[1]
        hits = [ln.strip() for ln in text.splitlines()
                if "cmd=0x40" in ln or "cmd 0x40" in ln or "cmdbyte" in ln or "cmd cmdbyte" in ln]
        camp.say("ack " + " | ".join(h[-180:] for h in hits[-8:]))
    finally:
        if restore:
            r3a3_silence.restore_factory()
            camp.say("R4m0 restored factory")
        else:
            try:
                camp.tune()
            except Exception as exc:
                camp.say("tune after the run failed (%s); R4m0 stays loaded" % exc)
            else:
                camp.say("R4m0 stays loaded")


if __name__ == "__main__":
    main()
