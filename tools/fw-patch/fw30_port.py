# FW30 = accepted FW29 plus the six F30F fixes.
# Ops 16 and 17 (the closed receive-RAM stream) answer sr=1. Their
# exclusive body at 0x5BD74 holds the new stub. The pool at 0x5BE34 stays:
# code outside this body loads it. The file does not grow.
import hashlib
import struct
import subprocess
from pathlib import Path

import fw23_build
import fw30_build

ROOT = Path(__file__).resolve().parents[2]
BUILD = ROOT / "radio_firmware" / "build"
FW29 = BUILD / "DMR003.FW29.V022.bin"
FACTORY = ROOT / "radio_firmware" / "DMR003.UV4T.V022-ORIGINAL.bin"
DEST = BUILD / "DMR003.FW30.V022.bin"
TAG = range(0x38464, 0x38474)
STUB_AT = 0x5BD74
STUB_END = 0x5BE34
DROP_CALL = 0x5B748
DROP_TAIL = 0x5B65A
OP7_AT = 0x5AF4C
GUARD_AT = 0x37F8
XIP = 0x0301A000

# Moved block. The F30F layout, then the later engine words that FW29 added
# past 0x4B00C. 0x4C7E0 stays: the factory image names it too.
RING = 0x4F2C0
FLAG = 0x4F2E0
BLOCK = 0x4F2E4
ARM = 0x4F2F0
BUF = 0x4F2F4
BUF2 = 0x4F4F4
EXT = 0x4F6F4
WORD_B260 = 0x4F768
TAIL = 0x4F76C
ENDF = 0x4DAAC
MAGIC = 0xA5
RAM_END = 0x4F794


def new_of(w):
    if 0x4A3E4 <= w <= 0x4A400:
        return RING + (w - 0x4A3E4)
    if w == 0x4DAAC:
        return FLAG
    if 0x4B000 <= w <= 0x4B00C:
        return BLOCK + (w - 0x4B000)
    if 0x4AC00 <= w < 0x4AE00:
        return BUF + (w - 0x4AC00)
    if 0x4AE00 <= w < 0x4B000:
        return BUF2 + (w - 0x4AE00)
    if 0x4B010 <= w <= 0x4B080:
        return EXT + (w - 0x4B010)
    if w == 0x4B260:
        return WORD_B260
    if 0x4B360 <= w <= 0x4B384:
        return TAIL + (w - 0x4B360)
    return None


def relocate(img):
    moved = []
    for off in range(0x5AEFC, 0x5C6FC, 4):
        w = struct.unpack_from("<I", img, off)[0]
        n = new_of(w)
        if n is None:
            continue
        struct.pack_into("<I", img, off, n)
        moved.append((off, w, n))
    return moved


def stub_asm():
    return """
	.text
	.global	refuse
	.global	op7
	.global	setend
	.global	guard
refuse:
	push	r15
	ld.b	r0, (r7, 1)
	movi	r1, 1
	lrw	r4, 0x8E7C
	jsr	r4
	pop	r15
op7:
	lrw	r4, 0x34808
	ld.b	r4, (r4, 0)
	bez	r4, reject
	lrw	r4, 0x%x
	movi	r1, 1
	st.w	r1, (r4, 0)
	lrw	r4, 0x%x
	jmp	r4
reject:
	lrw	r4, 0x%x
	jmp	r4
setend:
	push	r4, r15
	lrw	r3, 0x%x
	movi	r2, 1
	st.b	r2, (r3, 0)
	movi	r2, %d
	st.b	r2, (r3, 1)
	lrw	r4, 0x%x
	jsr	r4
	pop	r4, r15
guard:
	lrw	r3, 0x%x
	ld.b	r2, (r3, 0)
	cmpnei	r2, 1
	bt	cont
	ld.b	r2, (r3, 1)
	cmpnei	r2, %d
	bt	cont
	cmpnei	r0, 1
	bt	cont
	movi	r2, 0
	st.b	r2, (r3, 0)
	st.b	r2, (r3, 1)
	movi	r0, 0
cont:
	zextb	r4, r0
	mov	r0, r14
	lrw	r3, 0x%x
	jmp	r3
""" % (ARM, XIP + 0x5AF52, XIP + 0x5AFC8, ENDF, MAGIC, XIP + DROP_TAIL,
       ENDF, MAGIC, XIP + 0x37FC)


