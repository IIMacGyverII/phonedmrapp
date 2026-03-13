package com.dmrmod.hooks;

import de.robv.android.xposed.XposedBridge;
import java.util.ArrayList;
import java.util.List;

/**
 * Improved AFSK Decoder with PLL and AGC
 * Based on Dire Wolf's approach but simplified for Java
 */
public class AFSKDecoderPLL {
    private static final String TAG = "DMRModHooks-APRS-DecoderPLL";
    
    private static final int MARK_FREQUENCY = 1200;
    private static final int SPACE_FREQUENCY = 2200;
    private static final int BAUD_RATE = 1200;
    private static final int SAMPLE_RATE = 48000;
    
    // PLL constants (from Dire Wolf)
    private static final int TICKS_PER_PLL_CYCLE = 0x80000000; // 2^31
    private static final int PLL_STEP_PER_SAMPLE = (int)((long)TICKS_PER_PLL_CYCLE * BAUD_RATE / SAMPLE_RATE);
    
    // PLL inertia (how much to nudge on transitions)
    private static final float PLL_LOCKED_INERTIA = 0.89f;      // When we have signal
    private static final float PLL_SEARCHING_INERTIA = 0.41f;   // When searching
    
    // AGC constants
    private static final float AGC_FAST_ATTACK = 0.080f;
    private static final float AGC_SLOW_DECAY = 0.00012f;
    
    // Goertzel coefficients
    private static final double MARK_COEFF = 2.0 * Math.cos(2.0 * Math.PI * MARK_FREQUENCY / SAMPLE_RATE);
    private static final double SPACE_COEFF = 2.0 * Math.cos(2.0 * Math.PI * SPACE_FREQUENCY / SAMPLE_RATE);
    private static final int SAMPLES_PER_BIT = 40; // 48000/1200
    
    /**
     * Decode with PLL-based bit recovery
     */
    public static List<byte[]> decode(short[] audioSamples) {
        List<byte[]> packets = new ArrayList<>();
        
        try {
            // AGC state
            float markPeak = 0.0f, markValley = 0.0f;
            float spacePeak = 0.0f, spaceValley = 0.0f;
            
            // PLL state
            int pllCounter = 0;
            int prevPllCounter = 0;
            boolean prevDemodBit = false;
            boolean dataDetect = false;
            
            // Goertzel state for mark frequency
            double q0_mark = 0, q1_mark = 0, q2_mark = 0;
            // Goertzel state for space frequency  
            double q0_space = 0, q1_space = 0, q2_space = 0;
            
            int sampleIndex = 0;
            int bitCount = 0;
            
            List<Boolean> bits = new ArrayList<>();
            
            // Process each sample
            for (short sample : audioSamples) {
                double sampleNorm = sample / 32768.0;
                
                // Update Goertzel filters
                q0_mark = MARK_COEFF * q1_mark - q2_mark + sampleNorm;
                q2_mark = q1_mark;
                q1_mark = q0_mark;
                
                q0_space = SPACE_COEFF * q1_space - q2_space + sampleNorm;
                q2_space = q1_space;
                q1_space = q0_space;
                
                sampleIndex++;
                
                // Calculate power every SAMPLES_PER_BIT samples
                if (sampleIndex % SAMPLES_PER_BIT == 0) {
                    float markPower = (float)(q1_mark * q1_mark + q2_mark * q2_mark - q1_mark * q2_mark * MARK_COEFF);
                    float spacePower = (float)(q1_space * q1_space + q2_space * q2_space - q1_space * q2_space * SPACE_COEFF);
                    
                    // Reset Goertzel for next symbol
                    q0_mark = q1_mark = q2_mark = 0;
                    q0_space = q1_space = q2_space = 0;
                    
                    // AGC normalization (from Dire Wolf)
                    float markNorm = agc(markPower, AGC_FAST_ATTACK, AGC_SLOW_DECAY, markPeak, markValley);
                    float spaceNorm = agc(spacePower, AGC_FAST_ATTACK, AGC_SLOW_DECAY, spacePeak, spaceValley);
                    
                    // Update AGC peaks/valleys
                    if (markPower >= markPeak) {
                        markPeak = markPower * AGC_FAST_ATTACK + markPeak * (1.0f - AGC_FAST_ATTACK);
                    } else {
                        markPeak = markPower * AGC_SLOW_DECAY + markPeak * (1.0f - AGC_SLOW_DECAY);
                    }
                    if (markPower <= markValley) {
                        markValley = markPower * AGC_FAST_ATTACK + markValley * (1.0f - AGC_FAST_ATTACK);
                    } else {
                        markValley = markPower * AGC_SLOW_DECAY + markValley * (1.0f - AGC_SLOW_DECAY);
                    }
                    
                    if (spacePower >= spacePeak) {
                        spacePeak = spacePower * AGC_FAST_ATTACK + spacePeak * (1.0f - AGC_FAST_ATTACK);
                    } else {
                        spacePeak = spacePower * AGC_SLOW_DECAY + spacePeak * (1.0f - AGC_SLOW_DECAY);
                    }
                    if (spacePower <= spaceValley) {
                        spaceValley = spacePower * AGC_FAST_ATTACK + spaceValley * (1.0f - AGC_FAST_ATTACK);
                    } else {
                        spaceValley = spacePower * AGC_SLOW_DECAY + spaceValley * (1.0f - AGC_SLOW_DECAY);
                    }
                    
                    float demodOut = markNorm - spaceNorm;
                    boolean demodBit = demodOut > 0;
                    
                    // PLL: Increment counter
                    prevPllCounter = pllCounter;
                    pllCounter += PLL_STEP_PER_SAMPLE * SAMPLES_PER_BIT; // Add for all samples in this bit period
                    
                    // Check for overflow (sample point)
                    if (pllCounter < 0 && prevPllCounter > 0) {
                        // Sample a bit!
                        bits.add(demodBit);
                        bitCount++;
                        
                        //XposedBridge.log(TAG + ": Sampled bit " + bitCount + ": " + (demodBit ? "1" : "0"));
                    }
                    
                    // On transitions, nudge PLL
                    if (demodBit != prevDemodBit) {
                        float inertia = dataDetect ? PLL_LOCKED_INERTIA : PLL_SEARCHING_INERTIA;
                        pllCounter = (int)(pllCounter * inertia);
                        
                        // Simple data detect: if we have bits, we have data
                        dataDetect = (bitCount > 10);
                    }
                    
                    prevDemodBit = demodBit;
                }
            }
            
            XposedBridge.log(TAG + ": PLL decoded " + bits.size() + " bits");
            
            // Now process bits using existing logic
            // (NRZI decode, find FLAGS, unstuff, FCS check)
            // ... rest of AFSKDecoder logic ...
            
        } catch (Exception e) {
            XposedBridge.log(TAG + ": Error in PLL decoder: " + e.getMessage());
        }
        
        return packets;
    }
    
    /**
     * AGC function from Dire Wolf
     */
    private static float agc(float in, float fastAttack, float slowDecay, float peak, float valley) {
        if (peak > valley) {
            return ((in - 0.5f * (peak + valley)) / (peak - valley));
        }
        return 0.0f;
    }
}
