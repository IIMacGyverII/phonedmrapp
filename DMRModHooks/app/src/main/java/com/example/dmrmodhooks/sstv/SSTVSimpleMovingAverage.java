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
