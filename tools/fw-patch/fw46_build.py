# FW46: FW45's removed call put back as 0xE9C(r0, 0), the stock unkey.
# FW45 left 0x38875 at 1. The second 0xE9C(1) is not restored.
import hashlib
import subprocess
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
SRC = ROOT / "radio_firmware" / "build" / "DMR003.FW45.V022.bin"
DEST = ROOT / "radio_firmware" / "build" / "DMR003.FW46.V022.bin"
TAG = slice(0x38464, 0x38474)
MOV = 0x5B756
CALL = 0x5B758
OBJDUMP = Path(r"C:\Users\Joshua\tools\csky-elfabiv2\bin\csky-elfabiv2-objdump.exe")


def build():
    img = bytearray(SRC.read_bytes())
    if img[TAG] != b"DMR003.FW45.V022":
        raise SystemExit("tag")
    if img[MOV:MOV + 2] != bytes.fromhex("0131"):
        raise SystemExit("movi")
    if img[CALL:CALL + 4] != bytes.fromhex("036c036c"):
        raise SystemExit("nop")
    img[MOV:MOV + 2] = bytes.fromhex("0031")
    img[CALL:CALL + 4] = bytes.fromhex("fde3a22b")
    img[TAG] = b"DMR003.FW46.V022"
    DEST.write_bytes(img)
    print(DEST.name)
    print(hashlib.sha256(bytes(img)).hexdigest())
    dump = subprocess.check_output(
        [str(OBJDUMP), "-b", "binary", "-m", "csky", "-D",
         "--start-address=0x5B754", "--stop-address=0x5B760", str(DEST)],
        text=True, errors="replace")
    print(dump)
    if "movi" not in dump or "bsr" not in dump:
        raise SystemExit("asm")


if __name__ == "__main__":
    build()
