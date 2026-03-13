# APRS AFSK Audio Generation - Continued Debugging Session
**Date**: March 10, 2026  
**Phase**: 17 - Exhaustive Encoding Tests  
**Status**: ❌ BLOCKED - All encoding methods fail despite correct audio

## Session Summary

Continued from Phase 16 where we discovered our audio produces SPACE (2200 Hz) when it should produce MARK (1200 Hz). This session revealed a **massive discovery**: our audio is actually CORRECT, but Dire Wolf still decodes 0 packets with ALL encoding methods tested.

## Critical Discovery: Audio Is Actually Correct!

### Verification via `analyze_our_audio.py`
Analyzed our generated `test_flags_only.wav` bit-by-bit:

```
Bit 0 (samples   0-40): crossings=[11, 22, 33], avg_freq=2181.8 Hz, detected=SPACE, expected=SPACE ✓
Bit 1 (samples  40-80): crossings=[7, 27], avg_freq=1200.0 Hz, detected=MARK , expected=MARK  ✓
Bit 2 (samples  80-120): crossings=[7, 27], avg_freq=1200.0 Hz, detected=MARK , expected=MARK  ✓
Bit 3 (samples 120-160): crossings=[7, 27], avg_freq=1200.0 Hz, detected=MARK , expected=MARK  ✓
Bit 4 (samples 160-200): crossings=[7, 27], avg_freq=1200.0 Hz, detected=MARK , expected=MARK  ✓
Bit 5 (samples 200-240): crossings=[7, 27], avg_freq=1200.0 Hz, detected=MARK , expected=MARK  ✓
Bit 6 (samples 240-280): crossings=[7, 27], avg_freq=1200.0 Hz, detected=MARK , expected=MARK  ✓
Bit 7 (samples 280-320): crossings=[4, 15, 26, 37], avg_freq=2181.8 Hz, detected=SPACE, expected=SPACE ✓
```

**ALL BITS MATCH EXPECTED FREQUENCIES!**

For 0x7E FLAG (LSB-first: 01111110):
- Bit 0: SPACE ✓
- Bits 1-6: MARK (six consecutive 1s) ✓
- Bit 7: SPACE ✓

The previous "inversion" was a misunderstanding - we were looking at the wrong samples (during the transition period between frequencies).

## Configuration Matching Dire Wolf Reference

After extensive testing, matched ALL parameters to Dire Wolf's `gen_packets`:

| Parameter | Dire Wolf Reference | Our Generator | Status |
|-----------|-------------------|---------------|--------|
| Sample Rate | 44100 Hz | 44100 Hz | ✅ Match |
| Mark Freq | 1200 Hz | 1200 Hz | ✅ Match |
| Space Freq | 2200 Hz | 2200 Hz | ✅ Match |
| Amplitude | 25% (8191) | 25% (8191) | ✅ Match |
| Lead-in Silence | 1170 samples (27ms) | 1170 samples | ✅ Match |
| Tail Silence | ~4410 samples (100ms) | 4410 samples | ✅ Match |
| Phase Continuity | Continuous | Continuous | ✅ Match |
| Cumulative Timing | Yes | Yes | ✅ Match |

### Amplitude Verification
```
Reference max amplitude: 8191
Reference % of max: 25.0%
Our max amplitude: 8191
Our % of max: 25.0%
```

## Exhaustive Encoding Tests

Created `test_all_encodings.py` to test every possible encoding method:

### Test Results (ALL FAILED)

1. **Direct FSK (bit 1=MARK, 0=SPACE)**: ❌ 0 packets
2. **Direct FSK Inverted (bit 0=MARK, 1=SPACE)**: ❌ 0 packets  
3. **NRZI (bit 0=transition, 1=no change)**: ❌ 0 packets
4. **NRZI Inverted (bit 1=transition, 0=no change)**: ❌ 0 packets

Also tested with both initial states:
- Starting at MARK: ❌ Failed
- Starting at SPACE: ❌ Failed

**All 8 combinations (4 encodings × 2 initial states) fail to decode!**

## Packet Structure Analysis

### Full APRS Packet Test
Tested with complete valid APRS packet structure:

```
Destination: APZDMR-0
Source: EXAM-9
Control: 0x03 (UI frame)
PID: 0xF0 (No layer 3)
Info: !3734.50N/12334.50W-Hello
FCS: 0xC57C (calculated correctly)
```

**Packet bytes (hex)**:
```
82 A0 B4 88 9A A4 60 8A B0 82 9A 40 40 73 03 F0 21 33 37 33 34 2E 35 30 4E 2F 31
32 33 33 34 2E 35 30 57 2D 48 65 6C 6C 6F 7C C5
```

**With bit stuffing applied (first 80 bytes)**:
```
82 A0 B4 88 9A A4 60 8A B0 82 9A 40 40 73 03 F0 41 66 6E 66 68 5C 6A 60 9C 5E 62
64 66 66 68 5C 6A 60 AE 5A 90 CA D8 D8 DE F8 14 03
```

Frame structure: `FLAG (0x7E) + preamble (20 FLAGS) + stuffed_data + FLAG (0x7E)`

Result: **0 packets decoded**

### Pure FLAGS Test
Also tested with simplest possible case (30 consecutive FLAG bytes):
```python
test_data = bytes([0x7E] * 30)
```

Result: **0 packets decoded**

## Bit Stuffing Verification

Tested bit stuffing implementation with `test_bit_stuffing.py`:

```
Test 1: 0xAA (10101010) → AA (no stuffing needed) ✅
Test 2: 0x1F (11111000) → 1F00 (stuffed 0 after five 1s) ✅
Test 3: 0x7E (FLAG) → BE00 (correctly stuffed) ✅
Test 4: 0xFF 0xFF → DFF705 (multiple stuffed 0s) ✅
```

Bit stuffing is working correctly.

## What's Working vs What's Not

### ✅ Confirmed Working
1. **Audio waveform generation**
   - Clean sine waves
   - Correct 1200 Hz (MARK) tone
   - Correct 2200 Hz (SPACE) tone
   - Smooth transitions between frequencies

2. **Phase continuity**
   - Phase initialized once
   - Never reset during generation
   - Accumulates continuously across all bits

3. **Timing accuracy**
   - Cumulative fractional timing (no drift)
   - At 44100 Hz: 36.75 samples/bit (handled correctly)
   - Bit boundaries calculated precisely

4. **Packet structure**
   - AX.25 addresses encoded correctly (shifted callsigns)
   - FCS calculated correctly
   - Bit stuffing applied correctly
   - FLAGS added outside stuffed region

5. **Audio file format**
   - Valid WAV format
   - 16-bit signed PCM
   - Mono channel
   - Correct sample rate

### ❌ Still Failing
- **Dire Wolf decodes 0 packets** with ALL configurations
- Every encoding method fails (Direct FSK, NRZI, both inverted)
- Both initial states fail (MARK and SPACE)
- Both simple (FLAGS only) and complex (full packet) tests fail
- Reference audio generated by Dire Wolf's `gen_packets` works perfectly

## The Paradox

**Our audio is demonstrably correct:**
- Zero-crossing analysis confirms correct frequencies per bit
- Waveform structure matches expected pattern for 0x7E (SPACE, 6×MARK, SPACE)
- All parameters match Dire Wolf reference exactly
- Phase continuity and timing are mathematically correct

**Yet Dire Wolf won't decode it:**
- Dire Wolf accepts and decodes its own generated audio
- Dire Wolf rejects our audio with identical parameters
- No difference in sample rate, amplitude, frequencies, or timing
- No errors reported - just silently decodes 0 packets

## Dire Wolf Output (Typical)

```
44100 samples per second.  16 bits per sample.  1 audio channels.
49968 audio bytes in file.  Duration = 0.6 seconds.
Fix Bits level = 0
Channel 0: 1200 baud, AFSK 1200 & 2200 Hz, A, 44100 sample rate, Tx AX.25.

0 from aprs_fixed_test.wav
0 packets decoded in 0.017 seconds.  34.2 x realtime
```

No errors, just 0 packets decoded.

## Hypotheses for Failure

