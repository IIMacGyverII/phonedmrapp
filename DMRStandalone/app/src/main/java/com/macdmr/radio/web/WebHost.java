package com.macdmr.radio.web;

import android.content.Context;
import android.content.SharedPreferences;
import android.os.Handler;
import android.os.Looper;

import com.macdmr.radio.ChannelStore;
import com.macdmr.radio.RadioService;
import com.macdmr.radio.pkt.PacketStore;

import org.json.JSONArray;
import org.json.JSONObject;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.InputStream;
import java.net.Inet4Address;
import java.net.InetAddress;
import java.net.NetworkInterface;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;
import java.util.concurrent.Callable;
import java.util.concurrent.FutureTask;
import java.util.concurrent.TimeUnit;

/**
 * SignalDeck Web on the phone: owns the {@link WebServer}, answers its JSON API from the running {@link RadioService}
 * (writes run on the main thread, like the phone UI's), and turns the service's listener callbacks into live events.
 * Settings live in prefs "web": enabled, pin, tx (transmit from the web), port.
 */
public final class WebHost {
    public static final int DEFAULT_PORT = 8080;
    private static final String TX_OFF = "Transmit from the web is off (phone: Device → SignalDeck Web)";
    private final RadioService svc;
    private final Handler ui = new Handler(Looper.getMainLooper());
    private volatile WebServer server;
    private volatile Thread ticker;
    private volatile String lastError;

    public WebHost(RadioService svc) { this.svc = svc; }

    private SharedPreferences prefs() { return svc.getSharedPreferences("web", Context.MODE_PRIVATE); }
    public boolean enabled() { return prefs().getBoolean("enabled", false); }
    public boolean allowTx() { return prefs().getBoolean("tx", false); }
    public void setAllowTx(boolean on) { prefs().edit().putBoolean("tx", on).apply(); }
    public int port() { return prefs().getInt("port", DEFAULT_PORT); }
    public String pin() {
        String p = prefs().getString("pin", null);
        if (p == null) { p = WebServer.newPin(); prefs().edit().putString("pin", p).apply(); }
        return p;
    }
    /** A new PIN logs every browser out. */
    public void newPin() { prefs().edit().putString("pin", WebServer.newPin()).apply(); if (running()) { stop(); start(); } }
    public boolean running() { WebServer s = server; return s != null && s.running(); }
    public int clients() { WebServer s = server; return s == null ? 0 : s.clients(); }
    public int listeners() { WebServer s = server; return s == null ? 0 : s.audioClients(); }
    /** Received audio for the browsers that are listening (8 kHz mono 16-bit). */
    public void rxAudio(byte[] mono, int n) { WebServer s = server; if (s != null) s.publishAudio(mono, n); }
    public String lastError() { return lastError; }

    /** Turn the web server on or off (and remember it). Returns null or an error. */
    public String setEnabled(boolean on) {
        prefs().edit().putBoolean("enabled", on).apply();
        if (on) return start();
        stop(); return null;
    }

    public synchronized String start() {
        if (running()) return null;
        WebServer s = new WebServer(port(), pin(), this::asset, this::api);
        try { s.start(); } catch (Exception e) { lastError = "Port " + port() + ": " + e.getMessage(); return lastError; }
        server = s; lastError = null;
        ui.post(() -> svc.addListener(events));
        Thread t = new Thread(this::tick, "web-tick"); t.setDaemon(true); ticker = t; t.start();
        return null;
    }
    public synchronized void stop() {
        WebServer s = server; server = null;
        if (s != null) s.stop();
        Thread t = ticker; ticker = null; if (t != null) t.interrupt();
        ui.post(() -> svc.removeListener(events));
    }

    /** The addresses a browser on the same network can use. */
    public List<String> urls() {
        java.util.ArrayList<String> out = new java.util.ArrayList<>();
        try {
            for (NetworkInterface ni : Collections.list(NetworkInterface.getNetworkInterfaces())) {
                if (!ni.isUp() || ni.isLoopback()) continue;
                for (InetAddress a : Collections.list(ni.getInetAddresses()))
                    if (a instanceof Inet4Address && a.isSiteLocalAddress()) out.add("http://" + a.getHostAddress() + (port() == 80 ? "" : ":" + port()));
            }
        } catch (Exception ignored) { }
        return out;
    }

