/*
 * SignalDeck - Copyright (C) 2026 IIMacGyverII
 * SPDX-License-Identifier: GPL-3.0-or-later
 * Free software under the GNU General Public License v3 or later, with the additional terms in COPYRIGHT
 * (keep this notice and the author credit, mark modified versions, no rights to the SignalDeck name or icon).
 */
package com.macdmr.radio.ham;

import java.util.ArrayList;
import java.util.List;

/** Where a satellite is from the observer (azimuth, elevation, range, range rate), its passes, and the Doppler shift. */
public final class SatTrack {
    private SatTrack() { }
    static final double OMEGA = 7.292115e-5, C = 299792.458;

    public static final class Look { public double az, el, rangeKm, rangeRateKmS; }
    public static final class Pass { public long aos, los, tca; public double maxEl, aosAz, losAz; public long durationS() { return (los - aos) / 1000; } }

    /** Observer position in ECEF km (WGS-84). */
    static double[] observer(double lat, double lon, double altM) {
        double a = 6378.137, f = 1 / 298.257223563, e2 = f * (2 - f), la = Math.toRadians(lat), lo = Math.toRadians(lon), h = altM / 1000.0;
        double n = a / Math.sqrt(1 - e2 * Math.sin(la) * Math.sin(la));
        return new double[] { (n + h) * Math.cos(la) * Math.cos(lo), (n + h) * Math.cos(la) * Math.sin(lo), (n * (1 - e2) + h) * Math.sin(la) };
    }

    public static Look look(Sgp4 s, long utcMs, double lat, double lon, double altM) {
        double[] rv = s.at(utcMs);
        double th = Sgp4.gmst(Sgp4.jdOf(utcMs)), c = Math.cos(th), sn = Math.sin(th);
        double x = c * rv[0] + sn * rv[1], y = -sn * rv[0] + c * rv[1], z = rv[2];
        double vx = c * rv[3] + sn * rv[4] + OMEGA * y, vy = -sn * rv[3] + c * rv[4] - OMEGA * x, vz = rv[5];   // earth-fixed velocity
        double[] o = observer(lat, lon, altM);
        double px = x - o[0], py = y - o[1], pz = z - o[2], range = Math.sqrt(px * px + py * py + pz * pz);
        double la = Math.toRadians(lat), lo = Math.toRadians(lon);
        double south = Math.sin(la) * Math.cos(lo) * px + Math.sin(la) * Math.sin(lo) * py - Math.cos(la) * pz;
        double east = -Math.sin(lo) * px + Math.cos(lo) * py;
        double up = Math.cos(la) * Math.cos(lo) * px + Math.cos(la) * Math.sin(lo) * py + Math.sin(la) * pz;
        Look l = new Look();
        l.rangeKm = range; l.el = Math.toDegrees(Math.asin(up / range));
        l.az = (Math.toDegrees(Math.atan2(east, -south)) + 360) % 360;
        l.rangeRateKmS = (px * vx + py * vy + pz * vz) / range;
        return l;
    }

    /** Passes starting within {@code hours} of {@code fromMs} that rise above {@code minEl} degrees at their highest. */
    public static List<Pass> passes(Sgp4 s, long fromMs, double hours, double lat, double lon, double altM, double minEl) {
        List<Pass> out = new ArrayList<>();
        long end = fromMs + (long) (hours * 3600_000), step = 30_000;
        double prev = look(s, fromMs, lat, lon, altM).el;
        Pass cur = null;
        if (prev > 0) { cur = new Pass(); cur.aos = fromMs; cur.aosAz = look(s, fromMs, lat, lon, altM).az; }
        for (long t = fromMs + step; t <= end + 3600_000 && (t <= end || cur != null); t += step) {
            Look l = look(s, t, lat, lon, altM);
            if (prev <= 0 && l.el > 0) { cur = new Pass(); cur.aos = edge(s, t - step, t, lat, lon, altM); cur.aosAz = look(s, cur.aos, lat, lon, altM).az; }
            if (cur != null && l.el > cur.maxEl) { cur.maxEl = l.el; cur.tca = t; }
            if (prev > 0 && l.el <= 0 && cur != null) {
                cur.los = edge(s, t - step, t, lat, lon, altM); cur.losAz = look(s, cur.los, lat, lon, altM).az;
                refineTca(s, cur, lat, lon, altM);
                if (cur.maxEl >= minEl && cur.aos <= end) out.add(cur);
                cur = null;
            }
            prev = l.el;
        }
        return out;
    }

    /** The moment the elevation crosses zero between {@code a} and {@code b}, to a second. */
    private static long edge(Sgp4 s, long a, long b, double lat, double lon, double altM) {
        boolean upAtA = look(s, a, lat, lon, altM).el > 0;
        while (b - a > 1000) { long m = (a + b) / 2; if ((look(s, m, lat, lon, altM).el > 0) == upAtA) a = m; else b = m; }
        return (a + b) / 2;
    }
    private static void refineTca(Sgp4 s, Pass p, double lat, double lon, double altM) {
        long a = Math.max(p.aos, p.tca - 30_000), b = Math.min(p.los, p.tca + 30_000);
        for (long t = a; t <= b; t += 1000) { double el = look(s, t, lat, lon, altM).el; if (el > p.maxEl) { p.maxEl = el; p.tca = t; } }
    }

    /** The frequency heard on the ground for a satellite transmitting {@code hz} (range rate positive = receding). */
    public static long downlink(long hz, double rangeRateKmS) { return Math.round(hz * (1 - rangeRateKmS / C)); }
    /** What to transmit so the satellite hears {@code hz}. */
    public static long uplink(long hz, double rangeRateKmS) { return Math.round(hz * (1 + rangeRateKmS / C)); }
}
