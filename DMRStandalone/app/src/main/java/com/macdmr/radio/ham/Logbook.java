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
import java.util.TimeZone;

/**
 * The station logbook: contacts you log (QSOs, with signal reports) and stations the radio heard on its own (DMR
 * callers with a RadioID callsign, APRS stations, Morse identifications), exported as ADIF for logging programs and
 * QSL services. Heard entries are marked SWL in the export until you mark them as a contact.
 */
public final class Logbook extends SQLiteOpenHelper {
    public static final class Entry {
        public long id, ts; public long freqHz; public String call = "", mode = "FM", name = "", notes = "", rstSent = "", rstRcvd = "", source = "", grid = "", qth = "";
        public boolean qso;
    }

    public Logbook(Context c) { super(c, "logbook.db", null, 2); }

    @Override public void onCreate(SQLiteDatabase db) {
        db.execSQL("CREATE TABLE log (_id INTEGER PRIMARY KEY AUTOINCREMENT, ts INTEGER, call TEXT, freq INTEGER, mode TEXT, rstSent TEXT, rstRcvd TEXT, name TEXT, notes TEXT, qso INTEGER, source TEXT, grid TEXT DEFAULT '', qth TEXT DEFAULT '')");
    }
    @Override public void onUpgrade(SQLiteDatabase db, int o, int n) {
        if (o < 2) { db.execSQL("ALTER TABLE log ADD COLUMN grid TEXT DEFAULT ''"); db.execSQL("ALTER TABLE log ADD COLUMN qth TEXT DEFAULT ''"); }   // callsign lookup
    }

    /** Fill in name, grid and place for every entry of {@code call} that lacks them (from a callsign lookup). */
    public synchronized void enrich(String call, String name, String grid, String qth) {
        String c = baseCall(call); if (c == null) return;
        SQLiteDatabase db = getWritableDatabase();
        if (name != null && !name.isEmpty()) { ContentValues v = new ContentValues(); v.put("name", name); db.update("log", v, "call=? AND (name IS NULL OR name='')", new String[] { c }); }
        if (grid != null && !grid.isEmpty()) { ContentValues v = new ContentValues(); v.put("grid", grid); db.update("log", v, "call=? AND (grid IS NULL OR grid='')", new String[] { c }); }
        if (qth != null && !qth.isEmpty()) { ContentValues v = new ContentValues(); v.put("qth", qth); db.update("log", v, "call=? AND (qth IS NULL OR qth='')", new String[] { c }); }
    }
    /** Distinct 4-character grid squares among contacts (VUCC-style count). */
    public synchronized java.util.Set<String> gridsWorked() {
        java.util.Set<String> g = new java.util.TreeSet<>();
        try (Cursor c = getReadableDatabase().rawQuery("SELECT grid FROM log WHERE qso=1 AND grid IS NOT NULL AND length(grid)>=4", null)) { while (c.moveToNext()) g.add(c.getString(0).substring(0, 2).toUpperCase(Locale.US) + c.getString(0).substring(2, 4)); }
        return g;
    }

    /** A station heard: a new entry, or the time of the last heard entry for it (same mode, within an hour) moved on. */
    public synchronized void heard(String call, long freqHz, String mode, String name, String source) {
        String c = baseCall(call); if (c == null) return;
        long now = System.currentTimeMillis();
        SQLiteDatabase db = getWritableDatabase();
        try (Cursor k = db.rawQuery("SELECT _id FROM log WHERE call=? AND mode=? AND qso=0 AND ts>? ORDER BY ts DESC LIMIT 1", new String[] { c, mode, String.valueOf(now - 3600_000L) })) {
            if (k.moveToFirst()) { ContentValues v = new ContentValues(); v.put("ts", now); db.update("log", v, "_id=?", new String[] { String.valueOf(k.getLong(0)) }); return; }
        }
        Entry e = new Entry(); e.ts = now; e.call = c; e.freqHz = freqHz; e.mode = mode; e.name = name == null ? "" : name; e.source = source == null ? "" : source;
        save(e);
    }

    public synchronized long save(Entry e) {
        ContentValues v = new ContentValues();
        v.put("ts", e.ts); v.put("call", e.call.trim().toUpperCase(Locale.US)); v.put("freq", e.freqHz); v.put("mode", e.mode); v.put("rstSent", e.rstSent); v.put("rstRcvd", e.rstRcvd);
        v.put("name", e.name); v.put("notes", e.notes); v.put("qso", e.qso ? 1 : 0); v.put("source", e.source); v.put("grid", e.grid == null ? "" : e.grid); v.put("qth", e.qth == null ? "" : e.qth);
        if (e.id > 0) { getWritableDatabase().update("log", v, "_id=?", new String[] { String.valueOf(e.id) }); return e.id; }
        return e.id = getWritableDatabase().insert("log", null, v);
    }
    public synchronized void delete(long id) { getWritableDatabase().delete("log", "_id=?", new String[] { String.valueOf(id) }); }
    public synchronized int count(boolean qsoOnly) { try (Cursor c = getReadableDatabase().rawQuery("SELECT COUNT(*) FROM log" + (qsoOnly ? " WHERE qso=1" : ""), null)) { return c.moveToFirst() ? c.getInt(0) : 0; } }

