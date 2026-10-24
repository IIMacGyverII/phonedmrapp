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


def bsr32_disp(img, at):
    """Signed byte displacement of a C-SKY V2 32-bit bsr (high halfword stored first)."""
    hi = int.from_bytes(img[at:at + 2], "little")
    lo = int.from_bytes(img[at + 2:at + 4], "little")
    word = (hi << 16) | lo
    assert word >> 26 == 0b111000, f"not a bsr32 at 0x{at:X}: {word:08X}"
    off = (word & 0x3FFFFFF) << 1
    if off & (1 << 26):
        off -= 1 << 27
    return off


def bsr32_target(img, at):
    """Decode a bsr as if `at` were the runtime PC. File offsets match XIP code only."""
    return (at + bsr32_disp(img, at)) & 0xFFFFFFFF


def bsr32_runtime(img, at):
    """Runtime address of a bsr whose PC is XIP + file offset."""
    return (0x0301A000 + at + bsr32_disp(img, at)) & 0xFFFFFFFF


def br16_target(img, at):
    """File offset reached by a 16-bit br. Displacement is in halfwords from `at`."""
    hw = int.from_bytes(img[at:at + 2], "little")
    assert hw >> 10 == 1, f"not a br16 at 0x{at:X}: {hw:04X}"
    disp = hw & 0x3FF
    if disp & 0x200:
        disp -= 0x400
    return at + disp * 2


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
        # The 0x58 variants share five immediates, and the C7000 stubs share the
        # redirect plus the tail. One from each group, plus the shared mask patch.
        # c7000-fm-adcgain, c7000-txram-square and c7000-txram-dmr share the tail
        # with the other stubs and are not in this set.
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
            ["c7000-fm-flat", "c7000-fm-adcgain"],
            ["c7000-fm-canary", "c7000-fm-adcgain"],
            ["c7000-fm-proof", "c7000-fm-adcgain"],
            ["c7000-fm-flat", "c7000-txram-square"],
            ["c7000-fm-canary", "c7000-txram-square"],
            ["c7000-fm-proof", "c7000-txram-square"],
            ["c7000-fm-adcgain", "c7000-txram-square"],
            ["c7000-fm-flat", "c7000-txram-dmr"],
            ["c7000-fm-canary", "c7000-txram-dmr"],
            ["c7000-fm-proof", "c7000-txram-dmr"],
            ["c7000-fm-adcgain", "c7000-txram-dmr"],
            ["c7000-txram-square", "c7000-txram-dmr"],
            ["c7000-fm-flat", "c7000-txram-dmr-a512"],
            ["c7000-fm-canary", "c7000-txram-dmr-a512"],
            ["c7000-fm-proof", "c7000-txram-dmr-a512"],
            ["c7000-fm-adcgain", "c7000-txram-dmr-a512"],
            ["c7000-txram-square", "c7000-txram-dmr-a512"],
            ["c7000-txram-dmr", "c7000-txram-dmr-a512"],
            ["c7000-fm-flat", "c7000-txram-dmr-a1024"],
            ["c7000-fm-canary", "c7000-txram-dmr-a1024"],
            ["c7000-fm-proof", "c7000-txram-dmr-a1024"],
            ["c7000-fm-adcgain", "c7000-txram-dmr-a1024"],
            ["c7000-txram-square", "c7000-txram-dmr-a1024"],
            ["c7000-txram-dmr", "c7000-txram-dmr-a1024"],
            ["c7000-txram-dmr-a512", "c7000-txram-dmr-a1024"],
            ["c7000-fm-flat", "c7000-txram-dmr-a2048"],
            ["c7000-fm-canary", "c7000-txram-dmr-a2048"],
            ["c7000-fm-proof", "c7000-txram-dmr-a2048"],
            ["c7000-fm-adcgain", "c7000-txram-dmr-a2048"],
            ["c7000-txram-square", "c7000-txram-dmr-a2048"],
            ["c7000-txram-dmr", "c7000-txram-dmr-a2048"],
            ["c7000-txram-dmr-a512", "c7000-txram-dmr-a2048"],
            ["c7000-txram-dmr-a1024", "c7000-txram-dmr-a2048"],
            ["c7000-fm-flat", "c7000-txram-dmr-a4096"],
            ["c7000-fm-canary", "c7000-txram-dmr-a4096"],
            ["c7000-fm-proof", "c7000-txram-dmr-a4096"],
            ["c7000-fm-adcgain", "c7000-txram-dmr-a4096"],
            ["c7000-txram-square", "c7000-txram-dmr-a4096"],
            ["c7000-txram-dmr", "c7000-txram-dmr-a4096"],
            ["c7000-txram-dmr-a512", "c7000-txram-dmr-a4096"],
            ["c7000-txram-dmr-a1024", "c7000-txram-dmr-a4096"],
            ["c7000-txram-dmr-a2048", "c7000-txram-dmr-a4096"],
            ["c7000-fm-flat", "c7000-txram-dmr-sine1k"],
            ["c7000-fm-canary", "c7000-txram-dmr-sine1k"],
            ["c7000-fm-proof", "c7000-txram-dmr-sine1k"],
            ["c7000-fm-adcgain", "c7000-txram-dmr-sine1k"],
            ["c7000-txram-square", "c7000-txram-dmr-sine1k"],
            ["c7000-txram-dmr", "c7000-txram-dmr-sine1k"],
            ["c7000-txram-dmr-a512", "c7000-txram-dmr-sine1k"],
            ["c7000-txram-dmr-a1024", "c7000-txram-dmr-sine1k"],
            ["c7000-txram-dmr-a2048", "c7000-txram-dmr-sine1k"],
            ["c7000-txram-dmr-a4096", "c7000-txram-dmr-sine1k"],
            ["c7000-fm-flat", "c7000-txram-dmr-sine1k-p4096"],
            ["c7000-fm-canary", "c7000-txram-dmr-sine1k-p4096"],
            ["c7000-fm-proof", "c7000-txram-dmr-sine1k-p4096"],
            ["c7000-fm-adcgain", "c7000-txram-dmr-sine1k-p4096"],
            ["c7000-txram-square", "c7000-txram-dmr-sine1k-p4096"],
            ["c7000-txram-dmr", "c7000-txram-dmr-sine1k-p4096"],
            ["c7000-txram-dmr-a512", "c7000-txram-dmr-sine1k-p4096"],
            ["c7000-txram-dmr-a1024", "c7000-txram-dmr-sine1k-p4096"],
            ["c7000-txram-dmr-a2048", "c7000-txram-dmr-sine1k-p4096"],
            ["c7000-txram-dmr-a4096", "c7000-txram-dmr-sine1k-p4096"],
            ["c7000-txram-dmr-sine1k", "c7000-txram-dmr-sine1k-p4096"],
            ["c7000-fm-flat", "c7000-txram-dmr-sine1k-p5120"],
            ["c7000-fm-canary", "c7000-txram-dmr-sine1k-p5120"],
            ["c7000-fm-proof", "c7000-txram-dmr-sine1k-p5120"],
            ["c7000-fm-adcgain", "c7000-txram-dmr-sine1k-p5120"],
            ["c7000-txram-square", "c7000-txram-dmr-sine1k-p5120"],
            ["c7000-txram-dmr", "c7000-txram-dmr-sine1k-p5120"],
            ["c7000-txram-dmr-a512", "c7000-txram-dmr-sine1k-p5120"],
            ["c7000-txram-dmr-a1024", "c7000-txram-dmr-sine1k-p5120"],
            ["c7000-txram-dmr-a2048", "c7000-txram-dmr-sine1k-p5120"],
            ["c7000-txram-dmr-a4096", "c7000-txram-dmr-sine1k-p5120"],
            ["c7000-txram-dmr-sine1k", "c7000-txram-dmr-sine1k-p5120"],
            ["c7000-txram-dmr-sine1k-p4096", "c7000-txram-dmr-sine1k-p5120"],
            ["c7000-fm-flat", "c7000-txram-dmr-rrc"],
            ["c7000-fm-canary", "c7000-txram-dmr-rrc"],
            ["c7000-fm-proof", "c7000-txram-dmr-rrc"],
            ["c7000-fm-adcgain", "c7000-txram-dmr-rrc"],
            ["c7000-txram-square", "c7000-txram-dmr-rrc"],
            ["c7000-txram-dmr", "c7000-txram-dmr-rrc"],
            ["c7000-txram-dmr-a512", "c7000-txram-dmr-rrc"],
            ["c7000-txram-dmr-a1024", "c7000-txram-dmr-rrc"],
            ["c7000-txram-dmr-a2048", "c7000-txram-dmr-rrc"],
            ["c7000-txram-dmr-a4096", "c7000-txram-dmr-rrc"],
            ["c7000-txram-dmr-sine1k", "c7000-txram-dmr-rrc"],
            ["c7000-txram-dmr-sine1k-p4096", "c7000-txram-dmr-rrc"],
            ["c7000-txram-dmr-sine1k-p5120", "c7000-txram-dmr-rrc"],
        ]
        # R4b uses the same call sites, stub and table window as R4a.
        partners = [p[0] for p in pairs if p[1] == "c7000-txram-dmr-rrc"]
        pairs.extend([[left, "c7000-txram-m17-lsf"] for left in partners])
        pairs.append(["c7000-txram-dmr-rrc", "c7000-txram-m17-lsf"])
        # R4c overlaps those call sites, the stub, and the whole zero tail.
        pairs.extend([[left, "c7000-txram-m17-stream"] for left in partners])
        pairs.append(["c7000-txram-dmr-rrc", "c7000-txram-m17-stream"])
        pairs.append(["c7000-txram-m17-lsf", "c7000-txram-m17-stream"])
        # R4d adds the two service-wake sites on top of the R4c window.
        pairs.extend([[left, "c7000-txram-m17-wake"] for left in partners])
        pairs.append(["c7000-txram-dmr-rrc", "c7000-txram-m17-wake"])
        pairs.append(["c7000-txram-m17-lsf", "c7000-txram-m17-wake"])
        pairs.append(["c7000-txram-m17-stream", "c7000-txram-m17-wake"])
        # R4e uses the same windows as R4d. The cursor wraps instead of ending.
        pairs.extend([[left, "c7000-txram-m17-loop"] for left in partners])
        pairs.append(["c7000-txram-dmr-rrc", "c7000-txram-m17-loop"])
        pairs.append(["c7000-txram-m17-lsf", "c7000-txram-m17-loop"])
        pairs.append(["c7000-txram-m17-stream", "c7000-txram-m17-loop"])
        pairs.append(["c7000-txram-m17-wake", "c7000-txram-m17-loop"])
        # R4f uses the same windows as R4e. The table stops before the end frame.
        pairs.extend([[left, "c7000-txram-m17-loop5"] for left in partners])
        pairs.append(["c7000-txram-dmr-rrc", "c7000-txram-m17-loop5"])
        pairs.append(["c7000-txram-m17-lsf", "c7000-txram-m17-loop5"])
        pairs.append(["c7000-txram-m17-stream", "c7000-txram-m17-loop5"])
        pairs.append(["c7000-txram-m17-wake", "c7000-txram-m17-loop5"])
        pairs.append(["c7000-txram-m17-loop", "c7000-txram-m17-loop5"])
        # R4g uses the same windows as R4f. The payload bytes are 0 through 15.
        pairs.extend([[left, "c7000-txram-m17-pay16"] for left in partners])
        pairs.append(["c7000-txram-dmr-rrc", "c7000-txram-m17-pay16"])
        pairs.append(["c7000-txram-m17-lsf", "c7000-txram-m17-pay16"])
        pairs.append(["c7000-txram-m17-stream", "c7000-txram-m17-pay16"])
        pairs.append(["c7000-txram-m17-wake", "c7000-txram-m17-pay16"])
        pairs.append(["c7000-txram-m17-loop", "c7000-txram-m17-pay16"])
        pairs.append(["c7000-txram-m17-loop5", "c7000-txram-m17-pay16"])
        # R4h fills the file through EOF. Frame 5, end bit clear.
        pairs.extend([[left, "c7000-txram-m17-lich5"] for left in partners])
        pairs.append(["c7000-txram-dmr-rrc", "c7000-txram-m17-lich5"])
        pairs.append(["c7000-txram-m17-lsf", "c7000-txram-m17-lich5"])
        pairs.append(["c7000-txram-m17-stream", "c7000-txram-m17-lich5"])
        pairs.append(["c7000-txram-m17-wake", "c7000-txram-m17-lich5"])
        pairs.append(["c7000-txram-m17-loop", "c7000-txram-m17-lich5"])
        pairs.append(["c7000-txram-m17-loop5", "c7000-txram-m17-lich5"])
        pairs.append(["c7000-txram-m17-pay16", "c7000-txram-m17-lich5"])
        # R4i adds the end frame in the gap and the prefix ahead of the stub.
        pairs.extend([[left, "c7000-txram-m17-eot1"] for left in partners])
        pairs.append(["c7000-txram-dmr-rrc", "c7000-txram-m17-eot1"])
        pairs.append(["c7000-txram-m17-lsf", "c7000-txram-m17-eot1"])
        pairs.append(["c7000-txram-m17-stream", "c7000-txram-m17-eot1"])
        pairs.append(["c7000-txram-m17-wake", "c7000-txram-m17-eot1"])
        pairs.append(["c7000-txram-m17-loop", "c7000-txram-m17-eot1"])
        pairs.append(["c7000-txram-m17-loop5", "c7000-txram-m17-eot1"])
        pairs.append(["c7000-txram-m17-pay16", "c7000-txram-m17-eot1"])
        pairs.append(["c7000-txram-m17-lich5", "c7000-txram-m17-eot1"])
        # R4j uses the same windows as R4i. on_unkey returns instead of waiting.
        pairs.extend([[left, "c7000-txram-m17-eot2"] for left in partners])
        pairs.append(["c7000-txram-dmr-rrc", "c7000-txram-m17-eot2"])
        pairs.append(["c7000-txram-m17-lsf", "c7000-txram-m17-eot2"])
        pairs.append(["c7000-txram-m17-stream", "c7000-txram-m17-eot2"])
        pairs.append(["c7000-txram-m17-wake", "c7000-txram-m17-eot2"])
        pairs.append(["c7000-txram-m17-loop", "c7000-txram-m17-eot2"])
        pairs.append(["c7000-txram-m17-loop5", "c7000-txram-m17-eot2"])
        pairs.append(["c7000-txram-m17-pay16", "c7000-txram-m17-eot2"])
        pairs.append(["c7000-txram-m17-lich5", "c7000-txram-m17-eot2"])
        pairs.append(["c7000-txram-m17-eot1", "c7000-txram-m17-eot2"])
        # R4k uses the same windows. drop_ptt also posts the stop status.
        pairs.extend([[left, "c7000-txram-m17-eot3"] for left in partners])
        pairs.append(["c7000-txram-dmr-rrc", "c7000-txram-m17-eot3"])
        pairs.append(["c7000-txram-m17-lsf", "c7000-txram-m17-eot3"])
        pairs.append(["c7000-txram-m17-stream", "c7000-txram-m17-eot3"])
        pairs.append(["c7000-txram-m17-wake", "c7000-txram-m17-eot3"])
        pairs.append(["c7000-txram-m17-loop", "c7000-txram-m17-eot3"])
        pairs.append(["c7000-txram-m17-loop5", "c7000-txram-m17-eot3"])
        pairs.append(["c7000-txram-m17-pay16", "c7000-txram-m17-eot3"])
        pairs.append(["c7000-txram-m17-lich5", "c7000-txram-m17-eot3"])
        pairs.append(["c7000-txram-m17-eot1", "c7000-txram-m17-eot3"])
        pairs.append(["c7000-txram-m17-eot2", "c7000-txram-m17-eot3"])
        # R4m uses the same gap as the M17 prefixes, and the same slot as R4l.
        pairs.append(["c7000-cmd40-ack", "c7000-cmd40-ack2"])
        pairs.append(["c7000-txram-m17-eot1", "c7000-cmd40-ack2"])
        pairs.append(["c7000-txram-m17-eot2", "c7000-cmd40-ack2"])
        pairs.append(["c7000-txram-m17-eot3", "c7000-cmd40-ack2"])
        pairs.append(["c7000-cmd40-ack", "c7000-cmd40-echo"])
        pairs.append(["c7000-cmd40-ack2", "c7000-cmd40-echo"])
        pairs.append(["c7000-txram-m17-eot1", "c7000-cmd40-echo"])
        pairs.append(["c7000-txram-m17-eot2", "c7000-cmd40-echo"])
        pairs.append(["c7000-txram-m17-eot3", "c7000-cmd40-echo"])
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

    def test_c7000_adcgain_lowers_live_gcr_adcl_by_6db(self):
        img, _ = build.build(["c7000-fm-adcgain"], "UVt0", self.cfg)
        self.assertEqual(bsr32_target(img, 0x3074), 0x5B000)
        self.assertEqual(bsr32_target(img, 0x5B002), 0xFD011220)
        # The byte after the redirected write is the C7000 stores, not a second
        # AT1846S write. 0x84C5 is not in the stub.
        self.assertNotIn(bytes.fromhex("c584"), img[0x5B000:0x5B030])
        self.assertEqual(int.from_bytes(img[0x5B016:0x5B018], "little"), 0x2A7C)  # subi r2, 125
        self.assertEqual((-125) & 0xFF, 0x83)
        self.assertEqual(img[0x5B018:0x5B01C], bytes.fromhex("43dce500"))  # st.b r2, (r3, 0xe5)
        pool = [int.from_bytes(img[0x5B020 + 4 * k:0x5B024 + 4 * k], "little") for k in range(4)]
        self.assertEqual(pool, [0x11000500, 0x11000504, 0x000F1010, 0x16000900])
        # 0x61F4's three gains, each 6 counts lower. The 0 dB floor stays.
        self.assertEqual(int.from_bytes(img[0x61FE:0x6200], "little"), 0x2B7A)  # 123 -> 0x85
        self.assertEqual(int.from_bytes(img[0x620C:0x620E], "little"), 0x2B7D)  # 126 -> 0x82
        self.assertEqual(int.from_bytes(img[0x6228:0x622A], "little"), 0x2B7C)  # 125 -> 0x83
        self.assertEqual(img[0x6238:0x623A], self.fac[0x6238:0x623A])
        self.assertEqual(int.from_bytes(self.fac[0x6238:0x623A], "little"), 0x2B7F)
        self.assertEqual((-123) & 0xFF, 0x85)
        self.assertEqual((-126) & 0xFF, 0x82)
        self.assertEqual((-125) & 0xFF, 0x83)
        # Init's 0x8B store and the five factory 0x8405 immediates stay.
        self.assertEqual(img[0x6540:0x6542], self.fac[0x6540:0x6542])
        for off in (0x2C90, 0x3054, 0x344E, 0x34F2, 0x3640):
            self.assertEqual(img[off:off + 2], bytes.fromhex("0584"))

    def test_c7000_dacgain_lowers_every_table_slot_by_6db(self):
        # Guide 6.5.2.25: godl bit 5 clear is 0..-31 dB; bit 5 set counts backwards, +1..+32 dB.
        def db(byte):
            godl = byte & 0x3F
            return (32 - (godl & 0x1F)) if godl & 0x20 else -godl

        img, _ = build.build(["c7000-fm-dacgain"], "UVt0", self.cfg)
        fac = self.fac[0x36ED0:0x36EE4]
        new = img[0x36ED0:0x36EE4]
        self.assertEqual(fac.hex(), "800088008200bc00b700b400b000ae00aa00a800")
        self.assertEqual(new.hex(), "86008e0088008200bd00ba00b600b400b000ae00")
        for i in range(10):
            a, b = fac[2 * i], new[2 * i]
            self.assertEqual(fac[2 * i + 1], 0)
            self.assertEqual(new[2 * i + 1], 0)
            self.assertTrue(a & 0x80 and b & 0x80, "lrgod stays set")
            self.assertEqual(db(b), db(a) - 6, "slot %d 0x%02X -> 0x%02X" % (i, a, b))
        # The three loaders still OR 0x80 and store offset 0xDF. Init's 0xAB is not the live value.
        for off in (0xADE, 0xE16, 0x61E8):
            self.assertEqual(img[off:off + 2], bytes.fromhex("8874"))  # zextb r2
        self.assertEqual(img[0x6538:0x653A], bytes.fromhex("542b"))  # subi r3, 85
        # No stub, and the ADC-gain sites and the factory 0x58 immediates stay.
        self.assertEqual(img[0x3074:0x3078], self.fac[0x3074:0x3078])
        self.assertEqual(img[0x5B000:0x5B030], self.fac[0x5B000:0x5B030])
        for off in (0x61FE, 0x620C, 0x6228, 0x6238):
            self.assertEqual(img[off:off + 2], self.fac[off:off + 2])
        for off in (0x2C90, 0x3054, 0x344E, 0x34F2, 0x3640):
            self.assertEqual(img[off:off + 2], bytes.fromhex("0584"))
        self.assertEqual(img[0x38464:0x38474], b"DMR003.UVt0.V022")

    def test_txram_square_fills_after_the_voice_source_clear(self):
        img, _ = build.build(["c7000-txram-square"], "UVt0", self.cfg)
        # +0x3EDF8 is bclri r2, 0 / st.w (the clear). The patch starts at the next instruction.
        self.assertEqual(self.fac[0x3EDF8:0x3EDFC], bytes.fromhex("803a40b3"))
        self.assertEqual(img[0x3EDF8:0x3EDFC], self.fac[0x3EDF8:0x3EDFC])
        # The hooked bytes execute at IRAM 0x159F4, not at the file offset.
        self.assertEqual(img[0x3EDFC:0x3EE02], bytes.fromhex("82e106fb0030"))
        disp = bsr32_disp(img, 0x3EDFC)
        self.assertEqual((0x159F4 + disp) & 0xFFFFFFFF, 0x03075000)
        self.assertNotEqual(bsr32_target(img, 0x3EDFC), 0x5B000)
        self.assertEqual(img[0x3EE00:0x3EE02], bytes.fromhex("0030"))  # pad, movi r0, 0
        self.assertEqual(img[0x3EE02:0x3EE04], bytes.fromhex("3230"))  # movi r0, 50, the delay
        self.assertEqual(self.fac[0x3EE02:0x3EE04], bytes.fromhex("3230"))

        xip = 0x0301A000
        flag = 0x4DAAC
        # Boot zeroes this word and the factory image never names it. Not 0x31AF4.
        self.assertTrue(0x31AF4 < flag < 0x4DAB0)
        self.assertEqual(flag & 3, 0)
        self.assertEqual(self.fac.find(flag.to_bytes(4, "little")), -1)
        # The 0x26 sites are flash-resident (below the IRAM copy).
        self.assertLess(0x929C, 0x39408)
        self.assertLess(0x92B2, 0x39408)

        def hw(off):
            return int.from_bytes(img[off:off + 2], "little")

        def bt_file(off):
            word = hw(off)
            self.assertEqual(word & 0xFC00, 0x0800, "not a 16-bit bt")
            imm = word & 0x3FF
            if imm & 0x200:
                imm -= 0x400
            return off + (imm << 1)

        def rt(file_pc, file_tgt):
            """Runtime target of a PC-relative branch. Stub and 0x26 handler both run at XIP."""
            disp = file_tgt - file_pc
            return (file_pc + xip + disp) & 0xFFFFFFFF

        # Flag zero falls through into the factory PTT store and returns.
        # Layout is c7000_txram_square.S linked at file 0x5B000.
        self.assertEqual(bt_file(0x5B006), 0x5B010)
        self.assertEqual(rt(0x5B006, 0x5B010), xip + 0x5B010)
        self.assertEqual(hw(0x5B00A), 0x3201)  # movi r2, 1
        self.assertEqual(hw(0x5B00C), 0xB340)  # st.w
        self.assertEqual(hw(0x5B00E), 0x783C)  # jmp r15, before any TX-RAM store
        # Taken path is the square. Bit 4 is not set.
        self.assertEqual(hw(0x5B014), 0x3AA0)  # bseti r2, 0
        self.assertEqual(hw(0x5B01C), 0x3A84)  # bclri r2, 4
        self.assertEqual(hw(0x5B01E), 0x3A86)  # bclri r2, 6
        self.assertNotIn((0x3AA4).to_bytes(2, "little"), img[0x5B000:0x5B04C])
        self.assertEqual(hw(0x5B024), 0x3101)  # movi r1, 1 -> +256
        self.assertEqual(hw(0x5B034), 0x31FF)  # movi r1, 255 -> -256
        self.assertEqual(img[0x5B026:0x5B02A], bytes.fromhex("02ea0001"))  # movi r2, 256
        self.assertEqual(img[0x5B036:0x5B03A], bytes.fromhex("02ea0001"))
        self.assertEqual(hw(0x5B02A), 0xAB20)  # st.h r1, (r3, 0)
        self.assertEqual(bt_file(0x5B032), 0x5B02A)
        self.assertEqual(rt(0x5B032, 0x5B02A), xip + 0x5B02A)
        self.assertEqual(bt_file(0x5B042), 0x5B03A)
        self.assertEqual(rt(0x5B042, 0x5B03A), xip + 0x5B03A)
        self.assertEqual(hw(0x5B046), 0x3201)  # movi r2, 1
        self.assertEqual(hw(0x5B048), 0xB340)  # st.w PTT, after both fills
        self.assertEqual(hw(0x5B04A), 0x783C)  # jmp r15
        # set_flag / clear_flag, reached from the 0x26 handler.
        self.assertEqual((0x92B2 + xip + bsr32_disp(img, 0x92B2)) & 0xFFFFFFFF, xip + 0x5B04C)
        self.assertEqual((0x929C + xip + bsr32_disp(img, 0x929C)) & 0xFFFFFFFF, xip + 0x5B058)
        self.assertEqual(hw(0x5B04E), 0x3201)  # movi r2, 1
        self.assertEqual(hw(0x5B050), 0xB340)  # st.w flag
        self.assertEqual(hw(0x5B052), 0x3001)  # movi r0, 1
        self.assertEqual(hw(0x5B054), 0x3101)  # movi r1, 1
        self.assertEqual(hw(0x5B056), 0x783C)
        self.assertEqual(hw(0x5B05A), 0x3300)  # movi r3, 0
        self.assertEqual(hw(0x5B05C), 0xB260)  # st.w r3, (r2, 0)
        self.assertEqual(hw(0x5B060), 0x783C)
        # The instruction after each handler patch is the factory one.
        self.assertEqual(img[0x92B6:0x92BA], self.fac[0x92B6:0x92BA])
        self.assertEqual(img[0x92A0:0x92A2], self.fac[0x92A0:0x92A2])
        pool = [int.from_bytes(img[0x5B064 + 4 * k:0x5B068 + 4 * k], "little") for k in range(6)]
        self.assertEqual(pool, [flag, 0x11000560, 0x11000080, 0x11000500, 0x16000030, 0x38874])
        # Not the tune-time redirect, the pad byte, or a 0x58 immediate.
        self.assertEqual(img[0x3074:0x3078], self.fac[0x3074:0x3078])
        self.assertEqual(img[0x3EE16:0x3EE18], self.fac[0x3EE16:0x3EE18])
        for off in (0x2C90, 0x3054, 0x344E, 0x34F2, 0x3640):
            self.assertEqual(img[off:off + 2], bytes.fromhex("0584"))

    def test_txram_dmr_arms_the_square_from_the_host_key(self):
        img, _ = build.build(["c7000-txram-dmr"], "R3a3", self.cfg)
        xip = 0x0301A000

        def hw(off):
            return int.from_bytes(img[off:off + 2], "little")

        def word(off):
            return int.from_bytes(img[off:off + 4], "little")

        def bt_file(off):
            raw = hw(off)
            self.assertEqual(raw & 0xFC00, 0x0800, "not a 16-bit bt")
            imm = raw & 0x3FF
            if imm & 0x200:
                imm -= 0x400
            return off + (imm << 1)

        # Both launch=1 sites call on_key. Both launch=2 sites call on_unkey.
        # File-offset displacement is the XIP displacement (the base cancels).
        for site in (0x92C8, 0x92E0):
            self.assertEqual(bsr32_target(self.fac, site), 0xE9C)
            self.assertEqual(bsr32_target(img, site), 0x5B000)
            self.assertEqual((site + xip + bsr32_disp(img, site)) & 0xFFFFFFFF, xip + 0x5B000)
        for site in (0x92AA, 0x92FA):
            self.assertEqual(bsr32_target(self.fac, site), 0xE9C)
            self.assertEqual(bsr32_target(img, site), 0x5B088)
            self.assertEqual((site + xip + bsr32_disp(img, site)) & 0xFFFFFFFF, xip + 0x5B088)
        # The instruction after each replaced bsr is the factory one. R3a2's
        # sites and the other 0xe9c caller stay factory.
        for off in (0x92CC, 0x92E4, 0x92AE, 0x92FE, 0x92B2, 0x929C, 0x9364):
            self.assertEqual(img[off:off + 4], self.fac[off:off + 4])

        # on_key: save the handler's r4-r8, post the event, then the DMR path.
        self.assertEqual(hw(0x5B000), 0x14D5)  # push r4-r8, r15
        self.assertEqual(bsr32_target(img, 0x5B002), 0xE9C)
        self.assertEqual((0x5B002 + xip + bsr32_disp(img, 0x5B002)) & 0xFFFFFFFF, xip + 0xE9C)
        self.assertEqual(hw(0x5B008), 0x3387)  # movi r3, 135
        self.assertEqual(hw(0x5B00A), 0x4365)  # lsli r3, 5 -> 0x10E0
        self.assertEqual(hw(0x5B010), 0x3280)  # movi r2, 128 -> WORK_MODE 0x80
        self.assertEqual(hw(0x5B018), 0x3AA0)  # bseti r2, 0
        self.assertEqual(hw(0x5B020), 0x3A84)  # bclri r2, 4
        self.assertEqual(hw(0x5B022), 0x3A86)  # bclri r2, 6
        self.assertNotIn((0x3AA4).to_bytes(2, "little"), img[0x5B000:0x5B0BC])
        self.assertEqual(hw(0x5B028), 0x3101)  # movi r1, 1 -> +256
        self.assertEqual(hw(0x5B038), 0x31FF)  # movi r1, 255 -> -256
        self.assertEqual(img[0x5B02A:0x5B02E], bytes.fromhex("02ea0001"))
        self.assertEqual(img[0x5B03A:0x5B03E], bytes.fromhex("02ea0001"))
        self.assertEqual(hw(0x5B02E), 0xAB20)  # st.h
        self.assertEqual(hw(0x5B03E), 0xAB20)
        self.assertEqual(bt_file(0x5B036), 0x5B02E)
        self.assertEqual(bt_file(0x5B046), 0x5B03E)
        # 0x30 = 0x4006, then 0x4026, then 0x58 = 0xBCFD, each via the IRAM write.
        self.assertEqual(hw(0x5B048), 0x3030)
        self.assertEqual(word(0x5B04A), 0x4006EA01)
        self.assertEqual(bsr32_target(img, 0x5B04E), 0xFD011220)
        self.assertEqual((0x5B04E + xip + bsr32_disp(img, 0x5B04E)) & 0xFFFFFFFF, 0x2B220)
        self.assertEqual(word(0x5B054), 0x4026EA01)
        self.assertEqual(bsr32_target(img, 0x5B058), 0xFD011220)
        self.assertEqual((0x5B058 + xip + bsr32_disp(img, 0x5B058)) & 0xFFFFFFFF, 0x2B220)
        self.assertEqual(hw(0x5B05C), 0x3058)  # movi r0, 88
        self.assertEqual(word(0x5B05E), 0xBCFDEA01)
        self.assertEqual(bsr32_target(img, 0x5B062), 0xFD011220)
        self.assertEqual((0x5B062 + xip + bsr32_disp(img, 0x5B062)) & 0xFFFFFFFF, 0x2B220)
        self.assertEqual(hw(0x5B068), 0x3201)  # movi r2, 1
        self.assertEqual(hw(0x5B06A), 0xB340)  # st.w PTT, after the fills and the writes
        self.assertEqual(hw(0x5B06C), 0x1495)  # pop r4-r8, r15, before the pool
        pool = [word(0x5B070 + 4 * k) for k in range(6)]
        self.assertEqual(pool, [0x11000104, 0x11000100, 0x11000080, 0x11000500, 0x16000030, 0x11000560])

        # on_unkey restores PTT, the TX-RAM bit, and the wide-FM AT1846S pair.
        self.assertEqual(hw(0x5B088), 0x14D5)
        self.assertEqual(bsr32_target(img, 0x5B08A), 0xE9C)
        self.assertEqual(hw(0x5B090), 0x3200)  # movi r2, 0
        self.assertEqual(hw(0x5B092), 0xB340)
        self.assertEqual(hw(0x5B098), 0x3A80)  # bclri r2, 0
        self.assertEqual(hw(0x5B09C), 0x3058)
        self.assertEqual(word(0x5B09E), 0x8405EA01)
        self.assertEqual(bsr32_target(img, 0x5B0A2), 0xFD011220)
        self.assertEqual((0x5B0A2 + xip + bsr32_disp(img, 0x5B0A2)) & 0xFFFFFFFF, 0x2B220)
        self.assertEqual(word(0x5B0A8), 0x7026EA01)
        self.assertEqual(bsr32_target(img, 0x5B0AC), 0xFD011220)
        self.assertEqual((0x5B0AC + xip + bsr32_disp(img, 0x5B0AC)) & 0xFFFFFFFF, 0x2B220)
        self.assertEqual(hw(0x5B0B0), 0x1495)
        self.assertEqual([word(0x5B0B4), word(0x5B0B8)], [0x11000560, 0x11000080])

        # Not the tune redirect, the key-up hook, the pad byte, or a 0x58 immediate.
        self.assertEqual(img[0x3074:0x3078], self.fac[0x3074:0x3078])
        self.assertEqual(img[0x3EDFC:0x3EE02], self.fac[0x3EDFC:0x3EE02])
        self.assertEqual(img[0x3EE16:0x3EE18], self.fac[0x3EE16:0x3EE18])
        for off in (0x2C90, 0x3054, 0x344E, 0x34F2, 0x3640, 0x2E94):
            self.assertEqual(img[off:off + 2], self.fac[off:off + 2])
        self.assertEqual(img[0x38464:0x38474], b"DMR003.R3a3.V022")

    def test_txram_dmr_a512_changes_only_the_two_fill_immediates(self):
        # R3a4. One 6 dB step. The measured R3a3 bytes stay buildable.
        quiet, _ = build.build(["c7000-txram-dmr"], "R3a3", self.cfg)
        loud, _ = build.build(["c7000-txram-dmr-a512"], "R3a4", self.cfg)
        diff = [i for i, (a, b) in enumerate(zip(quiet, loud)) if a != b]
        self.assertEqual(diff, [0x3846E, 0x5B028, 0x5B038])
        self.assertEqual(int.from_bytes(loud[0x5B028:0x5B02A], "little"), 0x3102)
        self.assertEqual(int.from_bytes(loud[0x5B038:0x5B03A], "little"), 0x31FE)
        self.assertNotIn((0x3AA4).to_bytes(2, "little"), loud[0x5B000:0x5B0BC])
        self.assertEqual(loud[0x3074:0x3078], self.fac[0x3074:0x3078])
        self.assertEqual(loud[0x3EDFC:0x3EE02], self.fac[0x3EDFC:0x3EE02])
        self.assertEqual(loud[0x38464:0x38474], b"DMR003.R3a4.V022")

    def test_txram_dmr_a1024_changes_only_the_two_fill_immediates(self):
        # R3a5. One more 6 dB step. The measured R3a4 bytes stay buildable.
        prev, _ = build.build(["c7000-txram-dmr-a512"], "R3a4", self.cfg)
        loud, _ = build.build(["c7000-txram-dmr-a1024"], "R3a5", self.cfg)
        diff = [i for i, (a, b) in enumerate(zip(prev, loud)) if a != b]
        self.assertEqual(diff, [0x3846E, 0x5B028, 0x5B038])
        self.assertEqual(int.from_bytes(loud[0x5B028:0x5B02A], "little"), 0x3104)
        self.assertEqual(int.from_bytes(loud[0x5B038:0x5B03A], "little"), 0x31FC)
        self.assertNotIn((0x3AA4).to_bytes(2, "little"), loud[0x5B000:0x5B0BC])
        self.assertEqual(loud[0x3074:0x3078], self.fac[0x3074:0x3078])
        self.assertEqual(loud[0x3EDFC:0x3EE02], self.fac[0x3EDFC:0x3EE02])
        self.assertEqual(loud[0x38464:0x38474], b"DMR003.R3a5.V022")

    def test_txram_dmr_a2048_changes_only_the_two_fill_immediates(self):
        # R3a6. One more 6 dB step. The measured R3a5 bytes stay buildable.
        prev, _ = build.build(["c7000-txram-dmr-a1024"], "R3a5", self.cfg)
        loud, _ = build.build(["c7000-txram-dmr-a2048"], "R3a6", self.cfg)
        diff = [i for i, (a, b) in enumerate(zip(prev, loud)) if a != b]
        self.assertEqual(diff, [0x3846E, 0x5B028, 0x5B038])
        self.assertEqual(int.from_bytes(loud[0x5B028:0x5B02A], "little"), 0x3108)
        self.assertEqual(int.from_bytes(loud[0x5B038:0x5B03A], "little"), 0x31F8)
        self.assertNotIn((0x3AA4).to_bytes(2, "little"), loud[0x5B000:0x5B0BC])
        self.assertEqual(loud[0x3074:0x3078], self.fac[0x3074:0x3078])
        self.assertEqual(loud[0x3EDFC:0x3EE02], self.fac[0x3EDFC:0x3EE02])
        self.assertEqual(loud[0x38464:0x38474], b"DMR003.R3a6.V022")

    def test_txram_dmr_a4096_changes_only_the_two_fill_immediates(self):
        # R3a7. One more 6 dB step. The measured R3a6 bytes stay buildable.
        prev, _ = build.build(["c7000-txram-dmr-a2048"], "R3a6", self.cfg)
        loud, _ = build.build(["c7000-txram-dmr-a4096"], "R3a7", self.cfg)
        diff = [i for i, (a, b) in enumerate(zip(prev, loud)) if a != b]
        self.assertEqual(diff, [0x3846E, 0x5B028, 0x5B038])
        self.assertEqual(int.from_bytes(loud[0x5B028:0x5B02A], "little"), 0x3110)
        self.assertEqual(int.from_bytes(loud[0x5B038:0x5B03A], "little"), 0x31F0)
        self.assertNotIn((0x3AA4).to_bytes(2, "little"), loud[0x5B000:0x5B0BC])
        self.assertEqual(loud[0x3074:0x3078], self.fac[0x3074:0x3078])
        self.assertEqual(loud[0x3EDFC:0x3EE02], self.fac[0x3EDFC:0x3EE02])
        self.assertEqual(loud[0x38464:0x38474], b"DMR003.R3a7.V022")

    def test_txram_dmr_sine_is_one_kilohertz_at_peak_2048(self):
        # R3a8. Eight samples, one cycle, repeated. Peak immediate is 8.
        img, _ = build.build(["c7000-txram-dmr-sine1k"], "R3a8", self.cfg)
        xip = 0x0301A000

        def hw(off):
            return int.from_bytes(img[off:off + 2], "little")

        def word(off):
            return int.from_bytes(img[off:off + 4], "little")

        def bt_file(off):
            raw = hw(off)
            self.assertEqual(raw & 0xFC00, 0x0800, "not a 16-bit bt")
            imm = raw & 0x3FF
            if imm & 0x200:
                imm -= 0x400
            return off + (imm << 1)

        for site in (0x92C8, 0x92E0):
            self.assertEqual(bsr32_target(self.fac, site), 0xE9C)
            self.assertEqual(bsr32_target(img, site), 0x5B000)
        for site in (0x92AA, 0x92FA):
            self.assertEqual(bsr32_target(self.fac, site), 0xE9C)
            self.assertEqual(bsr32_target(img, site), 0x5B0A0)
        for off in (0x92CC, 0x92E4, 0x92AE, 0x92FE, 0x92B2, 0x929C, 0x9364):
            self.assertEqual(img[off:off + 4], self.fac[off:off + 4])

        self.assertEqual(hw(0x5B000), 0x14D5)
        self.assertEqual(bsr32_target(img, 0x5B002), 0xE9C)
        self.assertEqual((0x5B002 + xip + bsr32_disp(img, 0x5B002)) & 0xFFFFFFFF, xip + 0xE9C)
        self.assertEqual(hw(0x5B008), 0x3387)
        self.assertEqual(hw(0x5B00A), 0x4365)
        self.assertEqual(hw(0x5B010), 0x3280)
        self.assertEqual(hw(0x5B018), 0x3AA0)
        self.assertEqual(hw(0x5B020), 0x3A84)
        self.assertEqual(hw(0x5B022), 0x3A86)
        self.assertNotIn((0x3AA4).to_bytes(2, "little"), img[0x5B000:0x5B0D4])
        self.assertEqual(hw(0x5B028), 0x3240)  # movi r2, 64, the repeat count
        samples = []
        off = 0x5B02A
        for _ in range(8):
            raw = hw(off)
            self.assertEqual(raw & 0xFF00, 0x3100)
            samples.append(raw & 0xFF)
            self.assertEqual(hw(off + 2), 0xAB20)  # st.h r1, (r3, 0)
            self.assertEqual(hw(off + 4), 0x2301)  # addi r3, 2
            off += 6
        self.assertEqual(samples, [0, 6, 8, 6, 0, 250, 248, 250])
        signed = [v - 256 if v >= 128 else v for v in samples]
        self.assertEqual(max(abs(v) for v in signed), 8)
        self.assertNotIn(16, samples)
        self.assertNotIn(32, samples)
        movi_r1 = []
        for at in range(0x5B000, 0x5B0D4, 2):
            raw = hw(at)
            if raw & 0xFF00 == 0x3100:
                movi_r1.append(raw & 0xFF)
        self.assertEqual(movi_r1, samples)
        self.assertEqual(bt_file(0x5B05E), 0x5B02A)
        self.assertEqual(hw(0x5B060), 0x3030)
        self.assertEqual(word(0x5B062), 0x4006EA01)
        self.assertEqual(bsr32_target(img, 0x5B066), 0xFD011220)
        self.assertEqual((0x5B066 + xip + bsr32_disp(img, 0x5B066)) & 0xFFFFFFFF, 0x2B220)
        self.assertEqual(word(0x5B06C), 0x4026EA01)
        self.assertEqual(bsr32_target(img, 0x5B070), 0xFD011220)
        self.assertEqual((0x5B070 + xip + bsr32_disp(img, 0x5B070)) & 0xFFFFFFFF, 0x2B220)
        self.assertEqual(hw(0x5B074), 0x3058)
        self.assertEqual(word(0x5B076), 0xBCFDEA01)
        self.assertEqual(bsr32_target(img, 0x5B07A), 0xFD011220)
        self.assertEqual((0x5B07A + xip + bsr32_disp(img, 0x5B07A)) & 0xFFFFFFFF, 0x2B220)
        self.assertEqual(hw(0x5B080), 0x3201)
        self.assertEqual(hw(0x5B082), 0xB340)
        self.assertEqual(hw(0x5B084), 0x1495)
        pool = [word(0x5B088 + 4 * k) for k in range(6)]
        self.assertEqual(pool, [0x11000104, 0x11000100, 0x11000080, 0x11000500, 0x16000030, 0x11000560])

        self.assertEqual(hw(0x5B0A0), 0x14D5)
        self.assertEqual(bsr32_target(img, 0x5B0A2), 0xE9C)
        self.assertEqual(hw(0x5B0A8), 0x3200)
        self.assertEqual(hw(0x5B0AA), 0xB340)
        self.assertEqual(hw(0x5B0B0), 0x3A80)
        self.assertEqual(hw(0x5B0B4), 0x3058)
        self.assertEqual(word(0x5B0B6), 0x8405EA01)
        self.assertEqual(bsr32_target(img, 0x5B0BA), 0xFD011220)
        self.assertEqual((0x5B0BA + xip + bsr32_disp(img, 0x5B0BA)) & 0xFFFFFFFF, 0x2B220)
        self.assertEqual(word(0x5B0C0), 0x7026EA01)
        self.assertEqual(bsr32_target(img, 0x5B0C4), 0xFD011220)
        self.assertEqual((0x5B0C4 + xip + bsr32_disp(img, 0x5B0C4)) & 0xFFFFFFFF, 0x2B220)
        self.assertEqual(hw(0x5B0C8), 0x1495)
        self.assertEqual([word(0x5B0CC), word(0x5B0D0)], [0x11000560, 0x11000080])

        self.assertEqual(img[0x3074:0x3078], self.fac[0x3074:0x3078])
        self.assertEqual(img[0x3EDFC:0x3EE02], self.fac[0x3EDFC:0x3EE02])
        self.assertEqual(img[0x3EE16:0x3EE18], self.fac[0x3EE16:0x3EE18])
        self.assertEqual(img[0x5B0D4:0x5B100], self.fac[0x5B0D4:0x5B100])
        for off in (0x2C90, 0x3054, 0x344E, 0x34F2, 0x3640, 0x2E94):
            self.assertEqual(img[off:off + 2], self.fac[off:off + 2])
        self.assertEqual(img[0x38464:0x38474], b"DMR003.R3a8.V022")

    def test_txram_dmr_sine_p4096_changes_only_the_sample_immediates(self):
        # R3a9. One doubling of the measured sine. The R3a8 bytes stay buildable.
        prev, _ = build.build(["c7000-txram-dmr-sine1k"], "R3a8", self.cfg)
        loud, _ = build.build(["c7000-txram-dmr-sine1k-p4096"], "R3a9", self.cfg)
        diff = [i for i, (a, b) in enumerate(zip(prev, loud)) if a != b]
        self.assertEqual(diff, [0x3846E, 0x5B030, 0x5B036, 0x5B03C, 0x5B048, 0x5B04E, 0x5B054])
        samples = []
        for off in (0x5B02A, 0x5B030, 0x5B036, 0x5B03C, 0x5B042, 0x5B048, 0x5B04E, 0x5B054):
            raw = int.from_bytes(loud[off:off + 2], "little")
            self.assertEqual(raw & 0xFF00, 0x3100)
            samples.append(raw & 0xFF)
        self.assertEqual(samples, [0, 11, 16, 11, 0, 245, 240, 245])
        signed = [v - 256 if v >= 128 else v for v in samples]
        self.assertEqual(max(abs(v) for v in signed), 16)
        self.assertNotIn(32, samples)
        self.assertNotIn((0x3AA4).to_bytes(2, "little"), loud[0x5B000:0x5B0D4])
        self.assertEqual(loud[0x3074:0x3078], self.fac[0x3074:0x3078])
        self.assertEqual(loud[0x3EDFC:0x3EE02], self.fac[0x3EDFC:0x3EE02])
        self.assertEqual(bsr32_target(loud, 0x92C8), 0x5B000)
        self.assertEqual(bsr32_target(loud, 0x92AA), 0x5B0A0)
        self.assertEqual(loud[0x38464:0x38474], b"DMR003.R3a9.V022")

    def test_txram_dmr_sine_p5120_changes_only_the_sample_immediates(self):
        # R3a10. One step from the measured 4096-count sine toward a 2400 Hz
        # tone. The version field is 4 characters, so the tag is R3b0.
        prev, _ = build.build(["c7000-txram-dmr-sine1k-p4096"], "R3a9", self.cfg)
        loud, _ = build.build(["c7000-txram-dmr-sine1k-p5120"], "R3b0", self.cfg)
        diff = [i for i, (a, b) in enumerate(zip(prev, loud)) if a != b]
        self.assertEqual(diff, [0x3846D, 0x3846E, 0x5B030, 0x5B036, 0x5B03C, 0x5B048, 0x5B04E, 0x5B054])
        samples = []
        for off in (0x5B02A, 0x5B030, 0x5B036, 0x5B03C, 0x5B042, 0x5B048, 0x5B04E, 0x5B054):
            raw = int.from_bytes(loud[off:off + 2], "little")
            self.assertEqual(raw & 0xFF00, 0x3100)
            samples.append(raw & 0xFF)
        self.assertEqual(samples, [0, 14, 20, 14, 0, 242, 236, 242])
        signed = [v - 256 if v >= 128 else v for v in samples]
        self.assertEqual(max(abs(v) for v in signed), 20)
        self.assertNotIn(32, samples)
        self.assertNotIn((0x3AA4).to_bytes(2, "little"), loud[0x5B000:0x5B0D4])
        self.assertEqual(loud[0x3074:0x3078], self.fac[0x3074:0x3078])
        self.assertEqual(loud[0x3EDFC:0x3EE02], self.fac[0x3EDFC:0x3EE02])
        self.assertEqual(bsr32_target(loud, 0x92C8), 0x5B000)
        self.assertEqual(bsr32_target(loud, 0x92AA), 0x5B0A0)
        self.assertEqual(loud[0x38464:0x38474], b"DMR003.R3b0.V022")

    def test_txram_dmr_rrc_is_a_capped_4fsk_table(self):
        # R4a. Fixed RRC pattern, peak count 5120. Tag R4a0. on_unkey at +0x5B080.
        img, _ = build.build(["c7000-txram-dmr-rrc"], "R4a0", self.cfg)
        xip = 0x0301A000

        def hw(off):
            return int.from_bytes(img[off:off + 2], "little")

        def word(off):
            return int.from_bytes(img[off:off + 4], "little")

        def bt_file(off):
            raw = hw(off)
            self.assertEqual(raw & 0xFC00, 0x0800, "not a 16-bit bt")
            imm = raw & 0x3FF
            if imm & 0x200:
                imm -= 0x400
            return off + (imm << 1)

        for site in (0x92C8, 0x92E0):
            self.assertEqual(bsr32_target(self.fac, site), 0xE9C)
            self.assertEqual(bsr32_target(img, site), 0x5B000)
        for site in (0x92AA, 0x92FA):
            self.assertEqual(bsr32_target(self.fac, site), 0xE9C)
            self.assertEqual(bsr32_target(img, site), 0x5B080)
        self.assertEqual(bsr32_target(img, 0x5B002), 0xE9C)
        self.assertEqual(bsr32_target(img, 0x5B082), 0xE9C)
        for at in (0x5B042, 0x5B04C, 0x5B056, 0x5B09A, 0x5B0A4):
            self.assertEqual(bsr32_target(img, at), 0xFD011220)
            self.assertEqual((at + xip + bsr32_disp(img, at)) & 0xFFFFFFFF, 0x2B220)

        self.assertEqual(hw(0x5B000), 0x14D5)
        self.assertEqual(hw(0x5B018), 0x3AA0)
        self.assertEqual(word(0x5B02A), 0x0200EA02)  # movi r2, 512, stored little-endian
        self.assertEqual(hw(0x5B02E), 0x8C20)  # ld.h r1, (r4, 0)
        self.assertEqual(hw(0x5B030), 0xAB20)  # st.h r1, (r3, 0)
        self.assertEqual(bt_file(0x5B03A), 0x5B02E)
        self.assertEqual(hw(0x5B060), 0x1495)
        self.assertEqual(word(0x5B078), 0x03076000)
        self.assertEqual(hw(0x5B080), 0x14D5)
        self.assertEqual([word(0x5B0AC), word(0x5B0B0)], [0x11000560, 0x11000080])
        self.assertNotIn((0x3AA4).to_bytes(2, "little"), img[0x5B000:0x5B0B4])

        # 51 copies of the 10-sample period, then the first two samples again.
        period = [19, 12, 2, 254, 244, 236, 7, 20, 249, 1]
        imms = [hw(0x5C000 + 2 * i) for i in range(512)]
        self.assertEqual(imms, period * 51 + period[:2])
        signed = [v - 256 if v >= 128 else v for v in imms]
        self.assertEqual(max(abs(v) for v in signed), 20)
        self.assertEqual(max(abs(v) for v in signed) * 256, 5120)

        allowed = set(range(0x3846B, 0x3846F))
        for off, n in ((0x92C8, 4), (0x92E0, 4), (0x92AA, 4), (0x92FA, 4),
                       (0x5B000, 180), (0x5C000, 1024)):
            allowed.update(range(off, off + n))
        changed = {i for i, (a, b) in enumerate(zip(self.fac, img)) if a != b}
        self.assertTrue(changed <= allowed, sorted(changed - allowed)[:12])
        self.assertEqual(img[0x3074:0x3078], self.fac[0x3074:0x3078])
        self.assertEqual(img[0x3EDFC:0x3EE02], self.fac[0x3EDFC:0x3EE02])
        self.assertEqual(img[0x3EE16:0x3EE18], self.fac[0x3EE16:0x3EE18])
        self.assertEqual(img[0x5B0B4:0x5C000], self.fac[0x5B0B4:0x5C000])
        self.assertEqual(img[0x5C400:0x5C6FC], self.fac[0x5C400:0x5C6FC])
        for off in (0x2C90, 0x3054, 0x344E, 0x34F2, 0x3640, 0x2E94):
            self.assertEqual(img[off:off + 2], self.fac[off:off + 2])
        self.assertEqual(img[0x38464:0x38474], b"DMR003.R4a0.V022")

    def test_txram_m17_lsf_is_one_link_setup_frame(self):
        # R4b. One LSF in the 512-sample loop. Tag R4b0. Same stub as R4a.
        import numpy as np

        import m17_lsf_table
        import m17

        img, _ = build.build(["c7000-txram-m17-lsf"], "R4b0", self.cfg)
        prev, _ = build.build(["c7000-txram-dmr-rrc"], "R4a0", self.cfg)
        pcm = m17_lsf_table.counts()
        pred = m17_lsf_table.prediction(pcm)
        self.assertLess(pred["stop_hz"], 5000)
        self.assertGreater(pred["peak_count"], 4000)
        self.assertLess(int(pcm[0]), 0)
        self.assertEqual(int(pcm[510]), 0)
        self.assertEqual(int(pcm[511]), 0)
        self.assertEqual(img[0x5C000:0x5C400], m17_lsf_table.table_bytes(pcm))
        back = []
        raw = img[0x5C000:0x5C400]
        for i in range(0, 1024, 2):
            v = (raw[i] << 8) | raw[i + 1]
            if v >= 32768:
                v -= 65536
            back.append(v)
        self.assertEqual(back, [int(s) for s in pcm])
        self.assertEqual(img[0x5B000:0x5B0B4], prev[0x5B000:0x5B0B4])
        for off in (0x92C8, 0x92E0, 0x92AA, 0x92FA):
            self.assertEqual(img[off:off + 4], prev[off:off + 4])
        self.assertNotEqual(img[0x5C000:0x5C400], prev[0x5C000:0x5C400])
        self.assertEqual(bsr32_target(img, 0x92C8), 0x5B000)
        self.assertEqual(bsr32_target(img, 0x92E0), 0x5B000)
        self.assertEqual(bsr32_target(img, 0x92AA), 0x5B080)
        self.assertEqual(bsr32_target(img, 0x92FA), 0x5B080)
        self.assertEqual(img[0x3074:0x3078], self.fac[0x3074:0x3078])
        self.assertEqual(img[0x3EDFC:0x3EE02], self.fac[0x3EDFC:0x3EE02])
        self.assertEqual(img[0x5B0B4:0x5C000], self.fac[0x5B0B4:0x5C000])
        self.assertEqual(img[0x5C400:0x5C6FC], self.fac[0x5C400:0x5C6FC])
        self.assertEqual(img[0x38464:0x38474], b"DMR003.R4b0.V022")
        air = np.tile(-m17_lsf_table.HZ_PER_COUNT * pcm.astype(float), 4)
        got = m17.decode_transmission(air, 8000, verbose=False)
        self.assertIsNotNone(got["lsf"])
        self.assertTrue(got["lsf"][2])

    def test_txram_m17_stream_polls_the_half_select(self):
        # R4c. One LSF and six stream frames in the zero tail. Tag R4c0.
        # The stub polls FM_ADDR_SW and does not enable the refill interrupt.
        import m17_stream_table
        import m17

        img, _ = build.build(["c7000-txram-m17-stream"], "R4c0", self.cfg)
        xip = 0x0301A000
        self.assertEqual(len(img), len(self.fac))

        def hw(off):
            return int.from_bytes(img[off:off + 2], "little")

        def word(off):
            return int.from_bytes(img[off:off + 4], "little")

        for site in (0x92C8, 0x92E0):
            self.assertEqual(bsr32_target(self.fac, site), 0xE9C)
            self.assertEqual(bsr32_target(img, site), 0x5B000)
        for site in (0x92AA, 0x92FA):
            self.assertEqual(bsr32_target(self.fac, site), 0xE9C)
            self.assertEqual(bsr32_target(img, site), 0x5B128)
        self.assertEqual(bsr32_target(img, 0x5B002), 0xE9C)
        self.assertEqual(bsr32_target(img, 0x5B12A), 0xE9C)
        self.assertEqual(bsr32_target(img, 0x5B074), 0x541F8)
        for at in (0x5B042, 0x5B04C, 0x5B056, 0x5B142, 0x5B14C):
            self.assertEqual(bsr32_target(img, at), 0xFD011220)
            self.assertEqual((at + xip + bsr32_disp(img, at)) & 0xFFFFFFFF, 0x2B220)

        self.assertEqual(hw(0x5B000), 0x14D6)
        self.assertEqual(hw(0x5B128), 0x14D5)
        self.assertEqual(word(0x5B114), 0x03075400)
        self.assertEqual(word(0x5B11C), 0x030766FC)
        self.assertEqual(word(0x5B120), 0x1100056C)
        self.assertNotIn((0x1100039C).to_bytes(4, "little"), img[0x5B000:0x5B15C])
        for at in range(0x5B000, 0x5B159, 2):
            hi = int.from_bytes(img[at:at + 2], "little")
            if hi >> 10 != 0b111000:
                continue
            self.assertNotIn(bsr32_target(img, at), (0x18A70, 0x03032A70))

        pcm = m17_stream_table.counts()
        pred = m17_stream_table.prediction(pcm)
        self.assertEqual(pred["peak_count"], 6451)
        self.assertLess(pred["stop_hz"], 5000)
        self.assertLess(int(pcm[0]), 0)
        self.assertEqual(img[0x5B400:0x5C6FC], m17_stream_table.table_bytes(pcm))
        self.assertEqual(img[0x5B15C:0x5B400], self.fac[0x5B15C:0x5B400])
        self.assertEqual(img[0x3074:0x3078], self.fac[0x3074:0x3078])
        self.assertEqual(img[0x3EDFC:0x3EE02], self.fac[0x3EDFC:0x3EE02])
        self.assertEqual(img[0x38464:0x38474], b"DMR003.R4c0.V022")
        air = -m17_stream_table.HZ_PER_COUNT * pcm.astype(float)
        got = m17.decode_transmission(air, 8000, verbose=False)
        self.assertIsNotNone(got["lsf"])
        self.assertTrue(got["lsf"][2])
        self.assertEqual([f[0] for f in got["frames"]], [0, 1, 2, 3, 4, 0x8005])

        allowed = set(range(0x3846B, 0x3846F))
        for off, n in ((0x92C8, 4), (0x92E0, 4), (0x92AA, 4), (0x92FA, 4),
                       (0x5B000, 348), (0x5B400, 4860)):
            allowed.update(range(off, off + n))
        changed = {i for i, (a, b) in enumerate(zip(self.fac, img)) if a != b}
        self.assertTrue(changed <= allowed, sorted(changed - allowed)[:12])

    def test_txram_m17_wake_refills_after_the_key_returns(self):
        # R4d. on_key returns at once. The service-task wake refills.
        # Tag R4d0. The task entry itself is not patched.
        import m17_stream_table
        import m17

        img, _ = build.build(["c7000-txram-m17-wake"], "R4d0", self.cfg)
        xip = 0x0301A000
        stub_end = 0x5B1B0
        self.assertEqual(len(img), len(self.fac))
        self.assertEqual(bsr32_target(self.fac, 0x18B5C), 0x18B70)
        self.assertEqual(bsr32_target(self.fac, 0x18B68), 0x3D20)
        for site in (0x92C8, 0x92E0):
            self.assertEqual(bsr32_target(self.fac, site), 0xE9C)
            self.assertEqual(bsr32_target(img, site), 0x5B0D0)
        for site in (0x92AA, 0x92FA):
            self.assertEqual(bsr32_target(self.fac, site), 0xE9C)
            self.assertEqual(bsr32_target(img, site), 0x5B168)
        self.assertEqual(bsr32_target(img, 0x18B5C), 0x5B000)
        self.assertEqual(bsr32_target(img, 0x18B68), 0x5B006)
        self.assertEqual(int.from_bytes(img[0x5B000:0x5B002], "little"), 0x14D4)
        self.assertEqual(int.from_bytes(img[0x5B006:0x5B008], "little"), 0x14D4)
        stub = img[0x5B000:stub_end]
        bsrs = []
        for at in range(0x5B000, stub_end - 3, 2):
            hi = int.from_bytes(img[at:at + 2], "little")
            if hi >> 10 != 0b111000:
                continue
            bsrs.append(bsr32_target(img, at))
            if bsr32_target(img, at) == 0xFD011220:
                self.assertEqual((at + xip + bsr32_disp(img, at)) & 0xFFFFFFFF, 0x2B220)
        self.assertEqual(sorted(set(bsrs)), [0xE9C, 0xFD011220])
        self.assertEqual(bsrs.count(0xE9C), 2)
        self.assertEqual(bsrs.count(0xFD011220), 5)
        for addr, n in (
            (0x4DAAC, 3), (0x1100039C, 2), (0x03032B70, 1),
            (0x03075800, 1), (0x030766FC, 1), (0x1100056C, 1),
        ):
            self.assertEqual(stub.count(addr.to_bytes(4, "little")), n)
        self.assertNotIn((0x03032A70).to_bytes(4, "little"), stub)
        self.assertNotIn(bytes.fromhex("00e0f841"), stub)
        self.assertEqual(stub.count((0x3AAF).to_bytes(2, "little")), 1)
        self.assertEqual(stub.count((0x3A8F).to_bytes(2, "little")), 1)
        self.assertEqual(img[0x1F30:0x1F34], self.fac[0x1F30:0x1F34])
        self.assertEqual(img[0x18A70:0x18A78], self.fac[0x18A70:0x18A78])
        pcm = m17_stream_table.counts()
        pred = m17_stream_table.prediction(pcm)
        self.assertEqual(pred["peak_count"], 6451)
        self.assertLess(pred["stop_hz"], 5000)
        self.assertLess(int(pcm[0]), 0)
        self.assertEqual(img[0x5B400:0x5C6FC], m17_stream_table.table_bytes(pcm))
        self.assertEqual(img[stub_end:0x5B400], self.fac[stub_end:0x5B400])
        self.assertEqual(img[0x3074:0x3078], self.fac[0x3074:0x3078])
        self.assertEqual(img[0x3EDFC:0x3EE02], self.fac[0x3EDFC:0x3EE02])
        self.assertEqual(img[0x38464:0x38474], b"DMR003.R4d0.V022")
        air = -m17_stream_table.HZ_PER_COUNT * pcm.astype(float)
        got = m17.decode_transmission(air, 8000, verbose=False)
        self.assertIsNotNone(got["lsf"])
        self.assertTrue(got["lsf"][2])
        self.assertEqual([f[0] for f in got["frames"]], [0, 1, 2, 3, 4, 0x8005])
        allowed = set(range(0x3846B, 0x3846F))
        for off, n in (
            (0x92C8, 4), (0x92E0, 4), (0x92AA, 4), (0x92FA, 4),
            (0x18B5C, 4), (0x18B68, 4), (0x5B000, 432), (0x5B400, 4860),
        ):
            allowed.update(range(off, off + n))
        changed = {i for i, (a, b) in enumerate(zip(self.fac, img)) if a != b}
        self.assertTrue(changed <= allowed, sorted(changed - allowed)[:12])

    def test_txram_m17_loop_wraps_the_stream_until_unkey(self):
        # R4e. Same gates as R4d. The cursor wraps at the tail instead of ending.
        # Tag R4e0. The task entry itself is not patched.
        import m17_stream_table
        import m17

        img, _ = build.build(["c7000-txram-m17-loop"], "R4e0", self.cfg)
        xip = 0x0301A000
        stub_end = 0x5B170
        self.assertEqual(len(img), len(self.fac))
        self.assertEqual(bsr32_target(self.fac, 0x18B5C), 0x18B70)
        self.assertEqual(bsr32_target(self.fac, 0x18B68), 0x3D20)
        for site in (0x92C8, 0x92E0):
            self.assertEqual(bsr32_target(self.fac, site), 0xE9C)
            self.assertEqual(bsr32_target(img, site), 0x5B090)
        for site in (0x92AA, 0x92FA):
            self.assertEqual(bsr32_target(self.fac, site), 0xE9C)
            self.assertEqual(bsr32_target(img, site), 0x5B128)
        self.assertEqual(bsr32_target(img, 0x18B5C), 0x5B000)
        self.assertEqual(bsr32_target(img, 0x18B68), 0x5B006)
        self.assertEqual(int.from_bytes(img[0x5B000:0x5B002], "little"), 0x14D4)
        self.assertEqual(int.from_bytes(img[0x5B006:0x5B008], "little"), 0x14D4)
        self.assertEqual(int.from_bytes(img[0x5B090:0x5B092], "little"), 0x14D4)
        self.assertEqual(int.from_bytes(img[0x5B128:0x5B12A], "little"), 0x14D4)
        stub = img[0x5B000:stub_end]
        bsrs = []
        for at in range(0x5B000, stub_end - 3, 2):
            hi = int.from_bytes(img[at:at + 2], "little")
            if hi >> 10 != 0b111000:
                continue
            bsrs.append(bsr32_target(img, at))
            if bsr32_target(img, at) == 0xFD011220:
                self.assertEqual((at + xip + bsr32_disp(img, at)) & 0xFFFFFFFF, 0x2B220)
        self.assertEqual(sorted(set(bsrs)), [0xE9C, 0xFD011220])
        self.assertEqual(bsrs.count(0xE9C), 2)
        self.assertEqual(bsrs.count(0xFD011220), 5)
        for addr, n in (
            (0x4DAAC, 3), (0x1100039C, 2), (0x03032B70, 1),
            (0x03075800, 1), (0x030766E8, 1), (0x030757E8, 1),
            (0x03075400, 1), (0x1100056C, 1),
        ):
            self.assertEqual(stub.count(addr.to_bytes(4, "little")), n, hex(addr))
        self.assertEqual(stub.count((0x030766FC).to_bytes(4, "little")), 0)
        self.assertNotIn((0x03032A70).to_bytes(4, "little"), stub)
        self.assertNotIn(bytes.fromhex("00e0f841"), stub)
        self.assertEqual(stub.count((0x3AAF).to_bytes(2, "little")), 1)
        self.assertEqual(stub.count((0x3A8F).to_bytes(2, "little")), 1)
        self.assertEqual(img[0x1F30:0x1F34], self.fac[0x1F30:0x1F34])
        self.assertEqual(img[0x18A70:0x18A78], self.fac[0x18A70:0x18A78])
        pcm = m17_stream_table.counts()
        pred = m17_stream_table.prediction(pcm)
        self.assertEqual(pred["peak_count"], 6451)
        self.assertLess(pred["stop_hz"], 5000)
        self.assertLess(int(pcm[0]), 0)
        self.assertEqual(img[0x5B400:0x5C6FC], m17_stream_table.table_bytes(pcm))
        self.assertEqual(img[stub_end:0x5B400], self.fac[stub_end:0x5B400])
        self.assertEqual(img[0x3074:0x3078], self.fac[0x3074:0x3078])
        self.assertEqual(img[0x3EDFC:0x3EE02], self.fac[0x3EDFC:0x3EE02])
        self.assertEqual(img[0x38464:0x38474], b"DMR003.R4e0.V022")
        # Prefill 0..511, then 256-sample halves. At index 2420 wrap to 500.
        indexes = list(range(512))
        cursor = 512
        while len(indexes) < 16000:
            if cursor >= 2420:
                cursor = 500
            self.assertLess(cursor, 2420)
            indexes.append(cursor)
            cursor += 1
        self.assertNotIn(2420, indexes)
        self.assertGreaterEqual(indexes.count(500), 2)
        played = pcm[indexes]
        air = -m17_stream_table.HZ_PER_COUNT * played.astype(float)
        got = m17.decode_transmission(air, 8000, verbose=False)
        self.assertIsNotNone(got["lsf"])
        self.assertTrue(got["lsf"][2])
        fns = [f[0] for f in got["frames"]]
        self.assertGreaterEqual(len(fns), 20)
        self.assertTrue(set(fns) <= {0, 1, 2, 3, 4, 0x8005})
        self.assertTrue(all(f[1] == bytes(16) and f[2] == 0 for f in got["frames"]))
        allowed = set(range(0x3846B, 0x3846F))
        for off, n in (
            (0x92C8, 4), (0x92E0, 4), (0x92AA, 4), (0x92FA, 4),
            (0x18B5C, 4), (0x18B68, 4), (0x5B000, 368), (0x5B400, 4860),
        ):
            allowed.update(range(off, off + n))
        changed = {i for i, (a, b) in enumerate(zip(self.fac, img)) if a != b}
        self.assertTrue(changed <= allowed, sorted(changed - allowed)[:12])

    def test_txram_m17_loop5_omits_the_end_frame(self):
        # R4f. Same gates as R4e. The table is frames 0-4. No end bit.
        # Tag R4f0. The task entry itself is not patched.
        import m17_stream_table
        import m17

        img, _ = build.build(["c7000-txram-m17-loop5"], "R4f0", self.cfg)
        xip = 0x0301A000
        stub_end = 0x5B170
        table_end = 0x5C47C
        self.assertEqual(len(img), len(self.fac))
        self.assertEqual(bsr32_target(self.fac, 0x18B5C), 0x18B70)
        self.assertEqual(bsr32_target(self.fac, 0x18B68), 0x3D20)
        for site in (0x92C8, 0x92E0):
            self.assertEqual(bsr32_target(self.fac, site), 0xE9C)
            self.assertEqual(bsr32_target(img, site), 0x5B090)
        for site in (0x92AA, 0x92FA):
            self.assertEqual(bsr32_target(self.fac, site), 0xE9C)
            self.assertEqual(bsr32_target(img, site), 0x5B128)
        self.assertEqual(bsr32_target(img, 0x18B5C), 0x5B000)
        self.assertEqual(bsr32_target(img, 0x18B68), 0x5B006)
        self.assertEqual(int.from_bytes(img[0x5B000:0x5B002], "little"), 0x14D4)
        self.assertEqual(int.from_bytes(img[0x5B006:0x5B008], "little"), 0x14D4)
        self.assertEqual(int.from_bytes(img[0x5B090:0x5B092], "little"), 0x14D4)
        self.assertEqual(int.from_bytes(img[0x5B128:0x5B12A], "little"), 0x14D4)
        stub = img[0x5B000:stub_end]
        bsrs = []
        for at in range(0x5B000, stub_end - 3, 2):
            hi = int.from_bytes(img[at:at + 2], "little")
            if hi >> 10 != 0b111000:
                continue
            bsrs.append(bsr32_target(img, at))
            if bsr32_target(img, at) == 0xFD011220:
                self.assertEqual((at + xip + bsr32_disp(img, at)) & 0xFFFFFFFF, 0x2B220)
        self.assertEqual(sorted(set(bsrs)), [0xE9C, 0xFD011220])
        self.assertEqual(bsrs.count(0xE9C), 2)
        self.assertEqual(bsrs.count(0xFD011220), 5)
        for addr, n in (
            (0x4DAAC, 3), (0x1100039C, 2), (0x03032B70, 1),
            (0x03075800, 1), (0x03076468, 1), (0x030757E8, 1),
            (0x03075400, 1), (0x1100056C, 1),
        ):
            self.assertEqual(stub.count(addr.to_bytes(4, "little")), n, hex(addr))
        self.assertEqual(stub.count((0x030766E8).to_bytes(4, "little")), 0)
        self.assertEqual(stub.count((0x030766FC).to_bytes(4, "little")), 0)
        self.assertNotIn((0x03032A70).to_bytes(4, "little"), stub)
        self.assertNotIn(bytes.fromhex("00e0f841"), stub)
        self.assertEqual(stub.count((0x3AAF).to_bytes(2, "little")), 1)
        self.assertEqual(stub.count((0x3A8F).to_bytes(2, "little")), 1)
        self.assertEqual(img[0x1F30:0x1F34], self.fac[0x1F30:0x1F34])
        self.assertEqual(img[0x18A70:0x18A78], self.fac[0x18A70:0x18A78])
        pcm = m17_stream_table.counts_loop5()
        pred = m17_stream_table.prediction(pcm)
        self.assertEqual(pred["peak_count"], 6451)
        self.assertLess(pred["stop_hz"], 5000)
        self.assertLess(int(pcm[0]), 0)
        self.assertEqual(len(m17_stream_table.table_bytes()), 4860)
        self.assertEqual(
            m17_stream_table.counts()[:2090].tobytes(),
            pcm[:2090].tobytes(),
        )
        self.assertEqual(img[0x5B400:table_end], m17_stream_table.table_bytes_loop5(pcm))
        self.assertEqual(img[table_end:], self.fac[table_end:])
        self.assertEqual(img[stub_end:0x5B400], self.fac[stub_end:0x5B400])
        self.assertEqual(img[0x3074:0x3078], self.fac[0x3074:0x3078])
        self.assertEqual(img[0x3EDFC:0x3EE02], self.fac[0x3EDFC:0x3EE02])
        self.assertEqual(img[0x38464:0x38474], b"DMR003.R4f0.V022")
        # Prefill 0..511, then 256-sample halves. At index 2100 wrap to 500.
        indexes = list(range(512))
        cursor = 512
        while len(indexes) < 16000:
            if cursor >= 2100:
                cursor = 500
            self.assertLess(cursor, 2100)
            indexes.append(cursor)
            cursor += 1
        self.assertNotIn(2100, indexes)
        self.assertGreaterEqual(indexes.count(500), 2)
        played = pcm[indexes]
        air = -m17_stream_table.HZ_PER_COUNT * played.astype(float)
        got = m17.decode_transmission(air, 8000, verbose=False)
        self.assertIsNotNone(got["lsf"])
        self.assertTrue(got["lsf"][2])
        fns = [f[0] for f in got["frames"]]
        self.assertGreaterEqual(len(fns), 20)
        self.assertTrue(set(fns) <= {0, 1, 2, 3, 4})
        self.assertNotIn(0x8005, fns)
        self.assertTrue(all(f[1] == bytes(16) and f[2] == 0 for f in got["frames"]))
        allowed = set(range(0x3846B, 0x3846F))
        for off, n in (
            (0x92C8, 4), (0x92E0, 4), (0x92AA, 4), (0x92FA, 4),
            (0x18B5C, 4), (0x18B68, 4), (0x5B000, 368), (0x5B400, 4220),
        ):
            allowed.update(range(off, off + n))
        changed = {i for i, (a, b) in enumerate(zip(self.fac, img)) if a != b}
        self.assertTrue(changed <= allowed, sorted(changed - allowed)[:12])

    def test_txram_m17_pay16_sets_the_payload_bytes(self):
        # R4g. Same gates and the same stub instructions as R4f.
        # The 16 payload bytes are 0 through 15. Tag R4g0.
        import m17_stream_table
        import m17

        img, _ = build.build(["c7000-txram-m17-pay16"], "R4g0", self.cfg)
        loop5, _ = build.build(["c7000-txram-m17-loop5"], "R4f0", self.cfg)
        stub_end = 0x5B170
        table_end = 0x5C47C
        self.assertEqual(len(img), len(self.fac))
        self.assertEqual(img[0x5B000:stub_end], loop5[0x5B000:stub_end])
        for site in (0x92C8, 0x92E0):
            self.assertEqual(bsr32_target(img, site), 0x5B090)
        for site in (0x92AA, 0x92FA):
            self.assertEqual(bsr32_target(img, site), 0x5B128)
        self.assertEqual(bsr32_target(img, 0x18B5C), 0x5B000)
        self.assertEqual(bsr32_target(img, 0x18B68), 0x5B006)
        self.assertEqual(img[0x1F30:0x1F34], self.fac[0x1F30:0x1F34])
        self.assertEqual(img[0x18A70:0x18A78], self.fac[0x18A70:0x18A78])
        pcm = m17_stream_table.counts_pay16()
        base = m17_stream_table.counts_loop5()
        pred = m17_stream_table.prediction(pcm)
        self.assertEqual(pred["peak_count"], 6451)
        self.assertLess(pred["stop_hz"], 5000)
        self.assertLess(int(pcm[0]), 0)
        self.assertEqual(pcm[:510].tobytes(), base[:510].tobytes())
        self.assertNotEqual(int(pcm[510]), int(base[510]))
        self.assertEqual(len(pcm), 2110)
        self.assertEqual(len(m17_stream_table.table_bytes()), 4860)
        self.assertEqual(img[0x5B400:table_end], m17_stream_table.table_bytes_pay16(pcm))
        self.assertNotEqual(img[0x5B400:table_end], loop5[0x5B400:0x5B400 + 4220])
        self.assertEqual(img[table_end:], self.fac[table_end:])
        self.assertEqual(img[stub_end:0x5B400], self.fac[stub_end:0x5B400])
        self.assertEqual(img[0x3074:0x3078], self.fac[0x3074:0x3078])
        self.assertEqual(img[0x3EDFC:0x3EE02], self.fac[0x3EDFC:0x3EE02])
        self.assertEqual(img[0x38464:0x38474], b"DMR003.R4g0.V022")
        self.assertEqual(m17_stream_table.PAY16, bytes(range(16)))
        indexes = list(range(512))
        cursor = 512
        while len(indexes) < 16000:
            if cursor >= 2100:
                cursor = 500
            self.assertLess(cursor, 2100)
            indexes.append(cursor)
            cursor += 1
        self.assertNotIn(2100, indexes)
        played = pcm[indexes]
        air = -m17_stream_table.HZ_PER_COUNT * played.astype(float)
        got = m17.decode_transmission(air, 8000, verbose=False)
        self.assertIsNotNone(got["lsf"])
        self.assertTrue(got["lsf"][2])
        self.assertEqual(got["lsf"][0], m17_stream_table.BENCH_CALL)
        self.assertEqual(got["lsf"][1], m17_stream_table.BENCH_CALL)
        fns = [f[0] for f in got["frames"]]
        self.assertGreaterEqual(len(fns), 20)
        self.assertTrue(set(fns) <= {0, 1, 2, 3, 4})
        self.assertNotIn(0x8005, fns)
        self.assertTrue(all(f[1] == bytes(range(16)) and f[2] == 0 for f in got["frames"]))
        allowed = set(range(0x3846B, 0x3846F))
        for off, n in (
            (0x92C8, 4), (0x92E0, 4), (0x92AA, 4), (0x92FA, 4),
            (0x18B5C, 4), (0x18B68, 4), (0x5B000, 368), (0x5B400, 4220),
        ):
            allowed.update(range(off, off + n))
        changed = {i for i, (a, b) in enumerate(zip(self.fac, img)) if a != b}
        self.assertTrue(changed <= allowed, sorted(changed - allowed)[:12])

    def test_txram_m17_lich5_sends_frame_5_with_the_end_bit_clear(self):
        # R4h. Same gates as R4g. The wrap moves to sample 2420.
        # Frame 5 carries LICH part 5 and the end bit is clear. Tag R4h0.
        import m17_stream_table
        import m17

        img, _ = build.build(["c7000-txram-m17-lich5"], "R4h0", self.cfg)
        pay, _ = build.build(["c7000-txram-m17-pay16"], "R4g0", self.cfg)
        stub_end = 0x5B170
        self.assertEqual(len(img), len(self.fac))
        stub = img[0x5B000:stub_end]
        base_stub = pay[0x5B000:stub_end]
        diffs = [i for i, (a, b) in enumerate(zip(stub, base_stub)) if a != b]
        self.assertEqual(diffs, [132, 133])
        self.assertEqual(stub[132:136], bytes.fromhex("e8660703"))
        for site in (0x92C8, 0x92E0):
            self.assertEqual(bsr32_target(img, site), 0x5B090)
        for site in (0x92AA, 0x92FA):
            self.assertEqual(bsr32_target(img, site), 0x5B128)
        self.assertEqual(bsr32_target(img, 0x18B5C), 0x5B000)
        self.assertEqual(bsr32_target(img, 0x18B68), 0x5B006)
        self.assertEqual(img[0x1F30:0x1F34], self.fac[0x1F30:0x1F34])
        self.assertEqual(img[0x18A70:0x18A78], self.fac[0x18A70:0x18A78])
        pcm = m17_stream_table.counts_lich5()
        base = m17_stream_table.counts_pay16()
        pred = m17_stream_table.prediction(pcm)
        self.assertEqual(pred["peak_count"], 6451)
        self.assertLess(pred["stop_hz"], 5000)
        self.assertLess(int(pcm[0]), 0)
        self.assertEqual(pcm[:2094].tobytes(), base[:2094].tobytes())
        self.assertNotEqual(int(pcm[2094]), int(base[2094]))
        self.assertEqual(len(pcm), 2430)
        self.assertEqual(len(m17_stream_table.table_bytes()), 4860)
        self.assertEqual(len(m17_stream_table.table_bytes_pay16()), 4220)
        self.assertEqual(img[0x5B400:], m17_stream_table.table_bytes_lich5(pcm))
        self.assertNotEqual(img[0x5B400:], m17_stream_table.table_bytes())
        self.assertEqual(img[stub_end:0x5B400], self.fac[stub_end:0x5B400])
        self.assertEqual(img[0x3074:0x3078], self.fac[0x3074:0x3078])
        self.assertEqual(img[0x3EDFC:0x3EE02], self.fac[0x3EDFC:0x3EE02])
        self.assertEqual(img[0x38464:0x38474], b"DMR003.R4h0.V022")
        self.assertEqual(m17_stream_table.PAY16, bytes(range(16)))
        indexes = list(range(512))
        cursor = 512
        while len(indexes) < 16000:
            if cursor >= 2420:
                cursor = 500
            self.assertLess(cursor, 2420)
            indexes.append(cursor)
            cursor += 1
        self.assertNotIn(2420, indexes)
        self.assertIn(2100, indexes)
        played = pcm[indexes]
        air = -m17_stream_table.HZ_PER_COUNT * played.astype(float)
        got = m17.decode_transmission(air, 8000, verbose=False)
        self.assertIsNotNone(got["lsf"])
        self.assertTrue(got["lsf"][2])
        self.assertEqual(got["lsf"][0], m17_stream_table.BENCH_CALL)
        self.assertEqual(got["lsf"][1], m17_stream_table.BENCH_CALL)
        fns = [f[0] for f in got["frames"]]
        self.assertGreaterEqual(len(fns), 20)
        self.assertEqual(set(fns), {0, 1, 2, 3, 4, 5})
        self.assertNotIn(0x8005, fns)
        self.assertTrue(all(f[1] == bytes(range(16)) and f[2] == 0 for f in got["frames"]))
        allowed = set(range(0x3846B, 0x3846F))
        for off, n in (
            (0x92C8, 4), (0x92E0, 4), (0x92AA, 4), (0x92FA, 4),
            (0x18B5C, 4), (0x18B68, 4), (0x5B000, 368), (0x5B400, 4860),
        ):
            allowed.update(range(off, off + n))
        changed = {i for i, (a, b) in enumerate(zip(self.fac, img)) if a != b}
        self.assertTrue(changed <= allowed, sorted(changed - allowed)[:12])

    def test_txram_m17_eot1_sends_one_end_frame_when_the_key_ends(self):
        # R4i. The R4h loop stays. One end frame follows it, and only at unkey.
        # Tag R4i0. The end frame is the continuation tail, peak count 6337.
        import numpy as np
        import m17_stream_table
        import m17

        img, _ = build.build(["c7000-txram-m17-eot1"], "R4i0", self.cfg)
        self.assertEqual(len(img), len(self.fac))
        for site in (0x92C8, 0x92E0):
            self.assertEqual(bsr32_target(img, site), 0x5B090)
        for site in (0x92AA, 0x92FA):
            self.assertEqual(bsr32_target(img, site), 0x5B128)
        self.assertEqual(bsr32_target(img, 0x18B5C), 0x5B000)
        self.assertEqual(bsr32_target(img, 0x18B68), 0x5B006)
        self.assertEqual(bsr32_target(img, 0x5B092), 0xE9C)
        self.assertEqual(bsr32_target(img, 0x5B138), 0x5AF78)
        self.assertEqual(bsr32_target(img, 0x5AF86), 0x541F8)
        self.assertEqual(bsr32_target(img, 0x5AFC2), 0xE9C)
        self.assertEqual(img[0x1F30:0x1F34], self.fac[0x1F30:0x1F34])
        self.assertEqual(img[0x18A70:0x18A78], self.fac[0x18A70:0x18A78])
        self.assertEqual(img[0x39408:0x5AEFC], self.fac[0x39408:0x5AEFC])
        self.assertEqual(int.from_bytes(img[0x5B000:0x5B002], "little"), 0x14D4)
        self.assertEqual(int.from_bytes(img[0x5B006:0x5B008], "little"), 0x14D4)
        self.assertEqual(int.from_bytes(img[0x5B042:0x5B044], "little"), 0x075D)
        self.assertEqual(int.from_bytes(img[0x5B044:0x5B046], "little"), 0x3780)
        self.assertEqual(int.from_bytes(img[0x5B090:0x5B092], "little"), 0x14D4)
        self.assertEqual(int.from_bytes(img[0x5B128:0x5B12A], "little"), 0x14D4)
        self.assertEqual(int.from_bytes(img[0x5B12A:0x5B12C], "little"), 0x0407)
        self.assertEqual(int.from_bytes(img[0x5AF0C:0x5AF0E], "little"), 0x049C)
        self.assertEqual(int.from_bytes(img[0x5AF76:0x5AF78], "little"), 0x0474)
        self.assertEqual(int.from_bytes(img[0x5AF78:0x5AF7A], "little"), 0x14D4)
        self.assertNotEqual(img[0x5AEFC:0x5AFE4], bytes(232))
        self.assertEqual(img[0x5AFE4:0x5B000], bytes(28))
        off = 0x5B000
        while off + 4 <= 0x5B090:
            hi = int.from_bytes(img[off:off + 2], "little")
            self.assertNotEqual(hi >> 10, 0b111000, hex(off))
            off += 2
        pcm = m17_stream_table.counts_lich5()
        eot = m17_stream_table.counts_eot1()
        self.assertEqual(m17_stream_table.prediction(pcm)["peak_count"], 6451)
        eot_pred = m17_stream_table.prediction(eot)
        self.assertEqual(eot_pred["peak_count"], 6337)
        self.assertLess(eot_pred["stop_hz"], 5000)
        self.assertEqual(img[0x5B170:0x5B3F0], m17_stream_table.table_bytes_eot1(eot))
        self.assertEqual(img[0x5B3F0:0x5B400], self.fac[0x5B3F0:0x5B400])
        self.assertEqual(img[0x5B400:], m17_stream_table.table_bytes_lich5(pcm))
        self.assertEqual(img[0x3074:0x3078], self.fac[0x3074:0x3078])
        self.assertEqual(img[0x3EDFC:0x3EE02], self.fac[0x3EDFC:0x3EE02])
        self.assertEqual(img[0x38464:0x38474], b"DMR003.R4i0.V022")
        self.assertEqual(m17_stream_table.PAY16, bytes(range(16)))

        def pcm_of(blob):
            out = []
            for i in range(0, len(blob), 2):
                u = (blob[i] << 8) | blob[i + 1]
                if u >= 0x8000:
                    u -= 0x10000
                out.append(u)
            return out

        loop_pcm = pcm_of(img[0x5B400:])
        eot_pcm = pcm_of(img[0x5B170:0x5B3F0])
        self.assertEqual(loop_pcm, list(int(x) for x in pcm))
        self.assertEqual(eot_pcm, list(int(x) for x in eot))
        air = -m17_stream_table.HZ_PER_COUNT * np.concatenate([
            pcm[:2420], pcm[500:2420], pcm[500:2420], eot,
        ]).astype(float)
        got = m17.decode_transmission(air, 8000, verbose=False)
        lsf = got["lsf"]
        self.assertTrue(
            lsf is not None and lsf[2]
            and lsf[0] == m17_stream_table.BENCH_CALL
            and lsf[1] == m17_stream_table.BENCH_CALL
        )
        fns = [f[0] for f in got["frames"]]
        self.assertEqual(fns[-1], 0x8005)
        self.assertNotIn(0x8005, fns[:-1])
        self.assertTrue(set(fns[:-1]) <= {0, 1, 2, 3, 4, 5})
        self.assertGreaterEqual(len(fns), 8)
        self.assertTrue(all(f[1] == bytes(range(16)) and f[2] == 0 for f in got["frames"]))
        allowed = set(range(0x3846B, 0x3846F))
        for off, n in (
            (0x92C8, 4), (0x92E0, 4), (0x92AA, 4), (0x92FA, 4),
            (0x18B5C, 4), (0x18B68, 4),
            (0x5AEFC, 260), (0x5B000, 368), (0x5B170, 640), (0x5B400, 4860),
        ):
            allowed.update(range(off, off + n))
        changed = {i for i, (a, b) in enumerate(zip(self.fac, img)) if a != b}
        self.assertTrue(changed <= allowed, sorted(changed - allowed)[:12])

    def test_txram_m17_eot2_returns_from_unkey_and_the_wake_drops_ptt(self):
        # R4j. Same loop and end frame as R4i. on_unkey sets bit 31 and returns.
        # Tag R4j0. The wake stores cursor 0 and drops PTT. Peak count 6337.
        import numpy as np
        import m17_stream_table
        import m17

        img, _ = build.build(["c7000-txram-m17-eot2"], "R4j0", self.cfg)
        prev, _ = build.build(["c7000-txram-m17-eot1"], "R4i0", self.cfg)
        self.assertEqual(len(img), len(self.fac))
        for site in (0x92C8, 0x92E0):
            self.assertEqual(bsr32_target(img, site), 0x5B090)
        for site in (0x92AA, 0x92FA):
            self.assertEqual(bsr32_target(img, site), 0x5B128)
        self.assertEqual(bsr32_target(img, 0x18B5C), 0x5B000)
        self.assertEqual(bsr32_target(img, 0x18B68), 0x5B006)
        self.assertEqual(bsr32_target(img, 0x5B092), 0xE9C)
        self.assertEqual(bsr32_target(img, 0x5B132), 0x5AF9A)
        self.assertEqual(bsr32_runtime(img, 0x5AFB0), 0x2B220)
        self.assertEqual(bsr32_runtime(img, 0x5AFBA), 0x2B220)
        self.assertEqual(img[0x1F30:0x1F34], self.fac[0x1F30:0x1F34])
        self.assertEqual(img[0x18A70:0x18A78], self.fac[0x18A70:0x18A78])
        self.assertEqual(img[0x39408:0x5AEFC], self.fac[0x39408:0x5AEFC])
        self.assertEqual(img[0x5B000:0x5B128], prev[0x5B000:0x5B128])
        self.assertEqual(int.from_bytes(img[0x5B042:0x5B044], "little"), 0x075D)
        self.assertEqual(int.from_bytes(img[0x5B044:0x5B046], "little"), 0x3780)
        self.assertEqual(int.from_bytes(img[0x5AF0C:0x5AF0E], "little"), 0x049C)
        self.assertEqual(int.from_bytes(img[0x5AF26:0x5AF28], "little"), 0x0429)
        self.assertEqual(br16_target(img, 0x5AF26), 0x5AF78)
        self.assertEqual(int.from_bytes(img[0x5AF76:0x5AF78], "little"), 0x0474)
        self.assertEqual(br16_target(img, 0x5AF98), 0x5B05E)
        self.assertEqual(int.from_bytes(img[0x5AF78:0x5AF7A], "little"), 0x3500)
        self.assertEqual(int.from_bytes(img[0x5AF9A:0x5AF9C], "little"), 0x14D4)
        self.assertEqual(int.from_bytes(img[0x5B128:0x5B12A], "little"), 0x14D4)
        self.assertEqual(img[0x5B146:0x5B14C], bytes.fromhex("2384a73923a4"))
        off = 0x5B128
        while off + 4 <= 0x5B158:
            hi = int.from_bytes(img[off:off + 2], "little")
            if hi >> 10 == 0b111000:
                self.assertNotEqual(bsr32_target(img, off), 0xE9C)
                off += 4
            else:
                off += 2
        self.assertIn((0x11000560).to_bytes(4, "little"), img[0x5AEFC:0x5AFE4])
        self.assertIn((0x1100039C).to_bytes(4, "little"), img[0x5AEFC:0x5AFE4])
        self.assertIn((0x4DAAC).to_bytes(4, "little"), img[0x5B128:0x5B170])
        self.assertEqual(img[0x5AFE4:0x5B000], bytes(28))
        self.assertEqual(img[0x5B14E:0x5B150], bytes(2))
        self.assertEqual(int.from_bytes(img[0x5B150:0x5B154], "little"), 0x4DAAC)
        self.assertEqual(int.from_bytes(img[0x5B154:0x5B158], "little"), 0x03075400)
        self.assertEqual(img[0x5B158:0x5B170], bytes(24))
        pcm = m17_stream_table.counts_lich5()
        eot = m17_stream_table.counts_eot1()
        self.assertEqual(m17_stream_table.prediction(pcm)["peak_count"], 6451)
        eot_pred = m17_stream_table.prediction(eot)
        self.assertEqual(eot_pred["peak_count"], 6337)
        self.assertLess(eot_pred["stop_hz"], 5000)
        self.assertEqual(img[0x5B170:0x5B3F0], prev[0x5B170:0x5B3F0])
        self.assertEqual(img[0x5B3F0:0x5B400], self.fac[0x5B3F0:0x5B400])
        self.assertEqual(img[0x5B400:], prev[0x5B400:])
        self.assertEqual(img[0x3074:0x3078], self.fac[0x3074:0x3078])
        self.assertEqual(img[0x3EDFC:0x3EE02], self.fac[0x3EDFC:0x3EE02])
        self.assertEqual(img[0x38464:0x38474], b"DMR003.R4j0.V022")

        def pcm_of(blob):
            out = []
            for i in range(0, len(blob), 2):
                u = (blob[i] << 8) | blob[i + 1]
                if u >= 0x8000:
                    u -= 0x10000
                out.append(u)
            return out

        air = -m17_stream_table.HZ_PER_COUNT * np.concatenate([
            pcm[:2420], pcm[500:2420], pcm[500:2420], eot,
        ]).astype(float)
        got = m17.decode_transmission(air, 8000, verbose=False)
        lsf = got["lsf"]
        self.assertTrue(
            lsf is not None and lsf[2]
            and lsf[0] == m17_stream_table.BENCH_CALL
            and lsf[1] == m17_stream_table.BENCH_CALL
        )
        fns = [f[0] for f in got["frames"]]
        self.assertEqual(fns[-1], 0x8005)
        self.assertNotIn(0x8005, fns[:-1])
        self.assertTrue(set(fns[:-1]) <= {0, 1, 2, 3, 4, 5})
        self.assertGreaterEqual(len(fns), 8)
        self.assertTrue(all(f[1] == bytes(range(16)) and f[2] == 0 for f in got["frames"]))
        allowed = set(range(0x3846B, 0x3846F))
        for off, n in (
            (0x92C8, 4), (0x92E0, 4), (0x92AA, 4), (0x92FA, 4),
            (0x18B5C, 4), (0x18B68, 4),
            (0x5AEFC, 260), (0x5B000, 368), (0x5B170, 640), (0x5B400, 4860),
        ):
            allowed.update(range(off, off + n))
        changed = {i for i, (a, b) in enumerate(zip(self.fac, img)) if a != b}
        self.assertTrue(changed <= allowed, sorted(changed - allowed)[:12])

    def test_txram_m17_eot3_posts_the_stop_status(self):
        # R4k. Same image as R4j. drop_ptt posts status byte 4. Tag R4k0.
        import m17_stream_table

        img, _ = build.build(["c7000-txram-m17-eot3"], "R4k0", self.cfg)
        prev, _ = build.build(["c7000-txram-m17-eot2"], "R4j0", self.cfg)
        self.assertEqual(len(img), len(self.fac))
        for site in (0x92C8, 0x92E0):
            self.assertEqual(bsr32_target(img, site), 0x5B090)
        for site in (0x92AA, 0x92FA):
            self.assertEqual(bsr32_target(img, site), 0x5B128)
        self.assertEqual(bsr32_target(img, 0x18B5C), 0x5B000)
        self.assertEqual(bsr32_target(img, 0x18B68), 0x5B006)
        self.assertEqual(img[0x5B000:0x5B170], prev[0x5B000:0x5B170])
        self.assertEqual(img[0x5B170:0x5B400], prev[0x5B170:0x5B400])
        self.assertEqual(img[0x5B400:], prev[0x5B400:])
        self.assertEqual(img[0x1F30:0x1F34], self.fac[0x1F30:0x1F34])
        self.assertEqual(img[0x18A70:0x18A78], self.fac[0x18A70:0x18A78])
        self.assertEqual(img[0x39408:0x5AEFC], self.fac[0x39408:0x5AEFC])
        self.assertEqual(br16_target(img, 0x5AF98), 0x5B05E)
        found = False
        off = 0x5AF9A
        while off + 4 <= 0x5B000:
            hi = int.from_bytes(img[off:off + 2], "little")
            if hi >> 10 == 0b111000:
                if bsr32_target(img, off) == 0x7E08:
                    self.assertEqual(int.from_bytes(img[off - 2:off], "little"), 0x3004)
                    found = True
                self.assertNotEqual(bsr32_target(img, off), 0xE9C)
                off += 4
            else:
                off += 2
        self.assertTrue(found)
        self.assertEqual(img[0x38464:0x38474], b"DMR003.R4k0.V022")
        loop = m17_stream_table.prediction(m17_stream_table.counts_lich5())
        end = m17_stream_table.prediction(m17_stream_table.counts_eot1())
        self.assertEqual(loop["peak_count"], 6451)
        self.assertEqual(end["peak_count"], 6337)
        self.assertLess(loop["stop_hz"], 5000)
        self.assertLess(end["stop_hz"], 5000)
        allowed = set(range(0x3846B, 0x3846F))
        for off, n in (
            (0x92C8, 4), (0x92E0, 4), (0x92AA, 4), (0x92FA, 4),
            (0x18B5C, 4), (0x18B68, 4),
            (0x5AEFC, 260), (0x5B000, 368), (0x5B170, 640), (0x5B400, 4860),
        ):
            allowed.update(range(off, off + n))
        changed = {i for i, (a, b) in enumerate(zip(self.fac, img)) if a != b}
        self.assertTrue(changed <= allowed, sorted(changed - allowed)[:12])

    def test_iram_padbyte_changes_the_halfword_after_keyup_returns(self):
        # R3-0. No log string lives in the IRAM copy. The byte after key-up's
        # jmp r15 is alignment padding; the pool starts at the next word.
        off = 0x3EE16
        self.assertTrue(0x39408 <= off < 0x5AEFC)
        self.assertEqual(self.fac[0x3EE14:0x3EE1C], bytes.fromhex("3c78000004010011"))
        self.assertEqual(self.fac[0x3ACCC:0x3ACEC], b"TMSGTRESTSUSQUEUFLAGTSIGSEMATICK")
        img, _ = build.build(["c7000-iram-padbyte"], "R301", self.cfg)
        self.assertEqual(img[off], 0x58)
        self.assertEqual(img[0x3EE14:0x3EE1C], bytes.fromhex("3c78580004010011"))
        self.assertEqual(img[0x3ACCC:0x3ACEC], self.fac[0x3ACCC:0x3ACEC])
        self.assertEqual(img[0x3EDFC:0x3EE02], self.fac[0x3EDFC:0x3EE02])
        diff = [i for i, (a, b) in enumerate(zip(self.fac, img)) if a != b]
        self.assertEqual(diff, [0x3846B, 0x3846C, 0x3846D, 0x3846E, off])
        self.assertEqual(img[0x38464:0x38474], b"DMR003.R301.V022")

    def test_cmd40_ack_replaces_the_empty_slot(self):
        # Command 0x40's table slot was an empty pop. The thunk acks and does not key.
        img, _ = build.build(["c7000-cmd40-ack"], "R4l0", self.cfg)
        self.assertEqual(len(img), len(self.fac))
        self.assertEqual(int.from_bytes(img[0x382B8:0x382BC], "little"), 0x0304FF64)
        self.assertEqual(img[0x35F64:0x35F6C], bytes.fromhex("136c00e003009514"))
        self.assertEqual(bsr32_target(img, 0x35F72), 0x8E7C)
        self.assertEqual(img[0x35F76:0x35F78], bytes.fromhex("9014"))
        self.assertEqual(img[0xAAFE:0xAB0E], self.fac[0xAAFE:0xAB0E])
        self.assertEqual(img[0x5AEFC:0x5B000], self.fac[0x5AEFC:0x5B000])
        self.assertEqual(img[0x38464:0x38474], b"DMR003.R4l0.V022")

    def test_cmd40_ack2_uses_the_unused_gap(self):
        # R4m. Same ack, placed at +0x5AEFC. The data table at +0x35F64 stays.
        img, _ = build.build(["c7000-cmd40-ack2"], "R4m0", self.cfg)
        self.assertEqual(len(img), len(self.fac))
        self.assertEqual(int.from_bytes(img[0x382B8:0x382BC], "little"), 0x03074EFC)
        self.assertEqual(img[0x5AEFC:0x5AF04], bytes.fromhex("136c00e003009514"))
        self.assertEqual(bsr32_target(img, 0x5AF0A), 0x8E7C)
        self.assertEqual(img[0x35F64:0x35FE4], self.fac[0x35F64:0x35FE4])
        self.assertEqual(img[0xAAFE:0xAB0E], self.fac[0xAAFE:0xAB0E])
        self.assertEqual(img[0x38464:0x38474], b"DMR003.R4m0.V022")

    def test_cmd40_echo_reads_the_body_byte(self):
        # R4n. The handler at +0x5AEFC replies with the byte at frame offset 8.
        img, _ = build.build(["c7000-cmd40-echo"], "R4n0", self.cfg)
        self.assertEqual(len(img), len(self.fac))
        self.assertEqual(int.from_bytes(img[0x382B8:0x382BC], "little"), 0x03074EFC)
        self.assertEqual(img[0x5AEFC:0x5AF04], bytes.fromhex("136c00e003009514"))
        self.assertEqual(bsr32_target(img, 0x5AF2A), 0x8E5C)
        self.assertEqual(bsr32_target(img, 0x5AF32), 0x7DE8)
        self.assertEqual(img[0x5AF38:0x5AF3A], bytes.fromhex("9114"))
        self.assertEqual(img[0x35F64:0x35FE4], self.fac[0x35F64:0x35FE4])
        self.assertEqual(img[0xAAFE:0xAB0E], self.fac[0xAAFE:0xAB0E])
        self.assertEqual(img[0x5AF3A:0x5B000], self.fac[0x5AF3A:0x5B000])
        self.assertEqual(img[0x38464:0x38474], b"DMR003.R4n0.V022")

    def test_refuses_bad_tag(self):
        for tag in ("UV4T", "UV4", "UV-1"):
            with self.subTest(tag=tag), self.assertRaises(SystemExit):
                build.build([], tag, self.cfg)

    def test_unknown_patch(self):
        with self.assertRaises(SystemExit):
            build.build(["version-from-image"], "UVt0", self.cfg)


if __name__ == "__main__":
    unittest.main()
