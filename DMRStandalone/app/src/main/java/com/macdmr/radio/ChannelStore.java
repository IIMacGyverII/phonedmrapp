package com.macdmr.radio;

import android.content.ContentValues;
import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;

import java.io.File;
import java.util.ArrayList;
import java.util.List;

/**
 * Our own channel table (one row per channel, numbered 1..n in display order). The field set is the
 * module's: it maps 1:1 onto the analog (0x23) / digital (0x22) command bodies.
 * First run: imports the stock app's database (per-area SQLite, table "channel_name") through a root copy,
 * so a user keeps every channel they already programmed.
 */
public final class ChannelStore extends SQLiteOpenHelper {
    public static final class Channel {
        public long id; public int number; public String name = ""; public int type;          // 0 digital, 1 analog
        public int rxFreq, txFreq, power, band = 1, sq = 2, rxType, rxSubCode, txType, txSubCode, relay = 2, mode;
        public int cc = 1, inSlot, outSlot, contactType = 1, txContact, encryptSw = 2, interrupt = 2;
        public String encryptKey = ""; public int[] groups = new int[0]; public boolean active;
        public String location = "";
        public boolean isDigital() { return type == 0; }
        public String freqText(int hz) { return String.format(java.util.Locale.US, "%.3f", hz / 1e6); }
    }

    public ChannelStore(Context c) { super(c, "radio.db", null, 1); }

    @Override public void onCreate(SQLiteDatabase db) {
        db.execSQL("CREATE TABLE channels (_id INTEGER PRIMARY KEY AUTOINCREMENT, number INTEGER, name TEXT, type INTEGER, rxFreq INTEGER, txFreq INTEGER,"
                + " power INTEGER, band INTEGER, sq INTEGER, rxType INTEGER, rxSubCode INTEGER, txType INTEGER, txSubCode INTEGER, relay INTEGER, mode INTEGER,"
                + " cc INTEGER, inSlot INTEGER, outSlot INTEGER, contactType INTEGER, txContact INTEGER, encryptSw INTEGER, encryptKey TEXT, interrupt INTEGER,"
                + " groups TEXT, active INTEGER, location TEXT)");
        db.execSQL("CREATE TABLE contacts (_id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, number INTEGER, type INTEGER)");
        db.execSQL("CREATE TABLE history (_id INTEGER PRIMARY KEY AUTOINCREMENT, channel INTEGER, ts INTEGER, kind TEXT, text TEXT, rssi INTEGER, dmrId INTEGER)");
    }

    @Override public void onUpgrade(SQLiteDatabase db, int o, int n) { }

    public int count() { try (Cursor c = getReadableDatabase().rawQuery("SELECT COUNT(*) FROM channels", null)) { return c.moveToFirst() ? c.getInt(0) : 0; } }

    public List<Channel> all() {
        List<Channel> out = new ArrayList<>();
        try (Cursor c = getReadableDatabase().query("channels", null, null, null, null, null, "number")) { while (c.moveToNext()) out.add(read(c)); }
        return out;
    }

    public Channel byNumber(int n) {
        try (Cursor c = getReadableDatabase().query("channels", null, "number=?", new String[] { String.valueOf(n) }, null, null, null)) { return c.moveToFirst() ? read(c) : null; }
    }

    public int activeNumber() {
        try (Cursor c = getReadableDatabase().rawQuery("SELECT number FROM channels WHERE active=1 LIMIT 1", null)) { return c.moveToFirst() ? c.getInt(0) : 1; }
    }

    public void setActive(int number) {
        SQLiteDatabase db = getWritableDatabase();
        db.execSQL("UPDATE channels SET active=0"); db.execSQL("UPDATE channels SET active=1 WHERE number=?", new Object[] { number });
    }

    public long insert(Channel ch) {
        if (ch.number <= 0) ch.number = count() + 1;
        return getWritableDatabase().insert("channels", null, values(ch));
    }

    public void update(Channel ch) { getWritableDatabase().update("channels", values(ch), "_id=?", new String[] { String.valueOf(ch.id) }); }

    public void addHistory(int channel, String kind, String text, int rssi, int dmrId) {
        ContentValues v = new ContentValues();
        v.put("channel", channel); v.put("ts", System.currentTimeMillis()); v.put("kind", kind); v.put("text", text); v.put("rssi", rssi); v.put("dmrId", dmrId);
        getWritableDatabase().insert("history", null, v);
    }

