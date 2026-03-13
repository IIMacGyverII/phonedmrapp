import javax.sound.sampled.*;
import java.io.*;
import java.util.*;

/**
 * Standalone test to compare our AFSK decoder with Dire Wolf
 */
public class AFSKTest {
    
    public static void main(String[] args) throws Exception {
        if (args.length == 0) {
            System.out.println("Usage: java AFSKTest <audio_file.wav>");
            return;
        }
        
        String filename = args[0];
        System.out.println("Testing file: " + filename);
        System.out.println("=".repeat(80));
        
        // Read WAV file
        AudioInputStream audioStream = AudioSystem.getAudioInputStream(new File(filename));
        AudioFormat format = audioStream.getFormat();
        
        System.out.println("Sample rate: " + format.getSampleRate() + " Hz");
        System.out.println("Channels: " + format.getChannels());
        System.out.println("Sample size: " + format.getSampleSizeInBits() + " bits");
        System.out.println();
        
        // Read samples
        byte[] audioBytes = audioStream.readAllBytes();
        short[] samples = new short[audioBytes.length / 2];
        
        for (int i = 0; i < samples.length; i++) {
            samples[i] = (short)((audioBytes[i * 2 + 1] << 8) | (audioBytes[i * 2] & 0xFF));
        }
        
        System.out.println("Total samples: " + samples.length);
        System.out.println("Duration: " + (samples.length / format.getSampleRate()) + " seconds");
        System.out.println();
        
        // Apply AGC
        System.out.println("Applying AGC...");
        samples = applyAGC(samples);
        System.out.println();
        
        // Demodulate with IQ
        System.out.println("Demodulating with IQ method...");
        boolean[] bits = demodulateIQ(samples);
        
        System.out.println("Demodulated " + bits.length + " bits");
        System.out.println("First 200 bits:");
        for (int i = 0; i < Math.min(200, bits.length); i++) {
            System.out.print(bits[i] ? '1' : '0');
            if ((i + 1) % 80 == 0) System.out.println();
        }
        System.out.println();
        System.out.println();
        
        // NRZI decode (original, non-inverted)
        System.out.println("NRZI decoding...");
        boolean[] nrzi = decodeNRZI(bits);
        System.out.println("First 200 bits after NRZI:");
        for (int i = 0; i < Math.min(200, nrzi.length); i++) {
            System.out.print(nrzi[i] ? '1' : '0');
            if ((i + 1) % 80 == 0) System.out.println();
        }
        System.out.println();
        System.out.println();
        
        // Find FLAGS
        System.out.println("Searching for FLAG patterns (01111110)...");
        List<Integer> flagPositions = new ArrayList<>();
        for (int i = 0; i <= nrzi.length - 8; i++) {
            if (!nrzi[i] && nrzi[i+1] && nrzi[i+2] && nrzi[i+3] && 
                nrzi[i+4] && nrzi[i+5] && nrzi[i+6] && !nrzi[i+7]) {
                flagPositions.add(i);
            }
        }
        System.out.println("Total FLAGs found: " + flagPositions.size());
        
        if (flagPositions.size() >= 2) {
            // Find the actual packet (between first reasonable FLAGS, before FLAG storm)
            int startFlag = -1, endFlag = -1;
            
            // Find first FLAG not followed immediately by another FLAG (start of packet)
            for (int i = 0; i < flagPositions.size() - 1; i++) {
                int gap = flagPositions.get(i + 1) - flagPositions.get(i);
                if (gap > 20) { // More than 20 bits between FLAGs = packet data
                    startFlag = flagPositions.get(i);
                    break;
                }
            }
            
            // Find last FLAG before a storm of consecutive FLAGs (end of packet)
            for (int i = 1; i < flagPositions.size(); i++) {
                int prevGap = flagPositions.get(i) - flagPositions.get(i - 1);
                if (prevGap <= 10) { // FLAG storm starting (FLAGs every 8 bits)
                    endFlag = flagPositions.get(i - 1);
                    break;
                }
            }
            
            if (startFlag == -1 || endFlag == -1 || startFlag >= endFlag) {
                System.out.println("Could not identify packet boundaries");
                System.out.println("First 10 FLAG positions: " + flagPositions.subList(0, Math.min(10, flagPositions.size())));
                return;
            }
            
            System.out.println("Packet start FLAG at bit " + startFlag);
            System.out.println("Packet end FLAG at bit " + endFlag);
            
            // Try different bit offsets to find correct alignment
            for (int offset = 0; offset <= 7; offset++) {
                int packetStart = startFlag + 8 + offset;
                int packetLength = endFlag - packetStart;
                
                if (packetLength < 100) continue;
                
                boolean[] packetBits = Arrays.copyOfRange(nrzi, packetStart, packetStart + packetLength);
                
                System.out.println("\\n========== TRYING OFFSET " + offset + " ==========");
                System.out.println("Extracting bits " + packetStart + " to " + (packetStart + packetLength - 1));
                System.out.println("Packet has " + packetLength + " bits");
                
                // Show first bits of packet
                System.out.println("First 80 packet bits:");
                for (int i = 0; i < Math.min(80, packetBits.length); i++) {
                    System.out.print(packetBits[i] ? '1' : '0');
                }
                System.out.println();
                
                // Remove bit stuffing
                boolean[] unstuffed = removeBitStuffing(packetBits);
                System.out.println("After unstuffing: " + unstuffed.length + " bits");
                
                // Convert to bytes (LSB first)
                if (unstuffed.length >= 56) { // At least 7 bytes for dest+src
                    int numBytes = Math.min(20, unstuffed.length / 8); // Show first 20 bytes
                    byte[] bytes = new byte[numBytes];
                    
                    for (int i = 0; i < numBytes; i++) {
                        int byteValue = 0;
                        for (int j = 0; j < 8; j++) {
                            if (unstuffed[i * 8 + j]) {
                                byteValue |= (1 << j);
                            }
                        }
                        bytes[i] = (byte) byteValue;
                    }
                    
                    System.out.print("First bytes (HEX): ");
                    for (int i = 0; i < numBytes; i++) {
                        System.out.print(String.format("%02X ", bytes[i] & 0xFF));
                    }
                    System.out.println();
                    
                    System.out.print("ASCII: ");
                    for (int i = 0; i < numBytes; i++) {
                        int val = bytes[i] & 0xFF;
                        // Try unshifting (>> 1) to see if it matches callsign
                        char c = (char)(val >> 1);
                        if (c >= 32 && c < 127) {
                            System.out.print(c);
                        } else {
                            System.out.print('.');
                        }
                    }
                    System.out.println(" (unshifted)");
                    
                    // Check if this looks like APBT62
                    if (numBytes >= 7) {
                        String dest = "";
                        for (int i = 0; i < 6; i++) {
                            char c = (char)((bytes[i] & 0xFF) >> 1);
                            if (c >= 32 && c < 127) dest += c;
                        }
                        System.out.println("Destination: " + dest);
                        if (dest.contains("APBT") || dest.contains("BG6LKK")) {
                            System.out.println("*** MATCH FOUND! ***");
                        }
                    }
                }
            }
        }
    }
    
