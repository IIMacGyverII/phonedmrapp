package com.example.dmrmodhooks.sstv;

import android.util.Log;

/**
 * Phase Differentiator FM Demodulator for SSTV
 * 
 * Implements continuous instantaneous frequency tracking using:
 * 1. Analytic signal generation (real + imaginary via Hilbert transform)
 * 2. Phase computation (atan2)
 * 3. Phase unwrapping (handle >π jumps)
 * 4. Frequency from phase derivative
 * 
 * This is the standard approach used by working SSTV decoders.
 * Unlike Goertzel (discrete frequency bins), this tracks continuous FM modulation.
 */
public class SSTVPhaseDemod {
    private static final String TAG = "SSTVPhaseDemod";
    
    private final float sampleRate;
    private final float centerFreq = 1900.0f;  // SSTV center frequency
    private final float scale;  // sampleRate / (2π) for freq calculation
    
    // 7-tap FIR Hilbert transform coefficients (90° phase shift at ~1900 Hz)
    // These approximate the imaginary component for analytic signal
    private static final float[] HILBERT_COEFFS = {
        0.0f, -0.4f, 0.0f, 0.0f, 0.0f, 0.4f, 0.0f
    };
    private static final int HILBERT_DELAY = HILBERT_COEFFS.length / 2;
    
    public SSTVPhaseDemod(float sampleRate) {
        this.sampleRate = sampleRate;
        this.scale = sampleRate / (2.0f * (float) Math.PI);
    }
    
    /**
     * Demodulate FM signal to get brightness value for a single pixel.
     * 
     * @param samples PCM samples (16-bit)
     * @param startPos Start position in samples array
     * @param windowSize Number of samples to analyze for this pixel
     * @return Brightness 0-255 based on frequency (1500 Hz = 0, 2300 Hz = 255)
     */
    public int demodulatePixel(short[] samples, int startPos, int windowSize) {
        if (windowSize < 2) return 0;
        
        // Ensure we have enough samples for Hilbert transform
        int effectiveStart = Math.max(0, startPos - HILBERT_DELAY);
        int effectiveLength = windowSize + HILBERT_DELAY;
        if (effectiveStart + effectiveLength > samples.length) {
            effectiveLength = samples.length - effectiveStart;
        }
        if (effectiveLength < windowSize) return 0;
        
        // Step 1: Create analytic signal (real + imaginary)
        float[] real = new float[effectiveLength];
        float[] imag = new float[effectiveLength];
        
        // Normalize PCM to [-1, 1]
        for (int i = 0; i < effectiveLength; i++) {
            real[i] = samples[effectiveStart + i] / 32768.0f;
        }
        
        // Apply Hilbert transform (FIR convolution) for imaginary component
        for (int i = HILBERT_DELAY; i < effectiveLength - HILBERT_DELAY; i++) {
            float sum = 0.0f;
            for (int j = 0; j < HILBERT_COEFFS.length; j++) {
                sum += real[i - HILBERT_DELAY + j] * HILBERT_COEFFS[j];
            }
            imag[i] = sum;
        }
        
        // Step 2: Compute instantaneous phase and unwrap
        float[] phase = new float[windowSize];
        float prevPhase = 0.0f;
        
        for (int i = 0; i < windowSize; i++) {
            int idx = startPos - effectiveStart + i;
            if (idx < 0 || idx >= effectiveLength) continue;
            
            // Phase from atan2(imaginary, real)
            float currentPhase = (float) Math.atan2(imag[idx], real[idx]);
            
            // Unwrap: fix jumps > π
            float delta = currentPhase - prevPhase;
            if (delta > Math.PI) delta -= 2.0f * (float) Math.PI;
            if (delta < -Math.PI) delta += 2.0f * (float) Math.PI;
            
            phase[i] = prevPhase + delta;
            prevPhase = phase[i];
        }
        
        // Step 3: Differentiate phase to get instantaneous frequency
        float sumFreq = 0.0f;
        int freqCount = 0;
        
        for (int i = 0; i < windowSize - 1; i++) {
            float dPhase = phase[i + 1] - phase[i];
            // freq = dθ/dt * (fs / 2π)
            float freq = dPhase * scale;
            
            // Accumulate for averaging (reduces noise)
            sumFreq += freq;
            freqCount++;
        }
        
        if (freqCount == 0) return 0;
        
        // Average frequency over the window
        float avgFreq = sumFreq / freqCount;
        
        // Step 4: Map frequency to brightness
        // SSTV range: 1500 Hz (black/0) to 2300 Hz (white/255)
        float normalized = (avgFreq - 1500.0f) / 800.0f;  // 800 Hz range
        
        // Clip to valid range
        if (normalized < 0.0f) normalized = 0.0f;
        if (normalized > 1.0f) normalized = 1.0f;
        
        int brightness = (int) (normalized * 255.0f);
        
        return brightness;
    }
    
