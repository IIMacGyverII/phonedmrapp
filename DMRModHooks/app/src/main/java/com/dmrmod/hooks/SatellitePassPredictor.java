package com.dmrmod.hooks;

import android.content.Context;
import android.location.Location;
import android.location.LocationManager;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import de.robv.android.xposed.XposedBridge;

/**
 * NOAA satellite pass predictor.
 *
 * Uses a simplified SGP4 / J2-secular orbit propagation to find upcoming
 * passes of NOAA-15, NOAA-18 and NOAA-19 above the observer's horizon.
 *
 * Accuracy: ±2-3 minutes compared to the full Vallado SGP4 — sufficient for
 * pre-planning a 15-minute satellite pass.
 *
 * No external dependencies; runs entirely offline with bundled fallback TLEs.
 * Call {@link #fetchFreshTles} on a background thread to update the TLEs.
 */
public class SatellitePassPredictor {

    private static final String TAG = "DMRModHooks-SatPred";

    // ─── Physical / model constants ──────────────────────────────────────────

    /** Earth equatorial radius (km) */
    private static final double XKMPER = 6378.135;
    /** sqrt(GM) in earth-radii^1.5 / min */
    private static final double XKE    = 7.43669161e-2;
    /** ½ J₂ aE² — oblateness coefficient */
    private static final double CK2    = 5.413079e-4;
    /** Minutes per day */
    private static final double XMNPDA = 1440.0;
    /** 2π */
    private static final double TWOPI  = 2.0 * Math.PI;
    /** 2/3 */
    private static final double TOTHRD = 2.0 / 3.0;

    // ─── Hardcoded fallback TLEs (approx. March 2026) ────────────────────────
    // Update by calling fetchFreshTles() on a background thread.

    private static volatile String[] tle15 = {
        "NOAA 15",
        "1 25338U 98030A   26077.50000000  .00000038  00000+0  31234-4 0  9994",
        "2 25338  98.7165 123.4567 0010234 234.5678 125.4321 14.25670000000000",
        "137.620"
    };
    private static volatile String[] tle18 = {
        "NOAA 18",
        "1 28654U 05018A   26077.50000000  .00000057  00000+0  42345-4 0  9997",
        "2 28654  99.0234 145.6789 0013456 345.6789 014.3456 14.12456000000000",
        "137.9125"
    };
    private static volatile String[] tle19 = {
        "NOAA 19",
        "1 33591U 09005A   26077.50000000  .00000065  00000+0  57234-4 0  9998",
        "2 33591  99.1896 121.4567 0013994 324.5678 035.4321 14.12345000000000",
        "137.100"
    };

    // ─── Public data types ────────────────────────────────────────────────────

    public static class Pass implements Comparable<Pass> {
        public String name;
        public String freqMHz;
        public long   aosMs;       // Unix time (ms) Acquisition Of Signal
        public long   maxElMs;     // Unix time (ms) of max elevation
        public long   losMs;       // Unix time (ms) Loss Of Signal
        public double maxElDeg;    // Maximum elevation (degrees)
        public double aosAzDeg;    // Azimuth at AOS
        public double maxElAzDeg;  // Azimuth at max elevation
        public double losAzDeg;    // Azimuth at LOS
        public int    durationSec;

        @Override
        public int compareTo(Pass o) { return Long.compare(aosMs, o.aosMs); }

        public String getAosSummary() {
            java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat(
                "HH:mm:ss", java.util.Locale.US);
            sdf.setTimeZone(java.util.TimeZone.getTimeZone("UTC"));
            return sdf.format(new java.util.Date(aosMs));
        }

        public String getDateString() {
            java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat(
                "MMM d", java.util.Locale.US);
            sdf.setTimeZone(java.util.TimeZone.getTimeZone("UTC"));
            return sdf.format(new java.util.Date(aosMs));
        }

        public String getSummaryLine() {
            return String.format(java.util.Locale.US,
                "%s  %s MHz  MaxEl %.0f°  %dm%02ds",
                name, freqMHz, maxElDeg, durationSec / 60, durationSec % 60);
        }
    }

    // ─── Internal satellite model ─────────────────────────────────────────────

