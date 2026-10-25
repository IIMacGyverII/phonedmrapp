"""Wake only on a terminal line of the UVm8/UVm9 campaign. Debug goes to oct_watch.log."""
import os, sys, time

LOG = r"C:\Users\Joshua\AppData\Local\Temp\fw1718\camp.log"
DBG = r"C:\Users\Joshua\AppData\Local\Temp\fw1718\oct_watch.log"
PID = int(sys.argv[1])
OFF = int(sys.argv[2])


def alive():
    try:
        os.kill(PID, 0)
    except OSError:
        return False
    return True


def dbg(s):
    with open(DBG, "a", encoding="utf-8") as f:
        f.write(time.strftime("%H:%M:%S ") + s + "\n")


off = OFF
buf = ""
dbg("watch pid %d from byte %d" % (PID, OFF))
while True:
    with open(LOG, "rb") as f:
        f.seek(off)
        data = f.read()
    if data:
        off += len(data)
        buf += data.decode("utf-8", "replace")
        lines = buf.splitlines()
        buf = "" if buf.endswith("\n") else lines[-1]
        done = lines if buf == "" else lines[:-1]
        for ln in done:
            dbg("log " + ln)
            if "OCT PHASE DONE" in ln:
                print("DONE: " + ln, flush=True)
                sys.exit(0)
            if "FACTORY RESTORE FAILED" in ln:
                print("FAILED: " + ln, flush=True)
                sys.exit(1)
            if "STOP:" in ln:
                print("ACTION_REQUIRED: " + ln, flush=True)
    if not alive():
        # the last lines may still be buffered; one more read already happened
        if "OCT PHASE DONE" not in buf:
            print("FAILED: campaign pid %d exited before OCT PHASE DONE" % PID, flush=True)
            sys.exit(1)
    time.sleep(15)
