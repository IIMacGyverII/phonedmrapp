# FW59: FW57 plus the All-Call store and the op 6 hold guard. F59D is the
# bench twin (opcode 14 window [0x30000, 0x50000)).
#
# (A') replaces the four bytes at 0x26F24. The voice-LC fail path has
# already stored FLCO (byte 0 masked with 0x3F) at r8-2, the destination
# word at r8-20 and the source word at r8-24. The stub writes those two
# words into 0x4D318[(byte 2 of 0x4C7BC)+7] and [+9] only when that FLCO
# is 0 and the destination is 0xFFFFFF. Every other call returns without
# a store. r8 is not written. r1, r2 and r3 are the only others. The
# return is the replaced `subi r3, r8, 16`, so 0x26F28 still runs.
#
# (B) is not in this image. 0x11D18 and 0x11D80 stay the FW57 branches.
#
# (C) is the FW58 op 6 guard, same instructions. The apply hook is the
# store at 0x5B2D2. The load at 0x5B2CC stays, because 0x5C550 jumps there
# and pointed_into flags a change within 4 bytes of that word.
import hashlib
import struct
import subprocess
import tempfile
from pathlib import Path

import fw23_build
import fw30_build
import fw58_build
import literal_guard
import space_map

ROOT = Path(__file__).resolve().parents[2]
SRC = ROOT / "radio_firmware" / "build" / "DMR003.FW57.V022.bin"
DEST = ROOT / "radio_firmware" / "build" / "DMR003.FW59.V022.bin"
DIAG = ROOT / "radio_firmware" / "build" / "DMR003.F59D.V022.bin"
TAG = fw58_build.TAG
BASE = fw58_build.BASE
TAIL_END = fw58_build.TAIL_END
XIP = fw58_build.XIP
HOLD = fw58_build.HOLD
SUBI_R3_R8_16 = fw58_build.SUBI_R3_R8_16
WIN_LO = fw58_build.WIN_LO
WIN_HI = fw58_build.WIN_HI
WIN_OLD = fw58_build.WIN_OLD
WIN_NEW = fw58_build.WIN_NEW

HOOKS = (
    ("rx_lc_ids", 0x26F24, "bsr"),
    ("op6_apply", 0x5B2D2, "br"),
    ("op6_release", 0x5BD36, "br"),
)
OLD_HOOK = {
    0x26F24: SUBI_R3_R8_16,
    0x5B2D2: fw58_build.OLD_HOOK[0x5B2D2],
    0x5BD36: fw58_build.OLD_HOOK[0x5BD36],
}
# (B) stays. These four bytes are the FW57 branches.
UNTOUCHED = (0x11D18, 0x11D80)

AS = fw30_build.AS
LD = fw30_build.LD
NM = AS.with_name("csky-elfabiv2-nm.exe")
OBJDUMP = literal_guard.OBJDUMP

CODE = {}
SYMBOLS = {}

