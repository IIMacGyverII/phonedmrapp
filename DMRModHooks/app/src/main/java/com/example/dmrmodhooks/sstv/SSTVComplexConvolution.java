/*
 * Derived from robot36 (https://github.com/xdsopl/robot36), Copyright (C) Ahmet Inan <xdsopl@gmail.com>,
 * licensed under the GNU General Public License v3.0 (see LICENSE at the repository root).
 * Ported to Java for DMRModHooks; the port and its modifications are likewise GPL-3.0-or-later.
 */
package com.example.dmrmodhooks.sstv;

/**
 * Complex FIR convolution filter for baseband signal processing
 * Based on robot36-2 implementation by Ahmet Inan
 */
public class SSTVComplexConvolution {
    public final int length;
    public final float[] taps;
    private final float[] realBuffer;
    private final float[] imagBuffer;
    private final SSTVComplex sum;
    private int position;

    public SSTVComplexConvolution(int length) {
        this.length = length;
        this.taps = new float[length];
        this.realBuffer = new float[length];
        this.imagBuffer = new float[length];
        this.sum = new SSTVComplex();
        this.position = 0;
    }

    /**
     * Push new complex sample and return filtered output
     */
    public SSTVComplex push(SSTVComplex input) {
        // Store input in circular buffer
        realBuffer[position] = input.real;
        imagBuffer[position] = input.imag;
        if (++position >= length) {
            position = 0;
        }

        // Convolve with taps
        sum.real = 0;
        sum.imag = 0;
        for (float tap : taps) {
            sum.real += tap * realBuffer[position];
            sum.imag += tap * imagBuffer[position];
            if (++position >= length) {
                position = 0;
            }
        }
        return sum;
    }
}
