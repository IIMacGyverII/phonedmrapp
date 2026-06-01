#!/usr/bin/env python3
"""
APRS Audio Analyzer - Compares two WAV files to identify differences
that might prevent AFSK decoding.
"""

import soundfile as sf
import numpy as np
from scipy.fft import fft, fftfreq
from scipy import signal
import sys

def analyze_wav(filename):
    """Comprehensive audio analysis for APRS AFSK debugging"""
    print(f"\n{'='*70}")
    print(f"Analyzing: {filename}")
    print(f"{'='*70}")
    
    # Load audio
    data, fs = sf.read(filename)
    
    # Convert stereo to mono if needed
    if data.ndim > 1:
        data = data.mean(axis=1)
        print(f"Channels: Stereo (averaged to mono)")
    else:
        print(f"Channels: Mono")
    
    N = len(data)
    duration = N / fs
    
    print(f"\nBasic Info:")
    print(f"  Sample rate: {fs} Hz")
    print(f"  Duration: {duration:.3f} seconds")
    print(f"  Total samples: {N:,}")
    
    # Amplitude statistics
    peak = np.max(np.abs(data))
    rms = np.sqrt(np.mean(data**2))
    
    print(f"\nAmplitude Statistics:")
    print(f"  Peak level: {peak:.4f} ({20*np.log10(peak+1e-10):.1f} dB)")
    print(f"  RMS level: {rms:.4f} ({20*np.log10(rms+1e-10):.1f} dB)")
    print(f"  Dynamic range: {peak/rms:.2f}")
    
    # Check for clipping
    clipped_samples = np.sum(np.abs(data) > 0.99)
    if clipped_samples > 0:
        print(f"  ⚠️  WARNING: {clipped_samples} samples clipped!")
    
    # Check for silence
    silent_samples = np.sum(np.abs(data) < 0.001)
    silence_percent = (silent_samples / N) * 100
    print(f"  Silent samples: {silent_samples:,} ({silence_percent:.1f}%)")
    
    # Frequency analysis using FFT
    print(f"\nFrequency Analysis:")
    
    # Use only first 2 seconds for FFT (or whole file if shorter)
    analysis_samples = min(N, int(2 * fs))
    yf = fft(data[:analysis_samples])
    xf = fftfreq(analysis_samples, 1/fs)[:analysis_samples//2]
    magnitude = np.abs(yf[:analysis_samples//2])
    
    # Find dominant frequencies
    # Only look in AFSK range (1000-2500 Hz for APRS)
    afsk_mask = (xf >= 1000) & (xf <= 2500)
    afsk_freqs = xf[afsk_mask]
    afsk_mag = magnitude[afsk_mask]
    
    if len(afsk_mag) > 0:
        # Find peaks
        peaks, properties = signal.find_peaks(afsk_mag, height=np.max(afsk_mag)*0.1, distance=20)
        
        if len(peaks) > 0:
            # Sort by magnitude
            sorted_idx = np.argsort(afsk_mag[peaks])[::-1]
            top_peaks = sorted_idx[:5]  # Top 5 peaks
            
            print(f"  Top frequencies in AFSK range (1000-2500 Hz):")
            for i, peak_idx in enumerate(top_peaks):
                if i >= len(peaks):
                    break
                freq = afsk_freqs[peaks[peak_idx]]
                mag = afsk_mag[peaks[peak_idx]]
                mag_db = 20*np.log10(mag+1e-10)
                print(f"    {i+1}. {freq:.1f} Hz @ {mag_db:.1f} dB")
                
                # Check if near APRS frequencies
                if abs(freq - 1200) < 50:
                    print(f"       ✓ Near MARK (1200 Hz)")
                elif abs(freq - 2200) < 50:
                    print(f"       ✓ Near SPACE (2200 Hz)")
        else:
            print(f"  ⚠️  WARNING: No significant peaks found in AFSK range!")
    
    # Find overall dominant frequency
    overall_peak_idx = np.argmax(magnitude)
    overall_peak_freq = xf[overall_peak_idx]
    print(f"\n  Overall dominant frequency: {overall_peak_freq:.1f} Hz")
    
    # Check energy distribution
    total_energy = np.sum(magnitude**2)
    afsk_energy = np.sum(afsk_mag**2) if len(afsk_mag) > 0 else 0
    afsk_energy_percent = (afsk_energy / total_energy) * 100
    print(f"  Energy in AFSK range: {afsk_energy_percent:.1f}%")
    
    # Time-domain features
    print(f"\nTime-Domain Features:")
    
    # Check for DC offset
    dc_offset = np.mean(data)
    print(f"  DC offset: {dc_offset:.6f}")
    
    # Zero crossing rate (indicator of frequency)
    zero_crossings = np.sum(np.diff(np.sign(data)) != 0)
    zcr = zero_crossings / duration
    print(f"  Zero crossing rate: {zcr:.1f} Hz")
    print(f"    (Approximate frequency: {zcr/2:.1f} Hz)")
    
    # Estimate baud rate from zero crossings
    # For AFSK: ZCR should be ~2x the tone frequency
    # For 1200 baud: expect ~1200-2200 Hz tones → ~2400-4400 ZCR
    if 2000 < zcr < 5000:
        print(f"    ✓ Zero crossing rate consistent with AFSK/APRS")
    else:
        print(f"    ⚠️  Zero crossing rate unusual for AFSK!")
    
    print(f"\n{'='*70}\n")

def compare_files(file1, file2):
    """Compare two files and highlight differences"""
    print(f"\n{'#'*70}")
    print(f"COMPARISON SUMMARY")
    print(f"{'#'*70}")
    
    data1, fs1 = sf.read(file1)
    data2, fs2 = sf.read(file2)
    
    if data1.ndim > 1:
        data1 = data1.mean(axis=1)
    if data2.ndim > 1:
        data2 = data2.mean(axis=1)
    
    print(f"\nFile 1: {file1}")
    print(f"File 2: {file2}")
    print(f"\nDifferences:")
    
    if fs1 != fs2:
        print(f"  ⚠️  Sample rate: {fs1} Hz vs {fs2} Hz (DIFFERENT!)")
    else:
        print(f"  ✓ Sample rate: Both {fs1} Hz")
    
    peak1 = np.max(np.abs(data1))
    peak2 = np.max(np.abs(data2))
    rms1 = np.sqrt(np.mean(data1**2))
    rms2 = np.sqrt(np.mean(data2**2))
    
    print(f"\n  Amplitude comparison:")
    print(f"    File 1 peak: {peak1:.4f}")
    print(f"    File 2 peak: {peak2:.4f}")
    print(f"    Ratio: {peak2/peak1:.2f}x")
    
    print(f"\n  RMS comparison:")
    print(f"    File 1 RMS: {rms1:.4f}")
    print(f"    File 2 RMS: {rms2:.4f}")
    print(f"    Ratio: {rms2/rms1:.2f}x")
    
    if abs(rms2/rms1 - 1.0) > 0.5:
        print(f"    ⚠️  Large RMS difference - amplitude issue!")
    
    print(f"\n{'#'*70}\n")

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python analyze_aprs_audio.py <file1.wav> [file2.wav]")
        sys.exit(1)
    
    # Analyze first file
    analyze_wav(sys.argv[1])
    
    # Analyze second file if provided
    if len(sys.argv) >= 3:
        analyze_wav(sys.argv[2])
        compare_files(sys.argv[1], sys.argv[2])
