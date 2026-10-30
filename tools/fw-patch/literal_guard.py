"""A patch must not cover a literal or a branch target that outside code uses.

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


# Live data. The 128 zeros at 0x35F64 are the tail of this table, not a
# code cave: image 3 and R4l both failed to boot after writing there.
# Measured on FW29, which matches the factory image across the range:
# the 0x05 run, the short gap, then 0x03, 0x02, 0x01 and the zero tail.
NEVER_WRITE = (range(0x35DF4, 0x35FE4),)


def never_written(old, new):
    """Offsets inside NEVER_WRITE whose bytes changed. Empty means clean."""
    if len(old) != len(new):
        raise ValueError("length")
    hits = []
    for span in NEVER_WRITE:
        for i in span:
            if i < len(old) and old[i] != new[i]:
                hits.append(i)
                if len(hits) >= 8:
                    return hits
    return hits


_BRANCH = {"br", "bt", "bf", "bsr", "jmpi"}
_TARGET = re.compile(r"0x([0-9a-f]+)")


def _disassemble(image):
    """(pc, byte_length, mnemonic, operands) in file order."""
    with tempfile.NamedTemporaryFile(suffix=".bin", delete=False) as tmp:
        tmp.write(image)
        path = tmp.name
    try:
        proc = subprocess.run(
            [OBJDUMP, "-b", "binary", "-m", "csky", "-D", path],
            capture_output=True, check=True)
    finally:
        Path(path).unlink(missing_ok=True)
    rows = []
    for ln in proc.stdout.decode("utf-8", "replace").splitlines():
        m = _LINE.match(ln)
        if m:
            rows.append((int(m.group(1), 16), m.group(2), m.group(3)))
    out = []
    for i, (pc, mnem, rest) in enumerate(rows):
        nxt = rows[i + 1][0] if i + 1 < len(rows) else pc + 2
        length = nxt - pc
        if length not in (2, 4):
            length = 4 if len(mnem) > 4 else 2
        out.append((pc, length, mnem, rest))
    return out


def branch_targets(image):
    """(pc, length, target) for a br, bt, bf, bsr or jmpi that names an address.

    `jmpi` through a register has no address and is not returned. The
    mnemonic is matched whole, so `bsr` is not also counted as `br`.
    """
    found = []
    for pc, length, mnem, rest in _disassemble(image):
        if mnem not in _BRANCH:
            continue
        t = _TARGET.search(rest)
        if not t:
            continue
        found.append((pc, length, int(t.group(1), 16)))
    return found


def _overlaps(pc, length, spans):
    for start, end in spans:
        if pc < end and start < pc + length:
            return True
    return False


def _local_branch(image, pc, length):
    """A 16-bit br, bt or bf. The opcode is the second byte: 04, 08, 0c.

    A halfword in a sine table or a literal pool disassembles as one of
    these mnemonics with a different second byte. Those are not branches.
    """
    if length != 2 or pc + 1 >= len(image):
        return False
    return image[pc + 1] in (0x04, 0x08, 0x0C)


def _one_instruction_hook(target, spans):
    """The branch lands on a span that is a single replaced instruction."""
    for start, end in spans:
        if start == target and end - start <= 4:
            return True
    return False


def _real_branch(image, pc, length, mnem):
    """A branch the CPU executes, not a pool halfword objdump calls a branch.

    A 16-bit br/bt/bf has opcode byte 04/08/0c. A 32-bit br starts with
    00 e8 and a 32-bit bsr with 00 e0. The variant-6 call at 0x5C564 is a
    bsr whose first halfword is e3 ff; objdump still names a target inside
    the image, and a 4-byte bsr/br/jmpi with an in-file target is kept.
    """
    if length == 2:
        return pc + 1 < len(image) and image[pc + 1] in (0x04, 0x08, 0x0C)
    if length != 4 or pc + 4 > len(image):
        return False
    if image[pc:pc + 2] in (b"\x00\xe0", b"\x00\xe8"):
        return True
    return mnem in ("br", "bsr", "jmpi")


def changed_branches(old, new, allowed=()):
    """Branches from outside a changed range into it, minus the build's list.

    `allowed` is (pc, target) pairs the build wrote on purpose. A restore
    is a change: FW28 put FW26's bytes back under FW27's callers, and those
    callers are hits. A branch whose own bytes sit in the same span as its
    target was rewritten with that range and is not a hit.
    """
    spans = written_ranges(old, new)
    listed = set(allowed)
    hits = []
    for pc, length, mnem, rest in _disassemble(new):
        if mnem not in _BRANCH:
            continue
        t = _TARGET.search(rest)
        if not t:
            continue
        target = int(t.group(1), 16)
        if target < 0 or target >= len(new):
            continue
        if not _real_branch(new, pc, length, mnem):
            continue
        home = None
        for start, end in spans:
            if start <= target < end:
                home = (start, end)
                break
        if home is None:
            continue
        if _overlaps(pc, length, (home,)):
            continue
        if (pc, target) in listed:
            continue
        hits.append((pc, target))
    return spans, hits


def covered_branches(old, new):
    """Local branches from outside a written span that land inside one.

    The branch is read from the new image. An instruction the patch
    rewrote overlaps a span and is the patch's own redirect, so it is not
    a hit. A 32-bit bsr or jmpi that still names the address it named
    before is a replaced callee, which is how a stub is entered, and is
    not a hit. A span of at most four bytes whose first byte is the
    target is one replaced instruction, the hook pattern, and is not a
    hit. FW27's failure is the other case: `br 0x5B864` and `bt 0x5B848`
    were left unchanged and land in the variant-6 bytes.
    """
    spans = written_ranges(old, new)
    hits = []
    for pc, length, target in branch_targets(new):
        if target < 0 or target >= len(new):
            continue
        if _overlaps(pc, length, spans):
            continue
        if not _inside(target, spans):
            continue
        if length == 4 and old[pc:pc + 4] == new[pc:pc + 4]:
            continue
        if not _local_branch(new, pc, length):
            continue
        if _one_instruction_hook(target, spans):
            continue
        hits.append((pc, target))
    return spans, hits


XIP = 0x0301A000


def _changed_runs(old, new):
    runs = []
    limit = min(len(old), len(new))
    i = 0
    while i < limit:
        if old[i] == new[i]:
            i += 1
            continue
        j = i + 1
        while j < limit and old[j] != new[j]:
            j += 1
        runs.append((i, j))
        i = j
    return runs


def _in_runs(addr, runs):
    for start, end in runs:
        if start <= addr < end:
            return True
        # A pointer at the push, with the body overwritten on the next halfword.
        if addr < start <= addr + 4:
            return True
    return False


def pointed_into(old, new):
    """Words in the old image whose XIP address lands in a changed range.

    Also a movih/ori pair in the new image that builds a 0x0307xxxx address
    landing in a changed range. FW56 fails this: 0x5BDE4, 0x5B3FC, 0x5B4A4.
    """
    import struct
    runs = _changed_runs(old, new)
    hits = []
    limit = min(len(old), len(new)) - 3
    for off in range(0, max(0, limit), 2):
        word = struct.unpack_from("<I", old, off)[0]
        if word < XIP:
            continue
        target = word - XIP
        if _in_runs(target, runs):
            hits.append(off)
    rows = [(pc, mnem, rest) for pc, _length, mnem, rest in _disassemble(new)]
    built = {}
    for pc, mnem, rest in rows:
        reg = _REG.search(rest)
        if not reg:
            continue
        n = int(reg.group(1))
        if mnem == "movih":
            imm = rest.split(",")[-1].strip()
            try:
                built[n] = int(imm, 0) << 16
            except ValueError:
                pass
        elif mnem == "ori" and n in built:
            imm = rest.split(",")[-1].strip()
            try:
                value = built[n] | int(imm, 0)
            except ValueError:
                continue
            if (value & 0xFFFF0000) == 0x03070000 and _in_runs(value - XIP, runs):
                hits.append(pc)
    return hits


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
