/*
 * SignalDeck - Copyright (C) 2026 IIMacGyverII
 * SPDX-License-Identifier: GPL-3.0-or-later
 * Free software under the GNU General Public License v3 or later, with the additional terms in COPYRIGHT
 * (keep this notice and the author credit, mark modified versions, no rights to the SignalDeck name or icon).
 */
package com.macdmr.radio.ui;

import android.app.AlertDialog;
import android.content.Context;
import android.os.Handler;
import android.os.Looper;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.widget.Toast;

import com.macdmr.radio.RadioService;
import com.macdmr.radio.ham.Maidenhead;
import com.macdmr.radio.ham.SatTrack;
import com.macdmr.radio.ham.Satellites;
import com.macdmr.radio.ham.Sgp4;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Locale;
import java.util.Map;

/** Satellite passes for the next day and one-tap tracking with Doppler correction. */
public final class SatelliteDialog {
    private SatelliteDialog() { }

    public static void show(Context c, RadioService svc) {
        final Satellites sats = svc.satellites();
        if (sats.elementsAgeMs() > 2 * 86_400_000L) {
            Toast.makeText(c, "Downloading satellite orbits…", Toast.LENGTH_SHORT).show();
            new Thread(() -> { String e = sats.update(); new Handler(Looper.getMainLooper()).post(() -> { if (e != null && sats.elementsAgeMs() == Long.MAX_VALUE) Toast.makeText(c, e, Toast.LENGTH_LONG).show(); else open(c, svc); }); }, "tle").start();
            return;
        }
        open(c, svc);
    }

