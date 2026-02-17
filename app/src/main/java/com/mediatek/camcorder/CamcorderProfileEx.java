package com.mediatek.camcorder;

import android.hardware.Camera;
import android.media.CamcorderProfile;
import android.util.Log;
import java.lang.reflect.Field;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;

public class CamcorderProfileEx {
    public static final int QUALITY_FINE = 111;
    public static final int QUALITY_FINE_4K2K = 123;
    public static final int QUALITY_H264_HIGH = 117;
    public static final int QUALITY_HIGH = 110;
    public static final int QUALITY_LIST_END = 123;
    private static final int QUALITY_LIST_START = getQualityNum("QUALITY_LIST_START");
    public static final int QUALITY_LIVE_EFFECT = 116;
    public static final int QUALITY_LOW = 108;
    public static final int QUALITY_MEDIUM = 109;
    public static final int QUALITY_NIGHT_FINE = 115;
    public static final int QUALITY_NIGHT_HIGH = 114;
    public static final int QUALITY_NIGHT_LOW = 112;
    public static final int QUALITY_NIGHT_MEDIUM = 113;
    public static final int QUALITY_TIME_LAPSE_LIST_END;
    public static final int QUALITY_TIME_LAPSE_LIST_START;
    public static final int SLOW_MOTION_FHD_120FPS = 2251;
    public static final int SLOW_MOTION_FHD_60FPS = 2250;
    public static final int SLOW_MOTION_HD_120FPS = 2241;
    public static final int SLOW_MOTION_HD_180FPS = 2242;
    public static final int SLOW_MOTION_HD_60FPS = 2240;
    private static final int SLOW_MOTION_LIST_END = 2251;
    private static final int SLOW_MOTION_LIST_START = 2231;
    public static final int SLOW_MOTION_VGA_120FPS = 2231;
    private static final String TAG = "CamcorderProfileEx";

    static {
        int qualityNum = getQualityNum("QUALITY_TIME_LAPSE_LIST_START");
        QUALITY_TIME_LAPSE_LIST_START = qualityNum;
        QUALITY_TIME_LAPSE_LIST_END = qualityNum + 123;
    }

    private static int getQualityNum(String str) {
        try {
            Field declaredField = CamcorderProfile.class.getDeclaredField(str);
            declaredField.setAccessible(true);
            return declaredField.getInt((Object) null);
        } catch (SecurityException unused) {
            Log.e(TAG, "getQualityNum error");
            return 0;
        } catch (NoSuchFieldException unused2) {
            Log.e(TAG, "getQualityNum error");
            return 0;
        } catch (IllegalArgumentException unused3) {
            Log.e(TAG, "getQualityNum error");
            return 0;
        } catch (IllegalAccessException unused4) {
            Log.e(TAG, "getQualityNum error");
            return 0;
        }
    }

    public static CamcorderProfile getProfile(int i) {
        int numberOfCameras = Camera.getNumberOfCameras();
        Camera.CameraInfo cameraInfo = new Camera.CameraInfo();
        for (int i2 = 0; i2 < numberOfCameras; i2++) {
            Camera.getCameraInfo(i2, cameraInfo);
            if (cameraInfo.facing == 0) {
                return getProfile(i2, i);
            }
        }
        return null;
    }

    public static CamcorderProfile getProfile(int i, int i2) {
        if ((i2 >= QUALITY_LIST_START && i2 <= 123) || ((i2 >= QUALITY_TIME_LAPSE_LIST_START && i2 <= QUALITY_TIME_LAPSE_LIST_END) || (i2 >= 2231 && i2 <= 2251))) {
            return native_get_camcorder_profile(i, i2);
        }
        throw new IllegalArgumentException("Unsupported quality level: " + i2);
    }

    private static final CamcorderProfile native_get_camcorder_profile(int i, int i2) {
        Class<CamcorderProfile> cls = CamcorderProfile.class;
        try {
            Class cls2 = Integer.TYPE;
            Method declaredMethod = cls.getDeclaredMethod("native_get_camcorder_profile", new Class[]{cls2, cls2});
            declaredMethod.setAccessible(true);
            return (CamcorderProfile) declaredMethod.invoke((Object) null, new Object[]{Integer.valueOf(i), Integer.valueOf(i2)});
        } catch (SecurityException unused) {
            Log.e(TAG, "native_get_camcorder_profile error");
            return null;
        } catch (NoSuchMethodException unused2) {
            Log.e(TAG, "native_get_camcorder_profile error");
            return null;
        } catch (IllegalArgumentException unused3) {
            Log.e(TAG, "native_get_camcorder_profile error");
            return null;
        } catch (IllegalAccessException unused4) {
            Log.e(TAG, "native_get_camcorder_profile error");
            return null;
        } catch (InvocationTargetException unused5) {
            Log.e(TAG, "native_get_camcorder_profile error");
            return null;
        }
    }
}
