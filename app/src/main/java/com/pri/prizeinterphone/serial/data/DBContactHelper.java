package com.pri.prizeinterphone.serial.data;

import android.content.ContentValues;
import android.content.Context;
import android.database.DatabaseErrorHandler;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

public class DBContactHelper extends SQLiteOpenHelper {
    public static final String CONTACT_NAME = "contact_database";
    public static final String DB_CONTACT_NAME = "contact_database.db";
    public static final int DB_VERSION = 1;

    public void onUpgrade(SQLiteDatabase sQLiteDatabase, int i, int i2) {
    }

    public DBContactHelper(@Nullable Context context, @Nullable String str, @Nullable SQLiteDatabase.CursorFactory cursorFactory, int i) {
        super(context, str, cursorFactory, i);
    }

    public DBContactHelper(@Nullable Context context, @Nullable String str, @Nullable SQLiteDatabase.CursorFactory cursorFactory, int i, @Nullable DatabaseErrorHandler databaseErrorHandler) {
        super(context, str, cursorFactory, i, databaseErrorHandler);
    }

    public DBContactHelper(@Nullable Context context, @Nullable String str, int i, @NonNull SQLiteDatabase.OpenParams openParams) {
        super(context, str, i, openParams);
    }

    public DBContactHelper(Context context) {
        super(context, DB_CONTACT_NAME, (SQLiteDatabase.CursorFactory) null, 1);
    }

    public void onCreate(SQLiteDatabase sQLiteDatabase) {
        sQLiteDatabase.execSQL("create table contact_database(_id integer primary key autoincrement, contact_name varchar ,contact_type integer ,contact_number varchar ,contact_active integer ,contact_icon varchar)");
    }

    public void updateData(ContactData contactData) {
        new ContentValues();
    }
}
