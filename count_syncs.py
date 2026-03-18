import wave, numpy as np
from PIL import Image

with wave.open('sstv_audio_live.wav', 'rb') as w:
    sr = w.getframerate()
    frames = w.readframes(w.getnframes())
samples = np.frombuffer(frames, dtype=np.int16).astype(np.float32) / 32768.0

print(f'Total samples: {len(samples)}, sr={sr}')

# FM demodulate via phase differentiation of the analytic signal
from scipy.signal import hilbert
analytic = hilbert(samples)
phase = np.unwrap(np.angle(analytic))
freq = np.diff(phase) / (2 * np.pi) * sr  # instantaneous frequency in Hz

# Find sync pulses: freq < 1350 Hz (sync region = ~1200Hz)
sync_mask = freq < 1350
sync_ints = np.diff(sync_mask.astype(int))
sync_starts = np.where(sync_ints == 1)[0]
sync_ends   = np.where(sync_ints == -1)[0]
if sync_mask[0]:  sync_starts = np.concatenate([[0], sync_starts])
if sync_mask[-1]: sync_ends   = np.concatenate([sync_ends, [len(sync_mask)-1]])

# Keep only 5ms Martin M1 sync pulses (4.5–5.5ms)
five_ms_min = int(0.0045 * sr)
five_ms_max = int(0.0055 * sr)

martin_syncs = []
for s, e in zip(sync_starts, sync_ends):
    dur = e - s
    if five_ms_min <= dur <= five_ms_max:
        martin_syncs.append(s)

print(f'Martin M1 syncs found: {len(martin_syncs)}')
if len(martin_syncs) >= 2:
    spacings = np.diff(martin_syncs)
    print(f'Image starts (~first sync after leader): sync[0] at {martin_syncs[0]} samples = {martin_syncs[0]/sr*1000:.1f}ms')
    print(f'Inter-sync median spacing: {np.median(spacings):.0f} samples  expected: {int(0.446446*sr)}')
    print(f'Min spacing: {spacings.min()}  Max: {spacings.max()}')
    
    # Decode image using sync positions
    line_samples = int(0.446446 * sr)
    IMG_W = 320
    IMG_H = 256
    
    img = np.zeros((IMG_H, IMG_W, 3), dtype=np.uint8)
    
    ch_samples = int(0.146432 * sr)  # channel width
    porch_samp = int(0.000572 * sr)  # 0.572ms porch
    sep_samp   = int(0.000572 * sr)  # 0.572ms sep
    
    # Use sync idx: decode line N between sync[N] and sync[N+1]
    decoded_rows = 0
    for row in range(IMG_H):
        if row + 1 >= len(martin_syncs):
            print(f'  Ran out of syncs at row {row}')
            break
        sync_end = martin_syncs[row] + int(0.004862 * sr)  # sync end
        green_start = sync_end + porch_samp
        blue_start  = green_start + ch_samples + sep_samp
        red_start   = blue_start  + ch_samples + sep_samp
        end_idx     = red_start   + ch_samples
        
        if end_idx >= len(freq):
            print(f'  Audio too short at row {row}')
            break
        
        for x in range(IMG_W):
            gi = green_start + (x * ch_samples) // IMG_W
            bi = blue_start  + (x * ch_samples) // IMG_W
            ri = red_start   + (x * ch_samples) // IMG_W
            # freq → brightness: 1500Hz=0, 2300Hz=255
            def f2b(f_hz): return max(0, min(255, int((f_hz - 1500) / 800 * 255)))
            img[row, x, 0] = f2b(freq[ri])
            img[row, x, 1] = f2b(freq[gi])
            img[row, x, 2] = f2b(freq[bi])
        decoded_rows += 1
    
    print(f'Decoded {decoded_rows} rows')
    row_means = img.mean(axis=(1,2))
    black_bottom = sum(1 for v in reversed(row_means) if v < 8)
    print(f'Black rows at bottom: {black_bottom}')
    Image.fromarray(img).save('sstv_ref_decoded.png')
    print('Saved sstv_ref_decoded.png')
