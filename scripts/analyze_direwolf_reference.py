#!/usr/bin/env python3
"""Find where Dire Wolf reference actually starts transmitting"""

import wave
import struct

with wave.open("direwolf_reference.wav", 'rb') as wav:
    sample_rate = wav.getframerate()
    n_frames = wav.getnframes()
    audio_data = wav.readframes(n_frames)
    samples = [struct.unpack('<h', audio_data[i:i+2])[0] for i in range(0, len(audio_data), 2)]

print(f"Total samples: {len(samples)}")
print(f"Sample rate: {sample_rate} Hz")

# Find where signal starts (non-zero)
signal_start = 0
for i, s in enumerate(samples):
    if abs(s) > 100:  # Threshold for "signal present"
        signal_start = i
        break

print(f"\nSignal starts at sample {signal_start} ({signal_start/sample_rate:.3f}s)")
print(f"First 20 non-zero samples: {samples[signal_start:signal_start+20]}")

# Analyze from signal start
zero_crossings = []
for i in range(signal_start+1, len(samples)):
    if (samples[i-1] >= 0 and samples[i] < 0) or (samples[i-1] < 0 and samples[i] >= 0):
        zero_crossings.append(i - signal_start)  # Relative to signal start
        if len(zero_crossings) >= 100:
            break

print(f"\nFirst 10 zero-crossing periods (samples between crossings):")
for i in range(min(10, len(zero_crossings)-1)):
    period = zero_crossings[i+1] - zero_crossings[i]
    freq = sample_rate / (2 * period)
    print(f"  Period {i}: {period} samples -> {freq:.1f} Hz")

# Decode bits from signal_start
samples_per_bit = sample_rate / 1200
bit_string = ""
for bit_idx in range(40):
    bit_center_sample = signal_start + int((bit_idx + 0.5) * samples_per_bit)
    
    # Find nearby zero crossings
    nearby_zc = []
    for zc in zero_crossings:
        zc_abs = zc + signal_start
        if abs(zc_abs - bit_center_sample) < samples_per_bit/2:
            nearby_zc.append(zc)
    
    if len(nearby_zc) >= 2:
        periods = [nearby_zc[i+1] - nearby_zc[i] for i in range(len(nearby_zc)-1)]
        avg_period = sum(periods) / len(periods)
        freq = sample_rate / (2 * avg_period)
        
        if freq < 1700:
            bit_value = "1"
            tone = "MARK"
        else:
            bit_value = "0"
            tone = "SPACE"
        
        bit_string += bit_value
        if bit_idx < 16:
            print(f"Bit {bit_idx}: {tone:5s} ({freq:.1f} Hz) -> {bit_value}")

print(f"\nFirst 40 bits: {bit_string}")

# Decode as bytes
print("\nDecoded bytes (LSB first):")
for byte_idx in range(5):
    byte_bits = bit_string[byte_idx*8:(byte_idx+1)*8]
    if len(byte_bits) == 8:
        byte_val = sum((1 << i) if bit == '1' else 0 for i, bit in enumerate(byte_bits))
        print(f"  Byte {byte_idx}: {byte_bits} = 0x{byte_val:02X}")
