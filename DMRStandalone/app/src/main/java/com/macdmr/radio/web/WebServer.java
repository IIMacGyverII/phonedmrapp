package com.macdmr.radio.web;

import java.io.BufferedInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.InetAddress;
import java.net.InetSocketAddress;
import java.net.ServerSocket;
import java.net.Socket;
import java.nio.charset.StandardCharsets;
import java.security.SecureRandom;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Locale;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.CopyOnWriteArrayList;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.LinkedBlockingQueue;
import java.util.concurrent.TimeUnit;

/**
 * SignalDeck's built-in web server (SignalDeck Web): a small HTTP/1.1 server with no libraries. It serves the web app
 * (static files through {@link Assets}), a JSON API ({@link Api}) and a Server-Sent Events stream for live state.
 * Access is limited to private (LAN) addresses and needs a login with the PIN shown on the phone; sessions are
 * cookies. Pure Java: the request parsing, routing and auth run in host unit tests.
 */
public final class WebServer {
    public interface Assets { byte[] read(String path) throws IOException; }
    public interface Api { Response handle(Request r) throws Exception; }

    public static final class Request {
        public String method, path, query = ""; public final Map<String, String> headers = new HashMap<>(); public byte[] body = new byte[0];
        public String remote;
        public String param(String k) {
            for (String kv : query.split("&")) { int e = kv.indexOf('='); if (e > 0 && kv.substring(0, e).equals(k)) return decode(kv.substring(e + 1)); }
            return null;
        }
        public String bodyText() { return new String(body, StandardCharsets.UTF_8); }
        static String decode(String s) { try { return java.net.URLDecoder.decode(s, "UTF-8"); } catch (Exception e) { return s; } }
    }
    public static final class Response {
        public int status = 200; public String type = "application/json; charset=utf-8"; public byte[] body = new byte[0];
        public final Map<String, String> headers = new HashMap<>();
        public static Response json(int status, String json) { Response r = new Response(); r.status = status; r.body = json.getBytes(StandardCharsets.UTF_8); return r; }
        public static Response bytes(String type, byte[] b) { Response r = new Response(); r.type = type; r.body = b; return r; }
        public static Response error(int status, String msg) { return json(status, "{\"error\":" + quote(msg) + "}"); }
    }

    private final int port;
    private final Assets assets;
    private final Api api;
    private final String pin;
    private volatile ServerSocket server;
    private volatile boolean running;
    private final ExecutorService pool = Executors.newCachedThreadPool(r -> { Thread t = new Thread(r, "web"); t.setDaemon(true); return t; });
    private final Map<String, Long> sessions = new ConcurrentHashMap<>();       // token -> last use
    private final Map<String, int[]> failures = new ConcurrentHashMap<>();      // remote -> {count, minute}
    private final CopyOnWriteArrayList<LinkedBlockingQueue<String>> streams = new CopyOnWriteArrayList<>();
    private final SecureRandom rnd = new SecureRandom();
    public static final long SESSION_IDLE_MS = 30L * 24 * 3600 * 1000;

    public WebServer(int port, String pin, Assets assets, Api api) { this.port = port; this.pin = pin; this.assets = assets; this.api = api; }

    public synchronized void start() throws IOException {
        if (running) return;
        ServerSocket s = new ServerSocket(); s.setReuseAddress(true); s.bind(new InetSocketAddress(port), 16);
        server = s; running = true;
        pool.execute(() -> { while (running) { try { Socket c = s.accept(); pool.execute(() -> serve(c)); } catch (IOException e) { if (!running) break; } } });
    }
    public synchronized void stop() {
        running = false;
        try { if (server != null) server.close(); } catch (IOException ignored) { }
        for (LinkedBlockingQueue<String> q : streams) q.offer("\u0000");                   // wake the event writers so they end
        streams.clear();
    }
    public boolean running() { return running; }
    public int clients() { return streams.size(); }

    /** Push one event to every connected browser ({@code type} plus a JSON object). */
    public void publish(String type, String json) {
        if (streams.isEmpty()) return;
        String frame = "event: " + type + "\ndata: " + json.replace("\n", "\ndata: ") + "\n\n";
        for (LinkedBlockingQueue<String> q : streams) { if (q.size() > 500) q.clear(); q.offer(frame); }
    }

    // ---- connection ----
    private void serve(Socket c) {
        try {
            c.setSoTimeout(30_000);
            InetAddress ra = c.getInetAddress();
            if (!lanAddress(ra)) { c.close(); return; }
            InputStream in = new BufferedInputStream(c.getInputStream()); OutputStream out = c.getOutputStream();
            for (int keep = 0; keep < 100; keep++) {
                Request r = read(in); if (r == null) break;
                r.remote = ra.getHostAddress();
                if ("GET".equals(r.method) && "/api/events".equals(r.path)) { if (authed(r)) { stream(c, out); return; } write(out, Response.error(401, "login required"), true); continue; }
                Response resp = route(r);
                boolean close = "close".equalsIgnoreCase(r.headers.get("connection"));
                write(out, resp, !close);
                if (close) break;
            }
        } catch (Exception ignored) {
        } finally { try { c.close(); } catch (IOException ignored) { } }
    }

