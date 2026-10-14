#!/usr/bin/env python3
"""FW0: show the image is not compiler Thumb.

Counts 16-bit LE halfwords, the 0xE468 (bytes 68 e4) stream, and
Thumb epilogue markers. Does not patch or flash.
"""
from __future__ import annotations

import collections
import struct
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
BIN = ROOT / "radio_firmware" / "DMR003.UV4T.V022-ORIGINAL.bin"


def u16(data: bytes, off: int) -> int:
    return struct.unpack_from("<H", data, off)[0]


def main() -> int:
    data = BIN.read_bytes()
    size = len(data)
    print(f"file: {BIN}  size={size}")

    hw_hist: collections.Counter[int] = collections.Counter()
    for off in range(0, size - 1, 2):
        hw_hist[u16(data, off)] += 1
    print("\n=== 16-bit LE hist (top 15) ===")
    for hw, n in hw_hist.most_common(15):
        print(f"  {hw:#06x}  n={n:5}  bytes {struct.pack('<H', hw).hex()}")

    e468 = [off for off in range(0, size - 3, 2) if u16(data, off) == 0xE468]
    nxt: collections.Counter[int] = collections.Counter(u16(data, off + 2) for off in e468)
    print(f"\n=== 0xE468 (bytes 68 e4) even-aligned n={len(e468)} ===")
    print("  next halfword top:")
    for hw, n in nxt.most_common(12):
        print(f"    {hw:#06x}  n={n}")

    bx_lr = pop_pc = push_lr = 0
    for off in range(0, size - 1, 2):
        hw = u16(data, off)
        if hw == 0x4770:
            bx_lr += 1
        if (hw & 0xFF00) == 0xBD00:
            pop_pc += 1
        if (hw & 0xFF00) == 0xB500:
            push_lr += 1
    print("\n=== Thumb epilogue markers (even-aligned) ===")
    print(f"  bx lr (0x4770): {bx_lr}")
    print(f"  pop {{..,pc}} (0xBDxx): {pop_pc}")
    print(f"  push {{..,lr}} (0xB5xx): {push_lr}")
    print("A ~380 KiB Cortex-M compiler image would have hundreds of bx lr / pop pc.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
