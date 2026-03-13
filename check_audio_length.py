"""
Check if we have enough audio for the full packet
"""

# Configuration
SAMPLE_RATE = 48000
BAUD_RATE = 1200
samples_per_bit = SAMPLE_RATE / BAUD_RATE  # 40 samples/bit

# Packet structure
silence_samples = 1280
preamble_flags = 20
preamble_bits = preamble_flags * 8

# From generator output
stuffed_data_bytes = 45  # From hex dump
final_packet_bytes = 1 + stuffed_data_bytes + 1  # Opening + data + closing = 47 bytes
final_packet_bits = final_packet_bytes * 8

# Tail silence
tail_bits = 48  # 4 bytes worth
tail_samples = tail_bits * samples_per_bit

# Total calculation
total_bits = preamble_bits + final_packet_bits + tail_bits
total_samples = silence_samples + (total_bits * samples_per_bit) + tail_samples

print("=" * 70)
print("AUDIO LENGTH CALCULATION:")
print("=" * 70)
print(f"Sample rate: {SAMPLE_RATE} Hz")
print(f"Baud rate: {BAUD_RATE} bps")
print(f"Samples per bit: {samples_per_bit}")
print()
print(f"Leading silence: {silence_samples} samples")
print(f"Preamble: {preamble_flags} FLAGS × 8 bits = {preamble_bits} bits")
print(f"  = {preamble_bits * samples_per_bit:.0f} samples")
print()
print(f"Packet data: {final_packet_bytes} bytes × 8 bits = {final_packet_bits} bits")
print(f"  = {final_packet_bits * samples_per_bit:.0f} samples")
print(f"  (1 opening FLAG + {stuffed_data_bytes} stuffed data + 1 closing FLAG)")
print()
print(f"Tail: {tail_bits} bits = {tail_samples:.0f} samples")
print()
print(f"TOTAL NEEDED: {total_samples:.0f} samples ({total_samples/SAMPLE_RATE:.3f} seconds)")
print()

# Check actual file
import wave
with wave.open("aprs_fixed_test.wav", 'rb') as wav:
    actual_samples = wav.getnframes()
    actual_rate = wav.getframerate()

print(f"ACTUAL FILE: {actual_samples} samples ({actual_samples/actual_rate:.3f} seconds)")
print()

if actual_samples < total_samples:
    shortfall = total_samples - actual_samples
    missing_bits = shortfall / samples_per_bit
    print(f"✗ FILE TOO SHORT!")
    print(f"  Missing: {shortfall:.0f} samples ({missing_bits:.1f} bits)")
    print(f"  This explains why closing FLAG is corrupted!")
else:
    extra = actual_samples - total_samples
    print(f"✓ File has enough samples")
    print(f"  Extra: {extra:.0f} samples")
