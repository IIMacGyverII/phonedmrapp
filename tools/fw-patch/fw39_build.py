# FW39: FW38, plus an immediate clear of the flags the FM key path tests.
#
# 0x5BBE2 sends an analog 0x26 down the symbol engine when the ring cursor
# is still below its count, or when the mode word is the tone magic and
# 0x4B030 / 0x4B02C are not zero. tx_launch (0xE9C) posts status 7 and
# returns without keying when 0xE64 says busy: channel byte 0x38B5C+0xAE
# is 3 and 0x38908 has bit 1 set with bit 0 clear, or bit 3 set with bit 2
# clear. The symbol end does clear 0x38908 bits 0 and 2, the ring and the
# mode word, but only after a countdown at 0x4B010 (armed to 8, decremented
# once per TX-RAM interrupt from 0x5B4D0). A 0x26 off returns before that.
#
# The clear runs from both unkey tails (0x5B622 and 0x5B658) through a
# 4-byte trampoline in the uncalled slot at 0x5B700.
# The post-unkey hook's restore pop at 0x5BD14 branches the same way, so
# the delayed countdown still clears them too. Neither tail pushes.
import hashlib
import struct
import subprocess
from pathlib import Path

import fw30_build
import literal_guard

ROOT = Path(__file__).resolve().parents[2]
SRC = ROOT / "radio_firmware" / "build" / "DMR003.FW38.V022.bin"
DEST = ROOT / "radio_firmware" / "build" / "DMR003.FW39.V022.bin"
TAG = slice(0x38464, 0x38474)
# 0x5B622 is the unkey taken when 0x4DAAC is already clear. The TX-RAM
# countdown often clears that word before the host's 0x26 off, so the
# full-path pop at 0x5B658 never runs.
SHORT_POP = 0x5B622
UNKEY_POP = 0x5B658
TRAMP = 0x5B700
RESTORE_POP = 0x5BD14
FINISH = 0x5BD30
RECLAIM_END = 0x5BD74
PRELUDE = 0x5B704
PRELUDE_END = 0x5B720
KEY_BSR = 0x92B6
XIP = 0x0301A000
IRAM_PRELUDE = 0x2AF24
PRE_ASM = """
	.text
	.global	arm
arm:
	push	r15
	lrw	r3, 0x38874
	movi	r2, 1
	st.b	r2, (r3, 6)
	bsr	.Lret
.Lret:
	pop	r15
"""
OBJDUMP = Path(r"C:\Users\Joshua\tools\csky-elfabiv2\bin\csky-elfabiv2-objdump.exe")

ASM = """
	.text
	.global	finish
finish:
	lrw	r3, 0x4a3e4
	ld.w	r0, (r3, 0)
	st.w	r0, (r3, 4)
	lrw	r3, 0x4b00c
	movi	r0, 0
	st.w	r0, (r3, 0)
	st.w	r0, (r3, 8)
	st.w	r0, (r3, 32)
	st.h	r0, (r3, 36)
	lrw	r3, 0x38908
	ld.b	r2, (r3, 0)
	bclri	r2, 0
	bclri	r2, 1
	bclri	r2, 2
	bclri	r2, 3
	st.b	r2, (r3, 0)
	lrw	r3, 0x38874
	movi	r2, 1
	st.b	r2, (r3, 6)
	pop	r4-r7, r15
"""


def encode_iram_bsr(file_at, runtime_target):
    delta = runtime_target - (XIP + file_at)
    if delta & 1:
        raise SystemExit("iram bsr")
    half = delta >> 1
    word = (0b111000 << 26) | (half & 0x3FFFFFF)
    return struct.pack("<HH", (word >> 16) & 0xFFFF, word & 0xFFFF)


def br16(at, target):
    delta = target - at
    if delta <= 0 or delta > 1022 or delta & 1:
        raise SystemExit("br16 %X -> %X" % (at, target))
    half = delta >> 1
    if half > 0x1FF:
        raise SystemExit("br16 range")
    return struct.pack("<H", 0x0400 | half)


