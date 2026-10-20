package com.macdmr.radio.ui;

import android.content.Context;
import android.view.Gravity;
import android.widget.LinearLayout;
import android.widget.ScrollView;
import android.widget.TextView;

import com.macdmr.radio.PacketEngine;
import com.macdmr.radio.RadioService;
import com.macdmr.radio.pkt.PacketStore;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Locale;

/**
 * APRS monitoring (144.390, the ISS on 145.825, or the KISS TNC): live packet feed, stations heard and messages,
 * counters since monitoring started, the switches that matter while monitoring, and message / beacon / map /
 * settings / stop.
 */
public final class AprsScreen extends ModeScreen {
    private final PacketEngine pe;
    private final PassCard passCard;
    private final TextView statPackets, statStations, statMsgs, statLast;
    private final TextView[] tabs = new TextView[3];
    private final TextView ackChip, digiChip, beaconChip, isChip;
    private final LinearLayout list;
    private final ScrollView scroll;
    private int tab;
    private long shownChanges = -1;
    private final SimpleDateFormat hm = new SimpleDateFormat("HH:mm:ss", Locale.US), dhm = new SimpleDateFormat("MM-dd HH:mm", Locale.US);

    public AprsScreen(Context c, RadioService svc, Runnable onClose) {
        super(c, svc, "APRS", "pkt", Neo.GREEN, onClose);
        pe = svc.packet();

        LinearLayout body = new LinearLayout(c); body.setOrientation(VERTICAL); body.setPadding(dp(14), dp(4), dp(14), 0);
        passCard = new PassCard(c); body.addView(passCard);
        // counters
        LinearLayout stats = new LinearLayout(c);
        statPackets = stat(stats, "PACKETS"); statStations = stat(stats, "STATIONS"); statMsgs = stat(stats, "FOR YOU"); statLast = stat(stats, "LAST HEARD");
        body.addView(stats);
        // switches that matter while monitoring
        LinearLayout chips = new LinearLayout(c); chips.setGravity(Gravity.CENTER_VERTICAL); chips.setPadding(0, dp(8), 0, dp(4));
        ackChip = chip(chips); digiChip = chip(chips); beaconChip = chip(chips); isChip = chip(chips);
        ackChip.setOnClickListener(v -> { pe.prefs().edit().putBoolean("autoAck", !pe.autoAck()).apply(); pe.applySettings(); refresh(); });
        digiChip.setOnClickListener(v -> { pe.prefs().edit().putBoolean("digipeat", !pe.digipeat()).apply(); pe.applySettings(); refresh(); });
        beaconChip.setOnClickListener(v -> { pe.prefs().edit().putInt("autoBeacon", (pe.autoBeacon() + 1) % 3).apply(); pe.applySettings(); refresh(); });
        isChip.setOnClickListener(v -> { if (pe.isEnabled()) pe.isStop(); else toast(pe.isStart()); refresh(); });
        android.widget.HorizontalScrollView hs = new android.widget.HorizontalScrollView(c); hs.setHorizontalScrollBarEnabled(false); hs.addView(chips);
        body.addView(hs);
        // tabs
        LinearLayout tb = new LinearLayout(c); tb.setPadding(0, dp(6), 0, dp(6));
        String[] names = { "LIVE", "STATIONS", "MESSAGES" };
        for (int i = 0; i < 3; i++) {
            final int k = i;
            TextView t = Neo.text(c, names[i], Neo.MUTED, 14, Neo.ui(c)); t.setGravity(Gravity.CENTER); t.setLetterSpacing(0.1f); t.setPadding(0, dp(8), 0, dp(8));
            t.setOnClickListener(v -> { tab = k; shownChanges = -1; refresh(); scrollTop(); });
            tb.addView(t, new LayoutParams(0, LayoutParams.WRAP_CONTENT, 1f)); tabs[i] = t;
        }
        body.addView(tb);
        scroll = new ScrollView(c); scroll.setVerticalScrollBarEnabled(false);
        list = new LinearLayout(c); list.setOrientation(VERTICAL); list.setPadding(0, 0, 0, dp(10));
        scroll.addView(list);
        body.addView(scroll, new LayoutParams(LayoutParams.MATCH_PARENT, 0, 1f));
        content.addView(body);

        LinearLayout r1 = buttonRow();
        button(r1, "Message", "send", Neo.AMBER, v -> PktDialog.sheet(c, svc, "message"));
        button(r1, "Beacon", "locate", Neo.AMBER, v -> {
            if (svc.satMode() == com.macdmr.radio.ham.Satellites.APRS) { toast(svc.issBeacon()); return; }          // through the ISS (path ARISS), Doppler-corrected
            String e = pe.sendBeacon(); toast(e == null ? "Beacon queued" : e);
        });
        button(r1, "Map", "map", Neo.CYAN, v -> MapDialog.show(c, svc));
        LinearLayout r2 = buttonRow();
        button(r2, "Settings", "menu", Neo.CYAN, v -> PktDialog.sheet(c, svc, "settings"));
        button(r2, "Stop", "stop", Neo.RED, v -> {
            if (pe.kiss().isActive()) pe.kissStop();
            if (svc.satMode() == com.macdmr.radio.ham.Satellites.APRS) { svc.endSatTracking(); toast("ISS APRS stopped"); close(); return; }
            toast(svc.aprsMonitor(false)); close();
        });
    }

