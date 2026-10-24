/* c7000-txram-dmr-rrc (R4a, tag R4a0). Same host-key path as the sine
 * stub. The fill is 512 halfwords from the table at file +0x5C000
 * (XIP 0x03076000): an RRC alpha=0.5 4FSK pattern, peak count 5120.
 * Not on the boot path. No +0x3074, no +0x3EDFC. Bit 4 stays clear.
 *
 * push r4-r8, r15. The bsr encodings are raw halfwords; the builder
 * fills them. Linked at file offset 0x5B000.
 */
	.text
	.global	on_key
	.global	on_unkey
on_key:
	push	r4-r8, r15
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
	lrw	r4, 0x03076000		/* sample table, file +0x5C000 */
	lrw	r2, 512
1:
	ld.h	r1, (r4, 0)
	st.h	r1, (r3, 0)
	addi	r4, 2
	addi	r3, 2
	subi	r2, 1
	cmpnei	r2, 0
	bt	1b
	movi	r0, 48			/* AT1846S 0x30 = 0x4006 */
	movi	r1, 16390
	.short	0xE000, 0x0000		/* bsr 0x2B220 */
	movi	r0, 48			/* 0x30 = 0x4026 */
	movi	r1, 16422
	.short	0xE000, 0x0000
	movi	r0, 88			/* 0x58 = 0xBCFD */
	movi	r1, 48381
	.short	0xE000, 0x0000
	lrw	r3, 0x11000560		/* PTT = 1 */
	movi	r2, 1
	st.w	r2, (r3, 0)
	pop	r4-r8, r15
	.align	2
	.literals

on_unkey:
	push	r4-r8, r15
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
	.short	0xE000, 0x0000
	movi	r0, 48			/* 0x30 = 0x7026 */
	movi	r1, 28710
	.short	0xE000, 0x0000
	pop	r4-r8, r15
	.align	2
	.literals
