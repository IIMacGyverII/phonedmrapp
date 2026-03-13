# APRS Transmission Problem - Detailed Notes for Analysis

**Date:** March 11, 2026  
**Project:** DMR Radio APRS Beacon Transmission  
**Status:** Audio transmits but doesn't decode, sounds wrong

---

## OBJECTIVE

Transmit APRS packets from Android DMR radio (TYT MD-UV380) by:
1. Generating Bell 202 AFSK audio (1200 Hz mark, 2200 Hz space, 1200 baud)
2. Injecting audio into radio's TX path via `PrizeTinyService.openWritePcm() → writeFrame()`
3. Having packets decode successfully on receivers (HackRF, other radios, direwolf decoder)

---

## WHAT'S WORKING ✅

1. **APRS RX (Receive)**: 100% functional - successfully decoding packets from air (e.g., BG6LKK-8)
2. **TX Audio Path**: Audio reaches transmitter - carrier present on 144.390 MHz
3. **RF Transmission**: Can hear audio on receivers
4. **Packet Structure**: Proper AX.25 encoding (addresses, control, PID, info, FCS)
5. **Radio Configuration**: AnalogMessage successfully switches from DMR digital to FM analog mode

---

## THE PROBLEM ❌

**Generated APRS audio "sounds nothing like a real APRS packet"**

- Transmits but **0 packets decoded** by direwolf or receivers
- Audio quality described as "way off" and "sounds wrong"
- Does not match the clear, distinct tone patterns heard from other DMR radios transmitting APRS

---

## TECHNICAL DETAILS

### Current Implementation (Latest Attempt - C Library Style)

**Packet Encoder** (`APRSPacketEncoder.java`):
```
Returns plain AX.25 frame:
- Destination: APZDMR-0
- Source: AA0AM-7 (user callsign)
- Path: WIDE1-1, WIDE2-1
- Control: 0x03 (UI frame)
- PID: 0xF0 (no layer 3)
- Info: Position data (!DDMM.HHN/DDDMM.HHW$/A=XXXXXX comment)
- FCS: CRC-16-CCITT (0xFFFF initial, 0x8408 reversed polynomial)
```

**AFSK Generator** (`AFSKGenerator.java`):
```
Sample Rate: 8000 Hz (radio's native rate)
Mark Frequency: 1200 Hz (binary 1)
Space Frequency: 2200 Hz (binary 0)
Baud Rate: 1200 bps
Amplitude: 75% of 16-bit max (24575)

Transmission sequence:
1. 25 preamble flags (0x7E) - no bit stuffing
2. Frame data with bit stuffing (zero inserted after 5 consecutive ones)
3. 5 trailing flags (0x7E) - no bit stuffing

NRZI Encoding: Bit 0 = frequency change, Bit 1 = no change
Bit Order: LSB first
Phase: Continuous across bit boundaries
```

**Transmission Path**:
```
1. AnalogMessage.send() - Configure FM analog @ 144.390 MHz
2. launchCommand() - Key transmitter
3. Wait 500ms - PTT settle
4. openWritePcm() - Open TX audio (frame size: 2048 bytes)
5. Wait 300ms - Carrier stabilization
6. Convert mono→stereo (duplicate L+R channels)
7. writeFrame() every 64ms - Send audio to tinyserver daemon
8. closeWritePcm() - Close channel
9. launchEnd() - Un-key transmitter
```

---

## TESTING EVIDENCE

### Test Files Generated

**direwolf_reference.wav** (Known Good - from other radio):
```
Sample Rate: 8000 Hz (old test) or 44100 Hz (recent)
Result: Decodes perfectly - 1 packet
Created by: Unknown APRS source (saved from working transmission)
```

**aprs_tx_XXX.wav** (Our Generated Audio):
```
Sample Rate: 8000 Hz
Result: 0 packets decoded
Direwolf output: "0 from aprs_tx_XXX.wav"
```

### direwolf Test Commands Used
```bash
# Test our generated audio
atest.exe test_aprs_tx.wav
Output: "8000 Hz, 0 packets decoded"

# Test reference audio
atest.exe direwolf_reference.wav
Output: "8000 Hz, 1 packet decoded"
DECODED[1] AA0AM-7>APZDMR:...
```

---

## IMPLEMENTATION EVOLUTION (What We've Tried)

### Attempt 1: Python Reference (afsk library)
- 20 zero bytes + 100 flags preamble
- Pre-calculated bit stuffing
- 48 kHz → downsampled to 8 kHz
- 50% amplitude
- **Result**: Didn't decode, wrong structure

### Attempt 2: Fixed Packet Structure
- Discovered bug: only preserving 16 flags instead of 120 bytes preamble
- Fixed to preserve full preamble
- **Result**: Still no decode

