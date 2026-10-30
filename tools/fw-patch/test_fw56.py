# FW56 puts the key gate in the mapped holes and leaves the pitch helper alone.
import unittest
from pathlib import Path

import fw30_build
import fw56_build
import literal_guard
import space_map

ROOT = Path(__file__).resolve().parents[2]
SRC = ROOT / "radio_firmware" / "build" / "DMR003.FW54.V022.bin"


class Fw56(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        fw56_build.build()
        cls.old = SRC.read_bytes()
        cls.new = fw56_build.DEST.read_bytes()

    def test_tag_and_size(self):
        self.assertEqual(len(self.new), len(self.old))
        self.assertEqual(self.new[fw56_build.TAG], b"DMR003.FW56.V022")

    def test_sites_call_the_gate_and_op1_calls_the_arm(self):
        self.assertEqual(fw30_build.bsr_target(self.new, 0x92C8), fw56_build.GATE_AT)
        self.assertEqual(fw30_build.bsr_target(self.new, 0x92E0), fw56_build.GATE_AT)
        self.assertNotEqual(fw30_build.bsr_target(self.new, 0x92AA), 0x5B614)
        self.assertEqual(fw30_build.bsr_target(self.new, 0x5AF44), fw56_build.ARM_AT)

    def test_pitch_helper_tone_end_and_nops_stay(self):
        self.assertEqual(self.old[fw56_build.HELPER.start:fw56_build.HELPER.stop],
                         self.new[fw56_build.HELPER.start:fw56_build.HELPER.stop])
        self.assertEqual(self.old[0x5B720:0x5B780], self.new[0x5B720:0x5B780])
        self.assertEqual(self.new[fw56_build.NOPS:fw56_build.NOPS + 6], bytes.fromhex("0131036c036c"))

    def test_guards_and_the_space_map(self):
        self.assertEqual(literal_guard.covered_loads(self.old, self.new)[1], [])
        self.assertEqual(literal_guard.covered_branches(self.old, self.new)[1], [])
        self.assertEqual(literal_guard.never_written(self.old, self.new), [])
        tagged = bytearray(self.new)
        tagged[fw56_build.TAG] = self.old[fw56_build.TAG]
        self.assertEqual(space_map.outside_free(self.old, bytes(tagged)), [])


if __name__ == "__main__":
    unittest.main()
