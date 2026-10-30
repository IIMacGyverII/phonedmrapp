# FW57: FW54, with the analog wrapper calling fw22_gate directly.
#
# Since FW3F the wrapper at 0x5BDEC pushes r15 and then calls the gate.
# The gate's skip path pops five words, so every analog key with nothing
# queued returns to the wrong address. Eight bytes at 0x5BDF4 become
# br 0x5BBE2; nop; nop. The gate then runs in on_key's frame.
# 0x5BDFC, the bez target, stays. No new space, no gate, no arm.
import hashlib
from pathlib import Path

import fw30_build
import literal_guard
import space_map

ROOT = Path(__file__).resolve().parents[2]
SRC = ROOT / "radio_firmware" / "build" / "DMR003.FW54.V022.bin"
DEST = ROOT / "radio_firmware" / "build" / "DMR003.FW57.V022.bin"
TAG = slice(0x38464, 0x38474)
SITE = 0x5BDF4
OLD = bytes.fromhex("d014ffe3f6fe9014")
NEW = fw30_build.encode_br(SITE, 0x5BBE2) + bytes.fromhex("036c036c")


def build():
    img = bytearray(SRC.read_bytes())
    old = bytes(img)
    if img[TAG] != b"DMR003.FW54.V022":
        raise SystemExit("tag")
    if img[SITE:SITE + 8] != OLD:
        raise SystemExit("wrapper")
    if NEW != bytes.fromhex("00e8f7fe036c036c"):
        raise SystemExit("encoding")
    img[SITE:SITE + 8] = NEW
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
    img[TAG] = b"DMR003.FW57.V022"
    DEST.write_bytes(img)
    print(DEST.name)
    print(hashlib.sha256(bytes(img)).hexdigest())
    return DEST
