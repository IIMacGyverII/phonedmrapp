package com.pri.prizeinterphone.serial.data;

import android.content.ContentValues;
import android.content.Context;
import android.database.DatabaseErrorHandler;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

public class DBConversationHelper extends SQLiteOpenHelper {
    public static final String CONVERSATION_NAME = "conversation_database";
    public static final String DB_CONVERSATION_NAME = "conversation_database.db";
    public static final int DB_VERSION = 1;

    public void onUpgrade(SQLiteDatabase sQLiteDatabase, int i, int i2) {
    }

    public DBConversationHelper(@Nullable Context context, @Nullable String str, @Nullable SQLiteDatabase.CursorFactory cursorFactory, int i) {
        super(context, str, cursorFactory, i);
    }

    public DBConversationHelper(@Nullable Context context, @Nullable String str, @Nullable SQLiteDatabase.CursorFactory cursorFactory, int i, @Nullable DatabaseErrorHandler databaseErrorHandler) {
        super(context, str, cursorFactory, i, databaseErrorHandler);
    }

    public DBConversationHelper(@Nullable Context context, @Nullable String str, int i, @NonNull SQLiteDatabase.OpenParams openParams) {
        super(context, str, i, openParams);
    }

    public DBConversationHelper(Context context) {
        super(context, DB_CONVERSATION_NAME, (SQLiteDatabase.CursorFactory) null, 1);
    }

    public void onCreate(SQLiteDatabase sQLiteDatabase) {
        sQLiteDatabase.execSQL("create table conversation_database(_id integer primary key autoincrement, conver_id varchar ,conver_type integer ,conver_target integer ,conver_name varchar ,conver_timestamp  varchar ,conver_unreadcount integer)");
    }

    public void updateData(ContactData contactData) {
        new ContentValues();
    }
}
