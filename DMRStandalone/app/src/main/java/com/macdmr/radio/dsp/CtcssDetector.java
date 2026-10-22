/*
 * SignalDeck - Copyright (C) 2026 IIMacGyverII
 * SPDX-License-Identifier: GPL-3.0-or-later
 * Free software under the GNU General Public License v3 or later, with the additional terms in COPYRIGHT
 * (keep this notice and the author credit, mark modified versions, no rights to the SignalDeck name or icon).
 */
package com.macdmr.radio.dsp;

/**
 * Continuous CTCSS (sub-audible tone) detector for software tone squelch.
 *
 * <p>Two Goertzel-based tests per 333 ms window, both of which must pass:
 * <ul>
 *   <li><b>voice/noise ratio</b> — tone power vs the mean of four far off-tone bins (±15, ±25 Hz).
 *       Voice is broadband and cancels between target and off bins, so this stays locked through
 *       speech (a tone-vs-total-energy fraction collapsed on voice and dropped the squelch
 *       mid-transmission).</li>
 *   <li><b>adjacent-tone ratio</b> — tone power vs the louder of the two <i>neighbouring standard
 *       CTCSS tones</i>. A transmission on the next tone up/down makes that neighbour the peak and
 *       the configured tone merely its skirt, so the target loses and is rejected (on-air: 97.4 Hz,
 *       2.6 Hz below 100.0, leaked past the far-bin test alone).</li>
 * </ul>
 *
 * <p>Calibrated on real 100 Hz captures: correct tone held voice-ratio 114–465 and adjacent-ratio
 * ≥1.77 even under loud voice; the adjacent 103.5 Hz tone sat ~32 on the voice-ratio. Thresholds
 * 50/20 (voice) and 1.4/1.1 (adjacent) separate correct / adjacent / voice.
 *
 * <p>Input is 8 kHz mono 16-bit LE (the standalone app decimates the vendor stereo stream before DSP).
 */
public final class CtcssDetector {

    private static final double[] OFFSETS = {-25, -15, 15, 25};

    private final int sampleRate;
    private final int window;                 // samples per window (~333 ms)

    private double freq = -1, adjLo = -1, adjHi = -1;
    private double cT;                          // target coefficient
    private final double[] cO = new double[OFFSETS.length];
    private double cLo, cHi;                    // adjacent-tone coefficients (0 = not set)

    private double sT1, sT2;
    private final double[] sO1 = new double[OFFSETS.length];
    private final double[] sO2 = new double[OFFSETS.length];
    private double sLo1, sLo2, sHi1, sHi2;
    private int n;

    private volatile boolean present;
    private volatile double lastVoice, lastAdj;

    private double onVoice = 50.0, offVoice = 20.0;   // tone / far-off-bin power
    private double onAdj = 1.4, offAdj = 1.1;          // tone / louder adjacent standard tone

    public CtcssDetector(int sampleRate) {
        this.sampleRate = sampleRate;
        this.window = Math.max(1, sampleRate / 3);   // 333 ms (resolves 2.5 Hz-spaced tones)
    }

    public void setThresholds(double onV, double offV, double onA, double offA) {
        onVoice = onV; offVoice = offV; onAdj = onA; offAdj = offA;
    }

    /**
     * Point the detector at a tone and its two neighbouring standard CTCSS tones (Hz; &lt;=0 to omit
     * a neighbour at the table edge). No-op if unchanged; {@code target<=0} disables detection.
     */
    public void setFrequency(double target, double adjLow, double adjHigh) {
        if (target == freq && adjLow == adjLo && adjHigh == adjHi) return;
        freq = target; adjLo = adjLow; adjHi = adjHigh;
        if (target > 0) {
            cT = coef(target);
            for (int k = 0; k < OFFSETS.length; k++) cO[k] = coef(target + OFFSETS[k]);
            cLo = adjLow > 0 ? coef(adjLow) : 0;
            cHi = adjHigh > 0 ? coef(adjHigh) : 0;
        }
        resetWindow();
        present = false;
    }

    public void reset() { resetWindow(); present = false; }

    private double coef(double f) { return 2 * Math.cos(2 * Math.PI * f / sampleRate); }

    private void resetWindow() {
        sT1 = sT2 = 0; sLo1 = sLo2 = sHi1 = sHi2 = 0; n = 0;
        for (int k = 0; k < OFFSETS.length; k++) { sO1[k] = 0; sO2[k] = 0; }
    }

    /** Feed 8 kHz mono 16-bit LE PCM. present() updates each window. */
    public void process(byte[] data, int length) {
        if (freq <= 0) return;
        if (length > data.length) length = data.length;
        for (int i = 0; i + 1 < length; i += 2) {   // 8 kHz mono 16-bit LE (the standalone RX stream; the module fed stereo L==R frames)
            int x = (short) ((data[i + 1] << 8) | (data[i] & 0xFF));
            double s0 = x + cT * sT1 - sT2; sT2 = sT1; sT1 = s0;
            for (int k = 0; k < OFFSETS.length; k++) {
                double so = x + cO[k] * sO1[k] - sO2[k]; sO2[k] = sO1[k]; sO1[k] = so;
            }
            if (cLo != 0) { double sl = x + cLo * sLo1 - sLo2; sLo2 = sLo1; sLo1 = sl; }
            if (cHi != 0) { double sh = x + cHi * sHi1 - sHi2; sHi2 = sHi1; sHi1 = sh; }
            if (++n >= window) {
                double pt = pw(sT1, sT2, cT);
                double po = 0;
                for (int k = 0; k < OFFSETS.length; k++) po += pw(sO1[k], sO2[k], cO[k]);
                po /= OFFSETS.length;
                double padj = Math.max(cLo != 0 ? pw(sLo1, sLo2, cLo) : 0,
                                       cHi != 0 ? pw(sHi1, sHi2, cHi) : 0);
                double voice = po > 1 ? pt / po : (pt > 1 ? 999 : 0);
                double adj = padj > 1 ? pt / padj : (pt > 1 ? 999 : 0);
                lastVoice = voice; lastAdj = adj;
                boolean okVoice = voice >= (present ? offVoice : onVoice);
                boolean okAdj   = adj   >= (present ? offAdj : onAdj);
                present = okVoice && okAdj;
                resetWindow();
            }
        }
    }

    private static double pw(double s1, double s2, double c) {
        return Math.max(0.0, s1 * s1 + s2 * s2 - c * s1 * s2);
    }

    public boolean isPresent() { return present; }
    public double lastVoiceRatio() { return lastVoice; }
    public double lastAdjRatio() { return lastAdj; }
}
