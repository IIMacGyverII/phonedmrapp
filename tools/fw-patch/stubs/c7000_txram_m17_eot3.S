/* c7000-txram-m17-eot3 (R4k, tag R4k0). Host key only.
 * Same bytes as eot2. drop_ptt, in the prefix, posts the stop status.
 *
 * The wake and the key match R4i until on_unkey. on_unkey sets bit 31 of
 * a loop cursor and returns. It does not wait, does not call 0xE9C, and
 * does not drop PTT. The reply at file +0x9294 therefore goes out while
 * the wake is still running. A cursor that is already 0 calls drop_ptt
 * so a second unkey still releases the radio. drop_ptt lives in the
 * prefix. The wake calls it when the end frame has been followed by two
 * zero halves and the cursor is stored as 0.
 *
 * The end frame is not in the loop. The loop is still frames 0-5 with the
 * end bit clear, payload bytes 0 through 15, peak count 6451.
 *
 * on_wake_disp replaces the bsr at file +0x18B5C (was bsr +0x18B70).
 * on_wake_skip replaces the bsr at file +0x18B68 (was bsr +0x3D20, and
 * that target is jmp r15). r3 is 1 to tail-call the dispatcher at
 * 0x03032B70, and 0 to return. Neither entry writes r8. A clear cursor
 * does not write TX RAM, PTT, or the mask. The task entry +0x18A70 is
 * not patched. No +0x3074, no +0x3EDFC. Bit 4 stays clear.
 *
 * Linked at file offset 0x5B000. The bsr encodings are raw halfwords;
 * the builder fills them. This stub stays 368 bytes so the end frame
 * fits in +0x5B170..+0x5B3F0.
 */
	.text
	.global	on_wake_disp
	.global	on_wake_skip
	.global	on_key
	.global	on_unkey

on_wake_disp:
	push	r4-r7, r15
	movi	r3, 1
	br	wake_body
on_wake_skip:
	push	r4-r7, r15
	movi	r3, 0
wake_body:
	/* r3 stays the return choice. A clear cursor is the boot path. */
	lrw	r4, 0x4daac
	ld.w	r5, (r4, 0)
	cmpnei	r5, 0
	bf	wake_done
	lrw	r2, 0x4c7e0		/* interrupt word saved before this call */
	ld.w	r2, (r2, 0)
	movi	r1, 1
	lsli	r1, 15
	and	r2, r1
	cmpnei	r2, 0
	bf	wake_done
	lrw	r2, 0x11000080		/* tx_voice_source, bit 0 */
	ld.w	r2, (r2, 0)
	movi	r1, 1
	and	r2, r1
	cmpnei	r2, 0
	bf	wake_done
	lrw	r2, 0x1100056c		/* FM_ADDR_SW */
	ld.w	r2, (r2, 0)
	andi	r2, r2, 3
	cmpnei	r2, 1
	bt	1f
	lrw	r6, 0x16000030		/* low half */
	br	2f
1:
	cmpnei	r2, 2
	bt	wake_done
	lrw	r6, 0x16000230		/* high half */
2:
	/* 256 samples. Sample 2420 is the tail (0x030766E8). Sample 500 is
	 * the first stream frame (0x030757E8). Frames 0-5 repeat.
	 * br wake_half at file +0x5AEFC. gas drops a br to an absolute
	 * .set, so the halfword is raw: pc 0x5B042, target 0x5AEFC. */
	.short	0x075D
	movi	r7, 128
	lsli	r7, 1
3:
	cmphs	r5, r2
	bf	4f
	lrw	r5, 0x030757e8
4:
	ld.h	r1, (r5, 0)
	st.h	r1, (r6, 0)
	addi	r5, 2
	addi	r6, 2
	subi	r7, 1
	cmpnei	r7, 0
	bt	3b
	st.w	r5, (r4, 0)
wake_done:
	cmpnei	r3, 0
	bt	10f
	pop	r4-r7, r15
	jmp	r15
10:
	pop	r4-r7, r15
	lrw	r3, 0x03032b70		/* dispatcher, file +0x18B70 */
	jmp	r3
	.align	2
	.literals
	/* The wrap immediate used to be an lrw here. wake_half loads it.
	 * The word stays so on_key does not move. */
	.long	0x030766E8

on_key:
	push	r4-r7, r15
	.short	0xE000, 0x00E9		/* bsr 0xe9c, filled in the patch bytes */
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
	lrw	r3, 0x16000030		/* both halves, 512 samples */
	lrw	r4, 0x03075400		/* table, file +0x5B400 */
	movi	r2, 128
	lsli	r2, 2			/* 512 */
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
	.short	0xE000, 0x0B22		/* bsr IRAM 0x2B220, filled in the patch bytes */
	movi	r0, 48			/* 0x30 = 0x4026 */
	movi	r1, 16422
	.short	0xE000, 0x0B22		/* bsr IRAM 0x2B220, filled in the patch bytes */
	movi	r0, 88			/* 0x58 = 0xBCFD */
	movi	r1, 48381
	.short	0xE000, 0x0B22		/* bsr IRAM 0x2B220, filled in the patch bytes */
	lrw	r3, 0x11000560		/* PTT = 1 */
	movi	r2, 1
	st.w	r2, (r3, 0)
	/* Arm the cursor before the interrupt. A wake with bit 15 still
	 * blocked does not copy. */
	lrw	r3, 0x4daac
	lrw	r2, 0x03075800		/* table + 512 samples */
	st.w	r2, (r3, 0)
	lrw	r3, 0x1100039c
	ld.w	r2, (r3, 0)
	bseti	r2, 15
	st.w	r2, (r3, 0)
	pop	r4-r7, r15
	.align	2
	.literals

on_unkey:
	push	r4-r7, r15
	/* Return to the 0x26 handler. The wake keeps the mask and finishes
	 * the end frame. r0 and r1 still belong to that handler. */
	lrw	r4, 0x4daac
	ld.w	r2, (r4, 0)
	cmpnei	r2, 0
	bt	setbit
	.short	0xE000, 0x4EFC		/* bsr drop_ptt, filled in the patch bytes */
	br	unkey_ret
setbit:
	mov	r1, r2
	lsri	r1, 31
	cmpnei	r1, 0
	bt	unkey_ret		/* the wake already has the request */
	lrw	r1, 0x03075400
	cmphs	r2, r1
	bf	unkey_ret		/* end frame or a drain sentinel */
	ld.b	r1, (r4, 3)
	bseti	r1, 7			/* bit 31, without rewriting the address */
	st.b	r1, (r4, 3)
unkey_ret:
	pop	r4-r7, r15
	.align	2
	.literals
