package com.mediatek.custom;

import android.annotation.ProductApi;
import dalvik.system.PathClassLoader;

public class CustomProperties {
    public static final String HOST_NAME = "HostName";
    public static final String MANUFACTURER = "Manufacturer";
    public static final String MODEL = "Model";
    public static final String MODULE_BLUETOOTH = "bluetooth";
    public static final String MODULE_BROWSER = "browser";
    public static final String MODULE_CMMB = "cmmb";
    public static final String MODULE_DM = "dm";
    public static final String MODULE_FMTRANSMITTER = "fmtransmitter";
    public static final String MODULE_HTTP_STREAMING = "http_streaming";
    public static final String MODULE_MMS = "mms";
    public static final String MODULE_RTSP_STREAMING = "rtsp_streaming";
    public static final String MODULE_SYSTEM = "system";
    public static final String MODULE_WLAN = "wlan";
    public static final int PROP_MODULE_MAX = 32;
    public static final int PROP_NAME_MAX = 64;
    public static final String RDS_VALUE = "RDSValue";
    public static final String SSID = "SSID";
    public static final String UAPROF_URL = "UAProfileURL";
    public static final String USER_AGENT = "UserAgent";
    static ClassLoader mLoader = new PathClassLoader("/system/framework/CustomPropInterface.jar", ClassLoader.getSystemClassLoader());

    private static native String native_get_string(String str, String str2, String str3);

    static {
        System.loadLibrary("custom_jni");
    }

    public static String getString(String str) {
        return getString((String) null, str, (String) null);
    }

    @ProductApi
    public static String getString(String str, String str2) {
        return getString(str, str2, (String) null);
    }

    @ProductApi
    public static String getString(String str, String str2, String str3) {
        if (str != null && str.length() > 32) {
            throw new IllegalArgumentException("module.length >32");
        } else if (str2 != null && str2.length() <= 64) {
            return native_get_string(str, str2, str3);
        } else {
            throw new IllegalArgumentException("name.length > 64");
        }
    }

    private static Class loadInterface() {
        Class<?> cls;
        try {
            cls = mLoader.loadClass("com.mediatek.custom.CustomPropInterface");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
            cls = null;
        }
        System.out.println("[CustomProp]loadInterface->clazz:" + cls);
        return cls;
    }
}
