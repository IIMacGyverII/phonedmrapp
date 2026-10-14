#!/usr/bin/env python3
"""Clamp-pattern hunt + 0x788C / repack listings."""
from __future__ import annotations

import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
from fw0_csky_disasm import BIN, disasm_range, iter_insns  # noqa: E402


def main() -> int:
    data = BIN.read_bytes()
    insns = list(iter_insns(data, 0, 0xB000))

    print("=== bez32 then movi #2 within 6 insns ===")
    for i, (off, sz, text, raw) in enumerate(insns):
        if not text.startswith("bez32"):
            continue
        win = insns[i : i + 8]
        if any("movi" in t and t.endswith("#0x2") for _, _, t, _ in win[1:6]):
            print(f"  {off:#07x} {text}")
            for o, _, t, _ in win[:7]:
                print(f"           {o:#07x} {t}")

    print("\n=== cmpnei #0 then movi #2 within 8 insns ===")
    for i, (off, sz, text, raw) in enumerate(insns):
        if "cmpnei" not in text or not text.endswith("#0x0"):
            continue
        win = insns[i : i + 10]
        if any("movi" in t and t.endswith("#0x2") for _, _, t, _ in win[1:8]):
            print(f"  {off:#07x} {text}")
            for o, _, t, _ in win[:8]:
                print(f"           {o:#07x} {t}")

    print("\n=== bnez32 then movi #2 within 6 (if-nz set 2) ===")
    for i, (off, sz, text, raw) in enumerate(insns):
        if not text.startswith("bnez32"):
            continue
        win = insns[i : i + 8]
        if any("movi" in t and t.endswith("#0x2") for _, _, t, _ in win[1:6]):
            # only if nearby ld.b
            blob = " ".join(t for _, _, t, _ in win)
            if "ld" in blob and ".b" in blob:
                print(f"  {off:#07x} {text}")
                for o, _, t, _ in win[:7]:
                    print(f"           {o:#07x} {t}")

    ranges = [
        (0x788C, 0x794C, "apply helper 0x788C"),
        (0x2DD8, 0x2E50, "0x2DD8 from apply"),
        (0x9B80, 0x9C40, "between sq/txType checks and analog repack"),
        (0x8688, 0x8760, "UART-adjacent pack of #9/#10"),
        (0x7F80, 0x8040, "0x7f96 ld #164 near builder callers"),
        (0x9E00, 0x9E80, "0x9e02 branch target from cmpnei r11,#1"),
    ]
    for a, b, note in ranges:
        print(f"\n##### {note} #####")
        disasm_range(data, a, b)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
