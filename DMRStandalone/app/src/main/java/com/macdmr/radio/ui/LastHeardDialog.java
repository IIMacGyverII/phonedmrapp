package com.macdmr.radio.ui;

import android.app.AlertDialog;
import android.content.Context;
import android.graphics.drawable.ColorDrawable;
import android.view.Gravity;
import android.widget.LinearLayout;
import android.widget.ScrollView;
import android.widget.TextView;

import com.macdmr.radio.ChannelStore;
import com.macdmr.radio.RadioService;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;

/** Last heard: who and which channel had activity, newest first, with names from contacts and the RadioID list. Tap to switch. */
public final class LastHeardDialog {
    private static final class Row { int channel, dmrId, count; long ts; String kind, text; }

    public static void show(Context c, RadioService svc) {
        float d = Theme.dp(c);
        LinearLayout body = Neo.sheetBody(c, "Last heard");
        TextView hint = Neo.label(c, "Newest first across every channel: alerts and car events, then who called, text and APRS traffic, what was recorded. Tap an alert or event for what it means; tap a heard line to switch to that channel.", 0xFF8A98A6, 12, false);
        hint.setPadding(0, (int) (4 * d), 0, (int) (8 * d)); body.addView(hint);
        LinearLayout tools = new LinearLayout(c); tools.setGravity(Gravity.CENTER);
        tools.setBaselineAligned(false);
        for (String[] t : new String[][] { { "Recordings", "rec" }, { "Captions", "txt" } }) {
            TextView b = Neo.button(c, t[0], t[1], t[1].equals("rec") ? Neo.RED : Neo.VIOLET); b.setTextSize(14);
            final boolean rec = t[1].equals("rec");
            b.setOnClickListener(v -> { if (rec) MediaDialogs.recordings(c, svc); else MediaDialogs.captions(c, svc); });
            LinearLayout.LayoutParams lp = new LinearLayout.LayoutParams(0, LinearLayout.LayoutParams.WRAP_CONTENT, 1f); lp.setMargins((int) (3 * d), (int) (6 * d), (int) (3 * d), (int) (10 * d)); tools.addView(b, lp);
        }
        body.addView(tools);

        final AlertDialog[] sheet = new AlertDialog[1];
        eventSections(c, svc, body, sheet);

        body.addView(Neo.sheetSection(c, "Heard"));
        LinkedHashMap<String, Row> rows = new LinkedHashMap<>();
        for (Object[] h : svc.store().lastHeard(400)) {
            Row r = new Row(); r.ts = (Long) h[0]; r.channel = (Integer) h[1]; r.kind = (String) h[2]; r.text = (String) h[3]; r.dmrId = (Integer) h[4];
            if (isAlert(r.text)) continue;   // a refusal is not something heard: it is listed under Alerts
            String key = r.channel + ":" + (r.kind.equals("dmr") || r.kind.equals("sms") ? r.dmrId : r.kind);
            Row e = rows.get(key);
            if (e == null) { r.count = 1; rows.put(key, r); } else e.count++;
        }
        SimpleDateFormat f = new SimpleDateFormat("MM-dd HH:mm:ss", Locale.US);
        if (rows.isEmpty()) body.addView(Neo.label(c, "Nothing heard yet.", 0xFFBFC8D0, 14, false));
        List<Row> list = new ArrayList<>(rows.values());
        for (Row r : list) {
            ChannelStore.Channel ch = svc.store().byNumber(r.channel);
            String chName = ch != null ? ch.name : (r.channel == 0 ? "VFO" : "channel " + r.channel);
            String who = r.dmrId > 0 ? svc.callerName(r.dmrId) : "";
            String title = (r.dmrId > 0 ? (who.isEmpty() ? "ID " + r.dmrId : who + "  ·  " + r.dmrId) : r.text.length() > 48 ? r.text.substring(0, 48) + "…" : r.text);
            LinearLayout rowv = new LinearLayout(c); rowv.setOrientation(LinearLayout.VERTICAL);
            rowv.setBackground(Neo.rowCard(c)); rowv.setPadding((int) (12 * d), (int) (8 * d), (int) (12 * d), (int) (8 * d));
            LinearLayout.LayoutParams lp = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, LinearLayout.LayoutParams.WRAP_CONTENT); lp.bottomMargin = (int) (6 * d);
            rowv.addView(Neo.label(c, title, r.dmrId > 0 ? Theme.AMBER : Theme.CYAN, 15, true));
            rowv.addView(Neo.label(c, f.format(new Date(r.ts)) + "  ·  " + chName + (r.count > 1 ? "  ·  " + r.count + "×" : "") + (r.dmrId > 0 && !r.text.isEmpty() ? "\n" + r.text : ""), 0xFFBFC8D0, 12, false));
            final int chNum = r.channel;
            rowv.setClickable(true);
            body.addView(rowv, lp);
            AlertDialog[] holder = new AlertDialog[1];
            rowv.setOnClickListener(v -> { if (chNum > 0) { svc.selectChannel(chNum); if (holder[0] != null) holder[0].dismiss(); } });
            rowv.setTag(holder);
        }
        AlertDialog a = Neo.showSheet(c, body); sheet[0] = a;
        for (int i = 0; i < body.getChildCount(); i++) { Object t = body.getChildAt(i).getTag(); if (t instanceof AlertDialog[]) ((AlertDialog[]) t)[0] = a; }

    }

    // ---- Alerts and Events: warnings, refusals, car and coverage milestones, each with what it means ----
    private static final long WEEK = 7L * 24 * 3600 * 1000;
    static boolean isAlert(String t) { return t != null && (t.startsWith("⛔") || t.startsWith("⚠")); }

    private static void eventSections(Context c, RadioService svc, LinearLayout body, AlertDialog[] sheet) {
        float d = Theme.dp(c);
        List<Object[]> ev = svc.store().events(System.currentTimeMillis() - WEEK, 300);
        List<Row> alerts = new ArrayList<>(), events = new ArrayList<>();
        Row prevA = null, prevE = null;
        for (Object[] h : ev) {
            Row r = new Row(); r.ts = (Long) h[0]; r.channel = (Integer) h[1]; r.kind = (String) h[2]; r.text = (String) h[3]; r.count = 1;
            boolean alert = isAlert(r.text) || "busy".equals(r.kind) || "alert".equals(r.kind) || "warn".equals(r.kind);
            Row prev = alert ? prevA : prevE;
            if (prev != null && prev.text.equals(r.text) && prev.channel == r.channel) { prev.count++; continue; }   // a run of the same line: one row, n×
            if (alert) { if (alerts.size() < 10) alerts.add(r); prevA = r; } else { if (events.size() < 15) events.add(r); prevE = r; }
        }
        SimpleDateFormat f = new SimpleDateFormat("MM-dd HH:mm:ss", Locale.US);
        if (!alerts.isEmpty()) body.addView(Neo.sheetSection(c, "Alerts (last 7 days)"));
        for (Row r : alerts) body.addView(eventRow(c, svc, r, f, true, sheet), rowLp(d));
        if (!events.isEmpty()) body.addView(Neo.sheetSection(c, "Car and coverage"));
        for (Row r : events) body.addView(eventRow(c, svc, r, f, false, sheet), rowLp(d));
    }

    private static LinearLayout.LayoutParams rowLp(float d) {
        LinearLayout.LayoutParams lp = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, LinearLayout.LayoutParams.WRAP_CONTENT); lp.bottomMargin = (int) (6 * d); return lp;
    }

    private static String chName(RadioService svc, int n) { ChannelStore.Channel ch = svc.store().byNumber(n); return ch != null ? ch.name : (n == 0 ? "VFO" : "channel " + n); }

    private static LinearLayout eventRow(Context c, RadioService svc, Row r, SimpleDateFormat f, boolean alert, AlertDialog[] sheet) {
        float d = Theme.dp(c);
        LinearLayout v = new LinearLayout(c); v.setOrientation(LinearLayout.VERTICAL);
        v.setBackground(alert ? Neo.tint(c, Neo.AMBER, 12, 1) : Neo.rowCard(c)); v.setPadding((int) (12 * d), (int) (8 * d), (int) (12 * d), (int) (8 * d));
        v.addView(Neo.label(c, r.text, alert ? Theme.AMBER : Theme.CYAN, 14, true));
        v.addView(Neo.label(c, f.format(new Date(r.ts)) + "  ·  " + chName(svc, r.channel) + (r.count > 1 ? "  ·  " + r.count + "×" : "") + "  ·  tap for details", 0xFFBFC8D0, 12, false));
        v.setClickable(true);
        v.setOnClickListener(x -> details(c, svc, r, sheet));
        return v;
    }

    /** One alert or event: what it means, what to do, and what else happened around it. */
    private static void details(Context c, RadioService svc, Row r, AlertDialog[] sheet) {
        float d = Theme.dp(c);
        String[] ex = explain(r.text);
        LinearLayout box = Neo.sheetBody(c, ex[0]);
        box.addView(Neo.label(c, r.text, isAlert(r.text) ? Theme.AMBER : Theme.CYAN, 14.5f, true));
        ChannelStore.Channel ch = svc.store().byNumber(r.channel);
        String when = new SimpleDateFormat("EEE MMM d, HH:mm:ss", Locale.US).format(new Date(r.ts)) + (r.count > 1 ? " (latest of " + r.count + " in a row)" : "");
        String where = ch == null ? chName(svc, r.channel) : ch.name + "  ·  TX " + String.format(Locale.US, "%.4f", ch.txFreq / 1e6) + " / RX " + String.format(Locale.US, "%.4f", ch.rxFreq / 1e6) + " MHz  ·  " + (ch.isDigital() ? "DMR" : "FM") + ", " + (ch.power == 1 ? "high" : "low") + " power";
        box.addView(Neo.sheetHint(c, when + "\n" + where));
        if (!ex[1].isEmpty()) { TextView t = Neo.label(c, ex[1], 0xFFD6DEE6, 13.5f, false); t.setLineSpacing(0, 1.12f); t.setPadding(0, (int) (6 * d), 0, (int) (4 * d)); box.addView(t); }
        List<Object[]> near = svc.store().around(r.ts, 20_000);
        if (near.size() > 1) {
            box.addView(Neo.sheetSection(c, "Around this time (±20 s)"));
            SimpleDateFormat hf = new SimpleDateFormat("HH:mm:ss", Locale.US);
            StringBuilder sb = new StringBuilder();
            for (Object[] h : near) { long ts = (Long) h[0]; sb.append(ts == r.ts ? "▶ " : "   ").append(hf.format(new Date(ts))).append("  ").append((String) h[3]).append('\n'); }
            TextView t = Neo.label(c, sb.substring(0, sb.length() - 1), 0xFFBFC8D0, 12, false); t.setTypeface(Neo.mono(c)); box.addView(t);
        }
        LinearLayout.LayoutParams bl = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, LinearLayout.LayoutParams.WRAP_CONTENT); bl.setMargins(0, (int) (10 * d), 0, 0);
        final AlertDialog[] self = new AlertDialog[1];
        if (r.text.contains("hiding DMR Radio")) {
            TextView open = Neo.button(c, "Open Android Auto settings", "intercom", Neo.AMBER); box.addView(open, bl);
            open.setOnClickListener(x -> { try { c.startActivity(com.macdmr.radio.car.AutoTrust.settingsIntent(c)); } catch (Throwable t) { android.widget.Toast.makeText(c, "Could not open Android Auto: " + t.getMessage(), android.widget.Toast.LENGTH_LONG).show(); } });
        }
        if (ch != null && (svc.current() == null || svc.current().number != ch.number)) {
            TextView tune = Neo.button(c, "Tune " + ch.name, "channels", Neo.CYAN); box.addView(tune, new LinearLayout.LayoutParams(bl));
            tune.setOnClickListener(x -> { svc.selectChannel(ch.number); if (self[0] != null) self[0].dismiss(); if (sheet[0] != null) sheet[0].dismiss(); });
        }
        self[0] = Neo.showSheet(c, box);
    }

    /** {title, explanation} for a history line, matched on its wording (the lines come from RadioService, CoverageLogger and PacketEngine). */
    static String[] explain(String t) {
        if (t.contains("while transmitting") && (t.contains("Android Auto dropped") || t.contains("USB cable dropped")))
            return new String[] { "Talking knocked out the USB cable", "While you transmitted on this channel the phone's USB port reset: the phone stopped charging and, with Android Auto on a cable, the car disconnected until you stopped talking. It does not matter which Talk button you used.\n\nThe radio's own signal gets into the USB cable. Whether it does depends on the frequency, not on where the antenna is: in one car a 2 m repeater transmitting on 144.770 MHz at high power did it every time, while 146.370 MHz did not.\n\nWhat helps:\n• a snap-on ferrite choke on the cable, close to the phone\n• a shorter, better-shielded cable\n• Low power for this channel (Channels → edit the channel)\n• wireless Android Auto, if the car has it" };
        if (t.contains("did not load DMR Radio"))
            return new String[] { "Android Auto skipped the radio", "Android Auto connected but never loaded the radio on this connection (normally it does within a few seconds), so DMR Radio was missing from the car's app list and its card opened the app on the phone. Unknown sources was on, so this is Android Auto's own hiccup, seen once after it had just started up. Unplug the USB cable and plug it in again: on the new connection it loads the radio." };
        if (t.contains("hiding DMR Radio"))
            return new String[] { "Android Auto is hiding the radio", "Android Auto only trusts apps installed from the Play Store. For this app it plays the sound and the steering-wheel buttons work, but DMR Radio is missing from the car's app list and tapping its card opens the app on the phone.\n\n" + com.macdmr.radio.car.AutoTrust.steps(com.macdmr.radio.car.AutoTrust.State.OFF) };
        if (t.contains("took the sound away"))
            return new String[] { "The car played something else", "Another source started playing in the car (music, an audio app, the car's own radio, or a call), so Android Auto gave it the speakers and the radio's sound paused. The radio keeps receiving, recording and decoding meanwhile. Press play on the radio's card or media screen to get the speakers back. Just before a disconnection this line is normal: Android Auto takes the sound away as it closes." };
        if (t.contains("Android Auto connected"))
            return new String[] { "Android Auto connected", "The phone connected to the car. In brackets: what the car lists for the radio, the media app (DMR Radio) or the full-screen Radio controls (Device → Full-screen Radio controls in the car)." };
        if (t.contains("Android Auto disconnected"))
            return new String[] { "Android Auto disconnected", "The connection to the car ended: the car was switched off, the cable was unplugged, or the link dropped. Look at Around this time below: if you were transmitting just before (a Voice TX line), the transmission probably disturbed the USB cable, and an alert says so when the app noticed." };
        if (t.contains("Android Auto opened"))
            return new String[] { "The car opened the radio", "Android Auto opened the radio's screen in the car (the media app's channel list, or Radio controls)." };
        if (t.contains("No reply from"))
            return new String[] { "No reply from the repeater", "After you transmitted on this repeater channel, the app listened for the repeater's answer (its signal coming back after you let go) and heard none. The coverage map marks this spot as not reaching the repeater. Either the repeater did not hear you, or you could not hear it." };
        if (t.contains("Keyed "))
            return new String[] { "The repeater answered", "After you transmitted, the repeater's signal came back: this spot reaches it. The level is the repeater's tail as heard here, and the coverage map records it." };
        if (t.contains("Coverage logging"))
            return new String[] { "Coverage logging", "Coverage logging records the signal and your key-ups with GPS for the coverage maps (Map → Coverage). With Device → Log coverage in the car on, it starts when Android Auto connects and stops when it disconnects." };
        if (t.contains("receive-only"))
            return new String[] { "Receive-only channel", "NOAA weather channels (162.400 to 162.550 MHz) marine VHF channels (156.000 to 157.450 MHz) and the AAR railroad channels (159.810 to 161.565 MHz) are receive-only. The radio does not transmit there, whatever button is pressed." };
        if (t.contains("30 s transmit limit"))
            return new String[] { "Too long to send", "This radio's firmware ends every transmission after 30 seconds, so the app refuses audio longer than about 28.5 seconds (for example a long recording or an SSTV mode that needs more time)." };
        if (t.contains("Channel busy"))
            return new String[] { "Channel busy", "The radio refused to transmit because the channel was busy: another station was on it, or on DMR the repeater's time slot was in use. Wait for it to clear and try again." };
        if (t.contains("Keyword"))
            return new String[] { "Keyword heard", "Live captions heard one of your keywords in received speech. Keywords are set on the intercom: long-press TXT → Keywords." };
        if (t.contains("Not sent"))
            return new String[] { "Not sent", "The transmission was refused before keying. Packet radio (APRS, DTMF, SSTV) needs an analog FM channel: AFSK tones cannot go out over DMR. Tune an FM channel and try again." };
        return new String[] { isAlert(t) ? "Alert" : "Event", "" };
    }
}
