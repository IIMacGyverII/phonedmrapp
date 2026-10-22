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
    public static final int DEFAULT_PORT = 8080, TLS_PORT = 8443;
    private static final int[] VFO_STEPS = { 5000, 6250, 10000, 12500, 25000 };     // VfoDialog.STEPS
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
    public void newPin() { prefs().edit().putString("pin", WebServer.newPin()).remove("sessions").apply(); if (running()) { stop(); start(); } }
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
        WebServer s = new WebServer(port(), pin(), this::asset, this::api, new WebServer.SessionStore() {
            @Override public java.util.Map<String, Long> load() {
                java.util.Map<String, Long> m = new java.util.HashMap<>();
                try { JSONObject o = new JSONObject(prefs().getString("sessions", "{}")); for (java.util.Iterator<String> it = o.keys(); it.hasNext(); ) { String k = it.next(); m.put(k, o.getLong(k)); } } catch (Exception ignored) { }
                return m;
            }
            @Override public void save(java.util.Map<String, Long> m) { prefs().edit().putString("sessions", new JSONObject(m).toString()).apply(); }
        });
        try { s.start(); } catch (Exception e) { lastError = "Port " + port() + ": " + e.getMessage(); return lastError; }
        server = s; lastError = null;
        s.webSocket("/api/ws/talk", (req, peer) -> new TalkSession(req, peer));
        try { s.startTls(TLS_PORT, WebTls.serverFactory()); tlsError = null; }                 // HTTPS: the browser microphone needs it
        catch (Exception e) { tlsError = String.valueOf(e.getMessage()); android.util.Log.w("WebHost", "https: " + e); }
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

    private volatile String tlsError;
    public boolean tlsRunning() { WebServer s = server; return s != null && s.tlsRunning(); }
    public String tlsError() { return tlsError; }
    /** The secure addresses (for talking with the browser's microphone). */
    public List<String> secureUrls() {
        java.util.ArrayList<String> out = new java.util.ArrayList<>();
        for (String u : urls()) out.add(u.replace("http://", "https://").replaceAll(":\\d+$", "") + ":" + TLS_PORT);
        return out;
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
        String p = path.startsWith("fonts/") || path.startsWith("exam/") ? path : "web/" + path;     // the exam pools and figures come straight from the phone's assets
        try (InputStream in = svc.getAssets().open(p)) { return readAll(in); } catch (FileNotFoundException e) { return null; }
    }
    private static byte[] readAll(InputStream in) throws java.io.IOException {
        ByteArrayOutputStream b = new ByteArrayOutputStream(); byte[] buf = new byte[16384]; int n;
        while ((n = in.read(buf)) != -1) if (n > 0) b.write(buf, 0, n);      // a read may return 0 bytes before the end (compressed assets)
        return b.toByteArray();
    }

    // ---- talk: the browser's microphone over a WebSocket ("down" / "up" text, 8 kHz s16le binary audio) ----
    private static volatile TalkSession talker;                           // one talker at a time
    private final class TalkSession implements WebServer.WebSocketSession {
        private final WebServer.Request req; private final WebServer.WebSocketPeer peer;
        private volatile WebTxFeed feed;
        TalkSession(WebServer.Request r, WebServer.WebSocketPeer p) { req = r; peer = p; p.sendText(state("ready", null)); }
        private String state(String st, String err) {
            try { JSONObject o = new JSONObject().put("state", st); if (err != null) o.put("error", err); return o.toString(); } catch (Exception e) { return "{}"; }
        }
        @Override public void text(String t) {
            if ("down".equals(t)) down(); else if ("up".equals(t)) release("released");
        }
        private synchronized void down() {
            if (feed != null) return;
            if (!allowTx()) { peer.sendText(state("rx", TX_OFF)); return; }
            RadioService.SatState sat = svc.satState();
            if (sat != null && sat.listenOnly && !sat.waiting) { peer.sendText(state("rx", "Receive only during this satellite pass")); return; }
            if (svc.txInhibited()) { peer.sendText(state("rx", "This channel is receive-only")); return; }
            if (!svc.isReady()) { peer.sendText(state("rx", "The radio is not ready")); return; }
            TalkSession other = talker;
            if ((other != null && other != this) || svc.isTransmitting()) { peer.sendText(state("rx", "Someone is already transmitting")); return; }
            talker = this;
            final WebTxFeed f = new WebTxFeed(); feed = f;
            svc.history("warn", "\uD83C\uDF10 Talking from the web with the browser microphone (" + req.remote + ")");
            ui.post(() -> svc.pttFromWeb(true, f));
            peer.sendText(state("tx", null));
            Thread w = new Thread(() -> {                                 // watchdog: no audio for 1.5 s (tab hidden, network gone) unkeys
                while (feed == f) {
                    try { Thread.sleep(200); } catch (InterruptedException e) { return; }
                    if (feed == f && f.idleNanos() > 1_500_000_000L) { release("no audio from the browser"); return; }
                }
            }, "web-talk-watchdog");
            w.setDaemon(true); w.start();
        }
        private synchronized void release(String why) {
            WebTxFeed f = feed; if (f == null) return;
            feed = null; f.close();
            if (talker == this) talker = null;
            ui.post(() -> svc.ptt(false));
            peer.sendText(state("rx", "released".equals(why) ? null : "Stopped: " + why));
        }
        @Override public void binary(byte[] b, int n) { WebTxFeed f = feed; if (f != null) f.push(b, 0, n); }
        @Override public void closed() { release("the connection closed"); }
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
        o.put("notes", ch.notes == null ? "" : ch.notes);
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
            if (!ChannelStore.inBand(ch.rxFreq) || !ChannelStore.inBand(ch.txFreq)) return "Frequencies must be 136–174 or 400–480 MHz";
            ch.power = b.optInt("power", ch.power) == 1 ? 1 : 0;
            ch.relay = b.optInt("relay", ch.relay) == 1 ? 1 : 2;
            if (b.has("notes")) ch.notes = b.optString("notes", "").trim();
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
                ch.txType = Math.max(0, Math.min(3, b.optInt("txType", ch.txType)));
                ch.rxType = Math.max(0, Math.min(3, b.optInt("rxType", ch.rxType)));
                int nTx = ch.txType == 1 ? com.macdmr.radio.dsp.ToneTable.CTCSS.length : com.macdmr.radio.dsp.ToneTable.DCS_COUNT, nRx = ch.rxType == 1 ? com.macdmr.radio.dsp.ToneTable.CTCSS.length : com.macdmr.radio.dsp.ToneTable.DCS_COUNT;
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
    /** A coverage square for the browser, coloured as the phone's map draws it (predicted squares fainter, underneath). */
    private static JSONObject cellJson(com.macdmr.radio.coverage.CoverageStore.Cell c, boolean tx, boolean predicted) throws Exception {
        int col; double alpha;
        if (predicted) { col = tx ? 0xFF2BEA7A : com.macdmr.radio.coverage.CoverageMath.signalColor(c.value); alpha = tx ? (0x22 + Math.min(20, c.value) * 4) / 255.0 : 0x4C / 255.0; }
        else { col = tx ? (c.keyed > 0 ? 0xFF2BEA7A : 0xFFFF5468) : com.macdmr.radio.coverage.CoverageMath.signalColor(c.value); alpha = 0xA8 / 255.0; }
        return new JSONObject().put("s", c.s).put("w", c.w).put("n", c.n).put("e", c.e).put("value", c.value).put("count", c.count).put("keyed", c.keyed).put("failed", c.failed)
                .put("color", String.format("#%06X", col & 0xFFFFFF)).put("alpha", Math.round(alpha * 100) / 100.0).put("predicted", predicted)
                .put("sunits", tx ? "" : com.macdmr.radio.coverage.CoverageMath.sUnits(c.value));
    }

    /** One terrain prediction at a time, run in the background (it can download terrain); the browser polls for it. Same settings as the phone's map. */
    private static final class PredJob { String id; volatile String status = "starting\u2026"; volatile com.macdmr.radio.coverage.Prediction.Result res; volatile String err; volatile boolean done; volatile long doneAt; }
    private volatile PredJob predJob;
    private synchronized PredJob prediction(String key, double lat, double lon, double hz) {
        android.content.SharedPreferences cp = svc.getSharedPreferences("coverage", Context.MODE_PRIVATE);
        final double ant = cp.getInt("ant_" + key, 0), erp = cp.getInt("pwr_" + key, 0), rad = cp.getInt("predRangeMi", 0) * 1609.344;
        android.location.Location me = svc.lastKnownLocation();
        final double meLat = me != null ? me.getLatitude() : Double.NaN, meLon = me != null ? me.getLongitude() : Double.NaN;
        String id = key + "|" + ant + "|" + erp + "|" + rad;
        PredJob j = predJob; long age = j == null ? 0 : System.currentTimeMillis() - j.doneAt;
        if (j != null && j.id.equals(id) && (!j.done || (j.err == null && age < 120_000) || (j.err != null && age < 60_000))) return j;   // as on the phone: re-calibrated with new readings at most every 2 minutes; a failure retried after a minute
        final PredJob nj = new PredJob(); nj.id = id; predJob = nj;
        new Thread(() -> {
            try {
                nj.res = com.macdmr.radio.coverage.Prediction.run(svc, svc.coverage().store(), key, lat, lon, hz, ant, erp, rad, meLat, meLon, t -> { nj.status = t; return predJob == nj; });
                nj.status = nj.res == null ? "stopped" : "done";
            } catch (Throwable t) { nj.err = t.getMessage() == null ? t.toString() : t.getMessage(); nj.status = "failed"; }
            nj.doneAt = System.currentTimeMillis(); nj.done = true;
        }, "web-prediction").start();
        return nj;
    }

    private static JSONObject toneLists() throws Exception {
        JSONArray c = new JSONArray(); for (int i = 0; i < com.macdmr.radio.dsp.ToneTable.CTCSS.length; i++) c.put(com.macdmr.radio.dsp.ToneTable.ctcssLabel(i));
        JSONArray d = new JSONArray(); for (int i = 0; i < com.macdmr.radio.dsp.ToneTable.DCS_COUNT; i++) d.put("DCS D" + com.macdmr.radio.dsp.ToneTable.dcsCode(i));   // the index the MCU gets; N/I comes from the type
        return new JSONObject().put("ctcss", c).put("dcs", d);
    }
    private JSONObject statusJson() throws Exception {
        JSONObject o = new JSONObject();
        o.put("link", svc.link()).put("ready", svc.isReady()).put("channel", channelObj(svc.current()));
        o.put("transmitting", svc.isTransmitting()).put("hearing", svc.hearing()).put("rssi", svc.lastRssi()).put("caller", svc.currentCaller());
        o.put("softSq", svc.softSqOn()).put("softSqLevel", svc.softSqLevel()).put("monitor", svc.monitorOn()).put("record", svc.recordOn())
                .put("scanning", svc.scanning()).put("vfo", svc.vfoActive()).put("zone", svc.zoneName()).put("zoneId", svc.zoneId())
                .put("txInhibited", svc.txInhibited()).put("webTx", allowTx()).put("tls", tlsRunning()).put("tlsPort", TLS_PORT);
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
    private static double parseD(String s, double def) { try { return s == null || s.isEmpty() ? def : Double.parseDouble(s); } catch (Exception e) { return def; } }
    private static int parse(String s, int def) { try { return s == null ? def : Integer.parseInt(s); } catch (Exception e) { return def; } }
    private static JSONObject checkInJson(com.macdmr.radio.ham.NetStore.CheckIn k) throws Exception {
        return new JSONObject().put("id", k.id).put("ts", k.ts).put("call", k.call).put("name", k.name).put("notes", k.notes).put("traffic", k.traffic).put("late", k.late).put("out", k.out);
    }
    private com.macdmr.radio.repeaters.RepeaterService repeaterService;
    private final java.util.Map<String, com.macdmr.radio.repeaters.RepeaterModels.Repeater> lastRepeaters = new java.util.concurrent.ConcurrentHashMap<>();
    private synchronized com.macdmr.radio.repeaters.RepeaterService repeaters() {
        if (repeaterService == null) repeaterService = new com.macdmr.radio.repeaters.RepeaterService(svc, svc.store());
        return repeaterService;
    }
    /** 8 kHz mono 16-bit samples as a WAV file. */
    static byte[] wav(short[] pcm) {
        java.nio.ByteBuffer b = java.nio.ByteBuffer.allocate(44 + pcm.length * 2).order(java.nio.ByteOrder.LITTLE_ENDIAN);
        b.put("RIFF".getBytes()).putInt(36 + pcm.length * 2).put("WAVEfmt ".getBytes()).putInt(16).putShort((short) 1).putShort((short) 1).putInt(8000).putInt(16000).putShort((short) 2).putShort((short) 16)
                .put("data".getBytes()).putInt(pcm.length * 2);
        for (short v : pcm) b.putShort(v);
        return b.array();
    }
    /** A backup folder by name, only inside Download/DMR/DMR_Backups. */
    private static File backupDir(String name) {
        if (name == null || name.isEmpty() || name.contains("/") || name.contains("\\") || name.contains("..")) return null;
        File d = new File(com.macdmr.radio.Backup.backupRoot(), name);
        return d.isDirectory() ? d : null;
    }
    private static void deleteTree(File f) { File[] l = f.listFiles(); if (l != null) for (File x : l) deleteTree(x); f.delete(); }
    /** A recording by its id "channel/file.wav", only inside Download/DMR/Audio. */
    private static File recording(String id) {
        if (id == null) return null;
        String[] p = id.split("/");
        if (p.length != 2 || p[0].isEmpty() || p[1].isEmpty() || id.contains("..") || id.contains("\\") || !p[1].endsWith(".wav")) return null;
        File f = new File(new File(com.macdmr.radio.ui.MediaDialogs.audioRoot(), p[0]), p[1]);
        return f.isFile() ? f : null;
    }
    private File sstvDir() { return new File(android.os.Environment.getExternalStoragePublicDirectory(android.os.Environment.DIRECTORY_DOWNLOADS), "DMR/SSTV"); }

    // ---- settings: the Device page's switches and choices ----
    private interface Get { Object get(); }
    private interface Set { void set(JSONObject b) throws Exception; }
    private static final class Setting {
        final String key, group, label, sub, kind; final String[] choices; final Get get; final Set set;
        Setting(String key, String group, String label, String sub, String kind, String[] choices, Get get, Set set) { this.key = key; this.group = group; this.label = label; this.sub = sub; this.kind = kind; this.choices = choices; this.get = get; this.set = set; }
    }
    private java.util.List<Setting> settings() {
        java.util.List<Setting> l = new java.util.ArrayList<>();
        android.content.SharedPreferences rp = svc.getSharedPreferences("radio", Context.MODE_PRIVATE);
        l.add(new Setting("dmrId", "Identity", "Your DMR ID", "What other radios see when you talk on DMR channels", "int", null, svc::localId, b -> {
            int v = b.getInt("value"); if (v < 1 || v > 0xFFFFFF) throw new IllegalArgumentException("A DMR ID is 1 to 16777215"); svc.setLocalId(v); }));
        l.add(new Setting("ownAtBoot", "Radio", "Own the radio at boot", "Otherwise the stock app is restored after a reboot", "bool", null, svc::ownAtBoot, b -> svc.setOwnAtBoot(b.getBoolean("value"))));
        l.add(new Setting("hwPtt", "Radio", "Side PTT key", "The phone's hardware push-to-talk button transmits", "bool", null, svc::hwPtt, b -> svc.setHwPtt(b.getBoolean("value"))));
        l.add(new Setting("volPtt", "Radio", "Volume-up transmits", "While the Intercom page is open on the phone", "bool", null, () -> rp.getBoolean("volPtt", false), b -> rp.edit().putBoolean("volPtt", b.getBoolean("value")).apply()));
        l.add(new Setting("customPtt", "Radio", "Custom PTT key", "The button learned on the phone (Device → Custom PTT key) transmits; learning needs the phone in hand", "bool", null, () -> com.macdmr.radio.CustomPttKey.enabled(svc), b -> { if (com.macdmr.radio.CustomPttKey.saved(svc) != null) { com.macdmr.radio.CustomPttKey.setEnabled(svc, b.getBoolean("value")); svc.customPttChanged(); } }));
        l.add(new Setting("scanSoftSq", "Radio", "Soft SQ while scanning", "Every analog channel, each at its own level", "bool", null, svc::scanSoftSq, b -> svc.setScanSoftSq(b.getBoolean("value"))));
        l.add(new Setting("roger", "Radio", "Roger beep", "A short sound at the end of each transmission", "choice", RadioService.ROGER_NAMES, svc::rogerStyle, b -> svc.setRogerStyle(Math.max(0, Math.min(RadioService.ROGER_NAMES.length - 1, b.getInt("value"))))));
        l.add(new Setting("voice", "Radio", "Voice announcements", "Channel changes, caller names, keyword alerts", "bool", null, svc::voiceOn, b -> svc.setVoiceOn(b.getBoolean("value"))));
        l.add(new Setting("keywords", "Radio", "Keyword alerts", "Words in live captions that raise an alert, separated by commas", "text", null, svc::keywords, b -> svc.setKeywords(b.getString("value"))));
        l.add(new Setting("logHeard", "Logbook", "Log stations heard", "DMR callers and APRS stations go into the logbook as Heard", "bool", null, svc::logHeard, b -> svc.setLogHeard(b.getBoolean("value"))));
        l.add(new Setting("lookupOnline", "Logbook", "Look up names online", "RadioID / callsign lookups for callers and stations", "bool", null, svc::lookupOnline, b -> svc.setLookupOnline(b.getBoolean("value"))));
        l.add(new Setting("coverage", "Coverage", "Coverage logging", "Records signal and key-ups with GPS for the coverage maps", "bool", null, () -> svc.coverage().enabled(), b -> svc.setCoverageLogging(b.getBoolean("value"))));
        l.add(new Setting("covInCar", "Coverage", "Log coverage in the car", "Coverage logging while Android Auto is connected", "bool", null, svc::coverageInCar, b -> svc.setCoverageInCar(b.getBoolean("value"))));
        l.add(new Setting("carMic", "Car", "Car microphone in Android Auto", "Talk uses the car's microphone through its hands-free link", "bool", null, svc::carMic, b -> svc.setCarMic(b.getBoolean("value"))));
        l.add(new Setting("wheelTalk", "Car", "Steering-wheel play/pause talks", "In Android Auto: play/pause starts and stops transmitting", "bool", null, svc::wheelTalk, b -> svc.setWheelTalk(b.getBoolean("value"))));
        l.add(new Setting("nextTalk", "Car", "Steering-wheel Next talks", "Hold Next to talk, or press it twice", "choice", RadioService.NEXT_TALK_NAMES, svc::nextTalkMode, b -> svc.setNextTalkMode(Math.max(0, Math.min(RadioService.NEXT_TALK_NAMES.length - 1, b.getInt("value"))))));
        l.add(new Setting("wheelMic", "Car", "Steering-wheel microphone", "Car (as a call) or the phone's microphone", "choice", RadioService.WHEEL_MIC_NAMES, svc::wheelMic, b -> svc.setWheelMic(Math.max(0, Math.min(1, b.getInt("value"))))));
        l.add(new Setting("voxStop", "Car", "Stop when I stop talking", "For transmissions started from the wheel", "choice", RadioService.VOX_NAMES, svc::voxStop, b -> svc.setVoxStop(Math.max(0, Math.min(RadioService.VOX_NAMES.length - 1, b.getInt("value"))))));
        l.add(new Setting("carScreen", "Car", "Full-screen Radio controls in the car", "Off: a media app; on: a big Talk screen (reconnect the car after changing)", "bool", null, svc::carControlsScreen, b -> svc.setCarControlsScreen(b.getBoolean("value"))));
        return l;
    }
    private JSONObject settingsJson() throws Exception {
        JSONArray a = new JSONArray();
        for (Setting s : settings()) {
            JSONObject o = new JSONObject().put("key", s.key).put("group", s.group).put("label", s.label).put("sub", s.sub).put("kind", s.kind).put("value", s.get.get());
            if (s.choices != null) o.put("choices", new JSONArray(java.util.Arrays.asList(s.choices)));
            a.put(o);
        }
        return new JSONObject().put("settings", a).put("link", svc.link()).put("ready", svc.isReady()).put("profile", svc.profile() == null ? "" : svc.profile().name)
                .put("version", com.macdmr.radio.BuildConfig.VERSION_NAME).put("webTx", allowTx()).put("browsers", clients()).put("listeners", listeners());
    }

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
                java.util.Set<Integer> favs = svc.store().favourites();
                JSONArray a = new JSONArray(); for (ChannelStore.Channel ch : svc.zoneChannels()) a.put(channelObj(ch).put("fav", favs.contains(ch.number)));
                JSONArray z = new JSONArray(); z.put(new JSONObject().put("id", 0).put("name", "ALL"));
                for (ChannelStore.Zone zz : svc.store().zones()) z.put(new JSONObject().put("id", zz.id).put("name", zz.name));
                return ok(new JSONObject().put("channels", a).put("zones", z).put("zoneId", svc.zoneId()));
            }
            case "/api/channel/star": if (!post) break; {                    // star / unstar: the ★ Favourites zone
                int n = b.optInt("number", 0); boolean on = b.optBoolean("on", true);
                if (svc.store().byNumber(n) == null) return WebServer.Response.error(404, "No channel " + n);
                onMain(() -> { svc.store().setFavourite(n, on); return null; });
                return ok(on ? "Starred channel " + n : "Channel " + n + " is no longer a favourite");
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
            case "/api/vfo": {                                                  // GET: the VFO's settings; POST: tune it (enters VFO mode)
                if (!post) {
                    JSONObject help = new JSONObject(); for (String[] h : com.macdmr.radio.ui.ChannelEditorView.helpForWeb()) help.put(h[0], h[1]);
                    JSONArray steps = new JSONArray(); for (int s : VFO_STEPS) steps.put(s);
                    return ok(new JSONObject().put("channel", channelFull(svc.vfoChannel())).put("active", svc.vfoActive()).put("step", svc.vfoStepHz()).put("steps", steps)
                            .put("help", help).put("tones", toneLists()));
                }
                if (svc.isTransmitting()) return WebServer.Response.error(409, "Not while transmitting");
                ChannelStore.Channel v = svc.vfoChannel();
                if (!b.has("lat")) b.put("lat", ""); if (!b.has("lon")) b.put("lon", "");
                String err = applyChannel(v, b);
                if (err != null) return WebServer.Response.error(400, err);
                if (v.isDigital() && v.contactType != 2 && v.txContact <= 0) return WebServer.Response.error(400, "A call number is needed for a private or group call");
                v.name = ""; v.lat = 0; v.lon = 0;
                int step = b.optInt("step", svc.vfoStepHz()); boolean stepOk = false; for (int s : VFO_STEPS) stepOk |= s == step;
                final boolean setStep = stepOk;
                onMain(() -> { if (setStep) svc.setVfoStepHz(step); svc.applyVfo(v); return null; });
                return ok(String.format(java.util.Locale.US, "VFO %.4f MHz", v.rxFreq / 1e6));
            }
            case "/api/vfo/exit": if (!post) break; onMain(() -> { svc.exitVfo(); return null; }); return ok("Back to the channel");
            case "/api/channel/delete": if (!post) break; {
                ChannelStore.Channel ch = svc.store().byNumber(b.optInt("number", 0));
                if (ch == null) return WebServer.Response.error(404, "No such channel");
                if (svc.isTransmitting()) return WebServer.Response.error(409, "Not while transmitting");
                onMain(() -> { svc.deleteChannel(ch); return null; });
                return ok("Deleted " + (ch.name.isEmpty() ? "channel " + ch.number : ch.name));
            }
            case "/api/sat/passes": {                                           // every satellite's next passes over the phone (no position sent)
                android.location.Location me = svc.lastKnownLocation();
                com.macdmr.radio.ham.Satellites sats = svc.satellites();
                java.util.Map<Integer, com.macdmr.radio.ham.Sgp4> el = sats.elements();
                long now = System.currentTimeMillis();
                JSONArray a = new JSONArray();
                for (com.macdmr.radio.ham.Satellites.Sat s : com.macdmr.radio.ham.Satellites.all(svc)) {
                    JSONObject o = new JSONObject().put("key", s.key).put("name", s.name).put("about", s.about).put("downHz", s.downHz).put("upHz", s.upHz)
                            .put("toneHz", s.toneHz).put("mode", s.mode).put("listenOnly", s.listenOnly());
                    JSONArray ps = new JSONArray(); com.macdmr.radio.ham.Sgp4 e = el.get(s.catalog);
                    if (e == null) o.put("problem", "No orbit for it in the download");
                    else if (me != null) {
                        for (com.macdmr.radio.ham.SatTrack.Pass pa : com.macdmr.radio.ham.SatTrack.passes(e, now - 15 * 60_000L, 24, me.getLatitude(), me.getLongitude(), me.hasAltitude() ? me.getAltitude() : 0, 10)) {
                            if (pa.los < now) continue;
                            ps.put(new JSONObject().put("aos", pa.aos).put("los", pa.los).put("maxEl", pa.maxEl).put("aosAz", pa.aosAz).put("losAz", pa.losAz));
                            if (ps.length() >= 6) break;
                        }
                    }
                    a.put(o.put("passes", ps));
                }
                return ok(new JSONObject().put("satellites", a).put("hasFix", me != null).put("elementsAgeH", sats.elementsAgeMs() / 3_600_000.0));
            }
            case "/api/sat/track": if (!post) break; {                          // track one pass {key, aos}
                android.location.Location me = svc.lastKnownLocation(); if (me == null) return WebServer.Response.error(409, "No position fix on the phone yet");
                String key = b.optString("key", ""); long aos = b.optLong("aos", 0);
                for (com.macdmr.radio.ham.Satellites.Sat s : com.macdmr.radio.ham.Satellites.all(svc)) {
                    if (!s.key.equals(key)) continue;
                    com.macdmr.radio.ham.Sgp4 e = svc.satellites().elements().get(s.catalog); if (e == null) return WebServer.Response.error(409, "No orbit for " + s.name);
                    for (com.macdmr.radio.ham.SatTrack.Pass pa : com.macdmr.radio.ham.SatTrack.passes(e, System.currentTimeMillis() - 15 * 60_000L, 24, me.getLatitude(), me.getLongitude(), me.hasAltitude() ? me.getAltitude() : 0, 10)) {
                        if (Math.abs(pa.aos - aos) > 120_000) continue;
                        String err = onMain(() -> { svc.setIssRepeat(-1); return svc.trackSat(s, e, pa); });
                        return err == null ? ok("Tracking " + s.name) : WebServer.Response.error(409, err);
                    }
                    return WebServer.Response.error(404, "That pass is no longer ahead");
                }
                return WebServer.Response.error(404, "No such satellite");
            }
            case "/api/recordings": {                                           // REC files: Download/DMR/Audio/<channel>/*.wav
                java.util.List<File> files = new java.util.ArrayList<>();
                File[] chans = com.macdmr.radio.ui.MediaDialogs.audioRoot().listFiles();
                if (chans != null) for (File d : chans) { File[] fs = d.listFiles(); if (fs != null) for (File f : fs) if (f.getName().endsWith(".wav")) files.add(f); }
                files.sort((x, y) -> Long.compare(y.lastModified(), x.lastModified()));
                JSONArray a = new JSONArray();
                for (File f : files) { if (a.length() >= 300) break; a.put(new JSONObject().put("id", f.getParentFile().getName() + "/" + f.getName()).put("channel", f.getParentFile().getName()).put("name", f.getName()).put("ts", f.lastModified()).put("seconds", Math.max(0, (f.length() - 44) / 16000.0))); }
                return ok(new JSONObject().put("recordings", a));
            }
            case "/api/recording": case "/api/recording/delete": {
                File f = recording(post ? b.optString("id", "") : r.param("id"));
                if (f == null) return WebServer.Response.error(404, "No such recording");
                if (post) return f.delete() ? ok("Deleted " + f.getName()) : WebServer.Response.error(500, "Could not delete " + f.getName());
                byte[] data; try (InputStream in = new java.io.FileInputStream(f)) { data = readAll(in); }
                WebServer.Response x = WebServer.Response.bytes("audio/wav", data);
                if ("1".equals(r.param("download"))) x.headers.put("Content-Disposition", "attachment; filename=\"" + f.getName().replace("\"", "") + "\"");
                return x;
            }
            case "/api/logbook": {
                com.macdmr.radio.ham.Logbook lb = svc.logbook();
                if (post) {                                                     // save {id?, call, freqMHz, mode, rstSent, rstRcvd, name, notes, ts?}
                    com.macdmr.radio.ham.Logbook.Entry e = null;
                    long id = b.optLong("id", 0);
                    if (id > 0) for (com.macdmr.radio.ham.Logbook.Entry x : lb.list(5000, false)) if (x.id == id) e = x;
                    if (e == null) { e = new com.macdmr.radio.ham.Logbook.Entry(); e.ts = System.currentTimeMillis(); e.qso = true; e.source = "web"; }
                    String call = b.optString("call", "").trim().toUpperCase(java.util.Locale.US);
                    if (call.isEmpty()) return WebServer.Response.error(400, "A callsign is needed");
                    e.call = call; e.mode = b.optString("mode", e.mode); e.rstSent = b.optString("rstSent", e.rstSent); e.rstRcvd = b.optString("rstRcvd", e.rstRcvd);
                    e.name = b.optString("name", e.name); e.notes = b.optString("notes", e.notes); e.qso = b.optBoolean("qso", e.qso);
                    if (b.has("freqMHz")) e.freqHz = Math.round(b.getDouble("freqMHz") * 1e6);
                    if (b.has("ts")) e.ts = b.getLong("ts");
                    lb.save(e);
                    return ok("Logged " + e.call);
                }
                boolean qsoOnly = "1".equals(r.param("qso"));
                java.util.List<com.macdmr.radio.ham.Logbook.Entry> list = lb.list(Math.min(2000, parse(r.param("limit"), 500)), qsoOnly);
                if ("adif".equals(r.param("format"))) {
                    WebServer.Response x = WebServer.Response.bytes("text/plain; charset=utf-8", com.macdmr.radio.ham.Logbook.adif(list, com.macdmr.radio.BuildConfig.VERSION_NAME).getBytes(java.nio.charset.StandardCharsets.UTF_8));
                    x.headers.put("Content-Disposition", "attachment; filename=\"signaldeck_log.adi\""); return x;
                }
                JSONArray a = new JSONArray();
                for (com.macdmr.radio.ham.Logbook.Entry e : list)
                    a.put(new JSONObject().put("id", e.id).put("ts", e.ts).put("call", e.call).put("freqHz", e.freqHz).put("band", com.macdmr.radio.ham.Logbook.band(e.freqHz)).put("mode", e.mode)
                            .put("name", e.name).put("notes", e.notes).put("rstSent", e.rstSent).put("rstRcvd", e.rstRcvd).put("qso", e.qso).put("source", e.source).put("grid", e.grid).put("qth", e.qth));
                return ok(new JSONObject().put("entries", a).put("qsos", lb.count(true)).put("total", lb.count(false)));
            }
            case "/api/logbook/delete": if (!post) break; { svc.logbook().delete(b.optLong("id", 0)); return ok("Deleted"); }
            case "/api/settings": {
                if (post) {
                    String key = b.optString("key", "");
                    for (Setting s : settings()) if (s.key.equals(key)) {
                        try { onMain(() -> { s.set.set(b); return null; }); }
                        catch (java.util.concurrent.ExecutionException e) { return WebServer.Response.error(400, e.getCause() == null ? String.valueOf(e) : String.valueOf(e.getCause().getMessage())); }
                        return ok(settingsJson().put("message", s.label + " saved"));
                    }
                    return WebServer.Response.error(404, "No such setting");
                }
                return ok(settingsJson());
            }
            case "/api/radio": if (!post) break; {                              // take over / hand back the radio
                String a = b.optString("action", "");
                if (svc.isTransmitting()) return WebServer.Response.error(409, "Not while transmitting");
                if (a.equals("takeover")) { svc.bringUp(); return ok("Taking over the radio"); }
                if (a.equals("handback")) { svc.shutDown(true); return ok("Handing the radio back to the stock app"); }
                return WebServer.Response.error(400, "action: takeover or handback");
            }
            case "/api/packet": {                                               // packet settings + tool states + DTMF log + weather alerts
                com.macdmr.radio.PacketEngine pe = svc.packet(); if (pe == null) return WebServer.Response.error(409, "Packet engine not ready");
                android.content.SharedPreferences pp = svc.getSharedPreferences("packet", Context.MODE_PRIVATE);
                JSONObject st = new JSONObject()
                        .put("callsignSet", pe.callsignSet()).put("ssid", pe.ssid()).put("comment", pe.comment()).put("path", pp.getString("path", "WIDE1-1,WIDE2-1"))
                        .put("symbol", pp.getString("symTable", "/") + pp.getString("symCode", "[")).put("autoBeacon", pe.autoBeacon()).put("beaconMin", pe.beaconMin())
                        .put("txPower", pe.dataTxPower()).put("leadKind", pe.packetLeadKind()).put("leadMs", pe.packetLeadMs()).put("passive", pe.passiveMode())
                        .put("autoAck", pp.getBoolean("autoAck", true)).put("digipeat", pp.getBoolean("digipeat", false)).put("dtmf", pp.getBoolean("dtmf", true))
                        .put("wx", pp.getBoolean("wx", true)).put("cw", pp.getBoolean("cw", true)).put("cwId", pp.getBoolean("cwId", false))
                        .put("telemetry", pp.getBoolean("telemetry", false)).put("weather", pp.getBoolean("weather", false)).put("txIgate", pp.getBoolean("txIgate", false))
                        .put("groups", pp.getString("groups", "")).put("kissPort", pp.getInt("kissPort", 8001))
                        .put("isServer", pe.isServer()).put("isPort", pe.isPort()).put("isPasscodeSet", !"-1".equals(pp.getString("isPasscode", "-1")))
                        .put("isBeaconMin", pe.isBeaconMin()).put("isComment", pp.getString("isComment", pe.comment()));
                JSONArray lk = new JSONArray(); for (String k : com.macdmr.radio.PacketEngine.LEAD_KINDS) lk.put(k);
                JSONArray lc = new JSONArray(); for (int ms : com.macdmr.radio.PacketEngine.LEAD_CHOICES) lc.put(ms);
                JSONArray dt = new JSONArray();
                for (PacketStore.Dtmf d : pe.store().dtmfLog(50)) dt.put(new JSONObject().put("ts", d.ts).put("digits", d.digits).put("channel", d.channel).put("channelName", d.channelName));
                JSONArray al = new JSONArray();
                for (PacketStore.Alert x : pe.store().alerts(50)) al.put(new JSONObject().put("ts", x.ts).put("event", x.event).put("summary", x.summary).put("eom", x.eom));
                JSONObject tools = new JSONObject().put("is", pe.isEnabled()).put("isStatus", pe.isStatus()).put("kiss", pe.kiss().isActive()).put("kissClient", pe.kiss().clientConnected())
                        .put("parrot", svc.parrot().enabled()).put("fox", svc.foxTxOn()).put("webTx", allowTx());
                return ok(new JSONObject().put("settings", st).put("leadKinds", lk).put("leadChoices", lc).put("tools", tools).put("dtmf", dt).put("alerts", al)
                        .put("dtmfSaved", new JSONArray(pp.getString("dtmfSaved", "[]"))));
            }
            case "/api/packet/settings": if (!post) break; {                   // the APRS settings sheet's checks (PktDialog)
                android.content.SharedPreferences pp = svc.getSharedPreferences("packet", Context.MODE_PRIVATE);
                android.content.SharedPreferences.Editor ed = pp.edit();
                try {
                    if (b.has("callsign") && !b.getString("callsign").trim().isEmpty()) {         // write-only: absent or empty keeps the stored one
                        String cs = b.getString("callsign").trim().toUpperCase(java.util.Locale.US);
                        int dash = cs.indexOf('-'); if (dash > 0) { b.put("ssid", Integer.parseInt(cs.substring(dash + 1).trim())); cs = cs.substring(0, dash).trim(); }
                        if (!cs.matches("[A-Z0-9]{1,6}")) return WebServer.Response.error(400, "Callsign: 1 to 6 letters and digits; the SSID goes in its own box");
                        ed.putString("callsign", cs);
                    }
                    if (b.has("ssid")) { int v = b.getInt("ssid"); if (v < 0 || v > 15) return WebServer.Response.error(400, "SSID is 0 to 15"); ed.putInt("ssid", v); }
                    if (b.has("symbol")) { String s = b.getString("symbol").trim(); ed.putString("symTable", s.length() >= 1 ? s.substring(0, 1) : "/").putString("symCode", s.length() >= 2 ? s.substring(1, 2) : "["); }
                    if (b.has("comment")) ed.putString("comment", b.getString("comment").trim());
                    if (b.has("path")) ed.putString("path", b.getString("path").trim().toUpperCase(java.util.Locale.US));
                    if (b.has("groups")) ed.putString("groups", b.getString("groups").trim().toUpperCase(java.util.Locale.US));
                    if (b.has("autoBeacon")) ed.putInt("autoBeacon", Math.max(0, Math.min(2, b.getInt("autoBeacon"))));
                    if (b.has("beaconMin")) ed.putInt("beaconMin", Math.max(1, b.getInt("beaconMin")));
                    if (b.has("txPower")) ed.putInt("txPower", b.getInt("txPower") == 0 ? 0 : 1);
                    if (b.has("leadKind")) ed.putInt("txLeadKind", Math.max(0, Math.min(com.macdmr.radio.PacketEngine.LEAD_KINDS.length - 1, b.getInt("leadKind"))));
                    if (b.has("leadMs")) { int ms = b.getInt("leadMs"); boolean okMs = false; for (int c : com.macdmr.radio.PacketEngine.LEAD_CHOICES) okMs |= c == ms; if (!okMs) return WebServer.Response.error(400, "Lead-in length must be one of the listed choices"); ed.putInt("txLeadMs", ms); }
                    if (b.has("passive")) ed.putInt("passive", Math.max(0, Math.min(2, b.getInt("passive"))));
                    for (String k : new String[] { "autoAck", "digipeat", "dtmf", "wx", "cw", "cwId", "telemetry", "weather", "txIgate" }) if (b.has(k)) ed.putBoolean(k, b.getBoolean(k));
                    if (b.has("kissPort")) { int v = b.getInt("kissPort"); if (v < 1024 || v > 65535) return WebServer.Response.error(400, "KISS port is 1024 to 65535"); ed.putInt("kissPort", v); }
                    if (b.has("isServer")) ed.putString("isServer", b.getString("isServer").trim());
                    if (b.has("isPort")) ed.putInt("isPort", b.getInt("isPort"));
                    if (b.has("isPasscode") && !b.getString("isPasscode").trim().isEmpty()) ed.putString("isPasscode", b.getString("isPasscode").trim());   // write-only
                    if (b.has("isBeaconMin")) ed.putInt("isBeaconMin", Math.max(0, b.getInt("isBeaconMin")));
                    if (b.has("isComment")) ed.putString("isComment", b.getString("isComment").trim());
                } catch (Exception e) { return WebServer.Response.error(400, "Check the numbers"); }
                ed.apply();
                onMain(() -> { svc.packet().applySettings(); return null; });
                return ok("APRS settings saved");
            }
            case "/api/packet/tool": if (!post) break; {                       // {tool: is|kiss|parrot, on}
                com.macdmr.radio.PacketEngine pe = svc.packet(); String tool = b.optString("tool", ""); boolean on = b.optBoolean("on", false);
                if (on && (tool.equals("parrot") || tool.equals("fox")) && !allowTx()) return WebServer.Response.error(403, TX_OFF);     // both transmit
                String msg = onMain(() -> {
                    switch (tool) {
                        case "is": if (on) { String e = pe.isStart(); return e == null ? "APRS-IS starting" : e; } pe.isStop(); return "APRS-IS off";
                        case "kiss": if (on) { String e = pe.kissStart(); return e == null ? "KISS TNC on" : e; } pe.kissStop(); return "KISS TNC off";
                        case "parrot": return svc.setParrot(on);
                        case "fox": return svc.setFoxTx(on);
                        default: return null;
                    }
                });
                return msg == null ? WebServer.Response.error(400, "tool: is, kiss, parrot or fox") : ok(msg);
            }
            case "/api/dtmf": if (!post) break; {
                if (!allowTx()) return WebServer.Response.error(403, TX_OFF);
                String seq = b.optString("seq", "").trim().toUpperCase(java.util.Locale.US);
                if (!seq.matches("[0-9A-D*#]{1,32}")) return WebServer.Response.error(400, "DTMF: 1 to 32 of 0-9, A-D, * and #");
                String e = onMain(() -> svc.packet().sendDtmf(seq));
                return e == null ? ok("Sending DTMF " + seq) : WebServer.Response.error(409, e);
            }
            case "/api/cwid": if (!post) break; {
                if (!allowTx()) return WebServer.Response.error(403, TX_OFF);
                String e = onMain(() -> svc.packet().sendCwId());
                return e == null ? ok("Sending the Morse ID") : WebServer.Response.error(409, e);
            }
            case "/api/sstv/send": if (!post) break; {                          // body: the picture's bytes (PNG/JPEG); ?mode=0..2
                if (!allowTx()) return WebServer.Response.error(403, TX_OFF);
                int[] modes = { com.macdmr.radio.pkt.SSTVEncoder.ROBOT_24_COLOR, com.macdmr.radio.pkt.SSTVEncoder.ROBOT_12_BW, com.macdmr.radio.pkt.SSTVEncoder.ROBOT_8_BW };
                int m = parse(r.param("mode"), 0); if (m < 0 || m >= modes.length) return WebServer.Response.error(400, "mode: 0 Robot 24 Color, 1 Robot 12 BW, 2 Robot 8 BW");
                android.graphics.Bitmap bmp = android.graphics.BitmapFactory.decodeByteArray(r.body, 0, r.body.length);
                if (bmp == null) return WebServer.Response.error(400, "That is not a picture this phone can read (use PNG or JPEG)");
                String e = onMain(() -> svc.packet().sendSstv(bmp, modes[m]));
                return e == null ? ok("Sending the picture as " + com.macdmr.radio.pkt.SSTVEncoder.name(modes[m])) : WebServer.Response.error(409, e);
            }
            case "/api/trainer": {                                              // the Morse trainer's lesson and speeds (shared with the phone's trainer)
                android.content.SharedPreferences tp = svc.getSharedPreferences("trainer", Context.MODE_PRIVATE);
                if (post) {
                    android.content.SharedPreferences.Editor ed = tp.edit();
                    if (b.has("lesson")) ed.putInt("lesson", Math.max(1, Math.min(com.macdmr.radio.ham.MorseTrainer.LESSONS, b.getInt("lesson"))));
                    if (b.has("wpm")) ed.putInt("wpm", Math.max(5, Math.min(40, b.getInt("wpm"))));
                    if (b.has("fw")) ed.putInt("fw", Math.max(5, Math.min(40, b.getInt("fw"))));
                    ed.apply();
                }
                return ok(new JSONObject().put("lesson", tp.getInt("lesson", 1)).put("wpm", tp.getInt("wpm", 20)).put("fw", tp.getInt("fw", 10))
                        .put("koch", com.macdmr.radio.ham.MorseTrainer.KOCH).put("lessons", com.macdmr.radio.ham.MorseTrainer.LESSONS));
            }
            case "/api/exam": {                                                 // the pools and this phone's progress (shared with the phone's Exam practice)
                android.content.SharedPreferences ep = svc.getSharedPreferences("exam", Context.MODE_PRIVATE);
                JSONArray a = new JSONArray();
                for (com.macdmr.radio.ham.ExamPool.Element e : com.macdmr.radio.ham.ExamPool.ELEMENTS)
                    a.put(new JSONObject().put("key", e.key).put("name", e.name).put("asset", e.asset).put("questions", e.questions).put("pass", e.pass)
                            .put("best", ep.getInt("best_" + e.key, -1)).put("missed", new JSONArray(ep.getStringSet("missed_" + e.key, new java.util.HashSet<>()))));
                return ok(new JSONObject().put("elements", a));
            }
            case "/api/exam/answer": if (!post) break; {                       // {element, id, right}: keeps the missed list like the phone
                String key = b.optString("element", ""), id = b.optString("id", "");
                if (!key.matches("tech|general|extra") || !id.matches("[A-Z][0-9][A-Z][0-9]{2}")) return WebServer.Response.error(400, "element and id");
                android.content.SharedPreferences ep = svc.getSharedPreferences("exam", Context.MODE_PRIVATE);
                java.util.Set<String> miss = new java.util.HashSet<>(ep.getStringSet("missed_" + key, new java.util.HashSet<>()));
                if (b.optBoolean("right", false)) miss.remove(id); else miss.add(id);
                ep.edit().putStringSet("missed_" + key, miss).apply();
                return ok(new JSONObject().put("missed", miss.size()));
            }
            case "/api/exam/result": if (!post) break; {                       // {element, right}: a full practice exam's score
                String key = b.optString("element", ""); int right = b.optInt("right", -1);
                if (!key.matches("tech|general|extra") || right < 0) return WebServer.Response.error(400, "element and right");
                android.content.SharedPreferences ep = svc.getSharedPreferences("exam", Context.MODE_PRIVATE);
                boolean best = right > ep.getInt("best_" + key, -1); if (best) ep.edit().putInt("best_" + key, right).apply();
                return ok(new JSONObject().put("best", best));
            }
            case "/api/nets": {                                                 // the running net (check-ins, stations heard lately) and past nets
                com.macdmr.radio.ham.NetStore ns = svc.nets();
                JSONObject o = new JSONObject();
                com.macdmr.radio.ham.NetStore.Net n = ns.running();
                if (n != null) {
                    JSONArray ins = new JSONArray(); java.util.Set<String> in = new java.util.HashSet<>();
                    for (com.macdmr.radio.ham.NetStore.CheckIn k : ns.checkIns(n.id)) { in.add(k.call); ins.put(checkInJson(k)); }
                    JSONArray heard = new JSONArray(); java.util.Set<String> seen = new java.util.HashSet<>(); long since = System.currentTimeMillis() - 30 * 60_000L;
                    for (com.macdmr.radio.ham.Logbook.Entry e : svc.logbook().list(80, false))
                        if (e.ts >= since && !in.contains(e.call) && seen.add(e.call)) heard.put(new JSONObject().put("call", e.call).put("name", e.name == null ? "" : e.name));
                    o.put("running", new JSONObject().put("id", n.id).put("name", n.name).put("channel", n.channel).put("freqHz", n.freqHz).put("start", n.start).put("checkIns", ins).put("heard", heard));
                }
                JSONArray past = new JSONArray();
                for (com.macdmr.radio.ham.NetStore.Net p0 : ns.past(30)) past.put(new JSONObject().put("id", p0.id).put("name", p0.name).put("channel", p0.channel).put("start", p0.start).put("end", p0.end).put("count", ns.checkIns(p0.id).size()));
                return ok(o.put("past", past).put("lastName", svc.getSharedPreferences("nets", Context.MODE_PRIVATE).getString("last", "")));
            }
            case "/api/nets/start": if (!post) break; {
                if (svc.nets().running() != null) return WebServer.Response.error(409, "A net is already running");
                String nm = b.optString("name", "").trim(); if (nm.isEmpty()) nm = "Net";
                svc.getSharedPreferences("nets", Context.MODE_PRIVATE).edit().putString("last", nm).apply();
                ChannelStore.Channel cur = svc.current();
                svc.nets().start(nm, cur == null ? "" : cur.name, cur == null ? 0 : cur.rxFreq);
                final String name = nm; onMain(() -> { svc.history("pkt", "📋 Net started: " + name); return null; });
                return ok("Net started: " + nm);
            }
            case "/api/nets/end": if (!post) break; {
                com.macdmr.radio.ham.NetStore.Net n = svc.nets().running(); if (n == null) return WebServer.Response.error(409, "No net is running");
                svc.nets().end(n); int c = svc.nets().checkIns(n.id).size();
                onMain(() -> { svc.history("pkt", "📋 Net ended: " + n.name + " (" + c + " check-ins)"); return null; });
                return ok("Net ended: " + c + " check-ins");
            }
            case "/api/nets/checkin": if (!post) break; {
                com.macdmr.radio.ham.NetStore.Net n = svc.nets().running(); if (n == null) return WebServer.Response.error(409, "No net is running");
                String cs = b.optString("call", "").trim().toUpperCase(java.util.Locale.US), nm = b.optString("name", "").trim();
                if (!cs.matches("[A-Z0-9/]{3,12}")) return WebServer.Response.error(400, "That does not look like a callsign");
                com.macdmr.radio.ham.NetStore.CheckIn k = svc.nets().checkIn(n, cs, nm);
                if (nm.isEmpty()) svc.enrichCall(cs, i -> { if (k.name == null || k.name.isEmpty()) { k.name = i.name; svc.nets().save(k); pub("net", "{}"); } });   // the name from the callsign lookup
                return ok("Checked in " + cs);
            }
            case "/api/nets/update": if (!post) break; {                        // {id, traffic?, late?, out?, notes?, remove?}
                com.macdmr.radio.ham.NetStore.Net n = svc.nets().running(); if (n == null) return WebServer.Response.error(409, "No net is running");
                long id = b.optLong("id", 0);
                for (com.macdmr.radio.ham.NetStore.CheckIn k : svc.nets().checkIns(n.id)) if (k.id == id) {
                    if (b.optBoolean("remove", false)) { svc.nets().remove(k); return ok("Removed " + k.call); }
                    if (b.has("traffic")) k.traffic = b.getBoolean("traffic"); if (b.has("late")) k.late = b.getBoolean("late"); if (b.has("out")) k.out = b.getBoolean("out");
                    if (b.has("notes")) k.notes = b.getString("notes"); if (b.has("name")) k.name = b.getString("name");
                    svc.nets().save(k); return ok(k.call + " updated");
                }
                return WebServer.Response.error(404, "No such check-in");
            }
            case "/api/nets/report": {                                          // the net's report text (the phone's NetStore.report)
                long id = r.param("id") == null ? -1 : Long.parseLong(r.param("id"));
                com.macdmr.radio.ham.NetStore.Net n = null;
                com.macdmr.radio.ham.NetStore.Net run = svc.nets().running(); if (run != null && (id < 0 || run.id == id)) n = run;
                if (n == null) for (com.macdmr.radio.ham.NetStore.Net p0 : svc.nets().past(200)) if (p0.id == id) n = p0;
                if (n == null) return WebServer.Response.error(404, "No such net");
                String text = com.macdmr.radio.ham.NetStore.report(n, svc.nets().checkIns(n.id), svc.packet() != null && svc.packet().callsignSet() ? svc.packet().callsign() : "");
                WebServer.Response x = WebServer.Response.bytes("text/plain; charset=utf-8", text.getBytes(java.nio.charset.StandardCharsets.UTF_8));
                if ("1".equals(r.param("download"))) x.headers.put("Content-Disposition", "attachment; filename=\"net_report.txt\"");
                return x;
            }
            case "/api/nets/delete": if (!post) break; {
                long id = b.optLong("id", 0); com.macdmr.radio.ham.NetStore.Net run = svc.nets().running();
                if (run != null && run.id == id) return WebServer.Response.error(409, "End the net first");
                svc.nets().deleteNet(id); return ok("Net deleted");
            }
            case "/api/keyer": {                                                // the voice keyer's three messages and the station-ID timer
                com.macdmr.radio.ham.VoiceKeyer k = svc.keyer();
                if (post) {
                    int slot = b.optInt("slot", -1); if (slot < 0 || slot >= com.macdmr.radio.ham.VoiceKeyer.SLOTS) return WebServer.Response.error(400, "slot 0 to 2");
                    if (b.has("name")) k.setName(slot, b.getString("name").trim());
                    if (b.has("addId")) k.setAddId(slot, b.getBoolean("addId"));
                    if (b.optBoolean("delete", false)) k.delete(slot);
                    if (b.optBoolean("send", false)) {
                        if (!allowTx()) return WebServer.Response.error(403, TX_OFF);
                        String e = onMain(() -> svc.sendKeyer(slot)); if (e != null) return WebServer.Response.error(409, e);
                    }
                }
                JSONArray a = new JSONArray();
                for (int i = 0; i < com.macdmr.radio.ham.VoiceKeyer.SLOTS; i++) a.put(new JSONObject().put("name", k.name(i)).put("has", k.has(i)).put("ms", k.lengthMs(i)).put("addId", k.addId(i)));
                long due = svc.idDueInMs();
                return ok(new JSONObject().put("slots", a).put("idDueMs", due == Long.MAX_VALUE ? null : due).put("webTx", allowTx()));
            }
            case "/api/keyer/audio": {                                          // GET ?slot= : the message as WAV; POST ?slot= : raw 8 kHz mono s16le body
                int slot = parse(r.param("slot"), -1); if (slot < 0 || slot >= com.macdmr.radio.ham.VoiceKeyer.SLOTS) return WebServer.Response.error(400, "slot 0 to 2");
                if (post) {
                    if (r.body.length < 1600) return WebServer.Response.error(400, "That recording is too short");
                    short[] pcm = new short[r.body.length / 2]; java.nio.ByteBuffer.wrap(r.body).order(java.nio.ByteOrder.LITTLE_ENDIAN).asShortBuffer().get(pcm);
                    svc.keyer().save(slot, pcm);
                    return ok("Saved " + svc.keyer().name(slot) + String.format(java.util.Locale.US, " (%.1f s)", Math.min(pcm.length, 200_000) / 8000.0));
                }
                short[] p0 = svc.keyer().pcm(slot); if (p0 == null || p0.length == 0) return WebServer.Response.error(404, "Nothing recorded");
                return WebServer.Response.bytes("audio/wav", wav(p0));
            }
            case "/api/textmodes": {                                            // RTTY / PSK31: GET state + text; POST {mode?, txMode?, clear?, send?}
                com.macdmr.radio.PacketEngine pe = svc.packet();
                if (post) {
                    if (b.has("send")) {
                        if (!allowTx()) return WebServer.Response.error(403, TX_OFF);
                        String e = onMain(() -> pe.textSend(b.getString("send")));
                        if (e != null) return WebServer.Response.error(409, e);
                    }
                    onMain(() -> {
                        if (b.has("mode")) pe.setTextMode(Math.max(0, Math.min(2, b.getInt("mode"))));
                        if (b.has("txMode")) pe.setTextTxMode(b.getInt("txMode") == 1 ? 1 : 2);
                        if (b.optBoolean("clear", false)) pe.textClear();
                        return null;
                    });
                }
                JSONArray modes = new JSONArray(); for (String m : com.macdmr.radio.PacketEngine.TEXT_MODES) modes.put(m);
                return ok(new JSONObject().put("mode", pe.textMode()).put("txMode", pe.textTxMode()).put("status", pe.textStatus()).put("text", pe.textReceived()).put("modes", modes).put("webTx", allowTx()));
            }
            case "/api/terminal": {                                             // AX.25 connected-mode terminal: GET transcript; POST {connect, via} | {send} | {disconnect} | {accept}
                com.macdmr.radio.PacketEngine pe = svc.packet();
                if (post) {
                    boolean tx = b.has("connect") || b.has("send") || (b.has("accept") && b.getBoolean("accept"));
                    if (tx && !allowTx()) return WebServer.Response.error(403, TX_OFF);
                    String e = onMain(() -> {
                        if (b.has("connect")) return pe.terminalConnect(b.getString("connect"), b.optString("via", ""));
                        if (b.has("send")) return pe.terminalSend(b.getString("send"));
                        if (b.optBoolean("disconnect", false)) { pe.terminalDisconnect(); return null; }
                        if (b.has("accept")) { pe.setAcceptConnections(b.getBoolean("accept")); return null; }
                        return null;
                    });
                    if (e != null) return WebServer.Response.error(409, e);
                }
                return ok(new JSONObject().put("state", pe.terminalState()).put("transcript", pe.transcriptText()).put("accept", pe.acceptConnections()).put("callsignSet", pe.callsignSet()).put("webTx", allowTx()));
            }
            case "/api/coverage": {                                             // coverage for all repeaters or one: measured squares (rx median signal / tx keyed or not), the repeaters with data, and the terrain prediction
                boolean tx = "tx".equals(r.param("layer"));
                com.macdmr.radio.coverage.CoverageStore st = svc.coverage().store();
                String key = r.param("key"); if (key != null && key.isEmpty()) key = null;
                double fLat = parseD(r.param("lat"), Double.NaN), fLon = parseD(r.param("lon"), Double.NaN), fHz = parseD(r.param("hz"), 0);
                String fName = r.param("name");
                if (key == null && fHz > 0 && !Double.isNaN(fLat)) key = com.macdmr.radio.coverage.CoverageMath.repeaterKey((int) fHz, fLat, fLon);   // a repeater from the map, measured or not
                JSONArray reps = new JSONArray();
                for (com.macdmr.radio.coverage.CoverageStore.Repeater x : st.repeaters()) {
                    reps.put(new JSONObject().put("key", x.key).put("name", x.name).put("rxHz", x.rxHz).put("lat", x.lat).put("lon", x.lon).put("rx", x.rxCount).put("tx", x.txCount));
                    if (x.key.equals(key)) { if (Double.isNaN(fLat)) { fLat = x.lat; fLon = x.lon; } if (fHz <= 0) fHz = x.rxHz; if (fName == null || fName.isEmpty()) fName = x.name; }
                }
                JSONArray a = new JSONArray();
                for (com.macdmr.radio.coverage.CoverageStore.Cell c : tx ? st.txCells(key) : st.rxCells(key)) a.put(cellJson(c, tx, false));
                JSONObject out = new JSONObject().put("cells", a).put("layer", tx ? "tx" : "rx").put("logging", svc.coverage().enabled()).put("repeaters", reps).put("key", key == null ? "" : key);
                if (key != null && "1".equals(r.param("predict")) && !Double.isNaN(fLat) && fHz > 0) {
                    PredJob j = prediction(key, fLat, fLon, fHz);
                    out.put("predictStatus", j.status).put("predictDone", j.done);
                    if (j.err != null) out.put("predictError", j.err);
                    if (j.res != null) {
                        JSONArray pa = new JSONArray(); for (com.macdmr.radio.coverage.CoverageStore.Cell c : tx ? j.res.tx : j.res.rx) pa.put(cellJson(c, tx, true));
                        out.put("predicted", pa).put("predictSummary", j.res.summary(!tx));
                    }
                }
                if (key != null) out.put("name", fName == null ? "" : fName).put("lat", fLat).put("lon", fLon);
                return ok(out);
            }
            case "/api/repeaters": {                                            // nearby repeaters (RadioID / BrandMeister / Hearham, cached by the phone)
                android.location.Location me = svc.lastKnownLocation(); if (me == null) return WebServer.Response.error(409, "No position fix on the phone yet");
                double mi = Math.max(5, Math.min(150, parse(r.param("radiusMi"), svc.getSharedPreferences("repeaters", Context.MODE_PRIVATE).getInt("radiusMi", 30))));
                StringBuilder st = new StringBuilder();
                java.util.List<com.macdmr.radio.repeaters.RepeaterModels.Repeater> found = repeaters().nearby(me.getLatitude(), me.getLongitude(), mi * 1.609344, "1".equals(r.param("force")), st);
                JSONArray a = new JSONArray(); lastRepeaters.clear();
                for (com.macdmr.radio.repeaters.RepeaterModels.Repeater x : found) {
                    lastRepeaters.put(x.key, x);
                    JSONObject o = new JSONObject().put("key", x.key).put("callsign", x.callsign).put("rxHz", x.rxHz).put("txHz", x.txHz).put("fm", x.fm).put("dmr", x.dmr).put("cc", x.cc)
                            .put("network", x.network).put("city", x.city).put("region", x.region).put("toneUp", x.toneUp).put("toneDown", x.toneDown).put("status", x.status)
                            .put("distanceKm", Double.isNaN(x.distanceMeters) ? null : x.distanceMeters / 1000.0).put("approx", x.approx);
                    if (x.hasCoords) o.put("lat", x.lat).put("lon", x.lon);
                    a.put(o);
                }
                return ok(new JSONObject().put("repeaters", a).put("status", st.toString()).put("radiusMi", mi));
            }
            case "/api/repeaters/talkgroups": {
                com.macdmr.radio.repeaters.RepeaterModels.Repeater x = lastRepeaters.get(r.param("key")); if (x == null) return WebServer.Response.error(404, "Search again: that repeater is not in the last list");
                JSONArray a = new JSONArray();
                for (com.macdmr.radio.repeaters.RepeaterModels.Talkgroup t : repeaters().talkgroups(x)) a.put(new JSONObject().put("id", t.id).put("slot", t.slot).put("name", t.name).put("kind", t.kind));
                return ok(new JSONObject().put("talkgroups", a));
            }
            case "/api/repeaters/add": if (!post) break; {                      // {key, talk: [tg…], confirm}: without confirm only the preview
                com.macdmr.radio.repeaters.RepeaterModels.Repeater x = lastRepeaters.get(b.optString("key", "")); if (x == null) return WebServer.Response.error(404, "Search again: that repeater is not in the last list");
                java.util.Set<Integer> talk = new java.util.HashSet<>(); JSONArray ta = b.optJSONArray("talk"); if (ta != null) for (int i = 0; i < ta.length(); i++) talk.add(ta.getInt(i));
                com.macdmr.radio.repeaters.RepeaterPlanner.Plan plan = repeaters().plan(x, talk);
                if (plan.channels.isEmpty()) return WebServer.Response.error(409, plan.warnings.isEmpty() ? "Nothing to program" : plan.warnings.get(0));
                if (!b.optBoolean("confirm", false)) return ok(new JSONObject().put("preview", com.macdmr.radio.repeaters.RepeaterService.preview(plan)));
                String res = repeaters().program(x, plan);
                return ok(res);
            }
            case "/api/zones": {
                if (post) {                                                     // save {id?, name, numbers[]}
                    ChannelStore.Zone z = new ChannelStore.Zone(); z.id = b.optLong("id", 0); z.name = b.optString("name", "").trim();
                    if (z.name.isEmpty()) return WebServer.Response.error(400, "A zone needs a name");
                    JSONArray ns = b.optJSONArray("numbers"); java.util.List<Integer> keep = new java.util.ArrayList<>();
                    if (ns != null) for (int i = 0; i < ns.length(); i++) { int n = ns.getInt(i); if (svc.store().byNumber(n) != null && !keep.contains(n)) keep.add(n); }
                    if (keep.isEmpty()) return WebServer.Response.error(400, "Pick at least one channel for the zone");
                    java.util.Collections.sort(keep); z.numbers = new int[keep.size()]; for (int i = 0; i < keep.size(); i++) z.numbers[i] = keep.get(i);
                    long id = svc.store().saveZone(z);
                    if (svc.zoneId() == id) onMain(() -> { svc.setZone(id); return null; });   // the active zone changed: scan and arrows follow it
                    return WebServer.Response.json(200, new JSONObject().put("ok", true).put("message", "Saved zone " + z.name).put("id", id).toString());
                }
                JSONArray zs = new JSONArray();
                for (ChannelStore.Zone z : svc.store().zones()) { JSONArray ns = new JSONArray(); for (int n : z.numbers) ns.put(n); zs.put(new JSONObject().put("id", z.id).put("name", z.name).put("numbers", ns)); }
                JSONArray all = new JSONArray(); for (ChannelStore.Channel ch : svc.store().all()) all.put(new JSONObject().put("number", ch.number).put("name", ch.name).put("rxFreq", ch.rxFreq).put("digital", ch.isDigital()));
                return ok(new JSONObject().put("zones", zs).put("channels", all).put("active", svc.zoneId()));
            }
            case "/api/zones/delete": if (!post) break; {
                long id = b.optLong("id", 0); ChannelStore.Zone z = svc.store().zone(id); if (z == null) return WebServer.Response.error(404, "No such zone");
                onMain(() -> { if (svc.zoneId() == id) svc.setZone(0); svc.store().deleteZone(id); return null; });
                return ok("Deleted zone " + z.name);
            }
            case "/api/backups": {                                              // the backups in Download/DMR/DMR_Backups
                JSONArray a = new JSONArray();
                for (File d : com.macdmr.radio.Backup.backups()) {
                    JSONArray fs = new JSONArray(); File[] l = d.listFiles(); if (l != null) for (File f : l) if (f.getName().endsWith(".csv")) fs.put(f.getName());
                    a.put(new JSONObject().put("name", d.getName()).put("ts", d.lastModified()).put("files", fs));
                }
                return ok(new JSONObject().put("backups", a));
            }
            case "/api/backup": if (!post) break; {
                File dir = com.macdmr.radio.Backup.export(svc.store(), svc.packet() != null ? svc.packet().dtmfSaved() : null);
                return WebServer.Response.json(200, new JSONObject().put("ok", true).put("message", "Backed up to Download/DMR/DMR_Backups/" + dir.getName()).put("name", dir.getName()).toString());
            }
            case "/api/backup/zip": {                                           // one backup as a .zip download
                File dir = backupDir(r.param("name")); if (dir == null) return WebServer.Response.error(404, "No such backup");
                ByteArrayOutputStream bo = new ByteArrayOutputStream();
                try (java.util.zip.ZipOutputStream z = new java.util.zip.ZipOutputStream(bo)) {
                    File[] l = dir.listFiles(); if (l != null) for (File f : l) if (f.isFile() && f.getName().endsWith(".csv")) {
                        z.putNextEntry(new java.util.zip.ZipEntry(dir.getName() + "/" + f.getName()));
                        try (InputStream in = new java.io.FileInputStream(f)) { z.write(readAll(in)); }
                        z.closeEntry();
                    }
                }
                WebServer.Response x = WebServer.Response.bytes("application/zip", bo.toByteArray());
                x.headers.put("Content-Disposition", "attachment; filename=\"" + dir.getName() + ".zip\""); return x;
            }
            case "/api/restore": if (!post) break; {                            // {name} an existing backup, or {files: {"Channels.csv": text, …}} uploaded from the computer
                if (svc.isTransmitting()) return WebServer.Response.error(409, "Not while transmitting");
                File dir;
                if (b.has("files")) {
                    JSONObject fs = b.getJSONObject("files");
                    java.util.Set<String> allowed = new java.util.HashSet<>(java.util.Arrays.asList("Contacts.csv", "TG_Lists.csv", "Channels.csv", "Zones.csv", "DTMF.csv"));
                    if (!fs.has("Channels.csv")) return WebServer.Response.error(400, "Channels.csv is needed (with Contacts.csv, TG_Lists.csv and Zones.csv from the same backup)");
                    dir = new File(svc.getCacheDir(), "web_restore"); deleteTree(dir); dir.mkdirs();
                    for (java.util.Iterator<String> it = fs.keys(); it.hasNext(); ) {
                        String n = it.next(); if (!allowed.contains(n)) continue;
                        try (java.io.FileOutputStream o = new java.io.FileOutputStream(new File(dir, n))) { o.write(fs.getString(n).getBytes(java.nio.charset.StandardCharsets.UTF_8)); }
                    }
                } else {
                    dir = backupDir(b.optString("name", "")); if (dir == null) return WebServer.Response.error(404, "No such backup");
                }
                final File from = dir;
                String res;
                try {
                    res = com.macdmr.radio.Backup.restore(svc.store(), from);
                    if (svc.packet() != null) for (java.util.Map.Entry<String, String> e : com.macdmr.radio.Backup.readDtmf(from).entrySet()) svc.packet().dtmfSave(e.getKey(), e.getValue());
                } catch (Exception e) { return WebServer.Response.error(400, "Restore failed: " + e.getMessage()); }
                onMain(() -> { svc.selectChannel(svc.store().activeNumber()); return null; });
                return ok(res);
            }
            case "/api/log": {                                                  // the Diagnostics page's log (last 300 lines)
                JSONArray a = new JSONArray(); for (String l : svc.recentLog()) a.put(l);
                return ok(new JSONObject().put("lines", a));
            }
            case "/api/heard": {                                                // Last heard, grouped like the phone's sheet, plus alerts and events
                java.util.LinkedHashMap<String, JSONObject> rows = new java.util.LinkedHashMap<>();
                for (Object[] h : svc.store().lastHeard(400)) {
                    long ts = (Long) h[0]; int ch = (Integer) h[1]; String kind = (String) h[2], text = (String) h[3]; int id = (Integer) h[4];
                    if (text != null && (text.startsWith("⛔") || text.startsWith("⚠"))) continue;
                    String key = ch + ":" + (kind.equals("dmr") || kind.equals("sms") ? id : kind);
                    JSONObject e = rows.get(key);
                    if (e != null) { e.put("count", e.getInt("count") + 1); continue; }
                    ChannelStore.Channel c = svc.store().byNumber(ch);
                    rows.put(key, new JSONObject().put("ts", ts).put("channel", ch).put("channelName", c != null ? c.name : ch == 0 ? "VFO" : "channel " + ch)
                            .put("kind", kind).put("text", text).put("dmrId", id).put("name", id > 0 ? svc.callerName(id) : "").put("count", 1));
                }
                JSONArray a = new JSONArray(); for (JSONObject o : rows.values()) a.put(o);
                JSONArray ev = new JSONArray();
                for (Object[] h : svc.store().events(System.currentTimeMillis() - 7L * 24 * 3600 * 1000, 100))
                    ev.put(new JSONObject().put("ts", h[0]).put("channel", h[1]).put("kind", h[2]).put("text", h[3]));
                return ok(new JSONObject().put("heard", a).put("events", ev));
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
