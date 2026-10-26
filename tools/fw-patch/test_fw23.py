# Host checks for opcode 13. The waveform is synthesized in the module, so this
# checks the same integer formula the stub uses, and that the built image carries
# the tag and does not add a PTT store in the new function.
import pathlib
import subprocess
import unittest

import fw23_build


ROOT = pathlib.Path(__file__).resolve().parents[2]
IMAGE = ROOT / "radio_firmware" / "build" / "DMR003.FW25.V022.bin"


class Fw23Test(unittest.TestCase):
    def test_one_kilohertz_repeats_every_eight_samples(self):
        phase = 0
        first = []
        for n in range(16):
            y, phase = fw23_build.sweep_sample(n, phase)
            first.append(y)
        self.assertEqual(first[:8], first[8:])
        self.assertEqual(max(first), 8191)
        self.assertEqual(min(first), -8191)

    def test_chirp_runs_from_50_to_just_under_3800(self):
        self.assertEqual(fw23_build.freq_hz(0), 1000)
        self.assertEqual(fw23_build.freq_hz(1599), 1000)
        self.assertEqual(fw23_build.freq_hz(1600), 50)
        self.assertEqual(fw23_build.freq_hz(23999), 3799)
        self.assertLessEqual(max(fw23_build.freq_hz(n) for n in range(1600, 24000)), 3799)

    def test_two_tone_is_a_square_at_the_symbol_level(self):
        self.assertEqual([fw23_build.square_sample(n) for n in range(8)], [8192] * 8)
        self.assertEqual([fw23_build.square_sample(n) for n in range(8, 16)], [-8192] * 8)
        self.assertEqual(fw23_build.square_sample(16), 8192)
        self.assertEqual(
            [fw23_build.square_sample(12000 + n) for n in range(4)],
            [8192, 8192, -8192, -8192])
        self.assertEqual(fw23_build.square_sample(23999), -8192)

    def test_image_tag_and_the_new_function_does_not_name_ptt(self):
        fw23_build.main()
        img = IMAGE.read_bytes()
        self.assertEqual(len(img), 378620)
        self.assertEqual(img[0x38464:0x38474], b"DMR003.FW25.V022")
        ext = img[0x5B794:0x5C6FC]
        for addr in (0x110003B0, 0x180000A0, 0x11000080, 0x11000100, 0x11000088):
            self.assertIn(addr.to_bytes(4, "little"), ext)
        # PTT exists in the inherited key path. It must not sit in the extension.
        self.assertNotIn((0x11000560).to_bytes(4, "little"), ext)
        dump = subprocess.check_output(
            [r"C:\Users\Joshua\tools\csky-elfabiv2\bin\csky-elfabiv2-objdump.exe", "-d",
             r"C:\Users\Joshua\AppData\Local\Temp\fw1718\fw21\ext.elf"],
            text=True, errors="replace")
        play = dump.split("<fw23_play>:", 1)[1].split("<fw21_clamp>:", 1)[0]
        self.assertIn("bclri", play)
        insns = [ln for ln in play.splitlines() if "\t" in ln]
        for addr in ("11000080", "11000100"):
            hits = [i for i, ln in enumerate(insns) if addr in ln.lower() and "lrw" in ln]
            self.assertGreaterEqual(len(hits), 1)
            for i in hits:
                self.assertIn("ld.w", insns[i + 1])
                self.assertNotIn("st.", insns[i + 1])


if __name__ == "__main__":
    unittest.main()
