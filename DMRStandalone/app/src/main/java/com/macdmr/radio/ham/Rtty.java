/*
 * SignalDeck - Copyright (C) 2026 IIMacGyverII
 * SPDX-License-Identifier: GPL-3.0-or-later
 * Free software under the GNU General Public License v3 or later, with the additional terms in COPYRIGHT
 * (keep this notice and the author credit, mark modified versions, no rights to the SignalDeck name or icon).
 */
package com.macdmr.radio.ham;

/**
 * RTTY: 45.45 baud Baudot (ITA2), 170 Hz shift, 1.5 stop bits, as amateurs send it. Audio is 8 kHz mono.
 *
 * Receive: the mark and space tones are mixed to baseband and low-passed (half a bit); the difference of their
 * levels is the bit. A start bit (mark to space) starts a character, bits are read in their middle, a missing stop
 * bit drops it. The pair is found by itself: every half second, while no character is being read, the two tones 170
 * Hz apart that stand out most between 600 and 2700 Hz are taken (mark is the lower one, as fldigi sends it).
 */
public final class Rtty {
    public static final double BAUD = 45.45, SHIFT = 170;
    private static final int SR = 8000;
    private static final double SPB = SR / BAUD;                   // samples per bit, 176

    // ITA2: index = 5-bit code (LSB first on air), letters and figures
    private static final String LTRS = "\0E\nA SIU\rDRJNFCKTZLWHYPQOBG\u000EMXV\u000F";
    private static final String FIGS = "\u0000" + "3\n- \u000787\r$4',!:(5\")2#6019?&\u000E./;\u000F";
    private static final int LTRS_CODE = 31, FIGS_CODE = 27;

    // ---- transmit ---------------------------------------------------------------------------------

    /** Phase-continuous AFSK of {@code text} (upper-cased) after {@code idleMs} of mark tone. */
    public static short[] encode(String text, double markHz, int idleMs) {
        StringBuilder bits = new StringBuilder();               // '1' = mark, '0' = space, at bit rate; stop bits as "1.5"
        java.util.List<double[]> seg = new java.util.ArrayList<>();
        seg.add(new double[] { 1, idleMs / 1000.0 * BAUD });
        boolean figs = false;
        addChar(seg, LTRS_CODE);
        for (char ch : text.toUpperCase(java.util.Locale.US).toCharArray()) {
            if (ch == '\n') { addChar(seg, 8); addChar(seg, 2); continue; }        // CR LF
            int l = LTRS.indexOf(ch), f = FIGS.indexOf(ch);
            if (ch == ' ') { addChar(seg, 4); figs = false; continue; }          // receivers unshift on space: send FIGS again after one
            if (l > 0 && l != LTRS_CODE && l != FIGS_CODE) { if (figs) { addChar(seg, LTRS_CODE); figs = false; } addChar(seg, l); }
            else if (f > 0 && f != LTRS_CODE && f != FIGS_CODE) { if (!figs) { addChar(seg, FIGS_CODE); figs = true; } addChar(seg, f); }
        }
        addChar(seg, LTRS_CODE); seg.add(new double[] { 1, 0.3 * BAUD });
        double total = 0; for (double[] s : seg) total += s[1];
        short[] out = new short[(int) Math.ceil(total * SPB)];
        double phase = 0, t = 0; int n = 0;
        for (double[] s : seg) {
            double hz = s[0] == 1 ? markHz : markHz + SHIFT; t += s[1] * SPB;
            for (; n < (int) t && n < out.length; n++) { phase += 2 * Math.PI * hz / SR; out[n] = (short) (14000 * Math.sin(phase)); }
        }
        int edge = 80; for (int i = 0; i < edge && i < out.length; i++) { double g = i / (double) edge; out[i] *= g; out[out.length - 1 - i] *= g; }
        return out;
    }
    private static void addChar(java.util.List<double[]> seg, int code) {
        seg.add(new double[] { 0, 1 });
        for (int b = 0; b < 5; b++) seg.add(new double[] { (code >> b) & 1, 1 });
        seg.add(new double[] { 1, 1.5 });
    }

    // ---- receive ----------------------------------------------------------------------------------

    public interface Listener { void onChar(char c); }

