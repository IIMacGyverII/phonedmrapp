# F30C: F30B without opcode 18. The tail holds two stubs.
# Idle 0x30 is 0x7026 on the wide M17 channel and 0x4026 on DMR, so the
# unmute writes back the value it read with bit 7 cleared.
# The key wrapper sets a flag at 0x4B384. The FM task branch at 0x18B68
# calls the check. The flag byte is set to 200 at key start and is not
# counted down: 200 task passes finish before the close's 0.3 s mute, so
# a countdown missed it. While the flag is set and the TX bits are clear,
# every pass clears bit 7. Opcode 18 is refused.
import hashlib
import subprocess
from pathlib import Path

import fw30_build
import literal_guard

ROOT = Path(r"D:\Documents\code\personal\phonedmrapp")
SRC = ROOT / "radio_firmware" / "build" / "DMR003.F30B.V022.bin"
DEST = ROOT / "radio_firmware" / "build" / "DMR003.F30C.V022.bin"
TAG = slice(0x38464, 0x38474)
CHECK = 0x5BFB4
LIMIT = 0x5BFFE
FLAG = 0x4B384

_BOTH = """
	.text
	.global	setflag
	.global	check
setflag:
	movi	r2, 1
	st.w	r2, (r3, 0)
	lrw	r4, 0x4b384
	movi	r2, 200
	st.b	r2, (r4, 0)
	jmp	r15
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
	movi	r0, 100
	.short	0xE000, 0x1BE8
	movi	r0, 48
	.short	0xE000, 0x125C
	bclri	r0, 7
	mov	r1, r0
	movi	r0, 48
	.short	0xE000, 0x1220
.Ldone:
	pop	r4, r15
"""


def _both(base):
    out = Path(r"C:\Users\Joshua\AppData\Local\Temp\fw1718\fw30")
    out.mkdir(parents=True, exist_ok=True)
    src = out / "f30cboth.S"
    src.write_text(_BOTH, encoding="utf-8")
    subprocess.check_call([str(fw30_build.AS), "-mcpu=ck803", "-mno-laf", "-o",
                           str(out / "f30cboth.o"), str(src)])
    subprocess.check_call([str(fw30_build.LD), "-Ttext=0x%X" % base, "-o",
                           str(out / "f30cboth.elf"), str(out / "f30cboth.o")])
    code, addr = fw30_build.fw23_build.text_of((out / "f30cboth.elf").read_bytes())
    if addr != base:
        raise SystemExit("linked at %X" % addr)
    return bytearray(code)


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
    stub = _both(CHECK)
    fw30_build._patch_one(stub, CHECK, bytes.fromhex("00e00b4d"), 0x5B4D0, "refill")
    fw30_build._patch_one(stub, CHECK, bytes.fromhex("00e05c12"), read_to, "read")
    fw30_build._patch_one(stub, CHECK, bytes.fromhex("00e02012"), write_to, "write")
    fw30_build._patch_one(stub, CHECK, bytes.fromhex("00e0e81b"), 0x1BE8, "delay")
    check_at = CHECK + 12
    if CHECK + len(stub) > LIMIT:
        raise SystemExit("end %X" % (CHECK + len(stub)))
    img[CHECK:CHECK + len(stub)] = stub
    img[0x18B68:0x18B6C] = fw30_build.encode_bsr(0x18B68, check_at)
    img[0x5B5E2:0x5B5E6] = fw30_build.encode_bsr(0x5B5E2, CHECK)
    img[0x5BCC4:0x5BCC8] = fw30_build.encode_bsr(0x5BCC4, 0x5BD74)
    if fw30_build.bsr_target(img, 0x18B68) != check_at:
        raise SystemExit("check call")
    if fw30_build.bsr_target(img, 0x5B5E2) != CHECK:
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
    print("stub", len(stub), "check", hex(check_at), "end", hex(CHECK + len(stub)))


if __name__ == "__main__":
    build()
