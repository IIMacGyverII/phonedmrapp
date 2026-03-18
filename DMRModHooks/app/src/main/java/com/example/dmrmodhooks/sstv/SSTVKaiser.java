package com.example.dmrmodhooks.sstv;

import java.util.Arrays;

/**
 * Kaiser window for FIR filter design
 * Based on robot36-2 implementation by Ahmet Inan
 */
public class SSTVKaiser {
    private final double[] summands;

    public SSTVKaiser() {
        // i0(x) converges for x inside -3*Pi:3*Pi in less than 35 iterations
        summands = new double[35];
    }

    private double square(double value) {
        return value * value;
    }

    /**
     * i0() implements the zero-th order modified Bessel function of the first kind
     * I_0(x) = sum_{m=0}^{infinity} ((x/2)^m / m!)^2
     */
    private double i0(double x) {
        summands[0] = 1;
        double val = 1;
        for (int n = 1; n < summands.length; ++n) {
            summands[n] = square(val *= x / (2 * n));
        }
        // Sort for numerical stability (add smallest first)
        Arrays.sort(summands);
        double sum = 0;
        for (int n = summands.length - 1; n >= 0; --n) {
            sum += summands[n];
        }
        return sum;
    }

    /**
     * Calculate Kaiser window value
     * @param alpha Shape parameter (larger = more sidelobe suppression)
     * @param n Sample index
     * @param N Total window length
     * @return Window value [0, 1]
     */
    public double window(double alpha, int n, int N) {
        return i0(Math.PI * alpha * Math.sqrt(1 - square((2.0 * n) / (N - 1) - 1))) / i0(Math.PI * alpha);
    }
}
