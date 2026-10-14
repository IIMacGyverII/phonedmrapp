#!/usr/bin/env python3
"""Walk ORIGINAL.bin as C-SKY V2 mixed 16/32-bit. Does not patch."""
from __future__ import annotations

import collections
import struct
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
BIN = ROOT / "radio_firmware" / "DMR003.UV4T.V022-ORIGINAL.bin"

# LLVM CSKYInstrFormats: 32-bit if first halfword bits 15:14 == 11.
# insn = (hw0 << 16) | hw1; opcode = bits 31:26.

OP_NAME = {
    0x30: "mfcr/mtcr/priv",
    0x31: "alu32",
    0x33: "grs/lrs",
    0x34: "ldr32",
    0x35: "str32",
    0x36: "ld32",
    0x37: "st32",
    0x38: "bsr32",
    0x39: "addi/subi/andi/xori32",
    0x3A: "movi/lrw/br/bt/bf/jmpi/push/pop",
    0x3B: "ori32",
    0x3F: "cp",
}


def u16(data: bytes, off: int) -> int:
    return struct.unpack_from("<H", data, off)[0]


def u32(data: bytes, off: int) -> int:
    return struct.unpack_from("<I", data, off)[0]


def is32(hw: int) -> bool:
    return (hw & 0xC000) == 0xC000


def walk(data: bytes, start: int, limit: int | None = None):
    n16 = n32 = 0
    op_hist: collections.Counter[int] = collections.Counter()
    sop39: collections.Counter[int] = collections.Counter()
    sop3a: collections.Counter[int] = collections.Counter()
    rts16 = nop = push16 = pop16 = nie = 0
    lrw32 = br32 = bsr32 = lrw16 = 0
    lrw32_sites: list[tuple[int, int, int]] = []  # off, rz, imm16
    lrw16_sites: list[tuple[int, int, int]] = []
    off = start
    end = len(data) if limit is None else min(len(data), start + limit)
    while off + 2 <= end:
        hw = u16(data, off)
        if is32(hw):
            if off + 4 > end:
                break
            hw1 = u16(data, off + 2)
            inst = (hw << 16) | hw1
            opc = (inst >> 26) & 0x3F
            op_hist[opc] += 1
            n32 += 1
            if opc == 0x39:
                sop39[(inst >> 12) & 0xF] += 1
            elif opc == 0x3A:
                sop = (inst >> 21) & 0x1F
                sop3a[sop] += 1
                if sop == 0x14:  # lrw32
                    lrw32 += 1
                    rz = (inst >> 16) & 0x1F
                    imm = inst & 0xFFFF
                    lrw32_sites.append((off, rz, imm))
                elif sop == 0x00:
                    br32 += 1
            elif opc == 0x38:
                bsr32 += 1
            off += 4
        else:
            n16 += 1
            if hw == 0x783C:
                rts16 += 1
            elif hw == 0x6C03:
                nop += 1
            elif hw == 0x1460:
                nie += 1
            elif 0x14C0 <= hw <= 0x14DF:
                push16 += 1
            elif 0x1480 <= hw <= 0x149F:
                pop16 += 1
            # lrw16: bits 15:13=000, bits 11:10=00
            if (hw & 0xEC00) == 0x0000 and hw != 0:
                # could be other 000x00 ops; lrw16 also has that shape
                lrw16 += 1
                rz = (hw >> 5) & 7
                lab = ((hw >> 12) & 1) << 7 | ((hw >> 8) & 3) << 5 | (hw & 0x1F)
                lrw16_sites.append((off, rz, lab))
            off += 2
    return {
        "n16": n16,
        "n32": n32,
        "op_hist": op_hist,
        "sop39": sop39,
        "sop3a": sop3a,
        "rts16": rts16,
        "nop": nop,
        "push16": push16,
        "pop16": pop16,
        "nie": nie,
        "lrw32": lrw32,
        "br32": br32,
        "bsr32": bsr32,
        "lrw16": lrw16,
        "lrw32_sites": lrw32_sites,
        "lrw16_sites": lrw16_sites,
        "end": off,
    }


def cstr_at(data: bytes, off: int) -> str | None:
    if off < 0 or off >= len(data):
        return None
    if not (32 <= data[off] < 127):
        return None
    j = off
    while j < len(data) and 32 <= data[j] < 127 and j - off < 64:
        j += 1
    if j > off and (j == len(data) or data[j] == 0):
        return data[off:j].decode("ascii", "ignore")
    return None


