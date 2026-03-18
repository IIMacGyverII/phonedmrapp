# SSTV Image Decoding Problem - Need Help

## What We're Trying to Do

Implement SSTV (Slow Scan Television) image decoding in an Android app that receives FM audio from a DMR radio at **8kHz sample rate, 16-bit mono PCM**.

### Current Status
- ✅ **Phase 1 WORKING**: VIS code detection (100% accuracy using Goertzel algorithm)
- ❌ **Phase 2 BROKEN**: Image decoding (producing mostly black images with scattered RGB pixels)

### Reference Validation
- User's HackRF transmits valid Scottie S2 SSTV signals
- The same WAV file decodes perfectly in colaclanth/sstv Python decoder
- Our VIS detection works perfectly (detects correct mode every time)
- All 256 scan lines are detected and processed
- **Problem**: Pixel brightness extraction is failing

## The Core Challenge

**Sample rate constraint**: 8kHz audio gives us only **~4.37 samples per pixel** for Scottie S2 mode:
- Scottie S2: 320 pixels in 146ms per channel  
- At HackRF's 1.198x slower speed: 1399 samples / 320 pixels = 4.37 samples/pixel
- SSTV frequency range: 1500 Hz (black) to 2300 Hz (white)
- Sync frequency: 1200 Hz

## Approaches Tried (All Failed)

### Attempt 1: Robot36 Phase-Based FM Demodulator (Ported from GitHub)
- **Code**: Ported 8 classes from colaclanth/robot36-c
- **Result**: All black images
- **Problem**: Normalized frequency -9.93 to 9.85 (should be -1 to +1)
- **Conclusion**: Phase-based FM demod produces wrong frequency range

### Attempt 2: FFT Per Pixel (Hann Window)
- **Code**: `SSTVFFTDemodulator.java` with 32-point FFT
- **Result**: All black images  
- **Problem**: Only detected 1000-1180 Hz (below SSTV range 1500-2300 Hz)
- **Conclusion**: FFT has terrible frequency resolution with only 3.6 samples/pixel at 8kHz

### Attempt 3: Goertzel Algorithm Per Pixel
- **Code**: `SSTVGoertzelDemod.java` - same algorithm that gives 100% VIS detection
- **Configurations tried**:
  - Window 32 samples + 13 test frequencies → All black
  - Window 24 samples + 9 test frequencies → All black  
  - Window 20 samples + 17 test frequencies (50 Hz steps) → Scattered RGB pixels
  - Window 16 samples + 9 test frequencies → All black
- **Problems identified**:
  - Threshold normalization mismatch (fixed - samples not normalized to [-1,1])
  - Sync frequency (1200 Hz) was in test array causing negative brightness (fixed)
  - Still producing mostly black with some RGB pixels
- **Current status**: Sync detection works, frequency detection happens, but brightness values mostly 0

### Attempt 4: Goertzel + Quadratic Interpolation (Current)
- **Code**: `SSTVPhaseDemod.java` - 5 coarse frequencies + parabolic interpolation
- **Theory**: Use fewer Goertzel bins (1500, 1700, 1900, 2100, 2300) then interpolate
- **Result**: Still mostly black with scattered RGB pixels
- **Logs show**: Lines 0-2 all report brightness R(0-0) G(0-0) B(0-0)

## Current Code

### Main Image Decoder (SSTVImageDecoder.java - Scottie decode section)

