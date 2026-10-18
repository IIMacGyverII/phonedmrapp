package com.macdmr.radio.ui;

import android.app.AlertDialog;
import android.content.Context;
import android.content.SharedPreferences;
import android.graphics.drawable.ColorDrawable;
import android.text.InputType;
import android.view.Gravity;
import android.view.View;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.ScrollView;
import android.widget.TextView;
import android.widget.Toast;

import com.macdmr.radio.PacketEngine;
import com.macdmr.radio.RadioService;
import com.macdmr.radio.pkt.PacketStore;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Locale;

/** PKT: the packet-radio tools — APRS (monitor, message, beacon, KISS TNC, stations, log, settings), DTMF, weather alerts. */
public final class PktDialog {
    private final Context c; private final RadioService svc; private final PacketEngine pe; private final float d;
    private AlertDialog dlg;

    public static void show(Context c, RadioService svc) { if (svc.packet() != null) new PktDialog(c, svc).open(); }
    private PktDialog(Context c, RadioService svc) { this.c = c; this.svc = svc; this.pe = svc.packet(); d = Theme.dp(c); }

    private void open() {
        LinearLayout body = page("📡  Packet radio");
        // ---- APRS ----
        body.addView(section("APRS"));
        body.addView(status());
        LinearLayout r1 = row();
        button(r1, pe.monitoring() ? "Stop monitoring" : "Monitor 144.390", Theme.PKT, x -> { toast(svc.aprsMonitor(!pe.monitoring())); dlg.dismiss(); });
        button(r1, pe.kiss().isActive() ? "Stop KISS TNC" : "KISS TNC", Theme.PKT, x -> {
            if (pe.kiss().isActive()) { pe.kissStop(); toast("KISS TNC stopped"); }
            else { String e = pe.kissStart(); toast(e == null ? "KISS TNC on 127.0.0.1:" + pe.kissPort() + " — point APRSdroid/YAAC at it (TCP KISS)" : e); }
            svc.aprsMonitor(pe.monitoring()); dlg.dismiss();
        });
        body.addView(r1);
        LinearLayout r2 = row();
        button(r2, "Send message", Theme.VFO, x -> message());
        button(r2, "Position beacon", Theme.VFO, x -> { String e = pe.sendBeacon(); toast(e == null ? "Beacon queued" : e); });
        body.addView(r2);
        LinearLayout r3 = row();
        button(r3, "Stations heard (" + pe.store().stationCount() + ")", Theme.SOFTSQ, x -> stations());
        button(r3, "APRS log", Theme.SOFTSQ, x -> aprsLog());
        button(r3, "Settings", Theme.MON, x -> settings());
        body.addView(r3);
        body.addView(hint("Passive decode runs on " + (pe.passiveMode() == 2 ? "every analog channel" : pe.passiveMode() == 1 ? "flagged channels" : "no channel (off)") + ". Monitoring parks the radio on 144.390 MHz, acks messages for you" + (pe.digipeat() ? " and digipeats WIDE1-1" : "") + ". Your channel comes back when you stop."));
        // ---- DTMF ----
        body.addView(section("DTMF"));
        LinearLayout r4 = row();
        button(r4, "Send DTMF", Theme.VFO, x -> dtmfSend());
        button(r4, "Heard", Theme.SOFTSQ, x -> dtmfLog());
        body.addView(r4);
        body.addView(hint("Touch-tone keys heard on any analog channel are decoded and logged" + (pe.dtmfEnabled() ? "." : " (decoder off in Settings).")));
        // ---- Weather ----
        body.addView(section("NOAA weather alerts"));
        LinearLayout r5 = row();
        button(r5, "Alerts heard", Theme.REC, x -> wxLog());
        body.addView(r5);
        body.addView(hint("SAME alert headers on the 162.400–162.550 MHz weather channels are decoded automatically and raise a notification" + (pe.wxEnabled() ? "." : " (off in Settings).")));
        dlg = dialog(body);
    }

    private TextView status() {
        String call = pe.callsignSet() ? pe.myCall() : "no callsign set";
        String st = (pe.monitoring() ? "monitoring 144.390" : "passive") + (pe.kiss().isActive() ? " · KISS " + (pe.kiss().clientConnected() ? "client connected" : "waiting for a client") + " · " + pe.kiss().rxFrames() + " rx / " + pe.kiss().txFrames() + " tx" : "");
        return hint("🔸 " + call + "  ·  " + st);
    }

