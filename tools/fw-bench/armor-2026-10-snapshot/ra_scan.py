"""R-A read-only scan of the factory objdump. Does not touch the radio."""
import re
from collections import defaultdict

DUMP = r"C:\Users\Joshua\AppData\Local\Temp\fw1718\factory.objdump.txt"
OUT = r"C:\Users\Joshua\AppData\Local\Temp\fw1718\ra_scan.txt"

line_re = re.compile(
    r"^\s*([0-9a-f]+):\t[0-9a-f ]+\t(\S+)\s*(.*)$", re.I
)
lit_re = re.compile(r"0x([0-9a-f]+)", re.I)

insns = []  # (addr, mnem, ops, raw)
with open(DUMP, "r", encoding="utf-8-sig", errors="replace") as f:
    for line in f:
        m = line_re.match(line.rstrip("\n"))
        if not m:
            continue
        addr = int(m.group(1), 16)
        mnem = m.group(2).lower()
        ops = m.group(3).strip()
        insns.append((addr, mnem, ops))

print(f"insns {len(insns)}")

def imm_of(ops, reg):
    """If ops assigns an immediate or literal to reg, return the int, else None.
    reg like 'r0'. Matches 'movi r0, 54' and 'lrw r0, 0x4d3ad'."""
    # movi r0, 54
    m = re.match(rf"movi\s+{reg}\s*,\s*(-?0x[0-9a-f]+|-?\d+)\b", ops, re.I)
    if m:
        return int(m.group(1), 0)
    m = re.match(rf"lrw\s+{reg}\s*,\s*(0x[0-9a-f]+)\b", ops, re.I)
    if m:
        return int(m.group(1), 16)
    return None

# index by addr
by_addr = {a: i for i, (a, _, _) in enumerate(insns)}

TARGETS = {
    0x2A4C: "copy_from_160004b0",
    0x2A78: "copy_from_16000960",
    0x2A14: "copy_to_computed",
    0x2AB4: "add_16000980_then_memcpy",  # function entry; also search bsr
    0x304E8: "memcpy",
    0x90B0: "reply_build",
    0x7DE8: "uart_send",
    0x7E94: "family21_emit",
    0x3EEEC: "four_byte_fold",
}

bsr_hits = defaultdict(list)
for i, (a, mnem, ops) in enumerate(insns):
    if mnem != "bsr":
        continue
    m = re.match(r"0x([0-9a-f]+)", ops, re.I)
    if not m:
        continue
    tgt = int(m.group(1), 16)
    if tgt in TARGETS:
        bsr_hits[tgt].append(i)

lines = []
def w(s=""):
    lines.append(s)

w(f"insns {len(insns)}")
for tgt, name in TARGETS.items():
    w(f"bsr {name} 0x{tgt:x}: {len(bsr_hits[tgt])} sites")

def last_writers(i, window=18):
    """Walk back from insns[i], return dict reg -> (addr, mnem, ops) of last write."""
    found = {}
    start = max(0, i - window)
    for j in range(i - 1, start - 1, -1):
        a, mnem, ops = insns[j]
        if mnem in ("bsr", "jsr", "jsri", "jmpi"):
            break
        # a taken branch that skips means the writer might be on another path;
        # still record, but stop at an unconditional branch.
        m = re.match(r"(r1[0-5]|r[0-9]|r1[0-2])\b", ops)
        # destination is the first register for movi/mov/lrw/ld/addu/zext
        dest = None
        mdest = re.match(
            r"(?:movi|mov|lrw|ld\.[bhw]|addu|zext[bh]|sext[bh]|lsli|lsri|and|andi|ori|xori|add|sub|not)\s+(r1[0-5]|r[0-9])\b",
            ops if False else f"{mnem} {ops}",
            re.I,
        )
        blob = f"{mnem} {ops}"
        mdest = re.match(
            r"(?:movi|mov|lrw|ld\.[bhw]|addu|zextb|zexth|sextb|sexth|lsli|lsri|and|andi|ori|add|addi|sub|subi|not|mult)\s+(r1[0-5]|r[0-9])\b",
            blob,
            re.I,
        )
        if mdest:
            dest = mdest.group(1).lower()
            if dest not in found:
                found[dest] = (a, mnem, ops)
        if mnem in ("br", "jbr", "jmp") and "r15" not in ops:
            break
    return found

