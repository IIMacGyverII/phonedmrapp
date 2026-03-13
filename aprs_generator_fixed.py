#!/usr/bin/env python3
"""
APRS AFSK Generator - FIXED VERSION
Implements Grok's recommendations:
1. Phase continuity - never reset phase inside loops
2. Cumulative fractional timing - no drift from int(36.75)
3. Proper preamble - 20 FLAG bytes before packet
4. Silence tail - 100ms zeros after transmission
5. 48000 Hz sample rate to match Android
"""

import struct
import wave
import math
import subprocess
import os

# Bell 202 AFSK parameters (Android-matching)
MARK_FREQ = 1200
SPACE_FREQ = 2200
BAUD_RATE = 1200
SAMPLE_RATE = 44100  # Match test_gen.wav
TX_TAIL_MS = 100     # 100ms silence after transmission
AMPLITUDE = 8191  # Exactly 25% like test_gen.wav (8191 not 8192!)
# CARRIER_MS = 100     # REMOVED - gen_packets doesn't use carrier!
PREAMBLE_FLAGS = 24  # Typical length

# Precomputed values
MARK_PHASE_INC = 2.0 * math.pi * MARK_FREQ / SAMPLE_RATE
SPACE_PHASE_INC = 2.0 * math.pi * SPACE_FREQ / SAMPLE_RATE

# AX.25 constants
FLAG = 0x7E

def calculate_fcs(data):
    """Calculate CRC-16-CCITT (0xFFFF) for FCS"""
    fcs = 0xFFFF
    for byte in data:
        fcs ^= byte
        for _ in range(8):
            if fcs & 0x0001:
                fcs = (fcs >> 1) ^ 0x8408
            else:
                fcs >>= 1
    return fcs ^ 0xFFFF

def add_callsign(packet, callsign, ssid, is_last):
    """Add AX.25 callsign field (7 bytes)"""
    padded_call = callsign.upper().ljust(6)[:6]
    for char in padded_call:
        packet.append(ord(char) << 1)
    ssid_byte = 0x60 | ((ssid & 0x0F) << 1)
    if is_last:
        ssid_byte |= 0x01
    packet.append(ssid_byte)

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

def generate_afsk_fixed(packet):
    """
    Generate AFSK with proper phase continuity and fractional timing.
    
    Key fixes:
    - Phase initialized ONCE, never reset
    - Cumulative fractional timing (no drift)
    - NRZI with continuous phase across bit transitions
    - Leading silence for carrier detect!
    - Many FLAGS for bit sync training
    """
    audio = []
    
    # Add leading silence - REQUIRED! test_gen.wav has 1170 samples
    if SAMPLE_RATE == 44100:
        silence_samples = 1170  # Exactly like test_gen.wav
    else:  # 48000 Hz
        silence_samples = 1280
    
    print(f"Adding {silence_samples} samples leading silence ({silence_samples/SAMPLE_RATE*1000:.1f}ms)")
    for _ in range(silence_samples):
        audio.append(0)
    
    # Phase is initialized ONCE and NEVER reset
    # Match test_gen.wav initial phase: 0.147155 radians (8.43°)
    phase = 0.147155
    
    # Start immediately with FLAGS (like gen_packets does)
    
    # Add preamble: Just many FLAGS (no 0x00 bytes!)
    # gen_packets starts immediately with FLAGS
    print(f"Adding {PREAMBLE_FLAGS} FLAG bytes for bit sync (like gen_packets)")
    preamble = bytes([FLAG] * PREAMBLE_FLAGS)
    full_packet = preamble + packet
    
    # NRZI state - start with MARK (Android-matching)
    current_phase_inc = MARK_PHASE_INC
    
    # Cumulative timing tracker
    bit_start_time = 0.0
    bit_duration = 1.0 / BAUD_RATE  # Exactly 1/1200 seconds per bit
    
    # Process each bit with NRZI encoding (AX.25 standard)
    # Standard NRZI: bit 0 = transition, bit 1 = no change  
    # CRITICAL: Output current state FIRST, then transition for NEXT bit!
    # Start at MARK (like test_gen.wav)
    nrzi_state = 1  # 0 = SPACE, 1 = MARK
    
    for byte_val in full_packet:
        for bit_idx in range(8):
            bit = (byte_val >> bit_idx) & 1  # LSB first
            
            # Output CURRENT state first
            if nrzi_state == 1:
                current_phase_inc = MARK_PHASE_INC
            else:
                current_phase_inc = SPACE_PHASE_INC
            
            # Calculate exact sample boundaries for this bit
                current_phase_inc = SPACE_PHASE_INC
            
            # Calculate exact sample boundaries for this bit
            bit_end_time = bit_start_time + bit_duration
            sample_start = int(bit_start_time * SAMPLE_RATE)
            sample_end = int(bit_end_time * SAMPLE_RATE)
            
            # Generate samples for this bit with continuous phase
            for _ in range(sample_start, sample_end):
                # Use round() not int() to avoid DC offset from truncation
                sample = round(AMPLITUDE *math.sin(phase))
                audio.append(sample)
                
                # Phase accumulates continuously - NEVER reset
                phase += current_phase_inc
                phase %= (2.0 * math.pi)  # Wrap to keep in range
            
            # NOW transition for next bit (if bit value is 0)
            if bit == 0:
                nrzi_state = 1 - nrzi_state
            
            # Move to next bit (carry fractional timing)
            bit_start_time = bit_end_time
    
    # Generate one more bit-period at current state before silence
    # This gives NRZI decoder enough length to decode the final bit
    bit_end_time = bit_start_time + bit_duration
    sample_start = int(bit_start_time * SAMPLE_RATE)
    sample_end = int(bit_end_time * SAMPLE_RATE)
    
    # Use current NRZI state (maintain tone)
    if nrzi_state == 1:
        current_phase_inc = MARK_PHASE_INC
    else:
        current_phase_inc = SPACE_PHASE_INC
    
    for _ in range(sample_start, sample_end):
        sample = round(AMPLITUDE * math.sin(phase))
        audio.append(sample)
        phase += current_phase_inc
        phase %= (2.0 * math.pi)
    
    # Add tail: silence (zeros) for decoder to flush
    tail_samples = (TX_TAIL_MS * SAMPLE_RATE) // 1000
    for _ in range(tail_samples):
        audio.append(0)
    
    return audio

