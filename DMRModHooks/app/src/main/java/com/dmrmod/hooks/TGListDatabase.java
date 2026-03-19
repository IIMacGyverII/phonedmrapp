package com.dmrmod.hooks;

import android.content.ContentValues;
import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;
import android.util.Log;

import java.util.ArrayList;
import java.util.List;

/**
 * Database for storing named DMR TalkGroup (TG) lists and per-channel TG list assignments.
 *
 * DESIGN:
 * - Named TG lists hold an ordered comma-separated sequence of DMR TG IDs with NO upper limit
 *   on the number of entries.  There is no database-level cap.
 * - Each channel can be assigned exactly one named TG list.
 * - At channel activation time (sendDigitalMessage hook) the first 32 TG IDs are placed into
 *   ChannelData.groups[] and routed to hardware.  Any additional IDs beyond slot 32 are stored
 *   here for display and future software filtering.
 * - Follows the same singleton / SQLiteOpenHelper pattern as ZoneDatabase and APRSDatabase.
 *
 * DATABASE FILE: "dmrmod_tglists.db"
 *
 * TABLES:
 *   tg_lists            — named lists of TG IDs
 *   channel_tglist_assignments — maps channel _id → tg_list id
 */
public class TGListDatabase extends SQLiteOpenHelper {

    private static final String TAG = "DMRModHooks_TGListDB";

    public static final String DATABASE_NAME = "dmrmod_tglists.db";
    private static final int DATABASE_VERSION = 1;

    // — tg_lists table —
    private static final String TABLE_TG_LISTS    = "tg_lists";
    private static final String COL_ID            = "id";
    private static final String COL_NAME          = "name";
    private static final String COL_TG_IDS        = "tg_ids";   // comma-separated integers
    private static final String COL_DESCRIPTION   = "description"; // optional human note

    // — channel_tglist_assignments table —
    private static final String TABLE_ASSIGNMENTS  = "channel_tglist_assignments";
    private static final String COL_CHANNEL_ID     = "channel_id";  // _id from channel DB
    private static final String COL_TG_LIST_ID     = "tg_list_id";

    /** Max entries sent to hardware in one channel-activation packet */
    public static final int HARDWARE_MAX_GROUPS = 32;

    private static TGListDatabase instance;

    private TGListDatabase(Context context) {
        super(context, DATABASE_NAME, null, DATABASE_VERSION);
    }

    /** Singleton accessor */
    public static synchronized TGListDatabase getInstance(Context context) {
        if (instance == null) {
            instance = new TGListDatabase(context.getApplicationContext());
        }
        return instance;
    }

    // =====================================================================
    //  Schema
    // =====================================================================

    @Override
    public void onCreate(SQLiteDatabase db) {
        db.execSQL(
            "CREATE TABLE " + TABLE_TG_LISTS + " (" +
            COL_ID          + " INTEGER PRIMARY KEY AUTOINCREMENT, " +
            COL_NAME        + " TEXT NOT NULL UNIQUE, " +
            COL_TG_IDS      + " TEXT NOT NULL DEFAULT '', " +
            COL_DESCRIPTION + " TEXT DEFAULT '')"
        );
        db.execSQL(
            "CREATE TABLE " + TABLE_ASSIGNMENTS + " (" +
            COL_CHANNEL_ID  + " INTEGER PRIMARY KEY, " +
            COL_TG_LIST_ID  + " INTEGER NOT NULL)"
        );
    }

