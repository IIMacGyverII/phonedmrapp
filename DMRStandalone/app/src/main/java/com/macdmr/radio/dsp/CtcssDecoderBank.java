package com.macdmr.radio.dsp;

/**
 * CTCSS decoder bank (SQ2): runs a Goertzel filter at <b>all</b> 51 standard CTCSS tone
 * frequencies over the received audio and reports which tone (if any) is present, so the UI can
 * show "which tone is coming in". This differs from {@link CtcssDetector}, which tests one
 * configured tone for squelch.
 *
 * <p>Per 333 ms window it picks the strongest tone bin and accepts it only when:
 * <ul>
 *   <li>it stands out from the mean of the other 50 tone bins by {@code RATIO} (broadband
 *       voice/noise lifts every bin roughly equally, so it fails this test), and</li>
 *   <li>it is a sharp local maximum (beats its two neighbouring standard tones), and</li>
 *   <li>the window carries real energy (dead-air guard), and</li>
 *   <li>the same tone repeats for {@code CONFIRM} consecutive windows (anti-flicker).</li>
 * </ul>
 *
 * <p>Thresholds are first-pass and expected to be calibrated on-air like the squelch work;
 * {@link #lastPeak()}/{@link #lastRatio()}/{@link #lastEnergy()} are logged as telemetry.
 *
 * <p>RX PCM is 8 kHz <b>stereo</b> 16-bit with L==R (see CLAUDE.md); takes the L sample of each
 * 4-byte frame.
 */
public final class CtcssDecoderBank {

    private final int sampleRate;
    private final int window;                 // samples per decision (~333 ms)
    private final double[] freqs;             // 51 CTCSS tone Hz
    private final String[] labels;            // "100.0" ...
    private final double[] coeff;             // Goertzel coefficient per tone
    private final double[] s1, s2;            // Goertzel state per tone
    private int n;
    private double energy;                    // sum of x^2 over the window

    private volatile int detectedIndex = -1;  // -1 = no tone
    private int candidate = -1, runs = 0;
    private volatile double lastPeak, lastRatio, lastEnergy;

    // Tunables. RATIO thresholds raised after on-air data (2026-10-16): a genuine CTCSS tone peaks at
    // ratio ~440-660, while a DCS data stream (broadband sub-audible) false-locked a single bin at
    // ratio up to ~31. 50/25 clears that false range with wide margin and stays far below real tones.
    // (If weak real tones are ever missed, lower RATIO_ON; if DCS still false-locks, raise it.)
    private static final int CONFIRM = 2;             // consecutive windows to (un)lock
    private static final double RATIO_ON = 50.0;      // peak / mean(other bins) to lock
    private static final double RATIO_OFF = 25.0;     // ... to release (hysteresis)
    private static final double NEIGHBOUR = 1.2;      // peak must beat each neighbour tone by this
    private static final double ENERGY_MIN = 4.0e5;   // per-sample energy floor (raw 16-bit, dead-air guard)

    public CtcssDecoderBank(int sampleRate) {
        this.sampleRate = sampleRate;
        // 750 ms + Hann weighting (2026-10-17): the 333 ms rectangular window read a clean 88.5 Hz
        // bench tone as its 91.5 Hz neighbour (3 Hz apart, leakage + the radio's low-end tilt).
        // With Hann at 750 ms the first null sits at 2.7 Hz, so adjacent standard tones no longer
        // rival each other; two windows (1.5 s) confirm a tone.
        this.window = Math.max(1, sampleRate * 3 / 4);
        int count = ToneConverter.ctcssCount();
        freqs = new double[count];
        labels = new String[count];
        coeff = new double[count];
        s1 = new double[count];
        s2 = new double[count];
        for (int i = 0; i < count; i++) {
            freqs[i] = ToneConverter.ctcssHz(i);
            labels[i] = ToneConverter.ctcssLabelAt(i);
            coeff[i] = 2 * Math.cos(2 * Math.PI * freqs[i] / sampleRate);
        }
    }

    /** Feed a raw RX buffer (8 kHz stereo 16-bit LE, L==R). Detection updates each window. */
    public void process(byte[] data, int length) {
        if (length > data.length) length = data.length;
        for (int i = 0; i + 1 < length; i += 4) {     // L sample per 4-byte stereo frame
            int xi = (short) ((data[i + 1] << 8) | (data[i] & 0xFF));
            energy += (double) xi * xi;
            samplesFed++;
            double x = xi * (0.5 - 0.5 * Math.cos(2 * Math.PI * n / window));   // Hann weight
            for (int t = 0; t < coeff.length; t++) {
                double s0 = x + coeff[t] * s1[t] - s2[t];
                s2[t] = s1[t];
                s1[t] = s0;
            }
            if (++n >= window) { evaluate(); resetWindow(); }
        }
    }

