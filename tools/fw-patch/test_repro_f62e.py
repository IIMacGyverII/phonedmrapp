#!/usr/bin/env python3
"""Rebuild F62E from the FW57 image in a temporary root.

Nothing here keys the radio.

  python tools/fw-patch/test_repro_f62e.py
"""
import hashlib
import shutil
import sys
import tempfile
import unittest
from pathlib import Path

REAL = Path(__file__).resolve().parents[2]
PATCH = REAL / "tools" / "fw-patch"
FW57 = REAL / "radio_firmware" / "build" / "DMR003.FW57.V022.bin"
BUILT = REAL / "radio_firmware" / "build" / "DMR003.F62E.V022.bin"
FINAL = "d94c73e7087a6be45046afc981d28112312e6ed2a45ac25f61e0ab28ca78cac4"


def sha256(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


class ReproF62E(unittest.TestCase):
    def test_temp_rebuild_matches(self):
        tmp = Path(tempfile.mkdtemp(prefix="f62erepro_"))
        try:
            shutil.copytree(PATCH, tmp / "tools" / "fw-patch",
                            ignore=shutil.ignore_patterns("__pycache__", "*.pyc"))
            dest = tmp / "radio_firmware" / "build" / "DMR003.FW57.V022.bin"
            dest.parent.mkdir(parents=True)
            shutil.copyfile(FW57, dest)
            sys.path.insert(0, str(tmp / "tools" / "fw-patch"))
            import f62e_build
            if not str(f62e_build.__file__).startswith(str(tmp)):
                raise AssertionError(f62e_build.__file__)
            before = sha256(BUILT)
            f62e_build.build()
            got = sha256(tmp / "radio_firmware" / "build" / "DMR003.F62E.V022.bin")
            self.assertEqual(got, FINAL)
            self.assertEqual(before, FINAL)
            self.assertEqual(sha256(BUILT), before)
        finally:
            shutil.rmtree(tmp, ignore_errors=True)


if __name__ == "__main__":
    unittest.main(verbosity=2)
