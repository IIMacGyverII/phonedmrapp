package com.example.dmrmodhooks.sstv;

/**
 * Numerically Controlled Oscillator (NCO) for complex baseband conversion
 * Based on robot36-2 implementation by Ahmet Inan
 */
public class SSTVPhasor {
    private final SSTVComplex value;
    private final SSTVComplex delta;

    /**
     * Create oscillator at specified frequency
     * @param frequency Oscillator frequency in Hz (negative for conjugate)
     * @param sampleRate Sample rate in Hz
     */
    public SSTVPhasor(double frequency, double sampleRate) {
        value = new SSTVComplex(1, 0);
        double omega = 2 * Math.PI * frequency / sampleRate;
        delta = new SSTVComplex((float) Math.cos(omega), (float) Math.sin(omega));
    }

    /**
     * Rotate phasor by one sample and return current value
     * Normalizes to prevent accumulation of rounding errors
     */
    public SSTVComplex rotate() {
        return value.div(value.mul(delta).abs());
    }
}
