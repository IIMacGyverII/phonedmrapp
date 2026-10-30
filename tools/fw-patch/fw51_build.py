# FW51: FW50's gate, plus one stock unkey per symbol key.
# Flag word 0x4DAAC: 0 = stock 0x26, 1 = symbol transfer, 2 = already off.
# A body 2 that sees 2 clears it and returns without a second 0xE9C.
# The symbol end calls 0xE9C(r1=1) before the drop, then stores 2.
import hashlib
import struct
import subprocess
from pathlib import Path

import fw30_build
import literal_guard

ROOT = Path(__file__).resolve().parents[2]
SRC = ROOT / "radio_firmware" / "build" / "DMR003.FW46.V022.bin"
DEST = ROOT / "radio_firmware" / "build" / "DMR003.FW51.V022.bin"
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
    # Symbol end: flag becomes 2, then 0xE9C(r1=1) before the drop.
    # 0x5B736 is movi r2, 0. The 20 bytes at 0x5B748 were the drop,
    # the r0 setup, and a second 0xE9C.
    if img[0x5B736:0x5B738] != bytes.fromhex("0032"):
        raise SystemExit("flag clear")
    img[0x5B736:0x5B738] = bytes.fromhex("0232")
    end = _linked(END_ASM, 0x5B748, "fw51e")
    if len(end) != 20:
        raise SystemExit("end %d" % len(end))
    es = end.find(struct.pack("<I", 0x11111111))
    ed = end.find(struct.pack("<I", 0x22222222))
    if es < 0 or ed < 0:
        raise SystemExit("end tokens")
    end[es:es + 4] = fw30_build.encode_bsr(0x5B748 + es, E9C)
    end[ed:ed + 4] = fw30_build.encode_bsr(0x5B748 + ed, 0x5BD98)
    img[0x5B748:0x5B75C] = end
    if img[0x5B626:0x5B628] != bytes.fromhex("0032"):
        raise SystemExit("host clear")
    img[0x5B626:0x5B628] = bytes.fromhex("0232")
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
    img[TAG] = b"DMR003.FW51.V022"
    DEST.write_bytes(img)
    print(DEST.name)
    print(hashlib.sha256(bytes(img)).hexdigest())
    print("gate", len(gate), "at", hex(GATE_AT),
          "unkey", hex(syms["unkey_gate"]), "arm", len(arm))
    if fw30_build.bsr_target(bytes(img), 0x92AA) != syms["unkey_gate"]:
        raise SystemExit("link")


if __name__ == "__main__":
    build()
