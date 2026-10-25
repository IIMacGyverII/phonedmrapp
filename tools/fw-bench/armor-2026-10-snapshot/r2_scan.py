"""Find modem-register accesses built by movih/rotli/lrw. Read-only."""
import re
from pathlib import Path

LISTING = Path(r"D:\Documents\code\personal\phonedmrapp\radio_firmware\fw1_csky_objdump.txt")
INS = re.compile(r"^\s*([0-9a-f]+):\s+[0-9a-f]+\s+(\S+)\s*(.*)$")
OUT = Path(r"C:\Users\Joshua\AppData\Local\Temp\fw1718\r2_scan.txt")


def imm_of(text):
    text = text.split("//")[0].strip()
    parts = [p.strip() for p in text.split(",")]
    return parts


def main():
    ins = []
    for line in LISTING.read_text(errors="replace").splitlines():
        m = INS.match(line)
        if m:
            ins.append((int(m.group(1), 16), m.group(2), m.group(3).split("//")[0].strip()))
    regs = {}
    hits = []
    bitops = []
    for i, (addr, op, args) in enumerate(ins):
        p = [x.strip() for x in args.split(",")] if args else []
        wrote = None
        try:
            if op == "movi" and len(p) >= 2:
                regs[p[0]] = int(p[1], 0) & 0xFFFFFFFF
                wrote = p[0]
            elif op == "movih" and len(p) >= 2:
                regs[p[0]] = (int(p[1], 0) & 0xFFFF) << 16
                wrote = p[0]
            elif op == "rotli" and len(p) >= 3 and p[1] in regs:
                v = regs[p[1]]
                sh = int(p[2], 0) & 31
                regs[p[0]] = ((v << sh) | (v >> (32 - sh))) & 0xFFFFFFFF
                wrote = p[0]
            elif op == "lsli" and len(p) >= 3 and p[1] in regs:
                regs[p[0]] = (regs[p[1]] << int(p[2], 0)) & 0xFFFFFFFF
                wrote = p[0]
            elif op == "bseti" and len(p) >= 2 and p[0] in regs:
                regs[p[0]] = regs[p[0]] | (1 << int(p[1], 0))
                wrote = p[0]
            elif op == "bclri" and len(p) >= 2 and p[0] in regs:
                regs[p[0]] = regs[p[0]] & ~(1 << int(p[1], 0))
                wrote = p[0]
            elif op == "addi" and len(p) >= 2 and p[0] in regs:
                regs[p[0]] = (regs[p[0]] + int(p[1], 0)) & 0xFFFFFFFF
                wrote = p[0]
            elif op == "subi" and len(p) >= 2 and p[0] in regs:
                regs[p[0]] = (regs[p[0]] - int(p[1], 0)) & 0xFFFFFFFF
                wrote = p[0]
            elif op == "mov" and len(p) >= 2 and p[1] in regs:
                regs[p[0]] = regs[p[1]]
                wrote = p[0]
            elif op == "lrw" and len(p) >= 2:
                regs[p[0]] = int(p[1], 0) & 0xFFFFFFFF
                wrote = p[0]
            elif op in ("ld.w", "ld.b", "ld.h") and len(p) >= 2:
                wrote = p[0]
                base = p[1].replace("(", "").strip()
                # form: r2, (r3, 0x0)
                inner = args[args.find("(") + 1:args.rfind(")")]
                bp = [x.strip() for x in inner.split(",")]
                if bp and bp[0] in regs:
                    base_v = regs[bp[0]]
                    off = int(bp[1], 0) if len(bp) > 1 else 0
                    ea = (base_v + off) & 0xFFFFFFFF
                    if 0x11000000 <= ea <= 0x11001000 or 0x16000000 <= ea <= 0x16001000:
                        hits.append((addr, op, ea, None))
                regs.pop(p[0], None)
            elif op in ("st.w", "st.b", "st.h") and " (" in args:
                inner = args[args.find("(") + 1:args.rfind(")")]
                bp = [x.strip() for x in inner.split(",")]
                src = p[0]
                if bp and bp[0] in regs:
                    base_v = regs[bp[0]]
                    off = int(bp[1], 0) if len(bp) > 1 else 0
                    ea = (base_v + off) & 0xFFFFFFFF
                    if 0x11000000 <= ea <= 0x11001000 or 0x16000000 <= ea <= 0x16001000:
                        val = regs.get(src)
                        hits.append((addr, op, ea, val))
            elif op in ("bsr", "jsr", "jmp", "br", "bt", "bf", "bez", "bnez"):
                regs.clear()
            elif p and op not in ("cmpnei", "cmpnei", "cmp", "cmphs", "tst", "zextb", "zexth", "sextb"):
                # a write to p[0] we do not model drops it, unless it is a store
                if op.startswith("st"):
                    pass
                elif p[0].startswith("r"):
                    regs.pop(p[0], None)
        except (ValueError, IndexError):
            if p and p[0].startswith("r"):
                regs.pop(p[0], None)
        # bit set/clear of a value just loaded from 0x11000080
        if op in ("bseti", "bclri") and len(p) >= 2:
            # look back a few ins for ld from 0x11000080 into this reg
            for a2, o2, ar2 in ins[max(0, i - 4):i]:
                if o2 == "ld.w" and ar2.startswith(p[0] + ","):
                    bitops.append((addr, op, p[1], a2, ar2))
    lines = []
    lines.append("== stores/loads in 0x1100xxxx and 0x1600xxxx ==")
    for addr, op, ea, val in hits:
        vs = " val=0x%X" % val if val is not None else ""
        lines.append("0x%05X %s ea=0x%08X%s" % (addr, op, ea, vs))
    lines.append("== bseti/bclri shortly after a load ==")
    for row in bitops:
        lines.append("0x%05X %s bit %s after 0x%05X %s" % row)
    # literal pool words
    lines.append("== lrw immediates in range ==")
    seen = set()
    for addr, op, args in ins:
        if op != "lrw":
            continue
        try:
            v = int(args.split(",")[1].strip(), 0)
        except ValueError:
            continue
        if (0x11000000 <= v <= 0x11001000 or 0x16000000 <= v <= 0x16001000) and (v, addr) not in seen:
            lines.append("0x%05X lrw 0x%08X" % (addr, v))
    text = "\n".join(lines) + "\n"
    OUT.write_text(text, encoding="utf-8")
    print("hits", len(hits), "bitops", len(bitops), "lines", len(lines))


if __name__ == "__main__":
    main()
