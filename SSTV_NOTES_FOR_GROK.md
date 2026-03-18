# SSTV Implementation Project - Technical Notes for Grok

**Date:** March 15, 2026  
**Project:** SSTV (Slow Scan Television) receiver implementation for Android DMR radio  
**Status:** Phase 1 (VIS Code Detection) - Debugging signal quality issues

---

## What We're Trying To Do

Implement SSTV image reception in an Android DMR radio app using Xposed hooks. The implementation follows the same architecture as the existing APRS packet decoder.

### Architecture Overview
- **Platform:** Android LSPosed module (Xposed framework)
- **Language:** Java 8
- **Audio Source:** PCM audio hook at 8kHz 16-bit mono (from `PCMReceiveManager.writeAudioTrack()`)
- **Integration Point:** `MainHook.java` - hooks into DMR radio app (`com.pri.prizeinterphone`)

### Phase 1 Goal: VIS Code Detection
The VIS (Vertical Interval Signaling) code identifies which SSTV mode is being transmitted. Structure:
```
Leader tone:    1900 Hz for 300ms  (bit sync)
Break tone:     1200 Hz for 10ms
Start bit:      1900 Hz for 30ms
Data bits (7):  1100 Hz = 0, 1300 Hz = 1 (30ms each, LSB first)
Parity bit:     1100/1300 Hz for 30ms (even parity)
Stop bit:       1200 Hz for 30ms
```

**VIS codes we support:**
- 0x08 = Robot 36 (priority mode)
- 0x38 = Scottie S2 (56 decimal)
- 0x3C = Scottie S1 (60 decimal)
- 0x2C = Martin M1 (44 decimal)
- 0x28 = Martin M2 (40 decimal)

---

## Technical Implementation

### Files Created
1. **SSTVMode.java** - VIS code database and mode parameters
2. **SSTVVISDetector.java** - Goertzel-based tone detector for VIS decoding
3. **SSTVReceiver.java** - Audio buffer manager and VIS detection coordinator
4. **MainHook.java** (modified) - Integration with radio app (+350 lines)

### Detection Algorithm (Goertzel)
Using Goertzel algorithm for efficient single-frequency tone detection:
```java
// Goertzel coefficient calculation
float k = (int)(0.5 + ((length * frequency) / sampleRate));
float w = (2.0f * Math.PI * k) / length;
float cosine = Math.cos(w);
float coeff = 2.0f * cosine;

// Process samples
for (int i = 0; i < length; i++) {
    q0 = coeff * q1 - q2 + samples[start + i];
    q2 = q1;
    q1 = q0;
}

// Calculate magnitude
float real = q1 - q2 * cosine;
float imag = q2 * Math.sin(w);
float magnitude = Math.sqrt(real * real + imag * imag) / length;
```

**Detection threshold:** `GOERTZEL_THRESHOLD = 10.0f`  
**Sample rate:** 8000 Hz  
**Bit duration:** 240 samples (30ms @ 8kHz)

### UI Implementation
- SSTV button in packet radio menu (purple, 0xFF6B5FD9)
- Live monitoring dialog with:
  - Software squelch toggle (green/gray)
  - Squelch slider (0-9) with live value display
  - Signal strength indicator (RSSI display)
  - VIS detection status updates (1-second refresh)

### Audio Path
```
HackRF SDR (144.500 MHz FM)
    ↓
DMR Radio (FM demodulator)
    ↓
PCMReceiveManager.writeAudioTrack() hook
    ↓
SSTVReceiver.processAudio() - buffers to 3MB circular buffer
    ↓
SSTVVISDetector.detectVIS() - Goertzel tone analysis
    ↓
SSTVMode.getModeByVIS() - identify mode
```

---

## Current Problem: VIS Detection Accuracy

### Test Setup
- **Transmitter:** HackRF SDR
- **Mode:** Scottie S2 (VIS code should be **0x38**)
- **Frequency:** 144.500 MHz FM
- **User reports:** "Signal is clean and generates good SSTV at Scottie 2"

