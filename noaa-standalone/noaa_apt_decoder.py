#!/usr/bin/env python3
"""
NOAA APT (Automatic Picture Transmission) Standalone Decoder
=============================================================

Decodes weather satellite imagery from NOAA APT audio recordings.

NOAA satellite downlink frequencies:
  NOAA-15: 137.620 MHz
  NOAA-18: 137.9125 MHz
  NOAA-19: 137.100 MHz  (most active as of 2025)

Signal format:
  - VHF FM carrier → radio demodulates to audio baseband
  - Audio contains 2400 Hz AM subcarrier carrying image data
  - 2 lines/second, 909 pixels per channel per line
  - Channel A: visible (daytime) or near-infrared (nighttime)
  - Channel B: thermal infrared (always active)

APT line structure at 4160 Hz (2080 samples/line):
  Sync A   (39)  — 1040 Hz alternating burst (line sync)
  Space A  (47)  — Black (0%) reference
  Image A  (909) — Channel A pixels
  Telemetry A (45) — Calibration / wedge data
  Sync B   (39)  — 832 Hz alternating burst (second channel marker)
  Space B  (47)  — Black reference
  Image B  (909) — Channel B pixels
  Telemetry B (45) — Calibration / wedge data
  Total   2080

Usage:
  python noaa_apt_decoder.py noaa1.wav
  python noaa_apt_decoder.py noaa1.wav --output-prefix satellite_pass
  python noaa_apt_decoder.py noaa1.wav --global-norm    # use global normalization
  python noaa_apt_decoder.py noaa1.wav --no-combine     # skip combined image

Requirements:
  pip install numpy scipy Pillow
  (scipy optional but strongly recommended for better image quality)
"""

import wave
import os
import sys
import argparse
import time
import numpy as np

try:
    from scipy.signal import butter, sosfilt, hilbert, resample_poly
    HAS_SCIPY = True
except ImportError:
    HAS_SCIPY = False
    print("WARNING: scipy not found.  Using fallback (lower quality).")
    print("         Install with:  pip install scipy\n")

try:
    from PIL import Image
    HAS_PIL = True
except ImportError:
    HAS_PIL = False
    print("ERROR: Pillow not found.  Install with:  pip install Pillow")
    sys.exit(1)


# ===========================================================================
# APT line-structure constants (all in samples at APT_RATE = 4160 Hz)
# ===========================================================================

APT_RATE          = 4160     # Standard APT working sample rate (Hz)
SAMPLES_PER_LINE  = 2080     # Samples per complete line at APT_RATE
SUBCARRIER_HZ     = 2400     # AM subcarrier frequency (Hz)
LINE_RATE         = 2.0      # Lines per second

SYNC_A_SAMPLES        = 39
SPACE_A_SAMPLES       = 47
IMAGE_A_SAMPLES       = 909
TELEMETRY_A_SAMPLES   = 45
SYNC_B_SAMPLES        = 39
SPACE_B_SAMPLES       = 47
IMAGE_B_SAMPLES       = 909
TELEMETRY_B_SAMPLES   = 45

# Pixel offsets within a 2080-sample line
IMAGE_A_START = SYNC_A_SAMPLES + SPACE_A_SAMPLES                            # 86
IMAGE_B_START = (IMAGE_A_START + IMAGE_A_SAMPLES
                 + TELEMETRY_A_SAMPLES + SYNC_B_SAMPLES + SPACE_B_SAMPLES)  # 1126

# Verify totals
assert IMAGE_A_START == 86
assert IMAGE_B_START == 1126
assert (SYNC_A_SAMPLES + SPACE_A_SAMPLES + IMAGE_A_SAMPLES + TELEMETRY_A_SAMPLES
        + SYNC_B_SAMPLES + SPACE_B_SAMPLES + IMAGE_B_SAMPLES
        + TELEMETRY_B_SAMPLES) == SAMPLES_PER_LINE


# ===========================================================================
# WAV loading
# ===========================================================================

def load_wav(filename):
    """
    Load a WAV file.  Returns (samples: float32 array, sample_rate: int).
    Handles mono and stereo, 8/16/32-bit PCM.
    Stereo → takes left channel only.
    """
    with wave.open(filename, 'rb') as wf:
        sr      = wf.getframerate()
        n_ch    = wf.getnchannels()
        sw      = wf.getsampwidth()
        n_frames = wf.getnframes()
        raw     = wf.readframes(n_frames)

    dtype_map = {1: np.uint8, 2: np.int16, 4: np.int32}
    if sw not in dtype_map:
        raise ValueError(f"Unsupported sample width: {sw} bytes")

    samples = np.frombuffer(raw, dtype=dtype_map[sw]).astype(np.float32)

    if n_ch == 2:
        samples = samples[0::2]   # Left channel

    # Normalise to [-1, 1]
    if sw == 1:
        samples = samples / 128.0 - 1.0    # unsigned 8-bit: 0-255
    elif sw == 2:
        samples /= 32768.0
    elif sw == 4:
        samples /= 2147483648.0

    return samples, sr


