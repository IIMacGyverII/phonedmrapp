package com.macdmr.radio.dsp;

import static org.junit.Assert.*;

import org.junit.Test;

public class SpectrumTest {
    private static short[] tone(double hz, double amp, int n) { short[] s = new short[n]; for (int i = 0; i < n; i++) s[i] = (short) (amp * 32767 * Math.sin(2 * Math.PI * hz * i / 8000)); return s; }

    @Test public void aToneLightsItsOwnBand() {
        for (double hz : new double[] { 300, 1000, 2400 }) {
            Spectrum sp = new Spectrum();
            float[] b = sp.feed(tone(hz, 0.5, 256), 256);
            assertNotNull(b);
            int want = Spectrum.bandOf(hz), best = 0; for (int i = 1; i < b.length; i++) if (b[i] > b[best]) best = i;
            assertEquals("peak band for " + hz + " Hz", want, best);
            assertTrue(b[want] > 0.8f);                                   // −6 dBFS sine near the top of the 60 dB scale
            for (int i = 0; i < b.length; i++) if (Math.abs(i - want) > 2) assertTrue(hz + " Hz leaks into band " + i + ": " + b[i], b[i] < b[want] - 0.3f);
        }
    }

    @Test public void silenceIsZeroAndBlocksAreReported() {
        Spectrum sp = new Spectrum();
        assertNull(sp.feed(new short[100], 100));                         // not a full block yet
        float[] b = sp.feed(new short[156], 156);
        assertNotNull(b); for (float v : b) assertEquals(0f, v, 0.001f);
        byte[] le = new byte[512]; short[] t = tone(1000, 0.5, 256); for (int i = 0; i < 256; i++) { le[2 * i] = (byte) t[i]; le[2 * i + 1] = (byte) (t[i] >> 8); }
        float[] c = new Spectrum().feed(le, 512);
        assertEquals(Spectrum.bandOf(1000), argmax(c));
    }
    private static int argmax(float[] b) { int k = 0; for (int i = 1; i < b.length; i++) if (b[i] > b[k]) k = i; return k; }

    @Test public void bandsCoverTheVoiceRange() {
        assertEquals(0, Spectrum.bandOf(200)); assertEquals(Spectrum.BANDS - 1, Spectrum.bandOf(3599)); assertEquals(-1, Spectrum.bandOf(150)); assertEquals(-1, Spectrum.bandOf(3700));
    }
}
