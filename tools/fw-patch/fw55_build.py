# FW55: FW54, with the four 0x26 sites calling stock 0xE9C again.
#
# FW54 sends body 1 to 0x5B580 and body 2 to 0x5B614. Body 2 then stores
# 1 at 0x38875, and the next phone-audio key does not radiate. The first
# DMR group slot 0 key after that unkey has a carrier and no sync. The
# factory image calls 0xE9C at all four sites, and its first slot 0 key
# decodes. These four calls are restored to those factory bytes.
#
# The FW54 nops at 0x5B756 stay, so a tone key still does not call
# 0xE9C(r1=0). 0x5B700 and 0x5B74C stay FW54.
import hashlib
from pathlib import Path

import fw30_build
import literal_guard

ROOT = Path(__file__).resolve().parents[2]
SRC = ROOT / "radio_firmware" / "build" / "DMR003.FW54.V022.bin"
FAC = ROOT / "radio_firmware" / "DMR003.UV4T.V022-ORIGINAL.bin"
DEST = ROOT / "radio_firmware" / "build" / "DMR003.FW55.V022.bin"
TAG = slice(0x38464, 0x38474)
SITES = (0x92AA, 0x92C8, 0x92E0, 0x92FA)
NOPS = 0x5B756
HELPER = range(0x5B700, 0x5B720)
LIVE_UNKEY = range(0x5B74C, 0x5B756)


def build():
    img = bytearray(SRC.read_bytes())
    old = bytes(img)
    fac = FAC.read_bytes()
    if img[TAG] != b"DMR003.FW54.V022":
        raise SystemExit("tag")
    if img[NOPS:NOPS + 6] != bytes.fromhex("0131036c036c"):
        raise SystemExit("nops")
    for at in SITES:
        if fw30_build.bsr_target(fac, at) != 0xE9C:
            raise SystemExit("factory site %X" % at)
        img[at:at + 4] = fac[at:at + 4]
        if fw30_build.bsr_target(img, at) != 0xE9C:
            raise SystemExit("retarget %X" % at)
    if literal_guard.covered_loads(old, bytes(img))[1]:
        raise SystemExit("load guard")
    if literal_guard.covered_branches(old, bytes(img))[1]:
        raise SystemExit("branch guard")
    if literal_guard.never_written(old, bytes(img)):
        raise SystemExit("never-write")
    img[TAG] = b"DMR003.FW55.V022"
    DEST.write_bytes(img)
    print(DEST.name)
    print(hashlib.sha256(bytes(img)).hexdigest())
    return DEST
