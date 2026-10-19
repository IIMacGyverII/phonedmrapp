package com.macdmr.radio.coverage;

import java.util.Arrays;
import java.util.List;
import java.util.Locale;

/**
 * The plain logic of coverage mapping, kept free of Android so it is unit tested: which fixes are good enough,
 * how a key-up is judged from the signal after you unkey, the map grid, and the colour scale.
 */
public final class CoverageMath {
    private CoverageMath() { }

    /** A fix is used only when it is this accurate (metres)... */
    public static final float MAX_ACCURACY_M = 50f;
    /** ...and this fresh. */
    public static final long MAX_FIX_AGE_MS = 15_000;
    /** Map grid edge in metres: small enough to follow a road, large enough to average a few readings. */
    public static final double CELL_M = 150;
    /** A key-up counts when the signal after you unkey stands this far above the quiet noise floor. */
    public static final int KEYUP_MARGIN_DB = 8;
    /** Readings taken after unkeying, in ms (the repeater's tail is usually there within half a second). */
    public static final long[] PROBE_MS = { 250, 550, 900, 1300, 1800 };
    /** Transmissions shorter than this are not judged (a bump of the key). */
    public static final long MIN_TX_MS = 600;

    public static boolean fixUsable(float accuracyM, long ageMs) {
        return accuracyM > 0 && accuracyM <= MAX_ACCURACY_M && ageMs >= 0 && ageMs <= MAX_FIX_AGE_MS;
    }

    /** Median of the quiet-channel readings (dBm); -999 when there are none. */
    public static int floor(List<Integer> quiet) {
        if (quiet == null || quiet.isEmpty()) return -999;
        int[] a = new int[quiet.size()]; for (int i = 0; i < a.length; i++) a[i] = quiet.get(i);
        return median(a);
    }

    public static int median(int[] v) {
        if (v.length == 0) return -999;
        int[] a = v.clone(); Arrays.sort(a);
        int n = a.length; return n % 2 == 1 ? a[n / 2] : (int) Math.round((a[n / 2 - 1] + a[n / 2]) / 2.0);
    }

    /** Key-up results. */
    public static final int NO_REPLY = 0, KEYED = 1, UNKNOWN = -1;

    /**
     * Judge a transmission from the readings after unkeying: KEYED when the strongest one stands
     * {@link #KEYUP_MARGIN_DB} above the floor; NO_REPLY when none does; UNKNOWN without a floor or readings.
     */
    public static int judgeKeyup(List<Integer> after, int floorDbm) {
        if (after == null || after.isEmpty() || floorDbm == -999) return UNKNOWN;
        int best = -999; for (int v : after) if (v != -999) best = Math.max(best, v);
        if (best == -999) return UNKNOWN;
        return best >= floorDbm + KEYUP_MARGIN_DB ? KEYED : NO_REPLY;
    }

    /** Repeater identity: its output frequency and position (a channel can be renumbered or renamed). */
    public static String repeaterKey(int rxHz, double lat, double lon) {
        return String.format(Locale.US, "%d@%.3f,%.3f", rxHz, lat, lon);
    }

    // ---- grid ---------------------------------------------------------------------------------------
    /** Grid row/column of a point: rows are {@link #CELL_M} of latitude, columns {@link #CELL_M} of longitude at that latitude band. */
    public static long cell(double lat, double lon) {
        long row = (long) Math.floor(lat * 111_320.0 / CELL_M);
        double rowLat = (row + 0.5) * CELL_M / 111_320.0;
        double mPerDegLon = 111_320.0 * Math.cos(Math.toRadians(rowLat));
        long col = (long) Math.floor(lon * mPerDegLon / CELL_M);
        return (row << 32) ^ (col & 0xFFFFFFFFL);
    }

    /** {south, west, north, east} of a grid cell. */
    public static double[] cellBounds(long cell) {
        long row = cell >> 32; long col = (int) (cell & 0xFFFFFFFFL);
        double s = row * CELL_M / 111_320.0, n = (row + 1) * CELL_M / 111_320.0;
        double rowLat = (row + 0.5) * CELL_M / 111_320.0;
        double mPerDegLon = 111_320.0 * Math.cos(Math.toRadians(rowLat));
        double w = col * CELL_M / mPerDegLon, e = (col + 1) * CELL_M / mPerDegLon;
        return new double[] { s, w, n, e };
    }

    // ---- colour -------------------------------------------------------------------------------------
    /** Weakest and strongest ends of the colour scale (dBm). */
    public static final int SCALE_LOW = -125, SCALE_HIGH = -65;

    /** Signal colour: blue (barely heard) through cyan, green and yellow to red (strong). Opaque ARGB. */
    public static int signalColor(int dbm) {
        double t = Math.max(0, Math.min(1, (dbm - SCALE_LOW) / (double) (SCALE_HIGH - SCALE_LOW)));
        int[] stops = { 0xFF3B5BFF, 0xFF19D3FF, 0xFF2BEA7A, 0xFFFFD84D, 0xFFFF5468 };
        double p = t * (stops.length - 1); int i = (int) Math.min(stops.length - 2, Math.floor(p)); double f = p - i;
        return mix(stops[i], stops[i + 1], f);
    }

    static int mix(int a, int b, double f) {
        int r = (int) Math.round(((a >> 16) & 0xFF) + (((b >> 16) & 0xFF) - ((a >> 16) & 0xFF)) * f);
        int g = (int) Math.round(((a >> 8) & 0xFF) + (((b >> 8) & 0xFF) - ((a >> 8) & 0xFF)) * f);
        int bl = (int) Math.round((a & 0xFF) + ((b & 0xFF) - (a & 0xFF)) * f);
        return 0xFF000000 | (r << 16) | (g << 8) | bl;
    }

    /** S-units for a reading (S9 = -93 dBm, 6 dB per S-unit; above S9 in 5 dB steps), for labels: "S7", "S9+5". */
    public static String sUnits(int dbm) {
        if (dbm >= -93) { int over = (int) Math.round((dbm + 93) / 5.0) * 5; return over <= 0 ? "S9" : "S9+" + over; }
        int s = 9 - (int) Math.ceil((-93 - dbm) / 6.0); return "S" + Math.max(0, s);
    }
}