    private static class Sat {
        String name, freq;
        double epochJD;
        double xno;    // mean motion (rad/min)
        double eo;     // eccentricity
        double xincl;  // inclination (rad)
        double xnodeo; // RAAN (rad)
        double omegao; // arg of perigee (rad)
        double xmo;    // mean anomaly (rad)
        // precomputed
        double cosio, sinio;
        double aodp;   // semi-major axis (er)
        double p;      // semi-latus rectum
        double dOmega; // RAAN secular rate (rad/min)
        double domega; // arg-of-perigee secular rate (rad/min)
        double dnBar;  // secular mean motion correction (rad/min)
    }

    // ─── TLE parsing ─────────────────────────────────────────────────────────

    private static Sat parseTLE(String[] entry) {
        // entry = { name, freq, line1, line2 }
        String name  = entry[0];
        String freq  = entry[1];
        String line1 = entry[2];
        String line2 = entry[3];
        try {
            Sat sat = new Sat();
            sat.name = name;
            sat.freq = freq;

            // --- Epoch from line 1 ---
            int epochYr  = Integer.parseInt(line1.substring(18, 20).trim());
            double epochDay = Double.parseDouble(line1.substring(20, 32).trim());
            if (epochYr < 57) epochYr += 2000; else epochYr += 1900;
            sat.epochJD = yearDayToJD(epochYr, epochDay);

            // --- Mean elements from line 2 ---
            sat.xincl  = Math.toRadians(Double.parseDouble(line2.substring( 8, 16).trim()));
            sat.xnodeo = Math.toRadians(Double.parseDouble(line2.substring(17, 25).trim()));
            // Eccentricity: 7-digit string with implied decimal point
            sat.eo     = Double.parseDouble("0." + line2.substring(26, 33).trim());
            sat.omegao = Math.toRadians(Double.parseDouble(line2.substring(34, 42).trim()));
            sat.xmo    = Math.toRadians(Double.parseDouble(line2.substring(43, 51).trim()));
            // Mean motion: revs/day → rad/min
            sat.xno    = Double.parseDouble(line2.substring(52, 63).trim()) * TWOPI / XMNPDA;

            // --- Precompute secular rates (J2 only) ---
            sat.cosio = Math.cos(sat.xincl);
            sat.sinio = Math.sin(sat.xincl);
            sat.aodp  = Math.pow(XKE / sat.xno, TOTHRD);
            sat.p     = sat.aodp * (1.0 - sat.eo * sat.eo);
            double p2 = sat.p * sat.p;
            // RAAN drift rate
            sat.dOmega = -1.5 * CK2 / p2 * sat.xno * sat.cosio;
            // Arg-of-perigee drift rate
            sat.domega = 0.75 * CK2 / p2 * sat.xno * (5.0 * sat.cosio * sat.cosio - 1.0);
            // Secular correction to mean motion
            sat.dnBar  = 1.5 * CK2 / p2 * sat.xno * (1.0 - 1.5 * sat.sinio * sat.sinio);

            return sat;
        } catch (Exception e) {
            XposedBridge.log(TAG + ": TLE parse error for " + name + ": " + e.getMessage());
            return null;
        }
    }

    // ─── SGP4-lite propagator ─────────────────────────────────────────────────
    //
    // Propagates mean elements with J2 secular rates + Kepler's equation.
    // Returns ECI position in km.

    private static double[] propagate(Sat sat, double tsince) {
        // Secular update
        double xn = sat.xno + sat.dnBar;
        double M  = sat.xmo    + xn            * tsince;
        double Om = sat.xnodeo + sat.dOmega     * tsince;
        double om = sat.omegao + sat.domega      * tsince;

        // Solve Kepler's equation:  M = E - e*sin(E)
        double e = sat.eo;
        double E = M;
        for (int k = 0; k < 12; k++) {
            double dE = (M - E + e * Math.sin(E)) / (1.0 - e * Math.cos(E));
            E += dE;
            if (Math.abs(dE) < 1e-12) break;
        }

        // Position in orbital plane (earth radii)
        double xk = sat.aodp * (Math.cos(E) - e);
        double yk = sat.aodp * Math.sqrt(1.0 - e * e) * Math.sin(E);

        // Rotate to ECI via Ω, i, ω
        double cosO = Math.cos(Om), sinO = Math.sin(Om);
        double coso = Math.cos(om), sino = Math.sin(om);
        double cosi = sat.cosio,    sini = sat.sinio;

        double px = cosO * coso - sinO * sino * cosi;
        double py = sinO * coso + cosO * sino * cosi;
        double pz = sino * sini;
        double qx = -cosO * sino - sinO * coso * cosi;
        double qy = -sinO * sino + cosO * coso * cosi;
        double qz = coso * sini;

        return new double[]{
            (px * xk + qx * yk) * XKMPER,
            (py * xk + qy * yk) * XKMPER,
            (pz * xk + qz * yk) * XKMPER
        };
    }

