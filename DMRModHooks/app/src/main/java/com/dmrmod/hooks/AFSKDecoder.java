package com.dmrmod.hooks;

import de.robv.android.xposed.XposedBridge;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.nio.ByteBuffer;
import java.nio.ByteOrder;
import java.util.ArrayList;
import java.util.List;

/**
 * AFSK Decoder for Bell 202 standard (1200 baud)
 * Demodulates 1200 Hz (mark) and 2200 Hz (space) tones
 */
public class AFSKDecoder {
    private static final String TAG = "DMRModHooks-APRS-Decoder";
    
    // Bell 202 frequencies
    private static final int MARK_FREQUENCY = 1200;   // Binary 1
    private static final int SPACE_FREQUENCY = 2200;  // Binary 0
    private static final int BAUD_RATE = 1200;
    private static final int SAMPLE_RATE = 48000;
    
    // Samples per bit
    private static final double SAMPLES_PER_BIT = (double) SAMPLE_RATE / BAUD_RATE;
    
    // Goertzel filter coefficients
    private static final double MARK_COEFF = 2.0 * Math.cos(2.0 * Math.PI * MARK_FREQUENCY / SAMPLE_RATE);
    private static final double SPACE_COEFF = 2.0 * Math.cos(2.0 * Math.PI * SPACE_FREQUENCY / SAMPLE_RATE);
    
    // PLL constants (based on Dire Wolf)
    private static final long TICKS_PER_PLL_CYCLE = 0x80000000L; // 2^31
    private static final int PLL_STEP_PER_SAMPLE = (int)((TICKS_PER_PLL_CYCLE * BAUD_RATE) / SAMPLE_RATE);
    
    // PLL inertia - how much to nudge on transitions
    private static final double PLL_LOCKED_INERTIA = 0.89;      // When we have signal
    private static final double PLL_SEARCHING_INERTIA = 0.41;   // When searching
    
    // Flag byte for AX.25
    private static final byte FLAG = 0x7E;
    
    private static int audioFileCounter = 0;
    
    /**
     * Decode AFSK audio samples into AX.25 packets
     */
    public static List<byte[]> decode(short[] audioSamples) {
        List<byte[]> packets = new ArrayList<>();
        
        try {
            // Save audio to WAV file for analysis with direwolf
            saveAudioToWAV(audioSamples);
            
            // Step 1: Demodulate AFSK to bits
            boolean[] bits = demodulateAFSK(audioSamples);
            
            if (bits == null || bits.length == 0) {
                XposedBridge.log(TAG + ":Demodulation returned no bits");
                return packets;
            }
            
            XposedBridge.log(TAG + ": Demodulated " + bits.length + " bits");
            
            // Log first 100 bits to see if we're getting flags
            StringBuilder firstBits = new StringBuilder();
            for (int i = 0; i < Math.min(100, bits.length); i++) {
                firstBits.append(bits[i] ? '1' : '0');
            }
            XposedBridge.log(TAG + ": First bits: " + firstBits.toString());
            
            // Step 2: Decode NRZI
            boolean[] nrziDecoded = decodeNRZI(bits);
            
            // Log first 100 bits after NRZI
            StringBuilder nrziBits = new StringBuilder();
            for (int i = 0; i < Math.min(100, nrziDecoded.length); i++) {
                nrziBits.append(nrziDecoded[i] ? '1' : '0');
            }
            XposedBridge.log(TAG + ": After NRZI: " + nrziBits.toString());
            
            // Step 3: Find packets between flag sequences (returns bit arrays with stuffing)
            List<boolean[]> rawPacketBits = findPacketBits(nrziDecoded);
            
            XposedBridge.log(TAG + ": Found " + rawPacketBits.size() + " raw packet bit arrays");
            
            // Step 4: Apply standard AX.25 decoding (LSB-first with bit de-stuffing)
            for (boolean[] rawBits : rawPacketBits) {
                // Remove bit stuffing (standard AX.25)
                boolean[] unstuffedBits = removeBitStuffingFromBits(rawBits);
                
                if (unstuffedBits != null && unstuffedBits.length >= 144) {  // At least 18 bytes
                    // Convert to bytes LSB-first (per AX.25 spec)
                    // First bit received → bit 0 (LSB) of byte
                    int numBytes = unstuffedBits.length / 8;
                    byte[] packet = new byte[numBytes];
                    for (int i = 0; i < numBytes; i++) {
                        int byteValue = 0;
                        for (int j = 0; j < 8; j++) {
                            if (unstuffedBits[i * 8 + j]) {
                                byteValue |= (1 << j);  // LSB-first: bit 0→position 0, bit 7→position 7
                            }
                        }
                        packet[i] = (byte) byteValue;
                    }
                    
                    // Log packet info for debugging
                    StringBuilder hexStr = new StringBuilder();
                    int bytesToShow = Math.min(20, packet.length);
                    for (int i = 0; i < bytesToShow; i++) {
                        hexStr.append(String.format("%02X ", packet[i] & 0xFF));
                    }
                    XposedBridge.log(TAG + ": RX Packet (" + packet.length + " bytes, LSB-first): " + hexStr.toString());
                    
                    if (verifyFCS(packet)) {
                        // Remove FCS bytes (last 2 bytes)
                        byte[] finalPacket = new byte[packet.length - 2];
                        System.arraycopy(packet, 0, finalPacket, 0, finalPacket.length);
                        packets.add(finalPacket);
                        XposedBridge.log(TAG + ": ✓✓✓ FCS VALID! Valid APRS packet decoded (" + finalPacket.length + " bytes)");
                    }
                }
            }
            
        } catch (Exception e) {
            XposedBridge.log(TAG + ": Error decoding AFSK: " + e.getMessage());
        }
        
        return packets;
    }
    
