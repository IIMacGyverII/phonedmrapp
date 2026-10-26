# Build DMR003.FW27.V022 from the FW26 image. The file does not grow.
#
# The stub links at 0x5BCA4, in the reclaimed opcode 13 playback. The
# variant-5 trampoline links at 0x5C54C. Op 17 does not
# copy a half itself: it calls op 5's send at file 0x5B1B4, which checksums
# and sends the 514-byte body. The 512-byte move is the same ld.b loop,
# inlined only because that loop falls into op 5's half counter and does
# not return. Before a group of halves it stores WORK_MODE 0x80 the way
# op 5 does at file 0x5B096, then waits for the next FM_ADDR_SW flip.
# The start body's third byte is the group length: 1, 2, 4 or 8.
#
# Op 5 reply body, unchanged, and what a stream frame is:
#   body[0..511]  512 big-endian sample bytes, first sample at body[0]
#   body[512]     sequence, one byte, the slot 0..5 (the send buffer ends
#                 at 0x4B000, so a wider counter would walk off it)
#   body[513]     half id, 0 = RAM 0x160004E0, 1 = RAM 0x160006E0.
#                 Same choice as the live op 5 copy at file 0x5B110:
#                 FM_ADDR_SW 1 copies 0x160004E0, 2 copies 0x160006E0.
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
# The FM key path's helper at 0x5BBE2 loads its literals from 0x5BE60.
# That pool stays. The stub is split around it.
POOL = 0x5BE60
POOL_END = 0x5BEE0
HIGH = 0x5BEE0
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
	.section .text.low,"ax"
	.global	fw27_gate
	.global	fw27_pend
	.global	fw27_send
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

/* The stream handler sits in front of the low pool. Its literals merge
 * with the gate's, and the key path's pool at 0x5BE60 stays intact. */
	.global	fw27_flow
fw27_flow:
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
	/* Body byte 2 is the store period (1, 2, 4 or 8). Default 1. */
	.short	0xE000, 0x0100
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
	bsr	.L576
	movi	r4, 0
	lrw	r3, 0x4b368
	st.w	r4, (r3, 0)
	lrw	r3, 0x4b378
	ld.w	r15, (r3, 0)
	jmp	r15
.Lnosw:
	/* Store WORK_MODE, then the next flip, then the copy. In the wrap. */
	.short	0xE000, 0x0200
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
	.literals

	.section .text.high,"ax"
/* r2 = divisor. Waits until the UART is idle, sets DLAB only after a
 * read-back, then restores the IER captured before the LCR write.
 * r0 = 0 when the new divisor is in force. Records at 0x4B380. */
	.global	fw27_div
fw27_div:
.Ldiv:
	movih	r3, 5129
	ld.w	r1, (r3, 0x4)
	lrw	r0, 0x4b380
	st.w	r1, (r0, 0)
	ld.w	r1, (r3, 0x7c)
	st.w	r1, (r0, 4)
	ld.w	r1, (r3, 0xc)
	st.w	r1, (r0, 8)
	movi	r4, 250
	lsli	r4, r4, 8
.Lbusy:
	ld.w	r1, (r3, 0x7c)
	andi	r1, r1, 1
	cmpnei	r1, 0
	bf	.Ltemt
	subi	r4, 1
	cmpnei	r4, 0
	bt	.Lbusy
	br	.Ldlab
.Ltemt:
	ld.w	r1, (r3, 0x14)
	andi	r1, r1, 64
	cmpnei	r1, 0
	bt	.Ldlab
	subi	r4, 1
	cmpnei	r4, 0
	bt	.Lbusy
.Ldlab:
	ld.w	r1, (r3, 0x7c)
	st.w	r1, (r0, 4)
	movi	r4, 32
.Ltry:
	ld.w	r1, (r3, 0xc)
	bseti	r1, 7
	st.w	r1, (r3, 0xc)
	ld.w	r1, (r3, 0xc)
	st.w	r1, (r0, 12)
	andi	r1, r1, 128
	cmpnei	r1, 0
	bt	.Ldll
	subi	r4, 1
	cmpnei	r4, 0
	bt	.Ltry
	movi	r1, 1
	st.w	r1, (r0, 24)
	jmp	r15
.Ldll:
	andi	r1, r2, 255
	st.w	r1, (r3, 0)
	lsri	r1, r2, 8
	andi	r1, r1, 255
	st.w	r1, (r3, 0x4)
	st.w	r2, (r0, 20)
	movi	r4, 32
