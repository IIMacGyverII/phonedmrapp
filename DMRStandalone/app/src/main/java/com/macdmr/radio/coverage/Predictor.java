/*
 * SignalDeck - Copyright (C) 2026 IIMacGyverII
 * SPDX-License-Identifier: GPL-3.0-or-later
 * Free software under the GNU General Public License v3 or later, with the additional terms in COPYRIGHT
 * (keep this notice and the author credit, mark modified versions, no rights to the SignalDeck name or icon).
 */
package com.macdmr.radio.coverage;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

/**
 * Terrain prediction for one repeater: path loss to every square of a grid around it, turned into
 * <ul>
 * <li>the repeater's signal at the phone (dBm), and</li>
 * <li>whether the phone should reach the repeater (the same path, the other way, against the repeater's receiver).</li>
 * </ul>
 * Both start from typical numbers (50 W repeater, 4 W handheld) and are corrected by what was measured: the
 * Heard readings shift the signal level ({@link #calibrateRx}), the key-ups move the reach limit
 * ({@link #calibrateTx}). Plain Java over an {@link Elevation} source, so it is unit tested with made-up hills.
 */
public final class Predictor {
    public interface Elevation { double at(double lat, double lon); }

    /** Trees, buildings and the body around a handheld, which the terrain does not show: a typical allowance (dB). */
    public static final double CLUTTER_DB = 12;
    /** Repeater ERP 50 W (47 dBm) + 2.15 dB to EIRP, handheld antenna -3 dBi, clutter: signal = this - path loss. */
    public static final double DOWNLINK_BUDGET = 47 + 2.15 - 3 - CLUTTER_DB;
    /** The same budget for a transmitter of {@code erpWatts} effective radiated power. */
    public static double downlinkBudget(double erpWatts) { return 10 * Math.log10(erpWatts * 1000) + 2.15 - 3 - CLUTTER_DB; }
    /** Handheld 4 W (36 dBm), -3 dBi antenna; repeater +6 dBi antenna, 2 dB feedline, -118 dBm sensitivity; clutter. */
    public static final double UPLINK_MAX_LOSS = 36 - 3 + 6 - 2 + 118 - CLUTTER_DB;
    /** Profile sample spacing (m) and the phone's antenna height (m). */
    public static final double SAMPLE_M = 100, RX_AGL = 1.5;

    public static final class Params {
        public double lat, lon, antennaAgl = 30, radiusM = 48_000, cellM = 300, sampleM = SAMPLE_M; public double hz;
        /** Signal at the phone = this - path loss (dBm); see {@link #downlinkBudget}. */
        public double budget = DOWNLINK_BUDGET;
    }

    /** One grid square: bounds and path loss. */
    public static final class Square { public double s, w, n, e, lat, lon, loss; }

    /** Path loss from the repeater to one point. */
    public static double loss(Elevation el, Params p, double lat, double lon) {
        double dist = metres(p.lat, p.lon, lat, lon);
        int n = Math.max(3, (int) Math.ceil(dist / p.sampleM) + 1);
        double[] prof = new double[n];
        for (int i = 0; i < n; i++) { double f = i / (double) (n - 1); prof[i] = el.at(p.lat + (lat - p.lat) * f, p.lon + (lon - p.lon) * f); }
        return Propagation.pathLoss(prof, dist / (n - 1), p.antennaAgl, RX_AGL, p.hz);
    }

    public interface Progress { boolean step(int done, int total); }   // false = cancel

    /** Path loss to every square within the radius (the repeater's own square skipped). Null when cancelled. */
    public static List<Square> grid(Elevation el, Params p, Progress pr) {
        double mLat = 111_320.0, mLon = 111_320.0 * Math.cos(Math.toRadians(p.lat));
        int half = (int) Math.ceil(p.radiusM / p.cellM);
        List<Square> out = new ArrayList<>();
        int total = (2 * half + 1) * (2 * half + 1), done = 0;
        for (int iy = -half; iy <= half; iy++) {
            for (int ix = -half; ix <= half; ix++, done++) {
                double cx = ix * p.cellM, cy = iy * p.cellM;
                if (cx * cx + cy * cy > p.radiusM * p.radiusM || (ix == 0 && iy == 0)) continue;
                Square s = new Square();
                s.lat = p.lat + cy / mLat; s.lon = p.lon + cx / mLon;
                s.s = s.lat - p.cellM / 2 / mLat; s.n = s.lat + p.cellM / 2 / mLat; s.w = s.lon - p.cellM / 2 / mLon; s.e = s.lon + p.cellM / 2 / mLon;
                s.loss = loss(el, p, s.lat, s.lon);
                out.add(s);
            }
            if (pr != null && !pr.step(done, total)) return null;
        }
        return out;
    }

    /**
     * Signal correction (dB) from Heard measurements: the median of (measured - predicted) over the given
     * points {lat, lon, dBm}. 0 without measurements.
     */
    public static double calibrateRx(Elevation el, Params p, List<double[]> measured) {
        if (measured == null || measured.isEmpty()) return 0;
        double[] diff = new double[measured.size()];
        for (int i = 0; i < diff.length; i++) { double[] m = measured.get(i); diff[i] = m[2] - (p.budget - loss(el, p, m[0], m[1])); }
        Arrays.sort(diff);
        int n = diff.length; return n % 2 == 1 ? diff[n / 2] : (diff[n / 2 - 1] + diff[n / 2]) / 2;
    }

