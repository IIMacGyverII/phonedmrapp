package com.macdmr.radio.pkt;

import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertTrue;

import java.nio.charset.StandardCharsets;
import java.util.Arrays;
import java.util.Random;

import org.junit.Test;

/** {@link Ax25#plausible}: real APRS frames pass, noise that slipped past the FCS does not. */
public class Ax25Test {

    private static byte[] noFcs(byte[] f) { return Arrays.copyOf(f, f.length - 2); }

    @Test public void realFramesPass() {
        assertTrue(Ax25.plausible(noFcs(Ax25.buildUiFrame("APDR16", 0, "N0CALL", 7, new String[] { "WIDE1-1", "WIDE2-1" }, ">test".getBytes(StandardCharsets.US_ASCII)))));
        assertTrue(Ax25.plausible(noFcs(Ax25.buildUiFrame("APRS", 0, "K0ABC", 0, null, "!4500.00N/09300.00W-".getBytes(StandardCharsets.US_ASCII)))));
        assertTrue(Ax25.plausible(noFcs(Ax25.buildUiFrame("T7SRQU", 0, "W1AW", 9, new String[] { "WIDE2-2" }, "`l7Bl!-/]\"4R}".getBytes(StandardCharsets.ISO_8859_1)))));
    }

    @Test public void malformedFramesFail() {
        byte[] good = noFcs(Ax25.buildUiFrame("APDR16", 0, "N0CALL", 7, null, ">x".getBytes(StandardCharsets.US_ASCII)));
        byte[] lower = good.clone(); lower[0] = (byte) ('a' << 1); assertFalse(Ax25.plausible(lower));            // lower-case callsign
        byte[] gap = good.clone(); gap[8] = (byte) (' ' << 1); assertFalse(Ax25.plausible(gap));                  // space inside a callsign
        byte[] ctrl = good.clone(); ctrl[14] = 0x13; assertFalse(Ax25.plausible(ctrl));                            // not a UI frame
        byte[] pid = good.clone(); pid[15] = (byte) 0xCF; assertFalse(Ax25.plausible(pid));                        // not "no layer 3"
        assertFalse(Ax25.plausible(Arrays.copyOf(good, 10)));                                                       // truncated
    }

    @Test public void randomNoiseAlmostNeverPasses() {
        Random r = new Random(1);
        int passed = 0, n = 200_000;
        for (int i = 0; i < n; i++) { byte[] f = new byte[16 + r.nextInt(60)]; r.nextBytes(f); if (Ax25.plausible(f)) passed++; }
        assertTrue("random frames accepted: " + passed, passed == 0);
    }
}
