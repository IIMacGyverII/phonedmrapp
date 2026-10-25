"""R-C step 1: WORK_MODE stores, SYS_INTERP_MASK bit 14, RX-RAM readers."""
import re
from pathlib import Path

text = Path(r"C:\Users\Joshua\AppData\Local\Temp\fw1718\factory.objdump.txt").read_text(
    encoding="utf-16", errors="replace")
lines = text.splitlines()
XIP = 0x0301A000
pat = re.compile(
    r"^\s*([0-9a-f]+):\s+[0-9a-f]+(?:\s+[0-9a-f]+)?\s+(\S+)\s+(.*)$")
ops = []
for ln in lines:
    m = pat.match(ln)
    if not m:
        continue
    addr = int(m.group(1), 16)
    mnem = m.group(2)
    rest = m.group(3).split("//")[0].strip()
    ops.append((addr, mnem, rest))

def file_off(addr):
    return addr - XIP

print("ops", len(ops))

def show(title, pred, limit=80):
    n = 0
    print("\n==", title)
    for addr, mnem, rest in ops:
        if pred(addr, mnem, rest):
            print("  +%05X  %s %s" % (file_off(addr), mnem, rest))
            n += 1
            if n >= limit:
                print("  ...")
                break
    print("  count", n)

show("lrw WORK_MODE", lambda a, m, r: m == "lrw" and "0x11000100" in r.split(",")[-1])
show("lrw MASK", lambda a, m, r: m == "lrw" and "0x1100039c" in r)
show("lrw LIST", lambda a, m, r: m == "lrw" and "0x11000398" in r)
def _in_rx(rest):
    m = re.search(r"0x([0-9a-f]+)\s*$", rest.replace(",", " "))
    # rest is "rN, 0xADDR"
    m = re.search(r",\s*0x([0-9a-f]+)", rest)
    if not m:
        return False
    v = int(m.group(1), 16)
    return 0x160004B0 <= v <= 0x160008DF

show("movih 0x1100", lambda a, m, r: m == "movih" and "0x1100" in r)
show("RX window lrw", lambda a, m, r: m == "lrw" and _in_rx(r))