    /**
     * How far (m) the signal can reach before it falls below {@code floorDbm} over flat ground, for choosing the
     * prediction's range: hills only shorten it. Stepped in 2 km, up to {@code maxM}.
     */
    public static double reachM(Params p, double floorDbm, double maxM) {
        for (double d = 2000; d <= maxM; d += 2000) {
            int n = Math.max(3, (int) Math.ceil(d / 200) + 1);
            double l = Propagation.pathLoss(new double[n], d / (n - 1), p.antennaAgl, RX_AGL, p.hz);
            if (p.budget - l < floorDbm) return d;
        }
        return maxM;
    }

    /** Antenna heights tried when fitting the measurements (m above ground). */
    public static final double[] FIT_HEIGHTS = { 10, 15, 20, 30, 45, 60, 90, 120, 180, 250, 350 };

    /**
     * The repeater antenna height that best explains the Heard measurements {lat, lon, dBm}: for each candidate
     * height the level is calibrated ({@link #calibrateRx}) and the spread of what is left (median absolute
     * deviation) is compared; the height with the smallest spread wins. Height changes the shape (how far the
     * signal carries over the terrain), the level only shifts it, so this needs readings at a range of distances.
     * Returns {height, level correction, spread dB}.
     */
    public static double[] fitAntenna(Elevation el, Params p, List<double[]> measured) {
        double bestH = p.antennaAgl, bestOff = 0, bestSpread = Double.MAX_VALUE;
        double keep = p.antennaAgl;
        for (double h : FIT_HEIGHTS) {
            p.antennaAgl = h;
            double[] diff = new double[measured.size()];
            for (int i = 0; i < diff.length; i++) { double[] m = measured.get(i); diff[i] = m[2] - (p.budget - loss(el, p, m[0], m[1])); }
            double off = median(diff.clone());
            double[] dev = new double[diff.length]; for (int i = 0; i < dev.length; i++) dev[i] = Math.abs(diff[i] - off);
            double spread = median(dev);
            if (spread < bestSpread - 0.25) { bestSpread = spread; bestH = h; bestOff = off; }   // a clearly better fit; ties keep the lower antenna
        }
        p.antennaAgl = keep;
        return new double[] { bestH, bestOff, bestSpread };
    }

    static double median(double[] a) { Arrays.sort(a); int n = a.length; return n == 0 ? 0 : n % 2 == 1 ? a[n / 2] : (a[n / 2 - 1] + a[n / 2]) / 2; }

    /**
     * Reach limit (largest path loss that still keys the repeater) from key-up attempts {lat, lon, keyed 1/0}:
     * the limit that classifies the most attempts correctly; with keyed attempts only it is at least the worst
     * of them; with failures only it is below the best of them. The default without attempts.
     */
    public static double calibrateTx(Elevation el, Params p, List<double[]> attempts) {
        if (attempts == null || attempts.isEmpty()) return UPLINK_MAX_LOSS;
        int n = attempts.size(); double[] l = new double[n]; boolean[] ok = new boolean[n];
        double maxOk = -1, minFail = 1e9; int nOk = 0;
        for (int i = 0; i < n; i++) {
            double[] a = attempts.get(i); l[i] = loss(el, p, a[0], a[1]); ok[i] = a[2] > 0.5;
            if (ok[i]) { nOk++; maxOk = Math.max(maxOk, l[i]); } else minFail = Math.min(minFail, l[i]);
        }
        if (nOk == n) return Math.max(UPLINK_MAX_LOSS, maxOk);
        if (nOk == 0) return Math.min(UPLINK_MAX_LOSS, minFail - 1);
        double best = UPLINK_MAX_LOSS; int bestErr = Integer.MAX_VALUE;
        double[] cand = l.clone(); Arrays.sort(cand);
        for (int c = 0; c <= n; c++) {
            double thr = c == 0 ? cand[0] - 1 : c == n ? cand[n - 1] + 1 : (cand[c - 1] + cand[c]) / 2;
            int err = 0; for (int i = 0; i < n; i++) if ((l[i] <= thr) != ok[i]) err++;
            if (err < bestErr || (err == bestErr && Math.abs(thr - UPLINK_MAX_LOSS) < Math.abs(best - UPLINK_MAX_LOSS))) { bestErr = err; best = thr; }
        }
        return best;
    }

    static double metres(double lat1, double lon1, double lat2, double lon2) {
        double dLat = Math.toRadians(lat2 - lat1), dLon = Math.toRadians(lon2 - lon1);
        double a = Math.sin(dLat / 2) * Math.sin(dLat / 2) + Math.cos(Math.toRadians(lat1)) * Math.cos(Math.toRadians(lat2)) * Math.sin(dLon / 2) * Math.sin(dLon / 2);
        return 2 * 6_371_000.0 * Math.asin(Math.min(1, Math.sqrt(a)));
    }
}
