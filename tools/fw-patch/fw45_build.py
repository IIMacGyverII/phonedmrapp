# FW45: FW44 without the symbol-engine's second 0xE9C(1).
# At 0x5B758 the engine end calls 0xE9C with r1 = 1, which takes the
# semaphore at 0x390D4 again. The key-up path already took it. Two nops.
import hashlib
import subprocess
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
SRC = ROOT / "radio_firmware" / "build" / "DMR003.FW44.V022.bin"
DEST = ROOT / "radio_firmware" / "build" / "DMR003.FW45.V022.bin"
TAG = slice(0x38464, 0x38474)
CALL = 0x5B758
OBJDUMP = Path(r"C:\Users\Joshua\tools\csky-elfabiv2\bin\csky-elfabiv2-objdump.exe")
NOP = bytes.fromhex("036c")


def build():
    img = bytearray(SRC.read_bytes())
    if img[TAG] != b"DMR003.FW44.V022":
        raise SystemExit("tag")
    if img[CALL:CALL + 4] != bytes.fromhex("fde3a22b"):
        raise SystemExit("bsr %s" % img[CALL:CALL + 4].hex())
    if img[CALL - 2:CALL] != bytes.fromhex("0131"):
        raise SystemExit("r1")
    img[CALL:CALL + 2] = NOP
    img[CALL + 2:CALL + 4] = NOP
    img[TAG] = b"DMR003.FW45.V022"
    DEST.write_bytes(img)
    print(DEST.name)
    print(hashlib.sha256(bytes(img)).hexdigest())
    dump = subprocess.check_output(
        [str(OBJDUMP), "-b", "binary", "-m", "csky", "-D",
         "--start-address=0x5B750", "--stop-address=0x5B760", str(DEST)],
        text=True, errors="replace")
    print(dump)
    if "bsr" in dump.split("5b756:")[-1].split("5b75c:")[0]:
        raise SystemExit("call remains")


if __name__ == "__main__":
    build()
