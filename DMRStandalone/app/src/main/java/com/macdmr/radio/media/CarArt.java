package com.macdmr.radio.media;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.LinearGradient;
import android.graphics.Paint;
import android.graphics.RadialGradient;
import android.graphics.RectF;
import android.graphics.Shader;
import android.graphics.Typeface;

import com.macdmr.radio.ChannelStore;
import com.macdmr.radio.coverage.CoverageMath;
import com.macdmr.radio.ui.Neo;

import java.util.HashMap;
import java.util.Locale;
import java.util.Map;

/**
 * The radio's look on the car screen. Android Auto draws media apps with its own templates, so the app's style goes
 * into the pictures it shows: the now-playing artwork is a small intercom panel (neon channel digits, frequency,
 * mode chips, state badge, signal meter), and every channel and zone in the list gets a neon tile.
 */
public final class CarArt {
    private CarArt() { }

    /** The live panel for the radio's current state (shared by the media screen and the control screen). */
    public static Bitmap panelFor(Context c, com.macdmr.radio.RadioService s) {
        State st = new State();
        st.ch = s.current(); st.zone = s.zoneLabelFor(s.current()); st.tx = s.isTransmitting(); st.rx = s.hearing(); st.scanning = s.isScanning();
        st.ready = s.isReady(); st.muted = s.isMuted(); st.dbm = s.lastRssi(); st.caller = s.currentCallsign(); st.target = s.currentTarget();
        return panel(c, st);
    }

    private static final int GROUND = 0xFF060B12, GROUND_TOP = 0xFF0D1B2B;
    private static final Map<String, Bitmap> tiles = new HashMap<>();

    /** What the panel shows. */
    static final class State {
        ChannelStore.Channel ch; String zone = ""; boolean tx, rx, scanning, ready, muted; int dbm = -999; String caller = "", target = "";
        String key() {
            int bucket = rx && dbm != -999 ? Math.max(0, Math.min(15, (dbm - CoverageMath.SCALE_LOW) / 4)) : -1;
            return (ch == null ? "-" : ch.number + "|" + ch.name + "|" + ch.rxFreq + "|" + ch.power) + "|" + zone + "|" + tx + rx + scanning + ready + muted + "|" + bucket + "|" + caller + "|" + target;
        }
    }

