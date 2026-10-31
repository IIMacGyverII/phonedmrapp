# F59E is F59D plus the two All-Call branches. The FW59 block stays.
import struct
import unittest

import fw30_build
import fw58_build
import fw59e_build
import literal_guard
import space_map

FW57_BNEZ = {
    0x11D18: 0x11D2E,
    0x11D80: 0x11D96,
}


class F59E(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        fw59e_build.build()
        cls.old = fw59e_build.SRC.read_bytes()
        cls.new = fw59e_build.DEST.read_bytes()

    def test_tag_and_the_fw59_block(self):
        self.assertEqual(self.new[fw59e_build.TAG], b"DMR003.F59E.V022")
        lo, hi = space_map.FW59_USED
        self.assertEqual(self.new[lo:hi], self.old[lo:hi])
        self.assertEqual(self.new[fw58_build.WIN_LO:fw58_build.WIN_LO + 4], fw58_build.WIN_NEW[0])
        self.assertEqual(self.new[fw58_build.WIN_HI:fw58_build.WIN_HI + 4], fw58_build.WIN_NEW[1])

    def test_only_the_two_hooks_the_stub_and_the_tag(self):
        changed = {i for i in range(len(self.old)) if self.old[i] != self.new[i]}
        allowed = set(range(fw59e_build.TAG.start, fw59e_build.TAG.stop))
        allowed |= set(range(space_map.F59E_STUB, fw58_build.TAIL_END))
        for _name, site in fw59e_build.HOOKS:
            allowed |= set(range(site, site + 4))
        self.assertTrue(changed <= allowed)
        self.assertTrue(any(i >= space_map.F59E_STUB for i in changed))
        tail = [i for i in changed if i >= space_map.F59E_STUB]
        self.assertLess(max(tail), fw58_build.TAIL_END)

    def test_mismatch_lands_on_the_stock_bnez_target(self):
        for site, taken in FW57_BNEZ.items():
            self.assertEqual(fw30_build.bsr_target(self.new, site), fw59e_build.SYMBOLS[
                "allcall_3" if site == 0x11D18 else "allcall_2"])
            self.assertEqual(self.new[taken:taken + 4], self.old[taken:taken + 4])
            self.assertIn(struct.pack("<I", fw58_build.XIP + taken), self.new[space_map.F59E_STUB:fw58_build.TAIL_END])
        for at in (0x11D1C, 0x11D84):
            self.assertEqual(self.new[at:at + 4], self.old[at:at + 4])
            self.assertIn(struct.pack("<I", fw58_build.XIP + at), self.new[space_map.F59E_STUB:fw58_build.TAIL_END])

    def test_guards(self):
        tagged = bytearray(self.new)
        tagged[fw59e_build.TAG] = self.old[fw59e_build.TAG]
        body = bytes(tagged)
        self.assertEqual(literal_guard.covered_loads(self.old, body)[1], [])
        self.assertEqual(literal_guard.covered_branches(self.old, body)[1], [])
        self.assertEqual(literal_guard.never_written(self.old, body), [])
        self.assertEqual(literal_guard.pointed_into(self.old, body), [])
        self.assertEqual(space_map.outside_free(self.old, body), [])


if __name__ == "__main__":
    unittest.main()
