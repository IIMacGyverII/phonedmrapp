import wave
import struct
import sys

def test_goertzel(wav_file):
    """Test Goertzel demodulation and show first decoded bits"""
    
    w = wave.open(wav_file, 'rb')
    sample_rate = w.getframerate()
    n_frames = w.getnframes()
    
    print(f"File: {wav_file}")
    print(f"Sample rate: {sample_rate} Hz")
    print(f"Frames: {n_frames}")
    print()
    
    # Read all samples
    audio_data = w.readframes(n_frames)
    samples = struct.unpack(f'<{n_frames}h', audio_data)
    w.close()
    
    # Goertzel parameters (same as AFSKDecoder.java)
    MARK_FREQ = 1200
    SPACE_FREQ = 2200
    BAUD = 1200
    SAMPLES_PER_BIT = sample_rate / BAUD
    
    import math
    MARK_COEFF = 2.0 * math.cos(2.0 * math.pi * MARK_FREQ / sample_rate)
    SPACE_COEFF = 2.0 * math.cos(2.0 * math.pi * SPACE_FREQ / sample_rate)
    
    print(f"Goertzel coefficients:")
    print(f"  MARK_COEFF ({MARK_FREQ} Hz): {MARK_COEFF}")
    print(f"  SPACE_COEFF ({SPACE_FREQ} Hz): {SPACE_COEFF}")
    print(f"  SAMPLES_PER_BIT: {SAMPLES_PER_BIT}")
    print()
    
    bits = []
    sample_index = 0
    
    # Process in chunks (like AFSKDecoder.java)
    while sample_index +int(SAMPLES_PER_BIT) <= len(samples):
        q0_mark = q1_mark = q2_mark = 0.0
        q0_space = q1_space = q2_space = 0.0
        
        # Process SAMPLES_PER_BIT samples
        for i in range(int(SAMPLES_PER_BIT)):
            if sample_index + i >= len(samples):
                break
            sample = samples[sample_index + i] / 32768.0
            
            # Mark filter
            q0_mark = MARK_COEFF * q1_mark - q2_mark + sample
            q2_mark = q1_mark
            q1_mark = q0_mark
            
            # Space filter
            q0_space = SPACE_COEFF * q1_space - q2_space + sample
            q2_space = q1_space
            q1_space = q0_space
        
        # Calculate power
        mark_power = q1_mark * q1_mark + q2_mark * q2_mark - q1_mark * q2_mark * MARK_COEFF
        space_power = q1_space * q1_space + q2_space * q2_space - q1_space * q2_space * SPACE_COEFF
        
        # Bit decision (mark > space = 1)
        bit = 1 if mark_power > space_power else 0
        bits.append(bit)
        
        sample_index += int(SAMPLES_PER_BIT)
        
        # Show first 200 bits
        if len(bits) <= 200:
            if len(bits) % 50 == 0:
                print(f"\nBit {len(bits):3d}: mark={mark_power:8.3f} space={space_power:8.3f} -> {bit}")
    
    print(f"\nTotal bits decoded: {len(bits)}")
    print(f"\nFirst 100 bits (raw):")
    print(''.join(str(b) for b in bits[:100]))
    
    # NRZI decode
    nrzi_decoded = []
    prev_state = 1  # Start with mark
    for bit in bits:
        # NRZI: transition = 0, no transition = 1
        if bit == prev_state:
            nrzi_decoded.append(1)  # No transition
        else:
            nrzi_decoded.append(0)  # Transition
        prev_state = bit
    
    print(f"\nFirst 100 bits (after NRZI decode):")
    print(''.join(str(b) for b in nrzi_decoded[:100]))
    
    # Look for FLAG pattern (01111110 = 0x7E)
    flag_pattern = '01111110'
    bit_string = ''.join(str(b) for b in bits)
    flag_count = bit_string.count(flag_pattern)
    print(f"\nFLAG patterns in raw bits: {flag_count}")
    
    nrzi_string = ''.join(str(b) for b in nrzi_decoded)
    nrzi_flag_count = nrzi_string.count(flag_pattern)
    print(f"FLAG patterns after NRZI decode: {nrzi_flag_count}")
    
    if nrzi_flag_count > 0:
        first_flag = nrzi_string.find(flag_pattern)
        print(f"\nFirst FLAG at bit {first_flag}")
        print(f"Bits around first FLAG:")
        start = max(0, first_flag - 20)
        end = min(len(nrzi_string), first_flag + 150)
        print(nrzi_string[start:end])

if __name__ == '__main__':
    if len(sys.argv) > 1:
        test_goertzel(sys.argv[1])
    else:
        print("Usage: python test_goertzel.py <wav_file>")
