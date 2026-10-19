package com.macdmr.radio.coverage;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertNotEquals;
import static org.junit.Assert.assertTrue;

import java.util.Arrays;
import java.util.Collections;

import org.junit.Test;

public class CoverageMathTest {
    @Test public void fixes() {
        assertTrue(CoverageMath.fixUsable(8, 1000));
        assertFalse(CoverageMath.fixUsable(120, 1000));    // network fix
        assertFalse(CoverageMath.fixUsable(8, 60_000));    // stale
        assertFalse(CoverageMath.fixUsable(0, 1000));      // no accuracy reported
    }

    @Test public void keyupJudging() {
        int floor = CoverageMath.floor(Arrays.asList(-121, -119, -120, -122, -120));
        assertEquals(-120, floor);
        assertEquals(CoverageMath.KEYED, CoverageMath.judgeKeyup(Arrays.asList(-119, -96, -95), floor));          // tail
        assertEquals(CoverageMath.NO_REPLY, CoverageMath.judgeKeyup(Arrays.asList(-119, -118, -121), floor));    // nothing came back
        assertEquals(CoverageMath.KEYED, CoverageMath.judgeKeyup(Arrays.asList(-112), floor));                   // weak but clear tail
        assertEquals(CoverageMath.UNKNOWN, CoverageMath.judgeKeyup(Arrays.asList(-100), -999));                  // no floor yet
        assertEquals(CoverageMath.UNKNOWN, CoverageMath.judgeKeyup(Collections.<Integer>emptyList(), floor));
    }

    @Test public void gridCellsAreAbout150m() {
        double lat = 45.3, lon = -93.6;
        long c = CoverageMath.cell(lat, lon);
        double[] b = CoverageMath.cellBounds(c);
        assertTrue(lat >= b[0] && lat < b[2] && lon >= b[1] && lon < b[3]);
        double hM = (b[2] - b[0]) * 111_320, wM = (b[3] - b[1]) * 111_320 * Math.cos(Math.toRadians(lat));
        assertEquals(150, hM, 1); assertEquals(150, wM, 3);
        assertEquals(c, CoverageMath.cell(lat + 0.0001, lon + 0.0001));        // 11 m away: same cell (unless on an edge)
        assertNotEquals(c, CoverageMath.cell(lat + 0.01, lon));                // 1.1 km away
        long sw = CoverageMath.cell(-33.9, 151.2); double[] sb = CoverageMath.cellBounds(sw);   // southern/eastern hemisphere
        assertTrue(-33.9 >= sb[0] && -33.9 < sb[2] && 151.2 >= sb[1] && 151.2 < sb[3]);
        long ww = CoverageMath.cell(40.0, -120.0); double[] wb = CoverageMath.cellBounds(ww);
        assertTrue(-120.0 >= wb[1] && -120.0 < wb[3]);
    }

    @Test public void colours() {
        assertEquals(0xFF3B5BFF, CoverageMath.signalColor(-140));
        assertEquals(0xFFFF5468, CoverageMath.signalColor(-40));
        assertEquals(0xFF2BEA7A, CoverageMath.signalColor(-95));    // middle of the scale
    }

    @Test public void sUnits() {
        assertEquals("S9", CoverageMath.sUnits(-93));
        assertEquals("S9+20", CoverageMath.sUnits(-73));
        assertEquals("S9+5", CoverageMath.sUnits(-88));
        assertEquals("S9+30", CoverageMath.sUnits(-65));
        assertEquals("S8", CoverageMath.sUnits(-99));
        assertEquals("S5", CoverageMath.sUnits(-117));
    }
}
