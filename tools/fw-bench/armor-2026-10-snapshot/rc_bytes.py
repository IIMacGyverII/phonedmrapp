"""What value is stored into bytes 1 and 2 of 0x34808, and the 0x16A path."""
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
want = {0x1218, 0x1234, 0x15508, 0x1564C, 0x1577A, 0x15B34, 0x15CF6, 0x15F76,
        0x162E2, 0x1650A, 0x167F6, 0x19470, 0x9A2C}
index = {a - XIP: i for i, (a, _, _) in enumerate(ops)}
for off in sorted(want):
    i = index.get(off)
    if i is None:
        print("MISSING", hex(off))
        continue
    print("\n-- +%05X" % off)
    for j in range(max(0, i - 10), min(len(ops), i + 6)):
        a, m, r = ops[j]
        mark = ">" if a - XIP == off else " "
        print("%s +%05X  %s %s" % (mark, a - XIP, m, r))
