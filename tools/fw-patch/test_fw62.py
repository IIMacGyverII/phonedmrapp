# FW62 group-match hook against the FW57 function it patches.
# Flag 0 and 1, argument 0 and 1, hit and miss, and the +0x2A arm.
# Nothing here keys the radio.
import unittest

import fw30_build
import fw61_build
import fw62_build
import literal_guard
import space_map
import test_f62e

XIP = fw62_build.XIP
FN = 0x27EA8
FN_END = 0x27F72
SENTINEL = 0x00ABCDEF
BASE = 0x34808
LIST = 0x31B48
OWN = 0x1234
FLAG = 0x4B364
SP = 0x7000


class Cpu(test_f62e.Cpu):
    def run(self, pc, span):
        self.pc = pc
        self.steps = 0
        while self.pc in span:
            self.steps += 1
            if self.steps > 4000:
                raise AssertionError("ran too long at %X" % self.pc)
            if self.pc not in self.ins:
                break
            mnem, rest, _addr = self.ins[self.pc]
            fall = self.nxt.get(self.pc, self.pc + 2)
            self.one(mnem, rest, fall)
        return self.pc

    def one(self, mnem, rest, fall):
        if mnem == "mov":
            dest, src = [p.strip() for p in rest.split(",")]
            self.r[test_f62e.parse_reg(dest)] = self.r[test_f62e.parse_reg(src)]
            self.pc = fall
            return
        if mnem == "zextb":
            dest, src = [p.strip() for p in rest.split(",")]
            self.r[test_f62e.parse_reg(dest)] = self.r[test_f62e.parse_reg(src)] & 0xFF
            self.pc = fall
            return
        if mnem == "lsli":
            dest, src, imm = [p.strip() for p in rest.split(",")]
            self.r[test_f62e.parse_reg(dest)] = (
                self.r[test_f62e.parse_reg(src)] << int(imm, 0)) & 0xFFFFFFFF
            self.pc = fall
            return
        if mnem == "cmphs":
            a, b = [p.strip() for p in rest.split(",")]
            self.set_c((self.r[test_f62e.parse_reg(a)] & 0xFFFFFFFF)
                       >= (self.r[test_f62e.parse_reg(b)] & 0xFFFFFFFF))
            self.pc = fall
            return
        if mnem == "or":
            dest, src = [p.strip() for p in rest.split(",")]
            self.r[test_f62e.parse_reg(dest)] |= self.r[test_f62e.parse_reg(src)]
            self.r[test_f62e.parse_reg(dest)] &= 0xFFFFFFFF
            self.pc = fall
            return
        if mnem == "subi":
            parts = [p.strip() for p in rest.split(",")]
            if len(parts) == 3 and test_f62e.parse_reg(parts[0]) != 14:
                self.r[test_f62e.parse_reg(parts[0])] = (
                    self.r[test_f62e.parse_reg(parts[1])] - int(parts[2], 0)) & 0xFFFFFFFF
                self.pc = fall
                return
        test_f62e.Cpu.one(self, mnem, rest, fall)


def _store(mem, addr, value, n=4):
    for i in range(n):
        mem[addr + i] = (value >> (8 * i)) & 0xFF


def memory(flag, byte_2a):
    mem = {}
    _store(mem, BASE + 0x34, OWN)
    _store(mem, BASE + 0x38, LIST)
    mem[BASE + 0x2A] = byte_2a
    mem[FLAG] = flag
    words = [1] * 32
    words[0] = 9
    words[3] = 99
    words.append(0)
    for n, word in enumerate(words):
        _store(mem, LIST + n * 4, word)
    return mem


def call(cpu_ins, cpu_nxt, image_len, flag, arg, ident, byte_2a):
    regs = [0] * 16
    regs[0] = arg
    regs[1] = ident
    regs[8] = 0x11111111
    regs[14] = SP
    regs[15] = SENTINEL
    span = set(range(FN, FN_END))
    span |= set(range(fw62_build.STUB, fw62_build.STUB + 0x40))
    span.add(0x17C4)
    span.add(0x17C6)
    cpu = Cpu(cpu_ins, cpu_nxt, regs, 0, memory(flag, byte_2a))
    left = cpu.run(FN, span)
    if left != SENTINEL:
        raise AssertionError("left at %X after %d" % (left, cpu.steps))
    if cpu.r[14] != SP or cpu.r[8] != 0x11111111:
        raise AssertionError("frame sp %X r8 %X" % (cpu.r[14], cpu.r[8]))
    if cpu.r[0] not in (0, 1):
        raise AssertionError("return %X" % cpu.r[0])
    return cpu.r[0]


