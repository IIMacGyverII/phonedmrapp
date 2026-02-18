package com.pri.prizeinterphone.data;

import android.content.Context;
import android.content.SharedPreferences;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.util.Base64;
import com.pri.prizeinterphone.InterPhoneApplication;
import java.io.ByteArrayOutputStream;
/* loaded from: classes4.dex */
public class PersonSharePrefData {
    public static final String PERSON_CONTACTS_SELETED_ID_DEFAULT = "default";
    public static final String PREF_PERSON_BUSY_NO_SEND = "pref_person_busy_no_send";
    public static final String PREF_PERSON_CHANNEL_AREA_SELECTED_INDEX = "pref_person_channel_area_selected_index";
    public static final String PREF_PERSON_CONTACTS_SELETED = "pref_person_contacts_seleted";
    public static final String PREF_PERSON_CONTACTS_SELETED_ID = "pref_person_contacts_seleted_id";
    public static final String PREF_PERSON_CONTACTS_SELETED_TYPE = "pref_person_contacts_seleted_type";
    public static final String PREF_PERSON_DATA = "com.pri.prizeinterphone.data.person";
    public static final String PREF_PERSON_DEVICE_ID = "pref_person_device_id";
    public static final String PREF_PERSON_ICON = "pref_person_icon";
    public static final String PREF_PERSON_LIMIT_SEND_TIME = "pref_person_limit_send_time";
    public static final String PREF_PERSON_MESSAGE_DB_VERSION = "pref_person_message_db_version";
    public static final String PREF_PERSON_PTT_END_TONE = "pref_person_ptt_end_tone";
    public static final String PREF_PERSON_PTT_RECORD = "pref_person_ptt_record";
    public static final String PREF_PERSON_PTT_START_TONE = "pref_person_ptt_start_tone";

    public static void putIntData(Context context, String str, int i) {
        SharedPreferences.Editor edit = InterPhoneApplication.getContext().getSharedPreferences("com.pri.prizeinterphone.data.person", 0).edit();
        edit.putInt(str, i);
        edit.commit();
    }

    public static int getIntData(Context context, String str, int i) {
        return InterPhoneApplication.getContext().getSharedPreferences("com.pri.prizeinterphone.data.person", 0).getInt(str, i);
    }

    public static void putStringData(Context context, String str, String str2) {
        SharedPreferences.Editor edit = InterPhoneApplication.getContext().getSharedPreferences("com.pri.prizeinterphone.data.person", 0).edit();
        edit.putString(str, str2);
        edit.commit();
    }

    public static String getStringData(Context context, String str, String str2) {
        return InterPhoneApplication.getContext().getSharedPreferences("com.pri.prizeinterphone.data.person", 0).getString(str, str2);
    }

    public static void putBooleanData(Context context, String str, boolean z) {
        SharedPreferences.Editor edit = InterPhoneApplication.getContext().getSharedPreferences("com.pri.prizeinterphone.data.person", 0).edit();
        edit.putBoolean(str, z);
        edit.commit();
    }

    public static boolean getBooleanData(Context context, String str, boolean z) {
        return InterPhoneApplication.getContext().getSharedPreferences("com.pri.prizeinterphone.data.person", 0).getBoolean(str, z);
    }

    public static void putImgData(Context context, String str, Bitmap bitmap) {
        SharedPreferences.Editor edit = InterPhoneApplication.getContext().getSharedPreferences("com.pri.prizeinterphone.data.person", 0).edit();
        ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
        bitmap.compress(Bitmap.CompressFormat.JPEG, 100, byteArrayOutputStream);
        edit.putString(str, new String(Base64.encodeToString(byteArrayOutputStream.toByteArray(), 0)));
        edit.commit();
    }

    public static Bitmap getImgData(Context context, String str, Bitmap bitmap) {
        String string = InterPhoneApplication.getContext().getSharedPreferences("com.pri.prizeinterphone.data.person", 0).getString(str, "");
        if (string == null || string.isEmpty()) {
            return bitmap;
        }
        byte[] decode = Base64.decode(string.getBytes(), 1);
        return BitmapFactory.decodeByteArray(decode, 0, decode.length);
    }
}