```java
public Bitmap decodeScottie(short[] samples, int startOffset, int actualDurationMs) {
    XposedBridge.log(TAG + ": Starting Scottie decode (" + samples.length + " samples, offset=" + startOffset + ")");
    
    Bitmap bitmap = Bitmap.createBitmap(SCOTTIE_WIDTH, SCOTTIE_HEIGHT, Bitmap.Config.ARGB_8888);
    bitmap.eraseColor(Color.WHITE);
    
    // Create demodulators
    SSTVGoertzelDemod goertzel = new SSTVGoertzelDemod(SAMPLE_RATE);  // For sync detection
    SSTVPhaseDemod demod = new SSTVPhaseDemod(SAMPLE_RATE);  // For pixel brightness (quadratic interpolation)
    
    // Window size - with quadratic interpolation we can use larger windows
    // for better frequency resolution without losing accuracy
    // At 1.198x slower: 1399 samples / 320 pixels = 4.37 samples/pixel
    // Window of 16 samples = ~3.7 pixels span, giving 500 Hz resolution
    // Quadratic interpolation refines this to much better than 500 Hz
    int windowSize = 16;  // 2ms window at 8kHz
    
    XposedBridge.log(TAG + ": Using QuadInterp demod with " + windowSize + " sample window");
    
    // Calculate timing scale from actual measured transmission duration
    float timingScale = actualDurationMs / (float)mode.durationMs;
    int adjustedChannelSamples = (int)(SCOTTIE_CHANNEL_SAMPLES * timingScale);  // 146ms per channel
    int adjustedSyncSamples = (int)(SCOTTIE_SYNC_SAMPLES * timingScale);  // 9ms sync
    int adjustedLineSamples = adjustedSyncSamples + (adjustedChannelSamples * 3);
    
    XposedBridge.log(TAG + ": Timing scale: " + timingScale + "x (" + actualDurationMs + "ms vs " + mode.durationMs + "ms)");
    XposedBridge.log(TAG + ": Adjusted: sync=" + adjustedSyncSamples + ", channel=" + adjustedChannelSamples);
    
    // Storage for RGB channels
    int[] rChannel = new int[SCOTTIE_WIDTH];
    int[] gChannel = new int[SCOTTIE_WIDTH];
    int[] bChannel = new int[SCOTTIE_WIDTH];
    
    int pos = startOffset;
    int currentLine = 0;
    
    // Process each scanline (Scottie: Sync + Green + Blue + Red)
    while (currentLine < SCOTTIE_HEIGHT && pos + adjustedLineSamples < samples.length) {
        // Find sync pulse (9ms at 1200Hz) using Goertzel
        int syncPos = goertzel.findSyncPulse(samples, pos, adjustedSyncSamples * 3, windowSize);
        if (syncPos < 0) {
            XposedBridge.log(TAG + ": No sync at line " + currentLine + ", stopping");
            break;
        }
        
        pos = syncPos + adjustedSyncSamples;  // Move past sync
        
        // Extract Green channel using QuadInterp per pixel
        for (int x = 0; x < SCOTTIE_WIDTH; x++) {
            int samplePos = (int)(pos + (x * adjustedChannelSamples) / (float)SCOTTIE_WIDTH);
            gChannel[x] = demod.extractPixelBrightness(samples, samplePos, windowSize);
        }
        pos += adjustedChannelSamples;
        
        // Extract Blue channel
        for (int x = 0; x < SCOTTIE_WIDTH; x++) {
            int samplePos = (int)(pos + (x * adjustedChannelSamples) / (float)SCOTTIE_WIDTH);
            bChannel[x] = demod.extractPixelBrightness(samples, samplePos, windowSize);
        }
        pos += adjustedChannelSamples;
        
        // Extract Red channel
        for (int x = 0; x < SCOTTIE_WIDTH; x++) {
            int samplePos = (int)(pos + (x * adjustedChannelSamples) / (float)SCOTTIE_WIDTH);
            rChannel[x] = demod.extractPixelBrightness(samples, samplePos, windowSize);
        }
        pos += adjustedChannelSamples;
        
        // Write scanline to bitmap
        for (int x = 0; x < SCOTTIE_WIDTH; x++) {
            int color = Color.rgb(rChannel[x], gChannel[x], bChannel[x]);
            bitmap.setPixel(x, currentLine, color);
        }
        
        // Debug: Log brightness stats for first few lines
        if (currentLine < 3) {
            int minR = 255, maxR = 0, minG = 255, maxG = 0, minB = 255, maxB = 0;
            for (int x = 0; x < SCOTTIE_WIDTH; x++) {
                if (rChannel[x] < minR) minR = rChannel[x];
                if (rChannel[x] > maxR) maxR = rChannel[x];
                if (gChannel[x] < minG) minG = gChannel[x];
                if (gChannel[x] > maxG) maxG = gChannel[x];
                if (bChannel[x] < minB) minB = bChannel[x];
                if (bChannel[x] > maxB) maxB = bChannel[x];
            }
            XposedBridge.log(TAG + ": Line " + currentLine + " brightness: R(" + minR + "-" + maxR + 
                           ") G(" + minG + "-" + maxG + ") B(" + minB + "-" + maxB + ")");
        }
        
        currentLine++;
        
        if (currentLine % 20 == 0) {
            XposedBridge.log(TAG + ": Decoded " + currentLine + "/256 lines");
        }
    }
    
    XposedBridge.log(TAG + ": Scottie decode complete (" + currentLine + " lines)");
    return bitmap;
}
```

