package com.dmrmod.hooks;

import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.util.Log;

public class DiagnosticDatabaseDump {
    private static final String TAG = "DMRModHooks_Diagnostic";
    
    public static void dumpChannelInfo(Context context, int channelNumber) {
        try {
            String dbPath = context.getDatabasePath("database_channel_area_default_uhf.db").getAbsolutePath();
            SQLiteDatabase db = SQLiteDatabase.openDatabase(dbPath, null, SQLiteDatabase.OPEN_READONLY);
            
            String[] columns = db.rawQuery("PRAGMA table_info(database_channel_area_default_uhf)", null)
                .getColumnNames();
            
            Cursor cursor = db.query(
                "database_channel_area_default_uhf",
                null,
                "channel_number = ?",
                new String[]{String.valueOf(channelNumber)},
                null, null, null
            );
            
            if (cursor != null && cursor.moveToFirst()) {
                Log.d(TAG, "========== CHANNEL " + channelNumber + " DUMP ==========");
                
                for (String columnName : cursor.getColumnNames()) {
                    int columnIndex = cursor.getColumnIndex(columnName);
                    int type = cursor.getType(columnIndex);
                    String value;
                    
                    switch (type) {
                        case Cursor.FIELD_TYPE_INTEGER:
                            value = String.valueOf(cursor.getLong(columnIndex));
                            break;
                        case Cursor.FIELD_TYPE_STRING:
                            value = "\"" + cursor.getString(columnIndex) + "\"";
                            break;
                        case Cursor.FIELD_TYPE_NULL:
                            value = "NULL";
                            break;
                        case Cursor.FIELD_TYPE_FLOAT:
                            value = String.valueOf(cursor.getDouble(columnIndex));
                            break;
                        default:
                            value = "(unknown type)";
                    }
                    
                    Log.d(TAG, columnName + ": " + value);
                }
                
                cursor.close();
            }
            
            db.close();
        } catch (Exception e) {
            Log.e(TAG, "Error dumping channel info", e);
        }
    }
    
    public static void dumpMultipleChannels(Context context) {
        Log.d(TAG, "\n\n========== DIAGNOSTIC DATABASE DUMP ==========\n");
        Log.d(TAG, "Dumping channels 1, 8, 9, and 16 for comparison");
        Log.d(TAG, "(User says 1-8 are Digital, 9-16 are Analog)\n");
        
        dumpChannelInfo(context, 1);   // First  Digital
        dumpChannelInfo(context, 8);   // Last Digital
        dumpChannelInfo(context, 9);   // First Analog
        dumpChannelInfo(context, 16);  // Last Analog
        
        Log.d(TAG, "\n========== END DIAGNOSTIC DUMP ==========\n\n");
    }
}
