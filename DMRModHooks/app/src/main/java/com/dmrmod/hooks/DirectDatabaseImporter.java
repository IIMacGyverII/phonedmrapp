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
 * - Clears existing channels and contacts, then imports from CSV (full replace)
 * - Uses transactions to ensure atomic imports (all-or-nothing)
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
    
    // === COMPOUND KEY ZONE MATCHING FEATURE FLAG ===
    // Set to true to enable compound key (channelNum|freq|name) zone matching
    // Set to false to revert to simple name-only matching
    // This fixes zone scrambling when importing channels with duplicate channel_numbers
    private static final boolean USE_COMPOUND_KEY_ZONES = false;
    // ==============================================
    
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
                    
                    // Step 1: Import TG lists BEFORE channels so name lookups succeed
                    File tgListsFile = new File(backupFolder, "TG_Lists.csv");
                    boolean tgListsOk = importTGLists(context, tgListsFile);

                    // Step 2: Import channels (TG list assignment happens inside importChannels)
                    File channelsFile = new File(backupFolder, "Channels.csv");
                    boolean channelsOk = importChannels(context, channelsFile);

                    // Step 3: Import contacts
                    File contactsFile = new File(backupFolder, "Contacts.csv");
                    boolean contactsOk = importContacts(context, contactsFile);

                    // Step 4: Import zones (optional - not all backups have zones)
                    File zonesFile = new File(backupFolder, "Zones.csv");
                    boolean zonesOk = importZones(context, zonesFile);

                    // Show result
                    final String message;
                    final boolean shouldRefresh;
                    if (channelsOk && contactsOk && zonesOk) {
                        message = "✓ Import successful!\nChannels, contacts, zones" +
                            (tgListsOk ? ", TG lists" : "") + " imported.";
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
            String headerLine = reader.readLine();
            
            // Detect if CSV has _id column (Android export format)
            // Format with _id: "_id,Channel Number,Channel Name,..." (37 columns with new fields, 29 legacy)
            // Format without _id: "Channel Number,Channel Name,..." (36 columns with new fields, 28 legacy)
            boolean hasIdColumn = false;
            boolean hasNewFields = false; // Encrypt, Relay, Interrupt, Active, etc.
            if (headerLine != null) {
                String[] headerFields = parseCSVLine(headerLine);
                if (headerFields.length >= 29 && headerFields[0].trim().equalsIgnoreCase("_id")) {
                    hasIdColumn = true;
                    hasNewFields = headerFields.length >= 37;
                    Log.i(TAG, "Detected Android export format with _id column (" + headerFields.length + " fields, newFields=" + hasNewFields + ")");
                } else if (headerFields.length >= 28 && headerFields[0].trim().equals("Channel Number")) {
                    hasIdColumn = false;
                    hasNewFields = headerFields.length >= 36;
                    Log.i(TAG, "Detected OpenGD77 format (" + headerFields.length + " fields, newFields=" + hasNewFields + ")");
                } else {
                    Log.w(TAG, "Unknown CSV format: " + headerFields.length + " columns, first=" + headerFields[0]);
                }
            }
            
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
                boolean hasSeenActiveChannel = false; // Track to ensure only ONE channel is marked active
                
                // Build contact name => ID map for lookup
                java.util.Map<String, Integer> contactMap = buildContactNameMap(context);
                
                String line;
                int skippedCount = 0;
                while ((line = reader.readLine()) != null) {
                if (line.trim().isEmpty()) continue;
                
                String[] fields = parseCSVLine(line);
                
                // Adjust minimum field count based on format
                // Legacy: 29 with _id, 28 without
                // New: 37 with _id, 36 without
                int minFields;
                if (hasNewFields) {
                    minFields = hasIdColumn ? 37 : 36;
                } else {
                    minFields = hasIdColumn ? 29 : 28;
                }
                
                if (fields.length < minFields) {
                    Log.w(TAG, "Skipping invalid line (expected " + minFields + " fields, got " + fields.length + "): " + line);
                    skippedCount++;
                    continue;
                }
                
                // Field offset: skip _id column if present
                int offset = hasIdColumn ? 1 : 0;
                
                // Wrap each channel import in try-catch to handle parsing errors gracefully
                try {
                    ContentValues values = new ContentValues();
                    
                    // If _id column is present, preserve the original _id value
                    // This is critical for maintaining zone assignments (zones reference channels by _id)
                    if (hasIdColumn) {
                        String channelId = fields[0].trim();
                        values.put("_id", Integer.parseInt(channelId));
                    }
                    
                    // Channel Number -> channel_number
                    String channelNumber = fields[offset + 0].trim();
                    values.put("channel_number", Integer.parseInt(channelNumber));
                    
                    // Channel Name -> channel_name
                    String channelName = fields[offset + 1].trim();
                    values.put("channel_name", channelName);
                
                // Channel Type -> channel_type (Database uses: 0=Digital, 1=Analog)
                // Accept both "Digital"/"Analog" and "Digital"/"Analogue" spellings
                String channelType = fields[offset + 2].trim();
                boolean isDMR = channelType.equalsIgnoreCase("Digital");
                values.put("channel_type", isDMR ? "0" : "1");  // Database uses numeric values
                
                // Rx Frequency -> channel_rxFreq (MHz to Hz)
                String rxFreq = fields[offset + 3].trim().replace("\t", "");
                double rxFreqMHz = Double.parseDouble(rxFreq);
                long rxFreqHz = (long)(rxFreqMHz * 1000000);
                values.put("channel_rxFreq", rxFreqHz);
                
                // Tx Frequency -> channel_txFreq (MHz to Hz)
                String txFreq = fields[offset + 4].trim().replace("\t", "");
                values.put("channel_txFreq", (long)(Double.parseDouble(txFreq) * 1000000));
                
                // DMR-specific fields - ONLY set for Digital channels
                if (isDMR) {
                    // Color Code -> channel_cc
                    String ccStr = fields[offset + 6].trim();
                    int colorCode = ccStr.isEmpty() ? 1 : Integer.parseInt(ccStr);
                    values.put("channel_cc", colorCode);
                    
                    // Timeslot -> channel_inBoundSlot
                    // CONVERT OpenGD77 1-based to Android 0-based: 1→0, 2→1
                    String tsStr = fields[offset + 7].trim();
                    int timeslot = tsStr.isEmpty() ? 1 : Integer.parseInt(tsStr);
                    int timeslotApp = timeslot - 1;  // OpenGD77 1-based → Android 0-based
                    values.put("channel_inBoundSlot", timeslotApp);
                    
                    // Contact -> channel_txContact (lookup ID by name)
                    String contactName = fields[offset + 8].trim();
                    int contactId = getContactId(contactMap, contactName);
                    values.put("channel_txContact", contactId);
                    // TG List name (field 9) is stored for later assignment after rowId is known
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
                    String rxTone = fields[offset + 13].trim();
                    rxType = ToneConverter.parseType(rxTone);
                    rxSubCode = ToneConverter.parseSubCode(rxTone);
                } catch (Exception e) {
                    Log.w(TAG, "Error parsing RX Tone, using None: " + e.getMessage());
                }
                try {
                    String txTone = fields[offset + 14].trim();
                    txType = ToneConverter.parseType(txTone);
                    txSubCode = ToneConverter.parseSubCode(txTone);
                } catch (Exception e) {
                    Log.w(TAG, "Error parsing TX Tone, using None: " + e.getMessage());
                }
                
                // Squelch (15) - Read from CSV with OpenGD77 percentage conversion
                // OpenGD77 uses percentages (5%, 10%, 15%...95%) or "Normal", app uses 0-9
                int squelch = 0;
                try {
                    String sqStr = fields[offset + 15].trim();
                    // OpenGD77 "Normal" = mid-range squelch (use 5 = 45%)
                    if (sqStr.equalsIgnoreCase("Normal")) {
                        squelch = 5;
                    } else if (!sqStr.isEmpty() && !sqStr.equalsIgnoreCase("None") && !sqStr.equalsIgnoreCase("Disabled")) {
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
                    String powerStr = fields[offset + 16].trim();
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
                
                // NEW FIELDS: Read from CSV if available (backward compatible with old format)
                int encryptSw, relay, interrupt, active, outBoundSlot, channelMode, contactType;
                String encryptKey;
                
                if (hasNewFields && fields.length >= minFields) {
                    // Parse new fields from CSV (fields 28-35 for OpenGD77, 29-36 for Android with _id)
                    try {
                        encryptSw = Integer.parseInt(fields[offset + 28].trim());
                        // CONVERT OpenGD77 format to Android app format:
                        // OpenGD77: 0=disabled, 1=enabled
                        // Android: 0=uninitialized, 1=enabled, 2=disabled
                        if (encryptSw == 0) {
                            encryptSw = 2;  // OpenGD77 0 (disabled) → Android 2 (disabled)
                        }
                        // encryptSw == 1 stays as 1 (enabled in both)
                    } catch (Exception e) {
                        Log.w(TAG, "CH" + channelNumber + " encryptSw parse failed: " + e.getMessage());
                        encryptSw = isDMR ? 1 : 2;  // Default to disabled (2) not enabled
                    }
                    encryptKey = fields[offset + 29].trim();
                    try {
                        relay = Integer.parseInt(fields[offset + 30].trim());
                        // VALIDATE: Relay must ALWAYS be 1 for activation to work
                        if (relay != 1) {
                            Log.w(TAG, "CH" + channelNumber + " relay=" + relay + " is invalid, forcing to 1");
                            relay = 1;
                        }
                    } catch (Exception e) {
                        Log.w(TAG, "CH" + channelNumber + " relay parse failed: " + e.getMessage());
                        relay = 1;
                    }
                    try {
                        interrupt = Integer.parseInt(fields[offset + 31].trim());
                        // VALIDATE: Interrupt must match channel type (Digital=2, Analog=0)
                        int expectedInterrupt = isDMR ? 2 : 0;
                        if (interrupt != expectedInterrupt) {
                            Log.w(TAG, "CH" + channelNumber + " interrupt=" + interrupt + " wrong for " + 
                                (isDMR ? "Digital" : "Analog") + " channel, forcing to " + expectedInterrupt);
                            interrupt = expectedInterrupt;
                        }
                    } catch (Exception e) {
                        Log.w(TAG, "CH" + channelNumber + " interrupt parse failed: " + e.getMessage());
                        interrupt = isDMR ? 2 : 0;
                    }
                    try {
                        active = Integer.parseInt(fields[offset + 32].trim());
                    } catch (Exception e) {
                        Log.w(TAG, "CH" + channelNumber + " active parse failed: " + e.getMessage());
                        active = isDMR ? 1 : 0;
                    }
                    // Protection: Only allow ONE channel to be active (first one wins)
                    if (active == 1) {
                        if (hasSeenActiveChannel) {
                            active = 0; // Force to inactive if we've already seen an active channel
                            Log.w(TAG, "CH" + channelNumber + " marked as active but another channel is already active - setting to inactive");
                        } else {
                            hasSeenActiveChannel = true; // Mark that we've seen the first active channel
                            Log.i(TAG, "CH" + channelNumber + " marked as active channel (current loaded channel)");
                        }
                    }
                    try {
                        outBoundSlot = Integer.parseInt(fields[offset + 33].trim());
                    } catch (Exception e) {
                        outBoundSlot = 0;
                    }
                    try {
                        channelMode = Integer.parseInt(fields[offset + 34].trim());
                    } catch (Exception e) {
                        channelMode = 0;
                    }
                    try {
                        contactType = Integer.parseInt(fields[offset + 35].trim());
                    } catch (Exception e) {
                        contactType = 0;
                    }
                    
                    Log.i(TAG, "CH" + channelNumber + " validated fields: encrypt=" + encryptSw + ",relay=" + relay + ",interrupt=" + interrupt + ",active=" + active);
                } else {
                    // Legacy CSV format: use defaults based on channel type
                    if (isDMR) {
                        encryptSw = 1;
                        encryptKey = "";
                        relay = 1;
                        interrupt = 2;
                        active = 1;
                    } else {
                        encryptSw = 0;
                        encryptKey = "";
                        relay = 1;
                        interrupt = 0;
                        active = 0;
                    }
                    // Protection: Only allow ONE channel to be active (first one wins)
                    if (active == 1) {
                        if (hasSeenActiveChannel) {
                            active = 0; // Force to inactive if we've already seen an active channel
                            Log.w(TAG, "CH" + channelNumber + " would be active (legacy format) but another channel is already active - setting to inactive");
                        } else {
                            hasSeenActiveChannel = true; // Mark that we've seen the first active channel
                            Log.i(TAG, "CH" + channelNumber + " marked as active channel (current loaded channel, legacy format)");
                        }
                    }
                    outBoundSlot = 0;
                    channelMode = 0;
                    contactType = 0;
                }
                
                // Apply parsed or default values
                values.put("channel_encryptSw", encryptSw);
                if (!encryptKey.isEmpty() || isDMR) {
                    values.put("channel_encryptKey", encryptKey);
                }
                values.put("channel_relay", relay);
                values.put("channel_interrupt", interrupt);
                values.put("channel_active", active);
                values.put("channel_outBoundSlot", outBoundSlot);
                values.put("channel_mode", channelMode);
                values.put("channel_contactType", contactType);
                
                // NEW: Parse Rx Only/Zone Skip/All Skip/TOT/VOX/No Beep/No Eco fields (18-24)
                // These fields come from OpenGD77 CSV exports
                // If not present in CSV, safe defaults are used (0 for boolean, 0 for TOT)
                try {
                    // Column 18 (offset + 17): Rx Only
                    String rxOnlyStr = (fields.length > offset + 17) ? fields[offset + 17].trim() : "No";
                    int rxOnly = rxOnlyStr.equalsIgnoreCase("Yes") ? 1 : 0;
                    values.put("channel_rxOnly", rxOnly);
                    
                    // Column 19 (offset + 18): Zone Skip
                    String zoneSkipStr = (fields.length > offset + 18) ? fields[offset + 18].trim() : "No";
                    int zoneSkip = zoneSkipStr.equalsIgnoreCase("Yes") ? 1 : 0;
                    values.put("channel_zoneSkip", zoneSkip);
                    
                    // Column 20 (offset + 19): All Skip
                    String allSkipStr = (fields.length > offset + 19) ? fields[offset + 19].trim() : "No";
                    int allSkip = allSkipStr.equalsIgnoreCase("Yes") ? 1 : 0;
                    values.put("channel_allSkip", allSkip);
                    
                    // Column 21 (offset + 20): TOT (Time-Out Timer, in seconds)
                    String totStr = (fields.length > offset + 20) ? fields[offset + 20].trim() : "0";
                    int tot = totStr.isEmpty() ? 0 : Integer.parseInt(totStr);
                    values.put("channel_tot", tot);
                    
                    // Column 22 (offset + 21): VOX (Voice-Activated Transmit)
                    String voxStr = (fields.length > offset + 21) ? fields[offset + 21].trim() : "Off";
                    int vox = voxStr.equalsIgnoreCase("On") ? 1 : 0;
                    values.put("channel_vox", vox);
                    
                    // Column 23 (offset + 22): No Beep
                    String noBeepStr = (fields.length > offset + 22) ? fields[offset + 22].trim() : "No";
                    int noBeep = noBeepStr.equalsIgnoreCase("Yes") ? 1 : 0;
                    values.put("channel_noBeep", noBeep);
                    
                    // Column 24 (offset + 23): No Eco
                    String noEcoStr = (fields.length > offset + 23) ? fields[offset + 23].trim() : "No";
                    int noEco = noEcoStr.equalsIgnoreCase("Yes") ? 1 : 0;
                    values.put("channel_noEco", noEco);
                    
                    Log.i(TAG, "CH" + channelNumber + " imported flags: rxOnly=" + rxOnly + 
                        " zoneSkip=" + zoneSkip + " allSkip=" + allSkip + " tot=" + tot + 
                        " vox=" + vox + " noBeep=" + noBeep + " noEco=" + noEco);
                } catch (Exception e) {
                    // Graceful fallback: Use safe defaults (0) if parsing fails
                    // This is safe because most radios don't use these fields
                    Log.w(TAG, "CH" + channelNumber + " error parsing flags fields, using defaults: " + e.getMessage());
                    values.put("channel_rxOnly", 0);
                    values.put("channel_zoneSkip", 0);
                    values.put("channel_allSkip", 0);
                    values.put("channel_tot", 0);
                    values.put("channel_vox", 0);
                    values.put("channel_noBeep", 0);
                    values.put("channel_noEco", 0);
                }
                
                // Insert into database
                // If _id was provided in CSV, it will be preserved; otherwise auto-increment
                long rowId = db.insert("database_channel_area_default_uhf", null, values);
                if (rowId > 0) {
                    Log.i(TAG, "✓ Inserted channel " + channelNumber + ": " + channelName + " (ID: " + rowId + ")");
                }
                
                if (rowId == -1) {
                    Log.e(TAG, "FAILED to insert channel " + channelNumber + ": " + channelName);
                } else {
                    importCount++;
                    
                    // Store the rowId (_id) for zone and TG list import later
                    final long finalRowId = rowId;

                    // Assign TG list to this channel (DMR channels only, field 9)
                    if (isDMR) {
                        try {
                            String tgListName = (fields.length > offset + 9) ? fields[offset + 9].trim() : "";
                            if (!tgListName.isEmpty()
                                    && !tgListName.equalsIgnoreCase("None")
                                    && !tgListName.equalsIgnoreCase("-")) {
                                TGListDatabase tgListDb = TGListDatabase.getInstance(context);
                                TGListDatabase.TGList tgList = tgListDb.getTGListByName(tgListName);
                                if (tgList != null) {
                                    tgListDb.assignTGListToChannel((int) finalRowId, tgList.id);
                                    // Also write TG IDs directly into channel_groups so the native
                                    // firmware picks them up (mirrors the saveChannelData logic).
                                    int[] hwGroups = tgList.getHardwareGroups();
                                    StringBuilder groupsSb = new StringBuilder();
                                    for (int gi = 0; gi < hwGroups.length; gi++) {
                                        if (gi > 0) groupsSb.append(',');
                                        groupsSb.append(hwGroups[gi]);
                                    }
                                    ContentValues groupsUpdate = new ContentValues();
                                    groupsUpdate.put("channel_groups", groupsSb.toString());
                                    db.update("database_channel_area_default_uhf", groupsUpdate,
                                            "_id=?", new String[]{String.valueOf(finalRowId)});
                                    Log.i(TAG, "  Assigned TG list '" + tgListName + "' and wrote " + hwGroups.length + " TG IDs into channel_groups for channel " + channelNumber);
                                } else {
                                    Log.w(TAG, "  TG list '" + tgListName + "' not found for channel " + channelNumber);
                                }
                            }
                        } catch (Exception e) {
                            Log.w(TAG, "Could not assign TG list for channel " + channelNumber + ": " + e.getMessage());
                        }
                    }

                    // Import APRS setting to APRSDatabase if present
                    try {
                        int aprsFieldIndex = offset + 24;
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
                        int latFieldIndex = offset + 25;
                        int lonFieldIndex = offset + 26;
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
                
                } catch (NumberFormatException e) {
                    // Handle parsing errors for numbers (frequencies, channel number, etc.)
                    String channelInfo = fields.length > offset + 1 ? fields[offset + 1] : "unknown";
                    Log.e(TAG, "✗ Failed to parse numeric field for channel '" + channelInfo + "': " + e.getMessage());
                    skippedCount++;
                } catch (Exception e) {
                    // Handle any other errors during channel import
                    String channelInfo = fields.length > offset + 1 ? fields[offset + 1] : "unknown";
                    Log.e(TAG, "✗ Failed to import channel '" + channelInfo + "': " + e.getMessage());
                    skippedCount++;
                }
            }
            
            // Mark transaction as successful
            db.setTransactionSuccessful();
            if (skippedCount > 0) {
                Log.w(TAG, "⚠ Imported " + importCount + " channels, skipped " + skippedCount + " channels due to errors");
            } else {
                Log.i(TAG, "✓ Imported " + importCount + " channels");
            }
            
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
                // Clear existing contacts to prevent duplicates on reimport
                int deletedCount = db.delete("contact_database", null, null);
                Log.i(TAG, "Cleared " + deletedCount + " existing contacts before import");
                
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
        // delegate to internal method — this signature kept for call-site compatibility
        return importZonesInternal(context, csvFile);
    }

    /**
     * Import TG_Lists.csv into TGListDatabase.
     *
     * Format (OpenGD77 / DMRModHooks compatible):
     *   TG List Name,Contact1,Contact2,...,Contact32
     *
     * Each contact column may be either:
     *   - A numeric TG ID (preferred — as exported by DirectDatabaseExporter)
     *   - A contact name (OpenGD77 CPS — resolved via contact_database)
     *
     * Lists split into _partN rows on export are automatically re-merged.
     * Existing TG lists with the same name are replaced (upsert).
     */
    private static boolean importTGLists(Context context, File csvFile) {
        if (!csvFile.exists()) {
            Log.i(TAG, "No TG_Lists.csv found - skipping TG list import");
            return true;
        }
        BufferedReader reader = null;
        try {
            Log.i(TAG, "Importing TG lists from: " + csvFile.getAbsolutePath());

            // Build contact-name → DMR ID map for OpenGD77 codeplugs that store names
            java.util.Map<String, Integer> contactDmrIdMap = buildContactDmrIdMap(context);

            TGListDatabase tgListDb = TGListDatabase.getInstance(context);

            // Accumulate rows — multi-part rows are merged by stripping _partN suffix
            java.util.LinkedHashMap<String, java.util.ArrayList<Integer>> accumulated =
                    new java.util.LinkedHashMap<>();

            reader = new BufferedReader(new FileReader(csvFile));
            String header = reader.readLine(); // skip header
            if (header == null) {
                Log.i(TAG, "TG_Lists.csv is empty");
                return true;
            }

            String line;
            while ((line = reader.readLine()) != null) {
                line = line.trim();
                if (line.isEmpty()) continue;
                String[] fields = parseCSVLine(line);
                if (fields.length < 1) continue;

                String rawName = fields[0].trim();
                if (rawName.isEmpty()) continue;

                // Strip _partN suffix so multi-part rows are merged under one key
                String listName = rawName.replaceAll("_part\\d+$", "");

                java.util.ArrayList<Integer> tgIds = accumulated.get(listName);
                if (tgIds == null) {
                    tgIds = new java.util.ArrayList<>();
                    accumulated.put(listName, tgIds);
                }

                for (int i = 1; i < fields.length; i++) {
                    String cell = fields[i].trim();
                    if (cell.isEmpty()) continue;
                    try {
                        int tgId = Integer.parseInt(cell);
                        if (tgId > 0) tgIds.add(tgId);
                    } catch (NumberFormatException e) {
                        // Cell is a contact name — try to resolve to DMR ID
                        Integer dmrId = contactDmrIdMap.get(cell);
                        if (dmrId != null && dmrId > 0) tgIds.add(dmrId);
                        else Log.w(TAG, "TG_Lists: unresolved contact name '" + cell + "'");
                    }
                }
            }

            int listCount = 0;
            for (java.util.Map.Entry<String, java.util.ArrayList<Integer>> entry : accumulated.entrySet()) {
                String name = entry.getKey();
                java.util.ArrayList<Integer> ids = entry.getValue();
                StringBuilder sb = new StringBuilder();
                for (int i = 0; i < ids.size(); i++) {
                    if (i > 0) sb.append(',');
                    sb.append(ids.get(i));
                }
                tgListDb.saveTGList(name, sb.toString());
                Log.i(TAG, "✓ Imported TG list '" + name + "' with " + ids.size() + " TGs");
                listCount++;
            }

            Log.i(TAG, "TG list import complete: " + listCount + " lists");
            return true;
        } catch (Exception e) {
            Log.e(TAG, "Error importing TG_Lists.csv: " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            if (reader != null) try { reader.close(); } catch (Exception ignored) {}
        }
    }

    /** Build contactName → DMR-ID map from the stock contact_database for TG list resolution. */
    private static java.util.Map<String, Integer> buildContactDmrIdMap(Context context) {
        java.util.Map<String, Integer> map = new java.util.LinkedHashMap<>();
        android.database.sqlite.SQLiteDatabase db = null;
        android.database.Cursor c = null;
        try {
            java.io.File dbFile = context.getDatabasePath("contact_database.db");
            if (!dbFile.exists()) return map;
            db = android.database.sqlite.SQLiteDatabase.openDatabase(
                dbFile.getAbsolutePath(), null,
                android.database.sqlite.SQLiteDatabase.OPEN_READONLY);
            c = db.query("contact_database",
                new String[]{"contact_name", "contact_number"},
                null, null, null, null, null);
            if (c != null && c.moveToFirst()) {
                do {
                    String name = c.getString(0);
                    int dmrId  = c.getInt(1);
                    if (name != null && !name.isEmpty() && dmrId > 0) map.put(name, dmrId);
                } while (c.moveToNext());
            }
        } catch (Exception e) {
            Log.w(TAG, "buildContactDmrIdMap: " + e.getMessage());
        } finally {
            if (c != null) c.close();
            if (db != null) db.close();
        }
        return map;
    }

    private static boolean importZonesInternal(Context context, File csvFile) {
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
            
            // Build channel lookup maps
            java.util.Map<String, Integer> channelNameMap = buildChannelNameMap(context);
            java.util.Map<String, Integer> channelCompoundKeyMap = null;
            
            if (USE_COMPOUND_KEY_ZONES) {
                // Build compound key map for more reliable zone matching
                channelCompoundKeyMap = buildChannelCompoundKeyMap(context);
                Log.i(TAG, "Compound key zone matching enabled ("+channelCompoundKeyMap.size()+" keys)");
            }
            
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
                
                // Remaining fields (up to 80) are channel names (or compound keys)
                List<Integer> channelIds = new ArrayList<>();
                for (int i = 1; i < fields.length; i++) {
                    String channelRef = fields[i].trim();
                    if (channelRef.isEmpty()) {
                        continue; // Empty fields are normal (not all zones have 80 channels)
                    }
                    
                    // Try compound key lookup first (if enabled), then fall back to name
                    Integer channelId = null;
                    
                    if (USE_COMPOUND_KEY_ZONES && channelCompoundKeyMap != null && channelRef.contains("|")) {
                        // Format: "channelNum|frequency|name" - try exact compound key match
                        channelId = channelCompoundKeyMap.get(channelRef);
                        if (channelId != null) {
                            Log.d(TAG, "Zone '" + zoneName + "': Mapped compound key '" + channelRef + "' to ID " + channelId);
                        }
                    }
                    
                    // Fall back to name-only lookup (for backward compatibility)
                    if (channelId == null) {
                        channelId = channelNameMap.get(channelRef);
                        if (channelId != null) {
                            Log.d(TAG, "Zone '" + zoneName + "': Mapped channel '" + channelRef + "' to ID " + channelId);
                        } else {
                            Log.w(TAG, "Zone '" + zoneName + "': Channel '" + channelRef + "' not found in database");
                        }
                    }
                    
                    if (channelId != null) {
                        channelIds.add(channelId);
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
     * Build compound key map for zone matching: "channelNum|frequency|name" => channel ID
     * This provides more reliable zone restoration when channel_number is not unique.
     * 
     * @param context Application context
     * @return Map of compound keys to channel IDs
     */
    private static java.util.Map<String, Integer> buildChannelCompoundKeyMap(Context context) {
        java.util.Map<String, Integer> compoundKeyMap = new java.util.HashMap<>();
        SQLiteDatabase db = null;
        Cursor cursor = null;
        
        try {
            File dbFile = context.getDatabasePath("database_channel_area_default_uhf.db");
            if (!dbFile.exists()) {
                Log.w(TAG, "Channel database not found");
                return compoundKeyMap;
            }
            
            db = SQLiteDatabase.openDatabase(dbFile.getAbsolutePath(), null, 
                SQLiteDatabase.OPEN_READONLY);
            
            cursor = db.query("database_channel_area_default_uhf", 
                new String[]{"_id", "channel_number", "channel_rxFreq", "channel_name"}, 
                null, null, null, null, null);
            
            if (cursor != null && cursor.moveToFirst()) {
                do {
                    int id = cursor.getInt(0);
                    int channelNum = cursor.getInt(1);
                    long rxFreqHz = cursor.getLong(2);
                    String name = cursor.getString(3);
                    
                    // Convert frequency from Hz to MHz with 5 decimal places (e.g., 446.00625)
                    double rxFreqMHz = rxFreqHz / 1000000.0;
                    String freqStr = String.format("%.5f", rxFreqMHz);
                    
                    // Build compound key: "channelNum|frequency|name"
                    String compoundKey = channelNum + "|" + freqStr + "|" + name;
                    compoundKeyMap.put(compoundKey, id);
                } while (cursor.moveToNext());
            }
            
            Log.i(TAG, "Built " + compoundKeyMap.size() + " compound keys for zone import");
            
        } catch (Exception e) {
            Log.w(TAG, "Error building compound key map: " + e.getMessage());
        } finally {
            if (cursor != null) cursor.close();
            if (db != null) db.close();
        }
        
        return compoundKeyMap;
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
