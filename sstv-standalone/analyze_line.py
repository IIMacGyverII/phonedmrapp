"""
Analyze the internal frequency structure of an SSTV scan line.
Prints average demodulated level at 10ms slices within the scan period after each sync,
to determine the actual line format.
"""
import wave, struct, sys, math

WAV = r"C:\Users\Joshua\Documents\android\phonedmrapp\sstv test\wav\Robot_24.wav"
if len(sys.argv) > 1:
    WAV = sys.argv[1]

# ---- read WAV using wave module ----
with wave.open(WAV, 'rb') as wf:
    sr = wf.getframerate()
    ch = wf.getnchannels()
    bits = wf.getsampwidth() * 8
    n_frames = wf.getnframes()
    raw = wf.readframes(n_frames)

# decode to mono float samples
if bits == 16:
    samples_all = [struct.unpack_from('<h', raw, i)[0] / 32768.0
                   for i in range(0, len(raw) - 1, 2)]
else:
    raise ValueError(f"Unsupported bit depth: {bits}")
# take channel 0 if stereo
if ch == 2:
    samples = samples_all[::2]
else:
    samples = samples_all
print(f"WAV: {sr}Hz, {ch}ch, {bits}bit, {len(samples)} samples ({len(samples)/sr:.1f}s)")

# ---- simple IQ FM demod (matches Java IQDemodulator) ----
from cmath import exp, pi
center = 1900.0
bw = 2800 - 1000  # 1800 Hz full BW
osc_step = exp(-2j * pi * center / sr)
osc = complex(1, 0)
LPF_N = int(round(0.002 * sr)) | 1
lpf_buf = [complex(0)] * LPF_N

demod = []
prev_angle = 0.0
for s in samples:
    iq = complex(s, 0) * osc
    osc *= osc_step
    lpf_buf.pop(0); lpf_buf.append(iq)
    filtered = sum(lpf_buf) / LPF_N
    angle = math.atan2(filtered.imag, filtered.real)
    diff = angle - prev_angle
    if diff > pi:  diff -= 2*pi
    if diff < -pi: diff += 2*pi
    prev_angle = angle
    freq_norm = diff * sr / (2 * pi * bw / 2)  # normalize to [-1, 1]
    demod.append(freq_norm)

print(f"Demod done. Samples: {len(demod)}")

# ---- sync detection (Schmitt on smoothed signal) ----
SYNC_VAL = (1200 - 1900) * 2 / bw  # normalized 1200Hz = -0.778
SYNC_LOW = (1250 - 1900) * 2 / bw  # -0.722
SYNC_HIGH = (1400 - 1900) * 2 / bw  # -0.556
SYNC_FILT = int(round(0.0025 * sr)) | 1
FILT_DELAY = (SYNC_FILT - 1) // 2
THRESH_5MS = int(round(0.007 * sr))
THRESH_9MS = int(round(0.0145 * sr))

# running average
avg_buf = [0.0] * SYNC_FILT
delayed = [0.0] * SYNC_FILT
avg_sum = 0.0
trigger_state = True  # True = above threshold (not in sync)
counter = 0
syncs = []  # (position, width_type)

for i, v in enumerate(demod):
    avg_sum += v - avg_buf[0]
    avg_buf.pop(0); avg_buf.append(v)
    avg = avg_sum / SYNC_FILT
    delayed.pop(0); delayed.append(avg)
    delayed_val = delayed[0]

    if trigger_state:  # above high threshold = normal signal
        if avg < SYNC_LOW:
            trigger_state = False  # entered sync
            counter = 1
    else:
        if avg > SYNC_HIGH:
            trigger_state = True  # exited sync
            if 20 <= counter <= 200 and abs(delayed_val - SYNC_VAL) <= 0.111:
                if counter < THRESH_5MS:
                    wt = "FIVE_MS"
                elif counter < THRESH_9MS:
                    wt = "NINE_MS"
                else:
                    wt = "TWENTY_MS"
                end_pos = i - FILT_DELAY
                syncs.append((end_pos, wt, counter))
            counter = 0
        else:
            counter += 1

print(f"\nDetected {len(syncs)} sync pulses")

# ---- show spacings ----
print("\nFirst 10 sync spacings:")
for i in range(1, min(11, len(syncs))):
    ms = (syncs[i][0] - syncs[i-1][0]) * 1000 / sr
    print(f"  {i-1:2d}->{i:2d}: {ms:8.2f} ms  [{syncs[i][1]}, counter={syncs[i][2]}]")

# ---- find steady-state syncs (200ms spacing) ----
steady = []
for i in range(1, len(syncs)):
    ms = (syncs[i][0] - syncs[i-1][0]) * 1000 / sr
    if 185 <= ms <= 215:
        steady.append(syncs[i-1][0])
if steady:
    steady.append(syncs[len(steady)][0])  # add last

print(f"\nSteady-state syncs (200ms spacing): {len(steady)}")

# ---- frequency profile: slice the period after sync end into 10ms bins ----
PERIOD_MS = 200
PERIOD_SMP = int(round(PERIOD_MS * sr / 1000))
SLICE_MS = 5
SLICE_SMP = int(round(SLICE_MS * sr / 1000))
NUM_SLICES = PERIOD_MS // SLICE_MS

NUM_LINES = min(20, len(steady) - 1)

def freq_to_level(n):
    return max(0, min(255, int((n + 0.444) / 0.888 * 255)))

print(f"\nFrequency profile (avg decoded level per {SLICE_MS}ms slice), first {NUM_LINES} lines:")
print("Slice offset |", " ".join(f"{i*SLICE_MS:4d}" for i in range(NUM_SLICES)))

line_avgs = []
for line_idx in range(NUM_LINES):
    sp = steady[line_idx]
    avgs = []
    for s in range(NUM_SLICES):
        start = sp + s * SLICE_SMP
        end = min(start + SLICE_SMP, len(demod))
        if end > start:
            vals = [freq_to_level(demod[j]) for j in range(start, end)]
            avgs.append(sum(vals) / len(vals))
        else:
            avgs.append(0)
    line_avgs.append(avgs)
    print(f"Line {line_idx:3d}      |", " ".join(f"{a:4.0f}" for a in avgs))

# ---- summary: column means (helps see structure) ----
means = [sum(line_avgs[r][c] for r in range(NUM_LINES)) / NUM_LINES
         for c in range(NUM_SLICES)]
print("\nColumn mean  |", " ".join(f"{m:4.0f}" for m in means))

# ---- standard deviation per column (high std = image content, low std = sync/porch) ----
stds = []
for c in range(NUM_SLICES):
    col = [line_avgs[r][c] for r in range(NUM_LINES)]
    mean = means[c]
    std = (sum((x - mean)**2 for x in col) / max(1, len(col))) ** 0.5
    stds.append(std)
print("Column std   |", " ".join(f"{s:4.0f}" for s in stds))
print()
print("Interpretation: Low std = sync/separator (flat DC).  High std = image data (varying per-line).")
