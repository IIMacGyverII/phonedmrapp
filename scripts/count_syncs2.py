"""
Count Martin M1 sync pulses by bandpass-filtering around sync frequency
and using threshold-based detection.
"""
import wave
import numpy as np
from scipy.signal import butter, sosfilt, sosfiltfilt

with wave.open('sstv_audio_live.wav', 'rb') as w:
    sr = w.getframerate()
    frames = w.readframes(w.getnframes())
samples = np.frombuffer(frames, dtype=np.int16).astype(np.float32) / 32768.0
print(f'Loaded: {len(samples)} samples @ {sr}Hz, {len(samples)/sr:.2f}s')

# Bandpass 900–1300 Hz to isolate sync energy
sos = butter(4, [900, 1300], btype='bandpass', fs=sr, output='sos')
sync_band = sosfilt(sos, samples)

# Envelope via RMS over 1ms windows
win = int(sr * 0.001)
energy = np.convolve(sync_band**2, np.ones(win)/win, mode='same')

# Threshold: high if energy is well above noise floor
# Find threshold as 2× noise floor (20th percentile of energy)
noise_floor = np.percentile(energy, 20)
threshold = noise_floor * 20
print(f'Noise floor: {noise_floor:.6f}, threshold: {threshold:.6f}')

# Schmitt trigger: detect transitions
above = energy > threshold
transitions = np.diff(above.astype(int))
rise = np.where(transitions == 1)[0]
fall = np.where(transitions == -1)[0]

# Align falls with rises
if len(rise) == 0 or len(fall) == 0:
    print('No sync pulses detected')
    exit()

if fall[0] < rise[0]:
    fall = fall[1:]

min_len = min(len(rise), len(fall))
rise = rise[:min_len]
fall = fall[:min_len]

# Filter: keep pulses that are 4.5–5.5ms long (Martin M1 sync)
min_samp = int(0.0045 * sr)
max_samp = int(0.0055 * sr)
durations = fall - rise
mask = (durations >= min_samp) & (durations <= max_samp)
martin_starts = rise[mask]
martin_ends = fall[mask]

print(f'Martin M1 sync pulses (4.5–5.5ms): {len(martin_starts)}')
print(f'First few at: {[f"{x/sr*1000:.1f}ms" for x in martin_starts[:5]]}')
print(f'Last few at: {[f"{x/sr*1000:.1f}ms" for x in martin_starts[-5:]]}')

if len(martin_starts) >= 2:
    spacings_ms = np.diff(martin_starts) / sr * 1000
    print(f'Spacing stats: median={np.median(spacings_ms):.2f}ms, '
          f'expected=446.45ms, stddev={np.std(spacings_ms):.2f}ms')
    
    # Count consecutive valid spacings (446 ± 50ms)
    valid_lines = 0
    for sp in spacings_ms:
        if 396 < sp < 496:
            valid_lines += 1
    print(f'Consecutive valid line spacings: {valid_lines}')
