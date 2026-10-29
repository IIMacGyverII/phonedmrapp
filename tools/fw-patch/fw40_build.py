# FW40: FW38, plus the stock TX-stop pair at the post-unkey hook.
#
# A symbol-mode 0x26 key stores 0 at 0x38908+0xA. The idle task at 0x63C
# only clears the channel-write busy byte 0x32457 when that flag is not 0
# and 0x38908+0xB counts down to 100. The stock status-4 path (0x85A) is
# what leaves A = 1 and B = 200. The symbol unkey sets B = 200 and the
# word at 0x32458 to 0, and leaves A at 0, so the next channel write's
# busy flag stays set. The plain FM unkey (0x38874 == 0) writes none of
# the three.
#
# The stores sit in restore, immediately before its pop, which is the
# post-unkey hook. r2 and r4 are still the caller's until the first
# instruction, so the new stores are after that and after the register
# restores. FW39's ring and flag clears are not in this image.
import hashlib
import struct
import subprocess
from pathlib import Path

import fw30_build
import literal_guard

ROOT = Path(__file__).resolve().parents[2]
SRC = ROOT / "radio_firmware" / "build" / "DMR003.FW37.V022.bin"
DEST = ROOT / "radio_firmware" / "build" / "DMR003.FW40.V022.bin"
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
NM = Path(r"C:\Users\Joshua\tools\csky-elfabiv2\bin\csky-elfabiv2-nm.exe")
OBJDUMP = Path(r"C:\Users\Joshua\tools\csky-elfabiv2\bin\csky-elfabiv2-objdump.exe")

ASM = """
	.text
	.global	save
	.global	restore
save:
	lrw	r2, 0x11000104
	ld.w	r0, (r2, 0)
	lrw	r3, 0x32520
	st.w	r0, (r3, 0)
	lrw	r2, 0x11000100
	ld.w	r0, (r2, 0)
	lrw	r3, 0x32680
	st.w	r0, (r3, 0)
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
	lrw	r3, 0x32680
	ld.w	r0, (r3, 0)
	lrw	r3, 0x11000100
	st.w	r0, (r3, 0)
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
"""


def symbols(path):
    out = subprocess.check_output([str(NM), str(path)], text=True)
    found = {}
    for line in out.splitlines():
        parts = line.split()
        if len(parts) >= 3 and parts[2] in ("save", "restore"):
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
    for addr in (WORK_SAVE, BAND_SAVE):
        if old.find(struct.pack("<I", addr)) >= 0:
            raise SystemExit("sram literal %X" % addr)
    entries = outside_entries(old)
    expect = [(0x5BCB2, 4, RECLAIM), (0x5C55A, 4, RECLAIM), (0x5C57A, 4, 0x5BD46)]
    if entries != expect:
        raise SystemExit("callers %s" % [(hex(p), n, hex(t)) for p, n, t in entries])
    if img[HELPER:HELPER + 2] == b"\x00\x00":
        raise SystemExit("helper empty")
    code = fw30_build._linked(ASM, RECLAIM, "fw40")
    elf = Path(r"C:\Users\Joshua\AppData\Local\Temp\fw1718\fw30\fw40.elf")
    sym = symbols(elf)
    save_at = sym["save"]
    restore_at = sym["restore"]
    if save_at == RECLAIM:
        pad_ok = True
    elif save_at == RECLAIM + 2 and code[:2] == b"\x00\x00":
        pad_ok = True
    else:
        pad_ok = False
    if not pad_ok:
        raise SystemExit("save at %X pad %s" % (save_at, code[:2].hex()))
    if not (RECLAIM < restore_at < RECLAIM_END):
        raise SystemExit("restore %X" % restore_at)
    need = (0x11000104, 0x32520, 0x11000100, WORK_SAVE, 0x11000500, BAND_SAVE, 0x38908)
    for word in need:
        if struct.pack("<I", word) not in code:
            raise SystemExit("missing literal %X" % word)
    if RECLAIM + len(code) > RECLAIM_END:
        raise SystemExit("stub %d ends %X" % (len(code), RECLAIM + len(code)))
    # The pop is 16-bit 0x1494, stored little-endian as 94 14, and the
    # A/B stores are the two st.b immediates 0xA and 0xB in that tail.
    if b"\x94\x14" not in code:
        raise SystemExit("pop")
    img[RECLAIM:RECLAIM + len(code)] = code
    if RECLAIM + len(code) < RECLAIM_END:
        img[RECLAIM + len(code):RECLAIM_END] = b"\x00" * (RECLAIM_END - RECLAIM - len(code))
    img[CALL:CALL + 4] = fw30_build.encode_bsr(CALL, save_at)
    img[HOOK:HOOK + 4] = fw30_build.encode_br(HOOK, restore_at)
    for site in CALLERS:
        img[site:site + 4] = fw30_build.encode_br(site, UNSUPPORTED)
    if img[CALL + 4:CALL + 8] != old[CALL + 4:CALL + 8]:
        raise SystemExit("store moved")
    if img[RECLAIM_END:HELPER + 16] != old[RECLAIM_END:HELPER + 16]:
        raise SystemExit("reply or helper")
    if img[OLD_SAVE:OLD_SAVE + 32] != old[OLD_SAVE:OLD_SAVE + 32]:
        raise SystemExit("old slot")
    if img[0x35F64:0x35F64 + 16] != old[0x35F64:0x35F64 + 16]:
        raise SystemExit("data table")
    for start, end in ((0x5C54C, 0x5C556), (0x5C560, 0x5C576), (0x5B2AC, 0x5B300)):
        if img[start:end] != old[start:end]:
            raise SystemExit("live hold %X" % start)
    changed = [i for i, (a, c) in enumerate(zip(old, img)) if a != c]
    allowed = set()
    for start, end in (
        (CALL, CALL + 4), (HOOK, HOOK + 4), (RECLAIM, RECLAIM_END),
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
    want_in = {(CALL, save_at), (HOOK, restore_at)}
    got_in = {(pc, target) for pc, _length, target in new_entries}
    if got_in != want_in:
        raise SystemExit("entries %s" % [(hex(p), hex(t)) for p, t in sorted(got_in)])
    img[TAG] = b"DMR003.FW40.V022"
    DEST.write_bytes(img)
    print(DEST.name)
    print(hashlib.sha256(bytes(img)).hexdigest())
    print("bytes", len(code), "save", hex(save_at), "restore", hex(restore_at))
    dump = subprocess.check_output(
        [str(OBJDUMP), "-b", "binary", "-m", "csky", "-D",
         "--start-address=0x%X" % restore_at, "--stop-address=0x%X" % RECLAIM_END,
         str(DEST)],
        text=True, errors="replace")
    print(dump)
    if "st.b" not in dump or "0xa" not in dump or "0xb" not in dump:
        raise SystemExit("stores missing from dump")


if __name__ == "__main__":
    build()
