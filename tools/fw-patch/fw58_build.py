# FW58: FW57 plus the heard-talkgroup store, the All-Call unmute, and the
# op 6 hold guard. F58D is the bench twin (opcode 14 window [0x30000, 0x50000)).
#
# (B) was approved as `br`, with the stub leaving by lrw+jmp. A br displacement
# is a signed 16-bit halfword count, and 0x5C59C is 0x4A884 bytes from 0x11d18,
# so the encoding does not exist. The sites are bsr. The stubs do not return:
# r3 == 0 jumps to the stock unmute, and any other destination jumps to the
# stock mute. r15 is already on the stack at 0x11A3A (st.w r15) and at 0x26C7E.
# The op 6 function pops r4-r7, r15 at 0x5B306.
#
# (C) The apply hook is the store at 0x5B2D2, not the load at 0x5B2CC.
# 0x5C550 jumps to 0x5B2CC when the variant is 4, and pointed_into flags any
# change within 4 bytes of that word. The load stays, so r4 is WORK_MODE and
# r5 is its old value. The hook replaces the store and the movi r5, 128, and
# the stub jumps to the st.w at 0x5B2D6. Release is the 4 bytes at 0x5BD36.
# Both are br: the displacement reaches the tail, and the stubs do not return.
import hashlib
import struct
import subprocess
import tempfile
from pathlib import Path

import fw23_build
import fw30_build
import literal_guard
import space_map

ROOT = Path(__file__).resolve().parents[2]
SRC = ROOT / "radio_firmware" / "build" / "DMR003.FW57.V022.bin"
DEST = ROOT / "radio_firmware" / "build" / "DMR003.FW58.V022.bin"
DIAG = ROOT / "radio_firmware" / "build" / "DMR003.F58D.V022.bin"
TAG = slice(0x38464, 0x38474)
BASE = 0x5C59C
TAIL_END = 0x5C6FC
XIP = 0x0301A000
HOLD = 0x484F4C44

# File bytes of `subi r3, r8, 16` at 0x26F24. The (A) stub executes this
# same instruction before it returns, so 0x26F28 still sees r3 = r8-16.
SUBI_R3_R8_16 = bytes.fromhex("68e40f10")

HOOKS = (
    # name, site, kind, exit the stub jumps to (None when the stub returns)
    ("rx_lc_ids", 0x26F24, "bsr", None),
    ("allcall_3", 0x11D18, "bsr", None),
    ("allcall_2", 0x11D80, "bsr", None),
    ("op6_apply", 0x5B2D2, "br", 0x5B2D6),
    ("op6_release", 0x5BD36, "br", 0x5BD3E),
)
OLD_HOOK = {
    0x26F24: SUBI_R3_R8_16,
    0x11D18: bytes.fromhex("23e90b00"),  # bnez r3, 0x11d2e
    0x11D80: bytes.fromhex("23e90b00"),  # bnez r3, 0x11d96
    0x5B2D2: bytes.fromhex("a0b08035"),  # st.w r5, (r0, 0); movi r5, 128
    0x5BD36: bytes.fromhex("8c10a094"),  # lrw r4, 0x4b000; ld.w r5, (r4, 0)
}

# Opcode 14 window, the same bytes F57D writes.
WIN_LO = 0x5C0CE
WIN_HI = 0x5C0D6
WIN_OLD = (bytes.fromhex("21ea0018"), bytes.fromhex("21ea0118"))
WIN_NEW = (bytes.fromhex("21ea0300"), bytes.fromhex("21ea0500"))

AS = fw30_build.AS
LD = fw30_build.LD
NM = AS.with_name("csky-elfabiv2-nm.exe")
OBJDUMP = literal_guard.OBJDUMP

# Filled by build(). Code ranges exclude literal pools.
CODE = {}
SYMBOLS = {}

