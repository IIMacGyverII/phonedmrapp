# FW41-D: FW40 with opcode 14's window moved to [0x30000, 0x40000).
# Diagnostic only. The two movih immediates at 0x5C0CE and 0x5C0D6
# were 0x1800 and 0x1801 (the HR-C7000 window). 3 and 4 cover the CPU
# addresses the firmware already lrws for 0x32457, 0x32458, 0x38908
# and 0x38874. FW41 puts the original immediates back.
import hashlib
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
SRC = ROOT / "radio_firmware" / "build" / "DMR003.FW40.V022.bin"
DEST = ROOT / "radio_firmware" / "build" / "DMR003.FW4D.V022.bin"
TAG = slice(0x38464, 0x38474)
LO = 0x5C0CE
HI = 0x5C0D6


def build():
    img = bytearray(SRC.read_bytes())
    if img[TAG] != b"DMR003.FW40.V022":
        raise SystemExit("tag")
    if img[LO:LO + 4] != bytes.fromhex("21ea0018"):
        raise SystemExit("lo")
    if img[HI:HI + 4] != bytes.fromhex("21ea0118"):
        raise SystemExit("hi")
    img[LO:LO + 4] = bytes.fromhex("21ea0300")
    img[HI:HI + 4] = bytes.fromhex("21ea0400")
    img[TAG] = b"DMR003.FW4D.V022"
    DEST.write_bytes(img)
    print(DEST.name)
    print(hashlib.sha256(bytes(img)).hexdigest())


if __name__ == "__main__":
    build()
