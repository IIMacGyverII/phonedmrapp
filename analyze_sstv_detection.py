"""
Simulate SSTVIQDemodulator sync detection on captured RF audio to diagnose
why PD120 is falsely returned for a ScottieDX signal.
"""
import wave, struct, math

WAV = r'sstv test/rf_capture.wav'
wf = wave.open(WAV)
sr = wf.getframerate()
nc = wf.getnchannels()
nf = wf.getnframes()
print(f'Sample rate: {sr} Hz, channels: {nc}, frames: {nf}, duration: {nf/sr:.1f}s')

data = wf.readframes(nf)
wf.close()
unpacked = struct.unpack('<' + 'h' * (len(data) // 2), data)
if nc > 1:
    samples = unpacked[::nc]
else:
    samples = unpacked
nf = len(samples)
print(f'Samples: {nf} ({nf/sr:.1f}s)')

# ---- Simulate IQ demodulator sync detection ----
LOWEST_FREQ  = 1000.0
HIGHEST_FREQ = 2800.0
SIGNAL_BW    = HIGHEST_FREQ - LOWEST_FREQ   # 1800 Hz
CENTER_FREQ  = (LOWEST_FREQ + HIGHEST_FREQ) / 2  # 1900 Hz

def normalize(f):
    return (f - CENTER_FREQ) * 2 / SIGNAL_BW

SCHMITT_LOW_VAL  = normalize(1250.0)
SCHMITT_HIGH_VAL = normalize(1400.0)

# Pulse width thresholds (matching SSTVIQDemodulator constructor)
FIVE_MS_MIN   = int(round(0.0025 * sr))
FIVE_MS_MAX   = int(round((0.005 + 0.009) / 2 * sr))
NINE_MS_MAX   = int(round((0.009 + 0.020) / 2 * sr))
TWENTY_MS_MAX = int(round((0.020 + 0.005) * sr))
print(f'Thresholds: 5ms_min={FIVE_MS_MIN} 5ms_max={FIVE_MS_MAX} 9ms_max={NINE_MS_MAX} 20ms_max={TWENTY_MS_MAX}')

# Simple phase-difference FM demod (no low-pass filter — rough but directional)
phase_step = -2 * math.pi * CENTER_FREQ / sr
angle = 0.0
prev_re, prev_im = 1.0, 0.0

schmitt_state = True   # True=HIGH, False=LOW
sync_counter  = 0

nine_ms   = []
five_ms   = []
twenty_ms = []

MAX_ANALYZE = min(nf, int(sr * 25))

for i in range(MAX_ANALYZE):
    s = samples[i] / 32768.0
    re = s * math.cos(angle)
    im = s * math.sin(angle)
    angle += phase_step
    if angle < -math.pi:
        angle += 2 * math.pi

    # FM demod: instantaneous phase difference
    # cross = Im(conj(prev) * curr) = prev_re*im - prev_im*re
    # dot   = Re(conj(prev) * curr) = prev_re*re + prev_im*im
    cross = prev_re * im - prev_im * re
    dot   = prev_re * re + prev_im * im
    freq_norm = math.atan2(cross, dot) / math.pi * (sr / SIGNAL_BW)
    prev_re, prev_im = re, im

    if schmitt_state:                              # currently HIGH
        if freq_norm < SCHMITT_LOW_VAL:
            schmitt_state = False
            sync_counter  = 1
    else:                                          # currently LOW
        sync_counter += 1
        if freq_norm > SCHMITT_HIGH_VAL:
            schmitt_state = True
            if FIVE_MS_MIN <= sync_counter < FIVE_MS_MAX:
                five_ms.append(i)
            elif sync_counter < NINE_MS_MAX:
                nine_ms.append(i)
            elif sync_counter < TWENTY_MS_MAX:
                twenty_ms.append(i)
            sync_counter = 0

print(f'\nSyncs in first {MAX_ANALYZE/sr:.0f}s:  9ms={len(nine_ms)}  5ms={len(five_ms)}  20ms={len(twenty_ms)}')
print('First 20 nine_ms positions (samples):', nine_ms[:20])
print('First 20 twenty_ms positions:', twenty_ms[:20])


def spacings_ms(positions):
    sp = []
    for i in range(1, len(positions)):
        ms = (positions[i] - positions[i - 1]) * 1000.0 / sr
        if ms > 30:
            sp.append(ms)
    return sp


def check_mode(sp, label, period, tol, min_votes=4):
    votes = sum(1 for s in sp if abs(s - period) < tol)
    status = 'MATCH' if votes >= min_votes else '----'
    print(f'  [{status}] {label}: {votes}/{len(sp)} spacings within +-{tol:.1f}ms of {period}ms')


def analyse(positions, label):
    if len(positions) < 2:
        print(f'{label}: too few positions ({len(positions)})')
        return
    sp = spacings_ms(positions)
    print(f'\n{label} ({len(positions)} positions, {len(sp)} spacings):')
    first10 = [round(s, 1) for s in sp[:10]]
    print(f'  First 10 spacings: {first10}')
    check_mode(sp, 'ScottieDX (1050.3ms)',  1050.3, 15.75)
    check_mode(sp, 'ScottieS1 (428.22ms)',   428.22, 12.0)
    check_mode(sp, 'PD120 (369.78ms)',        369.78, 12.0)
    check_mode(sp, 'PD180 (573.2ms)',          573.2, 12.0)
    check_mode(sp, 'Robot36 (150ms)',           150.0, 12.0)

analyse(nine_ms,   'NINE_MS positions')
analyse(five_ms,   'FIVE_MS positions')
analyse(twenty_ms, 'TWENTY_MS positions')

all_sorted = sorted(nine_ms + five_ms + twenty_ms)
analyse(all_sorted, 'ALL combined (sorted)')

# Show AT WHICH TIME (seconds) each auto-detect fires and what the counts are
print('\n--- Simulated auto-detect windows ---')
window_seconds = [5, 12, 16, 20]
for t in window_seconds:
    limit = t * sr
    n9  = sum(1 for p in nine_ms   if p < limit)
    n5  = sum(1 for p in five_ms   if p < limit)
    n20 = sum(1 for p in twenty_ms if p < limit)
    sp9  = spacings_ms([p for p in nine_ms   if p < limit])
    sp20 = spacings_ms([p for p in twenty_ms if p < limit])
    v9_sdx = sum(1 for s in sp9  if abs(s - 1050.3) < 15.75)
    v9_pd  = sum(1 for s in sp9  if abs(s -  369.78) < 12.0)
    v20_pd = sum(1 for s in sp20 if abs(s -  369.78) < 12.0)
    print(f'  t={t}s: 9ms={n9}(votes sdx={v9_sdx}/pd={v9_pd}) 20ms={n20}(pd={v20_pd}) 5ms={n5}')
