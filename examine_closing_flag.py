"""
Examine tones around the closing FLAG position
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
    count = 0
    for i in range(start, end - 1):
        if (samples[i] <= 0 and samples[i+1] > 0) or (samples[i] > 0 and samples[i+1] <= 0):
            count += 1
    return count

def classify_tone(crossings):
    return 'M' if crossings < 2.5 else 'S'

samples, sample_rate = read_wav("aprs_fixed_test.wav")
samples_per_bit = sample_rate / 1200

# Find signal start
start_sample = next(i for i, s in enumerate(samples) if abs(s) > 100)

# Extract all tones
tones = []
bit_num = 0
while True:
    start_idx = start_sample + int(bit_num * samples_per_bit)
    end_idx = start_sample + int((bit_num + 1) * samples_per_bit)
    if end_idx >= len(samples):
        break
    crossings = count_zero_crossings(samples, start_idx, end_idx)
    max_amp = max(abs(samples[i]) for i in range(start_idx, end_idx))
    tones.append((classify_tone(crossings), crossings, max_amp))
    bit_num += 1

print(f"Extracted {len(tones)} tones\n")

# Byte 65 should be at bit positions 520-527 (65 * 8 = 520)
# But NRZI decoding uses tone pairs, so we need tones 520-528
print("=" * 70)
print("TONES AROUND BYTE 65 (closing FLAG):")
print("=" * 70)
print(f"Byte 64 (last data byte):  tones 512-520")
print(f"Byte 65 (closing FLAG):    tones 520-528")
print(f" (Expected: 0x7E = bits 0,1,1,1,1,1,1,0)")
print(f" (Got: 0xFE = bits 0,1,1,1,1,1,1,1)")
print()

# Show tones 510-540
print("Tone#  M/S  X-ings  Amplitude  | Bit decode")
print("-" * 70)
for i in range(510, min(540, len(tones))):
    tone, crossings, amp = tones[i]
    
    # Decode bit (compare with previous tone)
    if i > 0:
        prev_tone = tones[i-1][0]
        bit = '0' if tone != prev_tone else '1'
    else:
        bit = '?'
    
    # Mark byte boundaries
    marker = ""
    if i == 512:
        marker = " ← Byte 64 starts"
    elif i == 520:
        marker = " ← Byte 65 starts (closing FLAG)"
    elif i == 528:
        marker = " ← Byte 66 starts"
    
    print(f"{i:5d}  {tone}    {crossings:4.1f}    {amp:6d}     | bit {bit}  {marker}")

print()
print("=" * 70)
print("ANALYSIS:")
print("=" * 70)

# Decode byte 65 specifically
byte_65_start = 520
byte_65_bits = []
for i in range(byte_65_start + 1, byte_65_start + 9):
    if i < len(tones):
        if tones[i][0] == tones[i-1][0]:
            byte_65_bits.append('1')
        else:
            byte_65_bits.append('0')

if len(byte_65_bits) == 8:
    bits_str = ''.join(byte_65_bits)
    byte_val = sum((int(b) << j) for j, b in enumerate(byte_65_bits))
    print(f"Byte 65 decoded bits: {bits_str} = 0x{byte_val:02X}")
    print(f"Expected (0x7E FLAG): 0111111 0 = 0x7E")
    print(f"Got:                  {bits_str} = 0x{byte_val:02X}")
    print()
    if byte_65_bits[7] == '1':
        print("✗ Bit 7 is WRONG: got 1, expected 0")
        print(f"  This means tones {byte_65_start + 7} and {byte_65_start + 8} are THE SAME")
        print(f"  Tone {byte_65_start + 7}: {tones[byte_65_start + 7][0]}")
        print(f"  Tone {byte_65_start + 8}: {tones[byte_65_start + 8][0]}")
        print(f"  They should be DIFFERENT!")
