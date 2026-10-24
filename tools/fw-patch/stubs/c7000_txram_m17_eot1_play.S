/* c7000-txram-m17-eot1 prefix (R4i, tag R4i0).
 *
 * Linked at file +0x5AEFC. The IRAM copy ends at this address and does
 * not include these bytes. wake_half is entered by br from the stub, so
 * r15 stays the task return and this code does not call 0xE9C.
 * play_eot is entered by bsr from on_unkey, on the 0x26 stack.
 *
 * A clear cursor copies nothing: the stub returns before the br.
 * Bit 31 of the cursor is the end request. Loop addresses keep it clear.
 * wake_half masks it before the wrap compare. At sample 2420
 * (0x030766E8) the source becomes the end frame at 0x03075170.
 * The half that finishes that frame is followed by one zero half, then
 * another wake stores cursor 0. play_eot calls 0xE9C only after that.
 */
	.text
	.global	wake_half
	.global	play_eot

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
	movi	r5, 0
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

play_eot:
	push	r4-r7, r15
	subi	sp, 8
	st.w	r0, (sp, 0)
	st.w	r1, (sp, 4)
	lrw	r7, 1200		/* delay(1) ticks, then unkey anyway */
wait:
	movi	r0, 1
	.short	0xE000, 0x41F8		/* bsr 0x541F8, filled in the patch bytes */
	subi	r7, 1
	cmpnei	r7, 0
	bf	leave
	lrw	r4, 0x4daac
	ld.w	r2, (r4, 0)
	cmpnei	r2, 0
	bf	leave
	mov	r1, r2
	lsri	r1, 31
	cmpnei	r1, 0
	bt	wait
	lrw	r1, 0x03075400
	cmphs	r2, r1
	bf	wait			/* end frame or a drain sentinel */
	ld.b	r1, (r4, 3)
	bseti	r1, 7			/* bit 31, without rewriting the address */
	st.b	r1, (r4, 3)
	br	wait
leave:
	lrw	r3, 0x1100039c
	ld.w	r2, (r3, 0)
	bclri	r2, 15
	st.w	r2, (r3, 0)
	lrw	r3, 0x4daac
	movi	r2, 0
	st.w	r2, (r3, 0)
	ld.w	r0, (sp, 0)
	ld.w	r1, (sp, 4)
	addi	sp, 8
	.short	0xE000, 0x00E9		/* bsr 0xe9c, filled in the patch bytes */
	pop	r4-r7, r15
	jmp	r15
	.align	2
	.literals
