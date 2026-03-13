package com.dmrmod.hooks;

import android.content.ContentValues;
import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;
import android.os.Environment;

import java.io.File;
import java.io.FileWriter;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Locale;

import de.robv.android.xposed.XposedBridge;

/**
 * Database for storing received APRS stations
 */
public class APRSReceivedDatabase extends SQLiteOpenHelper {
    private static final String TAG = "DMRModHooks-APRS-RxDB";
    
    private static final String DATABASE_NAME = "dmrmod_aprs_received.db";
    private static final int DATABASE_VERSION = 2;  // Changed to keep full history
    
    private static final String TABLE_STATIONS = "received_stations";
    
    // Columns
    private static final String COL_ID = "id";
    private static final String COL_CALLSIGN = "callsign";
    private static final String COL_SSID = "ssid";
    private static final String COL_LATITUDE = "latitude";
    private static final String COL_LONGITUDE = "longitude";
    private static final String COL_ALTITUDE = "altitude";
    private static final String COL_COMMENT = "comment";
    private static final String COL_SYMBOL_TABLE = "symbol_table";
    private static final String COL_SYMBOL_CODE = "symbol_code";
    private static final String COL_TIMESTAMP = "timestamp";
    private static final String COL_CHANNEL = "channel_number";
    
    private static APRSReceivedDatabase instance;
    
    private APRSReceivedDatabase(Context context) {
        super(context, DATABASE_NAME, null, DATABASE_VERSION);
    }
    
    public static synchronized APRSReceivedDatabase getInstance(Context context) {
        if (instance == null) {
            instance = new APRSReceivedDatabase(context.getApplicationContext());
        }
        return instance;
    }
    
    @Override
    public void onCreate(SQLiteDatabase db) {
        String createTable = "CREATE TABLE " + TABLE_STATIONS + " (" +
                COL_ID + " INTEGER PRIMARY KEY AUTOINCREMENT, " +
                COL_CALLSIGN + " TEXT NOT NULL, " +
                COL_SSID + " INTEGER NOT NULL, " +
                COL_LATITUDE + " REAL NOT NULL, " +
                COL_LONGITUDE + " REAL NOT NULL, " +
                COL_ALTITUDE + " INTEGER, " +
                COL_COMMENT + " TEXT, " +
                COL_SYMBOL_TABLE + " TEXT, " +
                COL_SYMBOL_CODE + " TEXT, " +
                COL_TIMESTAMP + " INTEGER NOT NULL, " +
                COL_CHANNEL + " INTEGER)";
        
        db.execSQL(createTable);
        XposedBridge.log(TAG + ": Database created with full history tracking");
    }
    
