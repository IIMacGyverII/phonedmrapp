# Build DMR003.FW27.V022 from the FW26 image. The file does not grow.
#
# The new code links at 0x5C54C, the zero tail after FW26. Op 17 does not
# copy a half itself: it calls op 5's send at file 0x5B1B4, which checksums
# and sends the 514-byte body. The 512-byte move is the same ld.b loop,
# inlined only because that loop falls into op 5's half counter and does
# not return.
#
# Op 5 reply body, unchanged, and what a stream frame is:
#   body[0..511]  512 big-endian sample bytes, first sample at body[0]
#   body[512]     sequence, one byte, the slot 0..5 (the send buffer ends
#                 at 0x4B000, so a wider counter would walk off it)
#   body[513]     half id, 0 = RAM 0x160004E0 (FM_ADDR_SW was 1),
#                 1 = RAM 0x160006E0 (FM_ADDR_SW was 2)
# The 8-byte header in front of the body has length 514. A 0x10 tail follows.
import struct
import subprocess
from pathlib import Path

import fw23_build
import fw26_build

AS = fw26_build.AS
LD = fw26_build.LD
NM = fw26_build.NM
HERE = Path(__file__).resolve().parent
ROOT = HERE.parent.parent
OUT = Path(r"C:\Users\Joshua\AppData\Local\Temp\fw1718\fw27")
# Opcode 13's playback (fw23_play through the byte before opcode 14).
# Opcode 12 ends at 0x5BCA2. Opcode 14 starts at 0x5C098.
BASE = 0x5BCA4
RECLAIM_END = 0x5C098
FILE_END = 0x5C6FC
XIP = 0x0301A000
GATE = 0x5B7DE
FW26_GATE = 0x03076464
SENDH = 0x5B1B4
UART57600 = 0x5DEC
PEND = 0x2B0C
PEND_SITE = 0x7C56
AT1846 = 0x2B220
MARK = 0x5354524D

