package com.dmrmod.hooks;

import android.content.ContentValues;
import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;

/**
 * Per-channel Soft SQ settings (on/off + level 1–9), keyed by channel {@code _id}, in a module-owned
 * database like {@link LocationDatabase}. When a channel is loaded its saved setting is applied, so
 * the right software squelch and level come up automatically. A channel with no row behaves as
 * before (Soft SQ off).
 *
 * <p>Like the other module side-tables this is one file across all channel areas (backlog R7/H8),
 * fine while only one area is in use; keys are channel {@code _id}.
 */
public class SoftSqDatabase extends SQLiteOpenHelper {

    private static final String DATABASE_NAME = "dmrmod_softsq.db";
    private static final int DATABASE_VERSION = 1;
    private static final String TABLE = "channel_softsq";
    private static final String COL_ID = "channel_id";    // channel _id
    private static final String COL_ENABLED = "enabled";  // 0 / 1
    private static final String COL_LEVEL = "level";      // 1..9

    private static SoftSqDatabase instance;

    /** One channel's Soft SQ setting. */
    public static final class Setting {
        public final boolean enabled;
        public final int level;
        public Setting(boolean enabled, int level) { this.enabled = enabled; this.level = level; }
    }

    private SoftSqDatabase(Context context) {
        super(context, DATABASE_NAME, null, DATABASE_VERSION);
    }

    public static synchronized SoftSqDatabase getInstance(Context context) {
        if (instance == null) instance = new SoftSqDatabase(context.getApplicationContext());
        return instance;
    }

    @Override
    public void onCreate(SQLiteDatabase db) {
        db.execSQL("CREATE TABLE " + TABLE + " (" +
            COL_ID + " INTEGER PRIMARY KEY, " +
            COL_ENABLED + " INTEGER DEFAULT 0, " +
            COL_LEVEL + " INTEGER DEFAULT 5)");
    }

    @Override
    public void onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion) { }

    /** Save (or clear) a channel's Soft SQ setting. Off + default level removes the row to stay tidy. */
    public void save(int channelId, boolean enabled, int level) {
        if (channelId <= 0) return;
        if (level < 1) level = 1; else if (level > 9) level = 9;
        try {
            SQLiteDatabase db = getWritableDatabase();
            if (!enabled) {
                // Keep the level so a later re-enable remembers it, but only if a row exists.
                ContentValues v = new ContentValues();
                v.put(COL_ENABLED, 0);
                v.put(COL_LEVEL, level);
                v.put(COL_ID, channelId);
                db.insertWithOnConflict(TABLE, null, v, SQLiteDatabase.CONFLICT_REPLACE);
            } else {
                ContentValues v = new ContentValues();
                v.put(COL_ID, channelId);
                v.put(COL_ENABLED, 1);
                v.put(COL_LEVEL, level);
                db.insertWithOnConflict(TABLE, null, v, SQLiteDatabase.CONFLICT_REPLACE);
            }
        } catch (Throwable ignore) { }
    }

    /** The channel's setting, or null if none stored. */
    public Setting get(int channelId) {
        if (channelId <= 0) return null;
        Cursor c = null;
        try {
            c = getReadableDatabase().query(TABLE, new String[]{COL_ENABLED, COL_LEVEL},
                COL_ID + "=?", new String[]{String.valueOf(channelId)}, null, null, null);
            if (c != null && c.moveToFirst()) {
                return new Setting(c.getInt(0) == 1, c.getInt(1));
            }
        } catch (Throwable ignore) {
        } finally { if (c != null) c.close(); }
        return null;
    }

    public void delete(int channelId) {
        try { getWritableDatabase().delete(TABLE, COL_ID + "=?", new String[]{String.valueOf(channelId)}); }
        catch (Throwable ignore) { }
    }
}
