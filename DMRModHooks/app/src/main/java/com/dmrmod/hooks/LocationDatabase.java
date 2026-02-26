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
    private static final int DATABASE_VERSION = 2;
    
    // Table and column names
    private static final String TABLE_LOCATIONS = "channel_locations";
    private static final String COLUMN_CHANNEL_NUMBER = "channel_number";
    private static final String COLUMN_LATITUDE = "latitude";
    private static final String COLUMN_LONGITUDE = "longitude";
    private static final String COLUMN_ELEVATION = "elevation";
    
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
                COLUMN_LONGITUDE + " REAL, " +
                COLUMN_ELEVATION + " REAL DEFAULT 0)";
        db.execSQL(createTable);
    }
    
    @Override
    public void onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion) {
        if (oldVersion < 2) {
            // Add elevation column to existing table
            db.execSQL("ALTER TABLE " + TABLE_LOCATIONS + " ADD COLUMN " + 
                    COLUMN_ELEVATION + " REAL DEFAULT 0");
        }
    }
    
    /**
     * Save or update location for a channel (without elevation)
     */
    public void saveLocation(int channelNumber, double latitude, double longitude) {
        saveLocation(channelNumber, latitude, longitude, 0.0);
    }
    
    /**
     * Save or update location for a channel (with elevation)
     */
    public void saveLocation(int channelNumber, double latitude, double longitude, double elevation) {
        SQLiteDatabase db = getWritableDatabase();
        ContentValues values = new ContentValues();
        values.put(COLUMN_CHANNEL_NUMBER, channelNumber);
        values.put(COLUMN_LATITUDE, latitude);
        values.put(COLUMN_LONGITUDE, longitude);
        values.put(COLUMN_ELEVATION, elevation);
        
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
                new String[]{COLUMN_LATITUDE, COLUMN_LONGITUDE, COLUMN_ELEVATION},
                COLUMN_CHANNEL_NUMBER + " = ?",
                new String[]{String.valueOf(channelNumber)},
                null, null, null
        );
        
        Location location = null;
        if (cursor.moveToFirst()) {
            double latitude = cursor.getDouble(0);
            double longitude = cursor.getDouble(1);
            double elevation = cursor.getDouble(2);
            location = new Location(latitude, longitude, elevation);
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
        public final double elevation;
        
        public Location(double latitude, double longitude) {
            this(latitude, longitude, 0.0);
        }
        
        public Location(double latitude, double longitude, double elevation) {
            this.latitude = latitude;
            this.longitude = longitude;
            this.elevation = elevation;
        }
    }
}
