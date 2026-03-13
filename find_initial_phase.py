"""
Calculate what initial phase test_gen.wav uses
"""
import wave
import struct
import math

with wave.open("test_gen_copy.wav", 'rb') as wav:
    wav.readframes(1170)  # Skip silence
    audio_data = wav.readframes(10)
    samples = struct.unpack(f'<10h', audio_data)

print("First 10 samples from test_gen:")
for i, s in enumerate(samples):
    print(f"  [{i}] {s:6d}")

# For 1200 Hz MARK tone at 44100 Hz sample rate:
freq = 1200
sample_rate = 44100
amplitude = 8191

# y = A * sin(phase)
# phase = arcsin(y / A)

print(f"\nAssuming {freq} Hz tone (SPACE for first bit):")
print(f"Sample 0: {samples[0]} / {amplitude} = {samples[0]/amplitude:.6f}")
phase_0 = math.asin(samples[0] / amplitude)
print(f"Initial phase: {phase_0:.6f} radians ({math.degrees(phase_0):.2f}°)")

# Verify this makes sense by checking next samples
phase_inc = 2.0 * math.pi * freq / sample_rate
print(f"\nVerification (phase inc = {phase_inc:.6f}):")
phase = phase_0
for i in range(10):
    predicted = amplitude * math.sin(phase)
    actual = samples[i]
    print(f"  [{i}] Predicted: {predicted:7.1f}  Actual: {actual:6d}  Error: {abs(predicted-actual):.1f}")
    phase += phase_inc
