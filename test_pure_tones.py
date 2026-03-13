"""
Generate pure test tones and verify Dire Wolf can detect them
"""
import math
import wave
import struct
import subprocess

SAMPLE_RATE = 48000
AMPLITUDE = int(32767 * 0.5)
MARK_FREQ = 1200
SPACE_FREQ = 2200

def generate_tone(freq, duration_ms):
    """Generate a pure sine wave"""
    samples = []
    phase_inc = 2.0 * math.pi * freq / SAMPLE_RATE
    phase = 0.0
    num_samples = int((duration_ms / 1000.0) * SAMPLE_RATE)
    
    for _ in range(num_samples):
        sample = int(AMPLITUDE * math.sin(phase))
        samples.append(sample)
        phase += phase_inc
        phase %= (2.0 * math.pi)
    
    return samples

def save_wav(filename, samples):
    with wave.open(filename, 'w') as wav:
        wav.setnchannels(1)
        wav.setsampwidth(2)
        wav.setframerate(SAMPLE_RATE)
        audio_data = struct.pack(f'<{len(samples)}h', *samples)
        wav.writeframes(audio_data)

# Test 1: Alternating MARK and SPACE (should decode as 010101...)
print("Test 1: Alternating tones (pattern for FLAGS)")
audio = []
bit_duration_ms = 1000.0 / 1200.0  # ~0.833ms per bit

for i in range(800):  # 100 bytes worth
    if i % 2 == 0:
        audio.extend(generate_tone(SPACE_FREQ, bit_duration_ms))
    else:
        audio.extend(generate_tone(MARK_FREQ, bit_duration_ms))

save_wav("test_alternating.wav", audio)
print(f"  Generated test_alternating.wav ({len(audio)/SAMPLE_RATE:.2f}s)")

# Test 2: Continuous MARK
print("\nTest 2: Continuous MARK (1200 Hz)")
audio = generate_tone(MARK_FREQ, 500)
save_wav("test_mark.wav", audio)
print(f"  Generated test_mark.wav ({len(audio)/SAMPLE_RATE:.2f}s)")

# Test 3: Continuous SPACE  
print("\nTest 3: Continuous SPACE (2200 Hz)")
audio = generate_tone(SPACE_FREQ, 500)
save_wav("test_space.wav", audio)
print(f"  Generated test_space.wav ({len(audio)/SAMPLE_RATE:.2f}s)")

print("\nTest with Dire Wolf atest:")
atest_path = r"C:\Users\Joshua\Downloads\direwolf-1.8.1-a231971_x86_64\direwolf-1.8.1-a231971_x86_64\atest.exe"

for filename in ["test_alternating.wav", "test_mark.wav", "test_space.wav"]:
    print(f"\n{filename}:")
    result = subprocess.run(
        [atest_path, "-B", "1200", filename],
        capture_output=True, text=True, timeout=5
    )
    if "decoded" in result.stdout:
        for line in result.stdout.split('\n'):
            if 'from' in line or 'decoded' in line:
                print(f"  {line}")