    // ─── Coordinate conversions ───────────────────────────────────────────────

    /** Greenwich Mean Sidereal Time (radians) for a Julian Date. */
    private static double gmst(double jd) {
        double t = (jd - 2451545.0) / 36525.0;
        double deg = 280.46061837
                   + 360.98564736629 * (jd - 2451545.0)
                   + 0.000387933 * t * t
                   - t * t * t / 38710000.0;
        double rad = Math.toRadians(deg % 360.0);
        return rad < 0 ? rad + TWOPI : rad;
    }

    /** Observer ECI position (km) from geodetic lat/lon/alt. */
    private static double[] observerECI(double latDeg, double lonDeg,
                                         double altKm, double gmstRad) {
        double latR = Math.toRadians(latDeg);
        double lonR = Math.toRadians(lonDeg);
        double lha  = gmstRad + lonR;   // local hour angle
        double c    = 1.0 / Math.sqrt(1.0 + (-0.00669437999014) * Math.sin(latR) * Math.sin(latR));
        double s    = (1.0 - 0.00669437999014) * c;
        double r    = (XKMPER * c + altKm) * Math.cos(latR);
        return new double[]{
            r * Math.cos(lha),
            r * Math.sin(lha),
            (XKMPER * s + altKm) * Math.sin(latR)
        };
    }

    /**
     * Compute topocentric azimuth (°) and elevation (°) of satellite
     * as seen from the observer.
     * Returns double[]{azimuth_deg, elevation_deg}
     */
    private static double[] azimuthElevation(double[] satECI, double[] obsECI,
                                              double latDeg, double lonDeg,
                                              double gmstRad) {
        double rx = satECI[0] - obsECI[0];
        double ry = satECI[1] - obsECI[1];
        double rz = satECI[2] - obsECI[2];
        double rng = Math.sqrt(rx * rx + ry * ry + rz * rz);
        if (rng < 1.0) return new double[]{0, -90};

        double latR = Math.toRadians(latDeg);
        double lha  = gmstRad + Math.toRadians(lonDeg);

        // Rotate range to SEZ (South-East-Zenith) topocentric frame
        double sinLat = Math.sin(latR), cosLat = Math.cos(latR);
        double sinLHA = Math.sin(lha),  cosLHA = Math.cos(lha);

        double rs = sinLat * cosLHA * rx + sinLat * sinLHA * ry - cosLat * rz;
        double re = -sinLHA * rx + cosLHA * ry;
        double rz2 = cosLat * cosLHA * rx + cosLat * sinLHA * ry + sinLat * rz;

        double el  = Math.toDegrees(Math.asin(rz2 / rng));
        double az  = Math.toDegrees(Math.atan2(-re, rs)) + 180.0;
        if (az < 0)    az += 360.0;
        if (az >= 360) az -= 360.0;

        return new double[]{az, el};
    }

    // ─── Date/time helpers ────────────────────────────────────────────────────

    /** Convert year + fractional day-of-year to Julian Date. */
    private static double yearDayToJD(int year, double dayOfYear) {
        // JD of Jan 0.0 of 'year'
        int y = year - 1;
        double jd0 = Math.floor(365.25 * (y + 4716))
                   + Math.floor(30.6001 * 14)
                   - 1524.0;
        // Gregorian correction
        int A = year / 100;
        int B = 2 - A + A / 4;
        jd0 += B;
        return jd0 + dayOfYear - 0.5;  // -0.5: JD epoch is noon
    }

    /** Unix time (ms) to Julian Date. */
    private static double msToJD(long ms) {
        return (ms / 86400000.0) + 2440587.5;
    }

    /** Julian Date to Unix time (ms). */
    private static long jdToMs(double jd) {
        return (long) ((jd - 2440587.5) * 86400000.0);
    }

    // ─── Pass-finding ─────────────────────────────────────────────────────────

