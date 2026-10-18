package com.macdmr.radio.dsp;

/**
 * The radio's CTCSS sub-code table (index -> Hz): the OEM list has 51 entries and starts at 62.5 Hz
 * (index 0 = 62.5, 1 = 67.0 ... 50 = 254.1), the same numbering the MCU receives in rxSubCode/txSubCode.
 * One source of truth: {@link ToneConverter}, which the CSV backups and the CTCSS decoder already use.
 */
public final class ToneTable {
    public static final double[] CTCSS;
    static { CTCSS = new double[ToneConverter.ctcssCount()]; for (int i = 0; i < CTCSS.length; i++) CTCSS[i] = ToneConverter.ctcssHz(i); }

    public static double ctcssHz(int code) { return code >= 0 && code < CTCSS.length ? CTCSS[code] : -1; }
    public static String ctcssLabel(int code) { double hz = ctcssHz(code); return hz > 0 ? String.format(java.util.Locale.US, "%.1f Hz", hz) : "—"; }
}
