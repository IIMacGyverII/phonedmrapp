# Robot36-2 SSTV Decoder Analysis

## Overview
Robot36-2 is a clean, well-engineered SSTV decoder by Ahmet Inan that uses proper signal processing techniques.

## Architecture

### 1. FM Demodulation Approach ⭐ **KEY DIFFERENCE FROM OUR IMPLEMENTATION**

They use **IQ (In-phase/Quadrature) Baseband Demodulation** instead of FFT:

```
Audio Input (8kHz PCM)
  ↓
Multiply by Complex Oscillator @ -1900 Hz (center frequency)
  ↓ (shifts spectrum: 1500-2300 Hz → -400 to +400 Hz)
Complex Low-Pass Filter (Kaiser windowed FIR, cutoff ~700 Hz)
  ↓ (removes high frequencies, keeps baseband signal)
Extract Phase: atan2(imag, real)
  ↓
Compute Phase Difference: Δphase = phase[n] - phase[n-1]
  ↓
Scale to Frequency: freq = Δphase * sampleRate / (bandwidth * π)
  ↓
Normalized Frequency Output: -1.0 (black) to +1.0 (white)
```

**Key Files:**
- `Demodulator.java` - Orchestrates demodulation and sync detection
- `FrequencyModulation.java` - Phase difference to frequency conversion
- `Phasor.java` - Complex oscillator (NCO)
- `ComplexConvolution.java` - FIR filter for baseband signal
- `Complex.java` - Complex number arithmetic

**Critical Parameters:**
```java
centerFrequency = 1900 Hz        // Midpoint of SSTV range
lowestFrequency = 1000 Hz        // Below black level
highestFrequency = 2800 Hz       // Above white level
cutoffFrequency = 700 Hz         // Baseband LPF cutoff
scanLineBandwidth = 800 Hz       // White - Black (2300 - 1500)
```

**Why This Works Better:**
1. **No FFT windowing artifacts** - direct phase tracking
2. **Better time resolution** - per-sample frequency estimation
3. **Automatic frequency offset handling** - baseband approach inherently robust
4. **More CPU efficient** - no FFT, just multiplication and filtering

### 2. Sync Pulse Detection

**Process:**
1. Apply moving average filter (2.5ms window) to smooth demodulated signal
2. Use Schmitt trigger for noise-immune sync detection:
   - Low threshold: normalized 1350 Hz
   - High threshold: normalized 1500 Hz  
   - Hysteresis prevents chatter on noisy signals
3. Measure pulse width and classify:
   - 2.5-7ms → 5ms sync (Martin, Wraase modes)
   - 7-14.5ms → 9ms sync (Robot, Scottie modes)
   - 14.5-25ms → 20ms sync (PaulDon modes)

**Key Files:**
- `SchmittTrigger.java` - Hysteresis comparator
- `SimpleMovingAverage.java` - Smoothing filter
- `Delay.java` - Compensate for filter delay

### 3. Mode Detection (Auto-Detection)

**Two-Stage Detection:**

#### Stage 1: VIS Code Detection (`handleHeader()` method)
```
Leader Tone: 1900 Hz for 300ms
  ↓
Break: 1200 Hz for 10ms
  ↓
Leader Tone: 1900 Hz for 300ms
  ↓
VIS Code: 10 bits @ 30ms each
  - Start bit: 1200 Hz
  - 8 data bits: 1100 Hz (1) or 1300 Hz (0)
  - Stop bit: 1200 Hz
  ↓
Parity Check: XOR of 8 bits
  ↓
Look up mode by VIS code
```

**VIS Code Examples:**
- Robot 36: code 8
- Scottie 1: code 60
- Scottie 2: code 56
- Martin 1: code 44

#### Stage 2: Sync-Based Auto-Detection
When VIS code missing or unrecognized:
1. Track last 4-5 sync pulses
2. Calculate mean scan line duration
3. Check consistency (std deviation < tolerance)
4. Find mode with closest matching scan line duration
5. Verify mode consistency over multiple lines

**Auto-detection Parameters:**
```java
scanLineMinSamples = 0.05s * sampleRate     // 50ms minimum
syncPulseToleranceSamples = 0.03s           // 30ms tolerance
scanLineToleranceSamples = 0.001s           // 1ms timing tolerance
```

### 4. Frequency Offset Correction ⭐ **CRITICAL FOR ACCURACY**

**Problem:** Transmitter and receiver oscillators may drift

**Solution:** Automatic frequency calibration
1. Measure actual sync pulse frequency (should be 1200 Hz)
2. Calculate offset: `freqOffset = measuredFreq - 1200Hz`
3. Apply correction in brightness conversion:
   ```java
   float freqToLevel(float frequency, float offset) {
       return 0.5f * (frequency - offset + 1.f);
   }
   ```

