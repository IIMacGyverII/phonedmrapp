package com.macdmr.radio.pkt;

import android.content.ContentValues;
import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;

import java.util.ArrayList;
import java.util.List;

/** Everything the packet modes hear: APRS stations and message log, DTMF sequences, weather alerts. */
public final class PacketStore extends SQLiteOpenHelper {
    public static final class Station {
        public String call; public double lat, lon; public int alt; public char symTable, symCode; public String comment = "";
        public double speedKmh = -1; public int courseDeg = -1; public long lastTs; public int count; public String via = "";
    }
    public static final class LogEntry { public long ts; public String kind, from, to, text, id; public boolean mine; }
    public static final class Dtmf { public long ts; public String digits; public int channel; public String channelName; }
    public static final class Alert { public long ts; public String event, summary, raw; public boolean eom; }

    public PacketStore(Context c) { super(c, "packet.db", null, 1); }

    @Override public void onCreate(SQLiteDatabase db) {
        db.execSQL("CREATE TABLE stations (call TEXT PRIMARY KEY, lat REAL, lon REAL, alt INTEGER, symTable TEXT, symCode TEXT, comment TEXT, speed REAL, course INTEGER, lastTs INTEGER, count INTEGER, via TEXT)");
        db.execSQL("CREATE TABLE aprs_log (_id INTEGER PRIMARY KEY AUTOINCREMENT, ts INTEGER, kind TEXT, src TEXT, dst TEXT, text TEXT, msgId TEXT, mine INTEGER)");
        db.execSQL("CREATE TABLE dtmf_log (_id INTEGER PRIMARY KEY AUTOINCREMENT, ts INTEGER, digits TEXT, channel INTEGER, channelName TEXT)");
        db.execSQL("CREATE TABLE wx_alerts (_id INTEGER PRIMARY KEY AUTOINCREMENT, ts INTEGER, event TEXT, summary TEXT, raw TEXT, eom INTEGER)");
    }
    @Override public void onUpgrade(SQLiteDatabase db, int o, int n) { }

    public synchronized void storeStation(APRSPacketDecoder.APRSPacket p, long ts) {
        String call = p.sourceCallsign + (p.sourceSSID != 0 ? "-" + p.sourceSSID : "");
        SQLiteDatabase db = getWritableDatabase();
        int count = 0;
        try (Cursor c = db.rawQuery("SELECT count FROM stations WHERE call=?", new String[] { call })) { if (c.moveToFirst()) count = c.getInt(0); }
        ContentValues v = new ContentValues();
        v.put("call", call); v.put("lat", p.latitude); v.put("lon", p.longitude); v.put("alt", p.altitude);
        v.put("symTable", String.valueOf(p.symbolTable)); v.put("symCode", String.valueOf(p.symbolCode)); v.put("comment", p.comment == null ? "" : p.comment);
        v.put("speed", p.speedKmh); v.put("course", p.courseDeg); v.put("lastTs", ts); v.put("count", count + 1);
        v.put("via", p.thirdPartyVia != null ? p.thirdPartyVia : (p.objectFrom != null ? p.objectFrom : ""));
        db.insertWithOnConflict("stations", null, v, SQLiteDatabase.CONFLICT_REPLACE);
    }

    public synchronized List<Station> stations(int limit) {
        List<Station> out = new ArrayList<>();
        try (Cursor c = getReadableDatabase().rawQuery("SELECT call,lat,lon,alt,symTable,symCode,comment,speed,course,lastTs,count,via FROM stations ORDER BY lastTs DESC LIMIT " + limit, null)) {
            while (c.moveToNext()) {
                Station s = new Station();
                s.call = c.getString(0); s.lat = c.getDouble(1); s.lon = c.getDouble(2); s.alt = c.getInt(3);
                s.symTable = c.getString(4).isEmpty() ? '/' : c.getString(4).charAt(0); s.symCode = c.getString(5).isEmpty() ? '>' : c.getString(5).charAt(0);
                s.comment = c.getString(6); s.speedKmh = c.getDouble(7); s.courseDeg = c.getInt(8); s.lastTs = c.getLong(9); s.count = c.getInt(10); s.via = c.getString(11);
                out.add(s);
            }
        }
        return out;
    }

