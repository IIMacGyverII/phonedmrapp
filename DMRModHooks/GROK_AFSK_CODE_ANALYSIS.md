# AFSK Generator Code for Grok Analysis

## Problem Statement
Generated APRS AFSK audio does not decode on direwolf or receivers. Audio "sounds very different" from real APRS packets even after applying recommended fixes.

## Current Status After Implementing Your Recommendations
- ✅ 8 kHz sample rate (radio hardware native)
- ✅ 80 preamble flags (was 25)
- ✅ 10 trailing flags (was 5)
- ✅ 0.5 second constant MARK carrier before preamble
- ✅ 50% amplitude (was 75%)
- ✅ 64ms frame timing (correct for 8 kHz stereo)
- ❌ Still no decode - audio sounds "very different"

## Hardware Details
- **Radio**: TYT MD-UV380 (DMR radio)
- **Audio Path**: PrizeTinyService.writeFrame() → tinyserver daemon → radio TX
- **Frame Format**: Stereo 16-bit PCM, 2048 byte frames, written every 64ms
- **Mode**: Analog FM (radio switched from DMR digital via AnalogMessage)
- **Frequency**: 144.390 MHz VHF

## Complete AFSKGenerator.java Code

```java
package com.dmrmod.hooks;

public class AFSKGenerator {
    
    // Bell 202 AFSK parameters  
    private static final int MARK_FREQ = 1200;    // 1200 Hz for binary 1 (mark)
    private static final int SPACE_FREQ = 2200;   // 2200 Hz for binary 0 (space)
    private static final int BAUD_RATE = 1200;    // 1200 bits per second
    private static final int SAMPLE_RATE = 8000;  // 8 kHz - radio hardware sample rate
    
    // Timing parameters
    private static final int TX_DELAY_MS = 0;       // No separate delay - flags provide sync
    private static final int TX_TAIL_MS = 100;      // 100ms post-transmission tail
    
    // Amplitude (50% per Grok recommendation for FM deviation)
    private static final int AMPLITUDE = (int)(32767 * 0.50);  // 50% of 16-bit max
    
    // Precomputed values
    private static final double SAMPLES_PER_BIT = (double) SAMPLE_RATE / BAUD_RATE;  // 6.666...
    
    /**
     * Generate AFSK audio with NRZI encoding matching C library (ax25-aprs-lib)
     * - Adds preamble/trailing flags during generation
     * - Does bit stuffing during transmission
     * - Uses continuous phase
     * 
     * @param frame Plain AX.25 frame (addresses + control + PID + info + FCS, NO flags)
     * @return 16-bit PCM audio samples (mono)
     */
    public static short[] generateAFSKWithNRZI(byte[] frame) {
        final int PREAMBLE_FLAGS = 80;  // 80 flag bytes (Grok recommendation for sync)
        final int TRAILING_FLAGS = 10;  // 10 flag bytes after frame
        final byte FLAG = 0x7E;
        
        // Add 0.5s MARK carrier before flags for receiver sync (Grok recommendation)
        int carrierSamples = SAMPLE_RATE / 2;  // 0.5 seconds = 4000 samples
        
        // Calculate estimated audio length
        int totalBytes = PREAMBLE_FLAGS + frame.length + TRAILING_FLAGS;
        int estimatedBits = totalBytes * 8;
        estimatedBits += estimatedBits / 5 + 1;  // Worst case bit stuffing
        int estimatedSamples = carrierSamples + (int)(estimatedBits * SAMPLES_PER_BIT) + 1000;
        
        short[] audio = new short[estimatedSamples];
        int[] sampleIndex = {0};  // Use array for mutability in helper method
        
        // State variables (use arrays for mutability)
        double[] phase = {0.0};
        int[] currentFreq = {MARK_FREQ};  // Start at mark frequency
        int[] consecutiveOnes = {0};      // For bit stuffing
        
        // 0. Send 0.5s constant MARK carrier for receiver sync and AGC
        double phaseInc = 2.0 * Math.PI * MARK_FREQ / SAMPLE_RATE;
        for (int i = 0; i < carrierSamples && sampleIndex[0] < audio.length; i++) {
            audio[sampleIndex[0]++] = (short)(AMPLITUDE * Math.sin(phase[0]));
            phase[0] += phaseInc;
            if (phase[0] >= 2.0 * Math.PI) {
                phase[0] -= 2.0 * Math.PI;
            }
        }
        
        // 1. Send preamble flags (no bit stuffing)
        for (int i = 0; i < PREAMBLE_FLAGS; i++) {
            transmitByte(audio, sampleIndex, phase, currentFreq, consecutiveOnes, FLAG, false);
        }
        
        // 2. Send frame data (WITH bit stuffing)
        for (int i = 0; i < frame.length; i++) {
            transmitByte(audio, sampleIndex, phase, currentFreq, consecutiveOnes, frame[i], true);
        }
        
        // 3. Send trailing flags (no bit stuffing)
        for (int i = 0; i < TRAILING_FLAGS; i++) {
            transmitByte(audio, sampleIndex, phase, currentFreq, consecutiveOnes, FLAG, false);
        }
        
        // Trim to actual size
        short[] result = new short[sampleIndex[0]];
        System.arraycopy(audio, 0, result, 0, sampleIndex[0]);
        
        return result;
    }
    
    /**
     * Transmit one byte with optional bit stuffing
     */
    private static void transmitByte(short[] audio, int[] sampleIndex, double[] phase, 
                                     int[] currentFreq, int[] consecutiveOnes, 
                                     byte b, boolean doStuffing) {
        // Transmit LSB first
        for (int bitIdx = 0; bitIdx < 8; bitIdx++) {
            boolean bit = ((b >> bitIdx) & 0x01) == 1;
            transmitBit(audio, sampleIndex, phase, currentFreq, consecutiveOnes, bit, doStuffing);
        }
    }
    
    /**
     * Transmit one bit with NRZI encoding and optional stuffing
     */
    private static void transmitBit(short[] audio, int[] sampleIndex, double[] phase,
                                    int[] currentFreq, int[] consecutiveOnes,
                                    boolean bit, boolean doStuffing) {
        // NRZI: bit=0 causes frequency change, bit=1 keeps current frequency
        if (!bit) {
            currentFreq[0] = (currentFreq[0] == MARK_FREQ) ? SPACE_FREQ : MARK_FREQ;
        }
        
        // Generate samples for this bit
        double phaseInc = 2.0 * Math.PI * currentFreq[0] / SAMPLE_RATE;
        int samplesForBit = SAMPLE_RATE / BAUD_RATE;  // 6.666 → truncates to 6 samples per bit
        
        for (int i = 0; i < samplesForBit && sampleIndex[0] < audio.length; i++) {
            audio[sampleIndex[0]++] = (short)(AMPLITUDE * Math.sin(phase[0]));
            phase[0] += phaseInc;
            if (phase[0] >= 2.0 * Math.PI) {
                phase[0] -= 2.0 * Math.PI;
            }
        }
        
        // Bit stuffing: after 5 consecutive ones, stuff a zero
        if (doStuffing) {
            if (bit) {
                consecutiveOnes[0]++;
                if (consecutiveOnes[0] == 5) {
                    transmitBit(audio, sampleIndex, phase, currentFreq, consecutiveOnes, false, false);
                    consecutiveOnes[0] = 0;
                }
            } else {
                consecutiveOnes[0] = 0;
            }
        }
    }
}
```

