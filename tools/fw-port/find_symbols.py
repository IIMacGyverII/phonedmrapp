#!/usr/bin/env python3
"""Find the anchors a firmware port needs in an HR-C7000 module image (C-SKY V2).

  python tools/fw-port/find_symbols.py radio_firmware/DMR003.UV4T.V022-ORIGINAL.bin
  python tools/fw-port/find_symbols.py <image> --symbols radio_firmware/symbols.csv   # compare

First piece of the port automation (radio_firmware/plan-port-automation.md, stage 2).
Host only, nothing is sent. Reads one image and prints, as JSON:

  version      the version string (what 0x34 reports) and its file offset
  thunks       the command dispatch table: 8-byte entries `mov r0, r4; bsr handler; pop r4-r8, r15`
  tot          the time-out timer (idiom: movi r1, 100; mult; cmphs), the 6-byte time-out struct it
               reads, and the dispatch entry whose handler writes that struct (= the 0x3B handler)
  identified   handlers named by what they touch (0x3B writes the time-out struct, 0x34 references
               the version string); the switch order is the compiler's, so never trust the position
  free         zero runs of 512 bytes or more inside the image (stub space candidates)
  known        for each symbols.csv row (when given): whether a found anchor lands on it

Validated on the Armor's DMR003.UV4T.V022 (FW19 review, 2026-10-24). A second image (the Atom XL's
DMR006.U4A.V082) is what proves it finds anchors rather than remembers them. 16-bit `lrw` only so far.
"""
import argparse
import csv
import json
import re
import struct
import sys
from pathlib import Path

XIP = 0x0301A000  # file offset 0 of the image sits here in the C-SKY address space

MOV_R0_R4 = 0x6C13
POP_R4_R8_R15 = 0x1495
MOVI_R1_100 = 0x3164
MULT_R1_R4 = 0x7C50
CMPHS_R1_R2 = 0x6484


def half(img, off):
    return struct.unpack_from("<H", img, off)[0]


def is_bsr32(h0):
    return (h0 & 0xFC00) == 0xE000


def bsr_target(img, off):
    """bsr32 at file offset `off`: returns the target file offset (None if it leaves the XIP window)."""
    h0, h1 = half(img, off), half(img, off + 2)
    disp = ((h0 & 0x3FF) << 16) | h1
    if disp & (1 << 25):
        disp -= 1 << 26
    tgt = off + disp * 2
    return tgt if 0 <= tgt < len(img) else None


def lrw16(img, off):
    """16-bit lrw at `off` → (rz, literal value) or None."""
    h = half(img, off)
    if (h & 0xF800) != 0x1000:
        return None
    rz = (h >> 5) & 7
    imm = (((h >> 8) & 7) << 5) | (h & 0x1F)
    lit = ((off + XIP) & ~3) + imm * 4 - XIP
    if lit + 4 > len(img):
        return None
    return rz, struct.unpack_from("<I", img, lit)[0]


def literals(img, start, length):
    """Every 16-bit lrw literal in [start, start+length), scanning on the 2-byte grid."""
    out = []
    for off in range(start, min(start + length, len(img) - 4), 2):
        r = lrw16(img, off)
        if r:
            out.append((off, r[0], r[1]))
    return out


def find_version(img):
    m = re.search(rb"DMR\d{3}\.[A-Z0-9]{3,5}\.V\d{3}", img)
    if not m:
        return None
    return {"string": m.group(0).decode(), "offset": m.start()}


def find_thunks(img, min_run=3):
    """Dispatch entries `mov r0, r4; bsr handler; pop r4-r8, r15` in runs of at least `min_run`
    (the switch's case bodies; their order is the compiler's, not the command byte's)."""
    runs, cur = [], []
    off = 0
    while off + 8 <= len(img):
        if half(img, off) == MOV_R0_R4 and is_bsr32(half(img, off + 2)) and half(img, off + 6) == POP_R4_R8_R15:
            tgt = bsr_target(img, off + 2)
            if cur and off != cur[-1]["entry"] + 8:
                if len(cur) >= min_run:
                    runs.append(cur)
                cur = []
            cur.append({"entry": off, "handler": tgt})
            off += 8
            continue
        off += 2
    if len(cur) >= min_run:
        runs.append(cur)
    if not runs:
        return None
    entries = [e for r in runs for e in r]
    return {"runs": [{"start": r[0]["entry"], "count": len(r)} for r in runs], "count": len(entries), "entries": entries}


