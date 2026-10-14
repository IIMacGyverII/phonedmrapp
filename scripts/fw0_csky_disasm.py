#!/usr/bin/env python3
"""Small C-SKY V2 disassembler for the UART builder helpers.

Does not patch. Enough opcodes to read +0x8E5C / +0x7DE8.
"""
from __future__ import annotations

import struct
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
BIN = ROOT / "radio_firmware" / "DMR003.UV4T.V022-ORIGINAL.bin"


def u16(data: bytes, off: int) -> int:
    return struct.unpack_from("<H", data, off)[0]


def is32(hw: int) -> bool:
    return (hw & 0xC000) == 0xC000


def sext(val: int, bits: int) -> int:
    sign = 1 << (bits - 1)
    return (val & (sign - 1)) - (val & sign)


def dis16(hw: int, pc: int) -> str:
    # lrw16: 15:13=000, 11:10=00
    if (hw & 0xEC00) == 0x0000 and hw != 0:
        rz = (hw >> 5) & 7
        lab = ((hw >> 12) & 1) << 7 | ((hw >> 8) & 3) << 5 | (hw & 0x1F)
        return f"lrw16 r{rz}, pool+{lab}*4"
    if hw == 0x783C:
        return "rts16"
    if hw == 0x6C03:
        return "nop"
    if hw == 0x1460:
        return "nie"
    if hw == 0x1461:
        return "nir"
    if 0x14C0 <= hw <= 0x14DF:
        return f"push16 0x{hw & 0x1F:x}"
    if 0x1480 <= hw <= 0x149F:
        return f"pop16 0x{hw & 0x1F:x}"

    # cmphsi16/cmplti16/cmpnei16: 15:10=001110, 9:8=sop, 7:5=rz, 4:0=imm5
    # LLVM CSKYInstrInfo16: sop 00=cmphsi (oimm5), 01=cmplti (oimm5), 10=cmpnei (uimm5)
    if (hw & 0xFC00) == 0x3800:
        sop = (hw >> 8) & 3
        rz = (hw >> 5) & 7
        imm5 = hw & 0x1F
        if sop == 0:
            return f"cmphsi16 r{rz}, #0x{imm5 + 1:x}"
        if sop == 1:
            return f"cmplti16 r{rz}, #0x{imm5 + 1:x}"
        if sop == 2:
            return f"cmpnei16 r{rz}, #0x{imm5:x}"
        return f"cmpi16 sop{sop} r{rz}, #{imm5}"

    # movi16: 15:11=00110
    if (hw & 0xF800) == 0x3000:
        return f"movi16 r{(hw >> 8) & 7}, #0x{hw & 0xFF:x}"
    # addi16 rz, #imm8: 15:11=00100
    if (hw & 0xF800) == 0x2000:
        return f"addi16 r{(hw >> 8) & 7}, #0x{hw & 0xFF:x}"
    # subi16: 15:11=00101
    if (hw & 0xF800) == 0x2800:
        return f"subi16 r{(hw >> 8) & 7}, #0x{hw & 0xFF:x}"

    # ld/st 16: 15:14=10, 13:11=sop
    if (hw & 0xC000) == 0x8000:
        sop = (hw >> 11) & 7
        rx = (hw >> 8) & 7
        rz = (hw >> 5) & 7
        imm = hw & 0x1F
        names = {
            0: "ld16.b",
            1: "ld16.h",
            2: "ld16.w",
            3: "ld16.w sp",
            4: "st16.b",
            5: "st16.h",
            6: "st16.w",
            7: "st16.w sp",
        }
        scale = {0: 1, 1: 2, 2: 4, 3: 4, 4: 1, 5: 2, 6: 4, 7: 4}.get(sop, 1)
        return f"{names.get(sop, 'ldst16')} r{rz}, (r{rx}, #{imm * scale})"

    # br16: 15=0, 14:10=00001 → 0x0400
    if (hw & 0xFC00) == 0x0400:
        off = sext(hw & 0x3FF, 10) << 1
        return f"br16 0x{pc + 2 + off:x}"
    if (hw & 0xFC00) == 0x0800:
        off = sext(hw & 0x3FF, 10) << 1
        return f"bt16 0x{pc + 2 + off:x}"
    if (hw & 0xFC00) == 0x0C00:
        off = sext(hw & 0x3FF, 10) << 1
        return f"bf16 0x{pc + 2 + off:x}"

    # zext/sext: 15:14=01, 13:10=1101
    if (hw & 0xFC00) == 0x7400:
        rz = (hw >> 6) & 0xF
        rx = (hw >> 2) & 0xF
        n = {0: "zextb16", 1: "zexth16", 2: "sextb16", 3: "sexth16"}.get(hw & 3, "ext16")
        return f"{n} r{rz}, r{rx}"
    # MOV16: 15:14=01, 13:10=1011, 1:0=11
    if (hw & 0xFC03) == 0x6C03:
        rz = (hw >> 6) & 0xF
        rx = (hw >> 2) & 0xF
        return f"mov16 r{rz}, r{rx}"
    # NOR/NOT: 15:14=01 13:10=1011 1:0=10
    if (hw & 0xFC03) == 0x6C02:
        rz = (hw >> 6) & 0xF
        rx = (hw >> 2) & 0xF
        if rz == rx:
            return f"not16 r{rz}"
        return f"nor16 r{rz}, r{rx}"
    # OR: sop 00
    if (hw & 0xFC03) == 0x6C00:
        rz = (hw >> 6) & 0xF
        rx = (hw >> 2) & 0xF
        return f"or16 r{rz}, r{rx}"
    # XOR sop 01
    if (hw & 0xFC03) == 0x6C01:
        rz = (hw >> 6) & 0xF
        rx = (hw >> 2) & 0xF
        return f"xor16 r{rz}, r{rx}"
    # AND: 15:14=01 13:10=1010 sop 00
    if (hw & 0xFC03) == 0x6800:
        rz = (hw >> 6) & 0xF
        rx = (hw >> 2) & 0xF
        return f"and16 r{rz}, r{rx}"
    # ADDU 2-op: 15:14=01 13:10=1000 sop 00 → 0x6000
    if (hw & 0xFC03) == 0x6000:
        rz = (hw >> 6) & 0xF
        rx = (hw >> 2) & 0xF
        return f"addu16 r{rz}, r{rx}"
    if (hw & 0xFC03) == 0x6002:
        rz = (hw >> 6) & 0xF
        rx = (hw >> 2) & 0xF
        return f"subu16 r{rz}, r{rx}"
    # cmphs/cmplt/cmpne: 15:14=01 13:10=1001
    if (hw & 0xFC00) == 0x6400:
        sop = hw & 3
        ry = (hw >> 6) & 0xF
        rx = (hw >> 2) & 0xF
        n = {0: "cmphs16", 1: "cmplt16", 2: "cmpne16"}.get(sop, f"cmp16 sop{sop}")
        return f"{n} r{rx}, r{ry}"

    # 3-reg addu16: 15:11=01011
    if (hw & 0xF800) == 0x5800:
        rx = (hw >> 8) & 7
        rz = (hw >> 5) & 7
        ry = (hw >> 2) & 7
        sop = hw & 3
        n = {0: "addu16", 1: "subu16"}.get(sop, f"alu3 sop{sop}")
        return f"{n} r{rz}, r{rx}, r{ry}"

    # lsli/lsri/asri: 15:14=01, 13:11=sop 0/1/2, but overlap...
    # I16_XZ_IMM5: 15:14=01, 13:11=sop, 10:8=rx, 7:5=rz, 4:0=imm5
    if (hw & 0xC000) == 0x4000 and ((hw >> 11) & 7) <= 2:
        sop = (hw >> 11) & 7
        rx = (hw >> 8) & 7
        rz = (hw >> 5) & 7
        imm5 = hw & 0x1F
        n = {0: "lsli16", 1: "lsri16", 2: "asri16"}.get(sop)
        if n:
            return f"{n} r{rz}, r{rx}, #{imm5}"

    return f".hword 0x{hw:04x}"


