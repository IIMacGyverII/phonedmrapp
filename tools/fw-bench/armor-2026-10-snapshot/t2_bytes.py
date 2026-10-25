"""Find stores that cover bytes 3 and 4 of RAM struct 0x34808.

Objdump of a raw image also decodes literal pools as code. An lrw is kept
only when the pool word it names really holds the immediate it prints.
"""
import collections
import re

BIN = r"D:\Documents\code\personal\phonedmrapp\radio_firmware\DMR003.UV4T.V022-ORIGINAL.bin"
DUMP = r"C:\Users\Joshua\AppData\Local\Temp\fw1718\factory.objdump.txt"
BASE = 0x34808

data = open(BIN, "rb").read()
line_re = re.compile(
    r"^\s*([0-9a-f]+):\s+([0-9a-f]+)\s+(\S+)(?:\s+(.*?))?(?:\s+//\s+([0-9a-fx]+))?\s*$",
    re.I,
)

insns = []
by_addr = {}
for raw in open(DUMP, encoding="utf-8-sig"):
    m = line_re.match(raw.rstrip("\n"))
    if not m:
        continue
    addr = int(m.group(1), 16)
    word = m.group(2)
    mnem = m.group(3)
    ops = (m.group(4) or "").strip()
    com = m.group(5)
    size = 2 if len(word) <= 4 else 4
    ins = (addr, size, mnem, ops, com)
    insns.append(ins)
    by_addr[addr] = ins

def pool_holds(comment, imm):
    if comment is None:
        return False
    p = int(comment, 16)
    if p < 0 or p + 4 > len(data) or (p & 3):
        return False
    return int.from_bytes(data[p:p + 4], "little") == imm

verified = []
for addr, size, mnem, ops, com in insns:
    if mnem != "lrw":
        continue
    mo = re.match(r"(r\d+)\s*,\s*(0x[0-9a-f]+)$", ops, re.I)
    if not mo:
        continue
    imm = int(mo.group(2), 16)
    if imm != BASE:
        continue
    if not pool_holds(com, imm):
        continue
    verified.append((addr, mo.group(1), int(com, 16)))

print(f"verified lrw of 0x{BASE:x}: {len(verified)}")
print("pools:", sorted(set(p for _, _, p in verified)))

# Instruction classification
dest_re = re.compile(r"^(r\d+)\b")
store_re = re.compile(
    r"^(r\d+)\s*,\s*\((r\d+)\s*,\s*(0x[0-9a-f]+|\d+)\)$", re.I
)
load_re = store_re
addi_re = re.compile(r"^(r\d+)\s*,\s*(-?0x[0-9a-f]+|-?\d+)$", re.I)
mov_re = re.compile(r"^(r\d+)\s*,\s*(r\d+)$", re.I)
br_re = re.compile(r"(0x[0-9a-f]+)$", re.I)

COND = {"bt", "bf", "bez", "bnez", "bhz", "blz", "bls", "bhs"}
STOP = {"br", "jmp", "jmpi", "rts"}

stores = []          # (pc, how, width, offset, data_reg, seed)
loads = []
calls = []           # (pc, target, args dict)
walks = []

def parse_imm(text):
    return int(text, 16) if text.lower().startswith("0x") else int(text)

