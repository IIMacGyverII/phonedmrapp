package com.macdmr.radio.coverage;

/**
 * Path loss over terrain = smooth-earth loss (plane earth within the radio horizon, ITU-R P.526 spherical-earth
 * diffraction beyond it, with antenna heights taken above the surrounding ground) + what the hills add: the
 * knife-edge diffraction of the real profile (Deygout: the main obstacle, then the strongest one on each side)
 * minus that of a smooth profile. Earth curvature at the usual effective radius (k = 4/3). Knife edges alone
 * ignore the ground reflection and read 20 dB or more too optimistic at range; plane earth alone ignores hills.
 * Good for a first look at where hills shadow a repeater; it knows nothing of trees and buildings, which is
 * why the predictor calibrates it with real measurements.
 */
public final class Propagation {
    private Propagation() { }

    static final double EARTH_R = 6_371_000.0, K = 4.0 / 3.0;

    /** Free-space path loss in dB. */
    public static double fspl(double meters, double hz) {
        double km = Math.max(meters, 1) / 1000.0, mhz = hz / 1e6;
        return 20 * Math.log10(km) + 20 * Math.log10(mhz) + 32.44;
    }

    /** ITU-R P.526 single knife-edge loss for diffraction parameter v (dB, 0 below v = -0.78). */
    public static double knifeEdge(double v) {
        if (v <= -0.78) return 0;
        return 6.9 + 20 * Math.log10(Math.sqrt((v - 0.1) * (v - 0.1) + 1) + v - 0.1);
    }

    /**
     * Total path loss (dB) along a terrain profile: {@code terrain[i]} is the ground height (m) at
     * {@code i * step} metres from the transmitter; the antennas stand {@code txAgl} and {@code rxAgl} above the
     * ground at the two ends.
     */
    public static double pathLoss(double[] terrain, double step, double txAgl, double rxAgl, double hz) {
        int n = terrain.length;
        double d = (n - 1) * step;
        if (n < 3) return fspl(d, hz);
        double lambda = 299_792_458.0 / hz;
        double ha = terrain[0] + txAgl, hb = terrain[n - 1] + rxAgl;
        // what the real terrain adds over smooth ground: its diffraction loss minus that of a smooth profile (which only has
        // the earth's bulge, already inside the smooth-earth term)
        double terrainDiff = deygout(terrain, step, 0, n - 1, ha, hb, lambda, 0);
        double smoothDiff = deygout(new double[n], step, 0, n - 1, txAgl, rxAgl, lambda, 0);
        double excess = Math.max(0, terrainDiff - smoothDiff);
        // effective heights for the smooth-earth part: above the average ground along the path (tx) and near the phone (rx),
        // so a transmitter on a hill or a phone on a rise keeps its advantage
        double meanAll = 0; int from = Math.max(1, n / 10); for (int i = from; i < n; i++) meanAll += terrain[i]; meanAll /= Math.max(1, n - from);
        int near = Math.max(1, (int) Math.round(2000 / step)); double meanNear = 0; int cnt = 0;
        for (int i = Math.max(0, n - 1 - near); i < n; i++) { meanNear += terrain[i]; cnt++; } meanNear /= Math.max(1, cnt);
        double h1 = Math.max(1, txAgl + terrain[0] - meanAll), h2 = Math.max(rxAgl, rxAgl + terrain[n - 1] - meanNear);
        return smoothEarth(d, h1, h2, hz) + excess;
    }

    /** Effective earth radius (km) for k = 4/3. */
    static final double AE_KM = K * EARTH_R / 1000;

    /**
     * Loss over a smooth earth (dB): within the radio horizon the plane-earth loss (direct ray and ground reflection,
     * 40 log d - 20 log h1 h2), never less than free space; beyond it free space plus the ITU-R P.526 spherical-earth
     * diffraction loss (F(X) + G(Y1) + G(Y2), land, vertical polarisation, beta = 1).
     */
    public static double smoothEarth(double meters, double h1, double h2, double hz) {
        double d = Math.max(meters, 1), dKm = d / 1000, mhz = hz / 1e6;
        double horizonKm = (Math.sqrt(2 * AE_KM * 1000 * h1) + Math.sqrt(2 * AE_KM * 1000 * h2)) / 1000;
        double fs = fspl(d, hz);
        if (dKm < horizonKm) return Math.max(fs, 40 * Math.log10(d) - 20 * Math.log10(h1 * h2));
        double x = 2.188 * Math.cbrt(mhz) * Math.pow(AE_KM, -2.0 / 3) * dKm;
        double f = x >= 1.6 ? 11 + 10 * Math.log10(x) - 17.6 * x : -20 * Math.log10(x) - 5.6488 * Math.pow(x, 1.425);
        double gain = f + heightGain(h1, mhz) + heightGain(h2, mhz);
        double planeEarthAtHorizon = Math.max(fspl(horizonKm * 1000, hz), 40 * Math.log10(horizonKm * 1000) - 20 * Math.log10(h1 * h2));
        return Math.max(Math.max(fs - gain, fs), planeEarthAtHorizon);   // never better than at the horizon itself
    }

    /** ITU-R P.526 height-gain G(Y) for an antenna h metres up (dB), with the land surface limit (K about 0.01). */
    static double heightGain(double h, double mhz) {
        double b = 9.575e-3 * Math.pow(mhz, 2.0 / 3) * Math.pow(AE_KM, -1.0 / 3) * h;
        double g = b > 2 ? 17.6 * Math.sqrt(b - 1.1) - 5 * Math.log10(b - 1.1) - 8 : 20 * Math.log10(b + 0.1 * b * b * b);
        return Math.max(g, 2 + 20 * Math.log10(0.01));
    }

    private static double deygout(double[] t, double step, int a, int b, double ha, double hb, double lambda, int depth) {
        if (b - a < 2) return 0;
        double total = (b - a) * step;
        int best = -1; double bestV = -1e9;
        for (int i = a + 1; i < b; i++) {
            double d1 = (i - a) * step, d2 = total - d1;
            double line = ha + (hb - ha) * d1 / total;
            double bulge = d1 * d2 / (2 * K * EARTH_R);
            double h = t[i] + bulge - line;
            double v = h * Math.sqrt(2 * total / (lambda * d1 * d2));
            if (v > bestV) { bestV = v; best = i; }
        }
        double loss = knifeEdge(bestV);
        if (loss <= 0 || depth >= 1) return loss;
        double edge = t[best];
        return loss + deygout(t, step, a, best, ha, edge, lambda, depth + 1) + deygout(t, step, best, b, edge, hb, lambda, depth + 1);
    }
}
