.class public Lcom/mediatek/pq/PictureQuality;
.super Ljava/lang/Object;
.source "PictureQuality.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/mediatek/pq/PictureQuality$GammaLut;,
        Lcom/mediatek/pq/PictureQuality$Range;,
        Lcom/mediatek/pq/PictureQuality$Hist;
    }
.end annotation


# static fields
.field private static final BLUELIGHT_DEFAULT_PROPERTY_NAME:Ljava/lang/String; = "persist.vendor.sys.pq.bluelight.default"

.field public static final CAPABILITY_MASK_COLOR:I = 0x1

.field public static final CAPABILITY_MASK_DC:I = 0x8

.field public static final CAPABILITY_MASK_GAMMA:I = 0x4

.field public static final CAPABILITY_MASK_OD:I = 0x10

.field public static final CAPABILITY_MASK_SHARPNESS:I = 0x2

.field private static final CHAMELEON_DEFAULT_PROPERTY_NAME:Ljava/lang/String; = "persist.vendor.sys.pq.chameleon.default"

.field public static final DCHIST_INFO_NUM:I = 0x14

.field private static final GAMMA_INDEX_PROPERTY_NAME:Ljava/lang/String; = "persist.vendor.sys.pq.gamma.index"

.field public static final GAMMA_LUT_SIZE:I = 0x200

.field public static final MODE_CAMERA:I = 0x1

.field public static final MODE_MASK:I = 0x1

.field public static final MODE_NORMAL:I = 0x0

.field public static final MODE_VIDEO:I = 0x2

.field public static final PIC_MODE_STANDARD:I = 0x0

.field public static final PIC_MODE_USER_DEF:I = 0x2

.field public static final PIC_MODE_VIVID:I = 0x1

.field static sLibStatus:Z = true


# direct methods
.method static constructor <clinit>()V
    .locals 2

    const-string v0, "JNI_PQ"

    :try_start_0
    const-string v1, "loadLibrary"

    .line 138
    invoke-static {v0, v1}, Landroid/util/Log;->v(Ljava/lang/String;Ljava/lang/String;)I

    const-string v1, "jni_pq"

    .line 139
    invoke-static {v1}, Ljava/lang/System;->loadLibrary(Ljava/lang/String;)V
    :try_end_0
    .catch Ljava/lang/UnsatisfiedLinkError; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    :catch_0
    const-string v1, "UnsatisfiedLinkError"

    .line 141
    invoke-static {v0, v1}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    const/4 v0, 0x0

    .line 142
    sput-boolean v0, Lcom/mediatek/pq/PictureQuality;->sLibStatus:Z

    :goto_0
    return-void
.end method

.method public constructor <init>()V
    .locals 0

    .line 60
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static SetESS20Enable(ZIZ)V
    .locals 0

    .line 767
    invoke-static {p0, p1, p2}, Lcom/mediatek/pq/PictureQuality;->nativeSetESS20Enable(ZIZ)V

    return-void
.end method

.method public static enableBlueLight(Z)Z
    .locals 1

    .line 468
    invoke-static {}, Lcom/mediatek/pq/PictureQuality;->getDefaultOnTransitionStep()I

    move-result v0

    invoke-static {p0, v0}, Lcom/mediatek/pq/PictureQuality;->nativeEnableBlueLight(ZI)Z

    move-result p0

    return p0
.end method

.method public static enableBlueLight(ZI)Z
    .locals 0

    .line 464
    invoke-static {p0, p1}, Lcom/mediatek/pq/PictureQuality;->nativeEnableBlueLight(ZI)Z

    move-result p0

    return p0
.end method

.method public static enableChameleon(Z)Z
    .locals 1

    .line 521
    invoke-static {}, Lcom/mediatek/pq/PictureQuality;->getDefaultOnTransitionStep()I

    move-result v0

    invoke-static {p0, v0}, Lcom/mediatek/pq/PictureQuality;->nativeEnableChameleon(ZI)Z

    move-result p0

    return p0
.end method

.method public static enableChameleon(ZI)Z
    .locals 0

    .line 517
    invoke-static {p0, p1}, Lcom/mediatek/pq/PictureQuality;->nativeEnableChameleon(ZI)Z

    move-result p0

    return p0
.end method

.method public static enableColor(I)Z
    .locals 0

    .line 212
    invoke-static {p0}, Lcom/mediatek/pq/PictureQuality;->nativeEnableColor(I)Z

    move-result p0

    return p0
.end method

.method public static enableColorEffect(I)Z
    .locals 0

    .line 240
    invoke-static {p0}, Lcom/mediatek/pq/PictureQuality;->nativeEnableColorEffect(I)Z

    move-result p0

    return p0
.end method