# Group seeds that share a pool; analyze each seed separately but
# allow branches inside [seed, pool).
for seed, seed_reg, pool in verified:
    # state: addr -> frozenset of (reg, offset)
    start_state = frozenset([(seed_reg, 0)])
    work = [(seed + by_addr[seed][1], start_state)]
    seen = {seed: start_state}
    steps = 0
    local_stores = []
    while work and steps < 4000:
        addr, state = work.pop()
        steps += 1
        if addr >= pool or addr not in by_addr:
            continue
        prev = seen.get(addr)
        if prev is not None and state <= prev:
            continue
        merged = state if prev is None else (prev | state)
        # If the same reg has two offsets, drop that reg.
        offs = {}
        bad = set()
        for reg, off in merged:
            if reg in offs and offs[reg] != off:
                bad.add(reg)
            offs[reg] = off
        for reg in bad:
            offs.pop(reg, None)
        state = frozenset(offs.items())
        seen[addr] = state
        _a, size, mnem, ops, com = by_addr[addr]
        ptrs = dict(state)
        fall = True
        extra = []

        sm = store_re.match(ops) if mnem.startswith("st") else None
        lm = load_re.match(ops) if mnem.startswith("ld") else None
        if sm and mnem.startswith("st"):
            data_reg, base, imm_s = sm.group(1), sm.group(2), sm.group(3)
            if base in ptrs:
                width = {"st.b": 1, "st.h": 2, "st.w": 4}.get(mnem, 0)
                off = ptrs[base] + parse_imm(imm_s)
                local_stores.append((addr, mnem, width, off, data_reg))
        elif lm and mnem.startswith("ld"):
            dest, base, imm_s = lm.group(1), lm.group(2), lm.group(3)
            if base in ptrs:
                width = {"ld.b": 1, "ld.h": 2, "ld.w": 4}.get(mnem, 0)
                off = ptrs[base] + parse_imm(imm_s)
                loads.append((addr, mnem, width, off, seed))
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
        elif mnem in ("addi", "subi"):
            am = addi_re.match(ops)
            if am and am.group(1) in ptrs:
                delta = parse_imm(am.group(2))
                if mnem == "subi":
                    delta = -delta
                ptrs[am.group(1)] = ptrs[am.group(1)] + delta
            elif dest_re.match(ops) and dest_re.match(ops).group(1) in ptrs:
                ptrs.pop(dest_re.match(ops).group(1), None)
        elif mnem == "lrw":
            mo = re.match(r"(r\d+)\s*,\s*(0x[0-9a-f]+)$", ops, re.I)
            if mo:
                dest = mo.group(1)
                imm = int(mo.group(2), 16)
                if imm == BASE and pool_holds(com, imm):
                    ptrs[dest] = 0
                elif dest in ptrs:
                    ptrs.pop(dest, None)
        elif mnem == "bsr":
            bm = br_re.search(ops)
            target = int(bm.group(1), 16) if bm else None
            args = {r: o for r, o in ptrs.items() if r in ("r0", "r1", "r2", "r3")}
            if args:
                calls.append((addr, target, tuple(sorted(args.items())), seed))
        elif mnem in COND or mnem == "br":
            bm = br_re.search(ops)
            if bm:
                target = int(bm.group(1), 16)
                if seed - 0x40 <= target < pool:
                    extra.append(target)
            if mnem == "br":
                fall = False
        elif mnem in STOP:
            fall = False
        else:
            # Destination is the first register. A write clobbers a pointer.
            dm = dest_re.match(ops)
            if dm and dm.group(1) in ptrs and mnem not in ("cmpnei", "cmpne", "cmphs", "cmplt", "tst", "zextb", "zexth", "sextb", "sexth"):
                # zext* writes dest. cmp does not.
                if mnem.startswith("zext") or mnem.startswith("sext") or mnem in (
                    "movi", "movih", "not", "bseti", "bclri", "lsli", "lsri", "asri",
                    "addu", "subu", "addc", "subc", "and", "andi", "or", "ori", "xor", "xori",
                    "mult", "mul", "divs", "divu", "revb", "revh", "ins", "ext",
                ):
                    ptrs.pop(dm.group(1), None)

        new_state = frozenset(ptrs.items())
        if fall:
            nxt = addr + size
            extra.append(nxt)
        for t in extra:
            work.append((t, new_state))
    for item in local_stores:
        stores.append((*item, seed))

print(f"\nstores recorded: {len(stores)}")
cover = [s for s in stores if s[2] and s[3] <= 4 < s[3] + s[2] or s[3] == 3 or (s[2] >= 2 and s[3] <= 4 < s[3] + s[2])]
# simpler: any store whose byte range intersects {3, 4}
hit = []
for pc, mnem, width, off, data_reg, seed in stores:
    if width <= 0:
        continue
    span = range(off, off + width)
    if 3 in span or 4 in span:
        hit.append((pc, mnem, width, off, data_reg, seed))

print(f"stores covering byte 3 or 4: {len(hit)}")
for row in hit:
    print(f"  +0x{row[0]:05x}  {row[1]:5} width {row[2]} at struct+{row[3]}  data {row[4]}  seed +0x{row[5]:05x}")

print(f"\ncalls with the pointer in r0-r3: {len(calls)}")
by_target = collections.Counter(t for _, t, _, _ in calls)
for t, n in by_target.most_common(30):
    print(f"  bsr 0x{t:x}  x{n}")

print("\ncall sites (first 40):")
for pc, target, args, seed in calls[:40]:
    print(f"  +0x{pc:05x} bsr 0x{target:x} args {args} seed +0x{seed:05x}")

# Offset histogram of ALL stores through the pointer, to see a byte-walk.
print("\nstore offset histogram (offset -> count):")
hist = collections.Counter(off for _, _, _, off, _, _ in stores)
for off, n in sorted(hist.items())[:80]:
    print(f"  {off:4}  {n}")
print("  ... total distinct", len(hist), "max", max(hist) if hist else None)
