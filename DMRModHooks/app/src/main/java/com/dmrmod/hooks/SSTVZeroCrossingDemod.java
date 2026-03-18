/*
SSTV Zero-Crossing FM Demodulator
Uses zero-crossing rate to estimate instantaneous frequency
Ideal for low sample rates (8kHz) where Goertzel/FFT have poor resolution
Based on Grok's recommendation for continuous FM demod
*/
package com.dmrmod.hooks;

import android.util.Log;

public class SSTVZeroCrossingDemod {
    private static final String TAG = "DMRModHooks-SSTV-ZeroCross";
    
    private static final double BLACK_FREQ = 1500;  // Hz
    private static final double WHITE_FREQ = 2300;  // Hz
    
    private final int sampleRate;
    private int debugPixelCount = 0;  // Debug counter
    
    public SSTVZeroCrossingDemod(int sampleRate) {
        this.sampleRate = sampleRate;
        debugPixelCount = 0;
        Log.d(TAG, "Zero-crossing demod initialized (sample rate: " + sampleRate + " Hz)");
    }
    
    /**
     * Extract pixel brightness using zero-crossing rate
     * Counts zero crossings in a window to estimate frequency
     * 
     * @param samples Audio samples
     * @param centerPos Center position of pixel
     * @param windowSize Number of samples to analyze
     * @return Brightness value (0-255)
     */
    public int extractPixelBrightness(short[] samples, int centerPos, int windowSize) {
        int startPos = centerPos - windowSize / 2;
        if (startPos < 1) startPos = 1;  // Need at least 1 sample before
        if (startPos + windowSize >= samples.length) {
            startPos = samples.length - windowSize - 1;
        }
        if (startPos < 1) return 0;
        
        // Count zero crossings in the window
        int crossings = countZeroCrossings(samples, startPos, windowSize);
        
        // Estimate frequency from zero-crossing rate
        // freq = (crossings / 2) * (sampleRate / windowSize)
        // Divide by 2 because each cycle has 2 crossings (positive and negative)
        double freq = (crossings * sampleRate) / (2.0 * windowSize);
        
        // Debug first few pixels
        if (debugPixelCount < 5) {
            Log.d(TAG, "Pixel " + debugPixelCount + ": crossings=" + crossings + 
                  ", freq=" + String.format("%.1f", freq) + " Hz, windowSize=" + windowSize);
            debugPixelCount++;
        }
        
        // Clamp to SSTV range
        if (freq < BLACK_FREQ) freq = BLACK_FREQ;
        if (freq > WHITE_FREQ) freq = WHITE_FREQ;
        
        // Convert frequency to brightness (1500 Hz = 0, 2300 Hz = 255)
        float brightness = (float)((freq - BLACK_FREQ) * 255.0 / (WHITE_FREQ - BLACK_FREQ));
        if (brightness < 0) brightness = 0;
        if (brightness > 255) brightness = 255;
        
        return Math.round(brightness);
    }
    
    /**
     * Count zero crossings in a sample window
     * 
     * @param samples Audio samples
     * @param start Start position
     * @param length Window length
     * @return Number of zero crossings
     */
    private int countZeroCrossings(short[] samples, int start, int length) {
        int count = 0;
        short prev = samples[start];
        
        for (int i = start + 1; i < start + length && i < samples.length; i++) {
            // Detect sign change (zero crossing)
            if ((prev >= 0 && samples[i] < 0) || (prev < 0 && samples[i] >= 0)) {
                count++;
            }
            prev = samples[i];
        }
        
        return count;
    }
    
    /**
     * Alternative: Continuous frequency estimation across multiple samples
     * This version processes a stream and returns average frequency
     * Use this for smoother results with very short windows
     */
    public double estimateFrequency(short[] samples, int start, int length) {
        if (length < 2) return BLACK_FREQ;
        
        // Count zero crossings
        int crossings = countZeroCrossings(samples, start, length);
        
        // Calculate frequency
        double freq = (crossings * sampleRate) / (2.0 * length);
        
        // Clamp to valid range
        if (freq < BLACK_FREQ) freq = BLACK_FREQ;
        if (freq > WHITE_FREQ) freq = WHITE_FREQ;
        
        return freq;
    }
    
    /**
     * Advanced: Weighted zero-crossing with amplitude threshold
     * Ignores crossings near zero (noise) by requiring minimum amplitude
     */
    public int extractPixelBrightnessFiltered(short[] samples, int centerPos, int windowSize) {
        int startPos = centerPos - windowSize / 2;
        if (startPos < 1) startPos = 1;
        if (startPos + windowSize >= samples.length) {
            startPos = samples.length - windowSize - 1;
        }
        if (startPos < 1) return 0;
        
        // Calculate RMS for adaptive threshold
        double sumSquares = 0;
        for (int i = startPos; i < startPos + windowSize && i < samples.length; i++) {
            double normalized = samples[i] / 32768.0;
            sumSquares += normalized * normalized;
        }
        double rms = Math.sqrt(sumSquares / windowSize);
        double threshold = rms * 0.1;  // 10% of RMS as noise threshold
        
        // Count zero crossings with amplitude threshold
        int count = 0;
        short prev = samples[startPos];
        
        for (int i = startPos + 1; i < startPos + windowSize && i < samples.length; i++) {
            double prevNorm = Math.abs(prev / 32768.0);
            double currNorm = Math.abs(samples[i] / 32768.0);
            
            // Only count if both samples are above threshold (ignore noise crossings)
            if ((prevNorm > threshold || currNorm > threshold) &&
                ((prev >= 0 && samples[i] < 0) || (prev < 0 && samples[i] >= 0))) {
                count++;
            }
            prev = samples[i];
        }
        
        // Estimate frequency
        double freq = (count * sampleRate) / (2.0 * windowSize);
        
        // Clamp and convert to brightness
        if (freq < BLACK_FREQ) freq = BLACK_FREQ;
        if (freq > WHITE_FREQ) freq = WHITE_FREQ;
        
        float brightness = (float)((freq - BLACK_FREQ) * 255.0 / (WHITE_FREQ - BLACK_FREQ));
        if (brightness < 0) brightness = 0;
        if (brightness > 255) brightness = 255;
        
        return Math.round(brightness);
    }
}
