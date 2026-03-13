package com.dmrmod.hooks;

import android.content.ContentValues;
import android.content.Context;
import android.content.SharedPreferences;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;

/**
 * Database for storing APRS settings (per-channel and global).
 * Manages callsign, beacon intervals, symbols, and enable/disable state.
 */
public class APRSDatabase extends SQLiteOpenHelper {
    
    private static final String DATABASE_NAME = "dmrmod_aprs.db";
    private static final int DATABASE_VERSION = 1;
    
    // Table for per-channel APRS settings
    private static final String TABLE_CHANNEL_APRS = "channel_aprs";
    private static final String COLUMN_CHANNEL_NUMBER = "channel_number";
    private static final String COLUMN_ENABLED = "enabled";
    private static final String COLUMN_COMMENT = "comment";
    private static final String COLUMN_SYMBOL_TABLE = "symbol_table";  // '/' or '\\'
    private static final String COLUMN_SYMBOL_CODE = "symbol_code";    // Single character
    
    // SharedPreferences for global APRS settings
    private static final String PREFS_NAME = "dmrmod_aprs_global";
    private static final String PREF_CALLSIGN = "callsign";
    private static final String PREF_SSID = "ssid";
    private static final String PREF_DEFAULT_SYMBOL_TABLE = "default_symbol_table";
    private static final String PREF_DEFAULT_SYMBOL_CODE = "default_symbol_code";
    private static final String PREF_APRS_FREQUENCY = "aprs_frequency";
    private static final String PREF_APRS_SQUELCH = "aprs_squelch";
    
    // Default values
    public static final String DEFAULT_CALLSIGN = "N0CALL";
    public static final int DEFAULT_SSID = 7;  // 7 is common for handhelds
    public static final char DEFAULT_SYMBOL_TABLE = '/';
    public static final char DEFAULT_SYMBOL_CODE = '[';  // Jogger/hiker symbol
    public static final String DEFAULT_APRS_FREQUENCY = "144.390";  // MHz (North America standard)
    public static final int DEFAULT_APRS_SQUELCH = 1;  // Squelch level 1
    
    private static APRSDatabase instance;
    private final Context context;
    
    private APRSDatabase(Context context) {
        super(context, DATABASE_NAME, null, DATABASE_VERSION);
        this.context = context.getApplicationContext();
    }
    
    /**
     * Get singleton instance of APRSDatabase
     */
    public static synchronized APRSDatabase getInstance(Context context) {
        if (instance == null) {
            instance = new APRSDatabase(context.getApplicationContext());
        }
        return instance;
    }
    
    @Override
    public void onCreate(SQLiteDatabase db) {
        String createTable = "CREATE TABLE " + TABLE_CHANNEL_APRS + " (" +
                COLUMN_CHANNEL_NUMBER + " INTEGER PRIMARY KEY, " +
                COLUMN_ENABLED + " INTEGER DEFAULT 0, " +  // 0 = disabled, 1 = enabled
                COLUMN_COMMENT + " TEXT, " +
                COLUMN_SYMBOL_TABLE + " TEXT DEFAULT '/', " +
                COLUMN_SYMBOL_CODE + " TEXT DEFAULT '[')";
        db.execSQL(createTable);
    }
    
