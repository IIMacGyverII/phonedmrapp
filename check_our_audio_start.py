"""
Check samples where audio should start in our file
"""
import wave
import struct

with wave.open("aprs_fixed_test.wav", 'rb') as wav:
    nframes = wav.getnframes()
    audio_data = wav.readframes(nframes)
    samples = struct.unpack(f'<{nframes}h', audio_data)
    
    # Audio should start at sample 1170
    start = 1170
    
    print(f"Our file - samples around {start} (where audio should start):")
    for i in range(start-10, start+30):
        marker = " ← SHOULD START HERE" if i == start else ""
        print(f"  [{i:5d}] {samples[i]:6d}{marker}")
    
    # Check first 10000 audio samples for DC offset
    audio_region = samples[start:start+10000]
    avg = sum(audio_region) / len(audio_region)
    max_val = max(audio_region)
    min_val = min(audio_region)
    
    print(f"\nAudio region stats:")
    print(f"  Average (DC offset): {avg:.2f}")
    print(f"  Max: {max_val}")
    print(f"  Min: {min_val}")
    print(f"  Peak: {max(abs(max_val), abs(min_val))}")
