#!/usr/bin/env python3
"""Rebuild FW61 and FW61T from the factory image in a temporary root.

FW61 is FW57 plus the hold guard copied from the FW59 image. FW61T gives
the 24-byte time-out slot back to the factory bytes. Nothing here keys
the radio.

  python tools/fw-patch/test_repro_fw61.py
"""
import hashlib
import shutil
import sys
import tempfile
import unittest
from pathlib import Path

REAL = Path(__file__).resolve().parents[2]
PATCH = REAL / "tools" / "fw-patch"
FACTORY = REAL / "radio_firmware" / "DMR003.UV4T.V022-ORIGINAL.bin"
BUILT = REAL / "radio_firmware" / "build"
FINAL = "e349cf5ecc8a05297c149a0b9dd00f9e9cd1c688c9bc6b0e9b291fdd7490df99"
TIMEOUT = "bfa9f1dc509770a32f8a28c04e0791c16161388247614227cc5cb9f70515da8e"

HOPS = (
    ("fw23_build", "main", "DMR003.FW25.V022.bin"),
    ("fw26_build", "main", "DMR003.FW26.V022.bin"),
    ("fw27_build", "build", "DMR003.FW27.V022.bin"),
    ("fw28_build", "build", "DMR003.FW28.V022.bin"),
    ("fw29_build", "build", "DMR003.FW29.V022.bin"),
    ("fw3b_bisect", "build_fw3d", "DMR003.FW3D.V022.bin"),
    ("fw3b_bisect", "build_fw3e", "DMR003.FW3E.V022.bin"),
    ("fw3b_bisect", "build_fw3f", "DMR003.FW3F.V022.bin"),
    ("fw3b_bisect", "build_fw3h", "DMR003.FW3H.V022.bin"),
    ("fw3b_bisect", "build_fw3j", "DMR003.FW3J.V022.bin"),
    ("fw3b_bisect", "build_fw3k", "DMR003.FW3K.V022.bin"),
    ("fw3b_bisect", "build_fw30_retag", "DMR003.FW30.V022.bin"),
    ("fw36_build", "build", "DMR003.FW36.V022.bin"),
    ("fw37_build", "build", "DMR003.FW37.V022.bin"),
    ("fw44_build", "build", "DMR003.FW44.V022.bin"),
    ("fw45_build", "build", "DMR003.FW45.V022.bin"),
    ("fw46_build", "build", "DMR003.FW46.V022.bin"),
    ("fw54_build", "build", "DMR003.FW54.V022.bin"),
    ("fw57_build", "build", "DMR003.FW57.V022.bin"),
    ("fw59_build", "build", "DMR003.FW59.V022.bin"),
    ("fw61_build", "build", "DMR003.FW61.V022.bin"),
)


def sha256(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


class ReproFW61(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.tmp = Path(tempfile.mkdtemp(prefix="fw61repro_"))
        shutil.copytree(PATCH, cls.tmp / "tools" / "fw-patch",
                        ignore=shutil.ignore_patterns("__pycache__", "*.pyc"))
        dest_fac = cls.tmp / "radio_firmware" / "DMR003.UV4T.V022-ORIGINAL.bin"
        dest_fac.parent.mkdir(parents=True)
        shutil.copyfile(FACTORY, dest_fac)
        (cls.tmp / "radio_firmware" / "build").mkdir()
        sys.path.insert(0, str(cls.tmp / "tools" / "fw-patch"))
        cls.rows = []
        for mod_name, fn_name, image in HOPS:
            mod = __import__(mod_name)
            if not str(mod.__file__).startswith(str(cls.tmp)):
                raise AssertionError("%s loaded from %s" % (mod_name, mod.__file__))
            before = sha256(BUILT / image)
            getattr(mod, fn_name)()
            got_path = cls.tmp / "radio_firmware" / "build" / image
            if not got_path.is_file():
                raise AssertionError("first missing image: %s" % image)
            got = sha256(got_path)
            cls.rows.append((image, mod_name + "." + fn_name, got, before))
            if got != before:
                raise AssertionError("first hop that differs: %s %s built %s measured %s" % (
                    mod_name + "." + fn_name, image, got, before))
            if sha256(BUILT / image) != before:
                raise AssertionError("wrote the real build tree at %s" % image)
        cls.tmod = __import__("fw61t_build")
        if not str(cls.tmod.__file__).startswith(str(cls.tmp)):
            raise AssertionError(cls.tmod.__file__)

    @classmethod
    def tearDownClass(cls):
        shutil.rmtree(cls.tmp, ignore_errors=True)

    def test_every_hop_matches_the_loaded_image(self):
        self.assertEqual(len(self.rows), len(HOPS))
        for image, step, got, measured in self.rows:
            with self.subTest(image=image):
                self.assertEqual(got, measured, step)

    def test_final_hash(self):
        image, _step, got, measured = self.rows[-1]
        self.assertEqual(image, "DMR003.FW61.V022.bin")
        self.assertEqual(got, FINAL)
        self.assertEqual(measured, FINAL)

    def test_timeout_variant(self):
        self.tmod.build()
        got = sha256(self.tmp / "radio_firmware" / "build" / "DMR003.F61T.V022.bin")
        measured = sha256(BUILT / "DMR003.F61T.V022.bin")
        self.assertEqual(got, TIMEOUT)
        self.assertEqual(measured, TIMEOUT)


if __name__ == "__main__":
    unittest.main(verbosity=2)
