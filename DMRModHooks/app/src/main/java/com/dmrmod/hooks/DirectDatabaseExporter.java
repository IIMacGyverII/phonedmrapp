package com.dmrmod.hooks;

import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.os.Environment;
import android.util.Log;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.FileWriter;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

/**
 * DirectDatabaseExporter - Export DMR data to OpenGD77-compatible CSV files
 * 
 * DESIGN:
 * - Runs directly in the target app's process with full database access
 * - No need for shell commands or IPC - direct SQLite access
 * - Exports to Download/DMR/DMR_Backups/ for easy user access via file manager
 * 
 * OPENGD77 COMPATIBILITY:
 * - Generates 5 CSV files required by OpenGD77 CPS (Channels, Contacts, TG_Lists, Zones, DTMF)
 * - Uses exact column headers and format expected by OpenGD77
 * - Supports both Digital (DMR) and Analog (FM) channel types
 * - Frequencies converted from Hz (database) to MHz (CSV)
 * 
 * OUTPUT FORMAT:
 * - Files timestamped: Channels_20260223_140530.csv
 * - Windows CRLF line endings (\r\n) for OpenGD77 compatibility
 * - UTF-8 encoding for international character support
 */
public class DirectDatabaseExporter {
    
    private static final String TAG = "DMRModHooks_DirectExport";
    
    // === COMPOUND KEY ZONE MATCHING FEATURE FLAG ===
    // Set to true to enable compound key (channelNum|freq|name) zone export
    // Set to false to revert to simple name-only export (OpenGD77 compatible)
    // MUST match the setting in DirectDatabaseImporter for proper round-trip
    private static final boolean USE_COMPOUND_KEY_ZONES = false;
    // ==============================================
    