ASM = r"""
	.text
	.global	rx_lc_ids
	.global	allcall_3
	.global	allcall_2
	.global	op6_apply
	.global	op6_release

/* (A) Fail path of the voice-LC store. Byte 2 of 0x4C7BC is the index the
 * 0x2B reader uses. Frame-20 is the destination, frame-24 the source.
 * r8 stays the frame pointer. r4 and above stay. Returns with r3 = r8-16. */
rx_lc_ids:
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
	subi	r3, r8, 16
	jmp	r15

/* (B) r2 and r3 only. r3 arrives as the 0x23d54 result. bez takes the stock
 * unmute. Otherwise the word at 0x4C59C+0xC is compared with bmaski 24.
 * Exits are XIP addresses, file offset + 0x0301A000. The same addition
 * used by the jmp at 0x5BCD4 (0x03076464 = 0x5C464 + 0x0301A000). */
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

/* (C) Apply. Entered with r0 = 0x4B000, r4 = WORK_MODE, r5 = its value.
 * Those three stay until the store. r1 is the variant. Save only when the
 * hold word is not already set, then movi r5, 128 and jump to the st.w. */
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

/* Release. r0 and r1 are live into the tail at 0x5B2A8, so only r4 and r5
 * are used. Restore only while the hold word is set. The tail clears it. */
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
    with tempfile.TemporaryDirectory(prefix="fw58_") as tmp:
        tmp = Path(tmp)
        src = tmp / "fw58.S"
        src.write_text(ASM, encoding="ascii")
        obj = tmp / "fw58.o"
        elf = tmp / "fw58.elf"
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
    """Half-open file ranges of each global symbol, stopping at its pool."""
    globals_ = [name for name, _site, _kind, _exit in HOOKS]
    marks = []
    for line in dump.splitlines():
        text = line.strip()
        for name in globals_:
            if text.startswith("0") and text.endswith("<%s>:" % name):
                marks.append((int(text.split()[0], 16), name, "sym"))
        if ".long" in text and text[:1].isdigit() or (text.startswith("0") and ".long" in text):
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
    missing = [name for name, _s, _k, _e in HOOKS if name not in ranges]
    if missing:
        raise SystemExit("no range %s" % missing)
    for name, (lo, hi) in ranges.items():
        if symbols.get(name) != lo:
            raise SystemExit("symbol %s at %X dump %X" % (name, symbols.get(name, -1), lo))
    return ranges


def _regs(dump, lo, hi):
    """Register numbers named by instructions in [lo, hi)."""
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
    """A pool must sit after jmp or br, so it is not executed."""
    prev = None
    for line in dump.splitlines():
        text = line.strip()
        mnem = _mnemonic(text)
        if mnem == ".long" and prev not in ("jmp", "br"):
            raise SystemExit("pool after %s" % prev)
        # .short 0 is the alignment pad the assembler inserts before a pool.
        if mnem and not mnem.startswith("."):
            prev = mnem


def _targets(image):
    return [(pc, length, target) for pc, length, target in literal_guard.branch_targets(image)]


def _hook_bytes(kind, site, target):
    if kind == "br":
        return fw30_build.encode_br(site, target)
    try:
        fw30_build.encode_br(site, target)
        reached = True
    except SystemExit:
        reached = False
    # (B) was approved as br. The tail is out of range, so the entry is bsr
    # and the stub jumps out instead of returning.
    if site in (0x11D18, 0x11D80) and reached:
        raise SystemExit("br reached %X from %X" % (target, site))
    return fw30_build.encode_bsr(site, target)


def _br_target(blob, at):
    hi, lo = struct.unpack_from("<HH", blob, at)
    if hi != 0xE800:
        raise SystemExit("not br at %X" % at)
    if lo >= 0x8000:
        lo -= 0x10000
    return at + (lo << 1)


def build():
    global CODE, SYMBOLS
    img = bytearray(SRC.read_bytes())
    old = bytes(img)
    if img[TAG] != b"DMR003.FW57.V022":
        raise SystemExit("tag")
    for site, expect in OLD_HOOK.items():
        if img[site:site + len(expect)] != expect:
            raise SystemExit("site %X" % site)
    if img[0x11A3A:0x11A3E] != bytes.fromhex("eedd0120"):
        raise SystemExit("mute prologue")
    if img[0x26C7E:0x26C82] != bytes.fromhex("eedd0120"):
        raise SystemExit("lc prologue")
    if img[0x5B306:0x5B308] != bytes.fromhex("9414"):
        raise SystemExit("op6 pop")
    # The four bytes after each op 6 hook stay. Nothing may already branch there.
    taken = _targets(old)
    for pc, _length, target in taken:
        if target in (0x5B2D4, 0x5BD38):
            raise SystemExit("branch %X -> %X" % (pc, target))
        if target in (0x26F26, 0x11D1A, 0x11D82):
            raise SystemExit("branch into %X" % target)
    wanted = {
        (0x5BD30, 0x5BD36),
        (0x26ECE, 0x26F24),
    }
    got = {(pc, target) for pc, _length, target in taken}
    missing = wanted - got
    if missing:
        raise SystemExit("missing branches %s" % [(hex(a), hex(b)) for a, b in missing])

    code, symbols, dump = _assemble()
    _prev_mnemonic(dump)
    ranges = _code_ranges(dump, symbols)
    if _regs(dump, *ranges["allcall_3"]) != {2, 3}:
        raise SystemExit("allcall_3 regs %s" % _regs(dump, *ranges["allcall_3"]))
    if _regs(dump, *ranges["allcall_2"]) != {2, 3}:
        raise SystemExit("allcall_2 regs %s" % _regs(dump, *ranges["allcall_2"]))
    if _regs(dump, *ranges["op6_apply"]) & {1, 4}:
        raise SystemExit("apply regs %s" % _regs(dump, *ranges["op6_apply"]))
    if not _regs(dump, *ranges["op6_release"]) <= {4, 5}:
        raise SystemExit("release regs %s" % _regs(dump, *ranges["op6_release"]))
    if SUBI_R3_R8_16 not in code:
        raise SystemExit("subi missing")
    if struct.pack("<I", HOLD) not in code:
        raise SystemExit("hold word missing")
    for at in (0x11D1C, 0x11D2E, 0x11D84, 0x11D96, 0x5B2D6, 0x5BD3E):
        if struct.pack("<I", XIP + at) not in code:
            raise SystemExit("exit %X missing" % at)
    img[BASE:BASE + len(code)] = code
    for name, site, kind, _exit in HOOKS:
        word = _hook_bytes(kind, site, symbols[name])
        if len(word) != 4:
            raise SystemExit("hook %s" % name)
        img[site:site + 4] = word
        landed = _br_target(img, site) if kind == "br" else fw30_build.bsr_target(img, site)
        if landed != symbols[name]:
            raise SystemExit("target %s %X" % (name, landed))
    # The variant-4 jump still lands on the original load.
    if img[0x5B2CC:0x5B2D2] != old[0x5B2CC:0x5B2D2]:
        raise SystemExit("apply load")
    if img[0x5C58C:0x5C590] != old[0x5C58C:0x5C590]:
        raise SystemExit("apply pointer")
    for at in (0x11D1C, 0x11D2E, 0x11D84, 0x11D96, 0x5B2D6, 0x5BD3E, 0x5B2F4, 0x5B2B6):
        if img[at:at + 4] != old[at:at + 4]:
            raise SystemExit("moved %X" % at)
    if literal_guard.covered_loads(old, bytes(img))[1]:
        raise SystemExit("load guard")
    if literal_guard.covered_branches(old, bytes(img))[1]:
        raise SystemExit("branch guard")
    if literal_guard.never_written(old, bytes(img)):
        raise SystemExit("never-write")
    pointed = literal_guard.pointed_into(old, bytes(img))
    if pointed:
        raise SystemExit("pointed %s" % [hex(p) for p in pointed[:12]])
    if space_map.outside_free(old, bytes(img)):
        raise SystemExit("space %s" % space_map.outside_free(old, bytes(img)))
    img[TAG] = b"DMR003.FW58.V022"
    DEST.write_bytes(img)
    CODE = ranges
    SYMBOLS = symbols
    print(DEST.name)
    print(hashlib.sha256(bytes(img)).hexdigest())
    return DEST


def build_diag():
    if not DEST.is_file() or DEST.read_bytes()[TAG] != b"DMR003.FW58.V022":
        build()
    img = bytearray(DEST.read_bytes())
    old = bytes(img)
    if img[WIN_LO:WIN_LO + 4] != WIN_OLD[0] or img[WIN_HI:WIN_HI + 4] != WIN_OLD[1]:
        raise SystemExit("window")
    img[WIN_LO:WIN_LO + 4] = WIN_NEW[0]
    img[WIN_HI:WIN_HI + 4] = WIN_NEW[1]
    if literal_guard.covered_loads(old, bytes(img))[1]:
        raise SystemExit("load guard")
    if literal_guard.covered_branches(old, bytes(img))[1]:
        raise SystemExit("branch guard")
    if literal_guard.never_written(old, bytes(img)):
        raise SystemExit("never-write")
    if literal_guard.pointed_into(old, bytes(img)):
        raise SystemExit("pointed")
    img[TAG] = b"DMR003.F58D.V022"
    DIAG.write_bytes(img)
    print(DIAG.name)
    print(hashlib.sha256(bytes(img)).hexdigest())
    return DIAG


if __name__ == "__main__":
    build()
    build_diag()
