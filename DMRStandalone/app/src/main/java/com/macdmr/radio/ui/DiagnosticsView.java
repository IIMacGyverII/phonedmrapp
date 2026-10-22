/*
 * SignalDeck - Copyright (C) 2026 IIMacGyverII
 * SPDX-License-Identifier: GPL-3.0-or-later
 * Free software under the GNU General Public License v3 or later, with the additional terms in COPYRIGHT
 * (keep this notice and the author credit, mark modified versions, no rights to the SignalDeck name or icon).
 */
package com.macdmr.radio.ui;

import android.content.Context;
import android.graphics.Typeface;
import android.text.method.ScrollingMovementMethod;
import android.view.Gravity;
import android.widget.LinearLayout;
import android.widget.ScrollView;
import android.widget.TextView;

import com.macdmr.radio.ChannelStore;
import com.macdmr.radio.RadioService;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;

/** Engine log and link controls (the spike UI), reachable from Settings → Diagnostics. */
public class DiagnosticsView extends LinearLayout implements RadioService.Listener {
    private final TextView log, state;
    private final SimpleDateFormat tf = new SimpleDateFormat("HH:mm:ss.SSS", Locale.US);
    private RadioService svc;

    public DiagnosticsView(Context c) {
        super(c);
        setOrientation(VERTICAL); setBackgroundColor(Theme.BG);
        int pad = Theme.dp(c, 10); setPadding(pad, pad, pad, pad);
        state = Theme.label(c, "", Theme.CYAN, 13, false); state.setTypeface(Typeface.MONOSPACE); addView(state);
        LinearLayout row = new LinearLayout(c); row.setGravity(Gravity.CENTER);
        TextView up = Theme.pillButton(c, "Bring radio up"), down = Theme.pillButton(c, "Release (stock app on)"), rssi = Theme.pillButton(c, "RSSI"), clear = Theme.pillButton(c, "Clear");
        for (TextView t : new TextView[] { up, down, rssi, clear }) { LayoutParams p = new LayoutParams(0, LayoutParams.WRAP_CONTENT, 1f); p.setMargins(4, 8, 4, 8); row.addView(t, p); }
        addView(row);
        up.setOnClickListener(v -> { if (svc != null) svc.bringUp(); });
        TextView ver = Theme.pillButton(c, "Module version"), cyc = Theme.pillButton(c, "Power-cycle module"), tone = Theme.pillButton(c, "1 kHz test tone (3 s)");
        ver.setOnClickListener(v -> { if (svc != null) svc.diagVersion(); });
        cyc.setOnClickListener(v -> { if (svc != null) new android.app.AlertDialog.Builder(c).setTitle("Power-cycle the radio module?").setMessage("Pulls the module's power line low and back up, waits for its boot banner and re-applies the channel. Use it if the radio stops answering.").setPositiveButton("Power-cycle", (d, w) -> svc.diagPowerCycle()).setNegativeButton("Cancel", null).show(); });
        tone.setOnClickListener(v -> { if (svc != null) new android.app.AlertDialog.Builder(c).setTitle("Transmit a 3 s test tone?").setMessage("Keys the radio on the current channel with a 1 kHz tone, for a bench receiver or SDR.").setPositiveButton("Transmit", (d, w) -> svc.diagTestTone(3000)).setNegativeButton("Cancel", null).show(); });
        LinearLayout row2 = new LinearLayout(c); row2.setGravity(Gravity.CENTER);
        for (TextView t : new TextView[] { ver, cyc, tone }) { LayoutParams p = new LayoutParams(0, LayoutParams.WRAP_CONTENT, 1f); p.setMargins(4, 0, 4, 8); row2.addView(t, p); }
        addView(row2);
        TextView rt = Theme.pillButton(c, "Check backup round trip");
        LayoutParams rtl = new LayoutParams(LayoutParams.MATCH_PARENT, LayoutParams.WRAP_CONTENT); rtl.setMargins(4, 0, 4, 8); addView(rt, rtl);
        rt.setOnClickListener(v -> { if (svc == null) return; say("backup round trip: exporting and restoring into a scratch database…");
            new Thread(() -> { final String r = com.macdmr.radio.Backup.selfTest(c, svc.store(), svc.packet() != null ? svc.packet().dtmfSaved() : null); post(() -> { for (String l : r.split("\n")) say(l); new android.app.AlertDialog.Builder(c).setTitle("Backup round trip").setMessage(r).setPositiveButton("OK", null).show(); }); }).start(); });
        TextView cm = Theme.pillButton(c, "Post a test car message");
        LayoutParams cml = new LayoutParams(LayoutParams.MATCH_PARENT, LayoutParams.WRAP_CONTENT); cml.setMargins(4, 0, 4, 8); addView(cm, cml);
        cm.setOnClickListener(v -> { com.macdmr.radio.CarMessages.test(c); say("test message posted (shows on the phone and in Android Auto; its reply is not sent)"); });
        down.setOnClickListener(v -> { if (svc != null) svc.shutDown(true); });
        rssi.setOnClickListener(v -> { if (svc != null) svc.pollRssi(); });
        ScrollView sv = new ScrollView(c);
        log = new TextView(c); log.setTextSize(11); log.setTypeface(Typeface.MONOSPACE); log.setTextColor(0xFFB0E8F0); log.setMovementMethod(new ScrollingMovementMethod());
        sv.addView(log);
        clear.setOnClickListener(v -> { lines.clear(); log.setText(""); });
        addView(sv, new LayoutParams(LayoutParams.MATCH_PARENT, 0, 1f));
    }

