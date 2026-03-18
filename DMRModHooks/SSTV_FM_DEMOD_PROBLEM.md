# SSTV FM Demodulation Problem - Analysis for Expert Review

**Date:** March 15, 2026  
**Status:** VIS detection 100% working, Image decode producing only noise

---

## Current Situation

### What Works Perfectly ✅
- **VIS (mode) detection**: 100% success rate using Goertzel algorithm
- **Sync pulse detection**: All 256 sync pulses found correctly (1200 Hz)
- **Per-line timing detection**: Measures actual sync-to-sync distance (consistently 1.194x)
- **Audio capture**: 8kHz 16-bit mono PCM from radio hardware
- **Reference validation**: Same WAV file decodes perfectly in colaclanth/sstv Python decoder

### What Doesn't Work ❌
- **Image decode**: Produces only horizontal lines of random RGB noise
- **Actual visual**: "predominantly black background with thin horizontal lines of multicolored noise (red, green, blue, cyan, magenta, yellow, white) in short wavy streaky segments, no recognizable shapes or content"
- **Diagnosis**: Not demodulating the FM signal - just detecting random frequencies

---

## Technical Environment

**Platform:** Android LSPosed Module (Java 8)  
**Sample Rate:** 8kHz 16-bit mono PCM  
**Signal:** SSTV Scottie S2 (320x256, RGB, 71 seconds)  
**SSTV Frequencies:** 1500 Hz (black) to 2300 Hz (white), 800 Hz range  
**Samples per pixel:** ~4.37 samples (very constrained!)

**Key Constraint:** Cannot use external libraries - must implement demodulation in pure Java 8

---

## What We've Tried (in chronological order)

### Approach 1-5: Custom Phase-Based Demodulators (FAILED)
- Implemented 5 different phase tracking algorithms
- Result: All produced all-black or all-white images
- Lesson: Phase tracking needs fine-tuning we didn't achieve

### Approach 6: Robot36 FM Demodulator Port (FAILED)
- Ported 8 classes from colaclanth/robot36-c GitHub project
- Phase-based FM demod using atan2
- Result: Detected wrong frequency range (-9.93 to 9.85 Hz, not SSTV range)
- Lesson: Direct port didn't adapt to our signal characteristics

### Approach 7: FFT Per-Pixel (FAILED)
- Used FFT to detect frequency in small windows
- Result: Detected 1000-1180 Hz (below SSTV 1500-2300 Hz)
- Lesson: Poor frequency resolution at 8kHz with short windows

### Approach 8: Zero-Crossing Rate Demodulator (FAILED)
- Counted zero crossings to estimate frequency
- Result: Detected 500-1000 Hz (way too low)
- Lesson: Zero-crossing doesn't work well for SSTV FM at 8kHz

### Approach 9: Goertzel with Multiple Configurations (CURRENT - PRODUCES NOISE)
- Tests 17 discrete frequencies (1500-2300 Hz in 50 Hz steps)
- Finds peak magnitude to determine brightness
- **Critical fixes applied:**
  - Removed sample normalization (was dividing by 32768)
  - Removed 1200 Hz sync from test frequencies
  - **Fractional k values** (no integer rounding): `k = (length * freq) / sampleRate`
  - Per-line adaptive brightness (stretch detected range to 0-255)
  - Window size reduced from 32 → 24 → 16 → 8 samples
  - Per-line timing detection from sync-to-sync measurements

- **Current parameters:**
  - Window: 8 samples (1ms, spans 1.8 pixels)
  - Timing: 1.193x base (measured per-line)
  - Test freqs: 1500, 1550, 1600... 2300 Hz (17 frequencies)

- **Result:** VIS works perfectly, sync detection perfect, BUT image is just random colored noise
- **Detected frequency range:** 1500-2100 Hz (per logs) - narrower than expected 1500-2300 Hz

---

## Root Cause Analysis

### The Fundamental Problem
**Goertzel detects "which discrete frequency is strongest" but doesn't capture continuous frequency modulation.**

