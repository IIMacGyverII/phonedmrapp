/*
 * SignalDeck - Copyright (C) 2026 IIMacGyverII
 * SPDX-License-Identifier: GPL-3.0-or-later
 * Free software under the GNU General Public License v3 or later, with the additional terms in COPYRIGHT
 * (keep this notice and the author credit, mark modified versions, no rights to the SignalDeck name or icon).
 */
package com.macdmr.radio.dsp;

import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertTrue;

import java.util.Random;

import org.junit.Test;

/** The noise squelch stays open through the silent pauses of a strong signal and closes on hiss. */
public class NoiseSquelchTest {
    private static byte[] pcm(short[] s) { byte[] b = new byte[s.length * 2]; for (int i = 0; i < s.length; i++) { b[2 * i] = (byte) s[i]; b[2 * i + 1] = (byte) (s[i] >> 8); } return b; }
    private static short[] voice(int ms) { short[] s = new short[ms * 8]; for (int i = 0; i < s.length; i++) s[i] = (short) (6000 * Math.sin(2 * Math.PI * 700 * i / 8000.0) + 2500 * Math.sin(2 * Math.PI * 1300 * i / 8000.0)); return s; }
    private static short[] silence(int ms) { short[] s = new short[ms * 8]; Random r = new Random(3); for (int i = 0; i < s.length; i++) s[i] = (short) (r.nextGaussian() * 8); return s; }
    private static short[] hiss(int ms) { short[] s = new short[ms * 8]; Random r = new Random(5); for (int i = 0; i < s.length; i++) s[i] = (short) (r.nextGaussian() * 4000); return s; }

    @Test public void pausesOnAStrongCarrierStayOpen() {
        NoiseSquelchDetector d = new NoiseSquelchDetector(8000);
        byte[] v = pcm(voice(1000)), q = pcm(silence(1000)), h = pcm(hiss(1500));
        d.process(v, v.length, 5); assertTrue("voice opens", d.isSignal());
        d.process(q, q.length, 5); assertTrue("a 1 s pause between phrases keeps it open", d.isSignal());
        d.process(v, v.length, 5); assertTrue(d.isSignal());
        d.process(h, h.length, 5); assertFalse("hiss (carrier gone) closes it", d.isSignal());
    }

    @Test public void silenceNeverOpens() {
        NoiseSquelchDetector d = new NoiseSquelchDetector(8000);
        byte[] q = pcm(silence(2000));
        d.process(q, q.length, 5); assertFalse(d.isSignal());
    }
}
