package com.dmrmod.hooks;

import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.util.Log;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.util.HashMap;
import java.util.Locale;
import java.util.Map;

/**
 * CSVExporter - Export DMR data to OpenGD77 compatible CSV format
 */
public class CSVExporter {
    
    private static final String TAG = "DMRModHooks_CSVExporter";
    
    // OpenGD77 CSV Headers (EXACT format required)
    private static final String CHANNELS_HEADER = 
        "Channel Number,Channel Name,Channel Type,Rx Frequency,Tx Frequency," +
        "Bandwidth kHz,Colour Code,Timeslot,Contact,TG List,DMR ID," +
        "TS1_TA_Tx,TS2_TA_Tx,RX Tone,TX Tone,Squelch,Power,Rx Only," +
        "Zone Skip,All Skip,TOT,VOX,Ch Scan List,Rx Group List,TX";
    
    private static final String CONTACTS_HEADER = 
        "Contact Name,ID,ID Type,TS Override";
    
    /**
     * Copy database from target app's private directory to our cache using su
     * Two-step process: root copy to /sdcard, then regular copy to cache
     */
    private static File copyDatabaseToCache(Context context, String targetPackage, String dbName) {
        File tempFile = null;
        try {
            String sourcePath = "/data/data/" + targetPackage + "/databases/" + dbName;
            File cacheDir = context.getCacheDir();
            File destFile = new File(cacheDir, dbName);
            
            // Delete old copy if exists
            if (destFile.exists()) {
                destFile.delete();
            }
            
            // Step 1: Copy from app's database directory to /sdcard using root
            tempFile = new File("/sdcard/dmrmod_temp_" + dbName);
            if (tempFile.exists()) {
                tempFile.delete();
            }
            
            Log.i(TAG, "Step 1: Copying with root: " + sourcePath + " -> " + tempFile.getAbsolutePath());
            
            // Use sh -c to ensure proper shell interpretation
            String[] cmd = {
                "/system_ext/bin/su",
                "-c",
                "sh -c 'cat \"" + sourcePath + "\" > \"" + tempFile.getAbsolutePath() + "\" && chmod 666 \"" + tempFile.getAbsolutePath() + "\"'"
            };
            Process process = Runtime.getRuntime().exec(cmd);
            
            // Read error stream
            java.io.BufferedReader errorReader = new java.io.BufferedReader(
                new java.io.InputStreamReader(process.getErrorStream()));
            String errorLine;
            StringBuilder errorOutput = new StringBuilder();
            while ((errorLine = errorReader.readLine()) != null) {
                errorOutput.append(errorLine).append("\n");
            }
            
            int exitCode = process.waitFor();
            if (exitCode != 0) {
                Log.e(TAG, "Root copy failed, exit code: " + exitCode);
                if (errorOutput.length() > 0) {
                    Log.e(TAG, "Error output: " + errorOutput.toString());
                }
                return null;
            }
            
            if (!tempFile.exists() || tempFile.length() == 0) {
                Log.e(TAG, "Root copy failed or empty");
                return null;
            }
            
            Log.i(TAG, "Step 2: Copying to cache: " + tempFile.getAbsolutePath() + " -> " + destFile.getAbsolutePath());
            
            // Step 2: Copy from /sdcard to cache using regular file I/O
            java.io.FileInputStream fis = new java.io.FileInputStream(tempFile);
            java.io.FileOutputStream fos = new java.io.FileOutputStream(destFile);
            byte[] buffer = new byte[8192];
            int bytesRead;
            while ((bytesRead = fis.read(buffer)) != -1) {
                fos.write(buffer, 0, bytesRead);
            }
            fis.close();
            fos.close();
            
            // Clean up temp file
            tempFile.delete();
            
            Log.i(TAG, "Database copied successfully: " + destFile.getAbsolutePath() + " (" + destFile.length() + " bytes)");
            return destFile;
            
        } catch (Exception e) {
            Log.e(TAG, "Error copying database: " + e.getMessage());
            e.printStackTrace();
            if (tempFile != null && tempFile.exists()) {
                tempFile.delete();
            }
            return null;
        }
    }
    
