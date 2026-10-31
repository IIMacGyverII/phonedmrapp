# F62F: F62E's counters, plus the three arms above 0xC0C8 and the loop
# head. Diagnostic only. Not a release image. Nothing here keys.
#
# The live literal at 0x5C6BC stays. The four new entries sit after it.
# A counter saves r2, r3, r12 and the PSR, then restores them. r15 is
# the hook's link. The receive function's return address stays on the
# stack from 0xC084.
import hashlib
from pathlib import Path

import fw30_build
import literal_guard
import space_map

ROOT = Path(__file__).resolve().parents[2]
SRC = ROOT / "radio_firmware" / "build" / "DMR003.FW57.V022.bin"
DEST = ROOT / "radio_firmware" / "build" / "DMR003.F62F.V022.bin"
TAG = slice(0x38464, 0x38474)
STUB = 0x5C59C
LITERAL = 0x5C6BC
TAIL = 0x5C6C0
TAIL_END = 0x5C6FC
GETTER = 0x5C4C8
BASE = 0x4F2C0
WIN_LO = 0x5C0CE
WIN_HI = 0x5C0D6
WIN_OLD = (bytes.fromhex("21ea0018"), bytes.fromhex("21ea0118"))
WIN_NEW = (bytes.fromhex("21ea0300"), bytes.fromhex("21ea0500"))
XIP = 0x0301A000


def xip(off):
    return XIP + off


LOOP = xip(0xC09E)
DROP = xip(0xC2CA)
OTHER = xip(0xC280)
START = xip(0xC1BA)
EARLY = (
    ("go_ee", xip(0xC0EE)),
    ("go_fa", xip(0xC1FA)),
    ("go_25c", xip(0xC25C)),
)

# file offset, symbol, old bytes, where the hook lives.
HOOKS = (
    (0xC0C8, "drop_c0c8", bytes.fromhex("00e9ebff"), "main"),
    (0xC12C, "drop_c12c", bytes.fromhex("23e9b9ff"), "main"),
    (0xC14A, "drop_c14a", bytes.fromhex("03e9aaff"), "main"),
    (0xC15E, "drop_c15e", bytes.fromhex("a00f2086"), "main"),
    (0xC168, "drop_c168", bytes.fromhex("23e99bff"), "main"),
    (0xC1A8, "direct_start", bytes.fromhex("413b0808"), "main"),
    (0xC1B6, "drop_c1b8", bytes.fromhex("8e64890c"), "main"),
    (0xC1BA, "post_start", bytes.fromhex("02e08781"), "main"),
    (0xC244, "post_stop", bytes.fromhex("02e04281"), "main"),
    (0xC276, "drop_c27e", bytes.fromhex("23e90500"), "main"),
    (0xC09E, "head_c09e", bytes.fromhex("0032cb6c"), "tail"),
    (0xC0B0, "arm_c0b0", bytes.fromhex("23e91f00"), "tail"),
    (0xC0B8, "arm_c0b8", bytes.fromhex("22e9a100"), "tail"),
    (0xC0C0, "arm_c0c0", bytes.fromhex("23e9ce00"), "tail"),
)
COUNT = (
    ("0xC0C8", 0),
    ("0xC12C", 1),
    ("0xC14A", 2),
    ("0xC15E", 3),
    ("0xC168", 4),
    ("0xC1B8", 5),
    ("0xC27E", 6),
    ("0xC1BA", 7),
    ("0xC244", 8),
    ("0xC09E", 9),
    ("0xC0B0", 10),
    ("0xC0B8", 11),
    ("0xC0C0", 12),
)


def _call_inc(index):
    return "\tmovi\tr12, %d\n\tbsr\tinc_body\n" % index


