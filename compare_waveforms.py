#!/usr/bin/env python3
"""Compare our generated AFSK to the working file"""

import wave
import struct
import math

def read_wav(filename):
    """Read WAV file and return samples"""
    with wave.open(filename, 'r') as wav:
        frames = wav.readframes(wav.getnframes())
        samples = struct.unpack(f'<{len(frames)//2}h', frames)
        return list(samples), wav.getframerate()

def detect_tone_frequency(samples, sample_rate, start_idx=0, count=100):
    """Detect frequency using zero-crossing"""
    segment = samples[start_idx:start_idx+count]
    zero_crossings = 0
    for i in range(1, len(segment)):
        if (segment[i-1] >= 0 and segment[i] < 0) or \
           (segment[i-1] < 0 and segment[i] >= 0):
            zero_crossings += 1
    
    if zero_crossings == 0:
        return 0
    
    freq = (zero_crossings / 2) / (len(segment) / sample_rate)
    return freq

# Read working file
working_file = r"C:\Users\Joshua\Documents\android\phonedmrapp\TT7F telemetry example.wav"
working_samples, working_rate = read_wav(working_file)

print("=" * 70)
print("WORKING FILE ANALYSIS")
print("=" * 70)
print(f"Sample rate: {working_rate} Hz")
print(f"Total samples: {len(working_samples)}")
print(f"Duration: {len(working_samples)/working_rate:.3f}s")
print(f"\nFirst 30 samples:")
for i in range(0, 30, 10):
    print(f"  [{i:3d}-{i+9:3d}]: {working_samples[i:i+10]}")

# Analyze frequency in different sections
print(f"\nFrequency analysis (100-sample windows):")
for start in [0, 500, 1000, 2000, 5000, 10000]:
    if start < len(working_samples) - 100:
        freq = detect_tone_frequency(working_samples, working_rate, start, 100)
        print(f"  Samples {start:5d}-{start+100:5d}: {freq:7.1f} Hz", end="")
        if abs(freq - 1200) < 100:
            print(" (MARK)")
        elif abs(freq - 2200) < 100:
            print(" (SPACE)")
        else:
            print(" (unknown/mixed)")

# Read one of our generated files
our_file = r"C:\Users\Joshua\Documents\android\phonedmrapp\aprs_debug\aprs_debug\known_good_Standard_NRZI_LSB.wav"
our_samples, our_rate = read_wav(our_file)

print("\n" +"=" * 70)
print("OUR GENERATED FILE ANALYSIS")
print("=" * 70)
print(f"Sample rate: {our_rate} Hz")
print(f"Total samples: {len(our_samples)}")
print(f"Duration: {len(our_samples)/our_rate:.3f}s")
print(f"\nFirst 30 samples:")
for i in range(0, 30, 10):
    print(f"  [{i:3d}-{i+9:3d}]: {our_samples[i:i+10]}")

print(f"\nFrequency analysis (100-sample windows):")
for start in [0, 500, 1000, 2000, 5000]:
    if start < len(our_samples) - 100:
        freq = detect_tone_frequency(our_samples, our_rate, start, 100)
        print(f"  Samples {start:5d}-{start+100:5d}: {freq:7.1f} Hz", end="")
        if abs(freq - 1200) < 100:
            print(" (MARK)")
        elif abs(freq - 2200) < 100:
            print(" (SPACE)")
        else:
            print(" (unknown/mixed)")

print("\n" + "=" * 70)
print("KEY DIFFERENCES")
print("=" * 70)
print(f"Sample rate: Working={working_rate}, Ours={our_rate}")
print(f"Amplitude: Working=±{max(abs(max(working_samples)), abs(min(working_samples)))}, " +
      f"Ours=±{max(abs(max(our_samples)), abs(min(our_samples)))}")
