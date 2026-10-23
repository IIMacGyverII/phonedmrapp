#!/usr/bin/env python3
"""List every AT1846S register access in the radio-module firmware.

The firmware programs its AT1846S RF IC through two calls into the external
code region: 0xFD011220 = write(reg r0, value r1) and 0xFD01125C = read(reg r0)
(docs/grok-deep-dive/11-firmware-fw0-results.md §21). This walks the objdump
listing, tracks the constant r0/r1 built just before each call (movi, lsli,
lsl, mov), and prints one row per access with the file offset of the r1
immediate when it is a 32-bit movi, which is what a value patch edits.

Usage:
  python scripts/fw_at1846_regmap.py [listing] [--reg 0x58]

listing defaults to radio_firmware/fw1_csky_objdump.txt (regenerate with the
objdump command in ch. 11 §12). Read-only.
"""
import argparse
import re
from pathlib import Path

WRITE = "0xfd011220"
READ = "0xfd01125c"
INS = re.compile(r"^\s*([0-9a-f]+):\s+([0-9a-f]+)\s+(\S+)\s*(.*)$")

# Register 0x58 fields (OpenRTX AT1846S register table).
F58 = [
    ((9, 7), "rx_ctc_hpf_bw"),
    ((6, 6), "rx_ctc_hpf_bypass"),
    ((5, 4), "voice_lpf_bypass"),
    ((3, 3), "emph_bypass"),
    ((2, 2), "ctc_lpf_bypass"),
    ((1, 0), "voice_hpf_bypass"),
]


def decode58(v):
    parts = []
    for (hi, lo), name in F58:
        f = (v >> lo) & ((1 << (hi - lo + 1)) - 1)
        parts.append(f"{name}={f:0{hi - lo + 1}b}")
    return " ".join(parts) + f" hi6={v >> 10:06b}"


def parse(path):
    ins = []
    for line in Path(path).read_text(errors="replace").splitlines():
        m = INS.match(line)
        if m:
            ins.append((int(m.group(1), 16), m.group(2), m.group(3), m.group(4).split("//")[0].strip()))
    return ins


def accesses(ins):
    for i, (addr, _, op, args) in enumerate(ins):
        if op != "bsr" or args not in (WRITE, READ):
            continue
        regs, imm_at = {}, {}
        for a, enc, o, ar in ins[max(0, i - 6):i]:
            p = [x.strip() for x in ar.split(",")]
            try:
                if o == "movi":
                    regs[p[0]] = int(p[1], 0)
                    imm_at[p[0]] = a + 2 if len(enc) == 8 else None
                elif o == "lsli" and p[1] in regs:
                    regs[p[0]] = regs[p[1]] << int(p[2], 0)
                    imm_at[p[0]] = None
                elif o == "lsl" and p[0] in regs and p[1] in regs:
                    regs[p[0]] = regs[p[0]] << regs[p[1]]
                    imm_at[p[0]] = None
                elif o == "mov" and p[1] in regs:
                    regs[p[0]] = regs[p[1]]
                    imm_at[p[0]] = None
                elif o in ("bsr", "jsr"):
                    regs, imm_at = {}, {}
                elif p and p[0] in regs and not o.startswith(("cmp", "st.")):
                    regs.pop(p[0], None)
                    imm_at.pop(p[0], None)
            except ValueError:
                pass
        yield (addr, "W" if args == WRITE else "R", regs.get("r0"),
               regs.get("r1") if args == WRITE else None, imm_at.get("r1") if args == WRITE else None)


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("listing", nargs="?", default="radio_firmware/fw1_csky_objdump.txt")
    ap.add_argument("--reg", type=lambda s: int(s, 0))
    a = ap.parse_args()
    for addr, kind, reg, val, imm in accesses(parse(a.listing)):
        if a.reg is not None and reg != a.reg:
            continue
        r = f"0x{reg:02X}" if reg is not None else "?"
        v = f"0x{val:04X}" if val is not None else ("?" if kind == "W" else "")
        im = f"imm@0x{imm:05X}" if imm is not None else ""
        extra = decode58(val) if reg == 0x58 and val is not None else ""
        print(f"0x{addr:05X} {kind} reg={r:5} val={v:7} {im:13} {extra}".rstrip())


if __name__ == "__main__":
    main()