w("\n=== bsr 0x2a4c argument recovery ===")
src_hist = defaultdict(int)
len_hist = defaultdict(int)
for i in bsr_hits[0x2A4C]:
    a = insns[i][0]
    wr = last_writers(i)
    def fmt(reg):
        if reg not in wr:
            return "?"
        wa, wm, wo = wr[reg]
        imm = imm_of(wo, reg) if wm in ("movi", "lrw") else None
        extra = f" = {imm}" if imm is not None else ""
        return f"{wm} {wo} @ {wa:#x}{extra}"
    r0 = wr.get("r0")
    r2 = wr.get("r2")
    r0imm = imm_of(r0[2], "r0") if r0 and r0[1] in ("movi", "lrw") else None
    r2imm = imm_of(r2[2], "r2") if r2 and r2[1] in ("movi", "lrw") else None
    if r0imm is not None and r0imm < 0x10000:
        src = 0x160004B0 + r0imm
        src_hist[r0imm] += 1
    else:
        src = None
    if r2imm is not None:
        len_hist[r2imm] += 1
    src_s = f" src {src:#x}" if src is not None else ""
    w(f"  {a:#x} r0: {fmt('r0')}{src_s}")
    w(f"       r1: {fmt('r1')}")
    w(f"       r2: {fmt('r2')}")

w("\nr0 immediate histogram (offset from 0x160004b0):")
for k in sorted(src_hist):
    w(f"  r0={k} (0x{k:x}) -> src 0x{0x160004B0+k:x}  x{src_hist[k]}")
w("r2 immediate histogram:")
for k in sorted(len_hist):
    w(f"  len={k} x{len_hist[k]}")

w("\n=== memcpy (0x304e8) sites whose r0 or r1 writer is an lrw in 0x16000000 or 0x11000000, or r2 len ===")
interesting_memcpy = 0
for i in bsr_hits[0x304E8]:
    a = insns[i][0]
    wr = last_writers(i, 12)
    blob = " ".join(f"{reg}:{wr[reg][1]} {wr[reg][2]}" for reg in ("r0", "r1", "r2") if reg in wr)
    if "0x160" in blob or "0x110" in blob or "0x4d" in blob.lower():
        interesting_memcpy += 1
        w(f"  {a:#x} {blob}")
w(f"interesting memcpy sites: {interesting_memcpy} / {len(bsr_hits[0x304E8])}")

w("\n=== reply_build / uart_send / family21 whose args mention 0x160 or 0x4d3 ===")
for tgt, name in ((0x90B0, "reply"), (0x7DE8, "uart_send"), (0x7E94, "fam21")):
    n = 0
    for i in bsr_hits[tgt]:
        a = insns[i][0]
        wr = last_writers(i, 16)
        blob = " ".join(f"{reg}:{wr[reg][2]}" for reg in ("r0", "r1", "r2", "r3") if reg in wr)
        if re.search(r"0x160|0x4d3|0x4c7|0x4d4", blob, re.I):
            n += 1
            w(f"  {name} {a:#x} {blob}")
    w(f"  {name} matching {n} / {len(bsr_hits[tgt])}")

# literal uses
w("\n=== unique 0x1600xxxx / 0x1100xxxx literals and next use ===")
use_count = defaultdict(lambda: defaultdict(int))  # addr -> mnem -> count
next_use = defaultdict(list)  # show a few examples

