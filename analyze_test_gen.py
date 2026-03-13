"""
Find where audio actually starts in test_gen.wav and check DC offset throughout
"""
import wave
import struct

with wave.open(r"C:\Users\Joshua\Downloads\direwolf-1.8.1-a231971_x86_64\direwolf-1.8.1-a231971_x86_64\test_gen.wav", 'rb') as wav:
    n_frames = wav.getnframes()
    audio_data = wav.readframes(n_frames)
    samples = struct.unpack(f'<{n_frames}h', audio_data)
    
    # Find where signal starts (first non-zero)
    start = 0
    for i, s in enumerate(samples):
        if abs(s) > 100:
            start = i
            break
    
    print(f"Signal starts at sample {start} ({start/44100*1000:.1f}ms)")
    print(f"\nSamples around signal start:")
    for i in range(max(0, start-10), min(start+30, len(samples))):
        marker = " ← START" if i == start else ""
        print(f"  [{i:5d}] {samples[i]:6d}{marker}")
    
    # Check DC offset in audio region
    audio_samples = samples[start:start+10000]
    avg = sum(audio_samples) / len(audio_samples)
    max_val = max(audio_samples)
    min_val = min(audio_samples)
    
    print(f"\nAudio region (samples {start}-{start+10000}):")
    print(f"  Average (DC offset): {avg:.2f}")
    print(f"  Max: {max_val}")
    print(f"  Min: {min_val}")
    print(f"  Peak amplitude: {max(abs(max_val), abs(min_val))}")
