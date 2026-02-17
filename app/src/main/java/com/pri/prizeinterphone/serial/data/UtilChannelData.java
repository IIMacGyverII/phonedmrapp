package com.pri.prizeinterphone.serial.data;

import android.content.ContentValues;
import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;
import com.android.internal.telephony.InboundSmsHandler;
import java.util.ArrayList;
import java.util.Arrays;

public class UtilChannelData {
    public static final int ID_MAX = 16776415;
    public static final int ID_MIN = 2;
    public static final int INSERT = 1111;
    public static final String TABLE_ACTIVE = "channel_active";
    public static final String TABLE_BAND = "channel_band";
    public static final String TABLE_CC = "channel_cc";
    public static final String TABLE_CHANNELMODE = "channel_mode";
    public static final String TABLE_CONTACTTYPE = "channel_contactType";
    public static final String TABLE_ENCRYPTKEY = "channel_encryptKey";
    public static final String TABLE_ENCRYPTSW = "channel_encryptSw";
    public static final String TABLE_GROUPS = "channel_groups";
    public static final String TABLE_ID = "_id";
    public static final String TABLE_INBOUNDSLOT = "channel_inBoundSlot";
    public static final String TABLE_INTERRUPT = "channel_interrupt";
    public static final String TABLE_NAME = "channel_name";
    public static final String TABLE_NUMBER = "channel_number";
    public static final String TABLE_OUTBOUNDSLOT = "channel_outBoundSlot";
    public static final String TABLE_POWER = "channel_power";
    public static final String TABLE_REALY = "channel_relay";
    public static final String TABLE_RXFREQ = "channel_rxFreq";
    public static final String TABLE_RXSUBCODE = "channel_rxSubCode";
    public static final String TABLE_RXTYPE = "channel_rxType";
    public static final String TABLE_SQ = "channel_sq";
    public static final String TABLE_TXCONTACT = "channel_txContact";
    public static final String TABLE_TXFREQ = "channel_txFreq";
    public static final String TABLE_TXSUBCODE = "channel_txSubCode";
    public static final String TABLE_TXTYPE = "channel_txType";
    public static final String TABLE_TYPE = "channel_type";
    public static final String TAG = "UtilChannelData";
    public static final int UPDATE = 1112;
    private SQLiteDatabase mDB;
    public String mDBName;
    public String mDataName;
    private SQLiteOpenHelper mHelper;

    public UtilChannelData(Context context) {
        this.mHelper = new DBChannelHelper(context);
        this.mDBName = DBChannelHelper.CHANNEL_NAME;
    }

    public UtilChannelData(Context context, String str) {
        this.mHelper = new DBChannelHelper(context, str);
        this.mDBName = "database_" + str;
        this.mDataName = str;
    }

    public void addChannel(ChannelData channelData) {
        this.mDB = this.mHelper.getWritableDatabase();
        ContentValues contentValues = new ContentValues();
        contentValues.put("channel_name", channelData.name);
        contentValues.put("channel_type", Integer.valueOf(channelData.type));
        contentValues.put("channel_number", Integer.valueOf(channelData.number));
        contentValues.put("channel_txFreq", Integer.valueOf(channelData.txFreq));
        contentValues.put("channel_rxFreq", Integer.valueOf(channelData.rxFreq));
        contentValues.put("channel_power", Integer.valueOf(channelData.power));
        contentValues.put("channel_cc", Integer.valueOf(channelData.cc));
        contentValues.put(TABLE_INBOUNDSLOT, Integer.valueOf(channelData.inBoundSlot));
        contentValues.put(TABLE_OUTBOUNDSLOT, Integer.valueOf(channelData.outBoundSlot));
        contentValues.put(TABLE_CHANNELMODE, Integer.valueOf(channelData.channelMode));
        contentValues.put("channel_contactType", Integer.valueOf(channelData.contactType));
        contentValues.put("channel_txContact", Integer.valueOf(channelData.txContact));
        contentValues.put("channel_encryptSw", Integer.valueOf(channelData.encryptSw));
        contentValues.put("channel_encryptKey", channelData.encryptKey);
        contentValues.put("channel_relay", Integer.valueOf(channelData.relay));
        contentValues.put("channel_interrupt", Integer.valueOf(channelData.interrupt));
        contentValues.put("channel_band", Integer.valueOf(channelData.band));
        contentValues.put("channel_sq", Integer.valueOf(channelData.sq));
        contentValues.put("channel_rxType", Integer.valueOf(channelData.rxType));
        contentValues.put("channel_rxSubCode", Integer.valueOf(channelData.rxSubCode));
        contentValues.put("channel_txType", Integer.valueOf(channelData.txType));
        contentValues.put("channel_txSubCode", Integer.valueOf(channelData.txSubCode));
        if (getActiveChannel() == null) {
            channelData.setActive(1);
        }
        contentValues.put("channel_active", Integer.valueOf(channelData.active));
        contentValues.put("channel_groups", coverGroupsString(channelData.groups));
        long insert = this.mDB.insert(this.mDBName, (String) null, contentValues);
        new ContentValues().put("_id", Long.valueOf(insert));
        int i = (int) insert;
        channelData.setId(i);
        channelData.setNumber(i);
        updateChannel(channelData);
    }

