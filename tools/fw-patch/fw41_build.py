# FW41: FW40, plus WORK_MODE ownership.
#
# Op 6 mode 3 action 1 saves WORK_MODE at 0x4B000 and stores 0x80.
# Mode 3 action 0 writes AT1846S 0x58 = 0x8405 and clears the marker
# at 0x4B008. It does not write 0x4B000 back. Mode 4 action 0 does.
# FW40's key save uses 0x32680, so a key that starts under the hold
# captures 0x80 and writes it back. The two slots do not overlap.
#
# While the marker is set, the key neither saves nor restores WORK_MODE.
# Mode 3 hold-off restores 0x4B000, then joins the existing tail.
import hashlib
import struct
import subprocess
from pathlib import Path

import fw30_build
import literal_guard

ROOT = Path(__file__).resolve().parents[2]
SRC = ROOT / "radio_firmware" / "build" / "DMR003.FW37.V022.bin"
DEST = ROOT / "radio_firmware" / "build" / "DMR003.FW41.V022.bin"
TAG = slice(0x38464, 0x38474)
CALL = 0x5B592
HOOK = 0x5B770
OLD_SAVE = 0x5B700
RECLAIM = 0x5BCDA
RECLAIM_END = 0x5BD74
HELPER = 0x5BD82
UNSUPPORTED = 0x5C584
CALLERS = (0x5BCB2, 0x5C55A, 0x5C57A)
WORK_SAVE = 0x32680
BAND_SAVE = 0x32684
HOLD_AT = 0x5B250
MODE4_RESTORE = 0x5B254
MODE3_TAIL = 0x5B2A8
NM = Path(r"C:\Users\Joshua\tools\csky-elfabiv2\bin\csky-elfabiv2-nm.exe")
OBJDUMP = Path(r"C:\Users\Joshua\tools\csky-elfabiv2\bin\csky-elfabiv2-objdump.exe")

ASM = """
	.text
	.global	save
	.global	restore
	.global	hold_off
save:
	lrw	r2, 0x11000104
	ld.w	r0, (r2, 0)
	lrw	r3, 0x32520
	st.w	r0, (r3, 0)
	lrw	r2, 0x4b008
	ld.w	r0, (r2, 0)
	lrw	r2, 0x484f4c44
	cmpne	r0, r2
	bt	1f
	br	2f
1:
	lrw	r2, 0x11000100
	ld.w	r0, (r2, 0)
	lrw	r3, 0x32680
	st.w	r0, (r3, 0)
2:
	lrw	r2, 0x11000500
	ld.w	r0, (r2, 0)
	lrw	r3, 0x32684
	st.w	r0, (r3, 0)
	lrw	r2, 0x11000104
	movi	r3, 135
	jmp	r15
restore:
	st.b	r2, (r4, 5)
	lrw	r3, 0x32520
	ld.w	r0, (r3, 0)
	lrw	r3, 0x11000104
	st.w	r0, (r3, 0)
	lrw	r2, 0x4b008
	ld.w	r0, (r2, 0)
	lrw	r2, 0x484f4c44
	cmpne	r0, r2
	bt	3f
	br	4f
3:
	lrw	r3, 0x32680
	ld.w	r0, (r3, 0)
	lrw	r3, 0x11000100
	st.w	r0, (r3, 0)
4:
	lrw	r3, 0x32684
	ld.w	r0, (r3, 0)
	lrw	r3, 0x11000500
	st.w	r0, (r3, 0)
	lrw	r3, 0x38908
	movi	r2, 1
	st.b	r2, (r3, 0xa)
	movi	r2, 200
	st.b	r2, (r3, 0xb)
	pop	r4-r7, r15
hold_off:
	cmpnei	r1, 4
	bt	5f
	.long	0x11223344
5:
	lrw	r4, 0x4b000
	ld.w	r5, (r4, 0)
	lrw	r4, 0x11000100
	st.w	r5, (r4, 0)
	.long	0x55667788
"""


def symbols(path):
    out = subprocess.check_output([str(NM), str(path)], text=True)
    found = {}
    for line in out.splitlines():
        parts = line.split()
        if len(parts) >= 3 and parts[2] in ("save", "restore", "hold_off"):
            found[parts[2]] = int(parts[0], 16)
    return found


def outside_entries(blob):
    found = []
    for pc, length, target in literal_guard.branch_targets(blob):
        if RECLAIM <= target < RECLAIM_END and not (RECLAIM <= pc < RECLAIM_END):
            found.append((pc, length, target))
    return found


