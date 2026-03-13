import javax.sound.sampled.*;
import java.io.*;
import java.util.*;

public class AFSKTest3 {
    public static void main(String[] args) throws Exception {
        String filename = args.length > 0 ? args[0] : "aprs_rx_001.wav";
        
        // Read WAV
        AudioInputStream audioStream = AudioSystem.getAudioInputStream(new File(filename));
        AudioFormat format = audioStream.getFormat();
        byte[] audioBytes = audioStream.readAllBytes();
        short[] samples = new short[audioBytes.length / 2];
        
        for (int i = 0; i < samples.length; i++) {
            samples[i] = (short)((audioBytes[i * 2 + 1] << 8) | (audioBytes[i * 2] & 0xFF));
        }
        
        samples = applyAGC(samples);
        boolean[] bits = demodulateIQ(samples);
        boolean[] nrzi = decodeNRZI(bits);
        
        // Find all FLAGs
        List<Integer> flags = new ArrayList<>();
        for (int i = 0; i <= nrzi.length - 8; i++) {
            if (!nrzi[i] && nrzi[i+1] && nrzi[i+2] && nrzi[i+3] && 
                nrzi[i+4] && nrzi[i+5] && nrzi[i+6] && !nrzi[i+7]) {
                flags.add(i);
            }
        }
        
        System.out.println("Total bits: " + bits.length);
        System.out.println("Total FLAGs: " + flags.size());
        System.out.println("\\nFLAG positions (showing gaps):");
        for (int i = 0; i < Math.min(15, flags.size()); i++) {
            int gap = (i > 0) ? flags.get(i) - flags.get(i-1) : 0;
            System.out.println("  FLAG " + i + " at bit " + flags.get(i) + " (gap=" + gap + ")");
        }
        
        // Look for the longest gap between FLAGs - that's likely the packet data
        int maxGap = 0, maxGapStart = -1, maxGapEnd = -1;
        for (int i = 1; i < flags.size(); i++) {
            int gap = flags.get(i) - flags.get(i-1);
            if (gap > maxGap && gap > 50) { // At least 50 bits
                maxGap = gap;
                maxGapStart = flags.get(i-1);
                maxGapEnd = flags.get(i);
            }
        }
        
        System.out.println("\\nLongest gap: " + maxGap + " bits between FLAG at " + maxGapStart + " and " + maxGapEnd);
        
        // Decode that section
        boolean[] packetBits = Arrays.copyOfRange(nrzi, maxGapStart + 8, maxGapEnd);
        boolean[] unstuffed = removeBitStuffing(packetBits);
        
        System.out.println("Packet bits: " + packetBits.length);
        System.out.println("After unstuffing: " + unstuffed.length + " bits\\n");
        
        // Convert to bytes
        int numBytes = unstuffed.length / 8;
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
        
        System.out.println("Decoded " + numBytes + " bytes:");
        for (int i = 0; i < Math.min(76, bytes.length); i++) {
            if (i % 16 == 0) System.out.print(String.format("  %03x:  ", i));
            System.out.print(String.format("%02x ", bytes[i] & 0xFF));
            if ((i + 1) % 16 == 0) System.out.println();
        }
        System.out.println("\\n");
        
        System.out.println("Expected (from Dire Wolf):");
        System.out.println("  000:  82 a0 84 a8 6c 64 e2 84 8e 6c 98 96 96 70 ae 92");
        System.out.println("  010:  88 8a 62 40 63 03 f0 21 34 35 31 33 2e 33 36 4e");
        System.out.println("  020:  2f 30 39 33 34 30 2e 34 30 57 26 33 35 33 2f 30");
        System.out.println("  030:  30 30 2f 41 3d 30 30 30 38 30 34 41 50 52 53 43");
        System.out.println("  040:  4e 20 57 49 46 49 20 34 2e 33 30 56");
        System.out.println();
        
        // Check FCS
        if (bytes.length >= 3) {
            int transmitted = (bytes[bytes.length-2] & 0xFF) | ((bytes[bytes.length-1] & 0xFF) << 8);
            int calculated = calculateFCS(bytes, bytes.length - 2);
            System.out.println("FCS: calculated=0x" + String.format("%04X", calculated) + 
                             ", transmitted=0x" + String.format("%04X", transmitted) +
                             (calculated == transmitted ? " ✓ VALID!" : " ✗ mismatch"));
        }
    }
    