def main() -> int:
    data = BIN.read_bytes()
    size = len(data)
    print(f"file {BIN} size={size}")

    r = walk(data, 0)
    print("\n=== walk from +0 (C-SKY V2 mix) ===")
    print(f"  16-bit insns={r['n16']}  32-bit insns={r['n32']}  ended@{r['end']:#x}")
    print(f"  rts16={r['rts16']} nop={r['nop']} push16={r['push16']} pop16={r['pop16']} nie={r['nie']}")
    print(f"  lrw32={r['lrw32']} br32={r['br32']} bsr32={r['bsr32']} lrw16-shape={r['lrw16']}")
    print("  32-bit opcode hist:")
    for opc, n in r["op_hist"].most_common(16):
        print(f"    {opc:#04x} {OP_NAME.get(opc, '?'):28} n={n}")
    print("  opcode 0x39 sop (0=addi 1=subi 2=andi 3=andni 4=xori):")
    for s, n in r["sop39"].most_common():
        print(f"    sop={s} n={n}")
    print("  opcode 0x3a sop (0=br32 0x14=lrw32 0x08=movi? ...):")
    for s, n in r["sop3a"].most_common(12):
        print(f"    sop={s:#04x} n={n}")

    anchors = {
        0x35FE4: "uC/OS-III Idle Task",
        0x3609C: "uC/OS-III Tick Task",
        0x36534: "PttTask",
        0x365C8: "encrypt",
        0x38464: "DMR003.UV4T.V022",
    }

    print("\n=== lrw32 PC-relative try (imm16 as byte/word offset) ===")
    hits = 0
    for off, rz, imm in r["lrw32_sites"][:]:
        pc = off + 4
        cands = [
            (pc + (imm << 2)) & 0xFFFFFFFF,
            (pc + (imm << 1)) & 0xFFFFFFFF,
            (pc + imm) & 0xFFFFFFFF,
            ((pc & ~3) + (imm << 2)) & 0xFFFFFFFF,
            ((off + 2) + (imm << 2)) & 0xFFFFFFFF,
        ]
        for tgt in cands:
            if tgt in anchors or (tgt < size and tgt in anchors):
                print(f"  HIT lrw32 r{rz} @{off:#x} imm={imm:#x} tgt={tgt:#x} {anchors.get(tgt)}")
                hits += 1
            s = cstr_at(data, tgt) if tgt < size else None
            # only print later if we want; keep quiet unless anchor
    print(f"  anchor hits with those formulas: {hits}")

    print("\n=== lrw32 load word at pool, value vs anchors (several bases) ===")
    bases = [0x00000000, 0x08000000, 0x20000000]
    votes: collections.Counter[int] = collections.Counter()
    shown = 0
    for off, rz, imm in r["lrw32_sites"]:
        pc = off + 4
        pool = (pc & ~3) + (imm << 2)
        if not (0 <= pool <= size - 4):
            pool = pc + (imm << 2)
        if not (0 <= pool <= size - 4):
            continue
        word = u32(data, pool)
        for b in bases:
            file_tgt = (word - b) & 0xFFFFFFFF
            if file_tgt in anchors:
                votes[b] += 1
                if shown < 20:
                    print(
                        f"  base={b:#010x} lrw32 @{off:#x} pool={pool:#x} "
                        f"word={word:#010x} -> {anchors[file_tgt]}"
                    )
                    shown += 1
    print("  votes", dict(votes))

    print("\n=== lrw32 pool=(pc+4)&~3 + imm<<2 ; word as file offset (base 0) ===")
    n_str = 0
    n_in = 0
    for off, rz, imm in r["lrw32_sites"]:
        pool = ((off + 4) & ~3) + (imm << 2)
        if not (0 <= pool <= size - 4):
            continue
        word = u32(data, pool)
        if 0 <= word < size:
            n_in += 1
            s = cstr_at(data, word)
            if s and len(s) >= 4:
                n_str += 1
                if n_str <= 12:
                    print(f"  @{off:#07x} r{rz} -> {word:#010x} {s!r}")
    print(f"  in-image pointers {n_in}/{len(r['lrw32_sites'])}  C-strings {n_str}")

    print("\n=== rts16/push16/pop16 by 4KiB (walk-synced) ===")
    # re-walk collecting per-page
    page_ctrl: collections.Counter[int] = collections.Counter()
    off = 0
    while off + 2 <= size:
        hw = u16(data, off)
        if is32(hw):
            off += 4
            continue
        if hw == 0x783C or 0x14C0 <= hw <= 0x14DF or 0x1480 <= hw <= 0x149F:
            page_ctrl[off >> 12] += 1
        off += 2
    for p, n in page_ctrl.most_common(12):
        print(f"  +{p << 12:#07x}  n={n}")
    print(f"  pages with any: {len(page_ctrl)}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
