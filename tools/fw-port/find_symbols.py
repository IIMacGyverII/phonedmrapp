#!/usr/bin/env python3
"""Find the anchors a firmware port needs in an HR-C7000 module image (C-SKY V2).

  python tools/fw-port/find_symbols.py radio_firmware/DMR003.UV4T.V022-ORIGINAL.bin
  python tools/fw-port/find_symbols.py <image> --symbols radio_firmware/symbols.csv   # compare

First piece of the port automation (radio_firmware/plan-port-automation.md, stage 2).
Host only, nothing is sent. Reads one image and prints, as JSON:

  version      the version string (what 0x34 reports) and its file offset
  thunks       the command dispatch table: 8-byte entries `mov r0, r4; bsr handler; pop r4-r8, r15` (the
               Armor's); when an image has none, `pop r4-rN, r15` for any N is tried and named in "idiom"
  tot          the time-out timer (idiom: movi r1, 100; mult; cmphs), the 6-byte time-out struct it
               reads, and the dispatch entry whose handler writes that struct (= the 0x3B handler)
  identified   handlers named by what they touch (0x3B writes the time-out struct, 0x34 references
               the version string); the switch order is the compiler's, so never trust the position
  free         zero runs of 512 bytes or more inside the image (stub space candidates)
  switch       (--switch) the command switch itself: `subi r3, base; cmphsi r3, n; lrw r2, table;
               ldr.w r3, (r2, r3 << 2); jmp r3`, its table read out, so each command byte names its case and
               the handler that case calls; 0x3B and 0x34 are then confirmed by byte and by what they touch
  known        for each symbols.csv row (when given): whether a found anchor lands on it

Validated on the Armor's DMR003.UV4T.V022 (FW19 review, 2026-10-24) and on the Atom XL's DMR006.U4A.V076
(2026-10-26, sha256 4f5f287b...4d40fe, the vendor-partition updater copy): the same jump-table switch (table at
file +0x33274, 103 cases from command 0x22), case bodies ending `pop r4-r5, r15`; 0x3B = case 0xa058 -> handler
0x9a5c (writes the time-out struct 0x38AF8), 0x34 = case 0xa09c -> handler 0x9f18 (loads the version string at
+0x33410). The Atom XL runs V082, not V076: nothing found here may be built for or loaded on an Atom XL until V082
is obtained and diffed. Tests: tools/fw-port/test_find_symbols.py. 16-bit `lrw` only so far.
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
POP_R4_RN_R15 = range(0x1491, 0x1499)   # pop r4-r4 .. r4-r11, always with r15
LDRW_R3_R2_R3_LSL2 = (0xD062, 0x0883)
JMP_R3 = 0x780C
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


def find_thunks(img, min_run=3, pops=(POP_R4_R8_R15,)):
    """Dispatch entries `mov r0, r4; bsr handler; pop r4-r8, r15` in runs of at least `min_run`
    (the switch's case bodies; their order is the compiler's, not the command byte's). `pops` widens the
    accepted epilogue (an image whose switch function saves fewer registers)."""
    runs, cur = [], []
    off = 0
    while off + 8 <= len(img):
        if half(img, off) == MOV_R0_R4 and is_bsr32(half(img, off + 2)) and half(img, off + 6) in pops:
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


def find_dispatch(img):
    """The Armor's thunk shape first (its output stays exactly as it was); otherwise any `pop r4-rN, r15`,
    with the epilogue the runs used named in "idiom"."""
    t = find_thunks(img)
    if t:
        return t
    t = find_thunks(img, pops=POP_R4_RN_R15)
    if t:
        used = sorted({half(img, e["entry"] + 6) for e in t["entries"]})
        t["idiom"] = "mov r0, r4; bsr; " + " / ".join(f"pop r4-r{4 + (p & 0xF) - 1}, r15" for p in used)
    return t


def find_switch(img):
    """`subi r3, base; ... cmphsi r3, n; ... lrw r2, table; ldr.w r3, (r2, r3 << 2); jmp r3`: the command switch.
    Returns every one found, its table read out (case file offsets, index = command byte - base)."""
    out = []
    for off in range(0, len(img) - 6, 2):
        if (half(img, off), half(img, off + 2)) != LDRW_R3_R2_R3_LSL2 or half(img, off + 4) != JMP_R3:
            continue
        table = n = base = None
        for b in range(off - 2, max(0, off - 18), -2):
            h = half(img, b)
            r = lrw16(img, b)
            if table is None and r and r[0] == 2:
                table = r[1] - XIP
            elif n is None and h == 0xEB03 and b + 4 <= off:
                n = half(img, b + 2) + 1
            elif base is None and (h & 0xFF00) == 0x2B00:
                base = (h & 0xFF) + 1
        if table is None or n is None or base is None or not (0 <= table and table + 4 * n <= len(img)):
            continue
        cases = [struct.unpack_from("<I", img, table + 4 * i)[0] - XIP for i in range(n)]
        if not all(0 <= c < len(img) for c in cases):
            continue
        out.append({"jump": off, "table": table, "base": base, "count": n, "cases": cases})
    return out


def case_handler(img, case):
    """The handler a case body calls: `mov r0, r4; bsr h` at the case, else None (an inline case)."""
    if case + 6 <= len(img) and half(img, case) == MOV_R0_R4 and is_bsr32(half(img, case + 2)):
        return bsr_target(img, case + 2)
    return None


def switch_report(img, tot_struct, ver):
    """--switch: per switch, every command byte with its case and handler and what the handler touches."""
    sw = []
    for s_ in find_switch(img):
        default = max(set(s_["cases"]), key=s_["cases"].count)   # the out-of-range / unknown-command case
        cmds, named = {}, {}
        starts = sorted({h for h in (case_handler(img, c) for c in s_["cases"]) if h is not None})
        for i, c in enumerate(s_["cases"]):
            if c == default:
                continue
            h = case_handler(img, c)
            touches = []
            if h is not None:
                # the handler's own body only: up to the next handler the switch calls (adjacent handlers share literals)
                end = min([x for x in starts if x > h] + [h + 0x100])
                lits = handler_literals(img, h, end - h)
                if tot_struct and tot_struct in lits:
                    touches.append("tot struct")
                if ver and ((ver["offset"] + XIP) in lits or ver["offset"] in lits):
                    touches.append("version string")
            cmd = hex(s_["base"] + i)
            cmds[cmd] = {"case": hex(c), "handler": hex(h) if h is not None else None, "touches": touches}
            if "tot struct" in touches:
                named[cmd + " set_tot"] = hex(h)
            if "version string" in touches:
                named[cmd + " version"] = hex(h)
        sw.append({"jump": hex(s_["jump"]), "table": hex(s_["table"]), "base": hex(s_["base"]), "count": s_["count"],
                   "default_case": hex(default), "named": named, "commands": cmds})
    return sw


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
    ap.add_argument("--switch", action="store_true", help="read the command switch's jump table (command byte -> case -> handler)")
    a = ap.parse_args()
    img = a.image.read_bytes()

    out = {"image": str(a.image), "size": len(img), "xip_base": hex(XIP)}
    out["version"] = find_version(img)
    thunks = find_dispatch(img)
    out["thunks"] = None if not thunks else {"runs": [{"start": hex(r["start"]), "count": r["count"]} for r in thunks["runs"]], "count": thunks["count"]}
    if thunks and "idiom" in thunks:
        out["thunks"]["idiom"] = thunks["idiom"]

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
    if a.switch:
        out["switch"] = switch_report(img, tot_struct, ver)

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
