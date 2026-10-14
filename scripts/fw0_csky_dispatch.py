#!/usr/bin/env python3
"""FW-B2: C-SKY V2 RX command dispatch + analog body / squelch clamp hunt.

Does not patch. Uses LLVM encodings (cmpnei32 = opc 0x3A sop 0x1A).
"""
from __future__ import annotations

import re
import sys
from collections import defaultdict
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
from fw0_csky_disasm import (  # noqa: E402
    BIN,
    disasm_range,
    is32,
    iter_insns,
    u16,
)

PROT = {
    0x20: "cmd?",
    0x21: "cmd? (MCU extra)",
    0x22: "SET_DIGITAL",
    0x23: "SET_ANALOG",
    0x24: "cmd?",
    0x27: "QUERY_INIT",
    0x28: "SET_ENHANCE",
    0x29: "SET_ENCRYPT",
    0x2A: "SET_GAIN_MIC",
    0x2B: "Q_DIG_AUDIO",
    0x2C: "SEND_SMS",
    0x2D: "RECV_SMS",
    0x2E: "SET_VOL",
    0x2F: "SET_LISTEN",
    0x30: "SET_SQUELCH",
    0x32: "Q_RSSI",
    0x33: "SET_OFFLINE/RELAY",
    0x34: "QUERY_VERSION",
    0x35: "INTERRUPT_TX",
    0x36: "STATUS",
    0x37: "SET_POLITE",
    0x3B: "SET_TOT",
    0x3F: "BER",
    0x68: "HEAD",
    0xAA: "INIT",
}

ANALOG = {
    0: "rxFreq[0]",
    1: "rxFreq[1]",
    2: "rxFreq[2]",
    3: "rxFreq[3]",
    4: "txFreq[0]",
    5: "txFreq[1]",
    6: "txFreq[2]",
    7: "txFreq[3]",
    8: "band",
    9: "power",
    10: "sq",
    11: "rxType",
    12: "rxSubCode",
    13: "txType",
    14: "txSubCode",
    15: "pwrSave",
    16: "volume",
    17: "monitor",
    18: "relay",
}

LD_RE = re.compile(
    r"^ld(?:16|32)\.b r(\d+), \(r(\d+), #(\d+)\)$"
)
ST_RE = re.compile(
    r"^st(?:16|32)\.b r(\d+), \(r(\d+), #(\d+)\)$"
)
MOVI_RE = re.compile(r"^movi(?:16|32) r(\d+), #0x([0-9a-f]+)$")
CMPNEI_RE = re.compile(r"^cmpnei(?:16|32) r(\d+), #(?:0x)?([0-9a-f]+)$")
BSR_RE = re.compile(r"^bsr32 0x([0-9a-f]+)$")
JSRI_RE = re.compile(r"^jsri32 \[0x([0-9a-f]+)\]$")
JMPI_RE = re.compile(r"^jmpi32 \[0x([0-9a-f]+)\]$")
LRW_RE = re.compile(r"^lrw32 r(\d+), \[0x([0-9a-f]+)\]$")


def pool_word(data: bytes, pool: int) -> int | None:
    if 0 <= pool + 4 <= len(data):
        return int.from_bytes(data[pool : pool + 4], "little")
    return None


def walk_all(data: bytes):
    return list(iter_insns(data, 0, len(data)))


