package com.android.internal.telephony.cat;

import android.compat.annotation.UnsupportedAppUsage;
import com.android.telephony.Rlog;

public abstract class CatLog {
    static final boolean DEBUG = true;

    @UnsupportedAppUsage
    public static void d(Object obj, String str) {
        String name = obj.getClass().getName();
        Rlog.d("CAT", name.substring(name.lastIndexOf(46) + 1) + ": " + str);
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public static void d(String str, String str2) {
        Rlog.d("CAT", str + ": " + str2);
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public static void e(Object obj, String str) {
        String name = obj.getClass().getName();
        Rlog.e("CAT", name.substring(name.lastIndexOf(46) + 1) + ": " + str);
    }

    public static void e(String str, String str2) {
        Rlog.e("CAT", str + ": " + str2);
    }
}
