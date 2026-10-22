/*
 * SignalDeck - Copyright (C) 2026 IIMacGyverII
 * SPDX-License-Identifier: GPL-3.0-or-later
 * Free software under the GNU General Public License v3 or later, with the additional terms in COPYRIGHT
 * (keep this notice and the author credit, mark modified versions, no rights to the SignalDeck name or icon).
 */
package com.macdmr.radio.pkt;

import com.macdmr.radio.pkt.sstv.SSTVIQDemodulator;

/**
 * Continuous Robot 36 receiver, MMSSTV-style: it does not wait for a VIS header. A line clock locks on three evenly
 * spaced sync pulses, follows the transmitter's real line period (slant correction), and coasts through lost syncs, so
 * a picture picked up halfway through, or one that fades in and out, is still drawn. Colour comes from each line's
 * separator tone (1500 Hz = R-Y, 2300 Hz = B-Y), so a lost line cannot swap the colours of the rest of the picture.
 * A picture that started with its leader tone is drawn from the top; one picked up part-way and ended by the
 * transmission stopping is moved to the bottom, where its last line belongs. While unlocked the decoder keeps drawing
 * what it hears (static), as MMSSTV does.
 *
 * Pure Java (no Android types): pixels are ARGB ints, so the decoder runs in host unit tests.
 */
public final class SstvContinuous {
    public interface Listener {
        /** The live canvas changed (a line was drawn); {@code locked} while a picture is being received. */
        void onLive(int[] argb, int width, int height, boolean locked, int pictureLines);
        /** A picture finished: complete (240 lines) or partial (signal lost); pixels already placed. */
        void onPicture(int[] argb, int width, int height, int lines, boolean complete);
    }

    public static final int W = 320, H = 240;
    private static final double LINE_MS = 150.0, SYNC_MS = 9.0, PORCH_MS = 3.0, Y_MS = 88.0, SEP_MS = 4.5, PORCH2_MS = 1.5, C_MS = 44.0;
    private static final double TIMING_MS = 0.55;           // the demodulator reports the sync this much late (measured against the reference picture)
    private static final int MAX_COAST = 12;                 // lines (1.8 s) without a sync before the lock is dropped
    private static final int MIN_SAVE = 16;                  // lines: shorter partial pictures are not kept

    private final int sr;
    private final SSTVIQDemodulator demod;
    private final Listener listener;
    private final float[] ring;                              // demodulated frequency, normalised (-1..1 over 1000..2800 Hz)
    private final int ringMask;
    private long n;                                          // samples processed
    private float[] chunkOut = new float[0];

    // line clock
    private final double nominal;                            // samples per line
    private double period;
    private boolean locked;
    private long lineStart = -1;                             // start of the current line (end of its sync)
    private int coast;
    private final long[] recentSync = new long[8]; private int recentCount;
    private long lastLeaderEnd = -1;                         // end of a 1900 Hz leader (start of a picture)
    private int leaderRun; private boolean leaderSeen;
    private float env;

    // picture
    private final int[][] yRow = new int[H][W], cRow = new int[H][W];
    private final int[] cType = new int[H];                  // 0 R-Y, 1 B-Y
    private int lines;                                       // lines in the current picture
    private int realLines;                                   // lines up to the last real (not coasted) sync
    private boolean fromTop;                                 // the picture began with its leader
    private final int[] canvas = new int[W * H];
    private int freeRow;                                     // unlocked: where static is drawn

    public SstvContinuous(int sampleRate, Listener l) {
        sr = sampleRate; listener = l;
        demod = new SSTVIQDemodulator(sampleRate);
        int size = 1; while (size < sampleRate * 2) size <<= 1;   // 2 s of history
        ring = new float[size]; ringMask = size - 1;
        nominal = LINE_MS * sampleRate / 1000.0; period = nominal;
        java.util.Arrays.fill(canvas, 0xFF202428);
    }

    public boolean locked() { return locked; }
    public int pictureLines() { return lines; }

