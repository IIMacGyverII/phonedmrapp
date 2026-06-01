import math

# Constants
MARK_FREQ = 1200
SPACE_FREQ = 2200
SAMPLE_RATE = 48000

# Calculate phase increments
MARK_PHASE_INC = 2.0 * math.pi * MARK_FREQ / SAMPLE_RATE
SPACE_PHASE_INC = 2.0 * math.pi * SPACE_FREQ / SAMPLE_RATE

print("VERIFICATION OF PHASE INCREMENTS")
print("=" * 60)
print(f"\nConstants:")
print(f"  MARK_FREQ   = {MARK_FREQ} Hz")
print(f"  SPACE_FREQ  = {SPACE_FREQ} Hz")
print(f"  SAMPLE_RATE = {SAMPLE_RATE} Hz")

print(f"\nPhase Increments:")
print(f"  MARK_PHASE_INC  = {MARK_PHASE_INC:.6f} rad/sample")
print(f"  SPACE_PHASE_INC = {SPACE_PHASE_INC:.6f} rad/sample")

# Verify by calculating back to frequency
mark_freq_check = MARK_PHASE_INC * SAMPLE_RATE / (2.0 * math.pi)
space_freq_check = SPACE_PHASE_INC * SAMPLE_RATE / (2.0 * math.pi)

print(f"\nVerification (calculate back to frequency):")
print(f"  MARK_PHASE_INC  * SAMPLE_RATE / (2π) = {mark_freq_check:.1f} Hz")
print(f"  SPACE_PHASE_INC * SAMPLE_RATE / (2π) = {space_freq_check:.1f} Hz")

# Calculate samples per cycle
mark_samples_per_cycle = SAMPLE_RATE / MARK_FREQ
space_samples_per_cycle = SAMPLE_RATE / SPACE_FREQ

print(f"\nSamples per complete cycle:")
print(f"  MARK  (1200 Hz): {mark_samples_per_cycle:.2f} samples")
print(f"  SPACE (2200 Hz): {space_samples_per_cycle:.2f} samples")

# Half-cycle (zero crossing period)
mark_half_cycle = mark_samples_per_cycle / 2
space_half_cycle = space_samples_per_cycle / 2

print(f"\nSamples per half-cycle (zero-crossing period):")
print(f"  MARK  (1200 Hz): {mark_half_cycle:.2f} samples")
print(f"  SPACE (2200 Hz): {space_half_cycle:.2f} samples")

print(f"\n{'=' * 60}")
print("EXPECTED BEHAVIOR:")
print("  - Using MARK_PHASE_INC should produce ~20 samples between zero crossings")
print("  - Using SPACE_PHASE_INC should produce ~11 samples between zero crossings")
print(f"\nOUR OBSERVATION:")
print("  - First period: 11 samples → matches SPACE (2200 Hz)")
print("  - But we're using MARK_PHASE_INC (0.157080) for bits 1-6!")
print(f"\n{'=' * 60}")

# Simulate first few samples with MARK_PHASE_INC
print("\nSIMULATING FIRST 50 SAMPLES WITH MARK_PHASE_INC:")
print("(After initial 40 SPACE samples for bit 0)")

phase = 0.0
# Skip first bit (40 samples of SPACE)
for i in range(40):
    phase += SPACE_PHASE_INC
    phase %= (2.0 * math.pi)

print(f"\nPhase after bit 0 (SPACE): {phase:.4f} rad = {math.degrees(phase):.1f}°")

# Now generate bit 1 (MARK) and find zero crossings
print(f"\nGenerating bit 1 (MARK, phase_inc={MARK_PHASE_INC:.6f}):")
prev_sample = math.sin(phase)
zero_crossings = []

for i in range(40):
    sample = math.sin(phase)
    
    # Check for zero crossing
    if (prev_sample < 0 and sample >= 0) or (prev_sample >= 0 and sample < 0):
        zero_crossings.append(i + 40)  # +40 to account for first bit
        print(f"  Zero crossing at sample {i + 40} (bit 1, sample {i})")
    
    phase += MARK_PHASE_INC
    phase %= (2.0 * math.pi)
    prev_sample = sample

if len(zero_crossings) >= 2:
    period = zero_crossings[1] - zero_crossings[0]
    freq = SAMPLE_RATE / (2 * period)
    print(f"\nPeriod between zero crossings: {period} samples → {freq:.1f} Hz")
