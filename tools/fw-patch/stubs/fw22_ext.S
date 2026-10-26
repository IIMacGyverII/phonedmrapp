
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
 * movi r1, 1. Ops 8-12 are handled here and do not return. */
fw21_ops:
	mov	r6, r15
	ld.w	r7, (r14, 0)
	ld.b	r3, (r7, 8)
	cmphsi	r3, 8
	bf	.Lpass
	cmphsi	r3, 13
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
	bt	.Ln10
	lrw	r4, 0x4b070
	st.w	r6, (r4, 0)
	bsr	fw22_read
	cmpnei	r0, 0
	bt	.Lbadop
	addi	r14, 4
	pop	r4-r7, r15
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
	.short	0
	.short	804
	.short	1608
	.short	2410
	.short	3212
	.short	4011
	.short	4808
	.short	5602
	.short	6393
	.short	7179
	.short	7962
	.short	8739
	.short	9512
	.short	10278
	.short	11039
	.short	11793
	.short	12539
	.short	13279
	.short	14010
	.short	14732
	.short	15446
	.short	16151
	.short	16846
	.short	17530
	.short	18204
	.short	18868
	.short	19519
	.short	20159
	.short	20787
	.short	21403
	.short	22005
	.short	22594
	.short	23170
	.short	23731
	.short	24279
	.short	24811
	.short	25329
	.short	25832
	.short	26319
	.short	26790
	.short	27245
	.short	27683
	.short	28105
	.short	28510
	.short	28898
	.short	29268
	.short	29621
	.short	29956
	.short	30273
	.short	30571
	.short	30852
	.short	31113
	.short	31356
	.short	31580
	.short	31785
	.short	31971
	.short	32137
	.short	32285
	.short	32412
	.short	32521
	.short	32609
	.short	32678
	.short	32728
	.short	32757
	.short	32767
	.short	32757
	.short	32728
	.short	32678
	.short	32609
	.short	32521
	.short	32412
	.short	32285
	.short	32137
	.short	31971
	.short	31785
	.short	31580
	.short	31356
	.short	31113
	.short	30852
	.short	30571
	.short	30273
	.short	29956
	.short	29621
	.short	29268
	.short	28898
	.short	28510
	.short	28105
	.short	27683
	.short	27245
	.short	26790
	.short	26319
	.short	25832
	.short	25329
	.short	24811
	.short	24279
	.short	23731
	.short	23170
	.short	22594
	.short	22005
	.short	21403
	.short	20787
	.short	20159
	.short	19519
	.short	18868
	.short	18204
	.short	17530
	.short	16846
	.short	16151
	.short	15446
	.short	14732
	.short	14010
	.short	13279
	.short	12539
	.short	11793
	.short	11039
	.short	10278
	.short	9512
	.short	8739
	.short	7962
	.short	7179
	.short	6393
	.short	5602
	.short	4808
	.short	4011
	.short	3212
	.short	2410
	.short	1608
	.short	804
	.short	0
	.short	-804
	.short	-1608
	.short	-2410
	.short	-3212
	.short	-4011
	.short	-4808
	.short	-5602
	.short	-6393
	.short	-7179
	.short	-7962
	.short	-8739
	.short	-9512
	.short	-10278
	.short	-11039
	.short	-11793
	.short	-12539
	.short	-13279
	.short	-14010
	.short	-14732
	.short	-15446
	.short	-16151
	.short	-16846
	.short	-17530
	.short	-18204
	.short	-18868
	.short	-19519
	.short	-20159
	.short	-20787
	.short	-21403
	.short	-22005
	.short	-22594
	.short	-23170
	.short	-23731
	.short	-24279
	.short	-24811
	.short	-25329
	.short	-25832
	.short	-26319
	.short	-26790
	.short	-27245
	.short	-27683
	.short	-28105
	.short	-28510
	.short	-28898
	.short	-29268
	.short	-29621
	.short	-29956
	.short	-30273
	.short	-30571
	.short	-30852
	.short	-31113
	.short	-31356
	.short	-31580
	.short	-31785
	.short	-31971
	.short	-32137
	.short	-32285
	.short	-32412
	.short	-32521
	.short	-32609
	.short	-32678
	.short	-32728
	.short	-32757
	.short	-32767
	.short	-32757
	.short	-32728
	.short	-32678
	.short	-32609
	.short	-32521
	.short	-32412
	.short	-32285
	.short	-32137
	.short	-31971
	.short	-31785
	.short	-31580
	.short	-31356
	.short	-31113
	.short	-30852
	.short	-30571
	.short	-30273
	.short	-29956
	.short	-29621
	.short	-29268
	.short	-28898
	.short	-28510
	.short	-28105
	.short	-27683
	.short	-27245
	.short	-26790
	.short	-26319
	.short	-25832
	.short	-25329
	.short	-24811
	.short	-24279
	.short	-23731
	.short	-23170
	.short	-22594
	.short	-22005
	.short	-21403
	.short	-20787
	.short	-20159
	.short	-19519
	.short	-18868
	.short	-18204
	.short	-17530
	.short	-16846
	.short	-16151
	.short	-15446
	.short	-14732
	.short	-14010
	.short	-13279
	.short	-12539
	.short	-11793
	.short	-11039
	.short	-10278
	.short	-9512
	.short	-8739
	.short	-7962
	.short	-7179
	.short	-6393
	.short	-5602
	.short	-4808
	.short	-4011
	.short	-3212
	.short	-2410
	.short	-1608
	.short	-804
	.align	2
	.literals
