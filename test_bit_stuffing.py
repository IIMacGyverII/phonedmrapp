"""Test bit stuffing implementation"""

def apply_bit_stuffing(data):
    """Apply bit stuffing: insert 0 after five consecutive 1s"""
    bits = []
    for byte in data:
        for i in range(8):
            bits.append((byte >> i) & 1)
    
    stuffed = []
    consecutive_ones = 0
    
    for bit in bits:
        stuffed.append(bit)
        if bit == 1:
            consecutive_ones += 1
            if consecutive_ones == 5:
                stuffed.append(0)  # Stuff a 0
                consecutive_ones = 0
        else:
            consecutive_ones = 0
    
    # Convert back to bytes
    result = []
    for i in range(0, len(stuffed), 8):
        byte_val = 0
        for j in range(min(8, len(stuffed) - i)):
            if stuffed[i + j]:
                byte_val |= (1 << j)
        result.append(byte_val)
    
    return bytes(result)

# Test with simple patterns
print("Testing bit stuffing:")
print()

# Test 1: No stuffing needed
test1 = bytes([0xAA])  # 10101010
result1 = apply_bit_stuffing(test1)
print(f"Test 1: 0xAA (10101010) → {result1.hex().upper()}")
print(f"  Expected: AA (no stuffing)")
print()

# Test 2: Five 1s (0x1F = 11111000) should insert a 0
test2 = bytes([0x1F])
result2 = apply_bit_stuffing(test2)
bits2 = []
for byte in test2:
    for i in range(8):
        bits2.append((byte >> i) & 1)
print(f"Test 2: 0x1F ({int(''.join(str(b) for b in bits2), 2):08b}) → {result2.hex().upper()}")
print(f"  Input bits (LSB first): {''.join(str(b) for b in bits2)}")
result_bits2 = []
for byte in result2:
    for i in range(8):
        result_bits2.append((byte >> i) & 1)
print(f"  Output bits: {''.join(str(b) for b in result_bits2)}")
print(f"  Expected: five 1s followed by stuffed 0")
print()

# Test 3: FLAG byte 0x7E should NOT be stuffed (it's < 5 consecutive 1s)
# 0x7E = 01111110 LSB first = 0,1,1,1,1,1,1,0
test3 = bytes([0x7E])
result3 = apply_bit_stuffing(test3)
bits3 = []
for byte in test3:
    for i in range(8):
        bits3.append((byte >> i) & 1)
print(f"Test 3: 0x7E (FLAG) → {result3.hex().upper()}")
print(f"  Input bits (LSB first): {''.join(str(b) for b in bits3)}")
result_bits3 = []
for byte in result3:
    for i in range(8):
        result_bits3.append((byte >> i) & 1)
print(f"  Output bits: {''.join(str(b) for b in result_bits3)}")
print(f"  Expected: 0 + six 1s + 0 = should trigger stuffing after 5th 1!")
print()

# Test 4: Multiple bytes with consecutive 1s crossing byte boundary
test4 = bytes([0xFF, 0xFF])  # 16 consecutive 1s
result4 = apply_bit_stuffing(test4)
print(f"Test 4: 0xFF 0xFF (16 consecutive 1s) → {result4.hex().upper()}")
bits4_in = []
for byte in test4:
    for i in range(8):
        bits4_in.append((byte >> i) & 1)
print(f"  Input bits: {''.join(str(b) for b in bits4_in)}")
bits4_out = []
for byte in result4:
    for i in range(8):
        bits4_out.append((byte >> i) & 1)
print(f"  Output bits: {''.join(str(b) for b in bits4_out)}")
print(f"  Should have stuffed 0s after every 5 consecutive 1s")
