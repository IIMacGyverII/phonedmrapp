# Notes for Grok - APRS AFSK Audio Generation Issue

**Date**: March 10, 2026  
**Status**: 🔴 BLOCKED - Python test script generates audio but direwolf decodes 0 packets  
**Goal**: Generate valid Bell 202 AFSK audio that direwolf can decode

---

## Problem Summary

We have working APRS packet encoding (AX.25 with FCS, bit stuffing, NRZI) and the code logic is **mathematically correct**, but the generated audio fails direwolf decoding with **0 packets decoded**. Even the working TT7F reference file stops working when we try to replicate its encoding.

### What Works ✅
- ✅ AX.25 packet structure (addresses, control, PID, FCS)
- ✅ FCS (CRC-16-CCITT) calculation verified correct
- ✅ Bit stuffing implementation (5 consecutive 1s → insert 0)
- ✅ NRZI toggle logic verified (debug shows 32+ transitions)
- ✅ Phase increments calculated correctly (0.170971 rad/sample for 1200 Hz, 0.313447 for 2200 Hz)
- ✅ Sample generation loop uses correct phase_inc values
- ✅ WAV file format (44100 Hz, 16-bit mono PCM)

### What Doesn't Work ❌
- ❌ **Direwolf decodes 0 packets from ALL our generated files**
- ❌ Even with Android-matching parameters (no preamble, start with MARK)
- ❌ Even with TT7F-matching parameters (44100 Hz, ±8191 amplitude, SPACE preamble)
- ❌ All 6 encoding variants fail (Standard/Inverted NRZI, LSB/MSB, Direct FSK)
- ❌ Pure FLAG bytes (0x7E) fail to decode
- ❌ Minimal test packets fail

---

## Investigation Timeline

### Phase 1: Initial Discovery
- Built Python test framework with 6 encoding variants
- Tested known-good packet structure from Grok
- **Result**: All variants decode 0 packets

### Phase 2: Reference File Analysis
- User provided `TT7F telemetry example.wav` (known working)
- Direwolf successfully decodes: `OK7DMT-11>APRS,WIDE2-1`
- Analyzed parameters: 44100 Hz, ±8191 amplitude, ~2072 Hz preamble (SPACE)

### Phase 3: Parameter Matching
- Updated generator to match TT7F exactly
- **Result**: Still 0 packets decoded

### Phase 4: Waveform Analysis
- Created `compare_waveforms.py` using zero-crossing analysis
- **Discovery**: Our audio shows constant 2205 Hz (SPACE) throughout
- Working file shows varying frequencies: 1984, 1764, 2205, 1323 Hz

### Phase 5: NRZI Logic Debugging
- Created `debug_nrzi.py` to trace encoding manually
- Verified 20 toggles, 12 no-changes in first 4 bytes
- **Conclusion**: NRZI logic is mathematically correct

### Phase 6: Unicode Console Bug 🐛
- Added debug output to generator
- Silent crashes with no output
- **Discovered**: Windows PowerShell can't encode `→` character (U+2192)
- **Error**: `UnicodeEncodeError: 'charmap' codec can't encode character`
- **Fix**: Replaced all `→` with `->` (ASCII)
- **Result**: Debug now visible, shows NRZI toggles executing correctly

### Phase 7: Sample-Level Analysis
- Added debug to print phase_inc values during sample generation
- **Verified**: 
  - Bit 0: phase_inc=0.170971 (MARK 1200 Hz)
  - Bit 7: phase_inc=0.313447 (SPACE 2200 Hz)  
  - Bit 8: phase_inc=0.170971 (MARK 1200 Hz)
- Variables ARE toggling correctly in the code

### Phase 8: Bit Pattern Comparison
- Created `compare_bit_patterns.py` to decode audio bit-by-bit
- **Working file**: `00000001 00000001 00000001...` (FLAG bytes 0x7E repeating)
- **Our file**: `00000000 00000000 00000000...` (ALL SPACE, no MARK!)
- **PARADOX**: Code shows MARK phase_inc (0.170971) but audio decodes as SPACE (2200 Hz)

### Phase 9: Android Implementation Comparison
- Examined `AFSKGenerator.java` in Android app
- **Differences found**:
  - Android: `TX_DELAY_MS = 0` (no preamble)
  - Android: Start with MARK frequency
  - Android: AMPLITUDE = 32767 * 0.8 = 26214
- Updated Python to match Android exactly
- **Result**: Still 0 packets decoded

---

## Current Code State

### Python Test Script: `aprs_generator_test.py`

