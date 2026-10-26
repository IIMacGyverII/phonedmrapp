"""PC-relative literal loads must not read a range a patch overwrites.

The failure that made FW27 ignore 0x26 was a load, not a branch: the key
helper at 0x5BBE2 still executed `lrw r4, 0x4A3E4` from the pool at
0x5BEA0 after the stub had replaced that word. objdump is the decoder.
A hit is an lrw whose literal address lies in a written span and whose
instruction lies outside every written span. The next instruction has to
name the register lrw just wrote, which is how this image uses a literal
and how a sine-table halfword that merely disassembles as lrw is left out.
A pool word of zeros is padding, not a live constant.
"""
import re
import subprocess
import tempfile
from pathlib import Path

OBJDUMP = r"C:\Users\Joshua\tools\csky-elfabiv2\bin\csky-elfabiv2-objdump.exe"
_LINE = re.compile(r"^\s*([0-9a-f]+):\s+\S+\s+(\S+)\s*(.*)$")
_REG = re.compile(r"\br(\d+)\b")
_POOL = re.compile(r"//\s+0x([0-9a-f]+)|address pool at 0x([0-9a-f]+)")


def literal_loads(image):
    """(instruction address, literal address) for every live lrw."""
    with tempfile.NamedTemporaryFile(suffix=".bin", delete=False) as tmp:
        tmp.write(image)
        path = tmp.name
    try:
        proc = subprocess.run(
            [OBJDUMP, "-b", "binary", "-m", "csky", "-D", path],
            capture_output=True, check=True)
    finally:
        Path(path).unlink(missing_ok=True)
    text = proc.stdout.decode("utf-8", "replace")
    rows = []
    for ln in text.splitlines():
        m = _LINE.match(ln)
        if m:
            rows.append((int(m.group(1), 16), m.group(2), m.group(3)))
    loads = []
    for i, (pc, mnem, rest) in enumerate(rows):
        if mnem != "lrw" or i + 1 >= len(rows):
            continue
        reg = _REG.search(rest)
        pool = _POOL.search(rest)
        if not reg or not pool:
            continue
        nxt_mnem, nxt_rest = rows[i + 1][1], rows[i + 1][2]
        # The literal is live when the next instruction reads it back, as a
        # base `(rN` or as the other input of a compare. A following lrw or
        # movi only writes that register, which is how the data tables
        # disassemble.
        reg_s = reg.group(1)
        base = "(r%s" % reg_s in nxt_rest.replace(" ", "")
        compared = nxt_mnem.startswith("cmp") and re.search(r"\br%s\b" % reg_s, nxt_rest)
        if not base and not compared:
            continue
        # Bytes 04 00 are a sine-table sample. objdump reads them as
        # `lrw r0, [pc, 1004]` and the following store names r0.
        if image[pc:pc + 2] == b"\x04\x00":
            continue
        loads.append((pc, int(pool.group(1) or pool.group(2), 16)))
    return loads


def written_ranges(old, new):
    """Half-open spans where the two images differ."""
    if len(old) != len(new):
        raise ValueError("length %d vs %d" % (len(old), len(new)))
    spans = []
    start = None
    for i, (a, b) in enumerate(zip(old, new)):
        if a != b:
            if start is None:
                start = i
        elif start is not None:
            spans.append((start, i))
            start = None
    if start is not None:
        spans.append((start, len(old)))
    return spans


def _inside(addr, spans):
    for start, end in spans:
        if start <= addr < end:
            return True
    return False


def covered_loads(old, new):
    """Loads issued outside a written span whose literal sits inside one.

    The load is read from the base image: the patch did not rewrite the
    instruction, so the address it names is still the one the CPU uses.
    """
    spans = written_ranges(old, new)
    hits = []
    for pc, pool in literal_loads(old):
        if pool < 0 or pool + 4 > len(old):
            continue
        # A zero word is padding. The lrw16 encoding of "constant 0, far
        # half" is a halfword of zeros, which the disassembler calls bkpt,
        # and sine-table bytes also decode as lrw of a zero they do not load.
        if old[pool:pool + 4] == b"\x00\x00\x00\x00":
            continue
        if _inside(pc, spans):
            continue
        if _inside(pool, spans):
            hits.append((pc, pool))
    return spans, hits
