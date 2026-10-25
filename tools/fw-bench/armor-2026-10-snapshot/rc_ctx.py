"""Print a window of factory instructions around named file offsets."""
import re
from pathlib import Path

text = Path(r"C:\Users\Joshua\AppData\Local\Temp\fw1718\factory.objdump.txt").read_text(
    encoding="utf-16", errors="replace")
pat = re.compile(r"^\s*([0-9a-f]+):\s+[0-9a-f]+(?:\s+[0-9a-f]+)?\s+(\S+)\s+(.*)$")
ops = []
for ln in text.splitlines():
    m = pat.match(ln)
    if not m:
        continue
    ops.append((int(m.group(1), 16), m.group(2), m.group(3).split("//")[0].strip()))
XIP = 0x0301A000
index = {a: i for i, (a, _, _) in enumerate(ops)}

def window(off, before=2, after=14):
    addr = XIP + off
    # nearest
    i = index.get(addr)
    if i is None:
        print("\nMISSING +%05X" % off)
        return
    print("\n-- +%05X" % off)
    for j in range(max(0, i - before), min(len(ops), i + after)):
        a, m, r = ops[j]
        mark = ">" if j == i else " "
        print("%s +%05X  %s %s" % (mark, a - XIP, m, r))

for off in (0x179A2, 0x179CA, 0x17A8E, 0x17D5E, 0x17E36, 0x1828A, 0x18B40, 0x194F0,
            0x3ECF6, 0x3EDCE, 0x3EE9E, 0x179C0, 0x17D50, 0x3EDE0, 0x18B20, 0x27E50, 0x2A4C):
    window(off)
