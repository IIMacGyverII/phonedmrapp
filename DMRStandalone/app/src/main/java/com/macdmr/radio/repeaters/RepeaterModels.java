package com.macdmr.radio.repeaters;

import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

/**
 * Plain data holders for the Nearby Repeaters feature (backlog E7, chapter 16 §4).
 *
 * <p>No Android imports — populated by the source parsers and consumed by the catalog, the UI
 * and the programmer. Frequencies are integer Hz (the OEM {@code ChannelData} unit).
 */
public final class RepeaterModels {

    private RepeaterModels() { }

    /** Source identity bits for the {@code sources} field / provenance badges. */
    public static final int SRC_BRANDMEISTER = 1;
    public static final int SRC_RADIOID      = 1 << 1;
    public static final int SRC_HEARHAM      = 1 << 2;
    public static final int SRC_REPEATERBOOK = 1 << 3;

    /** One talkgroup entry on a repeater's slot. slot: 1, 2, or 0 = unknown. */
    public static final class Talkgroup {
        public final int id;
        public final int slot;
        public String name;        // may be filled later from the TG name map
        public final String kind;  // "static", "timed", "dynamic", or null

        public Talkgroup(int id, int slot, String name, String kind) {
            this.id = id;
            this.slot = slot;
            this.name = name;
            this.kind = kind;
        }

        @Override public String toString() {
            return "TG " + id + (slot > 0 ? " TS" + slot : "") + (name != null ? " " + name : "");
        }
    }

    /** One repeater, merged across sources. Phase 0 populates the BrandMeister subset. */
    public static final class Repeater {
        public String key;          // normalised callsign + "|" + rxHz
        public String callsign;
        public long rxHz;           // what the user's radio receives (repeater output)
        public long txHz;           // what the user's radio transmits (repeater input)
        public double lat, lon;
        public boolean hasCoords;   // lat/lon are real (non-zero, reported)
        public boolean approx;      // coordinates are geocoded/locator-derived, not reported
        public boolean fm;
        public boolean dmr;
        public int cc = -1;         // DMR colour code, -1 = unknown
        public int dmrId;           // BrandMeister/RadioID device id
        public String network;      // "BM", "DMR+", "DMR-MARC", "FM", ...
        public String status;       // source status text
        public String lastSeen;     // source timestamp string (UTC)
        public String city;
        public String region;    // state/province, for geocoding RadioID rows
        public String country;
        public String toneUp;    // FM: TX sub-audible tone/code as a source string (e.g. "67.0", "D023N")
        public String toneDown;  // FM: RX tone/code
        public int bandwidth = 1; // 1 wide (25 kHz) / 0 narrow (12.5 kHz)
        public int sources;         // bitmask of SRC_*
        public long fetchedAt;      // epoch millis the record was fetched
        public final List<Talkgroup> talkgroups = new ArrayList<>();

        /** Transient, set when a list is built for a given location. */
        public double distanceMeters = Double.NaN;

        public boolean isSimplex() { return rxHz == txHz; }

        /** Repeater offset in Hz, signed (txHz − rxHz); 0 for simplex. */
        public long offsetHz() { return txHz - rxHz; }

        public String rxMhzString() { return String.format(Locale.US, "%.4f", rxHz / 1e6); }

        @Override public String toString() {
            return (callsign != null ? callsign : "?")
                 + " " + rxMhzString() + (dmr ? " DMR CC" + cc : " FM")
                 + (hasCoords ? String.format(Locale.US, " (%.4f,%.4f)", lat, lon) : " (no coords)");
        }
    }

    /** Normalise a callsign for keying: upper-case, strip anything but A–Z/0–9. */
    public static String normCall(String callsign) {
        if (callsign == null) return "";
        return callsign.toUpperCase(Locale.US).replaceAll("[^A-Z0-9]", "");
    }

    /** Dedupe key: normalised callsign + rounded RX frequency (2.5 kHz bucket). */
    public static String makeKey(String callsign, long rxHz) {
        long bucket = Math.round(rxHz / 2500.0) * 2500L;
        return normCall(callsign) + "|" + bucket;
    }
}