    // ---- APRS message ----
    private void message() {
        LinearLayout body = page("✉️  APRS message");
        final EditText to = field(body, "To (callsign-SSID)", "", InputType.TYPE_CLASS_TEXT | InputType.TYPE_TEXT_FLAG_CAP_CHARACTERS);
        final EditText text = field(body, "Message (up to 67 characters)", "", InputType.TYPE_CLASS_TEXT);
        body.addView(hint("Sent from " + (pe.callsignSet() ? pe.myCall() : "(set your callsign in Settings)") + " via " + String.join(",", pe.path()) + " with a message number, so the other station acks it."));
        LinearLayout r = row();
        button(r, "Send", Theme.PKT, x -> { String e = pe.sendMessage(to.getText().toString(), text.getText().toString()); toast(e == null ? "Message queued" : e); if (e == null) sub.dismiss(); });
        button(r, "Cancel", Theme.MON, x -> sub.dismiss());
        body.addView(r);
        sub = dialog(body);
    }
    private AlertDialog sub;

    // ---- DTMF send ----
    private void dtmfSend() {
        LinearLayout body = page("📟  Send DTMF");
        final EditText seq = field(body, "Keys (0-9, A-D, *, #)", "", InputType.TYPE_CLASS_TEXT | InputType.TYPE_TEXT_FLAG_CAP_CHARACTERS);
        LinearLayout pad = new LinearLayout(c); pad.setOrientation(LinearLayout.VERTICAL);
        String[] rows = { "123A", "456B", "789C", "*0#D" };
        for (String rr : rows) {
            LinearLayout line = row();
            for (char k : rr.toCharArray()) { final String ks = String.valueOf(k); TextView b = button(line, ks, Theme.SOFTSQ, x -> seq.append(ks)); b.setTextSize(18); }
            pad.addView(line);
        }
        body.addView(pad);
        LinearLayout r = row();
        button(r, "Transmit", Theme.PKT, x -> { String e = pe.sendDtmf(seq.getText().toString()); toast(e == null ? "DTMF queued" : e); if (e == null) sub.dismiss(); });
        button(r, "Clear", Theme.MON, x -> seq.setText(""));
        body.addView(r);
        sub = dialog(body);
    }

    // ---- lists ----
    private void stations() {
        LinearLayout body = page("📍  Stations heard");
        List<PacketStore.Station> list = pe.store().stations(200);
        android.location.Location me = svc.lastKnownLocation();
        if (list.isEmpty()) body.addView(hint("Nothing decoded yet. Positions, Mic-E, objects and NMEA reports land here with distance and bearing from you."));
        SimpleDateFormat f = new SimpleDateFormat("MM-dd HH:mm", Locale.US);
        for (PacketStore.Station s : list) {
            String dist = "";
            if (me != null) { float[] r = new float[2]; android.location.Location.distanceBetween(me.getLatitude(), me.getLongitude(), s.lat, s.lon, r); dist = String.format(Locale.US, "  %.1f mi %s", r[0] / 1609.344, compass(r[1])); }
            String extra = (s.speedKmh >= 0 ? String.format(Locale.US, " · %.0f mph", s.speedKmh * 0.621371) : "") + (s.alt != 0 ? " · " + Math.round(s.alt * 3.28084) + " ft" : "");
            LinearLayout rowv = shell();
            rowv.addView(Theme.label(c, s.call + dist, Theme.CYAN, 15, true));
            rowv.addView(Theme.label(c, f.format(new Date(s.lastTs)) + " · " + String.format(Locale.US, "%.4f, %.4f", s.lat, s.lon) + extra + (s.count > 1 ? " · " + s.count + "×" : "") + (s.via.isEmpty() ? "" : " · via " + s.via), 0xFFBFC8D0, 12, false));
            if (!s.comment.isEmpty()) rowv.addView(Theme.label(c, s.comment, 0xFF8A98A6, 12, false));
            final PacketStore.Station fs = s;
            rowv.setClickable(true); rowv.setOnClickListener(x -> {
                try { c.startActivity(new android.content.Intent(android.content.Intent.ACTION_VIEW, android.net.Uri.parse(String.format(Locale.US, "geo:%f,%f?q=%f,%f(%s)", fs.lat, fs.lon, fs.lat, fs.lon, android.net.Uri.encode(fs.call))))); } catch (Throwable t) { toast("No map app"); }
            });
            body.addView(rowv);
        }
        if (!list.isEmpty()) { LinearLayout r = row(); button(r, "Clear list", Theme.REC, x -> { pe.store().clearStations(); sub.dismiss(); }); body.addView(r); }
        sub = dialog(body);
    }

