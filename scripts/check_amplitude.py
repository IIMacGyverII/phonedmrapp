"""
Try to generate the EXACT same packet as Dire Wolf gen_packets
by extracting and replicating its byte sequence
"""
import struct
import wave
import math
import subprocess

MARK_FREQ = 1200
SPACE_FREQ = 2200
BAUD_RATE = 1200
SAMPLE_RATE = 44100
AMPLITUDE = int(32767 * 0.25)  # Match gen_packets default (50% which is 25% of max for mono)

MARK_PHASE_INC = 2.0 * math.pi * MARK_FREQ / SAMPLE_RATE
SPACE_PHASE_INC = 2.0 * math.pi * SPACE_FREQ / SAMPLE_RATE

# Read the Dire Wolf reference to see the amplitude it uses
with wave.open('C:\\Users\\Joshua\\Downloads\\direwolf-1.8.1-a231971_x86_64\\direwolf-1.8.1-a231971_x86_64\\good_test.wav', 'rb') as wav:
    # Skip silence lead-in
    wav.setpos(1200)  # Skip first ~1200 samples
    ref_data = wav.readframes(500)
    ref_samples = struct.unpack(f'<{len(ref_data)//2}h', ref_data)
    ref_max = max(abs(s) for s in ref_samples)
    print(f"Reference max amplitude: {ref_max}")
    print(f"Reference % of max: {100 * ref_max / 32767:.1f}%")

# Also check our previous attempts
try:
    with wave.open('aprs_fixed_test.wav', 'rb') as wav:
        wav.setpos(1200)  # Skip lead-in
        our_data = wav.readframes(500)
        our_samples = struct.unpack(f'<{len(our_data)//2}h', our_data)
        our_max = max(abs(s) for s in our_samples if s != 0)
        print(f"Our max amplitude: {our_max}")
        print(f"Our % of max: {100 * our_max / 32767:.1f}%")
except Exception as e:
    print(f"Could not read our test file: {e}")