# ===========================================================================
# AM demodulation
# ===========================================================================

def am_demodulate_scipy(samples, sample_rate):
    """
    AM demodulate via 6th-order Butterworth bandpass + Hilbert envelope.
    This is the high-quality path; requires scipy.
    """
    nyq = sample_rate / 2.0
    lo  = (SUBCARRIER_HZ - 600) / nyq
    hi  = (SUBCARRIER_HZ + 600) / nyq
    lo  = max(0.01, min(lo, 0.99))
    hi  = max(0.01, min(hi, 0.99))

    sos      = butter(6, [lo * nyq, hi * nyq], btype='bandpass',
                      fs=sample_rate, output='sos')
    filtered = sosfilt(sos, samples.astype(np.float64)).astype(np.float32)
    envelope = np.abs(hilbert(filtered)).astype(np.float32)
    return envelope


def am_demodulate_numpy(samples, sample_rate):
    """
    AM demodulate via I/Q mixing + moving-average low-pass.
    Fallback that only requires numpy.
    """
    t     = np.arange(len(samples), dtype=np.float64) / sample_rate
    i_mix = (samples * np.cos(2.0 * np.pi * SUBCARRIER_HZ * t)).astype(np.float32)
    q_mix = (samples * np.sin(2.0 * np.pi * SUBCARRIER_HZ * t)).astype(np.float32)

    # Low-pass: moving average over one subcarrier period
    w      = max(1, int(round(sample_rate / SUBCARRIER_HZ)))
    kernel = np.ones(w, dtype=np.float32) / w
    i_lp   = np.convolve(i_mix, kernel, mode='same')
    q_lp   = np.convolve(q_mix, kernel, mode='same')

    return 2.0 * np.sqrt(i_lp**2 + q_lp**2)   # ×2 to recover amplitude


def am_demodulate(samples, sample_rate):
    if HAS_SCIPY:
        return am_demodulate_scipy(samples, sample_rate)
    else:
        return am_demodulate_numpy(samples, sample_rate)


# ===========================================================================
# Resampling
# ===========================================================================

def resample_to_apt_rate(signal, from_rate):
    """Resample *signal* from *from_rate* Hz to APT_RATE (4160 Hz)."""
    if from_rate == APT_RATE:
        return signal

    if HAS_SCIPY:
        from math import gcd
        g   = gcd(int(from_rate), APT_RATE)
        up  = APT_RATE // g
        dn  = int(from_rate) // g
        return resample_poly(signal, up, dn).astype(np.float32)
    else:
        n_out = int(round(len(signal) * APT_RATE / from_rate))
        idx   = np.linspace(0, len(signal) - 1, n_out)
        return np.interp(idx, np.arange(len(signal)), signal).astype(np.float32)


# ===========================================================================
# Sync detection
# ===========================================================================