    /**
     * Demodulate FM signal for an entire scanline with diagnostics.
     * 
     * @param samples PCM samples
     * @param startPos Start of scanline
     * @param pixelCount Number of pixels
     * @param samplesPerPixel Samples per pixel (can be fractional avg)
     * @param brightnessOut Output array for brightness values
     * @param lineNum Line number for debug logging
     */
    public void demodulateLine(short[] samples, int startPos, int pixelCount, 
                               float samplesPerPixel, int[] brightnessOut, int lineNum) {
        float minFreq = Float.MAX_VALUE;
        float maxFreq = Float.MIN_VALUE;
        
        for (int pixel = 0; pixel < pixelCount && pixel < brightnessOut.length; pixel++) {
            // Calculate sample position for this pixel
            int pixelStart = startPos + (int)(pixel * samplesPerPixel);
            int windowSize = (int) Math.ceil(samplesPerPixel);
            
            if (pixelStart + windowSize > samples.length) {
                brightnessOut[pixel] = 0;
                continue;
            }
            
            // Get brightness via phase demodulation
            int brightness = demodulatePixel(samples, pixelStart, windowSize);
            brightnessOut[pixel] = brightness;
            
            // Track frequency range for diagnostics
            float freq = 1500.0f + (brightness / 255.0f) * 800.0f;
            if (freq < minFreq) minFreq = freq;
            if (freq > maxFreq) maxFreq = freq;
        }
        
        // Log diagnostics for first few lines
        if (lineNum < 3 || lineNum % 50 == 0) {
            Log.d(TAG, String.format("Line %d: freq range %.1f-%.1f Hz (%.1f-%d brightness)",
                    lineNum, minFreq, maxFreq, 
                    (minFreq - 1500) / 800 * 255, (int)((maxFreq - 1500) / 800 * 255)));
        }
    }
    
    /**
     * Diagnostic: Demodulate and log instantaneous frequencies for debugging.
     * Use this to verify frequency scaling is correct.
     */
    public void diagnoseFrequencies(short[] samples, int startPos, int length) {
        Log.d(TAG, "=== DIAGNOSTIC: Instantaneous Frequencies ===");
        
        float[] real = new float[length];
        float[] imag = new float[length];
        
        // Normalize PCM
        for (int i = 0; i < length; i++) {
            if (startPos + i >= samples.length) break;
            real[i] = samples[startPos + i] / 32768.0f;
        }
        
        // Hilbert transform
        for (int i = HILBERT_DELAY; i < length - HILBERT_DELAY; i++) {
            float sum = 0.0f;
            for (int j = 0; j < HILBERT_COEFFS.length; j++) {
                sum += real[i - HILBERT_DELAY + j] * HILBERT_COEFFS[j];
            }
            imag[i] = sum;
        }
        
        // Phase and frequency
        float prevPhase = 0.0f;
        int logCount = 0;
        
        for (int i = 1; i < Math.min(40, length); i++) {  // Log first 40 samples
            float currentPhase = (float) Math.atan2(imag[i], real[i]);
            
            float delta = currentPhase - prevPhase;
            if (delta > Math.PI) delta -= 2.0f * (float) Math.PI;
            if (delta < -Math.PI) delta += 2.0f * (float) Math.PI;
            
            float unwrappedPhase = prevPhase + delta;
            float freq = delta * scale;
            
            if (logCount < 20) {  // Log first 20
                Log.d(TAG, String.format("Sample %d: phase=%.3f, dPhase=%.3f, freq=%.1f Hz",
                        i, unwrappedPhase, delta, freq));
                logCount++;
            }
            
            prevPhase = unwrappedPhase;
        }
        
        Log.d(TAG, "Expected range for SSTV: 1500-2300 Hz");
        Log.d(TAG, "If you see 0-100 Hz → missing scale factor");
        Log.d(TAG, "If you see negative → sign flip in phase diff");
        Log.d(TAG, "=== END DIAGNOSTIC ===");
    }
}
