/*
 * SignalDeck - Copyright (C) 2026 IIMacGyverII
 * SPDX-License-Identifier: GPL-3.0-or-later
 * Free software under the GNU General Public License v3 or later, with the additional terms in COPYRIGHT
 * (keep this notice and the author credit, mark modified versions, no rights to the SignalDeck name or icon).
 */
package com.macdmr.radio.pkt;

import java.util.Calendar;
import java.util.Locale;
import java.util.TimeZone;

/**
 * APRS formats beyond the plain position report (APRS 1.0.1 / 1.2): objects, telemetry with its PARM/UNIT/EQNS
 * definitions, a position weather report carrying air pressure, third-party frames for gating internet messages to
 * RF, and SmartBeaconing (beacon rate from speed, extra beacons on turns).
 */
public final class AprsExtras {
    private AprsExtras() { }

    /** Object report: {@code ;NAME_____*DDHHMMzDDMM.hhN/DDDMM.hhW$comment}; {@code live} false kills the object. */
    public static String objectInfo(String name, boolean live, double lat, double lon, char symTable, char symCode, String comment, long utcMs) {
        String n = name == null ? "" : name.trim(); if (n.length() > 9) n = n.substring(0, 9);
        StringBuilder sb = new StringBuilder(";").append(n);
        for (int i = n.length(); i < 9; i++) sb.append(' ');
        Calendar c = Calendar.getInstance(TimeZone.getTimeZone("UTC")); c.setTimeInMillis(utcMs);
        sb.append(live ? '*' : '_').append(String.format(Locale.US, "%02d%02d%02dz", c.get(Calendar.DAY_OF_MONTH), c.get(Calendar.HOUR_OF_DAY), c.get(Calendar.MINUTE)));
        String pos = Ax25.positionInfo(lat, lon, symTable, symCode, comment == null ? "" : comment);
        return sb.append(pos.substring(1)).toString();                     // the position without its '=' type character
    }

    /** Telemetry: {@code T#seq,v1,v2,v3,v4,v5,00000000}; values 0 to 255 (seq 0 to 999). */
    public static String telemetryInfo(int seq, int[] v) {
        StringBuilder sb = new StringBuilder(String.format(Locale.US, "T#%03d", ((seq % 1000) + 1000) % 1000));
        for (int i = 0; i < 5; i++) sb.append(',').append(String.format(Locale.US, "%03d", Math.max(0, Math.min(255, i < v.length ? v[i] : 0))));
        return sb.append(",00000000").toString();
    }

    /** The definitions sent as messages to yourself: names, units and scaling (value = a·x² + b·x + c). */
    public static final String PARM = "PARM.Battery,Volts,Temp,Pressure,Signal";
    public static final String UNIT = "UNIT.%,V,C,hPa,dBm";
    public static final String EQNS = "EQNS.0,1,0,0,0.01,3,0,1,-40,0,1,900,0,1,-140";

    /** Raw telemetry values for {@link #EQNS}: battery %, volts, °C, sea-level hPa, dBm. */
    public static int[] telemetryValues(int batteryPct, double volts, double tempC, double hpa, int dbm) {
        return new int[] { batteryPct, (int) Math.round((volts - 3) * 100), (int) Math.round(tempC + 40), hpa > 0 ? (int) Math.round(hpa - 900) : 0, dbm == -999 ? 0 : dbm + 140 };
    }

    /** Position weather report with only the air pressure known: {@code =lat/lon_.../...g...t...bXXXXX comment}. */
    public static String weatherInfo(double lat, double lon, double seaLevelHpa, String comment) {
        String wx = ".../...g...t..." + String.format(Locale.US, "b%05d", Math.max(0, Math.min(99999, Math.round(seaLevelHpa * 10))));
        return Ax25.positionInfo(lat, lon, '/', '_', wx + (comment == null || comment.isEmpty() ? "" : comment));
    }

    /** Station pressure to sea level (barometric formula, standard atmosphere). */
    public static double seaLevel(double hpa, double altitudeM) { return hpa / Math.pow(1 - altitudeM / 44330.0, 5.255); }

    /**
     * An internet line wrapped for RF as a third-party frame (APRS 1.0.1 ch. 17):
     * {@code }SRC>DST,TCPIP,MYCALL*:info}, or null for a malformed line.
     */
    public static String thirdParty(String tnc2, String myCall) {
        if (tnc2 == null) return null;
        int gt = tnc2.indexOf('>'), colon = tnc2.indexOf(':', gt);
        if (gt <= 0 || colon < 0) return null;
        String src = tnc2.substring(0, gt), dst = tnc2.substring(gt + 1, colon).split(",")[0];
        return "}" + src + ">" + dst + ",TCPIP," + myCall + "*" + tnc2.substring(colon);
    }

    /**
     * SmartBeaconing (HamHUD): slower than {@code slowMph} beacon every {@code slowRateS}; faster, every
     * {@code fastRateS * fastMph / speed}, at least every {@code fastRateS}; and once more on a turn sharper than
     * {@code turnMinDeg + turnSlope / speed}, no sooner than {@code minTurnS} after the last beacon.
     */
    public static final class SmartBeacon {
        public int slowMph = 5, fastMph = 60, slowRateS = 1800, fastRateS = 180, turnMinDeg = 28, turnSlope = 26, minTurnS = 30;
        private long lastMs; private double lastHeading = Double.NaN;

        public long lastBeaconMs() { return lastMs; }
        /** Seconds between beacons at this speed. */
        public int rate(double mph) {
            if (mph < slowMph) return slowRateS;
            if (mph >= fastMph) return fastRateS;
            return (int) Math.min(slowRateS, Math.round(fastRateS * (double) fastMph / mph));
        }
        /** True when a beacon is due now (and records it). {@code heading} NaN when unknown. */
        public boolean due(long now, double mph, double heading) {
            if (lastMs == 0) { mark(now, heading); return true; }
            long since = (now - lastMs) / 1000;
            if (since >= rate(mph)) { mark(now, heading); return true; }
            if (mph >= slowMph && !Double.isNaN(heading) && !Double.isNaN(lastHeading) && since >= minTurnS) {
                double turn = Math.abs(((heading - lastHeading) % 360 + 540) % 360 - 180);
                if (turn > turnMinDeg + turnSlope / mph) { mark(now, heading); return true; }
            }
            return false;
        }
        private void mark(long now, double heading) { lastMs = now; lastHeading = heading; }
    }
}
