package com.pri.prizeinterphone.serial.data;

import android.content.ContentValues;
import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.util.Base64;
import android.util.Log;
import com.android.internal.telephony.InboundSmsHandler;
import java.io.ByteArrayOutputStream;
import java.util.ArrayList;

public class UtilContactsData {
    public static final int ID_MAX = 16776415;
    public static final int ID_MIN = 2;
    public static final int INSERT = 1111;
    public static final String TABLE_ACTIVE = "contact_active";
    public static final String TABLE_ICON = "contact_icon";
    public static final String TABLE_ID = "_id";
    public static final String TABLE_NAME = "contact_name";
    public static final String TABLE_NUMBER = "contact_number";
    public static final String TABLE_TYPE = "contact_type";
    public static final String TAG = "TAG_UtilContactsData";
    public static final int UPDATE = 1112;
    private SQLiteDatabase mDB;
    private String mDBName = DBContactHelper.CONTACT_NAME;
    private SQLiteOpenHelper mHelper;

    public UtilContactsData(Context context) {
        this.mHelper = new DBContactHelper(context);
    }

    public long addContact() {
        this.mDB = this.mHelper.getWritableDatabase();
        ContentValues contentValues = new ContentValues();
        contentValues.put(TABLE_NAME, "");
        return this.mDB.insert(this.mDBName, (String) null, contentValues);
    }

    public long addContact(ContactData contactData) {
        this.mDB = this.mHelper.getWritableDatabase();
        ContentValues contentValues = new ContentValues();
        contentValues.put("_id", Integer.valueOf(contactData.getId()));
        contentValues.put(TABLE_NAME, contactData.getName());
        contentValues.put(TABLE_TYPE, Integer.valueOf(contactData.getType()));
        contentValues.put(TABLE_NUMBER, contactData.getNumber());
        contentValues.put(TABLE_ACTIVE, Integer.valueOf(contactData.getActive()));
        if (contactData.bitmap != null) {
            ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
            contactData.bitmap.compress(Bitmap.CompressFormat.JPEG, 100, byteArrayOutputStream);
            contentValues.put(TABLE_ICON, new String(Base64.encodeToString(byteArrayOutputStream.toByteArray(), 0)));
        } else {
            contentValues.put(TABLE_ICON, "");
        }
        return this.mDB.insert(this.mDBName, (String) null, contentValues);
    }

    public void deleteContact(ContactData contactData) {
        SQLiteDatabase writableDatabase = this.mHelper.getWritableDatabase();
        this.mDB = writableDatabase;
        String str = this.mDBName;
        writableDatabase.delete(str, "_id = ?", new String[]{contactData.getId() + ""});
    }

    public ArrayList<ContactData> getAllContacts() {
        Bitmap bitmap;
        this.mDB = this.mHelper.getWritableDatabase();
        ArrayList<ContactData> arrayList = new ArrayList<>();
        Cursor query = this.mDB.query(this.mDBName, (String[]) null, (String) null, (String[]) null, (String) null, (String) null, (String) null);
        while (query.moveToNext()) {
            int i = query.getInt(query.getColumnIndex("_id"));
            int i2 = query.getInt(query.getColumnIndex(TABLE_TYPE));
            String string = query.getString(query.getColumnIndex(TABLE_NAME));
            String string2 = query.getString(query.getColumnIndex(TABLE_NUMBER));
            int i3 = query.getInt(query.getColumnIndex(TABLE_ACTIVE));
            String string3 = query.getString(query.getColumnIndex(TABLE_ICON));
            if (string3 == null || string3.isEmpty()) {
                bitmap = null;
            } else {
                byte[] decode = Base64.decode(string3.getBytes(), 1);
                bitmap = BitmapFactory.decodeByteArray(decode, 0, decode.length);
            }
            arrayList.add(new ContactData(i, i2, string, string2, i3, bitmap));
        }
        return arrayList;
    }

    public ArrayList<ContactData> getAllContacts(int i) {
        Bitmap bitmap;
        this.mDB = this.mHelper.getWritableDatabase();
        ArrayList<ContactData> arrayList = new ArrayList<>();
        Cursor query = this.mDB.query(this.mDBName, (String[]) null, "contact_type=?", new String[]{i + ""}, (String) null, (String) null, (String) null);
        while (query.moveToNext()) {
            int i2 = query.getInt(query.getColumnIndex("_id"));
            int i3 = query.getInt(query.getColumnIndex(TABLE_TYPE));
            String string = query.getString(query.getColumnIndex(TABLE_NAME));
            String string2 = query.getString(query.getColumnIndex(TABLE_NUMBER));
            int i4 = query.getInt(query.getColumnIndex(TABLE_ACTIVE));
            String string3 = query.getString(query.getColumnIndex(TABLE_ICON));
            if (string3 == null || string3.isEmpty()) {
                bitmap = null;
            } else {
                byte[] decode = Base64.decode(string3.getBytes(), 1);
                bitmap = BitmapFactory.decodeByteArray(decode, 0, decode.length);
            }
            arrayList.add(new ContactData(i2, i3, string, string2, i4, bitmap));
        }
        return arrayList;
    }

