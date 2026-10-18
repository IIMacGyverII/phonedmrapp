package com.macdmr.radio;

import android.content.ContentValues;
import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;

/**
 * The worldwide DMR ID register (radioid.net user.csv, ~300k rows): callers show as callsign and name instead
 * of a bare number. Downloaded on demand from the Device tab, kept in its own SQLite file.
 */
public final class RadioIdStore extends SQLiteOpenHelper {
    public static final String URL = "https://www.radioid.net/static/user.csv";
    public interface Progress { void update(String text); }

    public static final class Record {
        public int id; public String callsign = "", first = "", last = "", city = "", state = "", country = "";
        /** "W1AW Hiram" (callsign + first name); falls back to what exists. */
        public String display() { String n = first.trim(); return (callsign + (n.isEmpty() ? "" : " " + n)).trim(); }
        public String where() { List<String> p = new ArrayList<>(); for (String s : new String[] { city, state, country }) if (!s.trim().isEmpty()) p.add(s.trim()); return String.join(", ", p); }
    }

    private final Context ctx;
    private final HashMap<Integer, Record> cache = new HashMap<>();

    public RadioIdStore(Context c) { super(c.getApplicationContext(), "radioid.db", null, 1); ctx = c.getApplicationContext(); }

    @Override public void onCreate(SQLiteDatabase db) { db.execSQL("CREATE TABLE users (id INTEGER PRIMARY KEY, callsign TEXT, first TEXT, last TEXT, city TEXT, state TEXT, country TEXT)"); }
    @Override public void onUpgrade(SQLiteDatabase db, int o, int n) { }

    public synchronized Record lookup(int id) {
        if (id <= 0) return null;
        if (cache.containsKey(id)) return cache.get(id);
        Record r = null;
        try (Cursor c = getReadableDatabase().rawQuery("SELECT callsign,first,last,city,state,country FROM users WHERE id=?", new String[] { String.valueOf(id) })) {
            if (c.moveToFirst()) { r = new Record(); r.id = id; r.callsign = c.getString(0); r.first = c.getString(1); r.last = c.getString(2); r.city = c.getString(3); r.state = c.getString(4); r.country = c.getString(5); }
        } catch (Throwable ignored) { }
        if (cache.size() > 2000) cache.clear();
        cache.put(id, r);
        return r;
    }

    public int count() { try (Cursor c = getReadableDatabase().rawQuery("SELECT COUNT(*) FROM users", null)) { return c.moveToFirst() ? c.getInt(0) : 0; } catch (Throwable t) { return 0; } }
    public long lastSync() { return ctx.getSharedPreferences("radioid", Context.MODE_PRIVATE).getLong("lastSync", 0); }
    public String status() {
        int n = count();
        if (n == 0) return "not downloaded";
        return String.format(Locale.US, "%,d IDs, updated %s", n, new java.text.SimpleDateFormat("yyyy-MM-dd", Locale.US).format(new java.util.Date(lastSync())));
    }

    /** Download user.csv and replace the table. Blocking; call from a thread. Returns the number of rows imported. */
    public int downloadAndImport(Progress p) throws Exception {
        File f = new File(ctx.getCacheDir(), "radioid_user.csv");
        HttpURLConnection c = (HttpURLConnection) new URL(URL).openConnection();
        c.setConnectTimeout(30000); c.setReadTimeout(120000); c.setRequestProperty("User-Agent", "DMR Radio (Android)");
        if (c.getResponseCode() != 200) throw new Exception("HTTP " + c.getResponseCode());
        long total = c.getContentLengthLong(), got = 0; int lastPct = -1;
        try (InputStream in = c.getInputStream(); OutputStream out = new FileOutputStream(f)) {
            byte[] b = new byte[65536]; int n;
            while ((n = in.read(b)) > 0) {
                out.write(b, 0, n); got += n;
                int pct = total > 0 ? (int) (got * 100 / total) : -1;
                if (pct != lastPct && p != null) { lastPct = pct; p.update(pct >= 0 ? "Downloading… " + pct + "%" : String.format(Locale.US, "Downloading… %.1f MB", got / 1e6)); }
            }
        } finally { c.disconnect(); }
        int rows = importCsv(f, p);
        f.delete();
        return rows;
    }