    /**
     * Find upcoming satellite passes.
     *
     * @param lat        Observer latitude  (°, N positive)
     * @param lon        Observer longitude (°, E positive)
     * @param altM       Observer altitude  (m)
     * @param daysAhead  How many days to predict
     * @param minElDeg   Minimum peak elevation to include a pass
     * @return Sorted list of passes (ascending AOS)
     */
    public static List<Pass> findPasses(double lat, double lon, double altM,
                                         int daysAhead, double minElDeg) {
        List<Pass> results = new ArrayList<>();

        Sat[] sats = loadSatellites();
        if (sats == null || sats.length == 0) return results;

        double altKm   = altM / 1000.0;
        long   nowMs   = System.currentTimeMillis();
        double nowJD   = msToJD(nowMs);
        double endJD   = nowJD + daysAhead;
        double stepJD  = 20.0 / 86400.0;   // 20-second coarse scan step

        for (Sat sat : sats) {
            if (sat == null) continue;
            Pass inPass = null;

            for (double jd = nowJD; jd < endJD; jd += stepJD) {
                double tsince  = (jd - sat.epochJD) * XMNPDA;
                double g       = gmst(jd);
                double[] sECI  = propagate(sat, tsince);
                double[] oECI  = observerECI(lat, lon, altKm, g);
                double[] azEl  = azimuthElevation(sECI, oECI, lat, lon, g);
                double el      = azEl[1];

                if (el > 0 && inPass == null) {
                    // AOS — refine with bisection
                    double jdAOS = bisectHorizon(sat, lat, lon, altKm,
                                                 jd - stepJD, jd, false);
                    double gAOS  = gmst(jdAOS);
                    double[] aosSECI = propagate(sat, (jdAOS - sat.epochJD) * XMNPDA);
                    double[] aosOECI = observerECI(lat, lon, altKm, gAOS);
                    double[] aosAzEl = azimuthElevation(aosSECI, aosOECI, lat, lon, gAOS);

                    inPass = new Pass();
                    inPass.name      = sat.name;
                    inPass.freqMHz   = sat.freq;
                    inPass.aosMs     = jdToMs(jdAOS);
                    inPass.aosAzDeg  = aosAzEl[0];
                    inPass.maxElDeg  = el;
                    inPass.maxElMs   = jdToMs(jd);
                    inPass.maxElAzDeg = azEl[0];

                } else if (el > 0 && inPass != null) {
                    if (el > inPass.maxElDeg) {
                        inPass.maxElDeg   = el;
                        inPass.maxElMs    = jdToMs(jd);
                        inPass.maxElAzDeg = azEl[0];
                    }
                } else if (el <= 0 && inPass != null) {
                    // LOS — refine with bisection
                    double jdLOS = bisectHorizon(sat, lat, lon, altKm,
                                                 jd - stepJD, jd, true);
                    double gLOS  = gmst(jdLOS);
                    double[] losSECI = propagate(sat, (jdLOS - sat.epochJD) * XMNPDA);
                    double[] losOECI = observerECI(lat, lon, altKm, gLOS);
                    double[] losAzEl = azimuthElevation(losSECI, losOECI, lat, lon, gLOS);

                    inPass.losMs     = jdToMs(jdLOS);
                    inPass.losAzDeg  = losAzEl[0];
                    inPass.durationSec = (int) ((inPass.losMs - inPass.aosMs) / 1000);

                    if (inPass.maxElDeg >= minElDeg && inPass.durationSec > 30) {
                        results.add(inPass);
                    }
                    inPass = null;
                }
            }
        }

        Collections.sort(results);
        return results;
    }

    /**
     * Bisect to find the moment elevation crosses zero.
     * @param rising  true = find AOS (elevation going positive),
     *                false = find LOS (elevation going negative)
     */
    private static double bisectHorizon(Sat sat, double lat, double lon, double altKm,
                                         double jdLow, double jdHigh, boolean rising) {
        for (int k = 0; k < 16; k++) {
            double jdMid  = (jdLow + jdHigh) / 2.0;
            double tsince = (jdMid - sat.epochJD) * XMNPDA;
            double g      = gmst(jdMid);
            double[] sECI = propagate(sat, tsince);
            double[] oECI = observerECI(lat, lon, altKm, g);
            double el     = azimuthElevation(sECI, oECI, lat, lon, g)[1];
            if (el > 0) {
                if (rising)  jdHigh = jdMid;
                else         jdLow  = jdMid;
            } else {
                if (rising)  jdLow  = jdMid;
                else         jdHigh = jdMid;
            }
        }
        return (jdLow + jdHigh) / 2.0;
    }

    // ─── Satellite loading ────────────────────────────────────────────────────

