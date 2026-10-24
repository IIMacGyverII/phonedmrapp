/* Command 0x40 echoes its first body byte. Linked at file +0x5AEFC.
 * The dispatcher jumps here with r4 = the frame and r4-r8, r15 already
 * pushed. Nothing at boot sends 0x40. This does not key and does not
 * touch PTT. The reply is ten bytes: header, the command, rw=0, sr=0,
 * checksum, length 1, the byte at frame offset 8, and the tail.
 * Checksum is file +0x8E5C. The sender is file +0x7DE8.
 */
	.text
	.global	cmd40

cmd40:
	mov	r0, r4
	bsr	echo40
	.short	0x1495			/* pop r4-r8, r15: file bytes 95 14 */
echo40:
	push	r4, r15
	ld.b	r3, (r0, 1)		/* command byte */
	ld.b	r2, (r0, 8)		/* first body byte */
	subi	r14, 16
	mov	r4, r14
	movi	r1, 104			/* 0x68 */
	st.b	r1, (r4, 0)
	st.b	r3, (r4, 1)
	movi	r1, 0
	st.b	r1, (r4, 2)
	st.b	r1, (r4, 3)
	st.b	r1, (r4, 6)
	movi	r1, 1
	st.b	r1, (r4, 7)
	st.b	r2, (r4, 8)
	movi	r1, 16			/* tail 0x10 */
	st.b	r1, (r4, 9)
	mov	r1, r4
	movi	r0, 10
	.short	0xE000, 0x8E5C		/* bsr file +0x8E5C, filled in the patch */
	mov	r0, r4
	movi	r1, 10
	.short	0xE000, 0x7DE8		/* bsr file +0x7DE8, filled in the patch */
	addi	r14, 16
	pop	r4, r15
