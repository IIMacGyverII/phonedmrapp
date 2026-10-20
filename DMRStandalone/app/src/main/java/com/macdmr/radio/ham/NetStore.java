package com.macdmr.radio.ham;

import android.content.ContentValues;
import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Locale;

/** Nets you run as net control: each net and its check-ins (with traffic / late / out flags), kept for reports. */
public final class NetStore extends SQLiteOpenHelper {
    public static final class Net { public long id, start, end; public String name = "", channel = ""; public long freqHz; public boolean running() { return end == 0; } }
    public static final class CheckIn { public long id, netId, ts; public String call = "", name = "", notes = ""; public boolean traffic, late, out; }

    public NetStore(Context c) { super(c, "nets.db", null, 1); }

    @Override public void onCreate(SQLiteDatabase db) {
        db.execSQL("CREATE TABLE nets (_id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, start INTEGER, endTs INTEGER, channel TEXT, freq INTEGER)");
        db.execSQL("CREATE TABLE checkins (_id INTEGER PRIMARY KEY AUTOINCREMENT, net INTEGER, ts INTEGER, call TEXT, name TEXT, notes TEXT, traffic INTEGER, late INTEGER, outFlag INTEGER)");
    }
    @Override public void onUpgrade(SQLiteDatabase db, int o, int n) { }

    public synchronized Net start(String name, String channel, long freqHz) {
        Net n = new Net(); n.name = name; n.start = System.currentTimeMillis(); n.channel = channel; n.freqHz = freqHz;
        ContentValues v = new ContentValues(); v.put("name", name); v.put("start", n.start); v.put("endTs", 0); v.put("channel", channel); v.put("freq", freqHz);
        n.id = getWritableDatabase().insert("nets", null, v);
        return n;
    }
    public synchronized void end(Net n) { n.end = System.currentTimeMillis(); ContentValues v = new ContentValues(); v.put("endTs", n.end); getWritableDatabase().update("nets", v, "_id=?", new String[] { String.valueOf(n.id) }); }
    public synchronized void deleteNet(long id) { getWritableDatabase().delete("checkins", "net=?", new String[] { String.valueOf(id) }); getWritableDatabase().delete("nets", "_id=?", new String[] { String.valueOf(id) }); }

    public synchronized Net running() { List<Net> l = nets("endTs=0", 1); return l.isEmpty() ? null : l.get(0); }
    public synchronized List<Net> past(int limit) { return nets("endTs>0", limit); }
    private List<Net> nets(String where, int limit) {
        List<Net> out = new ArrayList<>();
        try (Cursor c = getReadableDatabase().rawQuery("SELECT _id, name, start, endTs, channel, freq FROM nets WHERE " + where + " ORDER BY start DESC LIMIT " + limit, null)) {
            while (c.moveToNext()) { Net n = new Net(); n.id = c.getLong(0); n.name = c.getString(1); n.start = c.getLong(2); n.end = c.getLong(3); n.channel = c.getString(4); n.freqHz = c.getLong(5); out.add(n); }
        }
        return out;
    }

    /** Check a station in (a second check-in of the same call returns the existing one). */
    public synchronized CheckIn checkIn(Net n, String call, String name) {
        String c = call.trim().toUpperCase(Locale.US);
        for (CheckIn x : checkIns(n.id)) if (x.call.equals(c)) return x;
        CheckIn k = new CheckIn(); k.netId = n.id; k.ts = System.currentTimeMillis(); k.call = c; k.name = name == null ? "" : name;
        k.late = n.end == 0 && k.ts - n.start > 15 * 60_000L;           // checking in a quarter of an hour after the start counts as late
        save(k); return k;
    }
    public synchronized void save(CheckIn k) {
        ContentValues v = new ContentValues(); v.put("net", k.netId); v.put("ts", k.ts); v.put("call", k.call); v.put("name", k.name); v.put("notes", k.notes);
        v.put("traffic", k.traffic ? 1 : 0); v.put("late", k.late ? 1 : 0); v.put("outFlag", k.out ? 1 : 0);
        if (k.id > 0) getWritableDatabase().update("checkins", v, "_id=?", new String[] { String.valueOf(k.id) }); else k.id = getWritableDatabase().insert("checkins", null, v);
    }
    public synchronized void remove(CheckIn k) { getWritableDatabase().delete("checkins", "_id=?", new String[] { String.valueOf(k.id) }); }
    public synchronized List<CheckIn> checkIns(long netId) {
        List<CheckIn> out = new ArrayList<>();
        try (Cursor c = getReadableDatabase().rawQuery("SELECT _id, net, ts, call, name, notes, traffic, late, outFlag FROM checkins WHERE net=? ORDER BY ts", new String[] { String.valueOf(netId) })) {
            while (c.moveToNext()) { CheckIn k = new CheckIn(); k.id = c.getLong(0); k.netId = c.getLong(1); k.ts = c.getLong(2); k.call = c.getString(3); k.name = c.getString(4); k.notes = c.getString(5); k.traffic = c.getInt(6) == 1; k.late = c.getInt(7) == 1; k.out = c.getInt(8) == 1; out.add(k); }
        }
        return out;
    }

    /** A plain-text net report for e-mail or a club log. */
    public static String report(Net n, List<CheckIn> ins, String netControl) {
        SimpleDateFormat d = new SimpleDateFormat("EEE MMM d yyyy", Locale.US), t = new SimpleDateFormat("HH:mm", Locale.US);
        long end = n.end == 0 ? System.currentTimeMillis() : n.end;
        StringBuilder sb = new StringBuilder();
        sb.append(n.name).append(" — ").append(d.format(new Date(n.start))).append('\n');
        sb.append(n.channel).append(n.freqHz > 0 ? String.format(Locale.US, " (%.4f MHz)", n.freqHz / 1e6) : "").append('\n');
        sb.append("Opened ").append(t.format(new Date(n.start))).append(", closed ").append(n.end == 0 ? "(running)" : t.format(new Date(end))).append(", ").append((end - n.start) / 60000).append(" min\n");
        if (netControl != null && !netControl.isEmpty()) sb.append("Net control: ").append(netControl).append('\n');
        int traffic = 0; for (CheckIn k : ins) if (k.traffic) traffic++;
        sb.append("Check-ins: ").append(ins.size()).append(traffic > 0 ? ", " + traffic + " with traffic" : "").append("\n\n");
        int i = 1;
        for (CheckIn k : ins) {
            String line = String.format(Locale.US, "%2d. %-8s %s  %s", i++, k.call, t.format(new Date(k.ts)), k.name == null ? "" : k.name);
            while (line.endsWith(" ")) line = line.substring(0, line.length() - 1);   // keep the numbers aligned, drop only trailing space
            sb.append(line);
            List<String> f = new ArrayList<>(); if (k.traffic) f.add("traffic"); if (k.late) f.add("late"); if (k.out) f.add("checked out");
            if (!f.isEmpty()) sb.append("  [").append(String.join(", ", f)).append(']');
            if (k.notes != null && !k.notes.isEmpty()) sb.append("  ").append(k.notes);
            sb.append('\n');
        }
        return sb.toString();
    }
}
