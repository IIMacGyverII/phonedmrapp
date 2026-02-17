package com.mediatek.boostfwk.utils;

import android.os.Trace;
import android.util.Log;
import android.util.Slog;

public final class LogUtil {
    public static final boolean DEBUG = Config.isBoostFwkLogEnable();
    private static final String DEBUG_TAG_HEAD = "SBE-";

    public static void slogi(String str, String str2) {
        Slog.i(str, str2);
    }

    public static void slogw(String str, String str2) {
        Slog.w(str, str2);
    }

    public static void slogd(String str, String str2) {
        if (DEBUG) {
            Slog.d(DEBUG_TAG_HEAD + str, str2);
        }
    }

    public static void sloge(String str, String str2) {
        Slog.e(str, str2);
    }

    public static void slogeDebug(String str, String str2) {
        if (DEBUG) {
            Slog.e(DEBUG_TAG_HEAD + str, str2);
        }
    }

    public static void traceAndLog(String str, String str2) {
        if (DEBUG) {
            Trace.traceBegin(8, str2);
            Slog.d(DEBUG_TAG_HEAD + str, str2);
            Trace.traceEnd(8);
        }
    }

    public static void traceBeginAndLog(String str, String str2) {
        if (DEBUG) {
            Trace.traceBegin(8, str2);
            Slog.d(DEBUG_TAG_HEAD + str, str2);
        }
    }

    public static void mLogi(String str, String str2) {
        Log.i(str, str2);
    }

    public static void mLogw(String str, String str2) {
        Log.w(str, str2);
    }

    public static void mLogd(String str, String str2) {
        if (DEBUG) {
            Log.d(DEBUG_TAG_HEAD + str, str2);
        }
    }

    public static void mLoge(String str, String str2) {
        Log.e(str, str2);
    }

    public static void mLogeDebug(String str, String str2) {
        if (DEBUG) {
            Log.e(DEBUG_TAG_HEAD + str, str2);
        }
    }

    public static void traceAndMLogd(String str, String str2) {
        if (DEBUG) {
            Trace.traceBegin(8, str2);
            Log.d(DEBUG_TAG_HEAD + str, str2);
            Trace.traceEnd(8);
        }
    }

    public static void traceBeginAndMLogd(String str, String str2) {
        if (DEBUG) {
            Trace.traceBegin(8, str2);
            Log.d(DEBUG_TAG_HEAD + str, str2);
        }
    }

    public static void traceBegin(String str) {
        if (DEBUG) {
            Trace.traceBegin(8, str);
        }
    }

    public static void traceEnd() {
        if (DEBUG) {
            Trace.traceEnd(8);
        }
    }

    public static void trace(String str) {
        if (DEBUG) {
            Trace.traceBegin(8, str);
            Trace.traceEnd(8);
        }
    }
}
