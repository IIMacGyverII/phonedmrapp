#!/usr/bin/env python3
"""FW-B2/C1: follow analog apply +0x7A30 and hunt sq clamp-to-2.

Does not patch.
"""
from __future__ import annotations

import re
import sys
from collections import defaultdict
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
from fw0_csky_disasm import BIN, disasm_range, iter_insns  # noqa: E402

BSR_RE = re.compile(r"^bsr32 0x([0-9a-f]+)$")
MOVI_RE = re.compile(r"^movi(?:16|32) r(\d+), #0x([0-9a-f]+)$")
STB_RE = re.compile(r"^st(?:16|32)\.b r(\d+), \(r(\d+), #(\d+)\)$")
LDB_RE = re.compile(r"^ld(?:16|32)\.b r(\d+), \(r(\d+), #(\d+)\)$")
CMP_RE = re.compile(
    r"^(?:cmpnei|cmphsi|cmplti)(?:16|32) r(\d+), #(?:0x)?([0-9a-f]+)$"
)


def walk(data: bytes, start: int = 0, end: int | None = None):
    return list(iter_insns(data, start, end if end is not None else len(data)))


def callers_of(insns, targets: set[int]) -> dict[int, list[int]]:
    out: dict[int, list[int]] = defaultdict(list)
    for off, sz, text, raw in insns:
        m = BSR_RE.match(text)
        if not m:
            continue
        tgt = int(m.group(1), 16)
        if tgt in targets:
            out[tgt].append(off)
    return out


def func_start(insns_by_off, off: int) -> int:
    """Walk backward a little for push16 / aligned gap."""
    cur = off
    seen = 0
    while cur > 0 and seen < 80:
        prev = None
        for delta in (2, 4):
            p = cur - delta
            if p in insns_by_off:
                prev = p
                break
        if prev is None:
            break
        text = insns_by_off[prev][1]
        if text.startswith("push16") or text == "rts16":
            return prev if text.startswith("push16") else cur
        cur = prev
        seen += 1
    return off


def main() -> int:
    data = BIN.read_bytes()
    insns = walk(data)
    by_off = {off: (sz, text, raw) for off, sz, text, raw in insns}
    print(f"file {BIN.name} insns={len(insns)}")

    targets = {
        0x7A30,
        0x794C,
        0x9A2C,
        0x9866,
        0x9D08,
        0x304E8,
        0x2DD8,
        0x788C,
        0x79C0,
        0x8E7C,
        0x37F4,
        0x6354,
        0x7E08,
        0x61A8,
        0x61F4,
        0x7BA8,
        0x2BAC,
    }
    calls = callers_of(insns, targets)
    print("\n=== callers of analog/apply helpers ===")
    for tgt in sorted(targets):
        cs = calls.get(tgt, [])
        print(f"  bsr -> {tgt:#x}: n={len(cs)}  {', '.join(f'{c:#x}' for c in cs[:12])}")

    print("\n=== movi #2 then nearby st.b (code prefix 0..0x20000) ===")
    pre = [x for x in insns if x[0] < 0x20000]
    for i, (off, sz, text, raw) in enumerate(pre):
        m = MOVI_RE.match(text)
        if not m or int(m.group(2), 16) != 2:
            continue
        rz = int(m.group(1))
        window = pre[i : i + 10]
        stores = []
        for o2, _, t2, _ in window[1:]:
            sm = STB_RE.match(t2)
            if sm and int(sm.group(1)) == rz:
                stores.append((o2, t2, int(sm.group(3))))
        if stores:
            print(f"  {off:#07x} {text}")
            for o2, t2, imm in stores:
                mark = "  << off10 sq?" if imm == 10 else ""
                print(f"           {o2:#07x} {t2}{mark}")

    print("\n=== ld.b then cmp #0/#1/#2/#9 and movi #2 in next 12 insns (0..0x12000) ===")
    pre2 = [x for x in insns if x[0] < 0x12000]
    for i, (off, sz, text, raw) in enumerate(pre2):
        lm = LDB_RE.match(text)
        if not lm:
            continue
        rz = int(lm.group(1))
        imm = int(lm.group(3))
        win = pre2[i : i + 14]
        texts = [t for _, _, t, _ in win]
        blob = " | ".join(texts)
        cmp_hit = False
        movi2 = False
        for t in texts[1:]:
            cm = CMP_RE.match(t)
            if cm and int(cm.group(1)) == rz and int(cm.group(2), 16) in (0, 1, 2, 9):
                cmp_hit = True
            mm = MOVI_RE.match(t)
            if mm and int(mm.group(2), 16) == 2:
                movi2 = True
            if t.startswith("bez32") and f"r{rz}" in t:
                cmp_hit = True
        if cmp_hit and (movi2 or imm == 10):
            print(f"  {off:#07x} {text}")
            for o2, _, t2, _ in win[:10]:
                print(f"           {o2:#07x} {t2}")

    print("\n=== st.b #10 anywhere in 0..0x12000 ===")
    for off, sz, text, raw in pre2:
        sm = STB_RE.match(text)
        if sm and int(sm.group(3)) == 10:
            print(f"  {off:#07x} {text}")

    ranges = [
        (0x9880, 0x9A30, "function containing analog unpack (look for prologue)"),
        (0x99C0, 0x9A30, "just before +0x9A2C"),
        (0x7880, 0x794C, "0x788C helper called by apply"),
        (0x79C0, 0x7A30, "0x79C0 called from apply"),
        (0x2DC0, 0x2E80, "0x2DD8 from apply"),
        (0x304D0, 0x30580, "0x304E8 memcpy?"),
        (0x7A30, 0x7B20, "apply analog (again, with better context)"),
        (0x9AA0, 0x9B80, "after unpack: checks + ACK + apply?"),
    ]
    for a, b, note in ranges:
        print(f"\n##### {note} #####")
        disasm_range(data, a, b)

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