.Lclr:
	ld.w	r1, (r3, 0xc)
	bclri	r1, 7
	st.w	r1, (r3, 0xc)
	ld.w	r1, (r3, 0xc)
	st.w	r1, (r0, 16)
	andi	r1, r1, 128
	cmpnei	r1, 0
	bf	.Ltail
	subi	r4, 1
	cmpnei	r4, 0
	bt	.Lclr
	movi	r1, 1
	st.w	r1, (r0, 24)
	jmp	r15
.Ltail:
	ld.w	r1, (r3, 0xc)
	ori	r1, r1, 3
	st.w	r1, (r3, 0xc)
	movi	r1, 103
	st.w	r1, (r3, 0x8)
	ld.w	r1, (r0, 0)
	st.w	r1, (r3, 0x4)
	movi	r1, 0
	st.w	r1, (r0, 24)
	jmp	r15

.Lclk:
	lrw	r2, 0x32f90
	ld.w	r0, (r2, 0)
	lsri	r0, r0, 4
	jmp	r15
.L576:
	push	r15
	bsr	.Lclk
	movi	r2, 225
	lsli	r2, r2, 8
	divu	r2, r0, r2
	bsr	.Ldiv
	pop	r15
.L230:
	push	r15
	bsr	.Lclk
	movi	r2, 225
	lsli	r2, r2, 10
	divu	r2, r0, r2
	bsr	.Ldiv
	pop	r15

.Lrate:
	push	r15
	ld.b	r4, (r7, 9)
	cmpnei	r4, 0
	bt	.Lr1
	bsr	.Lack
	bsr	.L576
	movi	r5, 0
	br	.Lflag
.Lr1:
	cmpnei	r4, 1
	bt	.Lr2
	bsr	.Lack
	bsr	.L230
	cmpnei	r0, 0
	bt	.Lkeep
	movi	r5, 1
	br	.Lflag
.Lkeep:
	movi	r5, 0
	br	.Lflag
.Lr2:
.Lpopbad:
	pop	r15
	mov	r15, r6
	jmp	r15
.Lflag:
	lrw	r4, 0x4b368
	st.w	r5, (r4, 0)
	lrw	r4, 0x4b36c
	lrw	r5, 30000
	st.w	r5, (r4, 0)
	pop	r15
.Lack:
	push	r15
	ld.b	r0, (r7, 1)
	movi	r1, 0
	.short	0xE000, 0x8E7C
	pop	r15

/* One half, then back. r5 is the slot. r2 is the half id.
 * The frame pointer is at (r14, 0) on entry. sendh reads it at (r14, 24). */
fw27_send:
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
	bsr	.L576
	movi	r4, 0
	lrw	r3, 0x4b368
	st.w	r4, (r3, 0)
.Lret:
	pop	r15
	.align	2
	.literals
"""


def patch_calls(code, base):
    jobs = (
        (bytes.fromhex("00e05b1b"), SENDH, False),
        (bytes.fromhex("00e07c8e"), 0x8E7C, False),
        # File 0x2B0C is the flash pend (XIP 0x0301CB0C). It is not IRAM 0x2B0C.
        (bytes.fromhex("00e00c2b"), PEND, False),
        (bytes.fromhex("00e0220b"), AT1846, True),
        (bytes.fromhex("00e0a418"), 0x18A4, False),
    )
    found_tokens = set()
    for token, target, iram in jobs:
        at = 0
        while True:
            found = code.find(token, at)
            if found < 0:
                break
            pc = (base + found) + (XIP if iram else 0)
            code[found:found + 4] = fw23_build.encode_bsr(pc, target)
            found_tokens.add(token)
            at = found + 4
    return code, found_tokens


TRAMP = 0x5C54C
TRAMP_END = TRAMP
WRAP = 0x5C590
WRAP_END = WRAP
REST_OFF = 0
# Filled in by build() from the stub's own branches. The earlier constants
# 0x5CD6 and 0x5D42 dropped the 0xB000 of the real file addresses.
MODE5_AT = 0
REST_AT = 0
TRAMP_ASM = r"""
	.text
	.global	apply5
	.global	rest5
apply5:
	cmpnei	r1, 4
	bt	.Ln4
	lrw	r12, 0x030752cc
	jmp	r12
