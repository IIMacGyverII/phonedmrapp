package com.example.dmrmodhooks.sstv;

/**
 * FIR filter design utilities
 * Based on robot36-2 implementation by Ahmet Inan
 */
public class SSTVFilter {
    /**
     * Sinc function: sin(π*x) / (π*x)
     */
    public static double sinc(double x) {
        if (x == 0) {
            return 1;
        }
        x *= Math.PI;
        return Math.sin(x) / x;
    }

    /**
     * Design low-pass filter tap
     * @param cutoff Cutoff frequency in Hz
     * @param sampleRate Sample rate in Hz
     * @param n Tap index
     * @param N Total number of taps
     * @return Filter coefficient
     */
    public static double lowPass(double cutoff, double sampleRate, int n, int N) {
        double f = 2 * cutoff / sampleRate;
        double x = n - (N - 1) / 2.0;
        return f * sinc(f * x);
    }
}
