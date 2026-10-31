# FW59 is FW57 plus the group All-Call store and the op 6 hold guard.
# F59D only widens opcode 14's window. (B) is not in either image.
import re
import subprocess
import tempfile
import unittest
from pathlib import Path

import fw30_build
import fw58_build
import fw59_build
import literal_guard
import space_map

ROOT = Path(__file__).resolve().parents[2]
OBJDUMP = literal_guard.OBJDUMP
_LINE = re.compile(r"^\s*([0-9a-f]+):\s+\S+\s+(\S+)\s*(.*)$")
_ALLCALL = 0xFFFFFF


def dump(blob, lo, hi):
    with tempfile.NamedTemporaryFile(suffix=".bin", delete=False) as tmp:
        tmp.write(blob)
        path = tmp.name
    try:
        proc = subprocess.run(
            [OBJDUMP, "-b", "binary", "-m", "csky", "-EL", "-D",
             "--start-address=%d" % lo, "--stop-address=%d" % hi, path],
            capture_output=True, check=True)
    finally:
        Path(path).unlink(missing_ok=True)
    return proc.stdout.decode("utf-8", "replace")


def rows_of(blob, lo, hi):
    rows = []
    for line in dump(blob, lo, hi).splitlines():
        match = _LINE.match(line)
        if not match:
            continue
        pc = int(match.group(1), 16)
        if lo <= pc < hi:
            rows.append((pc, match.group(2), match.group(3).split("//")[0].strip()))
    return rows


def _reg(token):
    if not token.startswith("r") or not token[1:].isdigit():
        raise AssertionError(token)
    return int(token[1:])


def _split(rest):
    return [part.strip() for part in rest.replace("(", " ").replace(")", " ").replace(",", " ").split() if part.strip()]


class Machine:
    """The (A') stub only. A store is a word written to 0x4D318."""

    def __init__(self, rows):
        self.rows = rows
        self.index = {pc: i for i, (pc, _m, _r) in enumerate(rows)}

    def run(self, flco, dest, source, slot):
        mem = {}

        def sb(addr, val):
            mem[addr & 0xFFFFFFFF] = val & 0xFF

        def lb(addr):
            return mem.get(addr & 0xFFFFFFFF, 0)

        def sw(addr, val):
            addr &= 0xFFFFFFFF
            for i in range(4):
                sb(addr + i, (val >> (8 * i)) & 0xFF)

        def lw(addr):
            return sum(lb(addr + i) << (8 * i) for i in range(4))

        frame = 0x2000
        sb(frame - 2, flco)
        sw(frame - 20, dest)
        sw(frame - 24, source)
        sb(0x4C7BC + 2, slot)
        for i in range(80):
            sb(0x4D318 + i, 0x11)
        regs = {1: 0, 2: 0, 3: 0, 8: frame, 15: 0xFFFFFFFF}
        original = dict(mem)
        not_equal = False
        step = 0
        stores = []
        i = 0
        while step < 80:
            step += 1
            pc, mnem, rest = self.rows[i]
            nxt = i + 1
            if mnem == "jmp":
                if rest != "r15":
                    raise AssertionError("jmp %s" % rest)
                break
            elif mnem == "subi":
                rd, rs, imm = _split(rest)
                regs[_reg(rd)] = (regs[_reg(rs)] - int(imm)) & 0xFFFFFFFF
            elif mnem == "ld.b":
                rd, rs, imm = _split(rest)
                regs[_reg(rd)] = lb(regs[_reg(rs)] + int(imm, 0))
            elif mnem == "ld.w":
                rd, rs, imm = _split(rest)
                regs[_reg(rd)] = lw(regs[_reg(rs)] + int(imm, 0))
            elif mnem == "andi":
                rd, rs, imm = _split(rest)
                regs[_reg(rd)] = regs[_reg(rs)] & int(imm)
            elif mnem == "bnez":
                rs, target = _split(rest)
                if regs[_reg(rs)] != 0:
                    nxt = self.index[int(target, 16)]
            elif mnem == "bmaski":
                rd, bits = _split(rest)
                regs[_reg(rd)] = (1 << int(bits)) - 1
            elif mnem == "cmpne":
                ra, rb = _split(rest)
                not_equal = regs[_reg(ra)] != regs[_reg(rb)]
            elif mnem == "bt":
                if not_equal:
                    nxt = self.index[int(rest, 16)]
            elif mnem == "zextb":
                rd, rs = _split(rest)
                regs[_reg(rd)] = regs[_reg(rs)] & 0xFF
            elif mnem == "mov":
                rd, rs = _split(rest)
                regs[_reg(rd)] = regs[_reg(rs)]
            elif mnem == "lrw":
                rd, imm = _split(rest)
                regs[_reg(rd)] = int(imm, 16)
            elif mnem == "addi":
                rd, imm = _split(rest)
                regs[_reg(rd)] = (regs[_reg(rd)] + int(imm)) & 0xFFFFFFFF
            elif mnem == "str.w":
                if rest.replace(" ", "") != "r1,(r3,r2<<2)":
                    raise AssertionError(rest)
                addr = (regs[3] + (regs[2] << 2)) & 0xFFFFFFFF
                sw(addr, regs[1])
                stores.append((addr, regs[1] & 0xFFFFFFFF))
            else:
                raise AssertionError("%s %s" % (mnem, rest))
            i = nxt
        else:
            raise AssertionError("did not return")
        if regs[8] != frame:
            raise AssertionError("r8")
        if regs[3] != (frame - 16) & 0xFFFFFFFF:
            raise AssertionError("r3 %X" % regs[3])
        written = {addr for addr, _val in stores}
        for addr, val in mem.items():
            if addr in original and val != original[addr] and addr not in written and not any(addr - n in written for n in range(4)):
                raise AssertionError("side write %X" % addr)
        return stores