ASM = r"""
	.text
	.global	rx_lc_ids
	.global	op6_apply
	.global	op6_release

/* (A') Group All-Call only. FLCO is the byte at r8-2. Destination is the
 * word at r8-20, source at r8-24. A non-zero FLCO, or any other
 * destination, skips both stores. r8 is unchanged. */
rx_lc_ids:
	subi	r3, r8, 2
	ld.b	r3, (r3, 0)
	andi	r3, r3, 63
	bnez	r3, 1f
	subi	r3, r8, 20
	ld.w	r2, (r3, 0)
	bmaski	r3, 24
	cmpne	r2, r3
	bt	1f
	lrw	r3, 0x4c7bc
	ld.b	r3, (r3, 2)
	zextb	r3, r3
	mov	r2, r3
	subi	r3, r8, 20
	ld.w	r1, (r3, 0)
	lrw	r3, 0x4d318
	addi	r2, 7
	str.w	r1, (r3, r2 << 2)
	lrw	r3, 0x4c7bc
	ld.b	r3, (r3, 2)
	zextb	r3, r3
	mov	r2, r3
	subi	r3, r8, 24
	ld.w	r1, (r3, 0)
	lrw	r3, 0x4d318
	addi	r2, 9
	str.w	r1, (r3, r2 << 2)
1:
	subi	r3, r8, 16
	jmp	r15

/* (C) Apply. Entered with r0 = 0x4B000, r4 = WORK_MODE, r5 = its value.
 * Save only when the hold word is not already set, then movi r5, 128
 * and jump to the st.w. */
op6_apply:
	lrw	r2, 0x4b008
	ld.w	r2, (r2, 0)
	lrw	r3, 0x484f4c44
	cmpne	r2, r3
	bf	1f
	st.w	r5, (r0, 0)
1:
	movi	r5, 128
	lrw	r2, 0x030752d6
	jmp	r2

/* Release. r0 and r1 are live into the tail, so only r4 and r5. Restore
 * only while the hold word is set. The tail clears the marker. */
op6_release:
	lrw	r4, 0x4b008
	ld.w	r5, (r4, 0)
	lrw	r4, 0x484f4c44
	cmpne	r5, r4
	bt	1f
	lrw	r4, 0x4b000
	ld.w	r5, (r4, 0)
	lrw	r4, 0x11000100
	st.w	r5, (r4, 0)
1:
	lrw	r4, 0x03075d3e
	jmp	r4
"""


def _run(cmd):
    proc = subprocess.run(cmd, capture_output=True)
    if proc.returncode != 0:
        raise SystemExit(proc.stderr.decode("utf-8", "replace") or proc.stdout.decode("utf-8", "replace"))
    return proc.stdout


def _assemble():
    with tempfile.TemporaryDirectory(prefix="fw59_") as tmp:
        tmp = Path(tmp)
        src = tmp / "fw59.S"
        src.write_text(ASM, encoding="ascii")
        obj = tmp / "fw59.o"
        elf = tmp / "fw59.elf"
        _run([str(AS), "-mcpu=ck803", "-o", str(obj), str(src)])
        _run([str(LD), "-Ttext=0x%X" % BASE, "-o", str(elf), str(obj)])
        code, addr = fw23_build.text_of(elf.read_bytes())
        if addr != BASE:
            raise SystemExit("linked at %X" % addr)
        if BASE + len(code) > TAIL_END:
            raise SystemExit("stub ends %X" % (BASE + len(code)))
        symbols = {}
        for line in _run([str(NM), str(elf)]).decode("utf-8", "replace").splitlines():
            parts = line.split()
            if len(parts) == 3 and parts[1] in ("T", "t"):
                symbols[parts[2]] = int(parts[0], 16)
        dump = _run([str(OBJDUMP), "-d", str(elf)]).decode("utf-8", "replace")
    return bytes(code), symbols, dump


def _code_ranges(dump, symbols):
    globals_ = [name for name, _site, _kind in HOOKS]
    marks = []
    for line in dump.splitlines():
        text = line.strip()
        for name in globals_:
            if text.startswith("0") and text.endswith("<%s>:" % name):
                marks.append((int(text.split()[0], 16), name, "sym"))
        if ".long" in text and (text[:1].isdigit() or text.startswith("0")):
            addr = int(text.split(":")[0], 16)
            marks.append((addr, None, "pool"))
    marks.sort(key=lambda row: (row[0], row[2] == "sym"))
    ranges = {}
    for i, (addr, name, kind) in enumerate(marks):
        if kind != "sym":
            continue
        end = BASE + 0x1000
        for nxt, _n, nk in marks[i + 1:]:
            if nk == "pool" or _n in globals_:
                end = nxt
                break
        ranges[name] = (addr, end)
    missing = [name for name, _s, _k in HOOKS if name not in ranges]
    if missing:
        raise SystemExit("no range %s" % missing)
    for name, (lo, hi) in ranges.items():
        if symbols.get(name) != lo:
            raise SystemExit("symbol %s at %X dump %X" % (name, symbols.get(name, -1), lo))
    return ranges


