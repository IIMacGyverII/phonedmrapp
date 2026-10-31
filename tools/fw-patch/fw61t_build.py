# FW61T: FW61 with the old time-out stub given back to the factory image.
# 0xAB18 on FW57 already branches to the stock handler at 0xA308.
# The 24 bytes at 0x5B700 are the leftover stub. Nothing branches there.
# The version field holds 16 characters, so the tag is DMR003.F61T.V022.
import hashlib
from pathlib import Path

import fw30_build
import fw59_build
import fw61_build

ROOT = Path(__file__).resolve().parents[2]
SRC = fw61_build.DEST
FACTORY = ROOT / "radio_firmware" / "DMR003.UV4T.V022-ORIGINAL.bin"
DEST = ROOT / "radio_firmware" / "build" / "DMR003.F61T.V022.bin"
TAG = fw61_build.TAG
SLOT = 0x5B700
SLOT_END = 0x5B718
CLAMP = 0xAB18
STOCK = 0xA308


def build():
    if not SRC.is_file() or SRC.read_bytes()[TAG] != b"DMR003.FW61.V022":
        fw61_build.build()
    img = bytearray(SRC.read_bytes())
    old = bytes(img)
    factory = FACTORY.read_bytes()
    if img[TAG] != b"DMR003.FW61.V022":
        raise SystemExit("tag")
    if factory[CLAMP:CLAMP + 4] != img[CLAMP:CLAMP + 4]:
        raise SystemExit("clamp bytes")
    if fw30_build.bsr_target(img, CLAMP) != STOCK:
        raise SystemExit("clamp target")
    img[SLOT:SLOT_END] = factory[SLOT:SLOT_END]
    if img[CLAMP:CLAMP + 4] != factory[CLAMP:CLAMP + 4]:
        raise SystemExit("clamp moved")
    # The slot is not in the free-tail map. The literal guard is the check.
    fw59_build._guards(old, bytes(img), False)
    img[TAG] = b"DMR003.F61T.V022"
    DEST.write_bytes(img)
    print(DEST.name)
    print(hashlib.sha256(bytes(img)).hexdigest())
    print("freed %X-%X (%d) back to the factory bytes" % (SLOT, SLOT_END, SLOT_END - SLOT))
    return DEST


if __name__ == "__main__":
    build()