**Why This Matters:**
- Typical drift: ±50 Hz or more
- Without correction: brightness values wrong → image too dark/bright
- With correction: compensates for hardware differences

### 5. Image Decoding - Scottie S2 Example

**From `RGBModes.Scottie()` factory:**
```java
syncPulseSeconds = 0.009         // 9ms
separatorSeconds = 0.0015        // 1.5ms  
channelSeconds = 0.088064        // Variable per mode

Timing Structure:
Line N-1: ... GREEN (88ms) | SEP (1.5ms) | BLUE (88ms) | SEP (1.5ms)
Line N:   SYNC (9ms) | SEP (1.5ms) | RED (88ms) | SEP (1.5ms) | ...

Notice: Scottie has peculiar timing where RGB spans sync pulses!
```

**Decoding Process (RGBDecoder.decodeScanLine()):**
1. Apply exponential moving average low-pass filter to scan line
2. Reverse filter (backward pass) for zero-phase filtering
3. Convert normalized frequency to brightness level
4. Sample at pixel positions: `pos = beginSamples + (i * channelSamples) / horizontalPixels`
5. Pack RGB into 32-bit ARGB: `0xff000000 | (R << 16) | (G << 8) | B`

### 6. Key Data Structures

**Mode Interface:**
```java
interface Mode {
    String getName();
    int getVISCode();
    int getWidth(), getHeight();
    int getFirstPixelSampleIndex();
    int getFirstSyncPulseIndex();
    int getScanLineSamples();
    boolean decodeScanLine(...);
    void resetState();
    Bitmap postProcessScopeImage(Bitmap bmp);
}
```

**PixelBuffer:**
- Simple container: `int[] pixels`, `int width`, `int height`
- Decoded scan line(s) stored here temporarily
- Copied to scope buffer (waterfall) and image buffer (final image)

### 7. Signal Processing Utilities

**ExponentialMovingAverage:**
- Configurable IIR low-pass filter
- Much more efficient than FIR for smoothing
- Can configure cutoff frequency dynamically
- Used for final pixel smoothing

**ComplexConvolution:**
- FIR filter operating on complex samples
- Kaiser window for excellent frequency response
- Used for baseband low-pass filtering

**SimpleMovingSum:**
- Efficient moving sum using binary tree structure
- O(log N) update time instead of O(N)
- Used for fast sync pulse filtering

### 8. How to Port to Our System

**Step 1: Create Helper Classes**
- Complex.java → SSTVComplex.java
- Phasor.java → SSTVPhasor.java  
- ComplexConvolution.java → SSTVComplexConvolution.java
- FrequencyModulation.java → SSTVFrequencyModulation.java
- SchmittTrigger.java, Delay.java, filters

**Step 2: Replace Demodulator**
- Replace SSTVFFTDemodulator with SSTVIQDemodulator
- Use baseband conversion approach
- Output normalized frequency values [-1, +1]

**Step 3: Implement Sync Detection**
- Add moving average smoothing
- Add Schmitt trigger sync detector
- Classify sync pulse width (5ms/9ms/20ms)

**Step 4: Improve Mode Detection**
- Keep existing VIS detection (it works!)
- Add sync-based auto-detection as fallback
- Implement frequency offset correction

**Step 5: Update Image Decoder**
- Change brightness mapping to use normalized frequencies
- Add exponential moving average for pixel smoothing
- Implement proper RGB channel timing for each mode

**Step 6: Integration**
- SSTVReceiver feeds audio → SSTVIQDemodulator
- Demodulator detects sync → feeds to SSTVImageDecoder
- Decoder extracts pixels → writes to Bitmap

## Critical Lessons Learned

### Why Our FFT Approach Failed:
1. **500 Hz frequency offset** - FFT detected 1000-2279 Hz instead of 1500-2300 Hz
   - Likely caused by DMR radio hardware frequency shift
   - Or sample rate not exactly 8000 Hz
2. **FFT windowing** - 64-sample window has 125 Hz resolution (too coarse)
3. **No frequency offset correction** - assumed exact frequencies
4. **Poor time resolution** - FFT window means averaging over 8ms

### Why IQ Demodulation Works:
1. **Per-sample frequency tracking** - much better time resolution
2. **Baseband approach** - frequency offset becomes DC offset (easy to remove)
3. **Phase-based** - more accurate than magnitude-based FFT
4. **Simple and efficient** - just complex multiply + filter + phase diff

### The "Simple Thing We Were Missing":
The user was right - we were overcomplicating it! The key insights:
1. Use **phase-based FM demodulation** (phase difference), not FFT magnitude
2. **Normalize frequencies** to [-1, +1] range in demodulator
3. **Measure and correct** frequency offset from sync pulses
4. Keep it **per-sample**, not windowed

## References
- Robot36-2 source: https://github.com/xdsopl/robot36-2
- Author: Ahmet Inan <xdsopl@gmail.com>
- License: Check original repository