MAIN = ("""
	.text
	.global	drop_c0c8
	.global	drop_c12c
	.global	drop_c14a
	.global	drop_c15e
	.global	drop_c168
	.global	drop_c1b8
	.global	drop_c27e
	.global	direct_start
	.global	post_start
	.global	post_stop
	.global	getter_slot
	.global	inc_body
	.global	inc9
	.global	inc10
	.global	inc11
	.global	inc12
drop_c0c8:
	bez	r0, 1f
	jmp	r15
1:
""" + _call_inc(0) + """
	br	go_loop
drop_c12c:
	bnez	r3, 1f
	jmp	r15
1:
""" + _call_inc(1) + """
	br	go_loop
drop_c14a:
	bez	r3, 1f
	jmp	r15
1:
""" + _call_inc(2) + """
	br	go_loop
drop_c15e:
	bf	1f
	ld.b	r1, (r6, 0)
	jmp	r15
1:
""" + _call_inc(3) + """
	br	go_loop
drop_c168:
	bnez	r3, 1f
	jmp	r15
1:
""" + _call_inc(4) + """
	br	go_loop
drop_c1b8:
	cmpne	r3, r2
	bf	1f
	jmp	r15
1:
""" + _call_inc(5) + """
	br	go_drop
drop_c27e:
	bnez	r3, 1f
	st.b	r10, (r4, 4)
""" + _call_inc(6) + """
	br	go_loop
1:
	br	go_other
direct_start:
	cmpnei	r3, 1
	bt	1f
	jmp	r15
1:
	br	go_start
go_loop:
	lrw	r15, %(loop)s
	jmp	r15
go_drop:
	lrw	r15, %(drop)s
	jmp	r15
go_other:
	lrw	r15, %(other)s
	jmp	r15
go_start:
	lrw	r15, %(start)s
	jmp	r15
post_start:
	push	r15
""" + _call_inc(7) + """
	bsr	getter_slot
	pop	r15
post_stop:
	push	r15
""" + _call_inc(8) + """
	bsr	getter_slot
	pop	r15
getter_slot:
	jmp	r15
inc9:
	movi	r12, 9
	br	inc_body
inc10:
	movi	r12, 10
	br	inc_body
inc11:
	movi	r12, 11
	br	inc_body
inc12:
	movi	r12, 12
	br	inc_body
inc_body:
	subi	r14, 16
	st.w	r2, (r14, 0)
	st.w	r3, (r14, 4)
	st.w	r12, (r14, 8)
	mfcr	r2, cr<0, 0>
	st.w	r2, (r14, 12)
	lrw	r2, 0x4F2C0
	addu	r2, r12
	ld.b	r3, (r2, 0)
	addi	r3, 1
	st.b	r3, (r2, 0)
	ld.w	r2, (r14, 12)
	mtcr	r2, cr<0, 0>
	ld.w	r12, (r14, 8)
	ld.w	r3, (r14, 4)
	ld.w	r2, (r14, 0)
	addi	r14, 16
	jmp	r15
	.align	2
	.literals
""") % {
    "loop": "0x%08X" % LOOP,
    "drop": "0x%08X" % DROP,
    "other": "0x%08X" % OTHER,
    "start": "0x%08X" % START,
}

TAIL_ASM = """
	.text
	.global	head_c09e
	.global	arm_c0b0
	.global	arm_c0b8
	.global	arm_c0c0
	.global	tail_end
head_c09e:
	movi	r2, 0
	mov	r3, r2
	br	inc9_slot
arm_c0b0:
	bnez	r3, 1f
	jmp	r15
1:
	bsr	inc10_slot
	br	go_ee
arm_c0b8:
	bnez	r2, 1f
	jmp	r15
1:
	bsr	inc11_slot
	br	go_fa
arm_c0c0:
	bnez	r3, 1f
	jmp	r15
1:
	bsr	inc12_slot
	br	go_25c
go_ee:
	lrw	r15, 0x030260EE
	jmp	r15
go_fa:
	lrw	r15, 0x030261FA
	jmp	r15
go_25c:
	lrw	r15, 0x0302625C
	jmp	r15
	.align	2
	.literals
tail_end:
inc9_slot:
	jmp	r15
inc10_slot:
	jmp	r15
inc11_slot:
	jmp	r15
inc12_slot:
	jmp	r15
"""


