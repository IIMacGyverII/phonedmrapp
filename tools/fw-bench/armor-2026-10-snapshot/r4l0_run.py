# R4l: command 0x40 acks. Does not key. Leaves the image loaded unless the tag is wrong.
import sys
sys.path.insert(0, r"C:\Users\Joshua\AppData\Local\Temp\fw1718")
import camp
import r3a3_run

IMAGE = camp.BUILD / "DMR003.R4l0.V022.bin"
TAG = "DMR003.R4l0.V022"
EXPECT = "83fb392796b969c79dc9ace160e7aea7fa6e2fe7d161a0c1b7ab61d05c374565"

def main():
    raw = IMAGE.read_bytes()
    import hashlib
    digest = hashlib.sha256(raw).hexdigest()
    if digest != EXPECT or raw[0x38464:0x38474] != TAG.encode():
        raise SystemExit("image is not R4l0")
    camp.say("image sha256 " + digest)
    r3a3_run.devices_ok()
    camp.adb("shell", "input", "keyevent", "224")
    camp.tune()
    try:
        loaded = camp.load_image(IMAGE)
    except Exception:
        import r3a3_silence
        r3a3_silence.restore_factory()
        raise
    camp.say("loaded " + loaded)
    if loaded != TAG:
        import r3a3_silence
        r3a3_silence.restore_factory()
        raise SystemExit("version %s is not %s" % (loaded, TAG))
    text = camp.adb("shell", "logcat", "-d", "-s", "RadioService:I", timeout=40)[1]
    if "开机初始化完成" not in text and "module booted" not in text:
        raise SystemExit("banner missing")
    camp.tune()
    rc, out = camp.broadcast(["--es", "cmd", "cmdbyte", "--ei", "b", "64"])
    camp.say("cmdbyte rc=%d %s" % (rc, out.strip().replace("\n", " ")[:160]))
    import time
    time.sleep(2)
    text = camp.adb("shell", "logcat", "-d", "-s", "RadioService:I", "DiagReceiver:I", timeout=40)[1]
    hits = [ln.strip() for ln in text.splitlines() if "cmd=0x40" in ln or "cmd 0x40" in ln or "cmdbyte" in ln]
    camp.say("ack " + " | ".join(h[-180:] for h in hits[-8:]))
    camp.tune()
    camp.say("R4l0 stays loaded")

if __name__ == "__main__":
    main()
