#!/usr/bin/env python3
"""Host test: every patch's original bytes are in the factory image, no two patches
overlap, a full build keeps the size and changes only the declared bytes, the tag-only
image differs from the factory image only in the version string, and the branch
encodings of the C7000 stub point where they should.

  python -m unittest tools/fw-patch/test_patches.py   (or run it directly)
"""
import sys
import unittest
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
import build  # noqa: E402

VERSION_AT = 0x38464


def bsr32_target(img, at):
    """Decode a C-SKY V2 32-bit bsr stored as two LE halfwords (high halfword first)."""
    hi = int.from_bytes(img[at:at + 2], "little")
    lo = int.from_bytes(img[at + 2:at + 4], "little")
    word = (hi << 16) | lo
    assert word >> 26 == 0b111000, f"not a bsr32 at 0x{at:X}: {word:08X}"
    off = (word & 0x3FFFFFF) << 1
    if off & (1 << 26):
        off -= 1 << 27
    return (at + off) & 0xFFFFFFFF


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
        # The 0x58 variants share five immediates, and the two C7000 stubs share the
        # redirect plus the tail. One from each group, plus the shared mask patch.
        names = ["fm-flat-58dd", "c7000-fm-flat", "ctcss-hpf-keep"]
        img, sites = build.build(names, "UVt0", self.cfg)
        self.assertEqual(len(img), len(self.fac))
        allowed = set()
        for off, repl, _ in sites:
            allowed.update(range(off, off + len(repl)))
        t = self.cfg["tag"]
        allowed.update(range(t["offset"], t["offset"] + t["length"]))
        changed = {i for i, (x, y) in enumerate(zip(self.fac, img)) if x != y}
        self.assertTrue(changed <= allowed, sorted(changed - allowed))
        self.assertEqual(img[VERSION_AT:VERSION_AT + 17], b"DMR003.UVt0.V022\x00")

    def test_exclusive_variants_refuse_to_stack(self):
        pairs = [
            ["fm-flat-58", "fm-flat-58dd"],
            ["fm-flat-58", "fm-flat-58fd"],
            ["fm-flat-58", "fm-flat-58bcfd"],
            ["fm-flat-58dd", "fm-flat-58fd"],
            ["fm-flat-58dd", "fm-flat-58bcfd"],
            ["fm-flat-58fd", "fm-flat-58bcfd"],
            ["c7000-fm-flat", "c7000-fm-canary"],
            ["c7000-fm-flat", "c7000-fm-proof"],
            ["c7000-fm-canary", "c7000-fm-proof"],
        ]
        for names in pairs:
            with self.subTest(names=names), self.assertRaises(SystemExit):
                build.build(names, "UVt0", self.cfg)

    def test_tag_only_differs_only_in_version_string(self):
        img, sites = build.build([], "UVm1", self.cfg)
        self.assertEqual(sites, [])
        self.assertEqual(len(img), len(self.fac))
        changed = [i for i, (x, y) in enumerate(zip(self.fac, img)) if x != y]
        self.assertTrue(changed, "tag-only image must differ from factory")
        self.assertTrue(all(VERSION_AT <= i < VERSION_AT + 16 for i in changed), [hex(i) for i in changed])
        self.assertEqual(img[VERSION_AT:VERSION_AT + 17], b"DMR003.UVm1.V022\x00")

    def test_version_reply_reads_image_string(self):
        # +0xA7EE lrw pool word at +0xA9E8 = flash 0x0301A000 + 0x38464 (ch. 11 §21.4), untouched.
        self.assertEqual(int.from_bytes(self.fac[0xA9E8:0xA9EC], "little"), 0x0301A000 + VERSION_AT)

    def test_fm_flat_58_value(self):
        img, _ = build.build(["fm-flat-58"], "UVt0", self.cfg)
        for s in self.cfg["patches"]["fm-flat-58"]["sites"]:
            v = int.from_bytes(img[s["offset"]:s["offset"] + 2], "little")
            self.assertEqual(v, 0x84C5)
            self.assertTrue(v & 0x40 and v & 0x80, "voice HPF (bit 6) and emphasis (bit 7) bypassed")

    def _assert_reg58(self, names, value, bits_on, bits_off):
        img, _ = build.build(names, "UVt0", self.cfg)
        key = names[0]
        for s in self.cfg["patches"][key]["sites"]:
            v = int.from_bytes(img[s["offset"]:s["offset"] + 2], "little")
            self.assertEqual(v, value)
            for b in bits_on:
                self.assertTrue(v & (1 << b), f"bit {b} set in 0x{v:04X}")
            for b in bits_off:
                self.assertFalse(v & (1 << b), f"bit {b} clear in 0x{v:04X}")
        # The mask patch is the other functional change, and it is only those two bytes.
        self.assertEqual(img[0x3338:0x333C], bytes.fromhex("03eaffff"))
        self.assertEqual(int.from_bytes(img[0x333A:0x333C], "little"), 0xFFFF)

    def test_fm_flat_58dd_with_mask(self):
        # bits 3, 4 CTCSS HPF/LPF; 6 voice HPF; 7 emphasis. Bit 5 (voice LPF) stays off.
        self._assert_reg58(["fm-flat-58dd", "ctcss-hpf-keep"], 0x84DD, (3, 4, 6, 7), (5,))

    def test_fm_flat_58fd_with_mask(self):
        self._assert_reg58(["fm-flat-58fd", "ctcss-hpf-keep"], 0x84FD, (3, 4, 5, 6, 7), ())

    def test_fm_flat_58bcfd_matches_dmr_immediate(self):
        # The DMR tune already writes 0xBCFD. Its value halfword is at +0x2E94
        # (the opcode halfword 0xEA01 is at +0x2E92). The analog sites take that
        # same halfword. Bits 11-13 are the part 0x84FD does not set.
        dmr = int.from_bytes(self.fac[0x2E94:0x2E96], "little")
        self.assertEqual(dmr, 0xBCFD)
        self._assert_reg58(["fm-flat-58bcfd", "ctcss-hpf-keep"], dmr, (3, 4, 5, 6, 7, 11, 12, 13), ())
        img, _ = build.build(["fm-flat-58bcfd", "ctcss-hpf-keep"], "UVt0", self.cfg)
        self.assertEqual(img[0x2E90:0x2E98], self.fac[0x2E90:0x2E98])
        # +0x320C is movi r0, 58 (register 0x3A) and +0x3214 is movi r2, 0x8FFF.
        # That mask is not applied to register 0x58, and this patch does not touch it.
        self.assertEqual(img[0x320C:0x3224], self.fac[0x320C:0x3224])
        self.assertEqual(int.from_bytes(self.fac[0x3216:0x3218], "little"), 0x8FFF)

    def test_ctcss_hpf_keep_alone(self):
        img, sites = build.build(["ctcss-hpf-keep"], "UVt0", self.cfg)
        self.assertEqual(len(sites), 1)
        self.assertEqual(sites[0][0], 0x333A)
        self.assertEqual(img[0x3338:0x333A], bytes.fromhex("03ea"))  # movi r3 opcode halfword
        self.assertEqual(img[0x333A:0x333C], bytes.fromhex("ffff"))
        self.assertEqual(self.fac[0x3338:0x333C], bytes.fromhex("03eaf7ff"))

    def test_c7000_stub_branches(self):
        img, _ = build.build(["c7000-fm-flat"], "UVt0", self.cfg)
        self.assertEqual(bsr32_target(self.fac, 0x3074), 0xFD011220)   # factory: AT1846S write
        self.assertEqual(bsr32_target(img, 0x3074), 0x5B000)           # patched: stub
        self.assertEqual(bsr32_target(img, 0x5B002), 0xFD011220)       # stub performs the write
        pool = [int.from_bytes(img[0x5B014 + 4 * k:0x5B018 + 4 * k], "little") for k in range(3)]
        self.assertEqual(pool, [0x11000500, 0x11000504, 0x000F1010])
        self.assertEqual((pool[2] >> 16) & 0xFF, 0x0F)
        self.assertTrue(all(b == 0 for b in self.fac[0x5AEFC:]), "zero tail")

    def test_c7000_canary_lowers_limiter_only(self):
        img, _ = build.build(["c7000-fm-canary"], "UVt0", self.cfg)
        flat, _ = build.build(["c7000-fm-flat"], "UVt0", self.cfg)
        self.assertEqual(bsr32_target(img, 0x3074), 0x5B000)
        self.assertEqual(bsr32_target(img, 0x5B002), 0xFD011220)
        pool = [int.from_bytes(img[0x5B014 + 4 * k:0x5B018 + 4 * k], "little") for k in range(3)]
        self.assertEqual(pool, [0x11000500, 0x11000504, 0x00021010])
        lim = (pool[2] >> 16) & 0xFF
        self.assertEqual(lim, 0x02)
        self.assertLess(lim, 0x0F)
        # The two stubs differ only in that limiter byte.
        differ = [i for i, (a, b) in enumerate(zip(flat, img)) if a != b]
        self.assertEqual(differ, [0x5B01E])
        self.assertEqual(img[0x5B01C:0x5B020], bytes.fromhex("10100200"))

    def test_c7000_proof_writes_reg58_from_the_stub(self):
        img, _ = build.build(["c7000-fm-proof"], "UVt0", self.cfg)
        self.assertEqual(bsr32_target(img, 0x3074), 0x5B000)
        self.assertEqual(bsr32_target(img, 0x5B002), 0xFD011220)   # redirected 0x3A write
        self.assertEqual(bsr32_target(img, 0x5B018), 0xFD011220)   # the proof write
        self.assertEqual(int.from_bytes(img[0x5B016:0x5B018], "little"), 0x84C5)
        self.assertEqual(img[0x5B012:0x5B014], bytes.fromhex("5830"))  # movi r0, 88
        pool = [int.from_bytes(img[0x5B020 + 4 * k:0x5B024 + 4 * k], "little") for k in range(3)]
        self.assertEqual(pool, [0x11000500, 0x11000504, 0x000F1010])
        self.assertEqual((pool[2] >> 16) & 0xFF, 0x0F)
        for off in (0x2C90, 0x3054, 0x344E, 0x34F2, 0x3640):
            self.assertEqual(img[off:off + 2], self.fac[off:off + 2])
            self.assertEqual(img[off:off + 2], bytes.fromhex("0584"))

    def test_refuses_bad_tag(self):
        for tag in ("UV4T", "UV4", "UV-1"):
            with self.subTest(tag=tag), self.assertRaises(SystemExit):
                build.build([], tag, self.cfg)

    def test_unknown_patch(self):
        with self.assertRaises(SystemExit):
            build.build(["version-from-image"], "UVt0", self.cfg)


if __name__ == "__main__":
    unittest.main()
