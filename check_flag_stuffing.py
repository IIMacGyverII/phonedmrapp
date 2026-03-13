from test_bit_stuffing import apply_bit_stuffing

# Check what happens when we stuff 0x7E
result = apply_bit_stuffing(bytes([0x7E]))
print(f"0x7E → {result.hex().upper()}")

bits = []
for byte in result:
    for i in range(8):
        bits.append((byte >> i) & 1)
print(f"Bits: {''.join(str(b) for b in bits)}")
print(f"Expected: 01111110 (8 bits)")
print(f"Got: {len(bits)} bits")

# Also check multiple FLAGS
result2 = apply_bit_stuffing(bytes([0x7E, 0x7E]))
print(f"\n0x7E 0x7E → {result2.hex().upper()}")
