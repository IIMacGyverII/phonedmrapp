package com.dmrmod.hooks;

import de.robv.android.xposed.XposedBridge;

/**
 * SSTV VIS (Vertical Interval Signaling) Code Detector
 * 
 * Detects the VIS code at the beginning of SSTV transmissions to identify the mode.
 * 
 * VIS Structure (after leader tone):
 * - Leader: 1900 Hz for 300ms (bit sync)
 * - Break: 1200 Hz for 10ms
 * - VIS start bit: 1900 Hz for 30ms
 * - 7 data bits (LSB first): 1100 Hz = 0, 1300 Hz = 1 (30ms each)
 * - Even parity bit: 1100/1300 Hz for 30ms
 * - VIS stop bit: 1200 Hz for 30ms
 * 
 * Uses Goertzel algorithm for efficient single-frequency detection.
 */
public class SSTVVISDetector {
    private static final String TAG = "DMRModHooks-SSTV-VIS";
    
    // VIS tone frequencies (Hz)
    private static final float FREQ_LEADER = 1900.0f;
    private static final float FREQ_BREAK = 1200.0f;
    private static final float FREQ_VIS_BIT0 = 1100.0f;
    private static final float FREQ_VIS_BIT1 = 1300.0f;
    private static final float FREQ_SYNC = 1200.0f;
    
    // Timing constants (computed from sampleRate in constructor)
    private int LEADER_MIN_SAMPLES;   // 300ms
    private int BREAK_SAMPLES;        // 10ms
    private int BIT_SAMPLES;          // 30ms per bit
    private int SECOND_LEADER_SAMPLES; // 300ms (second leader before VIS start bit)
    
    // Detection thresholds
    private static final float GOERTZEL_THRESHOLD = 3.5f;   // Lowered to 3.5 (measured 3.94 in testing)
    private static final float MIN_DELTA = 20.0f;            // Minimum difference between tones
    // A real 1900 Hz carrier must be significantly stronger than neighbouring SSTV-band
    // frequencies.  Using reference bins CLOSE to 1900 Hz (±150-300 Hz) means they see
    // the same IF-filter coloring as the target bin, so noise ratios collapse to ≈1.0
    // regardless of radio type.  A genuine 1900 Hz CW leader will still dominate them
    // (spectral leakage at 50-300 Hz away suppressed by sinc side-lobes ≈ 6-13%).
    // 2.0 corresponds to ≈0 dB audio SNR; weak but real SSTV leaders still pass.
    private static final float LEADER_PURITY_RATIO = 2.0f;
    
    // FIR bandpass filter coefficients (1000-2500 Hz @ 8kHz, 15-tap Hamming window)
    private static final float[] BANDPASS_COEFFS = {
        -0.011f, -0.015f, 0.000f, 0.045f, 0.098f, 0.139f, 0.152f, 0.139f,
        0.098f, 0.045f, 0.000f, -0.015f, -0.011f
    };
    
    // Known VIS codes for error correction (must stay in sync with SSTVMode.MODES)
    private static final int[] KNOWN_VIS_CODES = {
        0x02,  // Robot 8 BW
        0x03,  // Robot 12 BW
        0x04,  // Robot 24 Color
        0x08,  // Robot 36
        0x0C,  // Robot 72
        0x28,  // Martin M2
        0x2C,  // Martin M1
        0x38,  // Scottie S2
        0x3C,  // Scottie S1
        0x4C,  // Scottie DX
        0x5F,  // PD 120
        0x60   // PD 180
    };
    
    private int sampleRate;
    
    public SSTVVISDetector(int sampleRate) {
        this.sampleRate = sampleRate;
        LEADER_MIN_SAMPLES    = (int) (sampleRate * 0.300);  // 300ms
        BREAK_SAMPLES         = (int) (sampleRate * 0.010);  // 10ms
        BIT_SAMPLES           = (int) (sampleRate * 0.030);  // 30ms
        SECOND_LEADER_SAMPLES = (int) (sampleRate * 0.300);  // 300ms (standard SSTV: second leader after break)
    }
    
