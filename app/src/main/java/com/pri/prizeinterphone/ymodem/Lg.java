package com.pri.prizeinterphone.ymodem;

import android.util.Log;
/* loaded from: classes4.dex */
public class Lg {
    private static final boolean DEBUGGING = true;
    private static final String TAG = "YMODEM";

    private Lg() {
        throw new UnsupportedOperationException("cannot be instantiated");
    }

    public static void f(String str) {
        Log.e(TAG, str);
    }

    public static void i(String str) {
        Log.i(TAG, str);
    }

    public static void d(String str) {
        Log.d(TAG, str);
    }

    public static void e(String str) {
        e(TAG, str);
    }

    public static void v(String str) {
        Log.v(TAG, str);
    }

    public static void w(String str) {
        Log.w(TAG, str);
    }

    public static void i(String str, String str2) {
        Log.i(str, str2);
    }

    public static void d(String str, String str2) {
        Log.d(str, str2);
    }

    public static void e(String str, String str2) {
        Log.e(str, str2);
    }

    public static void v(String str, String str2) {
        Log.v(str, str2);
    }

    public static void w(String str, String str2) {
        w(str, str2);
    }

    public static void e(String str, String str2, Throwable th) {
        Log.e(str, str2, th);
    }

    public static void wtf(String str, String str2) {
        Log.wtf(str, str2);
    }
}
