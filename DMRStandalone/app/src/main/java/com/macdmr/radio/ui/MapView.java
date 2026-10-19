package com.macdmr.radio.ui;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Canvas;
import android.graphics.ColorMatrix;
import android.graphics.ColorMatrixColorFilter;
import android.graphics.Paint;
import android.graphics.Path;
import android.graphics.Rect;
import android.graphics.RectF;
import android.os.Handler;
import android.os.Looper;
import android.util.LruCache;
import android.view.GestureDetector;
import android.view.MotionEvent;
import android.view.ScaleGestureDetector;
import android.view.View;

import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

/**
 * A small slippy map: OpenStreetMap tiles (cached on disk for 30 days, darkened to the app's palette) with neon
 * markers. Pinch or double-tap to zoom, drag to pan, tap a marker to select it. Shows the OSM attribution the tile
 * licence requires.
 */
public class MapView extends View {
    public static final int STATION = 0, REPEATER_FM = 1, REPEATER_DMR = 2, CHANNEL = 3, ME = 4;

    public static final class Marker {
        public final double lat, lon; public final int kind; public final String label; public final Object data;
        public Marker(double lat, double lon, int kind, String label, Object data) { this.lat = lat; this.lon = lon; this.kind = kind; this.label = label; this.data = data; }
    }
    public interface OnSelect { void onSelect(Marker m); }

    private static final String TILE_URL = "https://tile.openstreetmap.org/%d/%d/%d.png";
    private static final String UA = "DMRRadio/1.0 (Android; com.macdmr.radio)";
    private static final long TILE_MAX_AGE = 30L * 24 * 3600 * 1000;

    private double cx = lonToX(-98.35), cy = latToY(39.5), zoom = 4;      // centre in normalised Web Mercator (0..1)
    private final float d, k;                                             // density; tile magnification so map text is readable
    private final List<Marker> markers = new ArrayList<>();
    private final boolean[] visible = { true, true, true, true, true };
    private Marker selected; private OnSelect onSelect;

    private final LruCache<String, Bitmap> mem = new LruCache<>(90);
    private final Set<String> loading = new HashSet<>();
    private final Map<String, Long> failed = new HashMap<>();
    private final ExecutorService pool = Executors.newFixedThreadPool(3);
    private final Handler ui = new Handler(Looper.getMainLooper());
    private final File dir;

    private final Paint tilePaint = new Paint(Paint.FILTER_BITMAP_FLAG), bg = new Paint(), dot = new Paint(Paint.ANTI_ALIAS_FLAG),
            halo = new Paint(Paint.ANTI_ALIAS_FLAG), ring = new Paint(Paint.ANTI_ALIAS_FLAG), text = new Paint(Paint.ANTI_ALIAS_FLAG),
            textBg = new Paint(Paint.ANTI_ALIAS_FLAG), attr = new Paint(Paint.ANTI_ALIAS_FLAG), grid = new Paint();
    private final Rect src = new Rect(); private final RectF dst = new RectF(); private final Path diamond = new Path();
    private final ScaleGestureDetector scale; private final GestureDetector gestures;

    public MapView(Context c) {
        super(c);
        d = c.getResources().getDisplayMetrics().density; k = Math.max(1f, d / 2f);
        dir = new File(c.getCacheDir(), "tiles");
        tilePaint.setColorFilter(new ColorMatrixColorFilter(darkMatrix()));
        bg.setColor(0xFF07101A);
        grid.setColor(0xFF0E1C2A); grid.setStrokeWidth(d);
        halo.setStyle(Paint.Style.FILL);
        ring.setStyle(Paint.Style.STROKE); ring.setStrokeWidth(2 * d);
        text.setTextSize(12 * d); text.setTypeface(Neo.uiSemi(c)); text.setColor(Neo.TEXT);
        textBg.setColor(0xCC07101A);
        attr.setTextSize(10 * d); attr.setColor(0xFF8DA2B8);
        scale = new ScaleGestureDetector(c, new ScaleGestureDetector.SimpleOnScaleGestureListener() {
            @Override public boolean onScale(ScaleGestureDetector g) { zoomAt(g.getFocusX(), g.getFocusY(), Math.log(g.getScaleFactor()) / Math.log(2)); return true; }
        });
        gestures = new GestureDetector(c, new GestureDetector.SimpleOnGestureListener() {
            @Override public boolean onDown(MotionEvent e) { return true; }
            @Override public boolean onScroll(MotionEvent a, MotionEvent b, float dx, float dy) {
                double w = world(); cx += dx / w; cy = clampY(cy + dy / w); cx = wrapX(cx); invalidate(); return true;
            }
            @Override public boolean onDoubleTap(MotionEvent e) { zoomAt(e.getX(), e.getY(), 1); return true; }
            @Override public boolean onSingleTapConfirmed(MotionEvent e) { select(hit(e.getX(), e.getY())); return true; }
        });
        setContentDescription("Map");
    }

