#!/usr/bin/env python3
"""Build a modified radio-module image from the factory image and named patches.

  python tools/fw-patch/build.py --tag UVm1                 # tag only: version string, nothing else
  python tools/fw-patch/build.py --tag UVm3 fm-flat-58      # tag + named patches

Writes radio_firmware/build/DMR003.<tag>.V022.bin and a .sha256 next to it. Refuses to
write anything if the factory image is not the expected one, if any site's original bytes
do not match, or if two patches touch the same byte. The image size never changes. The tag
(the "UV4T" field of the version string, which 0x34 reports) is always set, so every built
image identifies itself.
Plan: docs/deep-dive/19-firmware-modification-plan.md (C1). Host only, nothing is sent.
"""
import argparse
import hashlib
import sys
import tomllib
from pathlib import Path

HERE = Path(__file__).resolve().parent
REPO = HERE.parent.parent


def load(path=HERE / "patches.toml"):
    with open(path, "rb") as f:
        return tomllib.load(f)


def factory_bytes(cfg):
    fac = cfg["factory"]
    data = (REPO / fac["file"]).read_bytes()
    if len(data) != fac["size"]:
        raise SystemExit(f"factory image is {len(data)} B, expected {fac['size']}")
    if hashlib.md5(data).hexdigest() != fac["md5"]:
        raise SystemExit("factory image MD5 does not match patches.toml")
    return data


def check_sites(cfg, data, names):
    """Return (offset, replacement bytes, label) for every site; raise on any mismatch."""
    out, owner = [], {}
    for name in names:
        p = cfg["patches"].get(name)
        if p is None:
            raise SystemExit(f"unknown patch: {name}")
        for s in p["sites"]:
            off = s["offset"]
            orig = bytes.fromhex(s["original"])
            repl = bytes.fromhex(s["replacement"])
            if len(orig) != len(repl):
                raise SystemExit(f"{name} @0x{off:X}: original and replacement differ in length")
            if data[off:off + len(orig)] != orig:
                raise SystemExit(f"{name} @0x{off:X}: factory bytes {data[off:off + len(orig)].hex()} != {orig.hex()}")
            for b in range(off, off + len(orig)):
                if b in owner:
                    raise SystemExit(f"{name} @0x{b:X} overlaps {owner[b]}")
                owner[b] = name
            out.append((off, repl, f"{name}: {s.get('note', '')}"))
    return out


def tag_site(cfg, data, tag):
    t = cfg["tag"]
    if len(tag) != t["length"] or not tag.isascii() or not tag.isalnum():
        raise SystemExit(f"--tag must be {t['length']} ASCII letters/digits")
    if tag == t["original"]:
        raise SystemExit("--tag must differ from the factory field")
    off = t["offset"]
    if data[off:off + t["length"]] != t["original"].encode():
        raise SystemExit("factory version field not where patches.toml says")
    return off, tag.encode()


def build(names, tag, cfg=None):
    cfg = cfg or load()
    data = factory_bytes(cfg)
    sites = check_sites(cfg, data, names)
    img = bytearray(data)
    for off, repl, _ in sites:
        img[off:off + len(repl)] = repl
    toff, tbytes = tag_site(cfg, data, tag)
    img[toff:toff + len(tbytes)] = tbytes
    assert len(img) == len(data)
    return bytes(img), sites


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--tag", required=True, help="4-character image tag, replaces UV4T in the version string")
    ap.add_argument("--out", default=str(REPO / "radio_firmware" / "build"))
    ap.add_argument("patches", nargs="*")
    a = ap.parse_args()
    img, sites = build(a.patches, a.tag)
    version = img[0x38464:0x38474].decode()
    out = Path(a.out)
    out.mkdir(parents=True, exist_ok=True)
    path = out / f"{version}.bin"
    path.write_bytes(img)
    sha = hashlib.sha256(img).hexdigest()
    (out / f"{version}.bin.sha256").write_text(f"{sha}  {path.name}\n")
    for off, repl, label in sites:
        print(f"  0x{off:05X} <- {repl.hex():8}  {label}")
    print(f"{path}  {len(img)} B  version {version}  sha256 {sha}")


if __name__ == "__main__":
    sys.exit(main())
