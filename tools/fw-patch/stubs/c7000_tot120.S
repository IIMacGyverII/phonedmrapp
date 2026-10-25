/* 0x3B ceiling. The stock handler stores the body byte and clears the
 * enable flag when the byte is 0. There is no min(tot, 30). This stub
 * writes 120 into the body when the byte is 0 or greater than 120, then
 * calls the stock handler. The radio task counts 100 wakes per unit, and
 * a unit is one second (byte 10 ended a key at 12 s), so 120 is 120 s.
 * The bsr marker is patched to file +0xA308. Linked at file +0x5B700.
 */
	.text
	.global	tot120

tot120:
	push	r15
	addi	r3, r0, 8
	ld.b	r2, (r3, 0)
	movi	r1, 120
	bez	r2, .Lceil
	cmphs	r1, r2
	bt	.Lkeep
.Lceil:
	st.b	r1, (r3, 0)
.Lkeep:
	.short	0xE000, 0xA308
	pop	r15
