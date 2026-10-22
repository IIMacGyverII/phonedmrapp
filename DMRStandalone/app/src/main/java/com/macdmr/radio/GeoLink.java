/*
 * SignalDeck - Copyright (C) 2026 IIMacGyverII
 * SPDX-License-Identifier: GPL-3.0-or-later
 * Free software under the GNU General Public License v3 or later, with the additional terms in COPYRIGHT
 * (keep this notice and the author credit, mark modified versions, no rights to the SignalDeck name or icon).
 */
package com.macdmr.radio;

import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLDecoder;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * Coordinates out of whatever a maps app shares or copies: geo: URIs, Google Maps URLs (@lat,lon, !3d…!4d…,
 * q= / ll= / query= / center= / destination=), Apple Maps (ll=), OpenStreetMap (mlat/mlon, #map=z/lat/lon) and plain
 * "lat, lon" text. Short share links (maps.app.goo.gl, goo.gl/maps) are followed to their full URL first.
 */
public final class GeoLink {
    private GeoLink() { }

    private static final String NUM = "(-?\\d{1,3}(?:\\.\\d+)?)";
    private static final Pattern[] PATTERNS = {
        Pattern.compile("geo:" + NUM + "\\s*,\\s*" + NUM),
        Pattern.compile("!3d" + NUM + "!4d" + NUM),                                   // Google place pin (more exact than the camera)
        Pattern.compile("[?&](?:q|ll|query|sll|center|destination|daddr)=(?:loc:)?" + NUM + "(?:,|%2C)\\s*" + NUM, Pattern.CASE_INSENSITIVE),
        Pattern.compile("@" + NUM + "," + NUM),                                       // Google camera position
        Pattern.compile("mlat=" + NUM + "&mlon=" + NUM),
        Pattern.compile("#map=\\d+/" + NUM + "/" + NUM),
        Pattern.compile("center=" + NUM + "%2C" + NUM),                               // og:image of a Google Maps page
        Pattern.compile("^\\s*" + NUM + "\\s*[, ]\\s*" + NUM + "\\s*$"),              // "45.12345, -93.12345"
    };

    /** Coordinates in the text, or null. */
    public static double[] parse(String text) {
        if (text == null) return null;
        String t = text;
        try { t = URLDecoder.decode(text.replace("+", "%2B"), "UTF-8"); } catch (Throwable ignored) { }
        for (String s : new String[] { text, t }) {
            for (Pattern p : PATTERNS) {
                Matcher m = p.matcher(s);
                if (m.find()) {
                    double lat = Double.parseDouble(m.group(1)), lon = Double.parseDouble(m.group(2));
                    if (Math.abs(lat) <= 90 && Math.abs(lon) <= 180 && !(lat == 0 && lon == 0)) return new double[] { lat, lon };
                }
            }
        }
        return null;
    }

    /** Like {@link #parse}, but follows a shared short link over the network when the text has no coordinates. Call off the main thread. */
    public static double[] resolve(String text) {
        double[] r = parse(text);
        if (r != null || text == null) return r;
        Matcher u = Pattern.compile("https?://\\S+").matcher(text);
        if (!u.find()) return null;
        String url = u.group();
        try {
            for (int hop = 0; hop < 8; hop++) {
                HttpURLConnection c = (HttpURLConnection) new URL(url).openConnection();
                c.setInstanceFollowRedirects(false); c.setConnectTimeout(8000); c.setReadTimeout(8000);
                c.setRequestProperty("User-Agent", "Mozilla/5.0 (Linux; Android) SignalDeck");
                int code = c.getResponseCode();
                String loc = c.getHeaderField("Location");
                if (code >= 300 && code < 400 && loc != null) {
                    url = new URL(new URL(url), loc).toString(); c.disconnect();
                    r = parse(url); if (r != null) return r;
                    continue;
                }
                // final page: some carry the position only in their markup (og:image center=…, or an @lat,lon link)
                StringBuilder body = new StringBuilder();
                try (java.io.InputStream in = c.getInputStream()) { byte[] b = new byte[8192]; int n, total = 0; while ((n = in.read(b)) > 0 && total < 400_000) { body.append(new String(b, 0, n, "UTF-8")); total += n; } }
                c.disconnect();
                r = parse(url); if (r != null) return r;
                Matcher m = Pattern.compile("center=" + NUM + "%2C" + NUM).matcher(body); if (m.find()) return new double[] { Double.parseDouble(m.group(1)), Double.parseDouble(m.group(2)) };
                m = Pattern.compile("/@" + NUM + "," + NUM).matcher(body); if (m.find()) return new double[] { Double.parseDouble(m.group(1)), Double.parseDouble(m.group(2)) };
                return null;
            }
        } catch (Throwable ignored) { }
        return null;
    }
}
