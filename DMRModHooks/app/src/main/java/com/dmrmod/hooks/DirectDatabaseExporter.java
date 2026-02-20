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
 * DirectDatabaseExporter - Export DMR data directly from target app's process
 * This runs IN the target app with full database access
 */
public class DirectDatabaseExporter {
    
    private static final String TAG = "DMRModHooks_DirectExport";
    
    // OpenGD77 CSV Headers (28 columns - matches OpenGD77 CPS export format)
    private static final String CHANNELS_HEADER = 
        "Channel Number,Channel Name,Channel Type,Rx Frequency,Tx Frequency,Bandwidth (kHz)," +
        "Colour Code,Timeslot,Contact,TG List,DMR ID,TS1_TA_Tx,TS2_TA_Tx ID,RX Tone,TX Tone," +
        "Squelch,Power,Rx Only,Zone Skip,All Skip,TOT,VOX,No Beep,No Eco,APRS,Latitude,Longitude,Use Location";
    
    private static final String CONTACTS_HEADER = "Contact Name,ID,ID Type,TS Override";
    
    /**
     * Export channels and contacts directly from the app's own database
     * Called from within the hooked app context
     */
    public static boolean exportFromAppContext(Context appContext) {
        try {
            Log.i(TAG, "Starting direct export from app context");
            
            // Output to /sdcard where our module can access it
            File outputDir = new File("/sdcard/DMR_Backups");
            if (!outputDir.exists()) {
                outputDir.mkdirs();
            }
            
            String timestamp = new java.text.SimpleDateFormat("yyyyMMdd_HHmmss", Locale.US)
                .format(new java.util.Date());
            
            // OpenGD77 requires ALL 5 CSV files to be present
            File channelsFile = new File(outputDir, "Channels_" + timestamp + ".csv");
            File contactsFile = new File(outputDir, "Contacts_" + timestamp + ".csv");
            File tgListsFile = new File(outputDir, "TG_Lists_" + timestamp + ".csv");
            File zonesFile = new File(outputDir, "Zones_" + timestamp + ".csv");
            File dtmfFile = new File(outputDir, "DTMF_" + timestamp + ".csv");
            
            // Export all 5 required CSV files
            boolean channelsOk = exportChannelsDirect(appContext, channelsFile);
            boolean contactsOk = exportContactsDirect(appContext, contactsFile);
            boolean tgListsOk = exportTGListsCSV(tgListsFile);
            boolean zonesOk = exportZonesCSV(zonesFile);
            boolean dtmfOk = exportDTMFCSV(dtmfFile);
            
            if (channelsOk && contactsOk && tgListsOk && zonesOk && dtmfOk) {
                Log.i(TAG, "✓ Export successful! All 5 OpenGD77 CSV files created:");
                Log.i(TAG, "  Channels: " + channelsFile.getAbsolutePath());
                Log.i(TAG, "  Contacts: " + contactsFile.getAbsolutePath());
                Log.i(TAG, "  TG_Lists: " + tgListsFile.getAbsolutePath());
                Log.i(TAG, "  Zones: " + zonesFile.getAbsolutePath());
                Log.i(TAG, "  DTMF: " + dtmfFile.getAbsolutePath());
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
            
            int channelCount = cursor.getCount();
            if (channelCount == 0) {
                Log.w(TAG, "No channels found in database");
                return false;
            }
            
            Log.i(TAG, "Found " + channelCount + " channels");
            
            // Write CSV header
            BufferedWriter writer = new BufferedWriter(new FileWriter(outputFile));
            StringBuilder headerBuilder = new StringBuilder();
            headerBuilder.append("Channel Number,Channel Name,Channel Type,Rx Frequency,Tx Frequency,Bandwidth (kHz),");
            headerBuilder.append("Colour Code,Timeslot,Contact,TG List,DMR ID,TS1_TA_Tx,TS2_TA_Tx ID,RX Tone,TX Tone,");
            headerBuilder.append("Squelch,Power,Rx Only,Zone Skip,All Skip,TOT,VOX,No Beep,No Eco,APRS,Latitude,Longitude,Use Location");
            writer.write(headerBuilder.toString());
            writer.write("\r\n");  // Windows CRLF for OpenGD77 compatibility
            
            // Export all channels
            if (cursor.moveToFirst()) {
                do {
                    // Read channel data
                    int channelNumber = cursor.getInt(cursor.getColumnIndex("channel_number"));
                    String channelName = cursor.getString(cursor.getColumnIndex("channel_name"));
                    String channelType = cursor.getString(cursor.getColumnIndex("channel_type"));
                    int rxFreqHz = cursor.getInt(cursor.getColumnIndex("channel_rxFreq"));
                    int txFreqHz = cursor.getInt(cursor.getColumnIndex("channel_txFreq"));
                    int colorCode = cursor.getInt(cursor.getColumnIndex("channel_cc"));
                    int timeslot = cursor.getInt(cursor.getColumnIndex("channel_inBoundSlot"));
                    int contactId = cursor.getInt(cursor.getColumnIndex("channel_txContact"));
                    int band = cursor.getInt(cursor.getColumnIndex("channel_band"));
                    
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
                
                // Determine bandwidth (blank for Digital, 12.5 for Analogue)
                String bandwidth = isDigital ? "" : "12.5";
                
                // Determine channel type for OpenGD77 (Analogue vs Digital)
                String csvChannelType = isDigital ? "Digital" : "Analogue";
                
                // Build CSV row (28 columns) matching OpenGD77 CPS format exactly
                StringBuilder rowBuilder = new StringBuilder();
                rowBuilder.append(channelNumber).append(",");
                rowBuilder.append(channelName).append(",");
                rowBuilder.append(csvChannelType).append(",");
                rowBuilder.append(rxFreqMHz).append(",");
                rowBuilder.append(txFreqMHz).append(",");
                rowBuilder.append(bandwidth).append(",");
                
                if (csvChannelType.equals("Digital")) {
                    // Digital channels
                    rowBuilder.append(colorCode).append(",");           // 7. Colour Code
                    rowBuilder.append(timeslot).append(",");            // 8. Timeslot
                    rowBuilder.append("None,");                          // 9. Contact
                    rowBuilder.append("None,");                          // 10. TG List
                    rowBuilder.append("None,");                          // 11. DMR ID
                    rowBuilder.append("Off,");                           // 12. TS1_TA_Tx
                    rowBuilder.append("Off,");                           // 13. TS2_TA_Tx ID
                    rowBuilder.append(",");                              // 14. RX Tone (blank)
                    rowBuilder.append(",");                              // 15. TX Tone (blank)
                    rowBuilder.append(",");                              // 16. Squelch (blank)
                    rowBuilder.append("Master,");                        // 17. Power
                    rowBuilder.append("No,");                            // 18. Rx Only
                    rowBuilder.append("No,");                            // 19. Zone Skip
                    rowBuilder.append("No,");                            // 20. All Skip
                    rowBuilder.append("0,");                             // 21. TOT
                    rowBuilder.append("Off,");                           // 22. VOX
                    rowBuilder.append("No,");                            // 23. No Beep
                    rowBuilder.append("No,");                            // 24. No Eco
                    rowBuilder.append("None,");                          // 25. APRS
                    rowBuilder.append("0.128,");                         // 26. Latitude
                    rowBuilder.append("0.008,");                         // 27. Longitude
                    rowBuilder.append("No");                             // 28. Use Location
                } else {
                    // Analogue channels
                    rowBuilder.append(",,,,,,,");                       // 7-13. DMR fields (all blank)
                    rowBuilder.append("None,");                          // 14. RX Tone
                    rowBuilder.append("None,");                          // 15. TX Tone
                    rowBuilder.append("Disabled,");                      // 16. Squelch
                    rowBuilder.append("Master,");                        // 17. Power
                    rowBuilder.append("No,");                            // 18. Rx Only
                    rowBuilder.append("No,");                            // 19. Zone Skip
                    rowBuilder.append("No,");                            // 20. All Skip
                    rowBuilder.append("0,");                             // 21. TOT
                    rowBuilder.append("Off,");                           // 22. VOX
                    rowBuilder.append("No,");                            // 23. No Beep
                    rowBuilder.append("No,");                            // 24. No Eco
                    rowBuilder.append("None,");                          // 25. APRS
                    rowBuilder.append("0.128,");                         // 26. Latitude
                    rowBuilder.append("0.008,");                         // 27. Longitude
                    rowBuilder.append("No");                             // 28. Use Location
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
                    
                    writer.write(row);
                    writer.write("\r\n");  // Windows CRLF for OpenGD77 compatibility
                }
            }
            
            writer.close();
            Log.i(TAG, "✓ Contacts exported to: " + outputFile.getAbsolutePath());
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
     * Export TG_Lists.csv - Talk Group Lists (empty for now)
     * OpenGD77 requires this file to be present even if empty
     */
    private static boolean exportTGListsCSV(File outputFile) {
        try {
            BufferedWriter writer = new BufferedWriter(new FileWriter(outputFile));
            
            // Header: TG List Name + 32 Contact columns
            StringBuilder header = new StringBuilder("TG List Name");
            for (int i = 1; i <= 32; i++) {
                header.append(",Contact").append(i);
            }
            writer.write(header.toString());
            writer.write("\r\n");  // Windows CRLF
            
            writer.close();
            Log.i(TAG, "✓ TG_Lists exported: " + outputFile.getAbsolutePath());
            return true;
        } catch (Exception e) {
            Log.e(TAG, "Error exporting TG_Lists: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Export Zones.csv - Channel Zones (empty for now)
     * OpenGD77 requires this file to be present even if empty
     */
    private static boolean exportZonesCSV(File outputFile) {
        try {
            BufferedWriter writer = new BufferedWriter(new FileWriter(outputFile));
            
            // Header: Zone Name + 80 Channel columns
            StringBuilder header = new StringBuilder("Zone Name");
            for (int i = 1; i <= 80; i++) {
                header.append(",Channel").append(i);
            }
            writer.write(header.toString());
            writer.write("\r\n");  // Windows CRLF
            
            writer.close();
            Log.i(TAG, "✓ Zones exported: " + outputFile.getAbsolutePath());
            return true;
        } catch (Exception e) {
            Log.e(TAG, "Error exporting Zones: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
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
}
