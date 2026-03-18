/*
SSTV FFT-based demodulator
Based on the colaclanth/sstv Python decoder approach
Uses FFT per pixel window to find peak frequency, then converts to brightness
This is more robust than phase-based FM demodulation for SSTV
*/
package com.dmrmod.hooks;

import android.util.Log;

public class SSTVFFTDemodulator {
    private static final String TAG = "DMRModHooks-SSTV-FFTDemod";
    
    // SSTV frequency to brightness mapping
    // NOTE: With 2x correction at 8kHz, we actually detect 1000-2300 Hz range
    // (not the theoretical 1500-2300 Hz from SSTV spec)
    private static final double BLACK_FREQ = 1000;  // Hz (empirically measured)
    private static final double WHITE_FREQ = 2300;  // Hz (SSTV standard)
    private static final double FREQ_RANGE = WHITE_FREQ - BLACK_FREQ;  // 1300 Hz
    
    private final int sampleRate;
    private float minFreq = Float.MAX_VALUE;
    private float maxFreq = -Float.MAX_VALUE;  // Initialize to negative max for tracking maximum
    
    public SSTVFFTDemodulator(int sampleRate) {
        this.sampleRate = sampleRate;
        Log.d(TAG, "FFT demodulator initialized (with 2x frequency correction):");
        Log.d(TAG, "  Sample rate: " + sampleRate + " Hz");
        Log.d(TAG, "  Frequency range: " + BLACK_FREQ + "-" + WHITE_FREQ + " Hz");
    }
    
    /**
     * Extract single pixel brightness from PCM samples
     * Compatible interface with SSTVPhaseDemod
     * 
     * @param samples PCM sample array
     * @param startPos Starting position in sample array  
     * @param windowSize Number of samples to analyze
     * @return Brightness value (0-255)
     */
    public int extractPixelBrightness(short[] samples, int startPos, int windowSize) {
        if (startPos + windowSize > samples.length) {
            windowSize = samples.length - startPos;
        }
        if (windowSize < 8) {
            return 128; // Not enough samples, return gray
        }
        
        // Extract and normalize window
        float[] window = new float[windowSize];
        for (int i = 0; i < windowSize; i++) {
            window[i] = samples[startPos + i] / 32768.0f;
        }
        
        // Apply Hann window
        applyHannWindow(window);
        
        // Find peak frequency via FFT
        float freq = findPeakFrequency(window, sampleRate);
        
        // Diagnostic: Log first few frequencies
        if (minFreq == Float.MAX_VALUE && maxFreq == -Float.MAX_VALUE) {
            Log.d(TAG, "First pixel FFT result: " + freq + " Hz (window size: " + windowSize + ")");
        }
        
        // Track frequency range for diagnostics
        if (freq < minFreq) minFreq = freq;
        if (freq > maxFreq) maxFreq = freq;
        
        // Convert to brightness
        return frequencyToBrightness(freq);
    }
    
    /**
     * Reset per-line frequency statistics
     */
    public void resetLineStats() {
        // No-op for FFT demod (compatible with SSTVPhaseDemod interface)
    }
    
    /**
     * Get minimum detected frequency (for diagnostics)
     */
    public float getMinFreq() {
        return minFreq;
    }
    
    /**
     * Get maximum detected frequency (for diagnostics)
     */
    public float getMaxFreq() {
        return maxFreq;
    }
    
    /**
     * Find sync pulse in PCM samples
     * Looks for sustained 1200 Hz signal
     * 
     * @param samples PCM sample array
     * @param startPos Start search position
     * @param searchWindow Maximum samples to search
     * @param windowSize FFT window size
     * @return Position of sync pulse start, or -1 if not found
     */
    public int findSyncPulse(short[] samples, int startPos, int searchWindow, int windowSize) {
        int searchEnd = Math.min(startPos + searchWindow, samples.length - windowSize);
        
        // Look for frequency around 1200 Hz (sync pulse)
        // With 2x correction, we expect to see raw ~600 Hz → corrected ~1200 Hz
        float targetFreq = 1200.0f;
        float tolerance = 100.0f;
        
        for (int pos = startPos; pos < searchEnd; pos += windowSize / 4) {
            float[] window = new float[windowSize];
            for (int i = 0; i < windowSize; i++) {
                window[i] = samples[pos + i] / 32768.0f;
            }
            
            applyHannWindow(window);
            float freq = findPeakFrequency(window, sampleRate);
            
            if (Math.abs(freq - targetFreq) < tolerance) {
                // Found sync frequency, scan forward to find end of pulse
                int syncStart = pos;
                int syncEnd = pos;
                
                // Scan forward while frequency stays near 1200 Hz
                for (int p = pos; p < searchEnd; p += windowSize / 4) {
                    float[] w = new float[windowSize];
                    for (int i = 0; i < windowSize && p + i < samples.length; i++) {
                        w[i] = samples[p + i] / 32768.0f;
                    }
                    applyHannWindow(w);
                    float f = findPeakFrequency(w, sampleRate);
                    
                    if (Math.abs(f - targetFreq) < tolerance) {
                        syncEnd = p;
                    } else {
                        break;
                    }
                }
                
                // Return start of sync pulse
                return syncStart;
            }
        }
        
        return -1;  // Sync not found
    }
    