.method public static enableContentColor(I)Z
    .locals 0

    .line 217
    invoke-static {p0}, Lcom/mediatek/pq/PictureQuality;->nativeEnableContentColor(I)Z

    move-result p0

    return p0
.end method

.method public static enableDynamicContrast(I)Z
    .locals 0

    .line 229
    invoke-static {p0}, Lcom/mediatek/pq/PictureQuality;->nativeEnableDynamicContrast(I)Z

    move-result p0

    return p0
.end method

.method public static enableDynamicSharpness(I)Z
    .locals 0

    .line 234
    invoke-static {p0}, Lcom/mediatek/pq/PictureQuality;->nativeEnableDynamicSharpness(I)Z

    move-result p0

    return p0
.end method

.method public static enableGamma(I)Z
    .locals 0

    .line 246
    invoke-static {p0}, Lcom/mediatek/pq/PictureQuality;->nativeEnableGamma(I)Z

    move-result p0

    return p0
.end method

.method public static enableISOAdaptiveSharpness(I)Z
    .locals 0

    .line 255
    invoke-static {p0}, Lcom/mediatek/pq/PictureQuality;->nativeEnableISOAdaptiveSharpness(I)Z

    move-result p0

    return p0
.end method

.method public static enableMdpCCORR(I)Z
    .locals 0

    .line 618
    invoke-static {p0}, Lcom/mediatek/pq/PictureQuality;->nativeEnableMdpCCORR(I)Z

    move-result p0

    return p0
.end method

.method public static enableMdpDRE(I)Z
    .locals 0

    .line 611
    invoke-static {p0}, Lcom/mediatek/pq/PictureQuality;->nativeEnableMdpDRE(I)Z

    move-result p0

    return p0
.end method

.method public static enableOD(I)Z
    .locals 0

    .line 251
    invoke-static {p0}, Lcom/mediatek/pq/PictureQuality;->nativeEnableOD(I)Z

    move-result p0

    return p0
.end method

.method public static enablePQ(I)Z
    .locals 0

    .line 206
    invoke-static {p0}, Lcom/mediatek/pq/PictureQuality;->nativeEnablePQ(I)Z

    move-result p0

    return p0
.end method

.method public static enableSharpness(I)Z
    .locals 0

    .line 223
    invoke-static {p0}, Lcom/mediatek/pq/PictureQuality;->nativeEnableSharpness(I)Z

    move-result p0

    return p0
.end method

.method public static enableUltraResolution(I)Z
    .locals 0

    .line 259
    invoke-static {p0}, Lcom/mediatek/pq/PictureQuality;->nativeEnableUltraResolution(I)Z

    move-result p0

    return p0
.end method

.method public static enableVideoHDR(Z)Z
    .locals 0

    .line 597
    invoke-static {p0}, Lcom/mediatek/pq/PictureQuality;->nativeEnableVideoHDR(Z)Z

    move-result p0

    return p0
.end method

.method public static getAALFunction()I
    .locals 1

    .line 625
    invoke-static {}, Lcom/mediatek/pq/PictureQuality;->nativeGetAALFunction()I

    move-result v0

    return v0
.end method

.method public static getBlueLightStrength()I
    .locals 1

    .line 457
    invoke-static {}, Lcom/mediatek/pq/PictureQuality;->nativeGetBlueLightStrength()I

    move-result v0

    return v0
.end method

.method public static getBlueLightStrengthRange()Lcom/mediatek/pq/PictureQuality$Range;
    .locals 4

    .line 433
    new-instance v0, Lcom/mediatek/pq/PictureQuality$Range;

    invoke-direct {v0}, Lcom/mediatek/pq/PictureQuality$Range;-><init>()V

    const-string v1, "persist.vendor.sys.pq.bluelight.default"

    const/16 v2, 0x80

    .line 434
    invoke-static {v1, v2}, Landroid/os/SystemProperties;->getInt(Ljava/lang/String;I)I

    move-result v1

    const/4 v2, 0x0

    const/16 v3, 0xff

    invoke-virtual {v0, v2, v3, v1}, Lcom/mediatek/pq/PictureQuality$Range;->set(III)V

    return-object v0
.end method

.method public static getCapability()I
    .locals 1

    .line 156
    invoke-static {}, Lcom/mediatek/pq/PictureQuality;->nativeGetCapability()I

    move-result v0

    return v0
.end method

.method public static getChameleonStrength()I
    .locals 1

    .line 510
    invoke-static {}, Lcom/mediatek/pq/PictureQuality;->nativeGetChameleonStrength()I

    move-result v0

    return v0
.end method

