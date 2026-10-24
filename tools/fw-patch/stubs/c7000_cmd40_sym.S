/* Command 0x40 streams M17 symbols into a ring. The wake shapes them.
 * Linked at +0x5AEFC.
 *
 * Body byte 0 is the op code. 1 appends symbols, four per byte, the first
 * in bits 7:6 (01 = +3, 00 = +1, 10 = -1, 11 = -3). 2 reads the fill, the
 * underrun count and the last error. 3 resets the ring. 4 renders: the next
 * two bytes are a sample count N, 1..256, and the reply body is 2N bytes in
 * TX-RAM order, taken from the scratch at 0x4AC00. 5 captures four or six
 * FM receive halves. A 2-byte body forces four; a 3-byte body carries the
 * count in byte 2 and accepts only 4 or 6. The next byte is 0, 2, 3 or 4.
 * Every variant stores WORK_MODE 0x80 and holds it across the halves. 2
 * and 4 also clear FM_BANDWIDTH bits 6 and 4. 3 and 4 also store AT1846S
 * 0x58 as 0xBCFD and write 0x8405 back before the replies. Each change of
 * FM_ADDR_SW copies the half that value names, with ld.b, into 0x4A400
 * plus 512 times the index. Each reply is built in place: an 8-byte header
 * at the sample start minus 8, and the sequence, half id and tail just
 * after the 512 bytes. Those three bytes are saved and restored. Six
 * halves end at 0x4B000. Op 6 applies variant 3 or 4 and leaves it, or
 * restores it. Its body is three bytes: op, variant, action 1 apply or
 * 0 restore. It saves WORK_MODE at 0x4A3F8 and, for variant 4, the
 * bandwidth word at 0x4A3FC. Do not run op 5 while op 6 is held: op 5's
 * restore and the first reply header both use 0x4A3F8. Op 5 and op 6 do
 * not write PTT. Anything else is refused. Nothing in this command keys.
 * A clear cursor at 0x4DAAC does nothing, including at boot.
 *
 * The ring is 2048 signed bytes at 0x4A400. 0x4A3E4 is the write count,
 * 0x4A3E8 the next symbol base, 0x4A3EC the phase, 0x4A3F0 the underrun
 * count and 0x4A3F4 the last error. Boot zeroes that run.
 *
 * on_key calls file +0xE9C first. No queued symbols returns after that.
 * A queued ring fills both TX halves, then arms the cursor. The wake fills
 * one half through the 5-phase RRC. An underrun stores zeros and counts.
 * The task entry +0x18A70 is not patched.
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
	.short	0x1495

store40:
	push	r4-r7, r15
	mov	r7, r0
	subi	r14, 4
	st.w	r7, (r14, 0)
	ld.b	r2, (r7, 6)
	ld.b	r3, (r7, 7)
	lsli	r2, 8
	or	r2, r3
	cmpnei	r2, 0
	bf	.Lbad
	ld.b	r3, (r7, 8)
	cmpnei	r3, 3
	bt	.Lnot3
	lrw	r4, 0x4a3e4
	movi	r1, 0
	st.w	r1, (r4, 0)
	st.w	r1, (r4, 4)
	st.w	r1, (r4, 8)
	st.w	r1, (r4, 12)
	st.w	r1, (r4, 16)
	movi	r6, 0
	br	.Lreply2
.Lnot3:
	cmpnei	r3, 2
	bt	.Lnot2
	br	.Lstatus
.Lnot2:
	cmpnei	r3, 1
	bt	.Lmaybe4
	subi	r2, 1
	mov	r3, r2
	lsli	r3, 2
	lrw	r4, 0x4a3e4
	ld.w	r5, (r4, 0)
	ld.w	r6, (r4, 4)
	cmphs	r5, r6
	bf	.Lnone
	mov	r1, r5
	subu	r1, r6
	br	.Locc
.Lnone:
	movi	r1, 0
.Locc:
	addi	r1, 4
	movi	r4, 1
	lsli	r4, 11
	cmphs	r4, r1
	bt	.Lused
	mov	r1, r4
.Lused:
	subu	r4, r1
	cmphs	r4, r3
	bf	.Lfull
	addi	r7, 9
.Lbyte:
	cmpnei	r2, 0
	bf	.Lwrote
	ld.b	r1, (r7, 0)
	addi	r7, 1
	subi	r2, 1
	lsri	r0, r1, 6
	andi	r0, r0, 3
	bsr	put_sym
	lsri	r0, r1, 4
	andi	r0, r0, 3
	bsr	put_sym
	lsri	r0, r1, 2
	andi	r0, r0, 3
	bsr	put_sym
	andi	r0, r1, 3
	bsr	put_sym
	br	.Lbyte
.Lwrote:
	lrw	r4, 0x4a3f4
	movi	r1, 0
	st.w	r1, (r4, 0)
	br	.Lreply2
.Lfull:
	lrw	r4, 0x4a3f4
	movi	r1, 1
	st.w	r1, (r4, 0)
	movi	r5, 1
	br	.Lreply2s
.Lmaybe4:
	cmpnei	r3, 4
	bt	.Lmaybe5
	cmpnei	r2, 3
	bt	.Lbad
	ld.b	r1, (r7, 9)
	ld.b	r3, (r7, 10)
	lsli	r3, 8
	or	r1, r3
	cmpnei	r1, 0
	bf	.Lbad
	movi	r3, 1
	lsli	r3, 8
	cmphs	r3, r1
	bf	.Lbad
	lrw	r6, 0x4ac00
	mov	r5, r1
.Lrloop:
	cmpnei	r5, 0
	bf	.Lrdone
	bsr	one_sample
	st.h	r0, (r6, 0)
	addi	r6, 2
	subi	r5, 1
	br	.Lrloop
.Lrdone:
	lrw	r1, 0x4ac00
	subu	r6, r1
	mov	r5, r6
	addi	r5, 19
	bclri	r5, 0
	bclri	r5, 1
	subu	r14, r5
	mov	r4, r14
	movi	r2, 104
	st.b	r2, (r4, 0)
	ld.b	r2, (r7, 1)
	st.b	r2, (r4, 1)
	movi	r2, 0
	st.b	r2, (r4, 2)
	st.b	r2, (r4, 3)
	st.b	r2, (r4, 4)
	st.b	r2, (r4, 5)
	lsri	r2, r6, 8
	st.b	r2, (r4, 6)
	st.b	r6, (r4, 7)
	lrw	r1, 0x4ac00
	mov	r3, r6
	mov	r0, r4
	addi	r0, 8
.Lrcopy:
	cmpnei	r3, 0
	bf	.Lrcopied
	ld.b	r2, (r1, 0)
	st.b	r2, (r0, 0)
	addi	r1, 1
	addi	r0, 1
	subi	r3, 1
	br	.Lrcopy
.Lrcopied:
	movi	r2, 16
	st.b	r2, (r0, 0)
	mov	r0, r6
	addi	r0, 9
	mov	r1, r4
	.short	0xE000, 0x8E5C
	mov	r0, r4
	mov	r1, r6
	addi	r1, 9
	.short	0xE000, 0x7DE8
	addu	r14, r5
	addi	r14, 4
	pop	r4-r7, r15
.Lmaybe5:
	cmpnei	r3, 5
	bt	.Lmaybe6
	cmpnei	r2, 2
	bt	.Llen3
	movi	r0, 4
	br	.Lgotn
.Llen3:
	cmpnei	r2, 3
	bt	.Lbad
	ld.b	r0, (r7, 10)
	cmpnei	r0, 4
	bt	.Ln6
	br	.Lgotn
.Ln6:
	cmpnei	r0, 6
	bt	.Lbad
.Lgotn:
	ld.b	r1, (r7, 9)
	cmpnei	r1, 0
	bt	.Lv2
	br	.Lvok
.Lv2:
	cmpnei	r1, 2
	bt	.Lv3
	br	.Lvok
.Lv3:
	cmpnei	r1, 3
	bt	.Lv4
	br	.Lvok
.Lv4:
	cmpnei	r1, 4
	bt	.Lbad
.Lvok:
	subi	r14, 24
	st.b	r1, (r14, 15)
	st.b	r0, (r14, 14)
	lrw	r4, 0x11000100
	ld.w	r5, (r4, 0)
	st.w	r5, (r14, 0)
	movi	r0, 128
	st.w	r0, (r4, 0)
	cmpnei	r1, 2
	bt	.Lnb2
	br	.Lbw
.Lnb2:
	cmpnei	r1, 4
	bt	.Lnobw
.Lbw:
	lrw	r4, 0x11000500
	ld.w	r5, (r4, 0)
	st.w	r5, (r14, 4)
	bclri	r5, 4
	bclri	r5, 6
	st.w	r5, (r4, 0)
.Lnobw:
	ld.b	r1, (r14, 15)
	cmpnei	r1, 3
	bt	.Ln58a
	br	.Lw58
.Ln58a:
	cmpnei	r1, 4
	bt	.Lno58
.Lw58:
	movi	r0, 88
	movi	r1, 48381
	.short	0xE000, 0x0B22
.Lno58:
	movi	r6, 0
	movi	r4, 0
.Lround:
	movi	r3, 1
	lsli	r3, 22
.Lspin:
	cmpnei	r3, 0
	bf	.Lto
	subi	r3, 1
	lrw	r0, 0x1100056c
	ld.w	r0, (r0, 0)
	andi	r0, r0, 3
	cmpnei	r0, 1
	bt	.Ln1
	br	.Lleg
.Ln1:
	cmpnei	r0, 2
	bt	.Lspin
.Lleg:
	cmpnei	r4, 0
	bt	.Lhave
	mov	r4, r0
	br	.Lspin
.Lhave:
	mov	r1, r4
	subu	r1, r0
	cmpnei	r1, 0
	bf	.Lspin
	mov	r4, r0
	cmpnei	r4, 1
	bt	.Lrxhi
	lrw	r1, 0x160004e0
	movi	r2, 0
	br	.Lput
.Lrxhi:
	lrw	r1, 0x160006e0
	movi	r2, 1
.Lput:
	mov	r0, r14
	addi	r0, 8
	addu	r0, r6
	st.b	r2, (r0, 0)
	lrw	r0, 0x4a400
	mov	r2, r6
	lsli	r2, 9
	addu	r0, r2
	movi	r3, 1
	lsli	r3, 9
.Lrxbyte:
	ld.b	r2, (r1, 0)
	st.b	r2, (r0, 0)
	addi	r1, 1
	addi	r0, 1
	subi	r3, 1
	cmpnei	r3, 0
	bt	.Lrxbyte
	addi	r6, 1
	ld.b	r0, (r14, 14)
	mov	r1, r6
	subu	r1, r0
	cmpnei	r1, 0
	bt	.Lround
	bsr	.Lrest
	movi	r5, 0
.Louts:
	bsr	.Lsendh
	addi	r5, 1
	ld.b	r0, (r14, 14)
	mov	r1, r5
	subu	r1, r0
	cmpnei	r1, 0
	bt	.Louts
	addi	r14, 24
	addi	r14, 4
	pop	r4-r7, r15
.Lto:
	bsr	.Lrest
	addi	r14, 24
	br	.Lbad
.Lrest:
	lrw	r4, 0x4a3f8
	st.w	r15, (r4, 0)
	lrw	r4, 0x11000100
	ld.w	r5, (r14, 0)
	st.w	r5, (r4, 0)
	ld.b	r1, (r14, 15)
	cmpnei	r1, 2
	bt	.Lrb2
	br	.Lrbw
.Lrb2:
	cmpnei	r1, 4
	bt	.Lnrbw
.Lrbw:
	lrw	r4, 0x11000500
	ld.w	r5, (r14, 4)
	st.w	r5, (r4, 0)
.Lnrbw:
	ld.b	r1, (r14, 15)
	cmpnei	r1, 3
	bt	.Lrs3
	br	.Lrs58
.Lrs3:
	cmpnei	r1, 4
	bt	.Lrxdone
.Lrs58:
	movi	r0, 88
	movi	r1, 33797
	.short	0xE000, 0x0B22
.Lrxdone:
	lrw	r4, 0x4a3f8
	ld.w	r15, (r4, 0)
	jmp	r15
.Lsendh:
	mov	r7, r15
	lrw	r1, 0x4a400
	mov	r0, r5
	lsli	r0, 9
	addu	r1, r0
	mov	r4, r1
	subi	r4, 8
	movi	r2, 104
	st.b	r2, (r4, 0)
	ld.w	r0, (r14, 24)
	ld.b	r2, (r0, 1)
	st.b	r2, (r4, 1)
	movi	r2, 0
	st.b	r2, (r4, 2)
	st.b	r2, (r4, 3)
	st.b	r2, (r4, 4)
	st.b	r2, (r4, 5)
	movi	r2, 2
	st.b	r2, (r4, 6)
	st.b	r2, (r4, 7)
	mov	r0, r1
	movi	r3, 1
	lsli	r3, 9
	addu	r0, r3
	ld.b	r6, (r0, 0)
	st.b	r6, (r14, 16)
	ld.b	r6, (r0, 1)
	st.b	r6, (r14, 17)
	ld.b	r6, (r0, 2)
	st.b	r6, (r14, 18)
	st.b	r5, (r0, 0)
	mov	r6, r14
	addi	r6, 8
	addu	r6, r5
	ld.b	r2, (r6, 0)
	st.b	r2, (r0, 1)
	movi	r2, 16
	st.b	r2, (r0, 2)
	movi	r0, 1
	lsli	r0, 9
	addi	r0, 11
	mov	r1, r4
	.short	0xE000, 0x8E5C
	mov	r0, r4
	movi	r1, 1
	lsli	r1, 9
	addi	r1, 11
	.short	0xE000, 0x7DE8
	lrw	r1, 0x4a400
	mov	r0, r5
	lsli	r0, 9
	addu	r1, r0
	movi	r3, 1
	lsli	r3, 9
	addu	r1, r3
	ld.b	r2, (r14, 16)
	st.b	r2, (r1, 0)
	ld.b	r2, (r14, 17)
	st.b	r2, (r1, 1)
	ld.b	r2, (r14, 18)
	st.b	r2, (r1, 2)
	jmp	r7
.Lmaybe6:
	cmpnei	r3, 6
	bt	.Lbad
	cmpnei	r2, 3
	bt	.Lbad
	ld.b	r1, (r7, 9)
	ld.b	r3, (r7, 10)
	cmpnei	r3, 0
	bt	.Lapply
	lrw	r4, 0x4a3f8
	ld.w	r5, (r4, 0)
	lrw	r4, 0x11000100
	st.w	r5, (r4, 0)
	cmpnei	r1, 4
	bt	.Lno4
	lrw	r4, 0x4a3fc
	ld.w	r5, (r4, 0)
	lrw	r4, 0x11000500
	st.w	r5, (r4, 0)
	br	.Lr58b
.Lno4:
	cmpnei	r1, 3
	bt	.Lack
.Lr58b:
	movi	r0, 88
	movi	r1, 33797
	.short	0xE000, 0x0B22
	br	.Lack
.Lapply:
	cmpnei	r3, 1
	bt	.Lbad
	cmpnei	r1, 3
	bt	.Lap4
	br	.Lapdo
.Lap4:
	cmpnei	r1, 4
	bt	.Lbad
.Lapdo:
	lrw	r4, 0x11000100
	ld.w	r5, (r4, 0)
	lrw	r0, 0x4a3f8
	st.w	r5, (r0, 0)
	movi	r5, 128
	st.w	r5, (r4, 0)
	cmpnei	r1, 4
	bt	.Lonly58
	lrw	r4, 0x11000500
	ld.w	r5, (r4, 0)
	lrw	r0, 0x4a3fc
	st.w	r5, (r0, 0)
	bclri	r5, 4
	bclri	r5, 6
	st.w	r5, (r4, 0)
.Lonly58:
	movi	r0, 88
	movi	r1, 48381
	.short	0xE000, 0x0B22
.Lack:
	ld.w	r7, (r14, 0)
	ld.b	r0, (r7, 1)
	movi	r1, 0
	.short	0xE000, 0x8E7C
	addi	r14, 4
	pop	r4-r7, r15
.Lbad:
	ld.w	r7, (r14, 0)
	ld.b	r0, (r7, 1)
	movi	r1, 1
	.short	0xE000, 0x8E7C
	addi	r14, 4
	pop	r4-r7, r15
.Lstatus:
	ld.w	r7, (r14, 0)
	lrw	r4, 0x4a3e4
	ld.w	r6, (r4, 0)
	ld.w	r1, (r4, 4)
	cmphs	r6, r1
	bt	.Lstf
	movi	r6, 0
	br	.Lstb
.Lstf:
	subu	r6, r1
.Lstb:
	ld.w	r3, (r4, 12)
	ld.w	r1, (r4, 16)
	subi	r14, 20
	mov	r4, r14
	movi	r2, 104
	st.b	r2, (r4, 0)
	ld.b	r2, (r7, 1)
	st.b	r2, (r4, 1)
	movi	r2, 0
	st.b	r2, (r4, 2)
	st.b	r2, (r4, 3)
	st.b	r2, (r4, 6)
	movi	r2, 6
	st.b	r2, (r4, 7)
	st.b	r6, (r4, 8)
	lsri	r2, r6, 8
	st.b	r2, (r4, 9)
	st.b	r3, (r4, 10)
	lsri	r2, r3, 8
	st.b	r2, (r4, 11)
	st.b	r1, (r4, 12)
	lsri	r2, r1, 8
	st.b	r2, (r4, 13)
	movi	r2, 16
	st.b	r2, (r4, 14)
	mov	r1, r4
	movi	r0, 15
	.short	0xE000, 0x8E5C
	mov	r0, r4
	movi	r1, 15
	.short	0xE000, 0x7DE8
	addi	r14, 20
	addi	r14, 4
	pop	r4-r7, r15
.Lreply2:
	movi	r5, 0
.Lreply2s:
	ld.w	r7, (r14, 0)
	lrw	r4, 0x4a3e4
	ld.w	r6, (r4, 0)
	ld.w	r1, (r4, 4)
	cmphs	r6, r1
	bt	.Lr2
	movi	r6, 0
	br	.Lr2b
.Lr2:
	subu	r6, r1
.Lr2b:
	subi	r14, 16
	mov	r4, r14
	movi	r1, 104
	st.b	r1, (r4, 0)
	ld.b	r1, (r7, 1)
	st.b	r1, (r4, 1)
	movi	r1, 0
	st.b	r1, (r4, 2)
	st.b	r5, (r4, 3)
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
	.short	0xE000, 0x8E5C
	mov	r0, r4
	movi	r1, 11
	.short	0xE000, 0x7DE8
	addi	r14, 16
	addi	r14, 4
	pop	r4-r7, r15
	.align	2
	.literals

put_sym:
	push	r4-r7, r15
	lrw	r4, dibit
	addu	r4, r0
	ld.b	r0, (r4, 0)
	sextb	r0, r0
	lrw	r4, 0x4a3e4
	ld.w	r3, (r4, 0)
	movi	r6, 1
	lsli	r6, 11
	subi	r6, 1
	and	r3, r6
	lrw	r6, 0x4a400
	addu	r6, r3
	st.b	r0, (r6, 0)
	ld.w	r3, (r4, 0)
	addi	r3, 1
	st.w	r3, (r4, 0)
	pop	r4-r7, r15
	.align	2
	.literals

one_sample:
	push	r4-r7, r15
	lrw	r4, 0x4a3e4
	ld.w	r7, (r4, 0)
	ld.w	r5, (r4, 4)
	ld.w	r6, (r4, 8)
	cmphs	r5, r7
	bf	.Lacc
	ld.w	r2, (r4, 12)
	addi	r2, 1
	st.w	r2, (r4, 12)
	movi	r0, 0
	pop	r4-r7, r15
.Lacc:
	mov	r4, r6
	lsli	r4, 3
	addu	r4, r6
	lsli	r4, 1
	lrw	r0, coeffs
	addu	r4, r0
	movi	r2, 0
	movi	r3, 0
.Ltap:
	mov	r1, r5
	addu	r1, r3
	subi	r1, 4
	cmphs	r1, r7
	bt	.Lz
	movi	r0, 1
	lsli	r0, 11
	subi	r0, 1
	and	r1, r0
	lrw	r0, 0x4a400
	addu	r0, r1
	ld.b	r1, (r0, 0)
	sextb	r1, r1
	br	.Ls
.Lz:
	movi	r1, 0
.Ls:
	ld.hs	r0, (r4, 0)
	mult	r1, r0
	addu	r2, r1
	addi	r4, 2
	addi	r3, 1
	cmpnei	r3, 9
	bt	.Ltap
	lrw	r1, 1692
	mult	r2, r1
	asri	r2, r2, 15
	lrw	r1, 6451
	cmplt	r1, r2
	bf	.Llo
	mov	r2, r1
	br	.Lsw
.Llo:
	lrw	r1, -6451
	cmplt	r2, r1
	bf	.Lsw
	mov	r2, r1
.Lsw:
	mov	r1, r2
	lsri	r1, 8
	andi	r1, r1, 255
	andi	r2, r2, 255
	lsli	r2, 8
	or	r1, r2
	mov	r0, r1
	addi	r6, 3
	cmphsi	r6, 5
	bf	.Lsv
	subi	r6, 5
	addi	r5, 1
.Lsv:
	lrw	r4, 0x4a3e8
	st.w	r5, (r4, 0)
	st.w	r6, (r4, 4)
	pop	r4-r7, r15
	.align	2
	.literals

emit_n:
	push	r4-r7, r15
	mov	r6, r0
	mov	r7, r1
.Lem:
	bsr	one_sample
	st.h	r0, (r6, 0)
	addi	r6, 2
	subi	r7, 1
	cmpnei	r7, 0
	bt	.Lem
	pop	r4-r7, r15

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
	br	.Lhalf
.Lhi:
	cmpnei	r2, 2
	bt	wake_done
	lrw	r6, 0x16000230
.Lhalf:
	subi	r14, 4
	st.w	r3, (r14, 0)
	mov	r0, r6
	movi	r1, 128
	lsli	r1, 1
	bsr	emit_n
	ld.w	r3, (r14, 0)
	addi	r14, 4
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
	.short	0xE000, 0x00E9
	lrw	r2, 0x4a3e4
	ld.w	r3, (r2, 0)
	ld.w	r1, (r2, 4)
	cmphs	r1, r3
	bf	host_key
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
	lrw	r0, 0x16000030
	movi	r1, 128
	lsli	r1, 2
	bsr	emit_n
	movi	r0, 48
	movi	r1, 16390
	.short	0xE000, 0x0B22
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
	movi	r2, 1
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
	lrw	r2, 0x4daac
	ld.w	r2, (r2, 0)
	cmpnei	r2, 0
	bt	host_unkey
	.short	0xE000, 0x00E9
	pop	r4-r7, r15
host_unkey:
	lrw	r3, 0x4daac
	movi	r2, 0
	st.w	r2, (r3, 0)
	lrw	r3, 0x1100039c
	ld.w	r2, (r3, 0)
	bclri	r2, 15
	st.w	r2, (r3, 0)
	.short	0xE000, 0x00E9
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

dibit:
	.byte	1, 3, 0xff, 0xfd
	.align	2
coeffs:
	.short	291, -87, -1224, 3059, -32767, 3059, -1224, -87, 291
	.short	0, -440, -658, 4647, -29721, -2525, -770, 386, 177
	.short	0, -434, 155, 3327, -21703, -11549, 979, 561, -141
	.short	0, -141, 561, 979, -11549, -21703, 3327, 155, -434
	.short	0, 177, 386, -770, -2525, -29721, 4647, -658, -440