    public synchronized List<Entry> list(int limit, boolean qsoOnly) {
        List<Entry> out = new ArrayList<>();
        try (Cursor c = getReadableDatabase().rawQuery("SELECT _id, ts, call, freq, mode, rstSent, rstRcvd, name, notes, qso, source, grid, qth FROM log" + (qsoOnly ? " WHERE qso=1" : "") + " ORDER BY ts DESC LIMIT " + limit, null)) {
            while (c.moveToNext()) {
                Entry e = new Entry(); e.id = c.getLong(0); e.ts = c.getLong(1); e.call = c.getString(2); e.freqHz = c.getLong(3); e.mode = c.getString(4); e.rstSent = c.getString(5); e.rstRcvd = c.getString(6);
                e.name = c.getString(7); e.notes = c.getString(8); e.qso = c.getInt(9) == 1; e.source = c.getString(10); e.grid = c.getString(11) == null ? "" : c.getString(11); e.qth = c.getString(12) == null ? "" : c.getString(12); out.add(e);
            }
        }
        return out;
    }

    /** "W1AW-9" or "w1aw" to "W1AW"; null when it does not look like a callsign (a prefix, a digit, a suffix). */
    public static String baseCall(String call) {
        if (call == null) return null;
        String c = call.trim().toUpperCase(Locale.US); int d = c.indexOf('-'); if (d > 0) c = c.substring(0, d);
        int slash = c.indexOf('/'); if (slash > 0 && slash < c.length() - 1 && c.substring(slash + 1).length() <= 2) c = c.substring(0, slash);   // W1AW/R, W1AW/M
        return looksLikeCall(c) ? c : null;
    }
    /** One or two letters (or a digit and a letter), a digit, then one to four letters: K0ABC, W1AW, 2E0XYZ, VE3ABC. */
    public static boolean looksLikeCall(String c) {
        if (c == null || c.length() < 3 || c.length() > 7) return false;
        int p = -1; for (int i = 0; i < c.length(); i++) if (Character.isDigit(c.charAt(i))) p = i;        // the last digit
        if (p < 1 || p > 3) return false;
        String prefix = c.substring(0, p), suffix = c.substring(p + 1);
        if (suffix.length() < 1 || suffix.length() > 4) return false;
        for (char ch : suffix.toCharArray()) if (ch < 'A' || ch > 'Z') return false;
        boolean letter = false;
        for (char ch : prefix.toCharArray()) { if (ch >= 'A' && ch <= 'Z') letter = true; else if (ch < '0' || ch > '9') return false; }
        return letter;
    }

    // ---- ADIF -------------------------------------------------------------------------------------

    public static String band(long hz) {
        double m = hz / 1e6;
        if (m >= 144 && m <= 148) return "2m"; if (m >= 222 && m <= 225) return "1.25m"; if (m >= 420 && m <= 450) return "70cm";
        if (m >= 50 && m <= 54) return "6m"; if (m >= 902 && m <= 928) return "33cm";
        return null;
    }
    private static void field(StringBuilder sb, String name, String value) {
        if (value == null || value.isEmpty()) return;
        sb.append('<').append(name).append(':').append(value.length()).append('>').append(value).append(' ');
    }

    /** The entries as an ADIF 3.1 file. */
    public static String adif(List<Entry> entries, String version) {
        StringBuilder sb = new StringBuilder("SignalDeck logbook export\n");
        field(sb, "ADIF_VER", "3.1.4"); field(sb, "PROGRAMID", "SignalDeck"); field(sb, "PROGRAMVERSION", version);
        sb.append("<EOH>\n");
        SimpleDateFormat d = new SimpleDateFormat("yyyyMMdd", Locale.US), t = new SimpleDateFormat("HHmmss", Locale.US);
        d.setTimeZone(TimeZone.getTimeZone("UTC")); t.setTimeZone(TimeZone.getTimeZone("UTC"));
        for (Entry e : entries) {
            field(sb, "CALL", e.call); field(sb, "QSO_DATE", d.format(new Date(e.ts))); field(sb, "TIME_ON", t.format(new Date(e.ts)));
            if (e.freqHz > 0) field(sb, "FREQ", String.format(Locale.US, "%.6f", e.freqHz / 1e6));
            field(sb, "BAND", band(e.freqHz));
            if ("DMR".equals(e.mode)) { field(sb, "MODE", "DIGITALVOICE"); field(sb, "SUBMODE", "DMR"); }
            else field(sb, "MODE", e.mode);
            field(sb, "RST_SENT", e.rstSent); field(sb, "RST_RCVD", e.rstRcvd); field(sb, "NAME", e.name); field(sb, "GRIDSQUARE", e.grid); field(sb, "QTH", e.qth);
            String comment = (e.notes == null ? "" : e.notes.trim()) + (e.source == null || e.source.isEmpty() ? "" : ((e.notes == null || e.notes.trim().isEmpty()) ? "" : "; ") + e.source);
            field(sb, "COMMENT", comment);
            if (!e.qso) field(sb, "SWL", "Y");
            sb.append("<EOR>\n");
        }
        return sb.toString();
    }
}
