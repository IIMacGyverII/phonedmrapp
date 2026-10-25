"""Every WORK_MODE construction, and who writes bytes 1 and 2 of 0x34808."""
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

print("== WORK_MODE constructions (movih 4352, bseti 8)")
for i, (a, m, r) in enumerate(ops):
    if m == "movih" and r.startswith("r") and "4352" in r:
        nxt = ops[i + 1] if i + 1 < len(ops) else None
        if nxt and nxt[1] == "bseti" and ", 8" in nxt[2]:
            # following store
            tail = []
            for j in range(i + 2, min(i + 8, len(ops))):
                tail.append("+%05X %s %s" % (ops[j][0] - XIP, ops[j][1], ops[j][2]))
                if ops[j][1].startswith("st."):
                    break
            print("+%05X %s %s" % (a - XIP, m, r))
            for t in tail:
                print("   ", t)

print("\n== st.b of 0x34808 nearby (lrw base then st.b offset 1 or 2)")
for i, (a, m, r) in enumerate(ops):
    if m == "lrw" and ", 0x34808" in r:
        reg = r.split(",")[0].strip()
        for j in range(i + 1, min(i + 12, len(ops))):
            mm, rr = ops[j][1], ops[j][2]
            if mm == "st.b" and ("(%s," % reg) in rr:
                offm = re.search(r"0x([0-9a-f]+)", rr.split(",")[-1])
                if offm and int(offm.group(1), 16) in (1, 2):
                    print("+%05X st.b %s   (base lrw +%05X %s)" % (
                        ops[j][0] - XIP, rr, a - XIP, r))
            if mm == "lrw" and "0x34808" not in rr:
                break