    /** 16-bit mono samples at the decoder's sample rate. */
    public void process(short[] pcm, int len) {
        if (chunkOut.length < len) chunkOut = new float[len];
        short[] in = pcm; if (len != pcm.length) { in = new short[len]; System.arraycopy(pcm, 0, in, 0, len); }
        boolean sync = demod.process(in, chunkOut);
        long syncAt = sync && demod.syncPulseWidth == SSTVIQDemodulator.SyncPulseWidth.NINE_MS ? n + demod.syncPulseOffset : -1;
        for (int i = 0; i < len; i++) {
            float v = chunkOut[i];
            ring[(int) ((n + i) & ringMask)] = v;
            // leader: 1900 Hz (normalised 0) held for 200 ms
            env += (Math.abs(in[i]) - env) * 0.002f;          // input envelope: silence demodulates to "1900 Hz" too
            if (Math.abs(v) < 0.06f && env > 600) { if (++leaderRun == (int) (0.2 * sr)) { lastLeaderEnd = n + i; leaderSeen = true; } } else leaderRun = 0;
        }
        n += len;
        if (leaderSeen) { leaderSeen = false; if (locked) endPicture(lines >= H); }    // the next picture's leader: this one is over
        if (syncAt >= 0) onSync(syncAt);
        clock();
    }

    private void onSync(long s) {
        if (!locked) {
            // three syncs a whole number of lines apart (1..4) within 1 %: lock
            long[] match = new long[recentSync.length]; int hits = 0;
            for (int i = 0; i < recentCount; i++) {
                long d = s - recentSync[i]; double k = Math.round(d / nominal);
                if (k >= 1 && k <= 4 && Math.abs(d - k * nominal) < nominal * 0.01 * k) match[hits++] = recentSync[i];
            }
            System.arraycopy(recentSync, 0, recentSync, 1, recentSync.length - 1); recentSync[0] = s; recentCount = Math.min(recentCount + 1, recentSync.length);
            if (hits >= 2) {
                // lock from the FIRST matching sync and decode the lines since then from the history (nothing lost)
                java.util.Arrays.sort(match, 0, hits);
                long first = match[0];
                // the first line's sync can merge with the VIS stop bit (both 1200 Hz), so the demodulator does not report
                // it: if a 1200 Hz sync tone sits one line earlier, the picture starts there
                for (int k = 0; k < 2 && n - (first - (long) nominal) < ring.length - 16 && syncToneAt(first - Math.round(nominal)); k++) first -= Math.round(nominal);
                startPicture(first);
                if (first < match[0]) { endLine(match[0]); realLines = lines; }
                for (int i = 1; i < hits; i++) {
                    long m = match[i];
                    while (m - lineStart > period * 1.5) endLine(Math.round(lineStart + period));   // a missed sync between two matches
                    endLine(m); realLines = lines;
                }
                endLine(s); realLines = lines;
            }
            return;
        }
        double expected = lineStart + period;
        if (Math.abs(s - expected) < nominal * 0.04) {
            // a real sync where the clock expected it: the line ends here; follow the transmitter's timing
            double observed = s - lineStart;
            if (coast == 0) period += 0.08 * (observed - period);
            endLine(s); coast = 0; realLines = lines;
        }
    }

    /** Lines whose sync never came: close them on the clock (coasting). */
    private void clock() {
        if (!locked) {                                       // static while idle: one line per nominal period
            if (n - freeStart >= nominal + sr / 100) { drawFree(freeStart); freeStart += (long) nominal; }
            return;
        }
        while (n >= lineStart + period + nominal * 0.05) {
            long b = Math.round(lineStart + period);
            if (++coast > MAX_COAST) { endPicture(false); return; }
            endLine(b);
        }
    }
    private long freeStart;

    private void startPicture(long s) {
        if (lines > 0) endPicture(false);
        locked = true; coast = 0; period = nominal; lineStart = s; lines = 0; realLines = 0;
        fromTop = lastLeaderEnd >= 0 && s - lastLeaderEnd < 1.6 * sr;   // leader + VIS end about 0.9 s before the first sync
        java.util.Arrays.fill(canvas, 0xFF202428);
    }

    /** The line that began at lineStart is complete (its next sync is at b): decode it. */
    private void endLine(long b) {
        if (n - lineStart > ring.length - 16) { lineStart = b; return; }    // too old to read back
        int row = lines;
        if (row < H) {
            decodeLine(lineStart, row);
            lines++;
            render(row); if (row > 0) render(row - 1);
            if (listener != null) listener.onLive(canvas, W, H, true, lines);
        }
        lineStart = b;
        if (lines >= H) endPicture(true);
    }