    // ---- public API -------------------------------------------------------------------------------------
    public void setOnSelect(OnSelect s) { onSelect = s; }
    public void setMarkers(List<Marker> m) { markers.clear(); markers.addAll(m); if (selected != null && !markers.contains(selected)) selected = null; invalidate(); }
    public void setVisible(int kind, boolean on) { visible[kind] = on; if (!on && selected != null && selected.kind == kind) select(null); invalidate(); }
    public boolean isVisible(int kind) { return visible[kind]; }
    public void center(double lat, double lon, double z) { cx = lonToX(lon); cy = clampY(latToY(lat)); zoom = clampZoom(z); invalidate(); }
    public double zoom() { return zoom; }
    public void zoomBy(double dz) { zoomAt(getWidth() / 2f, getHeight() / 2f, dz); }
    public void select(Marker m) { selected = m; invalidate(); if (onSelect != null) onSelect.onSelect(m); }
    /** Fit these markers on screen (keeps a margin), at most zoom 14. */
    public void fit(List<Marker> m) {
        if (m.isEmpty() || getWidth() == 0) return;
        double minX = 1, maxX = 0, minY = 1, maxY = 0;
        for (Marker x : m) { double X = lonToX(x.lon), Y = latToY(x.lat); minX = Math.min(minX, X); maxX = Math.max(maxX, X); minY = Math.min(minY, Y); maxY = Math.max(maxY, Y); }
        cx = (minX + maxX) / 2; cy = clampY((minY + maxY) / 2);
        double spanX = Math.max(maxX - minX, 1e-6), spanY = Math.max(maxY - minY, 1e-6);
        double z = Math.min(Math.log(getWidth() * 0.8 / (256 * k * spanX)), Math.log(getHeight() * 0.75 / (256 * k * spanY))) / Math.log(2);
        zoom = clampZoom(Math.min(z, 14)); invalidate();
    }
    public void shutdown() { pool.shutdownNow(); }

    @Override public boolean onTouchEvent(MotionEvent e) {
        getParent().requestDisallowInterceptTouchEvent(true);
        scale.onTouchEvent(e); if (!scale.isInProgress()) gestures.onTouchEvent(e);
        return true;
    }

    // ---- drawing ----------------------------------------------------------------------------------------
    @Override protected void onDraw(Canvas cv) {
        int w = getWidth(), h = getHeight();
        cv.drawRect(0, 0, w, h, bg);
        int z = (int) Math.max(2, Math.min(18, Math.round(zoom)));
        int n = 1 << z;
        double ts = 256 * k * Math.pow(2, zoom - z);                 // tile edge on screen
        double tx = cx * n, ty = cy * n;
        int i0 = (int) Math.floor(tx - w / 2.0 / ts), i1 = (int) Math.floor(tx + w / 2.0 / ts);
        int j0 = (int) Math.max(0, Math.floor(ty - h / 2.0 / ts)), j1 = (int) Math.min(n - 1, Math.floor(ty + h / 2.0 / ts));
        for (int j = j0; j <= j1; j++) {
            for (int i = i0; i <= i1; i++) {
                float left = (float) (w / 2.0 + (i - tx) * ts), top = (float) (h / 2.0 + (j - ty) * ts);
                dst.set(left, top, (float) (left + ts) + 0.5f, (float) (top + ts) + 0.5f);
                int ii = ((i % n) + n) % n;
                Bitmap b = tile(z, ii, j, true);
                if (b != null) { cv.drawBitmap(b, null, dst, tilePaint); continue; }
                Bitmap p = tile(z - 1, ii / 2, j / 2, false);         // the parent, magnified, until this one arrives
                if (p != null) { int q = p.getWidth() / 2; src.set((ii % 2) * q, (j % 2) * q, (ii % 2) * q + q, (j % 2) * q + q); cv.drawBitmap(p, src, dst, tilePaint); }
                else { cv.drawRect(dst, bg); cv.drawLine(dst.left, dst.top, dst.right, dst.top, grid); cv.drawLine(dst.left, dst.top, dst.left, dst.bottom, grid); }
            }
        }
        for (Marker m : markers) {
            if (!visible[m.kind]) continue;
            float sx = sx(m.lon), sy = sy(m.lat);
            if (sx < -60 * d || sx > w + 60 * d || sy < -30 * d || sy > h + 30 * d) continue;
            drawMarker(cv, m, sx, sy);
        }
        placed.clear();                                              // labels above all the dots; one never covers another
        if (selected != null && visible[selected.kind]) label(cv, selected, w, h);
        for (Marker m : markers) if (m != selected && visible[m.kind]) label(cv, m, w, h);
        String a = "© OpenStreetMap contributors";
        float aw = attr.measureText(a);
        cv.drawRoundRect(w - aw - 14 * d, h - 20 * d, w - 4 * d, h - 4 * d, 4 * d, 4 * d, textBg);
        cv.drawText(a, w - aw - 9 * d, h - 8.5f * d, attr);
    }

