# FW62: FW57 plus the FW61 hold guard, plus the group-match hook.
# F62P: FW62 plus the opcode 14 window [0x30000, 0x50000).
# Nothing here keys the radio.
#
# 0x27EA8 matches a called id. Argument 0 compares the own id at
# 0x34808+0x34. Any other argument walks the 32 words at the pointer in
# 0x34808+0x38. Return 0 is a hit. A nonzero byte at 0x34808+0x2A calls
# 0x17C4 first, and that function is movi r0, 0; jmp r15, so the arm
# already returns a hit for every argument. Channel setup stores 0 at
# +0x2A (0x12CC and 0x1378). The other stores of that offset write task
# blocks, not this struct. The hook is therefore only the group arm.
#
# The hook replaces subi r3, r8, 4 at 0x27EEE. The stub loads 0x4B364.
# One sets r3 to 0 and jumps to the mov r0, r3 return at 0x27F62.
# Zero recomputes r3 = r8-4 and continues at 0x27EF2.
import hashlib
import struct
from pathlib import Path

import fw30_build
import fw58_build
import fw59_build
import fw61_build
import literal_guard
import space_map

ROOT = Path(__file__).resolve().parents[2]
SRC = fw61_build.SRC
GUARD = fw61_build.GUARD
DEST = ROOT / "radio_firmware" / "build" / "DMR003.FW62.V022.bin"
DIAG = ROOT / "radio_firmware" / "build" / "DMR003.F62P.V022.bin"
TAG = fw58_build.TAG
XIP = 0x0301A000
HOOK = 0x27EEE
HOOK_OLD = bytes.fromhex("68e40310")  # subi r3, r8, 4
CONTINUE = 0x27EF2
RETURN = 0x27F62
STUB = 0x5C634
LITERAL = 0x5C6BC
WIN_LO = 0x5C0CE
WIN_HI = 0x5C0D6
WIN_OLD = (bytes.fromhex("21ea0018"), bytes.fromhex("21ea0118"))
WIN_NEW = (bytes.fromhex("21ea0300"), bytes.fromhex("21ea0500"))

ASM = """
	.text
	.global	match_hook
match_hook:
	lrw	r3, 0x4B364
	ld.b	r3, (r3, 0)
	bnez	r3, 1f
	subi	r3, r8, 4
	lrw	r15, 0x%08X
	jmp	r15
1:
	movi	r3, 0
	lrw	r15, 0x%08X
	jmp	r15
	.align	2
	.literals
""" % (XIP + CONTINUE, XIP + RETURN)


def _symbols(path):
    import subprocess
    nm = fw30_build.AS.with_name("csky-elfabiv2-nm.exe")
    out = subprocess.check_output([str(nm), str(path)], text=True, errors="replace")
    sym = {}
    for line in out.splitlines():
        parts = line.split()
        if len(parts) >= 3 and parts[1] in ("T", "t"):
            sym[parts[2]] = int(parts[0], 16)
    return sym


def _apply_guard(img, old):
    guard = GUARD.read_bytes()
    if img[TAG] != b"DMR003.FW57.V022":
        raise SystemExit("tag")
    if guard[TAG] != b"DMR003.FW59.V022":
        raise SystemExit("fw59 tag")
    if fw58_build._br_target(guard, 0x5B2D2) != fw61_build.APPLY:
        raise SystemExit("fw59 apply")
    if fw58_build._br_target(guard, 0x5BD36) != fw61_build.RELEASE:
        raise SystemExit("fw59 release")
    for at, word in fw61_build.POOLS:
        if struct.unpack_from("<I", guard, at)[0] != word:
            raise SystemExit("pool %X" % at)
    for site, _target in fw61_build.HOOKS:
        if img[site:site + 4] != fw58_build.OLD_HOOK[site]:
            raise SystemExit("site %X" % site)
    img[fw61_build.CODE_LO:fw61_build.CODE_HI] = guard[fw61_build.CODE_LO:fw61_build.CODE_HI]
    img[fw61_build.POOL_LO:fw61_build.POOL_HI] = guard[fw61_build.POOL_LO:fw61_build.POOL_HI]
    for site, target in fw61_build.HOOKS:
        img[site:site + 4] = fw30_build.encode_br(site, target)
        if fw58_build._br_target(img, site) != target:
            raise SystemExit("hook %X" % site)
    if img[0x26F24:0x26F28] != old[0x26F24:0x26F28]:
        raise SystemExit("rx hook")
    if img[0x11D18:0x11D1C] != old[0x11D18:0x11D1C] or img[0x11D80:0x11D84] != old[0x11D80:0x11D84]:
        raise SystemExit("allcall hook")
    if img[0x5C59C:fw61_build.CODE_LO] != old[0x5C59C:fw61_build.CODE_LO]:
        raise SystemExit("allcall store")
    if img[fw61_build.CODE_HI:fw61_build.POOL_LO] != old[fw61_build.CODE_HI:fw61_build.POOL_LO]:
        raise SystemExit("gap")