    /**
     * Detect VIS code from audio samples
     * 
     * @param samples Audio samples (16-bit PCM)
     * @return SSTVVISResult containing VIS code and image start position
     */
    public SSTVVISResult detectVIS(short[] samples) {
        try {
            // Apply bandpass filter (1000-2500 Hz) to reduce noise
            short[] filtered = applyBandpassFilter(samples);
            
            // Step 1: Find leader tone (1900 Hz for 300ms minimum)
            int leaderEnd = findLeaderTone(filtered);
            if (leaderEnd == -1) {
                return SSTVVISResult.notDetected();
            }
            
            XposedBridge.log(TAG + ": Leader tone detected at sample " + leaderEnd);
            
            // Step 2: Verify break tone (1200 Hz for 10ms)
            if (!verifyBreakTone(filtered, leaderEnd)) {
                XposedBridge.log(TAG + ": Break tone not found");
                return SSTVVISResult.notDetected();
            }

            // Standard SSTV VIS structure:
            //   Leader1(300ms 1900Hz) + Break(10ms 1200Hz) + Leader2(300ms 1900Hz)
            //   + StartBit(30ms 1200Hz) + D0..D6(30ms each) + Parity + StopBit(30ms 1200Hz)
            // Skip past the 10ms break AND the second 300ms leader, then verify the 1200Hz start bit.
            int visStart = leaderEnd + BREAK_SAMPLES + SECOND_LEADER_SAMPLES;
            XposedBridge.log(TAG + ": Break + second leader skipped, VIS start bit at sample " + visStart);

            // Step 3: Verify VIS start bit (1200 Hz for 30ms)
            if (!verifyBreakTone(filtered, visStart)) {
                XposedBridge.log(TAG + ": VIS start bit (1200Hz) not found");
                return SSTVVISResult.notDetected();
            }

            visStart += BIT_SAMPLES;
            XposedBridge.log(TAG + ": VIS start bit verified, data bits from sample " + visStart);
            
            // Step 4: Decode 7 data bits (LSB first)
            int visCode = 0;
            int parityCount = 0;
            
            for (int i = 0; i < 7; i++) {
                int bitStart = visStart + (i * BIT_SAMPLES);
                if (bitStart + BIT_SAMPLES > filtered.length) {
                    XposedBridge.log(TAG + ": Insufficient samples for VIS bit " + i);
                    return SSTVVISResult.notDetected();
                }
                
                boolean bit = decodeBit(filtered, bitStart);
                if (bit) {
                    visCode |= (1 << i);  // LSB first
                    parityCount++;
                }
                
                XposedBridge.log(TAG + ": VIS bit " + i + " = " + (bit ? "1" : "0"));
            }
            
            // Step 5: Check parity bit (even parity)
            int parityStart = visStart + (7 * BIT_SAMPLES);
            if (parityStart + BIT_SAMPLES > filtered.length) {
                XposedBridge.log(TAG + ": Insufficient samples for parity bit");
                return SSTVVISResult.notDetected();
            }
            
            boolean parityBit = decodeBit(filtered, parityStart);
            if (parityBit) parityCount++;
            
            boolean parityOk = (parityCount % 2 == 0);
            if (!parityOk) {
                // Parity failed — an odd number of bits was corrupted.
                // Check if ANY known VIS code is exactly 1 bit away from visCode.
                // If yes: two equally-plausible explanations exist —
                //   (a) the PARITY BIT was the corrupted bit → data bits are correct
                //   (b) one DATA BIT was flipped, landing on the neighbouring known code
                //       (e.g. Martin M1 0x2C ↔ Martin M2 0x28, Scottie S1 0x3C ↔ S2 0x38)
                // These are indistinguishable from VIS alone → reject, fall through to
                // sync-spacing auto-detect which resolves the ambiguity by real line periods.
                //
                // If NO known code is exactly 1 bit away, the corrupted bit must be the
                // parity bit itself (most common single-bit error). Data is correct → accept.
                boolean hasKnown1BitNeighbour = false;
                for (int kvc : KNOWN_VIS_CODES) {
                    if (kvc != visCode && hammingDistance(visCode, kvc) == 1) {
                        hasKnown1BitNeighbour = true;
                        break;
                    }
                }
                if (hasKnown1BitNeighbour) {
                    XposedBridge.log(TAG + ": Parity failed for 0x" + Integer.toHexString(visCode)
                            + " which has a 1-bit-away known code — ambiguous, rejecting"
                            + " (will fall through to sync-based auto-detect)");
                    return SSTVVISResult.notDetected();
                }
                // No 1-bit known neighbour: parity bit itself was corrupted, data OK —
                // BUT only if the raw decoded bits already land on a known VIS code exactly.
                // If the code is not a known code, then more than 1 bit has been corrupted
                // (both data bits AND parity are wrong) and the result is unreliable.
                boolean visCodeIsKnown = false;
                for (int kvc : KNOWN_VIS_CODES) {
                    if (kvc == visCode) { visCodeIsKnown = true; break; }
                }
                if (!visCodeIsKnown) {
                    XposedBridge.log(TAG + ": Parity failed and 0x" + Integer.toHexString(visCode)
                            + " is not a known VIS code — multi-bit corruption, rejecting");
                    return SSTVVISResult.notDetected();
                }
                XposedBridge.log(TAG + ": Parity bit corrupted (no 1-bit neighbour, exact known code 0x"
                        + Integer.toHexString(visCode) + ") — accepting");
            }

            // Step 6: Apply Hamming distance error correction
            int correctedCode = correctVISWithHamming(visCode);
            if (correctedCode == SSTVMode.MODE_UNKNOWN) {
                XposedBridge.log(TAG + ": VIS 0x" + Integer.toHexString(visCode) + " rejected by Hamming check");
                return SSTVVISResult.notDetected();
            }
            
            XposedBridge.log(TAG + ": ✓ VIS code decoded: 0x" + Integer.toHexString(correctedCode) + 
                           " (" + SSTVMode.getModeName(correctedCode) + ")");
            
            // Calculate where image data starts (after parity bit + stop bit)
            int imageStartSample = parityStart + (2 * BIT_SAMPLES);  // After parity + stop bit
            XposedBridge.log(TAG + ": Image data starts at sample " + imageStartSample);
            
            return new SSTVVISResult(correctedCode, imageStartSample);
            
        } catch (Exception e) {
            XposedBridge.log(TAG + ": Error detecting VIS: " + e.getMessage());
            e.printStackTrace();
            return SSTVVISResult.notDetected();
        }
    }
    
