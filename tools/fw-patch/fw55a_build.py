# Bisect image (a): FW55 with the seven hooks restored to the factory image.
#
# The first group slot 0 key fails on FW55, whose 0x26 sites are already
# the factory calls. These seven hooks are the rest of the difference
# outside the tail. The tail stays FW55 and is unused once the hooks
# point at the factory code again. Not a release.
import hashlib
from pathlib import Path

import fw30_build
import literal_guard
import space_map

ROOT = Path(__file__).resolve().parents[2]
SRC = ROOT / "radio_firmware" / "build" / "DMR003.FW55.V022.bin"
FAC = ROOT / "radio_firmware" / "DMR003.UV4T.V022-ORIGINAL.bin"
DEST = ROOT / "radio_firmware" / "build" / "DMR003.F55A.V022.bin"
TAG = slice(0x38464, 0x38474)
# Four bytes each. 0xC1BA and 0xC244 are the two sites of one admit hook.
SITES = (
    0x37F8, 0x7C56, 0xA890, 0xC1BA, 0xC244, 0x17E26, 0x18B68, 0x382B8,
)
# 0x18B68 is bsr 0x3D20 in the factory image. The 10:15 review named
# 0x18B70; these bytes, and the older fw-patch tests, say 0x3D20.
BSR = {
    0x7C56: 0x2B0C,
    0xA890: 0x90B0,
    0xC1BA: 0x2404,
    0xC244: 0x2404,
    0x18B68: 0x3D20,
}
PLAIN = {
    0x37F8: bytes.fromhex("00753b6c"),
    0x17E26: bytes.fromhex("42e40f20"),
}
DISPATCH = 0x03024A54


def build():
    img = bytearray(SRC.read_bytes())
    old = bytes(img)
    fac = FAC.read_bytes()
    if img[TAG] != b"DMR003.FW55.V022":
        raise SystemExit("tag")
    if fac[TAG] != b"DMR003.UV4T.V022":
        raise SystemExit("factory tag")
    for at, target in BSR.items():
        if fw30_build.bsr_target(fac, at) != target:
            raise SystemExit("factory bsr %X" % at)
    for at, raw in PLAIN.items():
        if fac[at:at + 4] != raw:
            raise SystemExit("factory plain %X" % at)
    if int.from_bytes(fac[0x382B8:0x382BC], "little") != DISPATCH:
        raise SystemExit("factory dispatch")
    for at in SITES:
        if img[at:at + 4] == fac[at:at + 4]:
            raise SystemExit("already factory %X" % at)
        img[at:at + 4] = fac[at:at + 4]
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
    img[TAG] = b"DMR003.F55A.V022"
    DEST.write_bytes(img)
    print(DEST.name)
    print(hashlib.sha256(bytes(img)).hexdigest())
    return DEST
