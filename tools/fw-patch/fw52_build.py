# FW52: FW51, plus the early host unkey clears the countdown and refuses
# any further symbol chunk. Flag word 0x4DAAC stays 0. The refuse word
# 0x4D900 is set by that unkey and cleared by opcode 3 (the next stream).
import hashlib
import struct
import subprocess
from pathlib import Path

import fw30_build
import literal_guard

ROOT = Path(__file__).resolve().parents[2]
SRC = ROOT / "radio_firmware" / "build" / "DMR003.FW46.V022.bin"
DEST = ROOT / "radio_firmware" / "build" / "DMR003.FW52.V022.bin"
TAG = slice(0x38464, 0x38474)
HOLE = 0x5B65A
HOLE_END = 0x5B690
WRAP = 0x5B700
WRAP_END = 0x5B720
LIVE = 0x5B720
E9C = 0xE9C
UNKEY = 0x5B614
KEY = 0x5B580
APPEND = 0x5BDFE
APPEND_SITE = 0x5AF44
R1 = 0x5B756
FLAG = 0x4DAAC
OBJDUMP = Path(r"C:\Users\Joshua\tools\csky-elfabiv2\bin\csky-elfabiv2-objdump.exe")

# r12 selects key (1) or unkey (0). r2 keeps the flag address. A flag of 2
# is the already-off marker. The literal stays the live pool at 0x5B690.
GATE_AT = 0x5B65C
ARM_END = 0x5B718
POOL = 0x5B690

GATE_ASM = """
	.text
	.global	key_gate
	.global	unkey_gate
key_gate:
	movi	r3, 1
	br	.Lbody
unkey_gate:
	movi	r3, 0
.Lbody:
	push	r15
	mov	r12, r3
	lrw	r2, 0x4daac
	ld.w	r3, (r2, 0)
	cmpnei	r3, 0
	bt	.Lnz
	.long	0x11111111
	pop	r15
.Lnz:
	cmpnei	r3, 2
	bt	.Lsym
	movi	r3, 0
	st.w	r3, (r2, 0)
	pop	r15
.Lsym:
	cmpnei	r12, 0
	bt	.Lkey
	.long	0x22222222
	pop	r15
.Lkey:
	.long	0x33333333
	pop	r15
"""

# r2 is live across the op 1 call: 0x5BDFE jumps to 0x5AF52, which does subi r2, 1.
ARM_ASM = """
	.text
	.global	arm_flag
arm_flag:
	subi	sp, 4
	st.w	r2, (sp, 0)
	movih	r2, 4
	ori	r2, r2, 0xdaac
	movi	r3, 1
	st.w	r3, (r2, 0)
	ld.w	r2, (sp, 0)
	addi	sp, 4
	.long	0x55555555
"""

# Replaces 0x5B748..0x5B75C. r7 is the mode byte. One 0xE9C, then the drop.
END_ASM = """
	.text
	.global	end_unkey
end_unkey:
	mov	r0, r7
	movi	r1, 1
	.long	0x11111111
	.long	0x22222222
	br	.Lout
	nop
	nop
	nop
.Lout:
"""


def _linked(asm, base, name):
    return bytearray(fw30_build._linked(asm, base, name))


def _call(code, base, token, dest):
    slot = code.find(struct.pack("<I", token))
    if slot < 0:
        raise SystemExit("token %X" % token)
    code[slot:slot + 4] = fw30_build.encode_bsr(base + slot, dest)


def _syms(name):
    elf = Path(r"C:\Users\Joshua\AppData\Local\Temp\fw1718\fw30") / ("%s.elf" % name)
    out = subprocess.check_output([str(OBJDUMP), "-t", str(elf)], text=True, errors="replace")
    found = {}
    for line in out.splitlines():
        parts = line.split()
        if len(parts) >= 4 and parts[0][:1].isalnum():
            try:
                found[parts[-1]] = int(parts[0], 16)
            except ValueError:
                pass
    return found


def _encode_lrw_r3(at, pool):
    base = (at + 5) & ~3
    imm = (pool - base) // 4
    if not 0 <= imm <= 31 or base + imm * 4 != pool:
        raise SystemExit("lrw r3 from %X to %X" % (at, pool))
    return struct.pack("<H", 0x1061 + imm)


def _encode_br16(at, target):
    disp = (target - at) >> 1
    if not -512 <= disp < 512:
        raise SystemExit("br16 from %X to %X" % (at, target))
    return struct.pack("<H", 0x0400 | (disp & 0x3FF))


def _encode_bt16(at, target):
    disp = (target - at) >> 1
    if not -512 <= disp < 512:
        raise SystemExit("bt16 from %X to %X" % (at, target))
    return struct.pack("<H", 0x0800 | (disp & 0x3FF))


