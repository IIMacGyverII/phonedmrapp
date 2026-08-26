/*
 * Derived from robot36 (https://github.com/xdsopl/robot36), Copyright (C) Ahmet Inan <xdsopl@gmail.com>,
 * licensed under the GNU General Public License v3.0 (see LICENSE at the repository root).
 * Ported to Java for DMRModHooks; the port and its modifications are likewise GPL-3.0-or-later.
 */
package com.example.dmrmodhooks.sstv;

/**
 * Simple moving average filter
 * Based on robot36-2 implementation by Ahmet Inan
 */
public class SSTVSimpleMovingAverage {
    private final SSTVSimpleMovingSum sum;
    public final int length;

    public SSTVSimpleMovingAverage(int length) {
        this.sum = new SSTVSimpleMovingSum(length);
        this.length = length;
    }

    public float avg(float input) {
        return sum.sum(input) / length;
    }
}
