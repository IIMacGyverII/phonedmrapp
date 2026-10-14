#!/usr/bin/env python3
"""FW-A1c helper: recover Thumb-2 PC-relative and MOVW/MOVT refs to known strings.

Does not patch or flash. Complements Ghidra; can prove a load base from
ADR/LDR-literal/MOVW+MOVT even when 32-bit absolute literals are absent.
"""
from __future__ import annotations

import collections
import struct
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
BIN = ROOT / "radio_firmware" / "DMR003.UV4T.V022-ORIGINAL.bin"

ANCHOR_EXACT = (
    "DMR003.UV4T.V022",
    "uC/OS-III Idle Task",
    "uC/OS-III Tick Task",
    "uC/OS-III Timer Task",
    "uC/OS-III Stat Task",
    "uC/OS-III ISR Queue Task",
    "PttTask",
    "task init",
    "cpchanscan",
    "encrec_sem",
    "decrec_sem",
    "play_sem",
    "encrypt",
)

CANDIDATE_BASES = [
    0x00000000,
    0x00008000,
    0x00010000,
    0x08000000,
    0x08004000,
    0x08008000,
    0x0800C000,
    0x08100000,
    0x10000000,
    0x20000000,
]


def u16(data: bytes, off: int) -> int:
    return struct.unpack_from("<H", data, off)[0]


def u32(data: bytes, off: int) -> int:
    return struct.unpack_from("<I", data, off)[0]


def find_c_strings(data: bytes, min_len: int = 4) -> list[tuple[int, str]]:
    out: list[tuple[int, str]] = []
    i = 0
    n = len(data)
    while i < n:
        if 32 <= data[i] < 127:
            j = i
            while j < n and 32 <= data[j] < 127:
                j += 1
            if j - i >= min_len and (j == n or data[j] == 0):
                out.append((i, data[i:j].decode("ascii", "ignore")))
            i = j + 1
        else:
            i += 1
    return out


def decode_movw_movt(data: bytes, off: int) -> tuple[str, int, int] | None:
    """Thumb-2 MOVW/MOVT encoding T3. Returns (kind, Rd, imm16) or None."""
    if off + 4 > len(data) or off % 2:
        return None
    hw1 = u16(data, off)
    hw2 = u16(data, off + 2)
    if hw2 & 0x8000:
        return None
    op = hw1 & 0xFBF0
    if op == 0xF240:
        kind = "MOVW"
    elif op == 0xF2C0:
        kind = "MOVT"
    else:
        return None
    i_bit = (hw1 >> 10) & 1
    imm4 = hw1 & 0xF
    imm3 = (hw2 >> 12) & 7
    rd = (hw2 >> 8) & 0xF
    imm8 = hw2 & 0xFF
    imm16 = (imm4 << 12) | (i_bit << 11) | (imm3 << 8) | imm8
    return kind, rd, imm16


def scan_movw_movt_pairs(data: bytes, window: int = 32) -> list[dict]:
    """MOVW then a later MOVT (or reverse) to the same Rd within `window` bytes."""
    n = len(data) - 3
    sites: list[tuple[int, str, int, int]] = []
    off = 0
    while off < n:
        dec = decode_movw_movt(data, off)
        if dec:
            kind, rd, imm16 = dec
            sites.append((off, kind, rd, imm16))
            off += 4
        else:
            off += 2
    by_rd: dict[int, list[tuple[int, str, int]]] = collections.defaultdict(list)
    for off, kind, rd, imm16 in sites:
        by_rd[rd].append((off, kind, imm16))

    pairs = []
    seen = set()
    for rd, seq in by_rd.items():
        for i, (off_a, kind_a, imm_a) in enumerate(seq):
            for off_b, kind_b, imm_b in seq[i + 1 :]:
                if off_b - off_a > window:
                    break
                if {kind_a, kind_b} != {"MOVW", "MOVT"}:
                    continue
                lo = imm_a if kind_a == "MOVW" else imm_b
                hi = imm_b if kind_a == "MOVW" else imm_a
                addr = ((hi << 16) | lo) & 0xFFFFFFFF
                key = (off_a, off_b, rd, addr)
                if key in seen:
                    continue
                seen.add(key)
                pairs.append(
                    {
                        "off_lo": off_a if kind_a == "MOVW" else off_b,
                        "off_hi": off_b if kind_a == "MOVW" else off_a,
                        "first": off_a,
                        "rd": rd,
                        "addr": addr,
                    }
                )
    return pairs


def adr_t1_target(instr_off: int, hw: int) -> int | None:
    """ADR Rd, label (T1): 10100 Rd imm8 → Align(PC,4)+imm8*4. PC = instr+4."""
    if (hw & 0xF800) != 0xA000:
        return None
    imm8 = hw & 0xFF
    pc = instr_off + 4
    return (pc & ~3) + (imm8 * 4)


