# FW60 is FW57 plus the op 6 hold guard and the live-slot All-Call unmute.
# F60D only widens opcode 14's window. (A) and (A') are not in either image.
import re
import subprocess
import tempfile
import unittest
from pathlib import Path

import fw30_build
import fw58_build
import fw60_build
import literal_guard
import space_map

ROOT = Path(__file__).resolve().parents[2]
OBJDUMP = literal_guard.OBJDUMP
_LINE = re.compile(r"^\s*([0-9a-f]+):\s+\S+\s+(\S+)\s*(.*)$")
_ALLCALL = 0xFFFFFF
_UNMUTE = {0x11D1C: 0x0302BD1C, 0x11D84: 0x0302BD84}
_MUTE = {0x11D2E: 0x0302BD2E, 0x11D96: 0x0302BD96}


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


def _target(rest):
    return int(rest.split()[0].split("<")[0], 16)


class Machine:
    """The (D) stub. Returns the XIP address it jumps to."""

    def __init__(self, rows):
        self.rows = rows
        self.index = {pc: i for i, (pc, _m, _r) in enumerate(rows)}

    def run(self, r3, word, slot):
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

        for i in range(80):
            sb(0x4D318 + i, 0x11)
        sb(0x4C7BC + 2, slot)
        sw(0x4D318 + (slot + 7) * 4, word)
        regs = {2: 0, 3: r3 & 0xFFFFFFFF, 8: 0x1111, 15: 0xFFFFFFFF}
        cond = False
        step = 0
        i = 0
        while step < 80:
            step += 1
            _pc, mnem, rest = self.rows[i]
            nxt = i + 1
            if mnem == "jmp":
                if _reg(rest) == 8:
                    raise AssertionError("jmp r8")
                got = regs[_reg(rest)]
                if regs[8] != 0x1111 or regs[15] != 0xFFFFFFFF:
                    raise AssertionError("r8")
                return got
            elif mnem == "cmpnei":
                rd, imm = _split(rest)
                cond = regs[_reg(rd)] != (int(imm, 0) & 0xFFFFFFFF)
            elif mnem == "bf":
                if not cond:
                    nxt = self.index[_target(rest)]
            elif mnem == "bt":
                if cond:
                    nxt = self.index[_target(rest)]
            elif mnem == "cmpne":
                ra, rb = _split(rest)
                cond = regs[_reg(ra)] != regs[_reg(rb)]
            elif mnem == "lrw":
                rd, imm = _split(rest)
                regs[_reg(rd)] = int(imm, 16)
            elif mnem == "ld.b":
                rd, rs, imm = _split(rest)
                regs[_reg(rd)] = lb(regs[_reg(rs)] + int(imm, 0))
            elif mnem == "zextb":
                rd, rs = _split(rest)
                regs[_reg(rd)] = regs[_reg(rs)] & 0xFF
            elif mnem == "mov":
                rd, rs = _split(rest)
                regs[_reg(rd)] = regs[_reg(rs)]
            elif mnem == "addi":
                parts = _split(rest)
                if len(parts) == 2:
                    rd, imm = parts
                    regs[_reg(rd)] = (regs[_reg(rd)] + int(imm, 0)) & 0xFFFFFFFF
                else:
                    rd, rs, imm = parts
                    regs[_reg(rd)] = (regs[_reg(rs)] + int(imm, 0)) & 0xFFFFFFFF
            elif mnem == "ldr.w":
                if "<<" not in rest:
                    raise AssertionError(rest)
                rd, rb, ri, sh = _split(rest.replace("<<", " "))
                addr = (regs[_reg(rb)] + (regs[_reg(ri)] << int(sh))) & 0xFFFFFFFF
                regs[_reg(rd)] = lw(addr)
            elif mnem == "bmaski":
                rd, bits = _split(rest)
                regs[_reg(rd)] = (1 << int(bits)) - 1
            else:
                raise AssertionError("%s %s" % (mnem, rest))
            i = nxt
        raise AssertionError("did not jump")


