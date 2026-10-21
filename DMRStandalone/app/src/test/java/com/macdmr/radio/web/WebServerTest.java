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
