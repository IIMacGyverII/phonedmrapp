# F30C: F30B without opcode 18. The tail holds two stubs.
# Idle 0x30 is 0x7026 on the wide M17 channel and 0x4026 on DMR, so the
# unmute writes back the value it read with bit 7 cleared.
# The key wrapper sets a flag at 0x4B384. The FM task branch at 0x18B68
# calls the check: when the flag is set and TX bits 0 and 2 of 0x38908
# are clear, it clears bit 7 and then the flag. Opcode 18 is refused.
import hashlib
from pathlib import Path

import fw30_build
import literal_guard

ROOT = Path(r"D:\Documents\code\personal\phonedmrapp")
SRC = ROOT / "radio_firmware" / "build" / "DMR003.F30B.V022.bin"
DEST = ROOT / "radio_firmware" / "build" / "DMR003.F30C.V022.bin"
TAG = slice(0x38464, 0x38474)
CHECK = 0x5BFB4
SET = 0x5BFEC
LIMIT = 0x5BFFE
FLAG = 0x4B384

_CHECK = """
	.text
	.global	check
check:
	push	r4, r15
	.short	0xE000, 0x4D0B
	lrw	r4, 0x4b384
	ld.b	r2, (r4, 0)
	bez	r2, .Ldone
	lrw	r3, 0x38908
	ld.b	r2, (r3, 0)
	andi	r2, r2, 5
	bnez	r2, .Ldone
	movi	r0, 48
	.short	0xE000, 0x125C
	bclri	r0, 7
	mov	r1, r0
	movi	r0, 48
	.short	0xE000, 0x1220
	movi	r2, 0
	st.b	r2, (r4, 0)
.Ldone:
	pop	r4, r15
"""

_SET = """
	.text
	.global	setflag
setflag:
	movi	r2, 1
	st.w	r2, (r3, 0)
	lrw	r4, 0x4b384
	movi	r2, 1
	st.b	r2, (r4, 0)
	jmp	r15
"""


def build():
    img = bytearray(SRC.read_bytes())
    if img[TAG] != b"DMR003.F30B.V022":
        raise SystemExit("tag")
    if fw30_build.bsr_target(img, 0x18B68) != 0x5B4D0:
        raise SystemExit("refill")
    if img[0x5B5E2:0x5B5E6] != bytes.fromhex("013240b3"):
        raise SystemExit("key store")
    if fw30_build.bsr_target(img, 0x5BCC4) != 0x5BFB4:
        raise SystemExit("op18")
    base = SRC.read_bytes()
    read_to = fw30_build.bsr_target(base, 0x3898)
    write_to = fw30_build.bsr_target(base, 0x5B654)
    check = bytearray(fw30_build._linked(_CHECK, CHECK, "f30cck"))
    fw30_build._patch_one(check, CHECK, bytes.fromhex("00e00b4d"), 0x5B4D0, "refill")
    fw30_build._patch_one(check, CHECK, bytes.fromhex("00e05c12"), read_to, "read")
    fw30_build._patch_one(check, CHECK, bytes.fromhex("00e02012"), write_to, "write")
    flag = bytearray(fw30_build._linked(_SET, SET, "f30cset"))
    if CHECK + len(check) != SET:
        raise SystemExit("layout %X %d" % (CHECK + len(check), len(check)))
    if SET + len(flag) > LIMIT:
        raise SystemExit("end %X" % (SET + len(flag)))
    img[CHECK:CHECK + len(check)] = check
    img[SET:SET + len(flag)] = flag
    img[0x18B68:0x18B6C] = fw30_build.encode_bsr(0x18B68, CHECK)
    img[0x5B5E2:0x5B5E6] = fw30_build.encode_bsr(0x5B5E2, SET)
    img[0x5BCC4:0x5BCC8] = fw30_build.encode_bsr(0x5BCC4, 0x5BD74)
    if fw30_build.bsr_target(img, 0x18B68) != CHECK:
        raise SystemExit("check call")
    if fw30_build.bsr_target(img, 0x5B5E2) != SET:
        raise SystemExit("set call")
    if fw30_build.bsr_target(img, 0x5BCC4) != 0x5BD74:
        raise SystemExit("refuse")
    old = SRC.read_bytes()
    if literal_guard.covered_loads(old, bytes(img))[1]:
        raise SystemExit("load guard")
    if literal_guard.covered_branches(old, bytes(img))[1]:
        raise SystemExit("branch guard")
    img[TAG] = b"DMR003.F30C.V022"
    DEST.write_bytes(img)
    print(DEST)
    print(hashlib.sha256(img).hexdigest())
    print("check", len(check), "set", len(flag), "end", hex(SET + len(flag)))


if __name__ == "__main__":
    build()
