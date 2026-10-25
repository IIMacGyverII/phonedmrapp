# Restore the factory image and confirm the 0x34 tag. No HackRF, no key.
import sys
sys.path.insert(0, r"C:\Users\Joshua\AppData\Local\Temp\fw1718")
import camp

def main():
    if camp.hackrf_running():
        raise SystemExit("hackrf still running; not loading")
    camp.adb("shell", "input", "keyevent", "224")
    ver = camp.load_image(camp.FACTORY)
    camp.expect_version(ver, "DMR003.UV4T.V022")
    _, dbg = camp.adb("shell", "ls", "-l", "/sdcard/DMR/DMRDEBUG.bin")
    camp.say("DMRDEBUG " + dbg.strip().replace("\n", " ")[:200])
    _, text = camp.adb("shell", "logcat -d -t 80 -s RadioService:I", timeout=20)
    hits = [ln.strip() for ln in text.splitlines() if "module DMR" in ln or "module booted" in ln or "Channel 36" in ln or "0x23" in ln]
    for ln in hits[-12:]:
        camp.say(ln[-180:])
    camp.say("RESTORED " + ver)

if __name__ == "__main__":
    main()
