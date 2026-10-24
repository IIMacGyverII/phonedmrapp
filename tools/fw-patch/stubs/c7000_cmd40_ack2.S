/* Command 0x40 ack. Linked at file +0x5AEFC.
 * The dispatcher jumps here with r4 = the frame and r4-r8, r15 already
 * pushed. Nothing at boot sends 0x40. The body is ignored. r1 = 0 is the
 * success status on the reply. This is not the data table at +0x35F64.
 */
	.text
	.global	cmd40

cmd40:
	mov	r0, r4
	bsr	ack40
	.short	0x1495			/* pop r4-r8, r15: file bytes 95 14 */
ack40:
	push	r15
	ld.b	r0, (r0, 1)
	movi	r1, 0
	.short	0xE000, 0x8E7C		/* bsr file +0x8E7C, filled in the patch */
	pop	r15