def main() -> int:
    data = BIN.read_bytes()
    insns = walk_all(data)
    by_off = {off: (sz, text, raw) for off, sz, text, raw in insns}
    print(f"file {BIN.name}  size={len(data)}  insns={len(insns)}")

    print("\n=== cmpnei16/32 against protocol bytes ===")
    for off, sz, text, raw in insns:
        m = CMPNEI_RE.match(text)
        if not m:
            continue
        imm = int(m.group(2), 16)
        if imm in PROT:
            print(f"  {off:#07x}  {text:40}  {PROT[imm]}")

    print("\n=== jsri32 / jmpi32 (pool → word) ===")
    n_jsri = n_jmpi = 0
    for off, sz, text, raw in insns:
        m = JSRI_RE.match(text)
        if m:
            n_jsri += 1
            pool = int(m.group(1), 16)
            w = pool_word(data, pool)
            extra = ""
            if w is not None:
                extra = f" -> {w:#x}"
                if 0 <= w < len(data):
                    extra += " IN-IMAGE"
            if n_jsri <= 40 or (w is not None and 0 <= (w or -1) < len(data)):
                print(f"  jsri {off:#07x}  pool {pool:#x}{extra}")
            continue
        m = JMPI_RE.match(text)
        if m:
            n_jmpi += 1
            pool = int(m.group(1), 16)
            w = pool_word(data, pool)
            extra = ""
            if w is not None:
                extra = f" -> {w:#x}"
                if 0 <= w < len(data):
                    extra += " IN-IMAGE"
            if n_jmpi <= 20:
                print(f"  jmpi {off:#07x}  pool {pool:#x}{extra}")
    print(f"  totals: jsri32={n_jsri} jmpi32={n_jmpi}")

    print("\n=== 0xE2804FAC (the mystery 'bsr') ===")
    hits = [off for off, sz, text, raw in insns if raw == 0xE2804FAC]
    print(f"  synced-walk hits: {len(hits)}")
    for off in hits[:20]:
        print(f"    insn {off:#07x}  {by_off[off][1]}")
    # also raw byte search (may be unaligned)
    raw_hits = []
    needle = bytes.fromhex("80e2ac4f")  # LE halfwords 0xE280, 0x4FAC
    pos = 0
    while True:
        i = data.find(needle, pos)
        if i < 0:
            break
        raw_hits.append(i)
        pos = i + 1
    print(f"  raw byte hits of 80 e2 ac 4f: {len(raw_hits)} first={raw_hits[:12]}")

    print("\n=== bsr32 landing in-image (sample of unique targets near UART) ===")
    bsr_tgts: dict[int, list[int]] = defaultdict(list)
    oob = 0
    for off, sz, text, raw in insns:
        m = BSR_RE.match(text)
        if not m:
            continue
        tgt = int(m.group(1), 16)
        if 0 <= tgt < len(data):
            bsr_tgts[tgt].append(off)
        else:
            oob += 1
    print(f"  in-image unique targets={len(bsr_tgts)}  oob_bsr={oob}")
    for tgt in (0x8E5C, 0x8E7C, 0x8E80, 0x7D94, 0x7DE8, 0x5EF4, 0x7E94, 0x18E8, 0x1924, 0x2474):
        callers = bsr_tgts.get(tgt, [])
        print(f"  bsr -> {tgt:#x}: {len(callers)} callers  {', '.join(f'{c:#x}' for c in callers[:8])}")

    print("\n=== ld.b (rN, #10)  [analog sq offset] ===")
    ld10 = []
    for i, (off, sz, text, raw) in enumerate(insns):
        m = LD_RE.match(text)
        if m and int(m.group(3)) == 10:
            ld10.append((i, off, text, int(m.group(1)), int(m.group(2))))
    print(f"  count={len(ld10)}")
    for i, off, text, rz, rx in ld10:
        window = []
        for j in range(i, min(i + 12, len(insns))):
            window.append(insns[j][2])
        flag = ""
        joined = " | ".join(window)
        if re.search(r"cmpnei.*#0x0\b|cmpnei.*#0\b|bez32|movi.*#0x2\b", joined):
            flag = "  << clamp-ish"
        print(f"  {off:#07x}  {text}{flag}")
        print(f"           next: {joined}")

    print("\n=== analog-shaped sequential ld.b offsets (8..14 in one 24-insn window) ===")
    for i, (off, sz, text, raw) in enumerate(insns):
        m = LD_RE.match(text)
        if not m:
            continue
        base = int(m.group(2))
        offs = []
        for j in range(i, min(i + 24, len(insns))):
            m2 = LD_RE.match(insns[j][2])
            if m2 and int(m2.group(2)) == base:
                offs.append((insns[j][0], int(m2.group(3)), int(m2.group(1))))
        got = {o for _, o, _ in offs}
        if {8, 9, 10}.issubset(got) or {0, 4, 8, 10}.issubset(got):
            desc = ", ".join(
                f"{oa:#x}:#{imm}={ANALOG.get(imm, '?')}->r{rd}" for oa, imm, rd in offs
            )
            print(f"  window @{off:#07x}  {desc}")

    print("\n=== movi #0x22/#0x23 followed by call-like ===")
    for i, (off, sz, text, raw) in enumerate(insns):
        m = MOVI_RE.match(text)
        if not m:
            continue
        imm = int(m.group(2), 16)
        if imm not in (0x22, 0x23, 0x20, 0x21, 0x24, 0x2B, 0x36, 0x3B):
            continue
        nxt = []
        for j in range(i, min(i + 6, len(insns))):
            nxt.append(f"{insns[j][0]:#x}:{insns[j][2]}")
        print(f"  {off:#07x} movi r{m.group(1)}, #{imm:#x} ({PROT.get(imm,'')})")
        print(f"           {nxt}")

    ranges = [
        (0x7920, 0x7A80, "type-switch / movi 0x22-0x24"),
        (0x7C40, 0x7D94, "RX scan 0x68 / cmd byte"),
        (0x7E90, 0x7F40, "variable builder +0x7E94"),
        (0x8680, 0x8720, "ld.b #10 near UART"),
        (0x9300, 0x9480, "analog unpack candidate"),
        (0x44BC0, 0x44C80, "cmpnei #0x22 site"),
    ]
    for a, b, note in ranges:
        print(f"\n##### {note} #####")
        disasm_range(data, a, b)

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
