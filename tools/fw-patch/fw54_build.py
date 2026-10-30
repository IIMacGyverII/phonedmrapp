# FW54: FW46, with the engine-end unkey removed the way FW45 had it.
#
# FW46 calls 0xE9C with r1 = 0 at 0x5B758. That call does not return, so a
# tone key never reaches the host's stock unkey. FW53 branched to the pop
# at 0x5B77A and therefore skipped the drop at 0x5BD98, the TX-bit clear,
# and the jump to 0x5BD06. Its FT8 carrier died at 8.75 s near 1500 Hz and
# the app still reported transmitting.
#
# The six bytes at 0x5B756 are restored to FW45: movi r1, 1 and two nops.
# 0x5B748 still calls 0x5BD98. The TX-bit clear and the branch to 0x5BD06
# still run. 0x5B700 and 0x5B74C-0x5B755 stay FW46.
import hashlib
from pathlib import Path

import literal_guard

ROOT = Path(__file__).resolve().parents[2]
SRC = ROOT / "radio_firmware" / "build" / "DMR003.FW46.V022.bin"
DEST = ROOT / "radio_firmware" / "build" / "DMR003.FW54.V022.bin"
TAG = slice(0x38464, 0x38474)
SITE = 0x5B756
FW45 = bytes.fromhex("0131036c036c")
HELPER = range(0x5B700, 0x5B720)
LIVE_UNKEY = range(0x5B74C, 0x5B756)
DROP = 0x5B748


def build():
    img = bytearray(SRC.read_bytes())
    old = bytes(img)
    if img[TAG] != b"DMR003.FW46.V022":
        raise SystemExit("tag")
    if img[SITE:SITE + 6] != bytes.fromhex("0031fde3a22b"):
        raise SystemExit("unkey site")
    if img[DROP:DROP + 4] != bytes.fromhex("00e02803"):
        raise SystemExit("drop")
    img[SITE:SITE + 6] = FW45
    if literal_guard.covered_loads(old, bytes(img))[1]:
        raise SystemExit("load guard")
    if literal_guard.covered_branches(old, bytes(img))[1]:
        raise SystemExit("branch guard")
    if literal_guard.never_written(old, bytes(img)):
        raise SystemExit("never-write")
    img[TAG] = b"DMR003.FW54.V022"
    DEST.write_bytes(img)
    print(DEST.name)
    print(hashlib.sha256(bytes(img)).hexdigest())
    return DEST
