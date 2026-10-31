#!/usr/bin/env python3
"""Rebuild FW59 from the factory image in a temporary root.

Each hop is checked against the image in radio_firmware/build/. The final
image is the pinned FW59 hash, and F59D is that image plus the opcode 14
window. Nothing here keys the radio.

  python tools/fw-patch/test_repro_fw59.py
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
FINAL = "0d9f7a373fb3ee2b3e2447979242a4cdb0c06f0c37d04dc4f68c892062909b69"
DIAG = "db2cf035718e4f084224ba8fb7b80c022d6c3fa570459cab35c8630eed8dd2d8"

# Script, then the image that script writes. Order is the SRC chain.
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
)


def sha256(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


class ReproFW59(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.tmp = Path(tempfile.mkdtemp(prefix="fw59repro_"))
        shutil.copytree(PATCH, cls.tmp / "tools" / "fw-patch", ignore=shutil.ignore_patterns("__pycache__", "*.pyc"))
        dest_fac = cls.tmp / "radio_firmware" / "DMR003.UV4T.V022-ORIGINAL.bin"
        dest_fac.parent.mkdir(parents=True)
        shutil.copyfile(FACTORY, dest_fac)
        (cls.tmp / "radio_firmware" / "build").mkdir()
        sys.path.insert(0, str(cls.tmp / "tools" / "fw-patch"))
        cls.rows = []
        cls.mod = None
        for mod_name, fn_name, image in HOPS:
            mod = __import__(mod_name)
            if not str(mod.__file__).startswith(str(cls.tmp)):
                raise AssertionError("%s loaded from %s" % (mod_name, mod.__file__))
            if mod_name == "fw59_build":
                cls.mod = mod
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

    @classmethod
    def tearDownClass(cls):
        shutil.rmtree(cls.tmp, ignore_errors=True)

    def test_every_hop_matches_the_loaded_image(self):
        self.assertEqual(len(self.rows), len(HOPS))
        for image, step, got, measured in self.rows:
            with self.subTest(image=image):
                self.assertEqual(got, measured, step)

    def test_final_hash(self):
        image, step, got, measured = self.rows[-1]
        self.assertEqual(image, "DMR003.FW59.V022.bin")
        self.assertEqual(got, FINAL)
        self.assertEqual(measured, FINAL)

    def test_diag_hash(self):
        self.mod.build_diag()
        got = sha256(self.tmp / "radio_firmware" / "build" / "DMR003.F59D.V022.bin")
        measured = sha256(BUILT / "DMR003.F59D.V022.bin")
        self.assertEqual(got, DIAG)
        self.assertEqual(measured, DIAG)


if __name__ == "__main__":
    unittest.main(verbosity=2)
