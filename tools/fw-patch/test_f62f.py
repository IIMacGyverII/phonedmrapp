# Each F62F hook against the FW57 instructions it replaced.
# Both branch outcomes. Next PC, r0-r14, C, SP, and memory must match.
# One counter byte may be one higher. Nothing here keys the radio.
import unittest

import f62f_build
import test_f62e

disasm = test_f62e.disasm
parse_reg = test_f62e.parse_reg


class Cpu(test_f62e.Cpu):
    def one(self, mnem, rest, fall):
        if mnem == "mov":
            dest, src = rest.split(",")
            self.r[parse_reg(dest)] = self.r[parse_reg(src)]
            self.pc = fall
            return
        test_f62e.Cpu.one(self, mnem, rest, fall)


def fresh(c):
    regs, bit, mem = test_f62e.fresh(c)
    for i in range(13):
        mem[f62f_build.BASE + i] = 0
    return regs, bit, mem


SITES = test_f62e.SITES + (
    (0xC09E, 4, 4, ((5, 7, 9, 1, "head"), (1, 2, 3, 0, "head-c"))),
    (0xC0B0, 4, 4, ((1, 0, 4, 1, "bit0"), (1, 0, 0, 0, "bit0-clear"))),
    (0xC0B8, 4, 4, ((1, 2, 0, 1, "bit1"), (1, 0, 3, 0, "bit1-clear"))),
    (0xC0C0, 4, 4, ((1, 0, 4, 0, "bit2"), (1, 0, 0, 1, "bit2-clear"))),
)


class F62F(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        f62f_build.build()
        cls.fw57 = f62f_build.SRC.read_bytes()
        cls.img = f62f_build.DEST.read_bytes()
        cls.stock, cls.stock_n = disasm(cls.fw57)
        cls.hook, cls.hook_n = disasm(cls.img)

    def test_literal_tag_and_jumps(self):
        self.assertEqual(self.img[0x38464:0x38474], b"DMR003.F62F.V022")
        self.assertEqual(self.img[0x5C6BC:0x5C6C0], self.fw57[0x5C6BC:0x5C6C0])
        self.assertEqual(self.img[0x5C0CE:0x5C0D2], bytes.fromhex("21ea0300"))
        for addr in (f62f_build.LOOP, f62f_build.DROP, f62f_build.OTHER,
                     f62f_build.START, f62f_build.EARLY[0][1],
                     f62f_build.EARLY[1][1], f62f_build.EARLY[2][1]):
            self.assertIn(addr.to_bytes(4, "little"), self.img)

    def test_each_site_matches_fw57(self):
        body = (set(range(f62f_build.STUB, f62f_build.LITERAL))
                | set(range(f62f_build.TAIL, f62f_build.TAIL_END)))
        for site, hook_len, orig_len, cases in SITES:
            span = set(range(site, site + orig_len))
            hook_span = body | set(range(site, site + hook_len))
            for r0, r2, r3, c, note in cases:
                with self.subTest(site=hex(site), note=note):
                    self.compare(site, span, hook_span, r0, r2, r3, c)

    def compare(self, site, span, hook_span, r0, r2, r3, c):
        left = self.execute(self.stock, self.stock_n, site, span, r0, r2, r3, c)
        right = self.execute(self.hook, self.hook_n, site, hook_span, r0, r2, r3, c)
        self.assertEqual(right["pc"], left["pc"], "pc")
        self.assertEqual(right["c"], left["c"], "c")
        self.assertEqual(right["sp"], left["sp"], "sp")
        # The counter holds its index in r12. The receive function writes
        # r12 at 0xC2E6 before it reads r12, so the index is dead there.
        right["regs"][12] = left["regs"][12]
        self.assertEqual(right["regs"], left["regs"], "regs")
        ignore = set(range(f62f_build.BASE, f62f_build.BASE + 13))
        keys = set(left["mem"]) | set(right["mem"])
        for addr in keys:
            if addr in ignore or addr < left["sp"]:
                continue
            self.assertEqual(right["mem"].get(addr, 0), left["mem"].get(addr, 0), hex(addr))
        delta = sum(right["mem"].get(f62f_build.BASE + i, 0) for i in range(13))
        self.assertIn(delta, (0, 1))

    def execute(self, ins, nxt, site, span, r0, r2, r3, c):
        regs, bit, mem = fresh(c)
        regs[0] = r0
        regs[2] = r2
        regs[3] = r3
        cpu = Cpu(ins, nxt, regs, bit, mem)
        pc = cpu.run(site, span)
        return {
            "pc": pc,
            "c": cpu.cbit(),
            "sp": cpu.r[14],
            "regs": cpu.r[:14],
            "mem": cpu.mem,
        }


if __name__ == "__main__":
    unittest.main()
