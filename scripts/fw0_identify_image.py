#!/usr/bin/env python3
"""FW0: identify DMR003.UV4T.V022 image format, core, and load base.

Does not patch or flash. Reads ORIGINAL.bin only.
"""
from __future__ import annotations

import collections
import math
import struct
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
BIN = ROOT / "radio_firmware" / "DMR003.UV4T.V022-ORIGINAL.bin"

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
    0x40000000,
    0x60000000,
    0x80000000,
    0x90000000,
    0xA0000000,
    0xC0000000,
]


def entropy(b: bytes) -> float:
    if not b:
        return 0.0
    counts = collections.Counter(b)
    n = len(b)
    return -sum((c / n) * math.log2(c / n) for c in counts.values())


def find_c_strings(data: bytes, min_len: int = 6) -> list[tuple[int, str]]:
    out = []
    i = 0
    n = len(data)
    while i < n:
        if 32 <= data[i] < 127:
            j = i
            while j < n and 32 <= data[j] < 127:
                j += 1
            if j - i >= min_len and (j == n or data[j] == 0):
                s = data[i:j].decode("ascii", "ignore")
                out.append((i, s))
            i = j + 1
        else:
            i += 1
    return out


def interesting_strings(strs: list[tuple[int, str]]) -> list[tuple[int, str]]:
    keys = (
        "DMR",
        "UV4T",
        "V022",
        "uC/OS",
        "Idle",
        "Tick",
        "Timer",
        "squelch",
        "Squelch",
        "contact",
        "group",
        "Group",
        "UART",
        "YModem",
        "CRC",
        "task",
        "Task",
        "sem",
        "encrec",
        "decrec",
        "play_sem",
        "cpchan",
        "HR_C",
        "STM32",
        "GD32",
        "C6000",
        "AMBE",
        "DMR003",
    )
    picked = []
    for off, s in strs:
        if any(k in s for k in keys):
            picked.append((off, s))
    return picked


def count_pointers_to(data: bytes, abs_addr: int) -> list[int]:
    """File offsets of LE uint32 words equal to abs_addr."""
    target = struct.pack("<I", abs_addr & 0xFFFFFFFF)
    hits = []
    start = 0
    while True:
        i = data.find(target, start)
        if i < 0:
            break
        if i % 2 == 0:  # prefer even; still record
            hits.append(i)
        start = i + 1
    return hits


