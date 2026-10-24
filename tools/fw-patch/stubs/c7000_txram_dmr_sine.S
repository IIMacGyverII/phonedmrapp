/* c7000-txram-dmr-sine1k (R3a8). Same host-key DMR path as
 * c7000_txram_dmr.S: the four bsr 0xe9c sites inside the 0x26 handler,
 * on_key / on_unkey, RF_MODE 0x10E0, WORK_MODE 0x80, bit 0 of 0x11000080
 * (bit 4 stays clear), FM_BANDWIDTH bits 4 and 6 cleared, AT1846S
 * 0x30 = 0x4006 then 0x4026, 0x58 = 0xBCFD, PTT = 1. on_unkey puts the
 * wide-FM pair back. Not on the boot path. No +0x3074, no +0x3EDFC.
 *
 * The fill is a 1 kHz sine instead of the square. Eight samples, one
 * cycle at 8 kHz, repeated 64 times across the 512 halfwords. The movi
 * immediates are 0, 6, 8, 6, 0, 250, 248, 250. The TX RAM reads each
 * stored halfword big-endian, so those are 0, +1536, +2048, +1536, 0,
 * -1536, -2048, -1536. Peak count is 2048, the same peak as the A=2048
 * square. Nothing larger is stored. R3a9 is patch
 * c7000-txram-dmr-sine1k-p4096: the same bytes with sample immediates
 * 0, 11, 16, 11, 0, 245, 240, 245. Measured 2026-10-24: 1 kHz line
 * 1923 Hz, steady p99 2186 Hz. This file stays the peak-2048 image.
 *
 * push r4-r8, r15. r0-r3 only after the event post. The bsr encodings
 * are raw halfwords: gas emits a relocation for `bsr 0xFD011220` and ld
 * drops it. The build fills them. Linked at file offset 0x5B000
 * (XIP 0x03075000). on_unkey is not at 0x5B088; the launch=2 sites
 * branch to wherever this file places it.
 */
	.text
	.global	on_key
	.global	on_unkey
	.global	b_e9c_key
	.global	b_at_4006
	.global	b_at_4026
	.global	b_at_bcfd
	.global	b_e9c_unkey
	.global	b_at_8405
	.global	b_at_7026
on_key:
	push	r4-r8, r15
b_e9c_key:
	.short	0xE000, 0x0000		/* bsr 0xe9c */
	lrw	r2, 0x11000104		/* RF_MODE */
	movi	r3, 135
	lsli	r3, 5			/* 0x10E0 */
	st.w	r3, (r2, 0)
	lrw	r3, 0x11000100		/* WORK_MODE */
	movi	r2, 128			/* 0x80 */
	st.w	r2, (r3, 0)
	lrw	r3, 0x11000080
	ld.w	r2, (r3, 0)
	bseti	r2, 0
	st.w	r2, (r3, 0)
	lrw	r3, 0x11000500		/* FM_BANDWIDTH */
	ld.w	r2, (r3, 0)
	bclri	r2, 4
	bclri	r2, 6
	st.w	r2, (r3, 0)
	lrw	r3, 0x16000030
	movi	r2, 64			/* 64 cycles, not a sample */
1:
	movi	r1, 0			/* 0 */
	st.h	r1, (r3, 0)
	addi	r3, 2
	movi	r1, 6			/* +1536 */
	st.h	r1, (r3, 0)
	addi	r3, 2
	movi	r1, 8			/* +2048, peak */
	st.h	r1, (r3, 0)
	addi	r3, 2
	movi	r1, 6			/* +1536 */
	st.h	r1, (r3, 0)
	addi	r3, 2
	movi	r1, 0			/* 0 */
	st.h	r1, (r3, 0)
	addi	r3, 2
	movi	r1, 250			/* -1536 */
	st.h	r1, (r3, 0)
	addi	r3, 2
	movi	r1, 248			/* -2048, peak */
	st.h	r1, (r3, 0)
	addi	r3, 2
	movi	r1, 250			/* -1536 */
	st.h	r1, (r3, 0)
	addi	r3, 2
	subi	r2, 1
	cmpnei	r2, 0
	bt	1b
	movi	r0, 48			/* AT1846S 0x30 = 0x4006 */
	movi	r1, 16390
b_at_4006:
	.short	0xE000, 0x0000		/* bsr 0xFD011220 */
	movi	r0, 48			/* 0x30 = 0x4026, 12.5 kHz, last */
	movi	r1, 16422
b_at_4026:
	.short	0xE000, 0x0000
	movi	r0, 88			/* 0x58 = 0xBCFD */
	movi	r1, 48381
b_at_bcfd:
	.short	0xE000, 0x0000
	lrw	r3, 0x11000560		/* PTT = 1 */
	movi	r2, 1
	st.w	r2, (r3, 0)
	pop	r4-r8, r15
	.align	2
	.literals

on_unkey:
	push	r4-r8, r15
b_e9c_unkey:
	.short	0xE000, 0x0000		/* bsr 0xe9c */
	lrw	r3, 0x11000560
	movi	r2, 0
	st.w	r2, (r3, 0)
	lrw	r3, 0x11000080
	ld.w	r2, (r3, 0)
	bclri	r2, 0
	st.w	r2, (r3, 0)
	movi	r0, 88			/* 0x58 = 0x8405 */
	movi	r1, 33797
b_at_8405:
	.short	0xE000, 0x0000
	movi	r0, 48			/* 0x30 = 0x7026, wide FM */
	movi	r1, 28710
b_at_7026:
	.short	0xE000, 0x0000
	pop	r4-r8, r15
	.align	2
	.literals