    private final Listener listener;
    private double mark = 2125;
    private double pm, ps;                                         // NCO phases
    private double mi, mq, si, sq;                                 // low-passed baseband
    private final double alpha = 1 - Math.exp(-2 * Math.PI * (BAUD * 0.7) / SR);
    private int state = 0; private double clock; private int bitN, code;   // 0 idle (mark), 1 reading bits
    private boolean figs, lastMark = true;
    private final short[] hist = new short[4096]; private int hp, sinceTune; private boolean locked;
    private double level, quality;

    public Rtty(Listener l) { listener = l; }
    public double markHz() { return mark; }
    public boolean locked() { return locked; }
    public void setMark(double hz) { mark = hz; locked = true; }

    public void process(short[] x) { for (short v : x) sample(v); }
    public void process(byte[] mono, int n) { for (int i = 0; i + 1 < n; i += 2) sample((short) ((mono[i] & 0xFF) | (mono[i + 1] << 8))); }

    private void sample(short v) {
        hist[hp] = v; hp = (hp + 1) & (hist.length - 1);
        if (++sinceTune >= SR / 2) { sinceTune = 0; if (state == 0) tune(); }
        double x = v / 32768.0;
        pm += 2 * Math.PI * mark / SR; ps += 2 * Math.PI * (mark + SHIFT) / SR;
        if (pm > 2 * Math.PI) pm -= 2 * Math.PI; if (ps > 2 * Math.PI) ps -= 2 * Math.PI;
        mi += alpha * (x * Math.cos(pm) - mi); mq += alpha * (x * Math.sin(pm) - mq);
        si += alpha * (x * Math.cos(ps) - si); sq += alpha * (x * Math.sin(ps) - sq);
        double m = Math.hypot(mi, mq), s = Math.hypot(si, sq);
        level += 0.001 * (Math.max(m, s) - level);
        boolean isMark = m > s;
        // quality: with a real FSK signal one tone is far above the other; with noise they are alike
        double hi = Math.max(m, s), lo = Math.min(m, s);
        quality += 0.002 * ((hi > 3 * lo ? 1 : 0) - quality);
        if (!locked) return;
        if (quality < 0.6) { state = 0; lastMark = true; return; }
        if (state == 0) {
            if (lastMark && !isMark && s > 0.3 * level) { state = 1; clock = SPB * 1.5; bitN = 0; code = 0; }   // start bit: first data bit 1.5 bits on
        } else {
            if (--clock <= 0) {
                if (bitN < 5) { if (isMark) code |= 1 << bitN; bitN++; clock += SPB; }
                else { if (isMark) deliver(code); state = 0; }                                            // the stop bit must be mark
            }
        }
        lastMark = isMark;
    }

    private void deliver(int c) {
        if (c == LTRS_CODE) { figs = false; return; }
        if (c == FIGS_CODE) { figs = true; return; }
        if (c == 4) { figs = false; listener.onChar(' '); return; }   // unshift on space, as most decoders do
        char ch = (figs ? FIGS : LTRS).charAt(c);
        if (ch == '\r' || ch == 0) return;
        listener.onChar(ch);
    }

    /** Find the strongest 170 Hz pair in the last half second. */
    private void tune() {
        int n = 2048, start = (hp - n) & (hist.length - 1);
        double best = 0, bestHz = 0, single = 0, singleHz = 0, sum = 0; int cnt = 0;
        for (double f = 600; f <= 2700 - SHIFT; f += 10) {
            double a = goertzel(start, n, f), b = goertzel(start, n, f + SHIFT);
            sum += a + b; cnt += 2;
            double score = Math.min(a, b);                         // both tones there: a signal carrying data
            if (score > best) { best = score; bestHz = f; }
            if (a > single) { single = a; singleHz = f; }
        }
        double mean = sum / Math.max(1, cnt);
        double hz = best > 4 * mean ? bestHz : !locked && single > 10 * mean ? singleHz : -1;   // one steady tone: the idle mark
        if (hz > 0) { if (!locked || Math.abs(hz - mark) > 15) { mark = hz; pm = ps = 0; } locked = true; }
    }
    private double goertzel(int start, int n, double hz) {
        double w = 2 * Math.PI * hz / SR, c = 2 * Math.cos(w), s1 = 0, s2 = 0;
        for (int i = 0; i < n; i++) { double s0 = hist[(start + i) & (hist.length - 1)] + c * s1 - s2; s2 = s1; s1 = s0; }
        return Math.sqrt(Math.max(0, s1 * s1 + s2 * s2 - c * s1 * s2)) / n;
    }
}
