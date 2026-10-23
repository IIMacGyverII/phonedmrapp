#!/usr/bin/env python3
"""Host test: every patch's original bytes are in the factory image, no two patches
overlap, and a full build keeps the size and changes only the declared bytes.

  python -m unittest tools/fw-patch/test_patches.py   (or run it directly)
"""
import sys
import unittest
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
import build  # noqa: E402


class PatchTest(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.cfg = build.load()
        cls.fac = build.factory_bytes(cls.cfg)

    def test_every_patch_matches_factory(self):
        for name in self.cfg["patches"]:
            with self.subTest(patch=name):
                build.check_sites(self.cfg, self.fac, [name])

    def test_all_patches_together(self):
        names = list(self.cfg["patches"])
        img, sites = build.build(names, "UVt0", self.cfg)
        self.assertEqual(len(img), len(self.fac))
        allowed = set()
        for off, repl, _ in sites:
            allowed.update(range(off, off + len(repl)))
        t = self.cfg["tag"]
        allowed.update(range(t["offset"], t["offset"] + t["length"]))
        changed = {i for i, (x, y) in enumerate(zip(self.fac, img)) if x != y}
        self.assertTrue(changed <= allowed, sorted(changed - allowed))
        self.assertEqual(img[0x38464:0x38475], b"DMR003.UVt0.V022\x00")

    def test_version_pool_points_at_image_string(self):
        img, _ = build.build(["version-from-image"], "UVt0", self.cfg)
        self.assertEqual(int.from_bytes(img[0xA9E8:0xA9EC], "little"), 0x38464)

    def test_refuses_without_version_patch(self):
        with self.assertRaises(SystemExit):
            build.build(["fm-flat-58"], "UVt0", self.cfg)

    def test_refuses_bad_tag(self):
        for tag in ("UV4T", "UV4", "UV-1"):
            with self.subTest(tag=tag), self.assertRaises(SystemExit):
                build.build(["version-from-image"], tag, self.cfg)


if __name__ == "__main__":
    unittest.main()
