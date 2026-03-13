"""
Parse the full APRS packet from decoded bytes
Usage: python parse_full_packet.py [wav_file]
"""
import wave
import struct
import sys

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

def decode_callsign(bytes_data, start_idx):
    """Decode shifted callsign (6 chars + SSID byte)"""
    call = ""
    for i in range(6):
        char = bytes_data[start_idx + i] >> 1
        if char != 0x20:  # Not space
            call += chr(char)
    
    ssid_byte = bytes_data[start_idx + 6]
    ssid = (ssid_byte >> 1) & 0x0F
    is_last = (ssid_byte & 0x01) != 0
    
    if ssid > 0:
        call += f"-{ssid}"
    
    return call, is_last

# Get filename from command line or use default
if len(sys.argv) > 1:
    wav_filename = sys.argv[1]
else:
    wav_filename = "aprs_fixed_test.wav"

print(f"Decoding: {wav_filename}")
print("=" * 70)

# Decode the audio
samples, sample_rate = read_wav(wav_filename)
samples_per_bit = sample_rate / 1200

# Find signal
start_sample = next(i for i, s in enumerate(samples) if abs(s) > 100)

# Extract all available tones
tones = []
bit_num = 0
while True:
    start_idx = start_sample + int(bit_num * samples_per_bit)
    end_idx = start_sample + int((bit_num + 1) * samples_per_bit)
    if end_idx >= len(samples):
        break
    crossings = count_zero_crossings(samples, start_idx, end_idx)
    tones.append(classify_tone(crossings))
    bit_num += 1

print(f"Extracted {len(tones)} tones from audio")

# Decode NRZI
bits = [0 if tones[i] != tones[i-1] else 1 for i in range(1, len(tones))]

# Convert to bytes
packet_bytes = []
for i in range(0, len(bits) - 7, 8):
    byte_val = sum((bits[i + j] << j) for j in range(8))
    packet_bytes.append(byte_val)

print(f"Decoded {len(packet_bytes)} bytes total\n")

# Print all bytes
print("ALL DECODED BYTES:")
for i in range(0, len(packet_bytes), 16):
    hex_str = " ".join(f"{b:02X}" for b in packet_bytes[i:i+16])
    flags = " ".join("FL" if b == 0x7E else "  " for b in packet_bytes[i:i+16])
    print(f"{i:3d}: {hex_str}")
    print(f"     {flags}")
print()

# Find preamble end (last consecutive FLAG)
# In AX.25, the last preamble FLAG serves as the opening delimiter
preamble_end = 0
for i in range(len(packet_bytes)):
    if packet_bytes[i] != 0x7E:
        preamble_end = i - 1
        break

# The opening FLAG is the last FLAG in the preamble (byte preamble_end)
# Data starts immediately after (byte preamble_end + 1)
data_start = preamble_end + 1

print(f"Preamble+Opening: {preamble_end + 1} FLAGS (bytes 0-{preamble_end})")
print(f"Data starts: byte {data_start}")

# Find closing FLAG
closing_flag = next((i for i in range(data_start, len(packet_bytes)) if packet_bytes[i] == 0x7E), None)