    /**
     * Find leader tone (1900 Hz sustained for 300ms+)
     */
    private int findLeaderTone(short[] samples) {
        int windowSize = (int) (sampleRate * 0.050);  // 50ms window for leader confirmation
        int smallWindow = (int) (sampleRate * 0.010); // 10ms window for precise end detection
        int minLeaderWindows = 8;  // Need 8 windows = 400ms (extra margin reduces false positives)
        
        int consecutiveWindows = 0;
        boolean leaderConfirmed = false;
        int leaderConfirmedPos = -1;
        float[] windowMags = new float[minLeaderWindows];  // For inter-window consistency check
        
        for (int pos = 0; pos < samples.length - windowSize; pos += windowSize / 2) {
            float magnitude = goertzelMagnitude(samples, pos, windowSize, FREQ_LEADER);
            
            if (magnitude > GOERTZEL_THRESHOLD) {
                // Purity check: use reference bins CLOSE to 1900 Hz (±150–300 Hz).
                // These bins are equally shaped by the radio's IF filter, so noise
                // gives ratio ≈ 1.0 at all of them. Far-away bins (1100, 1300 Hz) can
                // appear lower than 1900 Hz just from IF-filter coloring, giving a
                // spuriously high ratio for noise. Near bins eliminate that artifact.
                float n1 = goertzelMagnitude(samples, pos, windowSize, 1600.0f);
                float n2 = goertzelMagnitude(samples, pos, windowSize, 1700.0f);
                float n3 = goertzelMagnitude(samples, pos, windowSize, 1800.0f);
                float n4 = goertzelMagnitude(samples, pos, windowSize, 2000.0f);
                float n5 = goertzelMagnitude(samples, pos, windowSize, 2100.0f);
                float n6 = goertzelMagnitude(samples, pos, windowSize, 2200.0f);
                float noiseAvg = (n1 + n2 + n3 + n4 + n5 + n6) / 6.0f;
                float purity = magnitude / (noiseAvg + 0.001f);
                if (purity < LEADER_PURITY_RATIO) {
                    // Noise — doesn't count toward consecutive windows
                    consecutiveWindows = 0;
                    continue;
                }
                // Store this window's magnitude for consistency check below
                if (consecutiveWindows < minLeaderWindows) {
                    windowMags[consecutiveWindows] = magnitude;
                }
                consecutiveWindows++;
                if (consecutiveWindows >= minLeaderWindows && !leaderConfirmed) {
                    // Consistency check: a real sustained 1900 Hz carrier has stable
                    // amplitude across windows (coefficient of variation CV < 0.45).
                    // Noise that passes purity by chance fluctuates much more (CV ≈ 0.5+,
                    // following a Rayleigh distribution). This catches colored noise from
                    // radio IF filters that can mimic purity across a few windows.
                    float wMean = 0;
                    for (int k = 0; k < minLeaderWindows; k++) wMean += windowMags[k];
                    wMean /= minLeaderWindows;
                    float sumSqDiff = 0;
                    for (int k = 0; k < minLeaderWindows; k++) {
                        float d = windowMags[k] - wMean;
                        sumSqDiff += d * d;
                    }
                    float cv = (float) Math.sqrt(sumSqDiff / minLeaderWindows) / (wMean + 0.001f);
                    if (cv > 0.40f) {
                        XposedBridge.log(TAG + ": Leader CV=" + String.format("%.2f", cv)
                                + " > 0.40 — magnitude too variable (noise), resetting");
                        consecutiveWindows = 0;
                        continue;
                    }
                    leaderConfirmed = true;
                    leaderConfirmedPos = pos;
                    XposedBridge.log(TAG + ": Leader confirmed (purity=" + String.format("%.2f", purity)
                            + ", CV=" + String.format("%.2f", cv) + ")");
                    // Don't return yet - keep scanning to find where leader ENDS
                }
            } else if (leaderConfirmed) {
                // 50ms window dropped - leader is ending around here.
                // Switch to fine 10ms scan to find the precise drop point.
                XposedBridge.log(TAG + ": Leader tone confirmed, scanning for end near sample " + pos);
                int scanEnd = Math.min(pos + windowSize * 2, samples.length - smallWindow);
                for (int p = leaderConfirmedPos; p < scanEnd; p += smallWindow) {
                    float m = goertzelMagnitude(samples, p, smallWindow, FREQ_LEADER);
                    if (m < GOERTZEL_THRESHOLD) {
                        XposedBridge.log(TAG + ": Leader tone (1900Hz) final magnitude: " + String.format("%.2f", magnitude) +
                                       ", end at sample " + p);
                        return p;
                    }
                }
                // Fallback if fine scan didn't find a clear drop
                return pos;
            } else {
                consecutiveWindows = 0;
            }
        }
        
        return -1;  // Leader not found
    }
    