def ldr_lit_t1(data: bytes, instr_off: int, hw: int) -> tuple[int, int] | None:
    """LDR Rt, [PC, #imm] T1: 01001 Rt imm8. Returns (literal_pool_off, loaded_word)."""
    if (hw & 0xF800) != 0x4800:
        return None
    imm8 = hw & 0xFF
    pc = instr_off + 4
    lit = (pc & ~3) + (imm8 * 4)
    if lit + 4 > len(data):
        return None
    return lit, u32(data, lit)


def add_wide_imm12(data: bytes, off: int) -> tuple[int, int, int] | None:
    """Thumb-2 ADD Rd, Rn, #imm12 (encoding T4 / ADD (immediate) T3-ish).

    Encoding T4 ADD (plain 12-bit):
      hw1 = 11110 i 100000 Rn
      hw2 = 0 imm3 Rd imm8
      imm12 = i:imm3:imm8
    Used as ADR when Rn == 15 (PC).
    """
    if off + 4 > len(data):
        return None
    hw1 = u16(data, off)
    hw2 = u16(data, off + 2)
    if (hw1 & 0xFB00) != 0xF200:
        return None
    if hw2 & 0x8000:
        return None
    rn = hw1 & 0xF
    i_bit = (hw1 >> 10) & 1
    imm3 = (hw2 >> 12) & 7
    rd = (hw2 >> 8) & 0xF
    imm8 = hw2 & 0xFF
    imm12 = (i_bit << 11) | (imm3 << 8) | imm8
    return rd, rn, imm12


def scan_pc_rel_to_offsets(data: bytes, targets: dict[int, str]) -> list[dict]:
    """Find ADR T1 / ADD-PC / LDR-literal that land on a known file offset."""
    hits = []
    n = len(data) - 1
    off = 0
    while off + 2 <= n:
        if off % 2:
            off += 1
            continue
        hw = u16(data, off)
        t = adr_t1_target(off, hw)
        if t is not None and t in targets:
            hits.append(
                {
                    "kind": "ADR_T1",
                    "instr": off,
                    "target_off": t,
                    "string": targets[t],
                    "rd": (hw >> 8) & 7,
                }
            )
        lit = ldr_lit_t1(data, off, hw)
        if lit is not None:
            lit_off, word = lit
            # word is an absolute address; file offset unknown until base
            hits.append(
                {
                    "kind": "LDR_LIT_T1",
                    "instr": off,
                    "lit_off": lit_off,
                    "word": word,
                    "rd": (hw >> 8) & 7,
                }
            )
        wide = add_wide_imm12(data, off)
        if wide is not None:
            rd, rn, imm12 = wide
            if rn == 15:
                pc = off + 4
                tgt = (pc & ~3) + imm12
                if tgt in targets:
                    hits.append(
                        {
                            "kind": "ADR_WIDE",
                            "instr": off,
                            "target_off": tgt,
                            "string": targets[tgt],
                            "rd": rd,
                            "imm12": imm12,
                        }
                    )
                # also try subtract form? skip
        off += 2
    return hits


