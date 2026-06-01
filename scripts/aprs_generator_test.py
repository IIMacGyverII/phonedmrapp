#!/usr/bin/env python3
"""
APRS AFSK Audio Generator Test Script
Generates APRS packets with AFSK modulation and tests with direwolf
"""

import struct
import wave
import math
import subprocess
import os

# Bell 202 AFSK parameters (matching Android implementation)
MARK_FREQ = 1200    # 1200 Hz for binary 1
SPACE_FREQ = 2200   # 2200 Hz for binary 0
BAUD_RATE = 1200    # 1200 bits per second
SAMPLE_RATE = 44100 # 44100 Hz sample rate
TX_DELAY_MS = 0     # No delay - flags provide sync (ANDROID MATCH)
TX_TAIL_MS = 100    # Post-transmission delay
AMPLITUDE = int(32767 * 0.8)  # 80% amplitude (ANDROID MATCH)

# Precomputed values
SAMPLES_PER_BIT = SAMPLE_RATE / BAUD_RATE
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
    # Pad/truncate callsign to 6 characters
    padded_call = callsign.upper().ljust(6)[:6]
    
    # Each character shifted left by 1
    for char in padded_call:
        packet.append(ord(char) << 1)
    
    # SSID byte
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

def encode_aprs_packet(source_call, source_ssid, dest_call, dest_ssid, 
                       path1_call, path1_ssid, path2_call, path2_ssid,
                       lat, lon, altitude, comment):
    """Encode APRS position packet"""
    packet = []
    
    # Add 8 preamble flags for synchronization
    for _ in range(8):
        packet.append(FLAG)
    
    # Destination address (APZDMR)
    add_callsign(packet, dest_call, dest_ssid, False)
    
    # Source address
    add_callsign(packet, source_call, source_ssid, False)
    
    # Path 1 (WIDE1-1)
    add_callsign(packet, path1_call, path1_ssid, False)
    
    # Path 2 (WIDE2-1)
    add_callsign(packet, path2_call, path2_ssid, True)
    
    # Control field (UI frame)
    packet.append(0x03)
    
    # Protocol ID (No layer 3)
    packet.append(0xF0)
    
    # Information field (position report)
    lat_deg = int(abs(lat))
    lat_min = (abs(lat) - lat_deg) * 60.0
    lat_ns = 'N' if lat >= 0 else 'S'
    
    lon_deg = int(abs(lon))
    lon_min = (abs(lon) - lon_deg) * 60.0
    lon_ew = 'E' if lon >= 0 else 'W'
    
    # Format: !DDMM.MMN/DDDMM.MMW-/A=xxxxxx
    info = f"!{lat_deg:02d}{lat_min:05.2f}{lat_ns}/{lon_deg:03d}{lon_min:05.2f}{lon_ew}-/A={altitude:06d}"
    if comment:
        info += comment
    
    for char in info:
        packet.append(ord(char))
    
    # Calculate FCS on everything except preamble flags
    data_for_fcs = bytes(packet[8:])
    fcs = calculate_fcs(data_for_fcs)
    packet.append(fcs & 0xFF)
    packet.append((fcs >> 8) & 0xFF)
    
    # Add closing flag
    packet.append(FLAG)
    
    # For now, skip bit stuffing to test basic packet structure
    result = bytes(packet)
    
    return result