    public synchronized int stationCount() { try (Cursor c = getReadableDatabase().rawQuery("SELECT COUNT(*) FROM stations", null)) { return c.moveToFirst() ? c.getInt(0) : 0; } }
    public synchronized void clearStations() { getWritableDatabase().delete("stations", null, null); }

    public synchronized void log(String kind, String from, String to, String text, String id, boolean mine) {
        ContentValues v = new ContentValues();
        v.put("ts", System.currentTimeMillis()); v.put("kind", kind); v.put("src", from); v.put("dst", to == null ? "" : to); v.put("text", text == null ? "" : text); v.put("msgId", id); v.put("mine", mine ? 1 : 0);
        SQLiteDatabase db = getWritableDatabase();
        db.insert("aprs_log", null, v);
        db.execSQL("DELETE FROM aprs_log WHERE _id NOT IN (SELECT _id FROM aprs_log ORDER BY _id DESC LIMIT 500)");
    }

    public synchronized List<LogEntry> aprsLog(int limit) {
        List<LogEntry> out = new ArrayList<>();
        try (Cursor c = getReadableDatabase().rawQuery("SELECT ts,kind,src,dst,text,msgId,mine FROM aprs_log ORDER BY _id DESC LIMIT " + limit, null)) {
            while (c.moveToNext()) { LogEntry e = new LogEntry(); e.ts = c.getLong(0); e.kind = c.getString(1); e.from = c.getString(2); e.to = c.getString(3); e.text = c.getString(4); e.id = c.getString(5); e.mine = c.getInt(6) == 1; out.add(e); }
        }
        return out;
    }

    public synchronized void dtmf(String digits, int channel, String channelName) {
        ContentValues v = new ContentValues(); v.put("ts", System.currentTimeMillis()); v.put("digits", digits); v.put("channel", channel); v.put("channelName", channelName);
        SQLiteDatabase db = getWritableDatabase(); db.insert("dtmf_log", null, v);
        db.execSQL("DELETE FROM dtmf_log WHERE _id NOT IN (SELECT _id FROM dtmf_log ORDER BY _id DESC LIMIT 200)");
    }

    public synchronized List<Dtmf> dtmfLog(int limit) {
        List<Dtmf> out = new ArrayList<>();
        try (Cursor c = getReadableDatabase().rawQuery("SELECT ts,digits,channel,channelName FROM dtmf_log ORDER BY _id DESC LIMIT " + limit, null)) {
            while (c.moveToNext()) { Dtmf d = new Dtmf(); d.ts = c.getLong(0); d.digits = c.getString(1); d.channel = c.getInt(2); d.channelName = c.getString(3); out.add(d); }
        }
        return out;
    }

    public synchronized void alert(String event, String summary, String raw, boolean eom) {
        ContentValues v = new ContentValues(); v.put("ts", System.currentTimeMillis()); v.put("event", event); v.put("summary", summary); v.put("raw", raw); v.put("eom", eom ? 1 : 0);
        SQLiteDatabase db = getWritableDatabase(); db.insert("wx_alerts", null, v);
        db.execSQL("DELETE FROM wx_alerts WHERE _id NOT IN (SELECT _id FROM wx_alerts ORDER BY _id DESC LIMIT 100)");
    }

    public synchronized List<Alert> alerts(int limit) {
        List<Alert> out = new ArrayList<>();
        try (Cursor c = getReadableDatabase().rawQuery("SELECT ts,event,summary,raw,eom FROM wx_alerts ORDER BY _id DESC LIMIT " + limit, null)) {
            while (c.moveToNext()) { Alert a = new Alert(); a.ts = c.getLong(0); a.event = c.getString(1); a.summary = c.getString(2); a.raw = c.getString(3); a.eom = c.getInt(4) == 1; out.add(a); }
        }
        return out;
    }
}
