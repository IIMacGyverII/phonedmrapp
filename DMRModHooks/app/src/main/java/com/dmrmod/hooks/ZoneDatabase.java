package com.dmrmod.hooks;

import android.content.ContentValues;
import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;

import java.util.ArrayList;
import java.util.List;

/**
 * Database for storing channel zone data.
 * Zones allow organizing channels into groups (like folders).
 * Each zone contains a list of channel numbers.
 * This follows the OpenGD77 Zones.csv format.
 */
public class ZoneDatabase extends SQLiteOpenHelper {
    
    private static final String DATABASE_NAME = "dmrmod_zones.db";
    private static final int DATABASE_VERSION = 1;
    
    // Table and column names
    private static final String TABLE_ZONES = "zones";
    private static final String COLUMN_ID = "id";
    private static final String COLUMN_NAME = "name";
    private static final String COLUMN_CHANNEL_LIST = "channel_list";
    
    private static ZoneDatabase instance;
    
    private ZoneDatabase(Context context) {
        super(context, DATABASE_NAME, null, DATABASE_VERSION);
    }
    
    /**
     * Get singleton instance of ZoneDatabase
     */
    public static synchronized ZoneDatabase getInstance(Context context) {
        if (instance == null) {
            instance = new ZoneDatabase(context.getApplicationContext());
        }
        return instance;
    }
    
    @Override
    public void onCreate(SQLiteDatabase db) {
        String createTable = "CREATE TABLE " + TABLE_ZONES + " (" +
                COLUMN_ID + " INTEGER PRIMARY KEY AUTOINCREMENT, " +
                COLUMN_NAME + " TEXT NOT NULL, " +
                COLUMN_CHANNEL_LIST + " TEXT NOT NULL)";
        db.execSQL(createTable);
    }
    
