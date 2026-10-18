package com.macdmr.radio.repeaters;

import java.util.Locale;

/**
 * Pure geographic helpers for the Nearby Repeaters feature (backlog E7, chapter 16 §4 / P0.3).
 *
 * <p>No Android imports, so every method is exercised by plain JUnit on the host
 * ({@code GeoUtilTest}). {@link MainHook}'s former private copies of the distance/bearing/arrow
 * helpers delegate here so the intercom location chip and this feature share one implementation.
 *
 * <p>Nothing here transmits, reads hardware or touches a database.
 */
public final class GeoUtil {

    private GeoUtil() { }

    private static final double EARTH_RADIUS_M = 6371000.0;

    /** Great-circle distance in metres between two WGS-84 points (haversine). */
    public static double haversineMeters(double lat1, double lon1, double lat2, double lon2) {
        double lat1Rad = Math.toRadians(lat1);
        double lat2Rad = Math.toRadians(lat2);
        double dLat = Math.toRadians(lat2 - lat1);
        double dLon = Math.toRadians(lon2 - lon1);
        double a = Math.sin(dLat / 2) * Math.sin(dLat / 2)
                 + Math.cos(lat1Rad) * Math.cos(lat2Rad) * Math.sin(dLon / 2) * Math.sin(dLon / 2);
        double c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
        return EARTH_RADIUS_M * c;
    }

    /** Initial bearing from point 1 to point 2, degrees 0–360 (0 = north, clockwise). */
    public static double bearingDegrees(double lat1, double lon1, double lat2, double lon2) {
        double lat1Rad = Math.toRadians(lat1);
        double lat2Rad = Math.toRadians(lat2);
        double dLon = Math.toRadians(lon2 - lon1);
        double y = Math.sin(dLon) * Math.cos(lat2Rad);
        double x = Math.cos(lat1Rad) * Math.sin(lat2Rad)
                 - Math.sin(lat1Rad) * Math.cos(lat2Rad) * Math.cos(dLon);
        double bearing = Math.toDegrees(Math.atan2(y, x));
        return (bearing + 360) % 360;
    }

    /** 8-point compass arrow + letters for a bearing, e.g. {@code "↗NE"}. */
    public static String directionArrow(double bearing) {
        double b = ((bearing % 360) + 360) % 360;
        if (b >= 337.5 || b < 22.5)  return "↑N";
        if (b < 67.5)  return "↗NE";
        if (b < 112.5) return "→E";
        if (b < 157.5) return "↘SE";
        if (b < 202.5) return "↓S";
        if (b < 247.5) return "↙SW";
        if (b < 292.5) return "←W";
        return "↖NW";
    }

    /** Distance only, metric under 10 km then miles, matching the intercom chip's old format. */
    public static String formatDistance(double meters) {
        if (meters < 1000)  return String.format(Locale.US, "%.0fm", meters);
        if (meters < 10000) return String.format(Locale.US, "%.1fkm", meters / 1000);
        return String.format(Locale.US, "%.1fmi", meters * 0.000621371);
    }

    /** Distance with a leading direction arrow, e.g. {@code "↘SE 380.6mi (612.5km)"}. */
    public static String formatDistanceWithArrow(double fromLat, double fromLon, double toLat, double toLon) {
        double meters = haversineMeters(fromLat, fromLon, toLat, toLon);
        String arrow = directionArrow(bearingDegrees(fromLat, fromLon, toLat, toLon));
        if (meters < 1000)  return String.format(Locale.US, "%s %.0fm", arrow, meters);
        if (meters < 10000) return String.format(Locale.US, "%s %.1fkm", arrow, meters / 1000);
        return String.format(Locale.US, "%s %.1fmi (%.1fkm)", arrow, meters * 0.000621371, meters / 1000);
    }

    // ---------------------------------------------------------------- band classification

    public static final int BAND_VHF = 0;   // 136–174 MHz
    public static final int BAND_UHF = 1;   // 400–480 MHz
    public static final int BAND_OTHER = 2; // outside the radio's two windows

