package com.macdmr.radio.coverage;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertTrue;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import org.junit.Test;

public class PredictorTest {
    @Test public void freeSpace() {
        assertEquals(105.5, Propagation.fspl(10_000, 450e6), 0.1);
        assertEquals(0, Propagation.knifeEdge(-1), 1e-9);
        assertEquals(6.0, Propagation.knifeEdge(0), 0.1);             // grazing edge: about 6 dB
        assertTrue(Propagation.knifeEdge(2.4) > 19 && Propagation.knifeEdge(2.4) < 21);
    }

    @Test public void flatGroundIsBetweenFreeSpaceAndPlaneEarth() {
        double[] flat = new double[101];
        double l = Propagation.pathLoss(flat, 100, 30, 1.5, 450e6);   // 10 km: free space 105.5 dB, plane earth 40 log d - 20 log(h1 h2) = 127 dB
        assertTrue("flat " + l, l > Propagation.fspl(10_000, 450e6) + 5 && l < 128);
    }

    @Test public void smoothEarthMatchesTheTextbook() {
        // plane earth at 20 km (inside the 27.6 km radio horizon), 30 m and 1.5 m: 40 log d - 20 log h1 h2 = 139.0 dB
        assertEquals(139.0, Propagation.smoothEarth(20_000, 30, 1.5, 162.5e6), 0.2);
        // beyond the horizon it keeps falling much faster than free space
        double at60 = Propagation.smoothEarth(60_000, 30, 1.5, 162.5e6), at120 = Propagation.smoothEarth(120_000, 30, 1.5, 162.5e6);
        assertTrue("60 km " + at60 + ", 120 km " + at120, at120 - at60 > 25);
        // a taller antenna sees further: less loss at the same distance
        assertTrue(Propagation.smoothEarth(60_000, 100, 1.5, 162.5e6) < at60 - 10);
        // never better than free space
        assertTrue(Propagation.smoothEarth(500, 30, 1.5, 162.5e6) >= Propagation.fspl(500, 162.5e6));
    }

    @Test public void ridgeShadows() {
        double[] flat = new double[101], ridge = new double[101];
        for (int i = 45; i <= 55; i++) ridge[i] = 150;                  // a 150 m hill halfway
        double open = Propagation.pathLoss(flat, 100, 30, 1.5, 450e6), hidden = Propagation.pathLoss(ridge, 100, 30, 1.5, 450e6);
        assertTrue("ridge adds " + (hidden - open), hidden - open > 8);    // on top of the flat-ground (plane earth) loss
        double[] high = ridge.clone(); high[0] = 400;                   // repeater on a 400 m mountain sees over it
        assertTrue(Propagation.pathLoss(high, 100, 30, 1.5, 450e6) < hidden - 15);
    }

    @Test public void fitsTheAntennaHeight() {
        Predictor.Elevation hills = (lat, lon) -> 250 + 40 * Math.sin(lat * 900) + 30 * Math.cos(lon * 700);
        Predictor.Params truth = new Predictor.Params(); truth.lat = 45.0; truth.lon = -93.0; truth.hz = 162.55e6; truth.antennaAgl = 120;
        java.util.List<double[]> m = new ArrayList<>();
        for (int i = 0; i < 24; i++) {                                   // readings 3 to 40 km out in different directions
            double brg = i * 0.9, km = 3 + i * 1.6;
            double lat = 45.0 + km / 111.32 * Math.cos(brg), lon = -93.0 + km / (111.32 * Math.cos(Math.toRadians(45))) * Math.sin(brg);
            m.add(new double[] { lat, lon, Predictor.DOWNLINK_BUDGET - Predictor.loss(hills, truth, lat, lon) + 10 });
        }
        Predictor.Params guess = new Predictor.Params(); guess.lat = 45.0; guess.lon = -93.0; guess.hz = 162.55e6; guess.antennaAgl = 30;
        double[] fit = Predictor.fitAntenna(hills, guess, m);
        assertEquals(120, fit[0], 1e-9);
        assertEquals(10, fit[1], 0.5);
        assertEquals(30, guess.antennaAgl, 1e-9);                        // the caller's params are left as they were
    }

    @Test public void reachGrowsWithPowerAndHeight() {
        Predictor.Params small = new Predictor.Params(); small.hz = 162.5e6; small.antennaAgl = 30; small.budget = Predictor.downlinkBudget(50);
        Predictor.Params big = new Predictor.Params(); big.hz = 162.5e6; big.antennaAgl = 85; big.budget = Predictor.downlinkBudget(1000);
        double a = Predictor.reachM(small, CoverageMath.SCALE_LOW, 200_000), b = Predictor.reachM(big, CoverageMath.SCALE_LOW, 200_000);
        assertTrue("50 W/30 m " + a + ", 1000 W/85 m " + b, b > a * 1.5 && a >= 10_000);
    }

    @Test public void gridAndCalibration() {
        Predictor.Elevation flat = (lat, lon) -> 250;
        Predictor.Elevation hill = (lat, lon) -> (lat > 45.05 && lat < 45.06) ? 450 : 250;   // an east-west ridge 6 km north
        Predictor.Params p = new Predictor.Params(); p.lat = 45.0; p.lon = -93.0; p.hz = 146.94e6; p.radiusM = 12_000; p.cellM = 1000;
        List<Predictor.Square> g = Predictor.grid(flat, p, null);
        assertTrue(g.size() > 400 && g.size() < 470);                   // pi * 12^2 squares
        double near = Predictor.loss(flat, p, 45.01, -93.0), far = Predictor.loss(flat, p, 45.1, -93.0);
        assertTrue(far > near + 15);
        assertTrue(Predictor.loss(hill, p, 45.1, -93.0) > Predictor.loss(flat, p, 45.1, -93.0) + 15);   // behind the ridge
        assertEquals(Predictor.loss(hill, p, 44.95, -93.0), Predictor.loss(flat, p, 44.95, -93.0), 0.5); // the other side: no hill

        // Heard readings 7 dB above the model: calibration says +7
        List<double[]> m = new ArrayList<>();
        for (double lat : new double[] { 45.02, 45.03, 44.98 }) m.add(new double[] { lat, -93.0, Predictor.DOWNLINK_BUDGET - Predictor.loss(flat, p, lat, -93.0) + 7 });
        assertEquals(7, Predictor.calibrateRx(flat, p, m), 0.01);

        // key-ups: keyed near, failed far -> limit between them
        double lNear = Predictor.loss(flat, p, 45.02, -93.0), lFar = Predictor.loss(flat, p, 45.09, -93.0);
        double thr = Predictor.calibrateTx(flat, p, Arrays.asList(new double[] { 45.02, -93.0, 1 }, new double[] { 45.09, -93.0, 0 }));
        assertTrue(thr > lNear && thr < lFar);
        assertEquals(Predictor.UPLINK_MAX_LOSS, Predictor.calibrateTx(flat, p, null), 1e-9);
    }
}
