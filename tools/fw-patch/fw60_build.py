# FW60: FW57 plus the op 6 hold guard and the live-slot All-Call unmute.
# F60D is the bench twin (opcode 14 window [0x30000, 0x50000)).
#
# (C) is the FW59 hold guard, same instructions, linked at 0x5C59C.
# Nops fill the rest of the span FW59 used, through 0x5C633. That span
# holds a bt at 0x5C62E whose target is 0x5C64E. Leaving the bt in place
# and writing 0x5C64E fails the branch guard. (D) starts at 0x5C634.
# One object containing both ran into the literal at 0x5C6BC, which
# 0x5C45E still loads. (D) alone ends before that word.
# No (A) and no (A').
# (D) replaces the branches at 0x11D18 and 0x11D80. r3 == 0 unmutes, as the
# stock branch did. Otherwise the word 0x4D318[(byte 2 of 0x4C7BC)+7] is
# read, the same word the caller-info report copies. 16777215 unmutes.
# Any other value mutes. r8 is not written. r2 and r3 are the only others.
import hashlib
import struct
import subprocess
import tempfile
from pathlib import Path

import fw23_build
import fw30_build
import fw58_build
import fw59_build
import literal_guard
import space_map

ROOT = Path(__file__).resolve().parents[2]
SRC = ROOT / "radio_firmware" / "build" / "DMR003.FW57.V022.bin"
DEST = ROOT / "radio_firmware" / "build" / "DMR003.FW60.V022.bin"
DIAG = ROOT / "radio_firmware" / "build" / "DMR003.F60D.V022.bin"
TAG = fw58_build.TAG
C_BASE = fw58_build.BASE
C_LIMIT = space_map.FW59_USED[1]
D_BASE = space_map.F59E_STUB
D_LIMIT = 0x5C6BC
TAIL_END = fw58_build.TAIL_END
XIP = fw58_build.XIP
HOLD = fw58_build.HOLD
EXITS = (0x11D1C, 0x11D2E, 0x11D84, 0x11D96)

HOOKS = (
    ("allcall_3", 0x11D18, "bsr"),
    ("allcall_2", 0x11D80, "bsr"),
    ("op6_apply", 0x5B2D2, "br"),
    ("op6_release", 0x5BD36, "br"),
)
OLD_HOOK = {
    0x11D18: fw58_build.OLD_HOOK[0x11D18],
    0x11D80: fw58_build.OLD_HOOK[0x11D80],
    0x5B2D2: fw58_build.OLD_HOOK[0x5B2D2],
    0x5BD36: fw58_build.OLD_HOOK[0x5BD36],
}
# (A') stays out. The voice-LC instruction is untouched.
UNTOUCHED = (0x26F24,)

AS = fw30_build.AS
LD = fw30_build.LD
NM = AS.with_name("csky-elfabiv2-nm.exe")
OBJDUMP = literal_guard.OBJDUMP

CODE = {}
SYMBOLS = {}
SPAN = (C_BASE, D_BASE)

ASM_C = r"""
	.text
	.global	op6_apply
	.global	op6_release

/* (C) Apply. Entered with r0 = 0x4B000, r4 = WORK_MODE, r5 = its value. */
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

/* Release. r0 and r1 stay live. Restore only while the hold word is set. */
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

ASM_D = r"""
	.text
	.global	allcall_3
	.global	allcall_2

/* (D) state 3. r3 == 0 is the stock fall-through, the unmute.
 * Otherwise the live slot word: 16777215 unmutes, anything else mutes. */
allcall_3:
	cmpnei	r3, 0
	bf	1f
	lrw	r3, 0x4c7bc
	ld.b	r3, (r3, 2)
	zextb	r3, r3
	mov	r2, r3
	lrw	r3, 0x4d318
	addi	r2, 7
	ldr.w	r2, (r3, r2 << 2)
	bmaski	r3, 24
	cmpne	r2, r3
	bt	2f
1:
	lrw	r3, 0x0302bd1c
	jmp	r3