    public int importCsv(File f, Progress p) throws Exception {
        try (BufferedReader r = new BufferedReader(new InputStreamReader(new java.io.FileInputStream(f), StandardCharsets.UTF_8), 1 << 16)) {
            String header = r.readLine();
            if (header == null) throw new Exception("empty file");
            if (header.startsWith("﻿")) header = header.substring(1);
            List<String> h = split(header); int iId = -1, iCall = -1, iFirst = -1, iLast = -1, iCity = -1, iState = -1, iCountry = -1;
            for (int i = 0; i < h.size(); i++) {
                String k = h.get(i).trim().toUpperCase(Locale.US);
                if (k.equals("RADIO_ID") || k.equals("ID")) iId = i; else if (k.equals("CALLSIGN")) iCall = i; else if (k.equals("FIRST_NAME") || k.equals("NAME")) iFirst = i;
                else if (k.equals("LAST_NAME") || k.equals("SURNAME")) iLast = i; else if (k.equals("CITY")) iCity = i; else if (k.equals("STATE")) iState = i; else if (k.equals("COUNTRY")) iCountry = i;
            }
            if (iId < 0 || iCall < 0) throw new Exception("not a RadioID user.csv (no RADIO_ID/CALLSIGN columns)");
            SQLiteDatabase db = getWritableDatabase();
            db.beginTransaction();
            int n = 0;
            try {
                db.delete("users", null, null);
                android.database.sqlite.SQLiteStatement st = db.compileStatement("INSERT OR REPLACE INTO users (id,callsign,first,last,city,state,country) VALUES (?,?,?,?,?,?,?)");
                String line;
                while ((line = r.readLine()) != null) {
                    if (line.isEmpty()) continue;
                    List<String> v = split(line);
                    if (v.size() <= Math.max(iId, iCall)) continue;
                    int id; try { id = Integer.parseInt(v.get(iId).trim()); } catch (NumberFormatException e) { continue; }
                    st.clearBindings(); st.bindLong(1, id); st.bindString(2, v.get(iCall).trim());
                    st.bindString(3, col(v, iFirst)); st.bindString(4, col(v, iLast)); st.bindString(5, col(v, iCity)); st.bindString(6, col(v, iState)); st.bindString(7, col(v, iCountry));
                    st.executeInsert();
                    if (++n % 20000 == 0 && p != null) p.update(String.format(Locale.US, "Importing… %,d", n));
                }
                db.setTransactionSuccessful();
            } finally { db.endTransaction(); }
            synchronized (this) { cache.clear(); }
            ctx.getSharedPreferences("radioid", Context.MODE_PRIVATE).edit().putLong("lastSync", System.currentTimeMillis()).apply();
            return n;
        }
    }

    private static String col(List<String> v, int i) { return i >= 0 && i < v.size() ? v.get(i).trim() : ""; }

    /** Minimal RFC-4180 split: quoted fields may contain commas and doubled quotes. */
    static List<String> split(String line) {
        List<String> out = new ArrayList<>(); StringBuilder sb = new StringBuilder(); boolean q = false;
        for (int i = 0; i < line.length(); i++) {
            char ch = line.charAt(i);
            if (q) { if (ch == '"') { if (i + 1 < line.length() && line.charAt(i + 1) == '"') { sb.append('"'); i++; } else q = false; } else sb.append(ch); }
            else if (ch == '"') q = true; else if (ch == ',') { out.add(sb.toString()); sb.setLength(0); } else sb.append(ch);
        }
        out.add(sb.toString());
        return out;
    }
}