    private static boolean[] removeBitStuffing(boolean[] stuffed) {
        List<Boolean> unstuffedList = new ArrayList<>();
        int consecutiveOnes = 0;
        
        for (int i = 0; i < stuffed.length; i++) {
            if (stuffed[i]) {
                consecutiveOnes++;
                unstuffedList.add(true);
            } else {
                if (consecutiveOnes == 5) {
                    // This is a stuffed bit, don't add it
                    consecutiveOnes = 0;
                } else {
                    unstuffedList.add(false);
                    consecutiveOnes = 0;
                }
            }
        }
        
        boolean[] unstuffed = new boolean[unstuffedList.size()];
        for (int i = 0; i < unstuffed.length; i++) {
            unstuffed[i] = unstuffedList.get(i);
        }
        return unstuffed;
    }
    
    private static int calculateFCS(byte[] data, int length) {
        int fcs = 0xFFFF;
        for (int i = 0; i < length; i++) {
            int b = data[i] & 0xFF;
            for (int bit = 0; bit < 8; bit++) {
                if (((fcs ^ b) & 0x01) != 0) {
                    fcs = (fcs >> 1) ^ 0x8408;
                } else {
                    fcs = fcs >> 1;
                }
                b >>= 1;
            }
        }
        return fcs ^ 0xFFFF;
    }
    
    private static short[] applyAGC(short[] samples) {
        double sumSquares = 0;
        for (short sample : samples) {
            sumSquares += (double)sample * sample;
        }
        double rms = Math.sqrt(sumSquares / samples.length);
        
        if (rms < 1.0) {
            System.out.println("Signal too weak (RMS=" + rms + ")");
            return samples;
        }
        
        double targetRMS = 5000.0;
        double gain = targetRMS / rms;
        double maxGain = 50.0;
        if (gain > maxGain) gain = maxGain;
        
        System.out.println("RMS=" + String.format("%.1f", rms) + ", gain=" + String.format("%.1f", gain) + "x");
        
        short[] normalized = new short[samples.length];
        for (int i = 0; i < samples.length; i++) {
            double amplified = samples[i] * gain;
            if (amplified > 32767) normalized[i] = 32767;
            else if (amplified < -32768) normalized[i] = -32768;
            else normalized[i] = (short) amplified;
        }
        
        return normalized;
    }
    
