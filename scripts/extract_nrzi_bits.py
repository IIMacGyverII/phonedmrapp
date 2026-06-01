"""
Extract NRZI-decoded bitstream from AFSK audio
Compare our output with Dire Wolf's gen_packets output
"""
import wave
import struct
import math

def read_wav(filename):
    """Read WAV file and return samples"""
    with wave.open(filename, 'rb') as wav:
        sample_rate = wav.getframerate()
        n_frames = wav.getnframes()
        audio_data = wav.readframes(n_frames)
        samples = struct.unpack(f'<{n_frames}h', audio_data)
    return samples, sample_rate

def detect_frequency(samples, sample_rate, start_idx, num_samples=40):
    """Detect if samples are MARK (1200 Hz) or SPACE (2200 Hz)"""
    # Find zero crossings
    crossings = []
    for i in range(start_idx, min(start_idx + num_samples - 1, len(samples) - 1)):
        if (samples[i] < 0 and samples[i+1] >= 0) or (samples[i] >= 0 and samples[i+1] < 0):
            crossings.append(i - start_idx)
    
    if len(crossings) < 2:
        # Not enough crossings - check amplitude to see if it's silence
        max_amp = max(abs(samples[i]) for i in range(start_idx, min(start_idx + num_samples, len(samples))))
        if max_amp < 100:
            return "SILENCE"
        # If amplitude is good but no crossings, might be DC offset issue
        return None
    
    # Calculate average period
    periods = [crossings[i+1] - crossings[i] for i in range(len(crossings)-1)]
    avg_period = sum(periods) / len(periods)
    
    # Calculate frequency
    freq = sample_rate / (2 * avg_period)
    
    # Classify as MARK or SPACE
    # Be more forgiving with thresholds
    if freq < 1650:  # Closer to 1200 Hz
        return "MARK"
    else:  # Closer to 2200 Hz
        return "SPACE"

def extract_nrzi_bits(filename, skip_silence=True):
    """Extract NRZI-encoded bits from audio file"""
    samples, sample_rate = read_wav(filename)
    
    # Calculate samples per bit
    baud_rate = 1200
    samples_per_bit = sample_rate / baud_rate
    
    print(f"File: {filename}")
    print(f"Sample rate: {sample_rate} Hz")
    print(f"Samples per bit: {samples_per_bit:.2f}")
    print(f"Total samples: {len(samples)}")
    
    # Skip leading silence if requested
    start_sample = 0
    if skip_silence:
        for i, s in enumerate(samples):
            if abs(s) > 100:  # Found non-silence
                start_sample = i
                break
        print(f"Signal starts at sample: {start_sample}")
    
    # Extract tone per bit period
    tones = []
    bit_num = 0
    sample_idx = start_sample
    silence_count = 0
    none_count = 0
    
    while sample_idx < len(samples) - samples_per_bit:
        # Detect frequency for this bit period
        tone = detect_frequency(samples, sample_rate, int(sample_idx), int(samples_per_bit))
        if tone is None:
            # Skip this bit if can't detect
            none_count += 1
            sample_idx += samples_per_bit
            continue
        if tone == "SILENCE":
            # Skip silence
            silence_count += 1
            sample_idx += samples_per_bit
            continue
        
        tones.append(tone)
        sample_idx += samples_per_bit
        bit_num += 1
        
        if bit_num >= 500:  # Limit to first 500 bits
            break
    
    print(f"Extracted {len(tones)} tones (skipped {silence_count} silence, {none_count} undetectable)")
    
    # Decode NRZI: MARK/SPACE sequence -> data bits
    # NRZI: transition = 0, no transition = 1
    bits = []
    prev_tone = tones[0] if tones else None
    
    for tone in tones[1:]:  # Start from second tone
        if tone == prev_tone:
            bits.append(1)  # No transition = 1
        else:
            bits.append(0)  # Transition = 0
        prev_tone = tone
    
    print(f"Decoded {len(bits)} NRZI bits")
    
    return tones, bits

def bits_to_bytes(bits):
    """Convert bit array to bytes (LSB first)"""
    bytes_out = []
    for i in range(0, len(bits) - 7, 8):
        byte_val = 0
        for j in range(8):
            if bits[i + j]:
                byte_val |= (1 << j)
        bytes_out.append(byte_val)
    return bytes_out

def compare_files(file1, file2):
    """Compare NRZI bitstreams from two files"""
    print("=" * 70)
    print("EXTRACTING FILE 1")
    print("=" * 70)
    tones1, bits1 = extract_nrzi_bits(file1)
    
    print("\n" + "=" * 70)
    print("EXTRACTING FILE 2")
    print("=" * 70)
    tones2, bits2 = extract_nrzi_bits(file2)
    
    print("\n" + "=" * 70)
    print("COMPARISON")
    print("=" * 70)
    
    # Compare tones
    print(f"\nFirst 50 tones comparison:")
    print(f"File 1: {' '.join(t[0] for t in tones1[:50])}")
    print(f"File 2: {' '.join(t[0] for t in tones2[:50])}")
    
    # Compare bits
    print(f"\nFirst 80 bits comparison:")
    print(f"File 1: {''.join(str(b) for b in bits1[:80])}")
    print(f"File 2: {''.join(str(b) for b in bits2[:80])}")
    
    # Find first difference
    min_len = min(len(bits1), len(bits2))
    first_diff = None
    for i in range(min_len):
        if bits1[i] != bits2[i]:
            first_diff = i
            break
    
    if first_diff is not None:
        print(f"\n⚠ First bit difference at position {first_diff}")
        print(f"File 1 bits[{first_diff-5}:{first_diff+10}]: {''.join(str(b) for b in bits1[first_diff-5:first_diff+10])}")
        print(f"File 2 bits[{first_diff-5}:{first_diff+10}]: {''.join(str(b) for b in bits2[first_diff-5:first_diff+10])}")
    else:
        print(f"\n✓ All bits match (up to {min_len} bits)")
    
    # Convert to bytes and compare
    bytes1 = bits_to_bytes(bits1[:160])  # First 20 bytes
    bytes2 = bits_to_bytes(bits2[:160])
    
    print(f"\nFirst 20 bytes (hex):")
    print(f"File 1: {' '.join(f'{b:02X}' for b in bytes1)}")
    print(f"File 2: {' '.join(f'{b:02X}' for b in bytes2)}")

# Test with our file vs gen_packets
our_file = "C:\\Users\\Joshua\\Documents\\android\\phonedmrapp\\aprs_fixed_test.wav"
ref_file = "C:\\Users\\Joshua\\Downloads\\direwolf-1.8.1-a231971_x86_64\\direwolf-1.8.1-a231971_x86_64\\test_gen.wav"

compare_files(our_file, ref_file)