    static boolean lanAddress(InetAddress a) {
        return a.isLoopbackAddress() || a.isSiteLocalAddress() || a.isLinkLocalAddress()
                || (a.getAddress().length == 16 && (a.getAddress()[0] & 0xFE) == 0xFC);      // IPv6 unique local
    }

    Response route(Request r) {
        try {
            if (r.path.equals("/api/login") && "POST".equals(r.method)) return login(r);
            if (r.path.equals("/api/logout")) { String t = token(r); if (t != null) sessions.remove(t); Response x = Response.json(200, "{\"ok\":true}"); x.headers.put("Set-Cookie", "sd_session=; Path=/; Max-Age=0; HttpOnly; SameSite=Strict"); return x; }
            if (r.path.startsWith("/api/")) {
                if (!authed(r)) return Response.error(401, "login required");
                Response x = api.handle(r);
                return x != null ? x : Response.error(404, "no such API: " + r.path);
            }
            String p = r.path.equals("/") ? "index.html" : r.path.substring(1);
            if (p.contains("..")) return Response.error(400, "bad path");
            byte[] b = assets.read(p);
            if (b == null) { b = assets.read("index.html"); p = "index.html"; }       // the app routes itself
            if (b == null) return Response.error(404, "not found");
            Response x = Response.bytes(mime(p), b);
            x.headers.put("Cache-Control", p.equals("index.html") ? "no-cache" : "max-age=300");
            return x;
        } catch (Exception e) { return Response.error(500, String.valueOf(e.getMessage())); }
    }

    private Response login(Request r) {
        int[] f = failures.computeIfAbsent(r.remote, k -> new int[2]);
        int minute = (int) (System.currentTimeMillis() / 60000);
        if (f[1] != minute) { f[0] = 0; f[1] = minute; }
        if (f[0] >= 5) return Response.error(429, "too many attempts: wait a minute");
        String given = jsonField(r.bodyText(), "pin");
        if (given == null || !constantEquals(given.trim().toUpperCase(Locale.US), pin.toUpperCase(Locale.US))) { f[0]++; return Response.error(403, "wrong PIN"); }
        byte[] b = new byte[24]; rnd.nextBytes(b);
        StringBuilder t = new StringBuilder(); for (byte x : b) t.append(String.format("%02x", x));
        sessions.put(t.toString(), System.currentTimeMillis());
        Response x = Response.json(200, "{\"ok\":true}");
        x.headers.put("Set-Cookie", "sd_session=" + t + "; Path=/; Max-Age=" + (SESSION_IDLE_MS / 1000) + "; HttpOnly; SameSite=Strict");
        return x;
    }
    boolean authed(Request r) {
        String t = token(r); if (t == null) return false;
        Long last = sessions.get(t); long now = System.currentTimeMillis();
        if (last == null || now - last > SESSION_IDLE_MS) { if (last != null) sessions.remove(t); return false; }
        sessions.put(t, now); return true;
    }
    private static String token(Request r) {
        String c = r.headers.get("cookie"); if (c == null) return null;
        for (String part : c.split(";")) { String p = part.trim(); if (p.startsWith("sd_session=")) return p.substring(11); }
        return null;
    }
    static boolean constantEquals(String a, String b) {
        byte[] x = a.getBytes(StandardCharsets.UTF_8), y = b.getBytes(StandardCharsets.UTF_8); int d = x.length ^ y.length;
        for (int i = 0; i < Math.min(x.length, y.length); i++) d |= x[i] ^ y[i];
        return d == 0;
    }

    private void stream(Socket c, OutputStream out) throws IOException {
        LinkedBlockingQueue<String> q = new LinkedBlockingQueue<>();
        streams.add(q);
        try {
            c.setSoTimeout(0);
            out.write(("HTTP/1.1 200 OK\r\nContent-Type: text/event-stream\r\nCache-Control: no-cache\r\nConnection: keep-alive\r\nX-Accel-Buffering: no\r\n\r\nretry: 3000\n\n").getBytes(StandardCharsets.UTF_8));
            out.flush();
            while (running) {
                String f = q.poll(15, TimeUnit.SECONDS);
                if (f == null) f = ": ping\n\n";                                  // keeps the connection (and Wi-Fi NAT) alive
                if (f.equals("\u0000")) break;
                out.write(f.getBytes(StandardCharsets.UTF_8)); out.flush();
            }
        } catch (InterruptedException ignored) {
        } finally { streams.remove(q); }
    }