ASM = r"""
	.text
	.global	fw27_gate
	.global	fw27_pend
fw27_gate:
	cmpnei	r3, 6
	bt	.Lnot6
	ld.b	r0, (r7, 9)
	cmpnei	r0, 5
	bt	.Lold
	bsr	.Lmode5
	br	.Ldone
.Lnot6:
	cmphsi	r3, 16
	bf	.Lold
	cmphsi	r3, 18
	bt	.Lold
	cmpnei	r3, 16
	bt	.L17
	bsr	.Lrate
	br	.Ldone
.L17:
	bsr	.Lflow
	br	.Ldone
.Lold:
	lrw	r12, 0x03076464
	jmp	r12
.Ldone:
	addi	r14, 4
	pop	r4-r7, r15

.Lmode5:
	push	r15
	ld.b	r1, (r7, 10)
	cmpnei	r1, 1
	bt	.Loff
	lrw	r4, 0x4b008
	ld.w	r5, (r4, 0)
	lrw	r0, 0x5354524d
	cmpne	r5, r0
	bf	.Lset
	movih	r4, 4352
	bseti	r4, 8
	ld.w	r5, (r4, 0)
	lrw	r0, 0x4b000
	st.w	r5, (r0, 0)
	movih	r4, 4352
	bseti	r4, 8
	bseti	r4, 10
	ld.w	r5, (r4, 0)
	st.w	r5, (r0, 4)
.Lset:
	movih	r4, 4352
	bseti	r4, 8
	movi	r5, 128
	st.w	r5, (r4, 0)
	movih	r4, 4352
	bseti	r4, 8
	bseti	r4, 10
	ld.w	r5, (r4, 0)
	bclri	r5, 4
	bclri	r5, 6
	st.w	r5, (r4, 0)
	movi	r0, 88
	movi	r1, 48381
	.short	0xE000, 0x0B22
	lrw	r4, 0x4b008
	lrw	r5, 0x5354524d
	st.w	r5, (r4, 0)
	br	.Lak
.Loff:
	cmpnei	r1, 0
	bt	.Lbad
	bsr	.Lrest
.Lak:
	ld.b	r0, (r7, 1)
	movi	r1, 0
	.short	0xE000, 0x8E7C
	pop	r15
.Lbad:
	mov	r15, r6
	jmp	r15

.Lrest:
	push	r15
	lrw	r4, 0x4b000
	ld.w	r5, (r4, 0)
	movih	r4, 4352
	bseti	r4, 8
	st.w	r5, (r4, 0)
	lrw	r4, 0x4b004
	ld.w	r5, (r4, 0)
	movih	r4, 4352
	bseti	r4, 8
	bseti	r4, 10
	st.w	r5, (r4, 0)
	lrw	r4, 0x4b008
	movi	r5, 0
	st.w	r5, (r4, 0)
	movi	r0, 88
	movi	r1, 33797
	.short	0xE000, 0x0B22
	pop	r15

.Ldiv:
	movih	r3, 5129
	ld.w	r1, (r3, 0xc)
	bseti	r1, 7
	st.w	r1, (r3, 0xc)
	movi	r1, 13
	st.w	r1, (r3, 0)
	movi	r1, 0
	st.w	r1, (r3, 0x4)
	ld.w	r1, (r3, 0xc)
	bclri	r1, 7
	st.w	r1, (r3, 0xc)
	movi	r1, 0
	st.w	r1, (r3, 0x4)
	ld.w	r1, (r3, 0xc)
	ori	r1, r1, 3
	st.w	r1, (r3, 0xc)
	movi	r1, 103
	st.w	r1, (r3, 0x8)
	movi	r1, 5
	st.w	r1, (r3, 0x4)
	jmp	r15

.Lrate:
	push	r15
	ld.b	r4, (r7, 9)
	cmpnei	r4, 0
	bt	.Lr1
	bsr	.Lack
	movi	r0, 20
	.short	0xE000, 0x18A4
	.short	0xE000, 0x5DEC
	movi	r5, 0
	br	.Lflag
.Lr1:
	cmpnei	r4, 1
	bt	.Lbad
	bsr	.Lack
	movi	r0, 20
	.short	0xE000, 0x18A4
	bsr	.Ldiv
	movi	r5, 1
.Lflag:
	lrw	r4, 0x4b368
	st.w	r5, (r4, 0)
	lrw	r4, 0x4b36c
	lrw	r5, 30000
	st.w	r5, (r4, 0)
	pop	r15
.Lack:
	ld.b	r0, (r7, 1)
	movi	r1, 0
	.short	0xE000, 0x8E7C
	jmp	r15

/* One half, then back. r5 is the slot. r2 is the half id.
 * The frame pointer is at (r14, 0) on entry. sendh reads it at (r14, 24). */
.Lsend:
	lrw	r3, 0x4b37c
	st.w	r15, (r3, 0)
	lrw	r0, 0x4a400
	mov	r3, r5
	lsli	r3, 9
	addu	r0, r3
	lrw	r1, 0x160004e0
	cmpnei	r2, 0
	bt	.Lsrc
	br	.Lmov
.Lsrc:
	lrw	r1, 0x160006e0
.Lmov:
	movi	r3, 1
	lsli	r3, 9
.Lbyte:
	ld.b	r4, (r1, 0)
	st.b	r4, (r0, 0)
	addi	r1, 1
	addi	r0, 1
	subi	r3, 1
	cmpnei	r3, 0
	bt	.Lbyte
	subi	r14, 24
	mov	r0, r14
	addi	r0, 8
	addu	r0, r5
	st.b	r2, (r0, 0)
	.short	0xE000, 0x1B5B
	addi	r14, 24
	lrw	r3, 0x4b37c
	ld.w	r15, (r3, 0)
	jmp	r15

.Lflow:
	lrw	r3, 0x4b378
	st.w	r15, (r3, 0)
	ld.b	r4, (r7, 9)
	cmpnei	r4, 1
	bt	.Lstop
	lrw	r4, 0x4b008
	ld.w	r5, (r4, 0)
	lrw	r0, 0x5354524d
	cmpne	r5, r0
	bt	.Lbad
	bsr	.Lack
	movi	r4, 0
	lrw	r0, 0x4b374
	st.h	r4, (r0, 0)
.Lspin:
	movi	r0, 1
	.short	0xE000, 0x18A4
	lrw	r3, 0x4b36c
	ld.w	r4, (r3, 0)
	cmpnei	r4, 0
	bf	.Lfall
	subi	r4, 1
	st.w	r4, (r3, 0)
	movih	r3, 5129
	ld.w	r0, (r3, 0x7c)
	andi	r0, r0, 8
	cmpnei	r0, 0
	bf	.Lnosw
	ld.w	r0, (r3, 0)
	andi	r0, r0, 255
	lrw	r1, 0x4ae00
	lrw	r3, 0x4b376
	ld.b	r4, (r3, 0)
	cmpnei	r4, 0
	bt	.Lputb
	cmpnei	r0, 104
	bt	.Lnosw
.Lputb:
	addu	r1, r4
	st.b	r0, (r1, 0)
	addi	r4, 1
	st.b	r4, (r3, 0)
	cmpnei	r4, 11
	bt	.Lnosw
	movi	r4, 0
	st.b	r4, (r3, 0)
	lrw	r1, 0x4ae00
	ld.b	r0, (r1, 8)
	cmpnei	r0, 17
	bt	.Lend
	ld.b	r0, (r1, 9)
	cmpnei	r0, 2
	bt	.Lend
	lrw	r3, 0x4b36c
	lrw	r4, 30000
	st.w	r4, (r3, 0)
	br	.Lnosw
.Lend:
	lrw	r3, 0x4b378
	ld.w	r15, (r3, 0)
	jmp	r15
.Lfall:
	.short	0xE000, 0x5DEC
	movi	r4, 0
	lrw	r3, 0x4b368
	st.w	r4, (r3, 0)
	lrw	r3, 0x4b378
	ld.w	r15, (r3, 0)
	jmp	r15
.Lnosw:
	lrw	r0, 0x1100056c
	ld.w	r0, (r0, 0)
	andi	r0, r0, 3
	lrw	r1, 0x4b375
	ld.b	r3, (r1, 0)
	cmpne	r0, r3
	bf	.Lspin
	cmpnei	r0, 1
	bt	.Lid
	movi	r2, 0
	br	.Lok
.Lid:
	cmpnei	r0, 2
	bt	.Lspin
	movi	r2, 1
.Lok:
	st.b	r0, (r1, 0)
	lrw	r1, 0x4b374
	ld.b	r5, (r1, 0)
	bsr	.Lsend
	addi	r5, 1
	cmpnei	r5, 6
	bt	.Lsv
	movi	r5, 0
.Lsv:
	st.b	r5, (r1, 0)
	br	.Lspin
.Lstop:
	cmpnei	r4, 0
	bt	.Lka
	br	.Lack
.Lka:
	cmpnei	r4, 2
	bt	.Lbad
	lrw	r4, 0x4b36c
	lrw	r5, 30000
	st.w	r5, (r4, 0)
	br	.Lack

/* Replaces the UART pend while 230400 is armed, so a silent host still
 * falls back. r2 stays 0 (wait) until the flag is set. */
fw27_pend:
	push	r15
	lrw	r3, 0x4b368
	ld.w	r3, (r3, 0)
	cmpnei	r3, 0
	bf	.Lcall
	movi	r2, 1
.Lcall:
	.short	0xE000, 0x2B0C
	cmpnei	r0, 1
	bf	.Lret
	lrw	r3, 0x4b368
	ld.w	r3, (r3, 0)
	cmpnei	r3, 0
	bf	.Lret
	lrw	r3, 0x4b36c
	ld.w	r4, (r3, 0)
	cmpnei	r4, 0
	bf	.Lret
	subi	r4, 1
	st.w	r4, (r3, 0)
	cmpnei	r4, 0
	bt	.Lret
	.short	0xE000, 0x5DEC
	movi	r4, 0
	lrw	r3, 0x4b368
	st.w	r4, (r3, 0)
.Lret:
	pop	r15
	.align	2
	.literals
"""


