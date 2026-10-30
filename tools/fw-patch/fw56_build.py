# FW56: FW54 plus the FW50 key gate, in the two free ranges on the space map.
#
# Body 1 and body 2 call the gate. While 0x4DAAC is 0 they call stock
# 0xE9C once, which is the phone-audio path. While the flag is set they
# call on_key (0x5B580) and on_unkey (0x5B614), which is how M17 and the
# tone queue key. Op 1 sets the flag through the arm at 0x5B6A0.
#
# The arm is not at 0x5B700. That is the pitch helper. The tone-end nops
# and the live unkey at 0x5B74C stay as FW54 left them.
import hashlib
import struct
from pathlib import Path

import fw30_build
import fw50_build
import literal_guard
import space_map

ROOT = Path(__file__).resolve().parents[2]
SRC = ROOT / "radio_firmware" / "build" / "DMR003.FW54.V022.bin"
DEST = ROOT / "radio_firmware" / "build" / "DMR003.FW56.V022.bin"
TAG = slice(0x38464, 0x38474)
GATE_AT = 0x5B65C
ARM_AT = 0x5B6A0
ARM_END = 0x5B6C0
POOL = 0x5B690
APPEND = 0x5BDFE
APPEND_SITE = 0x5AF44
E9C = 0xE9C
KEY = 0x5B580
UNKEY = 0x5B614
HELPER = range(0x5B700, 0x5B720)
NOPS = 0x5B756


def build():
    img = bytearray(SRC.read_bytes())
    old = bytes(img)
    if img[TAG] != b"DMR003.FW54.V022":
        raise SystemExit("tag")
    if img[NOPS:NOPS + 6] != bytes.fromhex("0131036c036c"):
        raise SystemExit("nops")
    if fw30_build.bsr_target(img, 0x92AA) != UNKEY:
        raise SystemExit("unkey site")
    if fw30_build.bsr_target(img, 0x92C8) != KEY:
        raise SystemExit("key site")
    if fw30_build.bsr_target(img, APPEND_SITE) != APPEND:
        raise SystemExit("append")
    if img[POOL:POOL + 4] != struct.pack("<I", 0x4DAAC):
        raise SystemExit("flag pool")
    gate = fw50_build._linked(fw50_build.GATE_ASM, GATE_AT, "fw56g")
    syms = fw50_build._syms("fw56g")
    fw50_build._call(gate, GATE_AT, 0x11111111, E9C)
    fw50_build._call(gate, GATE_AT, 0x22222222, UNKEY)
    fw50_build._call(gate, GATE_AT, 0x33333333, KEY)
    gate = fw50_build._retarget_lrw(gate, GATE_AT, POOL)
    if GATE_AT + len(gate) > POOL:
        raise SystemExit("gate %d" % len(gate))
    arm = fw50_build._linked(fw50_build.ARM_ASM, ARM_AT, "fw56a")
    slot = arm.find(struct.pack("<I", 0x55555555))
    if slot < 0:
        raise SystemExit("arm branch")
    arm[slot:slot + 4] = fw30_build.encode_br(ARM_AT + slot, APPEND)
    if ARM_AT + len(arm) > ARM_END:
        raise SystemExit("arm %d" % len(arm))
    img[GATE_AT:GATE_AT + len(gate)] = gate
    img[ARM_AT:ARM_AT + len(arm)] = arm
    for site in (0x92AA, 0x92FA):
        img[site:site + 4] = fw30_build.encode_bsr(site, syms["unkey_gate"])
    for site in (0x92C8, 0x92E0):
        img[site:site + 4] = fw30_build.encode_bsr(site, syms["key_gate"])
    img[APPEND_SITE:APPEND_SITE + 4] = fw30_build.encode_bsr(APPEND_SITE, ARM_AT)
    if literal_guard.covered_loads(old, bytes(img))[1]:
        raise SystemExit("load guard")
    if literal_guard.covered_branches(old, bytes(img))[1]:
        raise SystemExit("branch guard")
    if literal_guard.never_written(old, bytes(img)):
        raise SystemExit("never-write")
    if space_map.outside_free(old, bytes(img)):
        raise SystemExit("space map %s" % space_map.outside_free(old, bytes(img)))
    img[TAG] = b"DMR003.FW56.V022"
    DEST.write_bytes(img)
    print(DEST.name)
    print(hashlib.sha256(bytes(img)).hexdigest())
    print("gate", len(gate), "arm", len(arm))
    return DEST