    /**
     * Apply Automatic Gain Control (AGC) to normalize audio level
     * This is critical for decoding weak signals
     */
    private static short[] applyAGC(short[] samples) {
        // Calculate RMS (Root Mean Square) of the signal
        double sumSquares = 0;
        for (short sample : samples) {
            sumSquares += (double)sample * sample;
        }
        double rms = Math.sqrt(sumSquares / samples.length);
        
        // If signal is too weak, amplify it
        // Target RMS: ~5000 (reasonable level for 16-bit audio)
        double targetRMS = 5000.0;
        
        if (rms < 1.0) {
            // Avoid division by zero - signal is basically silent
            XposedBridge.log(TAG + ": AGC: Signal too weak (RMS=" + rms + "), cannot amplify");
            return samples;
        }
        
        double gain = targetRMS / rms;
        
        // Limit gain to prevent excessive amplification of noise
        double maxGain = 50.0;
        if (gain > maxGain) {
            gain = maxGain;
        }
        
        XposedBridge.log(TAG + ": AGC: RMS=" + String.format("%.1f", rms) + 
                        ", gain=" + String.format("%.1f", gain) + "x");
        
        // Apply gain with clipping protection
        short[] normalized = new short[samples.length];
        for (int i = 0; i < samples.length; i++) {
            double amplified = samples[i] * gain;
            
            // Clip to prevent overflow
            if (amplified > 32767) {
                normalized[i] = 32767;
            } else if (amplified < -32768) {
                normalized[i] = -32768;
            } else {
                normalized[i] = (short) amplified;
            }
        }
        
        return normalized;
    }
    
    /**
     * Demodulate AFSK using IQ mixing (Dire Wolf's proven approach)
     */
    private static boolean[] demodulateAFSK(short[] samples) {
        // Apply AGC first
        samples = applyAGC(samples);
        
        // Use IQ demodulation instead of Goertzel
        return AFSKDecoderIQ.demodulateAFSK(samples);
    }
    
    /**
     * Decode NRZI encoding
     * NRZI: No transition = 1, Transition = 0
     */
    private static boolean[] decodeNRZI(boolean[] nrziEncoded) {
        boolean[] decoded = new boolean[nrziEncoded.length];
        boolean previousState = true;  // Standard: TX starts with mark frequency
        
        for (int i = 0; i < nrziEncoded.length; i++) {
            // NRZI: Transition = 0, No transition = 1  
            decoded[i] = (nrziEncoded[i] == previousState);
            previousState = nrziEncoded[i];
        }
        
        return decoded;
    }
    
