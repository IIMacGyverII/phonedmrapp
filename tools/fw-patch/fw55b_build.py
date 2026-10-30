# Bisect image (b): FW55 with the seven hooks restored, the 0x40 dispatch kept.
#
# F55A also restored the dispatch word, so it was the factory image with a
# bench tag. F55B leaves 0x382B8 pointing at the FW55 tail. The hook sites
# are the factory instructions. Not a release. Load it only after F55A
# passes the first slot 0 key.
import hashlib
from pathlib import Path

import fw30_build
import fw55a_build
import literal_guard
import space_map

ROOT = Path(__file__).resolve().parents[2]
SRC = ROOT / "radio_firmware" / "build" / "DMR003.FW55.V022.bin"
FAC = ROOT / "radio_firmware" / "DMR003.UV4T.V022-ORIGINAL.bin"
DEST = ROOT / "radio_firmware" / "build" / "DMR003.F55B.V022.bin"
TAG = slice(0x38464, 0x38474)
SITES = tuple(at for at in fw55a_build.SITES if at != 0x382B8)


def build():
    img = bytearray(SRC.read_bytes())
    old = bytes(img)
    fac = FAC.read_bytes()
    if img[TAG] != b"DMR003.FW55.V022":
        raise SystemExit("tag")
    if fac[TAG] != b"DMR003.UV4T.V022":
        raise SystemExit("factory tag")
    if len(SITES) != 7:
        raise SystemExit("sites")
    kept = bytes(img[0x382B8:0x382BC])
    if kept == fac[0x382B8:0x382BC]:
        raise SystemExit("dispatch already factory")
    for at in SITES:
        if img[at:at + 4] == fac[at:at + 4]:
            raise SystemExit("already factory %X" % at)
        img[at:at + 4] = fac[at:at + 4]
    if img[0x382B8:0x382BC] != kept:
        raise SystemExit("dispatch")
    if img[0x5AEFC:] != old[0x5AEFC:]:
        raise SystemExit("tail")
    if literal_guard.covered_loads(old, bytes(img))[1]:
        raise SystemExit("load guard")
    if literal_guard.covered_branches(old, bytes(img))[1]:
        raise SystemExit("branch guard")
    if literal_guard.never_written(old, bytes(img)):
        raise SystemExit("never-write")
    if literal_guard.pointed_into(old, bytes(img)):
        raise SystemExit("pointed")
    if space_map.outside_free(old, bytes(img)):
        raise SystemExit("space")
    img[TAG] = b"DMR003.F55B.V022"
    DEST.write_bytes(img)
    print(DEST.name)
    print(hashlib.sha256(bytes(img)).hexdigest())
    return DEST


if __name__ == "__main__":
    build()
