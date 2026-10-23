/* c7000-fm-flat: called instead of the last AT1846S write of the FM branch of
 * at1846_tune (+0x3074, reg 0x3A = 0x40C3). Performs that write, then sets the
 * HR-C7000 FM audio registers (user guide 11.2.2.2/11.2.2.3):
 *   FM_BANDWIDTH 0x11000500 = 0x0F  (fmbpfon=0, fmpreemphasison=0, bandwidth bits as reset)
 *   FM_DEV_COEF  0x11000504 = FM_DEV_COEF_VALUE (reset 0x000F1010: tr_sig_lim 0x0F, dev coefs 0x10)
 * Linked at the flat file offset 0x5B000 (zero tail, XIP flash 0x03075000).
 * The AT1846S write is at flat 0xFD011220 (IRAM 0x2B220), as seen by flash code.
 */
	.text
	.global	_start
_start:
	push	r15
	bsr	at1846_write
	lrw	r3, 0x11000500
	movi	r2, 0x0F
	st.w	r2, (r3, 0)
	lrw	r3, 0x11000504
	lrw	r2, FM_DEV_COEF_VALUE
	st.w	r2, (r3, 0)
	pop	r15
	.align	2
	.literals