    /**
     * Export channels to OpenGD77 Channels.csv format
     */
    public static boolean exportChannels(Context context, String targetPackage, File outputFile) {
        BufferedWriter writer = null;
        SQLiteDatabase db = null;
        Cursor cursor = null;
        File dbCopy = null;
        
        try {
            // Build contact name mapping first
            Map<Integer, String> contactMap = buildContactMap(context, targetPackage);
            
            // Copy database to our cache using su
            dbCopy = copyDatabaseToCache(context, targetPackage, "database_channel_area_default_uhf.db");
            if (dbCopy == null) {
                Log.e(TAG, "Failed to copy channel database");
                return false;
            }
            
            // Open the copied database
            try {
                db = SQLiteDatabase.openDatabase(dbCopy.getAbsolutePath(), null, SQLiteDatabase.OPEN_READONLY);
            } catch (Exception e) {
                Log.e(TAG, "Channel database cannot be opened: " + e.getMessage());
                return false;
            }
            
            // Query all channels
            cursor = db.query("database_channel_area_default_uhf", null, null, null, null, null, "channel_number ASC");
            
            if (cursor == null) {
                Log.e(TAG, "Channel cursor is null");
                return false;
            }
            
            Log.i(TAG, "Exporting " + cursor.getCount() + " channels");
            
            // Create output file
            writer = new BufferedWriter(new FileWriter(outputFile));
            
            // Write header
            writer.write(CHANNELS_HEADER);
            writer.newLine();
            
            // Process each channel
            int channelCount = 0;
            while (cursor.moveToNext()) {
                try {
                    String csvRow = buildChannelRow(cursor, contactMap);
                    writer.write(csvRow);
                    writer.newLine();
                    channelCount++;
                } catch (Exception e) {
                    Log.e(TAG, "Error processing channel row: " + e.getMessage());
                    e.printStackTrace();
                }
            }
            
            Log.i(TAG, "Exported " + channelCount + " channels successfully");
            return true;
            
        } catch (Exception e) {
            Log.e(TAG, "Error exporting channels: " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            try {
                if (cursor != null) cursor.close();
                if (db != null) db.close();
                if (writer != null) writer.close();
            } catch (Exception e) {
                Log.e(TAG, "Error closing resources: " + e.getMessage());
            }
        }
    }
    
    /**
     * Export contacts to OpenGD77 Contacts.csv format
     */
    public static boolean exportContacts(Context context, String targetPackage, File outputFile) {
        BufferedWriter writer = null;
        SQLiteDatabase db = null;
        Cursor cursor = null;
        File dbCopy = null;
        
        try {
            // Copy database to our cache using su
            dbCopy = copyDatabaseToCache(context, targetPackage, "contact_database.db");
            if (dbCopy == null) {
                Log.e(TAG, "Failed to copy contact database");
                return false;
            }
            
            // Open the copied database
            try {
                db = SQLiteDatabase.openDatabase(dbCopy.getAbsolutePath(), null, SQLiteDatabase.OPEN_READONLY);
            } catch (Exception e) {
                Log.e(TAG, "Contact database cannot be opened: " + e.getMessage());
                return false;
            }
            
            // Query all contacts
            cursor = db.query("contact_database", null, null, null, null, null, "contact_name ASC");
            
            if (cursor == null) {
                Log.e(TAG, "Contact cursor is null");
                return false;
            }
            
            Log.i(TAG, "Exporting " + cursor.getCount() + " contacts");
            
            // Create output file
            writer = new BufferedWriter(new FileWriter(outputFile));
            
            // Write header
            writer.write(CONTACTS_HEADER);
            writer.newLine();
            
            // Process each contact
            int contactCount = 0;
            while (cursor.moveToNext()) {
                try {
                    String csvRow = buildContactRow(cursor);
                    writer.write(csvRow);
                    writer.newLine();
                    contactCount++;
                } catch (Exception e) {
                    Log.e(TAG, "Error processing contact row: " + e.getMessage());
                    e.printStackTrace();
                }
            }
            
            Log.i(TAG, "Exported " + contactCount + " contacts successfully");
            return true;
            
        } catch (Exception e) {
            Log.e(TAG, "Error exporting contacts: " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            try {
                if (cursor != null) cursor.close();
                if (db != null) db.close();
                if (writer != null) writer.close();
                // Clean up copied database
                if (dbCopy != null && dbCopy.exists()) {
                    dbCopy.delete();
                }
            } catch (Exception e) {
                Log.e(TAG, "Error closing resources: " + e.getMessage());
            }
        }
    }
    
    /**
     * Build contact ID -> name mapping
     */
    private static Map<Integer, String> buildContactMap(Context context, String targetPackage) {
        Map<Integer, String> contactMap = new HashMap<>();
        SQLiteDatabase db = null;
        Cursor cursor = null;
        File dbCopy = null;
        
        try {
            // Copy database to our cache using su
            dbCopy = copyDatabaseToCache(context, targetPackage, "contact_database.db");
            if (dbCopy == null) {
                Log.w(TAG, "Failed to copy contact database for contact map");
                return contactMap;
            }
            
            // Open the copied database
            try {
                db = SQLiteDatabase.openDatabase(dbCopy.getAbsolutePath(), null, SQLiteDatabase.OPEN_READONLY);
            } catch (Exception e) {
                Log.w(TAG, "Contact database not accessible for contact map: " + e.getMessage());
                return contactMap;
            }
            cursor = db.query("contact_database", new String[]{"_id", "contact_name"}, null, null, null, null, null);
            
            if (cursor != null) {
                while (cursor.moveToNext()) {
                    int id = cursor.getInt(0);
                    String name = cursor.getString(1);
                    contactMap.put(id, name != null ? name : "Unknown");
                }
            }
            
            Log.i(TAG, "Built contact map with " + contactMap.size() + " entries");
            
        } catch (Exception e) {
            Log.e(TAG, "Error building contact map: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                if (cursor != null) cursor.close();
                if (db != null) db.close();
                // Clean up copied database
                if (dbCopy != null && dbCopy.exists()) {
                    dbCopy.delete();
                }
            } catch (Exception e) {
                Log.e(TAG, "Error closing contact map resources: " + e.getMessage());
            }
        }
        
        return contactMap;
    }
    
    /**
     * Build CSV row for a channel (24 columns)
     */
    private static String buildChannelRow(Cursor cursor, Map<Integer, String> contactMap) {
        StringBuilder row = new StringBuilder();
        
        // Column 1: Channel Number
        int channelNumber = getInt(cursor, "channel_number", 0);
        row.append(channelNumber).append(",");
        
        // Column 2: Channel Name
        String channelName = getString(cursor, "channel_name", "");
        row.append(quote(channelName)).append(",");
        
        // Column 3: Channel Type (0=Digital, 1=Analog)
        int type = getInt(cursor, "channel_type", 0);
        row.append(type == 0 ? "Digital" : "Analog").append(",");
        
        // Column 4: Rx Frequency (convert Hz to MHz)
        int rxFreqHz = getInt(cursor, "channel_rxFreq", 0);
        String rxFreqMHz = convertFrequency(rxFreqHz);
        row.append(rxFreqMHz).append(",");
        
        // Column 5: Tx Frequency (convert Hz to MHz)
        int txFreqHz = getInt(cursor, "channel_txFreq", 0);
        String txFreqMHz = convertFrequency(txFreqHz);
        row.append(txFreqMHz).append(",");
        
        // Column 6: Bandwidth kHz (empty for digital, 12.5 or 25 for analog)
        row.append(",");
        
        // Column 7: Colour Code (0-15)
        int cc = getInt(cursor, "channel_cc", 1);
        row.append(cc).append(",");
        
        // Column 8: Timeslot (0=TS1 → output "1", 1=TS2 → output "2")
        int inboundSlot = getInt(cursor, "channel_inBoundSlot", 0);
        row.append(inboundSlot + 1).append(",");
        
        // Column 9: Contact (lookup name by ID)
        int contactId = getInt(cursor, "channel_txContact", 0);
        String contactName = contactMap.getOrDefault(contactId, "None");
        row.append(quote(contactName)).append(",");
        
        // Column 10: TG List
        row.append("None").append(",");
        
        // Column 11: DMR ID
        row.append("None").append(",");
        
        // Column 12: TS1_TA_Tx
        row.append("Off").append(",");
        
        // Column 13: TS2_TA_Tx
        row.append("Off").append(",");
        
        // Column 14: RX Tone (analog only)
        row.append(",");
        
        // Column 15: TX Tone (analog only)
        row.append(",");
        
        // Column 16: Squelch
        int sq = getInt(cursor, "channel_sq", 0);
        row.append(sq).append(",");
        
        // Column 17: Power (0=Low, 1=High)
        int power = getInt(cursor, "channel_power", 0);
        row.append(power == 0 ? "Low" : "High").append(",");
        
        // Column 18: Rx Only
        row.append(",");
        
        // Column 19: Zone Skip
        row.append(",");
        
        // Column 20: All Skip
        row.append("All").append(",");
        
        // Column 21: TOT (timeout timer)
        row.append("60").append(",");
        
        // Column 22: VOX
        row.append(",");
        
        // Column 23: Ch Scan List
        row.append("None").append(",");
        
        // Column 24: Rx Group List
        row.append("None").append(",");
        
        // Column 25: TX (last column, no trailing comma)
        row.append("");
        
        return row.toString();
    }
    
    /**
     * Build CSV row for a contact (4 columns)
     */
    private static String buildContactRow(Cursor cursor) {
        StringBuilder row = new StringBuilder();
        
        // Column 1: Contact Name
        String name = getString(cursor, "contact_name", "");
        row.append(quote(name)).append(",");
        
        // Column 2: ID (DMR ID)
        String dmrId = getString(cursor, "contact_number", "");
        row.append(dmrId).append(",");
        
        // Column 3: ID Type (0=Private, 1=Group)
        int type = getInt(cursor, "contact_type", 0);
        row.append(type == 0 ? "Private" : "Group").append(",");
        
        // Column 4: TS Override (last column, no trailing comma)
        row.append("None");
        
        return row.toString();
    }
    
    /**
     * Convert frequency from Hz to MHz (401025000 → 401.02500)
     */
    private static String convertFrequency(int freqHz) {
        if (freqHz == 0) {
            return "";
        }
        double freqMHz = freqHz / 1000000.0;
        return String.format(Locale.US, "%.5f", freqMHz);
    }
    
    /**
     * Quote CSV field if it contains comma or quotes
     */
    private static String quote(String field) {
        if (field == null || field.isEmpty()) {
            return "";
        }
        
        if (field.contains(",") || field.contains("\"") || field.contains("\n")) {
            // Escape quotes by doubling them
            String escaped = field.replace("\"", "\"\"");
            return "\"" + escaped + "\"";
        }
        
        return field;
    }
    
    /**
     * Get string from cursor with default value
     */
    private static String getString(Cursor cursor, String columnName, String defaultValue) {
        try {
            int index = cursor.getColumnIndex(columnName);
            if (index >= 0) {
                String value = cursor.getString(index);
                return value != null ? value : defaultValue;
            }
        } catch (Exception e) {
            Log.e(TAG, "Error getting string " + columnName + ": " + e.getMessage());
        }
        return defaultValue;
    }
    
    /**
     * Get integer from cursor with default value
     */
    private static int getInt(Cursor cursor, String columnName, int defaultValue) {
        try {
            int index = cursor.getColumnIndex(columnName);
            if (index >= 0) {
                return cursor.getInt(index);
            }
        } catch (Exception e) {
            Log.e(TAG, "Error getting int " + columnName + ": " + e.getMessage());
        }
        return defaultValue;
    }
}
