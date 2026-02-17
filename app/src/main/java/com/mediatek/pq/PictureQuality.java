package com.mediatek.pq;

import android.annotation.ProductApi;
import android.os.SystemProperties;
import android.util.Log;

public class PictureQuality {
    private static final String BLUELIGHT_DEFAULT_PROPERTY_NAME = "persist.vendor.sys.pq.bluelight.default";
    public static final int CAPABILITY_MASK_COLOR = 1;
    public static final int CAPABILITY_MASK_DC = 8;
    public static final int CAPABILITY_MASK_GAMMA = 4;
    public static final int CAPABILITY_MASK_OD = 16;
    public static final int CAPABILITY_MASK_SHARPNESS = 2;
    private static final String CHAMELEON_DEFAULT_PROPERTY_NAME = "persist.vendor.sys.pq.chameleon.default";
    public static final int DCHIST_INFO_NUM = 20;
    private static final String GAMMA_INDEX_PROPERTY_NAME = "persist.vendor.sys.pq.gamma.index";
    public static final int GAMMA_LUT_SIZE = 512;
    public static final int MODE_CAMERA = 1;
    public static final int MODE_MASK = 1;
    public static final int MODE_NORMAL = 0;
    public static final int MODE_VIDEO = 2;
    public static final int PIC_MODE_STANDARD = 0;
    public static final int PIC_MODE_USER_DEF = 2;
    public static final int PIC_MODE_VIVID = 1;
    static boolean sLibStatus = false;

    private static native boolean nativeEnableBlueLight(boolean z, int i);

    private static native boolean nativeEnableChameleon(boolean z, int i);

    private static native boolean nativeEnableColor(int i);

    private static native boolean nativeEnableColorEffect(int i);

    private static native boolean nativeEnableContentColor(int i);

    private static native boolean nativeEnableDynamicContrast(int i);

    private static native boolean nativeEnableDynamicSharpness(int i);

    private static native boolean nativeEnableGamma(int i);

    private static native boolean nativeEnableISOAdaptiveSharpness(int i);

    private static native boolean nativeEnableMdpCCORR(int i);

    private static native boolean nativeEnableMdpDRE(int i);

    private static native boolean nativeEnableOD(int i);

    private static native boolean nativeEnablePQ(int i);

    private static native boolean nativeEnableSharpness(int i);

    private static native boolean nativeEnableUltraResolution(int i);

    private static native boolean nativeEnableVideoHDR(boolean z);

    private static native int nativeGetAALFunction();

    private static native int nativeGetBlueLightStrength();

    private static native int nativeGetCapability();

    private static native int nativeGetChameleonStrength();

    private static native int nativeGetColorEffectIndex();

    private static native void nativeGetColorEffectIndexRange(Range range);

    private static native int nativeGetContrastIndex();

    private static native void nativeGetContrastIndexRange(Range range);

    private static native int nativeGetDefaultOffTransitionStep();

    private static native int nativeGetDefaultOnTransitionStep();

    private static native void nativeGetDynamicContrastHistogram(byte[] bArr, int i, int i2, Hist hist);

    private static native int nativeGetDynamicContrastIndex();

    private static native void nativeGetDynamicContrastIndexRange(Range range);

    private static native int nativeGetESSLEDMinStep();

    private static native int nativeGetESSOLEDMinStep();

    private static native int nativeGetExternalPanelNits();

    private static native void nativeGetGammaIndexRange(Range range);

    private static native int nativeGetGlobalPQStrength();

    private static native int nativeGetGlobalPQStrengthRange();

    private static native int nativeGetGlobalPQSwitch();

    private static native int nativeGetPicBrightnessIndex();

    private static native void nativeGetPicBrightnessIndexRange(Range range);

    private static native int nativeGetPictureMode();

    private static native int[] nativeGetRGBGain();

    private static native int nativeGetSaturationIndex();

    private static native void nativeGetSaturationIndexRange(Range range);

    private static native int nativeGetSharpnessIndex();

    private static native void nativeGetSharpnessIndexRange(Range range);

    private static native boolean nativeIsBlueLightEnabled();

    private static native boolean nativeIsChameleonEnabled();

    private static native boolean nativeIsVideoHDREnabled();

    private static native void nativeSetAALFunction(int i);

    private static native void nativeSetAALFunctionProperty(int i);

    private static native boolean nativeSetBlueLightStrength(int i, int i2);

    private static native void nativeSetCameraPreviewMode(int i);

    private static native boolean nativeSetCcorrMatrix(int[] iArr, int i);

    private static native boolean nativeSetChameleonStrength(int i, int i2);

    private static native void nativeSetColorEffectIndex(int i);

