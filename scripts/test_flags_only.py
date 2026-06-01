#!/usr/bin/env python3
"""Test generating pure MARK and SPACE tones to see if direwolf recognizes them"""

import struct
import wave
import math
import subprocess
import os

# Bell 202 AFSK parameters
MARK_FREQ = 1200    
SPACE_FREQ = 2200   
SAMPLE_RATE = 44100
AMPLITUDE = 8191
FLAG = 0x7E

def generate_flag_tone():
    """Generate a proper FLAG byte (01111110) using NRZI"""
    audio = []
    phase = 0.0
    
    # Start at SPACE
    current_phase_inc = 2.0 * math.pi * SPACE_FREQ / SAMPLE_RATE
    MARK_PHASE_INC = 2.0 * math.pi * MARK_FREQ / SAMPLE_RATE
    SPACE_PHASE_INC = 2.0 * math.pi * SPACE_FREQ / SAMPLE_RATE
    
    samples_per_bit = SAMPLE_RATE / 1200  # 36.75
    bit_counter = 0
    
    # FLAG = 0x7E = 01111110 (LSB first)
    # Bit 0 (0): toggle SPACE->MARK
    # Bit 1-5 (1): no change, stay at MARK  
    # Bit 6 (1): no  change, stay at MARK
    # Bit 7 (0): toggle MARK->SPACE
    
    flag_bits = [0, 1,1, 1, 1, 1, 1, 0]
    
    for bit in flag_bits:
        # NRZI: 0=toggle, 1=no change
        if bit == 0:
            if current_phase_inc == MARK_PHASE_INC:
                current_phase_inc = SPACE_PHASE_INC
            else:
                current_phase_inc = MARK_PHASE_INC
        
        bit_counter += 1
        bit_end_time = bit_counter / 1200
        bit_end_sample = int(bit_end_time * SAMPLE_RATE + 0.5)
        
        while len(audio) < bit_end_sample:
            audio.append(int(math.sin(phase) * AMPLITUDE))
            phase += current_phase_inc
            while phase >= 2.0 * math.pi:
                phase -= 2.0 * math.pi
    
    return audio

def save_wav(filename, audio_samples):
    """Save audio samples to WAV file"""
    with wave.open(filename, 'w') as wav_file:
        wav_file.setnchannels(1)  # Mono
        wav_file.setsampwidth(2)  # 16-bit
        wav_file.setframerate(SAMPLE_RATE)
        
        # Pack samples as 16-bit signed integers
        for sample in audio_samples:
            wav_file.writeframes(struct.pack('<h', sample))

# Generate test file: several FLAG bytes
audio = []

# Preamble: 200ms of SPACE tone
delay_samples = int(0.2 * SAMPLE_RATE)
phase = 0.0
SPACE_PHASE_INC = 2.0 * math.pi * SPACE_FREQ / SAMPLE_RATE
for _ in range(delay_samples):
    audio.append(int(math.sin(phase) * AMPLITUDE))
    phase += SPACE_PHASE_INC
    while phase >= 2.0 * math.pi:
        phase -= 2.0 * math.pi

# Generate several FLAG bytes
for _ in range(10):
    flag_audio = generate_flag_tone()
    audio.extend(flag_audio)

# Tail: 100ms of SPACE tone
tail_samples = int(0.1 * SAMPLE_RATE)
for _ in range(tail_samples):
    audio.append(int(math.sin(phase) * AMPLITUDE))
    phase += SPACE_PHASE_INC
    while phase >= 2.0 * math.pi:
        phase -= 2.0 * math.pi

# Save
filename = "test_flags_only.wav"
save_wav(filename, audio)
print(f"Generated {filename} with {len(audio)} samples ({len(audio)/SAMPLE_RATE:.2f}s)")

# Test with direwolf
direwolf_path = r"C:\Users\Joshua\Downloads\direwolf-1.8.1-a231971_x86_64\direwolf-1.8.1-a231971_x86_64"
atest_exe = os.path.join(direwolf_path, 'atest.exe')

try:
    result = subprocess.run([atest_exe, filename], capture_output=True, text=True, timeout=30)
    print("\nDirewolf output:")
    print(result.stdout)
    if result.stderr:
        print("Stderr:")
        print(result.stderr)
except Exception as e:
    print(f"Error running direwolf: {e}")