    @Override
    public void onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion) {
        // No upgrades yet
    }
    
    /**
     * Save or update a zone
     * @param zone Zone object with name and channel list
     * @return Zone ID (newly created or existing)
     */
    public long saveZone(Zone zone) {
        SQLiteDatabase db = getWritableDatabase();
        ContentValues values = new ContentValues();
        values.put(COLUMN_NAME, zone.name);
        values.put(COLUMN_CHANNEL_LIST, zone.getChannelListString());
        
        if (zone.id > 0) {
            // Update existing zone
            db.update(TABLE_ZONES, values, 
                    COLUMN_ID + " = ?",
                    new String[]{String.valueOf(zone.id)});
            return zone.id;
        } else {
            // Insert new zone
            return db.insert(TABLE_ZONES, null, values);
        }
    }
    
    /**
     * Get a zone by ID
     * @return Zone object or null if not found
     */
    public Zone getZone(long zoneId) {
        SQLiteDatabase db = getReadableDatabase();
        Cursor cursor = db.query(
                TABLE_ZONES,
                new String[]{COLUMN_ID, COLUMN_NAME, COLUMN_CHANNEL_LIST},
                COLUMN_ID + " = ?",
                new String[]{String.valueOf(zoneId)},
                null, null, null
        );
        
        Zone zone = null;
        if (cursor.moveToFirst()) {
            long id = cursor.getLong(0);
            String name = cursor.getString(1);
            String channelListStr = cursor.getString(2);
            zone = new Zone(id, name, channelListStr);
        }
        cursor.close();
        return zone;
    }
    
    /**
     * Get a zone by name
     * @return Zone object or null if not found
     */
    public Zone getZoneByName(String zoneName) {
        SQLiteDatabase db = getReadableDatabase();
        Cursor cursor = db.query(
                TABLE_ZONES,
                new String[]{COLUMN_ID, COLUMN_NAME, COLUMN_CHANNEL_LIST},
                COLUMN_NAME + " = ?",
                new String[]{zoneName},
                null, null, null
        );
        
        Zone zone = null;
        if (cursor.moveToFirst()) {
            long id = cursor.getLong(0);
            String name = cursor.getString(1);
            String channelListStr = cursor.getString(2);
            zone = new Zone(id, name, channelListStr);
        }
        cursor.close();
        return zone;
    }
    
    /**
     * Get all zones
     * @return List of all zones (empty list if none exist)
     */
    public List<Zone> getAllZones() {
        List<Zone> zones = new ArrayList<>();
        SQLiteDatabase db = getReadableDatabase();
        Cursor cursor = db.query(
                TABLE_ZONES,
                new String[]{COLUMN_ID, COLUMN_NAME, COLUMN_CHANNEL_LIST},
                null, null, null, null,
                COLUMN_NAME + " ASC"  // Sort alphabetically by name
        );
        
        while (cursor.moveToNext()) {
            long id = cursor.getLong(0);
            String name = cursor.getString(1);
            String channelListStr = cursor.getString(2);
            zones.add(new Zone(id, name, channelListStr));
        }
        cursor.close();
        return zones;
    }
    
    /**
     * Get channels in a specific zone
     * @param zoneId Zone ID
     * @return List of channel numbers (empty list if zone not found)
     */
    public List<Integer> getChannelsInZone(long zoneId) {
        Zone zone = getZone(zoneId);
        return zone != null ? zone.getChannelList() : new ArrayList<Integer>();
    }
    
    /**
     * Delete a zone
     * @param zoneId Zone ID to delete
     */
    public void deleteZone(long zoneId) {
        SQLiteDatabase db = getWritableDatabase();
        db.delete(TABLE_ZONES, 
                COLUMN_ID + " = ?",
                new String[]{String.valueOf(zoneId)});
    }
    
    /**
     * Delete all zones
     */
    public void clearAllZones() {
        SQLiteDatabase db = getWritableDatabase();
        db.delete(TABLE_ZONES, null, null);
    }
    
    /**
     * Get zone count
     * @return Number of zones in database
     */
    public int getZoneCount() {
        SQLiteDatabase db = getReadableDatabase();
        Cursor cursor = db.rawQuery("SELECT COUNT(*) FROM " + TABLE_ZONES, null);
        int count = 0;
        if (cursor.moveToFirst()) {
            count = cursor.getInt(0);
        }
        cursor.close();
        return count;
    }
    
    /**
     * Check if a zone name exists
     * @param zoneName Zone name to check
     * @return true if zone exists
     */
    public boolean zoneExists(String zoneName) {
        return getZoneByName(zoneName) != null;
    }
    
    /**
     * Data class for Zone
     * Contains zone ID, name, and list of channel numbers
     */
    public static class Zone {
        public final long id;
        public final String name;
        private final List<Integer> channelList;
        
        /**
         * Create new zone (for insert)
         */
        public Zone(String name, List<Integer> channelList) {
            this(0, name, channelList);
        }
        
        /**
         * Create zone with existing ID (from database)
         */
        public Zone(long id, String name, List<Integer> channelList) {
            this.id = id;
            this.name = name;
            this.channelList = new ArrayList<>(channelList);
        }
        
        /**
         * Create zone from database string (comma-separated channel numbers)
         */
        public Zone(long id, String name, String channelListStr) {
            this.id = id;
            this.name = name;
            this.channelList = parseChannelList(channelListStr);
        }
        
        /**
         * Get channel list
         */
        public List<Integer> getChannelList() {
            return new ArrayList<>(channelList);
        }
        
        /**
         * Get channel count in this zone
         */
        public int getChannelCount() {
            return channelList.size();
        }
        
        /**
         * Check if zone contains a channel
         */
        public boolean containsChannel(int channelNumber) {
            return channelList.contains(channelNumber);
        }
        
        /**
         * Get channel list as comma-separated string for database storage
         */
        public String getChannelListString() {
            StringBuilder sb = new StringBuilder();
            for (int i = 0; i < channelList.size(); i++) {
                if (i > 0) sb.append(",");
                sb.append(channelList.get(i));
            }
            return sb.toString();
        }
        
        /**
         * Parse comma-separated channel list string
         */
        private static List<Integer> parseChannelList(String channelListStr) {
            List<Integer> channels = new ArrayList<>();
            if (channelListStr == null || channelListStr.isEmpty()) {
                return channels;
            }
            
            String[] parts = channelListStr.split(",");
            for (String part : parts) {
                try {
                    int channelNum = Integer.parseInt(part.trim());
                    if (channelNum > 0) {
                        channels.add(channelNum);
                    }
                } catch (NumberFormatException e) {
                    // Skip invalid entries
                }
            }
            return channels;
        }
        
        @Override
        public String toString() {
            return name + " (" + channelList.size() + " channels)";
        }
    }
}