.method public static getChameleonStrengthRange()Lcom/mediatek/pq/PictureQuality$Range;
    .locals 4

    .line 486
    new-instance v0, Lcom/mediatek/pq/PictureQuality$Range;

    invoke-direct {v0}, Lcom/mediatek/pq/PictureQuality$Range;-><init>()V

    const-string v1, "persist.vendor.sys.pq.chameleon.default"

    const/16 v2, 0x80

    .line 487
    invoke-static {v1, v2}, Landroid/os/SystemProperties;->getInt(Ljava/lang/String;I)I

    move-result v1

    const/4 v2, 0x0

    const/16 v3, 0xff

    invoke-virtual {v0, v2, v3, v1}, Lcom/mediatek/pq/PictureQuality$Range;->set(III)V

    return-object v0
.end method

.method public static getColorEffectIndex()I
    .locals 1

    .line 381
    invoke-static {}, Lcom/mediatek/pq/PictureQuality;->nativeGetColorEffectIndex()I

    move-result v0

    return v0
.end method

.method public static getColorEffectIndexRange()Lcom/mediatek/pq/PictureQuality$Range;
    .locals 1

    .line 375
    new-instance v0, Lcom/mediatek/pq/PictureQuality$Range;

    invoke-direct {v0}, Lcom/mediatek/pq/PictureQuality$Range;-><init>()V

    .line 376
    invoke-static {v0}, Lcom/mediatek/pq/PictureQuality;->nativeGetColorEffectIndexRange(Lcom/mediatek/pq/PictureQuality$Range;)V

    return-object v0
.end method

.method public static getContrastIndex()I
    .locals 1

    .line 294
    invoke-static {}, Lcom/mediatek/pq/PictureQuality;->nativeGetContrastIndex()I

    move-result v0

    return v0
.end method

.method public static getContrastIndexRange()Lcom/mediatek/pq/PictureQuality$Range;
    .locals 1

    .line 288
    new-instance v0, Lcom/mediatek/pq/PictureQuality$Range;

    invoke-direct {v0}, Lcom/mediatek/pq/PictureQuality$Range;-><init>()V

    .line 289
    invoke-static {v0}, Lcom/mediatek/pq/PictureQuality;->nativeGetContrastIndexRange(Lcom/mediatek/pq/PictureQuality$Range;)V

    return-object v0
.end method

.method public static getDefaultOffTransitionStep()I
    .locals 1

    .line 537
    invoke-static {}, Lcom/mediatek/pq/PictureQuality;->nativeGetDefaultOffTransitionStep()I

    move-result v0

    return v0
.end method

.method public static getDefaultOnTransitionStep()I
    .locals 1

    .line 546
    invoke-static {}, Lcom/mediatek/pq/PictureQuality;->nativeGetDefaultOnTransitionStep()I

    move-result v0

    return v0
.end method

