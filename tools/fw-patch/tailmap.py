"""Recursive-descent reachability map of the stub tail of a DMR003 image.

Usage: python tailmap.py IMAGE [--old OLD] [--dump]
Roots: every 32-bit word anywhere in the image equal to 0x0301A000 + a tail
offset (XIP pointer), every branch/call from outside the tail into it, and
grs targets. Code is followed from roots; lrw pools and pointed-to data are
marked. Prints the map as ranges: code / pool / data(ptr) / unreached.
"""
import re
import struct
import subprocess
import sys

OD = r"C:\Users\Joshua\tools\csky-elfabiv2\bin\csky-elfabiv2-objdump.exe"
XIP = 0x0301A000
TAIL = 0x5AEFC
END = 0x5C6FC

COND = {"bt", "bf", "bez", "bnez", "bhz", "blsz", "blz", "bhsz", "bnezad"}
CALL = {"bsr", "jbsr"}
STOP = {"br", "jmp", "rts", "rte", "jmpi", "jmpix", "bkpt"}
LINE = re.compile(r"^\s*([0-9a-f]+):\s+([0-9a-f]+)(?: ([0-9a-f]+))?\s+(\S+)\s*(.*)$")


def disasm(img_path, start, stop):
    out = subprocess.run([OD, "-D", "-b", "binary", "-m", "csky", "-EL",
                          "--adjust-vma=0", "--start-address=0x%x" % start,
                          "--stop-address=0x%x" % stop, img_path],
                         capture_output=True, text=True).stdout
    ins = []
    for line in out.splitlines():
        m = LINE.match(line)
        if not m:
            continue
        a = int(m.group(1), 16)
        size = (len(m.group(2)) + len(m.group(3) or "")) // 2
        ins.append((a, size, m.group(4), m.group(5)))
    return ins


def target_of(ops):
    m = re.search(r"//\s*0x([0-9a-f]+)", ops)
    if m:
        return int(m.group(1), 16)
    m = re.search(r"0x([0-9a-f]+)\s*$", ops)
    return int(m.group(1), 16) if m else None


def trace(img_path, img, roots):
    kind = {}          # offset -> 'code' | 'pool' | 'data'
    why = {}           # block start -> reason
    calls_out = set()
    computed = []      # (addr, text) indirect jumps needing a look
    global data_ptrs
    data_ptrs = {}
    work = list(roots.items())
    seen = set()
    while work:
        start, reason = work.pop()
        if start in seen or not (TAIL <= start < END):
            continue
        seen.add(start)
        why.setdefault(start, reason)
        last_lrw = {}
        for a, size, mn, ops in disasm(img_path, start, min(END, start + 0x400)):
            if kind.get(a) == "code":
                break
            for k in range(size):
                kind[a + k] = "code"
            if mn in ("jmp", "jsr") and ops.strip().split()[0] in last_lrw:
                off = last_lrw[ops.strip().split()[0]] - XIP
                if TAIL <= off < END:
                    work.append((off, "%s via lrw@%X" % (mn, a)))
            if mn in ("lrw", "jsri", "jmpi"):
                pool = target_of(ops.split("//")[-1]) if "//" in ops else None
                if pool is not None and pool + 4 <= len(img):
                    for k in range(4):
                        kind.setdefault(pool + k, "pool")
                    val = struct.unpack_from("<I", img, pool)[0]
                    reg = ops.split(",")[0].strip()
                    last_lrw[reg] = val
                    off = val - XIP
                    if TAIL <= off < END:
                        data_ptrs.setdefault(off, "ptr lrw@%X" % a)
            if mn == "grs":
                t = target_of(ops)
                if t is not None:
                    work.append((t, "grs@%X" % a))
            if mn in COND or mn in CALL or mn == "br":
                t = target_of(ops)
                if t is not None:
                    if TAIL <= t < END:
                        work.append((t, "%s@%X" % (mn, a)))
                    else:
                        calls_out.add((a, mn, t))
            if mn in ("jmp", "jsr"):
                reg = ops.strip().split()[0] if ops.strip() else ""
                if reg not in last_lrw:
                    computed.append((a, mn + " " + ops))
            if mn in STOP:
                break
            if mn == "pop" and "r15" in ops:
                break
    return kind, why, calls_out, computed


def roots_of(img_path, img):
    roots = {TAIL: "cmd40 entry"}
    xip = {}
    for i in range(0, len(img) - 3, 2):
        off = struct.unpack_from("<I", img, i)[0] - XIP
        if TAIL <= off < END:
            xip[off] = i
    globals()["XIPWORDS"] = xip
    # branches from outside the tail (linear sweep of the non-tail image)
    for a, size, mn, ops in disasm(img_path, 0, TAIL):
        if mn in COND or mn in CALL or mn == "br" or mn == "grs":
            t = target_of(ops)
            if t is not None and TAIL <= t < END:
                roots.setdefault(t, "%s@%X" % (mn, a))
    return roots


def ranges(kind):
    out = []
    a = TAIL
    while a < END:
        k = kind.get(a, "unreached")
        b = a
        while b < END and kind.get(b, "unreached") == k:
            b += 1
        out.append((a, b, k))
        a = b
    return out


def main():
    path = sys.argv[1]
    img = open(path, "rb").read()
    roots = roots_of(path, img)
    kind, why, calls_out, computed = trace(path, img, roots)
    for off, w in data_ptrs.items():
        if kind.get(off) != "code":
            for k in range(4):
                kind.setdefault(off + k, "dataptr")
    print("xip words, and whether code reached them:")
    for off, i in sorted(XIPWORDS.items()):
        print("  word@%X -> %X  %s  %s" % (i, off, kind.get(off, "unreached"), data_ptrs.get(off, "")))
    print("roots:")
    for r, w in sorted(roots.items()):
        print("  %X  %s" % (r, w))
    print("map:")
    for a, b, k in ranges(kind):
        tag = why.get(a, "")
        print("  %X-%X %5d %-9s %s" % (a, b - 1, b - a, k, tag))
    print("calls out of the tail:")
    for a, mn, t in sorted(calls_out):
        print("  %X %s %X" % (a, mn, t))
    print("indirect jumps without a known lrw:")
    for a, t in computed:
        print("  %X %s" % (a, t))
    print("unreached total:", sum(b - a for a, b, k in ranges(kind) if k == "unreached"))


if __name__ == "__main__":
    main()
