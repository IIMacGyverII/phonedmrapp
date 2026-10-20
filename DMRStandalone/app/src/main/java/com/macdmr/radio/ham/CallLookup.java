package com.macdmr.radio.ham;

import android.content.ContentValues;
import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;
import android.util.Log;

import org.json.JSONObject;

import java.io.InputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.util.Locale;

/**
 * Callsign lookup in the free HamDB directory (api.hamdb.org: US licences, Canada and others), cached for 30 days
 * (a call not found, for 7). Gives the name, place, grid square and position. Only callsigns are sent.
 */
public final class CallLookup extends SQLiteOpenHelper {
    public static final class Info {
        public String call = "", name = "", city = "", state = "", country = "", grid = "", licClass = "";
        public double lat, lon; public boolean found;
        public String place() { StringBuilder sb = new StringBuilder(city); if (!state.isEmpty()) sb.append(sb.length() > 0 ? ", " : "").append(state); if (sb.length() == 0) sb.append(country); return sb.toString(); }
    }
    private static final long DAY = 86_400_000L;
    private long lastRequest;

    public CallLookup(Context c) { super(c, "calls.db", null, 1); }
    @Override public void onCreate(SQLiteDatabase db) { db.execSQL("CREATE TABLE calls (call TEXT PRIMARY KEY, ts INTEGER, found INTEGER, json TEXT)"); }
    @Override public void onUpgrade(SQLiteDatabase db, int o, int n) { }

    /** Cached result (possibly stale), or null when never looked up. Fast: safe on the main thread. */
    public synchronized Info cached(String call) {
        String c = Logbook.baseCall(call); if (c == null) return null;
        try (Cursor k = getReadableDatabase().rawQuery("SELECT json, found FROM calls WHERE call=?", new String[] { c })) {
            if (!k.moveToFirst()) return null;
            Info i = k.getInt(1) == 1 ? parse(new JSONObject(k.getString(0))) : new Info();
            i.call = c; i.found = k.getInt(1) == 1; return i;
        } catch (Throwable t) { return null; }
    }

    /** Look up (network when the cache is old or empty). Call off the main thread. */
    public Info lookup(String call) {
        String c = Logbook.baseCall(call); if (c == null) return null;
        synchronized (this) {
            try (Cursor k = getReadableDatabase().rawQuery("SELECT ts, found FROM calls WHERE call=?", new String[] { c })) {
                if (k.moveToFirst() && System.currentTimeMillis() - k.getLong(0) < (k.getInt(1) == 1 ? 30 : 7) * DAY) return cached(c);
            }
        }
        try {
            synchronized (this) { long wait = 1100 - (System.currentTimeMillis() - lastRequest); if (wait > 0) Thread.sleep(wait); lastRequest = System.currentTimeMillis(); }   // at most one request a second
            HttpURLConnection h = (HttpURLConnection) new URL("https://api.hamdb.org/v1/" + c + "/json/DMRRadio").openConnection();
            h.setConnectTimeout(8000); h.setReadTimeout(8000);
            if (h.getResponseCode() != 200) return cached(c);
            String body; try (InputStream in = h.getInputStream()) { body = new String(readAll(in), StandardCharsets.UTF_8); }
            JSONObject root = new JSONObject(body).getJSONObject("hamdb");
            boolean found = "OK".equalsIgnoreCase(root.optJSONObject("messages") != null ? root.getJSONObject("messages").optString("status") : "");
            JSONObject cs = root.optJSONObject("callsign");
            ContentValues v = new ContentValues(); v.put("call", c); v.put("ts", System.currentTimeMillis()); v.put("found", found ? 1 : 0); v.put("json", cs == null ? "{}" : cs.toString());
            synchronized (this) { getWritableDatabase().insertWithOnConflict("calls", null, v, SQLiteDatabase.CONFLICT_REPLACE); }
            return cached(c);
        } catch (Throwable t) { Log.w("CallLookup", c + ": " + t); return cached(c); }
    }

    static Info parse(JSONObject cs) {
        Info i = new Info();
        String first = cs.optString("fname").trim(), last = cs.optString("name").trim();
        i.name = (first.isEmpty() ? last : first + " " + last).trim();
        i.name = titleCase(i.name);
        i.city = titleCase(cs.optString("addr2").trim()); i.state = cs.optString("state").trim(); i.country = cs.optString("country").trim();
        i.grid = cs.optString("grid").trim(); i.licClass = cs.optString("class").trim();
        try { i.lat = Double.parseDouble(cs.optString("lat")); i.lon = Double.parseDouble(cs.optString("lon")); } catch (Throwable ignored) { }
        if (i.grid.isEmpty() && (i.lat != 0 || i.lon != 0)) i.grid = Maidenhead.grid(i.lat, i.lon, 6);
        return i;
    }
    static String titleCase(String s) {
        StringBuilder sb = new StringBuilder(); boolean up = true;
        for (char ch : s.toLowerCase(Locale.US).toCharArray()) { sb.append(up ? Character.toUpperCase(ch) : ch); up = ch == ' ' || ch == '-' || ch == '\''; }
        return sb.toString();
    }
    private static byte[] readAll(InputStream in) throws java.io.IOException {
        java.io.ByteArrayOutputStream o = new java.io.ByteArrayOutputStream(); byte[] b = new byte[4096]; int n;
        while ((n = in.read(b)) > 0) o.write(b, 0, n); return o.toByteArray();
    }
}