    private static String compass(float bearing) { float b = (bearing + 360) % 360; String[] dirs = { "N", "NE", "E", "SE", "S", "SW", "W", "NW" }; return dirs[(int) Math.round(b / 45.0) % 8]; }

    private void aprsLog() {
        LinearLayout body = page("📜  APRS log");
        List<PacketStore.LogEntry> list = pe.store().aprsLog(150);
        if (list.isEmpty()) body.addView(hint("Messages, acks, beacons, digipeats and status reports appear here, newest first."));
        SimpleDateFormat f = new SimpleDateFormat("MM-dd HH:mm:ss", Locale.US);
        for (PacketStore.LogEntry e : list) {
            String icon = e.kind.startsWith("msg") ? (e.kind.equals("msg-tx") ? "⬆️" : (e.mine ? "✉️" : "💬")) : e.kind.startsWith("ack") ? "✅" : e.kind.equals("beacon") ? "📍" : e.kind.equals("digi") ? "🔁" : e.kind.equals("pos") ? "📍" : "ℹ️";
            LinearLayout rowv = shell();
            rowv.addView(Theme.label(c, icon + " " + e.from + (e.to == null || e.to.isEmpty() ? "" : " → " + e.to) + (e.mine ? "  (for you)" : ""), e.mine ? Theme.AMBER : Theme.CYAN, 14, true));
            rowv.addView(Theme.label(c, f.format(new Date(e.ts)) + "  " + e.text + (e.id != null ? " {" + e.id : ""), 0xFFBFC8D0, 12, false));
            body.addView(rowv);
        }
        sub = dialog(body);
    }

    private void dtmfLog() {
        LinearLayout body = page("📟  DTMF heard");
        List<PacketStore.Dtmf> list = pe.store().dtmfLog(100);
        if (list.isEmpty()) body.addView(hint("No DTMF sequences decoded yet."));
        SimpleDateFormat f = new SimpleDateFormat("MM-dd HH:mm:ss", Locale.US);
        for (PacketStore.Dtmf e : list) {
            LinearLayout rowv = shell();
            rowv.addView(Theme.label(c, e.digits, Theme.CYAN, 18, true));
            rowv.addView(Theme.label(c, f.format(new Date(e.ts)) + "  ch " + e.channel + " " + e.channelName, 0xFFBFC8D0, 12, false));
            body.addView(rowv);
        }
        sub = dialog(body);
    }

    private void wxLog() {
        LinearLayout body = page("⛈️  Weather alerts heard");
        List<PacketStore.Alert> list = pe.store().alerts(100);
        if (list.isEmpty()) body.addView(hint("No SAME alert headers decoded yet. Park on a NOAA weather channel; the weekly test (RWT) is the usual first one you will see."));
        SimpleDateFormat f = new SimpleDateFormat("MM-dd HH:mm", Locale.US);
        for (PacketStore.Alert a : list) {
            LinearLayout rowv = shell();
            rowv.addView(Theme.label(c, (a.eom ? "End of message" : a.summary), a.eom ? 0xFF8A98A6 : Theme.AMBER, 14, true));
            rowv.addView(Theme.label(c, f.format(new Date(a.ts)) + "  " + a.raw, 0xFFBFC8D0, 11, false));
            body.addView(rowv);
        }
        sub = dialog(body);
    }

