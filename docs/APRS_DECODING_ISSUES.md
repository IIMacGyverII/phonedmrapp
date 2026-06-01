# APRS Receive Decoding Issues - Help Needed

## Summary
We have successfully implemented APRS transmission (TX) which works perfectly. We can transmit APRS beacons with real-time GPS, proper AX.25 encoding, Bell 202 AFSK modulation, bit stuffing, and NRZI encoding.

However, **APRS receive (RX) is completely failing** to decode packets. We're receiving audio, detecting flags, extracting packets of correct size, but **100% FCS (Frame Check Sequence) verification failures** after 40+ different decoding attempts.

## What We're Doing

### Transmission (Working ✅)
1. **GPS Acquisition**: Getting lat/lon/altitude from Android LocationManager
2. **AX.25 Encoding**: Creating proper UI frames with:
   - Opening flag (0x7E)
   - Destination: APZDMR-0 (shifted left by 1)
   - Source: Callsign-SSID (shifted left by 1)
   - Control: 0x03 (UI frame)
   - PID: 0xF0 (no layer 3 protocol)
   - Information field: Position data in APRS format
   - FCS: CRC-16-CCITT calculated over address/control/PID/info
   - Closing flag (0x7E)
3. **Bit Stuffing**: Applied ONLY to data between flags (not to flags themselves)
4. **NRZI Encoding**: 
   - Start with mark frequency (1200 Hz)
   - Binary 0 = toggle frequency
   - Binary 1 = no change
5. **AFSK Modulation**: Bell 202 standard
   - Mark: 1200 Hz = binary 1
   - Space: 2200 Hz = binary 0
   - 1200 baud
   - 48 kHz sample rate
6. **Audio Output**: AudioTrack, 80% amplitude, left channel

**TX packet example** (first 20 bytes after encoding):
```
7E 82 A0 B4 88 9A A4 60 82 82 60 82 9A 40 6E AE 92 88 8A 62
```

### Reception (Failing ❌)
1. **Audio Capture**: Hooking PCMReceiveManager.writeAudioTrack() 
   - Receiving 2048-byte chunks every ~64ms
   - Accumulating until RECEIVE_STOP event
   - Typical buffer: 60K-66K samples (1.2-1.4 seconds at 48kHz)
2. **AFSK Demodulation**: Goertzel algorithm for 1200 Hz and 2200 Hz detection
3. **NRZI Decoding**: Converting frequency changes back to bits
4. **Flag Detection**: Searching for 01111110 (0x7E) patterns bit-by-bit
5. **Packet Extraction**: Extracting bits between flag sequences
6. **Bit De-stuffing**: Removing stuffed zeros after five consecutive ones
7. **Byte Conversion**: Converting bit arrays to byte arrays
8. **FCS Verification**: CRC-16-CCITT check on received data

## What We're Seeing

### Successful Operations ✅
- Audio capture working (logs show writeAudioTrack called consistently)
- RECEIVE_STOP events triggering properly
- Buffer accumulation working (60K-66K samples per packet)
- Goertzel demodulation producing bit streams (1600-1650 bits per packet)
- **Flags being found**: 2-22 flags detected per transmission
- **Packets being extracted**: 18-111 byte packets (valid APRS size range)
- Different packet sizes per transmission (indicates multiple packets detected)

### Failed Operations ❌
- **100% FCS verification failures** across ALL attempts
- Decoded bytes show repeated patterns: `D2 D2 D2`, `4B 4B 4B`, `12 12 12`, `48 48 48`
- Decoded data completely different from transmitted data

### Example RX Data (all 4 combinations tested automatically):
```
LSB-NoStuff (22 bytes): 5D 71 94 E4 D2 D2 D2 D2 D2 D2 D2 D2 D2 12 12 12 12 12 12 12
MSB-NoStuff (22 bytes): BA 8E 29 27 4B 4B 4B 4B 4B 4B 4B 4B 4B 48 48 48 48 48 48 48
LSB-Stuff (22 bytes): 5D 71 94 E4 D2 D2 D2 D2 D2 D2 D2 D2 D2 12 12 12 12 12 12 12
MSB-Stuff (22 bytes): BA 8E 29 27 4B 4B 4B 4B 4B 4B 4B 4B 4B 48 48 48 48 48 48 48

FCS mismatch examples:
- calculated: 0x26d9, transmitted: 0x1212
- calculated: 0x2eb8, transmitted: 0x4848
```

**None match the TX data** (should start with: `82 A0 B4 88 9A A4 60...`)

### NRZI Decoded Bit Streams (first 100 bits):
```
1101101000000100001110111010000001110011110110100000011100111010001000000111001110100010000001110011
0001110101110001000000000110101100010001101000011101000111000010000111010001001010100010110010011100
0111001101011101111100111000010101111100000010110101111011000100001101011101110000101110000111100011
```

Some have 6+ consecutive 1s (close to flag pattern 01111110), but decoded data is still scrambled.

## Decoding Combinations Attempted (40+ iterations)

We have tested EVERY combination of these parameters:

### Mark/Space Frequency Assignment
- ✅ Standard: Mark (1200 Hz) = 1, Space (2200 Hz) = 0
- ❌ Swapped: Mark (1200 Hz) = 0, Space (2200 Hz) = 1

### NRZI Decoding
- ✅ Standard: transition = 0, no transition = 1
- ❌ Inverted: transition = 1, no transition = 0

