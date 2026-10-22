/*
 * SignalDeck - Copyright (C) 2026 IIMacGyverII
 * SPDX-License-Identifier: GPL-3.0-or-later
 * Free software under the GNU General Public License v3 or later, with the additional terms in COPYRIGHT
 * (keep this notice and the author credit, mark modified versions, no rights to the SignalDeck name or icon).
 */
package com.macdmr.radio;

import android.app.PendingIntent;
import android.appwidget.AppWidgetManager;
import android.appwidget.AppWidgetProvider;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.widget.RemoteViews;
import android.widget.Toast;

/**
 * Home-screen widget and the notification's buttons. Both send {@link #ACTION} broadcasts here; the commands go to
 * the running {@link RadioService}. Talk is tap-to-start / tap-to-stop (a widget cannot see a held finger) and the
 * service's 28 s transmit watchdog ends it before the firmware's 30 s limit.
 */
public class RadioWidget extends AppWidgetProvider {
    public static final String ACTION = "com.macdmr.radio.CONTROL";
    public static final String CMD_PREV = "prev", CMD_NEXT = "next", CMD_SCAN = "scan", CMD_TALK = "talk";

    @Override public void onUpdate(Context c, AppWidgetManager m, int[] ids) { refresh(c, RadioService.running); }

    @Override public void onReceive(Context c, Intent i) {
        super.onReceive(c, i);
        if (!ACTION.equals(i.getAction())) return;
        String cmd = i.getStringExtra("cmd");
        RadioService s = RadioService.running;
        if (s == null || !s.isReady()) { Toast.makeText(c, "Open the radio app first: the radio is not on", Toast.LENGTH_SHORT).show(); refresh(c, s); return; }
        if (CMD_PREV.equals(cmd)) s.stepChannel(-1);
        else if (CMD_NEXT.equals(cmd)) s.stepChannel(1);
        else if (CMD_SCAN.equals(cmd)) { String r = s.toggleScan(); if (r != null) Toast.makeText(c, r, Toast.LENGTH_SHORT).show(); }
        else if (CMD_TALK.equals(cmd)) {
            if (s.pttHeld()) s.ptt(false);
            else if (s.txInhibited()) Toast.makeText(c, "This channel is receive-only", Toast.LENGTH_SHORT).show();
            else s.ptt(true);
        }
    }

    static PendingIntent command(Context c, String cmd, int code) {
        Intent i = new Intent(c, RadioWidget.class).setAction(ACTION).putExtra("cmd", cmd);
        return PendingIntent.getBroadcast(c, code, i, PendingIntent.FLAG_UPDATE_CURRENT | PendingIntent.FLAG_IMMUTABLE);
    }