    // ---- settings ----
    private void settings() {
        final SharedPreferences p = pe.prefs();
        LinearLayout body = page("⚙️  APRS & packet settings");
        final EditText call = field(body, "Your callsign", p.getString("callsign", ""), InputType.TYPE_CLASS_TEXT | InputType.TYPE_TEXT_FLAG_CAP_CHARACTERS);
        final EditText ssid = field(body, "SSID (0–15; 7 = handheld, 9 = mobile)", String.valueOf(pe.ssid()), InputType.TYPE_CLASS_NUMBER);
        final EditText sym = field(body, "Symbol (table + code, e.g. /[ person, /> car, /- house)", p.getString("symTable", "/") + p.getString("symCode", "["), InputType.TYPE_CLASS_TEXT);
        final EditText comment = field(body, "Beacon comment", pe.comment(), InputType.TYPE_CLASS_TEXT);
        final EditText path = field(body, "Digipeater path", p.getString("path", "WIDE1-1,WIDE2-1"), InputType.TYPE_CLASS_TEXT | InputType.TYPE_TEXT_FLAG_CAP_CHARACTERS);
        final EditText port = field(body, "KISS TNC port", String.valueOf(pe.kissPort()), InputType.TYPE_CLASS_NUMBER);
        body.addView(section("Passive APRS decode"));
        final String[] modes = { "Off", "Flagged channels", "Every analog channel" };
        final int[] passive = { pe.passiveMode() };
        final TextView modeV = cycle(body, "Decode on", modes, passive[0], v -> passive[0] = v);
        final boolean[] flags = { pe.autoAck(), pe.digipeat(), pe.dtmfEnabled(), pe.wxEnabled() };
        toggle(body, "Auto-ack messages addressed to me (monitoring)", flags, 0);
        toggle(body, "Fill-in digipeater for WIDE1-1 (monitoring)", flags, 1);
        toggle(body, "DTMF decoder", flags, 2);
        toggle(body, "NOAA SAME weather alerts", flags, 3);
        LinearLayout r = row();
        button(r, "Save", Theme.PKT, x -> {
            try {
                String s = sym.getText().toString().trim();
                p.edit().putString("callsign", call.getText().toString().trim().toUpperCase(Locale.US))
                        .putInt("ssid", Math.max(0, Math.min(15, Integer.parseInt(ssid.getText().toString().trim()))))
                        .putString("symTable", s.length() >= 1 ? s.substring(0, 1) : "/").putString("symCode", s.length() >= 2 ? s.substring(1, 2) : "[")
                        .putString("comment", comment.getText().toString().trim()).putString("path", path.getText().toString().trim().toUpperCase(Locale.US))
                        .putInt("kissPort", Integer.parseInt(port.getText().toString().trim())).putInt("passive", passive[0])
                        .putBoolean("autoAck", flags[0]).putBoolean("digipeat", flags[1]).putBoolean("dtmf", flags[2]).putBoolean("wx", flags[3]).apply();
                toast("Saved"); sub.dismiss();
            } catch (NumberFormatException e) { toast("Check the numbers"); }
        });
        button(r, "Cancel", Theme.MON, x -> sub.dismiss());
        body.addView(r);
        sub = dialog(body);
    }

    private void toggle(LinearLayout body, String label, final boolean[] flags, final int i) {
        LinearLayout rowv = shell(); rowv.setOrientation(LinearLayout.HORIZONTAL); rowv.setGravity(Gravity.CENTER_VERTICAL);
        rowv.addView(Theme.label(c, label, 0xFFBFC8D0, 14, false), new LinearLayout.LayoutParams(0, LinearLayout.LayoutParams.WRAP_CONTENT, 1f));
        final TextView v = Theme.label(c, flags[i] ? "ON" : "OFF", flags[i] ? Theme.PKT[3] : 0xFF8A98A6, 13, true);
        v.setBackground(Theme.rounded(c, flags[i] ? Theme.PKT[0] : 0x18000000, flags[i] ? Theme.PKT[2] : 0x3300BFFF, 1, 14)); v.setPadding(dp(12), dp(6), dp(12), dp(6));
        rowv.addView(v);
        View.OnClickListener cl = x -> { flags[i] = !flags[i]; v.setText(flags[i] ? "ON" : "OFF"); v.setTextColor(flags[i] ? Theme.PKT[3] : 0xFF8A98A6); v.setBackground(Theme.rounded(c, flags[i] ? Theme.PKT[0] : 0x18000000, flags[i] ? Theme.PKT[2] : 0x3300BFFF, 1, 14)); };
        rowv.setClickable(true); rowv.setOnClickListener(cl); v.setOnClickListener(cl);
        body.addView(rowv);
    }

    // ---- widgets ----
    private interface IntSetter { void set(int v); }
    private int dp(float x) { return Math.round(x * d); }
    private void toast(String s) { Toast.makeText(c, s, Toast.LENGTH_LONG).show(); }

