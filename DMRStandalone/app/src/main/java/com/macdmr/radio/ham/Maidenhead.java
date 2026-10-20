package com.macdmr.radio.ham;

import java.util.Locale;

/** Maidenhead grid locators (FN31pr) and great-circle distance and bearing between two points. */
public final class Maidenhead {
    private Maidenhead() { }

    /** The locator of a position, 4, 6 or 8 characters. */
    public static String grid(double lat, double lon, int chars) {
        double x = lon + 180, y = lat + 90;
        if (x >= 360) x -= 1e-9; if (y >= 180) y -= 1e-9; if (x < 0) x = 0; if (y < 0) y = 0;
        StringBuilder sb = new StringBuilder();
        sb.append((char) ('A' + (int) (x / 20))).append((char) ('A' + (int) (y / 10)));
        x %= 20; y %= 10;
        sb.append((char) ('0' + (int) (x / 2))).append((char) ('0' + (int) y));
        if (chars >= 6) { x %= 2; y %= 1; sb.append((char) ('a' + (int) (x * 12))).append((char) ('a' + (int) (y * 24))); }
        if (chars >= 8) { x %= 1.0 / 12; y %= 1.0 / 24; sb.append((char) ('0' + (int) (x * 120))).append((char) ('0' + (int) (y * 240))); }
        return sb.toString();
    }

    /** The centre of a 4- or 6-character locator as {lat, lon}, or null. */
    public static double[] centre(String g) {
        if (g == null) return null;
        String s = g.trim();
        if (s.length() < 4) return null;
        s = s.substring(0, 2).toUpperCase(Locale.US) + s.substring(2, 4) + (s.length() >= 6 ? s.substring(4, 6).toLowerCase(Locale.US) : "");
        char a = s.charAt(0), b = s.charAt(1), c = s.charAt(2), d = s.charAt(3);
        if (a < 'A' || a > 'R' || b < 'A' || b > 'R' || c < '0' || c > '9' || d < '0' || d > '9') return null;
        double lon = (a - 'A') * 20 + (c - '0') * 2 - 180, lat = (b - 'A') * 10 + (d - '0') - 90;
        if (s.length() >= 6) {
            char e = s.charAt(4), f = s.charAt(5);
            if (e < 'a' || e > 'x' || f < 'a' || f > 'x') return null;
            lon += (e - 'a') * (2.0 / 24) + 1.0 / 24; lat += (f - 'a') * (1.0 / 24) + 0.5 / 24;
        } else { lon += 1; lat += 0.5; }
        return new double[] { lat, lon };
    }

    /** Great-circle distance in km. */
    public static double km(double la1, double lo1, double la2, double lo2) {
        double p1 = Math.toRadians(la1), p2 = Math.toRadians(la2), dp = p2 - p1, dl = Math.toRadians(lo2 - lo1);
        double h = Math.sin(dp / 2) * Math.sin(dp / 2) + Math.cos(p1) * Math.cos(p2) * Math.sin(dl / 2) * Math.sin(dl / 2);
        return 2 * 6371.0 * Math.asin(Math.min(1, Math.sqrt(h)));
    }
    /** Initial bearing in degrees true from point 1 to point 2. */
    public static double bearing(double la1, double lo1, double la2, double lo2) {
        double p1 = Math.toRadians(la1), p2 = Math.toRadians(la2), dl = Math.toRadians(lo2 - lo1);
        double y = Math.sin(dl) * Math.cos(p2), x = Math.cos(p1) * Math.sin(p2) - Math.sin(p1) * Math.cos(p2) * Math.cos(dl);
        return (Math.toDegrees(Math.atan2(y, x)) + 360) % 360;
    }
    public static String compass(double deg) { String[] n = { "N", "NE", "E", "SE", "S", "SW", "W", "NW" }; return n[(int) Math.round(((deg % 360) + 360) % 360 / 45.0) % 8]; }
}