    static PendingIntent openApp(Context c) {
        Intent i = new Intent(c, MainActivity.class).addFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_SINGLE_TOP);
        return PendingIntent.getActivity(c, 10, i, PendingIntent.FLAG_UPDATE_CURRENT | PendingIntent.FLAG_IMMUTABLE);
    }

    /** One line for the widget and the notification: TX / receiving / scanning / ready, or the link state. */
    public static String status(RadioService s) {
        if (s == null) return "Radio off · tap to open";
        if (!s.isReady()) return "Radio " + s.link();
        ChannelStore.Channel ch = s.current();
        String f = ch == null ? "" : ch.freqText(ch.rxFreq) + " MHz · ";
        if (s.coverageLogging() && !s.isTransmitting() && !s.hearing()) f = f + "Mapping coverage · ";
        if (s.isTransmitting()) return f + "TRANSMITTING";
        if (s.hearing()) return f + "Receiving";
        if (s.isScanning()) return f + (s.isScanHolding() ? "Scan holding" : "Scanning " + s.zoneName());
        return f + "Ready";
    }

    private static android.graphics.Typeface orbitron;
    /** The channel number in the intercom's neon Orbitron digits (launchers cannot load an app's fonts, so it is drawn here). */
    static android.graphics.Bitmap numberBitmap(Context c, String text, int color) {
        float d = c.getResources().getDisplayMetrics().density;
        if (orbitron == null) { try { orbitron = android.graphics.Typeface.createFromAsset(c.getAssets(), "fonts/orbitron.ttf"); } catch (Throwable t) { orbitron = android.graphics.Typeface.DEFAULT_BOLD; } }
        android.graphics.Paint p = new android.graphics.Paint(android.graphics.Paint.ANTI_ALIAS_FLAG);
        p.setTypeface(orbitron); p.setTextSize(36 * d); p.setColor(color); p.setFakeBoldText(true);
        float glow = 9 * d; p.setShadowLayer(glow, 0, 0, (color & 0x00FFFFFF) | 0xB0000000);
        android.graphics.Paint.FontMetrics fm = p.getFontMetrics();
        int w = (int) (p.measureText(text) + 2 * glow + 2), h = (int) (fm.descent - fm.ascent + 2 * glow);
        android.graphics.Bitmap b = android.graphics.Bitmap.createBitmap(w, h, android.graphics.Bitmap.Config.ARGB_8888);
        new android.graphics.Canvas(b).drawText(text, glow, glow - fm.ascent, p);
        return b;
    }

    public static void refresh(Context c, RadioService s) {
        try {
            AppWidgetManager m = AppWidgetManager.getInstance(c);
            int[] ids = m.getAppWidgetIds(new ComponentName(c, RadioWidget.class));
            if (ids == null || ids.length == 0) return;
            m.updateAppWidget(ids, build(c, s));
        } catch (Throwable ignored) { }
    }

    /** The widget's views for the current state (also shown live in Device → Home widget). */
    public static RemoteViews build(Context c, RadioService s) {
        {
            RemoteViews v = new RemoteViews(c.getPackageName(), R.layout.widget_radio);
            ChannelStore.Channel ch = s == null ? null : s.current();
            v.setTextViewText(R.id.w_num, ch == null ? "--" : String.format(java.util.Locale.US, "%02d", ch.number));
            v.setTextViewText(R.id.w_name, ch == null ? "SignalDeck" : ch.name);
            String st = status(s);
            boolean tx = s != null && s.isTransmitting(), rx = s != null && s.hearing();
            v.setTextViewText(R.id.w_status, st);
            v.setTextColor(R.id.w_status, tx ? 0xFFFF5468 : rx ? 0xFF2BEA7A : 0xFF8DA2B8);
            v.setTextColor(R.id.w_num, tx ? 0xFFFF5468 : 0xFF2BEA7A);
            if (ch != null) {
                v.setImageViewBitmap(R.id.w_num_img, numberBitmap(c, String.format(java.util.Locale.US, "%02d", ch.number), tx ? 0xFFFF5468 : 0xFF2BEA7A));
                v.setViewVisibility(R.id.w_num_img, android.view.View.VISIBLE); v.setViewVisibility(R.id.w_num, android.view.View.GONE);
            } else { v.setViewVisibility(R.id.w_num_img, android.view.View.GONE); v.setViewVisibility(R.id.w_num, android.view.View.VISIBLE); }
            boolean scanning = s != null && s.isScanning();
            v.setImageViewResource(R.id.w_scan, scanning ? R.drawable.ic_w_stop : R.drawable.ic_w_scan);
            v.setInt(R.id.w_scan, "setBackgroundResource", scanning ? R.drawable.widget_btn_scan_on : R.drawable.widget_btn_scan);
            boolean held = s != null && s.pttHeld();
            v.setImageViewResource(R.id.w_talk, held ? R.drawable.ic_w_ptt_tx : R.drawable.ic_w_ptt);
            v.setInt(R.id.w_talk, "setBackgroundResource", held ? R.drawable.widget_btn_tx : R.drawable.widget_btn_talk);
            v.setContentDescription(R.id.w_talk, held ? "Stop talking" : "Talk");
            v.setOnClickPendingIntent(R.id.w_open, openApp(c));
            v.setOnClickPendingIntent(R.id.w_prev, command(c, CMD_PREV, 1));
            v.setOnClickPendingIntent(R.id.w_next, command(c, CMD_NEXT, 2));
            v.setOnClickPendingIntent(R.id.w_scan, command(c, CMD_SCAN, 3));
            v.setOnClickPendingIntent(R.id.w_talk, command(c, CMD_TALK, 4));
            return v;
        }
    }
}