def build():
    img = bytearray(SRC.read_bytes())
    old = bytes(img)
    if img[TAG] != b"DMR003.FW38.V022":
        raise SystemExit("tag")
    if img[SHORT_POP:SHORT_POP + 2] != bytes.fromhex("9414"):
        raise SystemExit("short pop")
    if img[UNKEY_POP:UNKEY_POP + 2] != bytes.fromhex("9414"):
        raise SystemExit("unkey pop")
    if img[RESTORE_POP:RESTORE_POP + 2] != bytes.fromhex("9414"):
        raise SystemExit("restore pop")
    if img[FINISH:RECLAIM_END] != b"\x00" * (RECLAIM_END - FINISH):
        raise SystemExit("hole")
    code = fw30_build._linked(ASM, FINISH, "fw39")
    if FINISH + len(code) > RECLAIM_END:
        raise SystemExit("finish %d ends %X" % (len(code), FINISH + len(code)))
    if bytes.fromhex("9414") not in code:
        raise SystemExit("finish pop")
    img[FINISH:FINISH + len(code)] = code
    img[TRAMP:TRAMP + 4] = fw30_build.encode_br(TRAMP, FINISH)
    img[SHORT_POP:SHORT_POP + 2] = br16(SHORT_POP, TRAMP)
    img[UNKEY_POP:UNKEY_POP + 2] = br16(UNKEY_POP, TRAMP)
    img[RESTORE_POP:RESTORE_POP + 2] = br16(RESTORE_POP, FINISH)
    # The key prelude's lock wait is what holds the 0x26 handler (no ack).
    # Force the "already done" byte before the call. r0 and r1 stay 1, 1.
    if img[KEY_BSR:KEY_BSR + 4] != encode_iram_bsr(KEY_BSR, IRAM_PRELUDE):
        raise SystemExit("prelude bsr %s" % img[KEY_BSR:KEY_BSR + 4].hex())
    pre = bytearray(fw30_build._linked(PRE_ASM, PRELUDE, "fw39pre"))
    if PRELUDE + len(pre) > PRELUDE_END:
        raise SystemExit("prelude %d" % len(pre))
    # The placeholder bsr targets .Lgo, the jmp r15 immediately after it.
    placeholder = None
    for i in range(0, len(pre) - 4, 2):
        if pre[i:i + 4] == fw30_build.encode_bsr(PRELUDE + i, PRELUDE + i + 4):
            placeholder = i
            break
    if placeholder is None:
        raise SystemExit("placeholder")
    pre[placeholder:placeholder + 4] = encode_iram_bsr(PRELUDE + placeholder, IRAM_PRELUDE)
    img[PRELUDE:PRELUDE + len(pre)] = pre
    img[KEY_BSR:KEY_BSR + 4] = fw30_build.encode_bsr(KEY_BSR, PRELUDE)
    # The trampoline overwrites the first instruction of the uncalled
    # FW37 save. Nothing branches to it (fw38 moved both callers).
    changed = [i for i, (a, c) in enumerate(zip(old, img)) if a != c]
    allowed = set()
    for start, end in (
        (SHORT_POP, SHORT_POP + 2),
        (UNKEY_POP, UNKEY_POP + 2),
        (TRAMP, TRAMP + 4),
        (RESTORE_POP, RESTORE_POP + 2),
        (FINISH, FINISH + len(code)),
        (PRELUDE, PRELUDE + len(pre)),
        (KEY_BSR, KEY_BSR + 4),
    ):
        allowed.update(range(start, end))
    stray = [hex(i) for i in changed if i not in allowed]
    if stray:
        raise SystemExit("stray %s" % stray[:8])
    if literal_guard.covered_loads(old, bytes(img))[1]:
        raise SystemExit("load guard %s" % literal_guard.covered_loads(old, bytes(img))[1][:6])
    if literal_guard.covered_branches(old, bytes(img))[1]:
        raise SystemExit("branch guard %s" % literal_guard.covered_branches(old, bytes(img))[1][:6])
    if literal_guard.never_written(old, bytes(img)):
        raise SystemExit("never-write")
    img[TAG] = b"DMR003.FW39.V022"
    DEST.write_bytes(img)
    print(DEST.name)
    print(hashlib.sha256(bytes(img)).hexdigest())
    print("finish", len(code), "at", hex(FINISH))
    dump = subprocess.check_output(
        [str(OBJDUMP), "-b", "binary", "-m", "csky", "-D",
         "--start-address=0x%X" % FINISH, "--stop-address=0x%X" % (FINISH + len(code)),
         str(DEST)],
        text=True, errors="replace")
    print(dump)


if __name__ == "__main__":
    build()