    // ---- static files: assets/web/, fonts from assets/fonts/ ----
    private byte[] asset(String path) throws java.io.IOException {
        String p = path.startsWith("fonts/") ? path : "web/" + path;
        try (InputStream in = svc.getAssets().open(p)) { return readAll(in); } catch (FileNotFoundException e) { return null; }
    }
    private static byte[] readAll(InputStream in) throws java.io.IOException {
        ByteArrayOutputStream b = new ByteArrayOutputStream(); byte[] buf = new byte[16384]; int n;
        while ((n = in.read(buf)) > 0) b.write(buf, 0, n);
        return b.toByteArray();
    }

    // ---- live events ----
    private final RadioService.Listener events = new RadioService.Listener() {
        private long lastRssi, lastLevel;
        @Override public void onChannel(ChannelStore.Channel ch) { pub("channel", channelJson(ch)); }
        @Override public void onRx(boolean r) { pub("rx", "{\"on\":" + r + "}"); }
        @Override public void onTx(boolean t) { pub("tx", "{\"on\":" + t + "}"); }
        @Override public void onRssi(int dbm) { long now = System.currentTimeMillis(); if (now - lastRssi < 400) return; lastRssi = now; pub("rssi", "{\"dbm\":" + dbm + "}"); }
        @Override public void onAudioLevel(int amp) { long now = System.currentTimeMillis(); if (now - lastLevel < 100) return; lastLevel = now; pub("level", "{\"amp\":" + amp + "}"); }
        @Override public void onHistory(String line) { pub("history", "{\"line\":" + WebServer.quote(line) + "}"); }
        @Override public void onCaller(String text) { pub("caller", "{\"text\":" + WebServer.quote(text) + "}"); }
        @Override public void onLog(String s) { }
        @Override public void onLink(String state) { pub("link", "{\"state\":" + WebServer.quote(state) + "}"); }
        @Override public void onLocation(String text) { pub("location", "{\"text\":" + WebServer.quote(text) + "}"); }
        @Override public void onSms(int from, int type, String text) { pub("sms", "{\"from\":" + from + ",\"type\":" + type + ",\"text\":" + WebServer.quote(text) + "}"); }
        @Override public void onSmsResult(boolean ok) { pub("smsResult", "{\"ok\":" + ok + "}"); }
        @Override public void onModes(boolean softSq, int level, boolean open, boolean mon, boolean rec, boolean scan, boolean hold, String zone) {
            pub("modes", "{\"softSq\":" + softSq + ",\"softSqLevel\":" + level + ",\"squelchOpen\":" + open + ",\"monitor\":" + mon + ",\"record\":" + rec
                    + ",\"scanning\":" + scan + ",\"holding\":" + hold + ",\"zone\":" + WebServer.quote(zone) + "}");
        }
        @Override public void onCaption(boolean enabled, String live, String sentence) {
            pub("caption", "{\"enabled\":" + enabled + ",\"live\":" + WebServer.quote(live) + ",\"sentence\":" + WebServer.quote(sentence) + "}");
        }
    };
    private void pub(String type, String json) { WebServer s = server; if (s != null) s.publish(type, json); }

    /** Every 2 s while a browser is connected: the S-meter poll, the satellite card, mode state and new packets. */
    private void tick() {
        long aprsSeen = -1; String sstvSeen = null;
        while (Thread.currentThread() == ticker) {
            try { Thread.sleep(2000); } catch (InterruptedException e) { return; }
            if (clients() == 0) continue;
            try {
                svc.pollRssi();
                pub("sat", satJson().toString());
                pub("mode", modeJson().toString());
                com.macdmr.radio.PacketEngine p = svc.packet();
                if (p != null) {
                    long ch = p.store().changes();
                    if (ch != aprsSeen) { aprsSeen = ch; pub("aprs", "{\"changes\":" + ch + "}"); }
                    JSONObject s = sstvJson(); String st = s.toString();
                    if (!st.equals(sstvSeen) || p.sstvRx()) { sstvSeen = st; pub("sstv", st); }
                }
            } catch (Throwable ignored) { }
        }
    }

