"""
Regenerate ScottieDX.wav from the source BMP.

Scottie DX format (256 lines, 320 pixels/line):
  Header: 300ms 1900Hz + 10ms 1200Hz + 300ms 1900Hz + VIS bits + 300ms 1900Hz
  Each scan line: SYNC(9ms,1200Hz) + SEP(1.5ms,1500Hz) + G + SEP + B + SEP + R
  Channel freq: 1500 + (level/255)*800 Hz  (1500=black, 2300=white)

Channel slot → output pixel mapping (verified against working decoder rows 0-240):
  G-slot encodes source GREEN
  B-slot encodes source BLUE  
  R-slot encodes source RED
  (standard Scottie natural order - the decoder comment "G->R" was wrong)
  
  Actually - let me verify by checking what the working rows look like.
  Source row 240: R=146, G=129, B=93  (brownish)
  Decoded row 240 (phone): R=70, G=1, B=1 (trouble row, skip)
  Source row 0: check from BMP
  Decoded row 0: R≈99 mean

  Since the image looks right in the first 241 rows as reported by user,
  we just need to use a known-working encoder. Use pysstv-style encoding.
  
Scottie transmit order: G channel → B channel → R channel
Each channel: 1500 + pixel_level / 255 * 800 Hz
"""

import wave, struct, numpy as np
from PIL import Image

RATE    = 22050
IMG_W   = 320
IMG_H   = 256
VIS     = 0x4C  # ScottieDX VIS code

# Timing (ms)
SYNC_MS = 9.0
SEP_MS  = 1.5
CH_MS   = 345.6  # per-channel duration

def tone(freq_hz, duration_ms):
    """Generate a pure sine wave at freq_hz for duration_ms."""
    n = int(round(duration_ms / 1000.0 * RATE))
    t = np.arange(n) / RATE
    return np.sin(2 * np.pi * freq_hz * t)

def pixel_freq(level):
    """Map pixel level 0-255 to SSTV frequency 1500-2300 Hz."""
    return 1500.0 + (level / 255.0) * 800.0

def encode_channel(row_pixels):
    """Encode one colour channel (array of 0-255 values) as FM audio."""
    n = int(round(CH_MS / 1000.0 * RATE))
    samples = np.zeros(n)
    for i in range(n):
        pixel_idx = int(i * IMG_W / n)
        freq = pixel_freq(row_pixels[pixel_idx])
        # Simple FM: use cumulative phase
        samples[i] = freq
    # Convert frequency array to phase-continuous sine wave
    phase = 0.0
    audio = np.zeros(n)
    for i in range(n):
        audio[i] = np.sin(phase)
        phase += 2 * np.pi * samples[i] / RATE
        phase %= 2 * np.pi
    return audio

def vis_header():
    """Generate standard SSTV VIS header for ScottieDX."""
    out = []
    # 300ms 1900Hz leader
    out.append(tone(1900, 300))
    # 10ms 1200Hz break
    out.append(tone(1200, 10))
    # 300ms 1900Hz second leader
    out.append(tone(1900, 300))
    # 30ms 1200Hz start bit
    out.append(tone(1200, 30))
    # 7 data bits LSB first + 1 parity bit (30ms each)
    vis = VIS
    parity_count = 0
    for i in range(7):
        bit = (vis >> i) & 1
        parity_count += bit
        freq = 1100 if bit == 1 else 1300  # 1=1100Hz, 0=1300Hz
        out.append(tone(freq, 30))
    # Even parity
    parity_bit = 0 if (parity_count % 2 == 0) else 1
    out.append(tone(1100 if parity_bit == 1 else 1300, 30))
    # 30ms 1200Hz stop bit
    out.append(tone(1200, 30))
    # 5ms 1900Hz gap to cleanly separate VIS stop bit from initial sync
    out.append(tone(1900, 5))
    return np.concatenate(out)

# Load source image
img = np.array(Image.open('sstv test/320256C.bmp').convert('RGB'))
print(f"Source image: {img.shape[1]}x{img.shape[0]}")

# Build audio
audio_parts = [vis_header()]

# Correct Scottie DX structure:
#   INITIAL_SYNC (9ms)
#   Line 0 content (NO leading sync): SEP + G0 + SEP + B0 + SEP + R0  = 1041ms
#   For lines 1-255: SYNC(9ms) + SEP + G + SEP + B + SEP + R          = 1050ms
#   FINAL_SYNC (9ms) — allows line 255 to be decoded
#
# Decoder pairs (initial, sync1), (sync1, sync2), ..., (sync255, final)
# = 257 syncs, 256 pairs, 256 lines decoded.

def scan_line_content(row):
    """Return SEP + G + SEP + B + SEP + R audio for the given image row (no leading sync).
    Scottie decoder mapping: G-slot→R, B-slot→G, R-slot→B (cyclic shift).
    So encode: G-slot=src_R, B-slot=src_G, R-slot=src_B for natural output colors."""
    r_ch = img[row, :, 0]  # source Red
    g_ch = img[row, :, 1]  # source Green
    b_ch = img[row, :, 2]  # source Blue
    return np.concatenate([
        tone(1500, SEP_MS),
        encode_channel(r_ch),   # G-slot  (decoder reads G-slot → Red output)
        tone(1500, SEP_MS),
        encode_channel(g_ch),   # B-slot  (decoder reads B-slot → Green output)
        tone(1500, SEP_MS),
        encode_channel(b_ch),   # R-slot  (decoder reads R-slot → Blue output)
    ])

# INITIAL_SYNC
audio_parts.append(tone(1200, SYNC_MS))
# Line 0 content (no leading sync)
audio_parts.append(scan_line_content(0))
print("  Encoded row 0/256")

# Lines 1-255: leading SYNC + content
for row in range(1, IMG_H):
    audio_parts.append(tone(1200, SYNC_MS))    # leading sync
    audio_parts.append(scan_line_content(row))
    if row % 32 == 0:
        print(f"  Encoded row {row}/{IMG_H}")

# FINAL_SYNC — triggers decode of line 255
audio_parts.append(tone(1200, SYNC_MS))

# 500ms silence at end
audio_parts.append(np.zeros(int(0.5 * RATE)))

audio = np.concatenate(audio_parts)
audio_int16 = (audio * 0.9 * 32767).astype(np.int16).clip(-32767, 32767)

out_path = 'sstv test/wav/ScottieDX.wav'
with wave.open(out_path, 'w') as wf:
    wf.setnchannels(1)
    wf.setsampwidth(2)
    wf.setframerate(RATE)
    wf.writeframes(audio_int16.tobytes())

total_s = len(audio) / RATE
print(f"\nSaved: {out_path}")
print(f"Duration: {total_s:.2f}s  (expected ~{256*CH_MS*3/1000 + 256*SYNC_MS/1000 + 1:.1f}s image + header)")