def _regs(dump, lo, hi):
    found = set()
    for line in dump.splitlines():
        text = line.strip()
        if not text or ":" not in text:
            continue
        try:
            addr = int(text.split(":")[0], 16)
        except ValueError:
            continue
        if not lo <= addr < hi:
            continue
        if ".long" in text:
            raise SystemExit("pool inside %X-%X" % (lo, hi))
        rest = text.split("\t")[-1]
        for token in rest.replace(",", " ").replace("(", " ").replace(")", " ").split():
            if token.startswith("r") and token[1:].isdigit():
                found.add(int(token[1:]))
    return found


def _mnemonic(text):
    tokens = text.replace("\t", " ").split()
    if len(tokens) >= 3 and tokens[0].endswith(":"):
        return tokens[2]
    return None


def _prev_mnemonic(dump):
    prev = None
    for line in dump.splitlines():
        text = line.strip()
        mnem = _mnemonic(text)
        if mnem == ".long" and prev not in ("jmp", "br"):
            raise SystemExit("pool after %s" % prev)
        if mnem and not mnem.startswith("."):
            prev = mnem


def _stores_are_gated(dump, lo, hi):
    """Both str.w sit after the FLCO test and the 0xFFFFFF test, and both
    tests branch to the subi that the return executes."""
    rows = []
    for line in dump.splitlines():
        text = line.strip()
        if not text or ":" not in text:
            continue
        try:
            addr = int(text.split(":")[0], 16)
        except ValueError:
            continue
        if not lo <= addr < hi:
            continue
        rows.append((addr, text))
    mnems = []
    for addr, text in rows:
        mnem = _mnemonic(text)
        if mnem:
            mnems.append((addr, mnem, text))
    names = [m for _a, m, _t in mnems]
    if names.count("str.w") != 2:
        raise SystemExit("stores %s" % names)
    first_store = next(i for i, (_a, m, _t) in enumerate(mnems) if m == "str.w")
    head = mnems[:first_store]
    head_names = [m for _a, m, _t in head]
    if "andi" not in head_names or "bnez" not in head_names:
        raise SystemExit("flco gate %s" % head_names)
    if "bmaski" not in head_names or "cmpne" not in head_names or "bt" not in head_names:
        raise SystemExit("dest gate %s" % head_names)
    subi = [addr for addr, mnem, text in mnems if mnem == "subi" and "16" in text and "r8" in text]
    if len(subi) != 1:
        raise SystemExit("return subi %s" % subi)
    for _addr, mnem, text in head:
        if mnem in ("bnez", "bt") and hex(subi[0]) not in text and ("%x" % subi[0]) not in text:
            raise SystemExit("gate not to return: %s" % text)
    if mnems[-1][1] != "jmp":
        raise SystemExit("tail %s" % mnems[-1])


def _guards(old, img, check_space):
    if literal_guard.covered_loads(old, img)[1]:
        raise SystemExit("load guard")
    if literal_guard.covered_branches(old, img)[1]:
        raise SystemExit("branch guard")
    if literal_guard.never_written(old, img):
        raise SystemExit("never-write")
    pointed = literal_guard.pointed_into(old, img)
    if pointed:
        raise SystemExit("pointed %s" % [hex(p) for p in pointed[:12]])
    # The opcode 14 window is two immediates inside a live function. F58D
    # checks loads, branches and pointers there, not the free-tail map.
    if check_space and space_map.outside_free(old, img):
        raise SystemExit("space %s" % space_map.outside_free(old, img))