def dis32(inst: int, pc: int) -> str:
    opc = (inst >> 26) & 0x3F
    rz = (inst >> 21) & 0x1F
    rx = (inst >> 16) & 0x1F
    sop4 = (inst >> 12) & 0xF
    imm12 = inst & 0xFFF
    sop5 = (inst >> 21) & 0x1F
    ry = (inst >> 21) & 0x1F  # for some formats ry is 25:21
    imm16 = inst & 0xFFFF

    if opc == 0x38:  # bsr32
        imm = inst & 0x3FFFFFF
        tgt = pc + (sext(imm, 26) << 1)
        return f"bsr32 0x{tgt:x}"
    if opc == 0x36:
        n = {0: "ld32.b", 1: "ld32.h", 2: "ld32.w", 4: "ld32.bs", 5: "ld32.hs"}.get(sop4, f"ld32 sop{sop4}")
        scale = {0: 1, 1: 2, 2: 4, 4: 1, 5: 2}.get(sop4, 1)
        return f"{n} r{rz}, (r{rx}, #{imm12 * scale})"
    if opc == 0x37:
        n = {0: "st32.b", 1: "st32.h", 2: "st32.w"}.get(sop4, f"st32 sop{sop4}")
        scale = {0: 1, 1: 2, 2: 4}.get(sop4, 1)
        return f"{n} r{rz}, (r{rx}, #{imm12 * scale})"
    if opc == 0x39:
        n = {0: "addi32", 1: "subi32", 2: "andi32", 3: "andni32", 4: "xori32"}.get(sop4, f"imm12 sop{sop4}")
        return f"{n} r{rz}, r{rx}, #0x{imm12:x}"
    if opc == 0x3A:
        # LLVM I_16_L / I_16_X / I_16_X_L / I_16_MOV / I_16_JX — opcode 0x3A
        rz2 = (inst >> 16) & 0x1F  # rx or rz depending on format
        br_tgt = pc + (sext(imm16, 16) << 1)
        pool = ((pc + 4) & ~3) + (imm16 << 2)
        if sop5 == 0x00:
            return f"br32 0x{br_tgt:x}"
        if sop5 == 0x02:
            return f"bf32 0x{br_tgt:x}"
        if sop5 == 0x03:
            return f"bt32 0x{br_tgt:x}"
        if sop5 == 0x06:
            return f"jmp32 r{rz2}"
        if sop5 == 0x07:
            return f"jsr32 r{rz2}"
        if sop5 == 0x08:
            return f"bez32 r{rz2}, 0x{br_tgt:x}"
        if sop5 == 0x09:
            return f"bnez32 r{rz2}, 0x{br_tgt:x}"
        if sop5 == 0x0A:
            return f"bhz32 r{rz2}, 0x{br_tgt:x}"
        if sop5 == 0x0B:
            return f"blsz32 r{rz2}, 0x{br_tgt:x}"
        if sop5 == 0x0C:
            return f"blz32 r{rz2}, 0x{br_tgt:x}"
        if sop5 == 0x0D:
            return f"bhsz32 r{rz2}, 0x{br_tgt:x}"
        if sop5 == 0x10:
            return f"movi32 r{rz2}, #0x{imm16:x}"
        if sop5 == 0x11:
            return f"movih32 r{rz2}, #0x{imm16:x}"
        if sop5 == 0x14:
            return f"lrw32 r{rz2}, [0x{pool:x}]"
        if sop5 == 0x16:
            return f"jmpi32 [0x{pool:x}]"
        if sop5 == 0x17:
            return f"jsri32 [0x{pool:x}]"
        if sop5 == 0x18:
            return f"cmphsi32 r{rz2}, #{imm16 + 1}"
        if sop5 == 0x19:
            return f"cmplti32 r{rz2}, #{imm16 + 1}"
        if sop5 == 0x1A:
            return f"cmpnei32 r{rz2}, #0x{imm16:x}"
        return f"op3a sop={sop5:#x} r{rz2}, #0x{imm16:x}"
    if opc == 0x31:
        # ALU: ry 25:21, rx 20:16, sop 15:10, pcode 9:5, rz 4:0
        ry = (inst >> 21) & 0x1F
        rx = (inst >> 16) & 0x1F
        sop = (inst >> 10) & 0x3F
        pcode = (inst >> 5) & 0x1F
        rz = inst & 0x1F
        if sop == 0 and pcode == 1:
            return f"addu32 r{rz}, r{rx}, r{ry}"
        if sop == 0 and pcode == 4:
            return f"subu32 r{rz}, r{rx}, r{ry}"
        if sop == 1 and pcode == 4:
            return f"cmpne32 r{rx}, r{ry}"
        if sop == 1 and pcode == 1:
            return f"cmphs32 r{rx}, r{ry}"
        if sop == 1 and pcode == 2:
            return f"cmplt32 r{rx}, r{ry}"
        return f"alu32 sop={sop:#x} p={pcode:#x} r{rz}, r{rx}, r{ry}"
    if opc == 0x3B:
        return f"ori32 r{rz}, r{rx}, #0x{imm16:x}"
    return f".word 0x{inst:08x} opc={opc:#x}"


