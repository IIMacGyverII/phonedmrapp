# FW54 nops only the hung engine-end unkey. The drop and the live bytes stay.
import unittest
from pathlib import Path

import fw54_build
import literal_guard

ROOT = Path(__file__).resolve().parents[2]
SRC = ROOT / "radio_firmware" / "build" / "DMR003.FW46.V022.bin"
FW45 = ROOT / "radio_firmware" / "build" / "DMR003.FW45.V022.bin"


class Fw54(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        fw54_build.build()
        cls.old = SRC.read_bytes()
        cls.new = fw54_build.DEST.read_bytes()
        cls.fw45 = FW45.read_bytes()

    def test_tag_and_size(self):
        self.assertEqual(len(self.new), len(self.old))
        self.assertEqual(self.new[fw54_build.TAG], b"DMR003.FW54.V022")

    def test_only_the_unkey_site_and_the_tag_change(self):
        changed = {i for i in range(len(self.old)) if self.old[i] != self.new[i]}
        tag = set(range(fw54_build.TAG.start, fw54_build.TAG.stop))
        self.assertEqual(changed - tag, {0x5B756, 0x5B758, 0x5B759, 0x5B75A, 0x5B75B})

    def test_site_matches_fw45_and_the_drop_stays(self):
        self.assertEqual(self.new[0x5B756:0x5B75C], fw54_build.FW45)
        self.assertEqual(self.new[0x5B756:0x5B75C], self.fw45[0x5B756:0x5B75C])
        self.assertEqual(self.new[fw54_build.DROP:fw54_build.DROP + 4], bytes.fromhex("00e02803"))

    def test_pitch_helper_and_live_unkey_are_untouched(self):
        for span in (fw54_build.HELPER, fw54_build.LIVE_UNKEY):
            self.assertEqual(self.old[span.start:span.stop], self.new[span.start:span.stop])

    def test_guards(self):
        self.assertEqual(literal_guard.covered_loads(self.old, self.new)[1], [])
        self.assertEqual(literal_guard.covered_branches(self.old, self.new)[1], [])
        self.assertEqual(literal_guard.never_written(self.old, self.new), [])


if __name__ == "__main__":
    unittest.main()