    private static native boolean nativeSetColorRegion(int i, int i2, int i3, int i4, int i5);

    private static native void nativeSetContrastIndex(int i, int i2);

    private static native void nativeSetDynamicContrastIndex(int i);

    private static native void nativeSetESS20Enable(boolean z, int i, boolean z2);

    private static native boolean nativeSetESSLEDMinStep(int i);

    private static native boolean nativeSetESSOLEDMinStep(int i);

    private static native boolean nativeSetExternalPanelNits(int i);

    private static native void nativeSetGalleryNormalMode(int i);

    private static native void nativeSetGammaIndex(int i, int i2);

    private static native boolean nativeSetGlobalPQStrength(int i);

    private static native boolean nativeSetGlobalPQSwitch(int i);

    private static native void nativeSetLowBLReadabilityLevel(int i);

    private static native void nativeSetPicBrightnessIndex(int i, int i2);

    private static native boolean nativeSetPictureMode(int i, int i2);

    private static native boolean nativeSetRGBGain(int i, int i2, int i3, int i4);

    private static native void nativeSetReadabilityLevel(int i);

    private static native void nativeSetSaturationIndex(int i, int i2);

    private static native void nativeSetSharpnessIndex(int i);

    private static native void nativeSetSmartBacklightStrength(int i);

    private static native void nativeSetVideoPlaybackMode(int i);

    public static class Hist {
        public int[] info = new int[20];

        public Hist() {
            for (int i = 0; i < 20; i++) {
                set(i, 0);
            }
        }

        public void set(int i, int i2) {
            if (i >= 0 && i < 20) {
                this.info[i] = i2;
            }
        }
    }

    public static class Range {
        public int defaultValue;
        public int max;
        public int min;

        public Range() {
            set(0, 0, 0);
        }

        public void set(int i, int i2, int i3) {
            this.min = i;
            this.max = i2;
            this.defaultValue = i3;
        }
    }

    public static class GammaLut {
        public int hwid;
        public int[] lut = new int[512];

        public GammaLut() {
            for (int i = 0; i < 512; i++) {
                set(i, 0);
            }
        }

        public void set(int i, int i2) {
            if (i >= 0 && i < 512) {
                this.lut[i] = i2;
            }
        }
    }

    static {
        try {
            Log.v("JNI_PQ", "loadLibrary");
            System.loadLibrary("jni_pq");
        } catch (UnsatisfiedLinkError unused) {
            Log.e("JNI_PQ", "UnsatisfiedLinkError");
        }
    }

    public static boolean getLibStatus() {
        return sLibStatus;
    }

    public static int getCapability() {
        return nativeGetCapability();
    }

    public static String setMode(int i, int i2) {
        if (i == 1) {
            nativeSetCameraPreviewMode(i2);
            return null;
        } else if (i == 2) {
            nativeSetVideoPlaybackMode(i2);
            return null;
        } else {
            nativeSetGalleryNormalMode(i2);
            return null;
        }
    }

    @ProductApi
    public static String setMode(int i) {
        if (i == 1) {
            nativeSetCameraPreviewMode(getDefaultOnTransitionStep());
            return null;
        } else if (i == 2) {
            nativeSetVideoPlaybackMode(getDefaultOnTransitionStep());
            return null;
        } else {
            nativeSetGalleryNormalMode(getDefaultOnTransitionStep());
            return null;
        }
    }

    public static Hist getDynamicContrastHistogram(byte[] bArr, int i, int i2) {
        Hist hist = new Hist();
        nativeGetDynamicContrastHistogram(bArr, i, i2, hist);
        return hist;
    }

    public static boolean enablePQ(int i) {
        return nativeEnablePQ(i);
    }

    public static boolean enableColor(int i) {
        return nativeEnableColor(i);
    }

    public static boolean enableContentColor(int i) {
        return nativeEnableContentColor(i);
    }

    public static boolean enableSharpness(int i) {
        return nativeEnableSharpness(i);
    }

    public static boolean enableDynamicContrast(int i) {
        return nativeEnableDynamicContrast(i);
    }

    public static boolean enableDynamicSharpness(int i) {
        return nativeEnableDynamicSharpness(i);
    }

    public static boolean enableColorEffect(int i) {
        return nativeEnableColorEffect(i);
    }

    public static boolean enableGamma(int i) {
        return nativeEnableGamma(i);
    }

    public static boolean enableOD(int i) {
        return nativeEnableOD(i);
    }

    public static boolean enableISOAdaptiveSharpness(int i) {
        return nativeEnableISOAdaptiveSharpness(i);
    }

    public static boolean enableUltraResolution(int i) {
        return nativeEnableUltraResolution(i);
    }

