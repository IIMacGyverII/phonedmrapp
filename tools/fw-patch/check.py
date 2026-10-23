#!/usr/bin/env python3
"""Diff an image against the factory image and name every changed byte.

  python tools/fw-patch/check.py radio_firmware/build/DMR003.UVm1.V022.bin

Each changed range is attributed to the patch site (or the version tag) it belongs to;
anything unattributed is printed as UNKNOWN and the exit code is 1. Host only.
"""
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
import build  # noqa: E402


def main():
    if len(sys.argv) != 2:
        raise SystemExit(__doc__)
    cfg = build.load()
    fac = build.factory_bytes(cfg)
    img = Path(sys.argv[1]).read_bytes()
    if len(img) != len(fac):
        print(f"SIZE {len(img)} != factory {len(fac)}")
        return 1
    known = {}
    for name, p in cfg["patches"].items():
        for s in p["sites"]:
            n = len(bytes.fromhex(s["original"]))
            for b in range(s["offset"], s["offset"] + n):
                known[b] = (name, s["offset"], s["replacement"])
    t = cfg["tag"]
    for b in range(t["offset"], t["offset"] + t["length"]):
        known[b] = ("tag", t["offset"], None)
    seen, unknown = {}, []
    for i, (x, y) in enumerate(zip(fac, img)):
        if x == y:
            continue
        if i in known:
            seen.setdefault(known[i][:2], known[i])
        else:
            unknown.append(i)
    for (name, off), (_, _, repl) in sorted(seen.items(), key=lambda k: k[0][1]):
        n = len(bytes.fromhex(repl)) if repl else t["length"]
        got = img[off:off + n]
        tag = "" if repl is None or got.hex() == repl else "  (differs from patches.toml)"
        print(f"0x{off:05X} {name:20} {got.hex() if repl else got.decode(errors='replace')}{tag}")
    for i in unknown:
        print(f"0x{i:05X} UNKNOWN {fac[i]:02x} -> {img[i]:02x}")
    print(f"version: {img[0x38464:0x38474].decode(errors='replace')}")
    return 1 if unknown else 0


if __name__ == "__main__":
    sys.exit(main())