## Packet Structure Being Encoded

```
Plain AX.25 frame input to generator:
- Destination: APZDMR-0 (6 bytes address + 1 byte SSID)
- Source: AA0AM-7 (6 bytes address + 1 byte SSID)
- Digipeater 1: WIDE1-1 (7 bytes)
- Digipeater 2: WIDE2-1 (7 bytes, last address bit set)
- Control: 0x03
- PID: 0xF0
- Info: "!DDMM.HHN/DDDMM.HHW$/A=XXXXXX [comment]"
- FCS: CRC-16-CCITT (2 bytes)

Generator adds:
- 0.5s (4000 samples) constant 1200 Hz MARK tone
- 80 × 0x7E flags (no bit stuffing)
- Frame data with bit stuffing
- 10 × 0x7E flags (no bit stuffing)
```

## Transmission Chain

```java
// APRSBeacon.java
short[] audio = AFSKGenerator.generateAFSKWithNRZI(packet);  // 8 kHz mono
byte[] radioAudio = convertMonoToStereoBytes(audio);         // Duplicate L+R channels

// Write to radio in 2048-byte frames every 64ms
while (bytesWritten < radioAudio.length) {
    System.arraycopy(radioAudio, bytesWritten, frame, 0, bytesToWrite);
    XposedHelpers.callMethod(prizeTinyService, "writeFrame", frame, 2048);
    Thread.sleep(64);  // 2048 bytes / 4 bytes per sample / 8000 Hz = 64ms
}
```

## What We Know Works
- ✅ APRS RX: Successfully decodes packets from air (example: BG6LKK-8)
- ✅ TX path: writeFrame() successfully sends audio to radio
- ✅ RF transmission: Carrier present on 144.390 MHz
- ✅ Audio is audible on receivers
- ✅ Packet structure: AX.25 encoding verified (RX uses same structure)

## Critical Questions for Grok

1. **SAMPLES_PER_BIT = 6.666**: Does truncating to `int samplesForBit = 6` cause timing drift? Should we use floating-point accumulation?

2. **NRZI Logic**: Is `bit=0 → toggle frequency` correct, or should it be `bit=1 → toggle`?

3. **Bit Order**: LSB first is correct for AX.25, right?

4. **Phase Continuity**: When frequency changes (NRZI toggle), should phase reset or continue?

5. **Bit Stuffing Placement**: Is recursively calling `transmitBit()` during stuffing correct, or should stuffed bits be queued?

6. **MARK/SPACE Assignment**: Is MARK=1200Hz and SPACE=2200Hz correct for Bell 202?

7. **Frame Timing**: 64ms per frame at 8kHz stereo - is this causing audio speed mismatch?

8. **Stereo Duplication**: Radio expects stereo - is duplicating L+R correct, or should we use left-only?

9. **Sample Rate Reality Check**: Radio codec is 8kHz, but could internal processing expect different rate?

10. **Amplitude**: 50% (16383) - could this be too low for FM deviation?

## Test Results

- **direwolf atest**: 0 packets decoded
- **User feedback**: "sounds very different" (after adding 0.5s carrier + extended preamble)
- **Previous tests**: All variations (25 flags, 100 flags, 48kHz, 8kHz, 64ms, 11ms) failed to decode
- **Known good reference**: Have WAV file from working APRS transmission that decodes correctly

## Request

Please analyze the `generateAFSKWithNRZI()` and `transmitBit()` code and identify:
1. What is fundamentally wrong with the waveform generation?
2. Specific line-by-line fixes needed
3. Why would it sound "very different" from real APRS packets?

The fact that RX works perfectly suggests our AX.25/protocol understanding is correct, so the problem must be in the audio generation itself.

Thank you! 73
