# FW48-L: FW46 plus an entry log on 0xE9C. No store to 0x38875.
# The ring is BSS at 0x4D900, inside the opcode 14 window and inside the
# startup zero (0x31AF4..0x4DAB0), after the named word at 0x4D848 and
# before the live words at 0x4DAA4. Eight entries of {lr, r1, r0, tick}.
# tick is the call count (the OS tick is inside the ROM delay). The byte
# at 0x4D984+slot is 0xE64's return with bit 7 set, or 0 if that call
# skipped 0xE64. The old drop_ptt at 0x5B65A has no caller in this image.
# The 32 bytes at 0x5B700 are the same hole FW48 used. 0x5B720 stays.
import hashlib
import struct
import subprocess
from pathlib import Path

import fw30_build
import literal_guard

ROOT = Path(__file__).resolve().parents[2]
SRC = ROOT / "radio_firmware" / "build" / "DMR003.FW46.V022.bin"
DEST = ROOT / "radio_firmware" / "build" / "DMR003.F48L.V022.bin"
TAG = slice(0x38464, 0x38474)
LOG = 0x5B65A
LOG_END = 0x5B690
WRAP = 0x5B700
WRAP_END = 0x5B720
LIVE = 0x5B720
HOOK = 0xE9E
E64_SITE = 0xEBA
E64 = 0xE64
LO = 0x5C0CE
HI = 0x5C0D6
OBJDUMP = Path(r"C:\Users\Joshua\tools\csky-elfabiv2\bin\csky-elfabiv2-objdump.exe")

# r14 still holds push r4-r6,r15, so the caller's lr is at r14+12.
# Return to 0xEA2, which stores r3 at (r14,0). r3 is 0 and r14 is
# already subtracted by 4. r0 and r1 are the caller's arguments.
LOG_ASM = """
	.text
	.global	log_e9c
log_e9c:
	ld.w	r2, (r14, 12)
	movih	r3, 0x4d
	ori	r3, r3, 0x900
	ld.w	r4, (r3, 0)
	addi	r4, 1
	st.w	r4, (r3, 0)
	subi	r4, 1
	andi	r4, r4, 7
	lsli	r4, r4, 4
	addu	r4, r3
	addi	r4, 4
	st.w	r2, (r4, 0)
	st.w	r1, (r4, 4)
	st.w	r0, (r4, 8)
	ld.w	r2, (r3, 0)
	st.w	r2, (r4, 12)
	subi	r14, 4
	movi	r3, 0
	jmp	r15
"""

# Bit 7 set means 0xE64 ran. r0 stays the value 0xE9C tests.
WRAP_ASM = """
	.text
	.global	log_e64
log_e64:
	push	r4, r15
	.long	0xbbccddee
	lrw	r3, 0x4d900
	ld.w	r4, (r3, 0)
	subi	r4, 1
	andi	r4, r4, 7
	addu	r4, r3
	movi	r2, 128
	or	r2, r0
	addi	r4, 132
	st.b	r2, (r4, 0)
	pop	r4, r15
"""


def build():
    img = bytearray(SRC.read_bytes())
    old = bytes(img)
    if img[TAG] != b"DMR003.FW46.V022":
        raise SystemExit("tag")
    if img[LIVE:LIVE + 2] != bytes.fromhex("d414"):
        raise SystemExit("live")
    if img[HOOK:HOOK + 4] != bytes.fromhex("21140033"):
        raise SystemExit("hook %s" % img[HOOK:HOOK + 4].hex())
    if fw30_build.bsr_target(img, E64_SITE) != E64:
        raise SystemExit("e64 site")
    if img[LO:LO + 4] != bytes.fromhex("21ea0018"):
        raise SystemExit("lo")
    if img[HI:HI + 4] != bytes.fromhex("21ea0118"):
        raise SystemExit("hi")
    for pc, pool in literal_guard.literal_loads(old):
        if LOG <= pool < LOG_END and not (LOG <= pc < LOG_END):
            raise SystemExit("log pool")
        if WRAP <= pool < WRAP_END and not (WRAP <= pc < WRAP_END):
            raise SystemExit("wrap pool")
    for pc, _length, target in literal_guard.branch_targets(old):
        if LOG <= target < LIVE and not (LOG <= pc < LIVE):
            raise SystemExit("branch %X" % target)
    log = bytearray(fw30_build._linked(LOG_ASM, LOG, "fw48l_log"))
    if len(log) > LOG_END - LOG:
        raise SystemExit("log %d" % len(log))
    wrap = bytearray(fw30_build._linked(WRAP_ASM, WRAP, "fw48l_wrap"))
    slot = wrap.find(struct.pack("<I", 0xBBCCDDEE))
    if slot < 0 or len(wrap) > WRAP_END - WRAP:
        raise SystemExit("wrap %d" % len(wrap))
    wrap[slot:slot + 4] = fw30_build.encode_bsr(WRAP + slot, E64)
    img[LOG:LOG + len(log)] = log
    img[WRAP:WRAP + len(wrap)] = wrap
    img[HOOK:HOOK + 4] = fw30_build.encode_bsr(HOOK, LOG)
    img[E64_SITE:E64_SITE + 4] = fw30_build.encode_bsr(E64_SITE, WRAP)
    img[LO:LO + 4] = bytes.fromhex("21ea0300")
    img[HI:HI + 4] = bytes.fromhex("21ea0500")
    if img[LIVE:LIVE + 2] != bytes.fromhex("d414"):
        raise SystemExit("live moved")
    if literal_guard.covered_loads(old, bytes(img))[1]:
        raise SystemExit("load guard")
    if literal_guard.covered_branches(old, bytes(img))[1]:
        raise SystemExit("branch guard")
    if literal_guard.never_written(old, bytes(img)):
        raise SystemExit("never-write")
    img[TAG] = b"DMR003.F48L.V022"
    DEST.write_bytes(img)
    print(DEST.name)
    print(hashlib.sha256(bytes(img)).hexdigest())
    print("log", len(log), "wrap", len(wrap))
    dump = subprocess.check_output(
        [str(OBJDUMP), "-b", "binary", "-m", "csky", "-D",
         "--start-address=0x5B65A", "--stop-address=0x5B720", str(DEST)],
        text=True, errors="replace")
    print(dump)
    if "jmp" not in dump or "bsr" not in dump:
        raise SystemExit("asm")


if __name__ == "__main__":
    build()
