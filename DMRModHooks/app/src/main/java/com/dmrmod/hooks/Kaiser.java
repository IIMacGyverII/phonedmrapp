/*
Kaiser window function
Ported from robot36 by Ahmet Inan <xdsopl@gmail.com>
*/
package com.dmrmod.hooks;

import java.util.Arrays;

public class Kaiser {
    double[] summands;

    Kaiser() {
        // i0(x) converges for x inside -3*Pi:3*Pi in less than 35 iterations
        summands = new double[35];
    }

    private double square(double value) {
        return value * value;
    }

    /*
    i0() implements the zero-th order modified Bessel function of the first kind:
    https://en.wikipedia.org/wiki/Bessel_function#Modified_Bessel_functions:_I%CE%B1,_K%CE%B1
    $I_\alpha(x) = i^{-\alpha} J_\alpha(ix) = \sum_{m=0}^\infty \frac{1}{m!\, \Gamma(m+\alpha+1)}\left(\frac{x}{2}\right)^{2m+\alpha}$
    $I_0(x) = J_0(ix) = \sum_{m=0}^\infty \frac{1}{m!\, \Gamma(m+1)}\left(\frac{x}{2}\right)^{2m} = \sum_{m=0}^\infty \left(\frac{x^m}{2^m\,m!}\right)^{2}$
    We obviously can't use the factorial here, so let's get rid of it:
    $= 1 + \left(\frac{x}{2 \cdot 1}\right)^2 + \left(\frac{x}{2 \cdot 1}\cdot \frac{x}{2 \cdot 2}\right)^2 + \left(\frac{x}{2 \cdot 1}\cdot \frac{x}{2 \cdot 2}\cdot \frac{x}{2 \cdot 3}\right)^2 + .. = 1 + \sum_{m=1}^\infty \left(\prod_{n=1}^m \frac{x}{2n}\right)^2$
    */
    private double i0(double x) {
        summands[0] = 1;
        double val = 1;
        for (int n = 1; n < summands.length; ++n)
            summands[n] = square(val *= x / (2 * n));
        Arrays.sort(summands);
        double sum = 0;
        for (int n = summands.length - 1; n >= 0; --n)
            sum += summands[n];
        return sum;
    }

    public double window(double a, int n, int N) {
        return i0(Math.PI * a * Math.sqrt(1 - square((2.0 * n) / (N - 1) - 1))) / i0(Math.PI * a);
    }
}