    public String coverGroupsString(int[] iArr) {
        if (iArr == null) {
            iArr = new int[32];
            Arrays.fill(iArr, 0);
            iArr[0] = 1;
        }
        String str = "";
        for (int i = 0; i < iArr.length; i++) {
            if (i == 0) {
                str = str + iArr[i];
            } else {
                str = str + "," + iArr[i];
            }
        }
        return str;
    }

    public int[] coverGroupInt(String str) {
        int[] iArr = new int[32];
        Arrays.fill(iArr, 0);
        iArr[0] = 1;
        if (str != null && !str.equals("")) {
            String[] split = str.split(",");
            for (int i = 0; i < split.length; i++) {
                iArr[i] = Integer.parseInt(split[i]);
            }
        }
        return iArr;
    }

    public void deleteChannel(ChannelData channelData) {
        SQLiteDatabase writableDatabase = this.mHelper.getWritableDatabase();
        this.mDB = writableDatabase;
        String str = this.mDBName;
        writableDatabase.delete(str, "_id = ?", new String[]{channelData.getId() + ""});
    }

    public ChannelData getChannelInfo(int i) {
        SQLiteDatabase writableDatabase = this.mHelper.getWritableDatabase();
        this.mDB = writableDatabase;
        String str = this.mDBName;
        Cursor query = writableDatabase.query(str, (String[]) null, InboundSmsHandler.SELECT_BY_ID, new String[]{i + ""}, (String) null, (String) null, (String) null, "1");
        ChannelData channelData = null;
        while (query.moveToNext()) {
            channelData = new ChannelData(query.getInt(query.getColumnIndex("_id")), query.getString(query.getColumnIndex("channel_name")), query.getInt(query.getColumnIndex("channel_type")), query.getInt(query.getColumnIndex("channel_number")), query.getInt(query.getColumnIndex("channel_txFreq")), query.getInt(query.getColumnIndex("channel_rxFreq")), query.getInt(query.getColumnIndex("channel_power")), query.getInt(query.getColumnIndex("channel_cc")), query.getColumnIndex(TABLE_INBOUNDSLOT) != -1 ? query.getInt(query.getColumnIndex(TABLE_INBOUNDSLOT)) : 0, query.getColumnIndex(TABLE_OUTBOUNDSLOT) != -1 ? query.getInt(query.getColumnIndex(TABLE_OUTBOUNDSLOT)) : 0, query.getColumnIndex(TABLE_CHANNELMODE) != -1 ? query.getInt(query.getColumnIndex(TABLE_CHANNELMODE)) : 0, query.getInt(query.getColumnIndex("channel_contactType")), query.getInt(query.getColumnIndex("channel_txContact")), query.getInt(query.getColumnIndex("channel_encryptSw")), query.getString(query.getColumnIndex("channel_encryptKey")), query.getInt(query.getColumnIndex("channel_relay")), query.getInt(query.getColumnIndex("channel_interrupt")), query.getInt(query.getColumnIndex("channel_band")), query.getInt(query.getColumnIndex("channel_sq")), query.getInt(query.getColumnIndex("channel_rxType")), query.getInt(query.getColumnIndex("channel_rxSubCode")), query.getInt(query.getColumnIndex("channel_txType")), query.getInt(query.getColumnIndex("channel_txSubCode")), query.getInt(query.getColumnIndex("channel_active")), coverGroupInt(query.getString(query.getColumnIndex("channel_groups"))));
        }
        return channelData;
    }