    // ---- now playing --------------------------------------------------------------------------------
    static Bitmap panel(Context c, State s) {
        int W = 512;
        Bitmap b = Bitmap.createBitmap(W, W, Bitmap.Config.ARGB_8888);
        Canvas cv = new Canvas(b);
        Paint bg = new Paint(); bg.setShader(new RadialGradient(W / 2f, W * 0.42f, W * 0.8f, GROUND_TOP, GROUND, Shader.TileMode.CLAMP));
        cv.drawRect(0, 0, W, W, bg);
        traces(cv, W);
        int accent = s.tx ? Neo.RED : s.ch != null && s.ch.isDigital() ? Neo.VIOLET : Neo.CYAN;
        Paint border = new Paint(Paint.ANTI_ALIAS_FLAG); border.setStyle(Paint.Style.STROKE); border.setStrokeWidth(5); border.setColor(Neo.alpha(accent, 0x88));
        cv.drawRoundRect(new RectF(10, 10, W - 10, W - 10), 46, 46, border);

        // top: zone and state badge
        Paint caps = text(c, Neo.ui(c), 26, Neo.MUTED); caps.setLetterSpacing(0.18f);
        if (s.zone != null && !s.zone.isEmpty()) cv.drawText(("ZONE · " + s.zone).toUpperCase(Locale.US), 40, 70, caps);   // only a zone the channel is in
        String badge; int bc;
        if (!s.ready) { badge = "RADIO OFF"; bc = Neo.AMBER; }
        else if (s.tx) { badge = "TRANSMITTING"; bc = Neo.RED; }
        else if (s.rx) { badge = "RECEIVING"; bc = Neo.GREEN; }
        else if (s.scanning) { badge = "SCANNING"; bc = Neo.VIOLET; }
        else if (s.muted) { badge = "PAUSED"; bc = Neo.MUTED; }
        else { badge = "READY"; bc = Neo.CYAN; }
        Paint bt = text(c, Neo.ui(c), 26, bc); bt.setLetterSpacing(0.12f);
        float bw = bt.measureText(badge) + 34;
        Paint bf = new Paint(Paint.ANTI_ALIAS_FLAG); bf.setColor(Neo.alpha(bc, 0x2A)); Paint bs = new Paint(Paint.ANTI_ALIAS_FLAG); bs.setStyle(Paint.Style.STROKE); bs.setStrokeWidth(3); bs.setColor(Neo.alpha(bc, 0xCC));
        RectF br = new RectF(W - 40 - bw, 38, W - 40, 84); cv.drawRoundRect(br, 23, 23, bf); cv.drawRoundRect(br, 23, 23, bs);
        cv.drawText(badge, br.left + 17, 71, bt);

        // the neon digits
        String num = s.ch == null ? "--" : String.format(Locale.US, "%02d", s.ch.number);
        int digit = s.tx ? Neo.RED : Neo.GREEN;
        Paint d = text(c, Neo.display(c), num.length() > 2 ? 150 : 196, digit); d.setTextAlign(Paint.Align.CENTER); d.setShadowLayer(34, 0, 0, Neo.alpha(digit, 0xB0));
        Paint.FontMetrics fm = d.getFontMetrics();
        cv.drawText(num, W / 2f, 250 - (fm.ascent + fm.descent) / 2, d);

        // frequency and chips
        if (s.ch != null) {
            Paint f = text(c, Neo.mono(c), 44, Neo.TEXT_SOFT); f.setTextAlign(Paint.Align.CENTER);
            cv.drawText(s.ch.freqText(s.ch.rxFreq) + " MHz", W / 2f, 372, f);
            String[] chips = { s.ch.isDigital() ? "DMR" : "FM", s.ch.rxFreq < 300_000_000 ? "VHF" : "UHF", s.ch.power == 1 ? "HIGH PWR" : "LOW PWR" };
            int[] cc = { s.ch.isDigital() ? Neo.VIOLET : Neo.CYAN, Neo.CYAN, s.ch.power == 1 ? Neo.RED : Neo.AMBER };
            if (s.caller != null && !s.caller.isEmpty()) {                       // during a DMR call: who (callsign) and to what
                String who = s.caller.length() > 14 ? s.caller.substring(0, 13) + "…" : s.caller;
                String to = s.target == null ? "" : s.target.length() > 14 ? s.target.substring(0, 13) + "…" : s.target;
                if (to.isEmpty()) { chips = new String[] { who }; cc = new int[] { Neo.AMBER }; }
                else { chips = new String[] { who, to }; cc = new int[] { Neo.AMBER, Neo.VIOLET }; }
            }
            Paint ct = text(c, Neo.ui(c), 24, 0); ct.setLetterSpacing(0.1f);
            float total = 0; float[] w = new float[chips.length];
            for (int i = 0; i < chips.length; i++) { w[i] = ct.measureText(chips[i]) + 30; total += w[i]; }
            total += (chips.length - 1) * 12;
            float x = (W - total) / 2;
            for (int i = 0; i < chips.length; i++) {
                RectF r = new RectF(x, 396, x + w[i], 436);
                Paint cs = new Paint(Paint.ANTI_ALIAS_FLAG); cs.setStyle(Paint.Style.STROKE); cs.setStrokeWidth(2.5f); cs.setColor(Neo.alpha(cc[i], 0xAA));
                cv.drawRoundRect(r, 11, 11, cs);
                ct.setColor(cc[i]); cv.drawText(chips[i], x + 15, 425, ct);
                x += w[i] + 12;
            }
        }

        // the signal meter
        int segs = 18; float mx = 44, mw = W - 88, gap = 5, sw = (mw - gap * (segs - 1)) / segs, top = 472, h = 20;
        int lit = s.rx && s.dbm != -999 ? Math.round(Math.max(0, Math.min(1, (s.dbm - CoverageMath.SCALE_LOW) / (float) (CoverageMath.SCALE_HIGH - CoverageMath.SCALE_LOW))) * segs) : 0;
        Paint seg = new Paint(Paint.ANTI_ALIAS_FLAG);
        for (int i = 0; i < segs; i++) {
            int col = i < segs * 0.55 ? Neo.GREEN : i < segs * 0.8 ? 0xFFFFD84D : Neo.RED;
            seg.setColor(i < lit ? col : Neo.alpha(col, 0x22));
            float x = mx + i * (sw + gap);
            cv.drawRoundRect(new RectF(x, top, x + sw, top + h), 4, 4, seg);
        }
        Paint ml = text(c, Neo.mono(c), 22, s.rx && s.dbm != -999 ? Neo.TEXT_SOFT : Neo.DIM);
        String meter = s.rx && s.dbm != -999 ? CoverageMath.sUnits(s.dbm) + "  " + s.dbm + " dBm" : "NO SIGNAL";
        ml.setTextAlign(Paint.Align.RIGHT); cv.drawText(meter, W - 44, top - 8, ml);
        return b;
    }

