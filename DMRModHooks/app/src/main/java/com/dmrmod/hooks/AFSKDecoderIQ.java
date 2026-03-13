package com.dmrmod.hooks;

import de.robv.android.xposed.XposedBridge;
import java.util.ArrayList;
import java.util.List;

/**
 * AFSK Decoder using IQ demodulation (Dire Wolf approach)
 * This eliminates the Goertzel accumulation issues by using
 * sin/cos mixing + FIR low-pass filtering
 */
public class AFSKDecoderIQ {
    private static final String TAG = "DMRModHooks-APRS-Decoder";
    
    private static final int SAMPLE_RATE = 48000;
    private static final int BAUD_RATE = 1200;
    private static final int MARK_FREQ = 1200;
    private static final int SPACE_FREQ = 2200;
    
    // PLL constants (full 32-bit range for proper bit timing)
    private static final long TICKS_PER_PLL_CYCLE = 0x100000000L;  // 2^32 (full 32-bit range)
    private static final int PLL_STEP_PER_SAMPLE = (int)((TICKS_PER_PLL_CYCLE * BAUD_RATE) / SAMPLE_RATE);
    private static final double PLL_LOCKED_INERTIA = 0.89;
    private static final double PLL_SEARCHING_INERTIA = 0.41;
    
    // FIR filter size (tuned for 1200 baud at 48kHz)
    private static final int FILTER_SIZE = 32;
    
    // Oscillator phase increment per sample
    private static final long MARK_PHASE_INC = (long)((1L << 32) * MARK_FREQ / SAMPLE_RATE);
    private static final long SPACE_PHASE_INC = (long)((1L << 32) * SPACE_FREQ / SAMPLE_RATE);
    
    /**
     * Fast sine approximation using phase (32-bit integer)
     * Phase wraps at 2^32, representing 0-2π
     */
    private static float fastSin(long phase) {
        // Use top 8 bits for lookup (256 entries)
        int index = (int)((phase >> 24) & 0xFF);
        double angle = 2.0 * Math.PI * index / 256.0;
        return (float)Math.sin(angle);
    }
    
    /**
     * Fast cosine approximation
     */
    private static float fastCos(long phase) {
        return fastSin(phase + (1L << 30));  // cos = sin(x + π/2)
    }
    
    /**
     * Simple FIR low-pass filter (moving average)
     */
    private static class FIRFilter {
        private float[] buffer;
        private int index;
        private float sum;
        
        public FIRFilter(int size) {
            buffer = new float[size];
            index = 0;
            sum = 0;
        }
        
        public float filter(float sample) {
            // Remove oldest sample from sum
            sum -= buffer[index];
            // Add new sample
            buffer[index] = sample;
            sum += sample;
            // Advance circular buffer
            index = (index + 1) % buffer.length;
            // Return average
            return sum / buffer.length;
        }
    }
    
    /**
     * Demodulate AFSK using IQ mixing (Dire Wolf's approach)
     */
    public static boolean[] demodulateAFSK(short[] samples) {
        List<Boolean> bitsList = new ArrayList<>();
        
        // Oscillator phases (32-bit wrap-around for 0-2π)
        long markPhase = 0;
        long spacePhase = 0;
        
        // FIR filters for I and Q components
        FIRFilter markIFilter = new FIRFilter(FILTER_SIZE);
        FIRFilter markQFilter = new FIRFilter(FILTER_SIZE);
        FIRFilter spaceIFilter = new FIRFilter(FILTER_SIZE);
        FIRFilter spaceQFilter = new FIRFilter(FILTER_SIZE);
        
        // PLL state
        int pllCounter = (int)(TICKS_PER_PLL_CYCLE / 2);
        boolean prevDemodData = false;
        boolean dataDetect = false;
        
        for (int i = 0; i < samples.length; i++) {
            // Normalize sample to -1.0 to +1.0
            float sample = samples[i] / 32768.0f;
            
            // IQ demodulation for MARK frequency (1200 Hz)
            // Multiply sample by cos/sin at mark frequency
            float markI = sample * fastCos(markPhase);
            float markQ = sample * fastSin(markPhase);
            markPhase += MARK_PHASE_INC;
            
            // Low-pass filter I and Q components
            markI = markIFilter.filter(markI);
            markQ = markQFilter.filter(markQ);
            
            // Compute amplitude: sqrt(I² + Q²)
            float markAmp = (float)Math.sqrt(markI * markI + markQ * markQ);
            
            // IQ demodulation for SPACE frequency (2200 Hz)
            float spaceI = sample * fastCos(spacePhase);
            float spaceQ = sample * fastSin(spacePhase);
            spacePhase += SPACE_PHASE_INC;
            
            // Low-pass filter
            spaceI = spaceIFilter.filter(spaceI);
            spaceQ = spaceQFilter.filter(spaceQ);
            
            // Compute amplitude
            float spaceAmp = (float)Math.sqrt(spaceI * spaceI + spaceQ * spaceQ);
            
            // Demodulated output: mark - space (like Dire Wolf)
            float demodOut = markAmp - spaceAmp;
            boolean demodData = (demodOut > 0);
            
            // Transition detection for PLL nudging (Dire Wolf's approach)
            if (demodData != prevDemodData && bitsList.size() > 5) {
                double inertia = dataDetect ? PLL_LOCKED_INERTIA : PLL_SEARCHING_INERTIA;
                pllCounter = (int)(pllCounter * inertia);
            }
            prevDemodData = demodData;
            
            // PLL: Sample bit on overflow
            int prevPllCounter = pllCounter;
            pllCounter += PLL_STEP_PER_SAMPLE;
            
            if ((prevPllCounter > 0) && (pllCounter < 0)) {
                // Sample the bit
                bitsList.add(demodData);
                
                if (bitsList.size() > 20) {
                    dataDetect = true;
                }
            }
        }
        
        // Convert to array
        boolean[] bits = new boolean[bitsList.size()];
        for (int i = 0; i < bits.length; i++) {
            bits[i] = bitsList.get(i);
        }
        
        XposedBridge.log(TAG + ": IQ demodulated " + bits.length + " bits");
        return bits;
    }
}
