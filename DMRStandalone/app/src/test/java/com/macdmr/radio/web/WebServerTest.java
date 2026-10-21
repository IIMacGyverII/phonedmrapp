package com.macdmr.radio.web;

import static org.junit.Assert.*;

import org.junit.Test;

import java.io.ByteArrayInputStream;
import java.net.InetAddress;
import java.nio.charset.StandardCharsets;

public class WebServerTest {
    private static WebServer.Request parse(String raw) throws Exception {
        return WebServer.read(new ByteArrayInputStream(raw.getBytes(StandardCharsets.UTF_8)));
    }
    private static WebServer server() {
        return new WebServer(0, "ABCD2345", p -> p.equals("index.html") ? "<html>".getBytes() : null,
                r -> r.path.equals("/api/ping") ? WebServer.Response.json(200, "{\"pong\":true}") : null);
    }

    @Test public void parsesRequestLineHeadersQueryAndBody() throws Exception {
        WebServer.Request r = parse("POST /api/x%20y?limit=5&name=a%2Fb HTTP/1.1\r\nHost: h\r\nContent-Length: 7\r\nCookie: a=1; sd_session=tok\r\n\r\n{\"a\":1}");
        assertEquals("POST", r.method); assertEquals("/api/x y", r.path);
        assertEquals("5", r.param("limit")); assertEquals("a/b", r.param("name")); assertNull(r.param("nope"));
        assertEquals("{\"a\":1}", r.bodyText()); assertEquals("h", r.headers.get("host"));
    }

    @Test public void rejectsHugeBodies() throws Exception {
        assertNull(parse("POST / HTTP/1.1\r\nContent-Length: 999999999\r\n\r\n"));
    }

    @Test public void apiNeedsLoginAndPinWorks() throws Exception {
        WebServer s = server();
        WebServer.Request r = parse("GET /api/ping HTTP/1.1\r\n\r\n"); r.remote = "192.168.1.5";
        assertEquals(401, s.route(r).status);

        WebServer.Request bad = parse("POST /api/login HTTP/1.1\r\nContent-Length: 14\r\n\r\n{\"pin\":\"NOPE\"}"); bad.remote = "192.168.1.5";
        assertEquals(403, s.route(bad).status);

        String body = "{\"pin\":\"abcd2345\"}";
        WebServer.Request good = parse("POST /api/login HTTP/1.1\r\nContent-Length: " + body.length() + "\r\n\r\n" + body); good.remote = "192.168.1.5";
        WebServer.Response lr = s.route(good);
        assertEquals(200, lr.status);
        String cookie = lr.headers.get("Set-Cookie"); assertTrue(cookie.startsWith("sd_session=")); assertTrue(cookie.contains("HttpOnly"));
        String tok = cookie.substring(11, cookie.indexOf(';'));

        WebServer.Request ok = parse("GET /api/ping HTTP/1.1\r\nCookie: sd_session=" + tok + "\r\n\r\n"); ok.remote = "192.168.1.5";
        WebServer.Response pr = s.route(ok);
        assertEquals(200, pr.status); assertEquals("{\"pong\":true}", new String(pr.body, StandardCharsets.UTF_8));

        WebServer.Request none = parse("GET /api/other HTTP/1.1\r\nCookie: sd_session=" + tok + "\r\n\r\n"); none.remote = "192.168.1.5";
        assertEquals(404, s.route(none).status);
    }

    @Test public void loginIsRateLimited() throws Exception {
        WebServer s = server();
        int last = 0;
        for (int i = 0; i < 7; i++) {
            WebServer.Request bad = parse("POST /api/login HTTP/1.1\r\nContent-Length: 12\r\n\r\n{\"pin\":\"XX\"}"); bad.remote = "10.0.0.9";
            last = s.route(bad).status;
        }
        assertEquals(429, last);
    }

    @Test public void staticFilesFallBackToTheAppAndRefuseTraversal() throws Exception {
        WebServer s = server();
        WebServer.Request r = parse("GET /some/page HTTP/1.1\r\n\r\n"); r.remote = "127.0.0.1";
        WebServer.Response x = s.route(r);
        assertEquals(200, x.status); assertTrue(x.type.startsWith("text/html"));
        WebServer.Request t = parse("GET /../secret HTTP/1.1\r\n\r\n"); t.remote = "127.0.0.1";
        assertEquals(400, s.route(t).status);
    }

