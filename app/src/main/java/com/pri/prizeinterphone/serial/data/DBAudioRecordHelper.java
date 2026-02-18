package com.pri.prizeinterphone.serial.data;

import android.content.Context;
import android.database.DatabaseErrorHandler;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
/* loaded from: classes4.dex */
public class DBAudioRecordHelper extends SQLiteOpenHelper {
    public static final String DB_RECORD_NAME = "record_database.db";
    public static final int DB_VERSION = 1;
    public static final String RECORD_NAME = "record_database";
    private int type;

    @Override // android.database.sqlite.SQLiteOpenHelper
    public void onUpgrade(SQLiteDatabase sQLiteDatabase, int i, int i2) {
    }

    public DBAudioRecordHelper(@Nullable Context context, @Nullable String str, @Nullable SQLiteDatabase.CursorFactory cursorFactory, int i) {
        super(context, str, cursorFactory, i);
    }

    public DBAudioRecordHelper(@Nullable Context context, @Nullable String str, @Nullable SQLiteDatabase.CursorFactory cursorFactory, int i, @Nullable DatabaseErrorHandler databaseErrorHandler) {
        super(context, str, cursorFactory, i, databaseErrorHandler);
    }

    public DBAudioRecordHelper(@Nullable Context context, @Nullable String str, int i, @NonNull SQLiteDatabase.OpenParams openParams) {
        super(context, str, i, openParams);
    }

    public DBAudioRecordHelper(Context context) {
        super(context, DB_RECORD_NAME, (SQLiteDatabase.CursorFactory) null, 1);
    }

    public DBAudioRecordHelper(int i, Context context) {
        super(context, DB_RECORD_NAME, (SQLiteDatabase.CursorFactory) null, 1);
        this.type = i;
    }

    @Override // android.database.sqlite.SQLiteOpenHelper
    public void onCreate(SQLiteDatabase sQLiteDatabase) {
        sQLiteDatabase.execSQL("CREATE TABLE IF NOT EXISTS record_database(_id integer primary key autoincrement, record_name varchar ,record_channelName varchar ,record_timestamp integer ,record_direction integer ,record_filePath varchar )");
    }
}