    /**
     * Verify break tone (1200 Hz for 10ms)
     */
    private boolean verifyBreakTone(short[] samples, int pos) {
        if (pos + BREAK_SAMPLES > samples.length) {
            return false;
        }
        
        float magnitude = goertzelMagnitude(samples, pos, BREAK_SAMPLES, FREQ_BREAK);
        XposedBridge.log(TAG + ": Break tone (1200Hz) magnitude: " + String.format("%.2f", magnitude) + 
                       " (threshold: " + GOERTZEL_THRESHOLD + ")");
        return magnitude > GOERTZEL_THRESHOLD;
    }
    
    /**
     * Verify VIS start bit (1900 Hz for 30ms)
     */
    private boolean verifyStartBit(short[] samples, int pos) {
        if (pos + BIT_SAMPLES > samples.length) {
            return false;
        }
        
        float magnitude = goertzelMagnitude(samples, pos, BIT_SAMPLES, FREQ_LEADER);
        XposedBridge.log(TAG + ": Start bit (1900Hz) magnitude: " + String.format("%.2f", magnitude) + 
                       " (threshold: " + GOERTZEL_THRESHOLD + ")");
        return magnitude > GOERTZEL_THRESHOLD;
    }
    
    /**
     * Decode single VIS bit with multi-window averaging (1100 Hz = 0, 1300 Hz = 1)
     */
    private boolean decodeBit(short[] samples, int pos) {
        if (pos + BIT_SAMPLES > samples.length) {
            return false;
        }
        
        // Multi-window averaging: sample at 3 positions across the 30ms bit
        int offset1 = 0;
        int offset2 = BIT_SAMPLES / 3;       // 10ms into bit
        int offset3 = 2 * BIT_SAMPLES / 3;   // 20ms into bit
        int windowSize = BIT_SAMPLES / 3;    // Use 10ms windows
        
        // Average magnitudes from 3 windows
        float mag0 = (
            goertzelMagnitude(samples, pos + offset1, windowSize, FREQ_VIS_BIT0) +
            goertzelMagnitude(samples, pos + offset2, windowSize, FREQ_VIS_BIT0) +
            goertzelMagnitude(samples, pos + offset3, windowSize, FREQ_VIS_BIT0)
        ) / 3.0f;
        
        float mag1 = (
            goertzelMagnitude(samples, pos + offset1, windowSize, FREQ_VIS_BIT1) +
            goertzelMagnitude(samples, pos + offset2, windowSize, FREQ_VIS_BIT1) +
            goertzelMagnitude(samples, pos + offset3, windowSize, FREQ_VIS_BIT1)
        ) / 3.0f;
        
        // Calculate delta and apply adaptive threshold
        float delta = Math.abs(mag1 - mag0);
        boolean isStrongSignal = (mag0 > GOERTZEL_THRESHOLD || mag1 > GOERTZEL_THRESHOLD);
        boolean hasClearWinner = delta > MIN_DELTA;
        
        // DEBUG: Log magnitudes and decision logic
        XposedBridge.log(TAG + ": Goertzel @ pos " + pos + 
                       " | 1100Hz: " + String.format("%.2f", mag0) + 
                       " | 1300Hz: " + String.format("%.2f", mag1) + 
                       " | Delta: " + String.format("%.2f", delta) +
                       " | Strong: " + isStrongSignal +
                       " | Clear: " + hasClearWinner +
                       " | Decision: " + (mag1 > mag0 ? "1" : "0"));
        
        // Warn if weak or unclear signal
        if (!isStrongSignal || !hasClearWinner) {
            XposedBridge.log(TAG + ": ⚠ Weak/unclear bit at pos " + pos);
        }
        
        // Return true if 1300 Hz is stronger (bit = 1)
        return mag1 > mag0;
    }
    
