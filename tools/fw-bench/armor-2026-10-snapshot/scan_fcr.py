"""Byte-level search for a store that can reach FCR_ADC (0x160009D7).

Objdump mis-decodes literal pools, so the factory image bytes are the authority.
A 32-bit C-SKY V2 insn is two LE halfwords, high halfword first.
"""
import re
from pathlib import Path

IMG = Path(r"D:\Documents\code\personal\phonedmrapp\radio_firmware\DMR003.UV4T.V022-ORIGINAL.bin").read_bytes()
DUMP = Path(r"D:\Documents\code\personal\phonedmrapp\radio_firmware\fw1_csky_objdump.txt").read_text(encoding="utf-8", errors="replace")
N = len(IMG)

def u16(off):
    return int.from_bytes(IMG[off:off + 2], "little")

def u32(off):
    return int.from_bytes(IMG[off:off + 4], "little")

def word(off):
    """Logical 32-bit insn: high halfword stored first."""
    return (u16(off) << 16) | u16(off + 2)

# --- constants in the image (LE words), any alignment of 2 ---
NEEDLES = {
    0x160009D7: "FCR_ADC absolute",
    0x160009C0: "codec base 0x160009C0",
    0x16000900: "codec base 0x16000900",
    0x16000017: "misread prose address",
    0x00038B5C: "RAM 0x38b5c",
}
print("== LE words ==")
for val, name in NEEDLES.items():
    b = val.to_bytes(4, "little")
    hits = []
    start = 0
    while True:
        i = IMG.find(b, start)
        if i < 0:
            break
        hits.append(i)
        start = i + 2
    print(f"  0x{val:08X} {name}: {len(hits)} hits " + ", ".join(f"0x{h:X}" for h in hits[:30]))

# --- 32-bit store class: opcode 0x37, subop 0 st.b / 1 st.h / 2 st.w ---
# byte span relative to base: st.b disp, st.h disp*2 len 2, st.w disp*4 len 4
FCR = 0xD7          # from 0x16000900
FCR_FROM_C0 = 0x17  # from 0x160009C0

def covers(base_off, disp, kind):
    scale = (1, 2, 4)[kind]
    start = disp * scale
    return start <= base_off < start + scale

print("\n== 32-bit st.b/st.h/st.w whose disp would cover FCR_ADC from either base ==")
KIND = ("st.b", "st.h", "st.w")
n32 = 0
for off in range(0, N - 4, 2):
    hi = u16(off)
    if (hi >> 10) != 0x37:
        continue
    w = word(off)
    sub = (w >> 12) & 0xF
    if sub > 2:
        continue
    disp = w & 0xFFF
    rz = (w >> 21) & 31
    rx = (w >> 16) & 31
    hit = []
    if covers(FCR, disp, sub):
        hit.append("from 0x16000900")
    if covers(FCR_FROM_C0, disp, sub):
        hit.append("from 0x160009C0")
    if not hit:
        continue
    n32 += 1
    print(f"  0x{off:05X} {KIND[sub]} r{rz}, (r{rx}, disp 0x{disp:X})  {', '.join(hit)}  word {w:08X}")
print(f"  count {n32}")

# --- 16-bit stores. disp5, rx is 5 bits for st.b and 3 bits for st.h/st.w ---
print("\n== 16-bit stores that could cover +0x17 (base 0x160009C0). +0xD7 is out of disp5 range ==")
n16 = 0
for off in range(0, N - 2, 2):
    hw = u16(off)
    top = hw & 0xF800
    if top == 0xA000 or (0xA000 <= hw <= 0xA7FF):
        # st.b only when bit 12 of the halfword is the top of a 5-bit rx and the
        # opcode is 10100. st.h is 10101 (0xA800). Keep st.b as (hw & 0xF800) == 0xA000.
        pass
    if (hw & 0xF800) == 0xA000:
        disp = hw & 0x1F
        if disp != 0x17 and not (disp <= 0x17 < disp + 1):
            continue
        if disp != 0x17:
            continue
        rx = (hw >> 8) & 0x1F
        rz = (hw >> 5) & 0x7
        n16 += 1
        print(f"  0x{off:05X} st.b r{rz}, (r{rx}, 0x17)  hw {hw:04X}")
    elif (hw & 0xF800) == 0xA800:
        disp = hw & 0x1F
        start = disp * 2
        if not (start <= 0x17 < start + 2):
            continue
        rx = (hw >> 8) & 0x7
        rz = (hw >> 5) & 0x7
        n16 += 1
        print(f"  0x{off:05X} st.h r{rz}, (r{rx}, byte 0x{start:X}) covers +0x17  hw {hw:04X}")
    elif (hw & 0xF800) == 0xB000:
        disp = hw & 0x1F
        start = disp * 4
        if not (start <= 0x17 < start + 4):
            continue
        rx = (hw >> 8) & 0x7
        rz = (hw >> 5) & 0x7
        n16 += 1
        print(f"  0x{off:05X} st.w r{rz}, (r{rx}, byte 0x{start:X}) covers +0x17  hw {hw:04X}")
