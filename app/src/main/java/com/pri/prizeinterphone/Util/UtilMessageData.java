package com.pri.prizeinterphone.Util;

import android.content.ContentValues;
import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;
import android.util.Log;
import com.pri.prizeinterphone.InterPhoneApplication;
import com.pri.prizeinterphone.data.DBMessageHelper;
import com.pri.prizeinterphone.data.MessageData;
import com.pri.prizeinterphone.data.MessageListData;
import java.util.ArrayList;

public class UtilMessageData {
    public static final int RECIEVE = 1;
    public static final int SEND = 0;
    public static final String TABLE_LIST_ID = "message_list_id";
    public static final String TABLE_LIST_VALUE = "message_list_value";
    public static final String TABLE_RECIEVE = "message_recieve";
    public static final String TABLE_TIME = "message_time";
    public static final String TABLE_VALUE = "message_value";
    private SQLiteDatabase mDB;
    private String mDBName;
    private SQLiteOpenHelper mHelper;

    public UtilMessageData(String str, int i, Context context) {
        this.mHelper = new DBMessageHelper(str, i, InterPhoneApplication.getContext());
        this.mDBName = "message_db_" + i + "_" + str;
    }

    public void insertData(MessageData messageData) {
        this.mDB = this.mHelper.getWritableDatabase();
        ContentValues contentValues = new ContentValues();
        contentValues.put(TABLE_TIME, messageData.time);
        contentValues.put(TABLE_VALUE, messageData.value);
        contentValues.put(TABLE_RECIEVE, Integer.valueOf(messageData.isRecieve));
        this.mDB.insert(this.mDBName, (String) null, contentValues);
    }

    public void deleteData(MessageData messageData) {
        SQLiteDatabase writableDatabase = this.mHelper.getWritableDatabase();
        this.mDB = writableDatabase;
        writableDatabase.delete(this.mDBName, "message_time = ?", new String[]{messageData.getTime()});
    }

    public void deleteAllData() {
        SQLiteDatabase writableDatabase = this.mHelper.getWritableDatabase();
        this.mDB = writableDatabase;
        writableDatabase.delete(this.mDBName, (String) null, (String[]) null);
    }

    public ArrayList<MessageData> queryData() {
        this.mDB = this.mHelper.getWritableDatabase();
        ArrayList<MessageData> arrayList = new ArrayList<>();
        Cursor query = this.mDB.query(this.mDBName, (String[]) null, (String) null, (String[]) null, (String) null, (String) null, (String) null);
        while (query.moveToNext()) {
            arrayList.add(new MessageData(query.getString(query.getColumnIndex(TABLE_TIME)), query.getString(query.getColumnIndex(TABLE_VALUE)), query.getInt(query.getColumnIndex(TABLE_RECIEVE))));
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
        this.mDB = this.mHelper.getWritableDatabase();
        ArrayList<MessageListData> arrayList = new ArrayList<>();
        Cursor query = this.mDB.query("message_list_database", (String[]) null, (String) null, (String[]) null, (String) null, (String) null, (String) null);
        while (query.moveToNext()) {
            arrayList.add(new MessageListData(query.getString(query.getColumnIndex("message_list_id")), query.getString(query.getColumnIndex("message_list_value"))));
        }
        return arrayList;
    }

    public void updateListData(MessageListData messageListData, MessageListData messageListData2) {
        this.mDB = this.mHelper.getWritableDatabase();
        ContentValues contentValues = new ContentValues();
        contentValues.put("message_list_id", messageListData.id);
        contentValues.put("message_list_value", messageListData.value);
        this.mDB.update("message_list_database", contentValues, "message_list_id = ?", new String[]{messageListData2.getId()});
    }

    public MessageListData queryListData(String str) {
        SQLiteDatabase writableDatabase = this.mHelper.getWritableDatabase();
        this.mDB = writableDatabase;
        Cursor query = writableDatabase.query("message_list_database", (String[]) null, "message_list_id=?", new String[]{str}, (String) null, (String) null, (String) null);
        if (!query.moveToFirst()) {
            return null;
        }
        Log.e("peisaisai", "cursor has data!");
        return new MessageListData(query.getString(query.getColumnIndex("message_list_id")), query.getString(query.getColumnIndex("message_list_value")));
    }
}
