package com.dmrmod.hooks;

import android.content.ContentValues;
import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.util.Log;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

/**
 * CSVImporter - Import OpenGD77 compatible CSV files into DMR database
 */
public class CSVImporter {
    
    private static final String TAG = "DMRModHooks_CSVImporter";
    
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
            
            Log.i(TAG, "Database copied successfully: " + destFile.getAbsolutePath());
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
     * Copy database back to target app's directory using su
     * Two-step process: regular copy to /sdcard, then root copy to target
     */
    private static boolean copyDatabaseBack(File sourceFile, String targetPackage, String dbName) {
        File tempFile = null;
        try {
            String destPath = "/data/data/" + targetPackage + "/databases/" + dbName;
            
            // Step 1: Copy from cache to /sdcard using regular file I/O
            tempFile = new File("/sdcard/dmrmod_temp_" + dbName);
            if (tempFile.exists()) {
                tempFile.delete();
            }
            
            Log.i(TAG, "Step 1: Copying to /sdcard: " + sourceFile.getAbsolutePath() + " -> " + tempFile.getAbsolutePath());
            
            java.io.FileInputStream fis = new java.io.FileInputStream(sourceFile);
            java.io.FileOutputStream fos = new java.io.FileOutputStream(tempFile);
            byte[] buffer = new byte[8192];
            int bytesRead;
            while ((bytesRead = fis.read(buffer)) != -1) {
                fos.write(buffer, 0, bytesRead);
            }
            fis.close();
            fos.close();
            
            // Step 2: Copy from /sdcard to app's database directory using root
            Log.i(TAG, "Step 2: Copying with root: " + tempFile.getAbsolutePath() + " -> " + destPath);
            
            // Use sh -c to ensure proper shell interpretation
            String[] cmd = {
                "/system_ext/bin/su",
                "-c",
                "sh -c 'cat \"" + tempFile.getAbsolutePath() + "\" > \"" + destPath + "\" && chmod 660 \"" + destPath + "\" && chown system:system \"" + destPath + "\"'"
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
                Log.e(TAG, "Failed to copy database back, exit code: " + exitCode);
                if (errorOutput.length() > 0) {
                    Log.e(TAG, "Error output: " + errorOutput.toString());
                }
                tempFile.delete();
                return false;
            }
            
            // Clean up temp file
            tempFile.delete();
            
            Log.i(TAG, "Database copied back successfully");
            return true;
            
        } catch (Exception e) {
            Log.e(TAG, "Error copying database back: " + e.getMessage());
            e.printStackTrace();
            if (tempFile != null && tempFile.exists()) {
                tempFile.delete();
            }
            return false;
        }
    }
    
