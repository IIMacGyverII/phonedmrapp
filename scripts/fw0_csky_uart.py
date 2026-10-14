#!/usr/bin/env python3
"""FW-B1: C-SKY V2 synced walk for UART frame bytes and nearby stores.

Does not patch. Protocol bytes from OEM Packet: 0x68 head, 0x10 tail,
0x22/0x23/0x2B/0x36/0xAA cmds.
"""
from __future__ import annotations

import struct
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
BIN = ROOT / "radio_firmware" / "DMR003.UV4T.V022-ORIGINAL.bin"

PROT = {
    0x68: "HEAD",
    0x10: "TAIL",
    0x22: "SET_DIGITAL",
    0x23: "SET_ANALOG",
    0x2B: "Q_DIG_AUDIO",
    0x36: "STATUS",
    0xAA: "INIT",
    0x30: "SQUELCH",
    0x3B: "TOT",
}


def u16(data: bytes, off: int) -> int:
    return struct.unpack_from("<H", data, off)[0]


def is32(hw: int) -> bool:
    return (hw & 0xC000) == 0xC000


def decode_movi16(hw: int) -> tuple[int, int] | None:
    """movi16 rz, #imm8: bits 15:11=00110, 10:8=rz, 7:0=imm8."""
    if (hw & 0xF800) != 0x3000:
        return None
    return (hw >> 8) & 7, hw & 0xFF


def decode_movi32(inst: int) -> tuple[int, int] | None:
    """movi32: opcode 0x3a sop 0x10, rz bits 20:16, imm16 bits 15:0."""
    if ((inst >> 26) & 0x3F) != 0x3A:
        return None
    if ((inst >> 21) & 0x1F) != 0x10:
        return None
    return (inst >> 16) & 0x1F, inst & 0xFFFF


def decode_stb16(hw: int) -> tuple[int, int, int] | None:
    """st16.b rz, (rx, imm5): 15:14=10, 13:11=100."""
    if (hw & 0xF800) != 0xA000:
        return None
    rx = (hw >> 8) & 7
    rz = (hw >> 5) & 7
    imm = hw & 0x1F
    return rz, rx, imm


def decode_stb32(inst: int) -> tuple[int, int, int] | None:
    """st32.b: opcode 0x37 sop 0."""
    if ((inst >> 26) & 0x3F) != 0x37:
        return None
    if ((inst >> 12) & 0xF) != 0:
        return None
    rz = (inst >> 21) & 0x1F
    rx = (inst >> 16) & 0x1F
    imm = inst & 0xFFF
    return rz, rx, imm


def walk_insns(data: bytes):
    """Yield (off, size, kind, payload). kind: movi16/movi32/stb16/stb32/other."""
    off = 0
    n = len(data)
    while off + 2 <= n:
        hw = u16(data, off)
        if is32(hw):
            if off + 4 > n:
                break
            inst = (hw << 16) | u16(data, off + 2)
            m = decode_movi32(inst)
            if m:
                yield off, 4, "movi32", m
            else:
                s = decode_stb32(inst)
                if s:
                    yield off, 4, "stb32", s
                else:
                    yield off, 4, "other32", inst
            off += 4
        else:
            m = decode_movi16(hw)
            if m:
                yield off, 2, "movi16", m
            else:
                s = decode_stb16(hw)
                if s:
                    yield off, 2, "stb16", s
                else:
                    yield off, 2, "other16", hw
            off += 2


def main() -> int:
    data = BIN.read_bytes()
    insns = list(walk_insns(data))
    print(f"file {BIN}  insns={len(insns)}")

    movis = []
    for i, (off, sz, kind, pl) in enumerate(insns):
        if kind in ("movi16", "movi32"):
            rz, imm = pl
            if imm in PROT:
                movis.append((i, off, kind, rz, imm))

    print("\n=== movi of protocol bytes (synced C-SKY walk) ===")
    by_imm: dict[int, int] = {}
    for i, off, kind, rz, imm in movis:
        by_imm[imm] = by_imm.get(imm, 0) + 1
    for imm, name in sorted(PROT.items()):
        print(f"  #{imm:#04x} ({name}): {by_imm.get(imm, 0)}")

    print("\n=== each protocol movi + next ~8 insns (store?) ===")
    shown = 0
    for i, off, kind, rz, imm in movis:
        if shown >= 80:
            print("  ... truncated")
            break
        window = insns[i : i + 9]
        stores = []
        for off2, sz2, kind2, pl2 in window[1:]:
            if kind2 == "stb16":
                srz, srx, simm = pl2
                if srz == rz or (rz < 8 and srz == rz):
                    stores.append(f"st16.b r{srz}, (r{srx}, #{simm}) @{off2:#x}")
            elif kind2 == "stb32":
                srz, srx, simm = pl2
                if srz == rz:
                    stores.append(f"st32.b r{srz}, (r{srx}, #{simm}) @{off2:#x}")
        mark = "  STORE" if stores else "       "
        print(
            f"{mark} {off:#07x} {kind} r{rz}, #{imm:#04x} {PROT[imm]:12} "
            f"{'; '.join(stores) if stores else ''}"
        )
        shown += 1

    # HEAD then TAIL close in program order
    print("\n=== movi #0x68 then movi #0x10 within 16 insns ===")
    n_pair = 0
    for i, off, kind, rz, imm in movis:
        if imm != 0x68:
            continue
        for j, off2, kind2, rz2, imm2 in movis:
            if off2 <= off:
                continue
            if off2 - off > 64:
                break
            # use insn index distance
        # index-based
        for j, off2, kind2, rz2, imm2 in movis:
            if j <= i:
                continue
            if j - i > 16:
                break
            if imm2 == 0x10:
                n_pair += 1
                print(
                    f"  HEAD {off:#07x} r{rz}  then TAIL {off2:#07x} r{rz2}  "
                    f"delta_insns={j-i} delta_bytes={off2-off}"
                )
    print(f"  pairs: {n_pair}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
