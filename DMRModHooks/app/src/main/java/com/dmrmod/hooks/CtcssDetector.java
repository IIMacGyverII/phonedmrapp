package com.dmrmod.hooks;

/**
 * Continuous CTCSS (sub-audible tone) detector via a block Goertzel, for software tone squelch.
 *
 * <p>Feasibility was measured on-device (a known 100.0 Hz keyup showed the tone 605× above its
 * neighbours in the 8 kHz RX PCM), so the sub-audible tone does survive into the audio the module
 * sees. This runs a Goertzel at the channel's configured tone frequency over ~200 ms windows and
 * reports whether that tone is present as a fraction of the window's total energy (1.0 = a pure
 * tone). Hysteresis on/off thresholds avoid chattering; they are tuned on-air.
 *
 * <p>Stateful; one instance is reused for the single active RX. PCM is 16-bit little-endian mono.
 */
public final class CtcssDetector {

    private final int sampleRate;
    private final int window;          // samples per detection window (~200 ms)

    private double freq = -1;
    private double coeff;              // 2*cos(2*pi*f/fs)
    private double s1, s2;             // Goertzel state
    private int n;                     // samples into the current window
    private double totalEnergy;        // sum of x^2 over the window

    private volatile boolean present;
    private volatile double lastFraction;

    // Tunable: fraction of window energy that must sit at the tone to count as present.
    // On-device calibration (100 Hz keyup, 250 ms window): correct tone peaked ~0.86, the adjacent
    // 103.5 Hz tone leaked only ~0.08, and voice read ~0.00 — so 0.20/0.10 separates all three.
    private double onThreshold = 0.20;
    private double offThreshold = 0.10;

    public CtcssDetector(int sampleRate) {
        this.sampleRate = sampleRate;
        this.window = Math.max(1, sampleRate / 4);   // 250 ms (best adjacent-tone selectivity vs latency)
    }

    public void setThresholds(double on, double off) { onThreshold = on; offThreshold = off; }

    /** Point the detector at a tone frequency (Hz). No-op if unchanged. &lt;=0 disables detection. */
    public void setFrequency(double f) {
        if (f == freq) return;
        freq = f;
        if (f > 0) coeff = 2 * Math.cos(2 * Math.PI * f / sampleRate);
        resetWindow();
        present = false;
    }

    public void reset() { resetWindow(); present = false; }

    private void resetWindow() { s1 = 0; s2 = 0; n = 0; totalEnergy = 0; }

    /**
     * Feed a raw RX buffer; present()/lastFraction() update each completed window. The buffer is
     * 8 kHz <b>stereo</b> 16-bit with L==R (measured 2026-10-14), so we take the L sample of each
     * 4-byte frame — genuine 8 kHz mono, matching the recording path and the sampleRate (8000) used
     * for the Goertzel coefficient. Stepping by 2 instead would read L,R,L,R at an effective 16 kHz
     * and look for the tone in the wrong bin.
     */
    public void process(byte[] data, int length) {
        if (freq <= 0) return;
        if (length > data.length) length = data.length;
        for (int i = 0; i + 1 < length; i += 4) {   // L sample per 4-byte stereo frame -> 8 kHz mono
            int x = (short) ((data[i + 1] << 8) | (data[i] & 0xFF));
            double s0 = x + coeff * s1 - s2;
            s2 = s1;
            s1 = s0;
            totalEnergy += (double) x * x;
            if (++n >= window) {
                double tonePower = s1 * s1 + s2 * s2 - coeff * s1 * s2;
                // For a pure tone, tonePower / totalEnergy == window/2, so this normalises to ~1.0.
                double frac = totalEnergy > 1.0 ? tonePower / (totalEnergy * (window / 2.0)) : 0.0;
                if (frac < 0) frac = 0;
                lastFraction = frac;
                if (!present && frac >= onThreshold) present = true;
                else if (present && frac < offThreshold) present = false;
                resetWindow();
            }
        }
    }

    public boolean isPresent() { return present; }
    public double lastFraction() { return lastFraction; }
}
