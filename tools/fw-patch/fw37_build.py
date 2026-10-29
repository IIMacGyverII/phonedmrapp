# FW37: FW36 without the bit-7 clear. The symbol key stores RF_MODE 0x10E0
# without the stock save, and its end never reaches the stock restore, so
# the word stays 0x10E0 until a restart. This image saves the old word to
# SRAM 0x32520 just before that store, and writes it back at the same
# post-unkey hook the bit-7 clear used. The hook still does the store and
# the pop the branch replaced. Opcode 16/17 and the data-table tail stay.
import hashlib
import struct
import subprocess
from pathlib import Path

import fw30_build
import literal_guard

ROOT = Path(__file__).resolve().parents[2]
SRC = ROOT / "radio_firmware" / "build" / "DMR003.FW36.V022.bin"
DEST = ROOT / "radio_firmware" / "build" / "DMR003.FW37.V022.bin"
TAG = slice(0x38464, 0x38474)
SLOT = 0x5B700
SLOT_END = 0x5B720
HOOK = 0x5B770
CALL = 0x5B592
GATE = 0x5B720
NM = Path(r"C:\Users\Joshua\tools\csky-elfabiv2\bin\csky-elfabiv2-nm.exe")

ASM = """
	.text
	.global	save
	.global	restore
save:
	lrw	r2, 0x11000104
	ld.w	r0, (r2, 0)
	lrw	r3, 0x32520
	st.w	r0, (r3, 0)
	movi	r3, 135
	jmp	r15
restore:
	st.b	r2, (r4, 5)
	lrw	r3, 0x32520
	ld.w	r0, (r3, 0)
	lrw	r3, 0x11000104
	st.w	r0, (r3, 0)
	pop	r4-r7, r15
"""


def symbols(path):
    out = subprocess.check_output([str(NM), str(path)], text=True)
    found = {}
    for line in out.splitlines():
        parts = line.split()
        if len(parts) >= 3 and parts[2] in ("save", "restore"):
            found[parts[2]] = int(parts[0], 16)
    return found


def build():
    img = bytearray(SRC.read_bytes())
    old = bytes(img)
    if img[TAG] != b"DMR003.FW36.V022":
        raise SystemExit("tag")
    if img[CALL:CALL + 4] != bytes.fromhex("59108733"):
        raise SystemExit("call site %s" % img[CALL:CALL + 8].hex())
    if img[CALL + 4:CALL + 8] != bytes.fromhex("654360b2"):
        raise SystemExit("store tail")
    if img[HOOK:HOOK + 4] != fw30_build.encode_br(HOOK, SLOT):
        raise SystemExit("hook")
    if img[GATE:GATE + 2] != bytes.fromhex("d414"):
        raise SystemExit("gate")
    code = fw30_build._linked(ASM, SLOT, "fw37")
    elf = Path(r"C:\Users\Joshua\AppData\Local\Temp\fw1718\fw30\fw37.elf")
    sym = symbols(elf)
    save_at = sym["save"]
    restore_at = sym["restore"]
    if save_at != SLOT:
        raise SystemExit("save at %X" % save_at)
    if restore_at + 12 > SLOT_END or len(code) > SLOT_END - SLOT:
        raise SystemExit("stub %d restore %X" % (len(code), restore_at))
    img[SLOT:SLOT + len(code)] = code
    img[CALL:CALL + 4] = fw30_build.encode_bsr(CALL, save_at)
    img[HOOK:HOOK + 4] = fw30_build.encode_br(HOOK, restore_at)
    if img[CALL + 4:CALL + 8] != old[CALL + 4:CALL + 8]:
        raise SystemExit("store moved")
    if img[GATE:HOOK] != old[GATE:HOOK] or img[HOOK + 4:0x5BD74] != old[HOOK + 4:0x5BD74]:
        raise SystemExit("gate or handler")
    if img[0x35F64:0x35F64 + 16] != old[0x35F64:0x35F64 + 16]:
        raise SystemExit("data table")
    if literal_guard.covered_loads(old, bytes(img))[1]:
        raise SystemExit("load guard %s" % literal_guard.covered_loads(old, bytes(img))[1][:6])
    if literal_guard.covered_branches(old, bytes(img))[1]:
        raise SystemExit("branch guard %s" % literal_guard.covered_branches(old, bytes(img))[1][:6])
    if literal_guard.never_written(old, bytes(img)):
        raise SystemExit("never-write")
    img[TAG] = b"DMR003.FW37.V022"
    DEST.write_bytes(img)
    print(DEST.name)
    print(hashlib.sha256(bytes(img)).hexdigest())
    print("bytes", len(code), "save", hex(save_at), "restore", hex(restore_at))


if __name__ == "__main__":
    build()