    /**
     * Log first line frequencies for diagnostics
     */
    public void logFirstLineFrequencies(short[] samples, int startPos, int count) {
        int windowSize = 64;
        Log.d(TAG, "=== FIRST LINE FREQUENCY DIAGNOSTIC (FFT + 2x correction) ===");
        
        for (int i = 0; i < Math.min(10, count / windowSize); i++) {
            int pos = startPos + (i * count / 10);
            if (pos + windowSize >= samples.length) break;
            
            float[] window = new float[windowSize];
            for (int j = 0; j < windowSize; j++) {
                window[j] = samples[pos + j] / 32768.0f;
            }
            
            applyHannWindow(window);
            
            // Get raw frequency (before 2x correction)
            float rawFreq = findPeakFrequencyRaw(window, sampleRate);
            float correctedFreq = rawFreq * 2.0f;
            
            Log.d(TAG, "Pixel " + i + ": FFT " + rawFreq + " Hz (corrected: " + correctedFreq + " Hz)");
        }
        
        Log.d(TAG, "Expected SSTV range: 1500-2300 Hz");
        Log.d(TAG, "FFT method with 2x frequency correction");
        Log.d(TAG, "=== END DIAGNOSTIC ===");
    }
    
    // Helper method to get raw frequency without 2x correction (for diagnostics)
    private float findPeakFrequencyRaw(float[] data, int sampleRate) {
        int N = data.length;
        
        // Same search range as findPeakFrequency (before 2x correction)
        int minBin = (int)((600.0 * N) / sampleRate);  
        int maxBin = (int)((1400.0 * N) / sampleRate);
        if (maxBin >= N/2) maxBin = N/2 - 1;
        
        float maxMagnitude = 0;
        int maxBin_idx = minBin;
        
        for (int k = minBin; k <= maxBin; k++) {
            float magnitude = computeBinMagnitude(data, k);
            if (magnitude > maxMagnitude) {
                maxMagnitude = magnitude;
                maxBin_idx = k;
            }
        }
        
        // Barycentric interpolation
        float peakBin = maxBin_idx;
        if (maxBin_idx > minBin && maxBin_idx < maxBin) {
            float mag_prev = computeBinMagnitude(data, maxBin_idx - 1);
            float mag_curr = maxMagnitude;
            float mag_next = computeBinMagnitude(data, maxBin_idx + 1);
            
            float denom = mag_prev + mag_curr + mag_next;
            if (denom > 0) {
                peakBin = maxBin_idx + (mag_next - mag_prev) / denom;
            }
        }
        
        return (peakBin * sampleRate) / N;  // Return WITHOUT 2x correction
    }
    
    /**
     * Demodulate PCM audio to brightness values using FFT per pixel
     * @param pcmData Input PCM samples (16-bit signed)
     * @param output Output brightness array (0-255)
     * @param windowSize Number of samples per FFT window
     * @param pixelCount Number of pixels to extract
     */
    public void demodulate(short[] pcmData, int[] output, int windowSize, int pixelCount) {
        if (pcmData.length < windowSize) {
            Log.e(TAG, "Insufficient samples for demodulation");
            return;
        }
        
        int samplesPerPixel = (pcmData.length - windowSize) / pixelCount;
        if (samplesPerPixel < 1) samplesPerPixel = 1;
        
        Log.d(TAG, "Demodulating " + pixelCount + " pixels:");
        Log.d(TAG, "  Window size: " + windowSize + " samples");
        Log.d(TAG, "  Samples per pixel: " + samplesPerPixel);
        
        float minFreq = Float.MAX_VALUE;
        float maxFreq = Float.MIN_VALUE;
        int minBrightness = 255;
        int maxBrightness = 0;
        
        for (int i = 0; i < pixelCount; i++) {
            int startPos = i * samplesPerPixel;
            int endPos = Math.min(startPos + windowSize, pcmData.length);
            int actualWindowSize = endPos - startPos;
            
            if (actualWindowSize < windowSize / 2) {
                // Not enough samples remaining
                output[i] = 0;
                continue;
            }
            
            // Extract window
            float[] window = new float[actualWindowSize];
            for (int j = 0; j < actualWindowSize; j++) {
                window[j] = pcmData[startPos + j] / 32768.0f;
            }
            
            // Apply Hann window to reduce spectral leakage
            applyHannWindow(window);
            
            // Perform FFT and find peak frequency
            float peakFreq = findPeakFrequency(window, sampleRate);
            
            // Track frequency range
            if (peakFreq < minFreq) minFreq = peakFreq;
            if (peakFreq > maxFreq) maxFreq = peakFreq;
            
            // Convert frequency to brightness (0-255)
            int brightness = frequencyToBrightness(peakFreq);
            
            // Track brightness range
            if (brightness < minBrightness) minBrightness = brightness;
            if (brightness > maxBrightness) maxBrightness = brightness;
            
            output[i] = brightness;
        }
        
        Log.d(TAG, "Demodulation complete:");
        Log.d(TAG, "  Frequency range: " + minFreq + " to " + maxFreq + " Hz");
        Log.d(TAG, "  Brightness range: " + minBrightness + " to " + maxBrightness);
    }
    
