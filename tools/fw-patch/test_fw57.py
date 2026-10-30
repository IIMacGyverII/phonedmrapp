# FW57 is the eight-byte wrapper fix. Everything else stays FW54.
import unittest
from pathlib import Path

import fw30_build
import fw57_build
import literal_guard
import space_map

ROOT = Path(__file__).resolve().parents[2]
SRC = ROOT / "radio_firmware" / "build" / "DMR003.FW54.V022.bin"


class Fw57(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        fw57_build.build()
        cls.old = SRC.read_bytes()
        cls.new = fw57_build.DEST.read_bytes()

    def test_the_eight_bytes(self):
        self.assertEqual(self.new[0x5BDF4:0x5BDFC], bytes.fromhex("00e8f7fe036c036c"))

    def test_bez_target_stays(self):
        self.assertEqual(self.new[0x5BDFC:0x5BDFE], bytes.fromhex("9414"))
        self.assertEqual(int.from_bytes(self.new[0x5BDFC:0x5BDFE], "little"), 0x1494)

    def test_the_four_sites_stay(self):
        for at in (0x92C8, 0x92E0):
            self.assertEqual(fw30_build.bsr_target(self.new, at), 0x5B580)
        for at in (0x92AA, 0x92FA):
            self.assertEqual(fw30_build.bsr_target(self.new, at), 0x5B614)

    def test_only_the_wrapper_and_the_tag_change(self):
        changed = {i for i in range(len(self.old)) if self.old[i] != self.new[i]}
        tag = set(range(fw57_build.TAG.start, fw57_build.TAG.stop))
        self.assertEqual(changed - tag, set(range(0x5BDF4, 0x5BDFC)))

    def test_guards(self):
        self.assertEqual(literal_guard.covered_loads(self.old, self.new)[1], [])
        self.assertEqual(literal_guard.covered_branches(self.old, self.new)[1], [])
        self.assertEqual(literal_guard.never_written(self.old, self.new), [])
        self.assertEqual(literal_guard.pointed_into(self.old, self.new), [])
        tagged = bytearray(self.new)
        tagged[fw57_build.TAG] = self.old[fw57_build.TAG]
        self.assertEqual(space_map.outside_free(self.old, bytes(tagged)), [])


class DiagTwins(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        import fw57_diag
        fw57_diag.build()
        cls.f54 = (ROOT / "radio_firmware" / "build" / "DMR003.FW54.V022.bin").read_bytes()
        cls.d54 = (ROOT / "radio_firmware" / "build" / "DMR003.F54D.V022.bin").read_bytes()
        cls.f57 = (ROOT / "radio_firmware" / "build" / "DMR003.FW57.V022.bin").read_bytes()
        cls.d57 = (ROOT / "radio_firmware" / "build" / "DMR003.F57D.V022.bin").read_bytes()

    def test_windows(self):
        for blob, tag in ((self.d54, b"DMR003.F54D.V022"), (self.d57, b"DMR003.F57D.V022")):
            self.assertEqual(blob[0x38464:0x38474], tag)
            self.assertEqual(blob[0x5C0CE:0x5C0D2], bytes.fromhex("21ea0300"))
            self.assertEqual(blob[0x5C0D6:0x5C0DA], bytes.fromhex("21ea0500"))

    def test_only_the_window_and_the_tag(self):
        for old, new in ((self.f54, self.d54), (self.f57, self.d57)):
            changed = {i for i in range(len(old)) if old[i] != new[i]}
            allowed = set(range(0x38464, 0x38474)) | set(range(0x5C0CE, 0x5C0D2)) | set(range(0x5C0D6, 0x5C0DA))
            self.assertTrue(changed <= allowed)


if __name__ == "__main__":
    unittest.main()
