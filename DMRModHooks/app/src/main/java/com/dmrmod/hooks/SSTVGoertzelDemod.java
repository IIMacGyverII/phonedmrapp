/*
SSTV Goertzel-based demodulator
Uses Goertzel algorithm to detect SSTV frequencies in short windows
This works well with low sample rates (8kHz) where FFT has poor resolution
*/
package com.dmrmod.hooks;

import android.util.Log;

public class SSTVGoertzelDemod {
    private static final String TAG = "DMRModHooks-SSTV-Goertzel";
    
    // SSTV frequency mapping
    private static final double BLACK_FREQ = 1500;  // Hz
    private static final double WHITE_FREQ = 2300;  // Hz
    private static final double SYNC_FREQ = 1200;   // Hz (only for sync detection)
    
    // Test frequencies for pixel brightness (1500-2300 Hz range only, exclude sync 1200 Hz)
    // Higher resolution: 50 Hz steps across the SSTV range
    private static final double[] TEST_FREQS = {
        1500, 1550, 1600, 1650, 1700, 1750, 1800, 1850, 1900, 1950,
        2000, 2050, 2100, 2150, 2200, 2250, 2300
    };
    
    private final int sampleRate;
    private static int debugPixelCount = 0;  // Debug counter
    
    // Track frequency range for diagnostics
    private double minFreq = 9999;
    private double maxFreq = 0;
    private int pixelCount = 0;
    
    // Per-line stats for adaptive brightness
    private double lineMinFreq = 9999;
    private double lineMaxFreq = 0;
    private int linePixelCount = 0;
    
    public SSTVGoertzelDemod(int sampleRate) {
        this.sampleRate = sampleRate;
        debugPixelCount = 0;  // Reset on new instance
        minFreq = 9999;
        maxFreq = 0;
        pixelCount = 0;
        lineMinFreq = 9999;
        lineMaxFreq = 0;
        linePixelCount = 0;
        Log.d(TAG, "Goertzel demod initialized (sample rate: " + sampleRate + " Hz)");
    }
    
    /**
     * Reset per-line frequency statistics
     * Call this at the start of each line for per-line adaptive brightness
     */
    public void resetLineStats() {
        lineMinFreq = 9999;
        lineMaxFreq = 0;
        linePixelCount = 0;
    }
    
    public void logFrequencyRange() {
        Log.d(TAG, "Detected frequency range over " + pixelCount + " pixels: " + 
              String.format("%.1f", minFreq) + " - " + String.format("%.1f", maxFreq) + " Hz" +
              " (should be 1500-2300 Hz for full brightness range)");
    }
    
    /**
     * Extract pixel brightness using Goertzel algorithm
     * Tests multiple frequencies and finds the peak
     * 
     * @param samples Audio samples
     * @param centerPos Center position of pixel window
     * @param windowSize Number of samples to analyze
     * @return Brightness value (0-255)
     */
    public int extractPixelBrightness(short[] samples, int centerPos, int windowSize) {
        // Extract window centered on pixel
        int startPos = centerPos - windowSize / 2;
        if (startPos < 0) startPos = 0;
        if (startPos + windowSize > samples.length) {
            startPos = samples.length - windowSize;
        }
        if (startPos < 0 || windowSize < 4) return 0;
        
        // Test each frequency and find peak
        double maxMagnitude = 0;
        double peakFreq = BLACK_FREQ;
        
        // Debug: For first 3 pixels, log ALL frequency magnitudes
        StringBuilder freqDump = null;
        if (debugPixelCount < 3) {
            freqDump = new StringBuilder("Pixel " + debugPixelCount + " freqs: ");
        }
        
        for (double freq : TEST_FREQS) {           
            double magnitude = goertzel(samples, startPos, windowSize, freq);
            
            if (debugPixelCount < 3 && freqDump != null) {
                freqDump.append(String.format("%.0f=%.1f ", freq, magnitude));
            }
            
            if (magnitude > maxMagnitude) {
                maxMagnitude = magnitude;
                peakFreq = freq;
            }
        }
        
        // Track frequency range for diagnostics (global)
        pixelCount++;
        if (peakFreq < minFreq) minFreq = peakFreq;
        if (peakFreq > maxFreq) maxFreq = peakFreq;
        
        // Track per-line frequency range
        linePixelCount++;
        if (peakFreq < lineMinFreq) lineMinFreq = peakFreq;
        if (peakFreq > lineMaxFreq) lineMaxFreq = peakFreq;
        
        // Debug: Log first few pixels with ALL frequencies
        if (debugPixelCount < 3 && freqDump != null) {
            Log.d(TAG, freqDump.toString());
            Log.d(TAG, "Pixel " + debugPixelCount + ": PEAK=" + peakFreq + 
                  " Hz, magnitude=" + maxMagnitude + ", windowSize=" + windowSize);
            debugPixelCount++;
        }
        
        // Convert frequency to brightness with PER-LINE adaptive scaling
        // Use per-line range for consistent brightness across image (prevents bottom compression)
        float brightness;
        if ((lineMaxFreq - lineMinFreq) > 100) {
            // Use per-line adaptive range (kicks in as soon as we have 100Hz+ range)
            brightness = (float)((peakFreq - lineMinFreq) * 255.0 / (lineMaxFreq - lineMinFreq));
        } else {
            // Use standard SSTV mapping (until we have enough frequency variation)
            brightness = (float)((peakFreq - BLACK_FREQ) * 255.0 / (WHITE_FREQ - BLACK_FREQ));
        }
        
        if (brightness < 0) brightness = 0;
        if (brightness > 255) brightness = 255;
        
        return Math.round(brightness);
    }
    
