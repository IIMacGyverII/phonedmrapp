package com.pri.prizeinterphone.serial.data;

import android.content.ContentValues;
import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;
import android.util.Log;
import java.util.ArrayList;

public class UtilConversationData {
    public static final int ID_MAX = 16776415;
    public static final int ID_MIN = 2;
    public static final int INSERT = 1111;
    public static final String TABLE_CONVTARGET = "conver_target";
    public static final String TABLE_CONVTYPE = "conver_type";
    public static final String TABLE_ID = "conver_id";
    public static final String TABLE_NAME = "conver_name";
    public static final String TABLE_TIMESTAMP = "conver_timestamp";
    public static final String TABLE_UNREADCOUNT = "conver_unreadcount";
    public static final String TAG = "TAG_UtilConversationData";
    public static final int UPDATE = 1112;
    private SQLiteDatabase mDB;
    private String mDBName = DBConversationHelper.CONVERSATION_NAME;
    private SQLiteOpenHelper mHelper;

    public UtilConversationData(Context context) {
        this.mHelper = new DBConversationHelper(context);
    }

    public long addConversation(ConversationData conversationData) {
        this.mDB = this.mHelper.getWritableDatabase();
        ContentValues contentValues = new ContentValues();
        contentValues.put(TABLE_CONVTYPE, Integer.valueOf(conversationData.convType));
        contentValues.put(TABLE_CONVTARGET, Integer.valueOf(conversationData.convTarget));
        return this.mDB.insert(this.mDBName, (String) null, contentValues);
    }

    public void updateConverstion(ConversationData conversationData) {
        this.mDB = this.mHelper.getWritableDatabase();
        ContentValues contentValues = new ContentValues();
        contentValues.put(TABLE_ID, Integer.valueOf(conversationData._id));
        contentValues.put(TABLE_CONVTYPE, Integer.valueOf(conversationData.convType));
        contentValues.put(TABLE_CONVTARGET, Integer.valueOf(conversationData.convTarget));
        contentValues.put(TABLE_NAME, conversationData.name);
        contentValues.put(TABLE_TIMESTAMP, conversationData.timestamp);
        contentValues.put(TABLE_UNREADCOUNT, Integer.valueOf(conversationData.unReadCount));
        SQLiteDatabase sQLiteDatabase = this.mDB;
        String str = this.mDBName;
        sQLiteDatabase.update(str, contentValues, "conver_type=? AND conver_target=?", new String[]{conversationData.convType + "", conversationData.convTarget + ""});
    }

    public void deleteConverstion(ConversationData conversationData) {
        this.mDB = this.mHelper.getWritableDatabase();
        Log.i(TAG, "deleteConverstion: " + conversationData.toString());
        SQLiteDatabase sQLiteDatabase = this.mDB;
        String str = this.mDBName;
        sQLiteDatabase.delete(str, "conver_type=? AND conver_target=?", new String[]{conversationData.convType + "", conversationData.convTarget + ""});
    }

    public ConversationData getConversation(int i, int i2) {
        SQLiteDatabase writableDatabase = this.mHelper.getWritableDatabase();
        this.mDB = writableDatabase;
        String str = this.mDBName;
        Cursor query = writableDatabase.query(str, (String[]) null, "conver_type=? AND conver_target=?", new String[]{i + "", i2 + ""}, (String) null, (String) null, (String) null, "1");
        ConversationData conversationData = null;
        while (query.moveToNext()) {
            conversationData = new ConversationData(query.getInt(query.getColumnIndex(TABLE_ID)), query.getInt(query.getColumnIndex(TABLE_CONVTYPE)), query.getInt(query.getColumnIndex(TABLE_CONVTARGET)), query.getString(query.getColumnIndex(TABLE_NAME)), Long.valueOf(query.getLong(query.getColumnIndex(TABLE_TIMESTAMP))), query.getInt(query.getColumnIndex(TABLE_UNREADCOUNT)));
        }
        return conversationData;
    }

    public void deleteConversation(ConversationData conversationData) {
        SQLiteDatabase writableDatabase = this.mHelper.getWritableDatabase();
        this.mDB = writableDatabase;
        String str = this.mDBName;
        writableDatabase.delete(str, "conver_id = ?", new String[]{conversationData.getId() + ""});
    }

    public ArrayList<ConversationData> getAllConversations() {
        this.mDB = this.mHelper.getWritableDatabase();
        ArrayList<ConversationData> arrayList = new ArrayList<>();
        Cursor query = this.mDB.query(this.mDBName, (String[]) null, (String) null, (String[]) null, (String) null, (String) null, "conver_timestamp desc");
        while (query.moveToNext()) {
            arrayList.add(new ConversationData(query.getInt(query.getColumnIndex(TABLE_ID)), query.getInt(query.getColumnIndex(TABLE_CONVTYPE)), query.getInt(query.getColumnIndex(TABLE_CONVTARGET)), query.getString(query.getColumnIndex(TABLE_NAME)), Long.valueOf(query.getLong(query.getColumnIndex(TABLE_TIMESTAMP))), query.getInt(query.getColumnIndex(TABLE_UNREADCOUNT))));
        }
        return arrayList;
    }

    public void resetData() {
        SQLiteDatabase writableDatabase = this.mHelper.getWritableDatabase();
        this.mDB = writableDatabase;
        writableDatabase.delete(this.mDBName, (String) null, (String[]) null);
    }

    public void close() {
        SQLiteDatabase sQLiteDatabase = this.mDB;
        if (sQLiteDatabase != null) {
            sQLiteDatabase.close();
        }
    }
}
