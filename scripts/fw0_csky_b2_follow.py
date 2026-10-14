#!/usr/bin/env python3
"""FW-B2 follow: helpers 0x3ddc / 0x11940, analog unpack, RX after 0x20/0x21."""
from __future__ import annotations

import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
from fw0_csky_disasm import BIN, disasm_range, iter_insns  # noqa: E402


def main() -> int:
    data = BIN.read_bytes()
    ranges = [
        (0x3DC0, 0x3E80, "helper 0x3ddc (cmd in r0)"),
        (0x11920, 0x11A20, "helper 0x11940 (cmd in r1)"),
        (0x0640, 0x06E0, "ld.b #10 then bez — clamp candidate"),
        (0x09A20, 0x09B40, "analog 19-byte unpack (sq at #10)"),
        (0x09CE0, 0x09DC0, "second analog unpack +0x9d08"),
        (0x09840, 0x09940, "third analog unpack +0x9866"),
        (0x07C80, 0x07D50, "RX after cmp 0x20/0x21"),
        (0x02A260, 0x02A340, "copy analog fields #8..#10"),
        (0x07940, 0x079C0, "type switch 0x794c"),
        (0x02460, 0x024B0, "bsr +0x2474 (ld.b global rts)"),
    ]
    for a, b, note in ranges:
        print(f"\n##### {note} #####")
        disasm_range(data, a, b)

    print("\n=== after ld.b #10: look for movi #2 / cmpnei #2 / st.b #10 ===")
    insns = list(iter_insns(data, 0, min(len(data), 0x20000)))  # code-ish prefix
    for i, (off, sz, text, raw) in enumerate(insns):
        if "ld" in text and "#10)" in text and ".b" in text:
            win = insns[i : i + 16]
            texts = [t for _, _, t, _ in win]
            blob = " || ".join(texts)
            if any(
                s in blob
                for s in (
                    "movi16 r",  # too broad
                )
            ):
                interesting = any(
                    ("#0x2" in t or "#2" in t or "#0x0" in t)
                    and ("movi" in t or "cmpnei" in t)
                    for t in texts[1:8]
                ) or any("st" in t and "#10)" in t for t in texts[1:8])
                if interesting:
                    print(f"  {off:#07x}")
                    for o, _, t, _ in win[:10]:
                        print(f"    {o:#07x}  {t}")

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