**Parameters** (Android-matching):
```python
MARK_FREQ = 1200
SPACE_FREQ = 2200
BAUD_RATE = 1200
SAMPLE_RATE = 44100
TX_DELAY_MS = 0        # No preamble (Android match)
TX_TAIL_MS = 100
AMPLITUDE = int(32767 * 0.8)  # 26214
```

**NRZI Generation** (simplified):
```python
current_freq = MARK_FREQ
current_phase_inc = MARK_PHASE_INC

for byte in packet:
    for bit_idx in range(8):
        bit = (byte >> bit_idx) & 1  # LSB first
        
        if bit == 0:  # Toggle on 0
            if current_freq == MARK_FREQ:
                current_phase_inc = SPACE_PHASE_INC
            else:
                current_phase_inc = MARK_PHASE_INC
        
        # Generate samples for this bit
        bit_end_sample = int((bit_counter / BAUD_RATE) * SAMPLE_RATE)
        while len(audio) - delay_samples < bit_end_sample:
            audio.append(int(math.sin(phase) * AMPLITUDE))
            phase += current_phase_inc  # ← Uses correct value
            phase = phase % (2 * math.pi)
```

**Debug Output** (verified correct):
```
Bit 0: SPACE->MARK (phase_inc=0.170971)
Bit 1-6: stay at 1200Hz
Bit 7: MARK->SPACE (phase_inc=0.313447)
Bit 8: SPACE->MARK (phase_inc=0.170971)
```

**But Audio Analysis Shows**:
```
Bit 0-23: ALL SPACE (2205 Hz)
Decoded bytes: 0x00 0x00 0x00 (should be 0x80 0x80 0x80)
```

---

## The Mystery 🤔

### What We Know
1. **Variables toggle correctly** - debug confirms `current_phase_inc` alternates
2. **Sample loop uses correct value** - `phase += current_phase_inc` with verified values
3. **Audio doesn't reflect the changes** - waveform analysis shows constant SPACE frequency
4. **Even minimal tests fail** - 10 FLAG bytes (0x7E) decode as 0 packets

### What We Don't Know
- Why correct phase increments don't produce correct frequencies
- Why Android Java code (seemingly identical logic) might work but Python doesn't
- If there's a subtle Bell 202 encoding detail we're missing
- If direwolf has specific requirements we're not meeting

### Theories
1. **Timing Issue**: Maybe `int(SAMPLES_PER_BIT)` truncation (36.75 → 36) causes phase misalignment
   - We implemented exact timing: `bit_end_time * SAMPLE_RATE`
   - Still fails
   
2. **Phase Continuity**: Maybe preamble phase needs to align with first data bit
   - Working file starts with SPACE preamble
   - Our attempts with SPACE preamble fail too
   
3. **Amplitude Issue**: Maybe 26214 (80% of 32767) is wrong
   - Tried 8191 (from working file) - still fails
   
4. **Sample Format**: Maybe WAV header or sample packing is wrong
   - Working file: 16-bit signed PCM, mono, 44100 Hz
   - Our files: Same format
   - Direct byte comparison would be needed

5. **Hidden Python Bug**: Maybe Python's sine/phase arithmetic has precision issues
   - But we verified phase_inc values are correct (6 decimal places)
   - Math.sin should be accurate enough

---

## Test Files Created

### Python Scripts
1. **`aprs_generator_test.py`** - Main generator with 6 encoding variants
2. **`analyze_working_aprs.py`** - Analyzes TT7F reference file
3. **`compare_waveforms.py`** - Zero-crossing frequency analysis
4. **`compare_bit_patterns.py`** - Bit-by-bit decoding of audio
5. **`debug_nrzi.py`** - Standalone NRZI logic tester
6. **`simple_tone_test.py`** - Pure 1200/2200 Hz tone generator
7. **`test_flags_only.py`** - Minimal FLAG byte test
8. **`check_specific_samples.py`** - Sample-level frequency analysis
9. **`decode_working_file.py`** - Decode TT7F bit pattern

### Reference Files
- **`TT7F telemetry example.wav`** - Known-working APRS audio (decodes successfully)
- **`test_audio.wav`** - Various test outputs
- **`known_good_*.wav`** - Generated tests (all fail, in `aprs_debug/aprs_debug/`)

### Android Implementation
- **`DMRModHooks/app/src/main/java/.../AFSKGenerator.java`** - Android AFSK generator
  - Has both `generateAFSK()` and `generateAFSKWithNRZI()` methods
  - Uses 48000 Hz sample rate, we tested with 44100 Hz
  - Direct FSK: `bit 1 = MARK, bit 0 = SPACE`
  - NRZI: `bit 0 = toggle, bit 1 = no change`

