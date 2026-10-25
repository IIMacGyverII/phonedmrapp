"""Find DW UART register writes around base 0x14090000. Reading only."""
import struct
import sys
from pathlib import Path

sys.path.insert(0, r"D:\Documents\code\personal\phonedmrapp\scripts")
import fw0_csky_disasm as d

data = d.BIN.read_bytes()
hits = []
# movih32 rN, #0x1409  -> bytes: (0x20|rz) EA 09 14
for i in range(0, len(data) - 3):
    if data[i + 1] == 0xEA and data[i + 2] == 0x09 and data[i + 3] == 0x14:
        rz = data[i] & 0x1F
        if data[i] == (0x20 | rz) or (data[i] & 0xE0) == 0x20:
            # confirm full encoding
            hw0 = data[i] | (data[i + 1] << 8)
            if (hw0 & 0xFFE0) == 0xEA20:
                hits.append(i)

# literal 0x14090000 and nearby registers
lits = []
for i in range(0, len(data) - 3):
    v = struct.unpack_from("<I", data, i)[0]
    if 0x14090000 <= v <= 0x140900FF and (v & 3) == 0:
        lits.append((i, v))

print("movih 0x1409 sites", len(hits))
for h in hits:
    print(f"  file +0x{h:X} rz={data[h] & 0x1F}")

print("literals", len(lits))
for off, v in lits[:40]:
    print(f"  +0x{off:X} = 0x{v:X}")

# Disassemble a window after each movih and keep stores/movi
for h in hits:
    print(f"\n==== movih at +0x{h:X} ====")
    end = min(len(data), h + 180)
    for off, size, text, raw in d.iter_insns(data, h, end):
        keep = any(k in text for k in ("st", "movi", "lrw", "bsr", "rts", "push", "pop", "addi", "ori"))
        if keep or off == h:
            print(f"  {off:#07x}  {text}")