.Ln4:
	cmpnei	r1, 5
	bt	.Lrej
	.short	0xE000, 0xCD5C
	addi	r14, 4
	pop	r4-r7, r15
rest5:
	cmpnei	r1, 3
	bt	.Ln3
	lrw	r12, 0x030752ac
	jmp	r12
.Ln3:
	cmpnei	r1, 5
	bt	.Lrej
	.short	0xE000, 0xD25C
	lrw	r12, 0x030752fa
	jmp	r12
.Lrej:
	lrw	r12, 0x03075308
	jmp	r12
	.align	2
	.literals
"""


def mode_targets(code):
    """File address of .Lmode5 and .Lrest, from the stub's own branches.

    The gate's first bsr is .Lmode5. The bsr 0x5A bytes into that function
    is .Lrest. Both are inside the stub, so a file-to-file branch reaches
    them when the code runs at its XIP address.
    """
    mode5 = fw26_build.decode_bsr(BASE + 0xA, bytes(code[0xA:0xE]))
    rest_at = mode5 + 0x5A
    rest = fw26_build.decode_bsr(rest_at, bytes(code[rest_at - BASE:rest_at - BASE + 4]))
    if not (BASE < mode5 < RECLAIM_END and BASE < rest < RECLAIM_END):
        raise SystemExit("mode5 %X rest %X are outside the stub" % (mode5, rest))
    return mode5, rest


WRAP_ASM = r"""
	.text
	.global	regsend
/* Same frame as op 5's send, plus WORK_MODE, FM_BANDWIDTH and the
 * AT1846S 0x58 mirror at body bytes 514..525. r5 is the slot. The half
 * id is on the stack where sendh reads it. */
regsend:
	mov	r7, r15
	lrw	r1, 0x4a400
	mov	r0, r5
	lsli	r0, 9
	addu	r1, r0
	mov	r4, r1
	subi	r4, 8
	movi	r2, 104
	st.b	r2, (r4, 0)
	ld.w	r0, (r14, 0x18)
	ld.b	r2, (r0, 1)
	st.b	r2, (r4, 1)
	movi	r2, 0
	st.b	r2, (r4, 2)
	st.b	r2, (r4, 3)
	st.b	r2, (r4, 4)
	st.b	r2, (r4, 5)
	movi	r2, 2
	st.b	r2, (r4, 6)
	movi	r2, 14
	st.b	r2, (r4, 7)
	mov	r0, r1
	movi	r3, 1
	lsli	r3, 9
	addu	r0, r3
	mov	r6, r14
	addi	r6, 8
	addu	r6, r5
	ld.b	r2, (r6, 0)
	st.b	r5, (r0, 0)
	st.b	r2, (r0, 1)
	lrw	r6, 0x11000100
	ld.w	r2, (r6, 0)
	st.b	r2, (r0, 2)
	lsri	r3, r2, 8
	st.b	r3, (r0, 3)
	lsri	r3, r2, 16
	st.b	r3, (r0, 4)
	lsri	r3, r2, 24
	st.b	r3, (r0, 5)
	lrw	r6, 0x11000500
	ld.w	r2, (r6, 0)
	st.b	r2, (r0, 6)
	lsri	r3, r2, 8
	st.b	r3, (r0, 7)
	lsri	r3, r2, 16
	st.b	r3, (r0, 8)
	lsri	r3, r2, 24
	st.b	r3, (r0, 9)
	lrw	r6, 0x3a81c
	ld.w	r2, (r6, 0)
	st.b	r2, (r0, 10)
	lsri	r3, r2, 8
	st.b	r3, (r0, 11)
	lsri	r3, r2, 16
	st.b	r3, (r0, 12)
	lsri	r3, r2, 24
	st.b	r3, (r0, 13)
	movi	r2, 16
	st.b	r2, (r0, 14)
	movi	r0, 2
	lsli	r0, 8
	addi	r0, 23
	mov	r1, r4
	.short	0xE000, 0x5C8E
	mov	r0, r4
	movi	r1, 2
	lsli	r1, 8
	addi	r1, 23
	.short	0xE000, 0xE87D
	jmp	r7

	.global	period_init
	.global	halfstep
/* r7 is the command frame. Body length at bytes 6..7. Body[2] at byte 10
 * is the store period. 1, 2, 4 and 8 are accepted. Anything else is 1.
 * The countdown at 0x4B373 starts at 0 so the first pass stores. */