def _symbols(path):
    import subprocess
    nm = fw30_build.AS.with_name("csky-elfabiv2-nm.exe")
    out = subprocess.check_output([str(nm), str(path)], text=True, errors="replace")
    sym = {}
    for line in out.splitlines():
        parts = line.split()
        if len(parts) >= 3 and parts[1] in ("T", "t"):
            sym[parts[2]] = int(parts[0], 16)
    return sym


def _br16_target(code, at):
    hw = code[at] | (code[at + 1] << 8)
    if hw & 0xFC00 != 0x0400:
        return None
    disp = hw & 0x3FF
    if disp & 0x200:
        disp -= 0x400
    return at + (disp << 1)


def _encode_br16(at, target):
    disp = (target - at) >> 1
    if not -512 <= disp <= 511:
        raise SystemExit("br16 from %X to %X" % (at, target))
    hw = 0x0400 | (disp & 0x3FF)
    return bytes((hw & 0xFF, (hw >> 8) & 0xFF))


def _set_lrw_r15(blob, at, pool):
    base = at & ~3
    imm = (pool - base) >> 2
    if not 0 <= imm <= 0xFFFF or base + (imm << 2) != pool:
        raise SystemExit("lrw r15 from %X to %X" % (at, pool))
    blob[at:at + 4] = bytes((0x8F, 0xEA, imm & 0xFF, (imm >> 8) & 0xFF))


def _patch_bsr(code, base, slot, dest):
    found = 0
    for i in range(0, len(code) - 3, 2):
        if not (0xE0 <= code[i + 1] <= 0xE3):
            continue
        if fw30_build.bsr_target(bytes(code), i) != slot - base:
            continue
        code[i:i + 4] = fw30_build.encode_bsr(base + i, dest)
        found += 1
    if found != 1:
        raise SystemExit("bsr to %X found %d" % (slot, found))


def _patch_br16(code, base, slot, dest):
    found = 0
    for i in range(0, len(code) - 1, 2):
        hit = _br16_target(code, i)
        if hit is None or hit != slot - base:
            continue
        code[i:i + 2] = _encode_br16(base + i, dest)
        found += 1
    if found != 1:
        raise SystemExit("br16 to %X found %d" % (slot, found))


def _patch_getter(code, stub, slot):
    found = 0
    for i in range(0, len(code) - 3, 2):
        if not (0xE0 <= code[i + 1] <= 0xE3):
            continue
        if fw30_build.bsr_target(bytes(code), i) != slot - stub:
            continue
        code[i:i + 4] = fw30_build.encode_bsr(stub + i, GETTER)
        found += 1
    if found != 2:
        raise SystemExit("getter sites %d" % found)


def _guards(old, img):
    if literal_guard.covered_loads(old, bytes(img))[1]:
        raise SystemExit("load guard")
    branches = literal_guard.covered_branches(old, bytes(img))[1]
    if branches:
        raise SystemExit("branch guard %s" % [(hex(a), hex(b)) for a, b in branches[:8]])
    if literal_guard.never_written(old, bytes(img)):
        raise SystemExit("never-write")
    pointed = literal_guard.pointed_into(old, bytes(img))
    if pointed:
        raise SystemExit("pointed %s" % [hex(p) for p in pointed[:8]])
    bad = space_map.outside_free(old, bytes(img))
    windows = (range(WIN_LO, WIN_LO + 4), range(WIN_HI, WIN_HI + 4))
    extra = [span for span in bad
             if not any(w.start <= span[0] and span[1] <= w.stop for w in windows)]
    if extra:
        raise SystemExit("space %s" % extra)


