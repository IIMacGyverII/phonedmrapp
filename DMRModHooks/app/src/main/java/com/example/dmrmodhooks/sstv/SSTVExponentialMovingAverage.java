package com.example.dmrmodhooks.sstv;

/**
 * Exponential Moving Average (IIR low-pass filter)
 * Much more efficient than FIR for smoothing
 * Based on robot36-2 implementation by Ahmet Inan
 */
public class SSTVExponentialMovingAverage {
    private float alpha;
    private float previous;

    public SSTVExponentialMovingAverage() {
        this.alpha = 1;
        this.previous = 0;
    }

    /**
     * Filter one sample
     */
    public float avg(float input) {
        return previous = previous * (1 - alpha) + alpha * input;
    }

    /**
     * Set alpha directly (0 = infinite smoothing, 1 = no smoothing)
     */
    public void setAlpha(double alpha) {
        this.alpha = (float) alpha;
    }

    /**
     * Set alpha with cascaded filters
     */
    public void setAlpha(double alpha, int order) {
        setAlpha(Math.pow(alpha, 1.0 / order));
    }

    /**
     * Configure filter via cutoff frequency
     * @param cutoffFreq Cutoff frequency in Hz
     * @param sampleRate Sample rate in Hz
     * @param order Filter order (cascade count)
     */
    public void setCutoff(double cutoffFreq, double sampleRate, int order) {
        double x = Math.cos(2 * Math.PI * cutoffFreq / sampleRate);
        setAlpha(x - 1 + Math.sqrt(x * (x - 4) + 3), order);
    }

    /**
     * Configure first-order filter via cutoff frequency
     */
    public void setCutoff(double cutoffFreq, double sampleRate) {
        setCutoff(cutoffFreq, sampleRate, 1);
    }

    /**
     * Reset filter state
     */
    public void reset() {
        previous = 0;
    }
}
