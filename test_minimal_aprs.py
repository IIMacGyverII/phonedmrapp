"""
Minimal APRS test - simplest possible packet
"""
import math
import wave
import struct
import subprocess

# Bell 202 AFSK parameters
MARK_FREQ = 1200
SPACE_FREQ = 2200
BAUD_RATE = 1200
SAMPLE_RATE = 48000
TX_TAIL_MS = 100
AMPLITUDE = int(32767 * 0.5)
PREAMBLE_FLAGS = 80  # Try even more FLAGS
FLAG = 0x7E

MARK_PHASE_INC = 2.0 * math.pi * MARK_FREQ / SAMPLE_RATE
SPACE_PHASE_INC = 2.0 * math.pi * SPACE_FREQ / SAMPLE_RATE

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

def apply_bit_stuffing(data):
    bits = []
    for byte_val in data:
        for bit_idx in range(8):
            bits.append((byte_val >> bit_idx) & 1)
    
    stuffed_bits = []
    consecutive_ones = 0
    for bit in bits:
        stuffed_bits.append(bit)
        if bit == 1:
            consecutive_ones += 1
            if consecutive_ones == 5:
                stuffed_bits.append(0)
                consecutive_ones = 0
        else:
            consecutive_ones = 0
    
    stuffed_bytes = bytearray()
    for i in range(0, len(stuffed_bits), 8):
        if i + 8 <= len(stuffed_bits):
            byte_val = sum((stuffed_bits[i + j] << j) for j in range(8))
            stuffed_bytes.append(byte_val)
    
    return bytes(stuffed_bytes)

def add_callsign(packet, call, ssid, is_last):
    padded = (call + "      ")[:6]
    for char in padded:
        packet.append(ord(char) << 1)
    ssid_byte = (ssid << 1) | 0x60
    if is_last:
        ssid_byte |= 0x01
    packet.append(ssid_byte)

def generate_afsk(packet):
    audio = []
    phase = 0.0
    
    # Preamble FLAGS
    preamble = bytes([FLAG] * PREAMBLE_FLAGS)
    full_packet = preamble + packet
    
    # Try starting with MARK (1) instead of SPACE (0)
    nrzi_state = 1
    bit_start_time = 0.0
    bit_duration = 1.0 / BAUD_RATE
    
    for byte_val in full_packet:
        for bit_idx in range(8):
            bit = (byte_val >> bit_idx) & 1
            
            if nrzi_state == 1:
                current_phase_inc = MARK_PHASE_INC
            else:
                current_phase_inc = SPACE_PHASE_INC
            
            bit_end_time = bit_start_time + bit_duration
            sample_start = int(bit_start_time * SAMPLE_RATE)
            sample_end = int(bit_end_time * SAMPLE_RATE)
            
            for _ in range(sample_start, sample_end):
                sample = int(AMPLITUDE * math.sin(phase))
                audio.append(sample)
                phase += current_phase_inc
                phase %= (2.0 * math.pi)
            
            if bit == 0:
                nrzi_state = 1 - nrzi_state
            
            bit_start_time = bit_end_time
    
    # Extra bit for NRZI decoder
    bit_end_time = bit_start_time + bit_duration
    sample_start = int(bit_start_time * SAMPLE_RATE)
    sample_end = int(bit_end_time * SAMPLE_RATE)
    
    if nrzi_state == 1:
        current_phase_inc = MARK_PHASE_INC
    else:
        current_phase_inc = SPACE_PHASE_INC
    
    for _ in range(sample_start, sample_end):
        sample = int(AMPLITUDE * math.sin(phase))
        audio.append(sample)
        phase += current_phase_inc
        phase %= (2.0 * math.pi)
    
    # Tail silence
    tail_samples = (TX_TAIL_MS * SAMPLE_RATE) // 1000
    for _ in range(tail_samples):
        audio.append(0)
    
    return audio

def save_wav(filename, audio_samples):
    with wave.open(filename, 'w') as wav_file:
        wav_file.setnchannels(1)
        wav_file.setsampwidth(2)
        wav_file.setframerate(SAMPLE_RATE)
        audio_data = struct.pack(f'<{len(audio_samples)}h', *audio_samples)
        wav_file.writeframes(audio_data)

# Minimal packet: TEST>APRS:!0000.00N/00000.00W-
packet = []
add_callsign(packet, "APRS", 0, False)  # Dest
add_callsign(packet, "TEST", 0, True)   # Source
packet.append(0x03)  # Control
packet.append(0xF0)  # PID
info = "!0000.00N/00000.00W-"
for char in info:
    packet.append(ord(char))

data_for_fcs = bytes(packet)
fcs = calculate_fcs(data_for_fcs)
data_with_fcs = data_for_fcs + bytes([fcs & 0xFF, (fcs >> 8) & 0xFF])
stuffed_data = apply_bit_stuffing(data_with_fcs)
final_packet = bytes([FLAG]) + stuffed_data + bytes([FLAG, FLAG])

print(f"Minimal packet: TEST>APRS:!0000.00N/00000.00W-")
print(f"FCS: 0x{fcs:04X}")
print(f"Preamble: {PREAMBLE_FLAGS} FLAGS")
print(f"Packet length: {len(final_packet)} bytes")

audio = generate_afsk(final_packet)
save_wav("test_minimal.wav", audio)
print(f"Generated: test_minimal.wav ({len(audio)/SAMPLE_RATE:.2f}s)")

# Test
result = subprocess.run(
    ["C:\\Program Files\\Dire Wolf\\direwolf.exe", "-t", "0", "-r", "48000", "test_minimal.wav"],
    capture_output=True, text=True,  timeout=5
)

if "1 from test_minimal.wav" in result.stdout:
    print("\n*** SUCCESS! ***")
else:
    print(f"\n[FAIL] 0 packets decoded")
    print(result.stdout[:500])
