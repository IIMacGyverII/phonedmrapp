"""Name the stores of bytes 3 and 4 at 0x34808.

16-bit lrw (r0-r7), halfword little-endian:
  (hw & 0xFC00) == 0x1000
  disp = ((hw >> 8) & 3) << 5 | (hw & 0x1F)     # words
  rd   = (hw >> 5) & 7
  EA   = (pc & ~3) + disp * 4

32-bit lrw, two little-endian halfwords, low halfword first in the file:
  (h0 & 0xFFF0) == 0xEA80
  rd = h0 & 0xF
  EA = (pc & ~3) + h1 * 4
"""
import collections
import re

BIN = r"D:\Documents\code\personal\phonedmrapp\radio_firmware\DMR003.UV4T.V022-ORIGINAL.bin"
DUMP = r"C:\Users\Joshua\AppData\Local\Temp\fw1718\factory.objdump.txt"
data = open(BIN, "rb").read()
N = len(data)

def u16(off):
    return int.from_bytes(data[off:off + 2], "little")

def u32(off):
    return int.from_bytes(data[off:off + 4], "little")

def decode_lrw(pc):
    """Return (rd, ea, size) or None."""
    if pc + 2 > N or pc & 1:
        return None
    hw = u16(pc)
    if (hw & 0xFC00) == 0x1000:
        disp = ((hw >> 8) & 3) << 5 | (hw & 0x1F)
        rd = (hw >> 5) & 7
        ea = (pc & ~3) + disp * 4
        if 0 <= ea <= N - 4:
            return rd, ea, 2
    if pc + 4 <= N:
        h0 = u16(pc)
        h1 = u16(pc + 2)
        if (h0 & 0xFFF0) == 0xEA80:
            rd = h0 & 0xF
            ea = (pc & ~3) + h1 * 4
            if 0 <= ea <= N - 4:
                return rd, ea, 4
    return None

# Every even PC. A 32-bit insn's second halfword can alias a 16-bit decode;
# keep a hit only when the pool word is exactly the constant we ask for.
def xrefs(const):
    hits = []
    pc = 0
    while pc + 2 <= N:
        dec = decode_lrw(pc)
        if dec and u32(dec[1]) == const:
            hits.append((pc, dec[0], dec[1], dec[2]))
        pc += 2
    # Drop a 16-bit hit that is the second half of a 32-bit hit.
    longs = {pc for pc, rd, ea, sz in hits if sz == 4}
    hits = [h for h in hits if not (h[3] == 2 and (h[0] - 2) in longs)]
    return hits

BASE = 0x34808
FLAG = 0x324D7
refs = xrefs(BASE)
print(f"real lrw of 0x{BASE:x}: {len(refs)}")
print("pool slots used", len(set(ea for _, _, ea, _ in refs)))

# Objdump index, for the forward walk. Trust it only as text; the seeds are real.
line_re = re.compile(
    r"^\s*([0-9a-f]+):\s+([0-9a-f]+)\s+(\S+)(?:\s+(.*?))?(?:\s+//\s+([0-9a-fx]+))?\s*$",
    re.I,
)
by_addr = {}
for raw in open(DUMP, encoding="utf-8-sig"):
    m = line_re.match(raw.rstrip("\n"))
    if not m:
        continue
    addr = int(m.group(1), 16)
    word = m.group(2)
    size = 2 if len(word) <= 4 else 4
    by_addr[addr] = (size, m.group(3), (m.group(4) or "").strip())

pool_words = set()
pc = 0
while pc + 2 <= N:
    dec = decode_lrw(pc)
    if dec and 0 <= dec[1] <= N - 4:
        # only mark pools that some real lrw uses for ANY constant? too many.
        pass
    pc += 2
# Mark the 4 bytes of every pool that holds BASE, plus a general set of
# pools referenced by the verified seeds' own functions later.
base_pools = {ea for _, _, ea, _ in refs}

store_re = re.compile(r"^(r\d+)\s*,\s*\((r\d+)\s*,\s*(-?0x[0-9a-f]+|-?\d+)\)$", re.I)
addi_re = re.compile(r"^(r\d+)\s*,\s*(-?0x[0-9a-f]+|-?\d+)$", re.I)
mov_re = re.compile(r"^(r\d+)\s*,\s*(r\d+)$", re.I)
br_re = re.compile(r"(0x[0-9a-f]+)$", re.I)
dest_re = re.compile(r"^(r\d+)\b")

def parse_imm(text):
    return int(text, 16) if text.lower().startswith("0x") or text.lower().startswith("-0x") else int(text)

COND = {"bt", "bf", "bez", "bnez", "bhz", "blz", "bls", "bhs"}
CLOBBER = {
    "movi", "movih", "not", "bseti", "bclri", "lsli", "lsri", "asri",
    "addu", "subu", "addc", "subc", "and", "andi", "or", "ori", "xor", "xori",
    "mult", "mul", "divs", "divu", "revb", "revh", "ins", "ext", "rotli", "asrc",
    "ixh", "ixw", "zext", "sext",
}

hits = []       # stores covering 3 or 4
calls = []
escapes = []    # pointer stored to memory
all_store_pcs = collections.Counter()

