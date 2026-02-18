package com.pri.prizeinterphone.data;

import android.content.Context;
import android.database.DatabaseErrorHandler;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import com.pri.prizeinterphone.Util.UtilMessageData;
/* loaded from: classes4.dex */
public class DBMessageHelper extends SQLiteOpenHelper {
    public static final String DB_MESSAGE_NAME = "message_database.db";
    public static final int DB_VERSION = 1;
    public static final String MESSAGE_LIST_NAME = "message_list_database";
    public static final String MESSAGE_NAME = "message_db";
    private String messageId;
    private int type;

    public DBMessageHelper(@Nullable Context context, @Nullable String str, @Nullable SQLiteDatabase.CursorFactory cursorFactory, int i) {
        super(context, str, cursorFactory, i);
    }

    public DBMessageHelper(@Nullable Context context, @Nullable String str, @Nullable SQLiteDatabase.CursorFactory cursorFactory, int i, @Nullable DatabaseErrorHandler databaseErrorHandler) {
        super(context, str, cursorFactory, i, databaseErrorHandler);
    }

    public DBMessageHelper(@Nullable Context context, @Nullable String str, int i, @NonNull SQLiteDatabase.OpenParams openParams) {
        super(context, str, i, openParams);
    }

    public DBMessageHelper(String str, int i, Context context) {
        super(context, "message_database.db", (SQLiteDatabase.CursorFactory) null, 1);
        this.messageId = str;
        this.type = i;
    }

    @Override // android.database.sqlite.SQLiteOpenHelper
    public void onCreate(SQLiteDatabase sQLiteDatabase) {
        sQLiteDatabase.execSQL("CREATE TABLE IF NOT EXISTS message_db_" + this.type + "_" + this.messageId + "(_id integer primary key autoincrement, " + UtilMessageData.TABLE_TIME + " varchar UNIQUE ON CONFLICT REPLACE, " + UtilMessageData.TABLE_VALUE + " varchar ," + UtilMessageData.TABLE_RECIEVE + " varchar )");
        sQLiteDatabase.execSQL("CREATE TABLE IF NOT EXISTS message_list_database(_id integer primary key autoincrement, message_list_id varchar UNIQUE ON CONFLICT REPLACE, message_list_value varchar )");
    }

    @Override // android.database.sqlite.SQLiteOpenHelper
    public void onUpgrade(SQLiteDatabase sQLiteDatabase, int i, int i2) {
        sQLiteDatabase.execSQL("CREATE TABLE IF NOT EXISTS message_db_" + this.type + "_" + this.messageId + "(_id integer primary key autoincrement, " + UtilMessageData.TABLE_TIME + " varchar UNIQUE ON CONFLICT REPLACE, " + UtilMessageData.TABLE_VALUE + " varchar ," + UtilMessageData.TABLE_RECIEVE + " varchar )");
    }
}
