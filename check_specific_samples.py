#!/usr/bin/env python3
"""Check frequency at specific sample ranges where we know what frequency should be"""

import wave
import struct

def detect_tone_frequency(samples, sample_rate, start_idx=0, count=100):
    """Detect frequency using zero-crossing rate"""
    segment = samples[start_idx:start_idx+count]
    zero_crossings = 0
    for i in range(1, len(segment)):
        if (segment[i-1] >= 0 and segment[i] < 0) or \
           (segment[i-1] < 0 and segment[i] >= 0):
            zero_crossings += 1
    freq = (zero_crossings / 2) / (len(segment) / sample_rate)
    return freq

# Read our generated file
filepath = r'aprs_debug\aprs_debug\known_good_Standard_NRZI_LSB.wav'
with wave.open(filepath, 'rb') as wav:
    sample_rate = wav.getframerate()
    n_frames = wav.getnframes()
    audio_data = wav.readframes(n_frames)
    samples = [struct.unpack('<h', audio_data[i:i+2])[0] for i in range(0, len(audio_data), 2)]

print("Our generated file specific sample analysis:")
print(f"Total samples: {len(samples)}")
print()

# Preamble is 200ms = 0.2 * 44100 = 8820 samples (SPACE tone)
# Then packet starts:
#   Bit 0-6 (byte 0, bits 0-6): ~7 * 36.75 = 257 samples (mostly MARK)
#   Bit 7 (byte 0, bit 7): ~36.75 samples at SPACE (2200 Hz)
#   Bit 8 (byte 1, bit 0): ~36.75 samples at MARK (1200 Hz)

preamble_end = 8820
bit_samples = 36.75

# Check preamble (should be SPACE = 2200 Hz)
print(f"Preamble samples 8000-8100 (should be 2200 Hz SPACE):")
freq = detect_tone_frequency(samples, sample_rate, 8000, 100)
print(f"  Frequency: {freq:.1f} Hz")
print()

# Bit 0-6 are at MARK (1200 Hz after first toggle)
bit0_start = preamble_end
print(f"Bit 0-1 samples {bit0_start}-{bit0_start+100} (should be 1200 Hz MARK):")
freq = detect_tone_frequency(samples, sample_rate, bit0_start, 100)
print(f"  Frequency: {freq:.1f} Hz")
print()

# Bit 7 at SPACE (toggles from MARK to SPACE)
bit7_start = int(preamble_end + 7 * bit_samples)
print(f"Bit 7 sample {bit7_start}-{bit7_start+36} (should be 2200 Hz SPACE):")
freq = detect_tone_frequency(samples, sample_rate, bit7_start, 36)
print(f"  Frequency: {freq:.1f} Hz")
print()

# Bit 8 at MARK (toggles from SPACE to MARK)
bit8_start = int(preamble_end + 8 * bit_samples)
print(f"Bit 8 sample {bit8_start}-{bit8_start+36} (should be 1200 Hz MARK):")
freq = detect_tone_frequency(samples, sample_rate, bit8_start, 36)
print(f"  Frequency: {freq:.1f} Hz")
print()

# Bit 10 at SPACE (toggles from MARK to SPACE)
bit10_start = int(preamble_end + 10 * bit_samples)
print(f"Bit 10 sample {bit10_start}-{bit10_start+36} (should be 2200 Hz SPACE):")
freq = detect_tone_frequency(samples, sample_rate, bit10_start, 36)
print(f"  Frequency: {freq:.1f} Hz")
