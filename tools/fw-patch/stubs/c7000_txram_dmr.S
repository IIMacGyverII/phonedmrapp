/* c7000-txram-dmr (R3a3). The 0x26 handler posts an event with bsr 0xe9c and
 * never calls FM key-up. R3a2's flag therefore stayed clear on a host key and
 * the radio radiated the codec tone. These two entries replace the four
 * bsr 0xe9c sites inside that handler (launch = 1 at +0x92C8 and +0x92E0,
 * launch = 2 at +0x92AA and +0x92FA). Nothing else calls them. The boot
 * self-test keys through +0x3D688 and does not send 0x26, so this stub is not
 * on the key-up path and does not run at module boot.
 *
 * on_key calls 0xe9c with the handler's r0/r1, then selects TX RAM, fills the
 * A = 256 square. R3a4 is patch c7000-txram-dmr-a512: the same bytes with
 * movi r1, 2 and movi r1, 254. R3a5 is patch c7000-txram-dmr-a1024:
 * movi r1, 4 and movi r1, 252. R3a6 is patch c7000-txram-dmr-a2048:
 * movi r1, 8 and movi r1, 248. R3a7 is patch c7000-txram-dmr-a4096:
 * movi r1, 16 and movi r1, 240. R3a8 is a separate stub,
 * c7000_txram_dmr_sine.S: a 1 kHz sine at the same peak count as the
 * A = 2048 square. This file stays the image that was measured.
 * The stub programs the DMR modulator (RF_MODE 0x10E0, WORK_MODE 0x80,
 * AT1846S 0x30 = 0x4006 then 0x4026, 0x58 = 0xBCFD) and stores PTT = 1.
 * on_unkey calls 0xe9c, then PTT = 0, clears the TX-RAM bit, and puts the
 * wide-FM pair back (0x58 = 0x8405, 0x30 = 0x7026). The factory reload is the
 * real restore.
 *
 * push r4-r8, r15 so a callee cannot lose the handler's r7. r0-r3 only after
 * the event post. The bsr encodings are raw halfwords: gas emits a relocation
 * for `bsr 0xFD011220` and ld drops it. Linked at file offset 0x5B000
 * (XIP 0x03075000). Bit 4 of 0x11000080 stays clear.
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
	movi	r1, 1			/* big-endian +256 */
	movi	r2, 256
1:
	st.h	r1, (r3, 0)
	addi	r3, 2
	subi	r2, 1
	cmpnei	r2, 0
	bt	1b
	movi	r1, 255			/* big-endian -256 */
	movi	r2, 256
2:
	st.h	r1, (r3, 0)
	addi	r3, 2
	subi	r2, 1
	cmpnei	r2, 0
	bt	2b
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