    public static int getPictureMode() {
        return nativeGetPictureMode();
    }

    public static boolean setPictureMode(int i, int i2) {
        return nativeSetPictureMode(i, i2);
    }

    public static boolean setPictureMode(int i) {
        return nativeSetPictureMode(i, getDefaultOffTransitionStep());
    }

    public static boolean setColorRegion(int i, int i2, int i3, int i4, int i5) {
        return nativeSetColorRegion(i, i2, i3, i4, i5);
    }

    public static Range getContrastIndexRange() {
        Range range = new Range();
        nativeGetContrastIndexRange(range);
        return range;
    }

    public static int getContrastIndex() {
        return nativeGetContrastIndex();
    }

    public static void setContrastIndex(int i, int i2) {
        nativeSetContrastIndex(i, i2);
    }

    public static void setContrastIndex(int i) {
        nativeSetContrastIndex(i, getDefaultOffTransitionStep());
    }

    public static Range getSaturationIndexRange() {
        Range range = new Range();
        nativeGetSaturationIndexRange(range);
        return range;
    }

    public static int getSaturationIndex() {
        return nativeGetSaturationIndex();
    }

    public static void setSaturationIndex(int i, int i2) {
        nativeSetSaturationIndex(i, i2);
    }

    public static void setSaturationIndex(int i) {
        nativeSetSaturationIndex(i, getDefaultOffTransitionStep());
    }

    public static Range getPicBrightnessIndexRange() {
        Range range = new Range();
        nativeGetPicBrightnessIndexRange(range);
        return range;
    }

    public static int getPicBrightnessIndex() {
        return nativeGetPicBrightnessIndex();
    }

    public static void setPicBrightnessIndex(int i, int i2) {
        nativeSetPicBrightnessIndex(i, i2);
    }

    public static void setPicBrightnessIndex(int i) {
        nativeSetPicBrightnessIndex(i, getDefaultOffTransitionStep());
    }

    public static Range getSharpnessIndexRange() {
        Range range = new Range();
        nativeGetSharpnessIndexRange(range);
        return range;
    }

    public static int getSharpnessIndex() {
        return nativeGetSharpnessIndex();
    }

    public static void setSharpnessIndex(int i) {
        nativeSetSharpnessIndex(i);
    }

    public static Range getDynamicContrastIndexRange() {
        Range range = new Range();
        nativeGetDynamicContrastIndexRange(range);
        return range;
    }

    public static int getDynamicContrastIndex() {
        return nativeGetDynamicContrastIndex();
    }

    public static void setDynamicContrastIndex(int i) {
        nativeSetDynamicContrastIndex(i);
    }

    public static Range getColorEffectIndexRange() {
        Range range = new Range();
        nativeGetColorEffectIndexRange(range);
        return range;
    }

    public static int getColorEffectIndex() {
        return nativeGetColorEffectIndex();
    }

    public static void setColorEffectIndex(int i) {
        nativeSetColorEffectIndex(i);
    }

    public static Range getGammaIndexRange() {
        Range range = new Range();
        nativeGetGammaIndexRange(range);
        return range;
    }

    public static void setGammaIndex(int i, int i2) {
        nativeSetGammaIndex(i, i2);
    }

    public static void setGammaIndex(int i) {
        nativeSetGammaIndex(i, getDefaultOnTransitionStep());
    }

    public static int getGammaIndex() {
        return SystemProperties.getInt(GAMMA_INDEX_PROPERTY_NAME, getGammaIndexRange().defaultValue);
    }

    public static Range getBlueLightStrengthRange() {
        Range range = new Range();
        range.set(0, 255, SystemProperties.getInt(BLUELIGHT_DEFAULT_PROPERTY_NAME, 128));
        return range;
    }

    public static boolean setBlueLightStrength(int i, int i2) {
        return nativeSetBlueLightStrength(i, i2);
    }

    public static boolean setBlueLightStrength(int i) {
        return nativeSetBlueLightStrength(i, getDefaultOffTransitionStep());
    }

    public static int getBlueLightStrength() {
        return nativeGetBlueLightStrength();
    }

    public static boolean enableBlueLight(boolean z, int i) {
        return nativeEnableBlueLight(z, i);
    }

    public static boolean enableBlueLight(boolean z) {
        return nativeEnableBlueLight(z, getDefaultOnTransitionStep());
    }

    public static boolean isBlueLightEnabled() {
        return nativeIsBlueLightEnabled();
    }

    public static Range getChameleonStrengthRange() {
        Range range = new Range();
        range.set(0, 255, SystemProperties.getInt(CHAMELEON_DEFAULT_PROPERTY_NAME, 128));
        return range;
    }

