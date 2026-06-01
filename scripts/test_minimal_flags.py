#!/usr/bin/env python3
"""Minimal test - just send FLAG bytes without bit stuffing"""

import struct
import wave
import math
import subprocess
import os

MARK_FREQ = 1200
SPACE_FREQ = 2200
BAUD_RATE = 1200
SAMPLE_RATE = 44100  # Match Dire Wolf reference exactly
AMPLITUDE = int(32767 * 0.8)

MARK_PHASE_INC = 2.0 * math.pi * MARK_FREQ / SAMPLE_RATE
SPACE_PHASE_INC = 2.0 * math.pi * SPACE_FREQ / SAMPLE_RATE

def generate_afsk_simple(packet_bytes):
    """Direct FSK: 1=MARK, 0=SPACE, no bit stuffing, no NRZI"""
    audio = []
    
    # Add silence lead-in (like Dire Wolf reference: 1170 samples @ 44100 Hz = 27ms)
    for _ in range(1170):
        audio.append(0)
    
    phase = 0.0
    
    bit_start_time = 0.0
    bit_duration = 1.0 / BAUD_RATE
    
    print("\nFirst byte encoding (0x7E = 01111110):")
    
    for byte_idx, byte_val in enumerate(packet_bytes):
        for bit_idx in range(8):
            bit = (byte_val >> bit_idx) & 1  # LSB first
            
            # Direct FSK
            if bit == 1:
                phase_inc = MARK_PHASE_INC
                freq_name = "MARK"
            else:
                phase_inc = SPACE_PHASE_INC
                freq_name = "SPACE"
            
            if byte_idx == 0:  # Debug first byte
                print(f"  Bit {bit_idx}: {bit} → {freq_name} (phase_inc={phase_inc:.6f})")
            
            # Generate samples
            bit_end_time = bit_start_time + bit_duration
            sample_start = int(bit_start_time * SAMPLE_RATE)
            sample_end = int(bit_end_time * SAMPLE_RATE)
            
            samples_generated = 0
            for _ in range(sample_start, sample_end):
                sample = int(AMPLITUDE * math.sin(phase))
                audio.append(sample)
                phase += phase_inc
                phase %= (2.0 * math.pi)
                samples_generated += 1
            
            if byte_idx == 0:
                print(f"      Generated {samples_generated} samples")
            
            bit_start_time = bit_end_time
        
        if byte_idx == 0:
            print()
    
    # Add silence tail
    for _ in range(4800):  # 100ms
        audio.append(0)
    
    return audio

def save_wav(filename, audio_samples):
    with wave.open(filename, 'w') as wav_file:
        wav_file.setnchannels(1)
        wav_file.setsampwidth(2)
        wav_file.setframerate(SAMPLE_RATE)
        for sample in audio_samples:
            wav_file.writeframes(struct.pack('<h', sample))

def test_with_direwolf(wav_filename):
    direwolf_path = r"C:\Users\Joshua\Downloads\direwolf-1.8.1-a231971_x86_64\direwolf-1.8.1-a231971_x86_64"
    atest_exe = os.path.join(direwolf_path, 'atest.exe')
    
    try:
        result = subprocess.run([atest_exe, wav_filename], capture_output=True, text=True, timeout=10)
        for line in result.stdout.split('\n'):
            if ' from ' in line:
                parts = line.split()
                if parts and parts[0].isdigit():
                    return int(parts[0]), result.stdout
        return 0, result.stdout
    except Exception as e:
        return 0, str(e)

# Test 1: Just FLAGS (0x7E)
print("TEST 1: Pure FLAGS (0x7E), no bit stuffing")
print("=" * 60)
flags_only = bytes([0x7E] * 30)
audio = generate_afsk_simple(flags_only)
save_wav("test_flags_only.wav", audio)
print(f"Generated: test_flags_only.wav")

packets, output = test_with_direwolf("test_flags_only.wav")
print(f"Result: {packets} packets")
if packets == 0:
    print("Failed - no packets\n")
else:
    print(f"SUCCESS!\n{output}\n")

# Test 2: Mixed pattern to verify bit order
print("\nTEST 2: Pattern 0xAA (10101010) to verify bit order")
print("=" * 60)
pattern = bytes([0x7E] * 10 + [0xAA] * 10 + [0x7E] * 10)
audio = generate_afsk_simple(pattern)
save_wav("test_pattern.wav", audio)
print(f"Generated: test_pattern.wav")

# Analyze first byte
print("\n0xAA = 10101010 binary")
print("LSB first: bits 0,2,4,6=0 (SPACE), bits 1,3,5,7=1 (MARK)")
print("Expected: alternating SPACE-MARK pattern")

packets, output = test_with_direwolf("test_pattern.wav")
print(f"Result: {packets} packets")
