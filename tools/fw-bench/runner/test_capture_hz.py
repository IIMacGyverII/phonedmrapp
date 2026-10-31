# The capture centre follows the phone frequency. The old field stayed at
# 467.385 MHz when --freq moved the phone.
#
# python tools/fw-bench/runner/test_capture_hz.py
import sys
import unittest
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
import hackrf
from common import Config


class CaptureHz(unittest.TestCase):
    def test_default_is_the_bench_offset(self):
        cfg = Config()
        self.assertEqual(hackrf.capture_hz(cfg), 467_625_000 - 240_000)

    def test_another_phone_frequency_moves_the_capture(self):
        cfg = Config(freq_hz=441_025_000)
        self.assertEqual(hackrf.capture_hz(cfg), 441_025_000 - 240_000)
        self.assertEqual(cfg.capture_hz, 467_385_000)


if __name__ == "__main__":
    unittest.main()
