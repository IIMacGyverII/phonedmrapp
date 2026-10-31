# The no-carrier rule must see a weak carrier at the capture offset.
# A continuous carrier fills every second, so the wideband RMS and the
# quietest second match, and the old rule called that "no carrier".
#
# python tools/fw-bench/runner/test_fm_nocarrier.py
import sys
import tempfile
import unittest
from pathlib import Path

import numpy as np

HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))
import fm  # noqa: E402


class Cfg:
    fs_iq = 2_400_000
    offset_hz = 240_000
    dec = 50
    fs_a = 48_000
    stop_hz = 5000.0


def write_iq(path, z):
    # z is complex float. Scale into int8 without clipping the noise.
    peak = float(np.max(np.abs(np.real(z)))) 
    peak = max(peak, float(np.max(np.abs(np.imag(z)))), 1.0)
    scale = 80.0 / peak
    iq = np.empty(z.size * 2, np.int8)
    iq[0::2] = np.clip(np.real(z) * scale, -127, 127).astype(np.int8)
    iq[1::2] = np.clip(np.imag(z) * scale, -127, 127).astype(np.int8)
    iq.tofile(path)


def tone(cfg, seconds, freq, amp, noise):
    n = int(cfg.fs_iq * seconds)
    t = np.arange(n) / cfg.fs_iq
    rng = np.random.default_rng(1)
    z = amp * np.exp(2j * np.pi * freq * t)
    z = z + noise * (rng.standard_normal(n) + 1j * rng.standard_normal(n))
    return z.astype(np.complex64)


class NoCarrier(unittest.TestCase):
    def test_noise_only_is_no_carrier(self):
        cfg = Cfg()
        z = tone(cfg, 2.0, cfg.offset_hz, 0.0, 8.0)
        with tempfile.TemporaryDirectory() as d:
            path = Path(d) / "noise.iq"
            write_iq(path, z)
            _dev, info = fm.demod(cfg, path)
        self.assertTrue(info["no_carrier"])
        self.assertLess(info["carrier_db"], 10.0)

    def test_weak_continuous_tone_at_the_offset_is_a_carrier(self):
        # Wideband, the tone is below the noise, and it is in every second,
        # so the old quietest-second test would have said no carrier.
        cfg = Cfg()
        z = tone(cfg, 2.0, cfg.offset_hz, 6.0, 8.0)
        sec = cfg.fs_iq
        quiet = min(float(np.sqrt(np.mean(np.abs(z[i * sec:(i + 1) * sec]) ** 2))) for i in range(2))
        whole = float(np.sqrt(np.mean(np.abs(z) ** 2)))
        self.assertLessEqual(whole, quiet * (10 ** (6.0 / 20.0)))
        with tempfile.TemporaryDirectory() as d:
            path = Path(d) / "tone.iq"
            write_iq(path, z)
            _dev, info = fm.demod(cfg, path)
        self.assertFalse(info["no_carrier"], info["carrier_db"])
        self.assertGreaterEqual(info["carrier_db"], 10.0)

    def test_tone_away_from_the_offset_is_no_carrier(self):
        cfg = Cfg()
        z = tone(cfg, 2.0, cfg.offset_hz + 300_000.0, 6.0, 8.0)
        with tempfile.TemporaryDirectory() as d:
            path = Path(d) / "away.iq"
            write_iq(path, z)
            _dev, info = fm.demod(cfg, path)
        self.assertTrue(info["no_carrier"], info["carrier_db"])


if __name__ == "__main__":
    unittest.main()
