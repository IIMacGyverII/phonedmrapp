package com.dmrmod.hooks;

/**
 * ========== REFERENCE ONLY - TX NOT FUNCTIONAL ON THIS HARDWARE ==========
 * 
 * APRS TX is disabled due to hardware limitation: TYT MD-UV380 analog FM mode
 * has hardwired voice DSP (bandpass/AGC/compression) that destroys AFSK tones.
 * 
 * This code generates perfect AFSK audio (confirmed by direwolf: audio level = 100).
 * All 6 transmission methods tested failed due to DSP corruption (27% AFSK energy loss).
 * 
 * For APRS TX: Use external TNC (e.g., Mobilinkd $100) or APRS radio (e.g., Anytone D878UV).
 * See APRS_TX_INVESTIGATION_FINAL_REPORT.md for complete technical analysis.
 * 
 * This file is preserved as reference implementation for external TNC use.
 * ===========================================================================
 * 
 * Generates AFSK (Audio Frequency Shift Keying) audio for APRS transmission.
 * Uses Bell 202 modulation: 1200 Hz (mark/1), 2200 Hz (space/0) at 1200 baud.
 */
public class AFSKGenerator {
    
    // Bell 202 AFSK parameters  
    private static final int MARK_FREQ = 1200;    // 1200 Hz for binary 1 (mark)
    private static final int SPACE_FREQ = 2200;   // 2200 Hz for binary 0 (space)
    private static final int BAUD_RATE = 1200;    // 1200 bits per second
    private static final int SAMPLE_RATE = 8000;  // 8 kHz - radio hardware sample rate
    
    // Timing parameters
    private static final int TX_DELAY_MS = 0;       // No separate delay - flags provide sync
    private static final int TX_TAIL_MS = 100;      // 100ms post-transmission tail
    
    // Amplitude (100% - maximum to overcome radio's severe 21 dB attenuation)
    private static final int AMPLITUDE = (int)(32767 * 1.0);  // 100% of 16-bit max
    
    // Precomputed values
    private static final double SAMPLES_PER_BIT = (double) SAMPLE_RATE / BAUD_RATE;
    private static final double MARK_PHASE_INC = 2.0 * Math.PI * MARK_FREQ / SAMPLE_RATE;
    private static final double SPACE_PHASE_INC = 2.0 * Math.PI * SPACE_FREQ / SAMPLE_RATE;
    
    /**
     * Generate AFSK audio from AX.25 packet bytes
     * 
     * @param packet Complete AX.25 packet (including flags)
     * @return 16-bit PCM audio samples (mono)
     */
    public static short[] generateAFSK(byte[] packet) {
        // Packet already has bit stuffing applied between flags
        
        // Calculate total audio length
        int numBits = packet.length * 8;
        int numSamples = (int) (numBits * SAMPLES_PER_BIT);
        
        // Add TX delay and tail
        int delaysamples = (TX_DELAY_MS * SAMPLE_RATE) / 1000;
        int tailSamples = (TX_TAIL_MS * SAMPLE_RATE) / 1000;
        int totalSamples = delaysamples + numSamples + tailSamples;
        
        short[] audio = new short[totalSamples];
        
        // Generate TX delay (continuous mark tone)
        int sampleIndex = 0;
        double phase = 0.0;
        for (int i = 0; i < delaysamples; i++) {
            audio[sampleIndex++] = (short) (Math.round(AMPLITUDE * Math.sin(phase)));
            phase += MARK_PHASE_INC;
            if (phase >= 2.0 * Math.PI) phase -= 2.0 * Math.PI;
        }
        
        // Generate AFSK for each bit
        for (int byteIndex = 0; byteIndex < packet.length; byteIndex++) {
            byte b = packet[byteIndex];
            
            // Process each bit (LSB first for NRZI encoding)
            for (int bitIndex = 0; bitIndex < 8; bitIndex++) {
                boolean bit = ((b >> bitIndex) & 0x01) == 1;
                
                // NRZI encoding: 1 = no change, 0 = change frequency
                // For simplicity, we'll use direct encoding here: 1 = mark, 0 = space
                double phaseInc = bit ? MARK_PHASE_INC : SPACE_PHASE_INC;
                
                // Generate samples for this bit
                int samplesThisBit = (int) SAMPLES_PER_BIT;
                for (int i = 0; i < samplesThisBit && sampleIndex < (delaysamples + numSamples); i++) {
                    audio[sampleIndex++] = (short) (Math.round(AMPLITUDE * Math.sin(phase)));
                    phase += phaseInc;
                    if (phase >= 2.0 * Math.PI) phase -= 2.0 * Math.PI;
                }
            }
        }
        
        // Generate TX tail (continuous mark tone)
        for (int i = 0; i < tailSamples && sampleIndex < totalSamples; i++) {
            audio[sampleIndex++] = (short) (Math.round(AMPLITUDE * Math.sin(phase)));
            phase += MARK_PHASE_INC;
            if (phase >= 2.0 * Math.PI) phase -= 2.0 * Math.PI;
        }
        
        return audio;
    }
    
