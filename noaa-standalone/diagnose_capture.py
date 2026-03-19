#!/usr/bin/env python3
"""
NOAA Capture Diagnostic Tool
=============================
Analyses a WAV file captured from the phone's PCM hook and answers:
  1. What is the actual sample rate? (spectrum analysis)
  2. Is there a 2400 Hz subcarrier present? (FFT peak detection)
  3. Can we decode an image from it? (try multiple rates)

Usage:
  python diagnose_capture.py noaa_pcm_*.wav
  python diagnose_capture.py noaa_pcm_20260318_195800.wav
"""

import wave
import os
import sys
import numpy as np

try:
    from scipy.signal import butter, sosfilt, hilbert, resample_poly
    from scipy.fft import rfft, rfftfreq
    HAS_SCIPY = True
except ImportError:
    HAS_SCIPY = False
    print("WARNING: scipy not found – install with: pip install scipy")

try:
    from PIL import Image
    HAS_PIL = True
except ImportError:
    HAS_PIL = False
    print("ERROR: Pillow not found – install with: pip install Pillow"); sys.exit(1)

# ── APT constants ────────────────────────────────────────────────────────────
APT_RATE         = 4160
SAMPLES_PER_LINE = 2080
SUBCARRIER_HZ    = 2400.0
IMAGE_A_START    = 86
IMAGE_A_LEN      = 909
IMAGE_B_START    = 1126
IMAGE_B_LEN      = 909
IMAGE_WIDTH      = IMAGE_A_LEN + IMAGE_B_LEN  # 1818


def load_wav(path):
    with wave.open(path, 'rb') as wf:
        sr    = wf.getframerate()
        n_ch  = wf.getnchannels()
        sw    = wf.getsampwidth()
        raw   = wf.readframes(wf.getnframes())
    dtype = {1: np.uint8, 2: np.int16, 4: np.int32}[sw]
    samples = np.frombuffer(raw, dtype=dtype).astype(np.float32)
    if n_ch == 2:
        samples = samples[0::2]
    if sw == 1: samples = samples / 128.0 - 1.0
    elif sw == 2: samples /= 32768.0
    elif sw == 4: samples /= 2147483648.0
    return samples, sr


def analyse_spectrum(samples, sr, label=""):
    """Show dominant frequencies and check for 2400 Hz subcarrier."""
    # Use first 5 seconds for speed
    n = min(len(samples), 5 * sr)
    chunk = samples[:n]

    if HAS_SCIPY:
        freqs = rfftfreq(len(chunk), 1.0 / sr)
        mag   = np.abs(rfft(chunk))
    else:
        mag   = np.abs(np.fft.rfft(chunk))
        freqs = np.fft.rfftfreq(len(chunk), 1.0 / sr)

    # Top 5 peaks
    top_idx = np.argsort(mag)[-10:][::-1]
    print(f"\n{'='*60}")
    print(f"Spectrum analysis {label}  (first {n/sr:.1f}s, rate={sr} Hz)")
    print(f"{'='*60}")
    print("Top frequency components:")
    for idx in top_idx:
        print(f"  {freqs[idx]:8.1f} Hz   magnitude={mag[idx]:.0f}")

    # Check if 2400 Hz subcarrier is present
    sub_lo = max(0, int((SUBCARRIER_HZ - 200) / sr * len(chunk)))
    sub_hi = int((SUBCARRIER_HZ + 200) / sr * len(chunk))
    sub_power = mag[sub_lo:sub_hi].max() if sub_hi > sub_lo else 0.0
    total_power = mag.max()
    ratio = sub_power / total_power if total_power > 0 else 0.0
    print(f"\n2400 Hz subcarrier: peak={sub_power:.0f}  total_peak={total_power:.0f}  ratio={ratio:.3f}")
    if ratio > 0.05:
        print("  ✅ 2400 Hz subcarrier PRESENT — signal looks valid")
    else:
        print("  ❌ 2400 Hz subcarrier WEAK/ABSENT — no NOAA signal in this audio")
    return ratio > 0.05


def am_demodulate(samples, sr):
    """Hilbert-based AM demodulation (better quality than IIR)."""
    if HAS_SCIPY:
        nyq = sr / 2.0
        sos = butter(6, [SUBCARRIER_HZ - 600, SUBCARRIER_HZ + 600],
                     btype='bandpass', fs=sr, output='sos')
        filtered = sosfilt(sos, samples.astype(np.float64)).astype(np.float32)
        return np.abs(hilbert(filtered)).astype(np.float32)
    else:
        t     = np.arange(len(samples)) / sr
        i_mix = samples * np.cos(2 * np.pi * SUBCARRIER_HZ * t).astype(np.float32)
        q_mix = samples * np.sin(2 * np.pi * SUBCARRIER_HZ * t).astype(np.float32)
        w = max(1, int(round(sr / SUBCARRIER_HZ)))
        k = np.ones(w) / w
        return 2.0 * np.sqrt(np.convolve(i_mix, k, 'same')**2 + np.convolve(q_mix, k, 'same')**2)