### Quadratic Interpolation Demodulator (SSTVPhaseDemod.java)

```java
package com.dmrmod.hooks;

import android.util.Log;

public class SSTVPhaseDemod {
    private static final String TAG = "DMRModHooks-SSTV-QuadInterp";
    
    private static final double BLACK_FREQ = 1500;  // Hz
    private static final double WHITE_FREQ = 2300;  // Hz
    
    private final int sampleRate;
    
    public SSTVPhaseDemod(int sampleRate) {
        this.sampleRate = sampleRate;
        Log.d(TAG, "QuadInterp demod initialized (sample rate: " + sampleRate + " Hz)");
    }
    
    /**
     * Extract pixel brightness using Goertzel + quadratic interpolation
     * Tests coarse frequency grid, then interpolates to find true peak
     */
    public int extractPixelBrightness(short[] samples, int centerPos, int windowSize) {
        int startPos = centerPos - windowSize / 2;
        if (startPos < 0) startPos = 0;
        if (startPos + windowSize > samples.length) {
            startPos = samples.length - windowSize;
        }
        if (startPos < 0 || windowSize < 4) return 0;
        
        // Test frequencies across SSTV range (coarse grid)
        double[] testFreqs = {1500, 1700, 1900, 2100, 2300};
        double[] mags = new double[testFreqs.length];
        
        // Calculate magnitude at each test frequency
        double maxMag = 0;
        int maxIdx = 0;
        for (int i = 0; i < testFreqs.length; i++) {
            mags[i] = goertzel(samples, startPos, windowSize, testFreqs[i]);
            if (mags[i] > maxMag) {
                maxMag = mags[i];
                maxIdx = i;
            }
        }
        
        // Use quadratic interpolation to find true peak between the 3 highest bins
        double peakFreq = testFreqs[maxIdx];
        
        if (maxIdx > 0 && maxIdx < testFreqs.length - 1) {
            // Quadratic interpolation using 3 points around peak
            double y1 = mags[maxIdx - 1];
            double y2 = mags[maxIdx];
            double y3 = mags[maxIdx + 1];
            
            // Parabola vertex: offset = (y1 - y3) / (2 * (y1 - 2*y2 + y3))
            double denom = y1 - 2 * y2 + y3;
            if (Math.abs(denom) > 0.001) {
                double offset = (y1 - y3) / (2 * denom);
                // Clamp offset to [-0.5, 0.5]
                if (offset < -0.5) offset = -0.5;
                if (offset > 0.5) offset = 0.5;
                
                // Interpolate frequency
                double freqStep = testFreqs[maxIdx] - testFreqs[maxIdx - 1];
                peakFreq = testFreqs[maxIdx] + offset * freqStep;
            }
        }
        
        // Convert frequency to brightness
        float brightness = (float)((peakFreq - BLACK_FREQ) * 255.0 / (WHITE_FREQ - BLACK_FREQ));
        if (brightness < 0) brightness = 0;
        if (brightness > 255) brightness = 255;
        
        return Math.round(brightness);
    }
    
    /**
     * Goertzel algorithm for single-frequency detection
     * CRITICAL: Samples NOT normalized (matches VIS detector that works perfectly)
     */
    private double goertzel(short[] samples, int start, int length, double targetFreq) {
        double k = (int)(0.5 + ((length * targetFreq) / sampleRate));
        double omega = (2.0 * Math.PI * k) / length;
        double coeff = 2.0 * Math.cos(omega);
        
        double q0 = 0, q1 = 0, q2 = 0;
        
        for (int i = 0; i < length; i++) {
            q0 = coeff * q1 - q2 + samples[start + i];  // NO normalization
            q2 = q1;
            q1 = q0;
        }
        
        double real = q1 - q2 * Math.cos(omega);
        double imag = q2 * Math.sin(omega);
        return Math.sqrt(real * real + imag * imag) / length;
    }
}
```

