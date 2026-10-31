# F62D: FW57 plus the opcode 14 window and one counter byte per receive drop.
# Diagnostic only. Not a release image. Nothing here keys the radio.
#
# The counters sit at 0x4F2C0, the first bytes after the stock heap
# (0x4EAB0-0x4F2B0) and inside the opcode 14 window [0x30000, 0x50000).
# No aligned word in FW57 names that range. They are above bss, so boot
# does not zero them; the bench reads them by difference. A byte wraps
# at 256.
#
# Each hook is a bsr. The stub repeats the original test and then takes
# the original path. The two 2-byte branches cannot grow in place:
# 0xC15E takes the following ld.b with it, and 0xC27E is reached by
# replacing the bnez at 0xC276 (the br's only entry). The bt at 0xC1AA
# is the other entry of the start post, so that test moves into the stub
# and both entries share the start counter.
import hashlib
from pathlib import Path

import fw30_build
import literal_guard
import space_map

ROOT = Path(__file__).resolve().parents[2]
SRC = ROOT / "radio_firmware" / "build" / "DMR003.FW57.V022.bin"
DEST = ROOT / "radio_firmware" / "build" / "DMR003.F62D.V022.bin"
TAG = slice(0x38464, 0x38474)
STUB = 0x5C59C
STUB_END = 0x5C6FC
GETTER = 0x5C4C8
BASE = 0x4F2C0
WIN_LO = 0x5C0CE
WIN_HI = 0x5C0D6
WIN_OLD = (bytes.fromhex("21ea0018"), bytes.fromhex("21ea0118"))
WIN_NEW = (bytes.fromhex("21ea0300"), bytes.fromhex("21ea0500"))
XIP = 0x0301A000
LOOP = XIP + 0xC09E
DROP = XIP + 0xC2CA
AFTER = XIP + 0xC1BE
OTHER = XIP + 0xC280

# file offset -> (symbol, old bytes). The old bytes are the whole hook.
HOOKS = (
    (0xC0C8, "drop_c0c8", bytes.fromhex("00e9ebff")),
    (0xC12C, "drop_c12c", bytes.fromhex("23e9b9ff")),
    (0xC14A, "drop_c14a", bytes.fromhex("03e9aaff")),
    (0xC15E, "drop_c15e", bytes.fromhex("a00f2086")),
    (0xC168, "drop_c168", bytes.fromhex("23e99bff")),
    (0xC1A8, "direct_start", bytes.fromhex("413b0808")),
    (0xC1B6, "drop_c1b8", bytes.fromhex("8e64890c")),
    (0xC1BA, "post_start", bytes.fromhex("02e08781")),
    (0xC244, "post_stop", bytes.fromhex("02e04281")),
    (0xC276, "drop_c27e", bytes.fromhex("23e90500")),
)
# Index in the byte block. direct_start and post_start share index 7.
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
)

