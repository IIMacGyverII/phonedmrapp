#!/usr/bin/env python3
"""Compare bit patterns between working and generated files"""

import wave
import struct

def analyze_file(filepath):
    with wave.open(filepath, 'rb') as wav:
        sample_rate = wav.getframerate()
        n_frames = wav.getnframes()
        audio_data = wav.readframes(n_frames)
        samples = [struct.unpack('<h', audio_data[i:i+2])[0] for i in range(0, len(audio_data), 2)]
    
    print(f"\n{'='*70}")
    print(f"Analyzing: {filepath}")
    print(f"{'='*70}")
    print(f"Sample rate: {sample_rate} Hz, Total samples: {len(samples)}, Duration: {len(samples)/sample_rate:.3f}s\n")
    
    BAUD_RATE = 1200
    samples_per_bit = sample_rate / BAUD_RATE
    
    # Detect zero crossings
    zero_crossings = []
    for i in range(1, min(3000, len(samples))):
        if (samples[i-1] >= 0 and samples[i] < 0) or (samples[i-1] < 0 and samples[i] >= 0):
            zero_crossings.append(i)
    
    # Decode bits
    bit_string = ""
    for bit_idx in range(50):
        bit_center_sample = int((bit_idx + 0.5) * samples_per_bit)
        nearby_zc = [zc for zc in zero_crossings if abs(zc - bit_center_sample) < samples_per_bit/2]
        
        if len(nearby_zc) >= 2:
            periods = [nearby_zc[i+1] - nearby_zc[i] for i in range(len(nearby_zc)-1)]
            avg_period = sum(periods) / len(periods)
            freq = sample_rate / (2 * avg_period)
            
            if freq < 1700:
                bit_value = "1"  # MARK
            else:
                bit_value = "0"  # SPACE
            
            bit_string += bit_value
            if bit_idx < 24:
                print(f"Bit {bit_idx:2d}: {'MARK' if bit_value=='1' else 'SPACE':5s} ({freq:6.1f} Hz)")
    
    print(f"\nBit pattern: {bit_string[:40]}")
    
    # Decode as bytes (LSB first)
    print("\nDecoded bytes (LSB first):")
    for byte_idx in range(min(5, len(bit_string)//8)):
        byte_bits = bit_string[byte_idx*8:(byte_idx+1)*8]
        if len(byte_bits) == 8:
            byte_val = sum((1 << i) if bit == '1' else 0 for i, bit in enumerate(byte_bits))
            print(f"  Byte {byte_idx}: {byte_bits} = 0x{byte_val:02X}")
    
    return bit_string

working_bits = analyze_file("TT7F telemetry example.wav")
our_bits = analyze_file(r"aprs_debug\aprs_debug\known_good_Standard_NRZI_LSB.wav")

print("\n" + "="*70)
print("COMPARISON")
print("="*70)
print(f"Working: {working_bits[:40]}")
print(f"Ours:    {our_bits[:40]}")

if working_bits[:24] == our_bits[:24]:
    print("\n✓ First 24 bits MATCH!")
else:
    print("\n✗ Bits DO NOT match")
    for i in range(min(len(working_bits), len(our_bits))):
        if i < len(working_bits) and i < len(our_bits) and working_bits[i] != our_bits[i]:
            print(f"  First difference at bit {i}: working='{working_bits[i]}' ours='{our_bits[i]}'")
            break