---

## Known-Good Packet Structure

From Grok (APZDMR-0>EXAMPLE-9 position beacon):
```
Destination: APZDMR-0
  0x82 0xA0 0x84 0x9A 0x84 0x62 0x60

Source: EXAMPLE-9
  0x9E 0x9A 0x68 0x84 0x62 0x40 0x63

Control: 0x03 (UI frame)
PID: 0xF0 (no layer 3)

Info: !07334.50N/01234.50W-Hello world!
  0x21 0x30 0x37 0x33 0x34 0x2E 0x35 0x30 0x4E 0x2F
  0x30 0x31 0x32 0x33 0x34 0x2E 0x35 0x30 0x57 0x2D
  0x48 0x65 0x6C 0x6C 0x6F 0x20 0x77 0x6F 0x72 0x6C 0x64 0x21

FCS: 0x9035 (calculated, verified correct)

Full packet with flags and bit stuffing: 53 bytes
```

---

## Next Steps (Recommendations)

### Option 1: Use Direwolf to Generate Reference ⭐ RECOMMENDED
```powershell
# Direwolf can generate test audio
cd "C:\Users\Joshua\Downloads\direwolf-1.8.1-a231971_x86_64\direwolf-1.8.1-a231971_x86_64"
.\gen_packets.exe -o test_output.wav -r 44100 "APZDMR-0>EXAMPLE-9:!07334.50N/01234.50W-Test"
```
Then analyze the generated audio sample-by-sample to see exact encoding.

### Option 2: Test Android App Directly
1. Build current `DMRModHooks` APK
2. Use `AFSKGenerator.generateAFSKWithNRZI()` to generate audio
3. Record output to WAV file on phone
4. Transfer to PC and test with direwolf
5. If works: Compare byte-by-byte with Python output
6. If fails: Android has same issue, problem is in shared logic

### Option 3: Find Working Python Implementation
Search GitHub for "APRS AFSK Python" or "Bell 202 Python" to find proven encoder, compare line-by-line with ours.

### Option 4: Low-Level Audio Analysis
1. Extract first 1000 samples from working file
2. Extract first 1000 samples from our file
3. Compare byte-by-byte in hex editor
4. Calculate actual frequencies from phase changes
5. Look for patterns/differences

### Option 5: Consult APRS/Amateur Radio Community
- Post on Reddit r/amateurradio or r/APRS
- Ask on TAPR APRS forum
- Someone may have solved this exact issue

---

## Relevant Code Snippets

### Working TT7F File Analysis
```
Sample rate: 44100 Hz
Amplitude: ±8191
Duration: 0.457s

Decoded bit pattern (first 24 bits):
000000010000000100000001  (FLAG bytes: 0x80 repeating)

Bit 0-6: SPACE (2205 Hz)
Bit 7: MARK (1160 Hz)
Bit 8-14: SPACE (2205 Hz)
Bit 15: MARK (1225 Hz)
```

### Our Generated File Analysis
```
Sample rate: 44100 Hz
Amplitude: ±26214
Duration: 0.653s

Decoded bit pattern (first 24 bits):
000000000000000000000000  (ALL SPACE!)

Bit 0-23: ALL SPACE (2205 Hz)
NO MARK TONES DETECTED
```

### Phase Increment Verification
```python
MARK_PHASE_INC = 2π × 1200 / 44100 = 0.170971 rad/sample
SPACE_PHASE_INC = 2π × 2200 / 44100 = 0.313447 rad/sample

# Verification (reverse calculation):
freq = phase_inc × sample_rate / (2π)
MARK: 0.170971 × 44100 / (2π) = 1200.0 Hz ✓
SPACE: 0.313447 × 44100 / (2π) = 2200.0 Hz ✓
```

---

## Bell 202 AFSK Specification

### Standard
- **MARK** (binary 1): 1200 Hz
- **SPACE** (binary 0): 2200 Hz
- **Baud rate**: 1200 bps
- **Encoding**: NRZI (Non-Return to Zero Inverted)
  - Binary 0: Frequency transition
  - Binary 1: No frequency change

### AX.25 Packet Structure
```
FLAG (0x7E)
Destination Address (7 bytes)
Source Address (7 bytes)
Digipeater Addresses (0-8 addresses, 7 bytes each)
Control (1 byte)
PID (1 byte)
Information (1-256 bytes)
FCS (2 bytes)
FLAG (0x7E)
```

### Bit Stuffing
- After 5 consecutive 1s, insert a 0
- Prevents false FLAG detection (0x7E = 01111110)
- Applied to everything between opening and closing FLAGS

