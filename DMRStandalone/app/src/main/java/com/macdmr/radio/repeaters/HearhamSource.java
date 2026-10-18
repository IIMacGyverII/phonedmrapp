package com.macdmr.radio.repeaters;

import com.macdmr.radio.repeaters.RepeaterModels.Repeater;

import org.json.JSONArray;
import org.json.JSONObject;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

/**
 * hearham.com FM (and CC-only DMR) source (chapter 16 §3, P2.2).
 *
 * <p>{@code GET /api/repeaters/v1} is one JSON array of ~22.6 k repeaters with coordinates and
 * tones. Fields (live probe): {@code id, callsign, latitude, longitude, city, mode, encode, decode,
 * frequency (Hz int, repeater output), offset (Hz signed int), operational (0/1)}. The user's RX is
 * the repeater output ({@code frequency}); the user's TX is {@code frequency + offset}.
 *
 * <p>{@link #parse(String)} is pure and unit-tested. hearham DMR rows carry no talkgroups (encode
 * like {@code "CC4"}), so the catalog installs them as DMR only when a TG source also covers the
 * key; hearham on its own yields FM.
 */
public final class HearhamSource {

    public static final String URL = "https://hearham.com/api/repeaters/v1";

    private HearhamSource() { }

    public static List<Repeater> parse(String json) { return parse(json, System.currentTimeMillis()); }

    public static List<Repeater> parse(String json, long fetchedAt) {
        List<Repeater> out = new ArrayList<>();
        if (json == null) return out;
        JSONArray arr;
        try { arr = new JSONArray(json); } catch (Exception e) { return out; }
        for (int i = 0; i < arr.length(); i++) {
            JSONObject o = arr.optJSONObject(i);
            if (o == null) continue;
            try {
                String callsign = optString(o, "callsign");
                if (callsign == null) continue;
                long rxHz = o.optLong("frequency", 0);
                if (rxHz <= 0) {
                    try { rxHz = Math.round(Double.parseDouble(o.optString("frequency", "0"))); }
                    catch (Exception e) { rxHz = 0; }
                }
                if (rxHz <= 0) continue;
                long offset = o.optLong("offset", 0);
                long txHz = rxHz + offset;

                String mode = optString(o, "mode");
                String m = mode == null ? "" : mode.toLowerCase(Locale.US);
                boolean dmr = m.contains("dmr");
                boolean fm = m.contains("fm") || m.contains("analog") || m.isEmpty();

                Repeater r = new Repeater();
                r.callsign = callsign.trim();
                r.rxHz = rxHz;
                r.txHz = txHz;
                r.dmr = dmr;
                r.fm = fm && !dmr;
                r.network = dmr ? "DMR" : "FM";
                r.city = optString(o, "city");
                r.sources = RepeaterModels.SRC_HEARHAM;
                r.fetchedAt = fetchedAt;

                double lat = o.optDouble("latitude", 0);
                double lon = o.optDouble("longitude", 0);
                if (lat != 0 || lon != 0) { r.lat = lat; r.lon = lon; r.hasCoords = true; }

                String encode = optString(o, "encode");   // TX tone (or "CCn" for DMR)
                String decode = optString(o, "decode");   // RX tone
                if (dmr) {
                    r.cc = parseCc(encode);
                } else {
                    r.toneUp = encode;
                    r.toneDown = decode;
                }
                if (o.optInt("operational", 1) == 0) r.status = "not operational";

                r.key = RepeaterModels.makeKey(r.callsign, r.rxHz);
                out.add(r);
            } catch (Exception ignore) { }
        }
        return out;
    }

    /** "CC4" / "cc4" / "4" → 4; else -1. */
    static int parseCc(String encode) {
        if (encode == null) return -1;
        String s = encode.trim().toLowerCase(Locale.US).replace("cc", "").trim();
        try { return Integer.parseInt(s); } catch (Exception e) { return -1; }
    }

    private static String optString(JSONObject o, String k) {
        if (o.isNull(k)) return null;
        String s = o.optString(k, null);
        return (s == null || s.isEmpty()) ? null : s;
    }
}
