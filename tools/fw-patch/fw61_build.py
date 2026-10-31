# FW61: FW57 plus the FW59 hold guard, and nothing else.
# The guard bytes are the FW59 image from 0x5C5EA through 0x5C611,
# and the six literal words at 0x5C61C. The All-Call store in front of
# that block is not copied. No (A), no (A'), no (B), no (D).
import hashlib
import struct
from pathlib import Path

import fw30_build
import fw58_build
import fw59_build

ROOT = Path(__file__).resolve().parents[2]
SRC = ROOT / "radio_firmware" / "build" / "DMR003.FW57.V022.bin"
GUARD = ROOT / "radio_firmware" / "build" / "DMR003.FW59.V022.bin"
DEST = ROOT / "radio_firmware" / "build" / "DMR003.FW61.V022.bin"
TAG = fw58_build.TAG
CODE_LO = 0x5C5EA
CODE_HI = 0x5C612
POOL_LO = 0x5C61C
POOL_HI = 0x5C634
APPLY = 0x5C5EA
RELEASE = 0x5C5FC
HOOKS = ((0x5B2D2, APPLY), (0x5BD36, RELEASE))
POOLS = (
    (0x5C61C, 0x0004B008),
    (0x5C620, 0x484F4C44),
    (0x5C624, 0x030752D6),
    (0x5C628, 0x0004B000),
    (0x5C62C, 0x11000100),
    (0x5C630, 0x03075D3E),
)


def changed_runs(old, new):
    runs = []
    limit = min(len(old), len(new))
    i = 0
    while i < limit:
        if old[i] == new[i]:
            i += 1
            continue
        j = i + 1
        while j < limit and old[j] != new[j]:
            j += 1
        runs.append((i, j))
        i = j
    return runs


def build():
    img = bytearray(SRC.read_bytes())
    old = bytes(img)
    guard = GUARD.read_bytes()
    if img[TAG] != b"DMR003.FW57.V022":
        raise SystemExit("tag")
    if guard[TAG] != b"DMR003.FW59.V022":
        raise SystemExit("fw59 tag")
    if fw58_build._br_target(guard, 0x5B2D2) != APPLY:
        raise SystemExit("fw59 apply")
    if fw58_build._br_target(guard, 0x5BD36) != RELEASE:
        raise SystemExit("fw59 release")
    for at, word in POOLS:
        if struct.unpack_from("<I", guard, at)[0] != word:
            raise SystemExit("pool %X" % at)
    for site, _target in HOOKS:
        if img[site:site + 4] != fw58_build.OLD_HOOK[site]:
            raise SystemExit("site %X" % site)
    img[CODE_LO:CODE_HI] = guard[CODE_LO:CODE_HI]
    img[POOL_LO:POOL_HI] = guard[POOL_LO:POOL_HI]
    for site, target in HOOKS:
        img[site:site + 4] = fw30_build.encode_br(site, target)
        if fw58_build._br_target(img, site) != target:
            raise SystemExit("hook %X" % site)
    if img[0x26F24:0x26F28] != old[0x26F24:0x26F28]:
        raise SystemExit("rx hook")
    if img[0x11D18:0x11D1C] != old[0x11D18:0x11D1C] or img[0x11D80:0x11D84] != old[0x11D80:0x11D84]:
        raise SystemExit("allcall hook")
    if img[0x5C59C:CODE_LO] != old[0x5C59C:CODE_LO]:
        raise SystemExit("allcall store")
    if img[CODE_HI:POOL_LO] != old[CODE_HI:POOL_LO]:
        raise SystemExit("gap")
    fw59_build._guards(old, bytes(img), True)
    img[TAG] = b"DMR003.FW61.V022"
    DEST.write_bytes(img)
    print(DEST.name)
    print(hashlib.sha256(bytes(img)).hexdigest())
    for start, end in changed_runs(old, bytes(img)):
        if start == TAG.start:
            continue
        print("diff %X-%X (%d)" % (start, end, end - start))
    return DEST


if __name__ == "__main__":
    build()
