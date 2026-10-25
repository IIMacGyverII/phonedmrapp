"""Who calls the IRAM tune that calls at1846_set_ctcss_dcs?

Flash: file F runs at 0x0301A000+F.
IRAM: file F in [0x39408, 0x5AEFC) runs at F-0x29408.
bsr32 disp is relative to the run PC. Objdump (base 0) prints file+disp.
"""
import struct
from pathlib import Path

IMG = Path(r"D:\Documents\code\personal\phonedmrapp\radio_firmware\DMR003.UV4T.V022-ORIGINAL.bin")
img = IMG.read_bytes()
N = len(img)
FLASH_END = 0x39408
IRAM_LO, IRAM_HI = 0x39408, 0x5AEFC
XIP = 0x0301A000
IRAM_DELTA = 0x29408  # file - run

def u16(off):
    return struct.unpack_from("<H", img, off)[0]

def u32(off):
    return struct.unpack_from("<I", img, off)[0]

def run_pc(file_off):
    if file_off < FLASH_END:
        return (file_off + XIP) & 0xFFFFFFFF
    if IRAM_LO <= file_off < IRAM_HI:
        return (file_off - IRAM_DELTA) & 0xFFFFFFFF
    return None

def file_of(addr):
    if XIP <= addr < XIP + FLASH_END:
        return addr - XIP, "flash"
    if 0x10000 <= addr < 0x31AF4:
        return addr + IRAM_DELTA, "iram"
    return None, None

def bsr_disp(word):
    if word >> 26 != 0b111000:
        return None
    off = (word & 0x3FFFFFF) << 1
    if off & (1 << 26):
        off -= 1 << 27
    return off

def region(file_off):
    if file_off < FLASH_END:
        return file_off, FLASH_END
    if IRAM_LO <= file_off < IRAM_HI:
        return IRAM_LO, IRAM_HI
    return None

# Targets: run address -> name
TARGETS = {
    0x0301D2E4: "set_ctcss +0x32E4",
    0x0301D46C: "ctcss sibling +0x346C",
    0x0301CDD8: "flash tune +0x2DD8",
    0x0301D0D8: "squelch-ish +0x30D8",
    0x0301D0A4: "set_squelch +0x30A4",
    0x2B2A0: "IRAM tune +0x546A8",
    0x2B468: "IRAM tune2 +0x54870",
    0x2B5E0: "thunk tune +0x549E8",
    0x2B5D8: "thunk tune2 +0x549E0",
    0x2CA08: "fn +0x55E10 (calls tune thunk)",
    0x2C9B0: "fn +0x55DB8 (calls tune2 thunk)",
    0x2C99C: "copy176 +0x55DA4",
    0x0301CB14: "bw profile +0x2B14",
}

hits = {name: [] for name in TARGETS.values()}
jsri_hits = []
n_bsr = 0

for start, end in ((0, FLASH_END), (IRAM_LO, IRAM_HI)):
    off = start
    while off + 4 <= end:
        hw = u16(off)
        if hw & 0xC000 != 0xC000:
            off += 2
            continue
        # 32-bit candidate. Confirm it is not the second parcel of a previous
        # 32-bit insn: the linear sweep only lands here on even parcels that
        # the length rule itself produced, so this is aligned.
        word = (hw << 16) | u16(off + 2)
        disp = bsr_disp(word)
        if disp is not None:
            n_bsr += 1
            pc = run_pc(off)
            tgt = (pc + disp) & 0xFFFFFFFF
            name = TARGETS.get(tgt)
            if name:
                f, kind = file_of(tgt)
                hits[name].append((off, tgt, f, kind, f"0x{word:08X}"))
        elif word >> 26 == 0b111001:
            pc = run_pc(off)
            disp2 = (word & 0x3FFFFFF) << 1
            if disp2 & (1 << 26):
                disp2 -= 1 << 27
            tgt = (pc + disp2) & 0xFFFFFFFF
            if tgt in TARGETS:
                jsri_hits.append((off, tgt, TARGETS[tgt]))
        off += 4

print(f"bsr32 count (linear, length-aligned) {n_bsr}")
for name, rows in hits.items():
    print(f"\n== {name}: {len(rows)} callers ==")
    for off, tgt, f, kind, enc in rows:
        print(f"  file 0x{off:05X} -> run 0x{tgt:08X} ({kind} file 0x{f:05X}) {enc}")
print("\njsri hits", jsri_hits)

# Literal words (every 2 bytes) for the same run addresses and the RAM struct.
print("\n== literals ==")
want = {
    0x0002CA08: "run fn 55E10",
    0x0002C9B0: "run fn 55DB8",
    0x0002B2A0: "run IRAM tune",
    0x0002B5E0: "run thunk 549E8",
    0x0002B5D8: "run thunk 549E0",
    0x0002C99C: "run copy176",
    0x0301D2E4: "XIP set_ctcss",
    0x0301CDD8: "XIP flash tune",
    0x00038B5C: "RAM struct 0x38B5C",
    0x00032440: "RAM flag 0x32440",
    0x00038C70: "analog reply 0x38C70",
}
for off in range(0, N - 3, 2):
    w = u32(off)
    if w in want:
        print(f"  file 0x{off:05X} word 0x{w:08X} {want[w]}")

# What does the IRAM tune's tail actually call (true targets)?
print("\n== decoded IRAM bsrs of interest ==")
for off in (0x547B6, 0x547C0, 0x547C4, 0x547FA, 0x54812, 0x54816,
            0x54820, 0x548C8, 0x54904, 0x5494A, 0x549F4,
            0x55DAC, 0x55DDC, 0x55DE8, 0x55DF4, 0x55E00, 0x55E08,
            0x55E3E, 0x55E4C, 0x55E5A, 0x55E64):
    hw = u16(off)
    word = (hw << 16) | u16(off + 2)
    disp = bsr_disp(word)
    if disp is None:
        print(f"  0x{off:05X} NOT bsr {word:08X}")
        continue
    tgt = (run_pc(off) + disp) & 0xFFFFFFFF
    f, kind = file_of(tgt)
    extra = TARGETS.get(tgt, "")
    print(f"  file 0x{off:05X} -> 0x{tgt:08X} {kind} file {None if f is None else hex(f)} {extra}")