    private int color(int kind) {
        switch (kind) { case STATION: return Neo.GREEN; case REPEATER_FM: return Neo.CYAN; case REPEATER_DMR: return Neo.VIOLET; case CHANNEL: return Neo.AMBER; default: return 0xFF4DA3FF; }
    }

    private void drawMarker(Canvas cv, Marker m, float x, float y) {
        int col = color(m.kind);
        halo.setColor((col & 0x00FFFFFF) | 0x40000000);
        dot.setColor(col);
        if (m.kind == ME) {
            halo.setColor(0x334DA3FF); cv.drawCircle(x, y, 16 * d, halo);
            ring.setColor(0xFFFFFFFF); dot.setColor(0xFF4DA3FF);
            cv.drawCircle(x, y, 7 * d, dot); cv.drawCircle(x, y, 7 * d, ring);
            return;
        }
        cv.drawCircle(x, y, 11 * d, halo);
        if (m.kind == REPEATER_FM || m.kind == REPEATER_DMR) {
            float r = 6.5f * d; diamond.reset(); diamond.moveTo(x, y - r); diamond.lineTo(x + r, y); diamond.lineTo(x, y + r); diamond.lineTo(x - r, y); diamond.close();
            cv.drawPath(diamond, dot);
        } else if (m.kind == CHANNEL) {
            cv.drawCircle(x, y, 6 * d, dot); dot.setColor(0xFF07101A); cv.drawCircle(x, y, 2.4f * d, dot);
        } else cv.drawCircle(x, y, 5.5f * d, dot);
        if (m == selected) { ring.setColor(col); cv.drawCircle(x, y, 13 * d, ring); }
    }

    private final List<RectF> placed = new ArrayList<>();
    private void label(Canvas cv, Marker m, int w, int h) {
        if (m.label == null || m.kind == ME) return;
        float x = sx(m.lon), y = sy(m.lat) + 9 * d;
        if (x < -60 * d || x > w + 60 * d || y < -30 * d || y > h + 30 * d) return;
        String s = m.label; if (s.length() > 22) s = s.substring(0, 21) + "…";
        float tw = text.measureText(s), pad = 4 * d;
        RectF r = new RectF(x - tw / 2 - pad, y, x + tw / 2 + pad, y + 17 * d);
        for (RectF o : placed) if (RectF.intersects(o, r)) return;
        placed.add(r);
        text.setColor(m == selected ? Neo.TEXT : Neo.TEXT_SOFT);
        cv.drawRoundRect(r, 5 * d, 5 * d, textBg);
        cv.drawText(s, x - tw / 2, y + 12.5f * d, text);
    }

    private Marker hit(float x, float y) {
        Marker best = null; double bd = (26 * d) * (26 * d);
        for (Marker m : markers) {
            if (!visible[m.kind] || m.kind == ME) continue;
            double dx = sx(m.lon) - x, dy = sy(m.lat) - y, dd = dx * dx + dy * dy;
            if (dd < bd) { bd = dd; best = m; }
        }
        return best;
    }

    // ---- projection -------------------------------------------------------------------------------------
    private double world() { return 256 * k * Math.pow(2, zoom); }
    private float sx(double lon) { double dx = lonToX(lon) - cx; if (dx > 0.5) dx -= 1; else if (dx < -0.5) dx += 1; return (float) (getWidth() / 2.0 + dx * world()); }
    private float sy(double lat) { return (float) (getHeight() / 2.0 + (latToY(lat) - cy) * world()); }
    static double lonToX(double lon) { return (lon + 180) / 360; }
    static double latToY(double lat) { double r = Math.toRadians(Math.max(-85, Math.min(85, lat))); return (1 - Math.log(Math.tan(r) + 1 / Math.cos(r)) / Math.PI) / 2; }
    public double centerLat() { return Math.toDegrees(Math.atan(Math.sinh(Math.PI * (1 - 2 * cy)))); }
    public double centerLon() { return cx * 360 - 180; }
    private static double clampY(double y) { return Math.max(0.02, Math.min(0.98, y)); }
    private static double wrapX(double x) { return x - Math.floor(x); }
    private static double clampZoom(double z) { return Math.max(2, Math.min(18, z)); }

