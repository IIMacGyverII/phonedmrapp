package com.dmrmod.hooks;

/**
 * FM noise squelch: opens on a real signal (which <i>quiets</i> the high-frequency hiss) and closes
 * on static (full of it). This is how hardware FM squelch works and, unlike an amplitude/RMS gate,
 * it rejects the loud noise a weak signal produces — the reason the amplitude squelch passed static
 * even at level 9 (a −108 dBm signal is mostly noise, RMS ~12000).
 *
 * <p>Each ~128 ms window it measures the amplitude ratio of a high band (~3.3–3.7 kHz) to a mid
 * reference band (~1.2–1.6 kHz). On-device captures: signal windows ~0.02–0.10, static windows
 * ~0.30–0.60 — a ~10× contrast. A signal is "present" when the ratio is below the level's threshold,
 * with hysteresis. Level 0 disables it (pass all); 1 is most sensitive, 9 least.
 *
 * <p>RX PCM is 8 kHz stereo 16-bit with L==R; takes the L sample of each 4-byte frame.
 */
public final class NoiseSquelchDetector {

    private static final double[] HI  = {3300, 3500, 3700};
    private static final double[] MID = {1200, 1600};

    // Per level (0..9): ratio below which a signal is considered present (open). Higher level ->
    // lower threshold -> demands more quieting. Level 0 = always open.
    private static final double[] OPEN_THRESH =
        {999, 0.28, 0.24, 0.20, 0.17, 0.15, 0.13, 0.11, 0.10, 0.09};

    private final int window;
    private final double[] cHi = new double[HI.length];
    private final double[] cMid = new double[MID.length];
    private final double[] hi1 = new double[HI.length], hi2 = new double[HI.length];
    private final double[] md1 = new double[MID.length], md2 = new double[MID.length];
    private int n;
    private double totalEnergy;

    private volatile double ratio = 999;       // raw per-window high/mid amplitude ratio
    private volatile double smoothed = 999;    // EMA of ratio (~500 ms) — rides out voice sibilants
    private volatile boolean signal;
    private static final double EMA = 0.25;    // per 128 ms window -> ~0.5 s time constant
    private static final double CAP = 2.0;     // clamp raw ratio so transient spikes don't skew the EMA

    public NoiseSquelchDetector(int sampleRate) {
        this.window = Math.max(1, sampleRate / 8);   // ~128 ms
        for (int k = 0; k < HI.length; k++)  cHi[k]  = 2 * Math.cos(2 * Math.PI * HI[k]  / sampleRate);
        for (int k = 0; k < MID.length; k++) cMid[k] = 2 * Math.cos(2 * Math.PI * MID[k] / sampleRate);
    }

    public void reset() {
        for (int k = 0; k < HI.length; k++)  { hi1[k] = 0; hi2[k] = 0; }
        for (int k = 0; k < MID.length; k++) { md1[k] = 0; md2[k] = 0; }
        n = 0; totalEnergy = 0; signal = false; ratio = 999; smoothed = 999;
    }

    /** Feed a raw RX buffer; signal()/ratio() update each window. {@code level} is the Soft SQ level. */
    public void process(byte[] data, int length, int level) {
        if (length > data.length) length = data.length;
        for (int i = 0; i + 1 < length; i += 4) {   // L sample per 4-byte stereo frame
            int x = (short) ((data[i + 1] << 8) | (data[i] & 0xFF));
            for (int k = 0; k < HI.length; k++)  { double s = x + cHi[k]  * hi1[k] - hi2[k]; hi2[k] = hi1[k]; hi1[k] = s; }
            for (int k = 0; k < MID.length; k++) { double s = x + cMid[k] * md1[k] - md2[k]; md2[k] = md1[k]; md1[k] = s; }
            totalEnergy += (double) x * x;
            if (++n >= window) {
                double hiP = 0;  for (int k = 0; k < HI.length; k++)  hiP += pw(hi1[k], hi2[k], cHi[k]);
                double mdP = 0;  for (int k = 0; k < MID.length; k++) mdP += pw(md1[k], md2[k], cMid[k]);
                hiP /= HI.length; mdP /= MID.length;
                double raw = mdP > 1 ? Math.sqrt(hiP / mdP) : 999;
                ratio = raw;
                double capped = Math.min(raw, CAP);
                smoothed = smoothed > 100 ? capped : (smoothed * (1 - EMA) + capped * EMA);
                double open = threshFor(level);
                double close = open * 1.4;   // hysteresis: smoothed ratio must rise past this to re-close
                // Dead-silence guard: essentially no audio -> treat as no signal.
                boolean quiet = totalEnergy < (window * 400.0);   // ~RMS 20
                if (quiet) signal = false;
                else if (!signal && smoothed < open) signal = true;
                else if (signal && smoothed > close) signal = false;
                resetWindow();
            }
        }
    }

    private void resetWindow() {
        for (int k = 0; k < HI.length; k++)  { hi1[k] = 0; hi2[k] = 0; }
        for (int k = 0; k < MID.length; k++) { md1[k] = 0; md2[k] = 0; }
        n = 0; totalEnergy = 0;
    }

    private static double threshFor(int level) {
        if (level < 1) return OPEN_THRESH[1];
        if (level > 9) return OPEN_THRESH[9];
        return OPEN_THRESH[level];
    }

    private static double pw(double s1, double s2, double c) {
        return Math.max(0.0, s1 * s1 + s2 * s2 - c * s1 * s2);
    }

    public boolean isSignal() { return signal; }
    public double ratio() { return ratio; }
    public double smoothed() { return smoothed; }
}
