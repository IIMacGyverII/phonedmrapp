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
        end = fw27_build.STUB_END
        allowed = [
            range(0x38464, 0x38474),
            range(0x5B7DE, 0x5B7E2),
            range(0x7C56, 0x7C5A),
            range(0x5B816, 0x5B81A),
            range(fw27_build.BASE, end),
        ]
        for i, (a, b) in enumerate(zip(self.old, self.new)):
            if a == b:
                continue
            if any(i in span for span in allowed):
                continue
            self.fail("unexpected byte at %X" % i)

    def test_opcode_12_and_14_and_the_tail_stay(self):
        self.assertEqual(self.old[0x5BC0A:0x5BCA4], self.new[0x5BC0A:0x5BCA4])
        self.assertEqual(self.old[0x5C098:0x5C464], self.new[0x5C098:0x5C464])
        self.assertEqual(self.new[0x5C54C:0x5C6FC], bytes(0x5C6FC - 0x5C54C))

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


def fw26_target(img, off, xip=False):
    import fw26_build
    at = off + (XIP if xip else 0)
    return fw26_build.decode_bsr(at, img[off:off + 4])


if __name__ == "__main__":
    unittest.main()
