package com.pri.prizeinterphone.serial.data;

import android.content.ContentValues;
import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.util.ArrayMap;
import java.util.ArrayList;
import java.util.Map;
/* loaded from: classes4.dex */
public class UtilMessageData {
    public static final int RECIEVE = 1;
    public static final int SEND = 0;
    public static final String TABLE_CONTENT = "message_content";
    public static final String TABLE_CONVTYPE = "message_convType";
    public static final String TABLE_CONV_TARGET = "message_conv_target";
    public static final String TABLE_DIRECTION = "message_direction";
    public static final String TABLE_FROM = "message_from";
    public static final String TABLE_ID = "message_id";
    public static final String TABLE_LIST_ID = "message_list_id";
    public static final String TABLE_LIST_VALUE = "message_list_value";
    public static final String TABLE_STATUS = "message_status";
    public static final String TABLE_TIMESTAMP = "message_timestamp";
    public static final String TABLE_TO = "message_to";
    public static final String TAG = "TAG_UtilMessageData";
    private SQLiteDatabase mDB;
    private String mDBNameDefault;
    private DBMessageHelper mHelper;
    public Map<String, DBMessageHelper> messageTables = new ArrayMap();

    public UtilMessageData(Context context) {
        DBMessageHelper dBMessageHelper = new DBMessageHelper(context);
        this.mHelper = dBMessageHelper;
        this.mDBNameDefault = "message_db";
        this.mDB = dBMessageHelper.getWritableDatabase();
    }

    public Long addSms(MessageData messageData) {
        String dbName = getDbName(messageData.convType, messageData.conv_target);
        prepareDBTables(dbName);
        ContentValues contentValues = new ContentValues();
        contentValues.put(TABLE_ID, Long.valueOf(messageData.id));
        contentValues.put(TABLE_CONVTYPE, Integer.valueOf(messageData.convType));
        contentValues.put(TABLE_CONV_TARGET, Integer.valueOf(messageData.conv_target));
        contentValues.put(TABLE_FROM, Integer.valueOf(messageData.from));
        contentValues.put(TABLE_TO, Integer.valueOf(messageData.to));
        contentValues.put(TABLE_CONTENT, messageData.content);
        contentValues.put(TABLE_STATUS, Integer.valueOf(messageData.status));
        contentValues.put(TABLE_TIMESTAMP, Long.valueOf(messageData.timestamp));
        contentValues.put(TABLE_DIRECTION, Integer.valueOf(messageData.direction));
        return Long.valueOf(this.mDB.insert(dbName, null, contentValues));
    }

    public int updateSms(MessageData messageData) {
        String dbName = getDbName(messageData.convType, messageData.conv_target);
        prepareDBTables(dbName);
        ContentValues contentValues = new ContentValues();
        contentValues.put(TABLE_STATUS, Integer.valueOf(messageData.status));
        SQLiteDatabase sQLiteDatabase = this.mDB;
        return sQLiteDatabase.update(dbName, contentValues, "message_timestamp = ?", new String[]{messageData.getTimestamp() + ""});
    }

    public void prepareDBTables(String str) {
        this.mHelper.createTableIfNotExist(this.mDB, str);
    }

    public String getDbName(int i, int i2) {
        return "message_db_" + i + "_" + i2;
    }

    public void deleteSms(MessageData messageData) {
        this.mDB.delete(getDbName(messageData.getConvType(), messageData.getConv_target()), "message_timestamp = ?", new String[]{String.valueOf(messageData.getTimestamp())});
    }

    public void deleteAllSms(int i, int i2) {
        this.mDB.delete(getDbName(i, i2), null, null);
    }

    public ArrayList<MessageData> getAllSms(String str) {
        ArrayList<MessageData> arrayList = new ArrayList<>();
        Cursor query = this.mDB.query(this.mDBNameDefault, null, "message_conv_target=?", new String[]{str}, null, null, null);
        while (query.moveToNext()) {
            arrayList.add(new MessageData(query.getInt(query.getColumnIndex(TABLE_ID)), query.getInt(query.getColumnIndex(TABLE_CONVTYPE)), query.getInt(query.getColumnIndex(TABLE_CONV_TARGET)), query.getInt(query.getColumnIndex(TABLE_FROM)), query.getInt(query.getColumnIndex(TABLE_TO)), query.getString(query.getColumnIndex(TABLE_CONTENT)), query.getInt(query.getColumnIndex(TABLE_STATUS)), Long.valueOf(query.getLong(query.getColumnIndex(TABLE_TIMESTAMP))).longValue(), query.getInt(query.getColumnIndex(TABLE_DIRECTION))));
        }
        return arrayList;
    }

    public boolean isTableExist(String str) {
        SQLiteDatabase sQLiteDatabase = this.mDB;
        Cursor rawQuery = sQLiteDatabase.rawQuery("select name from sqlite_master where type='table' and name='" + str + "'", null);
        boolean z = false;
        while (rawQuery.moveToNext()) {
            if (rawQuery.getString(0).equals(str)) {
                z = true;
            }
        }
        rawQuery.close();
        return z;
    }

    public MessageData getLastSms(int i, int i2) {
        if (isTableExist(getDbName(i, i2))) {
            Cursor query = this.mDB.query(getDbName(i, i2), null, null, null, null, null, "message_timestamp desc", "1");
            if (query.moveToNext()) {
                return new MessageData(query.getInt(query.getColumnIndex(TABLE_ID)), query.getInt(query.getColumnIndex(TABLE_CONVTYPE)), query.getInt(query.getColumnIndex(TABLE_CONV_TARGET)), query.getInt(query.getColumnIndex(TABLE_FROM)), query.getInt(query.getColumnIndex(TABLE_TO)), query.getString(query.getColumnIndex(TABLE_CONTENT)), query.getInt(query.getColumnIndex(TABLE_STATUS)), Long.valueOf(query.getLong(query.getColumnIndex(TABLE_TIMESTAMP))).longValue(), query.getInt(query.getColumnIndex(TABLE_DIRECTION)));
            }
            return null;
        }
        return null;
    }