    public ChannelData getActiveChannel() {
        SQLiteDatabase writableDatabase = this.mHelper.getWritableDatabase();
        this.mDB = writableDatabase;
        Cursor query = writableDatabase.query(this.mDBName, (String[]) null, "channel_active=?", new String[]{"1"}, (String) null, (String) null, (String) null, "1");
        ChannelData channelData = null;
        while (query.moveToNext()) {
            channelData = new ChannelData(query.getInt(query.getColumnIndex("_id")), query.getString(query.getColumnIndex("channel_name")), query.getInt(query.getColumnIndex("channel_type")), query.getInt(query.getColumnIndex("channel_number")), query.getInt(query.getColumnIndex("channel_txFreq")), query.getInt(query.getColumnIndex("channel_rxFreq")), query.getInt(query.getColumnIndex("channel_power")), query.getInt(query.getColumnIndex("channel_cc")), query.getColumnIndex(TABLE_INBOUNDSLOT) != -1 ? query.getInt(query.getColumnIndex(TABLE_INBOUNDSLOT)) : 0, query.getColumnIndex(TABLE_OUTBOUNDSLOT) != -1 ? query.getInt(query.getColumnIndex(TABLE_OUTBOUNDSLOT)) : 0, query.getColumnIndex(TABLE_CHANNELMODE) != -1 ? query.getInt(query.getColumnIndex(TABLE_CHANNELMODE)) : 0, query.getInt(query.getColumnIndex("channel_contactType")), query.getInt(query.getColumnIndex("channel_txContact")), query.getInt(query.getColumnIndex("channel_encryptSw")), query.getString(query.getColumnIndex("channel_encryptKey")), query.getInt(query.getColumnIndex("channel_relay")), query.getInt(query.getColumnIndex("channel_interrupt")), query.getInt(query.getColumnIndex("channel_band")), query.getInt(query.getColumnIndex("channel_sq")), query.getInt(query.getColumnIndex("channel_rxType")), query.getInt(query.getColumnIndex("channel_rxSubCode")), query.getInt(query.getColumnIndex("channel_txType")), query.getInt(query.getColumnIndex("channel_txSubCode")), query.getInt(query.getColumnIndex("channel_active")), coverGroupInt(query.getString(query.getColumnIndex("channel_groups"))));
        }
        return channelData;
    }

    public ChannelData getChannel(int i) {
        SQLiteDatabase writableDatabase = this.mHelper.getWritableDatabase();
        this.mDB = writableDatabase;
        String str = this.mDBName;
        Cursor query = writableDatabase.query(str, (String[]) null, InboundSmsHandler.SELECT_BY_ID, new String[]{i + ""}, (String) null, (String) null, (String) null, "1");
        ChannelData channelData = null;
        while (query.moveToNext()) {
            channelData = new ChannelData(query.getInt(query.getColumnIndex("_id")), query.getString(query.getColumnIndex("channel_name")), query.getInt(query.getColumnIndex("channel_type")), query.getInt(query.getColumnIndex("channel_number")), query.getInt(query.getColumnIndex("channel_txFreq")), query.getInt(query.getColumnIndex("channel_rxFreq")), query.getInt(query.getColumnIndex("channel_power")), query.getInt(query.getColumnIndex("channel_cc")), query.getColumnIndex(TABLE_INBOUNDSLOT) != -1 ? query.getInt(query.getColumnIndex(TABLE_INBOUNDSLOT)) : 0, query.getColumnIndex(TABLE_OUTBOUNDSLOT) != -1 ? query.getInt(query.getColumnIndex(TABLE_OUTBOUNDSLOT)) : 0, query.getColumnIndex(TABLE_CHANNELMODE) != -1 ? query.getInt(query.getColumnIndex(TABLE_CHANNELMODE)) : 0, query.getInt(query.getColumnIndex("channel_contactType")), query.getInt(query.getColumnIndex("channel_txContact")), query.getInt(query.getColumnIndex("channel_encryptSw")), query.getString(query.getColumnIndex("channel_encryptKey")), query.getInt(query.getColumnIndex("channel_relay")), query.getInt(query.getColumnIndex("channel_interrupt")), query.getInt(query.getColumnIndex("channel_band")), query.getInt(query.getColumnIndex("channel_sq")), query.getInt(query.getColumnIndex("channel_rxType")), query.getInt(query.getColumnIndex("channel_rxSubCode")), query.getInt(query.getColumnIndex("channel_txType")), query.getInt(query.getColumnIndex("channel_txSubCode")), query.getInt(query.getColumnIndex("channel_active")), coverGroupInt(query.getString(query.getColumnIndex("channel_groups"))));
        }
        return channelData;
    }

