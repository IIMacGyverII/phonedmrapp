"""
Extract full decoded packet from our audio to see what Dire Wolf would see
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

def decode_nrzi_to_bits(tones):
    """Decode NRZI: transition=0, no transition=1"""
    bits = []
    for i in range(1, len(tones)):
        if tones[i] == tones[i-1]:
            bits.append(1)  # No transition
        else:
            bits.append(0)  # Transition
    return bits

def bits_to_bytes(bits):
    """Convert bits to bytes (LSB first)"""
    bytes_out = []
    for i in range(0, len(bits) - 7, 8):
        byte_val = 0
        for j in range(8):
            if bits[i + j]:
                byte_val |= (1 << j)
        bytes_out.append(byte_val)
    return bytes_out

def unstuff_bits(bits):
    """Remove bit stuffing: remove 0 after five consecutive 1s"""
    unstuffed = []
    consecutive_ones = 0
    i = 0
    
    while i < len(bits):
        bit = bits[i]
        unstuffed.append(bit)
        
        if bit == 1:
            consecutive_ones += 1
            if consecutive_ones == 5:
                # Next bit should be stuffed 0 - skip it
                i += 1  # Skip the stuffed 0
                if i < len(bits):
                    # Verify it's actually a 0
                    if bits[i] != 0:
                        print(f"Warning: Expected stuffed 0 at bit {i}, got {bits[i]}")
                consecutive_ones = 0
        else:
            consecutive_ones = 0
        
        i += 1
    
    return unstuffed

# Analyze our file
samples, sample_rate = read_wav("aprs_fixed_test.wav")
print(f"Sample rate: {sample_rate} Hz")
print(f"Total samples: {len(samples)}")

# Find signal start
start_sample = 0
for i, s in enumerate(samples):
    if abs(s) > 100:
        start_sample = i
        break

print(f"Signal starts at sample: {start_sample}")

# Extract tones
samples_per_bit = sample_rate / 1200
tones = []
sample_idx = start_sample

while sample_idx < len(samples) - samples_per_bit and len(tones) < 1000:
    tone = detect_tone(samples, sample_rate, int(sample_idx), int(samples_per_bit))
    if tone and tone != "SILENCE":
        tones.append(tone)
    sample_idx += samples_per_bit

print(f"Extracted {len(tones)} tones")

# Decode NRZI
bits = decode_nrzi_to_bits(tones)
print(f"Decoded {len(bits)} bits")

# Convert to bytes (these are NOT unstuffed yet)
raw_bytes = bits_to_bytes(bits)
print(f"\nFirst 50 bytes (raw - should see preamble FLAGS):")
print(" ".join(f"{b:02X}" for b in raw_bytes[:50]))

# Find FLAG positions in raw bytes
print(f"\nSearching for FLAG bytes (0x7E) in raw stream...")
flag_positions = []
for i, b in enumerate(raw_bytes):
    if b == 0x7E:
        flag_positions.append(i)
        if len(flag_positions) <= 25:  # Show first 25
            print(f"  FLAG at byte {i}")

print(f"Total FLAGS found: {len(flag_positions)}")

# Find the opening and closing flags (preamble will be many consecutive FLAGS)
# Look for first non-consecutive FLAG pair
print(f"\nLooking for packet boundaries (opening/closing FLAGS)...")
opening_flag_idx = None
closing_flag_idx = None

for i in range(len(flag_positions) - 1):
    if flag_positions[i+1] - flag_positions[i] > 1:
        # Found gap after preamble
        opening_flag_idx = flag_positions[i]
        # Find next flag (closing)
        closing_flag_idx = flag_positions[i+1]
        print(f"Opening FLAG at byte {opening_flag_idx}")
        print(f"Closing FLAG at byte {closing_flag_idx}")
        print(f"Stuffed data: bytes {opening_flag_idx + 1} to {closing_flag_idx - 1}")
        break

if opening_flag_idx is not None:
    # Extract bit-stuffed data between flags
    stuffed_data_start = (opening_flag_idx + 1) * 8  # Convert to bit index
    stuffed_data_end = closing_flag_idx * 8
    stuffed_bits = bits[stuffed_data_start:stuffed_data_end]
    
    print(f"\nBit-stuffed data: {len(stuffed_bits)} bits")
    
    # Now unstuff only this portion
    print(f"Unstuffing data between flags...")
    unstuffed_bits = unstuff_bits(stuffed_bits)
    print(f"After unstuffing: {len(unstuffed_bits)} bits (was {len(stuffed_bits)})")
    
    # Convert to bytes
    packet_bytes = bits_to_bytes(unstuffed_bits)
    print(f"\nDecoded packet data ({len(packet_bytes)} bytes):")
    print(" ".join(f"{b:02X}" for b in packet_bytes))
    
    print(f"\nExpected packet structure:")
    print("- Destination callsign (7 bytes)")
    print("- Source callsign (7 bytes)")
    print("- Control (1 byte): 0x03")
    print("- PID (1 byte): 0xF0")
    print("- Info: !3734.50N/12334.50W-Hello")
    print("- FCS (2 bytes)")
else:
    print("Could not find packet boundaries!")
