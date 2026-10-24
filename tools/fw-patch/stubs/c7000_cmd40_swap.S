/* Command 0x40 stores samples for TX RAM's big-endian halfwords.
 * Linked at +0x5AEFC.
 *
 * The host sends little-endian int16. ld.h/st.h would leave the low
 * byte at the low address, and TX RAM would read the swapped value.
 * This handler builds the signed sample, clamps it to ±6451, then
 * stores the high byte at the low address. Nothing else in the R4o
 * handler changes. 0x40 still does not key. A clear cursor does nothing.
 *
 * Nothing at boot sends 0x40 or 0x26. The cursor at 0x4DAAC is zeroed by
 * boot and the factory image has no literal of it. A clear cursor does not
 * write TX RAM, PTT, or the mask. 0x40 never sets PTT.
 *
 * The body is little-endian int16 samples, at most 798 bytes. Each sample
 * is clamped to ±6451. They land at 0x4A800. Count is 0x4A7F0 and one past
 * the last byte is 0x4A7F4. That run has no factory literal. Boot zeroes it.
 *
 * on_key calls file +0xE9C first. A zero count returns after that, so a key
 * with no stored samples is the stock key. A non-zero count then fills both
 * TX halves from the buffer, wrapping, sets the cursor to the end pointer,
 * and enables mask bit 15. The wake writes zero halves once the cursor has
 * reached that end. on_unkey with a zero count is only +0xE9C.
 *
 * The hooks are the per-wake calls at +0x18B5C and +0x18B68. The task entry
 * +0x18A70 is not patched.
 */
	.text
	.global	cmd40
	.global	on_wake_disp
	.global	on_wake_skip
	.global	on_key
	.global	on_unkey

cmd40:
	mov	r0, r4
	bsr	store40
	.short	0x1495			/* pop r4-r8, r15 */

store40:
	push	r4-r7, r15
	mov	r7, r0
	ld.b	r2, (r7, 6)
	ld.b	r3, (r7, 7)
	lsli	r2, 8
	or	r2, r3
	movi	r6, 0
	andi	r1, r2, 1
	cmpnei	r1, 0
	bt	reply
	cmpnei	r2, 0
	bf	reply
	lrw	r1, 798
	cmphs	r1, r2
	bf	reply
	lsri	r2, 1
	mov	r6, r2
	addi	r7, 8
	lrw	r4, 0x4a800
clamp:
	ld.b	r1, (r7, 0)		/* little-endian low byte */
	ld.b	r3, (r7, 1)		/* little-endian high byte */
	lsli	r3, 8
	or	r3, r1
	sexth	r3, r3
	lrw	r1, 6451
	cmplt	r1, r3
	bf	.Llo
	mov	r3, r1
	br	.Lst
.Llo:
	lrw	r1, -6451
	cmplt	r3, r1
	bf	.Lst
	mov	r3, r1
.Lst:
	/* st.h writes the low register byte to the low address.
	 * TX RAM reads that address as the high byte, so swap first. */
	mov	r1, r3
	lsri	r1, 8
	andi	r1, r1, 255
	andi	r3, r3, 255
	lsli	r3, 8
	or	r1, r3
	st.h	r1, (r4, 0)
	addi	r7, 2
	addi	r4, 2
	subi	r2, 1
	cmpnei	r2, 0
	bt	clamp
reply:
	lrw	r2, 0x4a7f0
	st.w	r6, (r2, 0)
	lrw	r3, 0x4a800
	mov	r1, r6
	lsli	r1, 1
	addu	r3, r1
	lrw	r2, 0x4a7f4
	st.w	r3, (r2, 0)
	lrw	r2, 0x4daac
	movi	r1, 0
	st.w	r1, (r2, 0)
	subi	r14, 16
	mov	r4, r14
	movi	r1, 104
	st.b	r1, (r4, 0)
	ld.b	r1, (r0, 1)
	st.b	r1, (r4, 1)
	movi	r1, 0
	st.b	r1, (r4, 2)
	st.b	r1, (r4, 3)
	st.b	r1, (r4, 6)
	movi	r1, 2
	st.b	r1, (r4, 7)
	st.b	r6, (r4, 8)
	lsri	r1, r6, 8
	st.b	r1, (r4, 9)
	movi	r1, 16
	st.b	r1, (r4, 10)
	mov	r1, r4
	movi	r0, 11
	.short	0xE000, 0x8E5C		/* bsr file +0x8E5C */
	mov	r0, r4
	movi	r1, 11
	.short	0xE000, 0x7DE8		/* bsr file +0x7DE8 */
	addi	r14, 16
	pop	r4-r7, r15
	.align	2
	.literals

on_wake_disp:
	push	r4-r7, r15
	movi	r3, 1
	br	wake_body
on_wake_skip:
	push	r4-r7, r15
	movi	r3, 0
wake_body:
	lrw	r4, 0x4daac
	ld.w	r5, (r4, 0)
	cmpnei	r5, 0
	bf	wake_done
	lrw	r2, 0x4c7e0
	ld.w	r2, (r2, 0)
	movi	r1, 1
	lsli	r1, 15
	and	r2, r1
	cmpnei	r2, 0
	bf	wake_done
	lrw	r2, 0x11000080
	ld.w	r2, (r2, 0)
	movi	r1, 1
	and	r2, r1
	cmpnei	r2, 0
	bf	wake_done
	lrw	r2, 0x1100056c
	ld.w	r2, (r2, 0)
	andi	r2, r2, 3
	cmpnei	r2, 1
	bt	.Lhi
	lrw	r6, 0x16000030
	br	.Lhave