    private TextView stat(LinearLayout row, String label) {
        LinearLayout box = new LinearLayout(c); box.setOrientation(VERTICAL); box.setGravity(Gravity.CENTER);
        box.setBackground(Neo.card(c, Neo.LINE_SOFT, 10)); box.setPadding(dp(4), dp(8), dp(4), dp(8));
        TextView v = Neo.text(c, "0", Neo.TEXT, 20, Neo.display(c)); v.setGravity(Gravity.CENTER); v.setSingleLine(true);
        TextView l = Neo.text(c, label, Neo.DIM, 10.5f, Neo.ui(c)); l.setGravity(Gravity.CENTER); l.setLetterSpacing(0.08f); l.setSingleLine(true);
        box.addView(v); box.addView(l);
        LayoutParams lp = new LayoutParams(0, LayoutParams.WRAP_CONTENT, 1f); lp.setMargins(dp(2), 0, dp(2), 0);
        row.addView(box, lp);
        return v;
    }
    private TextView chip(LinearLayout row) {
        TextView t = Neo.text(c, "", Neo.MUTED, 13, Neo.uiSemi(c)); t.setPadding(dp(12), dp(6), dp(12), dp(6)); t.setSingleLine(true);
        LayoutParams lp = new LayoutParams(LayoutParams.WRAP_CONTENT, LayoutParams.WRAP_CONTENT); lp.rightMargin = dp(6);
        row.addView(t, lp); return t;
    }
    private void chipState(TextView t, String label, boolean on) {
        set(t, label);
        if (Boolean.valueOf(on).equals(t.getTag())) return;
        t.setTag(on); t.setTextColor(on ? Neo.GREEN_LIGHT : Neo.MUTED);
        t.setBackground(Neo.outline(c, on ? Neo.GREEN : Neo.OFF, on ? 0x22 : 0x10, 14, 1));
    }
    private int tabShown = -1;
    private void scrollTop() { scroll.post(() -> scroll.scrollTo(0, 0)); }

    @Override protected long waitingHz() { com.macdmr.radio.RadioService.SatState st = svc.satState(); return st != null && st.mode == com.macdmr.radio.ham.Satellites.APRS && st.waiting ? st.nominalHz : 0; }
    @Override protected long waitingUntil() { com.macdmr.radio.RadioService.SatState st = svc.satState(); return st == null ? 0 : st.aos - 60_000; }
    @Override protected boolean stillRunning() { return pe.monitoring() || pe.kiss().isActive() || svc.satMode() == com.macdmr.radio.ham.Satellites.APRS; }

