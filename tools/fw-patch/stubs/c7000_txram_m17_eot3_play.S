/* c7000-txram-m17-eot3 prefix (R4k, tag R4k0).
 *
 * Linked at file +0x5AEFC. The IRAM copy ends at this address and does
 * not include these bytes. wake_half is entered by br from the stub, so
 * r15 stays the task return. This prefix does not call 0xE9C.
 *
 * A clear cursor copies nothing: the stub returns before the br.
 * Bit 31 of the cursor is the end request. Loop addresses keep it clear
 * until on_unkey sets it and returns. wake_half masks it before the wrap
 * compare. At sample 2420 (0x030766E8) the source becomes the end frame
 * at 0x03075170. The half that finishes that frame stores sentinel 4.
 * The next wake writes a zero half and stores 8. The wake after that
 * writes one more zero half, stores cursor 0, and calls drop_ptt.
 * drop_ptt clears PTT, the voice bit, and mask bit 15, and restores the
 * two AT1846S words. It then posts status byte 4 through file +0x7E08.
 * That poster only writes the status mailbox. pop of r15 returns.
 */
	.text
	.global	wake_half
	.global	drop_zero
	.global	drop_ptt

wake_half:
	mov	r1, r5
	lsri	r1, 31
	cmpnei	r1, 0
	bt	endbit
	lrw	r2, 0x03075400
	cmphs	r5, r2
	bf	special
	lrw	r2, 0x030766e8
	/* br 0x5B044. gas drops a br to an absolute .set. */
	.short	0x049C
endbit:
	bclri	r5, 31
	movi	r0, 0
	br	copy
special:
	lrw	r2, 0x03075170
	cmphs	r5, r2
	bf	sentinel
	movi	r0, 1
	br	copy
sentinel:
	cmpnei	r5, 4
	bt	sen8
	movi	r5, 8
	br	zhalf
sen8:
	/* Was movi r5, 0. Same size, so the br below stays at file +0x5AF76. */
	br	drop_zero
zhalf:
	movi	r1, 0
	movi	r7, 128
	lsli	r7, 1
zh:
	st.h	r1, (r6, 0)
	addi	r6, 2
	subi	r7, 1
	cmpnei	r7, 0
	bt	zh
	br	store_cur
copy:
	lrw	r2, 0x030766e8
	movi	r7, 128
	lsli	r7, 1
cloop:
	cmpnei	r0, 0
	bt	eot_samp
	cmphs	r5, r2
	bf	loop_samp
	lrw	r5, 0x03075170
	movi	r0, 1
eot_samp:
	lrw	r1, 0x030753f0
	cmphs	r5, r1
	bt	zsamp
loop_samp:
	ld.h	r1, (r5, 0)
	addi	r5, 2
	br	ss
zsamp:
	movi	r1, 0
ss:
	st.h	r1, (r6, 0)
	addi	r6, 2
	subi	r7, 1
	cmpnei	r7, 0
	bt	cloop
	cmpnei	r0, 0
	bf	keepbit
	lrw	r1, 0x030753f0
	cmphs	r5, r1
	bf	store_cur
	movi	r5, 4
	br	store_cur
keepbit:
	bseti	r5, 31
store_cur:
	st.w	r5, (r4, 0)
	/* br 0x5B05E, wake_done. The stub already has r4-r7,r15 pushed. */
	.short	0x0474

drop_zero:
	movi	r5, 0
	movi	r1, 0
	movi	r7, 128
	lsli	r7, 1
dz:
	st.h	r1, (r6, 0)
	addi	r6, 2
	subi	r7, 1
	cmpnei	r7, 0
	bt	dz
	st.w	r5, (r4, 0)		/* cursor 0 */
	subi	sp, 4
	st.w	r3, (sp, 0)		/* r3 is the wake's return choice */
	bsr	drop_ptt
	ld.w	r3, (sp, 0)
	addi	sp, 4
	/* br wake_done at file +0x5B05E. The filler writes the halfword. */
	.short	0x0001

drop_ptt:
	push	r4-r7, r15
	lrw	r3, 0x11000560		/* PTT = 0 */
	movi	r2, 0
	st.w	r2, (r3, 0)
	lrw	r3, 0x11000080
	ld.w	r2, (r3, 0)
	bclri	r2, 0
	st.w	r2, (r3, 0)
	movi	r0, 88			/* 0x58 = 0x8405 */
	movi	r1, 33797
	.short	0xE000, 0x0B22		/* bsr IRAM 0x2B220, filled in the patch bytes */
	movi	r0, 48			/* 0x30 = 0x7026 */
	movi	r1, 28710
	.short	0xE000, 0x0B22		/* bsr IRAM 0x2B220, filled in the patch bytes */
	lrw	r3, 0x1100039c
	ld.w	r2, (r3, 0)
	bclri	r2, 15
	st.w	r2, (r3, 0)
	movi	r0, 4			/* 0x36 body: transmit stopped */
	.short	0xE000, 0x7E08		/* bsr file +0x7E08, filled in the patch bytes */
	pop	r4-r7, r15
	.align	2
	.literals
