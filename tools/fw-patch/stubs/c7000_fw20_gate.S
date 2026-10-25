/* FW20. Called from the symbol wake once the ring has drained and op 7
 * is armed, instead of dropping immediately. Eight more TX-RAM half
 * interrupts play out the half just written and the one still sounding.
 * drop_ptt runs while the TX bits are still set. The stock unkey at
 * +0xE9C then runs (it restores the receiver only in that state), and
 * only after that are bits 0 and 2 of state byte 0x38908 cleared, with
 * the count at 0x38C64+2..5. Linked at file +0x5B720.
 * The countdown word is 0x4B010. A value above 8 is treated as idle.
 */
	.text
	.global	fw20_gate

fw20_gate:
	push	r4-r7, r15
	lrw	r4, 0x4b010
	ld.w	r2, (r4, 0)
	cmphsi	r2, 9
	bt	.Larm
	cmpnei	r2, 0
	bf	.Larm
	subi	r2, 1
	st.w	r2, (r4, 0)
	cmpnei	r2, 0
	bt	.Lout
	movi	r2, 0
	lrw	r4, 0x4daac
	st.w	r2, (r4, 0)
	lrw	r4, 0x4b00c
	st.w	r2, (r4, 0)
	lrw	r4, 0x4b010
	st.w	r2, (r4, 0)
	/* The receiver comes back only when the stock unkey runs while the
	   TX bits are still set. Read the same 0x38874 flag the 0x26 handler
	   uses, drop the carrier, then call that unkey, then clear the bits. */
	lrw	r4, 0x38874
	ld.b	r7, (r4, 0)
	.short	0xE000, 0x065A		/* bsr drop_ptt at file +0x5B65A, filled after assembly */
	cmpnei	r7, 0
	bt	.Lnz
	movi	r0, 0
	br	.Lcall
.Lnz:
	movi	r0, 1
.Lcall:
	movi	r1, 1
	.short	0xE000, 0x0E9C		/* bsr stock unkey at file +0xE9C, filled after assembly */
	lrw	r4, 0x38908
	ld.b	r2, (r4, 0)
	andi	r2, r2, 250
	st.b	r2, (r4, 0)
	lrw	r4, 0x38c64
	movi	r2, 0
	st.b	r2, (r4, 2)
	st.b	r2, (r4, 3)
	st.b	r2, (r4, 4)
	st.b	r2, (r4, 5)
	pop	r4-r7, r15
.Larm:
	movi	r2, 8
	lrw	r4, 0x4b010
	st.w	r2, (r4, 0)
.Lout:
	pop	r4-r7, r15
	.align	2
	.literals
