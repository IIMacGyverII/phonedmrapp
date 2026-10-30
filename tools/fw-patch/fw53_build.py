# FW53: FW46, with the symbol-end task no longer calling 0xE9C(r1=0).
#
# That call does not return, so a tone key that ends in this task never
# lets the host unkey. The branch at 0x5B748 now goes to the pop at
# 0x5B77A. The flag store just above it still clears 0x4DAAC. The host's
# body 2 is then the single stock unkey.
#
# 0x5B700 stays the pitch helper (FW50 overwrote it and FT8 moved to
# 7500 Hz). 0x5B74C stays the live unkey (FW52 overwrote it and group
# slot 0 stopped radiating). The instruction at 0x5B756 is movi r1, 1
# so a path that still reaches it uses the stock unkey argument.
import hashlib
from pathlib import Path

import fw30_build
import literal_guard

ROOT = Path(__file__).resolve().parents[2]
SRC = ROOT / "radio_firmware" / "build" / "DMR003.FW46.V022.bin"
DEST = ROOT / "radio_firmware" / "build" / "DMR003.FW53.V022.bin"
TAG = slice(0x38464, 0x38474)
SKIP = 0x5B748
POP = 0x5B77A
DROP = 0x5BD98
R1 = 0x5B756
HELPER = range(0x5B700, 0x5B720)
LIVE_UNKEY = range(0x5B74C, 0x5B756)


def build():
    img = bytearray(SRC.read_bytes())
    old = bytes(img)
    if img[TAG] != b"DMR003.FW46.V022":
        raise SystemExit("tag")
    if img[SKIP:SKIP + 4] != fw30_build.encode_bsr(SKIP, DROP):
        raise SystemExit("drop site")
    if img[R1:R1 + 2] != bytes.fromhex("0031"):
        raise SystemExit("r1")
    img[SKIP:SKIP + 4] = fw30_build.encode_br(SKIP, POP)
    img[R1:R1 + 2] = bytes.fromhex("0131")
    if literal_guard.covered_loads(old, bytes(img))[1]:
        raise SystemExit("load guard")
    if literal_guard.covered_branches(old, bytes(img))[1]:
        raise SystemExit("branch guard")
    if literal_guard.never_written(old, bytes(img)):
        raise SystemExit("never-write")
    img[TAG] = b"DMR003.FW53.V022"
    DEST.write_bytes(img)
    print(DEST.name)
    print(hashlib.sha256(bytes(img)).hexdigest())
    return DEST


if __name__ == "__main__":
    build()
