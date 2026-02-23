package com.dmrmod.hooks;

import android.app.AlertDialog;
import android.content.ContentValues;
import android.content.Context;
import android.database.sqlite.SQLiteDatabase;
import android.os.Environment;
import android.util.Log;

/**
 * DirectDatabaseImporter - Import OpenGD77 CSV files into app database
 * 
 * IMPORT STRATEGY:
 * - Reads OpenGD77-format CSV files from Download/DMR_Backups/
 * - Shows timestamp-based selection dialog for available backups
 * - Clears existing channels and imports from CSV (full replace)
 * - Preserves stock contacts to avoid breaking app functionality
 * 
 * CRITICAL: Digital vs Analog Channel Handling
 * The app database requires DIFFERENT field values for Digital (DMR) vs Analog (FM) channels:
 * 
 * Digital (DMR) channels require:
 *   - channel_type = 0
 *   - channel_encryptSw = 1
 *   - channel_interrupt = 2
 *   - channel_active = 1
 *   - channel_cc, channel_inBoundSlot set from CSV
 * 
 * Analog (FM) channels require:
 *   - channel_type = 1
 *   - channel_encryptSw = 0
 *   - channel_encryptKey = NULL (not set)
 *   - channel_interrupt = 0
 *   - channel_active = 0
 *   - channel_cc, channel_inBoundSlot = 0
 * 
 * Setting incorrect values causes "operation failure" toast when activating channels.
 * 
 * AUTO-REFRESH:
 * - Uses reflection to call DmrManager.getDmrManagerInstance().init() after import
 * - Forces app to reload channels from database without restart
 */
import android.widget.ArrayAdapter;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.HashSet;
import java.util.List;
import java.util.Locale;
import java.util.Set;

/**
 * DirectDatabaseImporter - Import OpenGD77 CSV files directly to app database
 * 
 * Runs IN the target app's process, so has direct access to databases.
 */
public class DirectDatabaseImporter {
    
    private static final String TAG = "DMRModHooks_DirectImport";
    
