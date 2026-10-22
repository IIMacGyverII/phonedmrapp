/*
 * SignalDeck - Copyright (C) 2026 IIMacGyverII
 * SPDX-License-Identifier: GPL-3.0-or-later
 * Free software under the GNU General Public License v3 or later, with the additional terms in COPYRIGHT
 * (keep this notice and the author credit, mark modified versions, no rights to the SignalDeck name or icon).
 */
package com.macdmr.radio.pkt;

import static org.junit.Assert.*;

import org.junit.Test;

import java.io.InputStream;
import java.util.HashSet;
import java.util.Set;

/**
 * The APRS decoder on direwolf's standard benchmark (gen_packets -n 100: 100 frames with increasing noise, at 8 kHz),
 * flat and with +-5 dB of twist (pre- and de-emphasised). Windows as PacketEngine cuts them (2 s + 1 s overlap, 6x
 * upsampled). direwolf 1.8.1 atest decodes 24 / 23 / 24 of these files (the ceiling to aim at).
 */
public class AfskBenchTest {
    static short[] wav(String name) throws Exception {
        try (InputStream in = AfskBenchTest.class.getResourceAsStream("/aprs/" + name)) {
            byte[] b = in.readAllBytes(); short[] s = new short[(b.length - 44) / 2];
            for (int i = 0; i < s.length; i++) s[i] = (short) ((b[44 + 2 * i] & 0xFF) | (b[44 + 2 * i + 1] << 8));
            return s;
        }
    }
    static short[] up6(short[] in) {
        short[] out = new short[in.length * 6];
        for (int i = 0; i < in.length; i++) { int a = in[i], b = i + 1 < in.length ? in[i + 1] : in[i]; for (int k = 0; k < 6; k++) out[i * 6 + k] = (short) (a + (b - a) * k / 6); }
        return out;
    }
    static int count(short[] a, boolean multi, boolean fix) { return count(a, multi, fix, multi || fix); }
    static int count(short[] a, boolean multi, boolean fix, boolean agc) { return count(a, multi, fix, agc, multi || fix || agc); }
    static int count(short[] a, boolean multi, boolean fix, boolean agc, boolean pre) {
        AFSKDecoder.MULTI_SLICER = multi; AFSKDecoder.BIT_FIX = fix; AFSKDecoder.TONE_AGC = agc; AFSKDecoderIQ.PREFILTER = pre;
        Set<String> got = new HashSet<>();
        int W = 16000, O = 8000;
        for (int start = 0; start < a.length; start += W) {
            int from = Math.max(0, start - O), to = Math.min(a.length, start + W);
            short[] win = new short[to - from]; System.arraycopy(a, from, win, 0, win.length);
            for (byte[] f : AFSKDecoder.decode(up6(win))) if (Ax25.plausible(f)) got.add(java.util.Arrays.toString(f));
        }
        AFSKDecoder.MULTI_SLICER = true; AFSKDecoder.BIT_FIX = true; AFSKDecoder.TONE_AGC = true; AFSKDecoderIQ.PREFILTER = true;
        return got.size();
    }

    @Test public void benchmark() throws Exception {
        StringBuilder sb = new StringBuilder("decoded of 100   legacy   new   (direwolf 1.8.1: 24 / 23 / 24)" + System.lineSeparator());
        String[] names = { "flat", "pre", "de" }; int[] dw = { 24, 23, 24 };
        for (int k = 0; k < 3; k++) {
            short[] a = wav("noise100_" + names[k] + ".wav");
            AFSKDecoderIQ.toneFilterSize = 32;                        // the legacy decoder's own filter
            int l = count(a, false, false, false, false);
            AFSKDecoderIQ.toneFilterSize = 52;
            long t0 = System.nanoTime(); int b = count(a, true, true, false, true); long ms = (System.nanoTime() - t0) / 1_000_000;
            sb.append(String.format("%-14s   %6d   %3d   (%d ms for %d s of audio)%n", names[k], l, b, ms, a.length / 8000));
            assertTrue(names[k] + ": new " + b + " must beat legacy " + l + " and reach direwolf " + dw[k], b > l && b >= dw[k]);
        }
        System.out.println(sb);
    }

    @Test public void noFalsePacketsFromNoise() {
        short[] a = new short[8000 * 60]; java.util.Random r = new java.util.Random(5);
        for (int i = 0; i < a.length; i++) a[i] = (short) (r.nextGaussian() * 6000);
        assertEquals("plausible frames from 60 s of noise", 0, count(a, true, true));
    }
}
