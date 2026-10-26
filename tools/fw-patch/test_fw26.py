# Host checks for FW26. The image is FW25 plus the promiscuous stubs.
# No radio and no transmission: the checks are the bytes and the disassembly.
import pathlib
import struct
import subprocess
import unittest

import fw26_build

ROOT = pathlib.Path(__file__).resolve().parents[2]
FW25 = ROOT / "radio_firmware" / "build" / "DMR003.FW25.V022.bin"
FW26 = ROOT / "radio_firmware" / "build" / "DMR003.FW26.V022.bin"
OBJDUMP = r"C:\Users\Joshua\tools\csky-elfabiv2\bin\csky-elfabiv2-objdump.exe"


def bsr_target(blob, at):
    return fw26_build.decode_bsr(at, blob[at:at + 4])


class Fw26Test(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        fw26_build.main()
        cls.fw25 = FW25.read_bytes()
        cls.img = FW26.read_bytes()
        cls.dump = subprocess.check_output(
            [OBJDUMP, "-d", r"C:\Users\Joshua\AppData\Local\Temp\fw1718\fw26\fw26.elf"],
            text=True, errors="replace")

    def test_tag_and_size(self):
        self.assertEqual(len(self.img), 378620)
        self.assertEqual(self.img[0x38464:0x38474], b"DMR003.FW26.V022")
        self.assertEqual(self.fw25[0x38464:0x38474], b"DMR003.FW25.V022")

    def test_only_the_patch_sites_and_the_tail_differ(self):
        changed = []
        for i, (a, b) in enumerate(zip(self.fw25, self.img)):
            if a != b:
                changed.append(i)
        allowed = set(range(0x3846B, 0x3846F))
        allowed.update(range(fw26_build.GATE_PATCH, fw26_build.GATE_PATCH + 4))
        for off in fw26_build.ADMIT_SITES:
            allowed.update(range(off, off + 4))
        allowed.update(range(fw26_build.FINISH_SITE, fw26_build.FINISH_SITE + 4))
        allowed.update(range(fw26_build.CC_SITE, fw26_build.CC_SITE + 4))
        allowed.update(range(fw26_build.BASE, 0x5C6FC))
        self.assertTrue(set(changed) <= allowed, [hex(i) for i in changed if i not in allowed][:12])
        self.assertIn(0x3846E, changed)

    def test_redirects_land_in_the_tail(self):
        gate = bsr_target(self.img, fw26_build.GATE_PATCH)
        admit = [bsr_target(self.img, off) for off in fw26_build.ADMIT_SITES]
        finish = bsr_target(self.img, fw26_build.FINISH_SITE)
        cc = bsr_target(self.img, fw26_build.CC_SITE)
        for target in (gate, finish, cc, *admit):
            self.assertGreaterEqual(target, fw26_build.BASE)
            self.assertLess(target, 0x5C6FC)
        self.assertEqual(admit[0], admit[1])
        self.assertEqual(self.img[fw26_build.CC_STORE:fw26_build.CC_STORE + 2], b"\x40\xb3")
        self.assertEqual(self.img[0x5B7E2:0x5B7E4], self.fw25[0x5B7E2:0x5B7E4])
        internal = []
        for line in self.dump.splitlines():
            if ".short" not in line or "0xe000" not in line:
                continue
            at = int(line.split(":")[0], 16)
            internal.append(bsr_target(self.img, at))
        self.assertEqual(sorted(internal), [0x2404, 0x7DE8, 0x8E5C])
        self.assertIn((0x030230B0).to_bytes(4, "little"), self.img[fw26_build.BASE:])

    def test_flag_off_paths_and_the_masks(self):
        def flat(text):
            return " ".join(text.split())
        finish = flat(self.dump.split("<fw26_finish>:", 1)[1].split("<fw26_ccbit>:", 1)[0])
        self.assertIn("lsri r13, r12, 4", finish)
        self.assertIn("lsri r12, r12, 19", finish)
        self.assertIn("andi r13, r13, 15", finish)
        self.assertIn("andi r12, r12, 1", finish)
        self.assertIn("movi r3, 11", finish)
        self.assertIn("jmp r12", finish)
        self.assertNotIn("jmp r15", finish)
        self.assertNotIn("lsri r12, r12, 22", finish)
        cc = flat(self.dump.split("<fw26_ccbit>:", 1)[1])
        self.assertIn("bseti r2, 8", cc)
        self.assertIn("andi r2, r2, 15", cc)
        admit = flat(self.dump.split("<fw26_admit>:", 1)[1].split("<fw26_finish>:", 1)[0])
        self.assertIn("movi r0, 1", admit)
        self.assertIn("movi r0, 0", admit)
        gate = flat(self.dump.split("<fw26_gate>:", 1)[1].split("<fw26_admit>:", 1)[0])
        self.assertIn("cmphsi r3, 16", gate)
        self.assertIn("pop r4-r7, r15", gate)

    def test_stubs_do_not_name_ptt_or_extend_the_file(self):
        stub = self.img[fw26_build.BASE:]
        self.assertNotIn(struct.pack("<I", 0x11000560), stub)
        self.assertIn(struct.pack("<I", fw26_build.FLAG), stub)
        self.assertIn(struct.pack("<I", 0x11000390), stub)
        self.assertTrue(stub.endswith(b"\x00"))


if __name__ == "__main__":
    unittest.main()
