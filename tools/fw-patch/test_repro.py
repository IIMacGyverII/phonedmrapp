#!/usr/bin/env python3
"""Host test: FW21 and FW22 rebuild to the images that were loaded.

The assembly in stubs/ is what the build scripts assemble. A clean checkout
plus the factory image and the C-SKY assembler reproduces the pinned sha256.
Nothing here keys the radio.

  python tools/fw-patch/test_repro.py
"""
import hashlib
import sys
import unittest
from pathlib import Path

HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))
import check  # noqa: E402
import fw21_build  # noqa: E402
import fw22_build  # noqa: E402

BUILD = HERE.parent.parent / "radio_firmware" / "build"


def norm(path):
    return path.read_text(encoding="utf-8").replace("\r\n", "\n")


def run_check(path):
    argv = sys.argv
    sys.argv = ["check.py", str(path)]
    try:
        return check.main()
    finally:
        sys.argv = argv


class ReproTest(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        fw21_build.main()
        fw22_build.main()

    def test_fw21_source_is_committed(self):
        self.assertEqual(norm(HERE / "stubs" / "fw21_ext.S"), fw21_build.asm_source().replace("\r\n", "\n"))

    def test_fw22_source_is_committed(self):
        self.assertEqual(norm(HERE / "stubs" / "fw22_ext.S"), fw22_build.asm_source().replace("\r\n", "\n"))

    def test_fw21_image_hash(self):
        img = (BUILD / "DMR003.FW21.V022.bin").read_bytes()
        self.assertEqual(hashlib.sha256(img).hexdigest(), check.PINNED["DMR003.FW21.V022"])

    def test_fw22_image_hash(self):
        img = (BUILD / "DMR003.FW22.V022.bin").read_bytes()
        self.assertEqual(hashlib.sha256(img).hexdigest(), check.PINNED["DMR003.FW22.V022"])

    def test_check_accepts_the_pinned_images(self):
        for name in ("DMR003.FW21.V022.bin", "DMR003.FW22.V022.bin"):
            with self.subTest(image=name):
                self.assertEqual(run_check(BUILD / name), 0)


if __name__ == "__main__":
    unittest.main()