def walk(seed, seed_reg):
    start = seed + by_addr[seed][0]
    work = [(start, frozenset([(f"r{seed_reg}", 0)]))]
    seen = {}
    steps = 0
    while work and steps < 6000:
        addr, state = work.pop()
        steps += 1
        if addr not in by_addr:
            continue
        # Do not execute a pool word.
        if addr in base_pools or (addr & ~3) in base_pools:
            continue
        prev = seen.get(addr)
        if prev is not None and state <= prev:
            continue
        offs = {}
        bad = set()
        for reg, off in (state if prev is None else prev | state):
            if reg in offs and offs[reg] != off:
                bad.add(reg)
            else:
                offs[reg] = off
        for reg in bad:
            offs.pop(reg, None)
        state = frozenset(offs.items())
        seen[addr] = state
        size, mnem, ops = by_addr[addr]
        ptrs = dict(state)
        fall = True
        extra = []
        sm = store_re.match(ops) if mnem.startswith("st") else None
        lm = store_re.match(ops) if mnem.startswith("ld") else None
        if sm:
            data_reg, base, imm_s = sm.group(1), sm.group(2), sm.group(3)
            if base in ptrs:
                width = {"st.b": 1, "st.h": 2, "st.w": 4}.get(mnem, 0)
                off = ptrs[base] + parse_imm(imm_s)
                all_store_pcs[(addr, mnem, off)] += 1
                if width and (3 in range(off, off + width) or 4 in range(off, off + width)):
                    hits.append((addr, mnem, width, off, data_reg, seed))
            if data_reg in ptrs and mnem == "st.w":
                escapes.append((addr, base, imm_s, ptrs[data_reg], seed))
        elif lm:
            dest, base, imm_s = lm.group(1), lm.group(2), lm.group(3)
            if dest in ptrs:
                ptrs.pop(dest, None)
        elif mnem == "mov":
            mm = mov_re.match(ops)
            if mm:
                dest, src = mm.group(1), mm.group(2)
                if src in ptrs:
                    ptrs[dest] = ptrs[src]
                elif dest in ptrs:
                    ptrs.pop(dest, None)
        elif mnem in ("addi", "subi") and addi_re.match(ops):
            am = addi_re.match(ops)
            if am.group(1) in ptrs:
                delta = parse_imm(am.group(2))
                if mnem == "subi":
                    delta = -delta
                ptrs[am.group(1)] += delta
        elif mnem == "lrw":
            mo = re.match(r"(r\d+)\s*,\s*(0x[0-9a-f]+)$", ops, re.I)
            if mo:
                dest = mo.group(1)
                if dest in ptrs and int(mo.group(2), 16) != BASE:
                    ptrs.pop(dest, None)
                if int(mo.group(2), 16) == BASE:
                    ptrs[dest] = 0
        elif mnem == "bsr":
            bm = br_re.search(ops)
            target = int(bm.group(1), 16) if bm else None
            args = tuple(sorted((r, o) for r, o in ptrs.items() if r in ("r0", "r1", "r2", "r3")))
            if args:
                calls.append((addr, target, args, seed))
        elif mnem in COND or mnem == "br":
            bm = br_re.search(ops)
            if bm:
                target = int(bm.group(1), 16)
                extra.append(target)
            if mnem == "br":
                fall = False
        elif mnem in ("jmp", "jmpi", "rts"):
            fall = False
        elif mnem == "pop" and "r15" in ops:
            fall = False
        else:
            dm = dest_re.match(ops)
            if dm and dm.group(1) in ptrs:
                if mnem.startswith("zext") or mnem.startswith("sext") or mnem in CLOBBER:
                    ptrs.pop(dm.group(1), None)
        new_state = frozenset(ptrs.items())
        if fall:
            extra.append(addr + size)
        for t in extra:
            work.append((t, new_state))

for pc, rd, ea, sz in refs:
    if pc in by_addr:
        walk(pc, rd)

print(f"\nstores covering byte 3 or 4: {len(hits)}")
seen_hit = set()
for row in hits:
    key = (row[0], row[1], row[3], row[4])
    if key in seen_hit:
        continue
    seen_hit.add(key)
    print(f"  +0x{row[0]:05x} {row[1]:5} width {row[2]} at +{row[3]} data {row[4]}")

print(f"\nunique call targets with pointer in r0-r3: ", end="")
uniq_calls = []
seen_c = set()
for pc, target, args, seed in calls:
    key = (pc, target, args)
    if key in seen_c:
        continue
    seen_c.add(key)
    uniq_calls.append((pc, target, args))
print(len(uniq_calls))
by_t = collections.Counter(t for _, t, _ in uniq_calls)
for t, n in by_t.most_common(20):
    print(f"  0x{t:x} x{n}")

print("\npointer escapes (st.w of the base):", len(escapes))
for row in escapes[:20]:
    print(f"  +0x{row[0]:05x} st.w to ({row[1]}, {row[2]}) off {row[3]}")

# Flag byte 0x324D7
flag_refs = xrefs(FLAG & ~3)  # a word lrw of the aligned address, then offset
# Also an exact lrw of the byte address is unlikely; search literals of the word address
# that contains it, and lrw of 0x324D7 itself.
print("\n--- flag ---")
for const, name in ((FLAG, "exact"), (FLAG & ~3, "aligned"), (0x324D0, "d0"), (0x32400, "400")):
    xs = xrefs(const)
    print(f"  lrw 0x{const:x} ({name}): {len(xs)}")

# Who stores through a register loaded with 0x324D4 or similar? Print lrw of nearby.
nearby = collections.Counter()
pc = 0
while pc + 2 <= N:
    dec = decode_lrw(pc)
    if dec:
        ea = dec[1]
        if 0 <= ea <= N - 4:
            val = u32(ea)
            if 0x32400 <= val <= 0x32500:
                nearby[val] += 1
    pc += 2
print("literals in 0x32400..0x32500:")
for val, n in sorted(nearby.items()):
    print(f"  0x{val:x} x{n}")