    private void zoomAt(float fx, float fy, double dz) {
        double nz = clampZoom(zoom + dz); if (nz == zoom) return;
        double w0 = world(), wx = cx + (fx - getWidth() / 2.0) / w0, wy = cy + (fy - getHeight() / 2.0) / w0;
        zoom = nz; double w1 = world();
        cx = wrapX(wx - (fx - getWidth() / 2.0) / w1); cy = clampY(wy - (fy - getHeight() / 2.0) / w1);
        invalidate();
    }

    /** Dark tiles: invert, turn hues back (so water stays blue), then dim and cool slightly. */
    private static ColorMatrix darkMatrix() {
        ColorMatrix inv = new ColorMatrix(new float[] { -1, 0, 0, 0, 255, 0, -1, 0, 0, 255, 0, 0, -1, 0, 255, 0, 0, 0, 1, 0 });
        double a = Math.PI, cos = Math.cos(a), sin = Math.sin(a);
        ColorMatrix hue = new ColorMatrix(new float[] {
                (float) (0.213 + cos * 0.787 - sin * 0.213), (float) (0.715 - cos * 0.715 - sin * 0.715), (float) (0.072 - cos * 0.072 + sin * 0.928), 0, 0,
                (float) (0.213 - cos * 0.213 + sin * 0.143), (float) (0.715 + cos * 0.285 + sin * 0.140), (float) (0.072 - cos * 0.072 - sin * 0.283), 0, 0,
                (float) (0.213 - cos * 0.213 - sin * 0.787), (float) (0.715 - cos * 0.715 + sin * 0.715), (float) (0.072 + cos * 0.928 + sin * 0.072), 0, 0,
                0, 0, 0, 1, 0 });
        ColorMatrix dim = new ColorMatrix(new float[] { 0.78f, 0, 0, 0, 2, 0, 0.84f, 0, 0, 6, 0, 0, 0.95f, 0, 14, 0, 0, 0, 1, 0 });
        ColorMatrix m = new ColorMatrix(); m.postConcat(inv); m.postConcat(hue); m.postConcat(dim);
        return m;
    }

    // ---- tiles ------------------------------------------------------------------------------------------
    private Bitmap tile(final int z, final int x, final int y, boolean fetch) {
        if (z < 0) return null;
        final String key = z + "/" + x + "/" + y;
        Bitmap b = mem.get(key);
        if (b != null || !fetch) return b;
        if (loading.contains(key)) return null;
        Long f = failed.get(key); if (f != null && System.currentTimeMillis() - f < 30000) return null;
        loading.add(key);
        pool.execute(() -> {
            Bitmap got = null;
            try {
                File file = new File(dir, key + ".png");
                if (file.exists() && System.currentTimeMillis() - file.lastModified() < TILE_MAX_AGE) got = decode(file);
                if (got == null) {
                    HttpURLConnection c = (HttpURLConnection) new URL(String.format(java.util.Locale.US, TILE_URL, z, x, y)).openConnection();
                    c.setRequestProperty("User-Agent", UA); c.setConnectTimeout(8000); c.setReadTimeout(10000);
                    if (c.getResponseCode() == 200) {
                        File tmp = new File(dir, key + ".part"); tmp.getParentFile().mkdirs();
                        try (InputStream in = c.getInputStream(); OutputStream out = new FileOutputStream(tmp)) { byte[] buf = new byte[16384]; int r; while ((r = in.read(buf)) > 0) out.write(buf, 0, r); }
                        if (tmp.renameTo(file)) got = decode(file);
                    }
                    c.disconnect();
                    if (got == null && file.exists()) got = decode(file);       // offline: an old tile beats none
                }
            } catch (Throwable ignored) { }
            final Bitmap res = got;
            ui.post(() -> { loading.remove(key); if (res != null) { mem.put(key, res); invalidate(); } else failed.put(key, System.currentTimeMillis()); });
        });
        return null;
    }

    private static Bitmap decode(File f) { BitmapFactory.Options o = new BitmapFactory.Options(); o.inPreferredConfig = Bitmap.Config.RGB_565; return BitmapFactory.decodeFile(f.getPath(), o); }
}
