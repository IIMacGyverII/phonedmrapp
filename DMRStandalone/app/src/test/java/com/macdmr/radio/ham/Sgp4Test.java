/*
 * SignalDeck - Copyright (C) 2026 IIMacGyverII
 * SPDX-License-Identifier: GPL-3.0-or-later
 * Free software under the GNU General Public License v3 or later, with the additional terms in COPYRIGHT
 * (keep this notice and the author credit, mark modified versions, no rights to the SignalDeck name or icon).
 */
package com.macdmr.radio.ham;

import static org.junit.Assert.*;

import org.junit.Test;

/** Vallado's SGP4 verification case for satellite 00005 (Vanguard 1, near earth). */
public class Sgp4Test {
    static final String L1 = "1 00005U 58002B   00179.78495062  .00000023  00000-0  28098-4 0  4753";
    static final String L2 = "2 00005  34.2682 348.7242 1859667 331.7664  19.3264 10.82419157413667";

    @Test public void matchesTheVerificationOutput() {
        Sgp4 s = new Sgp4("VANGUARD 1", L1, L2);
        assertFalse(s.deepSpace);
        double[] p0 = s.propagate(0);
        assertEquals(7022.465292, p0[0], 1e-3); assertEquals(-1400.082967, p0[1], 1e-3); assertEquals(0.039952, p0[2], 1e-3);
        assertEquals(1.893841, p0[3], 1e-5); assertEquals(6.405894, p0[4], 1e-5); assertEquals(4.534807, p0[5], 1e-5);
        double[] p360 = s.propagate(360);
        assertEquals(-7154.031202, p360[0], 1e-3); assertEquals(-3783.176825, p360[1], 1e-3); assertEquals(-3536.194122, p360[2], 1e-3);
        assertEquals(4.741887, p360[3], 1e-5); assertEquals(-4.151818, p360[4], 1e-5); assertEquals(-2.093935, p360[5], 1e-5);
    }

    @Test public void tleFields() {
        Sgp4 s = new Sgp4("V", L1, L2);
        assertEquals(5, s.catalog);
        assertEquals(0.28098e-4, s.bstar, 1e-12);
        assertEquals(2451723.28495062, s.epochJd, 1e-6);       // 2000 day 179.78495062
        assertEquals(-0.12345e-3, Sgp4.expo("-12345-3"), 1e-15);
    }

    @Test public void siderealTime() {
        // GMST at J2000.0 (2000-01-01 12:00 UT1) is 280.46061837 degrees
        assertEquals(280.46061837, Math.toDegrees(Sgp4.gmst(2451545.0)), 1e-4);
    }
}
