#!/usr/bin/env python3
"""
Quick audio analysis to check if AFSK signal is present
"""
import wave
import numpy as np
import sys

def analyze_audio(filename):
    with wave.open(filename, 'rb') as wav:
        sample_rate = wav.getframerate()
        n_channels = wav.getnchannels()
        n_frames = wav.getnframes()
        audio_data = wav.readframes(n_frames)
        
    # Convert to numpy array
    samples = np.frombuffer(audio_data, dtype=np.int16)
    
    print(f"File: {filename}")
    print(f"  Sample rate: {sample_rate} Hz")
    print(f"  Channels: {n_channels}")
    print(f"  Samples: {len(samples)}")
    print(f"  Duration: {len(samples)/sample_rate:.2f} seconds")
    print(f"  Min value: {samples.min()}")
    print(f"  Max value: {samples.max()}")
    print(f"  Mean: {samples.mean():.1f}")
    print(f"  Std dev: {samples.std():.1f}")
    print(f"  RMS: {np.sqrt(np.mean(samples**2)):.1f}")
    
    # Check if signal is mostly silent or clipped
    silent_threshold = 100
    silent_count = np.sum(np.abs(samples) < silent_threshold)
    silent_percent = (silent_count / len(samples)) * 100
    
    clipped_count = np.sum(np.abs(samples) > 32000)
    clipped_percent = (clipped_count / len(samples)) * 100
    
    print(f"  Silent samples (< {silent_threshold}): {silent_percent:.1f}%")
    print(f"  Clipped samples (> 32000): {clipped_percent:.1f}%")
    
    # FFT to see frequency content
    fft = np.fft.rfft(samples)
    freqs = np.fft.rfftfreq(len(samples), 1/sample_rate)
    magnitudes = np.abs(fft)
    
    # Find peak frequency
    peak_idx = np.argmax(magnitudes)
    peak_freq = freqs[peak_idx]
    print(f"  Peak frequency: {peak_freq:.1f} Hz")
    
    # Check for energy around 1200 Hz and 2200 Hz
    def energy_around(target_freq, width=100):
        mask = (freqs >= target_freq - width) & (freqs <= target_freq + width)
        return np.sum(magnitudes[mask])
    
    energy_1200 = energy_around(1200)
    energy_2200 = energy_around(2200)
    total_energy = np.sum(magnitudes)
    
    print(f"  Energy around 1200 Hz: {(energy_1200/total_energy)*100:.2f}% of total")
    print(f"  Energy around 2200 Hz: {(energy_2200/total_energy)*100:.2f}% of total")
    
    if energy_1200 > total_energy * 0.001 or energy_2200 > total_energy * 0.001:
        print("  ✓ AFSK tones detected!")
    else:
        print("  ✗ No significant AFSK tones found")
    
if __name__ == "__main__":
    if len(sys.argv) > 1:
        for filename in sys.argv[1:]:
            analyze_audio(filename)
            print()
    else:
        print("Usage: python analyze_audio.py <audio_file.wav> ...")