    public ArrayList<ChannelData> getAllChannels() {
        this.mDB = this.mHelper.getWritableDatabase();
        ArrayList<ChannelData> arrayList = new ArrayList<>();
        Cursor query = this.mDB.query(this.mDBName, (String[]) null, (String) null, (String[]) null, (String) null, (String) null, (String) null);
        while (query.moveToNext()) {
            int i = query.getInt(query.getColumnIndex("_id"));
            String string = query.getString(query.getColumnIndex("channel_name"));
            int i2 = query.getInt(query.getColumnIndex("channel_type"));
            int i3 = query.getInt(query.getColumnIndex("channel_number"));
            int i4 = query.getInt(query.getColumnIndex("channel_txFreq"));
            int i5 = query.getInt(query.getColumnIndex("channel_rxFreq"));
            int i6 = query.getInt(query.getColumnIndex("channel_power"));
            int i7 = query.getInt(query.getColumnIndex("channel_cc"));
            int i8 = query.getColumnIndex(TABLE_INBOUNDSLOT) != -1 ? query.getInt(query.getColumnIndex(TABLE_INBOUNDSLOT)) : 0;
            ChannelData channelData = r4;
            ChannelData channelData2 = new ChannelData(i, string, i2, i3, i4, i5, i6, i7, i8, query.getColumnIndex(TABLE_OUTBOUNDSLOT) != -1 ? query.getInt(query.getColumnIndex(TABLE_OUTBOUNDSLOT)) : 0, query.getColumnIndex(TABLE_CHANNELMODE) != -1 ? query.getInt(query.getColumnIndex(TABLE_CHANNELMODE)) : 0, query.getInt(query.getColumnIndex("channel_contactType")), query.getInt(query.getColumnIndex("channel_txContact")), query.getInt(query.getColumnIndex("channel_encryptSw")), query.getString(query.getColumnIndex("channel_encryptKey")), query.getInt(query.getColumnIndex("channel_relay")), query.getInt(query.getColumnIndex("channel_interrupt")), query.getInt(query.getColumnIndex("channel_band")), query.getInt(query.getColumnIndex("channel_sq")), query.getInt(query.getColumnIndex("channel_rxType")), query.getInt(query.getColumnIndex("channel_rxSubCode")), query.getInt(query.getColumnIndex("channel_txType")), query.getInt(query.getColumnIndex("channel_txSubCode")), query.getInt(query.getColumnIndex("channel_active")), coverGroupInt(query.getString(query.getColumnIndex("channel_groups"))));
            arrayList.add(channelData);
        }
        return arrayList;
    }

    public void updateChannel(ChannelData channelData) {
        this.mDB = this.mHelper.getWritableDatabase();
        ContentValues contentValues = new ContentValues();
        contentValues.put("channel_name", channelData.name);
        contentValues.put("channel_type", Integer.valueOf(channelData.type));
        contentValues.put("channel_number", Integer.valueOf(channelData.number));
        contentValues.put("channel_txFreq", Integer.valueOf(channelData.txFreq));
        contentValues.put("channel_rxFreq", Integer.valueOf(channelData.rxFreq));
        contentValues.put("channel_power", Integer.valueOf(channelData.power));
        contentValues.put("channel_cc", Integer.valueOf(channelData.cc));
        contentValues.put(TABLE_INBOUNDSLOT, Integer.valueOf(channelData.inBoundSlot));
        contentValues.put(TABLE_OUTBOUNDSLOT, Integer.valueOf(channelData.outBoundSlot));
        contentValues.put(TABLE_CHANNELMODE, Integer.valueOf(channelData.channelMode));
        contentValues.put("channel_contactType", Integer.valueOf(channelData.contactType));
        contentValues.put("channel_txContact", Integer.valueOf(channelData.txContact));
        contentValues.put("channel_encryptSw", Integer.valueOf(channelData.encryptSw));
        contentValues.put("channel_encryptKey", channelData.encryptKey);
        contentValues.put("channel_relay", Integer.valueOf(channelData.relay));
        contentValues.put("channel_interrupt", Integer.valueOf(channelData.interrupt));
        contentValues.put("channel_band", Integer.valueOf(channelData.band));
        contentValues.put("channel_sq", Integer.valueOf(channelData.sq));
        contentValues.put("channel_rxType", Integer.valueOf(channelData.rxType));
        contentValues.put("channel_rxSubCode", Integer.valueOf(channelData.rxSubCode));
        contentValues.put("channel_txType", Integer.valueOf(channelData.txType));
        contentValues.put("channel_txSubCode", Integer.valueOf(channelData.txSubCode));
        contentValues.put("channel_active", Integer.valueOf(channelData.active));
        contentValues.put("channel_groups", coverGroupsString(channelData.groups));
        SQLiteDatabase sQLiteDatabase = this.mDB;
        String str = this.mDBName;
        sQLiteDatabase.update(str, contentValues, "_id = ?", new String[]{channelData._id + ""});
    }

    public void close() {
        SQLiteDatabase sQLiteDatabase = this.mDB;
        if (sQLiteDatabase != null) {
            sQLiteDatabase.close();
        }
    }

    public void deleteAll() {
        SQLiteDatabase writableDatabase = this.mHelper.getWritableDatabase();
        this.mDB = writableDatabase;
        writableDatabase.execSQL("delete from " + this.mDBName);
    }
}
