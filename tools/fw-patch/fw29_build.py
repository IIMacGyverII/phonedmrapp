# Build DMR003.FW29.V022 from FW28. The file does not grow.
#
# FW28 put FW26's dispatcher back at 0x5B81A..0x5B875 and left three FW27
# branches aimed at that range. 0x5B2BE is the op 6 handler's non-zero
# value path, not a variant-6-only entry: variants 3, 4 and 5 with a
# value of 1 reach it and must fall through to 0x5B2C2, so those four
# bytes are FW26's compare again (value 1 continues, any other value
# takes the stock reject). Variant 6 is then refused at the trampoline.
# 0x5C564 is that trampoline's variant-6 arm; it branches to the existing
# sr=1 tail at 0x5C584 (jmp to file 0x5B308, movi r1,1, reply). 0x5BCAE
# is the opcode gate's r3==6 and not-variant-5 arm. The gate is entered
# only for opcodes 8 and above, so variants 3 and 4 never reach it. It
# takes the same sr=1 tail instead of the dispatcher epilogue.
import hashlib
from pathlib import Path

import fw27_build

ROOT = Path(__file__).resolve().parents[2]
BUILD = ROOT / "radio_firmware" / "build"
FW26 = BUILD / "DMR003.FW26.V022.bin"
FW28 = BUILD / "DMR003.FW28.V022.bin"
DEST = BUILD / "DMR003.FW29.V022.bin"
TAG = range(0x38464, 0x38474)
VALUE = range(0x5B2BE, 0x5B2C2)
GATE = 0x5BCAE
TRAMP = 0x5C564
REJECT = 0x5C584
# The stock dispatcher branches into the restored exit. FW28's build
# leaves them, and they land on the bytes they were written for.
RESTORED_EXIT = (
    (0x5B7EE, 0x5B864),
    (0x5B7FC, 0x5B864),
    (0x5B814, 0x5B848),
    (0x5B820, 0x5B838),
    (0x5B826, 0x5B838),
    (0x5B832, 0x5B864),
    (0x5B842, 0x5B864),
    (0x5B24E, 0x5B2BE),
)


def build():
    base = FW28.read_bytes()
    old = FW26.read_bytes()
    if base[TAG.start:TAG.stop] != b"DMR003.FW28.V022":
        raise SystemExit("FW28 tag " + base[TAG.start:TAG.stop].decode("ascii", "replace"))
    img = bytearray(base)
    img[VALUE.start:VALUE.stop] = old[VALUE.start:VALUE.stop]
    img[TRAMP:TRAMP + 4] = fw27_build.encode_br(TRAMP, REJECT)
    img[GATE:GATE + 4] = fw27_build.encode_br(GATE, REJECT)
    img[TAG.start:TAG.stop] = b"DMR003.FW29.V022"
    DEST.write_bytes(img)
    print(DEST)
    print(hashlib.sha256(img).hexdigest())
    return bytes(img)


if __name__ == "__main__":
    build()
