"""
Detailed analysis of bit-level encoding
"""
import wave
import struct

def read_wav(filename):
    with wave.open(filename, 'rb') as wav:
        sample_rate = wav.getframerate()
        n_frames = wav.getnframes()
        audio_data = wav.readframes(n_frames)
        samples = struct.unpack(f'<{n_frames}h', audio_data)
    return samples, sample_rate

def detect_tone(samples, sample_rate, start_idx, num_samples):
    """Detect MARK or SPACE"""
    crossings = []
    for i in range(start_idx, min(start_idx + num_samples - 1, len(samples) - 1)):
        if (samples[i] < 0 and samples[i+1] >= 0) or (samples[i] >= 0 and samples[i+1] < 0):
            crossings.append(i - start_idx)
    
    if len(crossings) < 2:
        max_amp = max(abs(samples[i]) for i in range(start_idx, min(start_idx + num_samples, len(samples))))
        if max_amp < 100:
            return "SILENCE"
        return None
    
    periods = [crossings[i+1] - crossings[i] for i in range(len(crossings)-1)]
    avg_period = sum(periods) / len(periods)
    freq = sample_rate / (2 * avg_period)
    
    return "MARK" if freq < 1650 else "SPACE"

samples, sample_rate = read_wav("aprs_fixed_test.wav")
print(f"Sample rate: {sample_rate} Hz")

# Find signal start
start_sample = 0
for i, s in enumerate(samples):
    if abs(s) > 100:
        start_sample = i
        break

print(f"Signal starts at sample: {start_sample}\n")

# Extract first 200 tones
samples_per_bit = sample_rate / 1200
tones = []
sample_idx = start_sample

for bit_num in range(200):
    tone = detect_tone(samples, sample_rate, int(sample_idx), int(samples_per_bit))
    if tone and tone != "SILENCE":
        tones.append(tone[0])  # Just M or S
    else:
        tones.append('?')
    sample_idx += samples_per_bit

# Print tones in groups of 8
print("First 200 tones (groups of 8 = one byte LSB-first):")
for i in range(0, min(200, len(tones)), 8):
    group = tones[i:i+8]
    print(f"Byte {i//8:3d}: {' '.join(group)}", end="")
    
    # Decode NRZI for this byte
    bits = []
    for j in range(1, len(group)):
        if group[j] == group[j-1]:
            bits.append('1')
        else:
            bits.append('0')
    
    # Convert to hex
    if len(bits) == 7:
        byte_val = 0
        for k, bit in enumerate(bits):
            if bit == '1':
                byte_val |= (1 << k)
        print(f"  → bits: {''.join(bits)} → 0x{byte_val:02X}")
    else:
        print()

print("\nExpected for 0x7E FLAG:")
print("Bits (LSB first): 0  1 1 1 1 1 1  0")
print("NRZI (start=SPACE): S M M M M M M M  (next S)")
print("                     ^transition    ^next transition")
print("                     =0             =0")
print("Decoded bits: 0 1 1 1 1 1 1 (comparing M-M M-M M-M M-M M-M M-M M-S)")
print("Next bit: 0 (M to S = transition)")
print("\nSo one FLAG spans: last tone of previous byte + 7 tones + first tone of next")