    private void evaluate() {
        double best = -1, second = -1, sum = 0;
        int bi = -1;
        for (int t = 0; t < coeff.length; t++) {
            double m = Math.max(0.0, s1[t] * s1[t] + s2[t] * s2[t] - coeff[t] * s1[t] * s2[t]);
            sum += m;
            if (m > best) { second = best; best = m; bi = t; }
            else if (m > second) { second = m; }
        }
        // keep this window's powers for debugTop()
        if (lastPowers == null || lastPowers.length != coeff.length) lastPowers = new double[coeff.length];
        for (int t = 0; t < coeff.length; t++) lastPowers[t] = power(t);
        windowsEvaluated++;
        double meanOthers = (sum - best) / Math.max(1, coeff.length - 1);
        double ratio = meanOthers > 1 ? best / meanOthers : (best > 1 ? 999 : 0);
        double perSample = energy / Math.max(1, window);
        lastPeak = best; lastRatio = ratio; lastEnergy = perSample;

        boolean locked = detectedIndex >= 0;
        boolean ok = bi >= 0
                && perSample >= ENERGY_MIN
                && ratio >= (locked ? RATIO_OFF : RATIO_ON)
                && beatsNeighbours(bi);
        int found = ok ? bi : -1;

        if (found == candidate) { if (runs < CONFIRM) runs++; }
        else { candidate = found; runs = 1; }
        if (runs >= CONFIRM) detectedIndex = candidate;
    }

    /** A true CTCSS tone peaks sharply; a neighbouring standard tone (or a skirt) must not rival it. */
    private boolean beatsNeighbours(int i) {
        double mi = power(i);
        boolean lo = (i == 0) || mi > power(i - 1) * NEIGHBOUR;
        boolean hi = (i == coeff.length - 1) || mi > power(i + 1) * NEIGHBOUR;
        return lo && hi;
    }

    private double power(int t) {
        return Math.max(0.0, s1[t] * s1[t] + s2[t] * s2[t] - coeff[t] * s1[t] * s2[t]);
    }

    private void resetWindow() {
        n = 0; energy = 0;
        java.util.Arrays.fill(s1, 0);
        java.util.Arrays.fill(s2, 0);
    }

    /** Clear detection and accumulators (call on RECEIVE_STOP). */
    public void reset() {
        resetWindow();
        detectedIndex = -1; candidate = -1; runs = 0;
    }

    private volatile double[] lastPowers;
    private volatile long windowsEvaluated = 0, samplesFed = 0;

    /** Telemetry: the k strongest bins of the last window as "label:dB-rel-to-peak", plus windows/samples seen. */
    public String debugTop(int k) {
        double[] p = lastPowers;
        if (p == null) return "(no window yet)";
        Integer[] idx = new Integer[p.length];
        for (int i = 0; i < p.length; i++) idx[i] = i;
        final double[] pp = p;
        java.util.Arrays.sort(idx, new java.util.Comparator<Integer>() {
            @Override public int compare(Integer a, Integer b) { return Double.compare(pp[b], pp[a]); }
        });
        StringBuilder sb = new StringBuilder();
        double top = Math.max(1e-9, p[idx[0]]);
        for (int i = 0; i < Math.min(k, idx.length); i++) {
            if (i > 0) sb.append(' ');
            sb.append(labels[idx[i]]).append(':').append(String.format(java.util.Locale.US, "%.1f", 10 * Math.log10(Math.max(1e-9, p[idx[i]]) / top)));
        }
        return sb.append(" windows=").append(windowsEvaluated).append(" samples=").append(samplesFed).toString();
    }

    public int detectedIndex() { return detectedIndex; }
    public double detectedHz() { int i = detectedIndex; return i >= 0 ? freqs[i] : -1; }
    public String detectedLabel() { int i = detectedIndex; return i >= 0 ? labels[i] : null; }
    public double lastPeak() { return lastPeak; }
    public double lastRatio() { return lastRatio; }
    public double lastEnergy() { return lastEnergy; }
}