def build():
    global CODE, SYMBOLS
    img = bytearray(SRC.read_bytes())
    old = bytes(img)
    if img[TAG] != b"DMR003.FW57.V022":
        raise SystemExit("tag")
    for site, expect in OLD_HOOK.items():
        if img[site:site + len(expect)] != expect:
            raise SystemExit("site %X" % site)
    if img[0x26C7E:0x26C82] != bytes.fromhex("eedd0120"):
        raise SystemExit("lc prologue")
    if img[0x5B306:0x5B308] != bytes.fromhex("9414"):
        raise SystemExit("op6 pop")
    taken = fw58_build._targets(old)
    for pc, _length, target in taken:
        if target in (0x5B2D4, 0x5BD38, 0x26F26):
            raise SystemExit("branch into %X from %X" % (target, pc))
    got = {(pc, target) for pc, _length, target in taken}
    missing = {(0x26ECE, 0x26F24), (0x5BD30, 0x5BD36)} - got
    if missing:
        raise SystemExit("missing branches %s" % [(hex(a), hex(b)) for a, b in missing])

    code, symbols, dump = _assemble()
    _prev_mnemonic(dump)
    ranges = _code_ranges(dump, symbols)
    _stores_are_gated(dump, *ranges["rx_lc_ids"])
    rx_regs = _regs(dump, *ranges["rx_lc_ids"])
    if not rx_regs <= {1, 2, 3, 8, 15}:
        raise SystemExit("rx regs %s" % rx_regs)
    if _regs(dump, *ranges["op6_apply"]) & {1, 4}:
        raise SystemExit("apply regs %s" % _regs(dump, *ranges["op6_apply"]))
    if not _regs(dump, *ranges["op6_release"]) <= {4, 5}:
        raise SystemExit("release regs %s" % _regs(dump, *ranges["op6_release"]))
    if SUBI_R3_R8_16 not in code:
        raise SystemExit("subi missing")
    if struct.pack("<I", HOLD) not in code:
        raise SystemExit("hold word missing")
    for at in (0x5B2D6, 0x5BD3E):
        if struct.pack("<I", XIP + at) not in code:
            raise SystemExit("exit %X missing" % at)
    for at in (0x11D1C, 0x11D2E, 0x11D84, 0x11D96):
        if struct.pack("<I", XIP + at) in code:
            raise SystemExit("allcall exit %X" % at)
    img[BASE:BASE + len(code)] = code
    for name, site, kind in HOOKS:
        if kind == "br":
            word = fw30_build.encode_br(site, symbols[name])
        else:
            word = fw30_build.encode_bsr(site, symbols[name])
        if len(word) != 4:
            raise SystemExit("hook %s" % name)
        img[site:site + 4] = word
        landed = fw58_build._br_target(img, site) if kind == "br" else fw30_build.bsr_target(img, site)
        if landed != symbols[name]:
            raise SystemExit("target %s %X" % (name, landed))
    for at in UNTOUCHED:
        if img[at:at + 4] != old[at:at + 4]:
            raise SystemExit("touched %X" % at)
    if img[0x26F28:0x26F2C] != old[0x26F28:0x26F2C]:
        raise SystemExit("tail moved")
    if img[0x5B2CC:0x5B2D2] != old[0x5B2CC:0x5B2D2]:
        raise SystemExit("apply load")
    if img[0x5C58C:0x5C590] != old[0x5C58C:0x5C590]:
        raise SystemExit("apply pointer")
    for at in (0x11D1C, 0x11D2E, 0x11D84, 0x11D96, 0x5B2D6, 0x5BD3E, 0x5B2F4, 0x5B2B6):
        if img[at:at + 4] != old[at:at + 4]:
            raise SystemExit("moved %X" % at)
    _guards(old, bytes(img), True)
    img[TAG] = b"DMR003.FW59.V022"
    DEST.write_bytes(img)
    CODE = ranges
    SYMBOLS = symbols
    print(DEST.name)
    print(hashlib.sha256(bytes(img)).hexdigest())
    return DEST


def build_diag():
    if not DEST.is_file() or DEST.read_bytes()[TAG] != b"DMR003.FW59.V022":
        build()
    img = bytearray(DEST.read_bytes())
    old = bytes(img)
    if img[WIN_LO:WIN_LO + 4] != WIN_OLD[0] or img[WIN_HI:WIN_HI + 4] != WIN_OLD[1]:
        raise SystemExit("window")
    img[WIN_LO:WIN_LO + 4] = WIN_NEW[0]
    img[WIN_HI:WIN_HI + 4] = WIN_NEW[1]
    _guards(old, bytes(img), False)
    img[TAG] = b"DMR003.F59D.V022"
    DIAG.write_bytes(img)
    print(DIAG.name)
    print(hashlib.sha256(bytes(img)).hexdigest())
    return DIAG


if __name__ == "__main__":
    build()
    build_diag()