    /** Classify an RF frequency (Hz) into the radio's bands. The OEM editor only accepts VHF/UHF. */
    public static int band(long freqHz) {
        if (freqHz >= 136000000L && freqHz <= 174000000L) return BAND_VHF;
        if (freqHz >= 400000000L && freqHz <= 480000000L) return BAND_UHF;
        return BAND_OTHER;
    }

    /** True if the frequency is one the radio can actually be tuned to (VHF or UHF window). */
    public static boolean inRadioRange(long freqHz) {
        return band(freqHz) != BAND_OTHER;
    }

    /** MHz (as a double, e.g. 439.7125) to integer Hz, the OEM {@code ChannelData} unit. */
    public static long mhzToHz(double mhz) {
        return Math.round(mhz * 1_000_000.0);
    }

    // ---------------------------------------------------------------- Maidenhead locator

    /**
     * Maidenhead grid locator to the latitude/longitude of the centre of that square.
     * Accepts 2, 4 or 6 characters (field, square, subsquare). Returns {lat, lon} or null if
     * the string is not a valid locator.
     */
    public static double[] maidenheadToLatLon(String grid) {
        if (grid == null) return null;
        String g = grid.trim().toUpperCase(Locale.US);
        int n = g.length();
        if (n != 2 && n != 4 && n != 6) return null;
        for (int i = 0; i < n; i++) {
            char c = g.charAt(i);
            boolean ok;
            if (i < 2)      ok = c >= 'A' && c <= 'R';
            else if (i < 4) ok = c >= '0' && c <= '9';
            else            ok = c >= 'A' && c <= 'X';
            if (!ok) return null;
        }
        double lon = (g.charAt(0) - 'A') * 20.0 - 180.0;
        double lat = (g.charAt(1) - 'A') * 10.0 - 90.0;
        double lonSize = 20.0, latSize = 10.0;
        if (n >= 4) {
            lon += (g.charAt(2) - '0') * 2.0;
            lat += (g.charAt(3) - '0') * 1.0;
            lonSize = 2.0; latSize = 1.0;
        }
        if (n >= 6) {
            lon += (g.charAt(4) - 'A') * (2.0 / 24.0);
            lat += (g.charAt(5) - 'A') * (1.0 / 24.0);
            lonSize = 2.0 / 24.0; latSize = 1.0 / 24.0;
        }
        // centre of the square
        lon += lonSize / 2.0;
        lat += latSize / 2.0;
        return new double[]{lat, lon};
    }

    /** Latitude/longitude to a 6-character Maidenhead locator. */
    public static String latLonToMaidenhead(double lat, double lon) {
        double adjLon = lon + 180.0;
        double adjLat = lat + 90.0;
        if (adjLon < 0) adjLon = 0; if (adjLon >= 360) adjLon = 359.999999;
        if (adjLat < 0) adjLat = 0; if (adjLat >= 180) adjLat = 179.999999;
        StringBuilder sb = new StringBuilder(6);
        sb.append((char) ('A' + (int) (adjLon / 20)));
        sb.append((char) ('A' + (int) (adjLat / 10)));
        sb.append((char) ('0' + (int) ((adjLon % 20) / 2)));
        sb.append((char) ('0' + (int) ((adjLat % 10) / 1)));
        sb.append((char) ('A' + (int) ((adjLon % 2) / (2.0 / 24.0))));
        sb.append((char) ('A' + (int) ((adjLat % 1) / (1.0 / 24.0))));
        return sb.toString();
    }

    /**
     * Extract a Maidenhead locator embedded in free text (BrandMeister {@code city} like
     * {@code "Banff, IO87QP"} or RadioID {@code map_info}). Returns the first 4- or 6-character
     * token that is a valid locator, else null.
     */
    public static String findLocator(String text) {
        if (text == null) return null;
        for (String tokRaw : text.split("[^A-Za-z0-9]+")) {
            String tok = tokRaw.trim();
            if ((tok.length() == 4 || tok.length() == 6) && maidenheadToLatLon(tok) != null) {
                return tok.toUpperCase(Locale.US);
            }
        }
        return null;
    }
}