    /**
     * Generate AFSK audio with NRZI encoding matching C library (ax25-aprs-lib)
     * - Adds preamble/trailing flags during generation
     * - Does bit stuffing during transmission
     * - Uses continuous phase
     * 
     * @param frame Plain AX.25 frame (addresses + control + PID + info + FCS, NO flags)
     * @return 16-bit PCM audio samples (mono)
     */
    public static short[] generateAFSKWithNRZI(byte[] frame) {
        final int PREAMBLE_FLAGS = 50;  // 50 flag bytes (reasonable for sync)
        final int TRAILING_FLAGS = 10;  // 10 flag bytes after frame
        final byte FLAG = 0x7E;
        
        // Remove separate carrier - flags provide sync (testing without carrier)
        int carrierSamples = 0;  // Was 0.5s, now 0
        
        // Calculate estimated audio length
        int totalBytes = PREAMBLE_FLAGS + frame.length + TRAILING_FLAGS;
        int estimatedBits = totalBytes * 8;
        estimatedBits += estimatedBits / 5 + 1;  // Worst case bit stuffing
        int estimatedSamples = carrierSamples + (int)(estimatedBits * SAMPLES_PER_BIT) + 1000;
        
        short[] audio = new short[estimatedSamples];
        int[] sampleIndex = {0};  // Use array for mutability in helper method
        
        // State variables (use arrays for mutability)
        double[] phase = {0.0};
        int[] currentFreq = {MARK_FREQ};  // Start at mark frequency
        int[] consecutiveOnes = {0};      // For bit stuffing
        double[] bitStartTime = {0.0};    // Cumulative time for precise sample count (fixes drift)
        
        // 0. Send 0.5s constant MARK carrier for receiver sync and AGC
        double phaseInc = 2.0 * Math.PI * MARK_FREQ / SAMPLE_RATE;
        for (int i = 0; i < carrierSamples && sampleIndex[0] < audio.length; i++) {
            audio[sampleIndex[0]++] = (short)(AMPLITUDE * Math.sin(phase[0]));
            phase[0] += phaseInc;
            if (phase[0] >= 2.0 * Math.PI) {
                phase[0] -= 2.0 * Math.PI;
            }
        }
        
        // 1. Send preamble flags (no bit stuffing)
        for (int i = 0; i < PREAMBLE_FLAGS; i++) {
            transmitByte(audio, sampleIndex, phase, currentFreq, consecutiveOnes, bitStartTime, FLAG, false);
        }
        
        // 2. Send frame data (WITH bit stuffing)
        for (int i = 0; i < frame.length; i++) {
            transmitByte(audio, sampleIndex, phase, currentFreq, consecutiveOnes, bitStartTime, frame[i], true);
        }
        
        // 3. Send trailing flags (no bit stuffing)
        for (int i = 0; i < TRAILING_FLAGS; i++) {
            transmitByte(audio, sampleIndex, phase, currentFreq, consecutiveOnes, bitStartTime, FLAG, false);
        }
        
        // Trim to actual size
        short[] result = new short[sampleIndex[0]];
        System.arraycopy(audio, 0, result, 0, sampleIndex[0]);
        
        return result;
    }
    
    /**
     * Transmit one byte with optional bit stuffing
     */
    private static void transmitByte(short[] audio, int[] sampleIndex, double[] phase, 
                                     int[] currentFreq, int[] consecutiveOnes, double[] bitStartTime,
                                     byte b, boolean doStuffing) {
        // Transmit LSB first
        for (int bitIdx = 0; bitIdx < 8; bitIdx++) {
            boolean bit = ((b >> bitIdx) & 0x01) == 1;
            transmitBit(audio, sampleIndex, phase, currentFreq, consecutiveOnes, bitStartTime, bit, doStuffing);
        }
    }
    
    /**
     * Transmit one bit with NRZI encoding and optional stuffing.
     * Uses floating-point cumulative timing to prevent drift (Grok fix #1).
     */
    private static void transmitBit(short[] audio, int[] sampleIndex, double[] phase,
                                    int[] currentFreq, int[] consecutiveOnes, double[] bitStartTime,
                                    boolean bit, boolean doStuffing) {
        // NRZI: Toggle frequency on bit=0 (standard APRS/Bell 202)
        // 0 = transition (change frequency), 1 = no transition (stay on current)
        if (!bit) {
            currentFreq[0] = (currentFreq[0] == MARK_FREQ) ? SPACE_FREQ : MARK_FREQ;
        }
        
        // Generate samples using floating-point timing to prevent drift
        // 8000 Hz / 1200 baud = 6.666... samples/bit (not 6!)
        double bitDurationSec = 1.0 / BAUD_RATE;  // 0.000833... seconds
        double bitEndTime = bitStartTime[0] + bitDurationSec;
        int sampleStart = (int) Math.round(bitStartTime[0] * SAMPLE_RATE);
        int sampleEnd = (int) Math.round(bitEndTime * SAMPLE_RATE);
        
        double phaseInc = 2.0 * Math.PI * currentFreq[0] / SAMPLE_RATE;
        
        for (int s = sampleStart; s < sampleEnd && sampleIndex[0] < audio.length; s++) {
            audio[sampleIndex[0]++] = (short)(AMPLITUDE * Math.sin(phase[0]));
            phase[0] += phaseInc;
            phase[0] %= (2.0 * Math.PI);  // Keep phase in range
        }
        
        // Update cumulative time for next bit (fractional part carries over!)
        bitStartTime[0] = bitEndTime;
        
        // Bit stuffing: after 5 consecutive ones, stuff a zero
        if (doStuffing) {
            if (bit) {
                consecutiveOnes[0]++;
                if (consecutiveOnes[0] == 5) {
                    transmitBit(audio, sampleIndex, phase, currentFreq, consecutiveOnes, bitStartTime, false, false);
                    consecutiveOnes[0] = 0;
                }
            } else {
                consecutiveOnes[0] = 0;
            }
        }
    }
    
    /**
     * Get the sample rate used for audio generation
     */
    public static int getSampleRate() {
        return SAMPLE_RATE;
    }
    
    /**
     * Get the TX delay in milliseconds
     */
    public static int getTxDelayMs() {
        return TX_DELAY_MS;
    }
    
    /**
     * Get the TX tail in milliseconds
     */
    public static int getTxTailMs() {
        return TX_TAIL_MS;
    }
}