    /**
     * Show backup selection dialog and import from app context
     */
    public static void showImportDialog(final Context context) {
        new Thread(new Runnable() {
            @Override
            public void run() {
                try {
                    // Find available backup sets (now folders instead of files)
                    File downloadDir = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOWNLOADS);
                    File backupDir = new File(downloadDir, "DMR_Backups");
                    if (!backupDir.exists() || !backupDir.isDirectory()) {
                        showError(context, "No backups found in Download/DMR_Backups/");
                        return;
                    }
                    
                    // Get list of backup folders (each folder name is a timestamp)
                    File[] files = backupDir.listFiles();
                    if (files == null || files.length == 0) {
                        showError(context, "No backup folders found");
                        return;
                    }
                    
                    // Find all folders with timestamp format (YYYYMMDD_HHMMSS)
                    List<String> timestamps = new ArrayList<>();
                    for (File file : files) {
                        if (file.isDirectory()) {
                            String name = file.getName();
                            // Check if folder name matches timestamp format: 20260223_140530
                            if (name.matches("\\d{8}_\\d{6}")) {
                                // Verify the folder contains required CSV files
                                File channelsFile = new File(file, "Channels.csv");
                                if (channelsFile.exists()) {
                                    timestamps.add(name);
                                    Log.i(TAG, "Found backup folder: " + name);
                                }
                            }
                        }
                    }
                    
                    if (timestamps.isEmpty()) {
                        showError(context, "No valid backup folders found");
                        return;
                    }
                    
                    // Sort timestamps (newest first)
                    Collections.sort(timestamps, Collections.reverseOrder());
                    final List<String> sortedTimestamps = timestamps;
                    
                    // Format timestamps for display
                    final List<String> displayNames = new ArrayList<>();
                    SimpleDateFormat inputFormat = new SimpleDateFormat("yyyyMMdd_HHmmss", Locale.US);
                    SimpleDateFormat outputFormat = new SimpleDateFormat("MMM dd, yyyy HH:mm:ss", Locale.US);
                    
                    for (String timestamp : sortedTimestamps) {
                        try {
                            Date date = inputFormat.parse(timestamp);
                            String formatted = outputFormat.format(date);
                            displayNames.add(formatted);
                        } catch (Exception e) {
                            displayNames.add(timestamp);
                        }
                    }
                    
                    // Show dialog on UI thread
                    ((android.app.Activity) context).runOnUiThread(new Runnable() {
                        @Override
                        public void run() {
                            AlertDialog.Builder builder = new AlertDialog.Builder(context);
                            builder.setTitle("Select Backup to Import");
                            
                            ArrayAdapter<String> adapter = new ArrayAdapter<>(
                                context,
                                android.R.layout.select_dialog_item,
                                displayNames
                            );
                            
                            builder.setAdapter(adapter, new android.content.DialogInterface.OnClickListener() {
                                @Override
                                public void onClick(android.content.DialogInterface dialog, int which) {
                                    final String selectedTimestamp = sortedTimestamps.get(which);
                                    
                                    // Confirm import
                                    new AlertDialog.Builder(context)
                                        .setTitle("Confirm Import")
                                        .setMessage("This will REPLACE all current channels and contacts with data from:\n\n" 
                                            + displayNames.get(which) + "\n\nContinue?")
                                        .setPositiveButton("Import", new android.content.DialogInterface.OnClickListener() {
                                            @Override
                                            public void onClick(android.content.DialogInterface dialog, int which) {
                                                performImport(context, selectedTimestamp);
                                            }
                                        })
                                        .setNegativeButton("Cancel", null)
                                        .show();
                                }
                            });
                            
                            builder.setNegativeButton("Cancel", null);
                            builder.show();
                        }
                    });
                    
                } catch (Exception e) {
                    Log.e(TAG, "Error showing import dialog: " + e.getMessage());
                    e.printStackTrace();
                    showError(context, "Error: " + e.getMessage());
                }
            }
        }).start();
    }
    
    /**
     * Perform the actual import in background thread
     */
    private static void performImport(final Context context, final String timestamp) {
        new Thread(new Runnable() {
            @Override
            public void run() {
                try {
                    Log.i(TAG, "Starting import for timestamp: " + timestamp);
                    
                    // Import from Download/DMR_Backups/[timestamp]/ folder
                    File downloadDir = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOWNLOADS);
                    File baseBackupDir = new File(downloadDir, "DMR_Backups");
                    File backupFolder = new File(baseBackupDir, timestamp);
                    
                    if (!backupFolder.exists() || !backupFolder.isDirectory()) {
                        Log.e(TAG, "Backup folder not found: " + backupFolder.getAbsolutePath());
                        showError(context, "Backup folder not found");
                        return;
                    }
                    
                    // Import channels (files now in timestamped folder with simple names)
                    File channelsFile = new File(backupFolder, "Channels.csv");
                    boolean channelsOk = importChannels(context, channelsFile);
                    
                    // Import contacts
                    File contactsFile = new File(backupFolder, "Contacts.csv");
                    boolean contactsOk = importContacts(context, contactsFile);
                    
                    // Show result
                    final String message;
                    final boolean shouldRefresh;
                    if (channelsOk && contactsOk) {
                        message = "✓ Import successful!\nChannels and contacts imported.";
                        shouldRefresh = true;
                    } else if (channelsOk) {
                        message = "⚠ Import partially successful\nChannels: OK, Contacts: Failed";
                        shouldRefresh = true;
                    } else if (contactsOk) {
                        message = "⚠ Import partially successful\nChannels: Failed, Contacts: OK";
                        shouldRefresh = false;
                    } else {
                        message = "❌ Import failed - check logs";
                        shouldRefresh = false;
                    }
                    
                    ((android.app.Activity) context).runOnUiThread(new Runnable() {
                        @Override
                        public void run() {
                            android.widget.Toast.makeText(context, message, android.widget.Toast.LENGTH_LONG).show();
                            
                            // Auto-refresh channel list if channels were imported
                            if (shouldRefresh) {
                                refreshChannelList(context);
                            }
                        }
                    });
                    
                } catch (Exception e) {
                    Log.e(TAG, "Error during import: " + e.getMessage());
                    e.printStackTrace();
                    showError(context, "Import error: " + e.getMessage());
                }
            }
        }).start();
    }
    
    /**
     * Import channels from CSV
     */
    private static boolean importChannels(Context context, File csvFile) {
        SQLiteDatabase db = null;
        BufferedReader reader = null;
        
        try {
            if (!csvFile.exists()) {
                Log.e(TAG, "Channels file not found: " + csvFile.getAbsolutePath());
                return false;
            }
            
            Log.i(TAG, "Importing channels from: " + csvFile.getAbsolutePath());
            
            // Open UHF database only (app uses one database at a time)
            File dbFile = context.getDatabasePath("database_channel_area_default_uhf.db");
            db = SQLiteDatabase.openDatabase(dbFile.getAbsolutePath(), null, SQLiteDatabase.OPEN_READWRITE);
            
            // Read CSV file first to parse all data
            reader = new BufferedReader(new FileReader(csvFile));
            String headerLine = reader.readLine(); // Skip header
            
            // Begin transaction
            db.beginTransaction();
            try {
                // Clear existing channels
                int deleted = db.delete("database_channel_area_default_uhf", null, null);
                Log.i(TAG, "Deleted " + deleted + " existing channels");
                
                // Reset autoincrement counter
                try {
                    db.execSQL("DELETE FROM sqlite_sequence WHERE name='database_channel_area_default_uhf'");
                    Log.i(TAG, "Reset autoincrement counter");
                } catch (Exception e) {
                    Log.i(TAG, "No autoincrement to reset (this is normal)");
                }
                
                // Import all channels to UHF database
                int importCount = 0;
                String line;
                while ((line = reader.readLine()) != null) {
                if (line.trim().isEmpty()) continue;
                
                String[] fields = parseCSVLine(line);
                if (fields.length < 28) {
                    Log.w(TAG, "Skipping invalid line (not enough fields): " + line);
                    continue;
                }
                
                ContentValues values = new ContentValues();
                
                // Channel Number (0) -> channel_number
                String channelNumber = fields[0].trim();
                values.put("channel_number", Integer.parseInt(channelNumber));
                
                // Channel Name (1) -> channel_name
                String channelName = fields[1].trim();
                values.put("channel_name", channelName);
                
                // Channel Type (2) -> channel_type (Database uses: 0=Digital, 1=Analog)
                String channelType = fields[2].trim();
                boolean isDMR = channelType.equalsIgnoreCase("Digital");
                values.put("channel_type", isDMR ? "0" : "1");  // Database uses numeric values
                
                // Rx Frequency (3) -> channel_rxFreq (MHz to Hz)
                String rxFreq = fields[3].trim().replace("\t", "");
                double rxFreqMHz = Double.parseDouble(rxFreq);
                long rxFreqHz = (long)(rxFreqMHz * 1000000);
                values.put("channel_rxFreq", rxFreqHz);
                
                // Tx Frequency (4) -> channel_txFreq (MHz to Hz)
                String txFreq = fields[4].trim().replace("\t", "");
                values.put("channel_txFreq", (long)(Double.parseDouble(txFreq) * 1000000));
                
                // DMR-specific fields - ONLY set for Digital channels
                if (isDMR) {
                    // Color Code (6) -> channel_cc
                    String ccStr = fields[6].trim();
                    int colorCode = ccStr.isEmpty() ? 1 : Integer.parseInt(ccStr);
                    values.put("channel_cc", colorCode);
                    
                    // Timeslot (7) -> channel_inBoundSlot
                    String tsStr = fields[7].trim();
                    int timeslot = tsStr.isEmpty() ? 1 : Integer.parseInt(tsStr);
                    values.put("channel_inBoundSlot", timeslot);
                    
                    // Contact (8) -> channel_txContact
                    // Default contact ID 1 (created during import for "None" contacts)
                    values.put("channel_txContact", 1);
                } else {
                    // Analog channels - set DMR fields to 0
                    values.put("channel_cc", 0);
                    values.put("channel_inBoundSlot", 0);
                    values.put("channel_txContact", 0);
                }
                
                // Band - set based on frequency
                // VHF (136-174 MHz) = band 1, UHF (400-512 MHz) = band 0
                int band = (rxFreqMHz >= 136 && rxFreqMHz <= 174) ? 1 : 0;
                values.put("channel_band", band);
                
                // CRITICAL: Set all required fields that app needs for activation
                // These fields must NOT be NULL or activation fails with "operation failure" toast
                // IMPORTANT: Digital and Analog channels require DIFFERENT values for some fields!
                
                // Fields that are SAME for both Digital and Analog:
                values.put("channel_power", 0);           // Power level (0=low, 1=high)
                values.put("channel_outBoundSlot", 0);    // Outbound timeslot
                values.put("channel_mode", 0);            // Channel mode
                values.put("channel_contactType", 0);     // Contact type
                values.put("channel_relay", 1);           // Relay setting (SAME for both)
                values.put("channel_sq", 0);              // Squelch level
                values.put("channel_rxType", 0);          // RX tone type
                values.put("channel_rxSubCode", 0);       // RX tone code
                values.put("channel_txType", 0);          // TX tone type
                values.put("channel_txSubCode", 0);       // TX tone code
                values.put("channel_groups", "1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0"); // Zone groups
                
                // Fields that DIFFER between Digital and Analog:
                if (isDMR) {
                    // Digital channels (DMR)
                    values.put("channel_encryptSw", 1);       // Encryption switch
                    values.put("channel_encryptKey", "");     // Encryption key (empty string, NOT NULL)
                    values.put("channel_interrupt", 2);       // Interrupt mode
                    values.put("channel_active", 1);          // Channel active status (1=active)
                } else {
                    // Analog channels (FM)
                    values.put("channel_encryptSw", 0);       // No encryption
                    // channel_encryptKey left as NULL for analog (don't set it)
                    values.put("channel_interrupt", 0);       // No interrupt
                    values.put("channel_active", 0);          // Inactive by default
                }
                
                // Insert into database
                long rowId = db.insert("database_channel_area_default_uhf", null, values);
                if (rowId == -1) {
                    Log.e(TAG, "FAILED to insert channel " + channelNumber + ": " + channelName);
                } else {
                    importCount++;
                    Log.i(TAG, "✓ Inserted channel " + channelNumber + ": " + channelName + 
                        " (" + rxFreqMHz + " MHz, band=" + band + ", rowId=" + rowId + ")");
                }
            }
            
            // Mark transaction as successful
            db.setTransactionSuccessful();
            Log.i(TAG, "✓ Imported " + importCount + " channels");
            
            } finally {
                // End transaction
                db.endTransaction();
            }
            
            // Force WAL checkpoint
            try {
                db.execSQL("PRAGMA wal_checkpoint(FULL)");
                Log.i(TAG, "WAL checkpoint completed");
            } catch (Exception e) {
                Log.w(TAG, "WAL checkpoint failed (database might not use WAL): " + e.getMessage());
            }
            
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
                e.printStackTrace();
            }
        }
    }
    
    /**
     * Import contacts from CSV
     */
    private static boolean importContacts(Context context, File csvFile) {
        SQLiteDatabase db = null;
        BufferedReader reader = null;
        
        try {
            if (!csvFile.exists()) {
                Log.e(TAG, "Contacts file not found: " + csvFile.getAbsolutePath());
                return false;
            }
            
            Log.i(TAG, "Importing contacts from: " + csvFile.getAbsolutePath());
            
            // Open database directly
            File dbFile = context.getDatabasePath("contact_database.db");
            db = SQLiteDatabase.openDatabase(dbFile.getAbsolutePath(), null, SQLiteDatabase.OPEN_READWRITE);
            
            // Read CSV file first
            reader = new BufferedReader(new FileReader(csvFile));
            String headerLine = reader.readLine(); // Skip header
            
            // Begin transaction to ensure inserts are atomic
            db.beginTransaction();
            try {
                // DON'T delete existing contacts - preserve stock contacts
                // Channels reference contact ID 1 which exists in stock database
                Log.i(TAG, "Preserving existing contacts (stock contacts remain intact)");
                
                // Import all contacts from CSV
                int contactCount = 0;
                String line;
                while ((line = reader.readLine()) != null) {
                if (line.trim().isEmpty()) continue;
                
                String[] fields = parseCSVLine(line);
                if (fields.length < 4) {
                    Log.w(TAG, "Skipping invalid contact line: " + line);
                    continue;
                }
                
                ContentValues values = new ContentValues();
                
                // Contact Name (0) -> contact_name
                values.put("contact_name", fields[0].trim());
                
                // ID (1) -> contact_number
                values.put("contact_number", Integer.parseInt(fields[1].trim()));
                
                // ID Type (2) -> contact_type (Group=0, Private=1, All Call=2)
                String idType = fields[2].trim();
                int contactType;
                if (idType.equalsIgnoreCase("Group")) {
                    contactType = 0;
                } else if (idType.equalsIgnoreCase("Private")) {
                    contactType = 1;
                } else {
                    contactType = 2; // All Call
                }
                values.put("contact_type", contactType);
                
                // Set defaults - contact_icon must be empty string, not 0 (app expects base64 or empty)
                values.put("contact_active", 1);
                values.put("contact_icon", "");
                
                db.insert("contact_database", null, values);
                contactCount++;
            }
            
            // Mark transaction as successful
            db.setTransactionSuccessful();
            Log.i(TAG, "✓ Imported " + contactCount + " contacts");
            
            } finally {
                // End transaction
                db.endTransaction();
            }
            
            // Force WAL checkpoint to write changes to main database file
            try {
                db.execSQL("PRAGMA wal_checkpoint(FULL)");
                Log.i(TAG, "Contacts WAL checkpoint completed");
            } catch (Exception e) {
                Log.w(TAG, "Contacts WAL checkpoint failed (database might not use WAL): " + e.getMessage());
            }
            
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
                e.printStackTrace();
            }
        }
    }
    
    /**
     * Parse CSV line handling quoted fields properly
     */
    private static String[] parseCSVLine(String line) {
        List<String> fields = new ArrayList<>();
        StringBuilder field = new StringBuilder();
        boolean inQuotes = false;
        
        for (int i = 0; i < line.length(); i++) {
            char c = line.charAt(i);
            
            if (c == '"') {
                inQuotes = !inQuotes;
            } else if (c == ',' && !inQuotes) {
                fields.add(field.toString());
                field.setLength(0);
            } else {
                field.append(c);
            }
        }
        fields.add(field.toString());
        
        return fields.toArray(new String[0]);
    }
    
    /**
     * Show error message on UI thread
     */
    private static void showError(final Context context, final String message) {
        ((android.app.Activity) context).runOnUiThread(new Runnable() {
            @Override
            public void run() {
                android.widget.Toast.makeText(context, message, android.widget.Toast.LENGTH_LONG).show();
            }
        });
    }
    
    /**
     * Refresh channel list using DmrManager
     * This triggers all registered UpdateListeners (including InterPhoneChannelFragment)
     * to refresh their adapters automatically
     */
    private static void refreshChannelList(Context context) {
        try {
            // CRITICAL: Use app's classloader (from context), not default classloader
            ClassLoader appClassLoader = context.getClassLoader();
            
            // Use reflection to call DmrManager.getInstance().updateChannelList()
            Class<?> dmrManagerClass = Class.forName("com.pri.prizeinterphone.manager.DmrManager", true, appClassLoader);
            
            Log.i(TAG, "DmrManager class loaded: " + dmrManagerClass.getName());
            
            // Get singleton instance
            java.lang.reflect.Method getInstanceMethod = dmrManagerClass.getMethod("getInstance");
            Object dmrManager = getInstanceMethod.invoke(null);
            
            Log.i(TAG, "DmrManager instance obtained: " + dmrManager);
            
            // Call updateChannelList()
            java.lang.reflect.Method updateChannelListMethod = dmrManagerClass.getMethod("updateChannelList");
            updateChannelListMethod.invoke(dmrManager);
            
            Log.i(TAG, "✓ Channel list refreshed automatically - DmrManager.updateChannelList() called successfully!");
            
        } catch (Exception e) {
            Log.e(TAG, "Failed to refresh channel list: " + e.getClass().getName() + ": " + e.getMessage());
            e.printStackTrace();
            // Don't show error to user - import still succeeded
        }
    }
}
