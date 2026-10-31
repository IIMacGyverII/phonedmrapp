# F59F: F59D with the destination test no longer able to skip the store.
# The FLCO test stays. This is bisect (c): A′ without the destination test.
#
# The All-Call file's voice header and terminator are FLCO 0, FID 0,
# service options 0, destination 16777215, so both A and A′ store them.
# The other 84 bursts were not re-encoded. A group-voice LC among them
# is FLCO 0 with the old destination, and only the destination compare
# makes A′ skip it.
import hashlib
from pathlib import Path

import fw59_build
import literal_guard
import space_map

ROOT = Path(__file__).resolve().parents[2]
SRC = ROOT / "radio_firmware" / "build" / "DMR003.F59D.V022.bin"
DEST = ROOT / "radio_firmware" / "build" / "DMR003.F59F.V022.bin"
TAG = fw59_build.TAG
BT = 0x5C5B6
BT_BYTES = bytes.fromhex("1708")
NOP = bytes.fromhex("006c")


def build():
    img = bytearray(SRC.read_bytes())
    old = bytes(img)
    if img[TAG] != b"DMR003.F59D.V022":
        raise SystemExit("tag")
    if img[BT:BT + 2] != BT_BYTES:
        raise SystemExit("bt %s" % img[BT:BT + 2].hex())
    img[BT:BT + 2] = NOP
    if literal_guard.covered_loads(old, bytes(img))[1]:
        raise SystemExit("load guard")
    if literal_guard.covered_branches(old, bytes(img))[1]:
        raise SystemExit("branch guard")
    if literal_guard.never_written(old, bytes(img)):
        raise SystemExit("never-write")
    pointed = literal_guard.pointed_into(old, bytes(img))
    if pointed:
        raise SystemExit("pointed %s" % [hex(p) for p in pointed[:8]])
    if space_map.outside_free(old, bytes(img)):
        raise SystemExit("space")
    img[TAG] = b"DMR003.F59F.V022"
    DEST.write_bytes(img)
    print(DEST.name)
    print(hashlib.sha256(bytes(img)).hexdigest())
    return DEST


if __name__ == "__main__":
    build()
