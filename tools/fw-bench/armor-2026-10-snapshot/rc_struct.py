"""Stores through a live 0x34808 pointer, and callers of the RX-RAM copy."""
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

def dest_of(mnem, rest):
    if mnem.startswith("st") or mnem.startswith("cmp") or mnem in ("bt", "bf", "br", "bsr", "jmp", "bez", "bnez"):
        return None
    tok = rest.split(",")[0].strip()
    return tok if tok.startswith("r") else None

print("== stores through 0x34808")
for i, (a, m, r) in enumerate(ops):
    if m != "lrw" or not r.endswith("0x34808"):
        continue
    reg = r.split(",")[0].strip()
    for j in range(i + 1, min(i + 20, len(ops))):
        mm, rr = ops[j][1], ops[j][2]
        if mm.startswith("st.") and ("(%s," % reg) in rr:
            print("+%05X  %s %s" % (ops[j][0] - XIP, mm, rr))
        if dest_of(mm, rr) == reg:
            break

print("\n== bsr to RX copy +0x2A4C")
for a, m, r in ops:
    if m == "bsr" and "0x301ca4c" in r:
        print("+%05X  %s %s" % (a - XIP, m, r))

print("\n== 0x16A function from +19470")
idx = next(i for i, (a, _, _) in enumerate(ops) if a - XIP == 0x19470)
for a, m, r in ops[idx:idx + 40]:
    print("+%05X  %s %s" % (a - XIP, m, r))
    if m == "jmp":
        break
