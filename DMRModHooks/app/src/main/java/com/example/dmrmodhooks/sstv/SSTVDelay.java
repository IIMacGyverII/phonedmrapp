package com.example.dmrmodhooks.sstv;

/**
 * Digital delay line for compensating filter delays
 * Based on robot36-2 implementation by Ahmet Inan
 */
public class SSTVDelay {
    public final int length;
    private final float[] buffer;
    private int position;

    public SSTVDelay(int length) {
        this.length = length;
        this.buffer = new float[length];
        this.position = 0;
    }

    /**
     * Push new value and return oldest value
     */
    public float push(float input) {
        float output = buffer[position];
        buffer[position] = input;
        if (++position >= length) {
            position = 0;
        }
        return output;
    }
}
