#!/usr/bin/env python3
"""Rebuild FW62 and F62P from the FW57 and FW59 images in a temporary root.

Nothing here keys the radio.

  python tools/fw-patch/test_repro_fw62.py
"""
import hashlib
import shutil
import sys
import tempfile
import unittest
from pathlib import Path

REAL = Path(__file__).resolve().parents[2]
PATCH = REAL / "tools" / "fw-patch"
BUILD = REAL / "radio_firmware" / "build"
FW62 = "9a59307585c8b0d9caedef60e03cfd2dffff49a5533b42622d4de63766436dac"
F62P = "2f16bc09bf1fe51652a1cd07c77ac5d973d138e8509861a55bd3298b2369b944"


def sha256(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


class ReproFW62(unittest.TestCase):
    def test_temp_rebuild_matches(self):
        tmp = Path(tempfile.mkdtemp(prefix="fw62repro_"))
        try:
            shutil.copytree(PATCH, tmp / "tools" / "fw-patch",
                            ignore=shutil.ignore_patterns("__pycache__", "*.pyc"))
            dest = tmp / "radio_firmware" / "build"
            dest.mkdir(parents=True)
            for name in ("DMR003.FW57.V022.bin", "DMR003.FW59.V022.bin"):
                shutil.copyfile(BUILD / name, dest / name)
            sys.path.insert(0, str(tmp / "tools" / "fw-patch"))
            for name in ("fw62_build", "fw61_build", "fw59_build", "fw58_build",
                         "fw30_build", "fw23_build", "literal_guard", "space_map"):
                sys.modules.pop(name, None)
            import fw62_build
            if not str(fw62_build.__file__).startswith(str(tmp)):
                raise AssertionError(fw62_build.__file__)
            before62 = sha256(BUILD / "DMR003.FW62.V022.bin")
            beforep = sha256(BUILD / "DMR003.F62P.V022.bin")
            fw62_build.build()
            fw62_build.build_f62p()
            self.assertEqual(sha256(dest / "DMR003.FW62.V022.bin"), FW62)
            self.assertEqual(sha256(dest / "DMR003.F62P.V022.bin"), F62P)
            self.assertEqual(before62, FW62)
            self.assertEqual(beforep, F62P)
            self.assertEqual(sha256(BUILD / "DMR003.FW62.V022.bin"), before62)
            self.assertEqual(sha256(BUILD / "DMR003.F62P.V022.bin"), beforep)
        finally:
            shutil.rmtree(tmp, ignore_errors=True)


if __name__ == "__main__":
    unittest.main(verbosity=2)
