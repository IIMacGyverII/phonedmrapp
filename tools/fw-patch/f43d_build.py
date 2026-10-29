# F43D: FW43 with opcode 14's window [0x30000, 0x11020000).
# Diagnostic only. One window has to cover both 0x38875 and
# 0x1100156C. The FW41 bounds are 0x1800 and 0x1801.
import hashlib
import subprocess
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
SRC = ROOT / "radio_firmware" / "build" / "DMR003.FW43.V022.bin"
DEST = ROOT / "radio_firmware" / "build" / "DMR003.F43D.V022.bin"
TAG = slice(0x38464, 0x38474)
LO = 0x5C0CE
HI = 0x5C0D6
OBJDUMP = Path(r"C:\Users\Joshua\tools\csky-elfabiv2\bin\csky-elfabiv2-objdump.exe")


def build():
    img = bytearray(SRC.read_bytes())
    if img[TAG] != b"DMR003.FW43.V022":
        raise SystemExit("tag")
    if img[LO:LO + 4] != bytes.fromhex("21ea0018"):
        raise SystemExit("lo %s" % img[LO:LO + 4].hex())
    if img[HI:HI + 4] != bytes.fromhex("21ea0118"):
        raise SystemExit("hi %s" % img[HI:HI + 4].hex())
    img[LO:LO + 4] = bytes.fromhex("21ea0300")
    img[HI:HI + 4] = bytes.fromhex("21ea0211")
    img[TAG] = b"DMR003.F43D.V022"
    DEST.write_bytes(img)
    print(DEST.name)
    print(hashlib.sha256(bytes(img)).hexdigest())
    dump = subprocess.check_output(
        [str(OBJDUMP), "-b", "binary", "-m", "csky", "-D",
         "--start-address=0x5C0C0", "--stop-address=0x5C0F0", str(DEST)],
        text=True, errors="replace")
    print(dump)
    if "movih" not in dump:
        raise SystemExit("movih")


if __name__ == "__main__":
    build()