    /**
     * Goertzel algorithm for single-frequency magnitude detection
     * More efficient than FFT for detecting specific tones.
     * 
     * @param samples Audio samples
     * @param start Start position
     * @param length Number of samples to analyze
     * @param frequency Target frequency (Hz)
     * @return Magnitude of the frequency component
     */
    private float goertzelMagnitude(short[] samples, int start, int length, float frequency) {
        // Goertzel coefficient
        float k = (int) (0.5 + ((length * frequency) / sampleRate));
        float w = (2.0f * (float) Math.PI * k) / length;
        float cosine = (float) Math.cos(w);
        float coeff = 2.0f * cosine;
        
        // Goertzel state variables
        float q0 = 0.0f;
        float q1 = 0.0f;
        float q2 = 0.0f;
        
        // Process samples
        for (int i = 0; i < length && (start + i) < samples.length; i++) {
            q0 = coeff * q1 - q2 + samples[start + i];
            q2 = q1;
            q1 = q0;
        }
        
        // Calculate magnitude
        float real = q1 - q2 * cosine;
        float imag = q2 * (float) Math.sin(w);
        float magnitude = (float) Math.sqrt(real * real + imag * imag);
        
        // Normalize by number of samples
        return magnitude / length;
    }
    
    /**
     * Quick test: Does buffer contain potential VIS code?
     * (Useful for early rejection before full decode)
     */
    public boolean containsPotentialVIS(short[] samples) {
        return findLeaderTone(samples) != -1;
    }
    
