/* c7000-fm-proof (UVm8): the c7000-fm-flat stub, plus one more AT1846S write.
 * Called instead of the last write of the FM branch of at1846_tune (+0x3074,
 * r0 = 0x3A, r1 = 0x40C3). It performs that write, sets the HR-C7000 FM
 * registers the same way c7000_fm_flat.S does, then writes register 0x58 =
 * 0x84C5. The five factory 0x8405 immediates are left alone, so a missing
 * pre-emphasis boost on the air means this stub ran on the keyed path.
 * The two bsr encodings are raw halfwords. gas emits R_CKCORE_PCREL_IMM26BY2
 * for `bsr 0xFD011220` and ld drops the instruction, so the displacement is
 * filled in here for a link address of 0x5B000 (the same address the redirect
 * uses). at1846_write is flat 0xFD011220, IRAM 0x2B220.
 * Linked at flat file offset 0x5B000 (zero tail, XIP 0x03075000).
 */
	.text
	.global	_start
_start:
	push	r15
	.short	0xE27D, 0xB10F		/* bsr 0xFD011220 from 0x5B002 */
	lrw	r3, 0x11000500
	movi	r2, 0x0F
	st.w	r2, (r3, 0)
	lrw	r3, 0x11000504
	lrw	r2, 0x000F1010
	st.w	r2, (r3, 0)
	movi	r0, 88			/* register 0x58 */
	movi	r1, 33989		/* 0x84C5: voice HPF and emphasis bypass */
	.short	0xE27D, 0xB104		/* bsr 0xFD011220 from 0x5B018 */
	pop	r15
