/*
 * SignalDeck - Copyright (C) 2026 IIMacGyverII
 * SPDX-License-Identifier: GPL-3.0-or-later
 * Free software under the GNU General Public License v3 or later, with the additional terms in COPYRIGHT
 * (keep this notice and the author credit, mark modified versions, no rights to the SignalDeck name or icon).
 */
package com.macdmr.radio.coverage;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertTrue;

import org.junit.Test;

public class MorseTest {
    @Test public void paris() {
        assertEquals(43, Morse.units("PARIS"));          // the standard word is 50 units with its 7-unit word gap
        assertEquals(43 + 7 + 43, Morse.units("PARIS PARIS"));
    }

    @Test public void callsignIdFitsEasily() {
        short[] p = Morse.pcm("N0CALL/M", 20, 800);
        double seconds = p.length / 8000.0;
        assertTrue("id " + seconds + " s", seconds > 2 && seconds < 7);
        for (int i = 0; i < 300 * 8; i++) assertEquals(0, p[i]);   // silent lead while the transmitter settles
        int peak = 0; for (short v : p) peak = Math.max(peak, Math.abs(v)); assertTrue(peak > 10000 && peak <= 11000);
    }
}
