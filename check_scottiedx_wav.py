"""
Check ScottieDX WAV for bad lines and regenerate if needed.
Scottie format: SYNC(9ms,1200Hz) | SEP(1.5ms,1500Hz) | G(345.6ms) | SEP | B | SEP | R
Channel encoding: freq = 1500 + level/255 * 800   (1500Hz=black, 2300Hz=white)
"""
import wave, struct, numpy as np
from PIL import Image

RATE = 22050
LINE_MS = 1050.3         # full Scottie DX scan line
SYNC_MS = 9.0
SEP_MS  = 1.5
CH_MS   = 345.6

LINE_S = int(round(LINE_MS / 1000.0 * RATE))
SYNC_S = int(round(SYNC_MS / 1000.0 * RATE))
SEP_S  = int(round(SEP_MS  / 1000.0 * RATE))
CH_S   = int(round(CH_MS   / 1000.0 * RATE))

def dominant_freq(sig, center, win=512):
    s = max(0, center - win//2)
    chunk = sig[s:s+win]
    if len(chunk) < 64:
        return 0
    chunk = chunk * np.hanning(len(chunk))
    spec = np.abs(np.fft.rfft(chunk, n=2048))
    freqs = np.fft.rfftfreq(2048, 1/RATE)
    mask = (freqs >= 1200) & (freqs <= 2400)
    return freqs[mask][np.argmax(spec[mask])]

# -- Load WAV --
with wave.open('sstv test/wav/ScottieDX.wav', 'rb') as f:
    assert f.getframerate() == RATE, f"Expected {RATE}Hz"
    raw = np.frombuffer(f.readframes(f.getnframes()), np.int16).astype(np.float32) / 32768.0

print(f"WAV: {len(raw)} samples ({len(raw)/RATE:.2f}s) @ {RATE}Hz")

# Estimate sp[0] using known row-236 sync position from standalone debug
SP_236 = 5496646
sp0 = SP_236 - 236 * LINE_S
print(f"Estimated sp[0] = {sp0}  ({sp0/RATE*1000:.0f}ms)")

# Scan all rows
print("\nRow  gMidHz  good?")
bad_rows = []
for row in range(256):
    sp = sp0 + row * LINE_S
    gStart = sp + SEP_S
    mid = gStart + CH_S // 2
    hz = dominant_freq(raw, mid)
    good = hz >= 1600
    if not good:
        bad_rows.append(row)
    if row >= 228 or not good:
        print(f"  {row:3d}: {hz:5.0f}Hz  {'OK' if good else 'BAD'}")

print(f"\nTotal bad rows: {len(bad_rows)}, first bad: {bad_rows[0] if bad_rows else 'none'}")