    // ---- JSON ----
    private static String channelJson(ChannelStore.Channel ch) { try { return channelObj(ch).toString(); } catch (Exception e) { return "{}"; } }
    private static JSONObject channelObj(ChannelStore.Channel ch) throws Exception {
        JSONObject o = new JSONObject();
        if (ch == null) return o;
        o.put("number", ch.number).put("name", ch.name).put("digital", ch.isDigital()).put("rxFreq", ch.rxFreq).put("txFreq", ch.txFreq)
                .put("power", ch.power).put("band", ch.band).put("cc", ch.cc).put("slot", ch.inSlot).put("txContact", ch.txContact)
                .put("rxType", ch.rxType).put("rxSubCode", ch.rxSubCode).put("txType", ch.txType).put("txSubCode", ch.txSubCode).put("location", ch.location);
        if (ch.lat != 0 || ch.lon != 0) o.put("lat", ch.lat).put("lon", ch.lon);
        return o;
    }
    /** Every field the channel editor has (the encrypt key itself stays on the phone: only whether one is set). */
    private static JSONObject channelFull(ChannelStore.Channel ch) throws Exception {
        JSONObject o = channelObj(ch);
        o.put("type", ch.type).put("relay", ch.relay).put("mode", ch.mode).put("contactType", ch.contactType).put("encryptSw", ch.encryptSw)
                .put("hasKey", ch.encryptKey != null && !ch.encryptKey.isEmpty()).put("interrupt", ch.interrupt).put("sq", ch.sq)
                .put("softSq", ch.softSq).put("softSqLevel", ch.softSqLevel);
        JSONArray g = new JSONArray(); for (int x : ch.groups) g.put(x); o.put("groups", g);
        return o;
    }
    /** The phone editor's checks (ChannelEditorView.apply), applied to a JSON body; returns null or the problem. */
    static String applyChannel(ChannelStore.Channel ch, JSONObject b) {
        try {
            ch.name = b.optString("name", ch.name).trim();
            ch.type = b.optInt("type", ch.type) == 0 ? 0 : 1;
            ch.txFreq = (int) Math.round(b.getDouble("txMHz") * 1e6);
            ch.rxFreq = (int) Math.round(b.getDouble("rxMHz") * 1e6);
            if (ch.rxFreq < 136_000_000 || ch.rxFreq > 480_000_000 || ch.txFreq < 136_000_000 || ch.txFreq > 480_000_000) return "Frequencies must be 136–174 or 400–480 MHz";
            ch.power = b.optInt("power", ch.power) == 1 ? 1 : 0;
            ch.relay = b.optInt("relay", ch.relay) == 1 ? 1 : 2;
            String la = b.optString("lat", "").trim(), lo = b.optString("lon", "").trim();
            if (la.isEmpty() && lo.isEmpty()) { ch.lat = 0; ch.lon = 0; }
            else {
                ch.lat = Double.parseDouble(la); ch.lon = Double.parseDouble(lo);
                if (Math.abs(ch.lat) > 90 || Math.abs(ch.lon) > 180) return "Latitude must be within ±90 and longitude within ±180";
            }
            if (ch.isDigital()) {
                ch.cc = Math.max(0, Math.min(15, b.optInt("cc", ch.cc)));
                ch.mode = b.optInt("mode", ch.mode) == 4 ? 4 : 0;
                ch.inSlot = ch.outSlot = b.optInt("slot", ch.inSlot) == 1 ? 1 : 0;
                ch.contactType = Math.max(0, Math.min(2, b.optInt("contactType", ch.contactType)));
                String call = b.optString("txContact", "").trim();
                ch.txContact = call.isEmpty() ? 0 : Integer.parseInt(call);
                if (ch.txContact < 0 || ch.txContact > 0xFFFFFF) return "The call number must be a DMR ID or talkgroup (1 to 16777215)";
                java.util.List<Integer> g = new java.util.ArrayList<>();
                for (String s : b.optString("groups", "").split("[,; ]+")) { s = s.trim(); if (!s.isEmpty()) g.add(Integer.parseInt(s)); }
                // the radio passes a group call only if its talkgroup is in this list (measured on air 2026-10-15): include the call target
                if (ch.contactType == 1 && ch.txContact > 0 && !g.contains(ch.txContact)) g.add(0, ch.txContact);
                if (g.size() > 32) return "At most 32 talkgroups in the RX list (including the call number)";
                ch.groups = new int[g.size()]; for (int i = 0; i < g.size(); i++) ch.groups[i] = g.get(i);
                ch.encryptSw = b.optInt("encryptSw", ch.encryptSw) == 1 ? 1 : 2;
                if (b.has("encryptKey")) ch.encryptKey = b.getString("encryptKey");            // absent: keep the stored key
                if (ch.encryptSw == 1 && (ch.encryptKey == null || ch.encryptKey.length() != 8)) return "Encrypt key must be exactly 8 characters";
                ch.interrupt = b.optInt("interrupt", ch.interrupt) == 1 ? 1 : 2;
            } else {
                ch.band = b.optInt("band", ch.band) == 0 ? 0 : 1;
                ch.softSq = b.optBoolean("softSq", ch.softSq);
                ch.softSqLevel = Math.max(1, Math.min(9, b.optInt("softSqLevel", ch.softSqLevel)));
                ch.sq = Math.max(0, Math.min(9, b.optInt("sq", ch.sq)));
                ch.txType = Math.max(0, Math.min(2, b.optInt("txType", ch.txType)));
                ch.rxType = Math.max(0, Math.min(2, b.optInt("rxType", ch.rxType)));
                int nTx = ch.txType == 1 ? com.macdmr.radio.dsp.ToneTable.CTCSS.length : 104, nRx = ch.rxType == 1 ? com.macdmr.radio.dsp.ToneTable.CTCSS.length : 104;
                ch.txSubCode = ch.txType == 0 ? 0 : Math.max(0, Math.min(nTx - 1, b.optInt("txSubCode", 0)));
                ch.rxSubCode = ch.rxType == 0 ? 0 : Math.max(0, Math.min(nRx - 1, b.optInt("rxSubCode", 0)));
            }
            if (ch.rxFreq < 300_000_000) ch.band = 1;                                  // VHF must be wide on this radio
            return null;
        } catch (NumberFormatException e) {
            return "Check the numbers: " + e.getMessage();
        } catch (Exception e) {
            return e.getMessage() == null ? e.toString() : e.getMessage();
        }
    }
    private static JSONObject toneLists() throws Exception {
        JSONArray c = new JSONArray(); for (int i = 0; i < com.macdmr.radio.dsp.ToneTable.CTCSS.length; i++) c.put(com.macdmr.radio.dsp.ToneTable.ctcssLabel(i));
        JSONArray d = new JSONArray(); for (int i = 0; i < 104; i++) d.put(String.format(java.util.Locale.US, "DCS D%03oN", i));
        return new JSONObject().put("ctcss", c).put("dcs", d);
    }
    private JSONObject statusJson() throws Exception {
        JSONObject o = new JSONObject();
        o.put("link", svc.link()).put("ready", svc.isReady()).put("channel", channelObj(svc.current()));
        o.put("transmitting", svc.isTransmitting()).put("hearing", svc.hearing()).put("rssi", svc.lastRssi()).put("caller", svc.currentCaller());
        o.put("softSq", svc.softSqOn()).put("softSqLevel", svc.softSqLevel()).put("monitor", svc.monitorOn()).put("record", svc.recordOn())
                .put("scanning", svc.scanning()).put("vfo", svc.vfoActive()).put("zone", svc.zoneName()).put("zoneId", svc.zoneId())
                .put("txInhibited", svc.txInhibited()).put("webTx", allowTx());
        o.put("mode", modeJson()).put("sat", satJson()).put("sstv", sstvJson());
        o.put("version", com.macdmr.radio.BuildConfig.VERSION_NAME);
        return o;
    }
    private JSONObject modeJson() throws Exception {
        JSONObject o = new JSONObject();
        com.macdmr.radio.PacketEngine p = svc.packet();
        o.put("active", svc.packetActive()).put("since", svc.modeSince());
        if (p != null) o.put("aprs", p.monitoring()).put("sstv", p.sstvRx()).put("kiss", p.kiss().isActive());
        o.put("parrot", svc.parrot().enabled());
        return o;
    }
    private JSONObject satJson() throws Exception {
        JSONObject o = new JSONObject();
        RadioService.SatState s = svc.satState();
        o.put("tracking", s != null).put("repeat", svc.issRepeat());
        if (s == null) return o;
        o.put("name", s.name).put("mode", s.mode).put("rxHz", s.rxHz).put("txHz", s.txHz).put("nominalHz", s.nominalHz).put("aos", s.aos).put("los", s.los)
                .put("maxEl", s.maxEl).put("waiting", s.waiting).put("listenOnly", s.listenOnly);
        if (s.look != null) o.put("el", s.look.el).put("az", s.look.az).put("rangeKm", s.look.rangeKm);
        return o;
    }
    private JSONObject sstvJson() throws Exception {
        com.macdmr.radio.PacketEngine p = svc.packet();
        JSONObject o = new JSONObject();
        if (p == null) return o;
        android.graphics.Bitmap b = p.sstvLast();
        o.put("on", p.sstvRx()).put("status", p.sstvStatus()).put("picture", b != null).put("stamp", b == null ? "" : System.identityHashCode(b) + "_" + b.getGenerationId());
        return o;
    }