ASM = r"""
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
drop_c0c8:
	cmpnei	r0, 0
	bt	1f
	lrw	r2, 0x4F2C0
	br	inc_go
1:
	jmp	r15
drop_c12c:
	cmpnei	r3, 0
	bf	1f
	lrw	r2, 0x4F2C0
	addi	r2, 1
	br	inc_go
1:
	jmp	r15
drop_c14a:
	cmpnei	r3, 0
	bt	1f
	lrw	r2, 0x4F2C0
	addi	r2, 2
	br	inc_go
1:
	jmp	r15
drop_c15e:
	cmpnei	r3, 104
	bt	1f
	lrw	r2, 0x4F2C0
	addi	r2, 3
	br	inc_go
1:
	ld.b	r1, (r6, 0)
	jmp	r15
drop_c168:
	cmpnei	r3, 0
	bf	1f
	lrw	r2, 0x4F2C0
	addi	r2, 4
	br	inc_go
1:
	jmp	r15
drop_c1b8:
	cmpne	r3, r2
	bt	1f
	subi	r14, 8
	st.w	r2, (r14, 0)
	st.w	r3, (r14, 4)
	lrw	r2, 0x4F2C0
	addi	r2, 5
	br	inc_restore_c2ca
1:
	jmp	r15
drop_c27e:
	cmpnei	r3, 0
	bf	1f
	lrw	r15, 0x03026E80
	jmp	r15
1:
	st.b	r10, (r4, 4)
	lrw	r2, 0x4F2C0
	addi	r2, 6
	br	inc_go
direct_start:
	push	r15
	cmpnei	r3, 1
	bf	1f
	bsr	count_start
	bsr	getter_slot
	addi	r14, 4
	lrw	r15, 0x03026EBE
	jmp	r15
1:
	pop	r15
post_start:
	push	r15
	bsr	count_start
	bsr	getter_slot
	pop	r15
post_stop:
	push	r15
	subi	r14, 8
	st.w	r2, (r14, 0)
	st.w	r3, (r14, 4)
	lrw	r2, 0x4F2C0
	addi	r2, 8
	bsr	inc_only
	ld.w	r3, (r14, 4)
	ld.w	r2, (r14, 0)
	addi	r14, 8
	bsr	getter_slot
	pop	r15
count_start:
	push	r15
	subi	r14, 8
	st.w	r2, (r14, 0)
	st.w	r3, (r14, 4)
	lrw	r2, 0x4F2C0
	addi	r2, 7
	bsr	inc_only
	ld.w	r3, (r14, 4)
	ld.w	r2, (r14, 0)
	addi	r14, 8
	pop	r15
inc_only:
	ld.b	r3, (r2, 0)
	addi	r3, 1
	st.b	r3, (r2, 0)
	jmp	r15
inc_go:
	ld.b	r3, (r2, 0)
	addi	r3, 1
	st.b	r3, (r2, 0)
	lrw	r15, 0x03026C9E
	jmp	r15
inc_restore_c2ca:
	ld.b	r3, (r2, 0)
	addi	r3, 1
	st.b	r3, (r2, 0)
	ld.w	r3, (r14, 4)
	ld.w	r2, (r14, 0)
	addi	r14, 8
	lrw	r15, 0x03026ECA
	jmp	r15
getter_slot:
	jmp	r15
	.align	2
	.literals
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


def _patch_getter(code, stub, slot):
    found = 0
    for i in range(0, len(code) - 3, 2):
        if not (0xE0 <= code[i + 1] <= 0xE3):
            continue
        if fw30_build.bsr_target(bytes(code), i) != slot - stub:
            continue
        code[i:i + 4] = fw30_build.encode_bsr(stub + i, GETTER)
        found += 1
    if found != 3:
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
    for site, _name, raw in HOOKS:
        if img[site:site + len(raw)] != raw:
            raise SystemExit("site %X is %s" % (site, img[site:site + len(raw)].hex()))
    if img[0xC27A:0xC280] != bytes.fromhex("44dd04001007"):
        raise SystemExit("dead br")
    if img[WIN_LO:WIN_LO + 4] != WIN_OLD[0] or img[WIN_HI:WIN_HI + 4] != WIN_OLD[1]:
        raise SystemExit("window")
    code = bytearray(fw30_build._linked(ASM, STUB, "f62d"))
    if STUB + len(code) > STUB_END:
        raise SystemExit("stub ends %X" % (STUB + len(code)))
    elf = Path(r"C:\Users\Joshua\AppData\Local\Temp\fw1718\fw30\f62d.elf")
    sym = _symbols(elf)
    _patch_getter(code, STUB, sym["getter_slot"])
    img[STUB:STUB + len(code)] = code
    for site, name, raw in HOOKS:
        img[site:site + len(raw)] = fw30_build.encode_bsr(site, sym[name])
    img[0xC27A:0xC280] = bytes.fromhex("6c036c036c03")
    img[WIN_LO:WIN_LO + 4] = WIN_NEW[0]
    img[WIN_HI:WIN_HI + 4] = WIN_NEW[1]
    _guards(old, img)
    img[TAG] = b"DMR003.F62D.V022"
    DEST.parent.mkdir(parents=True, exist_ok=True)
    DEST.write_bytes(img)
    print(DEST.name)
    print(hashlib.sha256(bytes(img)).hexdigest())
    print("stub %X-%X (%d)" % (STUB, STUB + len(code), len(code)))
    for name, index in COUNT:
        print("count %s -> %X" % (name, BASE + index))
    return DEST


if __name__ == "__main__":
    build()
