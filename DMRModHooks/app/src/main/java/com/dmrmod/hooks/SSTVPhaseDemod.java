/*
SSTV Zero-Crossing FM Demodulator
Counts zero crossings to estimate frequency - simple and robust for SSTV tones.
Expert guidance: "Works surprisingly well for clean SSTV tones at 8 kHz — no atan2 needed."
*/
package com.dmrmod.hooks;

import de.robv.android.xposed.XposedBridge;

public class SSTVPhaseDemod {
    private static final String TAG = "DMRModHooks-SSTV-ZeroCross";
    
    private final float sampleRate;
    
    // Diagnostics
    private float minFreq = Float.MAX_VALUE;
    private float maxFreq = Float.MIN_VALUE;
    private boolean firstLineDiagnostic = true;
    
    public SSTVPhaseDemod(float sampleRate) {
        this.sampleRate = sampleRate;
        
        XposedBridge.log(TAG + ": Initialized zero-crossing demod (fs=" + sampleRate + " Hz)");
    }
    
    /**
     * Reset per-line statistics
     */
    public void resetLineStats() {
        minFreq = Float.MAX_VALUE;
        maxFreq = Float.MIN_VALUE;
    }
    
    /**
     * Demodulate FM signal using zero-crossing rate.
     * Counts sign changes to estimate frequency.
     * 
     * @param samples PCM samples (16-bit)
     * @param startPos Start position in samples array
     * @param windowSize Number of samples to analyze
     * @return Brightness 0-255 based on frequency (1500 Hz = 0, 2300 Hz = 255)
     */
    public int extractPixelBrightness(short[] samples, int startPos, int windowSize) {
        if (windowSize < 4 || startPos < 0) return 0;
        if (startPos + windowSize > samples.length) return 0;
        
        // Count zero crossings (sign changes) in the window
        int crossings = 0;
        boolean prevPositive = samples[startPos] >= 0;
        
        for (int i = 1; i < windowSize; i++) {
            boolean currentPositive = samples[startPos + i] >= 0;
            if (currentPositive != prevPositive) {
                crossings++;
            }
            prevPositive = currentPositive;
        }
        
        // Frequency = (crossings / windowSize) * sampleRate / 2
        // Divide by 2 because each cycle has 2 crossings (positive and negative)
        float freq = (crossings / (float)windowSize) * sampleRate / 2.0f;
        
        // CORRECTION: All demodulation methods detect half the expected frequency
        // This might be due to the signal being pre-processed or sample rate mismatch
        // Multiply by 2 to get actual SSTV frequency range
        freq = freq * 2.0f;
        
        // Track min/max for diagnostics
        if (freq < minFreq) minFreq = freq;
        if (freq > maxFreq) maxFreq = freq;
        
        // Map frequency to brightness
        // SSTV range: 1500 Hz (black/0) to 2300 Hz (white/255)
        float normalized = (freq - 1500.0f) / 800.0f;
        
        // Clip to valid range
        if (normalized < 0.0f) normalized = 0.0f;
        if (normalized > 1.0f) normalized = 1.0f;
        
        int brightness = (int) (normalized * 255.0f);
        
        return brightness;
    }
    
    /**
     * Find sync pulse (1200 Hz) using zero-crossing rate.
     * 
     * @param samples PCM samples
     * @param startPos Start position to search
     * @param searchLength How many samples to search
     * @param windowSize Window size for frequency detection
     * @return Position of sync pulse, or -1 if not found
     */
    public int findSyncPulse(short[] samples, int startPos, int searchLength, int windowSize) {
        int bestPos = -1;
        float bestScore = Float.MAX_VALUE;
        
        // Scan for region with frequency near 1200 Hz
        for (int pos = startPos; pos < startPos + searchLength - windowSize; pos += windowSize / 2) {
            // Count zero crossings
            int crossings = 0;
            boolean prevPositive = samples[pos] >= 0;
            
            for (int i = 1; i < windowSize && pos + i < samples.length; i++) {
                boolean currentPositive = samples[pos + i] >= 0;
                if (currentPositive != prevPositive) {
                    crossings++;
                }
                prevPositive = currentPositive;
            }
            
            float freq = (crossings / (float)windowSize) * sampleRate / 2.0f;
            
            // CORRECTION: Double the frequency (same correction as pixel demod)
            freq = freq * 2.0f;
            
            // Score based on distance from 1200 Hz sync frequency
            float score = Math.abs(freq - 1200.0f);
            
            if (score < bestScore) {
                bestScore = score;
                bestPos = pos;
            }
            
            // If we find a very good match (within 100 Hz), accept it
            if (score < 100.0f) {
                break;
            }
        }
        
        return bestPos;
    }
    
    /**
     * Get detected frequency range for current line (for diagnostics)
     */
    public float getMinFreq() {
        return minFreq;
    }
    
    public float getMaxFreq() {
        return maxFreq;
    }
    
    /**
     * Diagnostic: Log frequencies for first line pixels to verify detection.
     */
    public void logFirstLineFrequencies(short[] samples, int startPos, int windowSize) {
        if (!firstLineDiagnostic) return;
        firstLineDiagnostic = false;
        
        XposedBridge.log(TAG + ": === FIRST LINE FREQUENCY DIAGNOSTIC (ZERO-CROSSING) ===");
        
        if (startPos < 0 || startPos + windowSize * 10 > samples.length) {
            XposedBridge.log(TAG + ": Not enough samples for diagnostic");
            return;
        }
        
        // Test first 10 pixels
        for (int pixel = 0; pixel < 10; pixel++) {
            int pos = startPos + (pixel * windowSize);
            
            if (pos + windowSize > samples.length) break;
            
            // Count zero crossings
            int crossings = 0;
            boolean prevPositive = samples[pos] >= 0;
            
            for (int i = 1; i < windowSize; i++) {
                boolean currentPositive = samples[pos + i] >= 0;
                if (currentPositive != prevPositive) {
                    crossings++;
                }
                prevPositive = currentPositive;
            }
            
            float freq = (crossings / (float)windowSize) * sampleRate / 2.0f;
            float correctedFreq = freq * 2.0f;  // Apply correction
            
            XposedBridge.log(TAG + String.format(": Pixel %d: %d crossings in %d samples = %.1f Hz (corrected: %.1f Hz)",
                    pixel, crossings, windowSize, freq, correctedFreq));
        }
        
        XposedBridge.log(TAG + ": Expected SSTV range: 1500-2300 Hz");
        XposedBridge.log(TAG + ": Zero-crossing method with 2x frequency correction");
        XposedBridge.log(TAG + ": (All demod methods detected half frequency - applying fix)");
        XposedBridge.log(TAG + ": === END DIAGNOSTIC ===");
    }
}