    @Test public void onlyLocalNetworksAreServed() throws Exception {
        assertTrue(WebServer.lanAddress(InetAddress.getByName("192.168.1.131")));
        assertTrue(WebServer.lanAddress(InetAddress.getByName("10.1.2.3")));
        assertTrue(WebServer.lanAddress(InetAddress.getByName("127.0.0.1")));
        assertTrue(WebServer.lanAddress(InetAddress.getByName("fd00::1")));
        assertFalse(WebServer.lanAddress(InetAddress.getByName("8.8.8.8")));
        assertFalse(WebServer.lanAddress(InetAddress.getByName("2001:4860::8888")));
    }

    @Test public void loginsSurviveARestartAsHashesAndLogoutEndsThem() throws Exception {
        final java.util.Map<String, Long> disk = new java.util.HashMap<>();
        WebServer.SessionStore store = new WebServer.SessionStore() {
            @Override public java.util.Map<String, Long> load() { return new java.util.HashMap<>(disk); }
            @Override public void save(java.util.Map<String, Long> m) { disk.clear(); disk.putAll(m); }
        };
        WebServer a = new WebServer(0, "ABCD2345", p -> null, r -> WebServer.Response.json(200, "{}"), store);
        String body = "{\"pin\":\"ABCD2345\"}";
        WebServer.Request li = parse("POST /api/login HTTP/1.1\r\nContent-Length: " + body.length() + "\r\n\r\n" + body); li.remote = "10.0.0.2";
        String cookie = a.route(li).headers.get("Set-Cookie"); String tok = cookie.substring(11, cookie.indexOf(';'));
        assertEquals(1, disk.size());
        assertFalse("the token itself is never stored", disk.containsKey(tok));
        assertTrue(disk.containsKey(WebServer.hash(tok)));

        WebServer b = new WebServer(0, "ABCD2345", p -> null, r -> WebServer.Response.json(200, "{}"), store);   // the app restarted
        WebServer.Request q = parse("GET /api/x HTTP/1.1\r\nCookie: sd_session=" + tok + "\r\n\r\n"); q.remote = "10.0.0.2";
        assertEquals(200, b.route(q).status);
        WebServer.Request lo = parse("GET /api/logout HTTP/1.1\r\nCookie: sd_session=" + tok + "\r\n\r\n"); lo.remote = "10.0.0.2";
        b.route(lo);
        assertTrue(disk.isEmpty());
        WebServer.Request q2 = parse("GET /api/x HTTP/1.1\r\nCookie: sd_session=" + tok + "\r\n\r\n"); q2.remote = "10.0.0.2";
        assertEquals(401, new WebServer(0, "ABCD2345", p -> null, r -> WebServer.Response.json(200, "{}"), store).route(q2).status);
    }

    @Test public void webSocketAcceptKeyMatchesTheRfcExample() {
        assertEquals("s3pPLMBiTxaQ9kYGzzhZRbK+xOo=", WebServer.acceptKey("dGhlIHNhbXBsZSBub25jZQ=="));
    }

