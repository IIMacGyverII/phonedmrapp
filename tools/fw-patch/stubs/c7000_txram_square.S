/* c7000-txram-square (R3). FM key-up stores PTT at +0x3EDFC, six bytes after
 * the tx_voice_source clear at +0x3EDF8. Those six bytes become bsr here plus
 * a 2-byte pad, so this runs before the 50 ms delay at +0x3EE02 and before
 * the modulator is keyed.
 *
 * Guide 7.2.2.1.2 lists one modem bit for the TX-RAM source: 0x11000080[0] = 1.
 * It does not mention ahb_wr_voice_en (bit 4), so this stub leaves bit 4 alone.
 * FM_BANDWIDTH bits 4 and 6 (pre-emphasis, band-pass) are cleared in place.
 * The ping-pong (0x16000030, two halves of 256 samples) is filled once:
 * low half +A, high half -A, 16-bit big-endian. Nothing refills it, so the
 * 64 ms pattern repeats as a 15.625 Hz square. A = 256 counts on this image
 * (stored halfwords 0x0001 and 0x00FF). PTT (0x11000560) is set after the fill.
 *
 * r0-r3 only. No call. Linked at file offset 0x5B000.
 */
	.text
	.global	_start
_start:
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
1:
	st.h	r1, (r3, 0)
	addi	r3, 2
	subi	r2, 1
	cmpnei	r2, 0
	bt	1b

	movi	r1, 255
	movi	r2, 256
2:
	st.h	r1, (r3, 0)
	addi	r3, 2
	subi	r2, 1
	cmpnei	r2, 0
	bt	2b

	lrw	r3, 0x11000560
	movi	r2, 1
	st.w	r2, (r3, 0)
	jmp	r15

	.align	2
	.literals
