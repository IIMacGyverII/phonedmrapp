# FW61 is FW57 plus the FW59 hold guard. FW61T also returns the
# 24-byte time-out slot to the factory image. Nothing here keys the radio.
import struct
import unittest
from pathlib import Path

import fw30_build
import fw58_build
import fw61_build
import fw61t_build
import literal_guard
import space_map

ROOT = Path(__file__).resolve().parents[2]
FACTORY = ROOT / "radio_firmware" / "DMR003.UV4T.V022-ORIGINAL.bin"


class Fw61(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        fw61_build.build()
        cls.old = fw61_build.SRC.read_bytes()
        cls.guard = fw61_build.GUARD.read_bytes()
        cls.new = fw61_build.DEST.read_bytes()

    def test_tag_and_the_guard_bytes(self):
        self.assertEqual(self.new[fw61_build.TAG], b"DMR003.FW61.V022")
        self.assertEqual(len(self.new), len(self.old))
        self.assertEqual(self.new[fw61_build.CODE_LO:fw61_build.CODE_HI],
                         self.guard[fw61_build.CODE_LO:fw61_build.CODE_HI])
        self.assertEqual(self.new[fw61_build.POOL_LO:fw61_build.POOL_HI],
                         self.guard[fw61_build.POOL_LO:fw61_build.POOL_HI])
        for at, word in fw61_build.POOLS:
            self.assertEqual(struct.unpack_from("<I", self.new, at)[0], word)

    def test_hooks_and_the_sites_that_stay(self):
        self.assertEqual(fw58_build._br_target(self.new, 0x5B2D2), fw61_build.APPLY)
        self.assertEqual(fw58_build._br_target(self.new, 0x5BD36), fw61_build.RELEASE)
        for at in (0x26F24, 0x11D18, 0x11D80):
            self.assertEqual(self.new[at:at + 4], self.old[at:at + 4], hex(at))
        self.assertEqual(self.new[0x5C59C:fw61_build.CODE_LO], self.old[0x5C59C:fw61_build.CODE_LO])
        self.assertEqual(self.new[fw61_build.CODE_HI:fw61_build.POOL_LO],
                         self.old[fw61_build.CODE_HI:fw61_build.POOL_LO])

    def test_only_the_hooks_the_guard_and_the_tag(self):
        changed = {i for i in range(len(self.old)) if self.old[i] != self.new[i]}
        allowed = set(range(fw61_build.TAG.start, fw61_build.TAG.stop))
        allowed |= set(range(fw61_build.CODE_LO, fw61_build.CODE_HI))
        allowed |= set(range(fw61_build.POOL_LO, fw61_build.POOL_HI))
        for site, _target in fw61_build.HOOKS:
            allowed |= set(range(site, site + 4))
        self.assertTrue(changed <= allowed)
        self.assertTrue(changed)

    def test_guards(self):
        tagged = bytearray(self.new)
        tagged[fw61_build.TAG] = self.old[fw61_build.TAG]
        body = bytes(tagged)
        self.assertEqual(literal_guard.covered_loads(self.old, body)[1], [])
        self.assertEqual(literal_guard.covered_branches(self.old, body)[1], [])
        self.assertEqual(literal_guard.never_written(self.old, body), [])
        self.assertEqual(literal_guard.pointed_into(self.old, body), [])
        self.assertEqual(space_map.outside_free(self.old, body), [])


class Fw61T(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        fw61t_build.build()
        cls.fw61 = fw61_build.DEST.read_bytes()
        cls.new = fw61t_build.DEST.read_bytes()
        cls.factory = FACTORY.read_bytes()

    def test_tag_and_the_freed_slot(self):
        self.assertEqual(self.new[fw61t_build.TAG], b"DMR003.F61T.V022")
        self.assertEqual(self.new[fw61t_build.SLOT:fw61t_build.SLOT_END],
                         self.factory[fw61t_build.SLOT:fw61t_build.SLOT_END])
        self.assertNotEqual(self.fw61[fw61t_build.SLOT:fw61t_build.SLOT_END],
                            self.new[fw61t_build.SLOT:fw61t_build.SLOT_END])
        self.assertEqual(fw30_build.bsr_target(self.new, fw61t_build.CLAMP), fw61t_build.STOCK)
        self.assertEqual(self.new[fw61t_build.CLAMP:fw61t_build.CLAMP + 4],
                         self.factory[fw61t_build.CLAMP:fw61t_build.CLAMP + 4])

    def test_only_the_slot_and_the_tag_differ_from_fw61(self):
        changed = {i for i in range(len(self.fw61)) if self.fw61[i] != self.new[i]}
        allowed = set(range(fw61t_build.TAG.start, fw61t_build.TAG.stop))
        allowed |= set(range(fw61t_build.SLOT, fw61t_build.SLOT_END))
        self.assertTrue(changed <= allowed)
        self.assertTrue(changed & set(range(fw61t_build.SLOT, fw61t_build.SLOT_END)))

    def test_guards(self):
        body = bytearray(self.fw61)
        body[fw61t_build.SLOT:fw61t_build.SLOT_END] = self.new[fw61t_build.SLOT:fw61t_build.SLOT_END]
        self.assertEqual(literal_guard.covered_loads(self.fw61, bytes(body))[1], [])
        self.assertEqual(literal_guard.covered_branches(self.fw61, bytes(body))[1], [])
        self.assertEqual(literal_guard.never_written(self.fw61, bytes(body)), [])
        self.assertEqual(literal_guard.pointed_into(self.fw61, bytes(body)), [])
        self.assertEqual(self.new[fw61_build.CODE_LO:fw61_build.CODE_HI],
                         self.fw61[fw61_build.CODE_LO:fw61_build.CODE_HI])


if __name__ == "__main__":
    unittest.main()
