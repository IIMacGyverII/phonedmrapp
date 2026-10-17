package com.macdmr.radio.dsp;

/** The radio's CTCSS sub-code table (index → Hz), same order as the stock app's picker. */
public final class ToneTable {
    public static final double[] CTCSS = { 67.0, 69.3, 71.9, 74.4, 77.0, 79.7, 82.5, 85.4, 88.5, 91.5, 94.8, 97.4, 100.0, 103.5, 107.2, 110.9, 114.8, 118.8, 123.0, 127.3,
            131.8, 136.5, 141.3, 146.2, 151.4, 156.7, 159.8, 162.2, 165.5, 167.9, 171.3, 173.8, 177.3, 179.9, 183.5, 186.2, 189.9, 192.8, 196.6, 199.5,
            203.5, 206.5, 210.7, 218.1, 225.7, 229.1, 233.6, 241.8, 250.3, 254.1 };

    public static double ctcssHz(int code) { return code >= 0 && code < CTCSS.length ? CTCSS[code] : -1; }
    public static String ctcssLabel(int code) { double hz = ctcssHz(code); return hz > 0 ? String.format(java.util.Locale.US, "%.1f Hz", hz) : "—"; }
}