def patch_calls(code):
    jobs = (
        (bytes.fromhex("00e05b1b"), SENDH, False),
        (bytes.fromhex("00e0ec5d"), UART57600, False),
        (bytes.fromhex("00e07c8e"), 0x8E7C, False),
        # File 0x2B0C is the flash pend (XIP 0x0301CB0C). It is not IRAM 0x2B0C.
        (bytes.fromhex("00e00c2b"), PEND, False),
        (bytes.fromhex("00e0220b"), AT1846, True),
        (bytes.fromhex("00e0a418"), 0x18A4, False),
    )
    for token, target, iram in jobs:
        at = 0
        n = 0
        while True:
            found = code.find(token, at)
            if found < 0:
                break
            pc = (BASE + found) + (XIP if iram else 0)
            code[found:found + 4] = fw23_build.encode_bsr(pc, target)
            n += 1
            at = found + 4
        if n == 0:
            raise SystemExit("missing call " + token.hex())
    return code


def build():
    OUT.mkdir(parents=True, exist_ok=True)
    src = OUT / "fw27.S"
    src.write_text(ASM, encoding="utf-8", newline="\n")
    subprocess.check_call([str(AS), "-mcpu=ck803", "-o", str(OUT / "fw27.o"), str(src)])
    subprocess.check_call([str(LD), "-Ttext=0x%X" % BASE, "-o", str(OUT / "fw27.elf"), str(OUT / "fw27.o")])
    code, addr = fw23_build.text_of((OUT / "fw27.elf").read_bytes())
    if addr != BASE:
        raise SystemExit("linked at %X" % addr)
    code = patch_calls(code)
    end = BASE + len(code)
    if end > RECLAIM_END:
        raise SystemExit("stub %d bytes ends at %X, opcode 14 starts at %X" % (
            len(code), end, RECLAIM_END))
    if struct.pack("<I", 0x11000560) in code:
        raise SystemExit("stub mentions PTT")
    names = subprocess.check_output([str(NM), str(OUT / "fw27.elf")], text=True)
    pend_at = None
    for line in names.splitlines():
        parts = line.split()
        if len(parts) >= 3 and parts[2] == "fw27_pend":
            pend_at = int(parts[0], 16)
    if pend_at is None:
        raise SystemExit("no fw27_pend")
    fw26 = (ROOT / "radio_firmware" / "build" / "DMR003.FW26.V022.bin").read_bytes()
    img = bytearray(fw26)
    img[0x38464:0x38474] = b"DMR003.FW27.V022"
    img[GATE:GATE + 4] = fw23_build.encode_bsr(GATE, BASE)
    img[PEND_SITE:PEND_SITE + 4] = fw23_build.encode_bsr(PEND_SITE + XIP, pend_at + XIP)
    # Opcode 13 falls into its body at 0x5B816. Send it to the sr=1 return.
    img[0x5B816:0x5B81A] = fw23_build.encode_bsr(0x5B816, 0x5B876)
    img[BASE:end] = code
    dest = ROOT / "radio_firmware" / "build" / "DMR003.FW27.V022.bin"
    dest.write_bytes(img)
    import hashlib
    global STUB_END, PEND_AT
    STUB_END = end
    PEND_AT = pend_at
    print("stub", len(code), "end", hex(end), "reclaim left", RECLAIM_END - end)
    print("pend", hex(pend_at))
    print(dest)
    print(hashlib.sha256(img).hexdigest())
    return dest


if __name__ == "__main__":
    build()
