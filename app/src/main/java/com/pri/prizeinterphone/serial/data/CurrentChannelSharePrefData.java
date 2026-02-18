package com.pri.prizeinterphone.serial.data;

import android.content.Context;
import android.content.SharedPreferences;
/* loaded from: classes4.dex */
public class CurrentChannelSharePrefData {
    public static final String PREF_CURRENT_CHANNEL_DATA = "com.pri.prizeinterphone.data.currentchannel";
    public static final String PREF_CURRENT_CHANNEL_ID = "pref_current_channel_id";

    public static void putIntData(Context context, String str, int i) {
        SharedPreferences.Editor edit = context.getSharedPreferences("com.pri.prizeinterphone.data.currentchannel", 0).edit();
        edit.putInt(str, i);
        edit.commit();
    }

    public static int getIntData(Context context, String str, int i) {
        return context.getSharedPreferences("com.pri.prizeinterphone.data.currentchannel", 0).getInt(str, i);
    }

    public static void putStringData(Context context, String str, String str2) {
        SharedPreferences.Editor edit = context.getSharedPreferences("com.pri.prizeinterphone.data.currentchannel", 0).edit();
        edit.putString(str, str2);
        edit.commit();
    }

    public static String getStringData(Context context, String str, String str2) {
        return context.getSharedPreferences("com.pri.prizeinterphone.data.currentchannel", 0).getString(str, str2);
    }

    public static void putBooleanData(Context context, String str, boolean z) {
        SharedPreferences.Editor edit = context.getSharedPreferences("com.pri.prizeinterphone.data.currentchannel", 0).edit();
        edit.putBoolean(str, z);
        edit.commit();
    }

    public static boolean getBooleanData(Context context, String str, boolean z) {
        return context.getSharedPreferences("com.pri.prizeinterphone.data.currentchannel", 0).getBoolean(str, z);
    }
}