    @Override
    public void onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion) {
        db.execSQL("DROP TABLE IF EXISTS " + TABLE_STATIONS);
        onCreate(db);
    }
    
    /**
     * Station data class
     */
    public static class ReceivedStation {
        public String callsign;
        public int ssid;
        public double latitude;
        public double longitude;
        public int altitude;
        public String comment;
        public char symbolTable;
        public char symbolCode;
        public long timestamp;
        public int channelNumber;
        
        public String getFullCallsign() {
            return callsign + "-" + ssid;
        }
        
        public String getLocationString() {
            return String.format("%.6f, %.6f", latitude, longitude);
        }
        
        public String getMapUrl() {
            return "geo:" + latitude + "," + longitude + "?q=" + latitude + "," + longitude + 
                   "(" + callsign + "-" + ssid + ")";
        }
        
        public String getGpxFilePath() {
            return Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOWNLOADS) +
                   "/DMR/APRS/" + callsign + "-" + ssid + ".gpx";
        }
    }
    
    /**
     * Store received station
     */
    public void storeStation(APRSPacketDecoder.APRSPacket packet, int channelNumber) {
        if (!packet.isValid) {
            return;
        }
        
        SQLiteDatabase db = getWritableDatabase();
        
        ContentValues values = new ContentValues();
        values.put(COL_CALLSIGN, packet.sourceCallsign);
        values.put(COL_SSID, packet.sourceSSID);
        values.put(COL_LATITUDE, packet.latitude);
        values.put(COL_LONGITUDE, packet.longitude);
        values.put(COL_ALTITUDE, packet.altitude);
        values.put(COL_COMMENT, packet.comment);
        values.put(COL_SYMBOL_TABLE, String.valueOf(packet.symbolTable));
        values.put(COL_SYMBOL_CODE, String.valueOf(packet.symbolCode));
        values.put(COL_TIMESTAMP, System.currentTimeMillis());
        values.put(COL_CHANNEL, channelNumber);
        
        // Insert as new record (keep full history)
        long result = db.insert(TABLE_STATIONS, null, values);
        
        if (result != -1) {
            XposedBridge.log(TAG + ": Stored station " + packet.sourceCallsign + "-" + 
                    packet.sourceSSID + " @ " + packet.latitude + ", " + packet.longitude);
            
            // Auto-export to text and GPX files (callsign-specific)
            exportToTextFile(packet, channelNumber);
            exportSingleCallsignToGPX(packet.sourceCallsign, packet.sourceSSID);
        }
    }
    
    /**
     * Get all received stations
     */
    public List<ReceivedStation> getAllStations() {
        List<ReceivedStation> stations = new ArrayList<>();
        SQLiteDatabase db = getReadableDatabase();
        
        Cursor cursor = db.query(TABLE_STATIONS, null, null, null, null, null, 
                COL_TIMESTAMP + " DESC");
        
        try {
            while (cursor.moveToNext()) {
                ReceivedStation station = new ReceivedStation();
                station.callsign = cursor.getString(cursor.getColumnIndex(COL_CALLSIGN));
                station.ssid = cursor.getInt(cursor.getColumnIndex(COL_SSID));
                station.latitude = cursor.getDouble(cursor.getColumnIndex(COL_LATITUDE));
                station.longitude = cursor.getDouble(cursor.getColumnIndex(COL_LONGITUDE));
                station.altitude = cursor.getInt(cursor.getColumnIndex(COL_ALTITUDE));
                station.comment = cursor.getString(cursor.getColumnIndex(COL_COMMENT));
                
                String symbolTable = cursor.getString(cursor.getColumnIndex(COL_SYMBOL_TABLE));
                station.symbolTable = (symbolTable != null && symbolTable.length() > 0) ? 
                        symbolTable.charAt(0) : '/';
                
                String symbolCode = cursor.getString(cursor.getColumnIndex(COL_SYMBOL_CODE));
                station.symbolCode = (symbolCode != null && symbolCode.length() > 0) ? 
                        symbolCode.charAt(0) : '[';
                
                station.timestamp = cursor.getLong(cursor.getColumnIndex(COL_TIMESTAMP));
                station.channelNumber = cursor.getInt(cursor.getColumnIndex(COL_CHANNEL));
                
                stations.add(station);
            }
        } finally {
            cursor.close();
        }
        
        return stations;
    }
    
    /**
     * Get recent stations (within last hour)
     */
    public List<ReceivedStation> getRecentStations() {
        List<ReceivedStation> stations = new ArrayList<>();
        SQLiteDatabase db = getReadableDatabase();
        
        long oneHourAgo = System.currentTimeMillis() - (60 * 60 * 1000);
        
        Cursor cursor = db.query(TABLE_STATIONS, null, 
                COL_TIMESTAMP + " > ?", 
                new String[]{String.valueOf(oneHourAgo)}, 
                null, null, COL_TIMESTAMP + " DESC");
        
        try {
            while (cursor.moveToNext()) {
                ReceivedStation station = new ReceivedStation();
                station.callsign = cursor.getString(cursor.getColumnIndex(COL_CALLSIGN));
                station.ssid = cursor.getInt(cursor.getColumnIndex(COL_SSID));
                station.latitude = cursor.getDouble(cursor.getColumnIndex(COL_LATITUDE));
                station.longitude = cursor.getDouble(cursor.getColumnIndex(COL_LONGITUDE));
                station.altitude = cursor.getInt(cursor.getColumnIndex(COL_ALTITUDE));
                station.comment = cursor.getString(cursor.getColumnIndex(COL_COMMENT));
                
                String symbolTable = cursor.getString(cursor.getColumnIndex(COL_SYMBOL_TABLE));
                station.symbolTable = (symbolTable != null && symbolTable.length() > 0) ? 
                        symbolTable.charAt(0) : '/';
                
                String symbolCode = cursor.getString(cursor.getColumnIndex(COL_SYMBOL_CODE));
                station.symbolCode = (symbolCode != null && symbolCode.length() > 0) ? 
                        symbolCode.charAt(0) : '[';
                
                station.timestamp = cursor.getLong(cursor.getColumnIndex(COL_TIMESTAMP));
                station.channelNumber = cursor.getInt(cursor.getColumnIndex(COL_CHANNEL));
                
                stations.add(station);
            }
        } finally {
            cursor.close();
        }
        
        return stations;
    }
    
    /**
     * Clear all received stations
     */
    public void clearAll() {
        SQLiteDatabase db = getWritableDatabase();
        db.delete(TABLE_STATIONS, null, null);
        XposedBridge.log(TAG + ": All stations cleared");
    }
    
    /**
     * Get station count
     */
    public int getStationCount() {
        SQLiteDatabase db = getReadableDatabase();
        Cursor cursor = db.rawQuery("SELECT COUNT(*) FROM " + TABLE_STATIONS, null);
        
        try {
            if (cursor.moveToFirst()) {
                return cursor.getInt(0);
            }
        } finally {
            cursor.close();
        }
        
        return 0;
    }
    
    /**
     * Append single packet to callsign-specific text log file (running log mode)
     * Automatically called after each new station is received
     */
    public boolean exportToTextFile(APRSPacketDecoder.APRSPacket packet, int channelNumber) {
        try {
            // Get Downloads/DMR/APRS directory
            File downloadDir = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOWNLOADS);
            File dmrDir = new File(downloadDir, "DMR");
            File aprsDir = new File(dmrDir, "APRS");
            
            // Create directories if they don't exist
            if (!aprsDir.exists()) {
                aprsDir.mkdirs();
            }
            
            // Create callsign-specific filename
            String callsignFile = packet.sourceCallsign + "-" + packet.sourceSSID + ".txt";
            File outputFile = new File(aprsDir, callsignFile);
            boolean isNewFile = !outputFile.exists();
            
            // Open in append mode
            PrintWriter writer = new PrintWriter(new FileWriter(outputFile, true));
            SimpleDateFormat timeFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.US);
            
            // If new file, write header
            if (isNewFile) {
                writer.println("===============================================");
                writer.println("APRS LOG: " + packet.sourceCallsign + "-" + packet.sourceSSID);
                writer.println("===============================================");
                writer.println("Started: " + timeFormat.format(new Date()));
                writer.println("===============================================");
                writer.println();
            }
            
            // Append this packet
            writer.println("─────────────────────────────────────────────");
            writer.println("Callsign: " + packet.sourceCallsign + "-" + packet.sourceSSID);
            writer.println("Time: " + timeFormat.format(new Date()));
            writer.println("Position: " + String.format("%.6f, %.6f", packet.latitude, packet.longitude));
            writer.println("Altitude: " + packet.altitude + " m");
            writer.println("Symbol: " + packet.symbolTable + packet.symbolCode);
            if (packet.comment != null && !packet.comment.isEmpty()) {
                writer.println("Comment: " + packet.comment);
            }
            writer.println("Channel: " + channelNumber);
            writer.println();
            
            writer.close();
            
            XposedBridge.log(TAG + ": Appended station " + packet.sourceCallsign + "-" + packet.sourceSSID + " to log");
            return true;
            
        } catch (Exception e) {
            XposedBridge.log(TAG + ": Error appending to text file: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Export single callsign's track to GPX format
     */
    public boolean exportSingleCallsignToGPX(String callsign, int ssid) {
        try {
            // Get Downloads/DMR/APRS directory
            File downloadDir = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOWNLOADS);
            File dmrDir = new File(downloadDir, "DMR");
            File aprsDir = new File(dmrDir, "APRS");
            
            if (!aprsDir.exists()) {
                aprsDir.mkdirs();
            }
            
            String gpxFilename = callsign + "-" + ssid + ".gpx";
            File outputFile = new File(aprsDir, gpxFilename);
            
            // Query this callsign's positions
            SQLiteDatabase db = getReadableDatabase();
            Cursor cursor = db.query(TABLE_STATIONS, null,
                    COL_CALLSIGN + " = ? AND " + COL_SSID + " = ?",
                    new String[]{callsign, String.valueOf(ssid)},
                    null, null, COL_TIMESTAMP + " ASC");
            
            if (cursor.getCount() == 0) {
                cursor.close();
                return false;
            }
            
            PrintWriter writer = new PrintWriter(new FileWriter(outputFile, false));
            SimpleDateFormat gpxTimeFormat = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'", Locale.US);
            
            // GPX header
            writer.println("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
            writer.println("<gpx version=\"1.1\" creator=\"DMR APRS Receiver\"");
            writer.println("     xmlns=\"http://www.topografix.com/GPX/1/1\"");
            writer.println("     xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"");
            writer.println("     xsi:schemaLocation=\"http://www.topografix.com/GPX/1/1 http://www.topografix.com/GPX/1/1/gpx.xsd\">");
            writer.println("  <metadata>");
            writer.println("    <name>" + callsign + "-" + ssid + "</name>");
            writer.println("    <desc>APRS track for " + callsign + "-" + ssid + "</desc>");
            writer.println("    <time>" + gpxTimeFormat.format(new Date()) + "</time>");
            writer.println("  </metadata>");
            
            // Track
            writer.println("  <trk>");
            writer.println("    <name>" + callsign + "-" + ssid + "</name>");
            writer.println("    <trkseg>");
            
            while (cursor.moveToNext()) {
                double lat = cursor.getDouble(cursor.getColumnIndex(COL_LATITUDE));
                double lon = cursor.getDouble(cursor.getColumnIndex(COL_LONGITUDE));
                int alt = cursor.getInt(cursor.getColumnIndex(COL_ALTITUDE));
                long timestamp = cursor.getLong(cursor.getColumnIndex(COL_TIMESTAMP));
                String comment = cursor.getString(cursor.getColumnIndex(COL_COMMENT));
                
                writer.println("      <trkpt lat=\"" + lat + "\" lon=\"" + lon + "\">");
                writer.println("        <ele>" + alt + "</ele>");
                writer.println("        <time>" + gpxTimeFormat.format(new Date(timestamp)) + "</time>");
                if (comment != null && !comment.isEmpty()) {
                    writer.println("        <desc>" + escapeXml(comment) + "</desc>");
                }
                writer.println("      </trkpt>");
            }
            
            writer.println("    </trkseg>");
            writer.println("  </trk>");
            writer.println("</gpx>");
            
            cursor.close();
            writer.close();
            
            XposedBridge.log(TAG + ": Exported track for " + callsign + "-" + ssid + " to " + outputFile.getAbsolutePath());
            return true;
            
        } catch (Exception e) {
            XposedBridge.log(TAG + ": Error exporting GPX for single callsign: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Export all stations to GPX format for track visualization in maps apps
     */
    public boolean exportToGPX() {
        try {
            // Get Downloads/DMR/APRS directory
            File downloadDir = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOWNLOADS);
            File dmrDir = new File(downloadDir, "DMR");
            File aprsDir = new File(dmrDir, "APRS");
            
            // Create directories if they don't exist
            if (!aprsDir.exists()) {
                aprsDir.mkdirs();
            }
            
            File outputFile = new File(aprsDir, "aprs_tracks.gpx");
            
            // Get all stations ordered by callsign and timestamp
            SQLiteDatabase db = getReadableDatabase();
            Cursor cursor = db.query(TABLE_STATIONS, null, null, null, null, null,
                    COL_CALLSIGN + " ASC, " + COL_SSID + " ASC, " + COL_TIMESTAMP + " ASC");
            
            // Write GPX file
            PrintWriter writer = new PrintWriter(new FileWriter(outputFile, false));
            SimpleDateFormat gpxTimeFormat = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'", Locale.US);
            
            // GPX header
            writer.println("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
            writer.println("<gpx version=\"1.1\" creator=\"DMR APRS Receiver\"");
            writer.println("     xmlns=\"http://www.topografix.com/GPX/1/1\"");
            writer.println("     xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"");
            writer.println("     xsi:schemaLocation=\"http://www.topografix.com/GPX/1/1 http://www.topografix.com/GPX/1/1/gpx.xsd\">");
            writer.println("  <metadata>");
            writer.println("    <name>APRS Received Stations</name>");
            writer.println("    <desc>APRS packets received via DMR radio</desc>");
            writer.println("    <time>" + gpxTimeFormat.format(new Date()) + "</time>");
            writer.println("  </metadata>");
            
            // Group stations by callsign
            String currentCallsign = null;
            int currentSSID = -1;
            boolean inTrack = false;
            int trackCount = 0;
            
            while (cursor.moveToNext()) {
                String callsign = cursor.getString(cursor.getColumnIndex(COL_CALLSIGN));
                int ssid = cursor.getInt(cursor.getColumnIndex(COL_SSID));
                double lat = cursor.getDouble(cursor.getColumnIndex(COL_LATITUDE));
                double lon = cursor.getDouble(cursor.getColumnIndex(COL_LONGITUDE));
                int alt = cursor.getInt(cursor.getColumnIndex(COL_ALTITUDE));
                long timestamp = cursor.getLong(cursor.getColumnIndex(COL_TIMESTAMP));
                String comment = cursor.getString(cursor.getColumnIndex(COL_COMMENT));
                
                // Check if new station
                if (!callsign.equals(currentCallsign) || ssid != currentSSID) {
                    // Close previous track if open
                    if (inTrack) {
                        writer.println("      </trkseg>");
                        writer.println("    </trk>");
                    }
                    
                    // Start new track
                    currentCallsign = callsign;
                    currentSSID = ssid;
                    String fullCall = callsign + "-" + ssid;
                    trackCount++;
                    
                    writer.println("  <trk>");
                    writer.println("    <name>" + fullCall + "</name>");
                    if (comment != null && !comment.isEmpty()) {
                        writer.println("    <desc>" + escapeXml(comment) + "</desc>");
                    }
                    writer.println("    <trkseg>");
                    inTrack = true;
                }
                
                // Add track point
                writer.println("      <trkpt lat=\"" + lat + "\" lon=\"" + lon + "\">");
                writer.println("        <ele>" + alt + "</ele>");
                writer.println("        <time>" + gpxTimeFormat.format(new Date(timestamp)) + "</time>");
                if (comment != null && !comment.isEmpty()) {
                    writer.println("        <desc>" + escapeXml(comment) + "</desc>");
                }
                writer.println("      </trkpt>");
            }
            
            // Close last track if open
            if (inTrack) {
                writer.println("      </trkseg>");
                writer.println("    </trk>");
            }
            
            cursor.close();
            
            // GPX footer
            writer.println("</gpx>");
            writer.close();
            
            XposedBridge.log(TAG + ": Exported " + trackCount + " station tracks to " + outputFile.getAbsolutePath());
            return true;
            
        } catch (Exception e) {
            XposedBridge.log(TAG + ": Error exporting to GPX: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Escape XML special characters
     */
    private String escapeXml(String str) {
        if (str == null) return "";
        return str.replace("&", "&amp;")
                  .replace("<", "&lt;")
                  .replace(">", "&gt;")
                  .replace("\"", "&quot;")
                  .replace("'", "&apos;");
    }
}
