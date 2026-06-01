"""
Compare our WAV file with known-good test_gen.wav
"""
import wave
import struct

def analyze_wav(filename):
    print(f"\n{'='*70}")
    print(f"Analyzing: {filename}")
    print('='*70)
    
    with wave.open(filename, 'rb') as wav:
        print(f"Channels: {wav.getnchannels()}")
        print(f"Sample width: {wav.getsampwidth()} bytes ({wav.getsampwidth()*8} bits)")
        print(f"Sample rate: {wav.getframerate()} Hz")
        print(f"Frames: {wav.getnframes()}")
        print(f"Duration: {wav.getnframes() / wav.getframerate():.3f} seconds")
        print(f"Compression: {wav.getcomptype()}")
        
        # Read first 1000 samples
        wav.rewind()
        audio_data = wav.readframes(1000)
        samples = struct.unpack(f'<{1000}h', audio_data)
        
        # Calculate statistics
        max_val = max(samples)
        min_val = min(samples)
        avg_val = sum(samples) / len(samples)
        abs_max = max(abs(max_val), abs(min_val))
        
        print(f"\nFirst 1000 samples:")
        print(f"  Max: {max_val}")
        print(f"  Min: {min_val}")
        print(f"  Average: {avg_val:.2f}")
        print(f"  Peak amplitude: {abs_max} ({abs_max/32767*100:.1f}% of max)")
        
        # Check for DC offset
        print(f"  DC offset: {avg_val:.2f} ({'YES' if abs(avg_val) > 100 else 'minimal'})")
        
        # Show first 20 samples
        print(f"\nFirst 20 sample values:")
        for i in range(20):
            print(f"  [{i:2d}] {samples[i]:6d}")

# Analyze both files
analyze_wav(r"C:\Users\Joshua\Downloads\direwolf-1.8.1-a231971_x86_64\direwolf-1.8.1-a231971_x86_64\test_gen.wav")
analyze_wav(r"C:\Users\Joshua\Documents\android\phonedmrapp\aprs_fixed_test.wav")
