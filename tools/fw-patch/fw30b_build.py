# FW30b: the retagged FW30 image plus a short opcode 18.
# The 122-byte read does not fit. This one calls the IRAM read the RSSI
# handler uses (0x2B25C) and sends the 16-bit value through 0x90B0.
# It sits at 0x5BFB4, an uncalled function; the live pool at 0x5BE34 and
# the shared code at 0x5BF24 and 0x5C040 stay.
import hashlib
import struct
from pathlib import Path

import fw30_build
import literal_guard

ROOT = Path(r"D:\Documents\code\personal\phonedmrapp")
SRC = ROOT / "radio_firmware" / "build" / "DMR003.FW30.V022.bin"
DEST = ROOT / "radio_firmware" / "build" / "DMR003.F30B.V022.bin"
TAG = slice(0x38464, 0x38474)
ENTRY = 0x5BFB4
STUB_AT = 0x5BFB2
LIMIT = 0x5BFFE
GATE_CMP = 0x5BCBC
GATE = 0x5BCC0

_ASM = """
	.text
	.global	op18
op18:
	push	r15
	ld.b	r0, (r7, 9)
	btsti	r0, 7
	bt	1f
	lrw	r1, 0x2b25c
	jsr	r1
	mov	r4, r0
	subi	r14, 8
	st.b	r4, (r14, 0)
	lsri	r0, r4, 8
	st.b	r0, (r14, 1)
	ld.b	r0, (r7, 1)
	movi	r1, 0
	mov	r2, r14
	movi	r3, 2
	.short	0xE000, 0x90B0
	addi	r14, 8
	br	2f
1:
	ld.b	r0, (r7, 1)
	movi	r1, 1
	.short	0xE000, 0x8E7C
2:
	pop	r15
"""


def gate(blob_base):
    """16 bytes: opcode 18 calls the stub, 16 and 17 keep their handler."""
    body = bytearray()
    body += bytes.fromhex("523b")             # cmpnei r3, 18
    body += bytes.fromhex("0408")             # bt 0x5BCCA
    body += fw30_build.encode_bsr(0x5BCC4, ENTRY)
    body += bytes.fromhex("0704")             # br 0x5BCD6
    body += fw30_build.encode_bsr(0x5BCCA, 0x5BD74)
    body += bytes.fromhex("0404")             # br 0x5BCD6
    if len(body) != 16:
        raise SystemExit("gate %d" % len(body))
    return bytes(body)


def build():
    img = bytearray(SRC.read_bytes())
    if img[TAG] != b"DMR003.FW30.V022":
        raise SystemExit("tag")
    if img[GATE_CMP:GATE_CMP + 2] != bytes.fromhex("113b"):
        raise SystemExit("compare")
    if img[STUB_AT:STUB_AT + 2] != bytes.fromhex("d014"):
        raise SystemExit("tail entry")
    stub = bytearray(fw30_build._linked(_ASM, STUB_AT, "op18"))
    fw30_build._patch_one(stub, STUB_AT, bytes.fromhex("00e0b090"), 0x90B0, "reply")
    fw30_build._patch_one(stub, STUB_AT, bytes.fromhex("00e07c8e"), 0x8E7C, "nack")
    if STUB_AT + len(stub) > LIMIT:
        raise SystemExit("stub ends %X" % (STUB_AT + len(stub)))
    img[GATE_CMP:GATE_CMP + 2] = bytes.fromhex("123b")  # cmphsi r3, 19
    img[GATE:GATE + 16] = gate(img)
    img[STUB_AT:STUB_AT + len(stub)] = stub
    if fw30_build.bsr_target(img, 0x5BCC4) != ENTRY:
        raise SystemExit("op18 call")
    if fw30_build.bsr_target(img, 0x5BCCA) != 0x5BD74:
        raise SystemExit("op16 call")
    spans, loads = literal_guard.covered_loads(bytes(SRC.read_bytes()), bytes(img))
    spans_b, branches = literal_guard.covered_branches(bytes(SRC.read_bytes()), bytes(img))
    if loads or branches:
        raise SystemExit("guard loads %s branches %s" % (loads, branches))
    img[TAG] = b"DMR003.F30B.V022"
    DEST.write_bytes(img)
    print(DEST)
    print(hashlib.sha256(img).hexdigest())
    print("stub", len(stub), "end", hex(STUB_AT + len(stub)))
    return bytes(img)


if __name__ == "__main__":
    build()
