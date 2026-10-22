/*
 * SignalDeck - Copyright (C) 2026 IIMacGyverII
 * SPDX-License-Identifier: GPL-3.0-or-later
 * Free software under the GNU General Public License v3 or later, with the additional terms in COPYRIGHT
 * (keep this notice and the author credit, mark modified versions, no rights to the SignalDeck name or icon).
 */
package com.macdmr.radio.ham;

import java.util.Locale;

/**
 * What a frequency is for, within the radio's 136–174 and 400–480 MHz: the US amateur band plans for 2 m and 70 cm
 * (ARRL, typical; local coordination varies) and the other services in range, with a caution where transmitting
 * needs another licence, is not allowed, or would disturb a special use (satellites, weak signal, beacons).
 */
public final class BandPlan {
    private BandPlan() { }

    public static final class Info {
        public final String use; public final String caution; public final boolean amateur;
        Info(String use, String caution, boolean amateur) { this.use = use; this.caution = caution; this.amateur = amateur; }
        public String text() { return caution == null ? use : use + ". " + caution; }
    }

    private static final String HAM = "Amateur licence needed to transmit";

    private static Info ham(String use) { return new Info(use, null, true); }
    private static Info hamCare(String use, String caution) { return new Info(use, caution, true); }
    private static Info other(String use, String caution) { return new Info(use, caution, false); }

    /** Use of {@code hz}, or null outside the radio's range. */
    public static Info of(long hz) {
        double m = hz / 1e6;
        // ---- 2 m amateur band ----
        if (m >= 144 && m < 148) {
            if (m < 144.10) return hamCare("2 m CW and moonbounce (EME)", "No FM here");
            if (m < 144.275) return hamCare("2 m weak-signal SSB (144.200 calling)", "No FM here");
            if (m < 144.30) return hamCare("2 m beacons", "Do not transmit");
            if (Math.abs(m - 144.39) < 0.0051) return ham("APRS, the North American packet frequency");
            if (m < 144.50) return hamCare("2 m new satellite and miscellaneous", "Keep FM off it");
            if (m < 144.60) return hamCare("2 m linear translator inputs", "For satellites and translators, not FM");
            if (m < 144.90) return ham("2 m FM repeater inputs");
            if (m < 145.10) return ham(m >= 145.01 && m <= 145.09 ? "2 m packet" : "2 m weak signal and FM simplex");
            if (m < 145.20) return hamCare("2 m linear translator outputs", "Not for FM");
            if (m < 145.50) return ham("2 m FM repeater outputs");
            if (m < 145.80) return ham("2 m miscellaneous and experimental");
            if (m < 146.00) return hamCare(Math.abs(m - 145.80) < 0.0051 ? "ISS voice downlink" : Math.abs(m - 145.825) < 0.0051 ? "Satellite APRS (the ISS moved to 437.825)" : Math.abs(m - 145.99) < 0.0051 ? "ISS repeater uplink" : "2 m satellite subband", "For satellites only: no terrestrial FM");
            if (m < 146.40) return ham("2 m FM repeater inputs");
            if (m < 146.60) return ham(Math.abs(m - 146.52) < 0.0051 ? "2 m national FM simplex calling" : "2 m FM simplex");
            if (m < 147.00) return ham("2 m FM repeater outputs");
            if (m < 147.40) return ham("2 m FM repeater outputs (positive offset)");
            if (m < 147.60) return ham("2 m FM simplex");
            return ham("2 m FM repeater inputs");
        }
        // ---- 70 cm amateur band ----
        if (m >= 420 && m < 450) {
            if (m < 432) return ham("70 cm amateur television and links");
            if (m < 432.07) return hamCare("70 cm moonbounce (EME)", "No FM here");
            if (m < 432.30) return hamCare("70 cm weak-signal CW and SSB (432.100 calling)", "No FM here");
            if (m < 433) return hamCare("70 cm weak signal and beacons", "No FM here");
            if (m < 435) return ham("70 cm auxiliary and repeater links");
            if (m < 438) return hamCare(Math.abs(m - 437.825) < 0.0151 ? "ISS APRS digipeater" : Math.abs(m - 437.55) < 0.0151 ? "ISS SSTV downlink" : Math.abs(m - 437.80) < 0.0101 ? "ISS repeater downlink" : "70 cm satellite subband", "For satellites only: no terrestrial FM");
            if (m < 442) return ham("70 cm amateur television, repeaters and links (local plans vary)");
            if (m < 445) return ham("70 cm FM repeaters (local plans vary)");
            if (m < 447) return ham(Math.abs(m - 446.0) < 0.0051 ? "70 cm national FM simplex calling" : "70 cm FM simplex and links");
            return ham("70 cm FM repeaters (local plans vary)");
        }
        // ---- other services ----
        if (m >= 136 && m < 137) return other("Space operations and aviation", "Receive only");
        if (m >= 137 && m < 138) return other("Weather and other satellites downlinks", "Receive only");
        if (m >= 138 && m < 144) return other("US government and military", "Do not transmit");
        if (m >= 148 && m < 150.8) return other("US government and military", "Do not transmit");
        if (m >= 151.8175 && m <= 151.9425) return other("MURS (licence-free, 2 W)", null);
        if (Math.abs(m - 154.57) < 0.006 || Math.abs(m - 154.60) < 0.006) return other("MURS (licence-free, 2 W)", null);
        if (m >= 150.8 && m < 156) return other("Land mobile: public safety and business", "Licensed users only; public safety must never be disturbed");
        if (m >= 156 && m <= 157.45) return other("Marine VHF", "Receive only on this radio");
        if (m >= 159.81 && m <= 161.565) return other("AAR railroad channels", "Receive only on this radio");
        if (m > 157.45 && m < 162.4) return other(m >= 161.6 ? "Marine shore stations and land mobile" : "Land mobile: business, industry, utilities", "Licensed users only");
        if (m >= 162.4 && m <= 162.55) return other("NOAA Weather Radio", "Receive only");
        if (m > 162.55 && m <= 174) return other("US federal government", "Do not transmit");
        if (m >= 400 && m < 406.1) return other("Weather balloons and satellites", "Do not transmit");
        if (m >= 406.1 && m < 420) return other("US federal government", "Do not transmit");
        if (frs(m)) return other(m >= 467.5 && m <= 467.72 ? "FRS and GMRS (channels 8–14, 0.5 W)" : "FRS and GMRS", "GMRS needs an FCC licence; FRS radios only, low power");
        if (m >= 467.5375 && m <= 467.7375) return other("GMRS repeater inputs", "FCC GMRS licence needed");
        if (m >= 450 && m < 470) return other("Land mobile: business, public safety, GMRS", "Licensed users only");
        if (m >= 470 && m <= 480) return other("Land mobile in some cities (TV channels 14–15 elsewhere)", "Licensed users only");
        return null;
    }

    private static boolean frs(double m) {
        for (int n = 1; n <= 22; n++) {
            double f = n <= 7 ? 462.5625 + (n - 1) * 0.025 : n <= 14 ? 467.5625 + (n - 8) * 0.025 : 462.55 + (n - 15) * 0.025;
            if (Math.abs(m - f) < 0.003) return true;
        }
        return false;
    }

    /** One line for a channel: "146.5200 MHz: 2 m national FM simplex calling". */
    public static String line(long hz) {
        Info i = of(hz);
        return String.format(Locale.US, "%.4f MHz: ", hz / 1e6) + (i == null ? "outside this radio's bands" : i.text());
    }

    public static final String HAM_NOTE = HAM;
}