def build():
    img = bytearray(SRC.read_bytes())
    old = bytes(img)
    if img[TAG] != b"DMR003.FW37.V022":
        raise SystemExit("tag")
    if img[CALL:CALL + 4] != fw30_build.encode_bsr(CALL, OLD_SAVE):
        raise SystemExit("call site")
    if img[CALL + 4:CALL + 8] != bytes.fromhex("654360b2"):
        raise SystemExit("store tail")
    if img[HOOK:HOOK + 4] != fw30_build.encode_br(HOOK, 0x5B70C):
        raise SystemExit("hook")
    if img[HOLD_AT:HOLD_AT + 4] != bytes.fromhex("44392b08"):
        raise SystemExit("hold gate %s" % img[HOLD_AT:HOLD_AT + 4].hex())
    for addr in (WORK_SAVE, BAND_SAVE):
        if old.find(struct.pack("<I", addr)) >= 0:
            raise SystemExit("sram literal %X" % addr)
    entries = outside_entries(old)
    expect = [(0x5BCB2, 4, RECLAIM), (0x5C55A, 4, RECLAIM), (0x5C57A, 4, 0x5BD46)]
    if entries != expect:
        raise SystemExit("callers %s" % [(hex(p), n, hex(t)) for p, n, t in entries])
    if img[HELPER:HELPER + 2] == b"\x00\x00":
        raise SystemExit("helper empty")
    code = fw30_build._linked(ASM, RECLAIM, "fw41")
    elf = Path(r"C:\Users\Joshua\AppData\Local\Temp\fw1718\fw30\fw41.elf")
    sym = symbols(elf)
    save_at = sym["save"]
    restore_at = sym["restore"]
    hold_at = sym["hold_off"]
    if save_at == RECLAIM:
        pad_ok = True
    elif save_at == RECLAIM + 2 and code[:2] == b"\x00\x00":
        pad_ok = True
    else:
        pad_ok = False
    if not pad_ok:
        raise SystemExit("save at %X pad %s" % (save_at, code[:2].hex()))
    if not (RECLAIM < restore_at < hold_at < RECLAIM_END):
        raise SystemExit("layout %X %X %X" % (restore_at, hold_at, RECLAIM_END))
    if RECLAIM + len(code) > RECLAIM_END:
        raise SystemExit("stub %d ends %X" % (len(code), RECLAIM + len(code)))
    if b"\x94\x14" not in code:
        raise SystemExit("pop")
    mode4 = code.find(struct.pack("<I", 0x11223344))
    mode3 = code.find(struct.pack("<I", 0x55667788))
    if mode4 < 0 or mode3 < 0 or code.find(struct.pack("<I", 0x11223344), mode4 + 4) >= 0:
        raise SystemExit("placeholders")
    code = bytearray(code)
    code[mode4:mode4 + 4] = fw30_build.encode_br(RECLAIM + mode4, MODE4_RESTORE)
    code[mode3:mode3 + 4] = fw30_build.encode_br(RECLAIM + mode3, MODE3_TAIL)
    img[RECLAIM:RECLAIM + len(code)] = code
    if RECLAIM + len(code) < RECLAIM_END:
        img[RECLAIM + len(code):RECLAIM_END] = b"\x00" * (RECLAIM_END - RECLAIM - len(code))
    img[CALL:CALL + 4] = fw30_build.encode_bsr(CALL, save_at)
    img[HOOK:HOOK + 4] = fw30_build.encode_br(HOOK, restore_at)
    img[HOLD_AT:HOLD_AT + 4] = fw30_build.encode_br(HOLD_AT, hold_at)
    for site in CALLERS:
        img[site:site + 4] = fw30_build.encode_br(site, UNSUPPORTED)
    if img[CALL + 4:CALL + 8] != old[CALL + 4:CALL + 8]:
        raise SystemExit("store moved")
    if img[RECLAIM_END:HELPER + 16] != old[RECLAIM_END:HELPER + 16]:
        raise SystemExit("reply or helper")
    if img[OLD_SAVE:OLD_SAVE + 32] != old[OLD_SAVE:OLD_SAVE + 32]:
        raise SystemExit("old slot")
    for start, end in ((0x5C54C, 0x5C556), (0x5C560, 0x5C576), (0x5B254, 0x5B300)):
        if img[start:end] != old[start:end]:
            raise SystemExit("live hold %X" % start)
    changed = [i for i, (a, c) in enumerate(zip(old, img)) if a != c]
    allowed = set()
    for start, end in (
        (CALL, CALL + 4), (HOOK, HOOK + 4), (HOLD_AT, HOLD_AT + 4), (RECLAIM, RECLAIM_END),
    ):
        allowed.update(range(start, end))
    for site in CALLERS:
        allowed.update(range(site, site + 4))
    stray = [hex(i) for i in changed if i not in allowed]
    if stray:
        raise SystemExit("stray %s" % stray[:8])
    if literal_guard.covered_loads(old, bytes(img))[1]:
        raise SystemExit("load guard %s" % literal_guard.covered_loads(old, bytes(img))[1][:6])
    if literal_guard.covered_branches(old, bytes(img))[1]:
        raise SystemExit("branch guard %s" % literal_guard.covered_branches(old, bytes(img))[1][:6])
    if literal_guard.never_written(old, bytes(img)):
        raise SystemExit("never-write")
    new_entries = outside_entries(bytes(img))
    want_in = {(CALL, save_at), (HOOK, restore_at), (HOLD_AT, hold_at)}
    got_in = {(pc, target) for pc, _length, target in new_entries}
    if got_in != want_in:
        raise SystemExit("entries %s" % [(hex(p), hex(t)) for p, t in sorted(got_in)])
    img[TAG] = b"DMR003.FW41.V022"
    DEST.write_bytes(img)
    print(DEST.name)
    print(hashlib.sha256(bytes(img)).hexdigest())
    print("bytes", len(code), "save", hex(save_at), "restore", hex(restore_at), "hold", hex(hold_at))
    dump = subprocess.check_output(
        [str(OBJDUMP), "-b", "binary", "-m", "csky", "-D",
         "--start-address=0x%X" % RECLAIM, "--stop-address=0x%X" % (RECLAIM + len(code)),
         str(DEST)],
        text=True, errors="replace")
    print(dump)
    def br_target(at):
        hi, lo = struct.unpack_from("<HH", img, at)
        if hi != 0xE800:
            raise SystemExit("not a br at %X (%04X)" % (at, hi))
        disp = lo - 0x10000 if lo & 0x8000 else lo
        return at + (disp << 1)

    if br_target(RECLAIM + mode4) != MODE4_RESTORE:
        raise SystemExit("mode4 branch %X" % br_target(RECLAIM + mode4))
    if br_target(RECLAIM + mode3) != MODE3_TAIL:
        raise SystemExit("mode3 branch %X" % br_target(RECLAIM + mode3))


if __name__ == "__main__":
    build()