    /**
     * Find packets between flag sequences (0x7E)
     * Returns bit arrays (with stuffing) for each packet
     */
    private static List<boolean[]> findPacketBits(boolean[] bits) {
        List<boolean[]> packets = new ArrayList<>();
        
        // Search for ALL flag patterns: 01111110 (0x7E)
        List<Integer> flagPositions = new ArrayList<>();
        
        for (int i = 0; i <= bits.length - 8; i++) {
            if (!bits[i] && bits[i+1] && bits[i+2] && bits[i+3] && 
                bits[i+4] && bits[i+5] && bits[i+6] && !bits[i+7]) {
                flagPositions.add(i);
            }
        }
        
        XposedBridge.log(TAG + ": Total flags found: " + flagPositions.size());
        
        if (flagPositions.size() < 2) {
            XposedBridge.log(TAG + ": Not enough flags for packet extraction");
            return packets;
        }
        
        // Find the longest gap between FLAGs - that's the packet data
        // (Packets are surrounded by FLAGS, idle periods have FLAGS every ~8 bits)
        int maxGap = 0;
        int maxGapStart = -1;
        int maxGapEnd = -1;
        
        for (int i = 1; i < flagPositions.size(); i++) {
            int gap = flagPositions.get(i) - flagPositions.get(i - 1);
            if (gap > maxGap && gap > 50) {  // At least 50 bits (minimum packet size)
                maxGap = gap;
                maxGapStart = flagPositions.get(i - 1);
                maxGapEnd = flagPositions.get(i);
            }
        }
        
        if (maxGapStart != -1 && maxGapEnd != -1) {
            XposedBridge.log(TAG + ": Longest gap: " + maxGap + " bits between flags at " + 
                           maxGapStart + " and " + maxGapEnd);
            
            // Extract packet bits (after start FLAG, before end FLAG)
            int packetStart = maxGapStart + 8;
            int packetLength = maxGapEnd - packetStart;
            
            if (packetLength > 0) {
                boolean[] packet = new boolean[packetLength];
                System.arraycopy(bits, packetStart, packet, 0, packetLength);
                packets.add(packet);
                XposedBridge.log(TAG + ": Extracted packet with " + packetLength + " bits");
            }
        } else {
            XposedBridge.log(TAG + ": No suitable packet found (no gaps > 50 bits)");
        }
        
        return packets;
    }
    
    /**
     * Remove bit stuffing from a bit array
     * (remove 0 after five consecutive 1s)
     */
    private static boolean[] removeBitStuffingFromBits(boolean[] stuffedBits) {
        List<Boolean> unstuffed = new ArrayList<>();
        int consecutiveOnes = 0;
        
        for (int i = 0; i < stuffedBits.length; i++) {
            boolean bit = stuffedBits[i];
            
            if (bit) {
                consecutiveOnes++;
                unstuffed.add(bit);
            } else {
                if (consecutiveOnes == 5) {
                    // This is a stuffed bit, skip it
                    consecutiveOnes = 0;
                } else {
                    unstuffed.add(bit);
                    consecutiveOnes = 0;
                }
            }
        }
        
        // Convert to array
        boolean[] result = new boolean[unstuffed.size()];
        for (int i = 0; i < result.length; i++) {
            result[i] = unstuffed.get(i);
        }
        
        return result;
    }
    
    /**
     * Remove bit stuffing (remove 0 after five consecutive 1s)
     */
    private static byte[] removeBitStuffing(byte[] stuffed) {
        List<Boolean> bits = new ArrayList<>();
        
        // Convert to bits
        for (byte b : stuffed) {
            for (int i = 0; i < 8; i++) {
                bits.add(((b >> i) & 1) == 1);
            }
        }
        
        // Remove stuffed bits
        List<Boolean> unstuffed = new ArrayList<>();
        int consecutiveOnes = 0;
        
        for (int i = 0; i < bits.size(); i++) {
            boolean bit = bits.get(i);
            
            if (bit) {
                consecutiveOnes++;
                unstuffed.add(bit);
            } else {
                if (consecutiveOnes == 5) {
                    // This is a stuffed bit, skip it
                    consecutiveOnes = 0;
                } else {
                    unstuffed.add(bit);
                    consecutiveOnes = 0;
                }
            }
        }
        
        // Convert back to bytes
        int numBytes = unstuffed.size() / 8;
        byte[] result = new byte[numBytes];
        
        for (int i = 0; i < numBytes; i++) {
            int byteValue = 0;
            for (int j = 0; j < 8; j++) {
                if (i * 8 + j < unstuffed.size() && unstuffed.get(i * 8 + j)) {
                    byteValue |= (1 << j);
                }
            }
            result[i] = (byte) byteValue;
        }
        
        return result;
    }
    