def build():
    fac = FACTORY.read_bytes()
    img = bytearray(FW29.read_bytes())
    if img[TAG.start:TAG.stop] != b"DMR003.FW29.V022":
        raise SystemExit("FW29 tag")
    if img[0x5BD74:STUB_END] == fac[0x5BD74:STUB_END]:
        raise SystemExit("op 17 body is factory")
    if fw30_build.bsr_target(img, DROP_CALL) != DROP_TAIL:
        raise SystemExit("drop call at %X is not %X" % (DROP_CALL, DROP_TAIL))
    if img[0x37F4:0x37F8] != fac[0x37F4:0x37F8]:
        raise SystemExit("close prologue differs from factory")
    moved = relocate(img)
    code = fw30_build._linked(stub_asm(), STUB_AT, "fw30port")
    if STUB_AT + len(code) > STUB_END:
        raise SystemExit("stub %d bytes, room %d" % (len(code), STUB_END - STUB_AT))
    img[STUB_AT:STUB_AT + len(code)] = code
    if STUB_AT + len(code) < STUB_END:
        img[STUB_AT + len(code):STUB_END] = b"\x00" * (STUB_END - STUB_AT - len(code))
    nm = subprocess.check_output([
        r"C:\Users\Joshua\tools\csky-elfabiv2\bin\csky-elfabiv2-nm.exe",
        r"C:\Users\Joshua\AppData\Local\Temp\fw1718\fw30\fw30port.elf",
    ], text=True)
    syms = {}
    for line in nm.splitlines():
        parts = line.split()
        if len(parts) == 3:
            syms[parts[2]] = int(parts[0], 16)
    for name in ("refuse", "op7", "setend", "guard"):
        if name not in syms:
            raise SystemExit("missing " + name)
    img[0x5BCC4:0x5BCC8] = fw30_build.encode_bsr(0x5BCC4, syms["refuse"])
    img[0x5BCCA:0x5BCCE] = fw30_build.encode_bsr(0x5BCCA, syms["refuse"])
    img[OP7_AT:OP7_AT + 4] = fw30_build.encode_bsr(OP7_AT, syms["op7"])
    img[OP7_AT + 4:OP7_AT + 6] = b"\x00\x00"
    img[DROP_CALL:DROP_CALL + 4] = fw30_build.encode_bsr(DROP_CALL, syms["setend"])
    img[GUARD_AT:GUARD_AT + 4] = fw30_build.encode_bsr(GUARD_AT, syms["guard"])
    img[0x18B5C:0x18B60] = fac[0x18B5C:0x18B60]
    img[TAG.start:TAG.stop] = b"DMR003.FW30.V022"
    if img[0x35F64:0x35FE4] != fac[0x35F64:0x35FE4]:
        raise SystemExit("data table written")
    if fw30_build.bsr_target(img, 0x18B68) != 0x5B4D0:
        raise SystemExit("refill hook")
    if img[0x37F4:0x37F8] != fac[0x37F4:0x37F8]:
        raise SystemExit("prologue")
    # The one-shot flag's literals stay at 0x4DAAC. The symbol flag moved.
    blob = bytes(img)
    if struct.pack("<I", ENDF) not in blob[STUB_AT:STUB_END]:
        raise SystemExit("close flag missing from the stub")
    if struct.pack("<I", FLAG) not in blob[0x5B55C:0x5B560]:
        raise SystemExit("refill flag was not moved")
    DEST.write_bytes(blob)
    print("moved", len(moved), "stub", len(code), "end", hex(STUB_AT + len(code)))
    for name in ("refuse", "op7", "setend", "guard"):
        print(name, hex(syms[name]))
    print("sha", hashlib.sha256(blob).hexdigest())
    return blob, syms, moved


if __name__ == "__main__":
    build()
