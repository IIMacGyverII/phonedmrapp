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

    /**
     * DCS: type 2 (normal) and type 3 (inverted) index the OEM's 83-code table (0 = 023, 82 = 754), the number the MCU
     * receives; it is not the octal code itself.
     */
    public static final int DCS_COUNT = ToneConverter.dcsCount();
    public static String dcsCode(int index) { return ToneConverter.dcsAt(index); }
    /** "023" (or "D023N"/"23") → its index, -1 if it is not one of the 83 codes. */
    public static int dcsIndex(String code) {
        if (code == null) return -1;
        String c = code.trim().toUpperCase(java.util.Locale.US).replaceAll("^D", "").replaceAll("[NIR]$", "");
        try { int v = Integer.parseInt(c, 8); for (int i = 0; i < DCS_COUNT; i++) if (Integer.parseInt(dcsCode(i), 8) == v) return i; } catch (RuntimeException ignored) { }
        return -1;
    }
    /** "100.0 Hz", "D023N", "D023I" or "—". */
    public static String toneLabel(int type, int code) {
        if (type == 1) return ctcssLabel(code);
        if ((type == 2 || type == 3) && dcsCode(code) != null) return "D" + dcsCode(code) + (type == 3 ? "I" : "N");
        return "—";
    }
}
