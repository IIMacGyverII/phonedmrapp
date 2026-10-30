# F55B keeps the FW55 dispatch word and restores the seven hook sites.
import unittest
from pathlib import Path

import fw30_build
import fw55a_build
import fw55b_build
import literal_guard
import space_map

ROOT = Path(__file__).resolve().parents[2]
SRC = ROOT / "radio_firmware" / "build" / "DMR003.FW55.V022.bin"
FAC = ROOT / "radio_firmware" / "DMR003.UV4T.V022-ORIGINAL.bin"


class Fw55b(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        fw55b_build.build()
        cls.old = SRC.read_bytes()
        cls.fac = FAC.read_bytes()
        cls.new = fw55b_build.DEST.read_bytes()

    def test_tag_and_dispatch(self):
        self.assertEqual(self.new[fw55b_build.TAG], b"DMR003.F55B.V022")
        self.assertEqual(self.new[0x382B8:0x382BC], self.old[0x382B8:0x382BC])
        self.assertNotEqual(self.new[0x382B8:0x382BC], self.fac[0x382B8:0x382BC])

    def test_hooks_match_the_factory_image(self):
        for at in fw55b_build.SITES:
            self.assertEqual(self.new[at:at + 4], self.fac[at:at + 4], hex(at))
        for at, target in fw55a_build.BSR.items():
            self.assertEqual(fw30_build.bsr_target(self.new, at), target)

    def test_tail_stays(self):
        self.assertEqual(self.new[0x5AEFC:], self.old[0x5AEFC:])

    def test_guards(self):
        self.assertEqual(literal_guard.covered_loads(self.old, self.new)[1], [])
        self.assertEqual(literal_guard.covered_branches(self.old, self.new)[1], [])
        self.assertEqual(literal_guard.never_written(self.old, self.new), [])
        self.assertEqual(literal_guard.pointed_into(self.old, self.new), [])
        self.assertEqual(space_map.outside_free(self.old, self.new), [])


if __name__ == "__main__":
    unittest.main()