    private LinearLayout page(String title) {
        LinearLayout body = new LinearLayout(c); body.setOrientation(LinearLayout.VERTICAL); body.setBackgroundColor(Theme.BG); body.setPadding(dp(16), dp(12), dp(16), dp(8));
        body.addView(Theme.label(c, title, Theme.PKT[3], 20, true));
        return body;
    }
    private AlertDialog dialog(LinearLayout body) {
        ScrollView sv = new ScrollView(c); sv.addView(body);
        AlertDialog a = new AlertDialog.Builder(c).setView(sv).create();
        if (a.getWindow() != null) a.getWindow().setBackgroundDrawable(new ColorDrawable(Theme.BG));
        a.show();
        return a;
    }
    private TextView hint(String s) { TextView t = Theme.label(c, s, 0xFF8A98A6, 12, false); t.setPadding(0, dp(4), 0, dp(6)); return t; }
    private TextView section(String s) { TextView t = Theme.label(c, s, 0xFFBFC8D0, 13, true); t.setPadding(0, dp(10), 0, dp(4)); return t; }
    private LinearLayout row() {
        LinearLayout r = new LinearLayout(c); r.setOrientation(LinearLayout.HORIZONTAL); r.setGravity(Gravity.CENTER_VERTICAL);
        LinearLayout.LayoutParams lp = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, LinearLayout.LayoutParams.WRAP_CONTENT); lp.topMargin = dp(2); lp.bottomMargin = dp(4); r.setLayoutParams(lp);
        return r;
    }
    private TextView button(LinearLayout row, String text, int[] accent, View.OnClickListener l) {
        TextView b = Theme.label(c, text, accent[3], 13, true); b.setGravity(Gravity.CENTER);
        b.setBackground(Theme.rounded(c, accent[0], accent[2], 2, 18)); b.setPadding(dp(6), dp(10), dp(6), dp(10)); b.setClickable(true); b.setOnClickListener(l);
        LinearLayout.LayoutParams lp = new LinearLayout.LayoutParams(0, LinearLayout.LayoutParams.WRAP_CONTENT, 1f); lp.setMargins(dp(3), dp(2), dp(3), dp(2));
        row.addView(b, lp);
        return b;
    }
    private LinearLayout shell() {
        LinearLayout r = new LinearLayout(c); r.setOrientation(LinearLayout.VERTICAL);
        r.setBackground(Theme.rounded(c, 0x18000000, 0x3300BFFF, 1, 8)); r.setPadding(dp(12), dp(8), dp(12), dp(8));
        LinearLayout.LayoutParams lp = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, LinearLayout.LayoutParams.WRAP_CONTENT); lp.bottomMargin = dp(6); r.setLayoutParams(lp);
        return r;
    }
    private EditText field(LinearLayout target, String label, String value, int inputType) {
        LinearLayout r = shell(); r.addView(Theme.label(c, label, 0xFF9AA4AE, 12, false));
        EditText e = new EditText(c); e.setText(value); e.setInputType(inputType); e.setTextSize(17); e.setTextColor(Theme.WHITE); e.setSingleLine(true); e.setBackground(null); e.setPadding(0, dp(4), 0, dp(4));
        r.addView(e); target.addView(r);
        return e;
    }
    private TextView cycle(LinearLayout target, String label, final String[] options, int index, final IntSetter setter) {
        LinearLayout r = shell(); r.setOrientation(LinearLayout.HORIZONTAL); r.setGravity(Gravity.CENTER_VERTICAL);
        r.addView(Theme.label(c, label, 0xFFBFC8D0, 14, false), new LinearLayout.LayoutParams(0, LinearLayout.LayoutParams.WRAP_CONTENT, 1f));
        final TextView v = Theme.label(c, options[index], Theme.CYAN, 14, true); v.setBackground(Theme.rounded(c, 0x1400E5FF, 0x8000E5FF, 1, 14)); v.setPadding(dp(12), dp(6), dp(12), dp(6));
        r.addView(v);
        final int[] cur = { index };
        View.OnClickListener cl = x -> { cur[0] = (cur[0] + 1) % options.length; v.setText(options[cur[0]]); setter.set(cur[0]); };
        r.setClickable(true); r.setOnClickListener(cl); v.setOnClickListener(cl);
        target.addView(r);
        return v;
    }
}
