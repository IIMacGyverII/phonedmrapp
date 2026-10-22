/*
 * SignalDeck - Copyright (C) 2026 IIMacGyverII
 * SPDX-License-Identifier: GPL-3.0-or-later
 * Free software under the GNU General Public License v3 or later, with the additional terms in COPYRIGHT
 * (keep this notice and the author credit, mark modified versions, no rights to the SignalDeck name or icon).
 */
package com.macdmr.radio.ui;

import android.app.AlertDialog;
import android.content.Context;
import android.graphics.Canvas;
import android.graphics.Paint;
import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.hardware.SensorEventListener;
import android.hardware.SensorManager;
import android.location.Location;
import android.location.LocationListener;
import android.location.LocationManager;
import android.os.Handler;
import android.os.Looper;
import android.view.Gravity;
import android.view.View;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.widget.Toast;

import com.macdmr.radio.ChannelStore;
import com.macdmr.radio.RadioService;
import com.macdmr.radio.ham.FoxHunt;

import java.util.List;
import java.util.Locale;

/**
 * Fox hunt: live signal strength (big number, S-meter, peak hold, an optional rising beep), the compass bearing the
 * phone points at, Mark to save a reading, a plot of the marks with the estimated fox, the off-frequency trick for
 * when the signal is too strong, and Be the fox (a beacon every so often on this channel).
 */
public final class FoxHuntDialog {
    private FoxHuntDialog() { }

    public static void show(Context c, RadioService svc) {
        if (svc == null) return;
        float d = Theme.dp(c);
        LinearLayout body = Neo.sheetBody(c, "Fox hunt");
        ChannelStore.Channel ch = svc.current();
        body.addView(Neo.sheetHint(c, "Listening on " + (ch == null ? "no channel" : ch.name + " (" + String.format(Locale.US, "%.4f", ch.rxFreq / 1e6) + " MHz)") + ". Walk or drive, point the phone where the signal is strongest and tap Mark; where the bearings cross is where the fox is."));

        final TextView big = Neo.text(c, "--", Neo.CYAN, 56, Neo.display(c)); big.setGravity(Gravity.CENTER);
        body.addView(big);
        final TextView sub = Neo.text(c, "", Neo.MUTED, 14, Neo.uiMedium(c)); sub.setGravity(Gravity.CENTER); body.addView(sub);
        final SMeterView meter = new SMeterView(c); body.addView(meter);
        final TextView info = Neo.label(c, "", 0xFFBFC8D0, 13, false); info.setPadding(0, (int) (6 * d), 0, (int) (4 * d)); body.addView(info);

        final PlotView plot = new PlotView(c, svc.fox());
        body.addView(plot, new LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, (int) (240 * d)));

        LinearLayout r1 = new LinearLayout(c); r1.setBaselineAligned(false);
        TextView mark = Neo.button(c, "Mark", "locate", Neo.GREEN), beep = Neo.button(c, "Beeper off", "volume", Neo.CYAN), off = Neo.button(c, "Off-frequency", "vfo", Neo.AMBER);
        for (TextView b : new TextView[] { mark, beep, off }) { b.setTextSize(14); Neo.fit(b); LinearLayout.LayoutParams lp = new LinearLayout.LayoutParams(0, LinearLayout.LayoutParams.MATCH_PARENT, 1f); lp.setMargins((int) (3 * d), (int) (8 * d), (int) (3 * d), 0); r1.addView(b, lp); }
        body.addView(r1);
        LinearLayout r2 = new LinearLayout(c); r2.setBaselineAligned(false);
        TextView map = Neo.button(c, "Open in maps", "map", Neo.CYAN), clear = Neo.button(c, "Clear marks", "close", Neo.RED);
        for (TextView b : new TextView[] { map, clear }) { b.setTextSize(14); LinearLayout.LayoutParams lp = new LinearLayout.LayoutParams(0, LinearLayout.LayoutParams.MATCH_PARENT, 1f); lp.setMargins((int) (3 * d), (int) (6 * d), (int) (3 * d), 0); r2.addView(b, lp); }
        body.addView(r2);

