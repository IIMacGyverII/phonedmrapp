/* c7000-fm-adcgain (UVm10): the UVm8 stub without the 0x58 write, plus a
 * lower GCR_ADCL. Called instead of the last AT1846S write of the FM branch
 * of at1846_tune (+0x3074, r0 = 0x3A, r1 = 0x40C3). It performs that write,
 * sets the HR-C7000 FM registers the same way c7000_fm_flat.S does, then
 * stores GCR_ADCL (0x16000900 + 0xE5) = 0x83.
 *
 * 0x83 is lrgid 1, gidl 3 = 3 dB. The codec init writes 0x8B (11 dB). The
 * analog 0x23 path calls 0x61F4(0) after this stub, and that function stores
 * 0x89 (9 dB) when RAM 0x38b5c+3 is 1, which the same path sets. The three
 * subi immediates in 0x61F4 are lowered by 6 counts in the same patch, so
 * the value left in the register is 0x83, 6 dB under the 9 dB the factory
 * image leaves on this path. A store of 0x85 here (6 dB under the init
 * value) would be overwritten, and would only be 4 dB under 0x89.
 *
 * The factory 0x8405 immediates are not in this stub. The bsr is raw
 * halfwords: gas emits R_CKCORE_PCREL_IMM26BY2 for `bsr 0xFD011220` and ld
 * drops it. Displacement is for a link address of 0x5B000. at1846_write is
 * flat 0xFD011220 (IRAM 0x2B220).
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
	lrw	r3, 0x16000900
	movi	r2, 0
	subi	r2, 125			/* 0 - 125 = 0x83 */
	st.b	r2, (r3, 0xe5)
	pop	r15
