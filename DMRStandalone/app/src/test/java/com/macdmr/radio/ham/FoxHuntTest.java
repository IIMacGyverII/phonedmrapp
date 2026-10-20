package com.macdmr.radio.ham;

import static org.junit.Assert.*;

import org.junit.Test;

public class FoxHuntTest {
    private static final double LAT = 45.2, LON = -93.5;

    /** Bearing in degrees true from (la, lo) to (la2, lo2), flat-earth (fine over a few km). */
    private static double bearing(double la, double lo, double la2, double lo2) {
        double x = Math.toRadians(lo2 - lo) * Math.cos(Math.toRadians(la)), y = Math.toRadians(la2 - la);
        return (Math.toDegrees(Math.atan2(x, y)) + 360) % 360;
    }
    private static double metres(double la, double lo, double la2, double lo2) {
        double x = Math.toRadians(lo2 - lo) * 6371000 * Math.cos(Math.toRadians(la)), y = Math.toRadians(la2 - la) * 6371000; return Math.hypot(x, y);
    }

    @Test public void bearingsCrossAtTheFox() {
        double fl = LAT + 0.01, fo = LON + 0.015;              // about 1.1 km north, 1.2 km east
        FoxHunt f = new FoxHunt();
        double[][] spots = { { LAT, LON }, { LAT + 0.004, LON - 0.006 }, { LAT - 0.003, LON + 0.012 } };
        int dbm = -100;
        for (double[] s : spots) f.add(new FoxHunt.Mark(s[0], s[1], dbm++, bearing(s[0], s[1], fl, fo) + (dbm % 2 == 0 ? 2 : -2), 0));   // 2 degrees of error
        FoxHunt.Estimate e = f.estimate();
        assertTrue(e.fromBearings);
        assertEquals(3, e.used);
        assertTrue("within 120 m, was " + metres(e.lat, e.lon, fl, fo), metres(e.lat, e.lon, fl, fo) < 120);
    }

    @Test public void parallelBearingsFallBackToTheStrongestSpot() {
        FoxHunt f = new FoxHunt();
        f.add(new FoxHunt.Mark(LAT, LON, -100, 90, 0));
        f.add(new FoxHunt.Mark(LAT + 0.001, LON, -80, 90, 0));
        FoxHunt.Estimate e = f.estimate();
        assertFalse(e.fromBearings);
        assertEquals(LAT + 0.001, e.lat, 1e-9);
    }

    @Test public void crossingBehindTheHunterIsRejected() {
        FoxHunt f = new FoxHunt();                               // two bearings pointing away from where their lines meet
        f.add(new FoxHunt.Mark(LAT, LON, -90, 45, 0));
        f.add(new FoxHunt.Mark(LAT, LON + 0.01, -95, 315, 0));
        f.add(new FoxHunt.Mark(LAT + 0.002, LON + 0.005, -85, Double.NaN, 0));
        FoxHunt.Estimate e = f.estimate();
        // 45 from the west spot and 315 from the east spot meet north of both: in front, accepted
        assertTrue(e.fromBearings);
        FoxHunt g = new FoxHunt();
        g.add(new FoxHunt.Mark(LAT, LON, -90, 225, 0));
        g.add(new FoxHunt.Mark(LAT, LON + 0.01, -95, 135, 0));
        assertFalse("lines meet behind both hunters", g.estimate().fromBearings);
    }

    @Test public void beaconFitsTheTransmitLimit() {
        short[] b = FoxHunt.beacon(5, "N0CALL");
        assertTrue(b.length > 8000 * 5 && b.length < 8000 * 20);
        assertEquals(8000 * 3 / 10 + 20 * 2000, FoxHunt.beacon(5, null).length);
    }
}