class Fw62(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        fw62_build.build()
        fw62_build.build_f62p()
        cls.old = fw62_build.SRC.read_bytes()
        cls.new = fw62_build.DEST.read_bytes()
        cls.diag = fw62_build.DIAG.read_bytes()
        cls.guard = fw62_build.GUARD.read_bytes()
        cls.stock, cls.stock_n = test_f62e.disasm(cls.old)
        cls.hook, cls.hook_n = test_f62e.disasm(cls.new)

    def test_tag_guard_and_the_hook(self):
        self.assertEqual(self.new[fw62_build.TAG], b"DMR003.FW62.V022")
        self.assertEqual(len(self.new), len(self.old))
        self.assertEqual(self.new[fw61_build.CODE_LO:fw61_build.CODE_HI],
                         self.guard[fw61_build.CODE_LO:fw61_build.CODE_HI])
        self.assertEqual(self.new[fw61_build.POOL_LO:fw61_build.POOL_HI],
                         self.guard[fw61_build.POOL_LO:fw61_build.POOL_HI])
        self.assertEqual(fw58_target(self.new, 0x5B2D2), fw61_build.APPLY)
        self.assertEqual(fw30_build.bsr_target(self.new, fw62_build.HOOK), fw62_build.STUB)
        self.assertEqual(self.new[fw62_build.LITERAL:fw62_build.LITERAL + 4],
                         self.old[fw62_build.LITERAL:fw62_build.LITERAL + 4])
        self.assertEqual(self.new[0x5C59C:fw61_build.CODE_LO],
                         self.old[0x5C59C:fw61_build.CODE_LO])

    def test_only_the_guard_the_stub_the_hook_and_the_tag(self):
        changed = {i for i in range(len(self.old)) if self.old[i] != self.new[i]}
        allowed = set(range(fw62_build.TAG.start, fw62_build.TAG.stop))
        allowed |= set(range(fw61_build.CODE_LO, fw61_build.CODE_HI))
        allowed |= set(range(fw61_build.POOL_LO, fw61_build.POOL_HI))
        allowed |= set(range(fw62_build.HOOK, fw62_build.HOOK + 4))
        allowed |= set(range(fw62_build.STUB, fw62_build.LITERAL))
        for site, _target in fw61_build.HOOKS:
            allowed |= set(range(site, site + 4))
        self.assertTrue(changed <= allowed)
        self.assertTrue(fw62_build.HOOK in changed)

    def test_diag_is_the_window(self):
        self.assertEqual(self.diag[fw62_build.TAG], b"DMR003.F62P.V022")
        self.assertEqual(self.diag[fw62_build.WIN_LO:fw62_build.WIN_LO + 4], fw62_build.WIN_NEW[0])
        self.assertEqual(self.diag[fw62_build.WIN_HI:fw62_build.WIN_HI + 4], fw62_build.WIN_NEW[1])
        changed = {i for i in range(len(self.new)) if self.new[i] != self.diag[i]}
        allowed = set(range(fw62_build.TAG.start, fw62_build.TAG.stop))
        allowed |= set(range(fw62_build.WIN_LO, fw62_build.WIN_LO + 4))
        allowed |= set(range(fw62_build.WIN_HI, fw62_build.WIN_HI + 4))
        self.assertTrue(changed)
        self.assertTrue(changed <= allowed)

    def test_guards(self):
        self.assertEqual(literal_guard.covered_loads(self.old, self.new)[1], [])
        self.assertEqual(literal_guard.covered_branches(self.old, self.new)[1], [])
        self.assertEqual(literal_guard.never_written(self.old, self.new), [])
        self.assertEqual(literal_guard.pointed_into(self.old, self.new), [])
        self.assertEqual(space_map.outside_free(self.old, self.new), [])
        windows = (range(fw62_build.WIN_LO, fw62_build.WIN_LO + 4),
                   range(fw62_build.WIN_HI, fw62_build.WIN_HI + 4))
        bad = space_map.outside_free(self.old, self.diag)
        extra = [span for span in bad
                 if not any(w.start <= span[0] and span[1] <= w.stop for w in windows)]
        self.assertEqual(extra, [])
        self.assertEqual(literal_guard.covered_loads(self.old, self.diag)[1], [])
        self.assertEqual(literal_guard.covered_branches(self.old, self.diag)[1], [])

    def test_match(self):
        # flag, arg, id, byte at +0x2A, stock return, patched return
        rows = []
        for flag in (0, 1):
            for arg, hit_id, miss_id in ((0, OWN, 99), (1, 99, 77)):
                for hit in (True, False):
                    ident = hit_id if hit else miss_id
                    rows.append((flag, arg, ident, 0))
        rows.append((0, 1, 77, 1))
        rows.append((1, 0, 99, 1))
        for flag, arg, ident, byte_2a in rows:
            stock = call(self.stock, self.stock_n, len(self.old), flag, arg, ident, byte_2a)
            patched = call(self.hook, self.hook_n, len(self.new), flag, arg, ident, byte_2a)
            if byte_2a:
                self.assertEqual(stock, 0, (flag, arg, ident))
                self.assertEqual(patched, 0, (flag, arg, ident))
                continue
            if flag == 0 or arg == 0:
                self.assertEqual(patched, stock, (flag, arg, ident, stock))
            else:
                self.assertEqual(patched, 0, (flag, arg, ident, stock))
            if flag == 0 and arg == 0:
                self.assertEqual(stock, 0 if ident == OWN else 1)
            if flag == 0 and arg == 1:
                self.assertEqual(stock, 0 if ident == 99 else 1)


def fw58_target(blob, at):
    import fw58_build
    return fw58_build._br_target(blob, at)


if __name__ == "__main__":
    unittest.main()