    public ArrayList<MessageData> getAllSms(int i, int i2) {
        ArrayList<MessageData> arrayList = new ArrayList<>();
        if (isTableExist(getDbName(i, i2))) {
            SQLiteDatabase sQLiteDatabase = this.mDB;
            String dbName = getDbName(i, i2);
            Cursor query = sQLiteDatabase.query(dbName, null, "message_to=? OR message_from=?", new String[]{i2 + "", i2 + ""}, null, null, TABLE_TIMESTAMP);
            while (query.moveToNext()) {
                arrayList.add(new MessageData(query.getInt(query.getColumnIndex(TABLE_ID)), query.getInt(query.getColumnIndex(TABLE_CONVTYPE)), query.getInt(query.getColumnIndex(TABLE_CONV_TARGET)), query.getInt(query.getColumnIndex(TABLE_FROM)), query.getInt(query.getColumnIndex(TABLE_TO)), query.getString(query.getColumnIndex(TABLE_CONTENT)), query.getInt(query.getColumnIndex(TABLE_STATUS)), Long.valueOf(query.getLong(query.getColumnIndex(TABLE_TIMESTAMP))).longValue(), query.getInt(query.getColumnIndex(TABLE_DIRECTION))));
            }
            return arrayList;
        }
        return arrayList;
    }

    public ArrayList<MessageData> getAllSms(int i) {
        ArrayList<MessageData> arrayList = new ArrayList<>();
        SQLiteDatabase sQLiteDatabase = this.mDB;
        String str = this.mDBNameDefault;
        Cursor query = sQLiteDatabase.query(str, null, "message_conv_target=?", new String[]{i + ""}, null, null, null);
        while (query.moveToNext()) {
            arrayList.add(new MessageData(query.getInt(query.getColumnIndex(TABLE_ID)), query.getInt(query.getColumnIndex(TABLE_CONVTYPE)), query.getInt(query.getColumnIndex(TABLE_CONV_TARGET)), query.getInt(query.getColumnIndex(TABLE_FROM)), query.getInt(query.getColumnIndex(TABLE_TO)), query.getString(query.getColumnIndex(TABLE_CONTENT)), query.getInt(query.getColumnIndex(TABLE_STATUS)), Long.valueOf(query.getLong(query.getColumnIndex(TABLE_TIMESTAMP))).longValue(), query.getInt(query.getColumnIndex(TABLE_DIRECTION))));
        }
        return arrayList;
    }

    public void close() {
        SQLiteDatabase sQLiteDatabase = this.mDB;
        if (sQLiteDatabase != null) {
            sQLiteDatabase.close();
        }
    }

    public void onUpgrade(int i, int i2) {
        SQLiteDatabase writableDatabase = this.mHelper.getWritableDatabase();
        this.mDB = writableDatabase;
        this.mHelper.onUpgrade(writableDatabase, i, i2);
    }

    public void insertList(MessageListData messageListData) {
        this.mDB = this.mHelper.getWritableDatabase();
        ContentValues contentValues = new ContentValues();
        contentValues.put("message_list_id", messageListData.id);
        contentValues.put("message_list_value", messageListData.value);
        this.mDB.insert("message_list_database", null, contentValues);
    }

    public void deleteListData(MessageListData messageListData) {
        SQLiteDatabase writableDatabase = this.mHelper.getWritableDatabase();
        this.mDB = writableDatabase;
        writableDatabase.delete("message_list_database", "message_list_id = ?", new String[]{messageListData.getId()});
    }

    public ArrayList<MessageListData> queryListData() {
        ArrayList<MessageListData> arrayList = new ArrayList<>();
        Cursor query = this.mDB.query("message_list_database", null, null, null, null, null, null);
        while (query.moveToNext()) {
            arrayList.add(new MessageListData(query.getString(query.getColumnIndex("message_list_id")), query.getString(query.getColumnIndex("message_list_value"))));
        }
        return arrayList;
    }

    public void updateListData(MessageListData messageListData, MessageListData messageListData2) {
        ContentValues contentValues = new ContentValues();
        contentValues.put("message_list_id", messageListData.id);
        contentValues.put("message_list_value", messageListData.value);
        this.mDB.update("message_list_database", contentValues, "message_list_id = ?", new String[]{messageListData2.getId()});
    }

    public MessageListData queryListData(String str) {
        Cursor query = this.mDB.query("message_list_database", null, "message_list_id=?", new String[]{str}, null, null, null);
        if (query.moveToFirst()) {
            return new MessageListData(query.getString(query.getColumnIndex("message_list_id")), query.getString(query.getColumnIndex("message_list_value")));
        }
        return null;
    }

    public void resetData() {
        SQLiteDatabase writableDatabase = this.mHelper.getWritableDatabase();
        this.mDB = writableDatabase;
        Cursor rawQuery = writableDatabase.rawQuery("select name from sqlite_master where type='table'", null);
        while (rawQuery.moveToNext()) {
            String string = rawQuery.getString(0);
            if (string.startsWith("message_db")) {
                this.mDB.delete(string, null, null);
            }
            SQLiteDatabase sQLiteDatabase = this.mDB;
            sQLiteDatabase.execSQL("delete from " + string);
        }
        rawQuery.close();
    }
}