    /** A few faint circuit traces in the corners, as on the intercom panel. */
    private static void traces(Canvas cv, int W) {
        Paint p = new Paint(Paint.ANTI_ALIAS_FLAG); p.setStyle(Paint.Style.STROKE); p.setStrokeWidth(2); p.setColor(Neo.alpha(Neo.CYAN, 0x1E));
        Paint dot = new Paint(Paint.ANTI_ALIAS_FLAG); dot.setColor(Neo.alpha(Neo.CYAN, 0x40));
        float[][] lines = { { 30, 130, 90, 130, 120, 100 }, { 30, 160, 70, 160, 100, 190, 150, 190 }, { W - 30, 140, W - 100, 140, W - 130, 110 }, { W - 30, 170, W - 80, 170 },
                { 30, 330, 80, 330, 110, 360 }, { W - 30, 320, W - 90, 320, W - 120, 350, W - 170, 350 } };
        for (float[] l : lines) {
            android.graphics.Path path = new android.graphics.Path(); path.moveTo(l[0], l[1]);
            for (int i = 2; i + 1 < l.length; i += 2) path.lineTo(l[i], l[i + 1]);
            cv.drawPath(path, p); cv.drawCircle(l[l.length - 2], l[l.length - 1], 4, dot);
        }
    }

    // ---- list tiles ---------------------------------------------------------------------------------
    public static Bitmap channelTilePublic(Context c, ChannelStore.Channel ch) { return channelTile(c, ch); }
    public static Bitmap zoneTilePublic(Context c, String name) { return zoneTile(c, name); }
    static synchronized Bitmap channelTile(Context c, ChannelStore.Channel ch) {
        String key = "ch" + ch.number + "|" + ch.type;
        Bitmap b = tiles.get(key); if (b != null) return b;
        int accent = ch.isDigital() ? Neo.VIOLET : Neo.CYAN;
        b = tileBase(accent);
        Canvas cv = new Canvas(b);
        String num = String.format(Locale.US, "%02d", ch.number);
        Paint d = text(c, Neo.display(c), num.length() > 2 ? 44 : 58, accent == Neo.VIOLET ? Neo.VIOLET_LIGHT : Neo.CYAN_LIGHT);
        d.setTextAlign(Paint.Align.CENTER); d.setShadowLayer(10, 0, 0, Neo.alpha(accent, 0xAA));
        Paint.FontMetrics fm = d.getFontMetrics();
        cv.drawText(num, 64, 64 - (fm.ascent + fm.descent) / 2, d);
        tiles.put(key, b);
        return b;
    }

    static synchronized Bitmap zoneTile(Context c, String name) {
        String n = name == null ? "" : name.toLowerCase(Locale.US);
        String icon = n.contains("last heard") ? "intercom" : n.contains("fav") ? "star" : n.contains("weather") || n.contains("wx") ? "alert" : n.contains("dmr") ? "radio" : n.contains("nearby") ? "repeaters"
                : n.contains("gmrs") || n.contains("family") || n.contains("frs") ? "intercom" : n.contains("all") ? "channels" : "zone";
        // a bare glyph on transparent ground: Android Auto tints folder icons (the zone tabs) to one colour
        String key = "zone|" + icon;
        Bitmap b = tiles.get(key); if (b != null) return b;
        b = Bitmap.createBitmap(128, 128, Bitmap.Config.ARGB_8888);
        Canvas cv = new Canvas(b);
        Neo.IconDrawable dr = new Neo.IconDrawable(icon, 0xFFFFFFFF);
        dr.setBounds(16, 16, 112, 112); dr.draw(cv);
        tiles.put(key, b);
        return b;
    }

    private static Bitmap tileBase(int accent) {
        Bitmap b = Bitmap.createBitmap(128, 128, Bitmap.Config.ARGB_8888);
        Canvas cv = new Canvas(b);
        Paint bg = new Paint(Paint.ANTI_ALIAS_FLAG); bg.setShader(new LinearGradient(0, 0, 0, 128, GROUND_TOP, GROUND, Shader.TileMode.CLAMP));
        RectF r = new RectF(4, 4, 124, 124); cv.drawRoundRect(r, 26, 26, bg);
        Paint s = new Paint(Paint.ANTI_ALIAS_FLAG); s.setStyle(Paint.Style.STROKE); s.setStrokeWidth(3); s.setColor(Neo.alpha(accent, 0x99));
        cv.drawRoundRect(r, 26, 26, s);
        return b;
    }

    private static Paint text(Context c, Typeface tf, float size, int color) {
        Paint p = new Paint(Paint.ANTI_ALIAS_FLAG); p.setTypeface(tf); p.setTextSize(size); p.setColor(color); return p;
    }
}