---

## Environment Details

### Software Versions
- **Python**: 3.14
- **Direwolf**: 1.8.1 (November 2025)
- **OS**: Windows 11
- **PowerShell**: (version unknown)

### Direwolf Test Command
```powershell
cd "C:\Users\Joshua\Downloads\direwolf-1.8.1-a231971_x86_64\direwolf-1.8.1-a231971_x86_64"
.\atest.exe "path\to\test.wav"
```

### Expected Success Output
```
44100 samples per second.  16 bits per sample.  1 audio channels.
1 from TT7F telemetry example.wav
OK7DMT-11>APRS,WIDE2-1:!/5MGoS(L_0GzW |!$!!#p+30n!!!"|
1 packets decoded in 0.004 seconds.
```

### Actual Output (All Our Files)
```
44100 samples per second.  16 bits per sample.  1 audio channels.
0 from test_file.wav
0 packets decoded in X seconds.
```

---

## Critical Questions for Grok

1. **Why doesn't alternating phase_inc produce alternating frequencies?**
   - Debug proves: phase_inc toggles between 0.170971 and 0.313447
   - Audio analysis proves: Output is constant 2205 Hz
   - What's the disconnect?

2. **Is there a Python-specific issue with sine wave generation?**
   - `int(math.sin(phase) * AMPLITUDE)` - could truncation cause this?
   - Should we use numpy instead?

3. **Does direwolf require specific audio characteristics we're missing?**
   - Preamble length?
   - Phase alignment at bit boundaries?
   - DC offset?
   - Exact amplitude patterns?

4. **Can you generate working APRS audio and show us the code?**
   - Even a minimal "Hello World" beacon
   - We can compare sample-by-sample

5. **Should we abandon Bell 202 and try a different approach?**
   - Use Android AudioTrack directly instead of pre-generating?
   - Use external library (if any exist for Android)?

---

## Notes on Android App

The actual Android app (`DMRModHooks`) has:
- **Current Status**: Built, TX audio generated but never tested with direwolf
- **Target**: BTech DMR radio via audio cable
- **Sample Rate**: 48000 Hz (Android), we tested Python with 44100 Hz
- **Use Case**: APRS beaconing during DMR voice calls to share GPS position

### Android Code Locations
```
DMRModHooks/app/src/main/java/com/dmrmod/hooks/
  ├── AFSKGenerator.java        ← AFSK audio generation
  ├── APRSBeacon.java           ← Beacon management
  ├── APRSPacketEncoder.java    ← Packet encoding (FCS, bit stuffing)
  └── AFSKDecoder.java          ← RX decoder (not fully tested)
```

The Android app may have the same issue we're debugging in Python. Once we solve this, we need to:
1. Update `AFSKGenerator.java` with the fix
2. Rebuild APK
3. Test TX beacon with direwolf
4. Test phone-to-phone APRS communication

---

## Success Criteria

We'll know we've solved this when:
- ✅ Direwolf output: `1 from test.wav` (not 0)
- ✅ Shows: `1 packets decoded in X seconds`
- ✅ Displays decoded packet content
- ✅ Works consistently with different packets
- ✅ Android app generates audio that direwolf decodes

---

## Final Thoughts

We've eliminated most common issues:
- ❌ Not a packet structure problem (verified bytes)
- ❌ Not an FCS problem (calculated correctly)
- ❌ Not a bit stuffing problem (applied correctly)
- ❌ Not an NRZI logic problem (toggles verified)
- ❌ Not a parameter problem (tried multiple combinations)

**The issue is at the audio synthesis level** - something about how we convert phase increments to actual audio samples is fundamentally wrong, but the Python math looks correct.

This strongly suggests:
1. There's a Bell 202 encoding detail we don't understand
2. Or direwolf has specific requirements not documented
3. Or there's a Python/audio generation bug we haven't found

**Recommendation**: Use direwolf's `gen_packets` to create reference audio, then reverse-engineer it. That's the fastest path to understanding what we're missing.

---

## Contact & Context

- **User**: Joshua (ham radio operator, Android developer)
- **Project**: DMRModHooks LSPosed module for PriInterPhone DMR app
- **Goal**: Add APRS TX/RX to DMR radios without APRS hardware
- **Workspace**: `C:\Users\Joshua\Documents\android\phonedmrapp`

If you're continuing this work, start by running:
```powershell
cd "C:\Users\Joshua\Documents\android\phonedmrapp"
python compare_bit_patterns.py  # See the problem visually
```

Good luck! 🍀