class Fw59(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        fw59_build.build()
        fw59_build.build_diag()
        cls.old = fw59_build.SRC.read_bytes()
        cls.new = fw59_build.DEST.read_bytes()
        cls.diag = fw59_build.DIAG.read_bytes()
        lo, hi = fw59_build.CODE["rx_lc_ids"]
        cls.machine = Machine(rows_of(cls.new, lo, hi))

    def test_tag_and_length(self):
        self.assertEqual(self.new[fw59_build.TAG], b"DMR003.FW59.V022")
        self.assertEqual(self.diag[fw59_build.TAG], b"DMR003.F59D.V022")
        self.assertEqual(len(self.new), len(self.old))

    def test_entries_and_the_stock_tail(self):
        sym = fw59_build.SYMBOLS
        self.assertEqual(fw30_build.bsr_target(self.new, 0x26F24), sym["rx_lc_ids"])
        self.assertEqual(fw58_build._br_target(self.new, 0x5B2D2), sym["op6_apply"])
        self.assertEqual(fw58_build._br_target(self.new, 0x5BD36), sym["op6_release"])
        self.assertEqual(self.new[0x26F28:0x26F2C], self.old[0x26F28:0x26F2C])
        self.assertIn("ld.b", dump(self.new, 0x26F28, 0x26F2C))
        for at in fw59_build.UNTOUCHED:
            self.assertEqual(self.new[at:at + 4], self.old[at:at + 4], hex(at))

    def test_group_allcall_stores_both_words(self):
        stores = self.machine.run(0, _ALLCALL, 42, 0)
        self.assertEqual(stores, [
            (0x4D318 + 7 * 4, _ALLCALL),
            (0x4D318 + 9 * 4, 42),
        ])

    def test_other_destinations_do_not_store(self):
        for dest in (0, 9, 99, _ALLCALL - 1, 0x01FFFFFF):
            self.assertEqual(self.machine.run(0, dest, 42, 0), [], hex(dest))

    def test_nonzero_flco_does_not_store(self):
        for flco in (1, 3, 63, 0x41):
            self.assertEqual(self.machine.run(flco, _ALLCALL, 42, 0), [], flco)

    def test_the_mask_and_the_slot(self):
        # 0x40 masked with 63 is still a group call.
        stores = self.machine.run(0x40, _ALLCALL, 7, 1)
        self.assertEqual(stores, [
            (0x4D318 + 8 * 4, _ALLCALL),
            (0x4D318 + 10 * 4, 7),
        ])

    def test_op6_is_the_hold_guard(self):
        text = dump(self.new, fw59_build.CODE["op6_apply"][0], fw59_build.CODE["op6_release"][1])
        for needle in ("0x4b008", "0x484f4c44", "0x30752d6", "0x4b000", "0x11000100", "0x3075d3e"):
            self.assertIn(needle, text)
        self.assertIn("movi", text)
        self.assertIn("128", text)
        self.assertEqual(self.new[0x5B2CC:0x5B2D2], self.old[0x5B2CC:0x5B2D2])
        for at in (0x5B2D6, 0x5BD3E, 0x5B2F4, 0x5B2B6):
            self.assertEqual(self.new[at:at + 4], self.old[at:at + 4], hex(at))
        code = self.new[fw59_build.BASE:fw59_build.TAIL_END]
        for at in (0x11D1C, 0x11D2E, 0x11D84, 0x11D96):
            self.assertNotIn((fw59_build.XIP + at).to_bytes(4, "little"), code)

    def test_only_the_hooks_the_stub_and_the_tag(self):
        changed = {i for i in range(len(self.old)) if self.old[i] != self.new[i]}
        allowed = set(range(fw59_build.TAG.start, fw59_build.TAG.stop))
        allowed |= set(range(fw59_build.BASE, fw59_build.TAIL_END))
        for _name, site, _kind in fw59_build.HOOKS:
            allowed |= set(range(site, site + 4))
        self.assertTrue(changed <= allowed)
        for _name, site, _kind in fw59_build.HOOKS:
            self.assertNotEqual(self.old[site:site + 4], self.new[site:site + 4])
        self.assertNotIn(0xC1BA, changed)
        self.assertNotIn(0xC244, changed)
        tail = [i for i in changed if i >= fw59_build.BASE]
        self.assertLess(max(tail), 0x5C634)

    def test_guards(self):
        tagged = bytearray(self.new)
        tagged[fw59_build.TAG] = self.old[fw59_build.TAG]
        body = bytes(tagged)
        self.assertEqual(literal_guard.covered_loads(self.old, body)[1], [])
        self.assertEqual(literal_guard.covered_branches(self.old, body)[1], [])
        self.assertEqual(literal_guard.never_written(self.old, body), [])
        self.assertEqual(literal_guard.pointed_into(self.old, body), [])
        self.assertEqual(space_map.outside_free(self.old, body), [])

    def test_retarget_windows(self):
        for window in ((0x26F24, 0x26F28), (0x5B2D2, 0x5B2D6), (0x5BD36, 0x5BD3A)):
            self.assertIn(window, space_map.RETARGET)


class F59D(unittest.TestCase):
    def test_window(self):
        diag = fw59_build.DIAG.read_bytes()
        fw = fw59_build.DEST.read_bytes()
        self.assertEqual(diag[fw59_build.WIN_LO:fw59_build.WIN_LO + 4], fw59_build.WIN_NEW[0])
        self.assertEqual(diag[fw59_build.WIN_HI:fw59_build.WIN_HI + 4], fw59_build.WIN_NEW[1])
        changed = {i for i in range(len(fw)) if fw[i] != diag[i]}
        allowed = set(range(0x38464, 0x38474))
        allowed |= set(range(fw59_build.WIN_LO, fw59_build.WIN_LO + 4))
        allowed |= set(range(fw59_build.WIN_HI, fw59_build.WIN_HI + 4))
        self.assertTrue(changed <= allowed)
        self.assertTrue(changed)


if __name__ == "__main__":
    unittest.main()
