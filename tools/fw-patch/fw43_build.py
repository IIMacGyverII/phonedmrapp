# FW43: FW41, plus the stock key-off at the symbol-key end.
#
# 0x5B720 calls 0xE9C with r1=1, then branches to the restore. FW42's
# raw store of 0 at 0x38875 is already 1 again before the select, so a
# later 0xE9C(1) overwrote it. The stock 0x26 off passes r0=0, r1=0
# into 0x5B580, which calls 0xE9C. This helper does that call. A and B
# stay as FW41 left them. The helper sits in the old save at 0x5B700.
# 0x5B720 is still live and is not overwritten.
import hashlib
import struct
import subprocess
from pathlib import Path

import fw30_build
import literal_guard

ROOT = Path(__file__).resolve().parents[2]
SRC = ROOT / "radio_firmware" / "build" / "DMR003.FW41.V022.bin"
DEST = ROOT / "radio_firmware" / "build" / "DMR003.FW43.V022.bin"
TAG = slice(0x38464, 0x38474)
CALL = 0x5B592
HOOK = 0x5B770
GIVE = 0x5B700
GIVE_END = 0x5B70A
UNKEY = 0xE9C
LIVE = 0x5B720
RECLAIM = 0x5BCDA
RECLAIM_END = 0x5BD74
HELPER = 0x5BD82
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
	bf	2f
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
	bf	4f
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
	.long	0xaabbccdd
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

GIVE_ASM = """
	.text
	.global	give
give:
	movi	r0, 0
	movi	r1, 0
	.long	0xbbccddee
	jmp	r15
"""


def symbols(path):
    out = subprocess.check_output([str(NM), str(path)], text=True)
    found = {}
    for line in out.splitlines():
        parts = line.split()
        if len(parts) >= 3 and parts[2] in ("save", "restore", "hold_off"):
            found[parts[2]] = int(parts[0], 16)
    return found


def dump(path, start, stop):
    return subprocess.check_output(
        [str(OBJDUMP), "-b", "binary", "-m", "csky", "-D",
         "--start-address=0x%X" % start, "--stop-address=0x%X" % stop, str(path)],
        text=True, errors="replace")


def br_target(img, at):
    hi, lo = struct.unpack_from("<HH", img, at)
    if hi != 0xE800:
        raise SystemExit("not a br at %X (%04X)" % (at, hi))
    disp = lo - 0x10000 if lo & 0x8000 else lo
    return at + (disp << 1)


def dead_give(blob):
    """No outside instruction reads or branches into the old save."""
    for pc, pool in literal_guard.literal_loads(blob):
        if GIVE <= pool < GIVE_END and not (GIVE <= pc < GIVE_END):
            raise SystemExit("live pool %X from %X" % (pool, pc))
    for pc, _length, target in literal_guard.branch_targets(blob):
        if GIVE <= target < LIVE:
            raise SystemExit("branch %X -> %X" % (pc, target))


