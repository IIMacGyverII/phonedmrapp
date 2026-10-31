# F59E: F59D plus FW58's All-Call unmute (B). The (A') store, the op 6
# guard and the opcode 14 window stay. The new stub starts at 0x5C634,
# after FW59's block.
#
# The two offline reads, before this image:
# (1) 0x4C59C+0xC is written at 0x14A34, 0x14D82 and 0x15446. Each loads
# byte 2 of 0x4C7BC, adds 7, and copies that 0x4D318 word. All three are
# in the function at 0x12A20, called from 0x12A0A. The admission branch
# at 0x11D18 is in the earlier function, so (B) compares the word a
# previous pass stored.
# (2) Each hooked site is one 32-bit bnez. Its taken target is the mute
# path (0x11D2E and 0x11D96). The stub jumps there on a mismatch and to
# the fall-through (0x11D1C and 0x11D84) on a match. Those four
# instructions are unchanged, so the stock stream is intact. Nothing in
# (B) is rewritten.
import hashlib
import struct
from pathlib import Path

import fw30_build
import fw58_build
import fw59_build
import literal_guard
import space_map

ROOT = Path(__file__).resolve().parents[2]
SRC = ROOT / "radio_firmware" / "build" / "DMR003.F59D.V022.bin"
DEST = ROOT / "radio_firmware" / "build" / "DMR003.F59E.V022.bin"
TAG = fw59_build.TAG
BASE = space_map.F59E_STUB
TAIL_END = fw58_build.TAIL_END
XIP = fw58_build.XIP
HOOKS = (
    ("allcall_3", 0x11D18),
    ("allcall_2", 0x11D80),
)
EXITS = {0x11D1C: "unmute", 0x11D2E: "mute", 0x11D84: "unmute", 0x11D96: "mute"}

ASM = r"""
	.text
	.global	allcall_3
	.global	allcall_2

/* (B) from FW58. r2 and r3 only. r3 arrives as the 0x23d54 result.
 * bez, or a destination of 0xFFFFFF, jumps to the stock unmute.
 * Any other destination jumps to the stock mute. */
allcall_3:
	bez	r3, 1f
	lrw	r2, 0x4c59c
	ld.w	r2, (r2, 0xc)
	bmaski	r3, 24
	cmpne	r2, r3
	bf	1f
	lrw	r3, 0x0302bd2e
	jmp	r3
1:
	lrw	r3, 0x0302bd1c
	jmp	r3

allcall_2:
	bez	r3, 1f
	lrw	r2, 0x4c59c
	ld.w	r2, (r2, 0xc)
	bmaski	r3, 24
	cmpne	r2, r3
	bf	1f
	lrw	r3, 0x0302bd96
	jmp	r3
1:
	lrw	r3, 0x0302bd84
	jmp	r3
"""

CODE = {}
SYMBOLS = {}


def _assemble():
    import tempfile
    from pathlib import Path as P
    with tempfile.TemporaryDirectory(prefix="fw59e_") as tmp:
        tmp = P(tmp)
        src = tmp / "fw59e.S"
        src.write_text(ASM, encoding="ascii")
        obj = tmp / "fw59e.o"
        elf = tmp / "fw59e.elf"
        fw59_build._run([str(fw30_build.AS), "-mcpu=ck803", "-o", str(obj), str(src)])
        fw59_build._run([str(fw30_build.LD), "-Ttext=0x%X" % BASE, "-o", str(elf), str(obj)])
        import fw23_build
        code, addr = fw23_build.text_of(elf.read_bytes())
        if addr != BASE:
            raise SystemExit("linked at %X" % addr)
        if BASE + len(code) > TAIL_END:
            raise SystemExit("stub ends %X" % (BASE + len(code)))
        symbols = {}
        nm = fw30_build.AS.with_name("csky-elfabiv2-nm.exe")
        for line in fw59_build._run([str(nm), str(elf)]).decode("utf-8", "replace").splitlines():
            parts = line.split()
            if len(parts) == 3 and parts[1] in ("T", "t"):
                symbols[parts[2]] = int(parts[0], 16)
        dump = fw59_build._run(
            [str(literal_guard.OBJDUMP), "-d", str(elf)]).decode("utf-8", "replace")
    return bytes(code), symbols, dump


def build():
    global CODE, SYMBOLS
    img = bytearray(SRC.read_bytes())
    old = bytes(img)
    if img[TAG] != b"DMR003.F59D.V022":
        raise SystemExit("tag")
    fw57 = (ROOT / "radio_firmware" / "build" / "DMR003.FW57.V022.bin").read_bytes()
    if img[0x11D18:0x11D1C] != fw57[0x11D18:0x11D1C]:
        raise SystemExit("site 11d18")
    if img[0x11D80:0x11D84] != fw57[0x11D80:0x11D84]:
        raise SystemExit("site 11d80")
    code, symbols, dump = _assemble()
    fw59_build._prev_mnemonic(dump)
    # Reuse the range splitter by pointing it at these two names.
    saved = fw59_build.HOOKS
    fw59_build.HOOKS = tuple((name, site, "bsr") for name, site in HOOKS)
    try:
        ranges = fw59_build._code_ranges(dump, symbols)
    finally:
        fw59_build.HOOKS = saved
    for name, site in HOOKS:
        regs = fw59_build._regs(dump, *ranges[name])
        if regs != {2, 3}:
            raise SystemExit("%s regs %s" % (name, regs))
    for at in EXITS:
        if struct.pack("<I", XIP + at) not in code:
            raise SystemExit("exit %X missing" % at)
    if BASE < space_map.FW59_USED[1]:
        raise SystemExit("overlaps FW59")
    img[BASE:BASE + len(code)] = code
    for name, site in HOOKS:
        word = fw30_build.encode_bsr(site, symbols[name])
        img[site:site + 4] = word
        if fw30_build.bsr_target(img, site) != symbols[name]:
            raise SystemExit("target %s" % name)
    for at in EXITS:
        if img[at:at + 4] != old[at:at + 4]:
            raise SystemExit("exit moved %X" % at)
    if img[space_map.FW59_USED[0]:space_map.FW59_USED[1]] != old[space_map.FW59_USED[0]:space_map.FW59_USED[1]]:
        raise SystemExit("fw59 block moved")
    body = bytes(img)
    if literal_guard.covered_loads(old, body)[1]:
        raise SystemExit("load guard")
    if literal_guard.covered_branches(old, body)[1]:
        raise SystemExit("branch guard")
    if literal_guard.never_written(old, body):
        raise SystemExit("never-write")
    pointed = literal_guard.pointed_into(old, body)
    if pointed:
        raise SystemExit("pointed %s" % [hex(p) for p in pointed[:12]])
    if space_map.outside_free(old, body):
        raise SystemExit("space %s" % space_map.outside_free(old, body))
    img[TAG] = b"DMR003.F59E.V022"
    DEST.write_bytes(img)
    CODE = ranges
    SYMBOLS = symbols
    print(DEST.name)
    print(hashlib.sha256(bytes(img)).hexdigest())
    return DEST


if __name__ == "__main__":
    build()