class Fw60(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        fw60_build.build()
        fw60_build.build_diag()
        cls.old = fw60_build.SRC.read_bytes()
        cls.new = fw60_build.DEST.read_bytes()
        cls.diag = fw60_build.DIAG.read_bytes()
        cls.machines = {}
        for name in ("allcall_3", "allcall_2"):
            lo, hi = fw60_build.CODE[name]
            cls.machines[name] = Machine(rows_of(cls.new, lo, hi))

    def test_tag_and_length(self):
        self.assertEqual(self.new[fw60_build.TAG], b"DMR003.FW60.V022")
        self.assertEqual(self.diag[fw60_build.TAG], b"DMR003.F60D.V022")
        self.assertEqual(len(self.new), len(self.old))

    def test_entries_and_the_stock_sites(self):
        sym = fw60_build.SYMBOLS
        self.assertEqual(sym["allcall_3"], 0x5C634)
        self.assertGreater(sym["allcall_2"], sym["allcall_3"])
        self.assertEqual(sym["op6_apply"], 0x5C59C)
        self.assertLess(fw60_build.SPAN[1], 0x5C6BC)
        self.assertEqual(fw30_build.bsr_target(self.new, 0x11D18), sym["allcall_3"])
        self.assertEqual(fw30_build.bsr_target(self.new, 0x11D80), sym["allcall_2"])
        self.assertEqual(fw58_build._br_target(self.new, 0x5B2D2), sym["op6_apply"])
        self.assertEqual(fw58_build._br_target(self.new, 0x5BD36), sym["op6_release"])
        self.assertEqual(self.new[0x26F24:0x26F28], self.old[0x26F24:0x26F28])
        self.assertEqual(self.new[0x26F24:0x26F28], fw58_build.SUBI_R3_R8_16)
        for at in fw60_build.EXITS:
            self.assertEqual(self.new[at:at + 4], self.old[at:at + 4], hex(at))

    def test_r3_zero_unmutes(self):
        for name, site in (("allcall_3", 0x11D1C), ("allcall_2", 0x11D84)):
            self.assertEqual(self.machines[name].run(0, 9, 0), _UNMUTE[site], name)

    def test_allcall_word_unmutes(self):
        for name, site in (("allcall_3", 0x11D1C), ("allcall_2", 0x11D84)):
            self.assertEqual(self.machines[name].run(1, _ALLCALL, 0), _UNMUTE[site], name)
            self.assertEqual(self.machines[name].run(1, _ALLCALL, 1), _UNMUTE[site], name)

    def test_other_words_mute(self):
        for word in (9, 99, 0, _ALLCALL - 1):
            for name, site in (("allcall_3", 0x11D2E), ("allcall_2", 0x11D96)):
                self.assertEqual(self.machines[name].run(1, word, 0), _MUTE[site], (name, word))

    def test_op6_is_the_hold_guard(self):
        text = dump(self.new, fw60_build.CODE["op6_apply"][0], fw60_build.CODE["op6_release"][1])
        for needle in ("0x4b008", "0x484f4c44", "0x30752d6", "0x4b000", "0x11000100", "0x3075d3e"):
            self.assertIn(needle, text)
        self.assertIn("movi", text)
        self.assertIn("128", text)
        self.assertEqual(self.new[0x5B2CC:0x5B2D2], self.old[0x5B2CC:0x5B2D2])
        for at in (0x5B2D6, 0x5BD3E, 0x5B2F4, 0x5B2B6):
            self.assertEqual(self.new[at:at + 4], self.old[at:at + 4], hex(at))

    def test_only_the_hooks_the_stub_and_the_tag(self):
        changed = {i for i in range(len(self.old)) if self.old[i] != self.new[i]}
        allowed = set(range(fw60_build.TAG.start, fw60_build.TAG.stop))
        allowed |= set(range(fw60_build.SPAN[0], fw60_build.SPAN[1]))
        for _name, site, _kind in fw60_build.HOOKS:
            allowed |= set(range(site, site + 4))
        self.assertTrue(changed <= allowed)
        for _name, site, _kind in fw60_build.HOOKS:
            self.assertNotEqual(self.old[site:site + 4], self.new[site:site + 4])
        self.assertNotEqual(self.old[0x5C62E:0x5C630], self.new[0x5C62E:0x5C630])
        self.assertEqual(self.new[0x5C6BC:0x5C6C0], self.old[0x5C6BC:0x5C6C0])
        tail = [i for i in changed if i >= fw60_build.C_BASE]
        self.assertGreaterEqual(min(tail), fw60_build.C_BASE)
        self.assertLess(max(tail), 0x5C6BC)

    def test_guards(self):
        tagged = bytearray(self.new)
        tagged[fw60_build.TAG] = self.old[fw60_build.TAG]
        body = bytes(tagged)
        self.assertEqual(literal_guard.covered_loads(self.old, body)[1], [])
        self.assertEqual(literal_guard.covered_branches(self.old, body)[1], [])
        self.assertEqual(literal_guard.never_written(self.old, body), [])
        self.assertEqual(literal_guard.pointed_into(self.old, body), [])
        self.assertEqual(space_map.outside_free(self.old, body), [])

    def test_retarget_windows(self):
        for window in ((0x11D18, 0x11D1C), (0x11D80, 0x11D84), (0x5B2D2, 0x5B2D6), (0x5BD36, 0x5BD3A)):
            self.assertIn(window, space_map.RETARGET)


class F60D(unittest.TestCase):
    def test_window(self):
        diag = fw60_build.DIAG.read_bytes()
        fw = fw60_build.DEST.read_bytes()
        self.assertEqual(diag[fw58_build.WIN_LO:fw58_build.WIN_LO + 4], fw58_build.WIN_NEW[0])
        self.assertEqual(diag[fw58_build.WIN_HI:fw58_build.WIN_HI + 4], fw58_build.WIN_NEW[1])
        changed = {i for i in range(len(fw)) if fw[i] != diag[i]}
        allowed = set(range(0x38464, 0x38474))
        allowed |= set(range(fw58_build.WIN_LO, fw58_build.WIN_LO + 4))
        allowed |= set(range(fw58_build.WIN_HI, fw58_build.WIN_HI + 4))
        self.assertTrue(changed <= allowed)
        self.assertTrue(changed)


if __name__ == "__main__":
    unittest.main()
