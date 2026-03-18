/*
Frequency Modulation demodulator
Ported from robot36 by Ahmet Inan <xdsopl@gmail.com>
*/
package com.dmrmod.hooks;

public class FrequencyModulation {
    private float prev;
    private final float scale;
    private final float Pi, TwoPi;

    FrequencyModulation(double bandwidth, double sampleRate) {
        this.Pi = (float) Math.PI;
        this.TwoPi = 2 * this.Pi;
        this.scale = (float) (sampleRate / (bandwidth * Math.PI));
    }

    private float wrap(float value) {
        if (value < -Pi)
            return value + TwoPi;
        if (value > Pi)
            return value - TwoPi;
        return value;
    }

    float demod(Complex input) {
        float phase = input.arg();
        float delta = wrap(phase - prev);
        prev = phase;
        return scale * delta;
    }
}
