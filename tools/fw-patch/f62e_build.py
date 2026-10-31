# F62E: the F62D counters, with each hook replaying the instructions it
# replaced. Diagnostic only. Not a release image. Nothing here keys.
#
# F62D's taken jumps were 0x0301A000 + file_offset + 0xC00, and the
# 0xC1BE jump was +0xD00. The first taken jump left the receive function.
# The addresses below are 0x0301A000 + the file offset.
#
# 0xC15E tests the C flag the cmpnei at 0xC15A already set. The compare
# is not one of the replaced bytes, so the stub branches on that C.
# 0xC1A8's taken path goes to 0xC1BA, which is its own hook, so this
# stub does not call the getter and does not count. The counter update
# saves r2, r3 and the PSR, then restores them. r15 is the far-jump
# register; the receive function's own return address is on the stack.
import hashlib
from pathlib import Path

import fw30_build
import literal_guard
import space_map

ROOT = Path(__file__).resolve().parents[2]
SRC = ROOT / "radio_firmware" / "build" / "DMR003.FW57.V022.bin"
DEST = ROOT / "radio_firmware" / "build" / "DMR003.F62E.V022.bin"
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


def xip(off):
    return XIP + off


LOOP = xip(0xC09E)
DROP = xip(0xC2CA)
OTHER = xip(0xC280)
START = xip(0xC1BA)

# file offset, symbol, old bytes, the stock instructions those bytes are.
HOOKS = (
    (0xC0C8, "drop_c0c8", bytes.fromhex("00e9ebff"), "bez r0, 0xc09e"),
    (0xC12C, "drop_c12c", bytes.fromhex("23e9b9ff"), "bnez r3, 0xc09e"),
    (0xC14A, "drop_c14a", bytes.fromhex("03e9aaff"), "bez r3, 0xc09e"),
    (0xC15E, "drop_c15e", bytes.fromhex("a00f2086"), "bf 0xc09e; ld.b r1, (r6, 0)"),
    (0xC168, "drop_c168", bytes.fromhex("23e99bff"), "bnez r3, 0xc09e"),
    (0xC1A8, "direct_start", bytes.fromhex("413b0808"), "cmpnei r3, 1; bt 0xc1ba"),
    (0xC1B6, "drop_c1b8", bytes.fromhex("8e64890c"), "cmpne r3, r2; bf 0xc2ca"),
    (0xC1BA, "post_start", bytes.fromhex("02e08781"), "bsr 0x5c4c8"),
    (0xC244, "post_stop", bytes.fromhex("02e04281"), "bsr 0x5c4c8"),
    (0xC276, "drop_c27e", bytes.fromhex("23e90500"), "bnez r3, 0xc280"),
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
)


def _inc(index):
    return (
        "inc%d:\n"
        "\tsubi\tr14, 8\n"
        "\tst.w\tr2, (r14, 0)\n"
        "\tst.w\tr3, (r14, 4)\n"
        "\tmovi\tr2, %d\n"
        "\tbr\tinc_body\n" % (index, index)
    )


ASM = """
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
drop_c0c8:
	bez	r0, 1f
	jmp	r15
1:
	bsr	inc0
	br	go_loop
drop_c12c:
	bnez	r3, 1f
	jmp	r15
1:
	bsr	inc1
	br	go_loop
drop_c14a:
	bez	r3, 1f
	jmp	r15
1:
	bsr	inc2
	br	go_loop
drop_c15e:
	bf	1f
	ld.b	r1, (r6, 0)
	jmp	r15
1:
	bsr	inc3
	br	go_loop
drop_c168:
	bnez	r3, 1f
	jmp	r15
1:
	bsr	inc4
	br	go_loop
drop_c1b8:
	cmpne	r3, r2
	bf	1f
	jmp	r15
1:
	bsr	inc5
	br	go_drop
drop_c27e:
	bnez	r3, 1f
	st.b	r10, (r4, 4)
	bsr	inc6
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
	bsr	inc7
	bsr	getter_slot
	pop	r15
post_stop:
	push	r15
	bsr	inc8
	bsr	getter_slot
	pop	r15
getter_slot:
	jmp	r15
""" % {
    "loop": "0x%08X" % LOOP,
    "drop": "0x%08X" % DROP,
    "other": "0x%08X" % OTHER,
    "start": "0x%08X" % START,
} + "".join(_inc(i) for i in range(9)) + """
inc_body:
	subi	r14, 4
	mfcr	r3, cr<0, 0>
	st.w	r3, (r14, 0)
	lrw	r3, 0x4F2C0
	addu	r3, r2
	ld.b	r2, (r3, 0)
	addi	r2, 1
	st.b	r2, (r3, 0)
	ld.w	r3, (r14, 0)
	mtcr	r3, cr<0, 0>
	ld.w	r3, (r14, 8)
	ld.w	r2, (r14, 4)
	addi	r14, 12
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
    for site, _name, raw, _text in HOOKS:
        if img[site:site + len(raw)] != raw:
            raise SystemExit("site %X is %s" % (site, img[site:site + len(raw)].hex()))
    if img[0xC27A:0xC280] != bytes.fromhex("44dd04001007"):
        raise SystemExit("dead br")
    if img[WIN_LO:WIN_LO + 4] != WIN_OLD[0] or img[WIN_HI:WIN_HI + 4] != WIN_OLD[1]:
        raise SystemExit("window")
    code = bytearray(fw30_build._linked(ASM, STUB, "f62e"))
    if STUB + len(code) > 0x5C6BC:
        raise SystemExit("stub covers the literal at 5C6BC, ends %X len %d" % (
            STUB + len(code), len(code)))
    elf = Path(r"C:\Users\Joshua\AppData\Local\Temp\fw1718\fw30\f62e.elf")
    sym = _symbols(elf)
    _patch_getter(code, STUB, sym["getter_slot"])
    img[STUB:STUB + len(code)] = code
    for site, name, raw, _text in HOOKS:
        img[site:site + len(raw)] = fw30_build.encode_bsr(site, sym[name])
    img[0xC27A:0xC280] = bytes.fromhex("6c036c036c03")
    img[WIN_LO:WIN_LO + 4] = WIN_NEW[0]
    img[WIN_HI:WIN_HI + 4] = WIN_NEW[1]
    _guards(old, img)
    img[TAG] = b"DMR003.F62E.V022"
    DEST.parent.mkdir(parents=True, exist_ok=True)
    DEST.write_bytes(img)
    print(DEST.name)
    print(hashlib.sha256(bytes(img)).hexdigest())
    print("stub %X-%X (%d)" % (STUB, STUB + len(code), len(code)))
    return DEST


if __name__ == "__main__":
    build()
