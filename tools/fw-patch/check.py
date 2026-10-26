#!/usr/bin/env python3
"""Diff an image against the factory image and name every changed byte.

  python tools/fw-patch/check.py radio_firmware/build/DMR003.UVm1.V022.bin

Each changed range is attributed to the patch site (or the version tag) it belongs to;
anything unattributed is printed as UNKNOWN and the exit code is 1. Host only.
"""
import hashlib
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
import build  # noqa: E402

# Images the build scripts reproduce byte for byte. The extension and its
# hooks are not rows in patches.toml; a matching hash is how check.py knows
# those bytes. Recorded 2026-10-26 from fw21_build.py and fw22_build.py.
PINNED = {
    "DMR003.FW21.V022": "f726056aa3e62db4399d45ee6cf5df4e29756083761c1651ce734d4c08d477ed",
    "DMR003.FW22.V022": "38f900a0df169c0101f9e6183fe8ec8d2e9cdca74169f034f5571b04aa988d6a",
}


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
    version = img[0x38464:0x38474].decode(errors="replace")
    digest = hashlib.sha256(img).hexdigest()
    pinned = PINNED.get(version)
    if pinned and digest == pinned:
        extra = f" ({len(unknown)} bytes outside patches.toml)" if unknown else ""
        print(f"pinned {version} {digest}{extra}")
        print(f"version: {version}")
        return 0
    if pinned:
        print(f"PIN MISMATCH {version} {digest}")
        print(f"expected    {pinned}")
    for i in unknown:
        print(f"0x{i:05X} UNKNOWN {fac[i]:02x} -> {img[i]:02x}")
    print(f"version: {version}")
    return 1 if unknown or pinned else 0


if __name__ == "__main__":
    sys.exit(main())
