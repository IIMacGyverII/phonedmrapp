package com.pri.prizeinterphone.Util;

import android.content.ContentValues;
import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.util.Base64;
import android.util.Log;
import com.pri.prizeinterphone.InterPhoneApplication;
import com.pri.prizeinterphone.data.ContactData;
import com.pri.prizeinterphone.data.DBGroupHelper;
import com.pri.prizeinterphone.data.DBPeopleHelper;
import java.io.ByteArrayOutputStream;
import java.util.ArrayList;
/* loaded from: classes4.dex */
public class UtilContactsData {
    public static final int ID_MAX = 16776415;
    public static final int ID_MIN = 2;
    public static final int INSERT = 1111;
    public static final String TABLE_ICON = "person_icon";
    public static final String TABLE_ID = "person_id";
    public static final String TABLE_NAME = "person_name";
    public static final int UPDATE = 1112;
    private SQLiteDatabase mDB;
    private String mDBName;
    private SQLiteOpenHelper mHelper;

    public UtilContactsData(String str, Context context) {
        if (str.equals(DBPeopleHelper.DB_PEOPLE_NAME)) {
            this.mHelper = new DBPeopleHelper(InterPhoneApplication.getContext());
            this.mDBName = DBPeopleHelper.PEOPLE_NAME;
        } else if (str.equals("group_database.db")) {
            this.mHelper = new DBGroupHelper(InterPhoneApplication.getContext());
            this.mDBName = "group_databas";
        }
    }

    public void insertData(ContactData contactData) {
        this.mDB = this.mHelper.getWritableDatabase();
        ContentValues contentValues = new ContentValues();
        contentValues.put(TABLE_ID, contactData.id);
        contentValues.put(TABLE_NAME, contactData.name);
        if (contactData.bitmap != null) {
            ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
            contactData.bitmap.compress(Bitmap.CompressFormat.JPEG, 100, byteArrayOutputStream);
            contentValues.put(TABLE_ICON, new String(Base64.encodeToString(byteArrayOutputStream.toByteArray(), 0)));
        } else {
            contentValues.put(TABLE_ICON, "");
        }
        this.mDB.insert(this.mDBName, null, contentValues);
    }

    public void deleteData(ContactData contactData) {
        SQLiteDatabase writableDatabase = this.mHelper.getWritableDatabase();
        this.mDB = writableDatabase;
        writableDatabase.delete(this.mDBName, "person_id = ?", new String[]{contactData.getId()});
    }

    public ContactData queryData(String str) {
        SQLiteDatabase writableDatabase = this.mHelper.getWritableDatabase();
        this.mDB = writableDatabase;
        Cursor query = writableDatabase.query(this.mDBName, null, "person_id=?", new String[]{str}, null, null, null);
        Bitmap bitmap = null;
        if (query.moveToFirst()) {
            Log.e("peisaisai", "cursor has data!");
            String string = query.getString(query.getColumnIndex(TABLE_ID));
            String string2 = query.getString(query.getColumnIndex(TABLE_NAME));
            String string3 = query.getString(query.getColumnIndex(TABLE_ICON));
            if (string3 != null && !string3.isEmpty()) {
                byte[] decode = Base64.decode(string3.getBytes(), 1);
                bitmap = BitmapFactory.decodeByteArray(decode, 0, decode.length);
            }
            return new ContactData(string, string2, bitmap);
        }
        return null;
    }

    public ArrayList<ContactData> queryData() {
        this.mDB = this.mHelper.getWritableDatabase();
        ArrayList<ContactData> arrayList = new ArrayList<>();
        Cursor query = this.mDB.query(this.mDBName, null, null, null, null, null, null);
        while (query.moveToNext()) {
            String string = query.getString(query.getColumnIndex(TABLE_ID));
            String string2 = query.getString(query.getColumnIndex(TABLE_NAME));
            String string3 = query.getString(query.getColumnIndex(TABLE_ICON));
            Bitmap bitmap = null;
            if (string3 != null && !string3.isEmpty()) {
                byte[] decode = Base64.decode(string3.getBytes(), 1);
                bitmap = BitmapFactory.decodeByteArray(decode, 0, decode.length);
            }
            arrayList.add(new ContactData(string, string2, bitmap));
        }
        return arrayList;
    }

    public boolean queryData(ContactData contactData, ContactData contactData2) {
        SQLiteDatabase writableDatabase = this.mHelper.getWritableDatabase();
        this.mDB = writableDatabase;
        Cursor query = writableDatabase.query(this.mDBName, new String[]{TABLE_ID, TABLE_NAME}, "person_id=?", new String[]{contactData.getId()}, null, null, null);
        if (query.moveToFirst()) {
            Log.e("peisaisai", "cursor has data!");
            String string = query.getString(query.getColumnIndex(TABLE_ID));
            String string2 = query.getString(query.getColumnIndex(TABLE_NAME));
            if (contactData2 == null || !contactData2.getId().equals(string) || !string2.equals(contactData2.getName())) {
                return true;
            }
        }
        Cursor query2 = this.mDB.query(this.mDBName, new String[]{TABLE_ID, TABLE_NAME}, "person_name=?", new String[]{contactData.getName()}, null, null, null);
        if (query2.moveToFirst()) {
            Log.e("peisaisai", "cursor has data!");
            String string3 = query2.getString(query2.getColumnIndex(TABLE_ID));
            String string4 = query2.getString(query2.getColumnIndex(TABLE_NAME));
            if (contactData2 == null || !contactData2.getId().equals(string3) || !string4.equals(contactData2.getName())) {
                return true;
            }
        }
        return false;
    }

    public void updateData(ContactData contactData, ContactData contactData2) {
        this.mDB = this.mHelper.getWritableDatabase();
        ContentValues contentValues = new ContentValues();
        contentValues.put(TABLE_ID, contactData.id);
        contentValues.put(TABLE_NAME, contactData.name);
        if (contactData.bitmap != null) {
            ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
            contactData.bitmap.compress(Bitmap.CompressFormat.JPEG, 100, byteArrayOutputStream);
            contentValues.put(TABLE_ICON, new String(Base64.encodeToString(byteArrayOutputStream.toByteArray(), 0)));
        } else {
            contentValues.put(TABLE_ICON, "");
        }
        this.mDB.update(this.mDBName, contentValues, "person_id = ?", new String[]{contactData2.getId()});
    }

    public void close() {
        SQLiteDatabase sQLiteDatabase = this.mDB;
        if (sQLiteDatabase != null) {
            sQLiteDatabase.close();
        }
    }
}