if closing_flag:
    print(f"Closing FLAG: byte {closing_flag}")
    print(f"Stuffed data: bytes {data_start} to {closing_flag - 1}\n")
    
    # Get stuffed data (this is bit-stuffed, need to unstuff)
    stuffed_data = packet_bytes[data_start:closing_flag]
    
    print("=" * 70)
    print("BIT-STUFFED DATA (between FLAGS):")
    print("=" * 70)
    for i in range(0, len(stuffed_data), 16):
        hex_str = " ".join(f"{b:02X}" for b in stuffed_data[i:i+16])
        print(f"{i:3d}: {hex_str}")
    print(f"\nStuffed data length: {len(stuffed_data)} bytes")
    
    # Convert to bits for unstuffing
    stuffed_bits = []
    for byte_val in stuffed_data:
        for bit_idx in range(8):
            stuffed_bits.append((byte_val >> bit_idx) & 1)
    
    print(f"Stuffed bits: {len(stuffed_bits)}")
    
    # Unstuff: remove 0 after five consecutive 1s
    unstuffed_bits = []
    consecutive_ones = 0
    i = 0
    stuffed_bit_count = 0
    
    while i < len(stuffed_bits):
        bit = stuffed_bits[i]
        unstuffed_bits.append(bit)
        
        if bit == 1:
            consecutive_ones += 1
            if consecutive_ones == 5:
                # Next bit should be stuffed 0 - skip it
                i += 1  # Move to stuffed bit
                if i < len(stuffed_bits):
                    if stuffed_bits[i] == 0:
                        stuffed_bit_count += 1
                    # Skip this bit
                consecutive_ones = 0
        else:
            consecutive_ones = 0
        
        i += 1
    
    print(f"Removed {stuffed_bit_count} stuffed bits")
    print(f"Unstuffed bits: {len(unstuffed_bits)}")
    
    # Convert back to bytes
    packet_data = []
    for i in range(0, len(unstuffed_bits) - 7, 8):
        byte_val = sum((unstuffed_bits[i + j] << j) for j in range(8))
        packet_data.append(byte_val)
    
    # Convert back to bytes
    packet_data = []
    for i in range(0, len(unstuffed_bits) - 7, 8):
        byte_val = sum((unstuffed_bits[i + j] << j) for j in range(8))
        packet_data.append(byte_val)
    
    print(f"Unstuffed packet data: {len(packet_data)} bytes\n")
    
    print("=" * 70)
    print("UNSTUFFED PACKET DATA:")
    print("=" * 70)
    for i in range(0, len(packet_data), 16):
        hex_str = " ".join(f"{b:02X}" for b in packet_data[i:i+16])
        print(f"{i:3d}: {hex_str}")
    
    print("\n" + "=" * 70)
    print("PARSED PACKET STRUCTURE:")
    print("=" * 70)
    
    # Parse addresses (first 14 bytes = 2 addresses)
    if len(packet_data) >= 14:
        dest_call, dest_last = decode_callsign(packet_data, 0)
        src_call, src_last = decode_callsign(packet_data, 7)
        
        print(f"Destination: {dest_call:12s} (bytes 0-6)")
        print(f"Source:      {src_call:12s} (bytes 7-13, last={'YES' if src_last else 'NO'})")
        
        # Control and PID
        if len(packet_data) >= 16:
            control = packet_data[14]
            pid = packet_data[15]
            print(f"Control:     0x{control:02X}{' (UI frame)' if control == 0x03 else ''}")
            print(f"PID:         0x{pid:02X}{' (No layer 3)' if pid == 0xF0 else ''}")
            
            # Info field (rest minus 2-byte FCS)
            if len(packet_data) >= 18:
                info_bytes = packet_data[16:-2]
                info_text = "".join(chr(b) if 32 <= b < 127 else f"\\x{b:02x}" for b in info_bytes)
                print(f"Info:        {info_text}")
                
                # FCS
                fcs = packet_data[-2] | (packet_data[-1] << 8)
                print(f"FCS:         0x{fcs:04X}")
                
                # Now verify FCS
                print("\n" + "=" * 70)
                print("FCS VERIFICATION:")
                print("=" * 70)
                
                # FCS should be on addresses + control + PID + info
                data_for_fcs = packet_data[:-2]
                
                # Calculate FCS (same as generator)
                def calculate_fcs(data):
                    fcs = 0xFFFF
                    for byte in data:
                        fcs ^= byte
                        for _ in range(8):
                            if fcs & 0x0001:
                                fcs = (fcs >> 1) ^ 0x8408
                            else:
                                fcs >>= 1
                    return fcs ^ 0xFFFF
                
                calculated_fcs = calculate_fcs(data_for_fcs)
                print(f"Calculated FCS: 0x{calculated_fcs:04X}")
                print(f"Packet FCS:     0x{fcs:04X}")
                print(f"Match: {'✓ YES' if calculated_fcs == fcs else '✗ NO'}")
    
else:
    print("No closing FLAG found!")

print("\n" + "=" * 70)
print("EXPECTED vs ACTUAL:")
print("=" * 70)
print("Expected destination: APZDMR-0")
print("Expected source:      EXAM-9")
print("Expected info:        !3734.50N/12334.50W-Hello")
