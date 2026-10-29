# FW41-D2: FW41-D plus breadcrumbs. Diagnostic only.
# Step byte 0x32688, pass counter 0x32689.
# No 32-bit literal of 0x32688..0x3268B in the factory image or in FW4D.
# FW40's stores are words at 0x32680 and 0x32684 (through 0x32687).
#
# The only zero hole is 0x5BD3C..0x5BD74 (56 bytes). A reply hook is 14
# bytes and does not fit beside the wait, so the reply site stays stock.
# Steps that do fit:
#   2  each pass of the 0x32457 wait (replaces bsr delay_ms at 0x9270).
#      r0 is already 10. Pass byte increments. Then the real delay.
#   3  past that wait (replaces ld.b r5,(r6,8) / cmpnei r5,1 at 0x9288).
#   4  entry of 0xE9C after its push (replaces subi sp,4 / movi r3,0 at
#      0xE9E). r3 is 0 again before the return. r0 and r1 are untouched.
# Step 0 means the handler never reached the wait or the instruction
# after it. The first trip skips the delay, so a clear flag lands on 3.
import hashlib
import struct
import subprocess
from pathlib import Path

import fw30_build

ROOT = Path(__file__).resolve().parents[2]
SRC = ROOT / "radio_firmware" / "build" / "DMR003.FW4D.V022.bin"
FACTORY = ROOT / "radio_firmware" / "DMR003.UV4T.V022-ORIGINAL.bin"
DEST = ROOT / "radio_firmware" / "build" / "DMR003.FW4E.V022.bin"
TAG = slice(0x38464, 0x38474)
STUB = 0x5BD3C
STUB_END = 0x5BD74
OBJDUMP = Path(r"C:\Users\Joshua\tools\csky-elfabiv2\bin\csky-elfabiv2-objdump.exe")
DELAY = 0x18A4

ASM = """
	.text
	.global	s2
	.global	s3
	.global	s4
s2:
	push	r15
	lrw	r2, 0x32688
	movi	r3, 2
	st.b	r3, (r2, 0)
	ld.b	r3, (r2, 1)
	addi	r3, 1
	st.b	r3, (r2, 1)
	bsr	.Ldelay
	pop	r15
s3:
	lrw	r2, 0x32688
	movi	r3, 3
	st.b	r3, (r2, 0)
	ld.b	r5, (r6, 8)
	cmpnei	r5, 1
	jmp	r15
s4:
	subi	r14, 4
	movi	r2, 4
	lrw	r3, 0x32688
	st.b	r2, (r3, 0)
	movi	r3, 0
	jmp	r15
.Ldelay:
	jmp	r15
"""

SITES = {"s2": 0x9270, "s3": 0x9288, "s4": 0xE9E}
EXPECT = {
    0x9270: bytes.fromhex("ffe31ac3"),
    0x9288: bytes.fromhex("a886413d"),
    0xE9E: bytes.fromhex("21140033"),
}


def literals(blob):
    hits = []
    for addr in (0x32688, 0x32689, 0x3268A, 0x3268B):
        raw = struct.pack("<I", addr)
        start = 0
        while True:
            at = blob.find(raw, start)
            if at < 0:
                break
            hits.append((addr, at))
            start = at + 1
    return hits


def build():
    img = bytearray(SRC.read_bytes())
    fac = FACTORY.read_bytes()
    fac_hits = literals(fac)
    src_hits = literals(bytes(img))
    if fac_hits or src_hits:
        raise SystemExit("literals factory %s image %s" % (fac_hits, src_hits))
    if img[TAG] != b"DMR003.FW4D.V022":
        raise SystemExit("tag")
    for at, raw in EXPECT.items():
        if img[at:at + 4] != raw:
            raise SystemExit("site %X is %s" % (at, img[at:at + 4].hex()))
    if img[STUB:STUB_END] != b"\x00" * (STUB_END - STUB):
        raise SystemExit("hole")
    code = bytearray(fw30_build._linked(ASM, STUB, "fw41d2"))
    elf = Path(r"C:\Users\Joshua\AppData\Local\Temp\fw1718\fw30\fw41d2.elf")
    text = subprocess.check_output(
        [str(OBJDUMP), "-d", str(elf)], text=True, errors="replace")
    jmp_at = []
    for line in text.splitlines():
        parts = line.split()
        if len(parts) >= 3 and parts[2] == "jmp" and "r15" in line:
            jmp_at.append(int(parts[0].rstrip(":"), 16))
    # The last jmp r15 is the .Ldelay placeholder. Earlier ones return.
    if len(jmp_at) < 2:
        raise SystemExit("jmps %s" % [hex(x) for x in jmp_at])
    delay_at = jmp_at[-1]
    hit = False
    for i in range(0, len(code) - 3, 2):
        if code[i:i + 4] == fw30_build.encode_bsr(STUB + i, delay_at):
            code[i:i + 4] = fw30_build.encode_bsr(STUB + i, DELAY)
            hit = True
    if not hit:
        raise SystemExit("delay bsr")
    if STUB + len(code) > STUB_END:
        raise SystemExit("stub %d ends %X" % (len(code), STUB + len(code)))
    sym = {}
    for line in text.splitlines():
        if ">:" in line and "<" in line:
            addr_s, rest = line.split("<", 1)
            name = rest.split(">", 1)[0]
            if name in SITES:
                sym[name] = int(addr_s, 16)
    for name in SITES:
        if name not in sym:
            raise SystemExit("missing " + name)
    for name, at in SITES.items():
        img[at:at + 4] = fw30_build.encode_bsr(at, sym[name])
    img[STUB:STUB + len(code)] = code
    img[TAG] = b"DMR003.FW4E.V022"
    found_delay = False
    for i in range(0, len(code) - 3, 2):
        if code[i:i + 4] == fw30_build.encode_bsr(STUB + i, DELAY):
            found_delay = True
    if not found_delay:
        raise SystemExit("delay not retargeted")
    DEST.write_bytes(img)
    print("scan factory 0  image 0")
    print(DEST.name)
    print(hashlib.sha256(bytes(img)).hexdigest())
    print("stub", len(code), "spare", STUB_END - (STUB + len(code)))
    for name, at in SITES.items():
        print(name, hex(sym[name]), "hook", hex(at),
              "bsr", fw30_build.bsr_target(img, at))
    dump = subprocess.check_output(
        [str(OBJDUMP), "-b", "binary", "-m", "csky", "-D",
         "--start-address=0x%X" % STUB, "--stop-address=0x%X" % (STUB + len(code)),
         str(DEST)], text=True, errors="replace")
    print(dump)
    for at, name in ((0x9270, "s2"), (0x9288, "s3"), (0xE9E, "s4")):
        if fw30_build.bsr_target(img, at) != sym[name]:
            raise SystemExit("hook %s" % name)


if __name__ == "__main__":
    build()
