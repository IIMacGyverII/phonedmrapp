package com.macdmr.radio.coverage;

import android.content.ContentValues;
import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Coverage measurements ({@code coverage.db}): what you heard from each repeater where ({@code rx}), and every
 * transmission into a repeater with whether it answered ({@code tx}). A repeater is identified by
 * {@link CoverageMath#repeaterKey}; its name and position are kept in {@code repeaters}.
 */
public final class CoverageStore extends SQLiteOpenHelper {
    public static final class Repeater { public String key, name; public int rxHz, txHz; public double lat, lon; public int rxCount, txCount, keyed; }
    public static final class Rx { public long ts; public String key; public double lat, lon; public float acc; public int dbm; }
    public static final class Tx { public long ts; public String key; public double lat, lon; public float acc; public int power, result, replyDbm, floorDbm; public long txMs; }
    /** One map square: its bounds, the value it is drawn with (median dBm, or a key-up result) and how many readings made it. */
    public static final class Cell { public double s, w, n, e; public int value, count; public int keyed, failed; public boolean predicted; }

    public CoverageStore(Context c) { super(c, "coverage.db", null, 1); }

    @Override public void onCreate(SQLiteDatabase db) {
        db.execSQL("CREATE TABLE repeaters (rkey TEXT PRIMARY KEY, name TEXT, rxHz INTEGER, txHz INTEGER, lat REAL, lon REAL)");
        db.execSQL("CREATE TABLE rx (_id INTEGER PRIMARY KEY AUTOINCREMENT, ts INTEGER, rkey TEXT, lat REAL, lon REAL, acc REAL, dbm INTEGER)");
        db.execSQL("CREATE TABLE tx (_id INTEGER PRIMARY KEY AUTOINCREMENT, ts INTEGER, rkey TEXT, lat REAL, lon REAL, acc REAL, power INTEGER, txMs INTEGER, result INTEGER, replyDbm INTEGER, floorDbm INTEGER)");
        db.execSQL("CREATE INDEX rx_key ON rx (rkey)");
        db.execSQL("CREATE INDEX tx_key ON tx (rkey)");
    }
    @Override public void onUpgrade(SQLiteDatabase db, int o, int n) { }

    public synchronized void noteRepeater(String key, String name, int rxHz, int txHz, double lat, double lon) {
        ContentValues v = new ContentValues();
        v.put("rkey", key); v.put("name", name); v.put("rxHz", rxHz); v.put("txHz", txHz); v.put("lat", lat); v.put("lon", lon);
        getWritableDatabase().insertWithOnConflict("repeaters", null, v, SQLiteDatabase.CONFLICT_REPLACE);
    }

    public synchronized void addRx(String key, double lat, double lon, float acc, int dbm, long ts) {
        ContentValues v = new ContentValues();
        v.put("ts", ts); v.put("rkey", key); v.put("lat", lat); v.put("lon", lon); v.put("acc", acc); v.put("dbm", dbm);
        getWritableDatabase().insert("rx", null, v);
    }

    public synchronized void addTx(String key, double lat, double lon, float acc, int power, long txMs, int result, int replyDbm, int floorDbm, long ts) {
        ContentValues v = new ContentValues();
        v.put("ts", ts); v.put("rkey", key); v.put("lat", lat); v.put("lon", lon); v.put("acc", acc); v.put("power", power);
        v.put("txMs", txMs); v.put("result", result); v.put("replyDbm", replyDbm); v.put("floorDbm", floorDbm);
        getWritableDatabase().insert("tx", null, v);
    }

    /** Repeaters with any measurement, most measured first. */
    public synchronized List<Repeater> repeaters() {
        List<Repeater> out = new ArrayList<>();
        try (Cursor c = getReadableDatabase().rawQuery("SELECT r.rkey, r.name, r.rxHz, r.txHz, r.lat, r.lon,"
                + " (SELECT COUNT(*) FROM rx WHERE rx.rkey = r.rkey), (SELECT COUNT(*) FROM tx WHERE tx.rkey = r.rkey),"
                + " (SELECT COUNT(*) FROM tx WHERE tx.rkey = r.rkey AND tx.result = 1) FROM repeaters r", null)) {
            while (c.moveToNext()) {
                Repeater r = new Repeater(); r.key = c.getString(0); r.name = c.getString(1); r.rxHz = c.getInt(2); r.txHz = c.getInt(3);
                r.lat = c.getDouble(4); r.lon = c.getDouble(5); r.rxCount = c.getInt(6); r.txCount = c.getInt(7); r.keyed = c.getInt(8);
                if (r.rxCount + r.txCount > 0) out.add(r);
            }
        }
        out.sort((a, b) -> Integer.compare(b.rxCount + b.txCount, a.rxCount + a.txCount));
        return out;
    }

    public synchronized int rxCount() { try (Cursor c = getReadableDatabase().rawQuery("SELECT COUNT(*) FROM rx", null)) { return c.moveToFirst() ? c.getInt(0) : 0; } }
    public synchronized int txCount() { try (Cursor c = getReadableDatabase().rawQuery("SELECT COUNT(*) FROM tx", null)) { return c.moveToFirst() ? c.getInt(0) : 0; } }

    public synchronized List<Rx> rx(String key) {
        List<Rx> out = new ArrayList<>();
        try (Cursor c = key == null ? getReadableDatabase().rawQuery("SELECT ts, rkey, lat, lon, acc, dbm FROM rx ORDER BY ts", null)
                : getReadableDatabase().rawQuery("SELECT ts, rkey, lat, lon, acc, dbm FROM rx WHERE rkey = ? ORDER BY ts", new String[] { key })) {
            while (c.moveToNext()) { Rx r = new Rx(); r.ts = c.getLong(0); r.key = c.getString(1); r.lat = c.getDouble(2); r.lon = c.getDouble(3); r.acc = c.getFloat(4); r.dbm = c.getInt(5); out.add(r); }
        }
        return out;
    }

    public synchronized List<Tx> tx(String key) {
        List<Tx> out = new ArrayList<>();
        try (Cursor c = key == null ? getReadableDatabase().rawQuery("SELECT ts, rkey, lat, lon, acc, power, txMs, result, replyDbm, floorDbm FROM tx ORDER BY ts", null)
                : getReadableDatabase().rawQuery("SELECT ts, rkey, lat, lon, acc, power, txMs, result, replyDbm, floorDbm FROM tx WHERE rkey = ? ORDER BY ts", new String[] { key })) {
            while (c.moveToNext()) {
                Tx t = new Tx(); t.ts = c.getLong(0); t.key = c.getString(1); t.lat = c.getDouble(2); t.lon = c.getDouble(3); t.acc = c.getFloat(4);
                t.power = c.getInt(5); t.txMs = c.getLong(6); t.result = c.getInt(7); t.replyDbm = c.getInt(8); t.floorDbm = c.getInt(9); out.add(t);
            }
        }
        return out;
    }

    /**
     * Receive map: one cell per grid square, valued by the median reading. With {@code key == null} (all
     * repeaters) a square shows the best repeater there: the highest of each repeater's median.
     */
    public List<Cell> rxCells(String key) {
        Map<String, Map<Long, List<Integer>>> by = new HashMap<>();
        for (Rx r : rx(key)) {
            Map<Long, List<Integer>> m = by.get(r.key); if (m == null) { m = new HashMap<>(); by.put(r.key, m); }
            long cell = CoverageMath.cell(r.lat, r.lon);
            List<Integer> l = m.get(cell); if (l == null) { l = new ArrayList<>(); m.put(cell, l); }
            l.add(r.dbm);
        }
        Map<Long, Cell> best = new HashMap<>();
        for (Map<Long, List<Integer>> m : by.values())
            for (Map.Entry<Long, List<Integer>> e : m.entrySet()) {
                int[] a = new int[e.getValue().size()]; for (int i = 0; i < a.length; i++) a[i] = e.getValue().get(i);
                int med = CoverageMath.median(a);
                Cell c = best.get(e.getKey());
                if (c == null) { c = cell(e.getKey()); c.value = med; c.count = a.length; best.put(e.getKey(), c); }
                else if (med > c.value) { c.value = med; c.count = a.length; }
            }
        return new ArrayList<>(best.values());
    }

    /**
     * Transmit map: one cell per square with how many transmissions keyed the repeater and how many got no
     * reply. No-reply attempts on a repeater that has never been seen to answer are left out: it may simply
     * have no tail.
     */
    public List<Cell> txCells(String key) {
        Map<String, Boolean> answers = new HashMap<>();
        List<Tx> all = tx(key);
        for (Tx t : all) if (t.result == CoverageMath.KEYED) answers.put(t.key, true);
        Map<Long, Cell> cells = new HashMap<>();
        for (Tx t : all) {
            if (t.result == CoverageMath.UNKNOWN) continue;
            if (t.result == CoverageMath.NO_REPLY && !answers.containsKey(t.key)) continue;
            long id = CoverageMath.cell(t.lat, t.lon);
            Cell c = cells.get(id); if (c == null) { c = cell(id); cells.put(id, c); }
            if (t.result == CoverageMath.KEYED) c.keyed++; else c.failed++;
            c.count++;
        }
        return new ArrayList<>(cells.values());
    }

    private static Cell cell(long id) { double[] b = CoverageMath.cellBounds(id); Cell c = new Cell(); c.s = b[0]; c.w = b[1]; c.n = b[2]; c.e = b[3]; return c; }

    public synchronized void clear(String key) {
        SQLiteDatabase db = getWritableDatabase();
        if (key == null) { db.delete("rx", null, null); db.delete("tx", null, null); db.delete("repeaters", null, null); }
        else { String[] a = { key }; db.delete("rx", "rkey=?", a); db.delete("tx", "rkey=?", a); db.delete("repeaters", "rkey=?", a); }
    }
}