    /**
     * Import contacts from CSV file
     */
    public static boolean importContacts(Context context, String targetPackage, File inputFile) {
        BufferedReader reader = null;
        SQLiteDatabase db = null;
        
        try {
            reader = new BufferedReader(new FileReader(inputFile));
            
            // Read and validate header
            String headerLine = reader.readLine();
            if (headerLine == null) {
                Log.e(TAG, "Empty contacts file");
                return false;
            }
            
            Log.i(TAG, "Contacts header: " + headerLine);
            
            // Open database for writing using context
            Log.i(TAG, "Opening contact database via context...");
            
            try {
                db = context.openOrCreateDatabase("contact_database.db", Context.MODE_PRIVATE, null);
            } catch (Exception e) {
                Log.e(TAG, "Contact database cannot be opened via context");
                Log.e(TAG, "Error: " + e.getMessage());
                return false;
            }
            
            // Clear existing contacts (optional - you might want to disable this)
            // db.delete("contact_database", null, null);
            
            int importCount = 0;
            int skipCount = 0;
            String line;
            
            while ((line = reader.readLine()) != null) {
                try {
                    if (line.trim().isEmpty()) {
                        continue;
                    }
                    
                    String[] fields = parseCSVLine(line);
                    
                    if (fields.length < 4) {
                        Log.w(TAG, "Skipping invalid contact row: " + line);
                        skipCount++;
                        continue;
                    }
                    
                    // Parse fields
                    String contactName = fields[0].trim();
                    String dmrId = fields[1].trim();
                    String idType = fields[2].trim();
                    
                    // Skip empty or "None" contacts
                    if (contactName.isEmpty() || contactName.equalsIgnoreCase("None") || 
                        dmrId.isEmpty() || dmrId.equalsIgnoreCase("None")) {
                        skipCount++;
                        continue;
                    }
                    
                    // Convert ID Type
                    int contactType = idType.equalsIgnoreCase("Group") ? 1 : 0;
                    
                    // Insert into database
                    ContentValues values = new ContentValues();
                    values.put("contact_name", contactName);
                    values.put("contact_number", dmrId);
                    values.put("contact_type", contactType);
                    values.put("contact_active", 1);
                    values.put("contact_icon", "");
                    
                    long result = db.insert("contact_database", null, values);
                    
                    if (result != -1) {
                        importCount++;
                        Log.d(TAG, "Imported contact: " + contactName + " (" + dmrId + ")");
                    } else {
                        Log.w(TAG, "Failed to import contact: " + contactName);
                        skipCount++;
                    }
                    
                } catch (Exception e) {
                    Log.e(TAG, "Error processing contact row: " + e.getMessage());
                    skipCount++;
                }
            }
            
            Log.i(TAG, "Imported " + importCount + " contacts, skipped " + skipCount);
            return true;
            
        } catch (Exception e) {
            Log.e(TAG, "Error importing contacts: " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            try {
                if (reader != null) reader.close();
                if (db != null) db.close();
            } catch (Exception e) {
                Log.e(TAG, "Error closing resources: " + e.getMessage());
            }
        }
    }
    
    /**
     * Import channels from CSV file
     */
    public static boolean importChannels(Context context, String targetPackage, File inputFile) {
        BufferedReader reader = null;
        SQLiteDatabase db = null;
        
        try {
            reader = new BufferedReader(new FileReader(inputFile));
            
            // Read and validate header
            String headerLine = reader.readLine();
            if (headerLine == null) {
                Log.e(TAG, "Empty channels file");
                return false;
            }
            
            Log.i(TAG, "Channels header: " + headerLine);
            
            // Build contact name -> ID mapping
            Map<String, Integer> contactMap = buildContactNameMap(context, targetPackage);
            
            // Open database for writing using context
            Log.i(TAG, "Opening channel database via context...");
            
            try {
                db = context.openOrCreateDatabase("database_channel_area_default_uhf.db", Context.MODE_PRIVATE, null);
            } catch (Exception e) {
                Log.e(TAG, "Channel database cannot be opened via context");
                Log.e(TAG, "Error: " + e.getMessage());
                return false;
            }
            
            // Clear existing channels (optional - you might want to disable this)
            // db.delete("database_channel_area_default_uhf", null, null);
            
            int importCount = 0;
            int skipCount = 0;
            String line;
            
            while ((line = reader.readLine()) != null) {
                try {
                    if (line.trim().isEmpty()) {
                        continue;
                    }
                    
                    String[] fields = parseCSVLine(line);
                    
                    if (fields.length < 24) {
                        Log.w(TAG, "Skipping invalid channel row (insufficient columns): " + line);
                        skipCount++;
                        continue;
                    }
                    
                    // Parse channel fields
                    int channelNumber = parseInt(fields[0], 0);
                    String channelName = fields[1].trim();
                    String channelType = fields[2].trim();
                    String rxFreqStr = fields[3].trim();
                    String txFreqStr = fields[4].trim();
                    int colourCode = parseInt(fields[6], 1);
                    int timeslot = parseInt(fields[7], 1);
                    String contactName = fields[8].trim();
                    int squelch = parseInt(fields[15], 0);
                    String power = fields[16].trim();
                    
                    // Skip empty channels
                    if (channelName.isEmpty() || channelName.equalsIgnoreCase("None")) {
                        skipCount++;
                        continue;
                    }
                    
                    // Convert frequencies MHz -> Hz
                    int rxFreqHz = convertFrequencyToHz(rxFreqStr);
                    int txFreqHz = convertFrequencyToHz(txFreqStr);
                    
                    if (rxFreqHz == 0 || txFreqHz == 0) {
                        Log.w(TAG, "Skipping channel with invalid frequency: " + channelName);
                        skipCount++;
                        continue;
                    }
                    
                    // Convert channel type
                    int type = channelType.equalsIgnoreCase("Analog") ? 1 : 0;
                    
                    // Convert timeslot (CSV: 1 or 2 -> DB: 0 or 1)
                    int inboundSlot = timeslot - 1;
                    if (inboundSlot < 0) inboundSlot = 0;
                    if (inboundSlot > 1) inboundSlot = 1;
                    
                    // Lookup contact ID
                    int contactId = contactMap.getOrDefault(contactName, 0);
                    
                    // Convert power
                    int powerLevel = power.equalsIgnoreCase("High") ? 1 : 0;
                    
                    // Insert into database
                    ContentValues values = new ContentValues();
                    values.put("channel_number", channelNumber);
                    values.put("channel_name", channelName);
                    values.put("channel_type", type);
                    values.put("channel_rxFreq", rxFreqHz);
                    values.put("channel_txFreq", txFreqHz);
                    values.put("channel_cc", colourCode);
                    values.put("channel_inBoundSlot", inboundSlot);
                    values.put("channel_outBoundSlot", inboundSlot);
                    values.put("channel_txContact", contactId);
                    values.put("channel_power", powerLevel);
                    values.put("channel_sq", squelch);
                    values.put("channel_active", 1);
                    values.put("channel_mode", 0);
                    values.put("channel_contactType", 0);
                    values.put("channel_encryptSw", 0);
                    values.put("channel_encryptKey", "");
                    values.put("channel_relay", 0);
                    values.put("channel_interrupt", 0);
                    values.put("channel_band", 0);
                    values.put("channel_rxType", 0);
                    values.put("channel_rxSubCode", 0);
                    values.put("channel_txType", 0);
                    values.put("channel_txSubCode", 0);
                    values.put("channel_groups", "");
                    
                    long result = db.insert("database_channel_area_default_uhf", null, values);
                    
                    if (result != -1) {
                        importCount++;
                        Log.d(TAG, "Imported channel: " + channelName + " (" + rxFreqHz + " Hz)");
                    } else {
                        Log.w(TAG, "Failed to import channel: " + channelName);
                        skipCount++;
                    }
                    
                } catch (Exception e) {
                    Log.e(TAG, "Error processing channel row: " + e.getMessage());
                    e.printStackTrace();
                    skipCount++;
                }
            }
            
            Log.i(TAG, "Imported " + importCount + " channels, skipped " + skipCount);
            return true;
            
        } catch (Exception e) {
            Log.e(TAG, "Error importing channels: " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            try {
                if (reader != null) reader.close();
                if (db != null) db.close();
            } catch (Exception e) {
                Log.e(TAG, "Error closing resources: " + e.getMessage());
            }
        }
    }
    
    /**
     * Build contact name -> ID mapping
     */
    private static Map<String, Integer> buildContactNameMap(Context context, String targetPackage) {
        Map<String, Integer> contactMap = new HashMap<>();
        SQLiteDatabase db = null;
        Cursor cursor = null;
        
        try {
            // Open via context
            Log.i(TAG, "Building contact name map via context...");
            
            try {
                db = context.openOrCreateDatabase("contact_database.db", Context.MODE_PRIVATE, null);
            } catch (Exception e) {
                Log.w(TAG, "Contact database not accessible for name map: " + e.getMessage());
                return contactMap;
            }
            cursor = db.query("contact", new String[]{"_id", "contact_name"}, null, null, null, null, null);
            
            if (cursor != null) {
                while (cursor.moveToNext()) {
                    int id = cursor.getInt(0);
                    String name = cursor.getString(1);
                    if (name != null && !name.isEmpty()) {
                        contactMap.put(name, id);
                    }
                }
            }
            
            Log.i(TAG, "Built contact name map with " + contactMap.size() + " entries");
            
        } catch (Exception e) {
            Log.e(TAG, "Error building contact name map: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                if (cursor != null) cursor.close();
                if (db != null) db.close();
            } catch (Exception e) {
                Log.e(TAG, "Error closing contact map resources: " + e.getMessage());
            }
        }
        
        return contactMap;
    }
    
    /**
     * Convert frequency from MHz to Hz (401.02500 -> 401025000)
     */
    private static int convertFrequencyToHz(String freqMHz) {
        try {
            if (freqMHz == null || freqMHz.trim().isEmpty()) {
                return 0;
            }
            double mhz = Double.parseDouble(freqMHz.trim());
            return (int) (mhz * 1000000);
        } catch (Exception e) {
            Log.e(TAG, "Error converting frequency: " + freqMHz + " - " + e.getMessage());
            return 0;
        }
    }
    
    /**
     * Parse integer with default value
     */
    private static int parseInt(String str, int defaultValue) {
        try {
            if (str == null || str.trim().isEmpty()) {
                return defaultValue;
            }
            return Integer.parseInt(str.trim());
        } catch (Exception e) {
            return defaultValue;
        }
    }
    
    /**
     * Parse CSV line respecting quotes
     */
    private static String[] parseCSVLine(String line) {
        List<String> fields = new ArrayList<>();
        StringBuilder currentField = new StringBuilder();
        boolean inQuotes = false;
        
        for (int i = 0; i < line.length(); i++) {
            char c = line.charAt(i);
            
            if (c == '"') {
                // Handle escaped quotes
                if (inQuotes && i + 1 < line.length() && line.charAt(i + 1) == '"') {
                    currentField.append('"');
                    i++; // Skip next quote
                } else {
                    inQuotes = !inQuotes;
                }
            } else if (c == ',' && !inQuotes) {
                // End of field
                fields.add(currentField.toString());
                currentField = new StringBuilder();
            } else {
                currentField.append(c);
            }
        }
        
        // Add last field
        fields.add(currentField.toString());
        
        return fields.toArray(new String[0]);
    }
}
