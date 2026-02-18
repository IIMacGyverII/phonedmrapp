package com.pri.prizeinterphone.serial.data;

import android.content.Context;
import android.database.DatabaseErrorHandler;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
/* loaded from: classes4.dex */
public class DBMessageHelper extends SQLiteOpenHelper {
    public static final String DB_MESSAGE_NAME = "message_database.db";
    public static final int DB_VERSION = 1;
    public static final String MESSAGE_LIST_NAME = "message_list_database";
    public static final String MESSAGE_NAME = "message_db";
    private String messageId;
    private int type;

    @Override // android.database.sqlite.SQLiteOpenHelper
    public void onCreate(SQLiteDatabase sQLiteDatabase) {
    }

    @Override // android.database.sqlite.SQLiteOpenHelper
    public void onUpgrade(SQLiteDatabase sQLiteDatabase, int i, int i2) {
    }

    public DBMessageHelper(@Nullable Context context, @Nullable String str, @Nullable SQLiteDatabase.CursorFactory cursorFactory, int i) {
        super(context, str, cursorFactory, i);
    }

    public DBMessageHelper(@Nullable Context context, @Nullable String str, @Nullable SQLiteDatabase.CursorFactory cursorFactory, int i, @Nullable DatabaseErrorHandler databaseErrorHandler) {
        super(context, str, cursorFactory, i, databaseErrorHandler);
    }

    public DBMessageHelper(@Nullable Context context, @Nullable String str, int i, @NonNull SQLiteDatabase.OpenParams openParams) {
        super(context, str, i, openParams);
    }

    public DBMessageHelper(Context context) {
        super(context, "message_database.db", (SQLiteDatabase.CursorFactory) null, 1);
    }

    public DBMessageHelper(int i, Context context) {
        super(context, "message_database.db", (SQLiteDatabase.CursorFactory) null, 1);
        this.type = i;
    }

    public void createTableIfNotExist(SQLiteDatabase sQLiteDatabase, String str) {
        sQLiteDatabase.execSQL("CREATE TABLE IF NOT EXISTS " + str + "(_id integer primary key autoincrement, " + UtilMessageData.TABLE_ID + " varchar ," + UtilMessageData.TABLE_CONVTYPE + " integer ," + UtilMessageData.TABLE_CONV_TARGET + " integer ," + UtilMessageData.TABLE_FROM + " integer ," + UtilMessageData.TABLE_TO + " integer ," + UtilMessageData.TABLE_CONTENT + " varchar ," + UtilMessageData.TABLE_STATUS + " integer ," + UtilMessageData.TABLE_TIMESTAMP + " varchar ," + UtilMessageData.TABLE_DIRECTION + " integer)");
    }
}