def _encode_lrw_r2(at, pool):
    base = (at + 5) & ~3
    imm = (pool - base) // 4
    if not 0 <= imm <= 63 or base + imm * 4 != pool:
        raise SystemExit("lrw r2 from %X to %X" % (at, pool))
    half = 0x1041 + (imm & 31) + ((imm >> 5) << 8)
    return struct.pack("<H", half)


def _retarget_lrw(code, base, pool):
    """Point the gate's own lrw at the live flag literal and drop its pool."""
    own = code.find(struct.pack("<I", FLAG))
    if own < 0:
        raise SystemExit("gate pool")
    hit = None
    for i in range(0, own, 2):
        half = struct.unpack_from("<H", code, i)[0]
        hi, lo = (half >> 8) & 0xFF, half & 0xFF
        if hi not in (0x10, 0x11) or not 0x41 <= lo <= 0x60:
            continue
        imm = (lo - 0x41) + (32 if hi == 0x11 else 0)
        at = base + i
        b = (at + 5) & ~3
        if b + imm * 4 == base + own:
            hit = i
    if hit is None:
        raise SystemExit("lrw site")
    code[hit:hit + 2] = _encode_lrw_r2(base + hit, pool)
    end = own
    if end >= 2 and code[end - 2:end] == b"\x00\x00":
        end -= 2
    return code[:end]


def _fw52_early(img):
    """Early host unkey: zero the countdowns, refuse later symbol chunks.

    The flag store at 0x5B628 already writes 0 before 0xE9C. This runs
    after that call. Opcode 1 sees 0x4D900 and does not store the flag.
    Opcode 3 clears 0x4D900 so the next stream is accepted.
    """
    refuse = 0x4D900
    pool = 0x5B770
    if img[pool:pool + 4] == struct.pack("<I", refuse):
        raise SystemExit("refuse pool already set")
    # The countdown literal the end task already owns.
    if img[0x5B784:0x5B788] != struct.pack("<I", 0x4B00C):
        raise SystemExit("countdown pool")
    if img[0x5B632:0x5B636] != fw30_build.encode_bsr(0x5B632, E9C):
        raise SystemExit("unkey e9c")
    if img[0x5AF32:0x5AF36] != fw30_build.encode_br(0x5AF32, 0x5B370):
        raise SystemExit("op3 tail")
    arm = bytearray(24)
    arm[0:2] = bytes.fromhex("8b6d")                          # mov r6, r2
    arm[2:4] = _encode_lrw_r2(0x5B702, pool)
    arm[4:6] = bytes.fromhex("6092")                          # ld.w r3, (r2, 0)
    arm[6:8] = bytes.fromhex("403b")                          # cmpnei r3, 0
    arm[8:10] = _encode_bt16(0x5B708, 0x5B74C)
    arm[10:12] = bytes.fromhex("0133")                        # movi r3, 1
    arm[12:14] = _encode_lrw_r2(0x5B70C, 0x5B780)
    arm[14:16] = bytes.fromhex("60b2")                        # st.w r3, (r2, 0)
    arm[16:18] = bytes.fromhex("9b6c")                        # mov r2, r6
    arm[18:22] = fw30_build.encode_br(0x5B712, APPEND)
    arm[22:24] = bytes.fromhex("036c")                        # mov r0, r0
    img[0x5B700:0x5B718] = arm
    stub = bytearray(0x28)
    stub[0:4] = fw30_build.encode_br(0x5B74C, 0x5AFB8)
    stub[4:8] = fw30_build.encode_bsr(0x5B750, E9C)
    stub[8:10] = bytes.fromhex("0032")                        # movi r2, 0
    stub[10:12] = _encode_lrw_r3(0x5B756, 0x5B784)
    stub[12:14] = bytes.fromhex("40b3")                       # st.w r2, (r3, 0)
    stub[14:16] = bytes.fromhex("41b3")                       # st.w r2, (r3, 4)
    stub[16:18] = bytes.fromhex("0132")                       # movi r2, 1
    stub[18:20] = _encode_lrw_r3(0x5B75E, pool)
    stub[20:22] = bytes.fromhex("40b3")
    stub[22:24] = _encode_br16(0x5B762, 0x5B636)
    stub[24:26] = bytes.fromhex("0032")                       # opcode 3: clear
    stub[26:28] = _encode_lrw_r3(0x5B766, pool)
    stub[28:30] = bytes.fromhex("40b3")
    stub[30:34] = fw30_build.encode_br(0x5B76A, 0x5B370)
    stub[36:40] = struct.pack("<I", refuse)
    if 0x5B74C + len(stub) > 0x5B774:
        raise SystemExit("stub over live countdown")
    img[0x5B74C:0x5B74C + len(stub)] = stub
    img[0x5B632:0x5B636] = fw30_build.encode_br(0x5B632, 0x5B750)
    img[0x5AF32:0x5AF36] = fw30_build.encode_br(0x5AF32, 0x5B764)