### 1. Timing Synchronization Issue
Dire Wolf may need specific timing markers we're not providing:
- Preamble duration (we have 20 FLAGS, ~167ms)
- Lead-in silence duration (we have 27ms)
- Specific phase alignment at start of packet

### 2. Bit Alignment Problem
Our bit stuffing or byte-to-bit conversion may be subtly wrong:
- LSB-first vs MSB-first confusion
- Off-by-one in bit positions
- Incorrect stuffed bit placement

### 3. NRZI State Tracking
NRZI encoding may require specific handling we're missing:
- Should we maintain state across FLAG bytes?
- Do FLAGS reset NRZI state?
- Is there an "idle" state between packets?

### 4. Waveform Artifact
Something subtle in our waveform generation that frequency analysis doesn't catch:
- Phase discontinuities too small to see in zero-crossing analysis
- Harmonic content different from Dire Wolf
- DC offset or other artifact

### 5. Dire Wolf Decoder Quirk
Dire Wolf may have specific requirements not documented:
- Expects specific Manchester encoding variant
- Requires exact phase at specific points
- Has undocumented sensitivity to something

## Files Created/Modified This Session

### Analysis Scripts
- `analyze_our_audio.py` - Bit-by-bit frequency analysis of our output
- `verify_phase_increments.py` - Mathematical verification of phase calculations
- `test_all_encodings.py` - Test all encoding method combinations
- `check_amplitude.py` - Compare amplitude with reference
- `compare_samples_detail.py` - Sample-by-sample waveform comparison

### Test Scripts
- `test_minimal_flags.py` - Pure FLAGS test (updated with lead-in, 44100 Hz)
- `test_bit_stuffing.py` - Verify bit stuffing implementation (fixed syntax error)
- `aprs_generator_fixed.py` - Main generator (updated to match Dire Wolf exactly)

### Test Audio Files
- `test_flags_only.wav` - 30 FLAGS with 44100 Hz, 25% amplitude
- `test_direct.wav` - Direct FSK encoding test
- `test_direct_inverted.wav` - Inverted Direct FSK test
- `test_nrzi.wav` - Standard NRZI test
- `test_nrzi_inverted.wav` - Inverted NRZI test
- `aprs_fixed_test.wav` - Full packet with all parameters matched

## Next Steps to Try

### Immediate (High Priority)
1. **Byte-by-byte comparison with Dire Wolf reference**
   - Extract actual decoded bytes from both audio files
   - Compare at bit level after NRZI decoding
   - Identify exact point where they diverge

2. **Test with different APRS decoder**
   - Try multimon-ng or direwolf in real-time mode
   - See if problem is specific to atest tool
   - Check if live decoder behaves differently

3. **Examine Dire Wolf source code**
   - Look at hdlc_rec.c (HDLC/AX.25 decoder)
   - Check demod_afsk.c (AFSK demodulator)
   - Find exact requirements for valid packets

4. **Generate with different tool**
   - Try soundmodem or other APRS audio generator
   - Compare their output with ours
   - See if they work with Dire Wolf

### Investigation (Medium Priority)
5. **Add verbose debugging to generator**
   - Log every bit decision
   - Track NRZI state through entire packet
   - Verify no unexpected state changes

6. **Test with Dire Wolf config file**
   - Try running full direwolf (not just atest)
   - Check if different demodulator settings help
   - Test with different filter options

7. **Compare spectrograms**
   - Visual frequency analysis over time
   - Look for patterns we're missing
   - Check for unexpected frequency content

8. **Test individual components**
   - Generate raw bitstream (no AFSK)
   - Verify NRZI encoding separately
   - Test bit stuffing output against known-good

### Research (Lower Priority)
9. **Ask Dire Wolf community**
   - Post on Dire Wolf GitHub issues
   - Ask on APRS-related forums
   - See if anyone has seen this before

10. **Try older Dire Wolf version**
    - Maybe newer version has stricter requirements
    - Test with version 1.5 or earlier
    - Check release notes for decoding changes

## Key Code Sections

