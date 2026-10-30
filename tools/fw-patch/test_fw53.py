# FW53 keeps the pitch helper and the live unkey, and skips the hung call.
import unittest
from pathlib import Path

import fw30_build
import fw53_build
import literal_guard

ROOT = Path(__file__).resolve().parents[2]
SRC = ROOT / "radio_firmware" / "build" / "DMR003.FW46.V022.bin"


class Fw53(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        fw53_build.build()
        cls.old = SRC.read_bytes()
        cls.new = fw53_build.DEST.read_bytes()

    def test_tag_and_size(self):
        self.assertEqual(len(self.new), len(self.old))
        self.assertEqual(self.new[fw53_build.TAG], b"DMR003.FW53.V022")

    def test_only_the_skip_the_argument_and_the_tag_change(self):
        changed = {i for i in range(len(self.old)) if self.old[i] != self.new[i]}
        tag = set(range(fw53_build.TAG.start, fw53_build.TAG.stop))
        self.assertEqual(changed - tag, {0x5B749, 0x5B74A, 0x5B74B, 0x5B756})
        self.assertTrue(changed <= tag | {0x5B748, 0x5B749, 0x5B74A, 0x5B74B, 0x5B756})

    def test_skip_lands_on_the_pop_and_r1_is_the_stock_unkey(self):
        self.assertEqual(self.new[0x5B748:0x5B74C], fw30_build.encode_br(0x5B748, 0x5B77A))
        self.assertEqual(self.new[0x5B756:0x5B758], bytes.fromhex("0131"))

    def test_pitch_helper_and_live_unkey_are_untouched(self):
        for span in (fw53_build.HELPER, fw53_build.LIVE_UNKEY):
            self.assertEqual(self.old[span.start:span.stop], self.new[span.start:span.stop])

    def test_guards(self):
        self.assertEqual(literal_guard.covered_loads(self.old, self.new)[1], [])
        self.assertEqual(literal_guard.covered_branches(self.old, self.new)[1], [])
        self.assertEqual(literal_guard.never_written(self.old, self.new), [])


if __name__ == "__main__":
    unittest.main()
