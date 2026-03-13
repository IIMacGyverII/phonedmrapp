#!/usr/bin/env python3
"""Analyze the working APRS file sample-by-sample to understand encoding"""

import wave
import struct
import math

def analyze_working_file():
    filepath = "TT7F telemetry example.wav"
    
    with wave.open(filepath, 'rb') as wav:
        sample_rate = wav.getframerate()
        n_frames = wav.getnframes()
        audio_data = wav.readframes(n_frames)
        samples = [struct.unpack('<h', audio_data[i:i+2])[0] for i in range(0, len(audio_data), 2)]
    
    print(f"Sample rate: {sample_rate} Hz")
    print(f"Total samples: {len(samples)}")
    print(f"Duration: {len(samples)/sample_rate:.3f}s")
    print()
    
    # Analyze phase changes to detect frequency
    # For a sine wave, the phase increment per sample tells us the frequency
    # freq = phase_inc * sample_rate / (2*pi)
    BAUD_RATE = 1200
    samples_per_bit = sample_rate / BAUD_RATE  # ~36.75
    
    print(f"Samples per bit: {samples_per_bit:.2f}")
    print()
    
    # Try to detect zero crossings and measure periods
    print("First 20 zero-crossings:")
    zero_crossings = []
    for i in range(1, min(1000, len(samples))):
        if (samples[i-1] >= 0 and samples[i] < 0) or (samples[i-1] < 0 and samples[i] >= 0):
            zero_crossings.append(i)
    
    for i in range(min(20, len(zero_crossings)-1)):
        period_samples = zero_crossings[i+1] - zero_crossings[i]
        freq_estimate = sample_rate / (2 * period_samples)
        print(f"ZC {i}: sample {zero_crossings[i]:5d}, period={period_samples:2d} samples, freq≈{freq_estimate:6.1f} Hz")
    
    print()
    print("Trying to decode bits from zero-crossing periods:")
    print()
    #  For MARK (1200 Hz): period = 44100/1200 = 36.75 samples per cycle
    # For SPACE (2200 Hz): period = 44100/2200 = 20.05 samples per cycle
    # So half-period (zero-crossing): MARK≈18 samples, SPACE≈10 samples
    
    # Look at intervals between zero-crossings
    bit_times = []
    for bit_idx in range(50):  # Try to decode first 50 bits
        bit_center_sample = int((bit_idx + 0.5) * samples_per_bit)
        
        # Find zero crossings near this bit
        nearby_zc = [zc for zc in zero_crossings if abs(zc - bit_center_sample) < samples_per_bit/2]
        
        if len(nearby_zc) >= 2:
            # Average period between zero crossings in this bit
            periods = [nearby_zc[i+1] - nearby_zc[i] for i in range(len(nearby_zc)-1)]
            avg_period = sum(periods) / len(periods)
            freq = sample_rate / (2 * avg_period)
            
            # Classify as MARK or SPACE
            if freq < 1700:  # Midpoint between 1200 and 2200
                tone = "MARK (1200Hz)"
                bit_value = "1"
            else:
                tone = "SPACE (2200Hz)"
                bit_value = "0"
            
            print(f"Bi t {bit_idx:2d} (sample {bit_center_sample:5d}): {tone:15s} -> {bit_value}, freq≈{freq:.1f}Hz")

analyze_working_file()