    @Override
    public void onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion) {
        // No upgrades yet
    }
    
    // ==================== Global Settings ====================
    
    /**
     * Get global callsign
     */
    public String getCallsign() {
        SharedPreferences prefs = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE);
        return prefs.getString(PREF_CALLSIGN, DEFAULT_CALLSIGN);
    }
    
    /**
     * Set global callsign
     */
    public void setCallsign(String callsign) {
        SharedPreferences prefs = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE);
        prefs.edit().putString(PREF_CALLSIGN, callsign.toUpperCase()).apply();
    }
    
    /**
     * Get global SSID (0-15)
     */
    public int getSSID() {
        SharedPreferences prefs = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE);
        return prefs.getInt(PREF_SSID, DEFAULT_SSID);
    }
    
    /**
     * Set global SSID (0-15)
     */
    public void setSSID(int ssid) {
        if (ssid < 0 || ssid > 15) {
            throw new IllegalArgumentException("SSID must be between 0 and 15");
        }
        SharedPreferences prefs = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE);
        prefs.edit().putInt(PREF_SSID, ssid).apply();
    }
    
    /**
     * Get default symbol table
     */
    public char getDefaultSymbolTable() {
        SharedPreferences prefs = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE);
        String value = prefs.getString(PREF_DEFAULT_SYMBOL_TABLE, String.valueOf(DEFAULT_SYMBOL_TABLE));
        return value.charAt(0);
    }
    
    /**
     * Set default symbol table
     */
    public void setDefaultSymbolTable(char table) {
        SharedPreferences prefs = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE);
        prefs.edit().putString(PREF_DEFAULT_SYMBOL_TABLE, String.valueOf(table)).apply();
    }
    
    /**
     * Get APRS frequency in MHz
     */
    public String getAprsFrequency() {
        SharedPreferences prefs = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE);
        return prefs.getString(PREF_APRS_FREQUENCY, DEFAULT_APRS_FREQUENCY);
    }
    
    /**
     * Set APRS frequency in MHz (e.g., "144.390")
     */
    public void setAprsFrequency(String frequency) {
        SharedPreferences prefs = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE);
        prefs.edit().putString(PREF_APRS_FREQUENCY, frequency).apply();
    }
    
    /**
     * Get APRS squelch level (0-9)
     */
    public int getAprsSquelch() {
        SharedPreferences prefs = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE);
        return prefs.getInt(PREF_APRS_SQUELCH, DEFAULT_APRS_SQUELCH);
    }
    
    /**
     * Set APRS squelch level (0-9)
     */
    public void setAprsSquelch(int squelch) {
        if (squelch < 0 || squelch > 9) {
            throw new IllegalArgumentException("Squelch must be between 0 and 9");
        }
        SharedPreferences prefs = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE);
        prefs.edit().putInt(PREF_APRS_SQUELCH, squelch).apply();
    }
    
    /**
     * Get default symbol code
     */
    public char getDefaultSymbolCode() {
        SharedPreferences prefs = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE);
        String value = prefs.getString(PREF_DEFAULT_SYMBOL_CODE, String.valueOf(DEFAULT_SYMBOL_CODE));
        return value.charAt(0);
    }
    
    /**
     * Set default symbol code
     */
    public void setDefaultSymbolCode(char code) {
        SharedPreferences prefs = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE);
        prefs.edit().putString(PREF_DEFAULT_SYMBOL_CODE, String.valueOf(code)).apply();
    }
    
    // ==================== Per-Channel Settings ====================
    
    /**
     * Check if APRS is enabled for a channel
     */
    public boolean isEnabled(int channelNumber) {
        APRSSettings settings = getChannelSettings(channelNumber);
        return settings != null && settings.enabled;
    }
    
    /**
     * Enable or disable APRS for a channel
     */
    public void setEnabled(int channelNumber, boolean enabled) {
        SQLiteDatabase db = getWritableDatabase();
        ContentValues values = new ContentValues();
        values.put(COLUMN_CHANNEL_NUMBER, channelNumber);
        values.put(COLUMN_ENABLED, enabled ? 1 : 0);
        
        db.insertWithOnConflict(TABLE_CHANNEL_APRS, null, values, 
                SQLiteDatabase.CONFLICT_IGNORE);
        
        values.clear();
        values.put(COLUMN_ENABLED, enabled ? 1 : 0);
        db.update(TABLE_CHANNEL_APRS, values, 
                COLUMN_CHANNEL_NUMBER + " = ?",
                new String[]{String.valueOf(channelNumber)});
    }
    
    /**
     * Get complete APRS settings for a channel
     */
    public APRSSettings getChannelSettings(int channelNumber) {
        SQLiteDatabase db = getReadableDatabase();
        Cursor cursor = db.query(
                TABLE_CHANNEL_APRS,
                null,  // All columns
                COLUMN_CHANNEL_NUMBER + " = ?",
                new String[]{String.valueOf(channelNumber)},
                null, null, null
        );
        
        APRSSettings settings = null;
        if (cursor.moveToFirst()) {
            settings = new APRSSettings();
            settings.channelNumber = channelNumber;
            settings.enabled = cursor.getInt(cursor.getColumnIndexOrThrow(COLUMN_ENABLED)) == 1;
            settings.comment = cursor.getString(cursor.getColumnIndexOrThrow(COLUMN_COMMENT));
            
            String symbolTable = cursor.getString(cursor.getColumnIndexOrThrow(COLUMN_SYMBOL_TABLE));
            settings.symbolTable = (symbolTable != null && !symbolTable.isEmpty()) ? 
                    symbolTable.charAt(0) : getDefaultSymbolTable();
            
            String symbolCode = cursor.getString(cursor.getColumnIndexOrThrow(COLUMN_SYMBOL_CODE));
            settings.symbolCode = (symbolCode != null && !symbolCode.isEmpty()) ? 
                    symbolCode.charAt(0) : getDefaultSymbolCode();
        }
        cursor.close();
        
        // Return defaults if no settings found
        if (settings == null) {
            settings = new APRSSettings();
            settings.channelNumber = channelNumber;
            settings.enabled = false;
            settings.comment = "";
            settings.symbolTable = getDefaultSymbolTable();
            settings.symbolCode = getDefaultSymbolCode();
        }
        
        return settings;
    }
    
    /**
     * Save complete APRS settings for a channel
     */
    public void saveChannelSettings(APRSSettings settings) {
        SQLiteDatabase db = getWritableDatabase();
        ContentValues values = new ContentValues();
        values.put(COLUMN_CHANNEL_NUMBER, settings.channelNumber);
        values.put(COLUMN_ENABLED, settings.enabled ? 1 : 0);
        values.put(COLUMN_COMMENT, settings.comment);
        values.put(COLUMN_SYMBOL_TABLE, String.valueOf(settings.symbolTable));
        values.put(COLUMN_SYMBOL_CODE, String.valueOf(settings.symbolCode));
        
        db.insertWithOnConflict(TABLE_CHANNEL_APRS, null, values, 
                SQLiteDatabase.CONFLICT_REPLACE);
    }
    
    /**
     * Delete APRS settings for a channel
     */
    public void deleteChannelSettings(int channelNumber) {
        SQLiteDatabase db = getWritableDatabase();
        db.delete(TABLE_CHANNEL_APRS, 
                COLUMN_CHANNEL_NUMBER + " = ?",
                new String[]{String.valueOf(channelNumber)});
    }
    
    /**
     * Clear all channel APRS settings
     */
    public void clearAllSettings() {
        SQLiteDatabase db = getWritableDatabase();
        db.delete(TABLE_CHANNEL_APRS, null, null);
    }
    
    /**
     * Data class for channel APRS settings
     */
    public static class APRSSettings {
        public int channelNumber;
        public boolean enabled;
        public String comment;
        public char symbolTable;
        public char symbolCode;
        
        public APRSSettings() {
            this.enabled = false;
            this.comment = "";
            this.symbolTable = DEFAULT_SYMBOL_TABLE;
            this.symbolCode = DEFAULT_SYMBOL_CODE;
        }
    }
}
