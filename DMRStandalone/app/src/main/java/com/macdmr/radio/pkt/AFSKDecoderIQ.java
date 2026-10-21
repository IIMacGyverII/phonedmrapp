package com.macdmr.radio.pkt;


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
    /** The mark and space tone strengths for every sample (the expensive part, done once for every slicer). */
    /** Band-pass ahead of the tone filters (direwolf does the same): 900..2500 Hz, Hann-windowed sinc at 48 kHz. Keeps
     *  low-frequency noise (piled up by receiver de-emphasis) and hiss above the tones out of the mark and space channels. */
    public static volatile boolean PREFILTER = true;
    /** Tone filter length (samples at 48 kHz) and band-pass edges: tunable for the benchmark. */
    // Benchmark 2026-10-20 (direwolf gen_packets -n 100 at 8 kHz, flat / pre- / de-emphasised; direwolf 1.8.1 decodes
    // 24/23/24): 32-sample filters without a band-pass 23/20/1; 52 samples (~1.1 bit) after an 800-2600 Hz band-pass with
    // five slicers 32/35/33. 48..56 samples all score within a few packets of this, so the choice is not fragile.
    public static volatile int toneFilterSize = 52;
    public static volatile double bpLowHz = 800, bpHighHz = 2600;
    private static float[] bpTaps; private static double bpBuiltLo, bpBuiltHi;
    private static synchronized float[] bandPass() {
        if (bpTaps != null && bpBuiltLo == bpLowHz && bpBuiltHi == bpHighHz) return bpTaps;
        bpBuiltLo = bpLowHz; bpBuiltHi = bpHighHz;
        int n = 193; double f1 = bpLowHz / SAMPLE_RATE, f2 = bpHighHz / SAMPLE_RATE; float[] t = new float[n]; int c = n / 2;
        for (int i = 0; i < n; i++) {
            int k = i - c;
            double h = k == 0 ? 2 * (f2 - f1) : (Math.sin(2 * Math.PI * f2 * k) - Math.sin(2 * Math.PI * f1 * k)) / (Math.PI * k);
            t[i] = (float) (h * (0.5 - 0.5 * Math.cos(2 * Math.PI * i / (n - 1))));
        }
        return bpTaps = t;
    }
    private static float[] prefilter(short[] x) {
        float[] t = bandPass(); int n = t.length, c = n / 2; float[] y = new float[x.length];
        for (int i = 0; i < x.length; i++) {
            float acc = 0; int lo = Math.max(0, i - c), hi = Math.min(x.length - 1, i + c);
            for (int j = lo; j <= hi; j++) acc += x[j] * t[j - i + c];
            y[i] = acc / 32768.0f;
        }
        return y;
    }

    public static float[][] toneStrengths(short[] samples) {
        float[] mark = new float[samples.length], space = new float[samples.length];
        long markPhase = 0, spacePhase = 0;
        int fs = toneFilterSize;
        FIRFilter mi = new FIRFilter(fs), mq = new FIRFilter(fs), si = new FIRFilter(fs), sq = new FIRFilter(fs);
        float[] in = PREFILTER ? prefilter(samples) : null;
        for (int i = 0; i < samples.length; i++) {
            float x = in != null ? in[i] : samples[i] / 32768.0f;
            float a = mi.filter(x * fastCos(markPhase)), b = mq.filter(x * fastSin(markPhase)); markPhase += MARK_PHASE_INC;
            float c = si.filter(x * fastCos(spacePhase)), d = sq.filter(x * fastSin(spacePhase)); spacePhase += SPACE_PHASE_INC;
            mark[i] = (float) Math.sqrt(a * a + b * b); space[i] = (float) Math.sqrt(c * c + d * d);
        }
        return new float[][] { mark, space };
    }

    /**
     * Each tone normalised to its own envelope (direwolf's approach): a fast-attack / slow-decay peak and valley per
     * tone, so that mark and space are compared on their own scales and twist of any size cancels out. Returns
     * {mark', space'} in about 0..1, ready for {@link #slice}.
     */
    public static float[][] normalise(float[] mark, float[] space) {
        float[] m = new float[mark.length], sp = new float[space.length];
        float mp = 0, mv = 0, spk = 0, sv = 0;
        final float attack = 0.70f, decay = 0.000090f;          // direwolf's fast attack / slow decay
        for (int i = 0; i < mark.length; i++) {
            float a = mark[i], b = space[i];
            mp = a >= mp ? mp + (a - mp) * attack : mp + (a - mp) * decay;
            mv = a <= mv ? mv + (a - mv) * attack : mv + (a - mv) * decay;
            spk = b >= spk ? spk + (b - spk) * attack : spk + (b - spk) * decay;
            sv = b <= sv ? sv + (b - sv) * attack : sv + (b - sv) * decay;
            m[i] = mp - mv > 1e-6f ? (a - mv) / (mp - mv) : 0;
            sp[i] = spk - sv > 1e-6f ? (b - sv) / (spk - sv) : 0;
        }
        return new float[][] { m, sp };
    }

    /**
     * One slicer: mark * {@code markGain} against space, with the same PLL bit clock as {@link #demodulateAFSK}. Several
     * gains side by side (as direwolf's "+" demodulators) cope with twist: radio audio often has 2200 Hz several dB
     * louder or quieter than 1200 Hz (pre-emphasis / de-emphasis), which a fixed comparison loses.
     */
    public static boolean[] slice(float[] mark, float[] space, float markGain) {
        boolean[] bits = new boolean[mark.length / 30 + 16]; int nb = 0;
        int pllCounter = (int) (TICKS_PER_PLL_CYCLE / 2);
        boolean prev = false, dataDetect = false;
        for (int i = 0; i < mark.length; i++) {
            boolean data = mark[i] * markGain - space[i] > 0;
            if (data != prev && nb > 5) pllCounter = (int) (pllCounter * (dataDetect ? PLL_LOCKED_INERTIA : PLL_SEARCHING_INERTIA));
            prev = data;
            int before = pllCounter; pllCounter += PLL_STEP_PER_SAMPLE;
            if (before > 0 && pllCounter < 0) {
                if (nb == bits.length) bits = java.util.Arrays.copyOf(bits, nb * 2);
                bits[nb++] = data; if (nb > 20) dataDetect = true;
            }
        }
        return java.util.Arrays.copyOf(bits, nb);
    }

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
        
        android.util.Log.d("pkt", TAG + ": IQ demodulated " + bits.length + " bits");
        return bits;
    }
}
