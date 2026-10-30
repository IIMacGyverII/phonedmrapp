# Bisect image (a) restores FW55's seven hooks to the factory bytes.
import unittest
from pathlib import Path

import fw30_build
import fw55a_build
import literal_guard
import space_map

ROOT = Path(__file__).resolve().parents[2]
SRC = ROOT / "radio_firmware" / "build" / "DMR003.FW55.V022.bin"
FAC = ROOT / "radio_firmware" / "DMR003.UV4T.V022-ORIGINAL.bin"


class Fw55a(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        fw55a_build.build()
        cls.old = SRC.read_bytes()
        cls.fac = FAC.read_bytes()
        cls.new = fw55a_build.DEST.read_bytes()

    def test_tag(self):
        self.assertEqual(self.new[fw55a_build.TAG], b"DMR003.F55A.V022")

    def test_hooks_match_the_factory_image(self):
        for at in fw55a_build.SITES:
            self.assertEqual(self.new[at:at + 4], self.fac[at:at + 4], hex(at))
        for at, target in fw55a_build.BSR.items():
            self.assertEqual(fw30_build.bsr_target(self.new, at), target)
        word = int.from_bytes(self.new[0x382B8:0x382BC], "little")
        self.assertEqual(word, fw55a_build.DISPATCH)

    def test_tail_and_key_sites_stay_fw55(self):
        self.assertEqual(self.new[0x5AEFC:], self.old[0x5AEFC:])
        for at in (0x92AA, 0x92C8, 0x92E0, 0x92FA):
            self.assertEqual(self.new[at:at + 4], self.old[at:at + 4])
            self.assertEqual(self.new[at:at + 4], self.fac[at:at + 4])
            self.assertEqual(fw30_build.bsr_target(self.new, at), 0xE9C)

    def test_only_the_hooks_and_the_tag_change(self):
        changed = {i for i in range(len(self.old)) if self.old[i] != self.new[i]}
        allowed = set(range(fw55a_build.TAG.start, fw55a_build.TAG.stop))
        for at in fw55a_build.SITES:
            allowed.update(range(at, at + 4))
        self.assertTrue(changed <= allowed)
        self.assertTrue(set(range(0x37F8, 0x37FC)) <= changed)

    def test_guards(self):
        self.assertEqual(literal_guard.covered_loads(self.old, self.new)[1], [])
        self.assertEqual(literal_guard.covered_branches(self.old, self.new)[1], [])
        self.assertEqual(literal_guard.never_written(self.old, self.new), [])
        self.assertEqual(literal_guard.pointed_into(self.old, self.new), [])
        self.assertEqual(space_map.outside_free(self.old, self.new), [])


if __name__ == "__main__":
    unittest.main()