    public boolean updateContact(ContactData contactData) {
        this.mDB = this.mHelper.getWritableDatabase();
        ContentValues contentValues = new ContentValues();
        contentValues.put("_id", Integer.valueOf(contactData.getId()));
        contentValues.put(TABLE_NAME, contactData.getName());
        contentValues.put(TABLE_TYPE, Integer.valueOf(contactData.getType()));
        contentValues.put(TABLE_NUMBER, contactData.getNumber());
        if (contactData.bitmap != null) {
            ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
            contactData.bitmap.compress(Bitmap.CompressFormat.JPEG, 100, byteArrayOutputStream);
            contentValues.put(TABLE_ICON, new String(Base64.encodeToString(byteArrayOutputStream.toByteArray(), 0)));
        } else {
            contentValues.put(TABLE_ICON, "");
        }
        Log.i(TAG, "updateContact: contact " + contactData.toString());
        SQLiteDatabase sQLiteDatabase = this.mDB;
        String str = this.mDBName;
        int update = sQLiteDatabase.update(str, contentValues, "_id = ?", new String[]{contactData.getId() + ""});
        Log.i(TAG, "updateContact: " + update);
        if (update == 1) {
            return true;
        }
        return false;
    }

    public ContactData getContact(int i, int i2) {
        SQLiteDatabase writableDatabase = this.mHelper.getWritableDatabase();
        this.mDB = writableDatabase;
        String str = this.mDBName;
        Cursor query = writableDatabase.query(str, (String[]) null, "contact_type=? AND contact_number=?", new String[]{i + "", i2 + ""}, (String) null, (String) null, (String) null, "1");
        Bitmap bitmap = null;
        if (!query.moveToNext()) {
            return null;
        }
        int i3 = query.getInt(query.getColumnIndex("_id"));
        int i4 = query.getInt(query.getColumnIndex(TABLE_TYPE));
        String string = query.getString(query.getColumnIndex(TABLE_NAME));
        String string2 = query.getString(query.getColumnIndex(TABLE_NUMBER));
        int i5 = query.getInt(query.getColumnIndex(TABLE_ACTIVE));
        String string3 = query.getString(query.getColumnIndex(TABLE_ICON));
        if (string3 != null && !string3.isEmpty()) {
            byte[] decode = Base64.decode(string3.getBytes(), 1);
            bitmap = BitmapFactory.decodeByteArray(decode, 0, decode.length);
        }
        return new ContactData(i3, i4, string, string2, i5, bitmap);
    }

    public ContactData getContact(int i) {
        SQLiteDatabase writableDatabase = this.mHelper.getWritableDatabase();
        this.mDB = writableDatabase;
        String str = this.mDBName;
        Cursor query = writableDatabase.query(str, (String[]) null, InboundSmsHandler.SELECT_BY_ID, new String[]{i + ""}, (String) null, (String) null, (String) null, "1");
        Bitmap bitmap = null;
        if (!query.moveToNext()) {
            return null;
        }
        int i2 = query.getInt(query.getColumnIndex("_id"));
        int i3 = query.getInt(query.getColumnIndex(TABLE_TYPE));
        String string = query.getString(query.getColumnIndex(TABLE_NAME));
        String string2 = query.getString(query.getColumnIndex(TABLE_NUMBER));
        int i4 = query.getInt(query.getColumnIndex(TABLE_ACTIVE));
        String string3 = query.getString(query.getColumnIndex(TABLE_ICON));
        if (string3 != null && !string3.isEmpty()) {
            byte[] decode = Base64.decode(string3.getBytes(), 1);
            bitmap = BitmapFactory.decodeByteArray(decode, 0, decode.length);
        }
        return new ContactData(i2, i3, string, string2, i4, bitmap);
    }

    public ContactData getActiveContact() {
        SQLiteDatabase writableDatabase = this.mHelper.getWritableDatabase();
        this.mDB = writableDatabase;
        Cursor query = writableDatabase.query(this.mDBName, (String[]) null, "contact_active=?", new String[]{"1"}, (String) null, (String) null, (String) null, "1");
        Bitmap bitmap = null;
        if (!query.moveToNext()) {
            return null;
        }
        int i = query.getInt(query.getColumnIndex("_id"));
        int i2 = query.getInt(query.getColumnIndex(TABLE_TYPE));
        String string = query.getString(query.getColumnIndex(TABLE_NAME));
        String string2 = query.getString(query.getColumnIndex(TABLE_NUMBER));
        int i3 = query.getInt(query.getColumnIndex(TABLE_ACTIVE));
        String string3 = query.getString(query.getColumnIndex(TABLE_ICON));
        if (string3 != null && !string3.isEmpty()) {
            byte[] decode = Base64.decode(string3.getBytes(), 1);
            bitmap = BitmapFactory.decodeByteArray(decode, 0, decode.length);
        }
        return new ContactData(i, i2, string, string2, i3, bitmap);
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