period_init:
	movi	r4, 1
	ld.b	r0, (r7, 6)
	cmpnei	r0, 0
	bt	.Pset
	ld.b	r0, (r7, 7)
	cmphsi	r0, 3
	bf	.Pset
	ld.b	r0, (r7, 10)
	cmpnei	r0, 2
	bt	.P4
	movi	r4, 2
	br	.Pset
.P4:
	cmpnei	r0, 4
	bt	.P8
	movi	r4, 4
	br	.Pset
.P8:
	cmpnei	r0, 8
	bt	.Pset
	movi	r4, 8
.Pset:
	lrw	r0, 0x4b372
	st.b	r4, (r0, 0)
	movi	r4, 0
	st.b	r4, (r0, 1)
	jmp	r15

/* One pass of the stream loop. No push: r14 is the frame pointer fw27_send
 * reads. Countdown 0 stores WORK_MODE 0x80, the same movi/st.w as op 5 at
 * 0x5B096, and remembers the pointer so the copy waits for the next flip.
 * Switch 1 copies 0x160004E0. The next slot is stored before the send. */
halfstep:
	lrw	r3, 0x4b360
	st.w	r15, (r3, 0)
	lrw	r3, 0x4b373
	ld.b	r4, (r3, 0)
	cmpnei	r4, 0
	bt	.Hwait
	lrw	r6, 0x11000100
	movi	r0, 128
	st.w	r0, (r6, 0)
	lrw	r6, 0x4b372
	ld.b	r0, (r6, 0)
	st.b	r0, (r3, 0)
	lrw	r6, 0x1100056c
	ld.w	r0, (r6, 0)
	andi	r0, r0, 3
	lrw	r1, 0x4b375
	st.b	r0, (r1, 0)
	br	.Hret
.Hwait:
	lrw	r6, 0x1100056c
	ld.w	r0, (r6, 0)
	andi	r0, r0, 3
	lrw	r1, 0x4b375
	ld.b	r3, (r1, 0)
	cmpne	r0, r3
	bf	.Hret
	cmpnei	r0, 1
	bt	.Hid
	movi	r2, 0
	br	.Hok
.Hid:
	cmpnei	r0, 2
	bt	.Hret
	movi	r2, 1
.Hok:
	st.b	r0, (r1, 0)
	lrw	r3, 0x4b373
	ld.b	r4, (r3, 0)
	cmpnei	r4, 0
	bf	.Hslot
	subi	r4, 1
	st.b	r4, (r3, 0)
.Hslot:
	lrw	r1, 0x4b374
	ld.b	r5, (r1, 0)
	mov	r4, r5
	addi	r4, 1
	cmpnei	r4, 6
	bt	.Hsv
	movi	r4, 0
.Hsv:
	st.b	r4, (r1, 0)
	.short	0xE000, 0xB15B
.Hret:
	lrw	r3, 0x4b360
	ld.w	r15, (r3, 0)
	jmp	r15
	.align	2
	.literals