    private <T> T onMain(Callable<T> c) throws Exception {
        if (Looper.myLooper() == Looper.getMainLooper()) return c.call();
        FutureTask<T> f = new FutureTask<>(c); ui.post(f); return f.get(5, TimeUnit.SECONDS);
    }
    private static WebServer.Response ok(JSONObject o) { return WebServer.Response.json(200, o.toString()); }
    private static WebServer.Response ok(String msg) { return WebServer.Response.json(200, "{\"ok\":true,\"message\":" + WebServer.quote(msg) + "}"); }
    private static JSONObject body(WebServer.Request r) { try { return r.body.length == 0 ? new JSONObject() : new JSONObject(r.bodyText()); } catch (Exception e) { return new JSONObject(); } }
    private static final String DEFAULT_QUICK = "QSL\nCopy, I will call you back\nOn my way\nWhere are you?\nSwitch to the other channel\nAll OK here";
    private List<String> quickReplies() {
        java.util.ArrayList<String> out = new java.util.ArrayList<>();
        for (String q : svc.getSharedPreferences("radio", Context.MODE_PRIVATE).getString("quickReplies", DEFAULT_QUICK).split("\n")) if (!q.trim().isEmpty()) out.add(q.trim());
        return out;
    }
    private static int parse(String s, int def) { try { return s == null ? def : Integer.parseInt(s); } catch (Exception e) { return def; } }
    private File sstvDir() { return new File(android.os.Environment.getExternalStoragePublicDirectory(android.os.Environment.DIRECTORY_DOWNLOADS), "DMR/SSTV"); }