### What We're Detecting
**Actual detection:** 0x20 (binary: 0000010)  
**Expected:** 0x38 (binary: 0111000)

### Detailed Goertzel Analysis (from logs)
```
Bit 0: 1100Hz: 219.19 | 1300Hz: 87.23  → Decision: 0 ✓ CORRECT
Bit 1: 1100Hz: 219.50 | 1300Hz: 85.56  → Decision: 0 ✓ CORRECT
Bit 2: 1100Hz: 117.86 | 1300Hz: 66.00  → Decision: 0 ✓ CORRECT
Bit 3: 1100Hz:   1.60 | 1300Hz:  1.58  → Decision: 0 ✗ WRONG (signal dropout!)
Bit 4: 1100Hz:  36.42 | 1300Hz: 19.37  → Decision: 0 ✗ WRONG (weak signal)
Bit 5: 1100Hz: 120.07 | 1300Hz: 127.13 → Decision: 1 ✓ CORRECT
Bit 6: 1100Hz: 117.46 | 1300Hz: 36.93  → Decision: 0 ✓ CORRECT
```

**Expected bit pattern for 0x38 (Scottie S2):**  
`0, 0, 0, 1, 1, 1, 0` (LSB first)

**What we're getting:**  
`0, 0, 0, 0, 0, 1, 0` (LSB first)

### Root Cause Analysis
**Bits 3 and 4 have signal dropouts:**
- Bit 3: Both tones extremely weak (1.6 vs normal 120-220)
- Bit 4: Weak signals (36 vs normal 120-220)
- Bits 0, 1, 2, 5, 6: All decode correctly with strong magnitudes

**Possible causes:**
1. **HackRF timing issue** - Gaps in transmission between bits 2→3→4
2. **FM path distortion** - Radio's FM demodulator dropping signal during those bits
3. **Squelch tail** - Hardware squelch cutting in/out (but we use squelch=2 which should be wide open)
4. **Sample timing offset** - We might be sampling between tones during bit transitions

### What Works Well
- Leader tone detection (1900Hz): magnitude 26.67 ✓
- Break tone detection (1200Hz): magnitude 370.76 ✓
- Start bit (1900Hz): magnitude 35.44 ✓
- Goertzel algorithm accurately measures frequencies
- 5 out of 7 bits decode perfectly with strong signals

---

## Tools and Technologies Used

### Development Environment
- **IDE:** VS Code
- **Build System:** Gradle 8.1.0
- **Android SDK:** compileSdk 34
- **Java:** Source/target compatibility 8
- **LSPosed:** Xposed framework for Android (module injection)

### Testing Tools
- **ADB:** Android Debug Bridge for logcat and APK installation
- **HackRF SDR:** SSTV signal transmission
- **Logcat:** Real-time debugging (`adb logcat -d | Select-String -Pattern "SSTV-VIS"`)

### Key Dependencies
- **Xposed Bridge API:** `XposedHelpers`, `XposedBridge` for hooking
- **Android UI:** `AlertDialog`, `SeekBar`, `ToggleButton` for monitoring interface
- **APRSDatabase:** SharedPreferences wrapper for settings persistence

### Reference Implementation
- **Robot36 Android app** (github.com/xdsopl/robot36) - Cloned for FM demodulator reference
- **APRS decoder** (existing in MainHook.java) - Architecture blueprint

---

## Next Steps / Questions for Investigation

### Option 1: Improve Signal Acquisition
- [ ] Add pre-filtering (bandpass 1000-2500 Hz) before Goertzel
- [ ] Implement bit synchronization (resample to exact 30ms boundaries)
- [ ] Add AGC (automatic gain control) normalization
- [ ] Try averaging multiple Goertzel windows per bit

### Option 2: Test with Different Sources
- [ ] Test with clean WAV file (eliminate HackRF variables)
- [ ] Try different SSTV software (QSSTV, MMSSTV)
- [ ] Test Robot 36 mode (0x08) instead of Scottie S2
- [ ] Record audio to file for offline analysis

