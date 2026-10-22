/*
 * SignalDeck - Copyright (C) 2026 IIMacGyverII
 * SPDX-License-Identifier: GPL-3.0-or-later
 * Free software under the GNU General Public License v3 or later, with the additional terms in COPYRIGHT
 * (keep this notice and the author credit, mark modified versions, no rights to the SignalDeck name or icon).
 */
package com.macdmr.radio.pkt;

import static org.junit.Assert.*;

import org.junit.Test;

import java.util.Calendar;
import java.util.TimeZone;

public class AprsExtrasTest {
    private static long utc(int day, int h, int m) { Calendar c = Calendar.getInstance(TimeZone.getTimeZone("UTC")); c.clear(); c.set(2026, Calendar.OCTOBER, day, h, m); return c.getTimeInMillis(); }

    @Test public void objectReport() {
        assertEquals(";NETCTL   *201435z4512.34N/09330.00WNNet control here",
                AprsExtras.objectInfo("NETCTL", true, 45.20567, -93.5, '/', 'N', "Net control here", utc(20, 14, 35)));
        assertEquals(";HAZARD-1 _011200z4500.00N\\09300.00W!", AprsExtras.objectInfo("HAZARD-1", false, 45.0, -93.0, '\\', '!', "", utc(1, 12, 0)));
        assertEquals("name cut to 9", ";ABCDEFGHI*", AprsExtras.objectInfo("ABCDEFGHIJK", true, 0, 0, '/', '/', "", 0).substring(0, 11));
    }

    @Test public void telemetry() {
        assertEquals("T#007,087,090,071,113,032,00000000", AprsExtras.telemetryInfo(7, AprsExtras.telemetryValues(87, 3.9, 31.2, 1012.6, -108)));
        assertEquals("T#999,000,255,000,000,000,00000000", AprsExtras.telemetryInfo(1999, new int[] { -5, 300 }).replace("T#999", "T#999"));
    }

    @Test public void weatherReportCarriesPressureInTenths() {
        String w = AprsExtras.weatherInfo(45.0, -93.0, 1013.25, "phone barometer");
        assertEquals("=4500.00N/09300.00W_.../...g...t...b10133phone barometer", w);
        assertEquals(1013.25, AprsExtras.seaLevel(1013.25, 0), 1e-9);
        assertEquals("about 1 hPa per 8.4 m near the ground", 1013.25, AprsExtras.seaLevel(1001.3, 100), 0.6);
    }

    @Test public void thirdPartyWrapsTheInternetLine() {
        assertEquals("}W1AW-9>APRS,TCPIP,N0CALL-10*::K0ABC    :hello{12",
                AprsExtras.thirdParty("W1AW-9>APRS,TCPIP*,qAC,T2USA::K0ABC    :hello{12", "N0CALL-10"));
        assertNull(AprsExtras.thirdParty("garbage", "N0CALL"));
    }

    @Test public void smartBeaconing() {
        AprsExtras.SmartBeacon sb = new AprsExtras.SmartBeacon();
        assertEquals(1800, sb.rate(0)); assertEquals(180, sb.rate(70)); assertEquals(360, sb.rate(30));
        long t = 1_000_000;
        assertTrue("first fix beacons", sb.due(t, 30, 90));
        assertFalse(sb.due(t + 200_000, 30, 92));
        assertTrue("rate reached at 30 mph", sb.due(t + 361_000, 30, 92));
        long t2 = t + 361_000;
        assertFalse("turn too soon", sb.due(t2 + 20_000, 30, 180));
        assertTrue("a sharp turn after 30 s", sb.due(t2 + 31_000, 30, 180));
        assertFalse("parked: no turn beacons", sb.due(t2 + 70_000, 2, 0));
    }
}