### Goertzel Sync Detection (SSTVGoertzelDemod.java - Works Perfectly)

```java
/**
 * Find sync pulse using Goertzel
 * This works perfectly - finds all 256 sync pulses correctly
 */
public int findSyncPulse(short[] samples, int start, int searchLength, int windowSize) {
    int maxSearch = Math.min(samples.length - windowSize, start + searchLength);
    double threshold = 0.3;  // Threshold for 1200 Hz detection
    
    double maxMag = 0;
    int maxPos = -1;
    
    // Search for strong 1200 Hz tone
    for (int i = start; i < maxSearch; i += windowSize / 4) {
        double magnitude = goertzel(samples, i, windowSize, SYNC_FREQ);  // 1200 Hz
        
        if (magnitude > maxMag) {
            maxMag = magnitude;
            maxPos = i;
        }
        
        if (magnitude > threshold) {
            // Verify it stays strong for ~9ms (sync duration)
            int syncLength = (int)(0.009 * sampleRate);
            boolean isSync = true;
            
            for (int j = 0; j < syncLength && (i + j + windowSize) < samples.length; j += windowSize / 2) {
                double checkMag = goertzel(samples, i + j, windowSize, SYNC_FREQ);
                if (checkMag < threshold * 0.3) {  // Allow 70% drop
                    isSync = false;
                    break;
                }
            }
            
            if (isSync) {
                return i;  // Found sync!
            }
        }
    }
    
    return -1;  // No sync found
}
```

## Actual Test Results

**Latest test log output:**
```
Starting Scottie decode (1154048 samples, offset=3880)
Using QuadInterp demod with 16 sample window
Timing scale: 1.1983662x (85084ms vs 71000ms)
Adjusted: sync=86, channel=1399
[... all 256 sync pulses found successfully ...]
Line 0 brightness: R(0-0) G(0-0) B(0-0)
Line 1 brightness: R(0-0) G(0-0) B(0-0)
Line 2 brightness: R(0-0) G(0-0) B(0-0)
Scottie decode complete (256 lines)
Image decoded successfully (320x256)
```

**User reports**: "lots of rgb pixels" but logs show all black (0-0 brightness).

## Questions for Grok

1. **Is our pixel sampling position calculation correct?**
   ```java
   int samplePos = (int)(pos + (x * adjustedChannelSamples) / (float)SCOTTIE_WIDTH);
   ```
   With adjustedChannelSamples=1399, SCOTTIE_WIDTH=320, this gives 4.37 samples per pixel.

2. **Is 16-sample window too long?** 
   - 16 samples at 8kHz = 2ms
   - Each pixel duration = 4.37 samples = 0.546ms
   - Window spans ~3.7 pixels
   - Is this causing pixels to blur together?

3. **Is Goertzel appropriate for SSTV at 8kHz?**
   - Works perfectly for VIS detection (16ms windows, 240 samples)
   - Fails for pixel brightness (2ms windows, 16 samples)
   - Frequency resolution = sampleRate / windowSize = 8000 / 16 = 500 Hz
   - SSTV range is 800 Hz (1500-2300), so 500 Hz resolution seems inadequate

4. **Should we be using a different approach entirely?**
   - The reference Python decoder uses FFT at 22kHz sample rate
   - At 8kHz we don't have enough samples for traditional FFT/Goertzel
   - Maybe we need actual FM demodulation (PLL, phase derivatives)?
   - Or zero-crossing rate analysis?

5. **Why does the reference decoder work?**
   - colaclanth/sstv Python decoder successfully decodes our exact WAV file
   - What algorithm does it use that we should replicate?
   - Can we adapt it for 8kHz constraint?

## What We Need

We need a working algorithm to convert **short[] PCM samples at 8kHz** to **per-pixel brightness (0-255)** for SSTV frequencies (1500-2300 Hz), given only ~4.37 samples per pixel.

The algorithm must be implementable in Java for Android (no native libraries, no complex DSP libraries).

**Help us fix this!**
