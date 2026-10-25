"""Print the bit op and a short window around each 0x11000080 store, plus the FM RAM reads."""
import re
from pathlib import Path

LISTING = Path(r"D:\Documents\code\personal\phonedmrapp\radio_firmware\fw1_csky_objdump.txt")
INS = re.compile(r"^\s*([0-9a-f]+):\s+[0-9a-f]+\s+(\S+)\s*(.*)$")
ins = []
for line in LISTING.read_text(errors="replace").splitlines():
    m = INS.match(line)
    if m:
        ins.append((int(m.group(1), 16), m.group(2), m.group(3).split("//")[0].strip()))

# windows of interest
ranges = [
    (0x1660, 0x1710, "early 0x11000080"),
    (0x6B90, 0x6C30, "0x6B 0x11000080"),
    (0x17870, 0x17940, "digital source bit"),
    (0x17C90, 0x17D50, "second digital source bit"),
    (0x195C0, 0x196C0, "0x195 source bit"),
    (0x3E060, 0x3E140, "0x3E0 source bit"),
    (0x3EEC0, 0x3EFA0, "bytes inside FM ping-pong"),
]
by = {a: (op, args) for a, op, args in ins}
for lo, hi, title in ranges:
    print("\n==== %s ====" % title)
    for a, op, args in ins:
        if lo <= a <= hi:
            print("  %05X  %-7s %s" % (a, op, args))