def find_tot_timer(img):
    """The wake routine: movi r1, 100 … mult r1, r4 … cmphs r1, r2 within 16 bytes; the struct is the
    lrw literal loaded just before (first lrw into r3 in the preceding 32 bytes)."""
    hits = []
    for off in range(0, len(img) - 16, 2):
        if half(img, off) != MOVI_R1_100:
            continue
        window = [half(img, o) for o in range(off + 2, off + 42, 2)]
        if MULT_R1_R4 in window and CMPHS_R1_R2 in window:
            lits = [l for l in literals(img, max(0, off - 48), 48) if l[1] == 3]
            struct_addr = lits[-1][2] if lits else None
            hits.append({"idiom": off, "struct": struct_addr})
    return hits


def handler_literals(img, handler, length=0x60):
    return {v for _, _, v in literals(img, handler, length)}


def find_free(img, min_len=512):
    out, i, n = [], 0, len(img)
    while i < n:
        if img[i] == 0:
            j = i
            while j < n and img[j] == 0:
                j += 1
            if j - i >= min_len:
                out.append({"offset": i, "length": j - i})
            i = j
        else:
            i += 1
    return out


def main():
    ap = argparse.ArgumentParser(description=__doc__.split("\n")[0])
    ap.add_argument("image", type=Path)
    ap.add_argument("--symbols", type=Path, help="symbols.csv to compare against")
    ap.add_argument("--entries", action="store_true", help="print every dispatch entry")
    a = ap.parse_args()
    img = a.image.read_bytes()

    out = {"image": str(a.image), "size": len(img), "xip_base": hex(XIP)}
    out["version"] = find_version(img)
    thunks = find_thunks(img)
    out["thunks"] = None if not thunks else {"runs": [{"start": hex(r["start"]), "count": r["count"]} for r in thunks["runs"]], "count": thunks["count"]}

    timers = find_tot_timer(img)
    out["tot"] = {"timer_candidates": [{"idiom": hex(t["idiom"]), "struct": hex(t["struct"]) if t["struct"] else None} for t in timers]}
    tot_struct = next((t["struct"] for t in timers if t["struct"]), None)

    # Handlers are identified by what they touch, never by their position in the switch.
    ident = {}
    ver = out["version"]
    if thunks:
        for e in thunks["entries"]:
            h = e["handler"]
            if h is None:
                continue
            lits = handler_literals(img, h, 0x100)
            if tot_struct and tot_struct in lits:
                ident.setdefault("0x3B set_tot", []).append(hex(h))
            if ver and ((ver["offset"] + XIP) in lits or ver["offset"] in lits):
                ident.setdefault("0x34 version", []).append(hex(h))
    out["identified"] = ident
    if a.entries and thunks:
        out["entries"] = [{"entry": hex(e["entry"]), "handler": hex(e["handler"]) if e["handler"] is not None else None}
                          for e in thunks["entries"]]

    out["free"] = [{"offset": hex(f["offset"]), "length": f["length"]} for f in find_free(img)]

    if a.symbols and a.symbols.exists():
        found = {}
        if thunks:
            for i, e in enumerate(thunks["entries"]):
                if e["handler"] is not None:
                    found[e["handler"]] = f"dispatch entry {i}"
        for t in timers:
            found[t["idiom"]] = "tot timer idiom"
        known = []
        with open(a.symbols, newline="", encoding="utf-8") as f:
            for row in csv.DictReader(f):
                off = int(row["offset"], 16)
                hit = found.get(off) or next((v + " (near)" for k, v in found.items() if abs(k - off) <= 0x20), None)
                known.append({"name": row["name"], "offset": row["offset"], "found": hit})
        out["known"] = known
        out["known_hit"] = sum(1 for k in known if k["found"])

    json.dump(out, sys.stdout, indent=1)
    print()


if __name__ == "__main__":
    main()
