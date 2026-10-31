# Each F62E hook against the FW57 instructions it replaced.
# Both branch outcomes. Next PC, r0-r14, C, SP, and memory must match.
# The counter byte may be one higher. r15 is the hook's link register.
# Nothing here keys the radio.
import re
import subprocess
import unittest
from pathlib import Path

import fw30_build
import f62d_build
import f62e_build

OBJDUMP = Path(r"C:\Users\Joshua\tools\csky-elfabiv2\bin\csky-elfabiv2-objdump.exe")
XIP = f62e_build.XIP
GETTER = f62e_build.GETTER
LINE = re.compile(r"^\s+([0-9a-f]+):\t[0-9a-f ]+\t(\S+)\s*(.*)$")
REG = {"r%d" % i: i for i in range(16)}


def disasm(blob):
    path = Path(r"C:\Users\Joshua\AppData\Local\Temp\fw1718\fw30\emu.bin")
    path.write_bytes(blob)
    text = subprocess.check_output(
        [str(OBJDUMP), "-b", "binary", "-m", "csky", "-D", str(path)],
        text=True, errors="replace")
    ins = {}
    order = []
    for line in text.splitlines():
        m = LINE.match(line)
        if not m:
            continue
        addr = int(m.group(1), 16)
        mnem = m.group(2)
        rest = m.group(3).split("//")[0].strip().rstrip(",")
        ins[addr] = (mnem, rest, addr)
        order.append(addr)
    nxt = {}
    for i, addr in enumerate(order):
        if i + 1 < len(order):
            nxt[addr] = order[i + 1]
    return ins, nxt


def parse_reg(text):
    text = text.strip()
    if text not in REG:
        raise AssertionError("reg %s" % text)
    return REG[text]


