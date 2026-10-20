package com.macdmr.radio.ham;

import static org.junit.Assert.*;

import org.junit.Test;

import java.util.List;

public class SatTrackTest {
    // AMSAT elements for the ISS on 2026-10-20
    static final String L1 = "1 25544U 98067A   26293.20919040  .00007447  00000-0  14339-3 0  9992";
    static final String L2 = "2 25544  51.6325  41.4118 0006742 286.2755  73.7491 15.48951472591133";

    @Test public void passGeometryAndDoppler() {
        Sgp4 s = new Sgp4("ISS", L1, L2);
        long from = Math.round((s.epochJd - 2440587.5) * 86_400_000.0);
        List<SatTrack.Pass> ps = SatTrack.passes(s, from, 24, 44.98, -93.27, 260, 0);
        assertTrue("several passes a day", ps.size() >= 4);
        for (SatTrack.Pass p : ps) {
            assertTrue(p.los > p.tca && p.tca > p.aos);
            assertTrue("an ISS pass lasts under 12 minutes", p.durationS() < 720);
            SatTrack.Look a = SatTrack.look(s, p.aos + 5000, 44.98, -93.27, 260), b = SatTrack.look(s, p.los - 5000, 44.98, -93.27, 260);
            assertTrue("approaching after rise", a.rangeRateKmS < 0); assertTrue("receding before set", b.rangeRateKmS > 0);
            long up = SatTrack.downlink(437_800_000, a.rangeRateKmS);
            if (p.maxEl > 20) assertTrue("70 cm Doppler at the rise of a good pass is about +9 to +10 kHz, was " + (up - 437_800_000), up - 437_800_000 > 8000 && up - 437_800_000 < 11000);
            else assertTrue("a low pass stays far away: less Doppler", up - 437_800_000 > 0 && up - 437_800_000 < 8000);
            assertTrue("rises and sets near the horizon", Math.abs(SatTrack.look(s, p.aos, 44.98, -93.27, 260).el) < 0.2);
        }
        assertEquals(145_990_000 + 3000, SatTrack.uplink(145_990_000, 6.16), 50);    // 6.16 km/s receding: send higher
    }
}