def scan_vector_table(data: bytes, file_off: int, base: int, size: int) -> dict | None:
    """Score a candidate Cortex-M vector table at file_off with given load base."""
    if file_off + 8 > len(data):
        return None
    sp, reset = struct.unpack_from("<II", data, file_off)
    img_lo, img_hi = base, base + size
    sp_sram = 0x20000000 <= sp <= 0x20040000 or 0x10000000 <= sp <= 0x10040000
    reset_thumb = reset & 1
    reset_in = img_lo <= (reset & ~1) < img_hi
    if not (sp_sram and reset_thumb and reset_in):
        # still count in-range odd pointers for a more general table
        pass
    in_range_odd = 0
    in_range = 0
    nvec = min(48, (len(data) - file_off) // 4)
    for i in range(nvec):
        w = struct.unpack_from("<I", data, file_off + 4 * i)[0]
        if img_lo <= (w & ~1) < img_hi:
            in_range += 1
            if w & 1:
                in_range_odd += 1
    return {
        "file_off": file_off,
        "base": base,
        "sp": sp,
        "reset": reset,
        "sp_sram": sp_sram,
        "reset_ok": bool(reset_thumb and reset_in),
        "in_range": in_range,
        "in_range_odd": in_range_odd,
        "nvec": nvec,
    }


def thumb_mov_imm8_hits(data: bytes, imm: int) -> list[int]:
    """Offsets of 16-bit Thumb `movs rN, #imm` (00100 Rd imm8)."""
    hits = []
    for rd in range(8):
        instr = 0x2000 | (rd << 8) | (imm & 0xFF)
        pat = struct.pack("<H", instr)
        start = 0
        while True:
            i = data.find(pat, start)
            if i < 0:
                break
            if i % 2 == 0:
                hits.append(i)
            start = i + 1
    return hits


def main() -> int:
    if not BIN.exists():
        print(f"missing {BIN}", file=sys.stderr)
        return 1
    data = BIN.read_bytes()
    size = len(data)
    print(f"file: {BIN}")
    print(f"size: {size} (0x{size:X})")
    print(f"md5:  (compute externally if needed)")
    print(f"entropy: {entropy(data):.3f} bits/byte")
    print(f"first 16 bytes: {data[:16].hex(' ')}")
    w0, w1, w2, w3 = struct.unpack_from("<IIII", data, 0)
    print(f"LE u32[0..3]: {w0:#010x} {w1:#010x} {w2:#010x} {w3:#010x}")

    # Header guess: look for size/magic
    print("\n=== strings of interest ===")
    all_s = find_c_strings(data, 4)
    interesting = interesting_strings(all_s)
    # always include version / rtos
    for off, s in all_s:
        if s in ("DMR003.UV4T.V022",) or s.startswith("uC/OS"):
            if (off, s) not in interesting:
                interesting.append((off, s))
    interesting.sort()
    for off, s in interesting[:80]:
        print(f"  +{off:#08x}  {s[:80]!r}")
    print(f"  ... {len(interesting)} interesting / {len(all_s)} total c-strings")

    # Pointer-score candidate bases using a few anchor strings
    anchors = [off for off, s in all_s if s in (
        "DMR003.UV4T.V022",
        "uC/OS-III Idle Task",
        "uC/OS-III Tick Task",
        "uC/OS-III Timer Task",
        "uC/OS-III Stat Task",
        "uC/OS-III ISR Queue Task",
    )]
    if not anchors:
        # fallback: any string containing those
        for off, s in all_s:
            if "uC/OS-III" in s or s.startswith("DMR003"):
                anchors.append(off)
    anchors = sorted(set(anchors))
    print(f"\n=== pointer score (LE uint32 == base+str_off) anchors={len(anchors)} ===")
    scores = []
    extra_bases = set(CANDIDATE_BASES)
    # Also try bases that would make w0 a mapped SP? skip
    # Try aligning so first word is something
    for a in anchors:
        # If a pointer to this string exists as 0x08xxxxxx, infer base
        pass
    # Infer bases from existing high pointers near 0x08
    ptr_hist = collections.Counter()
    for i in range(0, size - 3, 4):
        w = struct.unpack_from("<I", data, i)[0]
        if 0x08000000 <= w <= 0x08100000:
            ptr_hist[w >> 12] += 1
    print("  0x080xxxxx pointer pages (top):")
    for page, c in ptr_hist.most_common(8):
        print(f"    {page << 12:#010x}  n={c}")

    for base in sorted(extra_bases):
        hits = 0
        details = []
        for a in anchors:
            addrs = count_pointers_to(data, (base + a) & 0xFFFFFFFF)
            hits += len(addrs)
            if addrs:
                details.append((a, len(addrs)))
        scores.append((hits, base, details))
    scores.sort(reverse=True)
    print("  base pointer-to-anchor scores:")
    for hits, base, details in scores[:12]:
        print(f"    base={base:#010x}  hits={hits}  {details[:5]}")

    print("\n=== Cortex-M vector-table scan (file offsets 0..0x200 step 4; a few bases) ===")
    vt_bases = [0x00000000, 0x08000000, 0x00008000, 0x08004000]
    best_vt = []
    for base in vt_bases:
        for off in range(0, min(0x400, size - 16), 4):
            r = scan_vector_table(data, off, base, size)
            if r and (r["reset_ok"] or r["in_range_odd"] >= 8):
                best_vt.append(r)
    best_vt.sort(key=lambda r: (r["reset_ok"], r["in_range_odd"], r["in_range"]), reverse=True)
    for r in best_vt[:15]:
        print(
            f"  off={r['file_off']:#06x} base={r['base']:#010x} "
            f"SP={r['sp']:#010x} reset={r['reset']:#010x} "
            f"sp_sram={r['sp_sram']} reset_ok={r['reset_ok']} "
            f"in_range={r['in_range']}/{r['nvec']} odd={r['in_range_odd']}"
        )
    if not best_vt:
        print("  (no plausible Cortex-M table in first 1KB for those bases)")

    print("\n=== Thumb movs rN, #imm for protocol bytes ===")
    for imm, name in [(0x68, "head"), (0x10, "tail"), (0x22, "SET_DIGITAL"), (0x23, "SET_ANALOG"),
                      (0x2B, "Q_DIG_AUDIO"), (0xAA, "INIT"), (0x36, "STATUS")]:
        hits = thumb_mov_imm8_hits(data, imm)
        print(f"  movs rN, #{imm:#04x} ({name}): {len(hits)} even-aligned  "
              f"first={hits[:8]}")

    # Region entropy
    print("\n=== entropy by 16KiB ===")
    for off in range(0, size, 16384):
        chunk = data[off:off + 16384]
        print(f"  {off:#08x}  {entropy(chunk):.3f}  n={len(chunk)}")

    dump_flash_pointers(data, size)
    dump_header_and_mov68_context(data)
    return 0


def dump_flash_pointers(data: bytes, size: int) -> None:
    """Every aligned LE u32 in 0x08000000 .. 0x08000000+size (in-image if that base)."""
    lo, hi = 0x08000000, 0x08000000 + size
    ins = []
    out = []
    for i in range(0, len(data) - 3, 4):
        w = struct.unpack_from("<I", data, i)[0]
        if lo <= w < hi:
            ins.append((i, w, w - lo))
        elif 0x08000000 <= w <= 0x081FFFFF:
            out.append((i, w))
    print(f"\n=== pointers as if base=0x08000000 (in-image {lo:#x}..{hi:#x}) ===")
    print(f"  in-image: {len(ins)}  other-0x08: {len(out)}")
    # What in-image pointers land on: string? even?
    str_at = {}
    for off, s in find_c_strings(data, 4):
        str_at[off] = s
    str_hits = 0
    samples = []
    for file_off, abs_w, tgt in ins:
        if tgt in str_at:
            str_hits += 1
            if len(samples) < 20:
                samples.append((file_off, abs_w, str_at[tgt][:40]))
    print(f"  of which point at a C-string: {str_hits}")
    for file_off, abs_w, s in samples:
        print(f"    ptr@{file_off:#08x} -> {abs_w:#010x}  {s!r}")

    print("  other 0x08 pages (not in 378KB image):")
    pages = collections.Counter(w & 0xFFFFF000 for _, w in out)
    for page, c in pages.most_common(12):
        print(f"    {page:#010x}  n={c}")

    # Infer base: for each string, look at nearby 0x08 pointers? 
    # Reverse: unique (pointer - string_off) for pointers that could be that string
    print("\n=== inferred bases from (ptr - known_string_off) if ptr looks like flash ===")
    anchors = [(off, s) for off, s in find_c_strings(data, 4)
               if "uC/OS-III" in s or s.startswith("DMR003") or s in ("encrec_sem", "cpchanscan", "PttTask")]
    base_votes = collections.Counter()
    for i in range(0, len(data) - 3, 4):
        w = struct.unpack_from("<I", data, i)[0]
        if not (0x00000000 <= w <= 0x9FFFFFFF):
            continue
        for a, s in anchors:
            b = (w - a) & 0xFFFFFFFF
            if b % 0x1000 == 0 and b < 0xF0000000:
                base_votes[(b, a, s)] += 1
    # collapse by base
    by_base = collections.Counter()
    for (b, a, s), c in base_votes.items():
        by_base[b] += c
    print("  rounded bases with most (ptr==base+str) hits:")
    for b, c in by_base.most_common(15):
        if c >= 1:
            print(f"    {b:#010x}  hits={c}")


def dump_header_and_mov68_context(data: bytes) -> None:
    print("\n=== file +0x00..+0x40 hex ===")
    for off in range(0, 0x40, 16):
        print(f"  {off:#06x}  {data[off:off+16].hex(' ')}")
    print("\n=== 8 bytes around first movs #0x68 hits ===")
    hits = thumb_mov_imm8_hits(data, 0x68)
    for h in hits[:6]:
        lo = max(0, h - 8)
        print(f"  {h:#08x}: {data[lo:h+10].hex(' ')}")


if __name__ == "__main__":
    raise SystemExit(main())