    /**
     * Migrate old backups from Download/DMR_Backups/ to Download/DMR/DMR_Backups/
     * This is called automatically on first export to organize existing backups
     */
    private static void migrateOldBackups() {
        try {
            File downloadDir = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOWNLOADS);
            File oldBackupDir = new File(downloadDir, "DMR_Backups");
            File newBackupDir = new File(downloadDir, "DMR/DMR_Backups");
            
            // Check if old backup folder exists
            if (!oldBackupDir.exists()) {
                Log.i(TAG, "No old backups to migrate");
                return;
            }
            
            // Create new backup directory structure if it doesn't exist
            if (!newBackupDir.exists()) {
                newBackupDir.mkdirs();
                Log.i(TAG, "Created new backup directory: " + newBackupDir.getAbsolutePath());
            }
            
            // Get all backup folders from old location
            File[] oldBackups = oldBackupDir.listFiles();
            if (oldBackups == null || oldBackups.length == 0) {
                Log.i(TAG, "Old backup folder is empty, deleting it");
                oldBackupDir.delete();
                return;
            }
            
            // Move each backup folder to new location
            int movedCount = 0;
            for (File backupFolder : oldBackups) {
                if (backupFolder.isDirectory()) {
                    File newLocation = new File(newBackupDir, backupFolder.getName());
                    if (backupFolder.renameTo(newLocation)) {
                        Log.i(TAG, "Migrated backup: " + backupFolder.getName());
                        movedCount++;
                    } else {
                        Log.w(TAG, "Failed to migrate backup: " + backupFolder.getName());
                    }
                }
            }
            
            // Delete old backup folder if it's now empty
            File[] remaining = oldBackupDir.listFiles();
            if (remaining == null || remaining.length == 0) {
                if (oldBackupDir.delete()) {
                    Log.i(TAG, "Deleted empty old backup folder");
                } else {
                    Log.w(TAG, "Could not delete old backup folder (may have system files)");
                }
            }
            
            Log.i(TAG, "Migration complete: " + movedCount + " backups moved to new location");
            
        } catch (Exception e) {
            Log.e(TAG, "Error during backup migration: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    // OpenGD77 CSV Headers (37 columns - includes _id and all database fields)
    private static final String CHANNELS_HEADER = 
        "_id,Channel Number,Channel Name,Channel Type,Rx Frequency,Tx Frequency,Bandwidth (kHz)," +
        "Colour Code,Timeslot,Contact,TG List,DMR ID,TS1_TA_Tx,TS2_TA_Tx ID,RX Tone,TX Tone," +
        "Squelch,Power,Rx Only,Zone Skip,All Skip,TOT,VOX,No Beep,No Eco,APRS,Latitude,Longitude,Use Location," +
        "Encrypt Switch,Encrypt Key,Relay,Interrupt,Active,Outbound Slot,Channel Mode,Contact Type";
    
    private static final String CONTACTS_HEADER = "Contact Name,ID,ID Type,TS Override";
    
    /**
     * Export channels and contacts directly from the app's own database
     * Called from within the hooked app context
     */
    public static boolean exportFromAppContext(Context appContext) {
        try {
            Log.i(TAG, "Starting direct export from app context");
            
            // Migrate old backups to new location if they exist
            migrateOldBackups();
            
            // Output to Download/DMR/DMR_Backups for easy user access
            // Using Environment.DIRECTORY_DOWNLOADS ensures compatibility across Android versions
            File downloadDir = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOWNLOADS);
            File baseBackupDir = new File(downloadDir, "DMR/DMR_Backups");
            if (!baseBackupDir.exists()) {
                baseBackupDir.mkdirs();
            }
            
            // Create timestamped folder for this backup set
            String timestamp = new java.text.SimpleDateFormat("yyyyMMdd_HHmmss", Locale.US)
                .format(new java.util.Date());
            File outputDir = new File(baseBackupDir, timestamp);
            if (!outputDir.mkdirs()) {
                Log.e(TAG, "Failed to create backup folder: " + outputDir.getAbsolutePath());
                return false;
            }
            
            Log.i(TAG, "Created backup folder: " + outputDir.getAbsolutePath());
            
            // OpenGD77 CPS requires ALL 5 CSV files to be present for a valid codeplug
            // Even if empty, all files must exist or import will fail
            // Files now have simple names without timestamps (folder name IS the timestamp)
            File channelsFile = new File(outputDir, "Channels.csv");
            File contactsFile = new File(outputDir, "Contacts.csv");
            File tgListsFile = new File(outputDir, "TG_Lists.csv");
            File zonesFile = new File(outputDir, "Zones.csv");
            File dtmfFile = new File(outputDir, "DTMF.csv");
            
            // Export all 5 required CSV files
            boolean channelsOk = exportChannelsDirect(appContext, channelsFile);
            boolean contactsOk = exportContactsDirect(appContext, contactsFile);
            boolean tgListsOk = exportTGListsCSV(appContext, tgListsFile);
            boolean zonesOk = exportZonesCSV(appContext, zonesFile);
            boolean dtmfOk = exportDTMFCSV(dtmfFile);
            
            if (channelsOk && contactsOk && tgListsOk && zonesOk && dtmfOk) {
                Log.i(TAG, "✓ Export successful! All 5 OpenGD77 CSV files created:");
                Log.i(TAG, "  Channels: " + channelsFile.getAbsolutePath());
                Log.i(TAG, "  Contacts: " + contactsFile.getAbsolutePath());
                Log.i(TAG, "  TG_Lists: " + tgListsFile.getAbsolutePath());
                Log.i(TAG, "  Zones: " + zonesFile.getAbsolutePath());
                Log.i(TAG, "  DTMF: " + dtmfFile.getAbsolutePath());
                
                // Generate PDF summary with backup info and OpenGD77 instructions
                Log.i(TAG, "Generating PDF summary...");
                boolean pdfOk = PDFExporter.exportBackupSummary(appContext, outputDir);
                if (pdfOk) {
                    Log.i(TAG, "✓ PDF summary created successfully");
                } else {
                    Log.w(TAG, "⚠ PDF summary generation failed (CSV files unaffected)");
                }
                
                // Create zip archive of all backup files for easy transfer
                Log.i(TAG, "Creating backup archive...");
                boolean zipOk = createBackupZip(outputDir, timestamp);
                if (zipOk) {
                    Log.i(TAG, "✓ Backup archive created successfully");
                } else {
                    Log.w(TAG, "⚠ Backup archive creation failed (files unaffected)");
                }
                
                return true;
            } else {
                Log.e(TAG, "Export failed - channels:" + channelsOk + " contacts:" + contactsOk + 
                    " tgLists:" + tgListsOk + " zones:" + zonesOk + " dtmf:" + dtmfOk);
                return false;
            }
            
        } catch (Exception e) {
            Log.e(TAG, "Export error: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Create a zip archive of all backup files
     * Makes it easy to transfer the entire backup via USB, email, or cloud storage
     */
    private static boolean createBackupZip(File backupDir, String folderName) {
        try {
            File zipFile = new File(backupDir, "DMR_Backup_" + folderName + ".zip");
            FileOutputStream fos = new FileOutputStream(zipFile);
            ZipOutputStream zos = new ZipOutputStream(fos);
            
            // List of files to include in the zip
            String[] filesToZip = {
                "Channels.csv",
                "Contacts.csv",
                "TG_Lists.csv",
                "Zones.csv",
                "DTMF.csv",
                "Backup_Summary.pdf"
            };
            
            byte[] buffer = new byte[1024];
            
            for (String fileName : filesToZip) {
                File file = new File(backupDir, fileName);
                if (file.exists()) {
                    FileInputStream fis = new FileInputStream(file);
                    zos.putNextEntry(new ZipEntry(fileName));
                    
                    int length;
                    while ((length = fis.read(buffer)) > 0) {
                        zos.write(buffer, 0, length);
                    }
                    
                    zos.closeEntry();
                    fis.close();
                }
            }
            
            zos.close();
            fos.close();
            
            Log.i(TAG, "Zip archive created: " + zipFile.getAbsolutePath());
            return true;
            
        } catch (Exception e) {
            Log.e(TAG, "Error creating backup zip: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    private static boolean exportChannelsDirect(Context context, File outputFile) {
        SQLiteDatabase db = null;
        Cursor cursor = null;
        
        try {
            // Open UHF database only
            File dbFile = context.getDatabasePath("database_channel_area_default_uhf.db");
            Log.i(TAG, "Opening channel database: " + dbFile.getAbsolutePath());
            
            if (!dbFile.exists()) {
                Log.e(TAG, "Channel database not found");
                return false;
            }
            
            db = SQLiteDatabase.openDatabase(dbFile.getAbsolutePath(), null, 
                SQLiteDatabase.OPEN_READONLY);
            cursor = db.query("database_channel_area_default_uhf", null, null, null, 
                null, null, "channel_number ASC");
            
            // Initialize LocationDatabase for lat/lon queries
            LocationDatabase locationDb = LocationDatabase.getInstance(context);
            Log.i(TAG, "LocationDatabase initialized for export");
            
            int channelCount = cursor.getCount();
            if (channelCount == 0) {
                Log.w(TAG, "No channels found in database");
                return false;
            }
            
            Log.i(TAG, "Found " + channelCount + " channels");
            
            // Build contacts lookup map for efficient contact name resolution
            java.util.Map<Integer, String> contactMap = buildContactMap(context);

            // Build TG list name lookup map for channel export (channel _id → list name)
            TGListDatabase tgListDb = TGListDatabase.getInstance(context);
            
            // Write CSV header (use constant to ensure consistency)
            BufferedWriter writer = new BufferedWriter(new FileWriter(outputFile));
            writer.write(CHANNELS_HEADER);
            writer.write("\r\n");  // Windows CRLF for OpenGD77 compatibility
            
            // Export all channels
            if (cursor.moveToFirst()) {
                do {
                    // Read channel data
                    int channelId = cursor.getInt(cursor.getColumnIndex("_id"));
                    int channelNumber = cursor.getInt(cursor.getColumnIndex("channel_number"));
                    String channelName = cursor.getString(cursor.getColumnIndex("channel_name"));
                    String channelType = cursor.getString(cursor.getColumnIndex("channel_type"));
                    int rxFreqHz = cursor.getInt(cursor.getColumnIndex("channel_rxFreq"));
                    int txFreqHz = cursor.getInt(cursor.getColumnIndex("channel_txFreq"));
                    int colorCode = cursor.getInt(cursor.getColumnIndex("channel_cc"));
                    int timeslot = cursor.getInt(cursor.getColumnIndex("channel_inBoundSlot"));
                    int contactId = cursor.getInt(cursor.getColumnIndex("channel_txContact"));
                    int band = cursor.getInt(cursor.getColumnIndex("channel_band"));
                    int squelch = cursor.getInt(cursor.getColumnIndex("channel_sq"));
                    int power = cursor.getInt(cursor.getColumnIndex("channel_power"));
                    int rxType = cursor.getInt(cursor.getColumnIndex("channel_rxType"));
                    int rxSubCode = cursor.getInt(cursor.getColumnIndex("channel_rxSubCode"));
                    int txType = cursor.getInt(cursor.getColumnIndex("channel_txType"));
                    int txSubCode = cursor.getInt(cursor.getColumnIndex("channel_txSubCode"));
                    
                    // Read new fields for complete backup
                    int encryptSw = cursor.getInt(cursor.getColumnIndex("channel_encryptSw"));
                    String encryptKey = cursor.getString(cursor.getColumnIndex("channel_encryptKey"));
                    int relay = cursor.getInt(cursor.getColumnIndex("channel_relay"));
                    int interrupt = cursor.getInt(cursor.getColumnIndex("channel_interrupt"));
                    int active = cursor.getInt(cursor.getColumnIndex("channel_active"));
                    int outBoundSlot = cursor.getInt(cursor.getColumnIndex("channel_outBoundSlot"));
                    int channelMode = cursor.getInt(cursor.getColumnIndex("channel_mode"));
                    int contactType = cursor.getInt(cursor.getColumnIndex("channel_contactType"));
                    
                    // DIAGNOSTIC: Export ALL raw database columns for comparison
                    // This will help us find what changes when user edits+saves a channel
                    if (channelNumber <= 3 || channelNumber == 8 || channelNumber == 9 || channelNumber == 16) {
                        StringBuilder allFields = new StringBuilder();
                        allFields.append("CH").append(channelNumber).append(" ALL_FIELDS: ");
                        for (int i = 0; i < cursor.getColumnCount(); i++) {
                            String colName = cursor.getColumnName(i);
                            String value;
                            try {
                                value = cursor.getString(i);
                                if (value == null) value = "NULL";
                            } catch (Exception e) {
                                value = "ERROR";
                            }
                            allFields.append(colName).append("=").append(value).append(" | ");
                        }
                        Log.i(TAG, allFields.toString());
                    }
                
                // Use default name if channel name is null or empty
                if (channelName == null || channelName.trim().isEmpty()) {
                    channelName = "Channel" + channelNumber;
                }
                
                // Convert Hz to MHz for OpenGD77 - TAB-prefixed format
                String rxFreqMHz = String.format(Locale.US, "\t%.5f", rxFreqHz / 1000000.0);
                String txFreqMHz = String.format(Locale.US, "\t%.5f", txFreqHz / 1000000.0);
                
                // Database uses numeric values: 0=Digital/DMR, 1=Analog
                boolean isDigital = "0".equals(channelType);
                
                // VALIDATE critical activation fields before export
                // relay can be 0 (direct/APRS), 1 (relay disconnect), or 2 (normal/default)
                // Preserve actual value - do not force to 1 (which breaks transmit)
                if (relay != 0 && relay != 1 && relay != 2) {
                    Log.w(TAG, "CH" + channelNumber + " DB has invalid relay=" + relay + ", forcing to 2 (default)");
                    relay = 2;  // Use default from AnalogMessage/DigitalMessage constructors
                }
                
                // interrupt must be 2 for Digital, 0 for Analog
                int expectedInterrupt = isDigital ? 2 : 0;
                if (interrupt != expectedInterrupt) {
                    Log.w(TAG, "CH" + channelNumber + " DB has interrupt=" + interrupt + 
                        ", forcing to " + expectedInterrupt + " for " + (isDigital ? "Digital" : "Analog") + " export");
                    interrupt = expectedInterrupt;
                }
                
                // Determine bandwidth (blank for Digital, 12.5 for Analogue)
                String bandwidth = isDigital ? "" : "12.5";
                
                // Determine channel type for OpenGD77 (Analogue vs Digital)
                String csvChannelType = isDigital ? "Digital" : "Analogue";
                
                // Build CSV row (29 columns - includes _id for uniqueness)
                StringBuilder rowBuilder = new StringBuilder();
                rowBuilder.append(channelId).append(",");        // 1. _id (unique database ID)
                rowBuilder.append(channelNumber).append(",");    // 2. Channel Number
                rowBuilder.append(channelName).append(",");      // 3. Channel Name
                rowBuilder.append(csvChannelType).append(",");   // 3. Channel Type
                rowBuilder.append(rxFreqMHz).append(",");        // 4. Rx Frequency
                rowBuilder.append(txFreqMHz).append(",");        // 5. Tx Frequency
                rowBuilder.append(bandwidth).append(",");        // 6. Bandwidth (kHz)
                
                if (csvChannelType.equals("Digital")) {
                    // Digital channels
                    rowBuilder.append(colorCode).append(",");           // 7. Colour Code
                    // CONVERT Android 0-based timeslot to OpenGD77 1-based: 0→1, 1→2
                    int timeslotExport = timeslot + 1;
                    rowBuilder.append(timeslotExport).append(",");      // 8. Timeslot
                    // Look up contact name from ID
                    String contactName = getContactName(contactMap, contactId);
                    rowBuilder.append(contactName).append(",");         // 9. Contact
                    // Look up TG list assignment for this channel
                    String tgListName = tgListDb.getTGListNameForChannel(channelId);
                    rowBuilder.append(tgListName).append(",");           // 10. TG List
                    rowBuilder.append("None,");                          // 11. DMR ID
                    rowBuilder.append("Off,");                           // 12. TS1_TA_Tx
                    rowBuilder.append("Off,");                           // 13. TS2_TA_Tx ID
                    rowBuilder.append("");                               // 14. RX Tone (blank for digital)
                    rowBuilder.append(",");                              
                    rowBuilder.append("");                               // 15. TX Tone (blank for digital)
                    rowBuilder.append(",");                              
                    // Digital channels always have squelch disabled in OpenGD77
                    rowBuilder.append("Disabled").append(",");          // 16. Squelch (always Disabled for Digital)
                    // Convert power to OpenGD77 format: P1-P9
                    // App uses 0=low, 1=high. OpenGD77 uses P1 (lowest) to P9 (highest)
                    String powerStr = (power == 0) ? "P1" : "P9";
                    rowBuilder.append(powerStr).append(",");            // 17. Power
                    rowBuilder.append("No,");                            // 18. Rx Only
                    rowBuilder.append("No,");                            // 19. Zone Skip
                    rowBuilder.append("No,");                            // 20. All Skip
                    rowBuilder.append("0,");                             // 21. TOT
                    rowBuilder.append("Off,");                           // 22. VOX
                    rowBuilder.append("No,");                            // 23. No Beep
                    rowBuilder.append("No,");                            // 24. No Eco
                    
                    // Query APRSDatabase for APRS setting (Digital channels)
                    APRSDatabase aprsDb = APRSDatabase.getInstance(context);
                    String aprsStr = aprsDb.isEnabled(channelNumber) ? "TX" : "None";
                    rowBuilder.append(aprsStr).append(",");              // 25. APRS
                    
                    // Query LocationDatabase for lat/lon (Digital channels)
                    LocationDatabase.Location location = locationDb.getLocation(channelNumber);
                    if (location != null) {
                        rowBuilder.append(String.format(Locale.US, "%.6f", location.latitude)).append(",");
                        rowBuilder.append(String.format(Locale.US, "%.6f", location.longitude)).append(",");
                        rowBuilder.append("No");  // Use Location always "No" for compatibility
                    } else {
                        rowBuilder.append("0.128,");                         // 26. Latitude (default)
                        rowBuilder.append("0.008,");                         // 27. Longitude (default)
                        rowBuilder.append("No");                             // 28. Use Location
                    }
                    
                    // NEW FIELDS (29-36): Complete database backup
                    // CONVERT Android app format to OpenGD77 format:
                    // Android: 0=uninitialized, 1=enabled, 2=disabled
                    // OpenGD77: 0=disabled, 1=enabled
                    int encryptSwExport = (encryptSw == 1) ? 1 : 0;  // 1→1 (enabled), 0/2→0 (disabled)
                    rowBuilder.append(",").append(encryptSwExport);        // 29. Encrypt Switch
                    rowBuilder.append(",").append(encryptKey != null ? encryptKey : ""); // 30. Encrypt Key
                    rowBuilder.append(",").append(relay);                   // 31. Relay
                    rowBuilder.append(",").append(interrupt);               // 32. Interrupt
                    rowBuilder.append(",").append(active);                  // 33. Active (0=inactive, 1=active)
                    rowBuilder.append(",").append(outBoundSlot);            // 34. Outbound Slot
                    rowBuilder.append(",").append(channelMode);             // 35. Channel Mode
                    rowBuilder.append(",").append(contactType);             // 36. Contact Type
                } else {
                    // Analogue channels
                    rowBuilder.append(",,,,,,,");                       // 7-13. DMR fields (all blank)
                    // RX Tone - convert from database format to OpenGD77 CSV format
                    String rxTone = ToneConverter.toCSVFormat(rxType, rxSubCode);
                    rowBuilder.append(rxTone).append(",");             // 14. RX Tone (None/67.0/D023N/D023I)
                    // TX Tone - convert from database format to OpenGD77 CSV format
                    String txTone = ToneConverter.toCSVFormat(txType, txSubCode);
                    rowBuilder.append(txTone).append(",");             // 15. TX Tone (None/67.0/D023N/D023I)
                    // Convert squelch from app's 0-9 to OpenGD77 percentage format
                    // 0=Disabled, 1=5%, 2=15%, 3=25%, 4=35%, 5=45%, 6=55%, 7=65%, 8=75%, 9=85%
                    String squelchStr = (squelch == 0) ? "Disabled" : String.valueOf((squelch * 10) - 5);
                    rowBuilder.append(squelchStr).append(",");          // 16. Squelch (OpenGD77 percentage format)
                    // Convert power to OpenGD77 format: P1-P9
                    // App uses 0=low, 1=high. OpenGD77 uses P1 (lowest) to P9 (highest)
                    String powerStr = (power == 0) ? "P1" : "P9";
                    rowBuilder.append(powerStr).append(",");            // 17. Power
                    rowBuilder.append("No,");                            // 18. Rx Only
                    rowBuilder.append("No,");                            // 19. Zone Skip
                    rowBuilder.append("No,");                            // 20. All Skip
                    rowBuilder.append("0,");                             // 21. TOT
                    rowBuilder.append("Off,");                           // 22. VOX
                    rowBuilder.append("No,");                            // 23. No Beep
                    rowBuilder.append("No,");                            // 24. No Eco
                    
                    // Query APRSDatabase for APRS setting (Analog channels)
                    APRSDatabase aprsDb2 = APRSDatabase.getInstance(context);
                    String aprsStr2 = aprsDb2.isEnabled(channelNumber) ? "TX" : "None";
                    rowBuilder.append(aprsStr2).append(",");             // 25. APRS
                    
                    // Query LocationDatabase for lat/lon (Analog channels)
                    LocationDatabase.Location location = locationDb.getLocation(channelNumber);
                    if (location != null) {
                        rowBuilder.append(String.format(Locale.US, "%.6f", location.latitude)).append(",");
                        rowBuilder.append(String.format(Locale.US, "%.6f", location.longitude)).append(",");
                        rowBuilder.append("No");  // Use Location always "No" for compatibility
                    } else {
                        rowBuilder.append("0.128,");                         // 26. Latitude (default)
                        rowBuilder.append("0.008,");                         // 27. Longitude (default)
                        rowBuilder.append("No");                             // 28. Use Location
                    }
                    
                    // NEW FIELDS (29-36): Complete database backup
                    // NOTE: Analog channels do NOT support encryption
                    // Always export 0 (disabled) and empty key for analog
                    rowBuilder.append(",0");                                 // 29. Encrypt Switch (always 0/disabled for analog)
                    rowBuilder.append(",");                                  // 30. Encrypt Key (always empty for analog)
                    rowBuilder.append(",").append(relay);                   // 31. Relay
                    rowBuilder.append(",").append(interrupt);               // 32. Interrupt
                    rowBuilder.append(",").append(active);                  // 33. Active (0=inactive, 1=active)
                    rowBuilder.append(",").append(outBoundSlot);            // 34. Outbound Slot
                    rowBuilder.append(",").append(channelMode);             // 35. Channel Mode
                    rowBuilder.append(",").append(contactType);             // 36. Contact Type
                }
                
                writer.write(rowBuilder.toString());
                writer.write("\r\n");  // Windows CRLF for OpenGD77 compatibility
                
                } while (cursor.moveToNext());
            }
            
            writer.close();
            Log.i(TAG, "✓ Exported " + channelCount + " channels to: " + outputFile.getAbsolutePath());
            return true;
            
        } catch (Exception e) {
            Log.e(TAG, "Error exporting channels: " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            if (cursor != null) cursor.close();
            if (db != null) db.close();
        }
    }
    
    private static boolean exportContactsDirect(Context context, File outputFile) {
        SQLiteDatabase db = null;
        Cursor cursor = null;
        
        try {
            File dbFile = context.getDatabasePath("contact_database.db");
            Log.i(TAG, "Opening contact database: " + dbFile.getAbsolutePath());
            
            if (!dbFile.exists()) {
                Log.w(TAG, "Contact database not found: " + dbFile.getAbsolutePath());
                // Create empty contacts file
                BufferedWriter writer = new BufferedWriter(new FileWriter(outputFile));
                writer.write(CONTACTS_HEADER);
                writer.write("\r\n");  // Windows CRLF for OpenGD77 compatibility
                writer.close();
                return true;
            }
            
            db = SQLiteDatabase.openDatabase(dbFile.getAbsolutePath(), null, 
                SQLiteDatabase.OPEN_READONLY);
            
            // First, let's see what columns exist - query without ORDER BY
            cursor = db.query("contact_database", null, null, null, null, null, null);
            
            int contactCount = (cursor != null) ? cursor.getCount() : 0;
            Log.i(TAG, "Found " + contactCount + " contacts");
            
            // Log actual column names
            if (cursor != null && cursor.getCount() > 0) {
                String[] columnNames = cursor.getColumnNames();
                Log.i(TAG, "Contact table has " + columnNames.length + " columns:");
                for (int i = 0; i < columnNames.length; i++) {
                    Log.i(TAG, "  Column " + i + ": " + columnNames[i]);
                }
            }
            
            // Write CSV
            BufferedWriter writer = new BufferedWriter(new FileWriter(outputFile));
            writer.write(CONTACTS_HEADER);
            writer.write("\r\n");  // Windows CRLF for OpenGD77 compatibility
            
            // Use HashSet to track unique contacts and prevent duplicates
            java.util.HashSet<String> uniqueContacts = new java.util.HashSet<>();
            int duplicateCount = 0;
            
            if (cursor != null && cursor.getCount() > 0) {
                while (cursor.moveToNext()) {
                    String contactName = cursor.getString(cursor.getColumnIndex("contact_name"));
                    int dmrId = cursor.getInt(cursor.getColumnIndex("contact_number"));  // Fixed: was "dmr_id"
                    int contactType = cursor.getInt(cursor.getColumnIndex("contact_type"));
                    
                    String idType = (contactType == 0) ? "Group" : 
                                  (contactType == 1) ? "Private" : "All Call";
                    
                    // Build CSV row (4 columns)
                    String row = String.format(Locale.US, "%s,%d,%s,-",
                        contactName, dmrId, idType);
                    
                    // Only write if this contact is unique
                    if (uniqueContacts.add(row)) {
                        writer.write(row);
                        writer.write("\r\n");  // Windows CRLF for OpenGD77 compatibility
                    } else {
                        duplicateCount++;
                    }
                }
            }
            
            writer.close();
            Log.i(TAG, "✓ Contacts exported: " + uniqueContacts.size() + " unique contacts");
            if (duplicateCount > 0) {
                Log.i(TAG, "  Skipped " + duplicateCount + " duplicate contacts");
            }
            return true;
            
        } catch (Exception e) {
            Log.e(TAG, "Error exporting contacts: " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            if (cursor != null) cursor.close();
            if (db != null) db.close();
        }
    }
    
    /**
     * Export TG_Lists.csv — named TalkGroup lists stored in TGListDatabase.
     *
     * Format (OpenGD77 compatible):
     *   TG List Name,Contact1,Contact2,...,Contact32
     *
     * Each Contact column contains the numeric TG ID (not a contact name) so that the
     * values round-trip perfectly through our own importer without requiring a separate
     * contact lookup.  OpenGD77 CPS will import them as-is when the corresponding
     * numeric contacts exist in Contacts.csv.
     *
     * Lists with MORE than 32 TG IDs are written across multiple rows with the name
     * suffixed by "_partN" so no data is lost on export.
     */
    private static boolean exportTGListsCSV(Context context, File outputFile) {
        try {
            BufferedWriter writer = new BufferedWriter(new FileWriter(outputFile));

            // Header: TG List Name + 32 Contact columns (OpenGD77 format)
            StringBuilder header = new StringBuilder("TG List Name");
            for (int i = 1; i <= TGListDatabase.HARDWARE_MAX_GROUPS; i++) {
                header.append(",Contact").append(i);
            }
            writer.write(header.toString());
            writer.write("\r\n");  // Windows CRLF

            // Export all named TG lists from our database
            TGListDatabase tgListDb = TGListDatabase.getInstance(context);
            java.util.List<TGListDatabase.TGList> allLists = tgListDb.getAllTGLists();
            int rowsWritten = 0;

            for (TGListDatabase.TGList list : allLists) {
                java.util.List<Integer> ids = list.getTgIds();
                int total = ids.size();

                if (total == 0) {
                    // Write a row with empty contact columns so the list name is preserved
                    writer.write(escapeCsvField(list.name));
                    for (int i = 0; i < TGListDatabase.HARDWARE_MAX_GROUPS; i++) writer.write(",");
                    writer.write("\r\n");
                    rowsWritten++;
                    continue;
                }

                // Write one row per block of 32 TG IDs to avoid data loss
                int part = 1;
                for (int offset = 0; offset < total; offset += TGListDatabase.HARDWARE_MAX_GROUPS) {
                    String rowName = (total <= TGListDatabase.HARDWARE_MAX_GROUPS)
                            ? list.name  // single row — keep the exact list name
                            : list.name + "_part" + part;
                    writer.write(escapeCsvField(rowName));
                    for (int i = 0; i < TGListDatabase.HARDWARE_MAX_GROUPS; i++) {
                        writer.write(",");
                        int idx = offset + i;
                        if (idx < total) writer.write(String.valueOf(ids.get(idx)));
                    }
                    writer.write("\r\n");
                    rowsWritten++;
                    part++;
                }
            }

            writer.close();
            Log.i(TAG, "✓ TG_Lists exported: " + rowsWritten + " list rows → " + outputFile.getAbsolutePath());
            return true;
        } catch (Exception e) {
            Log.e(TAG, "Error exporting TG_Lists: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /** Escape a CSV field (wrap in quotes if it contains comma, quote, or newline). */
    private static String escapeCsvField(String value) {
        if (value == null) return "";
        if (value.contains(",") || value.contains("\"") || value.contains("\n")) {
            return "\"" + value.replace("\"", "\"\"") + "\"";
        }
        return value;
    }
    
    /**
     * Export Zones.csv - Channel Zones
     * OpenGD77 format: Zone Name,Channel1,Channel2,...,Channel80
     * 
     * Reads zones from ZoneDatabase and maps channel IDs (_id) to channel names.
     * If no zones exist, exports empty file (required by OpenGD77).
     */
    private static boolean exportZonesCSV(Context context, File outputFile) {
        BufferedWriter writer = null;
        
        try {
            // Build channel ID => channel reference map for export
            java.util.Map<Integer, String> channelMap;
            
            if (USE_COMPOUND_KEY_ZONES) {
                // Use compound key format for reliable zone restoration
                channelMap = buildChannelIdCompoundKeyMap(context);
                Log.i(TAG, "Using compound key format for zone export ("+channelMap.size()+" channels)");
            } else {
                // Use simple name-only format (OpenGD77 compatible)
                channelMap = buildChannelIdMap(context);
                Log.i(TAG, "Using name-only format for zone export (OpenGD77 compatible)");
            }
            
            writer = new BufferedWriter(new FileWriter(outputFile));
            
            // Header: Zone Name + 80 Channel columns
            StringBuilder header = new StringBuilder("Zone Name");
            for (int i = 1; i <= 80; i++) {
                header.append(",Channel").append(i);
            }
            writer.write(header.toString());
            writer.write("\r\n");  // Windows CRLF
            
            // Get zones from ZoneDatabase
            ZoneDatabase zoneDb = ZoneDatabase.getInstance(context);
            List<ZoneDatabase.Zone> zones = zoneDb.getAllZones();
            
            Log.i(TAG, "Exporting " + zones.size() + " zones to CSV");
            
            // Export each zone
            for (ZoneDatabase.Zone zone : zones) {
                StringBuilder line = new StringBuilder();
                line.append(zone.name);
                
                // Get channel list for this zone (contains _id values)
                List<Integer> channelIds = zone.getChannelList();
                
                // Write up to 80 channels (OpenGD77 limit)
                for (int i = 0; i < 80; i++) {
                    line.append(",");
                    if (i < channelIds.size()) {
                        int channelId = channelIds.get(i);
                        String channelName = channelMap.get(channelId);
                        if (channelName != null) {
                            line.append(channelName);
                        } else {
                            Log.w(TAG, "Zone '" + zone.name + "': Channel ID " + channelId + " not found in database");
                        }
                    }
                    // Empty fields for unused channel slots
                }
                
                writer.write(line.toString());
                writer.write("\r\n");  // Windows CRLF
                Log.i(TAG, "Exported zone: " + zone.name + " (" + channelIds.size() + " channels)");
            }
            
            writer.close();
            
            if (zones.size() > 0) {
                Log.i(TAG, "✓ Zones exported: " + zones.size() + " zones written to " + outputFile.getAbsolutePath());
            } else {
                Log.i(TAG, "✓ Zones exported: Empty file (no zones defined) - " + outputFile.getAbsolutePath());
            }
            return true;
            
        } catch (Exception e) {
            Log.e(TAG, "Error exporting Zones: " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            if (writer != null) {
                try {
                    writer.close();
                } catch (Exception e) {
                    // Ignore
                }
            }
        }
    }
    
    /**
     * Build a map of channel ID => channel name for zone export
     * 
     * @param context Application context
     * @return Map of channel IDs to names, or empty map if database doesn't exist
     */
    private static java.util.Map<Integer, String> buildChannelIdMap(Context context) {
        java.util.Map<Integer, String> channelMap = new java.util.HashMap<>();
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
                    channelMap.put(id, name);
                } while (cursor.moveToNext());
            }
            
            Log.i(TAG, "Loaded " + channelMap.size() + " channels for zone export");
            
        } catch (Exception e) {
            Log.w(TAG, "Error building channel ID map: " + e.getMessage());
        } finally {
            if (cursor != null) cursor.close();
            if (db != null) db.close();
        }
        
        return channelMap;
    }
    
    /**
     * Build compound key map for zone export: channel ID => "channelNum|frequency|name"
     * This provides more reliable zone restoration when channel_number is not unique.
     * 
     * @param context Application context
     * @return Map of channel IDs to compound keys
     */
    private static java.util.Map<Integer, String> buildChannelIdCompoundKeyMap(Context context) {
        java.util.Map<Integer, String> compoundKeyMap = new java.util.HashMap<>();
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
                    compoundKeyMap.put(id, compoundKey);
                } while (cursor.moveToNext());
            }
            
            Log.i(TAG, "Built " + compoundKeyMap.size() + " compound keys for zone export");
            
        } catch (Exception e) {
            Log.w(TAG, "Error building compound key map: " + e.getMessage());
        } finally {
            if (cursor != null) cursor.close();
            if (db != null) db.close();
        }
        
        return compoundKeyMap;
    }
    
    /**
     * Export DTMF.csv - DTMF Contacts (empty for now)
     * OpenGD77 requires this file to be present even if empty
     */
    private static boolean exportDTMFCSV(File outputFile) {
        try {
            BufferedWriter writer = new BufferedWriter(new FileWriter(outputFile));
            writer.write("Contact Name,Code");
            writer.write("\r\n");  // Windows CRLF
            writer.close();
            Log.i(TAG, "✓ DTMF exported: " + outputFile.getAbsolutePath());
            return true;
        } catch (Exception e) {
            Log.e(TAG, "Error exporting DTMF: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Build a map of contact ID => contact name for efficient lookup
     * 
     * @param context Application context
     * @return Map of contact IDs to names, or empty map if database doesn't exist
     */
    private static java.util.Map<Integer, String> buildContactMap(Context context) {
        java.util.Map<Integer, String> contactMap = new java.util.HashMap<>();
        SQLiteDatabase db = null;
        Cursor cursor = null;
        
        try {
            File dbFile = context.getDatabasePath("contact_database.db");
            if (!dbFile.exists()) {
                Log.w(TAG, "Contact database not found, contact names will show as 'None'");
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
                    contactMap.put(id, name);
                } while (cursor.moveToNext());
            }
            
            Log.i(TAG, "Loaded " + contactMap.size() + " contacts for lookup");
            
        } catch (Exception e) {
            Log.w(TAG, "Error building contact map: " + e.getMessage());
        } finally {
            if (cursor != null) cursor.close();
            if (db != null) db.close();
        }
        
        return contactMap;
    }
    
    /**
     * Get contact name by ID from the contact map
     * 
     * @param contactMap Map of contact IDs to names
     * @param contactId Contact ID to lookup
     * @return Contact name, or "None" if not found
     */
    private static String getContactName(java.util.Map<Integer, String> contactMap, int contactId) {
        if (contactId <= 0) {
            return "None";
        }
        String name = contactMap.get(contactId);
        return (name != null && !name.trim().isEmpty()) ? name : "None";
    }
}