"""


def link_wrap():
    src = OUT / "fw27_wrap.S"
    src.write_text(WRAP_ASM, encoding="utf-8", newline="\n")
    subprocess.check_call([str(AS), "-mcpu=ck803", "-o", str(OUT / "fw27_wrap.o"), str(src)])
    subprocess.check_call([str(LD), "-Ttext=0x%X" % WRAP, "-o", str(OUT / "fw27_wrap.elf"), str(OUT / "fw27_wrap.o")])
    code, addr = fw23_build.text_of((OUT / "fw27_wrap.elf").read_bytes())
    if addr != WRAP:
        raise SystemExit("wrap linked at %X" % addr)
    for token, target in (
            (bytes.fromhex("00e08e5c"), 0x8E5C),
            (bytes.fromhex("00e07de8"), 0x7DE8)):
        found = code.find(token)
        if found < 0:
            raise SystemExit("wrap missing " + token.hex())
        code[found:found + 4] = fw23_build.encode_bsr(WRAP + found, target)
    end = WRAP + len(code)
    if end > FILE_END:
        raise SystemExit("wrap ends at %X" % end)
    return code, end


def link_tramp():
    global REST_OFF
    src = OUT / "fw27_tramp.S"
    src.write_text(TRAMP_ASM, encoding="utf-8", newline="\n")
    subprocess.check_call([str(AS), "-mcpu=ck803", "-o", str(OUT / "fw27_tramp.o"), str(src)])
    subprocess.check_call([str(LD), "-Ttext=0x%X" % TRAMP, "-o", str(OUT / "fw27_tramp.elf"), str(OUT / "fw27_tramp.o")])
    code, addr = fw23_build.text_of((OUT / "fw27_tramp.elf").read_bytes())
    if addr != TRAMP:
        raise SystemExit("tramp linked at %X" % addr)
    names = subprocess.check_output([str(NM), str(OUT / "fw27_tramp.elf")], text=True)
    for line in names.splitlines():
        parts = line.split()
        if len(parts) >= 3 and parts[2] == "rest5":
            REST_OFF = int(parts[0], 16) - TRAMP
    if REST_OFF <= 0:
        raise SystemExit("no rest5")
    for token, target in ((bytes.fromhex("00e05ccd"), MODE5_AT), (bytes.fromhex("00e05cd2"), REST_AT)):
        found = code.find(token)
        if found < 0:
            raise SystemExit("missing tramp call " + token.hex())
        code[found:found + 4] = fw23_build.encode_bsr(TRAMP + found, target)
    end = TRAMP + len(code)
    if end > 0x5C6FC:
        raise SystemExit("tramp ends at %X" % end)
    return code, end


def elf_section(blob, name):
    e_shoff = struct.unpack_from("<I", blob, 32)[0]
    e_shentsize = struct.unpack_from("<H", blob, 46)[0]
    e_shnum = struct.unpack_from("<H", blob, 48)[0]
    e_shstrndx = struct.unpack_from("<H", blob, 50)[0]
    shstr = e_shoff + e_shstrndx * e_shentsize
    shstr_off = struct.unpack_from("<I", blob, shstr + 16)[0]
    for i in range(e_shnum):
        off = e_shoff + i * e_shentsize
        name_off = struct.unpack_from("<I", blob, off)[0]
        got = blob[shstr_off + name_off:blob.find(b"\x00", shstr_off + name_off)]
        if got == name:
            addr = struct.unpack_from("<I", blob, off + 12)[0]
            size = struct.unpack_from("<I", blob, off + 20)[0]
            data_off = struct.unpack_from("<I", blob, off + 16)[0]
            return bytearray(blob[data_off:data_off + size]), addr
    raise SystemExit("no section " + name.decode())


def build():
    OUT.mkdir(parents=True, exist_ok=True)
    src = OUT / "fw27.S"
    src.write_text(ASM, encoding="utf-8", newline="\n")
    subprocess.check_call([str(AS), "-mcpu=ck803", "-o", str(OUT / "fw27.o"), str(src)])
    ld = OUT / "fw27.ld"
    ld.write_text(
        "SECTIONS {\n"
        "  .text.low 0x%X : { *(.text.low) }\n"
        "  .text.high 0x%X : { *(.text.high) }\n"
        "}\n" % (BASE, HIGH),
        encoding="utf-8", newline="\n")
    subprocess.check_call([str(LD), "-T", str(ld), "-o", str(OUT / "fw27.elf"), str(OUT / "fw27.o")])
    elf = (OUT / "fw27.elf").read_bytes()
    low, low_at = elf_section(elf, b".text.low")
    high, high_at = elf_section(elf, b".text.high")
    if low_at != BASE or high_at != HIGH:
        raise SystemExit("linked low %X high %X" % (low_at, high_at))
    seen = set()
    low, seen_low = patch_calls(low, BASE)
    high, seen_high = patch_calls(high, HIGH)
    seen |= seen_low
    seen |= seen_high
    for token in (bytes.fromhex("00e07c8e"), bytes.fromhex("00e00c2b"), bytes.fromhex("00e0220b")):
        if token not in seen:
            raise SystemExit("missing call " + token.hex())
    low_end = BASE + len(low)
    high_end = HIGH + len(high)
    if low_end > POOL or high_end > RECLAIM_END:
        raise SystemExit("stub low ends %X (pool %X), high ends %X (opcode 14 %X)" % (
            low_end, POOL, high_end, RECLAIM_END))
    if struct.pack("<I", 0x11000560) in low or struct.pack("<I", 0x11000560) in high:
        raise SystemExit("stub mentions PTT")
    names = subprocess.check_output([str(NM), str(OUT / "fw27.elf")], text=True)
    pend_at = None
    send_at = None
    for line in names.splitlines():
        parts = line.split()
        if len(parts) < 3:
            continue
        if parts[2] == "fw27_pend":
            pend_at = int(parts[0], 16)
        elif parts[2] == "fw27_send":
            send_at = int(parts[0], 16)
    if pend_at is None or send_at is None:
        raise SystemExit("no fw27_pend or fw27_send")
    fw26 = (ROOT / "radio_firmware" / "build" / "DMR003.FW26.V022.bin").read_bytes()
    img = bytearray(fw26)
    img[0x38464:0x38474] = b"DMR003.FW27.V022"
    img[GATE:GATE + 4] = fw23_build.encode_bsr(GATE, BASE)
    img[PEND_SITE:PEND_SITE + 4] = fw23_build.encode_bsr(PEND_SITE + XIP, pend_at + XIP)
    # Opcode 13 falls into its body at 0x5B816. Send it to the sr=1 return.
    img[0x5B816:0x5B81A] = fw23_build.encode_bsr(0x5B816, 0x5B876)
    img[BASE:low_end] = low
    img[HIGH:high_end] = high
    global MODE5_AT, REST_AT
    MODE5_AT, REST_AT = mode_targets(low)
    tramp, tramp_end = link_tramp()
    img[TRAMP:tramp_end] = tramp
    wrap, wrap_end = link_wrap()
    img[WRAP:wrap_end] = wrap
    global WRAP_END
    WRAP_END = wrap_end
    for start, stop in ((BASE, low_end), (HIGH, high_end)):
        for off in range(start, stop - 3):
            if fw26_build.decode_bsr(off, bytes(img[off:off + 4])) == SENDH:
                img[off:off + 4] = fw23_build.encode_bsr(off, WRAP)
    wnames = subprocess.check_output([str(NM), str(OUT / "fw27_wrap.elf")], text=True)
    period_at = half_at = None
    for line in wnames.splitlines():
        parts = line.split()
        if len(parts) < 3:
            continue
        if parts[2] == "period_init":
            period_at = int(parts[0], 16)
        elif parts[2] == "halfstep":
            half_at = int(parts[0], 16)
    if period_at is None or half_at is None:
        raise SystemExit("wrap is missing period_init or halfstep")

    def patch_token(token, target, start=None, stop=None):
        raw = bytes.fromhex(token)
        hits = []
        spans = ((start, stop),) if start is not None else ((BASE, low_end), (HIGH, high_end))
        for start, stop in spans:
            at = start
            while True:
                found = img.find(raw, at, stop)
                if found < 0:
                    break
                hits.append(found)
                at = found + 1
        if len(hits) != 1:
            raise SystemExit("token %s hits %s" % (token, [hex(h) for h in hits]))
        found = hits[0]
        img[found:found + 4] = fw23_build.encode_bsr(found, target)

    patch_token("00e00001", period_at)
    patch_token("00e00002", half_at)
    patch_token("00e05bb1", send_at, WRAP, wrap_end)
    print("period", hex(period_at), "half", hex(half_at), "send", hex(send_at))
    # The live op 6 handler is at file 0x5B240 (XIP 0x03075240). Apply rejects
    # at 0x5B2C8 (cmpnei r1, 4; bt 0x5B308). Restore rejects at 0x5B2A8
    # (cmpnei r1, 3; bt 0x5B308) after variant 4 has already taken its own body.
    # File 0x52C8 is a different function; patching it does not admit variant 5.
    img[0x5B2C8:0x5B2CC] = fw23_build.encode_bsr(0x5B2C8, TRAMP)
    img[0x5B2A8:0x5B2AC] = fw23_build.encode_bsr(0x5B2A8, TRAMP + REST_OFF)
    dest = ROOT / "radio_firmware" / "build" / "DMR003.FW27.V022.bin"
    dest.write_bytes(img)
    import hashlib
    global STUB_END, STUB_LO_END, STUB_HI_END, PEND_AT, TRAMP_END
    STUB_END = high_end
    STUB_LO_END = low_end
    STUB_HI_END = high_end
    PEND_AT = pend_at
    TRAMP_END = tramp_end
    print("stub low", hex(BASE), hex(low_end), "high", hex(HIGH), hex(high_end))
    print("tramp", hex(TRAMP), hex(tramp_end))
    print("pend", hex(pend_at))
    print(dest)
    print(hashlib.sha256(img).hexdigest())
    return dest


if __name__ == "__main__":
    build()