def find_sync_offset(pixels, n_lines=20):
    """
    Locate the Sync A marker within a 2080-sample period.

    Method
    ------
    Sync A (1040 Hz) and Sync B (832 Hz) both appear as high-frequency
    periodic bursts in the demodulated signal.  They recur at exactly
    the same position (mod 2080) in every APT line.

    By reshaping the signal into artificial rows of 2080 samples and
    computing the mean adjacent-sample absolute difference per column,
    we get a profile where both sync positions appear as dominant peaks.

    The two peaks are separated by exactly 1040 samples (half a line).
    We pick the smaller column index as Sync A (it comes first in the line).

    Returns
    -------
    int  — best alignment offset (0 … SAMPLES_PER_LINE-1)
    """
    n = min(n_lines, len(pixels) // SAMPLES_PER_LINE)
    if n < 3:
        return 0

    total = n * SAMPLES_PER_LINE

    # Adjacent absolute differences capture high-frequency energy
    diff    = np.abs(np.diff(pixels[:total].astype(np.float32)))
    diff    = np.r_[diff, 0.0]          # Restore length

    matrix  = diff[:total].reshape(n, SAMPLES_PER_LINE)
    profile = matrix.mean(axis=0)       # Shape: (SAMPLES_PER_LINE,)

    # Sliding-window sum of length SYNC_A_SAMPLES using the cumsum trick
    cs      = np.r_[0.0, np.cumsum(profile)]
    win_sum = cs[SYNC_A_SAMPLES:] - cs[:-SYNC_A_SAMPLES]

    P1 = int(np.argmax(win_sum))

    # The second sync (Sync B) is exactly 1040 samples later (mod 2080).
    # Sync A always precedes Sync B, so Sync A has the smaller column index.
    P2 = (P1 + SAMPLES_PER_LINE - 1040) % SAMPLES_PER_LINE

    # Return whichever candidate is closer to position 0 (start of line).
    # In practice, Sync A is always at a smaller offset than Sync B.
    return min(P1, P2)


# ===========================================================================
# Image assembly
# ===========================================================================

def build_images(pixels, offset):
    """
    Align *pixels* to the sync offset, slice into lines, extract channels.

    Returns
    -------
    (ch_a, ch_b) — uint8 numpy arrays of shape (n_lines, 909)
    """
    aligned = pixels[offset:]
    n_lines = len(aligned) // SAMPLES_PER_LINE

    if n_lines < 10:
        raise ValueError(f"Too few lines ({n_lines}); check input or increase file length")

    frame = aligned[:n_lines * SAMPLES_PER_LINE].reshape(n_lines, SAMPLES_PER_LINE)

    # Per-line normalisation using the image pixels only (more robust than
    # global normalisation, adapts to varying signal strength during the pass)
    ch_a = np.zeros((n_lines, IMAGE_A_SAMPLES), dtype=np.uint8)
    ch_b = np.zeros((n_lines, IMAGE_B_SAMPLES), dtype=np.uint8)

    for i, row in enumerate(frame):
        img_pixels = np.concatenate([
            row[IMAGE_A_START : IMAGE_A_START + IMAGE_A_SAMPLES],
            row[IMAGE_B_START : IMAGE_B_START + IMAGE_B_SAMPLES],
        ])
        lo = np.percentile(img_pixels, 1.0)
        hi = np.percentile(img_pixels, 99.0)
        if hi <= lo:
            hi = lo + 1.0

        row_norm = np.clip((row - lo) / (hi - lo) * 255.0, 0, 255).astype(np.uint8)
        ch_a[i]  = row_norm[IMAGE_A_START : IMAGE_A_START + IMAGE_A_SAMPLES]
        ch_b[i]  = row_norm[IMAGE_B_START : IMAGE_B_START + IMAGE_B_SAMPLES]

    return ch_a, ch_b


def build_images_global_norm(pixels, offset):
    """
    Alternative: global (whole-pass) normalisation.
    Simpler, but can look washed-out if signal strength varies.
    """
    lo = np.percentile(pixels, 0.5)
    hi = np.percentile(pixels, 99.5)
    if hi <= lo:
        hi = lo + 1.0
    pix_norm = np.clip((pixels - lo) / (hi - lo) * 255.0, 0, 255).astype(np.uint8)

    aligned = pix_norm[offset:]
    n_lines  = len(aligned) // SAMPLES_PER_LINE
    frame    = aligned[:n_lines * SAMPLES_PER_LINE].reshape(n_lines, SAMPLES_PER_LINE)

    ch_a = frame[:, IMAGE_A_START : IMAGE_A_START + IMAGE_A_SAMPLES]
    ch_b = frame[:, IMAGE_B_START : IMAGE_B_START + IMAGE_B_SAMPLES]
    return ch_a, ch_b


# ===========================================================================
# Main pipeline
# ===========================================================================

def decode_apt(wav_path, output_prefix=None, use_global_norm=False,
               save_combined=True, verbose=True):
    """
    Full APT decode pipeline.

    Parameters
    ----------
    wav_path        : str  — path to input WAV file
    output_prefix   : str  — file path prefix for output PNGs (default: wav stem)
    use_global_norm : bool — use global rather than per-line normalisation
    save_combined   : bool — also save a side-by-side combined image
    verbose         : bool — print progress to stdout

    Returns
    -------
    dict with keys 'n_lines', 'channel_a', 'channel_b', 'combined' (paths)
    or None on failure.
    """
    t0 = time.time()

    if output_prefix is None:
        output_prefix = os.path.splitext(wav_path)[0]

    def log(msg):
        if verbose:
            print(msg)

    log("")
    log("=" * 60)
    log("  NOAA APT Decoder")
    log("=" * 60)
    log(f"  Input  : {wav_path}")
    log(f"  Output : {output_prefix}_channel*.png")
    log("-" * 60)

    # ── 1. Load WAV ──────────────────────────────────────────────
    log("  [1/5] Loading WAV ...")
    try:
        samples, sr = load_wav(wav_path)
    except Exception as e:
        print(f"ERROR loading WAV: {e}")
        return None
    log(f"        {len(samples):,} samples  @  {sr} Hz  ({len(samples)/sr:.1f} s)")

    # ── 2. AM demodulate ─────────────────────────────────────────
    log("  [2/5] AM demodulating 2400 Hz subcarrier ...")
    log(f"        Method: {'scipy Hilbert' if HAS_SCIPY else 'numpy I/Q'}")
    envelope = am_demodulate(samples, sr)
    del samples   # Free memory early

    # ── 3. Resample → APT rate ───────────────────────────────────
    log(f"  [3/5] Resampling {sr} Hz → {APT_RATE} Hz ...")
    apt_signal = resample_to_apt_rate(envelope, sr)
    del envelope
    log(f"        {len(apt_signal):,} samples  ({len(apt_signal)/APT_RATE:.1f} s)")

    # ── 4. Find sync offset ──────────────────────────────────────
    log("  [4/5] Detecting line sync ...")
    # For sync detection use a rough global norm so pixel values are comparable
    rough_norm = np.clip(apt_signal, 0, None)
    rough_lo = np.percentile(rough_norm, 0.5)
    rough_hi = np.percentile(rough_norm, 99.5)
    if rough_hi <= rough_lo:
        rough_hi = rough_lo + 1.0
    rough_pix = ((rough_norm - rough_lo) / (rough_hi - rough_lo) * 255).astype(np.uint8)

    offset = find_sync_offset(rough_pix, n_lines=30)
    log(f"        Sync A offset: {offset} samples  ({offset / APT_RATE * 1000:.1f} ms into line)")
    del rough_pix

    # ── 5. Build images ──────────────────────────────────────────
    log("  [5/5] Extracting image pixels ...")
    norm_label = "global" if use_global_norm else "per-line"
    log(f"        Normalisation: {norm_label}")

    try:
        if use_global_norm:
            ch_a, ch_b = build_images_global_norm(apt_signal, offset)
        else:
            ch_a, ch_b = build_images(apt_signal, offset)
    except ValueError as e:
        print(f"ERROR building images: {e}")
        return None

    n_lines = ch_a.shape[0]
    log(f"        Lines decoded: {n_lines}  ({n_lines / LINE_RATE:.0f} s of image)")

    # ── Save PNGs ────────────────────────────────────────────────
    out_a = output_prefix + "_channelA.png"
    out_b = output_prefix + "_channelB.png"
    out_c = output_prefix + "_combined.png" if save_combined else None

    Image.fromarray(ch_a, mode='L').save(out_a)
    Image.fromarray(ch_b, mode='L').save(out_b)
    log(f"        Saved: {out_a}  ({ch_a.shape[1]}×{n_lines} px)")
    log(f"        Saved: {out_b}  ({ch_b.shape[1]}×{n_lines} px)")

    if save_combined and out_c:
        combined = np.hstack([ch_a, ch_b])
        Image.fromarray(combined, mode='L').save(out_c)
        log(f"        Saved: {out_c}  ({combined.shape[1]}×{n_lines} px)")

    elapsed = time.time() - t0
    log("-" * 60)
    log(f"  Done in {elapsed:.1f}s.  {n_lines} lines decoded.")
    log("=" * 60)
    log("")

    return {
        "n_lines":   n_lines,
        "channel_a": out_a,
        "channel_b": out_b,
        "combined":  out_c,
    }


# ===========================================================================
# CLI entry point
# ===========================================================================

def main():
    parser = argparse.ArgumentParser(
        description="NOAA APT weather satellite image decoder",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog=__doc__,
    )
    parser.add_argument("wav_file",
        help="Input WAV file (NOAA APT audio recording)")
    parser.add_argument("--output-prefix", "-o", default=None,
        help="Output filename prefix (default: same stem as input)")
    parser.add_argument("--global-norm", action="store_true",
        help="Use global normalisation instead of per-line (simpler)")
    parser.add_argument("--no-combine", action="store_true",
        help="Skip combined side-by-side image")
    parser.add_argument("--quiet", "-q", action="store_true",
        help="Suppress progress output")

    args = parser.parse_args()

    if not os.path.isfile(args.wav_file):
        print(f"ERROR: File not found: {args.wav_file}")
        sys.exit(1)

    result = decode_apt(
        wav_path       = args.wav_file,
        output_prefix  = args.output_prefix,
        use_global_norm= args.global_norm,
        save_combined  = not args.no_combine,
        verbose        = not args.quiet,
    )

    if result is None:
        sys.exit(1)


if __name__ == "__main__":
    main()
