# Read-only scan of the factory image for a sender of command 0x36.
import sys
from pathlib import Path

img = Path(r"D:\Documents\code\personal\phonedmrapp\radio_firmware\DMR003.UV4T.V022-ORIGINAL.bin").read_bytes()
XIP = 0x0301A000
IRAM_FILE, IRAM_RUN = 0x39408, 0x10000


def bsr_disp(at):
    hi = int.from_bytes(img[at:at + 2], "little")
    lo = int.from_bytes(img[at + 2:at + 4], "little")
    word = (hi << 16) | lo
    if word >> 26 != 0b111000:
        return None
    off = (word & 0x3FFFFFF) << 1
    if off & (1 << 26):
        off -= 1 << 27
    return off


def file_target(at):
    disp = bsr_disp(at)
    if disp is None:
        return None
    if at < IRAM_FILE:
        pc = XIP + at
        return (pc + disp - XIP) & 0xFFFFFFFF
    pc = IRAM_RUN + (at - IRAM_FILE)
    run = (pc + disp) & 0xFFFFFFFF
    if XIP <= run < XIP + len(img):
        return run - XIP
    if IRAM_RUN <= run < IRAM_RUN + (0x5AEFC - IRAM_FILE):
        return IRAM_FILE + (run - IRAM_RUN)
    return None


# 16-bit movi rd, imm8: 0x3000 | (rd << 8) | imm
hits = []
for at in range(0, len(img) - 1, 2):
    hw = int.from_bytes(img[at:at + 2], "little")
    if hw == 0x3036:  # movi r0, 0x36
        hits.append(at)
print("movi r0, 0x36:", " ".join("0x%X" % h for h in hits))

want = {0x8E80, 0x8E5C, 0x901C, 0x9120, 0x7DE8, 0x7D94}
calls = {t: [] for t in want}
for at in range(0, len(img) - 3, 2):
    tgt = file_target(at)
    if tgt in calls:
        calls[tgt].append(at)
for t, sites in calls.items():
    print("bsr -> +0x%X (%d)" % (t, len(sites)))
    print(" ", " ".join("0x%X" % s for s in sites[:40]))
