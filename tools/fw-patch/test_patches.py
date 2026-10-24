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

    def test_refuses_bad_tag(self):
        for tag in ("UV4T", "UV4", "UV-1"):
            with self.subTest(tag=tag), self.assertRaises(SystemExit):
                build.build([], tag, self.cfg)

    def test_unknown_patch(self):
        with self.assertRaises(SystemExit):
            build.build(["version-from-image"], "UVt0", self.cfg)


if __name__ == "__main__":
    unittest.main()