def generate_afsk_nrzi(packet, use_nrzi=True, invert_nrzi=False, msb_first=False):
    """Generate AFSK audio with optional NRZI encoding"""
    num_bits = len(packet) * 8
    num_samples = int(num_bits * SAMPLES_PER_BIT)
    
    delay_samples = (TX_DELAY_MS * SAMPLE_RATE) // 1000
    tail_samples = (TX_TAIL_MS * SAMPLE_RATE) // 1000
    total_samples = delay_samples + num_samples + tail_samples
    
    audio = []
    phase = 0.0
    
    # TX delay - MARK tone (matches Android)
    for _ in range(delay_samples):
        audio.append(int(math.sin(phase) * AMPLITUDE))
        phase += MARK_PHASE_INC
        while phase >= 2.0 * math.pi:
            phase -= 2.0 * math.pi
    
    if use_nrzi:
        # NRZI encoding - start with MARK (matches Android)
        current_freq = MARK_FREQ
        current_phase_inc = MARK_PHASE_INC
        
        # Phase continues from preamble
        # phase already set from preamble
        
        bit_counter = 0
        sample_time = 0.0  # Track exact sample time
        
        for byte_idx, byte_val in enumerate(packet):
            for bit_idx in range(8):
                if msb_first:
                    bit = (byte_val >> (7 - bit_idx)) & 1
                else:
                    bit = (byte_val >> bit_idx) & 1
                
                # NRZI: 0 = toggle, 1 = no change (or inverted)
                if invert_nrzi:
                    toggle = (bit == 1)
                else:
                    toggle = (bit == 0)
                
                if toggle:
                    if current_freq == MARK_FREQ:
                        current_freq = SPACE_FREQ
                        current_phase_inc = SPACE_PHASE_INC
                    else:
                        current_freq = MARK_FREQ
                        current_phase_inc = MARK_PHASE_INC
                
                bit_counter += 1
                
                # Generate samples for this bit using exact timing
                bit_end_time = bit_counter / BAUD_RATE
                bit_end_sample = int(bit_end_time * SAMPLE_RATE + 0.5)
                
                while len(audio) - delay_samples < bit_end_sample:
                    audio.append(int(math.sin(phase) * AMPLITUDE))
                    phase += current_phase_inc
                    while phase >= 2.0 * math.pi:
                        phase -= 2.0 * math.pi
    else:
        # Direct FSK (1=mark, 0=space, no NRZI)
        bit_counter = 0
        
        for byte_val in packet:
            for bit_idx in range(8):
                if msb_first:
                    bit = (byte_val >> (7 - bit_idx)) & 1
                else:
                    bit = (byte_val >> bit_idx) & 1
                phase_inc = MARK_PHASE_INC if bit else SPACE_PHASE_INC
                
                bit_counter += 1
                
                # Generate samples using exact timing
                bit_end_time = bit_counter / BAUD_RATE
                bit_end_sample = int(bit_end_time * SAMPLE_RATE + 0.5)
                
                while len(audio) - delay_samples < bit_end_sample:
                    audio.append(int(math.sin(phase) * AMPLITUDE))
                    phase += phase_inc
                    while phase >= 2.0 * math.pi:
                        phase -= 2.0 * math.pi
    
    # TX tail - MARK tone (matches Android)
    for _ in range(tail_samples):
        audio.append(int(math.sin(phase) * AMPLITUDE))
        phase += MARK_PHASE_INC
        while phase >= 2.0 * math.pi:
            phase -= 2.0 * math.pi
    
    return audio

def save_wav(filename, audio_samples):
    """Save audio samples to WAV file"""
    with wave.open(filename, 'w') as wav_file:
        wav_file.setnchannels(1)  # Mono
        wav_file.setsampwidth(2)  # 16-bit
        wav_file.setframerate(SAMPLE_RATE)
        
        # Pack samples as 16-bit signed integers
        for sample in audio_samples:
            wav_file.writeframes(struct.pack('<h', sample))

def test_with_direwolf(wav_filename, direwolf_path):
    """Test WAV file with direwolf"""
    atest_exe = os.path.join(direwolf_path, 'atest.exe')
    
    try:
        result = subprocess.run(
            [atest_exe, wav_filename],
            capture_output=True,
            text=True,
            timeout=10
        )
        
        # Look for "X from" line to see how many packets decoded
        for line in result.stdout.split('\n'):
            if ' from ' in line:
                parts = line.split()
                if parts and parts[0].isdigit():
                    return int(parts[0]), result.stdout
        
        return 0, result.stdout
    except Exception as e:
        return 0, str(e)

