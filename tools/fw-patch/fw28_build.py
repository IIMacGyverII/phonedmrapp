# Build DMR003.FW28.V022 from the FW27 image. The file does not grow.
#
# FW27 put op 6 variant 6 in 0x5B81A..0x5B875. Ops 8 and 9 return through
# br 0x5B864, and op 14 dispatches at 0x5B848, both inside that range, so
# those ops ran the coefficient write and never sent a reply. FW28 copies
# FW26's bytes back over that range. The op 13 redirect at 0x5B816 stays:
# it is the four bytes immediately before the range. Variant 6 is dropped.
# The stream route it served is closed.
import hashlib
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
FW26 = ROOT / "radio_firmware" / "build" / "DMR003.FW26.V022.bin"
FW27 = ROOT / "radio_firmware" / "build" / "DMR003.FW27.V022.bin"
DEST = ROOT / "radio_firmware" / "build" / "DMR003.FW28.V022.bin"
# Inclusive end 0x5B875, so the slice stops at 0x5B876.
RESTORE = range(0x5B81A, 0x5B876)
REDIRECT = range(0x5B816, 0x5B81A)
TAG = range(0x38464, 0x38474)


def build():
    old = FW26.read_bytes()
    base = FW27.read_bytes()
    if len(old) != len(base):
        raise SystemExit("length %d vs %d" % (len(old), len(base)))
    if base[TAG.start:TAG.stop] != b"DMR003.FW27.V022":
        raise SystemExit("FW27 tag " + base[TAG.start:TAG.stop].decode("ascii", "replace"))
    img = bytearray(base)
    img[RESTORE.start:RESTORE.stop] = old[RESTORE.start:RESTORE.stop]
    if img[REDIRECT.start:REDIRECT.stop] != base[REDIRECT.start:REDIRECT.stop]:
        raise SystemExit("op 13 redirect was not kept")
    if img[REDIRECT.start:REDIRECT.stop] == old[REDIRECT.start:REDIRECT.stop]:
        raise SystemExit("op 13 redirect matches FW26")
    img[TAG.start:TAG.stop] = b"DMR003.FW28.V022"
    DEST.write_bytes(img)
    print(DEST)
    print(hashlib.sha256(img).hexdigest())
    return bytes(img)


if __name__ == "__main__":
    build()
