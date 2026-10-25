# R4t air: the render matched. One 50-frame key, then three 90-frame keys on a pass.
import re
import sys
import time

sys.path.insert(0, r"C:\Users\Joshua\AppData\Local\Temp\fw1718")
import camp
import r4s0_run as s


def underruns(line):
    m = re.search(r"underrun=(\d+)", line or "")
    return int(m.group(1)) if m else -1


def passed(result):
    if result is None or result["over"]:
        return False
    und = underruns(result["underrun_line"])
    camp.say("underrun count %d" % und)
    # About 100 ms of tail after the symbols is ~800 samples. A starved stream is tens of thousands.
    return result["lsf"] and result["good"] >= 45 and result["band"] and 0 <= und <= 2000


def main():
    camp.say("50-frame capture already decoded 50 good frames; running the three 90-frame keys")
    for i in range(3):
        camp.tune()
        result = s.one_key(90, 3.8, 8, "t90_%d" % i)
        if result is None or result["over"]:
            camp.say("stopped during 90-frame run %d" % i)
            break
        camp.say("90 %d lsf %s good %s band %s und %d" % (
            i, result["lsf"], result["good"], result["band"], underruns(result["underrun_line"])))
    camp.tune()
    rc, dbg = camp.adb("shell", "ls", "/sdcard/DMR/DMRDEBUG.bin")
    camp.say("DMRDEBUG rc=%s %s" % (rc, dbg.strip().replace("\n", " ")[:120]))
    camp.say("R4t0 stays loaded")


if __name__ == "__main__":
    main()
