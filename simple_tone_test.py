#!/usr/bin/env python3
"""Simple tone generator to test AFSK basics"""

import struct
import wave
import math

SAMPLE_RATE = 48000
FREQ_1200 = 1200
FREQ_2200 = 2200

def generate_pure_tones():
    """Generate 200ms of 1200Hz, then 200ms of 2200Hz"""
    audio = []
    phase = 0.0
    
    # 200ms of 1200 Hz
    phase_inc_1200 = 2.0 * math.pi * FREQ_1200 / SAMPLE_RATE
    for i in range(int(0.2 * SAMPLE_RATE)):
        audio.append(int(math.sin(phase) * 32767 * 0.8))
        phase += phase_inc_1200
        while phase >= 2.0 * math.pi:
            phase -= 2.0 * math.pi
    
    # 200ms of 2200 Hz
    phase_inc_2200 = 2.0 * math.pi * FREQ_2200 / SAMPLE_RATE
    for i in range(int(0.2 * SAMPLE_RATE)):
        audio.append(int(math.sin(phase) * 32767 * 0.8))
        phase += phase_inc_2200
        while phase >= 2.0 * math.pi:
            phase -= 2.0 * math.pi
    
    return audio

def save_wav(filename, audio_samples):
    """Save audio samples to WAV file"""
    with wave.open(filename, 'w') as wav_file:
        wav_file.setnchannels(1)  # Mono
        wav_file.setsampwidth(2)  # 16-bit
        wav_file.setframerate(SAMPLE_RATE)
        
        for sample in audio_samples:
            wav_file.writeframes(struct.pack('<h', sample))

if __name__ == "__main__":
    audio = generate_pure_tones()
    filename = r"C:\Users\Joshua\Documents\android\phonedmrapp\aprs_debug\aprs_debug\tone_test.wav"
    save_wav(filename, audio)
    print(f"Generated {len(audio)} samples ({len(audio)/SAMPLE_RATE:.2f}s)")
    print(f"Saved to: {filename}")
    print("This should be 200ms @ 1200Hz, then 200ms @ 2200Hz")
