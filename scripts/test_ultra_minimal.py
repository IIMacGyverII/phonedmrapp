"""
Ultra-minimal test: Just carrier + FLAGS, no actual packet
Try to match gen_packets as closely as possible
"""
import struct
import wave
import math
import subprocess

MARK_FREQ = 1200
SPACE_FREQ = 2200
BAUD_RATE = 1200
SAMPLE_RATE = 48000
AMPLITUDE = int(32767 * 0.25)

MARK_PHASE_INC = 2.0 * math.pi * MARK_FREQ / SAMPLE_RATE
SPACE_PHASE_INC = 2.0 * math.pi * SPACE_FREQ / SAMPLE_RATE

def generate_minimal():
    audio = []
    phase = 0.0
    
    # 1. Carrier: 100ms pure MARK
    print("Adding 100ms MARK carrier...")
    for _ in range(4800):  # 100ms at 48000 Hz
        sample = int(AMPLITUDE * math.sin(phase))
        audio.append(sample)
        phase += MARK_PHASE_INC
        phase %= (2.0 * math.pi)
    
    # 2. Just send 100 FLAG bytes (0x7E) with NRZI
    print("Adding 100 FLAGS with NRZI...")
    nrzi_state = 1  # Start at MARK
    bit_start_time = 0.0
    bit_duration = 1.0 / BAUD_RATE
    
    for _ in range(100):
        byte_val = 0x7E
        for bit_idx in range(8):
            bit = (byte_val >> bit_idx) & 1
            
            # NRZI: bit 0 = transition
            if bit == 0:
                nrzi_state = 1 - nrzi_state
            
            # Select frequency
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
    
    # 3. Tail: 100ms silence
    print("Adding tail silence...")
    for _ in range(4800):
        audio.append(0)
    
    return audio

# Generate
audio = generate_minimal()

# Save
with wave.open('test_ultra_minimal.wav', 'w') as wav:
    wav.setnchannels(1)
    wav.setsampwidth(2)
    wav.setframerate(SAMPLE_RATE)
    wav.writeframes(struct.pack(f'<{len(audio)}h', *audio))

print(f"Generated: test_ultra_minimal.wav ({len(audio)} samples, {len(audio)/SAMPLE_RATE:.2f}s)")

# Test
result = subprocess.run(
    ['C:\\Users\\Joshua\\Downloads\\direwolf-1.8.1-a231971_x86_64\\direwolf-1.8.1-a231971_x86_64\\atest.exe', 
     'test_ultra_minimal.wav'],
    capture_output=True,
    text=True
)

if "from" in result.stdout:
    print("✓✓✓ SUCCESS!")
    print(result.stdout)
else:
    print("✗ Failed: 0 packets")
    # Show just the summary line
    for line in result.stdout.split('\n'):
        if 'from' in line or 'decoded' in line:
            print(line)
