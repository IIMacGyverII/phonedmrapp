package com.pri.didouix.util;

import android.text.TextUtils;
import android.util.Log;

public class PrizeNestedScrollLog {
    private static final boolean DEBUG = false;
    private static final boolean FORCE_DEBUG = false;
    private static final String TAG = "NestedScrollLog";
    private static final boolean VERBOSE = false;

    public static void d(Object obj, String str) {
    }

    public static void d(Object obj, String str, Throwable th) {
    }

    public static void d(String str) {
    }

    public static void d(String str, String str2) {
    }

    public static void d(String str, String str2, Throwable th) {
    }

    public static void v(Object obj, String str) {
    }

    public static void v(Object obj, String str, Throwable th) {
    }

    public static void v(String str, String str2) {
    }

    public static void v(String str, String str2, Throwable th) {
    }

    public static void i(String str, String str2) {
        Log.i(TAG, delimit(str) + str2);
    }

    public static void i(String str, String str2, Throwable th) {
        Log.i(TAG, delimit(str) + str2, th);
    }

    public static void i(Object obj, String str) {
        Log.i(TAG, getPrefix(obj) + str);
    }

    public static void i(Object obj, String str, Throwable th) {
        Log.i(TAG, getPrefix(obj) + str, th);
    }

    public static void e(String str, String str2) {
        Log.e(TAG, delimit(str) + str2);
    }

    public static void e(String str, String str2, Throwable th) {
        Log.e(TAG, delimit(str) + str2, th);
    }

    public static void e(Object obj, String str) {
        Log.e(TAG, getPrefix(obj) + str);
    }

    public static void e(Object obj, String str, Throwable th) {
        Log.e(TAG, getPrefix(obj) + str, th);
    }

    public static void w(String str, String str2) {
        Log.w(TAG, delimit(str) + str2);
    }

    public static void w(String str, String str2, Throwable th) {
        Log.w(TAG, delimit(str) + str2, th);
    }

    public static void w(Object obj, String str) {
        Log.w(TAG, getPrefix(obj) + str);
    }

    public static void w(Object obj, String str, Throwable th) {
        Log.w(TAG, getPrefix(obj) + str, th);
    }

    private static String delimit(String str) {
        if (TextUtils.isEmpty(str)) {
            return "";
        }
        return "[" + str + "]";
    }

    private static String getPrefix(Object obj) {
        if (obj != null) {
            String simpleName = obj.getClass().getSimpleName();
            if (!TextUtils.isEmpty(simpleName)) {
                return "[" + simpleName + "]";
            }
        }
        return "";
    }
}
