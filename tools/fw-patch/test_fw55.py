# FW55 restores the four stock 0x26 calls. The tone-end nops stay.
import unittest
from pathlib import Path

import fw30_build
import fw55_build
import literal_guard

ROOT = Path(__file__).resolve().parents[2]
SRC = ROOT / "radio_firmware" / "build" / "DMR003.FW54.V022.bin"
FAC = ROOT / "radio_firmware" / "DMR003.UV4T.V022-ORIGINAL.bin"


class Fw55(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        fw55_build.build()
        cls.old = SRC.read_bytes()
        cls.new = fw55_build.DEST.read_bytes()
        cls.fac = FAC.read_bytes()

    def test_tag_and_size(self):
        self.assertEqual(len(self.new), len(self.old))
        self.assertEqual(self.new[fw55_build.TAG], b"DMR003.FW55.V022")

    def test_only_the_four_sites_and_the_tag_change(self):
        changed = {i for i in range(len(self.old)) if self.old[i] != self.new[i]}
        tag = set(range(fw55_build.TAG.start, fw55_build.TAG.stop))
        sites = set()
        for at in fw55_build.SITES:
            sites.update(range(at, at + 4))
        self.assertEqual(changed - tag, sites)

    def test_sites_match_factory_and_call_stock(self):
        for at in fw55_build.SITES:
            self.assertEqual(self.new[at:at + 4], self.fac[at:at + 4])
            self.assertEqual(fw30_build.bsr_target(self.new, at), 0xE9C)

    def test_tone_end_and_the_live_ranges_stay(self):
        self.assertEqual(self.new[fw55_build.NOPS:fw55_build.NOPS + 6], bytes.fromhex("0131036c036c"))
        for span in (fw55_build.HELPER, fw55_build.LIVE_UNKEY):
            self.assertEqual(self.old[span.start:span.stop], self.new[span.start:span.stop])

    def test_guards(self):
        self.assertEqual(literal_guard.covered_loads(self.old, self.new)[1], [])
        self.assertEqual(literal_guard.covered_branches(self.old, self.new)[1], [])
        self.assertEqual(literal_guard.never_written(self.old, self.new), [])


if __name__ == "__main__":
    unittest.main()