2:
	lrw	r3, 0x0302bd2e
	jmp	r3

/* (D) state 2. The same test, the other pair of exits. */
allcall_2:
	cmpnei	r3, 0
	bf	1f
	lrw	r3, 0x4c7bc
	ld.b	r3, (r3, 2)
	zextb	r3, r3
	mov	r2, r3
	lrw	r3, 0x4d318
	addi	r2, 7
	ldr.w	r2, (r3, r2 << 2)
	bmaski	r3, 24
	cmpne	r2, r3
	bt	2f
1:
	lrw	r3, 0x0302bd84
	jmp	r3
2:
	lrw	r3, 0x0302bd96
	jmp	r3
"""


def _run(cmd):
    proc = subprocess.run(cmd, capture_output=True)
    if proc.returncode != 0:
        raise SystemExit(proc.stderr.decode("utf-8", "replace") or proc.stdout.decode("utf-8", "replace"))
    return proc.stdout


def _assemble_one(text, base, limit):
    with tempfile.TemporaryDirectory(prefix="fw60_") as tmp:
        tmp = Path(tmp)
        src = tmp / "fw60.S"
        src.write_text(text, encoding="ascii")
        obj = tmp / "fw60.o"
        elf = tmp / "fw60.elf"
        _run([str(AS), "-mcpu=ck803", "-o", str(obj), str(src)])
        _run([str(LD), "-Ttext=0x%X" % base, "-o", str(elf), str(obj)])
        code, addr = fw23_build.text_of(elf.read_bytes())
        if addr != base:
            raise SystemExit("linked at %X" % addr)
        end = base + len(code)
        if end > limit:
            raise SystemExit("stub %X ends %X, limit %X" % (base, end, limit))
        if end > TAIL_END:
            raise SystemExit("stub ends %X" % end)
        symbols = {}
        for line in _run([str(NM), str(elf)]).decode("utf-8", "replace").splitlines():
            parts = line.split()
            if len(parts) == 3 and parts[1] in ("T", "t"):
                symbols[parts[2]] = int(parts[0], 16)
        dump = _run([str(OBJDUMP), "-d", str(elf)]).decode("utf-8", "replace")
    return bytes(code), symbols, dump


def _ranges(dump, symbols, hooks):
    saved = fw59_build.HOOKS
    fw59_build.HOOKS = hooks
    try:
        return fw59_build._code_ranges(dump, symbols)
    finally:
        fw59_build.HOOKS = saved


def _pad(base, length):
    """Fill the rest of FW59's span so the bt at 0x5C62E is overwritten."""
    if length == 0:
        return b""
    if length % 2:
        raise SystemExit("pad")
    text = "\t.text\n\t.global\tpad\npad:\n" + ("\tnop\n" * (length // 2))
    code, _symbols, dump = _assemble_one(text, base, base + length)
    if len(code) != length:
        raise SystemExit("pad len %X" % len(code))
    fw59_build._prev_mnemonic(dump)
    return code


def _guards(old, img, check_space):
    fw59_build._guards(old, img, check_space)


def build():
    global CODE, SYMBOLS
    img = bytearray(SRC.read_bytes())
    old = bytes(img)
    if img[TAG] != b"DMR003.FW57.V022":
        raise SystemExit("tag")
    for site, expect in OLD_HOOK.items():
        if img[site:site + len(expect)] != expect:
            raise SystemExit("site %X" % site)
    if img[C_BASE:D_LIMIT] != old[C_BASE:D_LIMIT]:
        raise SystemExit("tail")
    c_code, c_sym, c_dump = _assemble_one(ASM_C, C_BASE, C_LIMIT)
    pad = _pad(C_BASE + len(c_code), C_LIMIT - (C_BASE + len(c_code)))
    d_code, d_sym, d_dump = _assemble_one(ASM_D, D_BASE, D_LIMIT)
    # The assembler prints this with a run of spaces. 2206 is addi r2, 7.
    if d_dump.count("r2, 7") != 2 or d_code.count(bytes.fromhex("0622")) != 2:
        raise SystemExit("addi")
    fw59_build._prev_mnemonic(c_dump)
    fw59_build._prev_mnemonic(d_dump)
    c_hooks = tuple(row for row in HOOKS if row[0].startswith("op6"))
    d_hooks = tuple(row for row in HOOKS if row[0].startswith("allcall"))
    c_ranges = _ranges(c_dump, c_sym, c_hooks)
    d_ranges = _ranges(d_dump, d_sym, d_hooks)
    for name in ("allcall_3", "allcall_2"):
        regs = fw59_build._regs(d_dump, *d_ranges[name])
        if not regs <= {2, 3, 15}:
            raise SystemExit("%s regs %s" % (name, regs))
        if 8 in regs:
            raise SystemExit("%s writes r8" % name)
    if fw59_build._regs(c_dump, *c_ranges["op6_apply"]) & {1, 4}:
        raise SystemExit("apply regs")
    if not fw59_build._regs(c_dump, *c_ranges["op6_release"]) <= {4, 5}:
        raise SystemExit("release regs")
    if struct.pack("<I", HOLD) not in c_code:
        raise SystemExit("hold word missing")
    for at in (0x5B2D6, 0x5BD3E):
        if struct.pack("<I", XIP + at) not in c_code:
            raise SystemExit("exit %X missing" % at)
    for at in EXITS:
        if struct.pack("<I", XIP + at) not in d_code:
            raise SystemExit("allcall exit %X missing" % at)
    img[C_BASE:C_BASE + len(c_code)] = c_code
    img[C_BASE + len(c_code):C_LIMIT] = pad
    img[D_BASE:D_BASE + len(d_code)] = d_code
    symbols = {}
    symbols.update(c_sym)
    symbols.update(d_sym)
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
    for at in EXITS + (0x5B2D6, 0x5BD3E, 0x5B2F4, 0x5B2B6):
        if img[at:at + 4] != old[at:at + 4]:
            raise SystemExit("moved %X" % at)
    if img[0x5B2CC:0x5B2D2] != old[0x5B2CC:0x5B2D2]:
        raise SystemExit("apply load")
    if C_BASE + len(c_code) + len(pad) != D_BASE:
        raise SystemExit("gap")
    if img[D_LIMIT:TAIL_END] != old[D_LIMIT:TAIL_END]:
        raise SystemExit("literal")
    _guards(old, bytes(img), True)
    img[TAG] = b"DMR003.FW60.V022"
    DEST.write_bytes(img)
    CODE = {}
    CODE.update(c_ranges)
    CODE.update(d_ranges)
    SYMBOLS = symbols
    global SPAN
    SPAN = (C_BASE, D_BASE + len(d_code))
    print(DEST.name)
    print(hashlib.sha256(bytes(img)).hexdigest())
    return DEST


def build_diag():
    if not DEST.is_file() or DEST.read_bytes()[TAG] != b"DMR003.FW60.V022":
        build()
    img = bytearray(DEST.read_bytes())
    old = bytes(img)
    if img[fw58_build.WIN_LO:fw58_build.WIN_LO + 4] != fw58_build.WIN_OLD[0]:
        raise SystemExit("window")
    if img[fw58_build.WIN_HI:fw58_build.WIN_HI + 4] != fw58_build.WIN_OLD[1]:
        raise SystemExit("window hi")
    img[fw58_build.WIN_LO:fw58_build.WIN_LO + 4] = fw58_build.WIN_NEW[0]
    img[fw58_build.WIN_HI:fw58_build.WIN_HI + 4] = fw58_build.WIN_NEW[1]
    _guards(old, bytes(img), False)
    img[TAG] = b"DMR003.F60D.V022"
    DIAG.write_bytes(img)
    print(DIAG.name)
    print(hashlib.sha256(bytes(img)).hexdigest())
    return DIAG


if __name__ == "__main__":
    build()
    build_diag()
