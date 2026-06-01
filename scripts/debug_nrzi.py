#!/usr/bin/env python3
"""Debug NRZI encoding to see what's happening"""

MARK_FREQ = 1200
SPACE_FREQ = 2200

# Test with known-good packet first bytes
test_packet = bytes([0x7E, 0x82, 0xA0, 0x84])

print("Testing NRZI encoding logic:")
print(f"Packet bytes: {' '.join(f'{b:02X}' for b in test_packet)}")
print()

current_freq = SPACE_FREQ
toggle_count = 0
no_change_count = 0

for byte_idx, byte_val in enumerate(test_packet):
    print(f"Byte {byte_idx}: 0x{byte_val:02X} = 0b{byte_val:08b}")
    
    for bit_idx in range(8):
        bit = (byte_val >> bit_idx) & 1  # LSB first
        
        # Standard NRZI: 0 = toggle
        toggle = (bit == 0)
        
        if toggle:
            if current_freq == MARK_FREQ:
                current_freq = SPACE_FREQ
                action = "toggle MARK→SPACE"
            else:
                current_freq = MARK_FREQ
                action = "toggle SPACE→MARK"
            toggle_count += 1
        else:
            action = f"no change ({current_freq}Hz)"
            no_change_count += 1
        
        print(f"  Bit {bit_idx}: {bit} → {action}")
    print()

print(f"Summary: {toggle_count} toggles, {no_change_count} no-changes")
print(f"Final frequency: {current_freq} Hz")
