"""Who calls the WORK_MODE setup, and what the analog unpack calls."""
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
# function entry: the push just before +0x179A2
idx = next(i for i, (a, _, _) in enumerate(ops) if a - XIP == 0x179A2)
print("context before the mask store")
for a, m, r in ops[idx - 25:idx + 2]:
    print("+%05X %s %s" % (a - XIP, m, r))
entry = None
for j in range(idx, max(0, idx - 200), -1):
    if ops[j][1] in ("push", "subi") and "r14" in ops[j][2]:
        entry = ops[j][0]
        break
print("setup entry", None if entry is None else hex(entry - XIP))
if entry:
    tgt = "%x" % entry
    print("callers of", tgt)
    for a, m, r in ops:
        if m == "bsr" and tgt in r:
            print("  +%05X %s" % (a - XIP, r))

print("\nanalog unpack calls")
i0 = next(i for i, (a, _, _) in enumerate(ops) if a - XIP == 0x9A2C)
for a, m, r in ops[i0:i0 + 80]:
    if m in ("bsr", "jmp", "br") or "34808" in r or m == "push":
        print("+%05X %s %s" % (a - XIP, m, r))
    if m == "jmp" and a - XIP > 0x9A40:
        break