### Current NRZI Implementation (Latest Test)
```python
# Start at SPACE
nrzi_state = 0  # 0 = SPACE, 1 = MARK

for byte_val in full_packet:
    for bit_idx in range(8):
        bit = (byte_val >> bit_idx) & 1  # LSB first
        
        # Inverted NRZI: bit 1 causes transition
        if bit == 1:
            nrzi_state = 1 - nrzi_state  # Toggle
        
        # Select frequency based on NRZI state
        if nrzi_state == 1:
            current_phase_inc = MARK_PHASE_INC  # 0.170971
        else:
            current_phase_inc = SPACE_PHASE_INC # 0.313447
```

### Phase Continuity (Correct)
```python
phase = 0.0  # Initialize ONCE

for _ in range(sample_start, sample_end):
    sample = int(AMPLITUDE * math.sin(phase))
    audio.append(sample)
    phase += current_phase_inc  # Never reset!
    phase %= (2.0 * math.pi)
```

### Cumulative Timing (Correct)
```python
bit_start_time = 0.0
bit_duration = 1.0 / BAUD_RATE  # 1/1200 seconds

for each_bit:
    bit_end_time = bit_start_time + bit_duration
    sample_start = int(bit_start_time * SAMPLE_RATE)
    sample_end = int(bit_end_time * SAMPLE_RATE)
    
    # Generate samples...
    
    bit_start_time = bit_end_time  # Carry fractional part
```

## Reference Commands

### Generate Dire Wolf Reference
```powershell
cd "C:\Users\Joshua\Downloads\direwolf-1.8.1-a231971_x86_64\direwolf-1.8.1-a231971_x86_64"
"APZDMR>EXAM-9:!3734.50N/12334.50W-Hello" | Out-File -Encoding ascii test_packet.txt
.\gen_packets.exe -o good_test.wav -r 44100 test_packet.txt
```

### Test with Dire Wolf
```powershell
cd "C:\Users\Joshua\Downloads\direwolf-1.8.1-a231971_x86_64\direwolf-1.8.1-a231971_x86_64"
.\atest.exe good_test.wav        # Reference: 1 packet decoded ✅
.\atest.exe C:\Users\Joshua\Documents\android\phonedmrapp\aprs_fixed_test.wav  # Ours: 0 packets ❌
```

### Analyze Our Audio
```powershell
cd C:\Users\Joshua\Documents\android\phonedmrapp
python analyze_our_audio.py      # Shows bit-by-bit frequency analysis
```

## Questions for Grok

1. **Is there something fundamentally wrong with our approach?**
   - We've verified audio is correct
   - We've matched all parameters
   - Yet nothing decodes

2. **What could Dire Wolf be checking that we're not providing?**
   - Packet length limits?
   - Specific preamble patterns?
   - Timing synchronization markers?

3. **Should we abandon Dire Wolf and try a different decoder?**
   - Is this a Dire Wolf quirk?
   - Would multimon-ng or another tool work?

4. **Is our bit stuffing actually correct?**
   - Tests pass, but maybe implementation is subtly wrong
   - Could byte alignment be off?

5. **What's the most efficient next debugging step?**
   - Byte-level comparison?
   - Source code examination?
   - Different tool entirely?

## Environment Info

- **OS**: Windows
- **Python**: 3.14
- **Dire Wolf**: 1.8.1-a231971 (x86_64)
- **Working Directory**: `C:\Users\Joshua\Documents\android\phonedmrapp`
- **Dire Wolf Path**: `C:\Users\Joshua\Downloads\direwolf-1.8.1-a231971_x86_64\direwolf-1.8.1-a231971_x86_64`

## The Bottom Line

We have exhaustively tested and verified that:
- ✅ Our waveform is correct (confirmed via frequency analysis)
- ✅ All parameters match Dire Wolf reference exactly
- ✅ Phase continuity and timing are mathematically sound
- ✅ Packet structure follows AX.25 specification
- ✅ Bit stuffing works correctly

Yet Dire Wolf decodes **0 packets** with:
- ❌ All encoding methods (Direct FSK, NRZI, both inverted)
- ❌ Both initial states (MARK, SPACE)
- ❌ Simple tests (FLAGS only) and complex tests (full packet)
- ❌ Even when parameters match reference exactly

**This suggests we're missing something fundamental that isn't visible in frequency/waveform analysis.**

---

**Please help identify what we're missing, Grok!**