def build():
    img = bytearray(SRC.read_bytes())
    old = bytes(img)
    if img[TAG] != b"DMR003.FW57.V022":
        raise SystemExit("tag")
    for site, _name, raw, _where in HOOKS:
        if img[site:site + len(raw)] != raw:
            raise SystemExit("site %X is %s" % (site, img[site:site + len(raw)].hex()))
    if img[0xC27A:0xC280] != bytes.fromhex("44dd04001007"):
        raise SystemExit("dead br")
    if img[WIN_LO:WIN_LO + 4] != WIN_OLD[0] or img[WIN_HI:WIN_HI + 4] != WIN_OLD[1]:
        raise SystemExit("window")
    main = bytearray(fw30_build._linked(MAIN, STUB, "f62f"))
    if STUB + len(main) > LITERAL:
        raise SystemExit("main stub covers 5C6BC, ends %X len %d" % (
            STUB + len(main), len(main)))
    elf = Path(r"C:\Users\Joshua\AppData\Local\Temp\fw1718\fw30\f62f.elf")
    sym = _symbols(elf)
    _patch_getter(main, STUB, sym["getter_slot"])
    img[STUB:STUB + len(main)] = main
    tail = bytearray(fw30_build._linked(TAIL_ASM, TAIL, "f62f_tail"))
    tail_elf = Path(r"C:\Users\Joshua\AppData\Local\Temp\fw1718\fw30\f62f_tail.elf")
    tsym = _symbols(tail_elf)
    _patch_br16(tail, TAIL, tsym["inc9_slot"], sym["inc9"])
    for slot, real in (
        ("inc10_slot", "inc10"),
        ("inc11_slot", "inc11"),
        ("inc12_slot", "inc12"),
    ):
        _patch_bsr(tail, TAIL, tsym[slot], sym[real])
    # Two early jumps move into the 16 bytes before the live literal.
    # Their pool words stay with the tail and both shift down by 12.
    gap = STUB + len(main)
    if gap + 12 > LITERAL:
        raise SystemExit("no room before the literal, main ends %X" % gap)
    go_ee = tsym["go_ee"]
    go_fa = tsym["go_fa"]
    go_25c = tsym["go_25c"]
    _patch_br16(tail, TAIL, go_ee, gap)
    _patch_br16(tail, TAIL, go_fa, gap + 6)
    _patch_br16(tail, TAIL, go_25c, go_25c - 12)
    img[gap:gap + 6] = tail[go_ee - TAIL:go_ee - TAIL + 6]
    img[gap + 6:gap + 12] = tail[go_fa - TAIL:go_fa - TAIL + 6]
    kept = bytearray(tail[:go_ee - TAIL] + tail[go_25c - TAIL:tsym["tail_end"] - TAIL])
    _set_lrw_r15(img, gap, TAIL + len(kept) - 12)
    _set_lrw_r15(img, gap + 6, TAIL + len(kept) - 8)
    if TAIL + len(kept) > TAIL_END:
        raise SystemExit("tail length %d" % len(kept))
    img[TAIL:TAIL + len(kept)] = kept
    for site, name, raw, where in HOOKS:
        table = sym if where == "main" else tsym
        img[site:site + len(raw)] = fw30_build.encode_bsr(site, table[name])
    img[0xC27A:0xC280] = bytes.fromhex("6c036c036c03")
    img[WIN_LO:WIN_LO + 4] = WIN_NEW[0]
    img[WIN_HI:WIN_HI + 4] = WIN_NEW[1]
    if img[LITERAL:LITERAL + 4] != old[LITERAL:LITERAL + 4]:
        raise SystemExit("literal moved")
    _guards(old, img)
    img[TAG] = b"DMR003.F62F.V022"
    DEST.parent.mkdir(parents=True, exist_ok=True)
    DEST.write_bytes(img)
    print(DEST.name)
    print(hashlib.sha256(bytes(img)).hexdigest())
    print("main %X-%X (%d)" % (STUB, STUB + len(main), len(main)))
    print("tail %X-%X (%d)" % (TAIL, TAIL + len(kept), len(kept)))
    return DEST


if __name__ == "__main__":
    build()