    /**
     * Apply FIR bandpass filter (1000-2500 Hz) to reduce noise
     * 
     * @param samples Raw audio samples
     * @return Filtered audio samples
     */
    private short[] applyBandpassFilter(short[] samples) {
        int filterLength = BANDPASS_COEFFS.length;
        short[] filtered = new short[samples.length];
        
        // Apply FIR filter (convolution)
        for (int i = 0; i < samples.length; i++) {
            float sum = 0.0f;
            for (int j = 0; j < filterLength; j++) {
                int sampleIdx = i - j;
                if (sampleIdx >= 0) {
                    sum += samples[sampleIdx] * BANDPASS_COEFFS[j];
                }
            }
            // Clamp to 16-bit range
            filtered[i] = (short) Math.max(-32768, Math.min(32767, (int)sum));
        }
        
        return filtered;
    }
    
    /**
     * Apply Hamming distance error correction to decoded VIS code
     * 
     * @param decoded Decoded VIS code (may have bit errors)
     * @return Corrected VIS code (closest known mode) or original if no close match
     */
    private int correctVISWithHamming(int decoded) {
        int bestMatch = decoded;
        int bestDistance = Integer.MAX_VALUE;
        
        for (int knownCode : KNOWN_VIS_CODES) {
            int distance = hammingDistance(decoded, knownCode);
            if (distance < bestDistance) {
                bestDistance = distance;
                bestMatch = knownCode;
            }
        }
        
        // Exact match: return as-is (bestDistance == 0 means decoded IS a known code)
        if (bestDistance == 0) return decoded;

        // 1-2 bit errors: correct to nearest known code
        if (bestDistance <= 2) {
            XposedBridge.log(TAG + ": Hamming correction: 0x" + Integer.toHexString(decoded)
                           + " → 0x" + Integer.toHexString(bestMatch)
                           + " (" + bestDistance + " bit" + (bestDistance == 1 ? "" : "s") + ")");
            return bestMatch;
        }

        // More than 2 bit errors: raw code is unreliable, reject
        XposedBridge.log(TAG + ": VIS 0x" + Integer.toHexString(decoded)
                       + " is " + bestDistance + " bits from nearest known code — rejecting");
        return SSTVMode.MODE_UNKNOWN;
    }
    
    /**
     * Calculate Hamming distance between two 7-bit values
     * 
     * @param a First value
     * @param b Second value
     * @return Number of differing bits
     */
    private int hammingDistance(int a, int b) {
        int xor = (a ^ b) & 0x7F;  // XOR and mask to 7 bits
        int distance = 0;
        while (xor != 0) {
            distance += (xor & 1);
            xor >>= 1;
        }
        return distance;
    }
}