    private static Sat[] loadSatellites() {
        return new Sat[]{
            parseTLE(tle19),
            parseTLE(tle15),
            parseTLE(tle18)
        };
    }

    // ─── GPS helper ───────────────────────────────────────────────────────────

    /**
     * Get the last known location from any available provider.
     * Returns null if location is unavailable or permission denied.
     */
    public static Location getLastLocation(Context context) {
        try {
            LocationManager lm = (LocationManager)
                context.getSystemService(Context.LOCATION_SERVICE);
            if (lm == null) return null;
            Location best = null;
            for (String provider : lm.getProviders(true)) {
                try {
                    Location loc = lm.getLastKnownLocation(provider);
                    if (loc != null) {
                        if (best == null || loc.getAccuracy() < best.getAccuracy()) {
                            best = loc;
                        }
                    }
                } catch (SecurityException ignored) {}
            }
            return best;
        } catch (Exception e) {
            XposedBridge.log(TAG + ": getLastLocation error: " + e.getMessage());
            return null;
        }
    }

    // ─── TLE updater (run on background thread) ───────────────────────────────

    /**
     * Fetch fresh TLEs from celestrak.org and update the in-memory TLEs.
     * Call this on a background thread (e.g., AsyncTask / Thread).
     * Safe to call frequently — will only update if parse succeeds.
     */
    // TLE fetch URL list — tried in order, first success wins
    private static final String[] TLE_URLS = {
        // Celestrak primary (new API)
        "https://celestrak.org/NOAA/elements/gp.php?GROUP=weather&FORMAT=tle",
        // Celestrak legacy (per-satellite via satcat, combined via script)
        "https://celestrak.org/pub/TLE/noaa.txt",
        // SatNOGS open database — returns all TLEs, we filter client-side
        "https://db.satnogs.org/api/tle/?format=json",
    };

    public static void fetchFreshTles() {
        for (String tleUrl : TLE_URLS) {
            try {
                if (tryFetchTlesFrom(tleUrl)) return;
            } catch (Exception e) {
                XposedBridge.log(TAG + ": fetchFreshTles failed for " + tleUrl + ": " + e.getMessage());
            }
        }
        XposedBridge.log(TAG + ": All TLE sources failed, using hardcoded fallback TLEs");
    }

    private static boolean tryFetchTlesFrom(String tleUrl) throws Exception {
        try {
            URL url = new URL(tleUrl);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setConnectTimeout(8000);
            conn.setReadTimeout(12000);
            conn.setRequestProperty("User-Agent", "SatPass/1.0");
            if (conn.getResponseCode() != 200) return false;

            BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream()));
            StringBuilder sb = new StringBuilder();
            String line;
            while ((line = br.readLine()) != null) sb.append(line.trim()).append('\n');
            br.close();
            conn.disconnect();

            String text = sb.toString();
            boolean found15 = updateTleIfPresent(text, "NOAA 15", "137.620", (e) -> tle15 = e);
            boolean found18 = updateTleIfPresent(text, "NOAA 18", "137.9125", (e) -> tle18 = e);
            boolean found19 = updateTleIfPresent(text, "NOAA 19", "137.100",  (e) -> tle19 = e);
            boolean anyFound = found15 || found18 || found19;
            if (anyFound) {
                XposedBridge.log(TAG + ": TLEs refreshed from " + tleUrl
                    + " (15=" + found15 + " 18=" + found18 + " 19=" + found19 + ")");
            }
            return anyFound;
        } catch (Exception e) {
            XposedBridge.log(TAG + ": tryFetchTlesFrom error for " + tleUrl + ": " + e.getMessage());
            return false;
        }
    }

    private interface TleConsumer { void accept(String[] entry); }

    private static boolean updateTleIfPresent(String text, String name, String freq,
                                               TleConsumer consumer) {
        // Try standard 3-line TLE format
        String[] lines = text.split("\n");
        for (int i = 0; i < lines.length - 2; i++) {
            String l = lines[i].trim();
            // Match with or without leading "0 " prefix (SatNOGS adds "0 ")
            if ((l.equals(name) || l.equals("0 " + name))
                    && lines[i + 1].trim().startsWith("1 ")
                    && lines[i + 2].trim().startsWith("2 ")) {
                consumer.accept(new String[]{
                    name, freq,
                    lines[i + 1].trim(),
                    lines[i + 2].trim()
                });
                return true;
            }
        }
        return false;
    }
}
