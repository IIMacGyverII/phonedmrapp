package com.macdmr.radio.coverage;

/**
 * Path loss over terrain: free-space loss plus knife-edge diffraction by the Deygout method (the main obstacle,
 * then the strongest one on each side of it), with the earth's curvature at the usual effective radius (k = 4/3).
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
        return fspl(d, hz) + deygout(terrain, step, 0, n - 1, ha, hb, lambda, 0);
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