    private void decodeLine(long start, int row) {
        double ms = sr / 1000.0;
        double y0 = start + (PORCH_MS - TIMING_MS) * ms, yLen = Y_MS * ms;
        double sep0 = y0 + yLen, c0 = sep0 + (SEP_MS + PORCH2_MS) * ms, cLen = C_MS * ms;
        for (int x = 0; x < W; x++) yRow[row][x] = level(avg(y0 + x * yLen / W, yLen / W));
        for (int x = 0; x < W; x++) cRow[row][x] = level(avg(c0 + x * cLen / W, cLen / W));
        float sep = (float) avg(sep0 + 0.5 * ms, (SEP_MS - 1.0) * ms);
        cType[row] = sep < 0 ? 0 : 1;                        // 1500 Hz (below 1900) = R-Y, 2300 Hz = B-Y
    }
    /** A sync tone (1200 Hz, normalised about -0.78) just before sample b. */
    private boolean syncToneAt(long b) { return b > 0 && avg(b - 7.0 * sr / 1000, 5.0 * sr / 1000) < -0.6; }
    private double avg(double from, double len) {
        int a = (int) Math.floor(from), b = Math.max(a + 1, (int) Math.ceil(from + len));
        double s = 0; for (int i = a; i < b; i++) s += ring[i & ringMask];
        return s / (b - a);
    }
    /** Normalised frequency to 0..255 (1500 Hz black .. 2300 Hz white; full range, as MMSSTV). */
    private static int level(double v) {
        double hz = 1900 + v * 900;
        int l = (int) Math.round((hz - 1500) * 255 / 800);
        return l < 0 ? 0 : l > 255 ? 255 : l;
    }

    private void render(int row) {
        int cr = -1, cb = -1;
        for (int d : new int[] { 0, -1, 1, -2, 2 }) {
            int r = row + d; if (r < 0 || r >= lines) continue;
            if (cType[r] == 0 && cr < 0) cr = r; else if (cType[r] == 1 && cb < 0) cb = r;
        }
        int o = row * W;
        for (int x = 0; x < W; x++) {
            int Y = yRow[row][x], Cr = cr >= 0 ? cRow[cr][x] : 128, Cb = cb >= 0 ? cRow[cb][x] : 128;
            int r = clamp((int) (Y + 1.402 * (Cr - 128))), g = clamp((int) (Y - 0.344136 * (Cb - 128) - 0.714136 * (Cr - 128))), bl = clamp((int) (Y + 1.772 * (Cb - 128)));
            canvas[o + x] = 0xFF000000 | (r << 16) | (g << 8) | bl;
        }
    }
    private static int clamp(int v) { return v < 0 ? 0 : v > 255 ? 255 : v; }

    /** Unlocked: draw what the receiver hears as a grey line (static), wrapping down the canvas. */
    private void drawFree(long start) {
        if (n - start > ring.length - 16) return;
        double yLen = Y_MS * sr / 1000.0; int o = freeRow * W;
        for (int x = 0; x < W; x++) { int l = level(avg(start + (PORCH_MS - TIMING_MS) * sr / 1000.0 + x * yLen / W, yLen / W)); canvas[o + x] = 0xFF000000 | (l << 16) | (l << 8) | l; }
        freeRow = (freeRow + 1) % H;
        if (listener != null) listener.onLive(canvas, W, H, false, 0);
    }

    /** The picture ends: complete, or the signal was lost (partial). */
    private void endPicture(boolean complete) {
        locked = false; coast = 0; recentCount = 0; freeStart = n;
        // a lost signal: the coasted lines after the last real sync are noise, except the first one, which is the real last
        // line (it never gets a following sync because the transmission stops there)
        int got = complete ? lines : Math.min(lines, realLines + 1); lines = 0;
        if (got < MIN_SAVE && !complete) return;
        int[] out = new int[W * H];
        java.util.Arrays.fill(out, 0xFF000000);
        int shift = complete || fromTop ? 0 : H - got;       // picked up part-way: its last line is the picture's last line
        for (int r = 0; r < got; r++) System.arraycopy(canvas, r * W, out, (r + shift) * W, W);
        if (listener != null) listener.onPicture(out, W, H, got, complete);
    }

    /** Stop: finish a picture in progress (partial). */
    public void flush() { if (locked && lines > 0) endPicture(lines >= H); }
}
