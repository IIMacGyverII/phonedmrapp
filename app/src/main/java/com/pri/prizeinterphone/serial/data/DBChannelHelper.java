package com.pri.prizeinterphone.serial.data;

import android.content.ContentValues;
import android.content.Context;
import android.database.DatabaseErrorHandler;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;
import android.util.Log;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

public class DBChannelHelper extends SQLiteOpenHelper {
    public static final String CHANNEL_NAME = "database";
    public static final String DB_CHANNEL_NAME = "channel_database.db";
    public static final int DB_VERSION = 2;
    public static final String TABLE_ACTIVE = "channel_active";
    public static final String TABLE_BAND = "channel_band";
    public static final String TABLE_CC = "channel_cc";
    public static final String TABLE_CONTACTTYPE = "channel_contactType";
    public static final String TABLE_ENCRYPTKEY = "channel_encryptKey";
    public static final String TABLE_ENCRYPTSW = "channel_encryptSw";
    public static final String TABLE_GROUPS = "channel_groups";
    public static final String TABLE_ID = "channel_id";
    public static final String TABLE_INTERRUPT = "channel_interrupt";
    public static final String TABLE_NAME = "channel_name";
    public static final String TABLE_NUMBER = "channel_number";
    public static final String TABLE_POWER = "channel_power";
    public static final String TABLE_RXFREQ = "channel_rxFreq";
    public static final String TABLE_RXSUBCODE = "channel_rxSubCode";
    public static final String TABLE_RXTYPE = "channel_rxType";
    public static final String TABLE_Relay = "channel_relay";
    public static final String TABLE_SQ = "channel_sq";
    public static final String TABLE_TXCONTACT = "channel_txContact";
    public static final String TABLE_TXFREQ = "channel_txFreq";
    public static final String TABLE_TXSUBCODE = "channel_txSubCode";
    public static final String TABLE_TXTYPE = "channel_txType";
    public static final String TABLE_TYPE = "channel_type";
    public static final String TAG = "DBChannelHelper";
    public String name;

    public DBChannelHelper(@Nullable Context context, @Nullable String str, @Nullable SQLiteDatabase.CursorFactory cursorFactory, int i) {
        super(context, str, cursorFactory, i);
    }

    public DBChannelHelper(@Nullable Context context, @Nullable String str, @Nullable SQLiteDatabase.CursorFactory cursorFactory, int i, @Nullable DatabaseErrorHandler databaseErrorHandler) {
        super(context, str, cursorFactory, i, databaseErrorHandler);
    }

    public DBChannelHelper(@Nullable Context context, @Nullable String str, int i, @NonNull SQLiteDatabase.OpenParams openParams) {
        super(context, str, i, openParams);
    }

    public DBChannelHelper(Context context) {
        super(context, DB_CHANNEL_NAME, (SQLiteDatabase.CursorFactory) null, 2);
        Log.i(TAG, "DBChannelHelper: Context context " + context);
    }

    public DBChannelHelper(Context context, String str) {
        super(context, "database_" + str + ".db", (SQLiteDatabase.CursorFactory) null, 2);
        this.name = str;
        Log.i(TAG, "DBChannelHelper: Context context " + context);
    }

    public void onCreate(SQLiteDatabase sQLiteDatabase) {
        Log.i(TAG, "DBChannelHelper: onCreate");
        sQLiteDatabase.execSQL("create table " + "database_" + this.name + "(_id integer primary key autoincrement, " + "channel_name" + " varchar ," + "channel_type" + " integer ," + "channel_number" + " integer ," + "channel_txFreq" + " integer ," + "channel_rxFreq" + " integer ," + "channel_power" + " integer ," + "channel_cc" + " integer ," + UtilChannelData.TABLE_INBOUNDSLOT + " integer ," + UtilChannelData.TABLE_OUTBOUNDSLOT + " integer ," + UtilChannelData.TABLE_CHANNELMODE + " integer ," + "channel_contactType" + " integer ," + "channel_txContact" + " integer ," + "channel_encryptSw" + " integer ," + "channel_encryptKey" + " varchar ," + "channel_relay" + " integer ," + "channel_interrupt" + " integer ," + "channel_band" + " integer ," + "channel_sq" + " integer ," + "channel_rxType" + " integer ," + "channel_rxSubCode" + " integer ," + "channel_txType" + " integer ," + "channel_txSubCode" + " integer ," + "channel_active" + " integer ," + "channel_groups" + " varchar )");
    }

    public void onUpgrade(SQLiteDatabase sQLiteDatabase, int i, int i2) {
        Log.i(TAG, "DBChannelHelper: onUpgrade,oldVersion=" + i + ",newVersion=" + i2);
        if (i < 2) {
            sQLiteDatabase.execSQL("alter table " + "database_" + this.name + " add " + UtilChannelData.TABLE_INBOUNDSLOT + " integer");
            sQLiteDatabase.execSQL("alter table " + "database_" + this.name + " add " + UtilChannelData.TABLE_OUTBOUNDSLOT + " integer");
            sQLiteDatabase.execSQL("alter table " + "database_" + this.name + " add " + UtilChannelData.TABLE_CHANNELMODE + " integer");
        }
    }

    public void updateData(ContactData contactData) {
        new ContentValues();
    }
}
