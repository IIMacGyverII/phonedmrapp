package com.macdmr.radio.dsp;

/**
 * FM noise squelch: opens on a real signal (which <i>quiets</i> the high-frequency hiss) and closes
 * on static (full of it). Unlike an amplitude/RMS gate it is immune to the loud-static / quiet-signal
 * inversion — a weak signal's noise is quieter than static, so amplitude muted the signal and passed
 * the louder static.
 *
 * <p>It measures the <b>absolute</b> amplitude in a high band (~3.3–3.75 kHz) each 250 ms window —
 * not a ratio against the voice band, which made it voice-activated (you had to shout to fill the
 * mid band before it opened). On-device recordings: static windows read ~50–125, signal windows
 * ~1–12 regardless of how loud the talker was, so a threshold in the gap separates them and the
 * Soft SQ level (1 lenient … 9 strict) slides it. Level 0 disables (pass all). EMA-smoothed to ride
 * out voice sibilants (the only voice energy that reaches this band).
 *
 * <p>RX PCM is 8 kHz stereo 16-bit with L==R; takes the L sample of each 4-byte frame.
 */
public final class NoiseSquelchDetector {

    private static final double[] HI = {3300, 3450, 3600, 3750};

    // Per level (0..9): smoothed high-band amplitude below which a signal is "present" (open). All sit
    // below the static floor (~50) and above the signal level (~12). Higher level -> lower -> stricter.
    private static final double[] OPEN_THRESH = {1e9, 38, 35, 32, 29, 27, 24, 22, 19, 16};

    private final int window;
    private final double[] c  = new double[HI.length];
    private final double[] s1 = new double[HI.length];
    private final double[] s2 = new double[HI.length];
    private int n;
    private double totalEnergy;

    private volatile double highAmp = 999;     // raw per-window high-band amplitude
    private volatile double smoothed = 999;
    private volatile boolean signal;
    private static final double EMA = 0.5;     // ~0.5 s at 250 ms windows

    public NoiseSquelchDetector(int sampleRate) {
        this.window = Math.max(1, sampleRate / 4);   // 250 ms
        for (int k = 0; k < HI.length; k++) c[k] = 2 * Math.cos(2 * Math.PI * HI[k] / sampleRate);
    }

    public void reset() {
        for (int k = 0; k < HI.length; k++) { s1[k] = 0; s2[k] = 0; }
        n = 0; totalEnergy = 0; signal = false; highAmp = 999; smoothed = 999;
    }

    private void resetWindow() {
        for (int k = 0; k < HI.length; k++) { s1[k] = 0; s2[k] = 0; }
        n = 0; totalEnergy = 0;
    }

    /** Feed a raw RX buffer; signal()/highAmp() update each window. {@code level} is the Soft SQ level. */
    public void process(byte[] data, int length, int level) {
        if (length > data.length) length = data.length;
        for (int i = 0; i + 1 < length; i += 4) {   // L sample per 4-byte stereo frame
            int x = (short) ((data[i + 1] << 8) | (data[i] & 0xFF));
            for (int k = 0; k < HI.length; k++) { double s0 = x + c[k] * s1[k] - s2[k]; s2[k] = s1[k]; s1[k] = s0; }
            totalEnergy += (double) x * x;
            if (++n >= window) {
                double amp = 0;
                for (int k = 0; k < HI.length; k++) {
                    double pw = Math.max(0.0, s1[k] * s1[k] + s2[k] * s2[k] - c[k] * s1[k] * s2[k]);
                    amp += Math.sqrt(pw) / window * 2;
                }
                amp /= HI.length;
                highAmp = amp;
                smoothed = smoothed > 900 ? amp : smoothed * (1 - EMA) + amp * EMA;
                double open = threshFor(level);
                double close = Math.min(open * 1.3, 46);   // hysteresis, but stay below the static floor
                boolean quiet = totalEnergy < (window * 2500.0);   // RMS < ~50 -> no real audio (don't open)
                if (quiet) signal = false;
                else if (!signal && smoothed < open) signal = true;
                else if (signal && smoothed > close) signal = false;
                resetWindow();
            }
        }
    }

    private static double threshFor(int level) {
        if (level < 1) return OPEN_THRESH[1];
        if (level > 9) return OPEN_THRESH[9];
        return OPEN_THRESH[level];
    }

    public boolean isSignal() { return signal; }
    public double highAmp() { return highAmp; }
    public double smoothed() { return smoothed; }
}