### Attempt 3: C Library Style (ax25-aprs-lib)
- Plain AX.25 frame (no embedded preamble)
- 25 preamble flags + 5 trailing flags
- Bit stuffing during transmission (not pre-calculated)
- Continuous phase NRZI
- Native 8 kHz generation (no downsampling)
- 75% amplitude
- **Result**: "Sounds nothing like real APRS packet"

---

## REFERENCE IMPLEMENTATIONS STUDIED

### 1. Python `afsk` Library (C:\Users\Joshua\Downloads\afsk)
```python
# Key parameters:
MARK_HZ = 1200.0
SPACE_HZ = 2200.0
BAUD_RATE = 1200.0

# Preamble:
- 20 zero bytes (0x00) for clock sync
- 100 flags (0x7E)
- 1.05s silence before packet
- 1.05s silence after packet
- 50% amplitude (0.5 multiplier)
```

### 2. C `ax25-aprs-lib` (C:\Users\Joshua\Downloads\ax25-aprs-lib)
```c
// Key parameters:
#define AX25_AFSK1200_SAMPLERATE     (48000)
#define AX25_AFSK1200_BITRATE        (1200)
#define AX25_AFSK1200_FREQ1          (1200)
#define AX25_AFSK1200_FREQ2          (2200)
#define AX25_AFSK1200_PREAMBLE_BYTES (25)
#define AX25_AFSK1200_REST_BYTES     (5)

// Amplitude:
*((*wav)++) = (0.75 * 32768.0 * sin(ax25->phase));

// NRZI encoding:
if (!bit) {
    ax25->freq ^= ax25->freq1 ^ ax25->freq2;  // Toggle on 0
}

// Bit stuffing during transmission:
if (ax25->bc == 5) {
    len += _ax25_txbit(ax25, wav, 0, 0);  // Insert zero
}
```

### 3. PortaPack Mayhem Firmware (C:\Users\Joshua\Downloads\mayhem-firmware)
```cpp
// Uses baseband AFSK generation at 1.536 MHz
baseband::set_afsk_data(...)
// 10 kHz bandwidth parameter
// Much higher sample rate than our approach
```

---

## CURRENT HYPOTHESIS - POSSIBLE ISSUES

### 1. **Sample Rate Mismatch**
- Radio hardware may require different sample rate than 8 kHz
- DMR voice is 8 kHz, but analog FM TX path might expect different rate
- C library uses 48 kHz, we're using 8 kHz

### 2. **Frame Timing Issues**
- writeFrame() called every 64ms (calculated for 8 kHz stereo)
- Calculation: 2048 bytes ÷ 4 bytes/sample ÷ 8000 Hz = 64ms
- May not match actual buffer consumption rate

### 3. **Stereo Conversion**
- Converting mono to stereo by duplicating samples
- Radio may expect different stereo encoding or pure mono

### 4. **NRZI Implementation**
- Frequency toggling on bit=0 vs bit=1
- Starting frequency (mark vs space)
- Phase continuity across transitions

### 5. **Bit Stuffing Logic**
- When to stuff (after 5 ones vs different count)
- Whether to stuff in preamble flags
- Resetting consecutive ones counter

### 6. **Preamble Length**
- C library: 25 flags
- Python: 100 flags + 20 zeros
- Unknown what radio expects for proper AGC/decoder lock

### 7. **Amplitude/Deviation**
- 75% amplitude may overdrive or underdrive FM modulator
- FM deviation needs to be correct for Bell 202 (~3 kHz deviation)

### 8. **Phase Initialization**
- Starting phase = 0.0
- Python reference mentions 0.147155 radians initial phase

---

## COMPARISON: WORKING VS NON-WORKING

### Working (APRS RX from air)
```
Source: BG6LKK-8 and others
Decoded by: Our AFSKDecoder.java
Characteristics: Unknown - we're receiving, not generating
```

### Non-Working (Our TX)
```
User feedback: "sounds nothing like a real APRS packet"
Problem: Audio quality/characteristics fundamentally wrong
Not just timing or minor deviation issue
```

---

## RADIO HARDWARE CONSTRAINTS

**TYT MD-UV380 DMR Radio**:
- Native mode: DMR digital (TDMA)
- APRS TX mode: Analog FM
- Audio path: writeFrame() to tinyserver daemon
- Frame size: 2048 bytes
- Sample format: Stereo 16-bit PCM
- TX delays: 500ms PTT + 300ms carrier stabilization

**PrizeTinyService Methods**:
```java
openWritePcm() - Opens TX audio channel
writeFrame(byte[] frame, int size) - Writes audio frame
closeWritePcm() - Closes channel
getFrameSize() - Returns 2048
```

