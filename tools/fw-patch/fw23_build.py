# Build DMR003.FW23.V022. FW22, plus opcode 13: a 3 s idle playback out of the
# codec DAC. The first 200 ms is 1 kHz. The rest is a linear chirp from 50 Hz
# to 3800 Hz. Peak is a quarter of the sine table (about ±8192). PTT is never
# stored and AT1846S register 0x30 is never written. The 48 KB waveform is
# synthesized here because it fits neither one 0x40 frame nor the free flash.
import math
import struct
import subprocess
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
import build

AS = Path(r"C:\Users\Joshua\tools\csky-elfabiv2\bin\csky-elfabiv2-as.exe")
LD = Path(r"C:\Users\Joshua\tools\csky-elfabiv2\bin\csky-elfabiv2-ld.bfd.exe")
NM = Path(r"C:\Users\Joshua\tools\csky-elfabiv2\bin\csky-elfabiv2-nm.exe")
HERE = Path(__file__).resolve().parent
OUT = Path(r"C:\Users\Joshua\AppData\Local\Temp\fw1718\fw21")
BASE = 0x5B794
ONE = 0x5B408
ACK = 0x8E7C
MODE = 0x4B014
MAGIC_SYM = 0x47572101
MAGIC_TONE = 0x47572102
TABLE = 0x4B080
QUEUE = 0x4B260


def freq_hz(n):
    """Hz of sample n. 1600 samples (200 ms) at 1 kHz, then 50 Hz to 3800 Hz."""
    if n < 1600:
        return 1000
    return 50 + (n - 1600) * 3750 // 22400


def sweep_sample(n, phase):
    """One int16 and the next phase. phase is the 32-bit accumulator; its top 8 bits index the sine table."""
    inc = (freq_hz(n) * 536871) & 0xFFFFFFFF
    phase = (phase + inc) & 0xFFFFFFFF
    raw = int(round(math.sin(2 * math.pi * ((phase >> 24) & 255) / 256) * 32767))
    if raw < 0:
        y = -((-raw) >> 2)
    else:
        y = raw >> 2
    return y, phase


def encode_bsr(at, target):
    disp = target - at
    word = (0b111000 << 26) | ((disp >> 1) & 0x3FFFFFF)
    return struct.pack("<HH", (word >> 16) & 0xFFFF, word & 0xFFFF)


def text_of(blob):
    e_shoff = struct.unpack_from("<I", blob, 32)[0]
    e_shentsize = struct.unpack_from("<H", blob, 46)[0]
    e_shnum = struct.unpack_from("<H", blob, 48)[0]
    e_shstrndx = struct.unpack_from("<H", blob, 50)[0]
    shstr = e_shoff + e_shstrndx * e_shentsize
    shstr_off = struct.unpack_from("<I", blob, shstr + 16)[0]
    for i in range(e_shnum):
        off = e_shoff + i * e_shentsize
        name_off = struct.unpack_from("<I", blob, off)[0]
        name = blob[shstr_off + name_off:blob.find(b"\x00", shstr_off + name_off)]
        if name == b".text":
            addr = struct.unpack_from("<I", blob, off + 12)[0]
            size = struct.unpack_from("<I", blob, off + 20)[0]
            data_off = struct.unpack_from("<I", blob, off + 16)[0]
            return bytearray(blob[data_off:data_off + size]), addr
    raise SystemExit("no .text")


