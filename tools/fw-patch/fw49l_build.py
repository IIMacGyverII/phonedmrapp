# F49L: FW49's r1 = 0 unkey fix, plus the FW48-L entry log.
# The log occupies 0x5B65A for 44 bytes. The 8-byte unkey helper follows
# it. The 0xE64 return wrapper is the 32-byte hole at 0x5B700.
import hashlib
import struct
import subprocess
from pathlib import Path

import fw30_build
import literal_guard

ROOT = Path(__file__).resolve().parents[2]
SRC = ROOT / "radio_firmware" / "build" / "DMR003.FW46.V022.bin"
DEST = ROOT / "radio_firmware" / "build" / "DMR003.F49L.V022.bin"
TAG = slice(0x38464, 0x38474)
LOG = 0x5B65A
HELP = 0x5B686
REGION_END = 0x5B690
WRAP = 0x5B700
WRAP_END = 0x5B720
LIVE = 0x5B720
HOOK = 0xE9E
E64_SITE = 0xEBA
UNKEY = 0x5B61E
E9C = 0xE9C
E64 = 0xE64
LO = 0x5C0CE
HI = 0x5C0D6
OBJDUMP = Path(r"C:\Users\Joshua\tools\csky-elfabiv2\bin\csky-elfabiv2-objdump.exe")

LOG_ASM = """
	.text
	.global	log_e9c
log_e9c:
	ld.w	r2, (r14, 12)
	movih	r3, 4
	ori	r3, r3, 0xd900
	ld.w	r4, (r3, 0)
	addi	r4, 1
	st.w	r4, (r3, 0)
	subi	r4, 1
	andi	r4, r4, 7
	lsli	r4, r4, 4
	addu	r4, r3
	addi	r4, 4
	st.w	r2, (r4, 0)
	st.w	r1, (r4, 4)
	st.w	r0, (r4, 8)
	ld.w	r2, (r3, 0)
	st.w	r2, (r4, 12)
	subi	r14, 4
	movi	r3, 0
	jmp	r15
"""

HELP_ASM = """
	.text
	.global	unkey_r1
unkey_r1:
	movi	r1, 0
	.long	0xbbccddee
	jmp	r15
"""

WRAP_ASM = """
	.text
	.global	log_e64
log_e64:
	push	r4, r15
	.long	0xbbccddee
	lrw	r3, 0x4d900
	ld.w	r4, (r3, 0)
	subi	r4, 1
	andi	r4, r4, 7
	addu	r4, r3
	movi	r2, 128
	or	r2, r0
	addi	r4, 132
	st.b	r2, (r4, 0)
	pop	r4, r15
"""


def _patch(blob, asm, base, limit, token, dest):
    code = bytearray(fw30_build._linked(asm, base, "f49l_%X" % base))
    slot = code.find(struct.pack("<I", token)) if token else -1
    if token and slot < 0:
        raise SystemExit("token")
    if len(code) > limit - base:
        raise SystemExit("size %X %d" % (base, len(code)))
    if token:
        code[slot:slot + 4] = fw30_build.encode_bsr(base + slot, dest)
    blob[base:base + len(code)] = code
    return len(code)


def build():
    img = bytearray(SRC.read_bytes())
    old = bytes(img)
    if img[TAG] != b"DMR003.FW46.V022":
        raise SystemExit("tag")
    if img[LIVE:LIVE + 2] != bytes.fromhex("d414"):
        raise SystemExit("live")
    if img[HOOK:HOOK + 4] != bytes.fromhex("21140033"):
        raise SystemExit("hook")
    if fw30_build.bsr_target(img, E64_SITE) != E64:
        raise SystemExit("e64")
    if fw30_build.bsr_target(img, UNKEY) != E9C:
        raise SystemExit("unkey")
    if img[LO:LO + 4] != bytes.fromhex("21ea0018") or img[HI:HI + 4] != bytes.fromhex("21ea0118"):
        raise SystemExit("window")
    for pc, pool in literal_guard.literal_loads(old):
        if LOG <= pool < REGION_END and not (LOG <= pc < REGION_END):
            raise SystemExit("pool")
        if WRAP <= pool < WRAP_END and not (WRAP <= pc < WRAP_END):
            raise SystemExit("wrap pool")
    nlog = _patch(img, LOG_ASM, LOG, HELP, None, None)
    if nlog != HELP - LOG:
        raise SystemExit("log %d" % nlog)
    _patch(img, HELP_ASM, HELP, REGION_END, 0xBBCCDDEE, E9C)
    _patch(img, WRAP_ASM, WRAP, WRAP_END, 0xBBCCDDEE, E64)
    img[HOOK:HOOK + 4] = fw30_build.encode_bsr(HOOK, LOG)
    img[E64_SITE:E64_SITE + 4] = fw30_build.encode_bsr(E64_SITE, WRAP)
    img[UNKEY:UNKEY + 4] = fw30_build.encode_bsr(UNKEY, HELP)
    img[LO:LO + 4] = bytes.fromhex("21ea0300")
    img[HI:HI + 4] = bytes.fromhex("21ea0500")
    if img[LIVE:LIVE + 2] != bytes.fromhex("d414"):
        raise SystemExit("live moved")
    if literal_guard.covered_loads(old, bytes(img))[1]:
        raise SystemExit("load guard")
    if literal_guard.covered_branches(old, bytes(img))[1]:
        raise SystemExit("branch guard")
    if literal_guard.never_written(old, bytes(img)):
        raise SystemExit("never-write")
    img[TAG] = b"DMR003.F49L.V022"
    DEST.write_bytes(img)
    print(DEST.name)
    print(hashlib.sha256(bytes(img)).hexdigest())
    if fw30_build.bsr_target(img, UNKEY) != HELP:
        raise SystemExit("unkey link")
    if fw30_build.bsr_target(img, HOOK) != LOG:
        raise SystemExit("log link")


if __name__ == "__main__":
    build()
