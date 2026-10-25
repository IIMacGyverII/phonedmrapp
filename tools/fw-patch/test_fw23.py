# Host checks for opcode 13. The waveform is synthesized in the module, so this
# checks the same integer formula the stub uses, and that the built image carries
# the tag and does not add a PTT store in the new function.
import pathlib
import unittest

import fw23_build


ROOT = pathlib.Path(__file__).resolve().parents[2]
IMAGE = ROOT / "radio_firmware" / "build" / "DMR003.FW23.V022.bin"


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

    def test_image_tag_and_the_new_function_does_not_name_ptt(self):
        img = IMAGE.read_bytes()
        self.assertEqual(len(img), 378620)
        self.assertEqual(img[0x38464:0x38474], b"DMR003.FW23.V022")
        # The play function's literal pool holds the codec and the irq flag, not PTT.
        self.assertIn((0x110003B0).to_bytes(4, "little"), img)
        self.assertIn((0x180000A0).to_bytes(4, "little"), img)
        # PTT exists in the inherited key path. It must not sit in the new tail.
        tail = img[0x5BC7E:0x5C070]
        self.assertNotIn((0x11000560).to_bytes(4, "little"), tail)


if __name__ == "__main__":
    unittest.main()
