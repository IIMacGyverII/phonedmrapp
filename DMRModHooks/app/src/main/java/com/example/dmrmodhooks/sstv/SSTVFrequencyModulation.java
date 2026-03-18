package com.example.dmrmodhooks.sstv;

/**
 * FM demodulation via phase difference
 * Based on robot36-2 implementation by Ahmet Inan
 */
public class SSTVFrequencyModulation {
    private float previousPhase;
    private final float scale;
    private final float PI;
    private final float TWO_PI;

    /**
     * Create FM demodulator
     * @param bandwidth Signal bandwidth in Hz
     * @param sampleRate Sample rate in Hz
     */
    public SSTVFrequencyModulation(double bandwidth, double sampleRate) {
        this.PI = (float) Math.PI;
        this.TWO_PI = 2 * PI;
        // Scale factor to convert phase difference to normalized frequency
        this.scale = (float) (sampleRate / (bandwidth * Math.PI));
        this.previousPhase = 0;
    }

    /**
     * Wrap phase to [-π, π]
     */
    private float wrap(float value) {
        if (value < -PI) {
            return value + TWO_PI;
        }
        if (value > PI) {
            return value - TWO_PI;
        }
        return value;
    }

    /**
     * Demodulate complex baseband sample to normalized frequency
     * @param input Complex baseband sample
     * @return Normalized frequency: -1.0 (black/1500Hz) to +1.0 (white/2300Hz)
     */
    public float demod(SSTVComplex input) {
        float phase = input.arg();
        float delta = wrap(phase - previousPhase);
        previousPhase = phase;
        return scale * delta;
    }
}
