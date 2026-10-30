# FW45-D: FW44 with opcode 14's window moved to [0xFCFF0000, 0xFD020000).
# Diagnostic only. One unsigned cmphs pair spans that range. Reads of the
# ROM the FM key calls. No skipped ROM calls.
import hashlib
import subprocess
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
SRC = ROOT / "radio_firmware" / "build" / "DMR003.FW44.V022.bin"
DEST = ROOT / "radio_firmware" / "build" / "DMR003.F45D.V022.bin"
TAG = slice(0x38464, 0x38474)
LO = 0x5C0CE
HI = 0x5C0D6
OBJDUMP = Path(r"C:\Users\Joshua\tools\csky-elfabiv2\bin\csky-elfabiv2-objdump.exe")


def build():
    img = bytearray(SRC.read_bytes())
    if img[TAG] != b"DMR003.FW44.V022":
        raise SystemExit("tag")
    if img[LO:LO + 4] != bytes.fromhex("21ea0018"):
        raise SystemExit("lo")
    if img[HI:HI + 4] != bytes.fromhex("21ea0118"):
        raise SystemExit("hi")
    img[LO:LO + 4] = bytes.fromhex("21eafffc")
    img[HI:HI + 4] = bytes.fromhex("21ea02fd")
    img[TAG] = b"DMR003.F45D.V022"
    DEST.write_bytes(img)
    print(DEST.name)
    print(hashlib.sha256(bytes(img)).hexdigest())
    dump = subprocess.check_output(
        [str(OBJDUMP), "-b", "binary", "-m", "csky", "-D",
         "--start-address=0x5C0C8", "--stop-address=0x5C0E0", str(DEST)],
        text=True, errors="replace")
    print(dump)
    if "movih" not in dump or "64767" not in dump or "64770" not in dump:
        raise SystemExit("movih")


if __name__ == "__main__":
    build()