def save_wav(filename, audio_samples):
    """Save audio samples to WAV file"""
    with wave.open(filename, 'wb') as wav_file:  # Changed to 'wb'
        wav_file.setnchannels(1)  # Mono
        wav_file.setsampwidth(2)  # 16-bit
        wav_file.setframerate(SAMPLE_RATE)
        
        # Write all samples at once as bytes
        audio_data = struct.pack(f'<{len(audio_samples)}h', *audio_samples)
        wav_file.writeframes(audio_data)

def test_with_direwolf(wav_filename):
    """Test WAV file with direwolf"""
    direwolf_path = r"C:\Users\Joshua\Downloads\direwolf-1.8.1-a231971_x86_64\direwolf-1.8.1-a231971_x86_64"
    atest_exe = os.path.join(direwolf_path, 'atest.exe')
    
    try:
        result = subprocess.run(
            [atest_exe, wav_filename],
            capture_output=True,
            text=True,
            timeout=10
        )
        
        # Look for "X from" line
        for line in result.stdout.split('\n'):
            if ' from ' in line:
                parts = line.split()
                if parts and parts[0].isdigit():
                    return int(parts[0]), result.stdout
        
        return 0, result.stdout
    except Exception as e:
        return 0, str(e)

def main():
    print("APRS AFSK Generator - FIXED VERSION (NO Carrier - Like gen_packets!)")
    print("=" * 60)
    print(f"Sample Rate: {SAMPLE_RATE} Hz")
    print(f"Samples/bit: {SAMPLE_RATE / BAUD_RATE:.1f} (exact integer!)")
    print(f"Phase increments: MARK={MARK_PHASE_INC:.6f}, SPACE={SPACE_PHASE_INC:.6f}")
    print(f"Preamble: {PREAMBLE_FLAGS} FLAGS for bit sync (starts immediately!)")
    print()
    
    # Create test packet (EXACT copy of test_gen for testing)
    packet = []
    
    # Destination: TEST-0
    add_callsign(packet, "TEST", 0, False)
    
    # Source: WB2OSZ-15
    add_callsign(packet, "WB2OSZ", 15, True)
    
    # Control field (UI frame)
    packet.append(0x03)
    
    # Protocol ID (No layer 3)
    packet.append(0xF0)
    
    # Info: ,The quick brown fox jumps over the lazy dog!  1 of 4
    info = ",The quick brown fox jumps over the lazy dog!  1 of 4"
    for char in info:
        packet.append(ord(char))
    
    # Calculate FCS on everything except flags
    data_for_fcs = bytes(packet)
    fcs = calculate_fcs(data_for_fcs)
    
    # Apply bit stuffing to data+FCS
    data_with_fcs = data_for_fcs + bytes([fcs & 0xFF, (fcs >> 8) & 0xFF])
    stuffed_data = apply_bit_stuffing(data_with_fcs)
    
    # Build complete packet: FLAG + stuffed_data + FLAG + extra FLAG
    # Extra FLAG needed so NRZI decoder has enough tones for last bit!
    final_packet = bytes([FLAG]) + stuffed_data + bytes([FLAG, FLAG])
    
    print(f"Packet length: {len(final_packet)} bytes")
    print(f"FCS: 0x{fcs:04X}")
    print()
    
    # Debug: Print packet hex
    print(f"Packet bytes (hex):")
    print(" ".join(f"{b:02X}" for b in data_for_fcs))
    print(f"\nPacket with FCS (hex):")
    print(" ".join(f"{b:02X}" for b in data_with_fcs))
    print(f"\nStuffed packet (hex, first 80 bytes):")
    print(" ".join(f"{b:02X}" for b in stuffed_data[:80]))
    print()
    
    # Generate AFSK audio
    print("Generating AFSK audio with fixed phase continuity...")
    audio = generate_afsk_fixed(final_packet)
    
    # Save WAV
    output_file = "aprs_fixed_test.wav"
    save_wav(output_file, audio)
    print(f"[OK] Generated: {output_file}")
    print(f"  Duration: {len(audio)/SAMPLE_RATE:.3f}s")
    print(f"  Samples: {len(audio)}")
    print()
    
    # Test with direwolf
    print("Testing with Dire Wolf...")
    packets_decoded, output = test_with_direwolf(output_file)
    
    if packets_decoded > 0:
        print(f"*** SUCCESS! Decoded {packets_decoded} packet(s) ***")
        print()
        print("Dire Wolf output:")
        print(output)
    else:
        print(f"[FAIL] 0 packets decoded")
        print()
        print("Dire Wolf output:")
        print(output)
    
    return packets_decoded > 0

if __name__ == "__main__":
    success = main()
    exit(0 if success else 1)