def asm_source():
    sine = [int(round(math.sin(2 * math.pi * i / 256) * 32767)) for i in range(256)]
    words = "\n".join("\t.short\t%d" % v for v in sine)
    return r"""
	.text
	.global	fw21_op3
	.global	fw21_fill
	.global	fw21_ops
	.global	fw21_sample

/* Op 3 prefix. Replaces lrw r4, 0x4a3e4; movi r1, 0. Clears the mode word
 * and the tone counters, then returns r4 and r1 the way those two
 * instructions did. The stores that follow still clear the ring. */
fw21_op3:
	push	r15
	lrw	r4, 0x4b014
	movi	r5, 0
	movi	r6, 16
.Lz:
	st.w	r5, (r4, 0)
	addi	r4, 4
	subi	r6, 1
	cmpnei	r6, 0
	bt	.Lz
	lrw	r4, 0x4a3e4
	movi	r1, 0
	pop	r15

/* Op 2 fill. Replaces the ring-fill block. r7 is the frame, r2 the length.
 * A second body byte of 1 returns the tone pairs still queued. r4 is the
 * ring base on return, r6 is the count. */
fw21_fill:
	push	r15
	cmphsi	r2, 2
	bf	.Lring
	ld.b	r0, (r7, 9)
	cmpnei	r0, 1
	bt	.Lring
	lrw	r4, 0x4b030
	ld.hs	r6, (r4, 0)
	br	.Lfilld
.Lring:
	lrw	r4, 0x4a3e4
	ld.w	r6, (r4, 0)
	ld.w	r1, (r4, 4)
	cmphs	r6, r1
	bf	.Lempty
	subu	r6, r1
	br	.Lfilld
.Lempty:
	movi	r6, 0
.Lfilld:
	lrw	r4, 0x4a3e4
	pop	r15

/* Unknown opcode, called in place of the sr=1 prologue. r15 returns to
 * movi r1, 1. Ops 8-13 are handled here and do not return. */
fw21_ops:
	mov	r6, r15
	ld.w	r7, (r14, 0)
	ld.b	r3, (r7, 8)
	cmphsi	r3, 8
	bf	.Lpass
	cmphsi	r3, 14
	bt	.Lpass
	cmpnei	r3, 8
	bt	.Ln8
	lrw	r4, 0x4b070
	st.w	r6, (r4, 0)
	bsr	fw21_op8
	br	.Ldone
.Ln8:
	cmpnei	r3, 9
	bt	.Ln9
	lrw	r4, 0x4b070
	st.w	r6, (r4, 0)
	bsr	fw21_op9
	br	.Ldone
.Ln9:
	cmpnei	r3, 12
	bt	.Ln12
	lrw	r4, 0x4b070
	st.w	r6, (r4, 0)
	bsr	fw22_read
	cmpnei	r0, 0
	bt	.Lbadop
	addi	r14, 4
	pop	r4-r7, r15
.Ln12:
	cmpnei	r3, 13
	bt	.Ln10
	lrw	r4, 0x4b070
	st.w	r6, (r4, 0)
	bsr	fw23_play
	br	.Ldone
.Ln10:
	lrw	r4, 0x4b070
	st.w	r6, (r4, 0)
	bsr	fw21_op10
.Ldone:
	cmpnei	r0, 0
	bt	.Lbadop
	ld.w	r7, (r14, 0)
	ld.b	r0, (r7, 1)
	movi	r1, 0
	.short	0xE000, 0x8E7C
	addi	r14, 4
	pop	r4-r7, r15
.Lbadop:
	lrw	r4, 0x4b070
	ld.w	r6, (r4, 0)
	mov	r15, r6
	ld.w	r7, (r14, 0)
	ld.b	r0, (r7, 1)
	jmp	r15
.Lpass:
	ld.b	r0, (r7, 1)
	mov	r15, r6
	jmp	r15

/* r7 = frame. r0 = 0 on success, 1 to reject. Does not key. */
fw21_op8:
	push	r15
	ld.b	r2, (r7, 6)
	ld.b	r3, (r7, 7)
	lsli	r2, 8
	or	r2, r3
	ld.b	r3, (r7, 10)
	cmpnei	r3, 2
	bt	.Lnl4
	br	.Lnlok
.Lnl4:
	cmpnei	r3, 4
	bt	.Lno8
.Lnlok:
	ld.b	r0, (r7, 9)
	cmpnei	r0, 0
	bt	.Lsh1
	br	.Lshok
.Lsh1:
	cmpnei	r0, 1
	bt	.Lno8
.Lshok:
	mov	r1, r3
	lsli	r1, 1
	addi	r1, 7
	cmpne	r2, r1
	bt	.Lno8
	ld.b	r1, (r7, 11)
	ld.b	r2, (r7, 12)
	lsli	r2, 8
	or	r1, r2
	cmpnei	r1, 0
	bf	.Lno8
	ld.b	r2, (r7, 13)
	ld.b	r5, (r7, 14)
	lsli	r5, 8
	or	r2, r5
	cmpnei	r2, 0
	bf	.Lno8
	lrw	r4, 0x4b014
	movi	r5, 0
	movi	r6, 16
.Lc8:
	st.w	r5, (r4, 0)
	addi	r4, 4
	subi	r6, 1
	cmpnei	r6, 0
	bt	.Lc8
	lrw	r4, 0x4b014
	lrw	r5, 0x47572101
	st.w	r5, (r4, 0)
	st.h	r1, (r4, 4)
	st.h	r2, (r4, 6)
	ld.b	r0, (r7, 9)
	st.b	r0, (r4, 10)
	st.b	r3, (r4, 11)
	addi	r7, 15
	addi	r4, 12
.Llv:
	cmpnei	r3, 0
	bf	.Llvok
	ld.b	r0, (r7, 0)
	ld.b	r1, (r7, 1)
	lsli	r1, 8
	or	r0, r1
	lsli	r0, 16
	asri	r0, r0, 16
	lrw	r1, 10000
	cmplt	r1, r0
	bf	.Lhi
	mov	r0, r1
.Lhi:
	lrw	r1, -10000
	cmplt	r0, r1
	bf	.Lokv
	mov	r0, r1
.Lokv:
	st.h	r0, (r4, 0)
	addi	r4, 2
	addi	r7, 2
	subi	r3, 1
	br	.Llv
.Llvok:
	movi	r0, 0
	pop	r15
.Lno8:
	movi	r0, 1
	pop	r15

fw21_op9:
	push	r15
	ld.b	r2, (r7, 6)
	ld.b	r3, (r7, 7)
	lsli	r2, 8
	or	r2, r3
	ld.b	r3, (r7, 9)
	ld.b	r1, (r7, 10)
	cmpnei	r3, 0
	bf	.Lno9
	cmphsi	r3, 17
	bt	.Lno9
	cmpnei	r1, 0
	bf	.Lno9
	cmphsi	r1, 16
	bt	.Lno9
	mov	r0, r1
	andi	r0, r0, 1
	cmpnei	r0, 1
	bt	.Lno9
	mov	r0, r3
	mult	r0, r1
	lsli	r0, 1
	addi	r0, 3
	cmpne	r2, r0
	bt	.Lno9
	lrw	r4, 0x4b03c
	st.b	r3, (r4, 0)
	st.b	r1, (r4, 1)
	mov	r5, r3
	mult	r5, r1
	lrw	r4, 0x4b080
	addi	r7, 11
.Lcp:
	cmpnei	r5, 0
	bf	.Lcpok
	ld.b	r0, (r7, 0)
	ld.b	r2, (r7, 1)
	lsli	r2, 8
	or	r0, r2
	st.h	r0, (r4, 0)
	addi	r4, 2
	addi	r7, 2
	subi	r5, 1
	br	.Lcp
.Lcpok:
	movi	r0, 0
	pop	r15
.Lno9:
	movi	r0, 1
	pop	r15

/* Op 10 and 11. Amplitude, then pairs. A body that does not fit is rejected
 * and queues nothing. Op 11 remembers to arm the end when the queue drains. */
fw21_op10:
	push	r15
	ld.b	r3, (r7, 8)
	ld.b	r2, (r7, 6)
	ld.b	r1, (r7, 7)
	lsli	r2, 8
	or	r2, r1
	cmphsi	r2, 7
	bf	.Lno10
	subi	r0, r2, 3
	movi	r1, 4
	divu	r5, r0, r1
	mov	r6, r5
	lsli	r6, 2
	addi	r6, 3
	cmpne	r6, r2
	bt	.Lno10
	cmpnei	r5, 0
	bf	.Lno10
	lrw	r4, 0x4b030
	ld.hs	r6, (r4, 0)
	addu	r6, r5
	cmphsi	r6, 65
	bt	.Lno10
	ld.b	r0, (r7, 9)
	ld.b	r1, (r7, 10)
	lsli	r1, 8
	or	r0, r1
	lrw	r1, 10000
	cmplt	r1, r0
	bf	.La1
	mov	r0, r1
.La1:
	lrw	r1, -10000
	cmplt	r0, r1
	bf	.La2
	mov	r0, r1
.La2:
	lrw	r4, 0x4b028
	st.h	r0, (r4, 0)
	lrw	r4, 0x4b03e
	st.b	r5, (r4, 0)
	ld.b	r0, (r7, 8)
	st.b	r0, (r4, 1)
	lrw	r4, 0x4b034
	ld.hs	r6, (r4, 0)
	addi	r7, 11
.Lqp:
	cmpnei	r5, 0
	bf	.Lqdone
	mov	r0, r6
	andi	r0, r0, 63
	lsli	r0, 2
	lrw	r1, 0x4b260
	addu	r0, r1
	ld.b	r1, (r7, 0)
	ld.b	r2, (r7, 1)
	lsli	r2, 8
	or	r1, r2
	cmphsi	r1, 65528
	bt	.Lno10
	st.h	r1, (r0, 0)
	ld.b	r1, (r7, 2)
	ld.b	r2, (r7, 3)
	lsli	r2, 8
	or	r1, r2
	cmpnei	r1, 0
	bf	.Lno10
	cmphsi	r1, 10001
	bt	.Lno10
	st.h	r1, (r0, 2)
	addi	r7, 4
	addi	r6, 1
	subi	r5, 1
	br	.Lqp
.Lqdone:
	lrw	r4, 0x4b034
	st.h	r6, (r4, 0)
	lrw	r4, 0x4b03e
	ld.b	r5, (r4, 0)
	lrw	r4, 0x4b030
	ld.hs	r0, (r4, 0)
	addu	r0, r5
	st.h	r0, (r4, 0)
	lrw	r4, 0x4b014
	lrw	r5, 0x47572102
	st.w	r5, (r4, 0)
	lrw	r4, 0x4b03e
	ld.b	r3, (r4, 1)
	cmpnei	r3, 11
	bt	.Lendset
	lrw	r4, 0x4b036
	movi	r3, 1
	st.h	r3, (r4, 0)
.Lendset:
	lrw	r4, 0x4a3e4
	ld.w	r0, (r4, 0)
	st.w	r0, (r4, 4)
	movi	r0, 0
	st.w	r0, (r4, 8)
	movi	r0, 0
	pop	r15
.Lno10:
	movi	r0, 1
	pop	r15

/* One TX-RAM sample. Magic selects the engine; anything else is M17. */
fw21_sample:
	push	r4-r7, r15
	lrw	r4, 0x4b014
	ld.w	r2, (r4, 0)
	lrw	r3, 0x47572101
	cmpne	r2, r3
	bf	.Lsym
	lrw	r3, 0x47572102
	cmpne	r2, r3
	bf	.Ltone
	.short	0xE000, 0xB408
	pop	r4-r7, r15
.Lsym:
	bsr	fw21_sym
	br	.Lswap
.Ltone:
	bsr	fw21_tone
.Lswap:
	mov	r1, r0
	lsri	r1, 8
	andi	r1, r1, 255
	andi	r0, r0, 255
	lsli	r0, 8
	or	r0, r1
	pop	r4-r7, r15

fw21_sym:
	push	r15
	lrw	r4, 0x4b03a
	ld.b	r0, (r4, 0)
	cmpnei	r0, 0
	bt	.Lhave
	bsr	fw21_pull
.Lhave:
	lrw	r4, 0x4b01e
	ld.b	r0, (r4, 0)
	cmpnei	r0, 1
	bt	.Lhold
	bsr	fw21_poly
	br	.Lacc
.Lhold:
	lrw	r4, 0x4b03b
	ld.b	r0, (r4, 0)
	bsr	fw21_level
.Lacc:
	mov	r6, r0
	lrw	r4, 0x4b018
	ld.hs	r1, (r4, 0)
	ld.hs	r2, (r4, 2)
	lrw	r4, 0x4b01c
	ld.hs	r3, (r4, 0)
	addu	r3, r1
	cmphs	r3, r2
	bf	.Lnostep
	subu	r3, r2
	lrw	r4, 0x4b03a
	movi	r0, 0
	st.b	r0, (r4, 0)
	lrw	r4, 0x4b01c
.Lnostep:
	st.h	r3, (r4, 0)
	lrw	r4, 0x4a3ec
	mov	r0, r3
	st.w	r0, (r4, 0)
	mov	r0, r6
	pop	r15

fw21_pull:
	push	r15
	lrw	r4, 0x4a3e4
	ld.w	r2, (r4, 0)
	ld.w	r3, (r4, 4)
	cmphs	r3, r2
	bt	.Lgap
	mov	r0, r3
	movi	r1, 1
	lsli	r1, 11
	subi	r1, 1
	and	r0, r1
	lrw	r1, 0x4a400
	addu	r0, r1
	ld.b	r0, (r0, 0)
	addi	r3, 1
	st.w	r3, (r4, 4)
	lrw	r4, 0x4b03a
	movi	r1, 1
	st.b	r1, (r4, 0)
	st.b	r0, (r4, 1)
	lrw	r4, 0x4b04d
	movi	r2, 14
.Lsh:
	cmpnei	r2, 0
	bf	.Lshd
	ld.b	r1, (r4, 0)
	st.b	r1, (r4, 1)
	subi	r4, 1
	subi	r2, 1
	br	.Lsh
.Lshd:
	lrw	r4, 0x4b040
	st.b	r0, (r4, 0)
	pop	r15
.Lgap:
	lrw	r4, 0x4b03a
	movi	r0, 0
	st.b	r0, (r4, 0)
	st.b	r0, (r4, 1)
	pop	r15

fw21_index:
	cmpnei	r0, 1
	bt	.Li1
	movi	r0, 0
	jmp	r15
.Li1:
	cmpnei	r0, 3
	bt	.Li2
	movi	r0, 1
	jmp	r15
.Li2:
	cmpnei	r0, 255
	bt	.Li3
	movi	r0, 2
	jmp	r15
.Li3:
	movi	r0, 3
	jmp	r15

fw21_level:
	push	r15
	bsr	fw21_index
	lsli	r0, 1
	lrw	r4, 0x4b020
	addu	r4, r0
	ld.h	r0, (r4, 0)
	pop	r15

fw21_poly:
	push	r4-r7, r15
	lrw	r4, 0x4b01c
	ld.hs	r2, (r4, 0)
	lrw	r4, 0x4b01a
	ld.hs	r3, (r4, 0)
	lrw	r4, 0x4b03c
	ld.b	r1, (r4, 0)
	mult	r2, r1
	divu	r2, r2, r3
	ld.b	r3, (r4, 1)
	mov	r6, r2
	mult	r6, r3
	movi	r5, 0
	movi	r7, 0
.Ldot:
	cmpne	r7, r3
	bf	.Ldotd
	lrw	r4, 0x4b040
	addu	r4, r7
	ld.b	r0, (r4, 0)
	bsr	fw21_level
	mov	r1, r0
	mov	r0, r6
	addu	r0, r7
	lsli	r0, 1
	lrw	r4, 0x4b080
	addu	r4, r0
	ld.h	r0, (r4, 0)
	mult	r1, r0
	addu	r5, r1
	addi	r7, 1
	br	.Ldot
.Ldotd:
	mov	r0, r5
	asri	r0, r0, 15
	bsr	fw21_clamp
	pop	r4-r7, r15

/* Called from on_key with the ring already tested. Return into host_key when
 * the ring or a live tone queue is waiting. Otherwise leave on_key. The mode
 * word has to be the tone magic before the queue counts are trusted. */
fw22_gate:
	lrw	r4, 0x4a3e4
	ld.w	r2, (r4, 0)
	ld.w	r3, (r4, 4)
	cmphs	r3, r2
	bf	.Larm
	lrw	r4, 0x4b014
	ld.w	r2, (r4, 0)
	lrw	r3, 0x47572102
	cmpne	r2, r3
	bt	.Lskip
	lrw	r4, 0x4b030
	ld.h	r2, (r4, 0)
	cmpnei	r2, 0
	bt	.Larm
	lrw	r4, 0x4b02c
	ld.w	r2, (r4, 0)
	cmpnei	r2, 0
	bt	.Larm
.Lskip:
	pop	r4-r7, r15
.Larm:
	jmp	r15

/* Opcode 12. Body: uint32 file offset, uint16 length, both little-endian.
 * Length 1..240, and offset+length inside the 378620-byte image. The reply
 * body is those flash bytes. Sends the frame itself. */
fw22_read:
	ld.w	r7, (r14, 0)
	push	r15
	ld.b	r0, (r7, 6)
	ld.b	r1, (r7, 7)
	lsli	r0, r0, 8
	or	r0, r1
	cmpnei	r0, 7
	bt	.Lrdno
	ld.b	r0, (r7, 9)
	ld.b	r1, (r7, 10)
	lsli	r1, r1, 8
	or	r0, r1
	ld.b	r1, (r7, 11)
	lsli	r1, r1, 16
	or	r0, r1
	ld.b	r1, (r7, 12)
	lsli	r1, r1, 24
	or	r0, r1
	ld.b	r2, (r7, 13)
	ld.b	r3, (r7, 14)
	lsli	r3, r3, 8
	or	r2, r3
	cmpnei	r2, 0
	bf	.Lrdno
	movi	r3, 240
	cmphs	r3, r2
	bf	.Lrdno
	lrw	r1, 0x5c6fc
	cmphs	r0, r1
	bt	.Lrdno
	subu	r1, r0
	cmphs	r1, r2
	bf	.Lrdno
	mov	r6, r2
	lrw	r1, 0x0301a000
	addu	r0, r1
	lrw	r4, 0x4ae08
.Lrdcp:
	cmpnei	r2, 0
	bf	.Lrdhd
	ld.b	r1, (r0, 0)
	st.b	r1, (r4, 0)
	addi	r0, 1
	addi	r4, 1
	subi	r2, 1
	br	.Lrdcp
.Lrdhd:
	lrw	r4, 0x4ae00
	movi	r1, 104
	st.b	r1, (r4, 0)
	ld.b	r1, (r7, 1)
	st.b	r1, (r4, 1)
	movi	r1, 0
	st.b	r1, (r4, 2)
	st.b	r1, (r4, 3)
	st.b	r1, (r4, 4)
	st.b	r1, (r4, 5)
	lsri	r1, r6, 8
	st.b	r1, (r4, 6)
	st.b	r6, (r4, 7)
	mov	r0, r4
	addi	r0, 8
	addu	r0, r6
	movi	r1, 16
	st.b	r1, (r0, 0)
	mov	r0, r6
	addi	r0, 9
	mov	r1, r4
	.short	0xE000, 0x8E5C
	mov	r0, r4
	mov	r1, r6
	addi	r1, 9
	.short	0xE000, 0x7DE8
	movi	r0, 0
	pop	r15
.Lrdno:
	movi	r0, 1
	pop	r15

/* Opcode 13. Three seconds into the codec playback buffer at 0x180000A0,
 * 80 samples then 10 ms, 300 times. Does not store PTT and does not write
 * AT1846S 0x30. r0 = 0. The delay call is patched in main(). */
fw23_play:
	push	r15
	lrw	r4, 0x16000900
	movi	r3, 192
	st.b	r3, (r4, 0xc8)
	ld.b	r3, (r4, 0xcd)
	andi	r3, r3, 111
	st.b	r3, (r4, 0xcd)
	ld.b	r3, (r4, 0xd2)
	andi	r3, r3, 252
	st.b	r3, (r4, 0xd2)
	lrw	r4, 0x4b060
	movi	r3, 0
	st.w	r3, (r4, 0)
	st.w	r3, (r4, 4)
	st.w	r3, (r4, 8)
.Lpl:
	lrw	r4, 0x4b060
	ld.w	r6, (r4, 0)
	lrw	r3, 24000
	cmphs	r6, r3
	bt	.Lpdone
	lrw	r3, 1600
	cmphs	r6, r3
	bt	.Lchi
	lrw	r5, 1000
	br	.Lph
.Lchi:
	mov	r0, r6
	lrw	r1, 1600
	subu	r0, r1
	lrw	r1, 3750
	mult	r0, r0, r1
	lrw	r1, 22400
	divu	r0, r0, r1
	addi	r0, 50
	mov	r5, r0
.Lph:
	lrw	r1, 536871
	mult	r5, r5, r1
	ld.w	r0, (r4, 4)
	addu	r0, r5
	st.w	r0, (r4, 4)
	lsri	r0, r0, 24
	lsli	r0, r0, 1
	lrw	r1, sine
	addu	r1, r0
	ld.hs	r0, (r1, 0)
	asri	r0, r0, 2
	ld.w	r2, (r4, 8)
	lsli	r3, r2, 1
	lrw	r1, 0x180000a0
	addu	r1, r3
	st.h	r0, (r1, 0)
	addi	r2, 1
	st.w	r2, (r4, 8)
	addi	r6, 1
	st.w	r6, (r4, 0)
	cmpnei	r2, 80
	bt	.Lpl
	movi	r3, 0
	st.w	r3, (r4, 8)
	movi	r0, 10
	.short	0xE000, 0x18A4
	lrw	r3, 0x110003b0
	ld.w	r2, (r3, 0)
	bseti	r2, 5
	st.w	r2, (r3, 0)
	br	.Lpl
.Lpdone:
	movi	r0, 0
	pop	r15

fw21_clamp:
	lrw	r1, 10000
	cmplt	r1, r0
	bf	.Lc1
	mov	r0, r1
.Lc1:
	lrw	r1, -10000
	cmplt	r0, r1
	bf	.Lc2
	mov	r0, r1
.Lc2:
	jmp	r15

fw21_tone:
	push	r15
	lrw	r4, 0x4b02c
	ld.w	r2, (r4, 0)
	cmpnei	r2, 0
	bt	.Lplay
	lrw	r4, 0x4b030
	ld.hs	r3, (r4, 0)
	cmpnei	r3, 0
	bt	.Lpop
	lrw	r4, 0x4b036
	ld.hs	r3, (r4, 0)
	cmpnei	r3, 0
	bf	.Lzero
	movi	r3, 0
	st.h	r3, (r4, 0)
	lrw	r4, 0x4b00c
	movi	r3, 1
	st.w	r3, (r4, 0)
	lrw	r4, 0x4a3e4
	ld.w	r3, (r4, 0)
	st.w	r3, (r4, 4)
	movi	r3, 0
	st.w	r3, (r4, 8)
.Lzero:
	movi	r0, 0
	pop	r15
.Lpop:
	lrw	r4, 0x4b032
	ld.hs	r0, (r4, 0)
	mov	r1, r0
	andi	r1, r1, 63
	lsli	r1, 2
	lrw	r5, 0x4b260
	addu	r1, r5
	ld.hs	r5, (r1, 0)
	ld.hs	r6, (r1, 2)
	addi	r0, 1
	st.h	r0, (r4, 0)
	lrw	r4, 0x4b030
	ld.hs	r0, (r4, 0)
	subi	r0, 1
	st.h	r0, (r4, 0)
	lrw	r4, 0x4b038
	st.h	r5, (r4, 0)
	lsli	r6, 3
	lrw	r4, 0x4b02c
	st.w	r6, (r4, 0)
.Lplay:
	lrw	r4, 0x4b02c
	ld.w	r2, (r4, 0)
	subi	r2, 1
	st.w	r2, (r4, 0)
	lrw	r4, 0x4b038
	ld.h	r2, (r4, 0)
	cmpnei	r2, 0
	bf	.Lzero
	lrw	r4, 0x4b02a
	ld.h	r3, (r4, 0)
	addu	r3, r2
.Lwrap:
	lrw	r1, 64000
	cmphs	r3, r1
	bf	.Lidx
	subu	r3, r1
	br	.Lwrap
.Lidx:
	st.h	r3, (r4, 0)
	movi	r1, 250
	movi	r0, 0
.Ldv:
	cmphs	r3, r1
	bf	.Ldvd
	subu	r3, r1
	addi	r0, 1
	br	.Ldv
.Ldvd:
	lsli	r0, 1
	/* The pool word is the link address. main() adds the XIP base
	   0x0301A000, which is how the stock image addresses its own flash. */
	lrw	r4, sine
	addu	r4, r0
	ld.hs	r0, (r4, 0)
	lrw	r4, 0x4b028
	ld.hs	r1, (r4, 0)
	mult	r0, r0, r1
	asri	r0, r0, 15
	bsr	fw21_clamp
	pop	r15

	.align	2
sine:
""" + words + r"""
	.align	2
	.literals
"""