---

## CRITICAL QUESTIONS FOR GROK

1. **Sample Rate**: Should we be using 8 kHz, 48 kHz, or something else for Bell 202 AFSK transmitted via writeFrame() on this radio?

2. **NRZI Encoding**: Is our implementation correct?
   ```java
   // Our current code:
   if (!bit) {
       currentFreq = (currentFreq == MARK_FREQ) ? SPACE_FREQ : MARK_FREQ;
   }
   ```

3. **Bit Stuffing**: Should we:
   - Do it during transmission (current)
   - Pre-calculate and embed in packet
   - Not do it at all (flags handle sync)

4. **Preamble**: What's the correct preamble for reliable APRS decoding?
   - 25 flags (C library)
   - 100 flags + 20 zeros (Python)
   - Something else?

5. **Audio Quality**: Why would generated audio "sound nothing like a real APRS packet"?
   - What would cause fundamental audio characteristics to be wrong?
   - Is the waveform generation itself flawed?

6. **Frame Timing**: Is 64ms per 2048-byte frame correct for 8 kHz stereo?
   - Should we wait between writeFrame() calls?
   - Is the radio consuming audio at the rate we're providing it?

7. **Stereo Encoding**: Is simple L+R duplication correct?
   ```java
   output[i * 4] = (byte) (sample & 0xFF);           // Left low
   output[i * 4 + 1] = (byte) ((sample >> 8) & 0xFF); // Left high
   output[i * 4 + 2] = (byte) (sample & 0xFF);        // Right low (duplicate)
   output[i * 4 + 3] = (byte) ((sample >> 8) & 0xFF); // Right high (duplicate)
   ```

8. **Phase/Frequency**: Are we generating proper sine waves?
   ```java
   audio[sampleIndex++] = (short)(AMPLITUDE * Math.sin(phase));
   phase += phaseInc;
   if (phase >= 2.0 * Math.PI) {
       phase -= 2.0 * Math.PI;
   }
   ```

9. **FM Deviation**: Does 75% amplitude give correct ±3 kHz FM deviation for Bell 202?

10. **Comparison Method**: How can we validate our generated audio waveform against a known-good APRS packet?

---

## FILES AVAILABLE FOR ANALYSIS

1. **Source Code**:
   - `DMRModHooks/app/src/main/java/com/dmrmod/hooks/APRSPacketEncoder.java`
   - `DMRModHooks/app/src/main/java/com/dmrmod/hooks/AFSKGenerator.java`
   - `DMRModHooks/app/src/main/java/com/dmrmod/hooks/APRSBeacon.java`

2. **Test Audio Files**:
   - `/sdcard/aprs_debug/aprs_tx_XXX.wav` (our generated - fails to decode)
   - `/sdcard/aprs_debug/direwolf_reference.wav` (known good - decodes)

3. **Reference Implementations**:
   - `C:\Users\Joshua\Downloads\afsk\` (Python APRS encoder)
   - `C:\Users\Joshua\Downloads\ax25-aprs-lib\` (C APRS encoder)
   - `C:\Users\Joshua\Downloads\mayhem-firmware\` (PortaPack APRS)

4. **Decompiled App**:
   - Original TYT app with working APRS RX decoder

---

## EXPECTED OUTCOME

When working correctly:
1. Audio should sound identical to APRS packets from other radios
2. direwolf should decode: `DECODED[1] AA0AM-7>APZDMR:!DDMM.HHN/DDDMM.HHW$/A=XXXXXX...`
3. Receivers should successfully decode position/altitude/comment
4. Packet should appear on APRS-IS network when digipeated

---

## NEXT STEPS NEEDED

1. **Diagnose audio generation**: What's fundamentally wrong with our waveform?
2. **Validate against spec**: Compare generated audio to Bell 202 AFSK specification
3. **Test parameters**: Systematically vary sample rate, amplitude, timing
4. **Waveform analysis**: Compare our audio FFT/spectrogram to known-good packet
5. **Alternative approach**: Consider if we need completely different method

---

## REQUEST TO GROK

Please analyze this situation and provide:

1. **Root cause diagnosis**: Why would generated audio sound completely wrong?
2. **Specific code fixes**: What changes to make in AFSKGenerator.java
3. **Parameter validation**: Correct values for sample rate, amplitude, timing
4. **Testing approach**: How to validate audio before transmitting
5. **Alternative solutions**: If current approach is fundamentally flawed

The fact that user says it "sounds nothing like a real APRS packet" suggests the problem is more fundamental than just timing or minor parameter tuning. Something about our audio generation is creating wrong waveforms.
