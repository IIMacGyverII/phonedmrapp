package com.pri.prizeinterphone.data;

import android.content.ContentValues;
import android.content.Context;
import android.database.DatabaseErrorHandler;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

public class DBGroupHelper extends SQLiteOpenHelper {
    public static final String DB_GROUP_NAME = "group_database.db";
    public static final int DB_VERSION = 1;
    public static final String GROUP_NAME = "group_databas";

    public void onUpgrade(SQLiteDatabase sQLiteDatabase, int i, int i2) {
    }

    public DBGroupHelper(@Nullable Context context, @Nullable String str, @Nullable SQLiteDatabase.CursorFactory cursorFactory, int i) {
        super(context, str, cursorFactory, i);
    }

    public DBGroupHelper(@Nullable Context context, @Nullable String str, @Nullable SQLiteDatabase.CursorFactory cursorFactory, int i, @Nullable DatabaseErrorHandler databaseErrorHandler) {
        super(context, str, cursorFactory, i, databaseErrorHandler);
    }

    public DBGroupHelper(@Nullable Context context, @Nullable String str, int i, @NonNull SQLiteDatabase.OpenParams openParams) {
        super(context, str, i, openParams);
    }

    public DBGroupHelper(Context context) {
        super(context, "group_database.db", (SQLiteDatabase.CursorFactory) null, 1);
    }

    public void onCreate(SQLiteDatabase sQLiteDatabase) {
        sQLiteDatabase.execSQL("create table group_databas(_id integer primary key autoincrement, person_id varchar UNIQUE ON CONFLICT REPLACE, person_name varchar ,person_icon varchar )");
    }

    public void updateData(ContactData contactData) {
        new ContentValues();
    }
}