.method public static getDynamicContrastHistogram([BII)Lcom/mediatek/pq/PictureQuality$Hist;
    .locals 1

    .line 198
    new-instance v0, Lcom/mediatek/pq/PictureQuality$Hist;

    invoke-direct {v0}, Lcom/mediatek/pq/PictureQuality$Hist;-><init>()V

    .line 199
    invoke-static {p0, p1, p2, v0}, Lcom/mediatek/pq/PictureQuality;->nativeGetDynamicContrastHistogram([BIILcom/mediatek/pq/PictureQuality$Hist;)V

    return-object v0
.end method

.method public static getDynamicContrastIndex()I
    .locals 1

    .line 366
    invoke-static {}, Lcom/mediatek/pq/PictureQuality;->nativeGetDynamicContrastIndex()I

    move-result v0

    return v0
.end method

.method public static getDynamicContrastIndexRange()Lcom/mediatek/pq/PictureQuality$Range;
    .locals 1

    .line 360
    new-instance v0, Lcom/mediatek/pq/PictureQuality$Range;

    invoke-direct {v0}, Lcom/mediatek/pq/PictureQuality$Range;-><init>()V

    .line 361
    invoke-static {v0}, Lcom/mediatek/pq/PictureQuality;->nativeGetDynamicContrastIndexRange(Lcom/mediatek/pq/PictureQuality$Range;)V

    return-object v0
.end method

.method public static getESSLEDMinStep()I
    .locals 1

    .line 673
    invoke-static {}, Lcom/mediatek/pq/PictureQuality;->nativeGetESSLEDMinStep()I

    move-result v0

    return v0
.end method

.method public static getESSOLEDMinStep()I
    .locals 1

    .line 689
    invoke-static {}, Lcom/mediatek/pq/PictureQuality;->nativeGetESSOLEDMinStep()I

    move-result v0

    return v0
.end method

.method public static getExternalPanelNits()I
    .locals 1

    .line 706
    invoke-static {}, Lcom/mediatek/pq/PictureQuality;->nativeGetExternalPanelNits()I

    move-result v0

    return v0
.end method

.method public static getGammaIndex()I
    .locals 2

    .line 422
    invoke-static {}, Lcom/mediatek/pq/PictureQuality;->getGammaIndexRange()Lcom/mediatek/pq/PictureQuality$Range;

    move-result-object v0

    iget v0, v0, Lcom/mediatek/pq/PictureQuality$Range;->defaultValue:I

    const-string v1, "persist.vendor.sys.pq.gamma.index"

    invoke-static {v1, v0}, Landroid/os/SystemProperties;->getInt(Ljava/lang/String;I)I

    move-result v0

    return v0
.end method

.method public static getGammaIndexRange()Lcom/mediatek/pq/PictureQuality$Range;
    .locals 1

    .line 397
    new-instance v0, Lcom/mediatek/pq/PictureQuality$Range;

    invoke-direct {v0}, Lcom/mediatek/pq/PictureQuality$Range;-><init>()V

    .line 398
    invoke-static {v0}, Lcom/mediatek/pq/PictureQuality;->nativeGetGammaIndexRange(Lcom/mediatek/pq/PictureQuality$Range;)V

    return-object v0
.end method

.method public static getGlobalPQStrength()I
    .locals 1

    .line 582
    invoke-static {}, Lcom/mediatek/pq/PictureQuality;->nativeGetGlobalPQStrength()I

    move-result v0

    return v0
.end method

.method public static getGlobalPQStrengthRange()I
    .locals 1

    .line 590
    invoke-static {}, Lcom/mediatek/pq/PictureQuality;->nativeGetGlobalPQStrengthRange()I

    move-result v0

    return v0
.end method

.method public static getGlobalPQSwitch()I
    .locals 1

    .line 564
    invoke-static {}, Lcom/mediatek/pq/PictureQuality;->nativeGetGlobalPQSwitch()I

    move-result v0

    return v0
.end method

.method public static getLibStatus()Z
    .locals 1

    .line 147
    sget-boolean v0, Lcom/mediatek/pq/PictureQuality;->sLibStatus:Z

    return v0
.end method

.method public static getPicBrightnessIndex()I
    .locals 1

    .line 332
    invoke-static {}, Lcom/mediatek/pq/PictureQuality;->nativeGetPicBrightnessIndex()I

    move-result v0

    return v0
.end method

.method public static getPicBrightnessIndexRange()Lcom/mediatek/pq/PictureQuality$Range;
    .locals 1

    .line 326
    new-instance v0, Lcom/mediatek/pq/PictureQuality$Range;

    invoke-direct {v0}, Lcom/mediatek/pq/PictureQuality$Range;-><init>()V

    .line 327
    invoke-static {v0}, Lcom/mediatek/pq/PictureQuality;->nativeGetPicBrightnessIndexRange(Lcom/mediatek/pq/PictureQuality$Range;)V

    return-object v0
.end method

.method public static getPictureMode()I
    .locals 1

    .line 265
    invoke-static {}, Lcom/mediatek/pq/PictureQuality;->nativeGetPictureMode()I

    move-result v0

    return v0
.end method

.method public static getRGBGain()[D
    .locals 7

    const/4 v0, 0x3

    new-array v0, v0, [D

    .line 731
    invoke-static {}, Lcom/mediatek/pq/PictureQuality;->nativeGetRGBGain()[I

    move-result-object v1

    if-nez v1, :cond_0

    const-string v0, "PQ"

    const-string v1, "getRGBGain() return null arr"

    .line 733
    invoke-static {v0, v1}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    const/4 v0, 0x0

    return-object v0

    :cond_0
    const/4 v2, 0x0

    .line 736
    aget v3, v1, v2

    int-to-double v3, v3

    const-wide/high16 v5, 0x4090000000000000L    # 1024.0

    div-double/2addr v3, v5

    aput-wide v3, v0, v2

    const/4 v2, 0x1

    .line 737
    aget v3, v1, v2

    int-to-double v3, v3

    div-double/2addr v3, v5

    aput-wide v3, v0, v2

    const/4 v2, 0x2

    .line 738
    aget v1, v1, v2

    int-to-double v3, v1

    div-double/2addr v3, v5

    aput-wide v3, v0, v2

    return-object v0
.end method

.method public static getSaturationIndex()I
    .locals 1

    .line 313
    invoke-static {}, Lcom/mediatek/pq/PictureQuality;->nativeGetSaturationIndex()I

    move-result v0

    return v0
.end method

.method public static getSaturationIndexRange()Lcom/mediatek/pq/PictureQuality$Range;
    .locals 1

    .line 307
    new-instance v0, Lcom/mediatek/pq/PictureQuality$Range;

    invoke-direct {v0}, Lcom/mediatek/pq/PictureQuality$Range;-><init>()V

    .line 308
    invoke-static {v0}, Lcom/mediatek/pq/PictureQuality;->nativeGetSaturationIndexRange(Lcom/mediatek/pq/PictureQuality$Range;)V

    return-object v0
.end method

.method public static getSharpnessIndex()I
    .locals 1

    .line 351
    invoke-static {}, Lcom/mediatek/pq/PictureQuality;->nativeGetSharpnessIndex()I

    move-result v0

    return v0
.end method

.method public static getSharpnessIndexRange()Lcom/mediatek/pq/PictureQuality$Range;
    .locals 1

    .line 345
    new-instance v0, Lcom/mediatek/pq/PictureQuality$Range;

    invoke-direct {v0}, Lcom/mediatek/pq/PictureQuality$Range;-><init>()V

    .line 346
    invoke-static {v0}, Lcom/mediatek/pq/PictureQuality;->nativeGetSharpnessIndexRange(Lcom/mediatek/pq/PictureQuality$Range;)V

    return-object v0
.end method

.method public static isBlueLightEnabled()Z
    .locals 1

    .line 475
    invoke-static {}, Lcom/mediatek/pq/PictureQuality;->nativeIsBlueLightEnabled()Z

    move-result v0

    return v0
.end method

.method public static isChameleonEnabled()Z
    .locals 1

    .line 528
    invoke-static {}, Lcom/mediatek/pq/PictureQuality;->nativeIsChameleonEnabled()Z

    move-result v0

    return v0
.end method

.method public static isVideoHDREnabled()Z
    .locals 1

    .line 604
    invoke-static {}, Lcom/mediatek/pq/PictureQuality;->nativeIsVideoHDREnabled()Z

    move-result v0

    return v0
.end method

.method private static native nativeEnableBlueLight(ZI)Z
.end method

.method private static native nativeEnableChameleon(ZI)Z
.end method

.method private static native nativeEnableColor(I)Z
.end method

.method private static native nativeEnableColorEffect(I)Z
.end method

.method private static native nativeEnableContentColor(I)Z
.end method

.method private static native nativeEnableDynamicContrast(I)Z
.end method

.method private static native nativeEnableDynamicSharpness(I)Z
.end method

.method private static native nativeEnableGamma(I)Z
.end method

.method private static native nativeEnableISOAdaptiveSharpness(I)Z
.end method

.method private static native nativeEnableMdpCCORR(I)Z
.end method

.method private static native nativeEnableMdpDRE(I)Z
.end method

.method private static native nativeEnableOD(I)Z
.end method

.method private static native nativeEnablePQ(I)Z
.end method

.method private static native nativeEnableSharpness(I)Z
.end method

.method private static native nativeEnableUltraResolution(I)Z
.end method

.method private static native nativeEnableVideoHDR(Z)Z
.end method

.method private static native nativeGetAALFunction()I
.end method

.method private static native nativeGetBlueLightStrength()I
.end method

.method private static native nativeGetCapability()I
.end method

.method private static native nativeGetChameleonStrength()I
.end method

.method private static native nativeGetColorEffectIndex()I
.end method

.method private static native nativeGetColorEffectIndexRange(Lcom/mediatek/pq/PictureQuality$Range;)V
.end method

.method private static native nativeGetContrastIndex()I
.end method

.method private static native nativeGetContrastIndexRange(Lcom/mediatek/pq/PictureQuality$Range;)V
.end method

.method private static native nativeGetDefaultOffTransitionStep()I
.end method

.method private static native nativeGetDefaultOnTransitionStep()I
.end method

.method private static native nativeGetDynamicContrastHistogram([BIILcom/mediatek/pq/PictureQuality$Hist;)V
.end method

.method private static native nativeGetDynamicContrastIndex()I
.end method

.method private static native nativeGetDynamicContrastIndexRange(Lcom/mediatek/pq/PictureQuality$Range;)V
.end method

.method private static native nativeGetESSLEDMinStep()I
.end method

.method private static native nativeGetESSOLEDMinStep()I
.end method

.method private static native nativeGetExternalPanelNits()I
.end method

.method private static native nativeGetGammaIndexRange(Lcom/mediatek/pq/PictureQuality$Range;)V
.end method

.method private static native nativeGetGlobalPQStrength()I
.end method

.method private static native nativeGetGlobalPQStrengthRange()I
.end method

.method private static native nativeGetGlobalPQSwitch()I
.end method

.method private static native nativeGetPicBrightnessIndex()I
.end method

.method private static native nativeGetPicBrightnessIndexRange(Lcom/mediatek/pq/PictureQuality$Range;)V
.end method

.method private static native nativeGetPictureMode()I
.end method

.method private static native nativeGetRGBGain()[I
.end method

.method private static native nativeGetSaturationIndex()I
.end method

.method private static native nativeGetSaturationIndexRange(Lcom/mediatek/pq/PictureQuality$Range;)V
.end method

.method private static native nativeGetSharpnessIndex()I
.end method

.method private static native nativeGetSharpnessIndexRange(Lcom/mediatek/pq/PictureQuality$Range;)V
.end method

.method private static native nativeIsBlueLightEnabled()Z
.end method

.method private static native nativeIsChameleonEnabled()Z
.end method

.method private static native nativeIsVideoHDREnabled()Z
.end method

.method private static native nativeSetAALFunction(I)V
.end method

.method private static native nativeSetAALFunctionProperty(I)V
.end method

.method private static native nativeSetBlueLightStrength(II)Z
.end method

.method private static native nativeSetCameraPreviewMode(I)V
.end method

.method private static native nativeSetCcorrMatrix([II)Z
.end method

.method private static native nativeSetChameleonStrength(II)Z
.end method

.method private static native nativeSetColorEffectIndex(I)V
.end method

.method private static native nativeSetColorRegion(IIIII)Z
.end method

.method private static native nativeSetContrastIndex(II)V
.end method

.method private static native nativeSetDynamicContrastIndex(I)V
.end method

.method private static native nativeSetESS20Enable(ZIZ)V
.end method

.method private static native nativeSetESSLEDMinStep(I)Z
.end method

.method private static native nativeSetESSOLEDMinStep(I)Z
.end method

.method private static native nativeSetExternalPanelNits(I)Z
.end method

.method private static native nativeSetGalleryNormalMode(I)V
.end method

.method private static native nativeSetGammaIndex(II)V
.end method

.method private static native nativeSetGlobalPQStrength(I)Z
.end method

.method private static native nativeSetGlobalPQSwitch(I)Z
.end method

.method private static native nativeSetLowBLReadabilityLevel(I)V
.end method

.method private static native nativeSetPicBrightnessIndex(II)V
.end method

.method private static native nativeSetPictureMode(II)Z
.end method

.method private static native nativeSetRGBGain(IIII)Z
.end method

.method private static native nativeSetReadabilityLevel(I)V
.end method

.method private static native nativeSetSaturationIndex(II)V
.end method

.method private static native nativeSetSharpnessIndex(I)V
.end method

.method private static native nativeSetSmartBacklightStrength(I)V
.end method

.method private static native nativeSetVideoPlaybackMode(I)V
.end method

.method public static setAALFunction(I)V
    .locals 0

    .line 632
    invoke-static {p0}, Lcom/mediatek/pq/PictureQuality;->nativeSetAALFunction(I)V

    return-void
.end method

.method public static setAALFunctionProperty(I)V
    .locals 0

    .line 636
    invoke-static {p0}, Lcom/mediatek/pq/PictureQuality;->nativeSetAALFunctionProperty(I)V

    return-void
.end method

.method public static setBlueLightStrength(I)Z
    .locals 1

    .line 448
    invoke-static {}, Lcom/mediatek/pq/PictureQuality;->getDefaultOffTransitionStep()I

    move-result v0

    invoke-static {p0, v0}, Lcom/mediatek/pq/PictureQuality;->nativeSetBlueLightStrength(II)Z

    move-result p0

    return p0
.end method

.method public static setBlueLightStrength(II)Z
    .locals 0

    .line 444
    invoke-static {p0, p1}, Lcom/mediatek/pq/PictureQuality;->nativeSetBlueLightStrength(II)Z

    move-result p0

    return p0
.end method

.method public static setCcorrMatrix([DI)Z
    .locals 7

    const/16 v0, 0x9

    new-array v1, v0, [I

    const/4 v2, 0x0

    if-nez p0, :cond_0

    const-string p0, "PQ"

    const-string p1, "setCcorrMatrix() matrix is null"

    .line 750
    invoke-static {p0, p1}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    return v2

    .line 754
    :cond_0
    array-length v3, p0

    if-ne v3, v0, :cond_2

    :goto_0
    if-ge v2, v0, :cond_1

    .line 760
    aget-wide v3, p0, v2

    const-wide/high16 v5, 0x4090000000000000L    # 1024.0

    mul-double/2addr v3, v5

    double-to-int v3, v3

    aput v3, v1, v2

    add-int/lit8 v2, v2, 0x1

    goto :goto_0

    .line 763
    :cond_1
    invoke-static {v1, p1}, Lcom/mediatek/pq/PictureQuality;->nativeSetCcorrMatrix([II)Z

    move-result p0

    return p0

    .line 755
    :cond_2
    new-instance p1, Ljava/lang/IllegalArgumentException;

    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "Expected length: 9 (3x3 matrix), actual length: "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    array-length p0, p0

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-direct {p1, p0}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw p1
.end method

.method public static setChameleonStrength(I)Z
    .locals 1

    .line 501
    invoke-static {}, Lcom/mediatek/pq/PictureQuality;->getDefaultOffTransitionStep()I

    move-result v0

    invoke-static {p0, v0}, Lcom/mediatek/pq/PictureQuality;->nativeSetChameleonStrength(II)Z

    move-result p0

    return p0
.end method

.method public static setChameleonStrength(II)Z
    .locals 0

    .line 497
    invoke-static {p0, p1}, Lcom/mediatek/pq/PictureQuality;->nativeSetChameleonStrength(II)Z

    move-result p0

    return p0
.end method

.method public static setColorEffectIndex(I)V
    .locals 0

    .line 385
    invoke-static {p0}, Lcom/mediatek/pq/PictureQuality;->nativeSetColorEffectIndex(I)V

    return-void
.end method

.method public static setColorRegion(IIIII)Z
    .locals 0

    .line 283
    invoke-static {p0, p1, p2, p3, p4}, Lcom/mediatek/pq/PictureQuality;->nativeSetColorRegion(IIIII)Z

    move-result p0

    return p0
.end method

.method public static setContrastIndex(I)V
    .locals 1

    .line 302
    invoke-static {}, Lcom/mediatek/pq/PictureQuality;->getDefaultOffTransitionStep()I

    move-result v0

    invoke-static {p0, v0}, Lcom/mediatek/pq/PictureQuality;->nativeSetContrastIndex(II)V

    return-void
.end method

.method public static setContrastIndex(II)V
    .locals 0

    .line 298
    invoke-static {p0, p1}, Lcom/mediatek/pq/PictureQuality;->nativeSetContrastIndex(II)V

    return-void
.end method

.method public static setDynamicContrastIndex(I)V
    .locals 0

    .line 370
    invoke-static {p0}, Lcom/mediatek/pq/PictureQuality;->nativeSetDynamicContrastIndex(I)V

    return-void
.end method

.method public static setESSLEDMinStep(I)Z
    .locals 0

    .line 665
    invoke-static {p0}, Lcom/mediatek/pq/PictureQuality;->nativeSetESSLEDMinStep(I)Z

    move-result p0

    return p0
.end method

.method public static setESSOLEDMinStep(I)Z
    .locals 0

    .line 681
    invoke-static {p0}, Lcom/mediatek/pq/PictureQuality;->nativeSetESSOLEDMinStep(I)Z

    move-result p0

    return p0
.end method

.method public static setExternalPanelNits(I)Z
    .locals 0

    .line 698
    invoke-static {p0}, Lcom/mediatek/pq/PictureQuality;->nativeSetExternalPanelNits(I)Z

    move-result p0

    return p0
.end method

.method public static setGammaIndex(I)V
    .locals 1

    .line 412
    invoke-static {}, Lcom/mediatek/pq/PictureQuality;->getDefaultOnTransitionStep()I

    move-result v0

    invoke-static {p0, v0}, Lcom/mediatek/pq/PictureQuality;->nativeSetGammaIndex(II)V

    return-void
.end method

.method public static setGammaIndex(II)V
    .locals 0

    .line 408
    invoke-static {p0, p1}, Lcom/mediatek/pq/PictureQuality;->nativeSetGammaIndex(II)V

    return-void
.end method

.method public static setGlobalPQStrength(I)Z
    .locals 0

    .line 573
    invoke-static {p0}, Lcom/mediatek/pq/PictureQuality;->nativeSetGlobalPQStrength(I)Z

    move-result p0

    return p0
.end method

.method public static setGlobalPQSwitch(I)Z
    .locals 0

    .line 555
    invoke-static {p0}, Lcom/mediatek/pq/PictureQuality;->nativeSetGlobalPQSwitch(I)Z

    move-result p0

    return p0
.end method

.method public static setLowBLReadabilityLevel(I)V
    .locals 0

    .line 657
    invoke-static {p0}, Lcom/mediatek/pq/PictureQuality;->nativeSetLowBLReadabilityLevel(I)V

    return-void
.end method

.method public static setMode(I)Ljava/lang/String;
    .locals 1
    .annotation build Landroid/annotation/ProductApi;
    .end annotation

    const/4 v0, 0x1

    if-ne p0, v0, :cond_0

    .line 183
    invoke-static {}, Lcom/mediatek/pq/PictureQuality;->getDefaultOnTransitionStep()I

    move-result p0

    invoke-static {p0}, Lcom/mediatek/pq/PictureQuality;->nativeSetCameraPreviewMode(I)V

    goto :goto_0

    :cond_0
    const/4 v0, 0x2

    if-ne p0, v0, :cond_1

    .line 187
    invoke-static {}, Lcom/mediatek/pq/PictureQuality;->getDefaultOnTransitionStep()I

    move-result p0

    invoke-static {p0}, Lcom/mediatek/pq/PictureQuality;->nativeSetVideoPlaybackMode(I)V

    goto :goto_0

    .line 191
    :cond_1
    invoke-static {}, Lcom/mediatek/pq/PictureQuality;->getDefaultOnTransitionStep()I

    move-result p0

    invoke-static {p0}, Lcom/mediatek/pq/PictureQuality;->nativeSetGalleryNormalMode(I)V

    :goto_0
    const/4 p0, 0x0

    return-object p0
.end method

.method public static setMode(II)Ljava/lang/String;
    .locals 1

    const/4 v0, 0x1

    if-ne p0, v0, :cond_0

    .line 164
    invoke-static {p1}, Lcom/mediatek/pq/PictureQuality;->nativeSetCameraPreviewMode(I)V

    goto :goto_0

    :cond_0
    const/4 v0, 0x2

    if-ne p0, v0, :cond_1

    .line 168
    invoke-static {p1}, Lcom/mediatek/pq/PictureQuality;->nativeSetVideoPlaybackMode(I)V

    goto :goto_0

    .line 172
    :cond_1
    invoke-static {p1}, Lcom/mediatek/pq/PictureQuality;->nativeSetGalleryNormalMode(I)V

    :goto_0
    const/4 p0, 0x0

    return-object p0
.end method

.method public static setPicBrightnessIndex(I)V
    .locals 1

    .line 340
    invoke-static {}, Lcom/mediatek/pq/PictureQuality;->getDefaultOffTransitionStep()I

    move-result v0

    invoke-static {p0, v0}, Lcom/mediatek/pq/PictureQuality;->nativeSetPicBrightnessIndex(II)V

    return-void
.end method

.method public static setPicBrightnessIndex(II)V
    .locals 0

    .line 336
    invoke-static {p0, p1}, Lcom/mediatek/pq/PictureQuality;->nativeSetPicBrightnessIndex(II)V

    return-void
.end method

.method public static setPictureMode(I)Z
    .locals 1

    .line 276
    invoke-static {}, Lcom/mediatek/pq/PictureQuality;->getDefaultOffTransitionStep()I

    move-result v0

    invoke-static {p0, v0}, Lcom/mediatek/pq/PictureQuality;->nativeSetPictureMode(II)Z

    move-result p0

    return p0
.end method

.method public static setPictureMode(II)Z
    .locals 0

    .line 271
    invoke-static {p0, p1}, Lcom/mediatek/pq/PictureQuality;->nativeSetPictureMode(II)Z

    move-result p0

    return p0
.end method

.method public static setRGBGain(DDDI)Z
    .locals 2

    const-wide/high16 v0, 0x4090000000000000L    # 1024.0

    mul-double/2addr p0, v0

    double-to-int p0, p0

    mul-double/2addr p2, v0

    double-to-int p1, p2

    mul-double/2addr p4, v0

    double-to-int p2, p4

    .line 717
    invoke-static {p0, p1, p2, p6}, Lcom/mediatek/pq/PictureQuality;->nativeSetRGBGain(IIII)Z

    move-result p0

    return p0
.end method

.method public static setReadabilityLevel(I)V
    .locals 0

    .line 650
    invoke-static {p0}, Lcom/mediatek/pq/PictureQuality;->nativeSetReadabilityLevel(I)V

    return-void
.end method

.method public static setSaturationIndex(I)V
    .locals 1

    .line 321
    invoke-static {}, Lcom/mediatek/pq/PictureQuality;->getDefaultOffTransitionStep()I

    move-result v0

    invoke-static {p0, v0}, Lcom/mediatek/pq/PictureQuality;->nativeSetSaturationIndex(II)V

    return-void
.end method

.method public static setSaturationIndex(II)V
    .locals 0

    .line 317
    invoke-static {p0, p1}, Lcom/mediatek/pq/PictureQuality;->nativeSetSaturationIndex(II)V

    return-void
.end method

.method public static setSharpnessIndex(I)V
    .locals 0

    .line 355
    invoke-static {p0}, Lcom/mediatek/pq/PictureQuality;->nativeSetSharpnessIndex(I)V

    return-void
.end method

.method public static setSmartBacklightStrength(I)V
    .locals 0

    .line 643
    invoke-static {p0}, Lcom/mediatek/pq/PictureQuality;->nativeSetSmartBacklightStrength(I)V

    return-void
.end method