    public List<String> recentHistory(int channel, int limit) {
        List<String> out = new ArrayList<>();
        try (Cursor c = getReadableDatabase().rawQuery("SELECT ts, text, rssi FROM history WHERE channel=? ORDER BY ts DESC LIMIT ?", new String[] { String.valueOf(channel), String.valueOf(limit) })) {
            java.text.SimpleDateFormat f = new java.text.SimpleDateFormat("HH:mm:ss", java.util.Locale.US);
            while (c.moveToNext()) out.add(f.format(new java.util.Date(c.getLong(0))) + " " + c.getString(1) + (c.getInt(2) != -999 ? " " + c.getInt(2) + " dBm" : ""));
        }
        return out;
    }

    private static ContentValues values(Channel ch) {
        ContentValues v = new ContentValues();
        v.put("number", ch.number); v.put("name", ch.name); v.put("type", ch.type); v.put("rxFreq", ch.rxFreq); v.put("txFreq", ch.txFreq);
        v.put("power", ch.power); v.put("band", ch.band); v.put("sq", ch.sq); v.put("rxType", ch.rxType); v.put("rxSubCode", ch.rxSubCode);
        v.put("txType", ch.txType); v.put("txSubCode", ch.txSubCode); v.put("relay", ch.relay); v.put("mode", ch.mode); v.put("cc", ch.cc);
        v.put("inSlot", ch.inSlot); v.put("outSlot", ch.outSlot); v.put("contactType", ch.contactType); v.put("txContact", ch.txContact);
        v.put("encryptSw", ch.encryptSw); v.put("encryptKey", ch.encryptKey); v.put("interrupt", ch.interrupt);
        StringBuilder g = new StringBuilder(); for (int x : ch.groups) { if (g.length() > 0) g.append(','); g.append(x); }
        v.put("groups", g.toString()); v.put("active", ch.active ? 1 : 0); v.put("location", ch.location);
        return v;
    }

    private static Channel read(Cursor c) {
        Channel ch = new Channel();
        ch.id = c.getLong(c.getColumnIndexOrThrow("_id")); ch.number = c.getInt(c.getColumnIndexOrThrow("number")); ch.name = c.getString(c.getColumnIndexOrThrow("name"));
        ch.type = c.getInt(c.getColumnIndexOrThrow("type")); ch.rxFreq = c.getInt(c.getColumnIndexOrThrow("rxFreq")); ch.txFreq = c.getInt(c.getColumnIndexOrThrow("txFreq"));
        ch.power = c.getInt(c.getColumnIndexOrThrow("power")); ch.band = c.getInt(c.getColumnIndexOrThrow("band")); ch.sq = c.getInt(c.getColumnIndexOrThrow("sq"));
        ch.rxType = c.getInt(c.getColumnIndexOrThrow("rxType")); ch.rxSubCode = c.getInt(c.getColumnIndexOrThrow("rxSubCode")); ch.txType = c.getInt(c.getColumnIndexOrThrow("txType"));
        ch.txSubCode = c.getInt(c.getColumnIndexOrThrow("txSubCode")); ch.relay = c.getInt(c.getColumnIndexOrThrow("relay")); ch.mode = c.getInt(c.getColumnIndexOrThrow("mode"));
        ch.cc = c.getInt(c.getColumnIndexOrThrow("cc")); ch.inSlot = c.getInt(c.getColumnIndexOrThrow("inSlot")); ch.outSlot = c.getInt(c.getColumnIndexOrThrow("outSlot"));
        ch.contactType = c.getInt(c.getColumnIndexOrThrow("contactType")); ch.txContact = c.getInt(c.getColumnIndexOrThrow("txContact"));
        ch.encryptSw = c.getInt(c.getColumnIndexOrThrow("encryptSw")); ch.encryptKey = c.getString(c.getColumnIndexOrThrow("encryptKey")); ch.interrupt = c.getInt(c.getColumnIndexOrThrow("interrupt"));
        String g = c.getString(c.getColumnIndexOrThrow("groups")); List<Integer> gl = new ArrayList<>();
        if (g != null) for (String s : g.split(",")) { s = s.trim(); if (!s.isEmpty()) try { gl.add(Integer.parseInt(s)); } catch (NumberFormatException ignored) { } }
        ch.groups = new int[gl.size()]; for (int i = 0; i < gl.size(); i++) ch.groups[i] = gl.get(i);
        ch.active = c.getInt(c.getColumnIndexOrThrow("active")) == 1; ch.location = c.getString(c.getColumnIndexOrThrow("location"));
        return ch;
    }

    // ---- import from the stock app (root copy of its per-area database) ----------------------------

