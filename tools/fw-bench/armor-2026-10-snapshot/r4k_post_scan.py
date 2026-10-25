# Callers of the status poster at file +0x7E08.
from pathlib import Path

img = Path(r"D:\Documents\code\personal\phonedmrapp\radio_firmware\DMR003.UV4T.V022-ORIGINAL.bin").read_bytes()
XIP = 0x0301A000
IRAM_FILE, IRAM_RUN = 0x39408, 0x10000
WANT = 0x7E08


def file_target(at):
    hi = int.from_bytes(img[at:at + 2], "little")
    lo = int.from_bytes(img[at + 2:at + 4], "little")
    word = (hi << 16) | lo
    if word >> 26 != 0b111000:
        return None
    off = (word & 0x3FFFFFF) << 1
    if off & (1 << 26):
        off -= 1 << 27
    if at < IRAM_FILE:
        pc = XIP + at
        return (pc + off - XIP) & 0xFFFFFFFF
    pc = IRAM_RUN + (at - IRAM_FILE)
    run = (pc + off) & 0xFFFFFFFF
    if XIP <= run < XIP + len(img):
        return run - XIP
    return None


sites = [at for at in range(0, len(img) - 3, 2) if file_target(at) == WANT]
print("callers", " ".join("0x%X" % s for s in sites))
for at in sites:
    window = img[max(0, at - 12):at + 4]
    print("0x%X before" % at, window.hex())