    @Override
    public void onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion) {
        // Reserved for future migrations
    }

    // =====================================================================
    //  Inner data class
    // =====================================================================

    public static class TGList {
        public final long   id;
        public final String name;
        public final String description;
        private final List<Integer> tgIds;

        public TGList(long id, String name, String description, List<Integer> tgIds) {
            this.id          = id;
            this.name        = name;
            this.description = description != null ? description : "";
            this.tgIds       = tgIds;
        }

        /** Deserialise from the comma-separated DB string */
        public TGList(long id, String name, String description, String tgIdsRaw) {
            this(id, name, description, parseTgIds(tgIdsRaw));
        }

        /** Convenience constructor without description */
        public TGList(long id, String name, String tgIdsRaw) {
            this(id, name, "", parseTgIds(tgIdsRaw));
        }

        /** Read-only view of all TG IDs */
        public List<Integer> getTgIds() {
            return tgIds;
        }

        /** Total number of TG IDs in this list */
        public int size() {
            return tgIds.size();
        }

        /** Returns true when the list has more TG IDs than the hardware can accept */
        public boolean exceedsHardwareLimit() {
            return tgIds.size() > HARDWARE_MAX_GROUPS;
        }

        /**
         * Build the hardware groups array (exactly {@link #HARDWARE_MAX_GROUPS} slots).
         * Slots beyond the number of TG IDs in the list remain 0.
         */
        public int[] getHardwareGroups() {
            int[] hw = new int[HARDWARE_MAX_GROUPS];
            for (int i = 0; i < HARDWARE_MAX_GROUPS && i < tgIds.size(); i++) {
                hw[i] = tgIds.get(i);
            }
            return hw;
        }

        /** Serialise to a compact comma-separated string for DB storage */
        public String getTgIdsString() {
            if (tgIds.isEmpty()) return "";
            StringBuilder sb = new StringBuilder();
            for (int i = 0; i < tgIds.size(); i++) {
                if (i > 0) sb.append(',');
                sb.append(tgIds.get(i));
            }
            return sb.toString();
        }

        /** Returns true when the given TG ID is a member of the list */
        public boolean contains(int tgId) {
            return tgIds.contains(tgId);
        }

        /** Parse a comma-separated TG ID string into a list of integers.  Invalid tokens are skipped. */
        public static List<Integer> parseTgIds(String raw) {
            List<Integer> out = new ArrayList<>();
            if (raw == null || raw.trim().isEmpty()) return out;
            for (String part : raw.split(",")) {
                String p = part.trim();
                if (p.isEmpty()) continue;
                try {
                    int v = Integer.parseInt(p);
                    if (v > 0) out.add(v);   // skip zeros and negatives
                } catch (NumberFormatException ignored) {}
            }
            return out;
        }
    }

    // =====================================================================
    //  TGList CRUD
    // =====================================================================

    /**
     * Insert a new TG list or update an existing one.
     * If {@code list.id > 0} the existing row is updated; otherwise a new row is inserted.
     *
     * @return Row id of the new / updated record, or -1 on error.
     */
    public long saveTGList(TGList list) {
        SQLiteDatabase db = getWritableDatabase();
        ContentValues cv = new ContentValues();
        cv.put(COL_NAME,        list.name);
        cv.put(COL_TG_IDS,      list.getTgIdsString());
        cv.put(COL_DESCRIPTION, list.description);

        if (list.id > 0) {
            int rows = db.update(TABLE_TG_LISTS, cv,
                    COL_ID + "=?", new String[]{String.valueOf(list.id)});
            Log.i(TAG, "Updated TGList id=" + list.id + " name='" + list.name + "' (" + list.size() + " TGs)  rows=" + rows);
            return list.id;
        } else {
            long newId = db.insertWithOnConflict(TABLE_TG_LISTS, null, cv,
                    SQLiteDatabase.CONFLICT_REPLACE);
            Log.i(TAG, "Inserted TGList '" + list.name + "' with " + list.size() + " TGs, id=" + newId);
            return newId;
        }
    }

    /**
     * Convenience method — upsert a list by name with a raw TG-ID string.
     * If a list with that name already exists its TG IDs are replaced.
     *
     * @return Row id of the upserted record.
     */
    public long saveTGList(String name, String tgIdsRaw) {
        TGList existing = getTGListByName(name);
        long id = existing != null ? existing.id : 0;
        return saveTGList(new TGList(id, name, "", tgIdsRaw));
    }

    /** Fetch a TG list by its primary key.  Returns {@code null} if not found. */
    public TGList getTGList(long id) {
        SQLiteDatabase db = getReadableDatabase();
        Cursor c = db.query(TABLE_TG_LISTS,
                new String[]{COL_ID, COL_NAME, COL_DESCRIPTION, COL_TG_IDS},
                COL_ID + "=?", new String[]{String.valueOf(id)},
                null, null, null);
        TGList result = null;
        if (c.moveToFirst()) {
            result = new TGList(c.getLong(0), c.getString(1), c.getString(2), c.getString(3));
        }
        c.close();
        return result;
    }

    /** Fetch a TG list by name.  Returns {@code null} if not found. */
    public TGList getTGListByName(String name) {
        if (name == null) return null;
        SQLiteDatabase db = getReadableDatabase();
        Cursor c = db.query(TABLE_TG_LISTS,
                new String[]{COL_ID, COL_NAME, COL_DESCRIPTION, COL_TG_IDS},
                COL_NAME + "=?", new String[]{name},
                null, null, null);
        TGList result = null;
        if (c.moveToFirst()) {
            result = new TGList(c.getLong(0), c.getString(1), c.getString(2), c.getString(3));
        }
        c.close();
        return result;
    }

    /** Return all TG lists sorted alphabetically by name. */
    public List<TGList> getAllTGLists() {
        List<TGList> lists = new ArrayList<>();
        SQLiteDatabase db = getReadableDatabase();
        Cursor c = db.query(TABLE_TG_LISTS,
                new String[]{COL_ID, COL_NAME, COL_DESCRIPTION, COL_TG_IDS},
                null, null, null, null,
                COL_NAME + " ASC");
        while (c.moveToNext()) {
            lists.add(new TGList(c.getLong(0), c.getString(1), c.getString(2), c.getString(3)));
        }
        c.close();
        return lists;
    }

    /**
     * Delete a TG list and all channel assignments that reference it.
     *
     * @param id Row id of the list to remove.
     */
    public void deleteTGList(long id) {
        SQLiteDatabase db = getWritableDatabase();
        // Remove assignments first (referential integrity by hand since we don't use FK constraints)
        db.delete(TABLE_ASSIGNMENTS, COL_TG_LIST_ID + "=?", new String[]{String.valueOf(id)});
        db.delete(TABLE_TG_LISTS, COL_ID + "=?", new String[]{String.valueOf(id)});
        Log.i(TAG, "Deleted TGList id=" + id + " and all its channel assignments");
    }

    /** Remove all TG lists and all assignments.  Useful before a fresh import. */
    public void clearAllTGLists() {
        SQLiteDatabase db = getWritableDatabase();
        db.delete(TABLE_TG_LISTS, null, null);
        db.delete(TABLE_ASSIGNMENTS, null, null);
        Log.i(TAG, "Cleared all TGLists and assignments");
    }

    /** Returns the number of named TG lists currently stored. */
    public int getTGListCount() {
        SQLiteDatabase db = getReadableDatabase();
        Cursor c = db.rawQuery("SELECT COUNT(*) FROM " + TABLE_TG_LISTS, null);
        int count = 0;
        if (c.moveToFirst()) count = c.getInt(0);
        c.close();
        return count;
    }

    /** Returns {@code true} if a list with the given name exists. */
    public boolean tgListExists(String name) {
        return getTGListByName(name) != null;
    }

    // =====================================================================
    //  Channel ↔ TG list assignments
    // =====================================================================

    /**
     * Assign a TG list to a channel.  Any prior assignment for the same channel is replaced.
     *
     * @param channelId  _id from database_channel_area_default_uhf
     * @param tgListId   id from tg_lists table
     */
    public void assignTGListToChannel(int channelId, long tgListId) {
        SQLiteDatabase db = getWritableDatabase();
        ContentValues cv = new ContentValues();
        cv.put(COL_CHANNEL_ID,  channelId);
        cv.put(COL_TG_LIST_ID,  tgListId);
        db.insertWithOnConflict(TABLE_ASSIGNMENTS, null, cv, SQLiteDatabase.CONFLICT_REPLACE);
        Log.i(TAG, "Assigned TGList id=" + tgListId + " to channel id=" + channelId);
    }

    /**
     * Remove whatever TG list assignment exists for the given channel (if any).
     *
     * @param channelId  _id from channel database
     */
    public void removeAssignmentForChannel(int channelId) {
        SQLiteDatabase db = getWritableDatabase();
        db.delete(TABLE_ASSIGNMENTS, COL_CHANNEL_ID + "=?", new String[]{String.valueOf(channelId)});
        Log.i(TAG, "Removed TGList assignment for channel id=" + channelId);
    }

    /**
     * Get the TG list id assigned to the given channel.
     *
     * @return TG list id, or -1 if the channel has no assignment.
     */
    public long getTGListIdForChannel(int channelId) {
        SQLiteDatabase db = getReadableDatabase();
        Cursor c = db.query(TABLE_ASSIGNMENTS,
                new String[]{COL_TG_LIST_ID},
                COL_CHANNEL_ID + "=?", new String[]{String.valueOf(channelId)},
                null, null, null);
        long result = -1;
        if (c.moveToFirst()) result = c.getLong(0);
        c.close();
        return result;
    }

    /**
     * Get the TGList assigned to the given channel.
     *
     * @return {@link TGList} or {@code null} if no assignment exists.
     */
    public TGList getTGListForChannel(int channelId) {
        long listId = getTGListIdForChannel(channelId);
        if (listId < 0) return null;
        return getTGList(listId);
    }

    /**
     * Convenience method — returns the display name of the TG list assigned to a channel.
     *
     * @return List name, or {@code "None"} if no assignment.
     */
    public String getTGListNameForChannel(int channelId) {
        TGList list = getTGListForChannel(channelId);
        return list != null ? list.name : "None";
    }

    // =====================================================================
    //  Helpers
    // =====================================================================

    /**
     * Build a map of {@code tgListName → TGList} for all stored lists.
     * Useful for CSV-import name-resolution.
     */
    public java.util.Map<String, TGList> buildNameMap() {
        java.util.Map<String, TGList> map = new java.util.LinkedHashMap<>();
        for (TGList l : getAllTGLists()) {
            map.put(l.name, l);
        }
        return map;
    }
}