    /** @return number of channels imported, or -1 with the reason in {@code err}. */
    public int importFromStock(Context ctx, String stockPackage, String areaKey, StringBuilder err) {
        try {
            // stock files: databases/database_channel_area_<area>.db holding table database_channel_area_<area>
            File dst = new File(ctx.getCacheDir(), "stock_" + areaKey + ".db");
            String src = "/data/data/" + stockPackage + "/databases/database_channel_area_" + areaKey + ".db";
            String r = RootSetup.run("cp " + src + " " + dst.getAbsolutePath() + " && chmod 644 " + dst.getAbsolutePath() + " && chown $(stat -c %u:%g " + ctx.getCacheDir().getAbsolutePath() + ") " + dst.getAbsolutePath());
            if (!dst.exists() || dst.length() == 0) { err.append("copy failed: ").append(r); return -1; }
            SQLiteDatabase sdb = SQLiteDatabase.openDatabase(dst.getAbsolutePath(), null, SQLiteDatabase.OPEN_READONLY);
            int n = 0;
            SQLiteDatabase db = getWritableDatabase();
            db.beginTransaction();
            try (Cursor c = sdb.query("database_channel_area_" + areaKey, null, null, null, null, null, "_id")) {   // rows in display order
                db.delete("channels", null, null);
                while (c.moveToNext()) {
                    Channel ch = new Channel();
                    ch.number = ++n;
                    ch.name = col(c, "channel_name", ""); ch.type = coli(c, "channel_type", 1);
                    ch.rxFreq = coli(c, "channel_rxFreq", 0); ch.txFreq = coli(c, "channel_txFreq", 0); ch.power = coli(c, "channel_power", 0);
                    ch.band = coli(c, "channel_band", 1); ch.sq = coli(c, "channel_sq", 2); ch.rxType = coli(c, "channel_rxType", 0); ch.rxSubCode = coli(c, "channel_rxSubCode", 0);
                    ch.txType = coli(c, "channel_txType", 0); ch.txSubCode = coli(c, "channel_txSubCode", 0); ch.relay = coli(c, "channel_relay", 2); ch.mode = coli(c, "channel_mode", 0);
                    ch.cc = coli(c, "channel_cc", 1); ch.inSlot = coli(c, "channel_inBoundSlot", 0); ch.outSlot = coli(c, "channel_outBoundSlot", 0);
                    ch.contactType = coli(c, "channel_contactType", 1); ch.txContact = coli(c, "channel_txContact", 0); ch.encryptSw = coli(c, "channel_encryptSw", 2);
                    ch.encryptKey = col(c, "channel_encryptKey", ""); ch.interrupt = coli(c, "channel_interrupt", 2); ch.active = coli(c, "channel_active", 0) == 1;
                    if (ch.relay == 0) ch.relay = 2;
                    String groups = col(c, "channel_groups", null);
                    if (groups != null && !groups.trim().isEmpty()) {
                        List<Integer> gl = new ArrayList<>();
                        for (String s : groups.split("[,;\\- ]")) { s = s.trim(); if (!s.isEmpty()) try { int v = Integer.parseInt(s); if (v > 0) gl.add(v); } catch (NumberFormatException ignored) { } }
                        ch.groups = new int[gl.size()]; for (int i = 0; i < gl.size(); i++) ch.groups[i] = gl.get(i);
                    }
                    db.insert("channels", null, values(ch));
                }
                db.setTransactionSuccessful();
            } finally { db.endTransaction(); }
            File cdst = new File(ctx.getCacheDir(), "stock_contacts.db");
            RootSetup.run("cp /data/data/" + stockPackage + "/databases/contact_database.db " + cdst.getAbsolutePath() + " && chmod 644 " + cdst.getAbsolutePath());
            SQLiteDatabase cdb = cdst.exists() && cdst.length() > 0 ? SQLiteDatabase.openDatabase(cdst.getAbsolutePath(), null, SQLiteDatabase.OPEN_READONLY) : sdb;
            try (Cursor c = cdb.query("contact_database", null, null, null, null, null, null)) {
                db.delete("contacts", null, null);
                while (c.moveToNext()) {
                    ContentValues v = new ContentValues();
                    v.put("name", col(c, "contact_name", "")); v.put("number", coli(c, "contact_number", 0)); v.put("type", coli(c, "contact_type", 0));
                    db.insert("contacts", null, v);
                }
            } catch (Throwable t) { err.append("contacts: ").append(t.getMessage()).append("; "); }
            sdb.close();
            return n;
        } catch (Throwable t) { err.append(t.toString()); return -1; }
    }

    private static String col(Cursor c, String n, String d) { int i = c.getColumnIndex(n); return i < 0 || c.isNull(i) ? d : c.getString(i); }
    private static int coli(Cursor c, String n, int d) { int i = c.getColumnIndex(n); return i < 0 || c.isNull(i) ? d : c.getInt(i); }
}