class Cpu(object):
    def __init__(self, ins, nxt, regs, c, mem):
        self.ins = ins
        self.nxt = nxt
        self.r = list(regs)
        self.psr = 0x80000100 | (1 if c else 0)
        self.mem = dict(mem)
        self.pc = 0
        self.steps = 0

    def cbit(self):
        return self.psr & 1

    def set_c(self, bit):
        self.psr = (self.psr & ~1) | (1 if bit else 0)

    def ld(self, addr, n):
        return sum(self.mem.get(addr + i, 0) << (8 * i) for i in range(n))

    def st(self, addr, n, value):
        for i in range(n):
            self.mem[addr + i] = (value >> (8 * i)) & 0xFF

    def run(self, pc, span):
        """Execute while pc stays inside span. Return the pc that left it."""
        self.pc = pc
        while self.pc in span:
            self.steps += 1
            if self.steps > 400:
                raise AssertionError("ran too long at %X" % self.pc)
            if self.pc not in self.ins:
                break
            mnem, rest, addr = self.ins[self.pc]
            fall = self.nxt.get(self.pc, self.pc + 2)
            self.one(mnem, rest, fall)
        return self.pc

    def one(self, mnem, rest, fall):
        if mnem == "bez":
            reg, dest = rest.split(",")
            self.pc = int(dest, 16) if self.r[parse_reg(reg)] == 0 else fall
            return
        if mnem == "bnez":
            reg, dest = rest.split(",")
            self.pc = int(dest, 16) if self.r[parse_reg(reg)] != 0 else fall
            return
        if mnem == "bt":
            self.pc = int(rest, 16) if self.cbit() else fall
            return
        if mnem == "bf":
            self.pc = int(rest, 16) if not self.cbit() else fall
            return
        if mnem == "br":
            self.pc = int(rest, 16)
            return
        if mnem == "jmp":
            self.pc = self.r[parse_reg(rest)]
            if self.pc >= XIP:
                self.pc -= XIP
            return
        if mnem == "bsr":
            dest = int(rest, 16)
            ret = XIP + fall
            self.r[15] = ret
            if dest == GETTER:
                self.getter()
                self.pc = fall
                return
            self.pc = dest
            return
        if mnem == "cmpnei":
            reg, imm = rest.split(",")
            self.set_c(self.r[parse_reg(reg)] != int(imm, 0))
            self.pc = fall
            return
        if mnem == "cmpne":
            a, b = rest.split(",")
            self.set_c(self.r[parse_reg(a)] != self.r[parse_reg(b)])
            self.pc = fall
            return
        if mnem == "movi":
            reg, imm = rest.split(",")
            self.r[parse_reg(reg)] = int(imm, 0) & 0xFFFFFFFF
            self.pc = fall
            return
        if mnem == "addi":
            parts = [p.strip() for p in rest.split(",")]
            dest = parts[0]
            imm = int(parts[-1], 0)
            src = parts[-2]
            base = self.r[parse_reg(src)]
            total = base + imm
            if dest != "r14":
                self.set_c(1 if total > 0xFFFFFFFF else 0)
            self.r[parse_reg(dest)] = total & 0xFFFFFFFF
            self.pc = fall
            return
        if mnem == "subi" and "r14" in rest.split(",")[0]:
            imm = int(rest.split(",")[-1], 0)
            self.r[14] = (self.r[14] - imm) & 0xFFFFFFFF
            self.pc = fall
            return
        if mnem == "addu":
            parts = [p.strip() for p in rest.split(",")]
            dest, src = parts[0], parts[-1]
            other = parts[-2] if len(parts) == 3 else parts[0]
            self.r[parse_reg(dest)] = (self.r[parse_reg(other)] + self.r[parse_reg(src)]) & 0xFFFFFFFF
            self.pc = fall
            return
        if mnem == "lrw":
            reg, imm = rest.split(",")
            self.r[parse_reg(reg)] = int(imm, 16) & 0xFFFFFFFF
            self.pc = fall
            return
        if mnem == "mfcr":
            reg = rest.split(",")[0].strip()
            self.r[parse_reg(reg)] = self.psr
            self.pc = fall
            return
        if mnem == "mtcr":
            reg = rest.split(",")[0].strip()
            self.psr = self.r[parse_reg(reg)] & 0xFFFFFFFF
            self.pc = fall
            return
        if mnem == "push" and rest.strip() == "r15":
            self.r[14] = (self.r[14] - 4) & 0xFFFFFFFF
            self.st(self.r[14], 4, self.r[15])
            self.pc = fall
            return
        if mnem == "pop" and rest.strip() == "r15":
            self.r[15] = self.ld(self.r[14], 4)
            self.r[14] = (self.r[14] + 4) & 0xFFFFFFFF
            self.pc = self.r[15] - XIP if self.r[15] >= XIP else self.r[15]
            return
        # The load/store forms have a comma inside the parenthesis.
        self.memop(mnem, rest, fall)

    def memop(self, mnem, rest, fall):
        # "r1, (r6, 0)" or "r10, (r4, 4)"
        reg, loc = rest.split(",", 1)
        loc = loc.strip().lstrip("(").rstrip(")")
        base, off = [p.strip() for p in loc.split(",")]
        addr = (self.r[parse_reg(base)] + int(off, 0)) & 0xFFFFFFFF
        n = 4 if mnem.endswith("w") else 1
        if mnem.startswith("ld"):
            self.r[parse_reg(reg)] = self.ld(addr, n)
        elif mnem.startswith("st"):
            self.st(addr, n, self.r[parse_reg(reg)])
        else:
            raise AssertionError("op " + mnem + " " + rest)
        self.pc = fall

    def getter(self):
        self.r[0] = 0x41
        self.r[1] = 0x42
        self.r[2] = 0x43
        self.r[3] = 0x44
        self.r[12] = 0x45
        self.r[13] = 0x46
        self.set_c(1)


def fresh(c):
    regs = [0x1000 + i * 0x111 for i in range(16)]
    regs[14] = 0x5000
    regs[15] = 0x22222222
    regs[6] = 0x3000
    regs[4] = 0x3100
    regs[10] = 0x5A
    mem = {0x3000: 0xAB}
    for i in range(9):
        mem[f62e_build.BASE + i] = 0
    return regs, c, mem


