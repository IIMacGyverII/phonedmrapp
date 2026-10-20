package com.macdmr.radio.ham;

import android.content.Context;
import android.util.Log;

import java.io.File;
import java.io.InputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/** The FM satellites this radio can work, their frequencies, and their orbital elements (AMSAT, CelesTrak fallback). */
public final class Satellites {
    public static final class Sat {
        public final String key, name, tleName, about; public final int catalog; public final long downHz, upHz; public final double toneHz;
        Sat(String key, String name, String tleName, int catalog, long downHz, long upHz, double toneHz, String about) { this.key = key; this.name = name; this.tleName = tleName; this.catalog = catalog; this.downHz = downHz; this.upHz = upHz; this.toneHz = toneHz; this.about = about; }
    }

    public static final Sat[] ALL = {
        new Sat("iss-rptr", "ISS repeater", "ISS", 25544, 437_800_000, 145_990_000, 67.0, "Cross-band FM repeater, on at times: listen on 70 cm, talk on 2 m with 67 Hz"),
        new Sat("iss-voice", "ISS voice", "ISS", 25544, 145_800_000, 144_490_000, 0, "Crew contacts and school contacts; mostly listen"),
        new Sat("iss-aprs", "ISS APRS", "ISS", 25544, 145_825_000, 145_825_000, 0, "Packet digipeater: PKT → Beacon via ISS"),
        new Sat("so50", "SO-50", "SO-50", 27607, 436_795_000, 145_850_000, 67.0, "FM repeater; a 74.4 Hz tone for 2 s arms its 10-minute timer"),
        new Sat("po101", "PO-101", "PO-101", 43678, 145_900_000, 437_500_000, 141.3, "FM repeater on a schedule (Diwata-2); talk on 70 cm with 141.3 Hz"),
    };

    private final Context ctx;
    public Satellites(Context c) { ctx = c; }
    private File file() { return new File(ctx.getFilesDir(), "sats.tle"); }

    public long elementsAgeMs() { File f = file(); return f.exists() ? System.currentTimeMillis() - f.lastModified() : Long.MAX_VALUE; }

    /** Download fresh elements (call off the main thread). Error or null. */
    public String update() {
        String body = get("https://www.amsat.org/tle/current/nasabare.txt");
        if (body == null || !body.contains("25544")) {
            StringBuilder sb = new StringBuilder();
            for (int cat : new int[] { 25544, 27607, 43678 }) { String b = get("https://celestrak.org/NORAD/elements/gp.php?CATNR=" + cat + "&FORMAT=TLE"); if (b != null) sb.append(b.trim()).append('\n'); }
            body = sb.length() > 0 ? sb.toString() : null;
        }
        if (body == null) return "Could not download satellite orbits (AMSAT and CelesTrak unreachable)";
        try { Files.write(file().toPath(), body.getBytes(StandardCharsets.US_ASCII)); return null; } catch (Throwable t) { return "Could not save: " + t.getMessage(); }
    }

    /** Elements by catalog number from the saved file. */
    public Map<Integer, Sgp4> elements() {
        Map<Integer, Sgp4> out = new LinkedHashMap<>();
        try {
            String[] l = new String(Files.readAllBytes(file().toPath()), StandardCharsets.US_ASCII).split("\\r?\\n");
            for (int i = 0; i + 1 < l.length; i++) {
                if (l[i].startsWith("1 ") && l[i + 1].startsWith("2 ")) {
                    String name = i > 0 && !l[i - 1].startsWith("2 ") ? l[i - 1].trim() : "";
                    try { Sgp4 s = new Sgp4(name, l[i], l[i + 1]); out.put(s.catalog, s); } catch (Throwable ignored) { }
                    i++;
                }
            }
        } catch (Throwable ignored) { }
        return out;
    }

    private static String get(String url) {
        try {
            HttpURLConnection h = (HttpURLConnection) new URL(url).openConnection(); h.setConnectTimeout(10000); h.setReadTimeout(15000); h.setRequestProperty("User-Agent", "SignalDeck");
            if (h.getResponseCode() != 200) return null;
            try (InputStream in = h.getInputStream()) { java.io.ByteArrayOutputStream o = new java.io.ByteArrayOutputStream(); byte[] b = new byte[8192]; int n; while ((n = in.read(b)) > 0) o.write(b, 0, n); return o.toString("US-ASCII"); }
        } catch (Throwable t) { Log.w("Satellites", url + ": " + t); return null; }
    }

    public static Sat byKey(String k) { for (Sat s : ALL) if (s.key.equals(k)) return s; return null; }
    public static List<Sat> list() { List<Sat> l = new ArrayList<>(); for (Sat s : ALL) l.add(s); return l; }
}