    public static boolean setChameleonStrength(int i, int i2) {
        return nativeSetChameleonStrength(i, i2);
    }

    public static boolean setChameleonStrength(int i) {
        return nativeSetChameleonStrength(i, getDefaultOffTransitionStep());
    }

    public static int getChameleonStrength() {
        return nativeGetChameleonStrength();
    }

    public static boolean enableChameleon(boolean z, int i) {
        return nativeEnableChameleon(z, i);
    }

    public static boolean enableChameleon(boolean z) {
        return nativeEnableChameleon(z, getDefaultOnTransitionStep());
    }

    public static boolean isChameleonEnabled() {
        return nativeIsChameleonEnabled();
    }

    public static int getDefaultOffTransitionStep() {
        return nativeGetDefaultOffTransitionStep();
    }

    public static int getDefaultOnTransitionStep() {
        return nativeGetDefaultOnTransitionStep();
    }

    public static boolean setGlobalPQSwitch(int i) {
        return nativeSetGlobalPQSwitch(i);
    }

    public static int getGlobalPQSwitch() {
        return nativeGetGlobalPQSwitch();
    }

    public static boolean setGlobalPQStrength(int i) {
        return nativeSetGlobalPQStrength(i);
    }

    public static int getGlobalPQStrength() {
        return nativeGetGlobalPQStrength();
    }

    public static int getGlobalPQStrengthRange() {
        return nativeGetGlobalPQStrengthRange();
    }

    public static boolean enableVideoHDR(boolean z) {
        return nativeEnableVideoHDR(z);
    }

    public static boolean isVideoHDREnabled() {
        return nativeIsVideoHDREnabled();
    }

    public static boolean enableMdpDRE(int i) {
        return nativeEnableMdpDRE(i);
    }

    public static boolean enableMdpCCORR(int i) {
        return nativeEnableMdpCCORR(i);
    }

    public static int getAALFunction() {
        return nativeGetAALFunction();
    }

    public static void setAALFunction(int i) {
        nativeSetAALFunction(i);
    }

    public static void setAALFunctionProperty(int i) {
        nativeSetAALFunctionProperty(i);
    }

    public static void setSmartBacklightStrength(int i) {
        nativeSetSmartBacklightStrength(i);
    }

    public static void setReadabilityLevel(int i) {
        nativeSetReadabilityLevel(i);
    }

    public static void setLowBLReadabilityLevel(int i) {
        nativeSetLowBLReadabilityLevel(i);
    }

    public static boolean setESSLEDMinStep(int i) {
        return nativeSetESSLEDMinStep(i);
    }

    public static int getESSLEDMinStep() {
        return nativeGetESSLEDMinStep();
    }

    public static boolean setESSOLEDMinStep(int i) {
        return nativeSetESSOLEDMinStep(i);
    }

    public static int getESSOLEDMinStep() {
        return nativeGetESSOLEDMinStep();
    }

    public static boolean setExternalPanelNits(int i) {
        return nativeSetExternalPanelNits(i);
    }

    public static int getExternalPanelNits() {
        return nativeGetExternalPanelNits();
    }

    public static boolean setRGBGain(double d, double d2, double d3, int i) {
        return nativeSetRGBGain((int) (d * 1024.0d), (int) (d2 * 1024.0d), (int) (d3 * 1024.0d), i);
    }

    public static double[] getRGBGain() {
        double[] dArr = new double[3];
        int[] nativeGetRGBGain = nativeGetRGBGain();
        if (nativeGetRGBGain == null) {
            Log.e("PQ", "getRGBGain() return null arr");
            return null;
        }
        dArr[0] = ((double) nativeGetRGBGain[0]) / 1024.0d;
        dArr[1] = ((double) nativeGetRGBGain[1]) / 1024.0d;
        dArr[2] = ((double) nativeGetRGBGain[2]) / 1024.0d;
        return dArr;
    }

    public static boolean setCcorrMatrix(double[] dArr, int i) {
        int[] iArr = new int[9];
        if (dArr == null) {
            Log.e("PQ", "setCcorrMatrix() matrix is null");
            return false;
        } else if (dArr.length == 9) {
            for (int i2 = 0; i2 < 9; i2++) {
                iArr[i2] = (int) (dArr[i2] * 1024.0d);
            }
            return nativeSetCcorrMatrix(iArr, i);
        } else {
            throw new IllegalArgumentException("Expected length: 9 (3x3 matrix), actual length: " + dArr.length);
        }
    }

    public static void SetESS20Enable(boolean z, int i, boolean z2) {
        nativeSetESS20Enable(z, i, z2);
    }
}
