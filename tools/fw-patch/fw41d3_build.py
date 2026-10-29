# FW41-D3: FW41-D2 with opcode 14's window moved to [0x11000000, 0x11010000).
# Diagnostic only. The two movih immediates at 0x5C0CE and 0x5C0D6
# were 3 and 4 on FW4E. 0x1100 and 0x1101 cover SYS_INTERP_LIST,
# SYS_INTERP_MASK and SYS_INTERP_CLEAR. FW41 puts the original
# 0x1800/0x1801 immediates back.
import hashlib
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
SRC = ROOT / "radio_firmware" / "build" / "DMR003.FW4E.V022.bin"
DEST = ROOT / "radio_firmware" / "build" / "DMR003.FW4F.V022.bin"
TAG = slice(0x38464, 0x38474)
LO = 0x5C0CE
HI = 0x5C0D6


def build():
    img = bytearray(SRC.read_bytes())
    if img[TAG] != b"DMR003.FW4E.V022":
        raise SystemExit("tag")
    if img[LO:LO + 4] != bytes.fromhex("21ea0300"):
        raise SystemExit("lo")
    if img[HI:HI + 4] != bytes.fromhex("21ea0400"):
        raise SystemExit("hi")
    img[LO:LO + 4] = bytes.fromhex("21ea0011")
    img[HI:HI + 4] = bytes.fromhex("21ea0111")
    img[TAG] = b"DMR003.FW4F.V022"
    DEST.write_bytes(img)
    print(DEST.name)
    print(hashlib.sha256(bytes(img)).hexdigest())


if __name__ == "__main__":
    build()
