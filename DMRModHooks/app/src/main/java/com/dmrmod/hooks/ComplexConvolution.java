/*
Complex convolution (FIR filter for complex signals)
Ported from robot36 by Ahmet Inan <xdsopl@gmail.com>
*/
package com.dmrmod.hooks;

public class ComplexConvolution {
    public final int length;
    public final float[] taps;
    private final float[] real;
    private final float[] imag;
    private final Complex sum;
    private int pos;

    ComplexConvolution(int length) {
        this.length = length;
        this.taps = new float[length];
        this.real = new float[length];
        this.imag = new float[length];
        this.sum = new Complex();
        this.pos = 0;
    }

    Complex push(Complex input) {
        real[pos] = input.real;
        imag[pos] = input.imag;
        if (++pos >= length)
            pos = 0;
        sum.real = 0;
        sum.imag = 0;
        for (float tap : taps) {
            sum.real += tap * real[pos];
            sum.imag += tap * imag[pos];
            if (++pos >= length)
                pos = 0;
        }
        return sum;
    }
}