SITES = (
    # file, hook bytes, original run length, cases (r0, r2, r3, c, note)
    (0xC0C8, 4, 4, ((0, 1, 1, 1, "taken"), (5, 1, 1, 0, "fall"))),
    (0xC12C, 4, 4, ((1, 1, 0, 1, "fall"), (1, 1, 4, 0, "taken"))),
    (0xC14A, 4, 4, ((1, 1, 0, 1, "taken"), (1, 1, 3, 0, "fall"))),
    (0xC15E, 4, 4, ((1, 1, 0, 0, "c0"), (1, 1, 104, 1, "c1"))),
    (0xC168, 4, 4, ((1, 1, 0, 1, "fall"), (1, 1, 2, 0, "taken"))),
    (0xC1A8, 4, 4, ((1, 1, 1, 1, "equal"), (1, 1, 2, 0, "other"))),
    (0xC1B6, 4, 4, ((1, 9, 9, 1, "equal"), (1, 9, 8, 0, "differ"))),
    (0xC1BA, 4, 4, ((7, 2, 3, 0, "getter"), (7, 2, 3, 1, "getter-c"))),
    (0xC244, 4, 4, ((7, 2, 3, 0, "getter"), (7, 2, 3, 1, "getter-c"))),
    # The store and the branch to the loop sit in the next 6 bytes.
    (0xC276, 4, 10, ((1, 8, 0, 1, "store"), (1, 8, 3, 0, "skip"))),
)


class F62E(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        f62e_build.build()
        cls.fw57 = f62e_build.SRC.read_bytes()
        cls.img = f62e_build.DEST.read_bytes()
        cls.stock, cls.stock_n = disasm(cls.fw57)
        cls.hook, cls.hook_n = disasm(cls.img)

    def test_tag_window_and_jumps(self):
        self.assertEqual(self.img[0x38464:0x38474], b"DMR003.F62E.V022")
        self.assertEqual(self.img[0x5C0CE:0x5C0D2], bytes.fromhex("21ea0300"))
        blob = self.img
        for addr in (f62e_build.LOOP, f62e_build.DROP, f62e_build.OTHER, f62e_build.START):
            self.assertIn(addr.to_bytes(4, "little"), blob[f62e_build.STUB:f62e_build.STUB_END])
        self.assertNotIn((0x03026C9E).to_bytes(4, "little"), blob[f62e_build.STUB:f62e_build.STUB_END])

    def test_each_site_matches_fw57(self):
        for site, hook_len, orig_len, cases in SITES:
            span = set(range(site, site + orig_len))
            hook_span = set(range(f62e_build.STUB, f62e_build.STUB_END)) | set(range(site, site + hook_len))
            for r0, r2, r3, c, note in cases:
                with self.subTest(site=hex(site), note=note):
                    self.compare(site, span, hook_span, r0, r2, r3, c)

    def test_f62d_taken_jump_misses(self):
        f62d_build.build()
        ins, nxt = disasm(f62d_build.DEST.read_bytes())
        regs, c, mem = fresh(1)
        regs[0] = 0
        cpu = Cpu(ins, nxt, regs, c, mem)
        span = set(range(0xC0C8, 0xC0CC)) | set(range(f62d_build.STUB, f62d_build.STUB_END))
        pc = cpu.run(0xC0C8, span)
        self.assertNotEqual(pc, 0xC09E)

    def test_guards_and_fallthrough_bytes(self):
        f62e_build._guards(self.fw57, bytearray(self.img))
        for at in (0xC09E, 0xC0CC, 0xC162, 0xC1AC, 0xC1BE, 0xC248, 0xC280, 0xC2CA):
            self.assertEqual(self.img[at:at + 2], self.fw57[at:at + 2])
        self.assertEqual(self.img[0xC27A:0xC280], bytes.fromhex("6c036c036c03"))

    def compare(self, site, span, hook_span, r0, r2, r3, c):
        left = self.execute(self.stock, self.stock_n, site, span, r0, r2, r3, c)
        right = self.execute(self.hook, self.hook_n, site, hook_span, r0, r2, r3, c)
        self.assertEqual(right["pc"], left["pc"])
        self.assertEqual(right["c"], left["c"])
        self.assertEqual(right["sp"], left["sp"])
        self.assertEqual(right["regs"], left["regs"])
        ignore = set(range(f62e_build.BASE, f62e_build.BASE + 9))
        keys = set(left["mem"]) | set(right["mem"])
        for addr in keys:
            if addr in ignore or addr < left["sp"]:
                continue
            self.assertEqual(right["mem"].get(addr, 0), left["mem"].get(addr, 0), hex(addr))
        delta = sum(right["mem"].get(f62e_build.BASE + i, 0) for i in range(9))
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
