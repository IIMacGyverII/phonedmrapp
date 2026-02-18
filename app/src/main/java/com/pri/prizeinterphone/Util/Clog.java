package com.pri.prizeinterphone.Util;

import android.util.Log;
/* loaded from: classes4.dex */
public class Clog {
    private static final String TAG = "fzc";

    public static void d(String str, String str2, Throwable th) {
        Log.d(TAG, str + "," + str2, th);
    }

    public static void d(String str, String str2) {
        Log.d(TAG, str + "," + str2);
    }

    public static void v(String str, String str2, Throwable th) {
        Log.v(TAG, str + "," + str2, th);
    }

    public static void v(String str, String str2) {
        Log.v(TAG, str + "," + str2);
    }

    public static void i(String str, String str2, Throwable th) {
        Log.i(TAG, str + "," + str2, th);
    }

    public static void i(String str, String str2) {
        Log.i(TAG, str + "," + str2);
    }

    public static void e(String str, String str2, Throwable th) {
        Log.e(TAG, str + "," + str2, th);
    }

    public static void e(String str, String str2) {
        Log.e(TAG, str + "," + str2);
    }
}
