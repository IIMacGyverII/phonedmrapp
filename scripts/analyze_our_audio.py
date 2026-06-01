import wave
import struct

# Read our generated audio
with wave.open('test_flags_only.wav', 'rb') as wav:
    sample_rate = wav.getframerate()
    n_channels = wav.getnchannels()
    sampwidth = wav.getsampwidth()
    n_frames = wav.getnframes()
    
    audio_data = wav.readframes(n_frames)
    
    # Convert to samples
    if sampwidth == 2:  # 16-bit
        samples = struct.unpack(f'<{n_frames}h', audio_data)
    
print(f"OUR AUDIO FILE ANALYSIS")
print(f"=" * 60)
print(f"Sample rate: {sample_rate} Hz")
print(f"Total samples: {n_frames}")
print(f"Duration: {n_frames / sample_rate:.3f}s")

# Find first non-zero sample
first_nonzero = 0
for i, s in enumerate(samples):
    if s != 0:
        first_nonzero = i
        break

print(f"\nFirst non-zero sample: {first_nonzero}")
print(f"First 20 samples: {samples[:20]}")

# Find zero crossings
zero_crossings = []
for i in range(1, min(1000, len(samples))):
    if (samples[i-1] < 0 and samples[i] >= 0) or (samples[i-1] >= 0 and samples[i] < 0):
        zero_crossings.append(i)

print(f"\nFirst 10 zero crossings: {zero_crossings[:10]}")

if len(zero_crossings) >= 2:
    periods = [zero_crossings[i+1] - zero_crossings[i] for i in range(min(10, len(zero_crossings)-1))]
    print(f"Periods: {periods}")
    
    for i, period in enumerate(periods[:10]):
        freq = sample_rate / (2 * period)
        tone = "MARK" if freq < 1500 else "SPACE"
        print(f"  Period {i}: {period} samples → {freq:.1f} Hz ({tone})")

# Analyze bit boundaries (40 samples each)
print(f"\n{'=' * 60}")
print(f"ANALYSIS BY BIT (40 samples each at {sample_rate} Hz):")
print(f"{'=' * 60}")

for bit_num in range(8):
    start_sample = bit_num * 40
    end_sample = start_sample + 40
    
    # Find zero crossings in this bit
    bit_crossings = []
    for i in range(start_sample + 1, end_sample):
        if i < len(samples):
            if (samples[i-1] < 0 and samples[i] >= 0) or (samples[i-1] >= 0 and samples[i] < 0):
                bit_crossings.append(i - start_sample)  # Relative to bit start
    
    # Calculate average frequency
    if len(bit_crossings) >= 2:
        periods_in_bit = [bit_crossings[i+1] - bit_crossings[i] for i in range(len(bit_crossings)-1)]
        avg_period = sum(periods_in_bit) / len(periods_in_bit)
        avg_freq = sample_rate / (2 * avg_period)
        tone = "MARK" if avg_freq < 1500 else "SPACE"
    else:
        avg_freq = 0
        tone = "UNKNOWN"
    
    # Expected for 0x7E LSB-first
    expected_bits = [0, 1, 1, 1, 1, 1, 1, 0]
    expected_tone = "SPACE" if expected_bits[bit_num] == 0 else "MARK"
    match = "✓" if tone == expected_tone else "✗"
    
    print(f"Bit {bit_num} (samples {start_sample:3d}-{end_sample:3d}): "
          f"crossings={bit_crossings}, avg_freq={avg_freq:6.1f} Hz, "
          f"detected={tone:5s}, expected={expected_tone:5s} {match}")
