/*
 * SignalDeck - Copyright (C) 2026 IIMacGyverII
 * SPDX-License-Identifier: GPL-3.0-or-later
 * Free software under the GNU General Public License v3 or later, with the additional terms in COPYRIGHT
 * (keep this notice and the author credit, mark modified versions, no rights to the SignalDeck name or icon).
 */
package com.macdmr.radio.dsp;

/**
 * The received audio's spectrum for the intercom's bars (phone and web): 8 kHz mono in, every 256 samples (32 ms) a
 * Hann-windowed FFT, folded into {@link #BANDS} log-spaced bands from 200 Hz to 3.6 kHz (the voice band this radio passes),
 * each 0…1 on a 60 dB scale. Pure Java, host-tested.
 */
public final class Spectrum {
    public static final int BANDS = 18, N = 256;
    static final double F_LO = 200, F_HI = 3600, RATE = 8000, FLOOR_DB = -60, TOP_DB = 0;

    private final double[] win = new double[N], re = new double[N], im = new double[N];
    private final short[] buf = new short[N]; private int fill;
    private final int[] binLo = new int[BANDS], binHi = new int[BANDS];
    private final float[] out = new float[BANDS];

    public Spectrum() {
        for (int i = 0; i < N; i++) win[i] = 0.5 - 0.5 * Math.cos(2 * Math.PI * i / (N - 1));
        for (int b = 0; b < BANDS; b++) {
            double f0 = F_LO * Math.pow(F_HI / F_LO, (double) b / BANDS), f1 = F_LO * Math.pow(F_HI / F_LO, (double) (b + 1) / BANDS);
            binLo[b] = (int) Math.floor(f0 * N / RATE); binHi[b] = Math.max(binLo[b], (int) Math.ceil(f1 * N / RATE) - 1);
        }
    }

    /**
     * Feed little-endian 16-bit mono bytes; returns the bands each time a block completes (the same array, reused), or
     * null when no block completed in this call.
     */
    public float[] feed(byte[] mono, int len) {
        float[] r = null;
        for (int i = 0; i + 1 < len; i += 2) {
            buf[fill++] = (short) ((mono[i] & 0xFF) | (mono[i + 1] << 8));
            if (fill == N) { compute(); fill = 0; r = out; }
        }
        return r;
    }
    public float[] feed(short[] s, int n) {
        float[] r = null;
        for (int i = 0; i < n; i++) { buf[fill++] = s[i]; if (fill == N) { compute(); fill = 0; r = out; } }
        return r;
    }
    public void reset() { fill = 0; java.util.Arrays.fill(out, 0); }

    private void compute() {
        for (int i = 0; i < N; i++) { re[i] = buf[i] / 32768.0 * win[i]; im[i] = 0; }
        fft(re, im);
        for (int b = 0; b < BANDS; b++) {
            double p = 0;
            for (int k = binLo[b]; k <= binHi[b]; k++) p = Math.max(p, re[k] * re[k] + im[k] * im[k]);
            double db = 10 * Math.log10(p * 4.0 / (N * N) * 4 + 1e-12);      // ×4: the Hann window halves a sine's amplitude; full scale sine ≈ 0 dB
            out[b] = (float) Math.max(0, Math.min(1, (db - FLOOR_DB) / (TOP_DB - FLOOR_DB)));
        }
    }

    /** In-place radix-2 FFT (N a power of two). */
    static void fft(double[] re, double[] im) {
        int n = re.length;
        for (int i = 1, j = 0; i < n; i++) {
            int bit = n >> 1; for (; (j & bit) != 0; bit >>= 1) j ^= bit; j ^= bit;
            if (i < j) { double t = re[i]; re[i] = re[j]; re[j] = t; t = im[i]; im[i] = im[j]; im[j] = t; }
        }
        for (int len = 2; len <= n; len <<= 1) {
            double ang = -2 * Math.PI / len, wr = Math.cos(ang), wi = Math.sin(ang);
            for (int i = 0; i < n; i += len) {
                double cr = 1, ci = 0;
                for (int k = 0; k < len / 2; k++) {
                    int a = i + k, bb = a + len / 2;
                    double xr = re[bb] * cr - im[bb] * ci, xi = re[bb] * ci + im[bb] * cr;
                    re[bb] = re[a] - xr; im[bb] = im[a] - xi; re[a] += xr; im[a] += xi;
                    double t = cr * wr - ci * wi; ci = cr * wi + ci * wr; cr = t;
                }
            }
        }
    }

    /** The band a frequency falls in (-1 outside 200 Hz … 3.6 kHz), for tests and labels. */
    public static int bandOf(double hz) { if (hz < F_LO || hz >= F_HI) return -1; return (int) Math.floor(BANDS * Math.log(hz / F_LO) / Math.log(F_HI / F_LO)); }
}
