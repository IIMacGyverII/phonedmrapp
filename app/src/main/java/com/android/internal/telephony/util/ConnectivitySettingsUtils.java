package com.android.internal.telephony.util;

import android.content.ContentResolver;
import android.content.Context;
import android.provider.Settings;
import android.text.TextUtils;

public class ConnectivitySettingsUtils {
    public static final String PRIVATE_DNS_DEFAULT_MODE = "private_dns_default_mode";
    public static final String PRIVATE_DNS_MODE = "private_dns_mode";
    public static final int PRIVATE_DNS_MODE_OFF = 1;
    public static final String PRIVATE_DNS_MODE_OFF_STRING = "off";
    public static final int PRIVATE_DNS_MODE_OPPORTUNISTIC = 2;
    public static final String PRIVATE_DNS_MODE_OPPORTUNISTIC_STRING = "opportunistic";
    public static final int PRIVATE_DNS_MODE_PROVIDER_HOSTNAME = 3;
    public static final String PRIVATE_DNS_MODE_PROVIDER_HOSTNAME_STRING = "hostname";
    public static final String PRIVATE_DNS_SPECIFIER = "private_dns_specifier";

    public static String getPrivateDnsModeAsString(int i) {
        if (i == 1) {
            return PRIVATE_DNS_MODE_OFF_STRING;
        }
        if (i == 2) {
            return PRIVATE_DNS_MODE_OPPORTUNISTIC_STRING;
        }
        if (i == 3) {
            return PRIVATE_DNS_MODE_PROVIDER_HOSTNAME_STRING;
        }
        throw new IllegalArgumentException("Invalid private dns mode: " + i);
    }

    private static int getPrivateDnsModeAsInt(String str) {
        str.hashCode();
        char c = 65535;
        switch (str.hashCode()) {
            case -539229175:
                if (str.equals(PRIVATE_DNS_MODE_OPPORTUNISTIC_STRING)) {
                    c = 0;
                    break;
                }
                break;
            case -299803597:
                if (str.equals(PRIVATE_DNS_MODE_PROVIDER_HOSTNAME_STRING)) {
                    c = 1;
                    break;
                }
                break;
            case 109935:
                if (str.equals(PRIVATE_DNS_MODE_OFF_STRING)) {
                    c = 2;
                    break;
                }
                break;
        }
        switch (c) {
            case 0:
                return 2;
            case 1:
                return 3;
            case 2:
                return 1;
            default:
                throw new IllegalArgumentException("Invalid private dns mode: " + str);
        }
    }

    public static int getPrivateDnsMode(Context context) {
        ContentResolver contentResolver = context.getContentResolver();
        String string = Settings.Global.getString(contentResolver, PRIVATE_DNS_MODE);
        if (TextUtils.isEmpty(string)) {
            string = Settings.Global.getString(contentResolver, PRIVATE_DNS_DEFAULT_MODE);
        }
        if (TextUtils.isEmpty(string)) {
            return 2;
        }
        return getPrivateDnsModeAsInt(string);
    }

    public static void setPrivateDnsMode(Context context, int i) {
        if (i == 1 || i == 2 || i == 3) {
            Settings.Global.putString(context.getContentResolver(), PRIVATE_DNS_MODE, getPrivateDnsModeAsString(i));
            return;
        }
        throw new IllegalArgumentException("Invalid private dns mode: " + i);
    }

    public static String getPrivateDnsHostname(Context context) {
        return Settings.Global.getString(context.getContentResolver(), PRIVATE_DNS_SPECIFIER);
    }

    public static void setPrivateDnsHostname(Context context, String str) {
        Settings.Global.putString(context.getContentResolver(), PRIVATE_DNS_SPECIFIER, str);
    }
}
