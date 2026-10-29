# FW36: FW30 with the FW19 time-out clamp removed and one bit-7 clear
# in the bytes that clamp used. 0xAB18 goes back to the factory bsr
# 0xA308, so a 0x3B byte of 0 is stored unchanged (no module timer).
# The clear sits in 0x5B700..0x5B71F. A 16-bit br only reaches forward,
# so the hook is the 4-byte br at 0x5B770, over the last time-out store
# and the fall-through pop. The stub does that store, waits, then reads
# AT1846S 0x30 and writes it back with bit 7 clear. Bits 0 and 2 of
# 0x38908 were cleared at 0x5B760, immediately above this hook; the
# early pop at 0x5B77A does not come here. The gate at 0x5B720, opcode
# 16/17 at 0x5BD74 and the data-table tail at 0x35F64 are not written.
import hashlib
import struct
from pathlib import Path

import fw30_build
import literal_guard

ROOT = Path(__file__).resolve().parents[2]
SRC = ROOT / "radio_firmware" / "build" / "DMR003.FW30.V022.bin"
FACTORY = ROOT / "radio_firmware" / "DMR003.UV4T.V022-ORIGINAL.bin"
DEST = ROOT / "radio_firmware" / "build" / "DMR003.FW36.V022.bin"
TAG = slice(0x38464, 0x38474)
SLOT = 0x5B700
SLOT_END = 0x5B720
HOOK = 0x5B770
CLAMP_CALL = 0xAB18
STOCK_TOT = 0xA308
GATE = 0x5B720
EARLY_POP = 0x5B77A
OP16 = 0x5BD74

# r4 is 0x38C64 and r2 is 0: the three stores above the hook left them
# so, and this store is the one the 4-byte br replaced.
ASM = """
	.text
	.global	clear
clear:
	st.b	r2, (r4, 5)
	movi	r0, 100
	.short	0xE000, 0x1111
	movi	r0, 48
	.short	0xE000, 0x2222
	bclri	r0, 7
	mov	r1, r0
	movi	r0, 48
	.short	0xE000, 0x3333
	pop	r4-r7, r15
"""


def callers(image, start, end):
    hits = []
    for pc, length, target in literal_guard.branch_targets(image):
        if start <= target < end and not (start <= pc < end):
            hits.append((pc, length, target))
    words = []
    for at in range(0, len(image) - 3, 4):
        word = struct.unpack_from("<I", image, at)[0]
        if start <= word < end:
            words.append(at)
    return hits, words


def build():
    img = bytearray(SRC.read_bytes())
    old = bytes(img)
    factory = FACTORY.read_bytes()
    if img[TAG] != b"DMR003.FW30.V022":
        raise SystemExit("tag")
    if factory[CLAMP_CALL:CLAMP_CALL + 4] != bytes.fromhex("ffe3f8fb"):
        raise SystemExit("factory 0x3B")
    if fw30_build.bsr_target(factory, CLAMP_CALL) != STOCK_TOT:
        raise SystemExit("factory target")
    if img[HOOK:HOOK + 4] != bytes.fromhex("45a49414"):
        raise SystemExit("tail")
    if img[0x5B75C:HOOK] != bytes.fromhex("8c10408442e4fa2040a48b10003242a443a444a4"):
        raise SystemExit("bit clear moved")
    if img[EARLY_POP:EARLY_POP + 2] != bytes.fromhex("9414"):
        raise SystemExit("early pop")
    if img[SLOT_END:SLOT_END + 2] != bytes.fromhex("d414"):
        raise SystemExit("gate moved")
    before, pools = callers(old, SLOT, SLOT_END)
    if before != [(CLAMP_CALL, 4, SLOT)] or pools:
        raise SystemExit("callers %s pools %s" % (before[:6], [hex(p) for p in pools[:6]]))
    stub = bytearray(fw30_build._linked(ASM, SLOT, "fw36"))
    fw30_build._patch_one(stub, SLOT, bytes.fromhex("00e01111"), 0x1BE8, "delay")
    fw30_build._patch_one(stub, SLOT, bytes.fromhex("00e02222"), 0x54664, "read")
    fw30_build._patch_one(stub, SLOT, bytes.fromhex("00e03333"), 0x54628, "write")
    if len(stub) > SLOT_END - SLOT:
        raise SystemExit("stub %d bytes" % len(stub))
    if stub[-2:] != bytes.fromhex("9414"):
        raise SystemExit("stub pop %s" % stub[-8:].hex())
    img[SLOT:SLOT + len(stub)] = stub
    img[HOOK:HOOK + 4] = fw30_build.encode_br(HOOK, SLOT)
    img[CLAMP_CALL:CLAMP_CALL + 4] = factory[CLAMP_CALL:CLAMP_CALL + 4]
    if fw30_build.bsr_target(img, CLAMP_CALL) != STOCK_TOT:
        raise SystemExit("restored target")
    if img[GATE:HOOK] != old[GATE:HOOK] or img[EARLY_POP:OP16] != old[EARLY_POP:OP16]:
        raise SystemExit("gate or handler moved")
    if img[0x35F64:0x35F64 + 16] != old[0x35F64:0x35F64 + 16]:
        raise SystemExit("data table")
    after, pools = callers(bytes(img), SLOT, SLOT_END)
    if after != [(HOOK, 4, SLOT)] or pools:
        raise SystemExit("after %s pools %s" % (after[:8], [hex(p) for p in pools[:6]]))
    if literal_guard.covered_loads(old, bytes(img))[1]:
        raise SystemExit("load guard %s" % literal_guard.covered_loads(old, bytes(img))[1][:6])
    if literal_guard.covered_branches(old, bytes(img))[1]:
        raise SystemExit("branch guard %s" % literal_guard.covered_branches(old, bytes(img))[1][:6])
    if literal_guard.never_written(old, bytes(img)):
        raise SystemExit("never-write")
    img[TAG] = b"DMR003.FW36.V022"
    DEST.write_bytes(img)
    print(DEST.name)
    print(hashlib.sha256(bytes(img)).hexdigest())
    print("stub", len(stub), "end", hex(SLOT + len(stub)))


if __name__ == "__main__":
    build()