.Lhi:
	cmpnei	r2, 2
	bt	wake_done
	lrw	r6, 0x16000230
.Lhave:
	cmpnei	r5, 1
	bt	.Lnot1
	movi	r1, 0
	movi	r7, 128
	lsli	r7, 1
.Lz2:
	st.h	r1, (r6, 0)
	addi	r6, 2
	subi	r7, 1
	cmpnei	r7, 0
	bt	.Lz2
	movi	r5, 0
	st.w	r5, (r4, 0)
	br	wake_done
.Lnot1:
	lrw	r2, 0x4a7f4
	ld.w	r2, (r2, 0)
	cmphs	r5, r2
	bf	.Lcopy
	movi	r1, 0
	movi	r7, 128
	lsli	r7, 1
.Lz1:
	st.h	r1, (r6, 0)
	addi	r6, 2
	subi	r7, 1
	cmpnei	r7, 0
	bt	.Lz1
	movi	r5, 1
	st.w	r5, (r4, 0)
	br	wake_done
.Lcopy:
	movi	r7, 128
	lsli	r7, 1
.Lc:
	cmphs	r5, r2
	bt	.Lpad
	ld.h	r1, (r5, 0)
	st.h	r1, (r6, 0)
	addi	r5, 2
	addi	r6, 2
	subi	r7, 1
	cmpnei	r7, 0
	bt	.Lc
	br	.Lsave
.Lpad:
	cmpnei	r7, 0
	bf	.Lsave
	movi	r1, 0
	st.h	r1, (r6, 0)
	addi	r6, 2
	subi	r7, 1
	br	.Lpad
.Lsave:
	st.w	r5, (r4, 0)
wake_done:
	cmpnei	r3, 0
	bt	.Ldisp
	pop	r4-r7, r15
	jmp	r15
.Ldisp:
	pop	r4-r7, r15
	lrw	r3, 0x03032b70
	jmp	r3
	.align	2
	.literals

on_key:
	push	r4-r7, r15
	.short	0xE000, 0x00E9		/* bsr file +0xE9C */
	lrw	r2, 0x4a7f0
	ld.w	r2, (r2, 0)
	cmpnei	r2, 0
	bt	host_key
	pop	r4-r7, r15
host_key:
	lrw	r2, 0x11000104
	movi	r3, 135
	lsli	r3, 5
	st.w	r3, (r2, 0)
	lrw	r3, 0x11000100
	movi	r2, 128
	st.w	r2, (r3, 0)
	lrw	r3, 0x11000080
	ld.w	r2, (r3, 0)
	bseti	r2, 0
	st.w	r2, (r3, 0)
	lrw	r3, 0x11000500
	ld.w	r2, (r3, 0)
	bclri	r2, 4
	bclri	r2, 6
	st.w	r2, (r3, 0)
	lrw	r4, 0x4a800
	lrw	r5, 0x4a7f4
	ld.w	r5, (r5, 0)
	lrw	r3, 0x16000030
	movi	r2, 128
	lsli	r2, 2
.Lfill:
	cmphs	r4, r5
	bf	.Lsam
	lrw	r4, 0x4a800
.Lsam:
	ld.h	r1, (r4, 0)
	addi	r4, 2
	st.h	r1, (r3, 0)
	addi	r3, 2
	subi	r2, 1
	cmpnei	r2, 0
	bt	.Lfill
	movi	r0, 48
	movi	r1, 16390
	.short	0xE000, 0x0B22		/* bsr IRAM 0x2B220 */
	movi	r0, 48
	movi	r1, 16422
	.short	0xE000, 0x0B22
	movi	r0, 88
	movi	r1, 48381
	.short	0xE000, 0x0B22
	lrw	r3, 0x11000560
	movi	r2, 1
	st.w	r2, (r3, 0)
	lrw	r3, 0x4daac
	st.w	r5, (r3, 0)
	lrw	r3, 0x1100039c
	ld.w	r2, (r3, 0)
	bseti	r2, 15
	st.w	r2, (r3, 0)
	pop	r4-r7, r15
	.align	2
	.literals

on_unkey:
	push	r4-r7, r15
	lrw	r2, 0x4a7f0
	ld.w	r2, (r2, 0)
	cmpnei	r2, 0
	bt	host_unkey
	.short	0xE000, 0x00E9		/* bsr file +0xE9C */
	pop	r4-r7, r15
host_unkey:
	lrw	r3, 0x4daac
	movi	r2, 0
	st.w	r2, (r3, 0)
	lrw	r3, 0x1100039c
	ld.w	r2, (r3, 0)
	bclri	r2, 15
	st.w	r2, (r3, 0)
	.short	0xE000, 0x00E9		/* bsr file +0xE9C */
	lrw	r3, 0x11000560
	movi	r2, 0
	st.w	r2, (r3, 0)
	lrw	r3, 0x11000080
	ld.w	r2, (r3, 0)
	bclri	r2, 0
	st.w	r2, (r3, 0)
	movi	r0, 88
	movi	r1, 33797
	.short	0xE000, 0x0B22
	movi	r0, 48
	movi	r1, 28710
	.short	0xE000, 0x0B22
	pop	r4-r7, r15
	.align	2
	.literals
