#!/usr/bin/env python3
"""A patch may not overwrite a literal that outside code still loads.

No phone and no key. FW23 through the shipped FW27 are checked against the
image each one was built on. An image that paints over the key helper's
pool at 0x5BE60, which is what the old FW27 did, has to be reported.
"""
import sys
import unittest
from pathlib import Path

HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))
import literal_guard  # noqa: E402

ROOT = HERE.parent.parent / "radio_firmware" / "build"
# Each shipped image against the one it was built from.
PAIRS = (
    ("DMR003.FW22.V022.bin", "DMR003.FW23.V022.bin"),
    ("DMR003.FW23.V022.bin", "DMR003.FW24.V022.bin"),
    ("DMR003.FW24.V022.bin", "DMR003.FW25.V022.bin"),
    ("DMR003.FW25.V022.bin", "DMR003.FW26.V022.bin"),
    ("DMR003.FW26.V022.bin", "DMR003.FW27.V022.bin"),
)
POOL = range(0x5BE60, 0x5BEE0)


class LiteralGuardTest(unittest.TestCase):
    def test_shipped_images_leave_outside_loads_alone(self):
        for base_name, new_name in PAIRS:
            base = (ROOT / base_name).read_bytes()
            new = (ROOT / new_name).read_bytes()
            spans, hits = literal_guard.covered_loads(base, new)
            self.assertEqual(hits, [], "%s covers %s" % (new_name, hits[:4]))
            self.assertTrue(spans)

    def test_overwriting_the_key_pool_is_reported(self):
        base = (ROOT / "DMR003.FW26.V022.bin").read_bytes()
        bad = bytearray(base)
        bad[POOL.start:POOL.stop] = b"\xa5" * len(POOL)
        spans, hits = literal_guard.covered_loads(base, bytes(bad))
        key = [pool for pc, pool in hits if pc == 0x5BBE2]
        self.assertEqual(key, [0x5BEA0])
        self.assertTrue(all(pool in POOL for pc, pool in hits if pc == 0x5BBE2))


if __name__ == "__main__":
    unittest.main()