    private static short[] applyAGC(short[] samples) {
        double sum = 0;
        for (short s : samples) sum += (double)s * s;
        double rms = Math.sqrt(sum / samples.length);
        if (rms < 1.0) return samples;
        
        double gain = Math.min(50.0, 5000.0 / rms);
        short[] out = new short[samples.length];
        for (int i = 0; i < samples.length; i++) {
            double val = samples[i] * gain;
            out[i] = (short)Math.max(-32768, Math.min(32767, val));
        }
        return out;
    }
    
    private static boolean[] demodulateIQ(short[] samples) {
        List<Boolean> bitsList = new ArrayList<>();
        
        long TICKS_PER_PLL_CYCLE = 0x100000000L;
        int BAUD = 1200, RATE = 48000;
        int PLL_STEP = (int)((TICKS_PER_PLL_CYCLE * BAUD) / RATE);
        
        long markPhaseInc = (1L << 32) * 1200 / RATE;
        long spacePhaseInc = (1L << 32) * 2200 / RATE;
        
        FIR markI = new FIR(32), markQ = new FIR(32);
        FIR spaceI = new FIR(32), spaceQ = new FIR(32);
        
        int pllCounter = (int)(TICKS_PER_PLL_CYCLE / 2);
        boolean prevData = false, dataDetect = false;
        long markPhase = 0, spacePhase = 0;
        
        for (short sample : samples) {
            float s = sample / 32768.0f;
            
            float mI = markI.filter(s * fastCos(markPhase));
            float mQ = markQ.filter(s * fastSin(markPhase));
            float mAmp = (float)Math.sqrt(mI*mI + mQ*mQ);
            markPhase += markPhaseInc;
            
            float sI = spaceI.filter(s * fastCos(spacePhase));
            float sQ = spaceQ.filter(s * fastSin(spacePhase));
            float sAmp = (float)Math.sqrt(sI*sI + sQ*sQ);
            spacePhase += spacePhaseInc;
            
            boolean data = (mAmp - sAmp) > 0;
            
            if (data != prevData && bitsList.size() > 5) {
                pllCounter = (int)(pllCounter * (dataDetect ? 0.89 : 0.41));
            }
            prevData = data;
            
            int prev = pllCounter;
            pllCounter += PLL_STEP;
            if (prev > 0 && pllCounter < 0) {
                bitsList.add(data);
                if (bitsList.size() > 20) dataDetect = true;
            }
        }
        
        boolean[] bits = new boolean[bitsList.size()];
        for (int i = 0; i < bits.length; i++) bits[i] = bitsList.get(i);
        return bits;
    }
    
    private static float fastSin(long phase) {
        return (float)Math.sin(2.0 * Math.PI * ((phase >> 24) & 0xFF) / 256.0);
    }
    
    private static float fastCos(long phase) {
        return fastSin(phase + (1L << 30));
    }
    
    private static boolean[] decodeNRZI(boolean[] nrzi) {
        boolean[] out = new boolean[nrzi.length];
        boolean prev = true;
        for (int i = 0; i < nrzi.length; i++) {
            out[i] = (nrzi[i] == prev);
            prev = nrzi[i];
        }
        return out;
    }
    
    private static boolean[] removeBitStuffing(boolean[] stuffed) {
        List<Boolean> out = new ArrayList<>();
        int ones = 0;
        for (boolean bit : stuffed) {
            if (bit) {
                ones++;
                out.add(true);
            } else {
                if (ones == 5) {
                    ones = 0; // Skip stuffed 0
                } else {
                    out.add(false);
                    ones = 0;
                }
            }
        }
        boolean[] result = new boolean[out.size()];
        for (int i = 0; i < result.length; i++) result[i] = out.get(i);
        return result;
    }
    
    private static int calculateFCS(byte[] data, int length) {
        int fcs = 0xFFFF;
        for (int i = 0; i < length; i++) {
           int b = data[i] & 0xFF;
            for (int bit = 0; bit < 8; bit++) {
                if (((fcs ^ b) & 0x01) != 0) fcs = (fcs >> 1) ^ 0x8408;
                else fcs = fcs >> 1;
                b >>= 1;
            }
        }
        return fcs ^ 0xFFFF;
    }
    
    static class FIR {
        float[] buf;
        int idx;
        float sum;
        FIR(int size) { buf = new float[size]; }
        float filter(float sample) {
            sum -= buf[idx];
            buf[idx] = sample;
            sum += sample;
            idx = (idx + 1) % buf.length;
            return sum / buf.length;
        }
    }
}