    @Test public void webSocketNeedsLoginAndSameOriginThenCarriesTextAndBinary() throws Exception {
        WebServer s = new WebServer(18472, "PIN23456", p -> null, r -> null);
        final java.util.List<String> got = new java.util.concurrent.CopyOnWriteArrayList<>();
        s.webSocket("/api/ws/echo", (req, peer) -> new WebServer.WebSocketSession() {
            @Override public void text(String t) { got.add("text:" + t); peer.sendText("echo:" + t); }
            @Override public void binary(byte[] b, int n) { got.add("binary:" + n); }
            @Override public void closed() { got.add("closed"); }
        });
        s.start();
        try {
            String body = "{\"pin\":\"PIN23456\"}";
            WebServer.Request li = parse("POST /api/login HTTP/1.1\r\nContent-Length: " + body.length() + "\r\n\r\n" + body); li.remote = "127.0.0.1";
            String cookie = s.route(li).headers.get("Set-Cookie"); String tok = cookie.substring(11, cookie.indexOf(';'));
            String hs = "GET /api/ws/echo HTTP/1.1\r\nHost: 127.0.0.1:18472\r\nUpgrade: websocket\r\nConnection: Upgrade\r\nSec-WebSocket-Key: dGhlIHNhbXBsZSBub25jZQ==\r\nSec-WebSocket-Version: 13\r\n";
            // no login: refused
            try (java.net.Socket c = new java.net.Socket("127.0.0.1", 18472)) {
                c.getOutputStream().write((hs + "\r\n").getBytes(StandardCharsets.UTF_8));
                assertTrue(new String(c.getInputStream().readNBytes(12), StandardCharsets.UTF_8).startsWith("HTTP/1.1 401"));
            }
            // another site's page: refused
            try (java.net.Socket c = new java.net.Socket("127.0.0.1", 18472)) {
                c.getOutputStream().write((hs + "Cookie: sd_session=" + tok + "\r\nOrigin: http://evil.example\r\n\r\n").getBytes(StandardCharsets.UTF_8));
                assertTrue(new String(c.getInputStream().readNBytes(12), StandardCharsets.UTF_8).startsWith("HTTP/1.1 403"));
            }
            try (java.net.Socket c = new java.net.Socket("127.0.0.1", 18472)) {
                c.setSoTimeout(3000);
                java.io.OutputStream o = c.getOutputStream(); java.io.InputStream in = c.getInputStream();
                o.write((hs + "Cookie: sd_session=" + tok + "\r\nOrigin: http://127.0.0.1:18472\r\n\r\n").getBytes(StandardCharsets.UTF_8));
                StringBuilder head = new StringBuilder(); while (!head.toString().endsWith("\r\n\r\n")) head.append((char) in.read());
                assertTrue(head.toString(), head.toString().startsWith("HTTP/1.1 101") && head.toString().contains("s3pPLMBiTxaQ9kYGzzhZRbK+xOo="));
                byte[] mask = { 1, 2, 3, 4 };
                byte[] t = "down".getBytes(StandardCharsets.UTF_8);
                o.write(new byte[] { (byte) 0x81, (byte) (0x80 | t.length), 1, 2, 3, 4 }); for (int i = 0; i < t.length; i++) o.write(t[i] ^ mask[i & 3]);
                byte[] pcm = new byte[640];
                o.write(new byte[] { (byte) 0x82, (byte) (0x80 | 126), (byte) (pcm.length >> 8), (byte) pcm.length, 1, 2, 3, 4 }); for (int i = 0; i < pcm.length; i++) o.write(pcm[i] ^ mask[i & 3]);
                o.flush();
                assertEquals(0x81, in.read()); int len = in.read();
                assertEquals("echo:down", new String(in.readNBytes(len), StandardCharsets.UTF_8));
                o.write(new byte[] { (byte) 0x88, (byte) 0x80, 1, 2, 3, 4 }); o.flush();
                Thread.sleep(300);
            }
            assertEquals(java.util.Arrays.asList("text:down", "binary:640", "closed"), got);
        } finally { s.stop(); }
    }

    @Test public void quoteEscapes() {
        assertEquals("\"a\\\"b\\\\c\\n\\u0001\"", WebServer.quote("a\"b\\c\n\u0001"));
        assertEquals("null", WebServer.quote(null));
    }

    @Test public void pinsUseTheSafeAlphabet() {
        for (int i = 0; i < 50; i++) { String p = WebServer.newPin(); assertEquals(8, p.length()); assertTrue(p.matches("[A-HJ-NP-Z2-9]{8}")); }
    }

    @Test public void serverRunsAndStreamsEvents() throws Exception {
        WebServer s = new WebServer(18471, "PIN23456", p -> null, r -> null);
        s.start();
        try {
            java.net.Socket c = new java.net.Socket("127.0.0.1", 18471);
            c.getOutputStream().write("GET /api/status HTTP/1.1\r\nConnection: close\r\n\r\n".getBytes(StandardCharsets.UTF_8));
            String resp = new String(c.getInputStream().readAllBytes(), StandardCharsets.UTF_8);
            assertTrue(resp, resp.startsWith("HTTP/1.1 401"));
            c.close();
        } finally { s.stop(); }
    }
}
