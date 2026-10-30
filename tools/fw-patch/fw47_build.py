# FW47: FW46, and store 0 at 0x38875 after the engine-end 0xE9C(r0, 0).
# The helper is in the dead hole at 0x5B700. 0xE64's nonzero return
# skips 0xE9C's own store, so this one runs after the call returns.
import hashlib
import subprocess
from pathlib import Path

import fw30_build
import literal_guard

ROOT = Path(__file__).resolve().parents[2]
SRC = ROOT / "radio_firmware" / "build" / "DMR003.FW46.V022.bin"
DEST = ROOT / "radio_firmware" / "build" / "DMR003.FW47.V022.bin"
TAG = slice(0x38464, 0x38474)
HOLE = 0x5B700
HOLE_END = 0x5B720
LIVE = 0x5B720
CALL = 0x5B758
E9C = 0xE9C
OBJDUMP = Path(r"C:\Users\Joshua\tools\csky-elfabiv2\bin\csky-elfabiv2-objdump.exe")

ASM = """
	.text
	.global	clear75
clear75:
	push	r15
	.long	0xbbccddee
	movih	r3, 3
	ori	r3, r3, 0x8874
	movi	r2, 0
	st.b	r2, (r3, 1)
	pop	r15
"""


def build():
    img = bytearray(SRC.read_bytes())
    old = bytes(img)
    if img[TAG] != b"DMR003.FW46.V022":
        raise SystemExit("tag")
    if img[LIVE:LIVE + 2] != bytes.fromhex("d414"):
        raise SystemExit("live push")
    if fw30_build.bsr_target(img, CALL) != E9C:
        raise SystemExit("call")
    for pc, pool in literal_guard.literal_loads(old):
        if HOLE <= pool < HOLE_END and not (HOLE <= pc < HOLE_END):
            raise SystemExit("pool")
    for pc, _length, target in literal_guard.branch_targets(old):
        if HOLE <= target < LIVE:
            raise SystemExit("branch %X" % pc)
    code = bytearray(fw30_build._linked(ASM, HOLE, "fw47"))
    import struct
    slot = code.find(struct.pack("<I", 0xBBCCDDEE))
    if slot < 0 or len(code) > HOLE_END - HOLE:
        raise SystemExit("stub %d" % len(code))
    code[slot:slot + 4] = fw30_build.encode_bsr(HOLE + slot, E9C)
    img[HOLE:HOLE + len(code)] = code
    img[CALL:CALL + 4] = fw30_build.encode_bsr(CALL, HOLE)
    if fw30_build.bsr_target(img, CALL) != HOLE:
        raise SystemExit("redirect")
    if fw30_build.bsr_target(img, HOLE + slot) != E9C:
        raise SystemExit("inner")
    if literal_guard.covered_loads(old, bytes(img))[1]:
        raise SystemExit("load guard")
    if literal_guard.covered_branches(old, bytes(img))[1]:
        raise SystemExit("branch guard")
    if literal_guard.never_written(old, bytes(img)):
        raise SystemExit("never-write")
    img[TAG] = b"DMR003.FW47.V022"
    DEST.write_bytes(img)
    print(DEST.name)
    print(hashlib.sha256(bytes(img)).hexdigest())
    print("len", len(code))
    dump = subprocess.check_output(
        [str(OBJDUMP), "-b", "binary", "-m", "csky", "-D",
         "--start-address=0x5B700", "--stop-address=0x5B720", str(DEST)],
        text=True, errors="replace")
    print(dump)
    if "st.b" not in dump or "34932" not in dump:
        raise SystemExit("store")


if __name__ == "__main__":
    build()
