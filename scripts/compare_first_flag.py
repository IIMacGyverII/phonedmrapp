"""
Compare first FLAG waveform between test_gen and our file
"""
import wave
import struct

def get_flag_waveform(filename, start_sample):
    with wave.open(filename, 'rb') as wav:
        sample_rate = wav.getframerate()
        wav.readframes(start_sample)  # Skip to start
        
        # Read 8 bits worth of samples (one FLAG byte)
        samples_per_bit = sample_rate / 1200.0
        num_samples = int(8 * samples_per_bit)
        
        audio_data = wav.readframes(num_samples)
        samples = struct.unpack(f'<{num_samples}h', audio_data)
    
    return samples, sample_rate

# Get first FLAG from each file (starts at sample 1170)
ref_samples, ref_rate = get_flag_waveform("test_gen_copy.wav", 1170)
our_samples, our_rate = get_flag_waveform("aprs_fixed_test.wav", 1170)

print("First FLAG byte (0x7E = 01111110)")
print("Expected NRZI tones: S M M M M M M M (then S for next byte)")
print()
print(f"Reference (test_gen): {ref_rate} Hz, {len(ref_samples)} samples")
print(f"Our file:             {our_rate} Hz, {len(our_samples)} samples")
print()

# Compare first 100 samples
print("First 100 samples comparison:")
print("  Idx    Ref     Ours   Diff")
print("-" * 35)
for i in range(min(100, len(ref_samples), len(our_samples))):
    diff = our_samples[i] - ref_samples[i]
    marker = " !" if abs(diff) > 500 else ""
    print(f"  {i:3d}  {ref_samples[i]:6d}  {our_samples[i]:6d}  {diff:6d}{marker}")