### NRZI Initial State
- ✅ previousState = true (TX starts with mark)
- ❌ previousState = false

### Byte Ordering
- ✅ LSB-first: bit 0 → byte position 0 (matches TX)
- ❌ MSB-first: bit 0 → byte position 7

### Bit Stuffing
- ✅ With removal (standard AX.25)
- ❌ Without removal (in case other radio doesn't use it)

### Bit Polarity
- ✅ Normal bits
- ❌ Inverted bits (after demodulation)
- ❌ Inverted bits (before NRZI)
- ❌ Inverted bits (after NRZI)

### Current Best Attempt (Still Failing)
Testing **all 4 combinations automatically** on each packet:
1. LSB-first, no bit stuffing removal
2. MSB-first, no bit stuffing removal  
3. LSB-first, with bit stuffing removal
4. MSB-first, with bit stuffing removal

**Result**: All 4 still fail FCS verification

## Test Setup
- **Transmitter**: Separate walkie-talkie (not our app) sending APRS beacons every 30 seconds
- **Receiver**: Our Android app capturing audio via DMR radio's PCM stream
- **Audio path**: RF → DMR radio hardware → PCM buffer → our hook
- **No RF loopback issues** (using separate radios)

## Questions for Grok

### 1. Standard APRS/AX.25 Packet Structure
Can you outline the **exact, step-by-step structure** of a standard APRS packet over the air?
- Bit order within bytes (LSB-first or MSB-first)?
- Byte order for multi-byte fields?
- Exact flag format (01111110 or 11111101)?
- Where bit stuffing is applied (before or after NRZI? to flags or not?)
- NRZI encoding specifics (which direction? initial state?)

### 2. Bell 202 AFSK Standard
- Is mark (1200 Hz) = binary 1 or 0?
- Is space (2200 Hz) = binary 1 or 0?
- Could there be variations between radios?

### 3. Decoding Pipeline Order
What is the **CORRECT order** for decoding an APRS packet from audio?
1. AFSK demodulation → bits
2. NRZI decoding → bits
3. Flag detection → locate packet boundaries
4. Bit de-stuffing → remove stuffed zeros
5. Byte conversion → LSB or MSB first?
6. FCS verification → last 2 bytes with CRC-16-CCITT

Is this order correct? Where are we likely going wrong?

### 4. Common Pitfalls
What are the **most common mistakes** when implementing an APRS decoder?
- Byte bit-order (LSB vs MSB)?
- NRZI polarity?
- Bit stuffing timing (before/after what step)?
- FCS byte order (little-endian vs big-endian)?
- Audio signal inversion at hardware level?

### 5. Diagnostic Approach
Given that we're:
- ✅ Receiving audio successfully
- ✅ Finding flags (2-22 per transmission)
- ✅ Extracting packets of correct size (18-111 bytes)
- ❌ Getting 100% FCS failures with scrambled data

What is the **most likely root cause**? 

Should we:
- Check if the transmitting radio uses non-standard encoding?
- Record raw audio to WAV and analyze with direwolf?
- Compare our demodulated bit stream against known good implementation?
- Add correlation detection to auto-discover correct parameters?

### 6. Reference Implementation
Can you provide a **simple reference implementation** in pseudocode showing:
```
raw_audio[] → AFSK_demod() → nrzi_bits[] → decode_NRZI() → decoded_bits[] 
           → find_flags() → packet_bits[] → remove_stuffing() → unstuffed_bits[]
           → to_bytes(LSB_or_MSB?) → packet_bytes[] → verify_FCS() → valid?
```

With explicit notes on:
- What "true" and "false" represent at each stage
- Bit ordering conventions
- Where inversions might occur

## Code References

### Our TX Implementation (Working)
```java
// AFSKGenerator.java - generateAFSKWithNRZI()
boolean currentFrequencyIsMark = true;  // Start with mark
for (int byteIndex = 0; byteIndex < packet.length; byteIndex++) {
    byte b = packet[byteIndex];
    for (int bitIndex = 0; bitIndex < 8; bitIndex++) {
        boolean bit = ((b >> bitIndex) & 0x01) == 1;  // LSB first
        if (!bit) {  // NRZI: 0 = toggle
            currentFrequencyIsMark = !currentFrequencyIsMark;
        }
        double phaseInc = currentFrequencyIsMark ? MARK_PHASE_INC : SPACE_PHASE_INC;
        // Generate audio samples...
    }
}
```

### Our RX Implementation (Failing)
```java
// AFSKDecoder.java - Current approach
// 1. Goertzel demodulation
boolean bit = (markPower > spacePower);  // Mark=1, Space=0

// 2. NRZI decoding
boolean previousState = true;
decoded[i] = (nrziEncoded[i] == previousState);  // Transition=0, No change=1

// 3. Flag detection (bit-by-bit search for 01111110)

// 4. Bit de-stuffing (remove 0 after five 1s)

// 5. Byte conversion (testing BOTH LSB and MSB)
// LSB: byteValue |= (1 << j)
// MSB: byteValue |= (1 << (7 - j))

// 6. FCS verification (CRC-16-CCITT)
```

## Request
Please provide detailed guidance on:
1. What we're doing wrong in our decoding pipeline
2. The correct bit/byte ordering for AX.25 over Bell 202 AFSK
3. How to diagnose where in the pipeline the data is getting scrambled
4. Any non-obvious gotchas in APRS/AX.25 decoding

Thank you for any insights!
