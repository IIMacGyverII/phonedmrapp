"""
Better tone detection using simple zero-crossing count
"""
import wave
import struct

def read_wav(filename):
    with wave.open(filename, 'rb') as wav:
        sample_rate = wav.getframerate()
        n_frames = wav.getnframes()
        audio_data = wav.readframes(n_frames)
        samples = struct.unpack(f'<{n_frames}h', audio_data)
    return list(samples), sample_rate

def count_zero_crossings(samples, start, end):
    """Count zero crossings in a sample range"""
    count = 0
    for i in range(start, end - 1):
        if (samples[i] <= 0 and samples[i+1] > 0) or (samples[i] > 0 and samples[i+1] <= 0):
            count += 1
    return count

def classify_tone(crossings, samples_per_bit):
    """
    Classify based on zero crossing count
    At 48000 Hz, 40 samples/bit:
    - MARK (1200 Hz): ~2 crossings per bit
    - SPACE (2200 Hz): ~3-4 crossings per bit
    """
    if crossings < 2.5:
        return 'M'
    else:
        return 'S'

samples, sample_rate = read_wav("test_gen_copy.wav")
print(f"Sample rate: {sample_rate} Hz")
samples_per_bit = sample_rate / 1200
print(f"Samples per bit: {samples_per_bit}")

# Find signal start
start_sample = 0
for i, s in enumerate(samples):
    if abs(s) > 100:
        start_sample = i
        break

print(f"Signal starts at sample: {start_sample}\n")

# Extract tones using zero crossing method
tones = []
for bit_num in range(400):
    start_idx = start_sample + int(bit_num * samples_per_bit)
    end_idx = start_sample + int((bit_num + 1) * samples_per_bit)
    
    if end_idx >= len(samples):
        break
    
    crossings = count_zero_crossings(samples, start_idx, end_idx)
    tone = classify_tone(crossings, samples_per_bit)
    tones.append(tone)

print(f"Extracted {len(tones)} tones\n")

# Print tones in groups of 8
print("First 160 tones (groups of 8 for byte alignment):")
for i in range(0, min(160, len(tones)), 8):
    group = tones[i:i+8]
    print(f"Byte {i//8:3d}: {' '.join(group)}", end="")
    
    # Decode NRZI for this byte (need 8 tones to get 7 bits)
    if len(group) == 8:
        bits = []
        for j in range(1, 8):
            if group[j] == group[j-1]:
                bits.append('1')
            else:
                bits.append('0')
        
        # Convert to hex (LSB first)
        byte_val = 0
        for k, bit in enumerate(bits):
            if bit == '1':
                byte_val |= (1 << k)
        print(f"  → {''.join(bits)} → 0x{byte_val:02X}")
    else:
        print()

# Now decode as continuous stream
print("\nDecoding as continuous NRZI stream:")
all_bits = []
for i in range(1, len(tones)):
    if tones[i] == tones[i-1]:
        all_bits.append(1)
    else:
        all_bits.append(0)

# Convert to bytes
all_bytes = []
for i in range(0, len(all_bits) - 7, 8):
    byte_val = 0
    for j in range(8):
        if all_bits[i + j]:
            byte_val |= (1 << j)
    all_bytes.append(byte_val)

print(f"Total bits: {len(all_bits)}")
print(f"Total bytes: {len(all_bytes)}")
print(f"\nFirst 40 bytes:")
for i in range(0, min(40, len(all_bytes)), 10):
    print(f"{i:3d}: " + " ".join(f"{b:02X}" for b in all_bytes[i:i+10]))

# Count FLAGS
flag_count = sum(1 for b in all_bytes if b == 0x7E)
print(f"\nFLAG (0x7E) count: {flag_count}")
print(f"First 20 byte values:")
for i, b in enumerate(all_bytes[:20]):
    marker = " ← FLAG" if b == 0x7E else ""
    print(f"  {i:2d}: 0x{b:02X}{marker}")
