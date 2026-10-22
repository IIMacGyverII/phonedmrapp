/*
 * SignalDeck - Copyright (C) 2026 IIMacGyverII
 * SPDX-License-Identifier: GPL-3.0-or-later
 * Free software under the GNU General Public License v3 or later, with the additional terms in COPYRIGHT
 * (keep this notice and the author credit, mark modified versions, no rights to the SignalDeck name or icon).
 */
package com.macdmr.radio.repeaters;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.zip.GZIPInputStream;

/**
 * Thin {@link HttpURLConnection} wrapper for the Nearby Repeaters sources (chapter 16 §4, P0.1).
 *
 * <p>Sets a descriptive User-Agent (RadioID and RepeaterBook require one), accepts gzip, honours
 * timeouts, follows one redirect, and supports conditional GET via ETag / If-Modified-Since so a
 * cached catalog is not re-downloaded needlessly. No Android imports; network only.
 *
 * <p>This performs blocking I/O — callers run it off the UI thread (the feature uses a single
 * background executor, chapter 16 §4.3).
 */
public final class HttpClient {

    /** One real contact address goes here before the first production fetch (chapter 16 §9.2). */
    public static final String USER_AGENT =
        "DMRModHooks/4.0.0 (+https://github.com/IIMacGyverII/phonedmrapp)";

    private static final int CONNECT_TIMEOUT_MS = 15000;
    private static final int READ_TIMEOUT_MS = 30000;
    private static final int MAX_BODY_BYTES = 32 * 1024 * 1024; // 32 MB ceiling (hearham ~9.5 MB)

    private HttpClient() { }

    /** Result of a GET. {@code notModified} true when the server answered 304. */
    public static final class Response {
        public final int code;
        public final byte[] body;        // null when notModified or on a non-OK code
        public final String etag;        // may be null
        public final long lastModified;  // 0 if absent
        public final boolean notModified;

        Response(int code, byte[] body, String etag, long lastModified, boolean notModified) {
            this.code = code;
            this.body = body;
            this.etag = etag;
            this.lastModified = lastModified;
            this.notModified = notModified;
        }

        public boolean isOk() { return code == HttpURLConnection.HTTP_OK && body != null; }

        public String bodyUtf8() {
            if (body == null) return null;
            try { return new String(body, "UTF-8"); } catch (Exception e) { return new String(body); }
        }
    }

    public static Response get(String urlStr) throws IOException {
        return get(urlStr, null, 0L, null);
    }

    /**
     * GET {@code urlStr}. When {@code etag} or {@code ifModifiedSinceMillis} is given, sends the
     * matching conditional header; a 304 comes back as {@link Response#notModified}.
     *
     * @param accept value for the Accept header, or null to omit
     */
    public static Response get(String urlStr, String etag, long ifModifiedSinceMillis, String accept)
            throws IOException {
        HttpURLConnection conn = null;
        try {
            URL url = new URL(urlStr);
            conn = (HttpURLConnection) url.openConnection();
            conn.setConnectTimeout(CONNECT_TIMEOUT_MS);
            conn.setReadTimeout(READ_TIMEOUT_MS);
            conn.setInstanceFollowRedirects(true);
            conn.setRequestProperty("User-Agent", USER_AGENT);
            conn.setRequestProperty("Accept-Encoding", "gzip");
            if (accept != null) conn.setRequestProperty("Accept", accept);
            if (etag != null) conn.setRequestProperty("If-None-Match", etag);
            if (ifModifiedSinceMillis > 0) conn.setIfModifiedSince(ifModifiedSinceMillis);

            int code = conn.getResponseCode();
            String respEtag = conn.getHeaderField("ETag");
            long lastMod = conn.getLastModified();

            if (code == HttpURLConnection.HTTP_NOT_MODIFIED) {
                return new Response(code, null, respEtag != null ? respEtag : etag, lastMod, true);
            }
            if (code != HttpURLConnection.HTTP_OK) {
                return new Response(code, null, respEtag, lastMod, false);
            }

            boolean gzip = "gzip".equalsIgnoreCase(conn.getContentEncoding());
            InputStream in = conn.getInputStream();
            if (gzip) in = new GZIPInputStream(in);
            byte[] body = readAll(in);
            return new Response(code, body, respEtag, lastMod, false);
        } finally {
            if (conn != null) conn.disconnect();
        }
    }

    private static byte[] readAll(InputStream in) throws IOException {
        ByteArrayOutputStream out = new ByteArrayOutputStream(1 << 16);
        byte[] buf = new byte[1 << 16];
        int total = 0, n;
        try {
            while ((n = in.read(buf)) != -1) {
                total += n;
                if (total > MAX_BODY_BYTES) {
                    throw new IOException("response exceeds " + MAX_BODY_BYTES + " bytes");
                }
                out.write(buf, 0, n);
            }
        } finally {
            try { in.close(); } catch (IOException ignore) { }
        }
        return out.toByteArray();
    }
}
