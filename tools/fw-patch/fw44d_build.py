# FW44-D: FW44, plus a breadcrumb in 0xE9C.
#
# 0xE9C has no loop and no delay. The call that can fail to return is
# 0x1924, which passes r0=0x390D4, r1=0 and a stack slot to ROM
# 0xFCFF8268. Reaching that call stores 4 at 0x4B044 and returns
# without entering ROM. Reaching 0xE64 stores 2 first, then calls it.
# Opcode 14's window is [0x30000, 0x50000) so the byte can be read.
import hashlib
import struct
from pathlib import Path

import fw30_build
import literal_guard

ROOT = Path(__file__).resolve().parents[2]
SRC = ROOT / "radio_firmware" / "build" / "DMR003.FW44.V022.bin"
DEST = ROOT / "radio_firmware" / "build" / "DMR003.F44D.V022.bin"
TAG = slice(0x38464, 0x38474)
GIVE = 0x5B700
GIVE_END = 0x5B720
LIVE = 0x5B720
MARK_E64 = 0xEBA
SKIP_A = 0xF12
SKIP_B = 0x7E22
ROM = 0x1924
E64 = 0xE64
OBJDUMP = Path(r"C:\Users\Joshua\tools\csky-elfabiv2\bin\csky-elfabiv2-objdump.exe")
LO = 0x5C0CE
HI = 0x5C0D6
OBJDUMP = Path(r"C:\Users\Joshua\tools\csky-elfabiv2\bin\csky-elfabiv2-objdump.exe")

ASM = """
	.text
	.global	skip
	.global	mark
skip:
	movih	r3, 4
	ori	r3, r3, 0xb044
	movi	r2, 4
	st.b	r2, (r3, 0)
	jmp	r15
mark:
	movih	r3, 4
	ori	r3, r3, 0xb044
	movi	r2, 2
	st.b	r2, (r3, 0)
	.long	0xbbccddee
	jmp	r15
"""


def build():
    img = bytearray(SRC.read_bytes())
    old = bytes(img)
    if img[TAG] != b"DMR003.FW44.V022":
        raise SystemExit("tag")
    if img[LIVE:LIVE + 2] != bytes.fromhex("d414"):
        raise SystemExit("live push")
    for pc, pool in literal_guard.literal_loads(old):
        if GIVE <= pool < GIVE_END and not (GIVE <= pc < GIVE_END):
            raise SystemExit("live pool %X from %X" % (pool, pc))
    for pc, _length, target in literal_guard.branch_targets(old):
        if GIVE <= target < LIVE:
            raise SystemExit("branch %X -> %X" % (pc, target))
    for at, dest in ((SKIP_A, ROM), (SKIP_B, ROM), (MARK_E64, E64)):
        if fw30_build.bsr_target(img, at) != dest:
            raise SystemExit("site %X -> %X" % (at, fw30_build.bsr_target(img, at)))
    code = bytearray(fw30_build._linked(ASM, GIVE, "fw44d"))
    slot = code.find(struct.pack("<I", 0xBBCCDDEE))
    if slot < 0:
        raise SystemExit("slot")
    code[slot:slot + 4] = fw30_build.encode_bsr(GIVE + slot, E64)
    if len(code) > GIVE_END - GIVE:
        raise SystemExit("stub %d" % len(code))
    elf = Path(r"C:\Users\Joshua\AppData\Local\Temp\fw1718\fw30\fw44d.elf")
    sym = {}
    import subprocess
    nm = Path(r"C:\Users\Joshua\tools\csky-elfabiv2\bin\csky-elfabiv2-nm.exe")
    for line in subprocess.check_output([str(nm), str(elf)], text=True).splitlines():
        parts = line.split()
        if len(parts) >= 3 and parts[2] in ("skip", "mark"):
            sym[parts[2]] = int(parts[0], 16)
    img[GIVE:GIVE + len(code)] = code
    img[SKIP_A:SKIP_A + 4] = fw30_build.encode_bsr(SKIP_A, sym["skip"])
    img[SKIP_B:SKIP_B + 4] = fw30_build.encode_bsr(SKIP_B, sym["skip"])
    img[MARK_E64:MARK_E64 + 4] = fw30_build.encode_bsr(MARK_E64, sym["mark"])
    if img[LO:LO + 4] != bytes.fromhex("21ea0018") or img[HI:HI + 4] != bytes.fromhex("21ea0118"):
        raise SystemExit("window %s %s" % (img[LO:LO + 4].hex(), img[HI:HI + 4].hex()))
    img[LO:LO + 4] = bytes.fromhex("21ea0300")
    img[HI:HI + 4] = bytes.fromhex("21ea0500")
    if fw30_build.bsr_target(img, GIVE + slot) != E64:
        raise SystemExit("mark call")
    if fw30_build.bsr_target(img, SKIP_A) != sym["skip"]:
        raise SystemExit("skip a")
    if literal_guard.covered_loads(old, bytes(img))[1]:
        raise SystemExit("load guard")
    if literal_guard.covered_branches(old, bytes(img))[1]:
        raise SystemExit("branch guard")
    if literal_guard.never_written(old, bytes(img)):
        raise SystemExit("never-write")
    img[TAG] = b"DMR003.F44D.V022"
    DEST.write_bytes(img)
    print(DEST.name)
    print(hashlib.sha256(bytes(img)).hexdigest())
    print("skip", hex(sym["skip"]), "mark", hex(sym["mark"]), "len", len(code))
    dump = subprocess.check_output(
        [str(OBJDUMP), "-b", "binary", "-m", "csky", "-D",
         "--start-address=0x5B700", "--stop-address=0x5B720", str(DEST)],
        text=True, errors="replace")
    print(dump)


if __name__ == "__main__":
    build()
