# FW35: FW30 plus one bit-7 clear after the symbol-key close has finished.
# The close at 0x5B770 stores the last time-out byte and returns. That
# return is only the fall-through after the stock unkey and the TX-bit
# clear. The countdown's early return is the other pop, at 0x5B77A, and
# this build does not touch it. The replacement does that last store,
# then reads AT1846S 0x30 and writes it back with bit 7 clear, and only
# when bits 0 and 2 of 0x38908 are already clear. Opcode 18's old stub
# lived at 0x5BD74; both gate calls now take the sr=1 ack instead.
import hashlib
from pathlib import Path

import fw30_build
import literal_guard

ROOT = Path(__file__).resolve().parents[2]
SRC = ROOT / "radio_firmware" / "build" / "DMR003.FW30.V022.bin"
DEST = ROOT / "radio_firmware" / "build" / "DMR003.FW35.V022.bin"
TAG = slice(0x38464, 0x38474)
TAIL = 0x5B770
STUB = 0x5BD74
POOL = 0x5BE34
GATE_A = 0x5BCC4
GATE_B = 0x5BCCA

ASM = """
	.text
	.global	close_tail
	.global	op_refuse
close_tail:
	st.b	r2, (r4, 5)
	bsr	clear
	pop	r4-r7, r15
clear:
	push	r4, r15
	lrw	r4, 0x38908
	ld.b	r2, (r4, 0)
	andi	r2, r2, 5
	bnez	r2, .Ldone
	movi	r0, 100
	.short	0xE000, 0x1111
	movi	r0, 48
	.short	0xE000, 0x2222
	bclri	r0, 7
	mov	r1, r0
	movi	r0, 48
	.short	0xE000, 0x3333
.Ldone:
	pop	r4, r15
op_refuse:
	.short	0x8701, 0x3101
	.short	0xE000, 0x4444
	mov	r15, r6
	jmp	r15
"""


def build():
    img = bytearray(SRC.read_bytes())
    if img[TAG] != b"DMR003.FW30.V022":
        raise SystemExit("tag")
    if img[TAIL:TAIL + 4] != bytes.fromhex("45a49414"):
        raise SystemExit("tail %s" % img[TAIL:TAIL + 4].hex())
    if fw30_build.bsr_target(img, GATE_A) != STUB or fw30_build.bsr_target(img, GATE_B) != STUB:
        raise SystemExit("gate")
    stub = bytearray(fw30_build._linked(ASM, STUB, "fw35"))
    fw30_build._patch_one(stub, STUB, bytes.fromhex("00e01111"), 0x1BE8, "delay")
    fw30_build._patch_one(stub, STUB, bytes.fromhex("00e02222"), 0x54664, "read")
    fw30_build._patch_one(stub, STUB, bytes.fromhex("00e03333"), 0x54628, "write")
    fw30_build._patch_one(stub, STUB, bytes.fromhex("00e04444"), 0x8E7C, "ack")
    if STUB + len(stub) > POOL:
        raise SystemExit("stub ends at %X" % (STUB + len(stub)))
    refuse = stub.find(bytes.fromhex("01870131"))
    if refuse < 0:
        raise SystemExit("no refuse")
    old = bytes(img)
    img[STUB:STUB + len(stub)] = stub
    img[TAIL:TAIL + 4] = fw30_build.encode_br(TAIL, STUB)
    img[GATE_A:GATE_A + 4] = fw30_build.encode_bsr(GATE_A, STUB + refuse)
    img[GATE_B:GATE_B + 4] = fw30_build.encode_bsr(GATE_B, STUB + refuse)
    if literal_guard.covered_loads(old, bytes(img))[1]:
        raise SystemExit("load guard %s" % literal_guard.covered_loads(old, bytes(img))[1][:6])
    if literal_guard.covered_branches(old, bytes(img))[1]:
        raise SystemExit("branch guard %s" % literal_guard.covered_branches(old, bytes(img))[1][:6])
    img[TAG] = b"DMR003.FW35.V022"
    DEST.write_bytes(img)
    print(DEST.name)
    print(hashlib.sha256(bytes(img)).hexdigest())
    print("stub", len(stub), "end", hex(STUB + len(stub)), "refuse", hex(STUB + refuse))


if __name__ == "__main__":
    build()
