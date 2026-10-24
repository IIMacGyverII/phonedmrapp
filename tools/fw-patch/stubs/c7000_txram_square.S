/* c7000-txram-square (R3a2). FM key-up stores PTT at +0x3EDFC, six bytes after
 * the tx_voice_source clear at +0x3EDF8. Those six bytes become bsr _start
 * plus a 2-byte pad. _start runs before the 50 ms delay at +0x3EE02.
 *
 * The flag word is IRAM .bss 0x4DAAC. Boot zeroes 0x31AF4..0x4DAB0, and the
 * factory image has no literal of 0x4DAAC (the highest referenced word is
 * 0x4DAA8). The flash-resident 0x26 handler sets the word on launch = 1
 * (set_flag, patched over the two movs at +0x92B2) and clears it on
 * launch = 2 (clear_flag, patched over the lrw at +0x929C). The boot
 * self-test calls key-up without sending 0x26, so the flag is 0 and _start
 * does the factory PTT store and returns.
 *
 * When the flag is set, the TX-RAM path is the R3 body: 0x11000080[0] = 1
 * (bit 4, ahb_wr_voice_en, stays clear), FM_BANDWIDTH bits 4 and 6 cleared,
 * 0x16000030 filled +256 / -256 for 256 samples each, then PTT = 1.
 *
 * r0-r3 only. No call. Linked at file offset 0x5B000 (XIP 0x03075000).
 */
	.text
	.global	_start
	.global	set_flag
	.global	clear_flag
_start:
	lrw	r3, 0x4daac
	ld.w	r2, (r3, 0)
	cmpnei	r2, 0
	bt	1f
	lrw	r3, 0x11000560
	movi	r2, 1
	st.w	r2, (r3, 0)
	jmp	r15
1:
	lrw	r3, 0x11000080
	ld.w	r2, (r3, 0)
	bseti	r2, 0
	st.w	r2, (r3, 0)

	lrw	r3, 0x11000500
	ld.w	r2, (r3, 0)
	bclri	r2, 4
	bclri	r2, 6
	st.w	r2, (r3, 0)

	lrw	r3, 0x16000030
	movi	r1, 1
	movi	r2, 256
2:
	st.h	r1, (r3, 0)
	addi	r3, 2
	subi	r2, 1
	cmpnei	r2, 0
	bt	2b

	movi	r1, 255
	movi	r2, 256
3:
	st.h	r1, (r3, 0)
	addi	r3, 2
	subi	r2, 1
	cmpnei	r2, 0
	bt	3b

	lrw	r3, 0x11000560
	movi	r2, 1
	st.w	r2, (r3, 0)
	jmp	r15

set_flag:
	lrw	r3, 0x4daac
	movi	r2, 1
	st.w	r2, (r3, 0)
	movi	r0, 1
	movi	r1, 1
	jmp	r15

clear_flag:
	lrw	r2, 0x4daac
	movi	r3, 0
	st.w	r3, (r2, 0)
	lrw	r3, 0x38874
	jmp	r15

	.align	2
	.literals
