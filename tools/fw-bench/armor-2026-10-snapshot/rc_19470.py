"""Callers of the 0x16A function, and whether both arms store the mask."""
import re
from pathlib import Path

text = Path(r"C:\Users\Joshua\AppData\Local\Temp\fw1718\factory.objdump.txt").read_text(encoding="utf-16")
pat = re.compile(r"^\s*([0-9a-f]+):\s+[0-9a-f]+(?:\s+[0-9a-f]+)?\s+(\S+)\s+(.*)$")
ops = []
for ln in text.splitlines():
    m = pat.match(ln)
    if not m:
        continue
    ops.append((int(m.group(1), 16), m.group(2), m.group(3).split("//")[0].strip()))
XIP = 0x0301A000
print("around the +19470 callers")
for off in (0x62A8, 0x6380):
    i = next(i for i, (a, _, _) in enumerate(ops) if a - XIP == off)
    print("--")
    for a, m, r in ops[i - 12:i + 3]:
        print("+%05X %s %s" % (a - XIP, m, r))
print("bsr to +19470 / +19438")
for a, m, r in ops:
    if m == "bsr" and ("3033470" in r or "3033438" in r):
        print("+%05X %s" % (a - XIP, r))
i = next(i for i, (a, _, _) in enumerate(ops) if a - XIP == 0x194AE)
print("\n-- from 0x16B arm")
for a, m, r in ops[i:i + 30]:
    print("+%05X %s %s" % (a - XIP, m, r))
    if m == "jmp":
        break