    private static boolean[] demodulateIQ(short[] samples) {
        List<Boolean> bitsList = new ArrayList<>();
        
        // Oscillator constants
        long TICKS_PER_PLL_CYCLE = 0x100000000L; // Full 32-bit range (2^32)
        int BAUD_RATE = 1200;
        int SAMPLE_RATE = 48000;
        int PLL_STEP_PER_SAMPLE = (int)((TICKS_PER_PLL_CYCLE * BAUD_RATE) / SAMPLE_RATE);
        
        long MARK_PHASE_INC = (long)((1L << 32) * 1200 / SAMPLE_RATE);
        long SPACE_PHASE_INC = (long)((1L << 32) * 2200 / SAMPLE_RATE);
        
        // FIR filters
        int FILTER_SIZE = 32;
        FIRFilter markIFilter = new FIRFilter(FILTER_SIZE);
        FIRFilter markQFilter = new FIRFilter(FILTER_SIZE);
        FIRFilter spaceIFilter = new FIRFilter(FILTER_SIZE);
        FIRFilter spaceQFilter = new FIRFilter(FILTER_SIZE);
        
        // PLL state
        int pllCounter = (int)(TICKS_PER_PLL_CYCLE / 2);
        boolean prevDemodData = false;
        boolean dataDetect = false;
        
        long markPhase = 0;
        long spacePhase = 0;
        
        for (int i = 0; i < samples.length; i++) {
            float sample = samples[i] / 32768.0f;
            
            // IQ demodulation for MARK
            float markI = sample * fastCos(markPhase);
            float markQ = sample * fastSin(markPhase);
            markPhase += MARK_PHASE_INC;
            
            markI = markIFilter.filter(markI);
            markQ = markQFilter.filter(markQ);
            float markAmp = (float)Math.sqrt(markI * markI + markQ * markQ);
            
            // IQ demodulation for SPACE
            float spaceI = sample * fastCos(spacePhase);
            float spaceQ = sample * fastSin(spacePhase);
            spacePhase += SPACE_PHASE_INC;
            
            spaceI = spaceIFilter.filter(spaceI);
            spaceQ = spaceQFilter.filter(spaceQ);
            float spaceAmp = (float)Math.sqrt(spaceI * spaceI + spaceQ * spaceQ);
            
            // Demodulated output
            float demodOut = markAmp - spaceAmp;
            boolean demodData = (demodOut > 0);
            
            // PLL nudging
            if (demodData != prevDemodData && bitsList.size() > 5) {
                double inertia = dataDetect ? 0.89 : 0.41;
                pllCounter = (int)(pllCounter * inertia);
            }
            prevDemodData = demodData;
            
            // PLL sampling
            int prevPllCounter = pllCounter;
            pllCounter += PLL_STEP_PER_SAMPLE;
            
            if ((prevPllCounter > 0) && (pllCounter < 0)) {
                bitsList.add(demodData);
                if (bitsList.size() > 20) dataDetect = true;
            }
        }
        
        boolean[] bits = new boolean[bitsList.size()];
        for (int i = 0; i < bits.length; i++) {
            bits[i] = bitsList.get(i);
        }
        return bits;
    }
    
    private static float fastSin(long phase) {
        int index = (int)((phase >> 24) & 0xFF);
        double angle = 2.0 * Math.PI * index / 256.0;
        return (float)Math.sin(angle);
    }
    
    private static float fastCos(long phase) {
        return fastSin(phase + (1L << 30));
    }
    
    private static boolean[] decodeNRZI(boolean[] nrziEncoded) {
        boolean[] decoded = new boolean[nrziEncoded.length];
        boolean previousState = true;
        
        for (int i = 0; i < nrziEncoded.length; i++) {
            decoded[i] = (nrziEncoded[i] == previousState);  // Back to original
            previousState = nrziEncoded[i];
        }
        
        return decoded;
    }
    
    static class FIRFilter {
        private float[] buffer;
        private int index;
        private float sum;
        
        public FIRFilter(int size) {
            buffer = new float[size];
            index = 0;
            sum = 0;
        }
        
        public float filter(float sample) {
            sum -= buffer[index];
            buffer[index] = sample;
            sum += sample;
            index = (index + 1) % buffer.length;
            return sum / buffer.length;
        }
    }
}
