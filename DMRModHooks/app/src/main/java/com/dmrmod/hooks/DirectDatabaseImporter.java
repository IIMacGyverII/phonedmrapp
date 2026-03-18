package com.dmrmod.hooks;

import android.app.AlertDialog;
import android.content.ContentValues;
import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.os.Environment;
import android.util.Log;

/**
 * DirectDatabaseImporter - Import OpenGD77 CSV files into app database
 * 
 * IMPORT STRATEGY:
 * - Reads OpenGD77-format CSV files from Download/DMR/DMR_Backups/
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
                    File backupDir = new File(downloadDir, "DMR/DMR_Backups");
                    if (!backupDir.exists() || !backupDir.isDirectory()) {
                        showError(context, "No backups found in Download/DMR/DMR_Backups/");
                        return;
                    }
                    
                    // Get list of backup folders (each folder name is a timestamp)
                    File[] files = backupDir.listFiles();
                    if (files == null || files.length == 0) {
                        showError(context, "No backup folders found");
                        return;
                    }
                    
                    // Find all folders that contain backup files
                    List<String> folderNames = new ArrayList<>();
                    for (File file : files) {
                        if (file.isDirectory()) {
                            String name = file.getName();
                            // Verify the folder contains required CSV files
                            File channelsFile = new File(file, "Channels.csv");
                            if (channelsFile.exists()) {
                                folderNames.add(name);
                                Log.i(TAG, "Found backup folder: " + name);
                            }
                        }
                    }
                    
                    if (folderNames.isEmpty()) {
                        showError(context, "No valid backup folders found");
                        return;
                    }
                    
                    // Sort folder names (try to parse timestamps for sorting, fall back to alphabetical)
                    Collections.sort(folderNames, new java.util.Comparator<String>() {
                        @Override
                        public int compare(String name1, String name2) {
                            // Try timestamp-based comparison first
                            if (name1.matches("\\d{8}_\\d{6}") && name2.matches("\\d{8}_\\d{6}")) {
                                // Both are timestamps, sort newest first
                                return name2.compareTo(name1);
                            }
                            // Fall back to alphabetical (reverse for newest first)
                            return name2.compareTo(name1);
                        }
                    });
                    final List<String> sortedFolders = folderNames;
                    
                    // Format folder names for display (parse timestamps if possible)
                    final List<String> displayNames = new ArrayList<>();
                    SimpleDateFormat inputFormat = new SimpleDateFormat("yyyyMMdd_HHmmss", Locale.US);
                    SimpleDateFormat outputFormat = new SimpleDateFormat("MMM dd, yyyy HH:mm:ss", Locale.US);
                    
                    for (String folderName : sortedFolders) {
                        // Try to parse as timestamp for nice display
                        if (folderName.matches("\\d{8}_\\d{6}")) {
                            try {
                                Date date = inputFormat.parse(folderName);
                                String formatted = outputFormat.format(date);
                                displayNames.add(formatted);
                            } catch (Exception e) {
                                displayNames.add(folderName);
                            }
                        } else {
                            // Not a timestamp, just use folder name as-is
                            displayNames.add(folderName);
                        }
                    }
                    
                    // Show dialog on UI thread
                    ((android.app.Activity) context).runOnUiThread(new Runnable() {
                        @Override
                        public void run() {
                            AlertDialog.Builder builder = new AlertDialog.Builder(context);
                            builder.setTitle("Select Backup to Import");
                            
                            // Create custom list view that shows delete buttons
                            final android.widget.ListView listView = new android.widget.ListView(context);
                            
                            // Use array wrapper to allow adapter access from inner class
                            final BackupListAdapter[] adapterHolder = new BackupListAdapter[1];
                            
                            // Custom adapter with delete button
                            adapterHolder[0] = new BackupListAdapter(
                                context, 
                                sortedFolders, 
                                displayNames,
                                new BackupListAdapter.OnDeleteClickListener() {
                                    @Override
                                    public void onDeleteClick(final int position) {
                                        final String folderToDelete = sortedFolders.get(position);
                                        final String displayName = displayNames.get(position);
                                        
                                        // Show confirmation dialog
                                        new AlertDialog.Builder(context)
                                            .setTitle("Delete Backup")
                                            .setMessage("Are you sure you want to delete this backup?\n\n" 
                                                + displayName + "\n\nThis cannot be undone.")
                                            .setPositiveButton("Delete", new android.content.DialogInterface.OnClickListener() {
                                                @Override
                                                public void onClick(android.content.DialogInterface dialog, int which) {
                                                    // Delete the backup folder
                                                    deleteBackupFolder(context, folderToDelete);
                                                    
                                                    // Remove from lists
                                                    sortedFolders.remove(position);
                                                    displayNames.remove(position);
                                                    
                                                    // Refresh adapter
                                                    if (adapterHolder[0] != null) {
                                                        adapterHolder[0].notifyDataSetChanged();
                                                    }
                                                    
                                                    // If no backups left, close dialog
                                                    if (sortedFolders.isEmpty()) {
                                                        android.widget.Toast.makeText(context, 
                                                            "No backups remaining", 
                                                            android.widget.Toast.LENGTH_SHORT).show();
                                                    }
                                                }
                                            })
                                            .setNegativeButton("Cancel", null)
                                            .show();
                                    }
                                }
                            );
                            
                            listView.setAdapter(adapterHolder[0]);
                            
                            // Handle item click for import
                            listView.setOnItemClickListener(new android.widget.AdapterView.OnItemClickListener() {
                                @Override
                                public void onItemClick(android.widget.AdapterView<?> parent, android.view.View view, int position, long id) {
                                    final String selectedFolder = sortedFolders.get(position);
                                    final String displayName = displayNames.get(position);
                                    
                                    // Confirm import
                                    new AlertDialog.Builder(context)
                                        .setTitle("Confirm Import")
                                        .setMessage("This will REPLACE all current channels and contacts with data from:\n\n" 
                                            + displayName + "\n\nContinue?")
                                        .setPositiveButton("Import", new android.content.DialogInterface.OnClickListener() {
                                            @Override
                                            public void onClick(android.content.DialogInterface dialog, int which) {
                                                performImport(context, selectedFolder);
                                            }
                                        })
                                        .setNegativeButton("Cancel", null)
                                        .show();
                                }
                            });
                            
                            builder.setView(listView);
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
    private static void performImport(final Context context, final String folderName) {
        new Thread(new Runnable() {
            @Override
            public void run() {
                try {
                    Log.i(TAG, "Starting import for folder: " + folderName);
                    
                    // Import from Download/DMR/DMR_Backups/[folderName]/ folder
                    File downloadDir = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOWNLOADS);
                    File baseBackupDir = new File(downloadDir, "DMR/DMR_Backups");
                    File backupFolder = new File(baseBackupDir, folderName);
                    
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
                    
                    // Import zones (optional - not all backups have zones)
                    File zonesFile = new File(backupFolder, "Zones.csv");
                    boolean zonesOk = importZones(context, zonesFile);
                    
                    // Show result
                    final String message;
                    final boolean shouldRefresh;
                    if (channelsOk && contactsOk && zonesOk) {
                        message = "✓ Import successful!\nChannels, contacts, and zones imported.";
                        shouldRefresh = true;
                    } else if (channelsOk && contactsOk) {
                        message = "✓ Import successful!\nChannels and contacts imported (no zones).";
                        shouldRefresh = true;
                    } else if (channelsOk) {
                        message = "⚠ Import partially successful\nChannels: OK, Contacts: Failed, Zones: " + (zonesOk ? "OK" : "Failed");
                        shouldRefresh = true;
                    } else if (contactsOk) {
                        message = "⚠ Import partially successful\nChannels: Failed, Contacts: OK, Zones: " + (zonesOk ? "OK" : "Failed");
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
            
            // Initialize LocationDatabase for lat/lon import
            LocationDatabase locationDb = LocationDatabase.getInstance(context);
            locationDb.clearAllLocations();  // Clear existing locations before import
            Log.i(TAG, "LocationDatabase initialized for import");
            
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
                
                // Build contact name => ID map for lookup
                java.util.Map<String, Integer> contactMap = buildContactNameMap(context);
                
                String line;
                while ((line = reader.readLine()) != null) {
                if (line.trim().isEmpty()) continue;
                
                String[] fields = parseCSVLine(line);
                if (fields.length < 28) {
                    Log.w(TAG, "Skipping invalid line (not enough fields): " + line);
                    continue;
                }
                
                ContentValues values = new ContentValues();
                
                // Check if this is the new format with _ID field (29+ columns)
                // New format: _ID, Channel Number, Channel Name, ...
                // OpenGD77 format: Channel Number, Channel Name, ...
                // Channel Number -> channel_number
                String channelNumber = fields[0].trim();
                values.put("channel_number", Integer.parseInt(channelNumber));
                
                // Channel Name -> channel_name
                String channelName = fields[1].trim();
                values.put("channel_name", channelName);
                
                // Channel Type -> channel_type (Database uses: 0=Digital, 1=Analog)
                String channelType = fields[2].trim();
                boolean isDMR = channelType.equalsIgnoreCase("Digital");
                values.put("channel_type", isDMR ? "0" : "1");  // Database uses numeric values
                
                // Rx Frequency -> channel_rxFreq (MHz to Hz)
                String rxFreq = fields[3].trim().replace("\t", "");
                double rxFreqMHz = Double.parseDouble(rxFreq);
                long rxFreqHz = (long)(rxFreqMHz * 1000000);
                values.put("channel_rxFreq", rxFreqHz);
                
                // Tx Frequency -> channel_txFreq (MHz to Hz)
                String txFreq = fields[4].trim().replace("\t", "");
                values.put("channel_txFreq", (long)(Double.parseDouble(txFreq) * 1000000));
                
                // DMR-specific fields - ONLY set for Digital channels
                if (isDMR) {
                    // Color Code -> channel_cc
                    String ccStr = fields[6].trim();
                    int colorCode = ccStr.isEmpty() ? 1 : Integer.parseInt(ccStr);
                    values.put("channel_cc", colorCode);
                    
                    // Timeslot -> channel_inBoundSlot
                    String tsStr = fields[7].trim();
                    int timeslot = tsStr.isEmpty() ? 1 : Integer.parseInt(tsStr);
                    values.put("channel_inBoundSlot", timeslot);
                    
                    // Contact -> channel_txContact (lookup ID by name)
                    String contactName = fields[8].trim();
                    int contactId = getContactId(contactMap, contactName);
                    values.put("channel_txContact", contactId);
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
                
                // RX Tone and TX Tone - Parse CTCSS/DCS codes
                // OpenGD77 CSV format: "None", "67.0" (CTCSS), "D023N" (DCS Normal), "D023I" (DCS Inverted)
                int rxType = 0, rxSubCode = 0, txType = 0, txSubCode = 0;
                try {
                    String rxTone = fields[13].trim();
                    rxType = ToneConverter.parseType(rxTone);
                    rxSubCode = ToneConverter.parseSubCode(rxTone);
                } catch (Exception e) {
                    Log.w(TAG, "Error parsing RX Tone, using None: " + e.getMessage());
                }
                try {
                    String txTone = fields[14].trim();
                    txType = ToneConverter.parseType(txTone);
                    txSubCode = ToneConverter.parseSubCode(txTone);
                } catch (Exception e) {
                    Log.w(TAG, "Error parsing TX Tone, using None: " + e.getMessage());
                }
                
                // Squelch (15) - Read from CSV with OpenGD77 percentage conversion
                // OpenGD77 uses percentages (5%, 10%, 15%...95%), app uses 0-9
                int squelch = 0;
                try {
                    String sqStr = fields[15].trim();
                    if (!sqStr.isEmpty() && !sqStr.equalsIgnoreCase("None") && !sqStr.equalsIgnoreCase("Disabled")) {
                        // Remove % sign if present and parse as integer
                        String cleanSq = sqStr.replace("%", "").trim();
                        int sqPercent = Integer.parseInt(cleanSq);
                        
                        // Convert OpenGD77 percentage to app's 1-9 scale
                        // 0% or Disabled = 0, 5-10% = 1, 15-20% = 2, etc.
                        if (sqPercent <= 0) {
                            squelch = 0;
                        } else if (sqPercent <= 10) {
                            squelch = 1;
                        } else if (sqPercent <= 20) {
                            squelch = 2;
                        } else if (sqPercent <= 30) {
                            squelch = 3;
                        } else if (sqPercent <= 40) {
                            squelch = 4;
                        } else if (sqPercent <= 50) {
                            squelch = 5;
                        } else if (sqPercent <= 60) {
                            squelch = 6;
                        } else if (sqPercent <= 70) {
                            squelch = 7;
                        } else if (sqPercent <= 80) {
                            squelch = 8;
                        } else {  // 85-95% or higher
                            squelch = 9;
                        }
                        Log.i(TAG, "Converted squelch " + sqStr + " (" + sqPercent + "%) to level " + squelch);
                    }
                } catch (Exception e) {
                    squelch = 0;  // Default to 0 if parsing fails
                }
                
                // Power (16) - Read from CSV with OpenGD77 P1-P9 and +W- format
                // OpenGD77 uses P1 (lowest) to P9 and +W- (max)
                // App uses 0=low, 1=high, so divide range: P1-P4=low, P5-P9 and +W-=high
                int power = 1;  // Default to high
                try {
                    String powerStr = fields[16].trim();
                    // OpenGD77 low power range: P1, P2, P3, P4
                    if (powerStr.equalsIgnoreCase("P1") || powerStr.equalsIgnoreCase("P2") || 
                        powerStr.equalsIgnoreCase("P3") || powerStr.equalsIgnoreCase("P4") ||
                        powerStr.equalsIgnoreCase("Low")) {
                        power = 0;
                    // OpenGD77 high power range: P5, P6, P7, P8, P9, +W-, -W+
                    } else if (powerStr.equalsIgnoreCase("P5") || powerStr.equalsIgnoreCase("P6") ||
                               powerStr.equalsIgnoreCase("P7") || powerStr.equalsIgnoreCase("P8") ||
                               powerStr.equalsIgnoreCase("P9") || powerStr.equalsIgnoreCase("+W-") ||
                               powerStr.equalsIgnoreCase("-W+") || powerStr.equalsIgnoreCase("Master") ||
                               powerStr.equalsIgnoreCase("High")) {
                        power = 1;
                    }
                    Log.i(TAG, "Converted power " + powerStr + " to level " + power);
                } catch (Exception e) {
                    power = 1;  // Default to high power
                }
                
                // CRITICAL: Set all required fields that app needs for activation
                // These fields must NOT be NULL or activation fails with "operation failure" toast
                // IMPORTANT: Digital and Analog channels require DIFFERENT values for some fields!
                
                // Fields that are SAME for both Digital and Analog:
                values.put("channel_power", power);       // Power level (from CSV: 0=low, 1=high/master)
                values.put("channel_outBoundSlot", 0);    // Outbound timeslot
                values.put("channel_mode", 0);            // Channel mode
                values.put("channel_contactType", 0);     // Contact type
                values.put("channel_relay", 1);           // Relay setting (SAME for both)
                values.put("channel_sq", squelch);        // Squelch level (from CSV)
                values.put("channel_rxType", rxType);     // RX tone type (0=None, 1=CTCSS, 2=FDCS, 3=BDCS)
                values.put("channel_rxSubCode", rxSubCode); // RX tone code (index into tone array)
                values.put("channel_txType", txType);     // TX tone type (0=None, 1=CTCSS, 2=FDCS, 3=BDCS)
                values.put("channel_txSubCode", txSubCode); // TX tone code (index into tone array)
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
                
                // Insert into database (auto-increment _id)
                long rowId = db.insert("database_channel_area_default_uhf", null, values);
                if (rowId > 0) {
                    Log.i(TAG, "✓ Inserted channel " + channelNumber + ": " + channelName + " (ID: " + rowId + ")");
                }
                
                if (rowId == -1) {
                    Log.e(TAG, "FAILED to insert channel " + channelNumber + ": " + channelName);
                } else {
                    importCount++;
                    
                    // Store the rowId (_id) for zone import later
                    final long finalRowId = rowId;
                    
                    // Import APRS setting to APRSDatabase if present
                    try {
                        int aprsFieldIndex = 24;
                        if (fields.length > aprsFieldIndex) {
                            String aprsStr = fields[aprsFieldIndex].trim();
                            if (!aprsStr.isEmpty() && !aprsStr.equalsIgnoreCase("None")) {
                                // APRS enabled if field is "TX", "On", or non-empty
                                boolean aprsEnabled = aprsStr.equalsIgnoreCase("TX") || 
                                                     aprsStr.equalsIgnoreCase("On");
                                if (aprsEnabled) {
                                    APRSDatabase aprsDb = APRSDatabase.getInstance(context);
                                    aprsDb.setEnabled(Integer.parseInt(channelNumber), true);
                                    Log.i(TAG, "  Enabled APRS for channel " + channelNumber);
                                }
                            }
                        }
                    } catch (Exception e) {
                        Log.w(TAG, "Could not parse APRS setting for channel " + channelNumber + ": " + e.getMessage());
                    }
                    
                    // Import lat/lon to LocationDatabase if present
                    try {
                        int latFieldIndex = 25;
                        int lonFieldIndex = 26;
                        if (fields.length > lonFieldIndex) {
                            String latStr = fields[latFieldIndex].trim();
                            String lonStr = fields[lonFieldIndex].trim();
                            
                            // Only save if not default values
                            if (!latStr.isEmpty() && !lonStr.isEmpty()) {
                                double lat = Double.parseDouble(latStr);
                                double lon = Double.parseDouble(lonStr);
                                
                                // Don't save default values (0.128, 0.008)
                                if (Math.abs(lat - 0.128) > 0.001 || Math.abs(lon - 0.008) > 0.001) {
                                    locationDb.saveLocation(Integer.parseInt(channelNumber), lat, lon);
                                    Log.i(TAG, "  Saved location for channel " + channelNumber + ": " + lat + ", " + lon);
                                }
                            }
                        }
                    } catch (Exception e) {
                        Log.w(TAG, "Could not parse lat/lon for channel " + channelNumber + ": " + e.getMessage());
                    }
                    
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
    
    /**
     * Import zones from CSV
     * 
     * Zones.csv format (OpenGD77):
     * Zone Name,Channel1,Channel2,...,Channel80
     * Example: Local Pack,W9GLO Rptr,W9ZLQ Rptr,Simplex 1,,,
     * 
     * Each zone contains up to 80 channel names (not numbers).
     * We need to map channel names to channel numbers using the database.
     * 
     * @param context Application context
     * @param csvFile Zones.csv file
     * @return true if successful or no zones file exists, false if error
     */
    private static boolean importZones(Context context, File csvFile) {
        BufferedReader reader = null;
        
        try {
            // Zones are optional - return success if file doesn't exist
            if (!csvFile.exists()) {
                Log.i(TAG, "No Zones.csv file found - skipping zone import");
                return true;
            }
            
            Log.i(TAG, "Importing zones from: " + csvFile.getAbsolutePath());
            
            // Initialize ZoneDatabase
            ZoneDatabase zoneDb = ZoneDatabase.getInstance(context);
            zoneDb.clearAllZones();  // Clear existing zones before import
            Log.i(TAG, "ZoneDatabase initialized for import");
            
            // Build channel name => channel number map for lookup
            java.util.Map<String, Integer> channelNameMap = buildChannelNameMap(context);
            if (channelNameMap.isEmpty()) {
                Log.w(TAG, "No channels in database - cannot import zones");
                return false;
            }
            
            // Read CSV file
            reader = new BufferedReader(new FileReader(csvFile));
            String headerLine = reader.readLine(); // Skip header
            
            int importCount = 0;
            int skippedCount = 0;
            
            String line;
            while ((line = reader.readLine()) != null) {
                if (line.trim().isEmpty()) continue;
                
                String[] fields = parseCSVLine(line);
                if (fields.length < 1) {
                    Log.w(TAG, "Skipping invalid zone line (no zone name): " + line);
                    skippedCount++;
                    continue;
                }
                
                // First field is zone name
                String zoneName = fields[0].trim();
                if (zoneName.isEmpty()) {
                    Log.w(TAG, "Skipping zone with empty name");
                    skippedCount++;
                    continue;
                }
                
                // Remaining fields (up to 80) are channel names
                List<Integer> channelIds = new ArrayList<>();
                for (int i = 1; i < fields.length; i++) {
                    String channelName = fields[i].trim();
                    if (channelName.isEmpty()) {
                        continue; // Empty fields are normal (not all zones have 80 channels)
                    }
                    
                    // Look up channel ID by name
                    Integer channelId = channelNameMap.get(channelName);
                    if (channelId != null) {
                        channelIds.add(channelId);
                        Log.d(TAG, "Zone '" + zoneName + "': Mapped channel '" + channelName + "' to ID " + channelId);
                    } else {
                        Log.w(TAG, "Zone '" + zoneName + "': Channel '" + channelName + "' not found in database");
                    }
                }
                
                // Save zone if it has at least one channel
                if (channelIds.size() > 0) {
                    ZoneDatabase.Zone zone = new ZoneDatabase.Zone(zoneName, channelIds);
                    long zoneId = zoneDb.saveZone(zone);
                    importCount++;
                    Log.i(TAG, "Imported zone #" + zoneId + " '" + zoneName + "' with " + channelIds.size() + " channels");
                } else {
                    Log.w(TAG, "Skipping zone '" + zoneName + "' - no valid channels");
                    skippedCount++;
                }
            }
            
            Log.i(TAG, "Zone import complete: " + importCount + " zones imported, " + skippedCount + " skipped");
            return true;
            
        } catch (Exception e) {
            Log.e(TAG, "Error importing zones: " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            if (reader != null) {
                try {
                    reader.close();
                } catch (Exception e) {
                    // Ignore
                }
            }
        }
    }
    
    /**
     * Build a map of channel name => channel ID (_id) for zone import
     * 
     * @param context Application context
     * @return Map of channel names to channel IDs, or empty map if database doesn't exist
     */
    private static java.util.Map<String, Integer> buildChannelNameMap(Context context) {
        java.util.Map<String, Integer> channelMap = new java.util.HashMap<>();
        SQLiteDatabase db = null;
        Cursor cursor = null;
        
        try {
            File dbFile = context.getDatabasePath("database_channel_area_default_uhf.db");
            if (!dbFile.exists()) {
                Log.w(TAG, "Channel database not found");
                return channelMap;
            }
            
            db = SQLiteDatabase.openDatabase(dbFile.getAbsolutePath(), null, 
                SQLiteDatabase.OPEN_READONLY);
            
            cursor = db.query("database_channel_area_default_uhf", 
                new String[]{"_id", "channel_name"}, 
                null, null, null, null, null);
            
            if (cursor != null && cursor.moveToFirst()) {
                do {
                    int id = cursor.getInt(0);
                    String name = cursor.getString(1);
                    channelMap.put(name, id);
                } while (cursor.moveToNext());
            }
            
            Log.i(TAG, "Loaded " + channelMap.size() + " channels for zone import lookup");
            
        } catch (Exception e) {
            Log.w(TAG, "Error building channel name map: " + e.getMessage());
        } finally {
            if (cursor != null) cursor.close();
            if (db != null) db.close();
        }
        
        return channelMap;
    }
    
    /**
     * Build a map of contact name => contact ID for efficient lookup during import
     * 
     * @param context Application context
     * @return Map of contact names to IDs, or empty map if database doesn't exist
     */
    private static java.util.Map<String, Integer> buildContactNameMap(Context context) {
        java.util.Map<String, Integer> contactMap = new java.util.HashMap<>();
        SQLiteDatabase db = null;
        Cursor cursor = null;
        
        try {
            File dbFile = context.getDatabasePath("contact_database.db");
            if (!dbFile.exists()) {
                Log.w(TAG, "Contact database not found, all contacts will use default ID");
                return contactMap;
            }
            
            db = SQLiteDatabase.openDatabase(dbFile.getAbsolutePath(), null, 
                SQLiteDatabase.OPEN_READONLY);
            
            cursor = db.query("contact_database", 
                new String[]{"_id", "contact_name"}, 
                null, null, null, null, null);
            
            if (cursor != null && cursor.moveToFirst()) {
                do {
                    int id = cursor.getInt(0);
                    String name = cursor.getString(1);
                    contactMap.put(name, id);
                } while (cursor.moveToNext());
            }
            
            Log.i(TAG, "Loaded " + contactMap.size() + " contacts for import lookup");
            
        } catch (Exception e) {
            Log.w(TAG, "Error building contact name map: " + e.getMessage());
        } finally {
            if (cursor != null) cursor.close();
            if (db != null) db.close();
        }
        
        return contactMap;
    }
    
    /**
     * Get contact ID by name from the contact map
     * 
     * @param contactMap Map of contact names to IDs
     * @param contactName Contact name to lookup
     * @return Contact ID, or 1 (default) if not found or "None"
     */
    private static int getContactId(java.util.Map<String, Integer> contactMap, String contactName) {
        if (contactName == null || contactName.trim().isEmpty() || contactName.equalsIgnoreCase("None")) {
            return 1; // Default contact ID
        }
        Integer id = contactMap.get(contactName);
        if (id != null) {
            Log.d(TAG, "Resolved contact '" + contactName + "' to ID " + id);
            return id;
        }
        Log.w(TAG, "Contact not found: '" + contactName + "', using default ID 1");
        return 1; // Default if not found
    }
    
    /**
     * Delete a backup folder and all its contents
     */
    private static void deleteBackupFolder(Context context, String folderName) {
        try {
            File downloadDir = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOWNLOADS);
            File backupDir = new File(downloadDir, "DMR/DMR_Backups");
            File folderToDelete = new File(backupDir, folderName);
            
            if (!folderToDelete.exists()) {
                Log.w(TAG, "Folder to delete doesn't exist: " + folderToDelete.getAbsolutePath());
                return;
            }
            
            // Delete all files in the folder first
            if (folderToDelete.isDirectory()) {
                File[] files = folderToDelete.listFiles();
                if (files != null) {
                    for (File file : files) {
                        if (file.delete()) {
                            Log.i(TAG, "Deleted file: " + file.getName());
                        } else {
                            Log.w(TAG, "Failed to delete file: " + file.getName());
                        }
                    }
                }
            }
            
            // Delete the folder itself
            if (folderToDelete.delete()) {
                Log.i(TAG, "Deleted backup folder: " + folderName);
                android.widget.Toast.makeText(context, 
                    "✓ Backup deleted: " + folderName, 
                    android.widget.Toast.LENGTH_SHORT).show();
            } else {
                Log.e(TAG, "Failed to delete folder: " + folderName);
                android.widget.Toast.makeText(context, 
                    "Failed to delete backup folder", 
                    android.widget.Toast.LENGTH_SHORT).show();
            }
            
        } catch (Exception e) {
            Log.e(TAG, "Error deleting backup folder: " + e.getMessage());
            e.printStackTrace();
            android.widget.Toast.makeText(context, 
                "Error deleting backup: " + e.getMessage(), 
                android.widget.Toast.LENGTH_SHORT).show();
        }
    }
    
    /**
     * Custom adapter for backup list with delete buttons
     */
    static class BackupListAdapter extends android.widget.BaseAdapter {
        private final Context context;
        private final List<String> folderNames;
        private final List<String> displayNames;
        private final OnDeleteClickListener deleteListener;
        
        interface OnDeleteClickListener {
            void onDeleteClick(int position);
        }
        
        BackupListAdapter(Context context, List<String> folderNames, 
                         List<String> displayNames, OnDeleteClickListener deleteListener) {
            this.context = context;
            this.folderNames = folderNames;
            this.displayNames = displayNames;
            this.deleteListener = deleteListener;
        }
        
        @Override
        public int getCount() {
            return displayNames.size();
        }
        
        @Override
        public Object getItem(int position) {
            return displayNames.get(position);
        }
        
        @Override
        public long getItemId(int position) {
            return position;
        }
        
        @Override
        public android.view.View getView(final int position, android.view.View convertView, android.view.ViewGroup parent) {
            android.view.View view = convertView;
            
            if (view == null) {
                // Create custom layout for list item
                android.widget.LinearLayout layout = new android.widget.LinearLayout(context);
                layout.setOrientation(android.widget.LinearLayout.HORIZONTAL);
                layout.setPadding(20, 15, 20, 15);
                layout.setLayoutParams(new android.widget.LinearLayout.LayoutParams(
                    android.widget.LinearLayout.LayoutParams.MATCH_PARENT,
                    android.widget.LinearLayout.LayoutParams.WRAP_CONTENT
                ));
                
                // Text view for backup name
                android.widget.TextView textView = new android.widget.TextView(context);
                textView.setId(android.R.id.text1);
                textView.setTextSize(16);
                textView.setTextColor(0xFF000000);
                android.widget.LinearLayout.LayoutParams textParams = new android.widget.LinearLayout.LayoutParams(
                    0,
                    android.widget.LinearLayout.LayoutParams.WRAP_CONTENT
                );
                textParams.weight = 1.0f;
                textParams.gravity = android.view.Gravity.CENTER_VERTICAL;
                textView.setLayoutParams(textParams);
                layout.addView(textView);
                
                // Delete button (trash icon)
                android.widget.Button deleteButton = new android.widget.Button(context);
                deleteButton.setId(android.R.id.button1);
                deleteButton.setText("🗑️");
                deleteButton.setTextSize(20);
                deleteButton.setPadding(20, 10, 20, 10);
                android.widget.LinearLayout.LayoutParams buttonParams = new android.widget.LinearLayout.LayoutParams(
                    android.widget.LinearLayout.LayoutParams.WRAP_CONTENT,
                    android.widget.LinearLayout.LayoutParams.WRAP_CONTENT
                );
                buttonParams.leftMargin = 20;
                deleteButton.setLayoutParams(buttonParams);
                
                // Style the button
                android.graphics.drawable.GradientDrawable drawable = new android.graphics.drawable.GradientDrawable();
                drawable.setShape(android.graphics.drawable.GradientDrawable.RECTANGLE);
                drawable.setColor(0xFFFF5555);  // Red background
                drawable.setCornerRadius(10 * context.getResources().getDisplayMetrics().density);
                deleteButton.setBackground(drawable);
                deleteButton.setTextColor(0xFFFFFFFF);  // White text
                
                // Important: Make button not steal focus from list item clicks
                deleteButton.setFocusable(false);
                deleteButton.setFocusableInTouchMode(false);
                
                layout.addView(deleteButton);
                view = layout;
            }
            
            // Set backup name
            android.widget.TextView textView = view.findViewById(android.R.id.text1);
            textView.setText(displayNames.get(position));
            
            // Set delete button click listener
            android.widget.Button deleteButton = view.findViewById(android.R.id.button1);
            deleteButton.setFocusable(false);
            deleteButton.setFocusableInTouchMode(false);
            deleteButton.setOnClickListener(new android.view.View.OnClickListener() {
                @Override
                public void onClick(android.view.View v) {
                    if (deleteListener != null) {
                        deleteListener.onDeleteClick(position);
                    }
                }
            });
            
            return view;
        }
    }
}