def build():
    img = bytearray(SRC.read_bytes())
    old = bytes(img)
    if img[TAG] != b"DMR003.FW41.V022":
        raise SystemExit("tag")
    if img[LIVE:LIVE + 2] != bytes.fromhex("d414"):
        raise SystemExit("live push")
    dead_give(old)
    give = bytearray(fw30_build._linked(GIVE_ASM, GIVE, "fw43give"))
    slot = give.find(struct.pack("<I", 0xBBCCDDEE))
    if slot < 0:
        raise SystemExit("unkey slot")
    give[slot:slot + 4] = fw30_build.encode_bsr(GIVE + slot, UNKEY)
    if len(give) != GIVE_END - GIVE:
        raise SystemExit("give %d" % len(give))
    if b"\x3c\x78" not in give:
        raise SystemExit("give return")
    code = fw30_build._linked(ASM, RECLAIM, "fw43")
    elf = Path(r"C:\Users\Joshua\AppData\Local\Temp\fw1718\fw30\fw43.elf")
    sym = symbols(elf)
    save_at = sym["save"]
    restore_at = sym["restore"]
    hold_at = sym["hold_off"]
    if save_at != RECLAIM + 2 or code[:2] != b"\x00\x00":
        raise SystemExit("save at %X" % save_at)
    if not (RECLAIM < restore_at < hold_at < RECLAIM_END):
        raise SystemExit("layout %X %X" % (restore_at, hold_at))
    if RECLAIM + len(code) > RECLAIM_END:
        raise SystemExit("stub %d ends %X" % (len(code), RECLAIM + len(code)))
    if code.count(b"\x94\x14") != 1:
        raise SystemExit("pop")
    call = code.find(struct.pack("<I", 0xAABBCCDD))
    mode4 = code.find(struct.pack("<I", 0x11223344))
    mode3 = code.find(struct.pack("<I", 0x55667788))
    if call < 0 or mode4 < 0 or mode3 < 0:
        raise SystemExit("placeholders")
    if code.find(struct.pack("<I", 0xAABBCCDD), call + 4) >= 0:
        raise SystemExit("give call duplicated")
    code = bytearray(code)
    code[call:call + 4] = fw30_build.encode_bsr(RECLAIM + call, GIVE)
    code[mode4:mode4 + 4] = fw30_build.encode_br(RECLAIM + mode4, MODE4_RESTORE)
    code[mode3:mode3 + 4] = fw30_build.encode_br(RECLAIM + mode3, MODE3_TAIL)
    img[RECLAIM:RECLAIM + len(code)] = code
    if RECLAIM + len(code) < RECLAIM_END:
        img[RECLAIM + len(code):RECLAIM_END] = b"\x00" * (RECLAIM_END - RECLAIM - len(code))
    img[GIVE:GIVE_END] = give
    img[CALL:CALL + 4] = fw30_build.encode_bsr(CALL, save_at)
    img[HOOK:HOOK + 4] = fw30_build.encode_br(HOOK, restore_at)
    img[HOLD_AT:HOLD_AT + 4] = fw30_build.encode_br(HOLD_AT, hold_at)
    if img[GIVE_END:LIVE] != old[GIVE_END:LIVE]:
        raise SystemExit("pool tail")
    if img[LIVE:HOOK] != old[LIVE:HOOK]:
        raise SystemExit("live body")
    if img[RECLAIM_END:HELPER + 16] != old[RECLAIM_END:HELPER + 16]:
        raise SystemExit("reply or helper")
    if br_target(img, RECLAIM + mode4) != MODE4_RESTORE:
        raise SystemExit("mode4")
    if br_target(img, RECLAIM + mode3) != MODE3_TAIL:
        raise SystemExit("mode3")
    if fw30_build.bsr_target(img, RECLAIM + call) != GIVE:
        raise SystemExit("give call")
    if fw30_build.bsr_target(img, GIVE + slot) != UNKEY:
        raise SystemExit("unkey")
    if fw30_build.bsr_target(img, CALL) != save_at:
        raise SystemExit("save call")
    if br_target(img, HOOK) != restore_at:
        raise SystemExit("hook")
    if br_target(img, HOLD_AT) != hold_at:
        raise SystemExit("hold")
    changed = [i for i, (a, c) in enumerate(zip(old, img)) if a != c]
    allowed = set(range(GIVE, GIVE_END))
    allowed.update(range(RECLAIM, RECLAIM_END))
    for site in (CALL, HOOK, HOLD_AT):
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
    img[TAG] = b"DMR003.FW43.V022"
    DEST.write_bytes(img)
    text = dump(DEST, GIVE, LIVE)
    stub = dump(DEST, RECLAIM, RECLAIM_END)
    print(DEST.name)
    print(hashlib.sha256(bytes(img)).hexdigest())
    print("bytes", len(code), "save", hex(save_at), "restore", hex(restore_at), "hold", hex(hold_at))
    print(text)
    print(stub)
    if "0xe9c" not in text or "jmp" not in text:
        raise SystemExit("give dump")
    if "0x38908" not in stub or "0xa" not in stub or "0xb" not in stub:
        raise SystemExit("a/b")
    if "0x5b700" not in stub.split("bsr", 1)[-1].splitlines()[0]:
        raise SystemExit("bsr text")


if __name__ == "__main__":
    build()