    /** The ISS frequencies (ARISS changes the station's modes often): edit, reset, or check the ARISS status page. */
    private static void issFrequencies(Context c, RadioService svc) {
        LinearLayout body = Neo.sheetBody(c, "ISS frequencies");
        body.addView(Neo.sheetHint(c, "ARISS changes what the space station's radios do: APRS moves between 145.825 and 437.825, the repeater comes and goes, SSTV runs only during announced events. Set what the ARISS status page says now. The defaults are the status of 7 October 2026."));
        final String[][] f = { { "issAprs", "APRS digipeater (MHz)" }, { "issSstv", "SSTV pictures (MHz)" }, { "issRptrDown", "Repeater: listen (MHz)" }, { "issRptrUp", "Repeater: talk (MHz)" }, { "issVoiceDown", "Crew voice: listen (MHz)" }, { "issVoiceUp", "Crew voice: talk (MHz)" } };
        final long[] def = { Satellites.ISS_APRS_HZ, Satellites.ISS_SSTV_HZ, Satellites.ISS_RPTR_DOWN_HZ, Satellites.ISS_RPTR_UP_HZ, Satellites.ISS_VOICE_DOWN_HZ, Satellites.ISS_VOICE_UP_HZ };
        final android.widget.EditText[] e = new android.widget.EditText[f.length];
        for (int i = 0; i < f.length; i++) e[i] = field(c, body, f[i][1], String.format(Locale.US, "%.3f", Satellites.issHz(c, f[i][0], def[i]) / 1e6));
        final android.widget.EditText tone = field(c, body, "Repeater tone (Hz)", String.format(Locale.US, "%.1f", Satellites.issRptrTone(c)));
        final AlertDialog[] self = new AlertDialog[1];
        LinearLayout row = new LinearLayout(c);
        TextView save = Neo.button(c, "Save", "check", Neo.GREEN), reset = Neo.button(c, "Defaults", "restore", Neo.AMBER), status = Neo.button(c, "ARISS status", "globe", Neo.CYAN);
        for (TextView b : new TextView[] { save, reset, status }) { b.setTextSize(14); Neo.fit(b); LinearLayout.LayoutParams lp = new LinearLayout.LayoutParams(0, (int) (48 * Theme.dp(c)), 1f); lp.setMargins(4, 8, 4, 0); row.addView(b, lp); }
        body.addView(row);
        save.setOnClickListener(v -> {
            try {
                long[] hz = new long[f.length];
                for (int i = 0; i < f.length; i++) {
                    double m = Double.parseDouble(e[i].getText().toString().trim().replace(',', '.'));
                    if (m < 136 || m > 480) throw new NumberFormatException(f[i][1]);
                    hz[i] = Math.round(m * 1000) * 1000L;
                }
                double t = Double.parseDouble(tone.getText().toString().trim().replace(',', '.'));
                for (int i = 0; i < f.length; i++) Satellites.setIssHz(c, f[i][0], hz[i]);
                Satellites.setIssRptrTone(c, t);
                Toast.makeText(c, "Saved: used from the next pass you track", Toast.LENGTH_LONG).show();
                if (self[0] != null) self[0].dismiss();
            } catch (Throwable x) { Toast.makeText(c, "Check the numbers (MHz between 136 and 480)", Toast.LENGTH_LONG).show(); }
        });
        reset.setOnClickListener(v -> { Satellites.resetIss(c); Toast.makeText(c, "ISS frequencies back to the defaults", Toast.LENGTH_LONG).show(); if (self[0] != null) self[0].dismiss(); });
        status.setOnClickListener(v -> { try { c.startActivity(new android.content.Intent(android.content.Intent.ACTION_VIEW, android.net.Uri.parse(Satellites.ARISS_STATUS_URL))); } catch (Throwable x) { Toast.makeText(c, "No browser", Toast.LENGTH_LONG).show(); } });
        self[0] = Neo.showSheet(c, body);
    }
    private static android.widget.EditText field(Context c, LinearLayout body, String label, String value) {
        float d = Theme.dp(c);
        LinearLayout r = new LinearLayout(c); r.setOrientation(LinearLayout.VERTICAL); r.setBackground(Neo.rowCard(c)); r.setPadding((int) (12 * d), (int) (6 * d), (int) (12 * d), (int) (6 * d));
        r.addView(Neo.label(c, label, Neo.MUTED, 12, false));
        android.widget.EditText e = new android.widget.EditText(c); e.setText(value); e.setInputType(android.text.InputType.TYPE_CLASS_NUMBER | android.text.InputType.TYPE_NUMBER_FLAG_DECIMAL);
        e.setTextSize(17); e.setTextColor(Neo.TEXT); e.setSingleLine(true); e.setBackground(null); e.setPadding(0, (int) (2 * d), 0, (int) (2 * d));
        r.addView(e);
        LinearLayout.LayoutParams lp = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, LinearLayout.LayoutParams.WRAP_CONTENT); lp.bottomMargin = (int) (6 * d);
        body.addView(r, lp);
        return e;
    }

    private static void open(Context c, RadioService svc) {
        float d = Theme.dp(c);
        Satellites sats = svc.satellites();
        LinearLayout body = Neo.sheetBody(c, "Satellite passes");
        android.location.Location me = svc.lastKnownLocation();
        long age = sats.elementsAgeMs();
        body.addView(Neo.sheetHint(c, "Passes over you in the next 24 hours. Track a pass and the radio follows it: a minute before it rises the VFO takes the satellite's frequencies, corrected for Doppler every couple of seconds (never while you talk), and goes back to your channel after it sets. A vertical antenna hears the higher passes best. Orbits " + (age == Long.MAX_VALUE ? "not downloaded" : "from " + Math.max(0, age / 3_600_000L) + " h ago") + "."));
        final TextView live = Neo.label(c, "", Theme.CYAN, 14, true); body.addView(live);
        final TextView stop = Neo.button(c, "Stop tracking", "stop", Neo.RED); body.addView(stop);
        final AlertDialog[] self = new AlertDialog[1];
        stop.setOnClickListener(v -> { svc.endSatTracking(); Toast.makeText(c, "Tracking stopped", Toast.LENGTH_SHORT).show(); if (self[0] != null) self[0].dismiss(); });
        if (me == null) body.addView(Neo.sheetHint(c, "No position fix yet: turn on location, then open this again."));
        Map<Integer, Sgp4> el = sats.elements();
        SimpleDateFormat f = new SimpleDateFormat("EEE HH:mm", Locale.US);
        long now = System.currentTimeMillis();
        for (Satellites.Sat s : Satellites.all(c)) {
            body.addView(Neo.sheetSection(c, s.name));
            body.addView(Neo.sheetHint(c, s.listenOnly() ? String.format(Locale.US, "Listen %.3f MHz (receive only). %s", s.downHz / 1e6, s.about)
                    : String.format(Locale.US, "Listen %.3f, talk %.3f MHz%s. %s", s.downHz / 1e6, s.upHz / 1e6, s.toneHz > 0 ? String.format(Locale.US, " with %.1f Hz", s.toneHz) : "", s.about)));
            Sgp4 e = el.get(s.catalog);
            if (e == null || me == null) { body.addView(Neo.sheetHint(c, e == null ? "No orbit for it in the download." : "")); continue; }
            List<SatTrack.Pass> ps = SatTrack.passes(e, now - 15 * 60_000L, 24, me.getLatitude(), me.getLongitude(), me.hasAltitude() ? me.getAltitude() : 0, 10);
            int n = 0;
            for (SatTrack.Pass p : ps) {
                if (p.los < now) continue;
                if (++n > 4) break;
                boolean up = p.aos <= now;
                LinearLayout r = new LinearLayout(c); r.setOrientation(LinearLayout.VERTICAL); r.setBackground(up ? Neo.tint(c, Neo.GREEN, 12, 1) : Neo.rowCard(c)); r.setPadding((int) (12 * d), (int) (8 * d), (int) (12 * d), (int) (8 * d));
                r.addView(Neo.text(c, (up ? "Up now  ·  " : f.format(new Date(p.aos)) + "  ·  ") + String.format(Locale.US, "highest %.0f°  ·  %d min", p.maxEl, (p.durationS() + 30) / 60), up ? Neo.GREEN_LIGHT : Neo.TEXT, 15.5f, Neo.ui(c)));
                r.addView(Neo.text(c, "Rises " + Maidenhead.compass(p.aosAz) + ", sets " + Maidenhead.compass(p.losAz) + "  ·  tap to track", Neo.MUTED, 12.5f, Neo.uiMedium(c)));
                r.setClickable(true);
                r.setOnClickListener(v -> {
                    svc.setIssRepeat(-1);
                    String err = svc.trackSat(s, e, p);
                    Toast.makeText(c, err != null ? err : "Tracking " + s.name + (p.aos > System.currentTimeMillis() ? " from " + new SimpleDateFormat("HH:mm", Locale.US).format(new Date(p.aos - 60_000)) : " now"), Toast.LENGTH_LONG).show();
                    if (self[0] != null) self[0].dismiss();
                    if (err == null && s.mode != Satellites.VOICE && c instanceof com.macdmr.radio.MainActivity) ((com.macdmr.radio.MainActivity) c).openModeScreen();   // APRS / SSTV: their page
                });
                LinearLayout.LayoutParams lp = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, LinearLayout.LayoutParams.WRAP_CONTENT); lp.bottomMargin = (int) (6 * d);
                body.addView(r, lp);
            }
            if (n == 0) body.addView(Neo.sheetHint(c, "No pass above 10° in the next 24 hours."));
        }
        TextView freqs = Neo.button(c, "ISS frequencies", "radio", Neo.AMBER); body.addView(freqs);
        freqs.setOnClickListener(v -> { if (self[0] != null) self[0].dismiss(); issFrequencies(c, svc); });
        TextView upd = Neo.button(c, "Update orbits", "update", Neo.CYAN); body.addView(upd);
        upd.setOnClickListener(v -> new Thread(() -> { String e = sats.update(); new Handler(Looper.getMainLooper()).post(() -> { Toast.makeText(c, e == null ? "Orbits updated" : e, Toast.LENGTH_LONG).show(); if (e == null) { if (self[0] != null) self[0].dismiss(); open(c, svc); } }); }, "tle").start());
        final Handler h = new Handler(Looper.getMainLooper());
        final Runnable tick = new Runnable() { @Override public void run() {
            RadioService.SatState st = svc.satState();
            stop.setVisibility(st == null ? android.view.View.GONE : android.view.View.VISIBLE);
            if (st == null) live.setText("");
            else if (st.waiting || st.look == null) live.setText("Tracking " + st.name + ": waiting for the pass at " + new SimpleDateFormat("HH:mm", Locale.US).format(new Date(st.aos)));
            else live.setText(String.format(Locale.US, "%s  ·  azimuth %.0f° %s, elevation %.0f°\nlisten %.4f  ·  talk %.4f MHz  ·  %s", st.name, st.look.az, Maidenhead.compass(st.look.az), st.look.el, st.rxHz / 1e6, st.txHz / 1e6, st.look.rangeRateKmS < 0 ? "approaching" : "receding"));
            h.postDelayed(this, 1000);
        } };
        h.post(tick);
        self[0] = Neo.showSheet(c, body);
        self[0].setOnDismissListener(x -> h.removeCallbacks(tick));
    }
}
