package com.macdmr.radio.ham;

import static org.junit.Assert.*;

import org.junit.Test;

public class BandPlanTest {
    private static BandPlan.Info at(double mhz) { return BandPlan.of(Math.round(mhz * 1e6)); }

    @Test public void amateurSegments() {
        assertTrue(at(146.52).use.contains("calling")); assertTrue(at(146.52).amateur);
        assertTrue(at(144.39).use.contains("APRS"));
        assertTrue(at(145.80).use.contains("ISS")); assertNotNull(at(145.80).caution);
        assertTrue(at(146.94).use.contains("repeater outputs"));
        assertTrue(at(146.34).use.contains("repeater inputs"));
        assertTrue(at(144.20).use.contains("SSB")); assertEquals("No FM here", at(144.20).caution);
        assertTrue(at(436.795).use.contains("satellite"));
        assertTrue(at(446.0).use.contains("calling"));
    }

    @Test public void otherServices() {
        assertFalse(at(162.55).amateur); assertEquals("Receive only", at(162.55).caution);
        assertTrue(at(154.325).caution.contains("public safety"));
        assertTrue(at(462.5625).use.startsWith("FRS"));
        assertTrue(at(467.625).use.contains("GMRS repeater inputs"));
        assertTrue(at(151.88).use.contains("MURS")); assertNull(at(151.88).caution);
        assertTrue(at(156.80).use.contains("Marine"));
        assertTrue(at(160.215).use.contains("railroad"));
        assertNull(BandPlan.of(200_000_000));
    }
}