def main():
    OUT.mkdir(parents=True, exist_ok=True)
    src = OUT / "fw21_ext.S"
    src.write_text(asm_source(), encoding="utf-8")
    subprocess.check_call([str(AS), "-mcpu=ck803", "-o", str(OUT / "ext.o"), str(src)])
    subprocess.check_call([str(LD), "-Ttext=0x%X" % BASE, "-o", str(OUT / "ext.elf"), str(OUT / "ext.o")])
    code, addr = text_of((OUT / "ext.elf").read_bytes())
    if addr != BASE:
        raise SystemExit("linked at %X" % addr)
    names = subprocess.check_output([str(NM), str(OUT / "ext.elf")], text=True)
    sym = {}
    for line in names.splitlines():
        parts = line.split()
        if len(parts) >= 3:
            sym[parts[2]] = int(parts[0], 16)
    for label, token, target in (
        ("sample", bytes.fromhex("00e008b4"), ONE),
        ("ack", bytes.fromhex("00e07c8e"), ACK),
        ("cksum", bytes.fromhex("00e05c8e"), 0x8E5C),
        ("uart", bytes.fromhex("00e0e87d"), 0x7DE8),
        ("delay", bytes.fromhex("00e0a418"), 0x18A4),
    ):
        at = code.find(token)
        if at < 0:
            raise SystemExit("missing " + label)
        code[at:at + 4] = encode_bsr(BASE + at, target)
        print(label, "at", hex(BASE + at), "->", hex(target))
    sine_at = sym["sine"]
    word = struct.pack("<I", sine_at)
    xip = (0x0301A000 + sine_at) & 0xFFFFFFFF
    table = sine_at - BASE
    found = 0
    for at in range(0, len(code) - 3, 4):
        if table <= at < table + 512:
            continue
        if code[at:at + 4] == word:
            code[at:at + 4] = struct.pack("<I", xip)
            found += 1
            print("sine", hex(sine_at), "literal", hex(BASE + at), "->", hex(xip))
    if found < 1:
        raise SystemExit("sine literal missing")
    if BASE + len(code) > 0x5C6FC:
        raise SystemExit("extension overflows %X" % (BASE + len(code)))
    print("extension", len(code), "end", hex(BASE + len(code)))
    img, _ = build.build(["c7000-fw20-drop", "c7000-tot-120"], "FW23")
    img = bytearray(img)
    hooks = {
        0x5AF1E: bytes.fromhex("8c010031"),
        0x5AFEA: bytes.fromhex("00e00f02"),
        0x5B4BA: bytes.fromhex("ffe3a7ff"),
        0x5B308: bytes.fromhex("e0980187"),
        0x5B318: bytes.fromhex("8f11c094219458640308003602048661"),
    }
    for off, expect in hooks.items():
        got = bytes(img[off:off + len(expect)])
        if got != expect:
            raise SystemExit("hook %X is %s" % (off, got.hex()))
    if img[BASE:BASE + 32] != bytes(32):
        raise SystemExit("extension site is not empty")
    img[0x5AF1E:0x5AF22] = encode_bsr(0x5AF1E, sym["fw21_op3"])
    img[0x5AFEA:0x5AFEE] = encode_bsr(0x5AFEA, sym["fw21_sample"])
    img[0x5B4BA:0x5B4BE] = encode_bsr(0x5B4BA, sym["fw21_sample"])
    img[0x5B308:0x5B30C] = encode_bsr(0x5B308, sym["fw21_ops"])
    img[0x5B318:0x5B328] = encode_bsr(0x5B318, sym["fw21_fill"]) + bytes.fromhex("6c03") * 6
    img[BASE:BASE + len(code)] = code
    gate_at = 0x5B58E
    if bytes(img[gate_at:gate_at + 4]) != bytes.fromhex("020c9414"):
        raise SystemExit("on_key gate is %s" % bytes(img[gate_at:gate_at + 4]).hex())
    img[gate_at:gate_at + 4] = encode_bsr(gate_at, sym["fw22_gate"])
    if img[0x38464:0x38474] != b"DMR003.FW23.V022":
        raise SystemExit("tag " + img[0x38464:0x38474].decode())
    play = sym["fw23_play"] - BASE
    play_end = sym["fw21_clamp"] - BASE
    blob = bytes(code[play:play_end])
    if b"\x60\x05\x00\x11" in blob or struct.pack("<I", 0x11000560) in blob:
        raise SystemExit("opcode 13 mentions PTT")
    if struct.pack("<I", 0x11000560) in bytes(code):
        raise SystemExit("extension mentions PTT")
    dest = HERE.parent.parent / "radio_firmware" / "build" / "DMR003.FW23.V022.bin"
    dest.parent.mkdir(parents=True, exist_ok=True)
    dest.write_bytes(img)
    import hashlib
    print(dest)
    print(hashlib.sha256(img).hexdigest())


if __name__ == "__main__":
    main()
