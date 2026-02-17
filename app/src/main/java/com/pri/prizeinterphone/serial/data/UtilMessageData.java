package com.pri.prizeinterphone.serial.data;

import android.content.ContentValues;
import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.util.ArrayMap;
import java.util.ArrayList;
import java.util.Map;

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
        return Long.valueOf(this.mDB.insert(dbName, (String) null, contentValues));
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
        this.mDB.delete(getDbName(i, i2), (String) null, (String[]) null);
    }

    public ArrayList<MessageData> getAllSms(String str) {
        ArrayList<MessageData> arrayList = new ArrayList<>();
        Cursor query = this.mDB.query(this.mDBNameDefault, (String[]) null, "message_conv_target=?", new String[]{str}, (String) null, (String) null, (String) null);
        while (query.moveToNext()) {
            long j = (long) query.getInt(query.getColumnIndex(TABLE_ID));
            int i = query.getInt(query.getColumnIndex(TABLE_CONVTYPE));
            int i2 = query.getInt(query.getColumnIndex(TABLE_CONV_TARGET));
            int i3 = query.getInt(query.getColumnIndex(TABLE_FROM));
            int i4 = query.getInt(query.getColumnIndex(TABLE_TO));
            String string = query.getString(query.getColumnIndex(TABLE_CONTENT));
            Long valueOf = Long.valueOf(query.getLong(query.getColumnIndex(TABLE_TIMESTAMP)));
            arrayList.add(new MessageData(j, i, i2, i3, i4, string, query.getInt(query.getColumnIndex(TABLE_STATUS)), valueOf.longValue(), query.getInt(query.getColumnIndex(TABLE_DIRECTION))));
        }
        return arrayList;
    }

    public boolean isTableExist(String str) {
        SQLiteDatabase sQLiteDatabase = this.mDB;
        Cursor rawQuery = sQLiteDatabase.rawQuery("select name from sqlite_master where type='table' and name='" + str + "'", (String[]) null);
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
        if (!isTableExist(getDbName(i, i2))) {
            return null;
        }
        Cursor query = this.mDB.query(getDbName(i, i2), (String[]) null, (String) null, (String[]) null, (String) null, (String) null, "message_timestamp desc", "1");
        if (!query.moveToNext()) {
            return null;
        }
        long j = (long) query.getInt(query.getColumnIndex(TABLE_ID));
        int i3 = query.getInt(query.getColumnIndex(TABLE_CONVTYPE));
        int i4 = query.getInt(query.getColumnIndex(TABLE_CONV_TARGET));
        int i5 = query.getInt(query.getColumnIndex(TABLE_FROM));
        int i6 = query.getInt(query.getColumnIndex(TABLE_TO));
        String string = query.getString(query.getColumnIndex(TABLE_CONTENT));
        Long valueOf = Long.valueOf(query.getLong(query.getColumnIndex(TABLE_TIMESTAMP)));
        return new MessageData(j, i3, i4, i5, i6, string, query.getInt(query.getColumnIndex(TABLE_STATUS)), valueOf.longValue(), query.getInt(query.getColumnIndex(TABLE_DIRECTION)));
    }

    public ArrayList<MessageData> getAllSms(int i, int i2) {
        ArrayList<MessageData> arrayList = new ArrayList<>();
        if (!isTableExist(getDbName(i, i2))) {
            return arrayList;
        }
        SQLiteDatabase sQLiteDatabase = this.mDB;
        String dbName = getDbName(i, i2);
        Cursor query = sQLiteDatabase.query(dbName, (String[]) null, "message_to=? OR message_from=?", new String[]{i2 + "", i2 + ""}, (String) null, (String) null, TABLE_TIMESTAMP);
        while (query.moveToNext()) {
            long j = (long) query.getInt(query.getColumnIndex(TABLE_ID));
            int i3 = query.getInt(query.getColumnIndex(TABLE_CONVTYPE));
            int i4 = query.getInt(query.getColumnIndex(TABLE_CONV_TARGET));
            int i5 = query.getInt(query.getColumnIndex(TABLE_FROM));
            int i6 = query.getInt(query.getColumnIndex(TABLE_TO));
            String string = query.getString(query.getColumnIndex(TABLE_CONTENT));
            Long valueOf = Long.valueOf(query.getLong(query.getColumnIndex(TABLE_TIMESTAMP)));
            arrayList.add(new MessageData(j, i3, i4, i5, i6, string, query.getInt(query.getColumnIndex(TABLE_STATUS)), valueOf.longValue(), query.getInt(query.getColumnIndex(TABLE_DIRECTION))));
        }
        return arrayList;
    }

    public ArrayList<MessageData> getAllSms(int i) {
        ArrayList<MessageData> arrayList = new ArrayList<>();
        SQLiteDatabase sQLiteDatabase = this.mDB;
        String str = this.mDBNameDefault;
        Cursor query = sQLiteDatabase.query(str, (String[]) null, "message_conv_target=?", new String[]{i + ""}, (String) null, (String) null, (String) null);
        while (query.moveToNext()) {
            long j = (long) query.getInt(query.getColumnIndex(TABLE_ID));
            int i2 = query.getInt(query.getColumnIndex(TABLE_CONVTYPE));
            int i3 = query.getInt(query.getColumnIndex(TABLE_CONV_TARGET));
            int i4 = query.getInt(query.getColumnIndex(TABLE_FROM));
            int i5 = query.getInt(query.getColumnIndex(TABLE_TO));
            String string = query.getString(query.getColumnIndex(TABLE_CONTENT));
            Long valueOf = Long.valueOf(query.getLong(query.getColumnIndex(TABLE_TIMESTAMP)));
            arrayList.add(new MessageData(j, i2, i3, i4, i5, string, query.getInt(query.getColumnIndex(TABLE_STATUS)), valueOf.longValue(), query.getInt(query.getColumnIndex(TABLE_DIRECTION))));
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
        this.mDB.insert("message_list_database", (String) null, contentValues);
    }

    public void deleteListData(MessageListData messageListData) {
        SQLiteDatabase writableDatabase = this.mHelper.getWritableDatabase();
        this.mDB = writableDatabase;
        writableDatabase.delete("message_list_database", "message_list_id = ?", new String[]{messageListData.getId()});
    }

    public ArrayList<MessageListData> queryListData() {
        ArrayList<MessageListData> arrayList = new ArrayList<>();
        Cursor query = this.mDB.query("message_list_database", (String[]) null, (String) null, (String[]) null, (String) null, (String) null, (String) null);
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
        Cursor query = this.mDB.query("message_list_database", (String[]) null, "message_list_id=?", new String[]{str}, (String) null, (String) null, (String) null);
        if (query.moveToFirst()) {
            return new MessageListData(query.getString(query.getColumnIndex("message_list_id")), query.getString(query.getColumnIndex("message_list_value")));
        }
        return null;
    }

    public void resetData() {
        SQLiteDatabase writableDatabase = this.mHelper.getWritableDatabase();
        this.mDB = writableDatabase;
        Cursor rawQuery = writableDatabase.rawQuery("select name from sqlite_master where type='table'", (String[]) null);
        while (rawQuery.moveToNext()) {
            String string = rawQuery.getString(0);
            if (string.startsWith("message_db")) {
                this.mDB.delete(string, (String) null, (String[]) null);
            }
            SQLiteDatabase sQLiteDatabase = this.mDB;
            sQLiteDatabase.execSQL("delete from " + string);
        }
        rawQuery.close();
    }
}