SSTV is **FM (frequency modulated)** - the signal continuously sweeps between frequencies. Within an 8-sample window:
- Black pixel (1500 Hz): 12 cycles in 8ms (at 8kHz that's only 0.096 cycles per sample!)
- White pixel (2300 Hz): 18.4 cycles in 8ms

With only ~4.37 samples per pixel, we're trying to detect frequency changes across windows that barely contain ONE cycle. Goertzel tells us "1650 Hz is strongest" but doesn't tell us the **instantaneous frequency** of the FM signal.

### Why Reference Decoder Works
The colaclanth/sstv Python decoder:
1. Uses proper **FM demodulation** (phase-based with Hilbert transform + atan2)
2. Tracks **instantaneous frequency** continuously
3. Doesn't rely on discrete frequency bins
4. Decodes our exact WAV perfectly as Scottie S2

### Debug Evidence
From logs - first 3 pixels show distinct magnitudes (fractional k working):
```
Pixel 0: 1500=597.3, 1550=431.6, 1600=259.9 (all different)
```
But the peak frequency chosen is essentially random because we're not actually demodulating FM - we're just finding "which bin has most energy" in a tiny window.

---

## Options Moving Forward

### Option 1: Proper Phase-Based FM Demodulator ⭐ RECOMMENDED
**Approach:** Implement continuous FM demod using phase tracking (atan2 method)

**How it works:**
```java
// For each sample:
1. Convert to complex (I/Q) using Hilbert transform or simple delay
2. Calculate phase: φ[n] = atan2(Q[n], I[n])
3. Phase difference: Δφ = φ[n] - φ[n-1]
4. Instantaneous frequency: f = (Δφ / 2π) * sampleRate
5. Map frequency (1500-2300 Hz) to brightness (0-255)
```

**Pros:**
- Standard approach used by all working SSTV decoders
- Tracks instantaneous frequency (not discrete bins)
- Should work at 8kHz if implemented correctly
- We already tried this but may have had bugs

**Cons:**
- Need to implement Hilbert transform or IQ delay
- May need careful tuning of phase unwrapping
- Previous attempts failed (but we've learned more)

**Effort:** 1-2 hours to implement properly

---

### Option 2: Audio Upsampling Before Demodulation
**Approach:** Upsample 8kHz → 16kHz or 48kHz, then use standard FM demod

**How it works:**
```java
1. Interpolate samples (linear or cubic) to higher rate
2. Apply anti-aliasing filter
3. Use standard FM demod with more samples per pixel
4. Better frequency resolution and temporal precision
```

**Pros:**
- More samples per pixel (8kHz=4.37, 16kHz=8.74, 48kHz=26.2)
- Easier to implement standard algorithms
- Reduces impact of quantization

**Cons:**
- Computationally expensive (3-6x more samples to process)
- Adds interpolation artifacts
- Still need proper FM demod algorithm

**Effort:** 2-3 hours (upsampling + FM demod)

---

### Option 3: Continuous Goertzel Sliding Window
**Approach:** Use overlapping Goertzel windows with longer duration to track frequency trajectory

**How it works:**
```java
1. Use 32-64 sample Goertzel window (longer than current 8)
2. Slide window by 1-2 samples (heavy overlap)
3. Track which frequency bin peaks across trajectory
4. Interpolate between peaks to estimate continuous frequency
```

**Pros:**
- Incremental improvement to current approach
- Better frequency resolution with longer windows
- Might capture frequency transitions better

**Cons:**
- Still fundamentally discrete bin detection
- Longer windows = more blur (defeats recent 8-sample improvement)
- May still produce noise if FM demod is truly needed
- Computationally expensive (many overlapping Goertzels)

**Effort:** 1 hour to modify current code

---

### Option 4: STFT (Short-Time Fourier Transform) Spectrogram Approach
**Approach:** Generate spectrogram and track peak frequency over time

**How it works:**
```java
1. Compute STFT with overlapping windows
2. For each time slice, find peak frequency in 1500-2300 Hz
3. Track peak trajectory over time
4. Map to brightness values
```

**Pros:**
- Well-established DSP technique
- Visualizable (can debug via spectrogram)
- Handles noise better than single-bin detection

**Cons:**
- Computationally expensive
- Time-frequency resolution tradeoff (Heisenberg)
- Still may not work at 8kHz with 4.37 samples/pixel
- Complex to implement from scratch

**Effort:** 3-4 hours

---

### Option 5: Hybrid Goertzel + Phase Interpolation
**Approach:** Use Goertzel to get rough frequency bin, then interpolate using phase

**How it works:**
```java
1. Goertzel finds which 50 Hz bin (e.g., 1650 Hz)
2. Run Goertzel on adjacent bins (1600, 1700 Hz)
3. Use magnitude ratios + phase to interpolate exact frequency
4. Apply quadratic or parabolic interpolation
```

**Pros:**
- Combines strengths of both approaches
- Less computational than full STFT
- More accurate than pure Goertzel

**Cons:**
- Still relies on Goertzel which may be fundamentally wrong for FM
- Complex interpolation logic
- May not solve core problem

**Effort:** 2 hours

---

## Recommended Path Forward

### Primary Recommendation: **Option 1 - Proper Phase-Based FM Demodulator**

**Rationale:**
1. This is what **actually works** in the reference decoder
2. We've exhausted discrete frequency detection approaches
3. FM demodulation is fundamentally different from frequency detection
4. Standard approach in all working SSTV decoders

**Implementation Strategy:**
```java
class SSTVPhaseDemodulator {
    private double prevPhase = 0;
    private double prevI = 0, prevQ = 0;
    
    // Simple IQ using delay (avoid Hilbert complexity)
    public int demodulate(short[] samples, int pos, int length) {
        double sumFreq = 0;
        int count = 0;
        
        for (int i = pos; i < pos + length; i++) {
            double sample = samples[i];
            
            // Simple quadrature: Q is delayed I
            double I = sample;
            double Q = (i > 0) ? samples[i-1] : prevQ;
            
            // Phase from atan2
            double phase = Math.atan2(Q, I);
            
            // Phase difference (unwrap if needed)
            double phaseDiff = phase - prevPhase;
            if (phaseDiff > Math.PI) phaseDiff -= 2 * Math.PI;
            if (phaseDiff < -Math.PI) phaseDiff += 2 * Math.PI;
            
            // Instantaneous frequency
            double freq = (phaseDiff / (2 * Math.PI)) * 8000;
            
            sumFreq += freq;
            count++;
            prevPhase = phase;
        }
        
        double avgFreq = sumFreq / count;
        
        // Map 1500-2300 Hz to 0-255 brightness
        int brightness = (int)((avgFreq - 1500) * 255 / 800);
        if (brightness < 0) brightness = 0;
        if (brightness > 255) brightness = 255;
        
        return brightness;
    }
}
```

**Next Steps:**
1. Implement phase-based FM demod with simple IQ delay
2. Test on known SSTV WAV (not live transmission first)
3. Debug frequency detection vs reference decoder
4. Add phase unwrapping and filtering if needed
5. Optimize window size for 8kHz constraints

---

## Questions for Expert Review

1. **Is Goertzel fundamentally wrong for FM demodulation?**
   - Can discrete frequency bin detection ever work for continuous FM?
   - Or do we need true instantaneous frequency tracking?

2. **Why does Goertzel work perfectly for VIS detection but fails for image decode?**
   - VIS is FSK (discrete frequency shifts): 1100 Hz or 1300 Hz
   - Image is FM (continuous sweep): 1500-2300 Hz
   - Is this the key difference?

3. **At 8kHz with 4.37 samples/pixel, what's the best demodulation strategy?**
   - Phase-based (atan2)?
   - Upsampling first?
   - Something else entirely?

4. **Reference decoder succeeds - what's it doing differently?**
   - colaclanth/sstv uses scipy.signal.hilbert + phase tracking
   - Can we replicate this in pure Java without scipy?

5. **Why did our previous phase-based attempts fail?**
   - Wrong IQ generation?
   - Phase unwrapping bugs?
   - Incorrect frequency calculation from phase difference?

---

## Reference Materials

**Working Reference Decoder:**
- Repository: https://github.com/colaclanth/sstv
- Method: Hilbert transform → complex signal → atan2 phase → frequency
- Our WAV decodes perfectly in this tool (Scottie S2, 320x256)

**Robot36 Port (attempted):**
- Repository: https://github.com/xdsopl/robot36
- 8 classes ported: AudioInput, AudioResampler, Calibrate, Container, Decoder, Processor, SchemeTable, WindowFunction
- Result: Wrong frequency range detected

**Current Logs:**
- VIS detection: 100% (Goertzel works!)
- Sync detection: 256/256 found (Goertzel works!)
- Timing: Consistent 1.194x across all lines (perfect!)
- Frequency range: 1500-2100 Hz detected (narrower than 1500-2300 Hz expected)
- Image: Random colored noise, no recognizable content

---

## Summary

We've successfully implemented VIS detection, sync detection, timing correction, and per-line adaptive brightness using Goertzel. However, the fundamental approach of **discrete frequency bin detection appears incompatible with FM demodulation**.

The reference decoder proves our signal is valid. We need to pivot to **continuous instantaneous frequency tracking** (phase-based FM demod) instead of discrete frequency bins (Goertzel).

**Primary ask:** Guidance on implementing phase-based FM demodulation at 8kHz sample rate in pure Java 8, or alternative approaches that would work better than Goertzel for continuous FM.
