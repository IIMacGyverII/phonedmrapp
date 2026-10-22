/*
 * SignalDeck - Copyright (C) 2026 IIMacGyverII
 * SPDX-License-Identifier: GPL-3.0-or-later
 * Free software under the GNU General Public License v3 or later, with the additional terms in COPYRIGHT
 * (keep this notice and the author credit, mark modified versions, no rights to the SignalDeck name or icon).
 */
package com.macdmr.radio;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNull;
import static org.junit.Assert.assertTrue;

import org.junit.Test;

/** Roger tones: right length at 8 kHz, silent lead, no clicks at the edges, well inside full scale. */
public class RogerTest {
    @Test public void offIsNull() { assertNull(RadioService.rogerPcm(0)); }

    @Test public void lengthsAndLevels() {
        int[] ms = { 0, 220, 310, 580 };
        for (int s = 1; s <= 3; s++) {
            short[] p = RadioService.rogerPcm(s);
            assertEquals(ms[s] * 8, p.length);
            for (int i = 0; i < 40 * 8; i++) assertEquals(0, p[i]);
            int peak = 0; for (short v : p) peak = Math.max(peak, Math.abs(v));
            assertTrue(peak > 9000 && peak <= 11000);
            assertTrue(Math.abs(p[p.length - 1]) < 800);
        }
    }
}