    /**
     * Goertzel algorithm for single-frequency detection
     * 
     * @param samples Audio samples
     * @param start Start position in array
     * @param length Number of samples to process
     * @param targetFreq Target frequency in Hz
     * @return Magnitude at that frequency
     */
    private double goertzel(short[] samples, int start, int length, double targetFreq) {
        // Precompute coefficient - DO NOT ROUND k to integer!
        // Use fractional k for better frequency resolution at short windows
        double k = (length * targetFreq) / sampleRate;  // REMOVED: (int)(0.5 + ...)
        double omega = (2.0 * Math.PI * k) / length;
        double coeff = 2.0 * Math.cos(omega);
        
        // Goertzel filter
        double q0 = 0;
        double q1 = 0;
        double q2 = 0;
        
        // Process samples WITHOUT normalization (like VIS detector)
        for (int i = 0; i < length; i++) {
            q0 = coeff * q1 - q2 + samples[start + i];
            q2 = q1;
            q1 = q0;
        }
        
        // Calculate magnitude
        double real = q1 - q2 * Math.cos(omega);
        double imag = q2 * Math.sin(omega);
        return Math.sqrt(real * real + imag * imag) / length;
    }
    
    /**
     * Find sync pulse using Goertzel
     * Looks for strong 1200 Hz tone
     * 
     * @param samples Audio samples
     * @param start Start search position
     * @param searchLength How far to search
     * @param windowSize Window size for detection
     * @return Position of sync pulse, or -1 if not found
     */
    public int findSyncPulse(short[] samples, int start, int searchLength, int windowSize) {
        int maxSearch = Math.min(samples.length - windowSize, start + searchLength);
        // Threshold scaled for shorter windows (VIS uses 4.0 with 240 samples, we use 24 samples)
        double threshold = 0.3;  
        
        Log.d(TAG, "Searching for sync from sample " + start + " to " + maxSearch + 
                   " (search length: " + searchLength + ", window: " + windowSize + 
                   ", threshold: " + threshold + ")");
        
        double maxMag = 0;
        int maxPos = -1;
        
        // Search for strong 1200 Hz tone
        for (int i = start; i < maxSearch; i += windowSize / 4) {  // Hop by quarter-windows
            double magnitude = goertzel(samples, i, windowSize, SYNC_FREQ);
            
            if (magnitude > maxMag) {
                maxMag = magnitude;
                maxPos = i;
            }
            
            if (magnitude > threshold) {
                Log.d(TAG, "Potential sync at sample " + i + " (magnitude: " + magnitude + ")");
                
                // Verify it stays strong for ~9ms (72 samples @ 8kHz)
                int syncLength = (int)(0.009 * sampleRate);
                boolean isSync = true;
                
                for (int j = 0; j < syncLength && (i + j + windowSize) < samples.length; j += windowSize / 2) {
                    double checkMag = goertzel(samples, i + j, windowSize, SYNC_FREQ);
                    if (checkMag < threshold * 0.3) {  // Allow 70% drop but not complete loss
                        isSync = false;
                        break;
                    }
                }
                
                if (isSync) {
                    Log.d(TAG, "✓ Sync confirmed at sample " + i + " (magnitude: " + magnitude + ")");
                    return i;
                }
            }
        }
        
        Log.d(TAG, "No sync found (max magnitude was " + maxMag + " at sample " + maxPos + ", threshold: " + threshold + ")");
        return -1;
    }
}
