# FW42-D: FW41 with opcode 14's window moved to [0x30000, 0x50000).
# Diagnostic only. The two movih immediates at 0x5C0CE and 0x5C0D6
# are 0x1800 and 0x1801 on FW41. 3 and 5 cover SRAM 0x3xxxx/0x4xxxx,
# including the stub RAM at 0x4B000.
import hashlib
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
SRC = ROOT / "radio_firmware" / "build" / "DMR003.FW41.V022.bin"
DEST = ROOT / "radio_firmware" / "build" / "DMR003.F42D.V022.bin"
TAG = slice(0x38464, 0x38474)
LO = 0x5C0CE
HI = 0x5C0D6
OBJDUMP = Path(r"C:\Users\Joshua\tools\csky-elfabiv2\bin\csky-elfabiv2-objdump.exe")


def build():
    import subprocess
    img = bytearray(SRC.read_bytes())
    if img[TAG] != b"DMR003.FW41.V022":
        raise SystemExit("tag")
    if img[LO:LO + 4] != bytes.fromhex("21ea0018"):
        raise SystemExit("lo")
    if img[HI:HI + 4] != bytes.fromhex("21ea0118"):
        raise SystemExit("hi")
    img[LO:LO + 4] = bytes.fromhex("21ea0300")
    img[HI:HI + 4] = bytes.fromhex("21ea0500")
    img[TAG] = b"DMR003.F42D.V022"
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
