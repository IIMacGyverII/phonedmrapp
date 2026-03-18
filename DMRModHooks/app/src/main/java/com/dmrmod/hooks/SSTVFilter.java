/*
FIR Filter design functions
Ported from robot36 by Ahmet Inan <xdsopl@gmail.com>
*/
package com.dmrmod.hooks;

public final class SSTVFilter {
    public static double sinc(double x) {
        if (x == 0)
            return 1;
        x *= Math.PI;
        return Math.sin(x) / x;
    }

    public static double lowPass(double cutoff, double rate, int n, int N) {
        double f = 2 * cutoff / rate;
        double x = n - (N - 1) / 2.0;
        return f * sinc(f * x);
    }
}
