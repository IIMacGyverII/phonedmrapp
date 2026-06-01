"""
Generate a synthetic Robot 72 SSTV test signal.

Robot 72 format (240 lines, 320 pixels/line):
  VIS code: 0x0C
  Each scan line: SYNC(9ms,1200Hz) + PORCH(3ms,1500Hz) + Y(138ms) + SEP(4.5ms,1500Hz) +
                  PORCH2(1.5ms,1500Hz) + Ry(69ms) + SEP(4.5ms,1500Hz) +
                  PORCH2(1.5ms,1500Hz) + By(69ms)  =  300ms total

YUV encoding (same as Y Cb Cr but called Y Ry By in SSTV):
  Frequency = 1500 + level/255 * 800 Hz  (1500Hz=0, 2300Hz=255)
  For luma Y: 0=black=1500Hz, 255=white=2300Hz
  For chroma Ry/By: bipolar centered at 128 (0 chroma) = 1900Hz center
  
  Ry = R - Y  (red difference)
  By = B - Y  (blue difference)
  Encoded as unsigned 8-bit with 128 = neutral
"""

import wave, struct, numpy as np
from PIL import Image, ImageDraw

RATE  = 16000
W     = 320
H     = 240
VIS   = 0x0C  # Robot 72

def tone(freq_hz, duration_ms):
    n = int(round(duration_ms / 1000.0 * RATE))
    return freq_hz * np.ones(n)  # return frequency array

def freq_array_to_audio(freqs):
    """Convert frequency array to phase-continuous sine wave."""
    audio = np.zeros(len(freqs))
    phase = 0.0
    for i, f in enumerate(freqs):
        audio[i] = np.sin(phase)
        phase += 2 * np.pi * f / RATE
    return audio

def level_to_freq(level):
    """Map pixel level 0-255 to SSTV frequency 1500-2300 Hz."""
    return 1500.0 + (level / 255.0) * 800.0

def encode_channel(pixels, duration_ms):
    """Encode one channel array (0-255 per pixel) as a frequency array."""
    n = int(round(duration_ms / 1000.0 * RATE))
    freqs = np.zeros(n)
    for i in range(n):
        pixel_idx = int(i * len(pixels) / n)
        freqs[i] = level_to_freq(pixels[pixel_idx])
    return freqs

def rgb_to_yuv(r, g, b):
    """Convert RGB to YUV (YCbCr) in [0, 255] range."""
    Y  = int( 0.299 * r + 0.587 * g + 0.114 * b)
    Ry = int(-0.169 * r - 0.331 * g + 0.500 * b + 128)  # Cb in standard = By in Robot
    By = int( 0.500 * r - 0.419 * g - 0.081 * b + 128)  # Cr in standard = Ry in Robot
    # Actually Robot 72 uses:
    # Ry = R - Y  (red difference, Cr)
    # By = B - Y  (blue difference, Cb)
    Ry_robot = int(r - Y + 128)  # Ry = red difference centered at 128
    By_robot = int(b - Y + 128)  # By = blue difference centered at 128
    Y  = max(0, min(255, Y))
    Ry_robot = max(0, min(255, Ry_robot))
    By_robot = max(0, min(255, By_robot))
    return Y, Ry_robot, By_robot

def vis_header():
    """Generate standard SSTV VIS header."""
    parts = []
    parts.append(tone(1900, 300))   # Leader 1
    parts.append(tone(1200, 10))    # Break
    parts.append(tone(1900, 300))   # Leader 2
    parts.append(tone(1200, 30))    # Start bit

    vis = VIS
    parity_count = 0
    for i in range(7):
        bit = (vis >> i) & 1
        parity_count += bit
        freq = 1100 if bit else 1300
        parts.append(tone(freq, 30))

    parity_bit = 0 if (parity_count % 2 == 0) else 1
    parts.append(tone(1100 if parity_bit else 1300, 30))
    parts.append(tone(1200, 30))   # Stop bit
    return np.concatenate(parts)

# Create a simple test image: color bars (6 columns)
img_arr = np.zeros((H, W, 3), dtype=np.uint8)
colors = [
    (255, 255, 255),  # White
    (255, 255,   0),  # Yellow
    (  0, 255, 255),  # Cyan
    (  0, 255,   0),  # Green
    (255,   0, 255),  # Magenta
    (255,   0,   0),  # Red
    (  0,   0, 255),  # Blue
    (  0,   0,   0),  # Black
]
bar_w = W // len(colors)
for i, (r, g, b) in enumerate(colors):
    img_arr[:, i*bar_w:(i+1)*bar_w] = [r, g, b]
# Add a gradient strip at the bottom
for x in range(W):
    y_level = int(x / W * 255)
    img_arr[H-20:H, x] = [y_level, y_level, y_level]
# Mark top/bottom/center for orientation
img_arr[0:5, :] = [255, 0, 0]     # Red top line
img_arr[H-5:H, :] = [0, 0, 255]   # Blue bottom line
img_arr[H//2-2:H//2+2, :] = [255, 255, 0]  # Yellow center line

print(f"Test image: {W}x{H} color bars")

# Build audio
header_freqs = vis_header()
audio_parts = [header_freqs]

print(f"Generating {H} scan lines (300ms each = {H * 300}ms total)...")

for row in range(H):
    # Get image row
    row_pixels = img_arr[row, :, :]  # (W, 3)

    # Convert to YRyBy
    Y_arr  = np.zeros(W, dtype=float)
    Ry_arr = np.zeros(W, dtype=float)
    By_arr = np.zeros(W, dtype=float)
    for x in range(W):
        r, g, b = row_pixels[x]
        Y, Ry, By = rgb_to_yuv(int(r), int(g), int(b))
        Y_arr[x]  = Y
        Ry_arr[x] = Ry
        By_arr[x] = By

    # Build scan line frequency array
    line_parts = [
        tone(1200, 9.0),      # SYNC
        tone(1500, 3.0),      # PORCH
        encode_channel(Y_arr,  138.0),  # Y luma
        tone(1500, 4.5),      # SEP
        tone(1500, 1.5),      # PORCH2
        encode_channel(Ry_arr, 69.0),   # Ry (red difference)
        tone(1500, 4.5),      # SEP
        tone(1500, 1.5),      # PORCH2
        encode_channel(By_arr, 69.0),   # By (blue difference)
    ]
    audio_parts.append(np.concatenate(line_parts))

    if row % 60 == 0:
        print(f"  Row {row}/{H}")

# Add final sync to allow last line to be decoded via pair (sync_239, sync_240)
audio_parts.append(tone(1200, 9.0))

all_freqs = np.concatenate(audio_parts)
audio = freq_array_to_audio(all_freqs)
audio_int16 = (audio * 32767).astype(np.int16)

# Write WAV
outfile = 'robot72_test.wav'
with wave.open(outfile, 'w') as wf:
    wf.setnchannels(1)
    wf.setsampwidth(2)
    wf.setframerate(RATE)
    wf.writeframes(audio_int16.tobytes())

duration = len(audio) / RATE
print(f"Written {outfile}: {len(audio)} samples, {duration:.1f}s")

# Also save the test image for comparison
Image.fromarray(img_arr).save('robot72_source.png')
print("Saved robot72_source.png")