    @Override protected void refresh() {
        boolean iss = svc.satMode() == com.macdmr.radio.ham.Satellites.APRS;
        String what = iss ? "ISS APRS " + String.format(Locale.US, "%.3f", svc.satState().nominalHz / 1e6) + " \u00B7 Doppler-tracked" : !pe.monitoring() ? "KISS TNC on this channel" : "Monitoring " + String.format(Locale.US, "%.3f", svc.aprsMonitorHz() / 1e6);
        passCard.update(svc);
        if (pe.kiss().isActive()) what += pe.monitoring() ? " · KISS TNC :" + pe.kissPort() : " · port " + pe.kissPort();
        setSubtitle(what + (pe.callsignSet() ? "" : " · set your callsign in Settings"));

        long since = since();
        List<PacketStore.LogEntry> log = pe.store().aprsLog(300);
        int packets = 0, forYou = 0; long last = 0;
        for (PacketStore.LogEntry e : log) {
            if (e.ts < since) continue;
            boolean heard = !e.kind.endsWith("-tx") && !e.kind.equals("beacon") && !e.kind.startsWith("is-") && !e.kind.equals("ack-tx");
            if (heard) { packets++; last = Math.max(last, e.ts); }
            if (e.mine && e.kind.equals("msg")) forYou++;
        }
        set(statPackets, String.valueOf(packets));
        set(statStations, String.valueOf(pe.store().stationCount()));
        set(statMsgs, String.valueOf(forYou)); color(statMsgs, forYou > 0 ? Neo.AMBER : Neo.TEXT);
        set(statLast, last == 0 ? "—" : ago(last).replace(" ago", ""));

        String[] beacon = { "Beacon off", "Beacon " + pe.beaconMin() + " min", "SmartBeacon" };
        chipState(ackChip, "Auto-ack", pe.autoAck());
        chipState(digiChip, "Digipeater", pe.digipeat());
        chipState(beaconChip, beacon[Math.max(0, Math.min(2, pe.autoBeacon()))], pe.autoBeacon() != 0);
        chipState(isChip, pe.isEnabled() ? "APRS-IS: " + pe.isStatus() : "APRS-IS off", pe.isEnabled());
        if (tabShown != tab) for (int i = 0; i < 3; i++) { tabShown = tab; tabs[i].setTextColor(i == tab ? Neo.GREEN_LIGHT : Neo.MUTED); tabs[i].setBackground(i == tab ? Neo.outline(c, Neo.GREEN, 0x18, 10, 1) : null); }

        long ch = pe.store().changes();
        if (ch == shownChanges) return;
        shownChanges = ch;
        list.removeAllViews();
        if (tab == 0) showLive(log); else if (tab == 1) showStations(); else showMessages(log);
    }

    private void showLive(List<PacketStore.LogEntry> log) {
        int n = 0; long since = since(); boolean divided = false;
        for (PacketStore.LogEntry e : log) {
            if (n++ >= 120) break;
            if (!divided && e.ts < since) { divided = true; TextView t = Neo.caps(c, n == 1 ? "EARLIER  ·  nothing yet since monitoring started" : "EARLIER"); t.setPadding(dp(4), dp(10), 0, dp(6)); list.addView(t); }
            row(icon(e) + "  " + e.from + (e.to == null || e.to.isEmpty() ? "" : " → " + e.to),
                    (DateUtilsToday(e.ts) ? hm : dhm).format(new Date(e.ts)) + "   " + kindName(e) + (e.text == null || e.text.isEmpty() ? "" : "\n" + e.text),
                    e.mine ? Neo.AMBER : e.kind.endsWith("-tx") || e.kind.equals("beacon") ? Neo.VIOLET_LIGHT : Neo.CYAN, null);
        }
        if (n == 0) empty("Listening. Every packet the radio decodes appears here as it arrives: positions, messages, status, weather, objects, and what you send.");
    }

    private void showStations() {
        List<PacketStore.Station> st = pe.store().stations(200);
        android.location.Location me = svc.lastKnownLocation();
        for (PacketStore.Station s : st) {
            String dist = "";
            if (me != null) { float[] r = new float[2]; android.location.Location.distanceBetween(me.getLatitude(), me.getLongitude(), s.lat, s.lon, r); dist = String.format(Locale.US, "   %.1f mi %s", r[0] / 1609.344, compass(r[1])); }
            String extra = (s.speedKmh >= 0 ? String.format(Locale.US, " · %.0f mph", s.speedKmh * 0.621371) : "") + (s.alt != 0 ? " · " + Math.round(s.alt * 3.28084) + " ft" : "");
            final PacketStore.Station fs = s;
            row("📍  " + s.call + dist, ago(s.lastTs) + (s.count > 1 ? " · heard " + s.count + "×" : "") + extra + (s.via.isEmpty() ? "" : " · via " + s.via) + (s.comment.isEmpty() ? "" : "\n" + s.comment),
                    Neo.CYAN, () -> {
                        try { c.startActivity(new android.content.Intent(android.content.Intent.ACTION_VIEW, android.net.Uri.parse(String.format(Locale.US, "geo:%f,%f?q=%f,%f(%s)", fs.lat, fs.lon, fs.lat, fs.lon, android.net.Uri.encode(fs.call))))); } catch (Throwable t) { toast("No map app"); }
                    });
        }
        if (st.isEmpty()) empty("No positions yet. Stations appear with their distance and direction from you, newest first; tap one to open it in your maps app.");
    }

