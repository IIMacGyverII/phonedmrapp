#!/usr/bin/env python3
"""Compare our FLAGS vs Dire Wolf reference sample-by-sample"""

import wave
import struct

def get_samples(filepath, max_samples=2000):
    with wave.open(filepath, 'rb') as wav:
        sample_rate = wav.getframerate()
        audio_data = wav.readframes(max_samples)
        samples = [struct.unpack('<h', audio_data[i:i+2])[0] for i in range(0, len(audio_data), 2)]
    return samples, sample_rate

# Get reference (starts at sample 1170)
ref_samples, ref_rate = get_samples("direwolf_reference.wav", 3000)
ref_signal_start = 1170
ref_signal = ref_samples[ref_signal_start:ref_signal_start+400]

# Get our test
our_samples, our_rate = get_samples("test_flags_only.wav", 2000)
our_signal = our_samples[:400]

print("SAMPLE-BY-SAMPLE COMPARISON (first 40 samples)")
print("=" * 70)
print(f"Reference sample rate: {ref_rate} Hz")
print(f"Our sample rate: {our_rate} Hz")
print()

# Check if our signal is even present
our_max = max(abs(s) for s in our_samples[:1000])
print(f"Our signal max amplitude: {our_max}")

if our_max < 100:
    print("ERROR: Our signal is too quiet or all zeros!")
else:
    print("Our signal is present, amplitude looks OK")

print("\nFirst 40 samples:")
print("Sample | Reference | Ours     | Abs Diff")
print("-------|-----------|----------|----------")
for i in range(min(40, len(ref_signal), len(our_signal))):
    diff = abs(ref_signal[i] - our_signal[i])
    print(f"{i:6d} | {ref_signal[i]:9d} | {our_signal[i]:8d} | {diff:8d}")

# Find zero crossings in both
def find_zero_crossings(samples, count=20):
    zc = []
    for i in range(1, len(samples)):
        if (samples[i-1] >= 0 and samples[i] < 0) or (samples[i-1] < 0 and samples[i] >= 0):
            zc.append(i)
            if len(zc) >= count:
                break
    return zc

ref_zc = find_zero_crossings(ref_signal)
our_zc = find_zero_crossings(our_signal)

print(f"\nReference zero crossings (first 10): {ref_zc[:10]}")
print(f"Our zero crossings (first 10): {our_zc[:10]}")

if len(ref_zc) >= 2:
    ref_period = ref_zc[1] - ref_zc[0]
    ref_freq = ref_rate / (2 * ref_period)
    print(f"\nReference first period: {ref_period} samples → {ref_freq:.1f} Hz")

if len(our_zc) >= 2:
    our_period = our_zc[1] - our_zc[0]
    our_freq = our_rate / (2 * our_period)
    print(f"Our first period: {our_period} samples → {our_freq:.1f} Hz")

# Check phase offset
print(f"\nFirst zero crossing - Reference: sample {ref_zc[0]}, Ours: sample {our_zc[0]}")
print(f"Phase offset: {our_zc[0] - ref_zc[0]} samples")
