"""
Test different encoding methods to see which Dire Wolf accepts
"""
import struct
import wave
import math
import subprocess

MARK_FREQ = 1200
SPACE_FREQ = 2200
BAUD_RATE = 1200
SAMPLE_RATE = 44100
AMPLITUDE = int(32767 * 0.8)

MARK_PHASE_INC = 2.0 * math.pi * MARK_FREQ / SAMPLE_RATE
SPACE_PHASE_INC = 2.0 * math.pi * SPACE_FREQ / SAMPLE_RATE

def generate_with_encoding(bytes_data, encoding="direct"):
    """Generate AFSK with specified encoding"""
    audio = []
    
    # Lead-in silence
    for _ in range(1170):
        audio.append(0)
    
    phase = 0.0
    bit_start_time = 0.0
    bit_duration = 1.0 / BAUD_RATE
    
    # NRZI state (for NRZI encoding)
    nrzi_state = 1  # Start with MARK
    
    for byte_val in bytes_data:
        for bit_idx in range(8):
            bit = (byte_val >> bit_idx) & 1
            
            if encoding == "direct":
                # Direct FSK: bit 1 = MARK, bit 0 = SPACE
                phase_inc = MARK_PHASE_INC if bit == 1 else SPACE_PHASE_INC
            elif encoding == "direct_inverted":
                # Inverted: bit 0 = MARK, bit 1 = SPACE
                phase_inc = MARK_PHASE_INC if bit == 0 else SPACE_PHASE_INC
            elif encoding == "nrzi":
                # NRZI: bit 0 = transition, bit 1 = no transition
                if bit == 0:
                    nrzi_state = 1 - nrzi_state  # Toggle
                phase_inc = MARK_PHASE_INC if nrzi_state == 1 else SPACE_PHASE_INC
            elif encoding == "nrzi_inverted":
                # NRZI inverted: bit 1 = transition, bit 0 = no transition
                if bit == 1:
                    nrzi_state = 1 - nrzi_state  # Toggle
                phase_inc = MARK_PHASE_INC if nrzi_state == 1 else SPACE_PHASE_INC
            
            # Generate samples
            bit_end_time = bit_start_time + bit_duration
            sample_start = int(bit_start_time * SAMPLE_RATE)
            sample_end = int(bit_end_time * SAMPLE_RATE)
            
            for _ in range(sample_start, sample_end):
                sample = int(AMPLITUDE * math.sin(phase))
                audio.append(sample)
                phase += phase_inc
                phase %= (2.0 * math.pi)
            
            bit_start_time = bit_end_time
    
    # Tail silence
    for _ in range(4410):  # 100ms
        audio.append(0)
    
    return audio

def save_wav(filename, audio):
    with wave.open(filename, 'w') as wav:
        wav.setnchannels(1)
        wav.setsampwidth(2)
        wav.setframerate(SAMPLE_RATE)
        wav.writeframes(struct.pack(f'<{len(audio)}h', *audio))

def test_encoding(name, encoding):
    print(f"\n{'='*60}")
    print(f"TEST: {name}")
    print(f"{'='*60}")
    
    # Just send FLAGS
    test_data = bytes([0x7E] * 30)
    audio = generate_with_encoding(test_data, encoding)
    
    filename = f"test_{encoding}.wav"
    save_wav(filename, audio)
    print(f"Generated: {filename}")
    
    # Test with Dire Wolf
    result = subprocess.run(
        ['C:\\Users\\Joshua\\Downloads\\direwolf-1.8.1-a231971_x86_64\\direwolf-1.8.1-a231971_x86_64\\atest.exe', filename],
        capture_output=True,
        text=True
    )
    
    if "1 from" in result.stdout or "packets decoded" in result.stdout:
        decoded = [line for line in result.stdout.split('\n') if 'from' in line]
        if decoded:
            print(f"✓ SUCCESS: {decoded[0]}")
        else:
            print(f"✗ Failed: 0 packets")
    else:
        print(f"✗ Failed: 0 packets")

# Test all encoding methods
test_encoding("Direct FSK (bit 1=MARK, 0=SPACE)", "direct")
test_encoding("Direct FSK Inverted (bit 0=MARK, 1=SPACE)", "direct_inverted")
test_encoding("NRZI (bit 0=transition, 1=no change)", "nrzi")
test_encoding("NRZI Inverted (bit 1=transition, 0=no change)", "nrzi_inverted")

print(f"\n{'='*60}")
print("SUMMARY: Check which encoding (if any) decoded successfully")
print(f"{'='*60}")
