package com.macdmr.radio.ham;

import static org.junit.Assert.*;

import org.junit.Test;

import java.util.Random;

public class TextModesTest {
    private static short[] withNoise(short[] sig, int leadSamples, double noise, long seed) {
        Random r = new Random(seed);
        short[] x = new short[leadSamples + sig.length + 8000];
        for (int i = 0; i < x.length; i++) { double v = (i >= leadSamples && i - leadSamples < sig.length ? sig[i - leadSamples] : 0) + noise * r.nextGaussian(); x[i] = (short) Math.max(-32768, Math.min(32767, v)); }
        return x;
    }

    private static final String MSG = "CQ CQ DE N0CALL N0CALL K";

    @Test public void rttyRoundTrip() {
        for (double mark : new double[] { 915, 1275, 2125 }) {
            StringBuilder got = new StringBuilder();
            Rtty rx = new Rtty(got::append);
            rx.process(withNoise(Rtty.encode(MSG + "\nRST 599 73", mark, 1500), 3331, 1500, 5));
            assertTrue("mark " + mark + ": " + got, got.toString().contains(MSG));
            assertTrue("figures: " + got, got.toString().contains("RST 599 73"));
            assertEquals(mark, rx.markHz(), 15);
        }
    }

    @Test public void psk31RoundTrip() {
        for (double hz : new double[] { 700, 1013, 1850 }) {
            StringBuilder got = new StringBuilder();
            Psk31 rx = new Psk31(got::append);
            rx.process(withNoise(Psk31.encode(MSG + " lower case & 123.", hz), 1777, 3000, 9));
            assertTrue(hz + " Hz: [" + got + "]", got.toString().contains(MSG + " lower case & 123."));
        }
    }

    @Test public void psk31TracksAFrequencyError() {
        StringBuilder got = new StringBuilder();
        Psk31 rx = new Psk31(got::append);
        rx.process(withNoise(Psk31.encode("THE QUICK BROWN FOX JUMPS OVER THE LAZY DOG 0123456789", 1500.7), 500, 2000, 4));
        assertTrue("[" + got + "]", got.toString().contains("THE QUICK BROWN FOX JUMPS OVER THE LAZY DOG 0123456789"));
    }

    @Test public void psk31AfterLongNoise() {
        for (int lead = 8000 * 3; lead < 8000 * 3 + 256; lead += 23) {               // every alignment of the symbols to the sample clock
            StringBuilder got = new StringBuilder();
            Psk31 rx = new Psk31(got::append);
            rx.process(withNoise(Psk31.encode("PSK31 BENCH TEST de DMR Radio 73", 1234), lead, 300, lead));
            assertTrue(lead + " [" + got + "] at " + rx.freq(), got.toString().contains("PSK31 BENCH TEST de DMR Radio 73"));
        }
    }

    @Test public void varicodeIsPrefixFree() {
        for (String v : Psk31.VARICODE) { assertTrue(v.startsWith("1") && v.endsWith("1")); assertFalse(v, v.contains("00")); }
        assertEquals('e', Psk31.decode("11")); assertEquals(' ', Psk31.decode("1"));
    }

    @Test public void noiseGivesNothing() {
        StringBuilder a = new StringBuilder(), b = new StringBuilder();
        short[] n = withNoise(new short[0], 0, 4000, 11); short[] big = new short[8000 * 6]; for (int i = 0; i < big.length; i++) big[i] = n[i % n.length];
        new Rtty(a::append).process(big); new Psk31(b::append).process(big);
        assertTrue("rtty [" + a + "]", a.length() <= 2);
        assertTrue("psk [" + b + "]", b.length() <= 2);
    }
}