    // ---- HTTP parsing / writing ----
    static Request read(InputStream in) throws IOException {
        String line = readLine(in); if (line == null || line.isEmpty()) return null;
        String[] p = line.split(" "); if (p.length < 2) return null;
        Request r = new Request(); r.method = p[0].toUpperCase(Locale.US);
        String target = p[1]; int q = target.indexOf('?');
        r.path = Request.decode(q >= 0 ? target.substring(0, q) : target); if (q >= 0) r.query = target.substring(q + 1);
        int n = 0;
        for (String h; (h = readLine(in)) != null && !h.isEmpty(); ) {
            if (++n > 64) return null;
            int c = h.indexOf(':'); if (c > 0) r.headers.put(h.substring(0, c).trim().toLowerCase(Locale.US), h.substring(c + 1).trim());
        }
        String cl = r.headers.get("content-length");
        if (cl != null) {
            int len = Integer.parseInt(cl.trim()); if (len < 0 || len > 8 * 1024 * 1024) return null;
            byte[] b = new byte[len]; int off = 0; while (off < len) { int k = in.read(b, off, len - off); if (k < 0) return null; off += k; }
            r.body = b;
        }
        return r;
    }
    private static String readLine(InputStream in) throws IOException {
        ByteArrayOutputStream b = new ByteArrayOutputStream(); int c;
        while ((c = in.read()) >= 0) { if (c == '\n') break; if (c != '\r') b.write(c); if (b.size() > 8192) return null; }
        if (c < 0 && b.size() == 0) return null;
        return b.toString("UTF-8");
    }
    private static void write(OutputStream out, Response r, boolean keep) throws IOException {
        StringBuilder h = new StringBuilder("HTTP/1.1 ").append(r.status).append(' ').append(reason(r.status)).append("\r\n");
        h.append("Content-Type: ").append(r.type).append("\r\nContent-Length: ").append(r.body.length).append("\r\n");
        h.append("X-Content-Type-Options: nosniff\r\nReferrer-Policy: no-referrer\r\n");
        for (Map.Entry<String, String> e : r.headers.entrySet()) h.append(e.getKey()).append(": ").append(e.getValue()).append("\r\n");
        h.append("Connection: ").append(keep ? "keep-alive" : "close").append("\r\n\r\n");
        out.write(h.toString().getBytes(StandardCharsets.UTF_8)); out.write(r.body); out.flush();
    }
    private static String reason(int s) { switch (s) { case 200: return "OK"; case 400: return "Bad Request"; case 401: return "Unauthorized"; case 403: return "Forbidden"; case 404: return "Not Found"; case 429: return "Too Many Requests"; default: return s >= 500 ? "Server Error" : "OK"; } }
    static String mime(String p) {
        String e = p.substring(p.lastIndexOf('.') + 1).toLowerCase(Locale.US);
        switch (e) {
            case "html": return "text/html; charset=utf-8"; case "css": return "text/css; charset=utf-8"; case "js": return "application/javascript; charset=utf-8";
            case "json": return "application/json"; case "png": return "image/png"; case "jpg": case "jpeg": return "image/jpeg"; case "svg": return "image/svg+xml";
            case "ttf": return "font/ttf"; case "woff2": return "font/woff2"; case "ico": return "image/x-icon"; case "wav": return "audio/wav";
            default: return "application/octet-stream";
        }
    }

    // ---- tiny JSON helpers (the API side uses org.json; these keep this class host-testable) ----
    public static String quote(String s) {
        if (s == null) return "null";
        StringBuilder b = new StringBuilder("\"");
        for (char ch : s.toCharArray()) {
            switch (ch) { case '"': b.append("\\\""); break; case '\\': b.append("\\\\"); break; case '\n': b.append("\\n"); break; case '\r': b.append("\\r"); break; case '\t': b.append("\\t"); break;
                default: if (ch < 0x20) b.append(String.format("\\u%04x", (int) ch)); else b.append(ch); }
        }
        return b.append('"').toString();
    }
    static String jsonField(String json, String key) {
        int i = json.indexOf("\"" + key + "\""); if (i < 0) return null;
        int c = json.indexOf(':', i); if (c < 0) return null;
        int s = json.indexOf('"', c + 1); if (s < 0) return null;
        int e = json.indexOf('"', s + 1); if (e < 0) return null;
        return json.substring(s + 1, e);
    }
    /** A fresh PIN: 8 characters from an alphabet without look-alikes. */
    public static String newPin() {
        String a = "ABCDEFGHJKLMNPQRSTUVWXYZ23456789"; SecureRandom r = new SecureRandom(); StringBuilder b = new StringBuilder();
        for (int i = 0; i < 8; i++) b.append(a.charAt(r.nextInt(a.length())));
        return b.toString();
    }
    /** Drop sessions idle for longer than {@link #SESSION_IDLE_MS}. */
    public void prune() { long now = System.currentTimeMillis(); for (Iterator<Map.Entry<String, Long>> it = sessions.entrySet().iterator(); it.hasNext(); ) if (now - it.next().getValue() > SESSION_IDLE_MS) it.remove(); }
}