def iter_insns(data: bytes, start: int, end: int):
    """Yield (off, size, text, raw). raw is 16- or 32-bit encoding."""
    off = start
    n = len(data)
    end = min(end, n)
    while off < end and off + 2 <= n:
        hw = u16(data, off)
        if is32(hw):
            if off + 4 > n:
                break
            inst = (hw << 16) | u16(data, off + 2)
            yield off, 4, dis32(inst, off), inst
            off += 4
        else:
            yield off, 2, dis16(hw, off), hw
            off += 2


def disasm_range(data: bytes, start: int, end: int) -> None:
    print(f"\n==== {start:#x} .. {end:#x} ====")
    for off, size, text, raw in iter_insns(data, start, end):
        if size == 4:
            print(f"  {off:#07x}  {raw:08x}  {text}")
        else:
            print(f"  {off:#07x}  {raw:04x}      {text}")


def main() -> int:
    data = BIN.read_bytes()
    disasm_range(data, 0x8E5C, 0x8E7C)
    disasm_range(data, 0x7D94, 0x7DE8)
    disasm_range(data, 0x7DE8, 0x7E08)
    disasm_range(data, 0x5EF4, 0x5F80)
    disasm_range(data, 0x18E8, 0x1930)
    disasm_range(data, 0x1924, 0x1960)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