        body.addView(Neo.sheetSection(c, "Be the fox"));
        final TextView foxBtn = Neo.button(c, svc.foxTxOn() ? "Stop the fox beacon" : "Start the fox beacon", "bolt", Neo.VIOLET);
        body.addView(foxBtn, new LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, LinearLayout.LayoutParams.WRAP_CONTENT));
        body.addView(Neo.sheetHint(c, "Sends 5 seconds of beeps on this channel every minute (your callsign follows in Morse on amateur channels) until stopped or the channel changes, so others can hunt you. Hide the phone with a full battery."));

        // ---- live state ----
        final int[] peak = { -999 }; final boolean[] beeping = { false }; final int[] offset = { 0 };
        final double[] heading = { Double.NaN }; final Location[] here = { svc.lastKnownLocation() };
        final Handler h = new Handler(Looper.getMainLooper());
        final android.media.ToneGenerator[] tg = { null };
        final long[] nextBeep = { 0 };
        SensorManager sm = (SensorManager) c.getSystemService(Context.SENSOR_SERVICE);
        Sensor rot = sm == null ? null : sm.getDefaultSensor(Sensor.TYPE_ROTATION_VECTOR);
        final SensorEventListener sl = new SensorEventListener() {
            final float[] rm = new float[9], or = new float[3];
            @Override public void onSensorChanged(SensorEvent e) {
                SensorManager.getRotationMatrixFromVector(rm, e.values); SensorManager.getOrientation(rm, or);
                double az = Math.toDegrees(or[0]);
                Location l = here[0];
                if (l != null) az += new android.hardware.GeomagneticField((float) l.getLatitude(), (float) l.getLongitude(), (float) l.getAltitude(), System.currentTimeMillis()).getDeclination();   // magnetic to true north
                heading[0] = (az % 360 + 360) % 360;
            }
            @Override public void onAccuracyChanged(Sensor s, int a) { }
        };
        if (rot != null) sm.registerListener(sl, rot, SensorManager.SENSOR_DELAY_UI);
        LocationManager lm = (LocationManager) c.getSystemService(Context.LOCATION_SERVICE);
        final LocationListener ll = l -> here[0] = l;
        try { lm.requestLocationUpdates(LocationManager.GPS_PROVIDER, 1000, 0, ll, Looper.getMainLooper()); } catch (Throwable ignored) { }

        final Runnable tick = new Runnable() {
            @Override public void run() {
                svc.pollRssi();
                int dbm = svc.lastRssi();
                if (dbm != -999 && dbm > peak[0]) peak[0] = dbm;
                big.setText(dbm == -999 ? "--" : String.valueOf(dbm));
                big.setTextColor(dbm >= -70 ? Neo.RED : dbm >= -93 ? Neo.AMBER : Neo.CYAN);
                sub.setText((dbm == -999 ? "no reading" : "dBm  ·  " + SMeterView.sUnits(dbm)) + (peak[0] != -999 ? "  ·  peak " + peak[0] : "") + (offset[0] != 0 ? "  ·  tuned " + (offset[0] / 1000) + " kHz off" : ""));
                meter.setDbm(dbm);
                StringBuilder sb = new StringBuilder();
                sb.append(Double.isNaN(heading[0]) ? "No compass" : String.format(Locale.US, "Pointing %03.0f° %s", heading[0], compass(heading[0])));
                FoxHunt.Estimate est = svc.fox().estimate(); Location me = here[0];
                if (est != null && me != null) {
                    float[] res = new float[2]; Location.distanceBetween(me.getLatitude(), me.getLongitude(), est.lat, est.lon, res);
                    sb.append(String.format(Locale.US, "\n%s: %.2f mi %s (%03.0f°)", est.fromBearings ? "Fox estimate from " + est.used + " bearings" : "Strongest mark", res[0] / 1609.344, compass(res[1]), (res[1] + 360) % 360));
                } else if (svc.fox().marks().isEmpty()) sb.append("\nNo marks yet");
                info.setText(sb.toString());
                plot.update(me, heading[0]);
                if (beeping[0] && dbm != -999 && System.currentTimeMillis() >= nextBeep[0]) {      // faster and higher as the signal rises
                    double s = Math.max(0, Math.min(1, (dbm + 125) / 70.0));
                    try { if (tg[0] == null) tg[0] = new android.media.ToneGenerator(android.media.AudioManager.STREAM_MUSIC, 60); tg[0].startTone(s > 0.66 ? android.media.ToneGenerator.TONE_DTMF_D : s > 0.33 ? android.media.ToneGenerator.TONE_DTMF_9 : android.media.ToneGenerator.TONE_DTMF_1, 40); } catch (Throwable ignored) { }
                    nextBeep[0] = System.currentTimeMillis() + (long) (900 - 800 * s);
                }
                h.postDelayed(this, 250);
            }
        };
        h.post(tick);

        mark.setOnClickListener(v -> {
            Location me = here[0]; int dbm = svc.lastRssi();
            if (me == null) { Toast.makeText(c, "No position yet: turn on location", Toast.LENGTH_LONG).show(); return; }
            if (dbm == -999) { Toast.makeText(c, "No signal reading yet", Toast.LENGTH_SHORT).show(); return; }
            svc.fox().add(new FoxHunt.Mark(me.getLatitude(), me.getLongitude(), dbm, heading[0], System.currentTimeMillis()));
            Toast.makeText(c, String.format(Locale.US, "Marked %d dBm%s", dbm, Double.isNaN(heading[0]) ? "" : String.format(Locale.US, " toward %03.0f°", heading[0])), Toast.LENGTH_SHORT).show();
        });
        beep.setOnClickListener(v -> { beeping[0] = !beeping[0]; beep.setText(beeping[0] ? "Beeper on" : "Beeper off"); });
        off.setOnClickListener(v -> {
            ChannelStore.Channel cur = svc.current(); if (cur == null) return;
            int[] steps = { 0, 10_000, 20_000, 30_000 };
            int k = 0; for (int i = 0; i < steps.length; i++) if (steps[i] == offset[0]) k = i;
            int next = steps[(k + 1) % steps.length];
            String e = svc.foxOffset(next);
            if (e != null) { Toast.makeText(c, e, Toast.LENGTH_LONG).show(); return; }
            offset[0] = next; peak[0] = -999;
            off.setText(next == 0 ? "Off-frequency" : "+" + (next / 1000) + " kHz");
        });
        map.setOnClickListener(v -> {
            FoxHunt.Estimate est = svc.fox().estimate();
            if (est == null) { Toast.makeText(c, "Mark a reading first", Toast.LENGTH_SHORT).show(); return; }
            try { c.startActivity(new android.content.Intent(android.content.Intent.ACTION_VIEW, android.net.Uri.parse(String.format(Locale.US, "geo:%f,%f?q=%f,%f(Fox)", est.lat, est.lon, est.lat, est.lon)))); } catch (Throwable t) { Toast.makeText(c, "No map app", Toast.LENGTH_SHORT).show(); }
        });
        clear.setOnClickListener(v -> { svc.fox().clear(); peak[0] = -999; });
        foxBtn.setOnClickListener(v -> { String r = svc.setFoxTx(!svc.foxTxOn()); Toast.makeText(c, r, Toast.LENGTH_LONG).show(); foxBtn.setText(svc.foxTxOn() ? "Stop the fox beacon" : "Start the fox beacon"); });

        AlertDialog a = Neo.showSheet(c, body);
        a.setOnDismissListener(x -> {
            h.removeCallbacks(tick);
            if (sm != null) sm.unregisterListener(sl);
            try { lm.removeUpdates(ll); } catch (Throwable ignored) { }
            if (tg[0] != null) tg[0].release();
            if (offset[0] != 0) svc.foxOffset(0);       // back on the channel
        });
    }

    static String compass(double deg) { String[] n = { "N", "NE", "E", "SE", "S", "SW", "W", "NW" }; return n[(int) Math.round(((deg % 360) + 360) % 360 / 45.0) % 8]; }

    /** The marks around you: dots coloured by strength with their bearing, you in the middle, the estimate as a ring. */
    static final class PlotView extends View {
        private final FoxHunt fox; private Location me; private double heading = Double.NaN;
        private final Paint p = new Paint(Paint.ANTI_ALIAS_FLAG);
        PlotView(Context c, FoxHunt f) { super(c); fox = f; }
        void update(Location l, double hd) { me = l; heading = hd; invalidate(); }

        @Override protected void onDraw(Canvas cv) {
            float d = Theme.dp(getContext()), w = getWidth(), hgt = getHeight(), cx = w / 2, cy = hgt / 2;
            p.setStyle(Paint.Style.FILL); p.setColor(0xFF0A1622); cv.drawRoundRect(0, 0, w, hgt, 14 * d, 14 * d, p);
            p.setStyle(Paint.Style.STROKE); p.setStrokeWidth(d); p.setColor(0xFF1A2C3E);
            for (int i = 1; i <= 3; i++) cv.drawCircle(cx, cy, Math.min(cx, cy) * i / 3.2f, p);
            List<FoxHunt.Mark> ms = fox.marks(); FoxHunt.Estimate est = fox.estimate();
            if (me == null && ms.isEmpty()) { p.setStyle(Paint.Style.FILL); p.setColor(Neo.DIM); p.setTextSize(13 * d); p.setTextAlign(Paint.Align.CENTER); cv.drawText("Marks appear here", cx, cy, p); return; }
            double lat0 = me != null ? me.getLatitude() : ms.get(0).lat, lon0 = me != null ? me.getLongitude() : ms.get(0).lon, cos = Math.cos(Math.toRadians(lat0));
            double maxM = 50;
            for (FoxHunt.Mark m : ms) maxM = Math.max(maxM, dist(m.lat, m.lon, lat0, lon0, cos));
            if (est != null) maxM = Math.max(maxM, dist(est.lat, est.lon, lat0, lon0, cos));
            float scale = (float) (Math.min(cx, cy) * 0.9 / maxM);
            int max = -999; for (FoxHunt.Mark m : ms) max = Math.max(max, m.dbm);
            for (FoxHunt.Mark m : ms) {
                float x = cx + (float) (Math.toRadians(m.lon - lon0) * 6371000 * cos) * scale, y = cy - (float) (Math.toRadians(m.lat - lat0) * 6371000) * scale;
                int col = m.dbm >= -70 ? Neo.RED : m.dbm >= -93 ? Neo.AMBER : Neo.CYAN;
                if (m.hasBearing()) {
                    float len = Math.min(cx, cy) * 0.8f; double th = Math.toRadians(m.bearing);
                    p.setStyle(Paint.Style.STROKE); p.setStrokeWidth(1.5f * d); p.setColor(Neo.alpha(col, m.dbm == max ? 0xCC : 0x66));
                    cv.drawLine(x, y, x + (float) Math.sin(th) * len, y - (float) Math.cos(th) * len, p);
                }
                p.setStyle(Paint.Style.FILL); p.setColor(col); cv.drawCircle(x, y, (m.dbm == max ? 6 : 4) * d, p);
            }
            if (est != null) {
                float x = cx + (float) (Math.toRadians(est.lon - lon0) * 6371000 * cos) * scale, y = cy - (float) (Math.toRadians(est.lat - lat0) * 6371000) * scale;
                p.setStyle(Paint.Style.STROKE); p.setStrokeWidth(2.5f * d); p.setColor(Neo.GREEN); cv.drawCircle(x, y, 11 * d, p); cv.drawCircle(x, y, 3 * d, p);
            }
            if (me != null) {                                   // you: a white arrow along the compass heading
                p.setStyle(Paint.Style.FILL); p.setColor(0xFFFFFFFF);
                double th = Double.isNaN(heading) ? 0 : Math.toRadians(heading);
                android.graphics.Path ar = new android.graphics.Path();
                ar.moveTo(cx + (float) Math.sin(th) * 12 * d, cy - (float) Math.cos(th) * 12 * d);
                ar.lineTo(cx + (float) Math.sin(th + 2.5) * 8 * d, cy - (float) Math.cos(th + 2.5) * 8 * d);
                ar.lineTo(cx + (float) Math.sin(th - 2.5) * 8 * d, cy - (float) Math.cos(th - 2.5) * 8 * d);
                ar.close(); cv.drawPath(ar, p);
            }
            p.setStyle(Paint.Style.FILL); p.setColor(Neo.DIM); p.setTextSize(11 * d); p.setTextAlign(Paint.Align.LEFT);
            double ring = maxM / (0.9 * 3.2);                 // metres between rings
            cv.drawText(ring >= 1609 ? String.format(Locale.US, "rings %.1f mi apart", ring / 1609.344) : String.format(Locale.US, "rings %.0f m apart", ring), 10 * d, hgt - 10 * d, p);
            cv.drawText("N ↑", w - 34 * d, 18 * d, p);
        }
        private static double dist(double la, double lo, double la0, double lo0, double cos) { double x = Math.toRadians(lo - lo0) * 6371000 * cos, y = Math.toRadians(la - la0) * 6371000; return Math.sqrt(x * x + y * y); }
    }
}