def main():
    """Main test function"""
    print("APRS AFSK Generator Test Script")
    print("=" * 60)
    
    # Known-good packet from Grok (APZDMR-0>EXAMPLE-9 position beacon)
    # This is a real APRS packet structure before NRZI/AFSK
    KNOWN_GOOD_DATA = bytes([
        # Destination: APZDMR-0
        0x82, 0xA0, 0x84, 0x9A, 0x84, 0x62, 0x60,
        # Source: EXAMPLE-9
        0x9E, 0x9A, 0x68, 0x84, 0x62, 0x40, 0x63,
        0x03,  # Control
        0xF0,  # PID
        # Info: !07334.50N/01234.50W-Hello world!
        0x21, 0x30, 0x37, 0x33, 0x34, 0x2E, 0x35, 0x30, 0x4E, 0x2F,
        0x30, 0x31, 0x32, 0x33, 0x34, 0x2E, 0x35, 0x30, 0x57, 0x2D,
        0x48, 0x65, 0x6C, 0x6C, 0x6F, 0x20, 0x77, 0x6F, 0x72, 0x6C, 0x64, 0x21,
    ])
    
    # Calculate correct FCS for known-good packet
    correct_fcs = calculate_fcs(KNOWN_GOOD_DATA)
    
    # Add FCS to data
    data_with_fcs = KNOWN_GOOD_DATA + bytes([
        correct_fcs & 0xFF,
        (correct_fcs >> 8) & 0xFF
    ])
    
    # Apply bit stuffing to data+FCS
    stuffed_data = apply_bit_stuffing(data_with_fcs)
    
    # Build complete packet: FLAG + stuffed_data + FLAG
    KNOWN_GOOD_PACKET = bytes([0x7E]) + stuffed_data + bytes([0x7E])
    
    print("\n>>> TESTING KNOWN-GOOD PACKET FROM GROK <<<")
    print(f"Packet length: {len(KNOWN_GOOD_PACKET)} bytes")
    print(f"Calculated FCS: 0x{correct_fcs:04X}")
    print(f"Packet: {' '.join(f'{b:02X}' for b in KNOWN_GOOD_PACKET)}")
    
    # Direwolf path
    direwolf_path = r"C:\Users\Joshua\Downloads\direwolf-1.8.1-a231971_x86_64\direwolf-1.8.1-a231971_x86_64"
    output_dir = r"C:\Users\Joshua\Documents\android\phonedmrapp\aprs_debug\aprs_debug"
    
    # Test configuration
    test_cases = [
        ("Standard NRZI LSB", True, False, False),
        ("Standard NRZI MSB", True, False, True),
        ("Inverted NRZI LSB", True, True, False),
        ("Inverted NRZI MSB", True, True, True),
        ("Direct FSK LSB", False, False, False),
        ("Direct FSK MSB", False, False, True),
    ]
    
    # Test known-good packet from Grok first
    print("\n" + "=" * 60)
    print("Testing known-good packet...")
    print("=" * 60)
    for test_name, use_nrzi, invert_nrzi, msb_first in test_cases:
        print(f"\n[{test_name}] - Known-good")
        
        audio = generate_afsk_nrzi(KNOWN_GOOD_PACKET, use_nrzi, invert_nrzi, msb_first)
        wav_filename = os.path.join(output_dir, f"known_good_{test_name.replace(' ', '_')}.wav")
        save_wav(wav_filename, audio)
        print(f"  Generated: {os.path.basename(wav_filename)}")
        
        packets_decoded, output = test_with_direwolf(wav_filename, direwolf_path)
        if packets_decoded > 0:
            print(f"  ✓ SUCCESS! Decoded {packets_decoded} packet(s)")
            print("\nDirewolf output:")
            print(output)
            print("\n" + "=" * 60)
            print(f"WORKING CONFIGURATION: {test_name}")
            print("=" * 60)
            return True
        else:
            print(f"  ✗ Failed: 0 packets decoded")
    
    print("\n" + "=" * 60)
    print("Known-good packet failed - issue is in AFSK waveform generation")
    print("=" * 60)
    return False
    
    # APRS packet parameters (matching Android app)
    source_call = "AA0AM"
    source_ssid = 7
    dest_call = "APZDMR"
    dest_ssid = 0
    path1_call = "WIDE1"
    path1_ssid = 1
    path2_call = "WIDE2"
    path2_ssid = 1
    lat = 45.2225
    lon = -93.6733
    altitude = 268
    comment = ""
    
    # Encode packet once
    print("\nEncoding APRS packet...")
    packet = encode_aprs_packet(
        source_call, source_ssid, dest_call, dest_ssid,
        path1_call, path1_ssid, path2_call, path2_ssid,
        lat, lon, altitude, comment
    )
    
    print(f"Packet length: {len(packet)} bytes")
    print(f"Full packet: {' '.join(f'{b:02X}' for b in packet)}")
    
    # Also test with just flags to ensure basic tone generation works
    print("\n\nTesting minimal packet (just flags)...")
    minimal_packet = bytes([0x7E] * 20)
    print(f"Minimal packet: {' '.join(f'{b:02X}' for b in minimal_packet)}")
    
    # Direwolf path
    direwolf_path = r"C:\Users\Joshua\Downloads\direwolf-1.8.1-a231971_x86_64\direwolf-1.8.1-a231971_x86_64"
    output_dir = r"C:\Users\Joshua\Documents\android\phonedmrapp\aprs_debug\aprs_debug"
    
    print("\n" + "=" * 60)
    print("Testing different encoding methods...")
    print("=" * 60)
    
    # First test minimal packet
    print("\n>>> TESTING MINIMAL PACKET (flags only) <<<")
    for test_name, use_nrzi, invert_nrzi, msb_first in test_cases:
        print(f"\n[{test_name}] - Minimal")
        
        audio = generate_afsk_nrzi(minimal_packet, use_nrzi, invert_nrzi, msb_first)
        wav_filename = os.path.join(output_dir, f"test_minimal_{test_name.replace(' ', '_').replace('(', '').replace(')', '')}.wav")
        save_wav(wav_filename, audio)
        print(f"  Generated: {os.path.basename(wav_filename)}")
        
        packets_decoded, output = test_with_direwolf(wav_filename, direwolf_path)
        if packets_decoded > 0:
            print(f"  ✓ SUCCESS! Decoded {packets_decoded} packet(s)")
            print("\nDirewolf output:")
            print(output)
            return True
        else:
            print(f"  ✗ Failed: 0 packets decoded")
    
    # Then test full packet
    print("\n>>> TESTING FULL APRS PACKET <<<")
    for test_name, use_nrzi, invert_nrzi, msb_first in test_cases:
        print(f"\n[{test_name}]")
        
        # Generate audio
        audio = generate_afsk_nrzi(packet, use_nrzi, invert_nrzi, msb_first)
        
        # Save WAV
        wav_filename = os.path.join(output_dir, f"test_{test_name.replace(' ', '_').replace('(', '').replace(')', '')}.wav")
        save_wav(wav_filename, audio)
        print(f"  Generated: {wav_filename}")
        print(f"  Audio length: {len(audio)} samples ({len(audio)/SAMPLE_RATE:.2f}s)")
        
        # Test with direwolf
        packets_decoded, output = test_with_direwolf(wav_filename, direwolf_path)
        
        if packets_decoded > 0:
            print(f"  ✓ SUCCESS! Decoded {packets_decoded} packet(s)")
            print("\nDirewolf output:")
            print(output)
            return True
        else:
            print(f"  ✗ Failed: 0 packets decoded")
    
    print("\n" + "=" * 60)
    print("All test cases failed. Need to investigate further.")
    print("=" * 60)
    
    return False

if __name__ == "__main__":
    main()
