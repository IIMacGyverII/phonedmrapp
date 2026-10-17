package com.dmrmod.hooks;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertTrue;

import org.junit.Test;

/** Host unit tests for {@link DTMFDecoder} (backlog F9). Synthesised tones at 8 kHz, no device needed. */
public class DTMFDecoderTest {

    private static final int FS = 8000;
    private static final java.util.Map<Character, double[]> TONES = new java.util.HashMap<>();
    static {
        double[] low = { 697, 770, 852, 941 }, high = { 1209, 1336, 1477, 1633 };
        String[] rows = { "123A", "456B", "789C", "*0#D" };
        for (int r = 0; r < 4; r++) for (int c = 0; c < 4; c++) TONES.put(rows[r].charAt(c), new double[]{ low[r], high[c] });
    }

    /** digits with toneMs on / gapMs off, amplitude amp (16-bit), white noise of noiseRms added. */
    static short[] synth(String digits, int toneMs, int gapMs, double amp, double noiseRms, long seed) {
        java.util.Random rnd = new java.util.Random(seed);
        int n = (int) ((digits.length() * (toneMs + gapMs) + 2000) * FS / 1000.0);
        short[] out = new short[n];
        int pos = (int) (0.3 * FS);
        for (char d : digits.toCharArray()) {
            double[] f = TONES.get(d);
            int len = toneMs * FS / 1000;
            for (int i = 0; i < len && pos + i < n; i++) {
                double v = amp * 0.5 * (Math.sin(2 * Math.PI * f[0] * i / FS) + Math.sin(2 * Math.PI * f[1] * i / FS));
                out[pos + i] = (short) Math.max(-32768, Math.min(32767, v));
            }
            pos += len + gapMs * FS / 1000;
        }
        if (noiseRms > 0) for (int i = 0; i < n; i++) out[i] = (short) Math.max(-32768, Math.min(32767, out[i] + rnd.nextGaussian() * noiseRms));
        return out;
    }

    static class Capture implements DTMFDecoder.Listener {
        final StringBuilder digits = new StringBuilder();
        final java.util.List<String> sequences = new java.util.ArrayList<>();
        @Override public void onDigit(char d) { digits.append(d); }
        @Override public void onSequence(String s, long a, long b) { sequences.add(s); }
    }

    private static Capture run(short[] pcm) {
        Capture c = new Capture();
        DTMFDecoder d = new DTMFDecoder(FS, false, c, false);
        d.processSamples(pcm, pcm.length);
        d.flush();
        return c;
    }

    @Test public void cleanSequence() {
        Capture c = run(synth("1234567890*#ABCD", 80, 60, 8000, 0, 1));
        assertEquals("1234567890*#ABCD", c.digits.toString());
        assertEquals(1, c.sequences.size());
        assertEquals("1234567890*#ABCD", c.sequences.get(0));
    }

    @Test public void shortKeysAndRepeats() {
        // 50 ms keys (ITU minimum is 40 ms), repeated digit must be counted twice because of the gap
        Capture c = run(synth("1122", 50, 50, 6000, 0, 2));
        assertEquals("1122", c.digits.toString());
    }

    @Test public void noisy() {
        // SNR ≈ 6 dB per tone pair
        Capture c = run(synth("911", 100, 80, 6000, 2000, 3));
        assertEquals("911", c.digits.toString());
    }

    @Test public void twoSequencesSplitByGap() {
        short[] a = synth("12", 80, 60, 8000, 0, 4);
        short[] b = synth("34", 80, 60, 8000, 0, 5);
        short[] both = new short[a.length + b.length];
        System.arraycopy(a, 0, both, 0, a.length); System.arraycopy(b, 0, both, a.length, b.length);
        Capture c = run(both);
        assertEquals("1234", c.digits.toString());
        assertEquals(2, c.sequences.size());
        assertEquals("12", c.sequences.get(0)); assertEquals("34", c.sequences.get(1));
    }

    @Test public void silenceAndNoiseGiveNothing() {
        Capture c = run(synth("", 0, 0, 0, 3000, 6));
        assertEquals("", c.digits.toString());
        assertTrue(c.sequences.isEmpty());
    }

    @Test public void singleToneIsNotADigit() {
        int n = FS;
        short[] pcm = new short[n];
        for (int i = 0; i < n; i++) pcm[i] = (short) (8000 * Math.sin(2 * Math.PI * 941 * i / FS));
        Capture c = run(pcm);
        assertEquals("", c.digits.toString());
    }

    @Test public void stereoDuplicatedBytes() {
        short[] pcm = synth("42", 80, 60, 8000, 0, 7);
        byte[] bytes = new byte[pcm.length * 4];
        for (int i = 0; i < pcm.length; i++) {
            bytes[4 * i] = (byte) pcm[i]; bytes[4 * i + 1] = (byte) (pcm[i] >> 8);
            bytes[4 * i + 2] = bytes[4 * i]; bytes[4 * i + 3] = bytes[4 * i + 1];
        }
        Capture c = new Capture();
        DTMFDecoder d = new DTMFDecoder(FS, true, c, false);
        d.processAudio(bytes, bytes.length);
        d.flush();
        assertEquals("42", c.digits.toString());
    }
}