    /**
     * Calculate FCS (Frame Check Sequence) using CRC-16-CCITT
     * Used for verifying received packets
     */
    private static int calculateFCS(byte[] data, int start, int length) {
        int crc = 0xFFFF;  // Initial value
        
        for (int i = start; i < start + length; i++) {
            int b = data[i] & 0xFF;
            crc ^= b;
            
            for (int j = 0; j < 8; j++) {
                if ((crc & 1) != 0) {
                    crc = (crc >> 1) ^ 0x8408;  // Reversed polynomial
                } else {
                    crc >>= 1;
                }
            }
        }
        
        // Return complemented result
        return ~crc & 0xFFFF;
    }
    
    /**
     * Verify FCS (Frame Check Sequence) using CRC-16-CCITT
     */
    private static boolean verifyFCS(byte[] packet) {
        if (packet.length < 2) {
            return false;
        }
        
        // Calculate FCS for all bytes except last 2
        int calculatedFCS = calculateFCS(packet, 0, packet.length - 2);
        
        // Extract transmitted FCS (last 2 bytes) - little endian, no bit reversal
        int fcsLow = packet[packet.length - 2] & 0xFF;
        int fcsHigh = packet[packet.length - 1] & 0xFF;
        int transmittedFCS = fcsLow | (fcsHigh << 8);
        
        // FCS should match
        boolean valid = (calculatedFCS == transmittedFCS);
        
        if (!valid) {
            XposedBridge.log(TAG + ": FCS mismatch - calculated: 0x" + 
                    Integer.toHexString(calculatedFCS) + ", transmitted: 0x" + 
                    Integer.toHexString(transmittedFCS) + 
                    " (bytes: " + String.format("%02X %02X", fcsLow, fcsHigh) + ")");
        } else {
            XposedBridge.log(TAG + ": ✓ FCS VALID!");
        }
        
        return valid;
    }
    
    /**
     * Reverse bits in a byte
     */
    private static int reverseByte(int b) {
        int result = 0;
        for (int i = 0; i < 8; i++) {
            result = (result << 1) | ((b >> i) & 1);
        }
        return result;
    }
    
    /**
     * Save audio samples to WAV file for analysis with direwolf
     */
    private static void saveAudioToWAV(short[] audioSamples) {
        try {
            File outputDir = new File("/sdcard/aprs_debug");
            outputDir.mkdirs();
            
            String filename = String.format("/sdcard/aprs_debug/aprs_rx_%03d.wav", audioFileCounter++);
            FileOutputStream fos = new FileOutputStream(filename);
            
            // Write WAV header (44 bytes)
            int dataSize = audioSamples.length * 2;  // 16-bit samples
            int fileSize = dataSize + 36;
            
            ByteBuffer header = ByteBuffer.allocate(44);
            header.order(ByteOrder.LITTLE_ENDIAN);
            
            // RIFF chunk descriptor
            header.put("RIFF".getBytes());
            header.putInt(fileSize);
            header.put("WAVE".getBytes());
            
            // fmt sub-chunk
            header.put("fmt ".getBytes());
            header.putInt(16);  // Sub-chunk size (16 for PCM)
            header.putShort((short) 1);  // Audio format (1 = PCM)
            header.putShort((short) 1);  // Number of channels (1 = mono)
            header.putInt(SAMPLE_RATE);  // Sample rate
            header.putInt(SAMPLE_RATE * 2);  // Byte rate (SampleRate * NumChannels * BitsPerSample/8)
            header.putShort((short) 2);  // Block align (NumChannels * BitsPerSample/8)
            header.putShort((short) 16);  // Bits per sample
            
            // data sub-chunk
            header.put("data".getBytes());
            header.putInt(dataSize);
            
            fos.write(header.array());
            
            // Write audio samples
            ByteBuffer audioBuffer = ByteBuffer.allocate(dataSize);
            audioBuffer.order(ByteOrder.LITTLE_ENDIAN);
            for (short sample : audioSamples) {
                audioBuffer.putShort(sample);
            }
            fos.write(audioBuffer.array());
            fos.close();
            
            XposedBridge.log(TAG + ": ★★★ Saved audio to " + filename + " (" + audioSamples.length + " samples)");
        } catch (IOException e) {
            XposedBridge.log(TAG + ": Error saving WAV file: " + e.getMessage());
        }
    }
}

