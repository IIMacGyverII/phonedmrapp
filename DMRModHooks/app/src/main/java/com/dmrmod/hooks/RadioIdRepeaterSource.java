package com.dmrmod.hooks;

import com.dmrmod.hooks.RepeaterModels.Repeater;
import com.dmrmod.hooks.RepeaterModels.Talkgroup;

import org.json.JSONArray;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

/**
 * RadioID (radioid.net) repeater source (chapter 16 §3, P2.1).
 *
 * <p>{@code static/rptrs.json} is {@code {"rptrs":[ ... ]}}. Each record (live): {@code id, callsign,
 * city, state, country, frequency ("440.58750", repeater output), color_code (int), offset
 * ("+5.000"/"-0.600" MHz, sign = input relative to output), ipsc_network (free text), ts_linked,
 * status (always "ACTIVE"), talkgroups[]}. No coordinates — the catalog geolocates these later.
 *
 * <p>{@link #parse(String)} is pure and unit-tested. Used for non-BrandMeister DMR (DMR+, MARC,
 * c-Bridge) and for richer per-slot talkgroup tables.
 */
public final class RadioIdRepeaterSource {

    public static final String URL = "https://radioid.net/static/rptrs.json";

    private RadioIdRepeaterSource() { }

    public static List<Repeater> parse(String json) { return parse(json, System.currentTimeMillis()); }

    public static List<Repeater> parse(String json, long fetchedAt) {
        List<Repeater> out = new ArrayList<>();
        if (json == null) return out;
        JSONArray arr;
        try {
            JSONObject root = new JSONObject(json);
            arr = root.optJSONArray("rptrs");
        } catch (Exception e) {
            return out;
        }
        if (arr == null) return out;
        for (int i = 0; i < arr.length(); i++) {
            JSONObject o = arr.optJSONObject(i);
            if (o == null) continue;
            try {
                String callsign = optString(o, "callsign");
                if (callsign == null) continue;
                long rxHz = parseMhz(optString(o, "frequency"));
                if (rxHz <= 0) continue;
                long txHz = rxHz + parseOffsetHz(optString(o, "offset"));

                Repeater r = new Repeater();
                r.callsign = callsign.trim();
                r.rxHz = rxHz;
                r.txHz = txHz;
                r.dmr = true;
                r.fm = false;
                r.cc = o.optInt("color_code", -1);
                r.dmrId = o.optInt("id", 0);
                r.network = normalizeNetwork(optString(o, "ipsc_network"));
                r.city = optString(o, "city");
                r.region = optString(o, "state");
                r.country = optString(o, "country");
                r.sources = RepeaterModels.SRC_RADIOID;
                r.fetchedAt = fetchedAt;
                // no coordinates in RadioID; a locator may hide in map_info
                String locator = GeoUtil.findLocator(optString(o, "map_info"));
                if (locator != null) {
                    double[] ll = GeoUtil.maidenheadToLatLon(locator);
                    if (ll != null) { r.lat = ll[0]; r.lon = ll[1]; r.hasCoords = true; r.approx = true; }
                }

                int defaultSlot = slotFromTsLinked(optString(o, "ts_linked"));
                parseTalkgroups(o.optJSONArray("talkgroups"), defaultSlot, r.talkgroups);

                r.key = RepeaterModels.makeKey(r.callsign, r.rxHz);
                out.add(r);
            } catch (Exception ignore) { }
        }
        return out;
    }

    /** Talkgroups come as objects (id/slot/name) or bare ids; be lenient. */
    static void parseTalkgroups(JSONArray tgs, int defaultSlot, List<Talkgroup> out) {
        if (tgs == null) return;
        for (int i = 0; i < tgs.length(); i++) {
            JSONObject o = tgs.optJSONObject(i);
            if (o != null) {
                int id = firstInt(o, "talkgroup", "tg", "id", "tg_number");
                if (id <= 0) continue;
                int slot = firstInt(o, "slot", "ts", "timeslot");
                if (slot != 1 && slot != 2) slot = defaultSlot;
                String name = firstString(o, "name", "tg_name", "description");
                out.add(new Talkgroup(id, slot, name, "static"));
            } else {
                int id = tgs.optInt(i, 0);
                if (id > 0) out.add(new Talkgroup(id, defaultSlot, null, "static"));
            }
        }
    }

    static long parseMhz(String s) {
        if (s == null) return 0;
        try { return Math.round(Double.parseDouble(s.trim()) * 1_000_000.0); }
        catch (Exception e) { return 0; }
    }

    /** "+5.000" / "-0.600" (MHz) → signed Hz; a bare number is treated as MHz too. */
    static long parseOffsetHz(String s) {
        if (s == null) return 0;
        s = s.trim();
        if (s.isEmpty()) return 0;
        try { return Math.round(Double.parseDouble(s) * 1_000_000.0); }
        catch (Exception e) { return 0; }
    }

    static int slotFromTsLinked(String ts) {
        if (ts == null) return 0;
        String t = ts.toUpperCase(Locale.US);
        boolean one = t.contains("TS1"), two = t.contains("TS2");
        if (one && !two) return 1;
        if (two && !one) return 2;
        return 0; // both or unknown
    }

    static String normalizeNetwork(String n) {
        if (n == null) return null;
        String s = n.trim().toLowerCase(Locale.US);
        if (s.contains("brandmeister") || s.equals("bm")) return "BM";
        if (s.contains("dmr-plus") || s.contains("dmr+") || s.contains("dmrplus")) return "DMR+";
        if (s.contains("marc")) return "DMR-MARC";
        if (s.contains("tgif")) return "TGIF";
        return n.trim();
    }

    private static int firstInt(JSONObject o, String... keys) {
        for (String k : keys) {
            if (o.has(k) && !o.isNull(k)) {
                int v = o.optInt(k, Integer.MIN_VALUE);
                if (v != Integer.MIN_VALUE) return v;
                try { return Integer.parseInt(o.optString(k, "").trim()); } catch (Exception ignore) { }
            }
        }
        return 0;
    }

    private static String firstString(JSONObject o, String... keys) {
        for (String k : keys) {
            if (o.has(k) && !o.isNull(k)) {
                String s = o.optString(k, null);
                if (s != null && !s.isEmpty()) return s;
            }
        }
        return null;
    }

    private static String optString(JSONObject o, String k) {
        if (o.isNull(k)) return null;
        String s = o.optString(k, null);
        return (s == null || s.isEmpty()) ? null : s;
    }
}