    public void attach(RadioService s) { svc = s; s.addListener(this); state.setText("profile " + s.profile().name + " · uart " + s.profile().controlPort + " · audio " + s.profile().audio); }
    public void detach() { if (svc != null) svc.removeListener(this); svc = null; }

    /** Last 300 lines only, and the text view is refreshed only while this page is on screen: an unbounded TextView.append
     *  copied the whole log on every radio frame (10 a second while receiving) and slowed every page down over a session. */
    private static final int MAX_LINES = 300;
    private final java.util.ArrayDeque<String> lines = new java.util.ArrayDeque<>();
    private boolean dirty;
    private void say(String s) {
        lines.addLast(tf.format(new Date()) + " " + s); while (lines.size() > MAX_LINES) lines.removeFirst();
        if (isShown()) render(); else dirty = true;
    }
    private void render() {
        StringBuilder sb = new StringBuilder(lines.size() * 60); for (String l : lines) sb.append(l).append('\n');
        log.setText(sb); dirty = false;
    }
    @Override protected void onAttachedToWindow() {
        super.onAttachedToWindow();
        if (svc != null) { svc.setUiLog(true); lines.clear(); lines.addAll(svc.recentLog()); dirty = true; }   // the service kept the lines while this page was closed
        if (dirty) render();
    }
    @Override protected void onDetachedFromWindow() { super.onDetachedFromWindow(); if (svc != null) svc.setUiLog(false); }

    @Override public void onChannel(ChannelStore.Channel ch) { say("channel " + ch.number + " " + ch.name); }
    @Override public void onRx(boolean r) { say(r ? "RECEIVE_START" : "RECEIVE_STOP"); }
    @Override public void onTx(boolean t) { say(t ? "SEND_START" : "SEND_STOP"); }
    @Override public void onRssi(int dbm) { say("RSSI " + dbm + " dBm"); }
    @Override public void onAudioLevel(int a) { }
    @Override public void onHistory(String line) { }
    @Override public void onCaller(String text) { say("caller " + text); }
    @Override public void onLog(String s) { say(s); }
    @Override public void onLink(String st) { say("link: " + st); }
    @Override public void onSms(int from, int type, String text) { }
    @Override public void onSmsResult(boolean ok) { }
    @Override public void onLocation(String text) { }
    @Override public void onModes(boolean a, int b, boolean c2, boolean d2, boolean e, boolean f2, boolean g, String z) { }
    @Override public void onCaption(boolean en, String live, String sentence) { }
}