    private void showMessages(List<PacketStore.LogEntry> log) {
        int n = 0;
        for (PacketStore.LogEntry e : log) {
            boolean msg = e.kind.equals("msg") || e.kind.equals("msg-tx") || e.kind.equals("ack") || e.kind.equals("rej") || e.kind.equals("igate-rf");
            if (!msg) continue;
            n++;
            final String reply = e.kind.equals("msg") && e.mine ? e.from.replace(" (IS)", "") : null;
            row(icon(e) + "  " + e.from + " → " + e.to + (e.mine && e.kind.equals("msg") ? "   (for you)" : ""),
                    (DateUtilsToday(e.ts) ? hm : dhm).format(new Date(e.ts)) + "   " + kindName(e) + (e.text == null || e.text.isEmpty() ? "" : "\n" + e.text) + (reply != null ? "\nTap to reply" : ""),
                    e.mine ? Neo.AMBER : e.kind.equals("msg-tx") ? Neo.VIOLET_LIGHT : Neo.CYAN,
                    reply == null ? null : () -> PktDialog.sheet(c, svc, "message:" + reply));
        }
        if (n == 0) empty("No messages yet. Messages to your callsign" + (pe.autoAck() ? " (acknowledged automatically)" : "") + ", the groups you follow, bulletins and the messages you send are listed here.");
    }

    private void row(String title, String sub, int color, Runnable tap) {
        LinearLayout r = new LinearLayout(c); r.setOrientation(VERTICAL); r.setBackground(Neo.rowCard(c)); r.setPadding(dp(12), dp(8), dp(12), dp(8));
        TextView t = Neo.text(c, title, color, 15, Neo.uiSemi(c)); r.addView(t);
        TextView s = Neo.text(c, sub, Neo.TEXT_SOFT, 13, Neo.uiMedium(c)); s.setPadding(0, dp(2), 0, 0); r.addView(s);
        if (tap != null) { r.setClickable(true); r.setOnClickListener(v -> tap.run()); }
        LayoutParams lp = new LayoutParams(LayoutParams.MATCH_PARENT, LayoutParams.WRAP_CONTENT); lp.bottomMargin = dp(6);
        list.addView(r, lp);
    }
    private void empty(String s) { TextView t = Neo.sheetHint(c, s); t.setPadding(dp(4), dp(18), dp(4), 0); list.addView(t); }

    private static boolean DateUtilsToday(long ts) { return android.text.format.DateUtils.isToday(ts); }
    private static String icon(PacketStore.LogEntry e) {
        switch (e.kind) {
            case "msg": return e.mine ? "✉️" : "💬";
            case "msg-tx": return "⬆️";
            case "ack": case "ack-tx": return "✅";
            case "rej": return "⛔";
            case "pos": return "📍";
            case "beacon": case "is-beacon": return "📡";
            case "digi": return "🔁";
            case "status": return "ℹ️";
            case "object": return "📌";
            case "igate-rf": return "🌐";
            default: return "▫️";
        }
    }
    private static String kindName(PacketStore.LogEntry e) {
        switch (e.kind) {
            case "msg": return e.mine ? "message for you" : "message";
            case "msg-tx": return "message sent";
            case "ack": return "acknowledged";
            case "ack-tx": return "you acknowledged";
            case "rej": return "rejected";
            case "pos": return "position";
            case "beacon": return "you beaconed";
            case "is-beacon": return "internet beacon";
            case "digi": return "you digipeated";
            case "status": return "status";
            case "object": return "object";
            case "igate-rf": return "gated from the internet";
            default: return "packet";
        }
    }
    private static String compass(float bearing) { float b = (bearing + 360) % 360; String[] dirs = { "N", "NE", "E", "SE", "S", "SW", "W", "NW" }; return dirs[(int) Math.round(b / 45.0) % 8]; }
}
