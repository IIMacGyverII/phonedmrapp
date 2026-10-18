package com.macdmr.radio.pkt;

/**
 * DTMF decoder for the radio's 8 kHz RX audio (backlog F9, 2026-10-17).
 *
 * Goertzel filters on the eight DTMF frequencies over 20 ms blocks. A digit is reported when one
 * low-group and one high-group tone dominate (each ≥ 4× every other tone of its group, twist within
 * 8 dB, and the pair carrying most of the in-band energy) for two consecutive blocks; it is released
 * after two blocks without it. Digits are collected into a sequence that ends after
 * {@link #SEQUENCE_GAP_MS} without a new digit.
 *
 * Pure Java (no Android classes) so it runs under host JUnit.
 */
public class DTMFDecoder {

    public interface Listener {
        /** One decoded key, as it is pressed. */
        void onDigit(char digit);
        /** A complete sequence (≥ 1 digit) after {@link #SEQUENCE_GAP_MS} of no digits. */
        void onSequence(String digits, long startMs, long endMs);
    }

    public static final int SEQUENCE_GAP_MS = 1200;
    private static final int BLOCK_MS = 20;
    private static final double[] LOW  = { 697, 770, 852, 941 };
    private static final double[] HIGH = { 1209, 1336, 1477, 1633 };
    private static final char[][] KEYS = {
        { '1', '2', '3', 'A' },
        { '4', '5', '6', 'B' },
        { '7', '8', '9', 'C' },
        { '*', '0', '#', 'D' } };

    private final int sampleRate;
    private final boolean stereoDuplicated;
    private final int blockLen;
    private final double[] coefLow = new double[4], coefHigh = new double[4];
    private final Listener listener;

    private final short[] block;
    private int blockFill = 0;

    private char candidate = 0;     // digit seen in the last block(s)
    private int candidateCount = 0;
    private char current = 0;       // digit currently "pressed"
    private int silentCount = 0;

    private final StringBuilder sequence = new StringBuilder();
    private long seqStartMs = 0, lastDigitMs = 0;
    private long clockMs = 0;       // advanced by the audio stream (not wall time) so tests are deterministic
    private final boolean useWallClock;

    private double minLevel = 200.0;   // RMS floor (16-bit units) below which a block is ignored

    public DTMFDecoder(int sampleRate, boolean stereoDuplicated, Listener l) {
        this(sampleRate, stereoDuplicated, l, true);
    }

    DTMFDecoder(int sampleRate, boolean stereoDuplicated, Listener l, boolean wallClock) {
        this.sampleRate = sampleRate;
        this.stereoDuplicated = stereoDuplicated;
        this.listener = l;
        this.useWallClock = wallClock;
        this.blockLen = sampleRate * BLOCK_MS / 1000;
        this.block = new short[blockLen];
        for (int i = 0; i < 4; i++) {
            coefLow[i]  = 2.0 * Math.cos(2.0 * Math.PI * LOW[i]  / sampleRate);
            coefHigh[i] = 2.0 * Math.cos(2.0 * Math.PI * HIGH[i] / sampleRate);
        }
    }

    public void setMinLevel(double rms) { this.minLevel = rms; }

    public void reset() {
        blockFill = 0; candidate = 0; candidateCount = 0; current = 0; silentCount = 0;
        sequence.setLength(0);
    }

    /** 16-bit little-endian PCM; when stereoDuplicated, one sample per 4-byte frame is taken. */
    public void processAudio(byte[] data, int length) {
        int step = stereoDuplicated ? 4 : 2;
        for (int i = 0; i + 1 < length; i += step) {
            short s = (short) ((data[i + 1] << 8) | (data[i] & 0xFF));
            push(s);
        }
    }

    public void processSamples(short[] samples, int count) {
        for (int i = 0; i < count; i++) push(samples[i]);
    }

    private void push(short s) {
        block[blockFill++] = s;
        if (blockFill < blockLen) return;
        blockFill = 0;
        clockMs += BLOCK_MS;
        analyseBlock();
    }

    private long now() { return useWallClock ? System.currentTimeMillis() : clockMs; }

    private double goertzel(double coef) {
        double s0, s1 = 0, s2 = 0;
        for (int i = 0; i < blockLen; i++) {
            s0 = block[i] + coef * s1 - s2;
            s2 = s1; s1 = s0;
        }
        return s1 * s1 + s2 * s2 - coef * s1 * s2;
    }

    private void analyseBlock() {
        double sum = 0;
        for (int i = 0; i < blockLen; i++) sum += (double) block[i] * block[i];
        double rms = Math.sqrt(sum / blockLen);
        char digit = 0;
        if (rms >= minLevel) {
            double[] pl = new double[4], ph = new double[4];
            int li = 0, hi = 0;
            for (int i = 0; i < 4; i++) {
                pl[i] = goertzel(coefLow[i]);  if (pl[i] > pl[li]) li = i;
                ph[i] = goertzel(coefHigh[i]); if (ph[i] > ph[hi]) hi = i;
            }
            boolean ok = true;
            for (int i = 0; i < 4 && ok; i++) {
                if (i != li && pl[li] < 4.0 * pl[i]) ok = false;
                if (i != hi && ph[hi] < 4.0 * ph[i]) ok = false;
            }
            if (ok) {
                double twist = pl[li] / ph[hi];
                if (twist > 10.0 || twist < 1.0 / 10.0) ok = false;    // 10 dB (TX pre-emphasis tilts the high group up ~6 dB/oct; a de-emphasised RX sees less)
            }
            if (ok) {
                // the pair must carry most of the energy: Goertzel power ≈ (N²/4)·A² for a pure tone
                double pairAmp2 = (pl[li] + ph[hi]) * 4.0 / ((double) blockLen * blockLen);
                if (pairAmp2 < 0.5 * 2.0 * rms * rms) ok = false;      // < 50 % of the block's power
            }
            if (ok) digit = KEYS[li][hi];
        }
        if (digit != 0) {
            silentCount = 0;
            if (digit == candidate) candidateCount++; else { candidate = digit; candidateCount = 1; }
            if (candidateCount >= 2 && current != digit) {
                current = digit;
                onKey(digit);
            }
        } else {
            candidate = 0; candidateCount = 0;
            if (current != 0 && ++silentCount >= 2) current = 0;
        }
        // sequence end
        if (sequence.length() > 0 && current == 0 && now() - lastDigitMs >= SEQUENCE_GAP_MS) {
            String seq = sequence.toString();
            sequence.setLength(0);
            if (listener != null) listener.onSequence(seq, seqStartMs, lastDigitMs);
        }
    }

    private void onKey(char d) {
        long t = now();
        if (sequence.length() == 0) seqStartMs = t;
        lastDigitMs = t;
        sequence.append(d);
        if (sequence.length() > 64) sequence.delete(0, sequence.length() - 64);
        if (listener != null) listener.onDigit(d);
    }

    /** Flush a pending sequence (e.g. when the squelch closes for good). */
    public void flush() {
        if (sequence.length() > 0) {
            String seq = sequence.toString();
            sequence.setLength(0);
            current = 0; candidate = 0; candidateCount = 0;
            if (listener != null) listener.onSequence(seq, seqStartMs, lastDigitMs);
        }
    }
}