def build():
    img = bytearray(SRC.read_bytes())
    old = bytes(img)
    if img[TAG] != b"DMR003.FW46.V022":
        raise SystemExit("tag")
    if img[LIVE:LIVE + 2] != bytes.fromhex("d414"):
        raise SystemExit("live")
    if img[R1:R1 + 2] != bytes.fromhex("0031"):
        raise SystemExit("r1")
    if img[POOL:POOL + 4] != struct.pack("<I", FLAG):
        raise SystemExit("flag pool")
    if fw30_build.bsr_target(img, 0x92AA) != UNKEY:
        raise SystemExit("unkey site")
    if fw30_build.bsr_target(img, 0x92C8) != KEY:
        raise SystemExit("key site")
    if fw30_build.bsr_target(img, APPEND_SITE) != APPEND:
        raise SystemExit("append")
    gate = _linked(GATE_ASM, GATE_AT, "fw50g")
    syms = _syms("fw50g")
    if syms.get("key_gate") != GATE_AT or "unkey_gate" not in syms:
        raise SystemExit("symbols %s" % syms)
    _call(gate, GATE_AT, 0x11111111, E9C)
    _call(gate, GATE_AT, 0x22222222, UNKEY)
    _call(gate, GATE_AT, 0x33333333, KEY)
    gate = _retarget_lrw(gate, GATE_AT, POOL)
    if GATE_AT + len(gate) > HOLE_END:
        raise SystemExit("gate %d at %X" % (len(gate), GATE_AT))
    arm = _linked(ARM_ASM, WRAP, "fw50a")
    slot = arm.find(struct.pack("<I", 0x55555555))
    if slot < 0:
        raise SystemExit("arm branch")
    arm[slot:slot + 4] = fw30_build.encode_br(WRAP + slot, APPEND)
    if WRAP + len(arm) > ARM_END:
        raise SystemExit("arm %d" % len(arm))
    if arm.find(struct.pack("<I", FLAG)) >= 0:
        raise SystemExit("arm pool")
    img[GATE_AT:GATE_AT + len(gate)] = gate
    img[WRAP:WRAP + len(arm)] = arm
    for site in (0x92AA, 0x92FA):
        img[site:site + 4] = fw30_build.encode_bsr(site, syms["unkey_gate"])
    for site in (0x92C8, 0x92E0):
        img[site:site + 4] = fw30_build.encode_bsr(site, syms["key_gate"])
    img[APPEND_SITE:APPEND_SITE + 4] = fw30_build.encode_bsr(APPEND_SITE, WRAP)
    # The symbol-end task must not call 0xE9C. That call does not finish
    # and does not send status 4. Leave the flag at 0 (the store above)
    # and skip the drop and the 0xE9C. The host body 2 then takes the
    # stock 0xE9C once, on the command task, which is the plain-FM unkey.
    if img[0x5B748:0x5B74C] != fw30_build.encode_bsr(0x5B748, 0x5BD98):
        raise SystemExit("drop site")
    img[0x5B748:0x5B74C] = fw30_build.encode_br(0x5B748, 0x5B77A)
    _fw52_early(img)
    if img[LIVE:LIVE + 2] != bytes.fromhex("d414"):
        raise SystemExit("live moved")
    if img[POOL:POOL + 4] != struct.pack("<I", FLAG):
        raise SystemExit("pool moved")
    if literal_guard.covered_loads(old, bytes(img))[1]:
        raise SystemExit("load guard")
    if literal_guard.covered_branches(old, bytes(img))[1]:
        raise SystemExit("branch guard")
    if literal_guard.never_written(old, bytes(img)):
        raise SystemExit("never-write")
    # Opcode 14 window covers the flag word so the proof can read it back.
    if img[0x5C0CE:0x5C0D2] != bytes.fromhex("21ea0018"):
        raise SystemExit("lo")
    if img[0x5C0D6:0x5C0DA] != bytes.fromhex("21ea0118"):
        raise SystemExit("hi")
    img[0x5C0CE:0x5C0D2] = bytes.fromhex("21ea0300")
    img[0x5C0D6:0x5C0DA] = bytes.fromhex("21ea0500")
    if literal_guard.covered_loads(old, bytes(img))[1]:
        raise SystemExit("window load")
    if literal_guard.covered_branches(old, bytes(img))[1]:
        raise SystemExit("window branch")
    img[TAG] = b"DMR003.FW52.V022"
    DEST.write_bytes(img)
    print(DEST.name)
    print(hashlib.sha256(bytes(img)).hexdigest())
    print("gate", len(gate), "at", hex(GATE_AT),
          "unkey", hex(syms["unkey_gate"]), "arm", len(arm))
    if fw30_build.bsr_target(bytes(img), 0x92AA) != syms["unkey_gate"]:
        raise SystemExit("link")


if __name__ == "__main__":
    build()