def resample_to_apt(signal, from_rate):
    if from_rate == APT_RATE:
        return signal
    if HAS_SCIPY:
        from math import gcd
        g  = gcd(int(from_rate), APT_RATE)
        return resample_poly(signal, APT_RATE // g, from_rate // g).astype(np.float32)
    n_out = int(round(len(signal) * APT_RATE / from_rate))
    return np.interp(np.linspace(0, len(signal)-1, n_out), np.arange(len(signal)), signal).astype(np.float32)


def find_sync_offset(pixels):
    n = min(8, len(pixels) // SAMPLES_PER_LINE)
    if n < 1:
        return 0
    profile = np.zeros(SAMPLES_PER_LINE)
    for i in range(n):
        row = pixels[i * SAMPLES_PER_LINE:(i+1) * SAMPLES_PER_LINE]
        profile += np.abs(np.diff(row, append=row[-1]))
    # Sliding window of length 39
    cs  = np.cumsum(profile)
    cs  = np.concatenate([[0], cs])
    win = cs[39:] - cs[:-39]
    best = int(np.argmax(win))
    # Two peaks 1040 apart
    p2 = (best + SAMPLES_PER_LINE - 1040) % SAMPLES_PER_LINE
    return min(best, p2)


def decode_image(pixels, max_lines=400):
    """Extract pixel rows and build a PIL image."""
    offset = find_sync_offset(pixels)
    lines  = []
    pos    = offset
    while pos + SAMPLES_PER_LINE <= len(pixels) and len(lines) < max_lines:
        row = pixels[pos:pos + SAMPLES_PER_LINE]
        a   = row[IMAGE_A_START:IMAGE_A_START + IMAGE_A_LEN]
        b   = row[IMAGE_B_START:IMAGE_B_START + IMAGE_B_LEN]
        pixels_row = np.concatenate([a, b])
        lines.append(pixels_row)
        pos += SAMPLES_PER_LINE

    if not lines:
        return None
    arr = np.vstack(lines)

    # Global normalisation
    lo, hi = np.percentile(arr, 2), np.percentile(arr, 98)
    if hi - lo < 1e-6:
        return None
    arr = np.clip((arr - lo) / (hi - lo), 0, 1)
    img_data = (arr * 255).astype(np.uint8)
    return Image.fromarray(img_data, 'L')


def try_rates(samples, declared_rate, out_dir, stem):
    """Try the declared rate plus a set of common rates; save best result."""
    RATES_TO_TRY = sorted(set([
        declared_rate,
        8000, 11025, 12000, 16000, 22050, 44100, 48000,
        # Fine-grained around 12k
        11520, 12288, 13440,
    ]))

    best_std = -1
    best_rate = declared_rate

    for rate in RATES_TO_TRY:
        # Resample declared samples to this rate (by stretching the interpretation)
        # i.e. we re-interpret the bytes as if they were at `rate` instead of `declared_rate`
        reinterp = samples  # same raw bytes
        env = am_demodulate(reinterp, rate)
        apt = resample_to_apt(env, rate)
        if len(apt) < SAMPLES_PER_LINE * 4:
            continue
        img = decode_image(apt, max_lines=100)
        if img is None:
            continue
        arr = np.array(img)
        std = arr.std()
        # Also check for column structure (sync should be dark)
        sync_mean = arr[:, :39].mean()
        img_mean  = arr[:, 86:995].mean()
        structure = abs(sync_mean - img_mean)

        print(f"  rate={rate:6d}  std={std:5.1f}  sync_col={sync_mean:5.1f}  img_col={img_mean:5.1f}  structure={structure:5.1f}")

        out_path = os.path.join(out_dir, f"{stem}_rate{rate}.png")
        img.save(out_path)

        if structure > best_std:
            best_std  = structure
            best_rate = rate

    print(f"\n→ Best rate: {best_rate} Hz  (structure delta={best_std:.1f})")
    return best_rate


def main():
    if len(sys.argv) < 2:
        # Auto-find latest capture
        import glob
        captures = sorted(glob.glob("noaa_pcm_*.wav")) + \
                   sorted(glob.glob("../noaa-captures/noaa_pcm_*.wav"))
        if not captures:
            print("Usage: python diagnose_capture.py noaa_pcm_TIMESTAMP.wav")
            print("No noaa_pcm_*.wav files found in current directory or ../noaa-captures/")
            sys.exit(1)
        path = captures[-1]
        print(f"Auto-selected: {path}")
    else:
        path = sys.argv[1]

    print(f"\nAnalysing: {path}")
    samples, sr = load_wav(path)
    print(f"WAV: {sr} Hz, {len(samples)} samples, {len(samples)/sr:.1f}s")

    out_dir = os.path.dirname(os.path.abspath(path))
    stem    = os.path.splitext(os.path.basename(path))[0]

    # Step 1: Spectrum
    has_signal = analyse_spectrum(samples, sr)

    if not has_signal:
        print("\n⚠ No 2400 Hz subcarrier detected.")
        print("  Possible causes:")
        print("  - No NOAA satellite overhead during recording")
        print("  - Radio audio path filters out / distorts 2400 Hz")
        print("  - Wrong frequency (try NOAA-15: 137.620, NOAA-18: 137.9125)")
        # Still try to decode — maybe weak signal
        print("\nAttempting decode anyway at multiple rates...\n")
    else:
        print("\n✅ Signal looks valid! Trying multiple rates...\n")

    # Step 2: Try multiple rates
    print("Decoding at various assumed sample rates:")
    best = try_rates(samples, sr, out_dir, stem)

    print(f"\nOutput PNGs saved to: {out_dir}")
    print(f"Open {stem}_rate{best}.png for best result.")


if __name__ == "__main__":
    main()
