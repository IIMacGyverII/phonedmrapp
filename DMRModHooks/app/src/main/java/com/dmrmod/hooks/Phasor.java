/*
Numerically controlled oscillator (NCO)
Ported from robot36 by Ahmet Inan <xdsopl@gmail.com>
*/
package com.dmrmod.hooks;

public class Phasor {
    private final Complex value;
    private final Complex delta;

    Phasor(double frequency, double sampleRate) {
        this.value = new Complex(1, 0);
        this.delta = new Complex();
        this.delta.polar(1, (float) (2 * Math.PI * frequency / sampleRate));
    }

    Complex rotate() {
        value.mul(delta);
        value.div(value.abs());
        return value;
    }
}
