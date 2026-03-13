#!/usr/bin/env python3
"""Compare Dire Wolf reference vs our fixed output"""

import wave
import struct

def analyze_file(filepath):
    with wave.open(filepath, 'rb') as wav:
        sample_rate = wav.getframerate()
        n_frames = wav.getnframes()
        audio_data = wav.readframes(n_frames)
        samples = [struct.unpack('<h', audio_data[i:i+2])[0] for i in range(0, len(audio_data), 2)]
    
    print(f"\nAnalyzing: {filepath}")
    print("=" * 70)
    print(f"Sample rate: {sample_rate} Hz, Samples: {len(samples)}, Duration: {len(samples)/sample_rate:.3f}s")
    
    BAUD_RATE = 1200
    samples_per_bit = sample_rate / BAUD_RATE
    
    # Detect zero crossings
    zero_crossings = []
    for i in range(1, min(5000, len(samples))):
        if (samples[i-1] >= 0 and samples[i] < 0) or (samples[i-1] < 0 and samples[i] >= 0):
            zero_crossings.append(i)
    
    # Decode first 30 bits
    bit_string = ""
    print("\nFirst 30 bits:")
    for bit_idx in range(30):
        bit_center_sample = int((bit_idx + 0.5) * samples_per_bit)
        nearby_zc = [zc for zc in zero_crossings if abs(zc - bit_center_sample) < samples_per_bit/2]
        
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
                print(f"Bit {bit_idx:2d}: {tone:5s} ({freq:6.1f} Hz) -> {bit_value}")
    
    print(f"\nBit pattern: {bit_string}")
    
    # Decode as bytes (LSB first)
    print("\nDecoded bytes:")
    for byte_idx in range(min(3, len(bit_string)//8)):
        byte_bits = bit_string[byte_idx*8:(byte_idx+1)*8]
        if len(byte_bits) == 8:
            byte_val = sum((1 << i) if bit == '1' else 0 for i, bit in enumerate(byte_bits))
            print(f"  Byte {byte_idx}: {byte_bits} = 0x{byte_val:02X}")
    
    # Show first 100 samples
    print(f"\nFirst 50 samples: {samples[:50]}")
    
    return bit_string

print("DIREWOLF REFERENCE vs OUR FIXED OUTPUT")
print("=" * 70)

ref_bits = analyze_file("direwolf_reference.wav")
our_bits = analyze_file("aprs_fixed_test.wav")

print("\n" + "=" * 70)
print("COMPARISON")
print("=" * 70)
print(f"Reference: {ref_bits[:40]}")
print(f"Ours:      {our_bits[:40]}")

if ref_bits[:16] == our_bits[:16]:
    print("\n✓ First 16 bits MATCH!")
else:
    print("\n✗ Bits DO NOT match")
    for i in range(min(len(ref_bits), len(our_bits))):
        if i < len(ref_bits) and i < len(our_bits) and ref_bits[i] != our_bits[i]:
            print(f"  First difference at bit {i}")
            break