    // ---- the API ----
    private WebServer.Response api(WebServer.Request r) throws Exception {
        String p = r.path; boolean post = "POST".equals(r.method);
        final JSONObject b = post ? body(r) : new JSONObject();
        switch (p) {
            case "/api/status": return ok(statusJson());
            case "/api/history": {
                ChannelStore.Channel ch = svc.current(); int lim = Math.min(500, parse(r.param("limit"), 120));
                JSONArray a = new JSONArray(); if (ch != null) for (String l : svc.store().recentHistory(ch.number, lim)) a.put(l);
                return ok(new JSONObject().put("lines", a));
            }
            case "/api/channels": {
                JSONArray a = new JSONArray(); for (ChannelStore.Channel ch : svc.zoneChannels()) a.put(channelObj(ch));
                JSONArray z = new JSONArray(); z.put(new JSONObject().put("id", 0).put("name", "ALL"));
                for (ChannelStore.Zone zz : svc.store().zones()) z.put(new JSONObject().put("id", zz.id).put("name", zz.name));
                return ok(new JSONObject().put("channels", a).put("zones", z).put("zoneId", svc.zoneId()));
            }
            case "/api/channel/select": if (!post) break; {
                int n = b.optInt("number", -1); if (n < 0) return WebServer.Response.error(400, "number needed");
                onMain(() -> { svc.selectChannel(n); return null; }); return ok("Channel " + n);
            }
            case "/api/channel/step": if (!post) break; { int d = b.optInt("delta", 1); onMain(() -> { svc.stepChannel(d >= 0 ? 1 : -1); return null; }); return ok("stepped"); }
            case "/api/zone": if (!post) break; { long id = b.optLong("id", 0); onMain(() -> { svc.setZone(id); return null; }); return ok(svc.zoneName()); }
            case "/api/scan": if (!post) break; return ok(onMain(svc::toggleScan));
            case "/api/softsq": if (!post) break;
                onMain(() -> { if (b.has("on")) svc.setSoftSq(b.getBoolean("on")); if (b.has("level")) svc.setSoftSqLevel(b.getInt("level")); return null; });
                return ok(statusJson());
            case "/api/monitor": if (!post) break; onMain(() -> { svc.setMonitor(b.optBoolean("on", !svc.monitorOn())); return null; }); return ok(statusJson());
            case "/api/record": if (!post) break; onMain(() -> { svc.setRecord(b.optBoolean("on", !svc.recordOn())); return null; }); return ok(statusJson());
            case "/api/ptt": if (!post) break; {
                boolean down = b.optBoolean("down", false);
                if (down && !allowTx()) return WebServer.Response.error(403, TX_OFF);
                RadioService.SatState s = svc.satState();
                if (down && s != null && s.listenOnly) return WebServer.Response.error(409, "Receive only during this satellite pass");
                if (down) svc.history("warn", "🌐 Transmitting from the web (" + r.remote + ")");
                onMain(() -> { svc.ptt(down); return null; });
                return ok(down ? "PTT down" : "PTT up");
            }
            case "/api/aprs/log": {
                JSONArray a = new JSONArray();
                if (svc.packet() != null) for (PacketStore.LogEntry e : svc.packet().store().aprsLog(Math.min(500, parse(r.param("limit"), 200))))
                    a.put(new JSONObject().put("ts", e.ts).put("kind", e.kind).put("from", e.from).put("to", e.to).put("text", e.text).put("mine", e.mine));
                return ok(new JSONObject().put("log", a));
            }
            case "/api/aprs/stations": {
                JSONArray a = new JSONArray();
                if (svc.packet() != null) for (PacketStore.Station s : svc.packet().store().stations(Math.min(500, parse(r.param("limit"), 200)))) {
                    JSONObject o = new JSONObject().put("call", s.call).put("lastTs", s.lastTs).put("count", s.count).put("comment", s.comment).put("via", s.via)
                            .put("sym", String.valueOf(s.symTable) + s.symCode);
                    if (s.lat != 0 || s.lon != 0) o.put("lat", s.lat).put("lon", s.lon);
                    if (s.speedKmh >= 0) o.put("speedKmh", s.speedKmh);
                    if (s.courseDeg >= 0) o.put("course", s.courseDeg);
                    if (s.alt != 0) o.put("alt", s.alt);
                    a.put(o);
                }
                return ok(new JSONObject().put("stations", a));
            }
            case "/api/aprs/monitor": if (!post) break; return ok(onMain(() -> svc.aprsMonitor(b.optBoolean("on", true))));
            case "/api/aprs/message": if (!post) break; {
                if (!allowTx()) return WebServer.Response.error(403, TX_OFF);
                String to = b.optString("to", "").trim(), text = b.optString("text", "").trim();
                if (to.isEmpty() || text.isEmpty()) return WebServer.Response.error(400, "To and text are needed");
                String e = onMain(() -> svc.packet().sendMessage(to, text));
                return e == null ? ok("Message to " + to + " queued") : WebServer.Response.error(409, e);
            }
            case "/api/aprs/beacon": if (!post) break; {
                if (!allowTx()) return WebServer.Response.error(403, TX_OFF);
                String e = onMain(() -> svc.packet().sendBeacon());
                return e == null ? ok("Beacon sent") : WebServer.Response.error(409, e);
            }
            case "/api/sstv": return ok(sstvJson());
            case "/api/sstv/monitor": if (!post) break; return ok(String.valueOf(onMain(() -> svc.sstvMonitor(b.optBoolean("on", true), false))));
            case "/api/sstv/live.png": {
                android.graphics.Bitmap bm = svc.packet() == null ? null : svc.packet().sstvLast();
                if (bm == null) return WebServer.Response.error(404, "No picture yet");
                ByteArrayOutputStream o = new ByteArrayOutputStream(); bm.compress(android.graphics.Bitmap.CompressFormat.PNG, 100, o);
                WebServer.Response x = WebServer.Response.bytes("image/png", o.toByteArray()); x.headers.put("Cache-Control", "no-store"); return x;
            }
            case "/api/sstv/pictures": {
                File[] fs = sstvDir().listFiles((d, n) -> n.endsWith(".png") || n.endsWith(".jpg"));
                JSONArray a = new JSONArray();
                if (fs != null) {
                    Arrays.sort(fs, (x, y) -> Long.compare(y.lastModified(), x.lastModified()));
                    for (File f : fs) a.put(new JSONObject().put("name", f.getName()).put("ts", f.lastModified()).put("size", f.length()));
                }
                return ok(new JSONObject().put("pictures", a));
            }
            case "/api/sstv/picture": {
                String n = r.param("name");
                if (n == null || n.contains("/") || n.contains("\\") || n.contains("..")) return WebServer.Response.error(400, "Bad name");
                File f = new File(sstvDir(), n); if (!f.isFile()) return WebServer.Response.error(404, "Not found");
                byte[] data; try (InputStream in = new java.io.FileInputStream(f)) { data = readAll(in); }
                return WebServer.Response.bytes(n.endsWith(".png") ? "image/png" : "image/jpeg", data);
            }
            case "/api/iss": if (!post) break; {
                String m = b.optString("mode", "");
                if (m.equals("stop")) { onMain(() -> { svc.endSatTracking(); return null; }); return ok("Stopped tracking"); }
                int mode = m.equals("sstv") ? com.macdmr.radio.ham.Satellites.SSTV : m.equals("aprs") ? com.macdmr.radio.ham.Satellites.APRS : -1;
                if (mode < 0) return WebServer.Response.error(400, "mode: aprs, sstv or stop");
                String e = onMain(() -> { String err = svc.startIssMode(mode); if (err == null) svc.setIssRepeat(mode); return err; });
                return e == null ? ok("Tracking the ISS (" + m + ")") : WebServer.Response.error(409, e);
            }
            case "/api/channel": {                                              // one channel with everything the editor needs (number 0: a new one)
                int n = parse(r.param("number"), 0);
                ChannelStore.Channel ch = n > 0 ? svc.store().byNumber(n) : null;
                if (n > 0 && ch == null) return WebServer.Response.error(404, "No channel " + n);
                if (ch == null) {
                    ch = new ChannelStore.Channel(); ChannelStore.Channel cur = svc.current();
                    if (cur != null) { ch.type = cur.type; ch.rxFreq = cur.rxFreq; ch.txFreq = cur.txFreq; }
                }
                JSONObject help = new JSONObject(); for (String[] h : com.macdmr.radio.ui.ChannelEditorView.helpForWeb()) help.put(h[0], h[1]);
                return ok(new JSONObject().put("channel", channelFull(ch)).put("isNew", n <= 0).put("help", help).put("tones", toneLists()));
            }
            case "/api/channel/save": if (!post) break; {
                int n = b.optInt("number", 0);
                ChannelStore.Channel ch = n > 0 ? svc.store().byNumber(n) : new ChannelStore.Channel();
                if (ch == null) return WebServer.Response.error(404, "No channel " + n);
                String err = applyChannel(ch, b);
                if (err != null) return WebServer.Response.error(400, err);
                final ChannelStore.Channel c = ch; final boolean isNew = n <= 0;
                onMain(() -> { svc.saveChannel(c, isNew); return null; });
                return WebServer.Response.json(200, new JSONObject().put("ok", true).put("message", "Saved " + (c.name.isEmpty() ? "channel " + c.number : c.name)).put("number", c.number).toString());
            }
            case "/api/channel/delete": if (!post) break; {
                ChannelStore.Channel ch = svc.store().byNumber(b.optInt("number", 0));
                if (ch == null) return WebServer.Response.error(404, "No such channel");
                if (svc.isTransmitting()) return WebServer.Response.error(409, "Not while transmitting");
                onMain(() -> { svc.deleteChannel(ch); return null; });
                return ok("Deleted " + (ch.name.isEmpty() ? "channel " + ch.number : ch.name));
            }
            case "/api/help": {
                JSONArray a = new JSONArray();
                for (String[] t : com.macdmr.radio.ui.HelpView.topicsForWeb()) {
                    JSONArray secs = new JSONArray(); for (int i = 3; i + 1 < t.length; i += 2) secs.put(new JSONObject().put("head", t[i]).put("text", t[i + 1]));
                    a.put(new JSONObject().put("group", t[0]).put("title", t[1]).put("summary", t[2]).put("sections", secs));
                }
                return ok(new JSONObject().put("topics", a));
            }
            case "/api/contacts": {
                if (post) {                                                     // create or update {id?, name, number, type}
                    ChannelStore.Contact ct = new ChannelStore.Contact();
                    ct.id = b.optLong("id", 0); ct.name = b.optString("name", "").trim(); ct.number = b.optInt("number", 0); ct.type = b.optInt("type", 0);
                    if (ct.number <= 0 || ct.number > 0xFFFFFF) return WebServer.Response.error(400, "The DMR ID must be 1 to 16777215");
                    if (ct.type < 0 || ct.type > 2) return WebServer.Response.error(400, "type: 0 private, 1 group, 2 all");
                    if (ct.id > 0) svc.store().updateContact(ct); else svc.store().insertContact(ct);
                    return ok("Saved " + (ct.name.isEmpty() ? String.valueOf(ct.number) : ct.name));
                }
                JSONArray a = new JSONArray();
                for (ChannelStore.Contact ct : svc.store().contacts()) a.put(new JSONObject().put("id", ct.id).put("name", ct.name).put("number", ct.number).put("type", ct.type));
                return ok(new JSONObject().put("contacts", a));
            }
            case "/api/contacts/delete": if (!post) break; {
                long id = b.optLong("id", 0);
                for (ChannelStore.Contact ct : svc.store().contacts()) if (ct.id == id) { svc.store().deleteContact(ct); return ok("Deleted " + (ct.name.isEmpty() ? String.valueOf(ct.number) : ct.name)); }
                return WebServer.Response.error(404, "No such contact");
            }
            case "/api/conversations": {
                JSONArray a = new JSONArray();
                for (ChannelStore.Conversation c : svc.store().conversations())
                    a.put(new JSONObject().put("peer", c.peer).put("type", c.type).put("name", c.name).put("lastText", c.lastText).put("lastTs", c.lastTs).put("outgoing", c.outgoing));
                return ok(new JSONObject().put("conversations", a).put("quickReplies", new JSONArray(quickReplies())));
            }
            case "/api/messages": {
                if (post) {                                                     // send {peer, type, text}
                    if (!allowTx()) return WebServer.Response.error(403, TX_OFF);
                    String text = b.optString("text", "").trim(); int peer = b.optInt("peer", 0), type = b.optInt("type", 0);
                    if (text.isEmpty() || peer <= 0) return WebServer.Response.error(400, "A recipient and a text are needed");
                    if (text.length() > 140) return WebServer.Response.error(400, "Texts are at most 140 characters");
                    if (!svc.isReady()) return WebServer.Response.error(409, "The radio is not ready");
                    ChannelStore.Contact to = new ChannelStore.Contact(); to.number = peer; to.type = type;
                    String nm = svc.store().contactName(peer, type); to.name = nm == null ? "" : nm;
                    onMain(() -> { svc.sendSms(to, text); return null; });
                    return ok("Sending to " + (to.name.isEmpty() ? String.valueOf(peer) : to.name));
                }
                int peer = parse(r.param("peer"), 0), type = parse(r.param("type"), 0);
                JSONArray a = new JSONArray();
                for (ChannelStore.Message m : svc.store().messages(peer, type))
                    a.put(new JSONObject().put("id", m.id).put("outgoing", m.outgoing).put("ts", m.ts).put("text", m.text).put("status", m.status));
                return ok(new JSONObject().put("messages", a));
            }
            default: break;
        }
        return null;
    }
}
