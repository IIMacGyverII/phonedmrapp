/* c7000-txram-m17-stream (R4c, tag R4c0). Host key only.
 * Same 0x26 launch sites as the R4a stub. After the first 512 samples
 * and PTT=1, poll FM_ADDR_SW (0x1100056C). On each change of 1 or 2,
 * copy the next 256 samples into the half it names (1 = low). The table
 * is the zero tail from file +0x5B400. When it runs out, write two zero
 * halves and return so unkey can drop PTT. No mask write. No hook on
 * the service task. Not on the boot path.
 *
 * Linked at file offset 0x5B000. on_unkey follows on_key.
 */
	.text
	.global	on_key
	.global	on_unkey
on_key:
	push	r4-r9, r15
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
	/* r4 is the next sample. First FM_ADDR_SW value is only recorded. */
	lrw	r6, 0x030766fc		/* one past the last table byte */
	movi	r7, 0			/* last half select, 0 = not seen */
	movi	r8, 0			/* zero halves written */
	movi	r5, 16			/* half-write cap */
	movi	r9, 250
	lsli	r9, 1			/* 500 polls of delay(1) */
poll:
	movi	r0, 1
	.short	0xE000, 0x41F8		/* bsr 0x541F8, filled in the patch bytes */
	subi	r9, 1
	cmpnei	r9, 0
	bf	done
	lrw	r3, 0x1100056c		/* FM_ADDR_SW */
	ld.w	r2, (r3, 0)
	andi	r2, r2, 3
	cmpnei	r2, 1
	bt	2f
	br	3f
2:
	cmpnei	r2, 2
	bt	poll
3:
	cmpnei	r7, 0
	bt	4f
	mov	r7, r2
	br	poll
4:
	cmpne	r2, r7
	bf	poll
	mov	r7, r2
	lrw	r3, 0x16000030
	cmpnei	r2, 1
	bt	5f
	br	6f
5:
	lrw	r3, 0x16000230		/* high half */
6:
	movi	r2, 128
	lsli	r2, 1			/* 256 samples */
	cmphs	r4, r6
	bt	7f
8:
	cmphs	r4, r6
	bt	9f
	ld.h	r1, (r4, 0)
	st.h	r1, (r3, 0)
	addi	r4, 2
	addi	r3, 2
	subi	r2, 1
	cmpnei	r2, 0
	bt	8b
	movi	r8, 0
	br	10f
9:
	cmpnei	r2, 0
	bf	11f
	movi	r1, 0
	st.h	r1, (r3, 0)
	addi	r3, 2
	subi	r2, 1
	br	9b
11:
	movi	r8, 0
	br	10f
7:
	movi	r1, 0
12:
	st.h	r1, (r3, 0)
	addi	r3, 2
	subi	r2, 1
	cmpnei	r2, 0
	bt	12b
	addi	r8, 1
10:
	subi	r5, 1
	cmpnei	r5, 0
	bf	done
	cmpnei	r8, 2
	bt	poll
done:
	pop	r4-r9, r15
	.align	2
	.literals

on_unkey:
	push	r4-r8, r15
	.short	0xE000, 0x00E9		/* bsr 0xe9c, filled in the patch bytes */
	lrw	r3, 0x11000560
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
	pop	r4-r8, r15
	.align	2
	.literals
