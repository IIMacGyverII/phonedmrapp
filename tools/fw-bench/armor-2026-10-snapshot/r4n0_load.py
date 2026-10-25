# R4n: command 0x40 echoes its first body byte. This step only loads.
# It does not key. Factory is restored only when the tag or the banner is missing.
import hashlib
import sys
import time

sys.path.insert(0, r"C:\Users\Joshua\AppData\Local\Temp\fw1718")
import camp
import r3a3_run
import r3a3_silence

IMAGE = camp.BUILD / "DMR003.R4n0.V022.bin"
TAG = "DMR003.R4n0.V022"
EXPECT = "2faa75635478890e689f8685ed8e8d8ec87ddb17baba1b50fe9a7aeb36b0bbc7"


def main():
    raw = IMAGE.read_bytes()
    digest = hashlib.sha256(raw).hexdigest()
    if digest != EXPECT or raw[0x38464:0x38474] != TAG.encode():
        raise SystemExit("image is not R4n0")
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
    finally:
        if restore:
            r3a3_silence.restore_factory()
            camp.say("R4n0 restored factory")
        else:
            try:
                camp.tune()
            except Exception as exc:
                camp.say("tune after the load failed (%s); R4n0 stays loaded" % exc)
            else:
                camp.say("R4n0 stays loaded")


if __name__ == "__main__":
    main()
