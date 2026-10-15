package com.dmrmod.hooks;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertNull;
import static org.junit.Assert.assertTrue;

import org.junit.Test;

/** Host unit tests for {@link GeoUtil} (Nearby Repeaters P0.3). No device needed. */
public class GeoUtilTest {

    private static final double EPS_M = 1.0;      // metres
    private static final double EPS_DEG = 0.5;    // bearing degrees

    @Test public void haversineKnownDistance() {
        // Chicago (41.8781,-87.6298) to NYC City Hall (40.7128,-74.0060): ~1145 km great-circle.
        double m = GeoUtil.haversineMeters(41.8781, -87.6298, 40.7128, -74.0060);
        assertEquals(1145000.0, m, 15000.0);
    }

    @Test public void haversineZero() {
        assertEquals(0.0, GeoUtil.haversineMeters(51.5, -0.1, 51.5, -0.1), EPS_M);
    }

    @Test public void bearingCardinals() {
        // Due north: same longitude, higher latitude.
        assertEquals(0.0, GeoUtil.bearingDegrees(40, -80, 41, -80), EPS_DEG);
        // Due east near the equator.
        assertEquals(90.0, GeoUtil.bearingDegrees(0, 0, 0, 1), EPS_DEG);
        // Due south.
        assertEquals(180.0, GeoUtil.bearingDegrees(41, -80, 40, -80), EPS_DEG);
    }

    @Test public void directionArrows() {
        assertEquals("↑N", GeoUtil.directionArrow(0));
        assertEquals("↗NE", GeoUtil.directionArrow(45));
        assertEquals("→E", GeoUtil.directionArrow(90));
        assertEquals("↓S", GeoUtil.directionArrow(180));
        assertEquals("←W", GeoUtil.directionArrow(270));
        assertEquals("↑N", GeoUtil.directionArrow(359));   // wraps back to N
        assertEquals("↑N", GeoUtil.directionArrow(360));
    }

    @Test public void formatDistanceUnits() {
        assertEquals("500m", GeoUtil.formatDistance(500));
        assertEquals("5.0km", GeoUtil.formatDistance(5000));
        assertTrue(GeoUtil.formatDistance(50000).endsWith("mi"));
    }

    @Test public void bandClassification() {
        assertEquals(GeoUtil.BAND_VHF, GeoUtil.band(146_940_000L));
        assertEquals(GeoUtil.BAND_UHF, GeoUtil.band(439_712_500L));
        assertEquals(GeoUtil.BAND_UHF, GeoUtil.band(462_562_500L));   // GMRS is inside 400-480 (band-legal; licence is separate)
        assertEquals(GeoUtil.BAND_OTHER, GeoUtil.band(223_500_000L)); // 1.25 m, excluded
        assertTrue(GeoUtil.inRadioRange(146_940_000L));
        assertFalse(GeoUtil.inRadioRange(223_500_000L));
    }

    @Test public void mhzToHzRounds() {
        assertEquals(439712500L, GeoUtil.mhzToHz(439.7125));
        assertEquals(146940000L, GeoUtil.mhzToHz(146.94));
    }

    @Test public void maidenheadRoundTrip() {
        // A known-ish point; round-trip must land within one subsquare (~0.02 lat, ~0.04 lon).
        double lat = 41.8781, lon = -87.6298;
        String grid = GeoUtil.latLonToMaidenhead(lat, lon);
        assertEquals(6, grid.length());
        double[] ll = GeoUtil.maidenheadToLatLon(grid);
        assertNotNull(ll);
        assertEquals(lat, ll[0], 0.03);
        assertEquals(lon, ll[1], 0.05);
    }

    @Test public void maidenheadFieldAnchor() {
        // IO87QP (Banff, Scotland) should decode near 57.6, -2.6.
        double[] ll = GeoUtil.maidenheadToLatLon("IO87QP");
        assertNotNull(ll);
        assertEquals(57.6, ll[0], 0.1);
        assertEquals(-2.6, ll[1], 0.2);
    }

    @Test public void maidenheadRejectsJunk() {
        assertNull(GeoUtil.maidenheadToLatLon("ZZ99"));   // field letters only go to R
        assertNull(GeoUtil.maidenheadToLatLon("ABCDE"));  // wrong length
        assertNull(GeoUtil.maidenheadToLatLon(null));
    }

    @Test public void findLocatorInText() {
        assertEquals("IO87QP", GeoUtil.findLocator("Banff, IO87QP"));
        assertEquals("IN80DO", GeoUtil.findLocator("Somewhere IN80DO"));
        assertNull(GeoUtil.findLocator("Chicago"));
        assertNull(GeoUtil.findLocator(null));
    }
}
