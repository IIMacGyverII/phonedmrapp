#!/usr/bin/env python3
"""Analyze a working APRS audio file to understand the correct structure"""

import wave
import struct
import math

def analyze_wav(filename):
    """Analyze WAV file structure"""
    with wave.open(filename, 'r') as wav:
        print(f"File: {filename}")
        print(f"Channels: {wav.getnchannels()}")
        print(f"Sample width: {wav.getsampwidth()} bytes")
        print(f"Sample rate: {wav.getframerate()} Hz")
        print(f"Frames: {wav.getnframes()}")
        print(f"Duration: {wav.getnframes() / wav.getframerate():.3f}s")
        
        # Read all samples
        sample_rate = wav.getframerate()
        frames = wav.readframes(wav.getnframes())
        
        # Unpack as 16-bit signed integers
        samples = struct.unpack(f'<{len(frames)//2}h', frames)
        
        print(f"\nTotal samples: {len(samples)}")
        print(f"Min sample: {min(samples)}")
        print(f"Max sample: {max(samples)}")
        print(f"First 20 samples: {samples[:20]}")
        
        # Try to detect frequencies using zero-crossing rate
        # Look at first 1000 samples
        analyze_segment = samples[:1000]
        zero_crossings = 0
        for i in range(1, len(analyze_segment)):
            if (analyze_segment[i-1] >= 0 and analyze_segment[i] < 0) or \
               (analyze_segment[i-1] < 0 and analyze_segment[i] >= 0):
                zero_crossings += 1
        
        # Frequency = (zero_crossings / 2) / (samples / sample_rate)
        duration_ms = len(analyze_segment) / sample_rate * 1000
        estimated_freq = (zero_crossings / 2) / (len(analyze_segment) / sample_rate)
        
        print(f"\nFirst {len(analyze_segment)} samples analysis:")
        print(f"Zero crossings: {zero_crossings}")
        print(f"Estimated frequency: {estimated_freq:.1f} Hz")
        print(f"Duration analyzed: {duration_ms:.1f} ms")
        
        # Check if it's close to 1200 Hz or 2200 Hz
        if abs(estimated_freq - 1200) < 100:
            print("→ Preamble appears to be 1200 Hz (MARK)")
        elif abs(estimated_freq - 2200) < 100:
            print("→ Preamble appears to be 2200 Hz (SPACE)")
        
        return samples, sample_rate

if __name__ == "__main__":
    filename = r"C:\Users\Joshua\Documents\android\phonedmrapp\TT7F telemetry example.wav"
    samples, rate = analyze_wav(filename)
    
    print("\n" + "=" * 60)
    print("Key findings for AFSK generation:")
    print("=" * 60)
    print(f"1. Use sample rate: {rate} Hz")
    print(f"2. Sample amplitude range: ±{max(abs(min(samples)), abs(max(samples)))}")
    print(f"3. Check if preamble is MARK (1200Hz) or SPACE (2200Hz)")