### Option 3: Improve Decoder Robustness
- [ ] Add signal strength validation (reject bits with magnitude < 50)
- [ ] Implement multi-pass detection (scan entire buffer, pick strongest VIS)
- [ ] Add bit timing calibration (learn actual bit duration from signal)
- [ ] Try error correction (Hamming distance from known VIS codes)

### Current Hypothesis
The HackRF transmission may have timing issues or the FM path through the radio is introducing dropouts. The Goertzel detector is working correctly (proven by 5/7 bits decoding perfectly), but the audio signal has quality problems specifically at bits 3-4.

---

## Code Locations

### Key Files
- `DMRModHooks/app/src/main/java/com/dmrmod/hooks/SSTVMode.java`
- `DMRModHooks/app/src/main/java/com/dmrmod/hooks/SSTVVISDetector.java`
- `DMRModHooks/app/src/main/java/com/dmrmod/hooks/SSTVReceiver.java`
- `DMRModHooks/app/src/main/java/com/dmrmod/hooks/MainHook.java`

### Key Methods
- `SSTVVISDetector.detectVIS()` - Main VIS detection entry point
- `SSTVVISDetector.goertzelMagnitude()` - Single-frequency detector
- `SSTVVISDetector.decodeBit()` - Compare 1100Hz vs 1300Hz magnitudes
- `MainHook.startSSTVMonitoring()` - Hijack channel to 144.500 MHz
- `MainHook.updateSSTVLiveScreen()` - Live monitoring UI updates

### Debug Logging
All VIS detection steps logged with tag: `DMRModHooks-SSTV-VIS`
```bash
adb logcat -d | Select-String -Pattern "SSTV-VIS"
```

---

## Questions for Debugging

1. **Is the HackRF generating consistent timing between bits?** The dropout at bits 3-4 suggests a timing gap.

2. **Should we lower the detection threshold?** Current threshold is 10.0, but bit 4 only reaches 36.

3. **Is the FM demodulator in the radio introducing distortion?** 5/7 bits are clean, suggesting partial signal loss.

4. **Should we implement bit averaging?** Take multiple Goertzel measurements across each 30ms bit window and average them.

5. **Could this be a squelch issue?** Even though we set squelch=2 (wide open), the firmware might still be gating audio.

6. **Should we try error correction?** Calculate Hamming distance to known VIS codes and pick the closest match?

---

## Possible Solutions

### Solution 1: Signal Strength Threshold
Reject bits with magnitude < 50 as "unreliable" and retry detection:
```java
if (mag0 < MIN_SIGNAL_STRENGTH && mag1 < MIN_SIGNAL_STRENGTH) {
    // Signal too weak, retry or skip
    return -1;  // Invalid bit
}
```

### Solution 2: Multi-Window Averaging
Sample each bit multiple times and average:
```java
// Take 3 samples across the 30ms window
float mag0_avg = (goertzel(pos) + goertzel(pos+80) + goertzel(pos+160)) / 3.0f;
float mag1_avg = (goertzel(pos) + goertzel(pos+80) + goertzel(pos+160)) / 3.0f;
```

### Solution 3: Error Correction
Find closest matching VIS code using Hamming distance:
```java
int[] knownCodes = {0x08, 0x0C, 0x2C, 0x28, 0x3C, 0x38};
int bestMatch = findClosestVIS(detectedCode, knownCodes);  // Max 1-bit difference
```

### Solution 4: Bandpass Pre-Filter
Filter audio to 1000-2500 Hz before Goertzel:
```java
// Simple FIR bandpass filter
short[] filtered = applyBandpassFilter(samples, 1000, 2500, sampleRate);
```

---

**Status:** Waiting for clean test signal or different transmission method to isolate whether issue is in HackRF/FM path or detector algorithm.

**Next Test:** User should try transmitting Robot 36 (simpler mode) or use a different SSTV software to verify HackRF setup.
