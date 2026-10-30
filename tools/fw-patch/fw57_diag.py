# Bench-only opcode 14 windows. Never a release image.
# F54D is FW54, F57D is FW57. Both read [0x30000, 0x50000).
import hashlib
from pathlib import Path

import literal_guard

ROOT = Path(__file__).resolve().parents[2]
BUILD = ROOT / "radio_firmware" / "build"
LO = 0x5C0CE
HI = 0x5C0D6
OLD_LO = bytes.fromhex("21ea0018")
OLD_HI = bytes.fromhex("21ea0118")
NEW_LO = bytes.fromhex("21ea0300")
NEW_HI = bytes.fromhex("21ea0500")


def widen(src_name, old_tag, dest_name, new_tag):
    img = bytearray((BUILD / src_name).read_bytes())
    old = bytes(img)
    if img[0x38464:0x38474] != old_tag:
        raise SystemExit("tag")
    if img[LO:LO + 4] != OLD_LO or img[HI:HI + 4] != OLD_HI:
        raise SystemExit("window")
    img[LO:LO + 4] = NEW_LO
    img[HI:HI + 4] = NEW_HI
    if literal_guard.covered_loads(old, bytes(img))[1]:
        raise SystemExit("load guard")
    if literal_guard.covered_branches(old, bytes(img))[1]:
        raise SystemExit("branch guard")
    if literal_guard.never_written(old, bytes(img)):
        raise SystemExit("never-write")
    if literal_guard.pointed_into(old, bytes(img)):
        raise SystemExit("pointed")
    img[0x38464:0x38474] = new_tag
    dest = BUILD / dest_name
    dest.write_bytes(img)
    print(dest.name)
    print(hashlib.sha256(bytes(img)).hexdigest())
    return dest


def build():
    import fw57_build
    fw57_build.build()
    widen("DMR003.FW54.V022.bin", b"DMR003.FW54.V022",
          "DMR003.F54D.V022.bin", b"DMR003.F54D.V022")
    widen("DMR003.FW57.V022.bin", b"DMR003.FW57.V022",
          "DMR003.F57D.V022.bin", b"DMR003.F57D.V022")
