package com.dmrmod.hooks;

/**
 * Continuous CTCSS (sub-audible tone) detector for software tone squelch.
 *
 * <p>Measures the Goertzel power at the channel's configured tone frequency against the average
 * power at four nearby off-tone bins (±15, ±25 Hz). Voice is broadband, so it contributes about
 * equally to the target and the off bins and cancels in the ratio — which is why this stays locked
 * through speech, unlike a tone-vs-total-energy fraction (that collapsed once voice started and
 * dropped the squelch mid-transmission). On-device calibration (100 Hz, 250 ms windows): correct
 * tone rode 114–465 even under loud voice, the adjacent 103.5 Hz tone peaked ~32, and voice with no
 * tone peaked ~14 — so 50/20 on/off thresholds separate all three with margin.
 *
 * <p>RX PCM is 8 kHz <b>stereo</b> 16-bit with L==R; this takes the L sample of each 4-byte frame
 * (genuine 8 kHz mono). Stateful; one instance is reused for the single active RX.
 */
public final class CtcssDetector {

    private static final double[] OFFSETS = {-25, -15, 15, 25};

    private final int sampleRate;
    private final int window;                 // samples per detection window (~250 ms)

    private double freq = -1;
    private double coeffT;                     // target Goertzel coefficient
    private final double[] coeffO = new double[OFFSETS.length];
    private double sT1, sT2;                    // target Goertzel state
    private final double[] sO1 = new double[OFFSETS.length];
    private final double[] sO2 = new double[OFFSETS.length];
    private int n;

    private volatile boolean present;
    private volatile double lastRatio;

    // Tunable: tone power / mean off-bin power. On well above the adjacent-tone (~32) and voice (~14)
    // ceilings; off above those too so a real tone (>100) never chatters but a dropped tone closes.
    private double onThreshold = 50.0;
    private double offThreshold = 20.0;

    public CtcssDetector(int sampleRate) {
        this.sampleRate = sampleRate;
        this.window = Math.max(1, sampleRate / 4);   // 250 ms
    }

    public void setThresholds(double on, double off) { onThreshold = on; offThreshold = off; }

    /** Point the detector at a tone frequency (Hz). No-op if unchanged. &lt;=0 disables detection. */
    public void setFrequency(double f) {
        if (f == freq) return;
        freq = f;
        if (f > 0) {
            coeffT = 2 * Math.cos(2 * Math.PI * f / sampleRate);
            for (int k = 0; k < OFFSETS.length; k++) {
                coeffO[k] = 2 * Math.cos(2 * Math.PI * (f + OFFSETS[k]) / sampleRate);
            }
        }
        resetWindow();
        present = false;
    }

    public void reset() { resetWindow(); present = false; }

    private void resetWindow() {
        sT1 = 0; sT2 = 0; n = 0;
        for (int k = 0; k < OFFSETS.length; k++) { sO1[k] = 0; sO2[k] = 0; }
    }

    /**
     * Feed a raw RX buffer (8 kHz stereo 16-bit LE, L==R). present()/lastRatio() update each
     * completed 250 ms window.
     */
    public void process(byte[] data, int length) {
        if (freq <= 0) return;
        if (length > data.length) length = data.length;
        for (int i = 0; i + 1 < length; i += 4) {   // L sample per 4-byte stereo frame -> 8 kHz mono
            int x = (short) ((data[i + 1] << 8) | (data[i] & 0xFF));
            double s0 = x + coeffT * sT1 - sT2;
            sT2 = sT1; sT1 = s0;
            for (int k = 0; k < OFFSETS.length; k++) {
                double so = x + coeffO[k] * sO1[k] - sO2[k];
                sO2[k] = sO1[k]; sO1[k] = so;
            }
            if (++n >= window) {
                double pt = sT1 * sT1 + sT2 * sT2 - coeffT * sT1 * sT2;
                double po = 0;
                for (int k = 0; k < OFFSETS.length; k++) {
                    po += sO1[k] * sO1[k] + sO2[k] * sO2[k] - coeffO[k] * sO1[k] * sO2[k];
                }
                po /= OFFSETS.length;
                double ratio = po > 1.0 ? pt / po : (pt > 1.0 ? 999.0 : 0.0);
                lastRatio = ratio;
                if (!present && ratio >= onThreshold) present = true;
                else if (present && ratio < offThreshold) present = false;
                resetWindow();
            }
        }
    }

    public boolean isPresent() { return present; }
    public double lastRatio() { return lastRatio; }
}