def _guards(old, img, windows=()):
    if literal_guard.covered_loads(old, bytes(img))[1]:
        raise SystemExit("load guard")
    branches = literal_guard.covered_branches(old, bytes(img))[1]
    if branches:
        raise SystemExit("branch guard %s" % [(hex(a), hex(b)) for a, b in branches[:8]])
    if literal_guard.never_written(old, bytes(img)):
        raise SystemExit("never-write")
    pointed = literal_guard.pointed_into(old, bytes(img))
    if pointed:
        raise SystemExit("pointed %s" % [hex(p) for p in pointed[:8]])
    bad = space_map.outside_free(old, bytes(img))
    extra = [span for span in bad
             if not any(w.start <= span[0] and span[1] <= w.stop for w in windows)]
    if extra:
        raise SystemExit("space %s" % extra)
    fw59_build._guards(old, bytes(img), not windows)


def _stub():
    out = Path(r"C:\Users\Joshua\AppData\Local\Temp\fw1718\fw30")
    code = bytearray(fw30_build._linked(ASM, STUB, "fw62match"))
    sym = _symbols(out / "fw62match.elf")
    entry = sym["match_hook"]
    if entry != STUB:
        raise SystemExit("stub entry %X" % entry)
    if STUB + len(code) > LITERAL:
        raise SystemExit("stub covers 5C6BC, ends %X" % (STUB + len(code)))
    return bytes(code)


def build():
    img = bytearray(SRC.read_bytes())
    old = bytes(img)
    _apply_guard(img, old)
    if img[HOOK:HOOK + 4] != HOOK_OLD:
        raise SystemExit("match site %s" % img[HOOK:HOOK + 4].hex())
    stub = _stub()
    img[STUB:STUB + len(stub)] = stub
    img[HOOK:HOOK + 4] = fw30_build.encode_bsr(HOOK, STUB)
    if fw30_build.bsr_target(img, HOOK) != STUB:
        raise SystemExit("bsr")
    if img[LITERAL:LITERAL + 4] != old[LITERAL:LITERAL + 4]:
        raise SystemExit("literal")
    img[TAG] = b"DMR003.FW62.V022"
    _guards(old, img)
    DEST.write_bytes(img)
    print(DEST.name)
    print("stub %X-%X (%d)" % (STUB, STUB + len(stub), len(stub)))
    print(hashlib.sha256(bytes(img)).hexdigest())
    return DEST


def build_f62p():
    if not DEST.is_file():
        build()
    img = bytearray(DEST.read_bytes())
    old = bytes(img)
    if img[TAG] != b"DMR003.FW62.V022":
        raise SystemExit("fw62 tag")
    if img[WIN_LO:WIN_LO + 4] != WIN_OLD[0] or img[WIN_HI:WIN_HI + 4] != WIN_OLD[1]:
        raise SystemExit("window")
    img[WIN_LO:WIN_LO + 4] = WIN_NEW[0]
    img[WIN_HI:WIN_HI + 4] = WIN_NEW[1]
    img[TAG] = b"DMR003.F62P.V022"
    fw57 = SRC.read_bytes()
    windows = (range(WIN_LO, WIN_LO + 4), range(WIN_HI, WIN_HI + 4))
    _guards(fw57, img, windows)
    DIAG.write_bytes(img)
    print(DIAG.name)
    print(hashlib.sha256(bytes(img)).hexdigest())
    return DIAG


if __name__ == "__main__":
    build()
    build_f62p()
