#!/usr/bin/env python3
"""A patch may not overwrite a literal that outside code still loads.

No phone and no key. FW23 through the shipped FW27 are checked against the
image each one was built on. An image that paints over the key helper's
pool at 0x5BE60, which is what the old FW27 did, has to be reported.
"""
import sys
import unittest
from pathlib import Path

HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))
import fw28_build  # noqa: E402
import fw29_build  # noqa: E402
import fw30_build  # noqa: E402
import literal_guard  # noqa: E402

ROOT = HERE.parent.parent / "radio_firmware" / "build"
# Each shipped image against the one it was built from.
PAIRS = (
    ("DMR003.FW22.V022.bin", "DMR003.FW23.V022.bin"),
    ("DMR003.FW23.V022.bin", "DMR003.FW24.V022.bin"),
    ("DMR003.FW24.V022.bin", "DMR003.FW25.V022.bin"),
    ("DMR003.FW25.V022.bin", "DMR003.FW26.V022.bin"),
    ("DMR003.FW26.V022.bin", "DMR003.FW27.V022.bin"),
)
POOL = range(0x5BE60, 0x5BEE0)


class LiteralGuardTest(unittest.TestCase):
    def test_shipped_images_leave_outside_loads_alone(self):
        for base_name, new_name in PAIRS:
            base = (ROOT / base_name).read_bytes()
            new = (ROOT / new_name).read_bytes()
            spans, hits = literal_guard.covered_loads(base, new)
            self.assertEqual(hits, [], "%s covers %s" % (new_name, hits[:4]))
            self.assertTrue(spans)

    def test_overwriting_the_key_pool_is_reported(self):
        base = (ROOT / "DMR003.FW26.V022.bin").read_bytes()
        bad = bytearray(base)
        bad[POOL.start:POOL.stop] = b"\xa5" * len(POOL)
        spans, hits = literal_guard.covered_loads(base, bytes(bad))
        key = [pool for pc, pool in hits if pc == 0x5BBE2]
        self.assertEqual(key, [0x5BEA0])
        self.assertTrue(all(pool in POOL for pc, pool in hits if pc == 0x5BBE2))

    def test_fw27_branch_lands_in_the_variant6_range(self):
        base = (ROOT / "DMR003.FW26.V022.bin").read_bytes()
        new = (ROOT / "DMR003.FW27.V022.bin").read_bytes()
        spans, hits = literal_guard.covered_branches(base, new)
        pcs = {pc for pc, target in hits}
        self.assertIn(0x5B7EE, pcs)
        self.assertIn(0x5B7FC, pcs)
        self.assertIn(0x5B814, pcs)
        self.assertTrue(spans)

    def test_fw28_branch_targets_stay_outside_the_patch(self):
        fw28_build.build()
        base = (ROOT / "DMR003.FW26.V022.bin").read_bytes()
        new = (ROOT / "DMR003.FW28.V022.bin").read_bytes()
        self.assertEqual(new[0x38464:0x38474], b"DMR003.FW28.V022")
        self.assertEqual(new[0x5B81A:0x5B876], base[0x5B81A:0x5B876])
        fw27 = (ROOT / "DMR003.FW27.V022.bin").read_bytes()
        self.assertEqual(new[0x5B816:0x5B81A], fw27[0x5B816:0x5B81A])
        self.assertNotEqual(new[0x5B816:0x5B81A], base[0x5B816:0x5B81A])
        spans, hits = literal_guard.covered_branches(base, new)
        self.assertEqual(hits, [], "FW28 covers %s" % (hits[:6],))
        spans, loads = literal_guard.covered_loads(base, new)
        self.assertEqual(loads, [])

    def test_changed_range_catches_fw27_and_fw28_and_passes_fw29(self):
        fw26 = (ROOT / "DMR003.FW26.V022.bin").read_bytes()
        fw27 = (ROOT / "DMR003.FW27.V022.bin").read_bytes()
        fw28_build.build()
        fw28 = (ROOT / "DMR003.FW28.V022.bin").read_bytes()
        fw29_build.build()
        fw29 = (ROOT / "DMR003.FW29.V022.bin").read_bytes()
        _, fw27_hits = literal_guard.changed_branches(fw26, fw27)
        self.assertTrue({0x5B7EE, 0x5B7FC, 0x5B814} <= {pc for pc, _ in fw27_hits})
        _, fw28_hits = literal_guard.changed_branches(fw27, fw28, fw29_build.RESTORED_EXIT)
        self.assertTrue({0x5B2BE, 0x5BCAE, 0x5C564} <= {pc for pc, _ in fw28_hits})
        _, fw29_hits = literal_guard.changed_branches(fw28, fw29, fw29_build.RESTORED_EXIT)
        self.assertEqual(fw29_hits, [], "FW29 covers %s" % (fw29_hits[:6],))
        self.assertEqual(fw29[0x5B2BE:0x5B2C2], fw26[0x5B2BE:0x5B2C2])
        self.assertNotEqual(fw29[0x5C564:0x5C568], fw28[0x5C564:0x5C568])
        self.assertNotEqual(fw29[0x5BCAE:0x5BCB2], fw28[0x5BCAE:0x5BCB2])

    def test_fw30_pulses_register_30_and_passes_the_guard(self):
        fw29_build.build()
        fw30_build.build()
        fw29 = (ROOT / "DMR003.FW29.V022.bin").read_bytes()
        fw30 = (ROOT / "DMR003.FW30.V022.image4.bin").read_bytes()
        self.assertEqual(fw30[0x5B66A:0x5B66C], bytes.fromhex("0f6d"))
        self.assertEqual(fw30[0x5B66C:0x5B672], bytes.fromhex("303001ea0670"))
        self.assertEqual(fw30[0x5B676:0x5B67C], fw29[0x5B674:0x5B67A])
        self.assertEqual(fw30[0x5B718:0x5B720], bytes.fromhex("7f246e3240b49414"))
        self.assertEqual(fw30_build.bsr_target(fw30, 0x5B672), fw30_build.bsr_target(fw29, 0x5B670))
        self.assertEqual(fw30_build.bsr_target(fw30, 0x5B68A), fw30_build.bsr_target(fw29, 0x5B688))
        _, hits = literal_guard.changed_branches(
            fw29, fw30, ((0x5B68E, 0x5B718), (0x5BCC4, 0x5BD74),
                         (0x5BCCA, 0x5BDEE), (0x5BD7E, 0x5BDBC),
                         (0x5B582, 0x5BFA0), (0x5B76E, 0x5BE00)))
        self.assertEqual(hits, [], "FW30 covers %s" % (hits[:8],))
        self.assertEqual(literal_guard.never_written(fw29, fw30), [])
        self.assertEqual(literal_guard.covered_loads(fw29, fw30)[1], [])
        self.assertEqual(fw30[0x5BCBC:0x5BCBE], bytes.fromhex("123b"))
        self.assertEqual(fw30_build.bsr_target(fw30, 0x5BCC4), 0x5BD74)
        self.assertEqual(fw30[0x5BD80:0x5BD84], bytes.fromhex("3f10c57b"))
        self.assertEqual(fw30[0x5BDFC:0x5BE00], bytes.fromhex("5cb20200"))
        self.assertEqual(fw30[0x5BD74:0x5BD76], bytes.fromhex("0987"))
        self.assertEqual(fw30[0x35F64:0x35FE4], fw29[0x35F64:0x35FE4])
        poisoned = bytearray(fw30)
        poisoned[0x35F64] = 0x12
        self.assertEqual(literal_guard.never_written(fw30, poisoned), [0x35F64])
        rows = {pc: (mnem, rest) for pc, _ln, mnem, rest in literal_guard._disassemble(fw30)
                if 0x5B660 <= pc <= 0x5B720}
        self.assertEqual(rows[0x5B66A][0], "mov")
        self.assertEqual(rows[0x5B718][0], "addi")
        self.assertEqual(rows[0x5B71A][0], "movi")
        self.assertEqual(rows[0x5B71C][0], "st.w")
        self.assertEqual(rows[0x5B71E][0], "pop")

    def test_fw30_port_refuses_ops_16_and_17_and_passes_the_guard(self):
        import fw30_port
        fw29_build.build()
        blob, syms, _moved = fw30_port.build()
        fw29 = (ROOT / "DMR003.FW29.V022.bin").read_bytes()
        fac = (ROOT.parents[1] / "radio_firmware" / "DMR003.UV4T.V022-ORIGINAL.bin").read_bytes()
        self.assertEqual(blob[0x38464:0x38474], b"DMR003.FW3B.V022")
        self.assertEqual(blob[0x18B5C:0x18B60], fac[0x18B5C:0x18B60])
        self.assertEqual(blob[0x37F4:0x37F8], fac[0x37F4:0x37F8])
        self.assertEqual(blob[0x35F64:0x35FE4], fw29[0x35F64:0x35FE4])
        self.assertEqual(fw30_build.bsr_target(blob, 0x5BCC4), syms["refuse"])
        self.assertEqual(fw30_build.bsr_target(blob, 0x5BCCA), syms["refuse"])
        self.assertEqual(fw30_build.bsr_target(blob, 0x37F8), syms["guard"])
        self.assertEqual(fw30_build.bsr_target(blob, 0x5AF4C), syms["op7"])
        self.assertEqual(fw30_build.bsr_target(blob, 0x5B748), syms["setend"])
        self.assertEqual(fw30_build.bsr_target(blob, 0x92C8), syms["pre_key"])
        self.assertEqual(fw30_build.bsr_target(blob, 0x92E0), syms["pre_key"])
        self.assertEqual(fw30_build.bsr_target(blob, 0x92AA), syms["pre_unkey"])
        self.assertEqual(fw30_build.bsr_target(blob, 0x92FA), syms["pre_unkey"])
        self.assertEqual(fw30_build.bsr_target(blob, 0x18B68), syms["pre_refill"])
        allowed = (
            (0x5BCC4, syms["refuse"]), (0x5BCCA, syms["refuse"]),
            (0x37F8, syms["guard"]), (0x5AF4C, syms["op7"]),
            (0x5B748, syms["setend"]),
            (0x92C8, syms["pre_key"]), (0x92E0, syms["pre_key"]),
            (0x92AA, syms["pre_unkey"]), (0x92FA, syms["pre_unkey"]),
            (0x18B68, syms["pre_refill"]),
            (syms["pre_key"] + 2, syms["clear"]),
            (syms["pre_unkey"] + 2, syms["clear"]),
            (syms["pre_refill"] + 2, syms["clear"]),
            (syms["op7"], syms["clear"]),
            (syms["setend"] + 2, syms["clear"]),
            (syms["guard"], syms["clear"]))
        _, hits = literal_guard.changed_branches(fw29, blob, allowed)
        self.assertEqual(hits, [], "FW30 covers %s" % (hits[:6],))
        self.assertEqual(literal_guard.never_written(fw29, blob), [])
        outside = [(pc, pool) for pc, pool in literal_guard.literal_loads(fw29)
                   if 0x5BD74 <= pool < 0x5BE34 and not (0x5BD74 <= pc < 0x5BE34)]
        self.assertEqual(outside, [])

    def test_fw56_pointers_land_in_the_patch(self):
        fw54 = (ROOT / "DMR003.FW54.V022.bin").read_bytes()
        fw56 = (ROOT / "DMR003.FW56.V022.bin").read_bytes()
        hits = set(literal_guard.pointed_into(fw54, fw56))
        self.assertIn(0x5BDE4, hits)
        self.assertIn(0x5B3FC, hits)
        self.assertIn(0x5B4A4, hits)


if __name__ == "__main__":
    unittest.main()
