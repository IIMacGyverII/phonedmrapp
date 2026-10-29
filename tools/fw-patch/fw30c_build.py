# F30C: F30B plus two fixes.
# After a symbol drop, write 0x30 = 0x7026 again. The drop's stock unkey
# runs last and leaves bit 7 set (0x70A6). The symbol unkey itself already
# writes 0x7026 before that call.
# The close at 0x37F4 already calls the one-shot guard at 0x5BDAA. That
# guard turned the first r0==1 close into r0==0 and then cleared the flag.
# The stock unkey enters the same function with r0==0, so clearing on that
# entry let the squelch task's next close write 0x70A6. This build leaves
# the flag set. On the phone, opcode 3 then stops answering (see the
# handoff Stuck block). Do not load this output until that is answered.
# The empty unkey at 0x5B61E stays the stock call.
# Op 15's success path clears bit 8 of 0x11000384 and then points r4 at
# the ack buffer, which is what the two instructions it replaces did.
import hashlib
from pathlib import Path

import fw30_build
import literal_guard

ROOT = Path(r"D:\Documents\code\personal\phonedmrapp")
SRC = ROOT / "radio_firmware" / "build" / "DMR003.F30B.V022.bin"
DEST = ROOT / "radio_firmware" / "build" / "DMR003.F30C.V022.bin"
TAG = slice(0x38464, 0x38474)
OP18 = 0x5BFB2
CC = 0x5BFD8
UNMUTE = 0x5BFEC
LIMIT = 0x5BFFE
# The symbol unkey's own write. The displacement is PC-relative, so copy the target, not the bytes.

_OP18 = """
	.text
	.global	op18
op18:
	push	r15
	ld.b	r0, (r7, 9)
	lrw	r1, 0x2b25c
	jsr	r1
	mov	r4, r14
	st.b	r0, (r4, 0)
	lsri	r0, r0, 8
	st.b	r0, (r4, 1)
	ld.b	r0, (r7, 1)
	movi	r1, 0
	mov	r2, r4
	movi	r3, 2
	.short	0xE000, 0x90B0
	pop	r15
"""

_UNMUTE = """
	.text
	.global	unmute
unmute:
	push	r15
	.short	0xE000, 0x0E9C
	movi	r0, 48
	movi	r1, 28710
	.short	0xE000, 0x2B20
	pop	r15
"""

_CC = """
	.text
	.global	ccclr
ccclr:
	st.b	r0, (r4, 0)
	lrw	r3, 0x11000384
	ld.w	r2, (r3, 0)
	bclri	r2, 8
	st.w	r2, (r3, 0)
	subi	r4, r4, 1380
	jmp	r15
"""


def build():
    img = bytearray(SRC.read_bytes())
    if img[TAG] != b"DMR003.F30B.V022":
        raise SystemExit("tag")
    if img[0x5B758:0x5B75C] != bytes.fromhex("fde3a22b"):
        raise SystemExit("stock unkey")
    if img[0x5C484:0x5C486] != bytes.fromhex("00a4"):
        raise SystemExit("flag store")
    op18 = bytearray(fw30_build._linked(_OP18, OP18, "f30c18"))
    fw30_build._patch_one(op18, OP18, bytes.fromhex("00e0b090"), 0x90B0, "reply")
    unmute = bytearray(fw30_build._linked(_UNMUTE, UNMUTE, "f30cun"))
    fw30_build._patch_one(unmute, UNMUTE, bytes.fromhex("00e09c0e"), 0xE9C, "unkey")
    at = unmute.find(bytes.fromhex("00e0202b"))
    if at < 0:
        raise SystemExit("write placeholder")
    write_to = fw30_build.bsr_target(img, 0x5B654)
    unmute[at:at + 4] = fw30_build.encode_bsr(UNMUTE + at, write_to)
    cc = bytearray(fw30_build._linked(_CC, CC, "f30ccc"))
    end = CC + len(cc)
    if end > LIMIT:
        raise SystemExit("cc ends %X" % end)
    if OP18 + len(op18) > CC or CC + len(cc) > UNMUTE or UNMUTE + len(unmute) > LIMIT:
        raise SystemExit("overlap %X %X %X" % (OP18 + len(op18), CC + len(cc), UNMUTE + len(unmute)))
    img[OP18:OP18 + len(op18)] = op18
    img[UNMUTE:UNMUTE + len(unmute)] = unmute
    img[CC:end] = cc
    img[0x5B758:0x5B75C] = fw30_build.encode_bsr(0x5B758, UNMUTE)
    img[0x5C484:0x5C488] = fw30_build.encode_bsr(0x5C484, CC)
    # 0x5BDBC still skips to the zextb when r0 is not 1. When r0 is 1 the
    # flag stores become nops and r0 becomes 0, so the close does not mute.
    guard = img[0x5BDBC:0x5BDC6]
    if guard != bytes.fromhex("0508003240a341a30030"):
        raise SystemExit("guard %s" % guard.hex())
    img[0x5BDBC:0x5BDC6] = bytes.fromhex("05080030036c036c036c")
    if fw30_build.bsr_target(img, 0x5B61E) != 0xE9C:
        raise SystemExit("empty unkey")
    if fw30_build.bsr_target(img, 0x5B758) != UNMUTE:
        raise SystemExit("unmute call")
    if fw30_build.bsr_target(img, 0x5C484) != CC:
        raise SystemExit("cc call")
    if fw30_build.bsr_target(img, 0x5BCC4) != 0x5BFB4:
        raise SystemExit("op18 call")
    old = SRC.read_bytes()
    if literal_guard.covered_loads(old, bytes(img))[1]:
        raise SystemExit("load guard")
    if literal_guard.covered_branches(old, bytes(img))[1]:
        raise SystemExit("branch guard")
    img[TAG] = b"DMR003.F30C.V022"
    DEST.write_bytes(img)
    print(DEST)
    print(hashlib.sha256(img).hexdigest())
    print("op18", len(op18), "unmute", len(unmute), "cc", len(cc), "end", hex(end))


if __name__ == "__main__":
    build()
