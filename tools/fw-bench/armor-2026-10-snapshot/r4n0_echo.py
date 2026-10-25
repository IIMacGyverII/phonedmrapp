# R4n: two command 0x40 frames, body bytes 0x01 and 0x5A. Does not key.
import sys
import time

sys.path.insert(0, r"C:\Users\Joshua\AppData\Local\Temp\fw1718")
import camp


def main():
    camp.adb("shell", "input", "keyevent", "224")
    camp.adb("shell", "am", "start", "-n", "com.macdmr.radio/.MainActivity")
    time.sleep(4)
    camp.tune()
    camp.adb("shell", "logcat", "-c")
    for data in ("1", "90"):
        rc, out = camp.broadcast(["--es", "cmd", "cmdbyte", "--ei", "b", "64", "--ei", "d", data])
        camp.say("cmdbyte d=%s rc=%d %s" % (data, rc, out.strip().replace("\n", " ")[:120]))
        time.sleep(1.5)
    text = camp.adb("shell", "logcat", "-d", "-s", "RadioService:I", "DiagReceiver:I", timeout=40)[1]
    hits = [ln.strip() for ln in text.splitlines()
            if "cmd=0x40" in ln or "cmd 0x40" in ln or "body 0x" in ln or "cmdbyte" in ln]
    camp.say("echo " + " | ".join(h[-200:] for h in hits[-12:]))
    bad = [ln.strip() for ln in text.splitlines() if "cmd=0x26" in ln or "cmd=0x36" in ln]
    camp.say("keyed lines %d" % len(bad))
    camp.tune()
    camp.say("R4n0 stays loaded")


if __name__ == "__main__":
    main()
