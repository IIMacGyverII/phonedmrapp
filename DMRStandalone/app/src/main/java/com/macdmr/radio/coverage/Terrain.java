package com.macdmr.radio.coverage;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;

import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.HashMap;
import java.util.Locale;
import java.util.Map;

/**
 * Ground height from the open Terrain Tiles (Mapzen "terrarium" encoding on AWS Open Data: height in metres =
 * R * 256 + G + B / 256 - 32768), at zoom 11: about 55 m between samples at 45 degrees latitude. Tiles are
 * kept in the app's files for good (terrain does not change), so a prediction works offline afterwards.
 */
public final class Terrain implements Predictor.Elevation {
    static final int Z = 11, N = 1 << Z;
    private static final String URL_FMT = "https://s3.amazonaws.com/elevation-tiles-prod/terrarium/%d/%d/%d.png";
    private final File dir;
    private final Map<Long, short[]> tiles = new HashMap<>();

    public Terrain(Context c) { dir = new File(c.getFilesDir(), "terrain/" + Z); }

    public interface Progress { void step(int done, int total); }

    /** Make sure every tile covering the box is loaded (downloaded once). Returns null, or what went wrong. */
    public String load(double s, double w, double n, double e, Progress pr) {
        int x0 = tileX(w), x1 = tileX(e), y0 = tileY(n), y1 = tileY(s);
        int total = (x1 - x0 + 1) * (y1 - y0 + 1), done = 0, missing = 0;
        for (int y = y0; y <= y1; y++)
            for (int x = x0; x <= x1; x++) {
                if (pr != null) pr.step(done, total);
                if (!tiles.containsKey(key(x, y))) { short[] t = fetch(x, y); if (t != null) tiles.put(key(x, y), t); else missing++; }
                done++;
            }
        return missing == 0 ? null : missing + " of " + total + " terrain tiles could not be loaded (no connection?)";
    }

    private short[] fetch(int x, int y) {
        File f = new File(dir, x + "/" + y + ".png");
        try {
            if (!f.exists()) {
                HttpURLConnection c = (HttpURLConnection) new URL(String.format(Locale.US, URL_FMT, Z, x, y)).openConnection();
                c.setRequestProperty("User-Agent", "SignalDeck/1.0 (Android; com.macdmr.radio)"); c.setConnectTimeout(10000); c.setReadTimeout(15000);
                if (c.getResponseCode() != 200) { c.disconnect(); return null; }
                File tmp = new File(dir, x + "/" + y + ".part"); tmp.getParentFile().mkdirs();
                try (InputStream in = c.getInputStream(); OutputStream out = new FileOutputStream(tmp)) { byte[] b = new byte[16384]; int r; while ((r = in.read(b)) > 0) out.write(b, 0, r); }
                c.disconnect();
                if (!tmp.renameTo(f)) return null;
            }
            BitmapFactory.Options o = new BitmapFactory.Options(); o.inPreferredConfig = Bitmap.Config.ARGB_8888; o.inScaled = false; o.inPremultiplied = false;
            Bitmap b = BitmapFactory.decodeFile(f.getPath(), o);
            if (b == null || b.getWidth() != 256 || b.getHeight() != 256) { f.delete(); return null; }
            int[] px = new int[256 * 256]; b.getPixels(px, 0, 256, 0, 0, 256, 256); b.recycle();
            short[] h = new short[px.length];
            for (int i = 0; i < px.length; i++) {
                int p = px[i]; double m = ((p >> 16) & 0xFF) * 256 + ((p >> 8) & 0xFF) + (p & 0xFF) / 256.0 - 32768;
                h[i] = (short) Math.max(-500, Math.min(9000, Math.round(m)));
            }
            return h;
        } catch (Throwable t) { return null; }
    }

    /** Height in metres (bilinear between the four nearest samples; 0 where no tile is loaded). */
    @Override public double at(double lat, double lon) {
        double gx = (lon + 180) / 360 * N * 256 - 0.5;
        double r = Math.toRadians(Math.max(-85, Math.min(85, lat)));
        double gy = (1 - Math.log(Math.tan(r) + 1 / Math.cos(r)) / Math.PI) / 2 * N * 256 - 0.5;
        int x = (int) Math.floor(gx), y = (int) Math.floor(gy); double fx = gx - x, fy = gy - y;
        double a = sample(x, y), b = sample(x + 1, y), c = sample(x, y + 1), d = sample(x + 1, y + 1);
        return (a * (1 - fx) + b * fx) * (1 - fy) + (c * (1 - fx) + d * fx) * fy;
    }

    private double sample(int gx, int gy) {
        short[] t = tiles.get(key(gx >> 8, gy >> 8));
        return t == null ? 0 : t[(gy & 255) * 256 + (gx & 255)];
    }

    private static long key(int x, int y) { return ((long) x << 32) | (y & 0xFFFFFFFFL); }
    static int tileX(double lon) { return (int) Math.max(0, Math.min(N - 1, Math.floor((lon + 180) / 360 * N))); }
    static int tileY(double lat) { double r = Math.toRadians(Math.max(-85, Math.min(85, lat))); return (int) Math.max(0, Math.min(N - 1, Math.floor((1 - Math.log(Math.tan(r) + 1 / Math.cos(r)) / Math.PI) / 2 * N))); }
}
