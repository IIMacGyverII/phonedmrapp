package com.dmrmod.hooks;

import com.dmrmod.hooks.RepeaterModels.Repeater;
import com.dmrmod.hooks.RepeaterModels.Talkgroup;

import org.json.JSONArray;
import org.json.JSONObject;

import java.io.IOException;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * BrandMeister DMR backbone source (chapter 16 §3, P0.2).
 *
 * <p>{@code GET /v2/device?repeater=true} returns a ~1 MB JSON array of {@code DeviceIndex}
 * records. {@link #parseDeviceList(String)} turns that into {@link Repeater}s and is pure, so
 * {@code BrandMeisterSourceTest} runs it against a checked-in fixture with no device.
 * {@link #fetchDeviceList(long, String)} does the network GET via {@link HttpClient}.
 *
 * <p>Fields (live probe, research memo §BrandMeister): {@code id, callsign, tx, rx, colorcode,
 * status, lat, lng, city, last_seen}. <b>tx/rx are from the repeater's point of view</b>: the
 * repeater's tx is the user's RX. Simplex rows (tx == rx, ~429 hotspot-style 6-digit nodes) are
 * dropped. This source never transmits or writes anything.
 */
public final class BrandMeisterSource {

    public static final String DEVICE_LIST_URL =
        "https://api.brandmeister.network/v2/device?repeater=true";
    public static final String TALKGROUP_MAP_URL =
        "https://api.brandmeister.network/v2/talkgroup";
    /** Per-device static talkgroups: append the device id. */
    public static final String DEVICE_TALKGROUP_URL_PREFIX =
        "https://api.brandmeister.network/v2/device/";

    private BrandMeisterSource() { }

    /** Outcome of a parse: the repeaters plus a count of records skipped and why (for logging). */
    public static final class ParseResult {
        public final List<Repeater> repeaters = new ArrayList<>();
        public int skippedSimplex;
        public int skippedNoCallsign;
        public int skippedBadFreq;
        public int total;
    }

    /** Network fetch + parse. Device-only (uses {@link HttpClient}); not unit tested. */
    public static ParseResult fetchDeviceList(long fetchedAtMillis, String etagOrNull) throws IOException {
        HttpClient.Response r = HttpClient.get(DEVICE_LIST_URL, etagOrNull, 0L, "application/json");
        if (!r.isOk()) {
            throw new IOException("BrandMeister /device HTTP " + r.code);
        }
        return parseDeviceList(r.bodyUtf8(), fetchedAtMillis);
    }

    public static ParseResult parseDeviceList(String json) {
        return parseDeviceList(json, System.currentTimeMillis());
    }

    /**
     * Parse the {@code /device?repeater=true} array. Robust to missing fields and to numbers
     * arriving as either JSON numbers or strings. Never throws on a single bad record.
     */
    public static ParseResult parseDeviceList(String json, long fetchedAtMillis) {
        ParseResult out = new ParseResult();
        if (json == null) return out;
        JSONArray arr;
        try {
            arr = new JSONArray(json);
        } catch (Exception e) {
            return out;
        }
        out.total = arr.length();
        for (int i = 0; i < arr.length(); i++) {
            JSONObject o = arr.optJSONObject(i);
            if (o == null) continue;
            try {
                String callsign = optString(o, "callsign");
                if (callsign == null || callsign.trim().isEmpty()) {
                    out.skippedNoCallsign++;
                    continue;
                }
                double txMhz = optDouble(o, "tx");   // repeater output = user RX
                double rxMhz = optDouble(o, "rx");   // repeater input  = user TX
                if (txMhz <= 0 || rxMhz <= 0) {
                    out.skippedBadFreq++;
                    continue;
                }
                long rxHz = GeoUtil.mhzToHz(txMhz);
                long txHz = GeoUtil.mhzToHz(rxMhz);
                if (rxHz == txHz) {           // simplex hotspot-style node
                    out.skippedSimplex++;
                    continue;
                }

                Repeater rep = new Repeater();
                rep.callsign = callsign.trim();
                rep.rxHz = rxHz;
                rep.txHz = txHz;
                rep.dmr = true;
                rep.fm = false;
                rep.cc = (int) optLong(o, "colorcode", -1);
                rep.dmrId = (int) optLong(o, "id", 0);
                rep.network = "BM";
                rep.status = optString(o, "status");
                rep.lastSeen = optString(o, "last_seen");
                rep.city = optString(o, "city");
                rep.sources = RepeaterModels.SRC_BRANDMEISTER;
                rep.fetchedAt = fetchedAtMillis;

                double lat = optDouble(o, "lat");
                double lon = optDouble(o, "lng");
                if (lat != 0.0 || lon != 0.0) {
                    rep.lat = lat;
                    rep.lon = lon;
                    rep.hasCoords = true;
                } else {
                    // BrandMeister sometimes carries a Maidenhead locator in the city string.
                    String loc = GeoUtil.findLocator(rep.city);
                    if (loc != null) {
                        double[] ll = GeoUtil.maidenheadToLatLon(loc);
                        if (ll != null) {
                            rep.lat = ll[0];
                            rep.lon = ll[1];
                            rep.hasCoords = true;
                            rep.approx = true;
                        }
                    }
                }

                rep.key = RepeaterModels.makeKey(rep.callsign, rep.rxHz);
                out.repeaters.add(rep);
            } catch (Exception recordError) {
                // One malformed record never fails the whole parse.
            }
        }
        return out;
    }

    /**
     * Parse {@code GET /device/{id}/talkgroup} → the repeater's static talkgroups.
     * Shape: {@code [{"talkgroup":"23558","slot":"1","repeaterid":"235454"}, ...]} (all strings).
     * slot is 1 or 2; anything else becomes 0 (unknown). Names are filled later from the TG map.
     */
    public static List<Talkgroup> parseDeviceTalkgroups(String json) {
        List<Talkgroup> out = new ArrayList<>();
        if (json == null) return out;
        JSONArray arr;
        try { arr = new JSONArray(json); } catch (Exception e) { return out; }
        for (int i = 0; i < arr.length(); i++) {
            JSONObject o = arr.optJSONObject(i);
            if (o == null) continue;
            try {
                int tg = (int) optLong(o, "talkgroup", 0);
                if (tg <= 0) continue;
                int slot = (int) optLong(o, "slot", 0);
                if (slot != 1 && slot != 2) slot = 0;
                out.add(new Talkgroup(tg, slot, null, "static"));
            } catch (Exception ignore) { }
        }
        return out;
    }

    /**
     * Parse {@code GET /talkgroup} → a TG-id→name map. Shape: {@code {"3100":"USA Bridge", ...}}.
     * Returns a {@link LinkedHashMap} so iteration order is stable for tests.
     */
    public static Map<Integer, String> parseTalkgroupNames(String json) {
        Map<Integer, String> out = new LinkedHashMap<>();
        if (json == null) return out;
        JSONObject o;
        try { o = new JSONObject(json); } catch (Exception e) { return out; }
        for (java.util.Iterator<String> it = o.keys(); it.hasNext(); ) {
            String k = it.next();
            try {
                int tg = Integer.parseInt(k.trim());
                String name = o.optString(k, null);
                if (name != null && !name.isEmpty()) out.put(tg, name);
            } catch (Exception ignore) { }
        }
        return out;
    }

    // --------------------------------------------------------- lenient JSON field readers

    private static String optString(JSONObject o, String key) {
        if (o.isNull(key)) return null;
        String s = o.optString(key, null);
        return (s == null || s.isEmpty()) ? null : s;
    }

    private static double optDouble(JSONObject o, String key) {
        if (o.isNull(key)) return 0.0;
        double d = o.optDouble(key, Double.NaN);
        if (!Double.isNaN(d)) return d;
        try { return Double.parseDouble(o.optString(key, "0").trim()); }
        catch (Exception e) { return 0.0; }
    }

    private static long optLong(JSONObject o, String key, long def) {
        if (o.isNull(key)) return def;
        long v = o.optLong(key, Long.MIN_VALUE);
        if (v != Long.MIN_VALUE) return v;
        try { return Long.parseLong(o.optString(key, String.valueOf(def)).trim()); }
        catch (Exception e) { return def; }
    }
}
