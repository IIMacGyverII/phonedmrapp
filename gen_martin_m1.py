"""
Generate a proper 256-line Martin M1 test signal (color gradient / test pattern)
to verify the SSTV decoder can decode all 256 rows.
"""
import numpy as np
import wave, struct

SR = 16000

# Martin M1 timing (ms → samples)
def ms(t): return int(round(t * SR / 1000.0))

SYNC_HZ   = 1200.0
BLACK_HZ  = 1500.0
WHITE_HZ  = 2300.0
LEADER_HZ = 1900.0

def tone(freq_hz, duration_samples, amplitude=0.8):
    t = np.arange(duration_samples) / SR
    return (amplitude * np.sin(2 * np.pi * freq_hz * t)).astype(np.float32)

def freq_sweep(start_hz, end_hz, num_samples, amplitude=0.8):
    """Linear frequency sweep (used for single color channel)."""
    freqs = np.linspace(start_hz, end_hz, num_samples)
    t = np.arange(num_samples) / SR
    phase = np.cumsum(2 * np.pi * freqs / SR)
    return (amplitude * np.sin(phase)).astype(np.float32)

def pixel_to_hz(value_0_255):
    return BLACK_HZ + (WHITE_HZ - BLACK_HZ) * value_0_255 / 255.0

def encode_row(samples_out, row_idx, num_rows=256, width=320):
    """
    Encode one Martin M1 scan line.
    Format: SYNC(4.862ms) + PORCH(0.572ms) + GREEN(146.432ms) + SEP(0.572ms)
            + BLUE(146.432ms) + SEP(0.572ms) + RED(146.432ms)
    """
    sync_samp  = ms(4.862)
    porch_samp = ms(0.572)
    sep_samp   = ms(0.572)
    ch_samp    = ms(146.432)

    # Sync pulse
    samples_out.append(tone(SYNC_HZ, sync_samp))
    # Porch
    samples_out.append(tone(BLACK_HZ, porch_samp))

    # Generate test pattern: color gradient
    # Top half: red gradient L→R, green gradient T→B
    # Bottom half: blue gradient
    frac_row = row_idx / (num_rows - 1)  # 0.0 top → 1.0 bottom

    for ch_name in ['G', 'B', 'R']:
        ch_audio = np.zeros(ch_samp, dtype=np.float32)
        for x in range(width):
            frac_col = x / (width - 1)
            if ch_name == 'R':
                val = int(frac_col * 255)
            elif ch_name == 'G':
                val = int(frac_row * 255)
            elif ch_name == 'B':
                val = int((1 - frac_col) * frac_row * 255)  # corner sweep
            freq = pixel_to_hz(val)
            start_s = (x * ch_samp) // width
            end_s = ((x + 1) * ch_samp) // width
            n = end_s - start_s
            # Use a pure tone for each pixel segment
            t_seg = np.arange(n) / SR
            from_phase = 2 * np.pi * freq * start_s / SR
            ch_audio[start_s:end_s] = (0.8 * np.sin(from_phase + 2 * np.pi * freq * t_seg)).astype(np.float32)
        samples_out.append(ch_audio)
        if ch_name != 'R':  # separator between channels (not after last)
            samples_out.append(tone(BLACK_HZ, sep_samp))

# ---- Build full signal ----
parts = []

# Leader 1 (300ms @ 1900Hz)
parts.append(tone(LEADER_HZ, ms(300)))
# Break (10ms @ 1200Hz)
parts.append(tone(SYNC_HZ, ms(10)))
# Leader 2 (300ms @ 1900Hz)
parts.append(tone(LEADER_HZ, ms(300)))

# VIS start bit (30ms @ 1200Hz)
parts.append(tone(SYNC_HZ, ms(30)))

# VIS code for Martin M1 = 0x2C = 0b0101100, LSB first = 0,0,1,1,0,1,0
VIS_MARTIN_M1 = 0x2C
vis_bits = [(VIS_MARTIN_M1 >> i) & 1 for i in range(7)]
for bit in vis_bits:
    parts.append(tone(1300.0 if bit else 1100.0, ms(30)))
# Parity (even parity: count 1-bits)
ones = sum(vis_bits)
parity = ones % 2  # 0 → even parity bit = 0 → 1100Hz
parts.append(tone(1300.0 if parity else 1100.0, ms(30)))
# VIS stop bit (30ms @ 1200Hz)
parts.append(tone(SYNC_HZ, ms(30)))

# 256 scan lines
print("Generating 256 Martin M1 scan lines...")
for row in range(256):
    encode_row(parts, row)
    if row % 32 == 0:
        print(f"  Row {row}/256")

# 500ms tail silence
parts.append(np.zeros(ms(500), dtype=np.float32))

# Concatenate
audio = np.concatenate(parts)
print(f"Total duration: {len(audio)/SR:.2f}s ({len(audio)} samples)")

# Save as 16-bit WAV
pcm = np.clip(audio, -1, 1)
pcm_int = (pcm * 32767).astype(np.int16)
with wave.open('martin_m1_full_test.wav', 'wb') as wf:
    wf.setnchannels(1)
    wf.setsampwidth(2)
    wf.setframerate(SR)
    wf.writeframes(pcm_int.tobytes())
print("Saved: martin_m1_full_test.wav")