print(f"  count {n16}")

# --- lrw lines whose comment value is a codec/RAM address, verified against the pool word ---
print("\n== verified lrw of codec / 0x38b5c ==")
lrw_re = re.compile(
    r"^\s*([0-9a-f]+):\s+[0-9a-f]+\s+lrw\s+(r\d+),\s+(0x[0-9a-f]+)\s+//\s+(0x[0-9a-f]+)",
    re.I,
)
interesting = []
for line in DUMP.splitlines():
    m = lrw_re.match(line)
    if not m:
        continue
    at = int(m.group(1), 16)
    reg = m.group(2)
    val = int(m.group(3), 16)
    pool = int(m.group(4), 16)
    if not (0x16000900 <= val <= 0x16000A20 or val in (0x38B5C, 0x160009D7, 0x160009C0)):
        continue
    if pool + 4 > N:
        print(f"  POOL OOB 0x{at:X} {reg} {val:#x} pool {pool:#x}")
        continue
    got = u32(pool)
    ok = "ok" if got == val else f"POOL MISMATCH image {got:#x}"
    # also confirm the insn bytes really are an lrw (16-bit 00010 or 32-bit opcode 111010)
    if at + 2 <= N:
        hw = u16(at)
        kind = "16" if (hw >> 11) == 0b00010 else ("32" if (hw >> 10) == 0x3A else f"?? {hw:04X}")
    else:
        kind = "?"
    print(f"  0x{at:05X} {kind}-bit lrw {reg}, 0x{val:08X} pool 0x{pool:X} {ok}")
    interesting.append((at, reg, val, pool))

# --- for each verified codec-base lrw, walk forward in the objdump until the
# register is written, and report stores that use it as the base ---
print("\n== stores after a codec-base lrw, before that register is clobbered ==")
# index objdump instruction lines
insn_re = re.compile(r"^\s*([0-9a-f]+):\s+[0-9a-f]+\s+(\S+)\s+(.*)$", re.I)
insns = []
for line in DUMP.splitlines():
    m = insn_re.match(line)
    if m:
        insns.append((int(m.group(1), 16), m.group(2), m.group(3).strip(), line.strip()))
by_at = {a: i for i, (a, _, _, _) in enumerate(insns)}

def writes_reg(text, reg):
    # crude: mnemonic destination is the first rN, or the paren base is not a dest
    # A store's first reg is the VALUE, not a dest. Calls clobber caller-saved; we
    # only treat an explicit destination as a clobber, plus bsr/jmp/pop.
    op = text
    return False

for at, reg, val, pool in interesting:
    if not (0x16000900 <= val <= 0x16000A20):
        continue
    if at not in by_at:
        continue
    i = by_at[at]
    print(f"\n  from 0x{at:X} {reg} = 0x{val:X}")
    # walk up to 80 following instruction lines, stop at pop/jmp/br that leaves, or rewrite of reg
    for j in range(i + 1, min(i + 80, len(insns))):
        a, op, rest, raw = insns[j]
        # clobber?
        dest = None
        # lrw/mov/movi/addi/subi/ld.* write their first register
        if op in ("lrw", "mov", "movi", "addi", "subi", "ld.b", "ld.h", "ld.w", "ldr.b", "ldr.w", "zextb", "zexth", "addu", "subu", "and", "andi", "or", "xor", "lsli", "lsri", "bseti", "bclri", "not", "sextb", "sexth", "ins", "zext", "mult", "cmpnei", "cmphs", "cmplt"):
            mm = re.match(r"(r\d+)", rest)
            if mm:
                dest = mm.group(1)
        if op in ("pop", "jmp", "br", "rts"):
            print(f"    stop 0x{a:X} {op}")
            break
        if op.startswith("st"):
            # st.b rZ, (rX, disp) or str.b rZ, (rX, rY << n)
            if f"({reg}," in rest.replace(" ", "") or f"({reg}," in rest:
                print(f"    STORE 0x{a:X} {op} {rest}")
        if dest == reg and op not in ("cmpnei", "cmphs", "cmplt"):
            print(f"    clobber 0x{a:X} {op} {rest}")
            break

# subi sites we may patch: confirm bytes
print("\n== 0x61F4 subi bytes ==")
for off, expect in ((0x61FE, 0x2B74), (0x620C, 0x2B77), (0x6228, 0x2B76), (0x6238, 0x2B7F), (0x6540, 0x2A74)):
    hw = u16(off)
    imm = (hw & 0xFF) + 1
    val8 = (-imm) & 0xFF
    print(f"  0x{off:X} hw 0x{hw:04X} expect 0x{expect:04X} match {hw == expect} subi imm {imm} -> byte 0x{val8:02X}")