def main() -> int:
    if not BIN.exists():
        print(f"missing {BIN}", file=sys.stderr)
        return 1
    data = BIN.read_bytes()
    size = len(data)
    print(f"file: {BIN}")
    print(f"size: {size} (0x{size:X})")

    all_s = find_c_strings(data, 4)
    str_at = {off: s for off, s in all_s}
    anchors = [(off, s) for off, s in all_s if s in ANCHOR_EXACT]
    print(f"\n=== anchors ({len(anchors)}) ===")
    for off, s in anchors:
        print(f"  +{off:#08x}  {s!r}")

    target_offs = {off: s for off, s in anchors}

    print("\n=== MOVW/MOVT pairs (32-bit immediates) ===")
    pairs = scan_movw_movt_pairs(data, window=48)
    print(f"  pairs found: {len(pairs)}")
    # Histogram of high 16 bits
    hi_hist = collections.Counter((p["addr"] >> 16) for p in pairs)
    print("  top high-halves:")
    for hi, c in hi_hist.most_common(12):
        print(f"    {hi:#06x}xxxx  n={c}")

    print("\n=== MOVW/MOVT landing on anchors at candidate bases ===")
    votes: collections.Counter = collections.Counter()
    shown = 0
    for base in CANDIDATE_BASES:
        for p in pairs:
            file_tgt = (p["addr"] - base) & 0xFFFFFFFF
            if file_tgt in target_offs:
                votes[base] += 1
                if shown < 40:
                    print(
                        f"  base={base:#010x}  {p['first']:#08x}: r{p['rd']} = "
                        f"{p['addr']:#010x} -> +{file_tgt:#08x} {target_offs[file_tgt]!r}"
                    )
                    shown += 1
    print("  votes by base (MOVW/MOVT -> anchor):")
    for b, c in votes.most_common():
        print(f"    {b:#010x}  {c}")
    if not votes:
        print("    (none)")

    # Also: any pair whose reconstructed addr minus a known string off is a round base
    print("\n=== inferred bases from MOVW/MOVT addr - string_off ===")
    inf = collections.Counter()
    examples: dict[int, list] = collections.defaultdict(list)
    for p in pairs:
        for a, s in anchors:
            b = (p["addr"] - a) & 0xFFFFFFFF
            if b % 0x800 == 0 and b < 0xF0000000:
                inf[b] += 1
                if len(examples[b]) < 6:
                    examples[b].append((p["first"], p["addr"], a, s))
    for b, c in inf.most_common(15):
        if c >= 1:
            print(f"  {b:#010x}  hits={c}")
            for first, addr, a, s in examples[b]:
                print(f"      @{first:#08x}  {addr:#010x} - {a:#x} ({s!r})")

    print("\n=== PC-relative ADR T1 / ADR-wide landing on anchors (base-independent) ===")
    pc_hits = scan_pc_rel_to_offsets(data, target_offs)
    adr_hits = [h for h in pc_hits if h["kind"] in ("ADR_T1", "ADR_WIDE")]
    ldr_hits = [h for h in pc_hits if h["kind"] == "LDR_LIT_T1"]
    print(f"  ADR hits on anchors: {len(adr_hits)}")
    for h in adr_hits[:30]:
        print(
            f"    {h['kind']} @{h['instr']:#08x} r{h['rd']} -> "
            f"+{h['target_off']:#08x} {h['string']!r}"
        )
    if not adr_hits:
        print("    (none — strings not reached by nearby ADR)")

    print("\n=== LDR literal T1: loaded word vs anchors at candidate bases ===")
    ldr_votes: collections.Counter = collections.Counter()
    shown = 0
    for h in ldr_hits:
        word = h["word"]
        for base in CANDIDATE_BASES:
            file_tgt = (word - base) & 0xFFFFFFFF
            if file_tgt in target_offs:
                ldr_votes[base] += 1
                if shown < 40:
                    print(
                        f"  base={base:#010x}  LDR @{h['instr']:#08x} "
                        f"lit@{h['lit_off']:#08x} word={word:#010x} -> "
                        f"+{file_tgt:#08x} {target_offs[file_tgt]!r}"
                    )
                    shown += 1
    print("  votes by base (LDR lit -> anchor):")
    for b, c in ldr_votes.most_common():
        print(f"    {b:#010x}  {c}")
    if not ldr_votes:
        print("    (none)")

    # LDR literals whose word-string_off is round
    print("\n=== inferred bases from LDR-literal word - string_off ===")
    inf2 = collections.Counter()
    ex2: dict[int, list] = collections.defaultdict(list)
    for h in ldr_hits:
        word = h["word"]
        if word == 0:
            continue
        for a, s in anchors:
            b = (word - a) & 0xFFFFFFFF
            if b % 0x800 == 0 and b < 0xF0000000:
                inf2[b] += 1
                if len(ex2[b]) < 5:
                    ex2[b].append((h["instr"], word, a, s))
    for b, c in inf2.most_common(12):
        if c >= 2:
            print(f"  {b:#010x}  hits={c}")
            for instr, word, a, s in ex2[b]:
                print(f"      LDR @{instr:#08x}  {word:#010x} - {a:#x} ({s!r})")

    # Also report any LDR literal word that lands ON a C-string at 0x08000000
    print("\n=== LDR literals that decode as C-strings at base 0x08000000 ===")
    n_str = 0
    for h in ldr_hits:
        w = h["word"]
        if 0x08000000 <= w < 0x08000000 + size:
            tgt = w - 0x08000000
            if tgt in str_at:
                n_str += 1
                if n_str <= 25:
                    print(
                        f"  LDR @{h['instr']:#08x} -> {w:#010x} "
                        f"(+{tgt:#08x}) {str_at[tgt][:50]!r}"
                    )
    print(f"  total: {n_str}")

    print("\n=== MOVW/MOVT that decode as C-strings at base 0x08000000 ===")
    n_str = 0
    for p in pairs:
        w = p["addr"]
        if 0x08000000 <= w < 0x08000000 + size:
            tgt = w - 0x08000000
            if tgt in str_at:
                n_str += 1
                if n_str <= 25:
                    print(
                        f"  pair @{p['first']:#08x} r{p['rd']} -> {w:#010x} "
                        f"(+{tgt:#08x}) {str_at[tgt][:50]!r}"
                    )
    print(f"  total: {n_str}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
