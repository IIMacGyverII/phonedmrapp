package com.dmrmod.hooks;

import android.content.ContentValues;
import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;

/**
 * Separate database for storing channel location data (latitude/longitude).
 * This database is managed entirely by the DMRModHooks module and does not
 * interfere with the target app's database.
 */
public class LocationDatabase extends SQLiteOpenHelper {
    
    private static final String DATABASE_NAME = "dmrmod_locations.db";
    private static final int DATABASE_VERSION = 1;
    
    // Table and column names
    private static final String TABLE_LOCATIONS = "channel_locations";
    private static final String COLUMN_CHANNEL_NUMBER = "channel_number";
    private static final String COLUMN_LATITUDE = "latitude";
    private static final String COLUMN_LONGITUDE = "longitude";
    
    private static LocationDatabase instance;
    
    private LocationDatabase(Context context) {
        super(context, DATABASE_NAME, null, DATABASE_VERSION);
    }
    
    /**
     * Get singleton instance of LocationDatabase
     */
    public static synchronized LocationDatabase getInstance(Context context) {
        if (instance == null) {
            instance = new LocationDatabase(context.getApplicationContext());
        }
        return instance;
    }
    
    @Override
    public void onCreate(SQLiteDatabase db) {
        String createTable = "CREATE TABLE " + TABLE_LOCATIONS + " (" +
                COLUMN_CHANNEL_NUMBER + " INTEGER PRIMARY KEY, " +
                COLUMN_LATITUDE + " REAL, " +
                COLUMN_LONGITUDE + " REAL)";
        db.execSQL(createTable);
    }
    
    @Override
    public void onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion) {
        db.execSQL("DROP TABLE IF EXISTS " + TABLE_LOCATIONS);
        onCreate(db);
    }
    
    /**
     * Save or update location for a channel
     */
    public void saveLocation(int channelNumber, double latitude, double longitude) {
        SQLiteDatabase db = getWritableDatabase();
        ContentValues values = new ContentValues();
        values.put(COLUMN_CHANNEL_NUMBER, channelNumber);
        values.put(COLUMN_LATITUDE, latitude);
        values.put(COLUMN_LONGITUDE, longitude);
        
        db.insertWithOnConflict(TABLE_LOCATIONS, null, values, 
                SQLiteDatabase.CONFLICT_REPLACE);
    }
    
    /**
     * Get location for a channel
     * @return Location object or null if not found
     */
    public Location getLocation(int channelNumber) {
        SQLiteDatabase db = getReadableDatabase();
        Cursor cursor = db.query(
                TABLE_LOCATIONS,
                new String[]{COLUMN_LATITUDE, COLUMN_LONGITUDE},
                COLUMN_CHANNEL_NUMBER + " = ?",
                new String[]{String.valueOf(channelNumber)},
                null, null, null
        );
        
        Location location = null;
        if (cursor.moveToFirst()) {
            double latitude = cursor.getDouble(0);
            double longitude = cursor.getDouble(1);
            location = new Location(latitude, longitude);
        }
        cursor.close();
        return location;
    }
    
    /**
     * Delete location for a channel
     */
    public void deleteLocation(int channelNumber) {
        SQLiteDatabase db = getWritableDatabase();
        db.delete(TABLE_LOCATIONS, 
                COLUMN_CHANNEL_NUMBER + " = ?",
                new String[]{String.valueOf(channelNumber)});
    }
    
    /**
     * Delete all locations
     */
    public void clearAllLocations() {
        SQLiteDatabase db = getWritableDatabase();
        db.delete(TABLE_LOCATIONS, null, null);
    }
    
    /**
     * Simple data class for location
     */
    public static class Location {
        public final double latitude;
        public final double longitude;
        
        public Location(double latitude, double longitude) {
            this.latitude = latitude;
            this.longitude = longitude;
        }
    }
}
