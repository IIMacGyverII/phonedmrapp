package com.dmrmod.hooks;

import android.graphics.Bitmap;

/**
 * SSTV encoder for the modes that fit this radio's 30 s transmit time-out:
 * Robot 24 Color (24 s), Robot 12 BW (12 s), Robot 8 BW (8 s).
 *
 * Output is 8 kHz 16-bit mono PCM (the OEM mic path rate); the caller stereo-duplicates it into the
 * TX injection buffer. VIS uses the standard polarity (logical 1 = 1100 Hz, 0 = 1300 Hz), Robot
 * luma/chroma are full-range (Y 0..255 ↔ 1500..2300 Hz, Cb/Cr centred on 128) as the module's own
 * decoder, pySSTV and MMSSTV expect. Tones are continuous-phase with fractional-sample timing so
 * line timing does not drift across the image.
 */
public final class SSTVEncoder {
    public static final int SAMPLE_RATE = 8000;
    private static final double F_SYNC = 1200, F_BLACK = 1500, F_WHITE = 2300, F_LEADER = 1900;
    private static final double F_BIT1 = 1100, F_BIT0 = 1300;
    private static final double AMP = 30000;

    private SSTVEncoder() { }

    /** Supported modes (VIS codes). */
    public static final int ROBOT_24_COLOR = SSTVMode.MODE_ROBOT_24_C;   // 0x04, 320x120 lines (RX doubles to 240), ~24 s
    public static final int ROBOT_12_BW    = SSTVMode.MODE_ROBOT_12_BW;  // 0x03, 160x120, ~12 s
    public static final int ROBOT_8_BW     = SSTVMode.MODE_ROBOT_8_BW;   // 0x02, 160x120, ~8 s

    public static boolean isSupported(int mode) {
        return mode == ROBOT_24_COLOR || mode == ROBOT_12_BW || mode == ROBOT_8_BW;
    }

    public static String name(int mode) {
        return mode == ROBOT_24_COLOR ? "Robot 24 Color" : mode == ROBOT_12_BW ? "Robot 12 BW" : mode == ROBOT_8_BW ? "Robot 8 BW" : "?";
    }

    /** Approximate audio duration in ms (VIS + image + tails), for TOT checks and UI. */
    public static int durationMs(int mode) {
        int lines = 120;
        double lineMs = mode == ROBOT_24_COLOR ? (6 + 3 + 88 + 4.5 + 1.5 + 44 + 4.5 + 1.5 + 44)
                      : mode == ROBOT_12_BW    ? (7 + 3 + 90)
                      :                          (7 + 3 + 56);
        return (int) (100 + 300 + 10 + 300 + 30 + 9 * 30 + lines * lineMs + 100);
    }

    /** Encode a bitmap (any size; it is scaled to the mode's geometry). Returns 8 kHz mono PCM. */
    public static short[] encode(Bitmap src, int mode) {
        int w = (mode == ROBOT_24_COLOR) ? 320 : 160;
        int h = 120;
        Bitmap bmp = Bitmap.createScaledBitmap(src, w, h, true);
        int[] px = new int[w * h];
        bmp.getPixels(px, 0, w, 0, 0, w, h);

        Tone t = new Tone();
        t.tone(F_LEADER, 100);          // a little extra leader so the first 1900 Hz is clean after key-up
        vis(t, mode);

        double[] y = new double[w], cr = new double[w], cb = new double[w];
        for (int line = 0; line < h; line++) {
            for (int x = 0; x < w; x++) {
                int p = px[line * w + x];
                double r = (p >> 16) & 0xFF, g = (p >> 8) & 0xFF, b = p & 0xFF;
                y[x]  = clamp(0.299 * r + 0.587 * g + 0.114 * b);
                cb[x] = clamp(128 - 0.168736 * r - 0.331264 * g + 0.5 * b);
                cr[x] = clamp(128 + 0.5 * r - 0.418688 * g - 0.081312 * b);
            }
            if (mode == ROBOT_24_COLOR) {
                t.tone(F_SYNC, 6); t.tone(F_BLACK, 3);
                t.pixels(y, 88);
                t.tone(1500, 4.5); t.tone(1900, 1.5); t.pixels(cr, 44);
                t.tone(2300, 4.5); t.tone(1900, 1.5); t.pixels(cb, 44);
            } else {
                t.tone(F_SYNC, 7); t.tone(F_BLACK, 3);
                t.pixels(y, mode == ROBOT_12_BW ? 90 : 56);
            }
        }
        t.tone(F_LEADER, 100);
        return t.toShorts();
    }

    private static double clamp(double v) { return v < 0 ? 0 : v > 255 ? 255 : v; }

    private static void vis(Tone t, int code) {
        t.tone(F_LEADER, 300); t.tone(F_SYNC, 10); t.tone(F_LEADER, 300);
        t.tone(F_SYNC, 30);                              // start bit
        int ones = 0;
        for (int i = 0; i < 7; i++) {
            int bit = (code >> i) & 1; ones += bit;
            t.tone(bit == 1 ? F_BIT1 : F_BIT0, 30);      // LSB first
        }
        t.tone((ones % 2) == 1 ? F_BIT1 : F_BIT0, 30);   // even parity
        t.tone(F_SYNC, 30);                              // stop bit
    }

    /** Continuous-phase tone generator with fractional-sample timing carry. */
    private static final class Tone {
        private double phase = 0, tErr = 0;
        private short[] buf = new short[SAMPLE_RATE * 30];
        private int n = 0;

        private void ensure(int more) {
            if (n + more > buf.length) {
                short[] nb = new short[Math.max(buf.length * 2, n + more)];
                System.arraycopy(buf, 0, nb, 0, n); buf = nb;
            }
        }
        private int samplesFor(double ms) {
            double nf = ms * SAMPLE_RATE / 1000.0 + tErr;
            int k = (int) Math.round(nf); tErr = nf - k; return Math.max(k, 0);
        }
        void tone(double freq, double ms) {
            int k = samplesFor(ms); ensure(k);
            double dph = 2 * Math.PI * freq / SAMPLE_RATE;
            for (int i = 0; i < k; i++) { phase += dph; buf[n++] = (short) (AMP * Math.sin(phase)); }
            phase %= (2 * Math.PI);
        }
        void pixels(double[] vals, double ms) {
            int k = samplesFor(ms); ensure(k); int w = vals.length;
            for (int i = 0; i < k; i++) {
                double v = vals[(int) ((long) i * w / k)];
                double f = F_BLACK + (F_WHITE - F_BLACK) * v / 255.0;
                phase += 2 * Math.PI * f / SAMPLE_RATE;
                buf[n++] = (short) (AMP * Math.sin(phase));
            }
            phase %= (2 * Math.PI);
        }
        short[] toShorts() { short[] out = new short[n]; System.arraycopy(buf, 0, out, 0, n); return out; }
    }
}