    /**
     * Apply Hann window to reduce spectral leakage
     * w[n] = 0.5 * (1 - cos(2πn / (N-1)))
     */
    private void applyHannWindow(float[] data) {
        int N = data.length;
        for (int n = 0; n < N; n++) {
            double window = 0.5 * (1.0 - Math.cos(2.0 * Math.PI * n / (N - 1)));
            data[n] *= window;
        }
    }
    
    /**
     * Perform FFT and find peak frequency
     * Uses simple DFT since Android doesn't have built-in FFT
     * NOTE: Searches RAW frequency range (before 2x correction)
     */
    private float findPeakFrequency(float[] data, int sampleRate) {
        int N = data.length;
        
        // Search RAW frequency range (before 2x correction)
        // SSTV range after 2x: 1500-2300 Hz
        // Raw range before 2x: 750-1150 Hz
        // Search slightly wider for sync detection: 600-1400 Hz raw → 1200-2800 Hz corrected
        int minBin = (int)((600.0 * N) / sampleRate);
        int maxBin = (int)((1400.0 * N) / sampleRate);
        if (maxBin >= N/2) maxBin = N/2 - 1;
        
        float maxMagnitude = 0;
        int maxBin_idx = minBin;
        
        // Compute magnitude for each frequency bin in range
        for (int k = minBin; k <= maxBin; k++) {
            float real = 0;
            float imag = 0;
            
            double omega = 2.0 * Math.PI * k / N;
            
            for (int n = 0; n < N; n++) {
                real += data[n] * Math.cos(omega * n);
                imag -= data[n] * Math.sin(omega * n);
            }
            
            float magnitude = (float)Math.sqrt(real * real + imag * imag);
            
            if (magnitude > maxMagnitude) {
                maxMagnitude = magnitude;
                maxBin_idx = k;
            }
        }
        
        // Interpolate peak using barycentric method for sub-bin accuracy
        float peakBin = maxBin_idx;
        if (maxBin_idx > minBin && maxBin_idx < maxBin) {
            // Recompute magnitudes for neighboring bins
            float mag_prev = computeBinMagnitude(data, maxBin_idx - 1);
            float mag_curr = maxMagnitude;
            float mag_next = computeBinMagnitude(data, maxBin_idx + 1);
            
            float denom = mag_prev + mag_curr + mag_next;
            if (denom > 0) {
                peakBin = maxBin_idx + (mag_next - mag_prev) / denom;
            }
        }
        
        // Convert bin to frequency
        float frequency = (peakBin * sampleRate) / N;
        
        // CRITICAL 2x CORRECTION: All demodulation methods (Goertzel, phase-based, zero-crossing, FFT)
        // detect exactly half the expected frequency at 8 kHz. This is a characteristic of the
        // signal source (possibly hardware pre-processing or transmission). Apply 2x correction.
        frequency = frequency * 2.0f;
        
        return frequency;
    }
    
    /**
     * Compute magnitude for a single FFT bin
     */
    private float computeBinMagnitude(float[] data, int k) {
        int N = data.length;
        float real = 0;
        float imag = 0;
        
        double omega = 2.0 * Math.PI * k / N;
        
        for (int n = 0; n < N; n++) {
            real += data[n] * Math.cos(omega * n);
            imag -= data[n] * Math.sin(omega * n);
        }
        
        return (float)Math.sqrt(real * real + imag * imag);
    }
    
    /**
     * Convert frequency (Hz) to brightness (0-255)
     * Formula from reference decoder: brightness = (freq - 1500) / 3.1372549
     * where 3.1372549 = 800/255 (frequency range / brightness range)
     */
    private int frequencyToBrightness(float freq) {
        float brightness = (freq - (float)BLACK_FREQ) * 255.0f / (float)FREQ_RANGE;
        
        // Clamp to 0-255
        if (brightness < 0) brightness = 0;
        if (brightness > 255) brightness = 255;
        
        return Math.round(brightness);
    }
}
