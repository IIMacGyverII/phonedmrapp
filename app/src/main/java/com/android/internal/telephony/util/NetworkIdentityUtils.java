package com.android.internal.telephony.util;

public class NetworkIdentityUtils {
    public static String scrubSubscriberId(String str) {
        if (str == null) {
            return "null";
        }
        return str.substring(0, Math.min(6, str.length())) + "...";
    }

    public static String[] scrubSubscriberIds(String[] strArr) {
        if (strArr == null) {
            return null;
        }
        int length = strArr.length;
        String[] strArr2 = new String[length];
        for (int i = 0; i < length; i++) {
            strArr2[i] = scrubSubscriberId(strArr[i]);
        }
        return strArr2;
    }
}
