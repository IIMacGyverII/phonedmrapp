package com.pri.prizeinterphone.serial.data;

import android.content.ContentValues;
import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.util.ArrayMap;
import java.util.ArrayList;
import java.util.Map;
/* loaded from: classes4.dex */
public class UtilRecordData {
    public static final int RECIEVE = 1;
    public static final int SEND = 0;
    public static final String TABLE_CHANNELNAME = "record_channelName";
    public static final String TABLE_DIRECTION = "record_direction";
    public static final String TABLE_FILEPATH = "record_filePath";
    public static final String TABLE_NAME = "record_name";
    public static final String TABLE_TIMESTAMP = "record_timestamp";
    public static final String TAG = "TAG_UtilMessageData";
    private SQLiteDatabase mDB;
    private String mDBNameDefault;
    private DBAudioRecordHelper mHelper;
    public Map<String, DBMessageHelper> messageTables = new ArrayMap();

    public UtilRecordData(Context context) {
        DBAudioRecordHelper dBAudioRecordHelper = new DBAudioRecordHelper(context);
        this.mHelper = dBAudioRecordHelper;
        this.mDBNameDefault = DBAudioRecordHelper.RECORD_NAME;
        this.mDB = dBAudioRecordHelper.getWritableDatabase();
    }

    public ArrayList<AudioRecordData> getAllRecordFiles() {
        ArrayList<AudioRecordData> arrayList = new ArrayList<>();
        Cursor query = this.mDB.query(this.mDBNameDefault, null, null, null, null, null, "record_timestamp desc");
        while (query.moveToNext()) {
            int i = query.getInt(query.getColumnIndex("_id"));
            String string = query.getString(query.getColumnIndex(TABLE_NAME));
            String string2 = query.getString(query.getColumnIndex(TABLE_CHANNELNAME));
            String string3 = query.getString(query.getColumnIndex(TABLE_FILEPATH));
            Long valueOf = Long.valueOf(query.getLong(query.getColumnIndex(TABLE_TIMESTAMP)));
            arrayList.add(new AudioRecordData(i, string, string2, valueOf.longValue(), query.getInt(query.getColumnIndex(TABLE_DIRECTION)), string3));
        }
        return arrayList;
    }

    public int removeRecordFile(AudioRecordData audioRecordData) {
        SQLiteDatabase sQLiteDatabase = this.mDB;
        String str = this.mDBNameDefault;
        return sQLiteDatabase.delete(str, "record_timestamp=?", new String[]{audioRecordData.getTimestamp() + ""});
    }

    public long addRecordData(AudioRecordData audioRecordData) {
        ContentValues contentValues = new ContentValues();
        contentValues.put(TABLE_NAME, audioRecordData.getName());
        return this.mDB.insert(this.mDBNameDefault, null, contentValues);
    }

    public int updateRecordData(AudioRecordData audioRecordData) {
        ContentValues contentValues = new ContentValues();
        contentValues.put("_id", Long.valueOf(audioRecordData.getId()));
        contentValues.put(TABLE_NAME, audioRecordData.getName());
        contentValues.put(TABLE_CHANNELNAME, audioRecordData.getChannelName());
        contentValues.put(TABLE_DIRECTION, Integer.valueOf(audioRecordData.getDirection()));
        contentValues.put(TABLE_TIMESTAMP, Long.valueOf(audioRecordData.getTimestamp()));
        contentValues.put(TABLE_FILEPATH, audioRecordData.getFilePath());
        SQLiteDatabase sQLiteDatabase = this.mDB;
        String str = this.mDBNameDefault;
        return sQLiteDatabase.update(str, contentValues, "_id = ?", new String[]{audioRecordData.getId() + ""});
    }
}
