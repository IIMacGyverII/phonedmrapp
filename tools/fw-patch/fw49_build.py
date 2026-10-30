# FW49: FW46, and the launch-2 hook passes r1 = 0 into 0xE9C.
# The stock sites at 0x92A6 and 0x92F6 set r1 = 1 before calling the
# unkey prelude, which forwards that r1. 0xE9C stores r1 when 0xE64
# returns 0, so the host's PTT off writes 1 at 0x38875. Launch 2 is
# body 2. The key path is left as the stock sites pass it.
import hashlib
import struct
import subprocess
from pathlib import Path

import fw30_build
import literal_guard

ROOT = Path(__file__).resolve().parents[2]
SRC = ROOT / "radio_firmware" / "build" / "DMR003.FW46.V022.bin"
DEST = ROOT / "radio_firmware" / "build" / "DMR003.FW49.V022.bin"
TAG = slice(0x38464, 0x38474)
HELP = 0x5B65A
HELP_END = 0x5B690
CALL = 0x5B61E
E9C = 0xE9C
LIVE = 0x5B720
OBJDUMP = Path(r"C:\Users\Joshua\tools\csky-elfabiv2\bin\csky-elfabiv2-objdump.exe")

ASM = """
	.text
	.global	unkey_r1
unkey_r1:
	movi	r1, 0
	.long	0xbbccddee
	jmp	r15
"""


def build():
    img = bytearray(SRC.read_bytes())
    old = bytes(img)
    if img[TAG] != b"DMR003.FW46.V022":
        raise SystemExit("tag")
    if img[LIVE:LIVE + 2] != bytes.fromhex("d414"):
        raise SystemExit("live")
    if fw30_build.bsr_target(img, CALL) != E9C:
        raise SystemExit("call")
    for pc, pool in literal_guard.literal_loads(old):
        if HELP <= pool < HELP_END and not (HELP <= pc < HELP_END):
            raise SystemExit("pool")
    for pc, _length, target in literal_guard.branch_targets(old):
        if HELP <= target < HELP_END and not (HELP <= pc < HELP_END):
            raise SystemExit("branch")
    code = bytearray(fw30_build._linked(ASM, HELP, "fw49"))
    slot = code.find(struct.pack("<I", 0xBBCCDDEE))
    if slot < 0 or len(code) > HELP_END - HELP:
        raise SystemExit("stub %d" % len(code))
    code[slot:slot + 4] = fw30_build.encode_bsr(HELP + slot, E9C)
    img[HELP:HELP + len(code)] = code
    img[CALL:CALL + 4] = fw30_build.encode_bsr(CALL, HELP)
    if literal_guard.covered_loads(old, bytes(img))[1]:
        raise SystemExit("load guard")
    if literal_guard.covered_branches(old, bytes(img))[1]:
        raise SystemExit("branch guard")
    if literal_guard.never_written(old, bytes(img)):
        raise SystemExit("never-write")
    img[TAG] = b"DMR003.FW49.V022"
    DEST.write_bytes(img)
    print(DEST.name)
    print(hashlib.sha256(bytes(img)).hexdigest())
    print("len", len(code))
    dump = subprocess.check_output(
        [str(OBJDUMP), "-b", "binary", "-m", "csky", "-D",
         "--start-address=0x5B65A", "--stop-address=0x5B670", str(DEST)],
        text=True, errors="replace")
    print(dump)
    if "movi" not in dump or "bsr" not in dump:
        raise SystemExit("asm")


if __name__ == "__main__":
    build()
