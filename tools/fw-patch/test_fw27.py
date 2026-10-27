#!/usr/bin/env python3
"""Host check for DMR003.FW27.V022. No phone and no key.

The image is FW26 plus the tag, the opcode gate, the UART-pend hook,
the opcode-13 reject, and the stub in the reclaimed playback. Opcode 12,
opcode 14 and the free tail stay as they were.
"""
import struct
import sys
import unittest
from pathlib import Path

HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))
import fw23_build  # noqa: E402
import fw27_build  # noqa: E402

ROOT = HERE.parent.parent
FW26 = ROOT / "radio_firmware" / "build" / "DMR003.FW26.V022.bin"
FW27 = ROOT / "radio_firmware" / "build" / "DMR003.FW27.V022.bin"
XIP = 0x0301A000


class Fw27Test(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        fw27_build.build()
        cls.old = FW26.read_bytes()
        cls.new = FW27.read_bytes()

    def test_length_and_tag(self):
        self.assertEqual(len(self.new), len(self.old))
        self.assertEqual(self.new[0x38464:0x38474], b"DMR003.FW27.V022")
        self.assertNotIn(struct.pack("<I", 0x11000560), self.new[fw27_build.BASE:fw27_build.STUB_END])

    def test_only_the_named_sites_move(self):
        allowed = [
            range(0x38464, 0x38474),
            range(0x5B7DE, 0x5B7E2),
            range(0x7C56, 0x7C5A),
            range(0x5B816, 0x5B81A),
            range(fw27_build.V6_AT, fw27_build.VAR6_END),
            range(fw27_build.POOL_AT, fw27_build.POOL_END),
            range(fw27_build.BASE, fw27_build.STUB_LO_END),
            range(fw27_build.HIGH, fw27_build.STUB_HI_END),
            range(0x5B2A8, 0x5B2AC),
            range(0x5B2BE, 0x5B2C2),
            range(0x5B2C8, 0x5B2CC),
            range(fw27_build.TRAMP, fw27_build.TRAMP_END),
            range(fw27_build.WRAP, fw27_build.WRAP_END),
        ]
        for i, (a, b) in enumerate(zip(self.old, self.new)):
            if a == b:
                continue
            if any(i in span for span in allowed):
                continue
            self.fail("unexpected byte at %X" % i)

    def test_opcode_12_and_14_and_the_tail_stay(self):
        self.assertEqual(self.old[0x5BC0A:0x5BCA4], self.new[0x5BC0A:0x5BCA4])
        # The key path's helper loads these literals. The stub is split around them.
        self.assertEqual(self.old[0x5BE60:0x5BEE0], self.new[0x5BE60:0x5BEE0])
        self.assertEqual(self.old[0x5C098:0x5C464], self.new[0x5C098:0x5C464])
        self.assertEqual(self.new[fw27_build.WRAP_END:fw27_build.POOL_AT],
                         self.old[fw27_build.WRAP_END:fw27_build.POOL_AT])
        self.assertEqual(self.new[fw27_build.POOL_END:0x5C6FC],
                         bytes(0x5C6FC - fw27_build.POOL_END))
        self.assertEqual(self.old[0x5B81A:fw27_build.V6_AT], self.new[0x5B81A:fw27_build.V6_AT])
        self.assertEqual(self.new[fw27_build.VAR6_END:0x5B876], self.old[fw27_build.VAR6_END:0x5B876])

    def test_branches(self):
        gate = fw26_target(self.new, 0x5B7DE)
        self.assertEqual(gate, fw27_build.BASE)
        pend = fw26_target(self.new, 0x7C56, xip=True)
        self.assertEqual(pend, fw27_build.PEND_AT + XIP)
        # The hook must call the flash pend. Address 0x2B0C is that function's
        # file offset, not an IRAM entry.
        inner = fw26_target(self.new, fw27_build.PEND_AT + 0xC, xip=True)
        self.assertEqual(inner, 0x2B0C + XIP)
        reject = fw26_target(self.new, 0x5B816)
        self.assertEqual(reject, 0x5B876)
        self.assertEqual(self.old[0x5B2C8:0x5B2CC], bytes.fromhex("44391f08"))
        self.assertEqual(self.old[0x5B2A8:0x5B2AC], bytes.fromhex("43392f08"))
        self.assertEqual(fw26_target(self.new, 0x5B2C8), fw27_build.TRAMP)
        self.assertEqual(fw26_target(self.new, 0x5B2A8), fw27_build.TRAMP + fw27_build.REST_OFF)
        # The trampoline's own calls must land inside the stub, not at 0x5CD6.
        self.assertEqual(fw27_build.MODE5_AT, 0x5BCDA)
        self.assertEqual(fw27_build.REST_AT, 0x5BD46)
        self.assertEqual(fw26_target(self.new, 0x5C55A), fw27_build.MODE5_AT)
        self.assertEqual(fw26_target(self.new, 0x5C57A), fw27_build.REST_AT)
        self.assertEqual(fw26_target(self.new, 0x5C564), fw27_build.VAR6_AT)
        gate_br = fw27_build.BASE + 0xA
        disp = struct.unpack_from("<h", self.new, gate_br + 2)[0]
        self.assertEqual(self.new[gate_br:gate_br + 2], bytes.fromhex("00e8"))
        self.assertEqual(gate_br + (disp << 1), fw27_build.VAR6_AT)
        self.assertEqual(br_target(self.new, 0x5B2BE), fw27_build.FILT_AT)
        self.assertEqual(self.old[0x5B2C2:0x5B2C8], self.new[0x5B2C2:0x5B2C8])
        hole = self.new[fw27_build.FILT_AT:fw27_build.VAR6_END]
        self.assertIn(bytes.fromhex("01149414"), hole)
        self.assertEqual(sorted(br_targets(self.new, fw27_build.FILT_AT, fw27_build.VAR6_AT)),
                         [0x5B2C2, 0x5B308])
        def calls(target):
            return [off for off in range(fw27_build.VAR6_AT, fw27_build.VAR6_END - 3, 2)
                    if fw26_target(self.new, off) == target]
        if fw27_build.STAGE == "A":
            self.assertEqual(len(calls(0x8E7C)), 1)
            self.assertNotIn(struct.pack("<I", 0x11000504), hole)
        elif fw27_build.STAGE == "B":
            self.assertEqual(len(calls(0x8E5C)), 1)
            self.assertEqual(len(calls(0x7DE8)), 1)
            self.assertEqual(calls(0x8E7C), [])
            self.assertIn(struct.pack("<I", 0x11000504), hole)
            self.assertNotIn(struct.pack("<I", 0x11000500), hole)
        else:
            self.assertEqual(len(calls(0x5C0F8)), 1)
            self.assertEqual(calls(0x8E7C), [])
            pool = self.new[fw27_build.POOL_AT:fw27_build.POOL_END]
            for word in (0x11000504, 0xFFFF00FF, 0x4AE08, 0x4B008, 0x5354524D):
                self.assertIn(struct.pack("<I", word), pool)
            self.assertNotIn(struct.pack("<I", 0x180000A0), pool)
        self.assertNotIn(struct.pack("<I", 0x11000500), self.new[fw27_build.WRAP:fw27_build.POOL_END])
        self.assertNotIn(struct.pack("<I", 0x3A81C), self.new[fw27_build.WRAP:fw27_build.POOL_END])
        self.assertEqual(self.old[0x52A8:0x52AC], self.new[0x52A8:0x52AC])
        self.assertEqual(self.old[0x52C8:0x52CC], self.new[0x52C8:0x52CC])


def fw26_target(img, off, xip=False):
    import fw26_build
    at = off + (XIP if xip else 0)
    return fw26_build.decode_bsr(at, img[off:off + 4])


def br_target(img, off):
    if img[off:off + 2] != bytes.fromhex("00e8"):
        raise AssertionError("not a br at %X: %s" % (off, img[off:off + 4].hex()))
    disp = struct.unpack_from("<h", img, off + 2)[0]
    return off + (disp << 1)


def br_targets(img, start, stop):
    found = []
    off = start
    while off + 4 <= stop:
        if img[off:off + 2] == bytes.fromhex("00e8"):
            found.append(br_target(img, off))
            off += 4
        else:
            off += 2
    return found


if __name__ == "__main__":
    unittest.main()
