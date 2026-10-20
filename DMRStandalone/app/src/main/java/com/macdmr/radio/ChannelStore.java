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
        public double lat, lon, elev;              // from the module's location table (0 = none)
        public boolean softSq; public int softSqLevel = 5;   // software squelch (analog)
        public boolean isDigital() { return type == 0; }
        public String freqText(int hz) { return String.format(java.util.Locale.US, "%.3f", hz / 1e6); }
    }

    public static final class Contact { public long id; public String name = ""; public int number; public int type; }   // type 0 private, 1 group, 2 all
    public static final class Message { public long id; public int peer, type; public boolean outgoing; public long ts; public String text; public int status; }   // status 0 pending 1 sent 2 failed
    public static final class Conversation { public int peer, type; public String name, lastText; public long lastTs; public boolean outgoing; }

    public static final class Zone { public long id; public String name; public int[] numbers = new int[0]; }

    public ChannelStore(Context c) { super(c, "radio.db", null, 5); }
    /** A separate database file (the backup self-test restores into a scratch copy). */
    public ChannelStore(Context c, String file) { super(c, file, null, 5); }

    @Override public void onCreate(SQLiteDatabase db) {
        db.execSQL("CREATE TABLE channels (_id INTEGER PRIMARY KEY AUTOINCREMENT, number INTEGER, name TEXT, type INTEGER, rxFreq INTEGER, txFreq INTEGER,"
                + " power INTEGER, band INTEGER, sq INTEGER, rxType INTEGER, rxSubCode INTEGER, txType INTEGER, txSubCode INTEGER, relay INTEGER, mode INTEGER,"
                + " cc INTEGER, inSlot INTEGER, outSlot INTEGER, contactType INTEGER, txContact INTEGER, encryptSw INTEGER, encryptKey TEXT, interrupt INTEGER,"
                + " groups TEXT, active INTEGER, location TEXT, lat REAL DEFAULT 0, lon REAL DEFAULT 0, elev REAL DEFAULT 0, softSq INTEGER DEFAULT 0, softSqLevel INTEGER DEFAULT 5)");
        db.execSQL("CREATE TABLE zones (_id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, numbers TEXT)");
        db.execSQL("CREATE TABLE contacts (_id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, number INTEGER, type INTEGER)");
        db.execSQL("CREATE TABLE history (_id INTEGER PRIMARY KEY AUTOINCREMENT, channel INTEGER, ts INTEGER, kind TEXT, text TEXT, rssi INTEGER, dmrId INTEGER)");
        db.execSQL("CREATE TABLE messages (_id INTEGER PRIMARY KEY AUTOINCREMENT, peer INTEGER, type INTEGER, outgoing INTEGER, ts INTEGER, text TEXT, status INTEGER)");
    }

    @Override public void onUpgrade(SQLiteDatabase db, int o, int n) {
        // nothing user-created yet at v1: rebuild and let the stock import run again
        db.execSQL("DROP TABLE IF EXISTS channels"); db.execSQL("DROP TABLE IF EXISTS contacts"); db.execSQL("DROP TABLE IF EXISTS history"); db.execSQL("DROP TABLE IF EXISTS messages"); db.execSQL("DROP TABLE IF EXISTS zones");
        onCreate(db);
    }

    /** Tables added after v5 are created here (onUpgrade rebuilds everything, so the version stays put). */
    @Override public void onOpen(SQLiteDatabase db) {
        super.onOpen(db);
        if (!db.isReadOnly()) db.execSQL("CREATE TABLE IF NOT EXISTS tglists (_id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, tgs TEXT)");
    }

    /** A named talkgroup list (the module's TG lists): a set of talkgroups to drop into a channel's RX group list. */
    public static final class TgList { public long id; public String name = ""; public int[] tgs = new int[0]; }

    public List<TgList> tgLists() {
        List<TgList> out = new ArrayList<>();
        try (Cursor c = getReadableDatabase().rawQuery("SELECT _id, name, tgs FROM tglists ORDER BY name COLLATE NOCASE", null)) {
            while (c.moveToNext()) { TgList t = new TgList(); t.id = c.getLong(0); t.name = c.getString(1); t.tgs = parseInts(c.getString(2)); out.add(t); }
        }
        return out;
    }

    public void saveTgList(TgList t) {
        ContentValues v = new ContentValues(); v.put("name", t.name); v.put("tgs", joinInts(t.tgs));
        if (t.id > 0) getWritableDatabase().update("tglists", v, "_id=?", new String[] { String.valueOf(t.id) }); else t.id = getWritableDatabase().insert("tglists", null, v);
    }

    public void deleteTgList(TgList t) { getWritableDatabase().delete("tglists", "_id=?", new String[] { String.valueOf(t.id) }); }

    /** Up to 32 talkgroups: the channel's own first, then the list's, without duplicates. */
    static int[] mergeGroups(int[] own, int[] add) {
        java.util.LinkedHashSet<Integer> s = new java.util.LinkedHashSet<>();
        for (int g : own) if (g > 0) s.add(g);
        for (int g : add) if (g > 0 && s.size() < 32) s.add(g);
        int[] out = new int[Math.min(32, s.size())]; int i = 0; for (int g : s) { if (i >= out.length) break; out[i++] = g; }
        return out;
    }

    /**
     * The module's TG lists (dmrmod_tglists.db): copy the named lists into {@code tglists} and merge each channel's assigned
     * list into its RX group list. {@code stockIdToNumber} maps the stock row _id (what the module keys on) to our channel number.
     */
    private int importModuleTgLists(Context ctx, String stockPackage, java.util.Map<Integer, Integer> stockIdToNumber, StringBuilder err) {
        SQLiteDatabase tdb = copyStock(ctx, stockPackage, "dmrmod_tglists.db", "stock_tglists.db");
        if (tdb == null) return 0;
        SQLiteDatabase db = getWritableDatabase();
        int merged = 0;
        try {
            java.util.Map<Integer, int[]> byId = new java.util.HashMap<>();
            db.delete("tglists", null, null);
            try (Cursor c = tdb.rawQuery("SELECT id, name, tg_ids FROM tg_lists", null)) {
                while (c.moveToNext()) {
                    int[] tgs = parseInts(c.getString(2)); byId.put(c.getInt(0), tgs);
                    if (tgs.length == 0) continue;
                    TgList t = new TgList(); t.name = c.getString(1); t.tgs = tgs; saveTgList(t);
                }
            }
            try (Cursor c = tdb.rawQuery("SELECT channel_id, tg_list_id FROM channel_tglist_assignments", null)) {
                while (c.moveToNext()) {
                    Integer num = stockIdToNumber.get(c.getInt(0)); int[] tgs = byId.get(c.getInt(1));
                    if (num == null || tgs == null || tgs.length == 0) continue;
                    Channel ch = byNumber(num); if (ch == null || !ch.isDigital()) continue;
                    int[] g = mergeGroups(ch.groups, tgs);
                    if (g.length != ch.groups.length) { ContentValues v = new ContentValues(); v.put("groups", joinInts(g)); db.update("channels", v, "number=?", new String[] { String.valueOf(num) }); merged++; }
                }
            }
        } catch (Throwable t) { err.append("tglists: ").append(t.getMessage()).append("; "); }
        finally { tdb.close(); }
        return merged;
    }

    /**
     * For an install imported before TG lists were read: map the stock rows to our channels by name and receive frequency
     * (numbers may have changed since) and import the module's lists and assignments without touching anything else.
     */
    public int repairModuleTgLists(Context ctx, String stockPackage, String areaKey, StringBuilder err) {
        SQLiteDatabase sdb = copyStock(ctx, stockPackage, "database_channel_area_" + areaKey + ".db", "stock_repair.db");
        if (sdb == null) { err.append("stock channels not readable"); return -1; }
        java.util.Map<Integer, Integer> map = new java.util.HashMap<>();
        try (Cursor c = sdb.rawQuery("SELECT _id, channel_name, channel_rxFreq FROM database_channel_area_" + areaKey, null)) {
            List<Channel> mine = all();
            while (c.moveToNext()) {
                String name = c.getString(1); int rx = c.getInt(2);
                for (Channel ch : mine) if (ch.rxFreq == rx && ch.name != null && ch.name.equals(name)) { map.put(c.getInt(0), ch.number); break; }
            }
        } finally { sdb.close(); }
        return importModuleTgLists(ctx, stockPackage, map, err);
    }

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

    public void delete(Channel ch) {
        SQLiteDatabase db = getWritableDatabase();
        db.delete("channels", "_id=?", new String[] { String.valueOf(ch.id) });
        db.execSQL("UPDATE channels SET number = number - 1 WHERE number > ?", new Object[] { ch.number });   // keep 1..n contiguous
    }

    public void update(Channel ch) { getWritableDatabase().update("channels", values(ch), "_id=?", new String[] { String.valueOf(ch.id) }); }

    /**
     * Delete packet lines ("📡 SRC>…") whose source is not a callsign: noise frames that passed the FCS were logged
     * before {@code Ax25.plausible} existed. Returns how many were removed.
     */
    public int purgeGarbledPacketHistory() {
        java.util.List<Long> bad = new java.util.ArrayList<>();
        java.util.regex.Pattern call = java.util.regex.Pattern.compile("^[A-Z0-9]{1,6}(-\\d{1,2})?$");
        try (Cursor c = getReadableDatabase().rawQuery("SELECT _id, text FROM history WHERE kind = 'pkt'", null)) {
            while (c.moveToNext()) {
                String t = c.getString(1); if (t == null || !t.startsWith("\uD83D\uDCE1 ")) continue;   // only received-packet lines
                String body = t.startsWith("\uD83D\uDCE1 ") ? t.substring(3) : t;
                boolean control = false; for (int i = 0; i < t.length(); i++) { char ch = t.charAt(i); if (ch < 0x20 || ch == 0x7F || ch == '\uFFFD') { control = true; break; } }
                int end = body.length(); for (char stop : new char[] { '>', ':' }) { int k = body.indexOf(stop); if (k > 0 && k < end) end = k; }
                String src = body.substring(0, end).trim();
                boolean outgoing = body.startsWith("Sent ") || body.startsWith("Beacon ") || body.startsWith("Digipeated") || body.startsWith("APRS") || body.startsWith("SSTV") || body.startsWith("DTMF");
                if (control || (!outgoing && !call.matcher(src).matches())) bad.add(c.getLong(0));
            }
        }
        SQLiteDatabase db = getWritableDatabase();
        for (long id : bad) db.delete("history", "_id=?", new String[] { String.valueOf(id) });
        return bad.size();
    }

    public void addHistory(int channel, String kind, String text, int rssi, int dmrId) {
        ContentValues v = new ContentValues();
        v.put("channel", channel); v.put("ts", System.currentTimeMillis()); v.put("kind", kind); v.put("text", text); v.put("rssi", rssi); v.put("dmrId", dmrId);
        getWritableDatabase().insert("history", null, v);
    }

    /** Finished caption sentences, newest first: [ts, channel, text]. */
    public List<Object[]> captions(int limit) {
        List<Object[]> out = new ArrayList<>();
        try (Cursor c = getReadableDatabase().rawQuery("SELECT ts, channel, text FROM history WHERE kind='txt' ORDER BY ts DESC LIMIT " + limit, null)) {
            while (c.moveToNext()) out.add(new Object[] { c.getLong(0), c.getInt(1), c.getString(2) });
        }
        return out;
    }

    /** Newest events first for Last heard: [ts, channel, kind, text, dmrId]. */
    public List<Object[]> lastHeard(int limit) {
        List<Object[]> out = new ArrayList<>();
        try (Cursor c = getReadableDatabase().rawQuery("SELECT ts, channel, kind, text, dmrId FROM history WHERE kind IN ('rx','dmr','sms','rec','pkt') ORDER BY ts DESC LIMIT " + limit, null)) {
            while (c.moveToNext()) out.add(new Object[] { c.getLong(0), c.getInt(1), c.getString(2), c.getString(3), c.getInt(4) });
        }
        return out;
    }

    /** Warnings, errors and car/coverage events (the Alerts and Events sections of Last heard), newest first. */
    public List<Object[]> events(long sinceTs, int limit) {
        List<Object[]> out = new ArrayList<>();
        try (Cursor c = getReadableDatabase().rawQuery("SELECT ts, channel, kind, text, dmrId FROM history WHERE ts>=? AND (kind IN ('car','cov','warn','busy','alert') OR text LIKE '⛔%' OR text LIKE '⚠%') ORDER BY ts DESC LIMIT " + limit,
                new String[] { String.valueOf(sinceTs) })) {
            while (c.moveToNext()) out.add(new Object[] { c.getLong(0), c.getInt(1), c.getString(2), c.getString(3), c.getInt(4) });
        }
        return out;
    }

    /** Every history line within {@code ms} of {@code ts}, oldest first (the "Around this time" list of an event). */
    public List<Object[]> around(long ts, long ms) {
        List<Object[]> out = new ArrayList<>();
        try (Cursor c = getReadableDatabase().rawQuery("SELECT ts, channel, kind, text FROM history WHERE ts BETWEEN ? AND ? ORDER BY ts ASC LIMIT 40",
                new String[] { String.valueOf(ts - ms), String.valueOf(ts + ms) })) {
            while (c.moveToNext()) out.add(new Object[] { c.getLong(0), c.getInt(1), c.getString(2), c.getString(3) });
        }
        return out;
    }

    public List<String> recentHistory(int channel, int limit) {
        List<String> out = new ArrayList<>();
        // the module shows the newest N lines in chronological order (oldest at the top)
        try (Cursor c = getReadableDatabase().rawQuery("SELECT ts, text, rssi FROM (SELECT ts, text, rssi FROM history WHERE channel=? AND kind<>'txt' ORDER BY ts DESC LIMIT ?) ORDER BY ts ASC", new String[] { String.valueOf(channel), String.valueOf(limit) })) {
            java.text.SimpleDateFormat f = new java.text.SimpleDateFormat("HH:mm:ss", java.util.Locale.US);
            while (c.moveToNext()) out.add(f.format(new java.util.Date(c.getLong(0))) + " " + c.getString(1) + (c.getInt(2) != -999 ? " " + c.getInt(2) + " dBm" : ""));
        }
        return out;
    }

    // ---- zones ----
    public List<Zone> zones() {
        List<Zone> out = new ArrayList<>();
        try (Cursor c = getReadableDatabase().query("zones", null, null, null, null, null, "name COLLATE NOCASE")) {
            while (c.moveToNext()) { Zone z = new Zone(); z.id = c.getLong(0); z.name = c.getString(1); z.numbers = parseInts(c.getString(2)); out.add(z); }
        }
        return out;
    }
    public Zone zone(long id) { for (Zone z : zones()) if (z.id == id) return z; return null; }
    public long saveZone(Zone z) {
        ContentValues v = new ContentValues(); v.put("name", z.name); v.put("numbers", joinInts(z.numbers));
        if (z.id > 0) { getWritableDatabase().update("zones", v, "_id=?", new String[] { String.valueOf(z.id) }); return z.id; }
        return z.id = getWritableDatabase().insert("zones", null, v);
    }
    public void deleteZone(long id) { getWritableDatabase().delete("zones", "_id=?", new String[] { String.valueOf(id) }); }
    private static int[] parseInts(String s) {
        List<Integer> l = new ArrayList<>();
        if (s != null) for (String t : s.split("[,;\\- ]")) { t = t.trim(); if (!t.isEmpty()) try { l.add(Integer.parseInt(t)); } catch (NumberFormatException ignored) { } }
        int[] a = new int[l.size()]; for (int i = 0; i < a.length; i++) a[i] = l.get(i); return a;
    }
    private static String joinInts(int[] a) { StringBuilder b = new StringBuilder(); for (int x : a) { if (b.length() > 0) b.append(','); b.append(x); } return b.toString(); }

    // ---- contacts ----
    public List<Contact> contacts() {
        List<Contact> out = new ArrayList<>();
        try (Cursor c = getReadableDatabase().query("contacts", null, null, null, null, null, "name COLLATE NOCASE")) {
            while (c.moveToNext()) { Contact ct = new Contact(); ct.id = c.getLong(0); ct.name = c.getString(1) == null ? "" : c.getString(1); ct.number = c.getInt(2); ct.type = c.getInt(3); out.add(ct); }
        }
        return out;
    }
    public String contactName(int number, int type) {
        try (Cursor c = getReadableDatabase().rawQuery("SELECT name FROM contacts WHERE number=? ORDER BY (type=?) DESC LIMIT 1", new String[] { String.valueOf(number), String.valueOf(type) })) { return c.moveToFirst() ? c.getString(0) : ""; }
    }
    public void insertContact(Contact ct) { ContentValues v = new ContentValues(); v.put("name", ct.name); v.put("number", ct.number); v.put("type", ct.type); ct.id = getWritableDatabase().insert("contacts", null, v); }
    public void updateContact(Contact ct) { ContentValues v = new ContentValues(); v.put("name", ct.name); v.put("number", ct.number); v.put("type", ct.type); getWritableDatabase().update("contacts", v, "_id=?", new String[] { String.valueOf(ct.id) }); }
    public void deleteContact(Contact ct) { getWritableDatabase().delete("contacts", "_id=?", new String[] { String.valueOf(ct.id) }); }

    // ---- messages ----
    public long addMessage(int peer, int type, boolean outgoing, String text, int status) {
        ContentValues v = new ContentValues(); v.put("peer", peer); v.put("type", type); v.put("outgoing", outgoing ? 1 : 0); v.put("ts", System.currentTimeMillis()); v.put("text", text); v.put("status", status);
        return getWritableDatabase().insert("messages", null, v);
    }
    public void setMessageStatus(long id, int status) { ContentValues v = new ContentValues(); v.put("status", status); getWritableDatabase().update("messages", v, "_id=?", new String[] { String.valueOf(id) }); }
    public List<Message> messages(int peer, int type) {
        List<Message> out = new ArrayList<>();
        try (Cursor c = getReadableDatabase().query("messages", null, "peer=? AND type=?", new String[] { String.valueOf(peer), String.valueOf(type) }, null, null, "ts")) {
            while (c.moveToNext()) { Message m = new Message(); m.id = c.getLong(0); m.peer = c.getInt(1); m.type = c.getInt(2); m.outgoing = c.getInt(3) == 1; m.ts = c.getLong(4); m.text = c.getString(5); m.status = c.getInt(6); out.add(m); }
        }
        return out;
    }
    public List<Conversation> conversations() {
        List<Conversation> out = new ArrayList<>();
        try (Cursor c = getReadableDatabase().rawQuery("SELECT peer, type, text, ts, outgoing FROM messages m WHERE ts = (SELECT MAX(ts) FROM messages WHERE peer=m.peer AND type=m.type) ORDER BY ts DESC", null)) {
            while (c.moveToNext()) { Conversation cv = new Conversation(); cv.peer = c.getInt(0); cv.type = c.getInt(1); cv.lastText = c.getString(2); cv.lastTs = c.getLong(3); cv.outgoing = c.getInt(4) == 1; cv.name = contactName(cv.peer, cv.type); out.add(cv); }
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
        v.put("lat", ch.lat); v.put("lon", ch.lon); v.put("elev", ch.elev); v.put("softSq", ch.softSq ? 1 : 0); v.put("softSqLevel", ch.softSqLevel);
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
        ch.lat = c.getDouble(c.getColumnIndexOrThrow("lat")); ch.lon = c.getDouble(c.getColumnIndexOrThrow("lon")); ch.elev = c.getDouble(c.getColumnIndexOrThrow("elev"));
        ch.softSq = c.getInt(c.getColumnIndexOrThrow("softSq")) == 1; ch.softSqLevel = c.getInt(c.getColumnIndexOrThrow("softSqLevel"));
        return ch;
    }

    // ---- import from the stock app (root copy of its per-area database) ----------------------------

    /** @return number of channels imported, or -1 with the reason in {@code err}. */
    public int importFromStock(Context ctx, String stockPackage, String areaKey, StringBuilder err) {
        try {
            // stock files: databases/database_channel_area_<area>.db holding table database_channel_area_<area>
            File dst = new File(ctx.getCacheDir(), "stock_" + areaKey + ".db");
            String r = "";
            for (String base : new String[] { "/data/user/0/", "/data/data/" }) {        // su may see a different mount view
                String src = base + stockPackage + "/databases/database_channel_area_" + areaKey + ".db";
                r = RootSetup.run("cp " + src + " " + dst.getAbsolutePath() + " && chmod 644 " + dst.getAbsolutePath() + " && chown $(stat -c %u:%g " + ctx.getCacheDir().getAbsolutePath() + ") " + dst.getAbsolutePath());
                if (dst.exists() && dst.length() > 0) break;
            }
            if (!dst.exists() || dst.length() == 0) {
                err.append("copy failed: ").append(r).append(" | ls: ").append(RootSetup.run("ls /data/user/0/" + stockPackage + "/databases/ 2>&1 | head -5; id; cat /proc/self/attr/current"));
                return -1;
            }
            SQLiteDatabase sdb = SQLiteDatabase.openDatabase(dst.getAbsolutePath(), null, SQLiteDatabase.OPEN_READONLY);
            int n = 0;
            java.util.Map<Integer, Integer> stockIdToNumber = new java.util.HashMap<>();   // module side-tables key on the stock row _id
            SQLiteDatabase db = getWritableDatabase();
            db.beginTransaction();
            try (Cursor c = sdb.query("database_channel_area_" + areaKey, null, null, null, null, null, "_id")) {   // rows in display order
                db.delete("channels", null, null);
                while (c.moveToNext()) {
                    Channel ch = new Channel();
                    ch.number = ++n;
                    stockIdToNumber.put(coli(c, "_id", -1), ch.number);
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
            SQLiteDatabase cdbTmp = copyStock(ctx, stockPackage, "contact_database.db", "stock_contacts.db");
            SQLiteDatabase cdb = cdbTmp != null ? cdbTmp : sdb;
            try (Cursor c = cdb.query("contact_database", null, null, null, null, null, null)) {
                db.delete("contacts", null, null);
                while (c.moveToNext()) {
                    ContentValues v = new ContentValues();
                    v.put("name", col(c, "contact_name", "")); v.put("number", coli(c, "contact_number", 0)); v.put("type", coli(c, "contact_type", 0));
                    db.insert("contacts", null, v);
                }
            } catch (Throwable t) { err.append("contacts: ").append(t.getMessage()).append("; "); }
            // module side-tables: locations (per channel number) and the activity history
            try {
                SQLiteDatabase ldb = copyStock(ctx, stockPackage, "dmrmod_locations.db", "stock_locations.db");
                if (ldb != null) {
                    try (Cursor c = ldb.rawQuery("SELECT * FROM channel_locations", null)) {
                        while (c.moveToNext()) {
                            Integer mapped = stockIdToNumber.get(coli(c, "channel_number", 0));   // "channel_number" holds the stock _id
                            int num = mapped != null ? mapped : coli(c, "channel_number", 0);
                            ContentValues v = new ContentValues();
                            v.put("lat", c.getDouble(c.getColumnIndexOrThrow("latitude"))); v.put("lon", c.getDouble(c.getColumnIndexOrThrow("longitude")));
                            int ei = c.getColumnIndex("elevation"); v.put("elev", ei >= 0 && !c.isNull(ei) ? c.getDouble(ei) : 0);
                            db.update("channels", v, "number=?", new String[] { String.valueOf(num) });
                        }
                    }
                    ldb.close();
                }
            } catch (Throwable t) { err.append("locations: ").append(t.getMessage()).append("; "); }
            try {
                SQLiteDatabase hdb = copyStock(ctx, stockPackage, "dmrmod_history.db", "stock_history.db");
                if (hdb != null) {
                    db.delete("history", null, null);
                    try (Cursor c = hdb.rawQuery("SELECT channel_number, dmr_id, activity_type, rssi_dbm, created_at FROM channel_history ORDER BY created_at", null)) {
                        while (c.moveToNext()) {
                            ContentValues v = new ContentValues();
                            v.put("channel", c.getInt(0)); v.put("ts", c.getLong(4)); v.put("kind", "mod"); v.put("text", c.getString(2));
                            v.put("rssi", c.isNull(3) ? -999 : c.getInt(3));
                            int id = 0; try { id = Integer.parseInt(c.getString(1)); } catch (Exception ignored) { }
                            v.put("dmrId", id);
                            db.insert("history", null, v);
                        }
                    }
                    hdb.close();
                }
            } catch (Throwable t) { err.append("history: ").append(t.getMessage()).append("; "); }
            try {
                SQLiteDatabase zdb = copyStock(ctx, stockPackage, "dmrmod_zones.db", "stock_zones.db");
                if (zdb != null) {
                    db.delete("zones", null, null);
                    try (Cursor c = zdb.rawQuery("SELECT name, channel_list FROM zones", null)) {
                        while (c.moveToNext()) {
                            List<Integer> nums = new ArrayList<>();
                            for (int sid : parseInts(c.getString(1))) { Integer num = stockIdToNumber.get(sid); if (num != null) nums.add(num); }
                            Zone z = new Zone(); z.name = c.getString(0); z.numbers = new int[nums.size()]; for (int i = 0; i < nums.size(); i++) z.numbers[i] = nums.get(i);
                            ContentValues v = new ContentValues(); v.put("name", z.name); v.put("numbers", joinInts(z.numbers)); db.insert("zones", null, v);
                        }
                    }
                    zdb.close();
                }
            } catch (Throwable t) { err.append("zones: ").append(t.getMessage()).append("; "); }
            try {
                SQLiteDatabase qdb = copyStock(ctx, stockPackage, "dmrmod_softsq.db", "stock_softsq.db");
                if (qdb != null) {
                    try (Cursor c = qdb.rawQuery("SELECT channel_id, enabled, level FROM channel_softsq", null)) {
                        while (c.moveToNext()) {
                            Integer num = stockIdToNumber.get(c.getInt(0)); if (num == null) continue;
                            ContentValues v = new ContentValues(); v.put("softSq", c.getInt(1)); v.put("softSqLevel", c.getInt(2));
                            db.update("channels", v, "number=?", new String[] { String.valueOf(num) });
                        }
                    }
                    qdb.close();
                }
            } catch (Throwable t) { err.append("softsq: ").append(t.getMessage()).append("; "); }
            importModuleTgLists(ctx, stockPackage, stockIdToNumber, err);
            sdb.close();
            return n;
        } catch (Throwable t) { err.append(t.toString()); return -1; }
    }

    /** Root-copy one of the stock app's database files into our cache and open it read-only (null if unavailable). */
    private static SQLiteDatabase copyStock(Context ctx, String stockPackage, String file, String localName) {
        File dst = new File(ctx.getCacheDir(), localName);
        for (String base : new String[] { "/data/user/0/", "/data/data/" }) {
            RootSetup.run("cp " + base + stockPackage + "/databases/" + file + " " + dst.getAbsolutePath() + " && chmod 644 " + dst.getAbsolutePath());
            if (dst.exists() && dst.length() > 0) break;
        }
        if (!dst.exists() || dst.length() == 0) return null;
        try { return SQLiteDatabase.openDatabase(dst.getAbsolutePath(), null, SQLiteDatabase.OPEN_READONLY); } catch (Throwable t) { return null; }
    }

    private static String col(Cursor c, String n, String d) { int i = c.getColumnIndex(n); return i < 0 || c.isNull(i) ? d : c.getString(i); }
    private static int coli(Cursor c, String n, int d) { int i = c.getColumnIndex(n); return i < 0 || c.isNull(i) ? d : c.getInt(i); }
}
