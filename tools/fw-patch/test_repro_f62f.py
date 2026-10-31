#!/usr/bin/env python3
"""Rebuild F62F from the FW57 image in a temporary root.

Nothing here keys the radio.

  python tools/fw-patch/test_repro_f62f.py
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
BUILT = REAL / "radio_firmware" / "build" / "DMR003.F62F.V022.bin"
FINAL = "ac458dca6c83ede1873c2d417181e1aa055d5f0c8167ee107a301d65506cbabe"


def sha256(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


class ReproF62F(unittest.TestCase):
    def test_temp_rebuild_matches(self):
        tmp = Path(tempfile.mkdtemp(prefix="f62frepro_"))
        try:
            shutil.copytree(PATCH, tmp / "tools" / "fw-patch",
                            ignore=shutil.ignore_patterns("__pycache__", "*.pyc"))
            dest = tmp / "radio_firmware" / "build" / "DMR003.FW57.V022.bin"
            dest.parent.mkdir(parents=True)
            shutil.copyfile(FW57, dest)
            sys.path.insert(0, str(tmp / "tools" / "fw-patch"))
            for name in ("f62f_build", "fw30_build", "literal_guard", "space_map",
                         "fw23_build"):
                sys.modules.pop(name, None)
            import f62f_build
            if not str(f62f_build.__file__).startswith(str(tmp)):
                raise AssertionError(f62f_build.__file__)
            before = sha256(BUILT)
            f62f_build.build()
            got = sha256(tmp / "radio_firmware" / "build" / "DMR003.F62F.V022.bin")
            self.assertEqual(got, FINAL)
            self.assertEqual(before, FINAL)
            self.assertEqual(sha256(BUILT), before)
        finally:
            shutil.rmtree(tmp, ignore_errors=True)


if __name__ == "__main__":
    unittest.main(verbosity=2)