lit_ops_re = re.compile(r"lrw\s+(r1[0-5]|r[0-9])\s*,\s*(0x[0-9a-f]+)", re.I)
for i, (a, mnem, ops) in enumerate(insns):
    if mnem != "lrw":
        continue
    m = lit_ops_re.match(f"lrw {ops}")
    if not m:
        continue
    reg = m.group(1).lower()
    val = int(m.group(2), 16)
    if not (0x16000000 <= val <= 0x1600FFFF or 0x11000000 <= val <= 0x1100FFFF):
        continue
    # next use of reg within 6 insns: ld/st
    kind = "unread"
    for j in range(i + 1, min(i + 8, len(insns))):
        ja, jm, jo = insns[j]
        # clobber?
        if re.match(rf"(?:movi|mov|lrw|addu|add|addi)\s+{reg}\b", f"{jm} {jo}", re.I) and not jm.startswith("ld") and not jm.startswith("st"):
            # addu uses and writes
            if jm == "addu" and reg in jo:
                kind = f"addu {jo}"
                break
            kind = f"clobber {jm} {jo}"
            break
        if jm.startswith("ld.") or jm.startswith("st.") or jm in ("ld", "st"):
            if re.search(rf"\({reg}", jo) or jo.startswith(reg):
                kind = f"{jm} {jo}"
                break
        if jm == "bsr":
            kind = "passed to bsr"
            break
    use_count[val][kind.split()[0]] += 1
    if len(next_use[val]) < 4:
        next_use[val].append(f"{a:#x} {reg} -> {kind}")

def region(v):
    if v >= 0x16000000:
        return "1600"
    return "1100"

for base_name, lo, hi in (("1600", 0x16000000, 0x1600FFFF), ("1100", 0x11000000, 0x1100FFFF)):
    w(f"\n-- {base_name} --")
    keys = sorted(k for k in use_count if lo <= k <= hi)
    for k in keys:
        kinds = ", ".join(f"{m}:{c}" for m, c in sorted(use_count[k].items(), key=lambda kv: -kv[1]))
        w(f"  0x{k:08x}  {kinds}")
        for ex in next_use[k][:3]:
            w(f"      {ex}")

# rotli 22 builds of 0x1600xxxx
w("\n=== rotli that can build 0x1600xxxx ===")
nrot = 0
for i, (a, mnem, ops) in enumerate(insns):
    if mnem != "rotli":
        continue
    m = re.match(r"(r1[0-5]|r[0-9])\s*,\s*(r1[0-5]|r[0-9])\s*,\s*(\d+)", ops, re.I)
    if not m:
        continue
    nrot += 1
    sh = int(m.group(3))
    dest = m.group(1).lower()
    src = m.group(2).lower()
    # preceding movi of src
    imm = None
    for j in range(i - 1, max(0, i - 6) - 1, -1):
        ja, jm, jo = insns[j]
        if jm == "movi" and jo.lower().startswith(src):
            mm = re.search(r",\s*(-?0x[0-9a-f]+|-?\d+)", jo, re.I)
            if mm:
                imm = int(mm.group(1), 0) & 0xFFFF
            break
        if jm == "bsr":
            break
    if imm is None:
        continue
    # rotate left of a 32-bit zero-extended imm
    val = ((imm << sh) | (imm >> (32 - sh))) & 0xFFFFFFFF if sh else imm
    # also the documented 16-bit formula for sh==22
    if 0x11000000 <= val <= 0x1100FFFF or 0x16000000 <= val <= 0x1600FFFF or 0x14000000 <= val <= 0x1400FFFF:
        w(f"  {a:#x} movi {src},{imm} ({imm:#x}) rotli {sh} -> {val:#x}")
w(f"rotli insns seen: {nrot}")

# PCM window coverage: any r0 that reaches 0x160004E0..0x160008DF
w("\n=== does any recovered r0 put the 27-byte copy inside 0x160004E0-0x160008DF? ===")
PCM_LO, PCM_HI = 0x160004E0, 0x160008DF
inside = 0
outside = 0
unknown = 0
for i in bsr_hits[0x2A4C]:
    wr = last_writers(i)
    r0 = wr.get("r0")
    r2 = wr.get("r2")
    r0imm = imm_of(r0[2], "r0") if r0 and r0[1] == "movi" else None
    r2imm = imm_of(r2[2], "r2") if r2 and r2[1] == "movi" else None
    if r0imm is None:
        unknown += 1
        continue
    src = 0x160004B0 + r0imm
    length = r2imm if r2imm is not None else 1
    end = src + length - 1
    if end >= PCM_LO and src <= PCM_HI:
        inside += 1
    else:
        outside += 1
w(f"inside {inside}  outside {outside}  r0 not movi {unknown}")

text = "\n".join(lines)
with open(OUT, "w", encoding="utf-8") as f:
    f.write(text)
print(f"wrote {OUT} ({len(text)} chars)")
