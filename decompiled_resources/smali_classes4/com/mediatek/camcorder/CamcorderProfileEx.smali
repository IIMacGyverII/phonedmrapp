.class public Lcom/mediatek/camcorder/CamcorderProfileEx;
.super Ljava/lang/Object;
.source "CamcorderProfileEx.java"


# static fields
.field public static final QUALITY_FINE:I = 0x6f

.field public static final QUALITY_FINE_4K2K:I = 0x7b

.field public static final QUALITY_H264_HIGH:I = 0x75

.field public static final QUALITY_HIGH:I = 0x6e

.field public static final QUALITY_LIST_END:I = 0x7b

.field private static final QUALITY_LIST_START:I

.field public static final QUALITY_LIVE_EFFECT:I = 0x74

.field public static final QUALITY_LOW:I = 0x6c

.field public static final QUALITY_MEDIUM:I = 0x6d

.field public static final QUALITY_NIGHT_FINE:I = 0x73

.field public static final QUALITY_NIGHT_HIGH:I = 0x72

.field public static final QUALITY_NIGHT_LOW:I = 0x70

.field public static final QUALITY_NIGHT_MEDIUM:I = 0x71

.field public static final QUALITY_TIME_LAPSE_LIST_END:I

.field public static final QUALITY_TIME_LAPSE_LIST_START:I

.field public static final SLOW_MOTION_FHD_120FPS:I = 0x8cb

.field public static final SLOW_MOTION_FHD_60FPS:I = 0x8ca

.field public static final SLOW_MOTION_HD_120FPS:I = 0x8c1

.field public static final SLOW_MOTION_HD_180FPS:I = 0x8c2

.field public static final SLOW_MOTION_HD_60FPS:I = 0x8c0

.field private static final SLOW_MOTION_LIST_END:I = 0x8cb

.field private static final SLOW_MOTION_LIST_START:I = 0x8b7

.field public static final SLOW_MOTION_VGA_120FPS:I = 0x8b7

.field private static final TAG:Ljava/lang/String; = "CamcorderProfileEx"


# direct methods
.method static constructor <clinit>()V
    .locals 2

    const-string v0, "QUALITY_TIME_LAPSE_LIST_START"

    .line 165
    invoke-static {v0}, Lcom/mediatek/camcorder/CamcorderProfileEx;->getQualityNum(Ljava/lang/String;)I

    move-result v0

    sput v0, Lcom/mediatek/camcorder/CamcorderProfileEx;->QUALITY_TIME_LAPSE_LIST_START:I

    const-string v1, "QUALITY_LIST_START"

    .line 166
    invoke-static {v1}, Lcom/mediatek/camcorder/CamcorderProfileEx;->getQualityNum(Ljava/lang/String;)I

    move-result v1

    sput v1, Lcom/mediatek/camcorder/CamcorderProfileEx;->QUALITY_LIST_START:I

    add-int/lit8 v0, v0, 0x7b

    .line 167
    sput v0, Lcom/mediatek/camcorder/CamcorderProfileEx;->QUALITY_TIME_LAPSE_LIST_END:I

    return-void
.end method

.method public constructor <init>()V
    .locals 0

    .line 54
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static getProfile(I)Landroid/media/CamcorderProfile;
    .locals 4

    .line 202
    invoke-static {}, Landroid/hardware/Camera;->getNumberOfCameras()I

    move-result v0

    .line 203
    new-instance v1, Landroid/hardware/Camera$CameraInfo;

    invoke-direct {v1}, Landroid/hardware/Camera$CameraInfo;-><init>()V

    const/4 v2, 0x0

    :goto_0
    if-ge v2, v0, :cond_1

    .line 205
    invoke-static {v2, v1}, Landroid/hardware/Camera;->getCameraInfo(ILandroid/hardware/Camera$CameraInfo;)V

    .line 206
    iget v3, v1, Landroid/hardware/Camera$CameraInfo;->facing:I

    if-nez v3, :cond_0

    .line 207
    invoke-static {v2, p0}, Lcom/mediatek/camcorder/CamcorderProfileEx;->getProfile(II)Landroid/media/CamcorderProfile;

    move-result-object p0

    return-object p0

    :cond_0
    add-int/lit8 v2, v2, 0x1

    goto :goto_0

    :cond_1
    const/4 p0, 0x0

    return-object p0
.end method

.method public static getProfile(II)Landroid/media/CamcorderProfile;
    .locals 1

    .line 225
    sget v0, Lcom/mediatek/camcorder/CamcorderProfileEx;->QUALITY_LIST_START:I

    if-lt p1, v0, :cond_0

    const/16 v0, 0x7b

    if-le p1, v0, :cond_2

    :cond_0
    sget v0, Lcom/mediatek/camcorder/CamcorderProfileEx;->QUALITY_TIME_LAPSE_LIST_START:I

    if-lt p1, v0, :cond_1

    sget v0, Lcom/mediatek/camcorder/CamcorderProfileEx;->QUALITY_TIME_LAPSE_LIST_END:I

    if-le p1, v0, :cond_2

    :cond_1
    const/16 v0, 0x8b7

    if-lt p1, v0, :cond_3

    const/16 v0, 0x8cb

    if-gt p1, v0, :cond_3

    .line 234
    :cond_2
    invoke-static {p0, p1}, Lcom/mediatek/camcorder/CamcorderProfileEx;->native_get_camcorder_profile(II)Landroid/media/CamcorderProfile;

    move-result-object p0

    return-object p0

    .line 231
    :cond_3
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "Unsupported quality level: "

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    .line 232
    new-instance p1, Ljava/lang/IllegalArgumentException;

    invoke-direct {p1, p0}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw p1
.end method

.method private static getQualityNum(Ljava/lang/String;)I
    .locals 3

    const-string v0, "getQualityNum error"

    const-string v1, "CamcorderProfileEx"

    .line 176
    :try_start_0
    const-class v2, Landroid/media/CamcorderProfile;

    invoke-virtual {v2, p0}, Ljava/lang/Class;->getDeclaredField(Ljava/lang/String;)Ljava/lang/reflect/Field;

    move-result-object p0

    const/4 v2, 0x1

    .line 177
    invoke-virtual {p0, v2}, Ljava/lang/reflect/Field;->setAccessible(Z)V

    const/4 v2, 0x0

    .line 178
    invoke-virtual {p0, v2}, Ljava/lang/reflect/Field;->getInt(Ljava/lang/Object;)I

    move-result p0
    :try_end_0
    .catch Ljava/lang/SecurityException; {:try_start_0 .. :try_end_0} :catch_3
    .catch Ljava/lang/NoSuchFieldException; {:try_start_0 .. :try_end_0} :catch_2
    .catch Ljava/lang/IllegalArgumentException; {:try_start_0 .. :try_end_0} :catch_1
    .catch Ljava/lang/IllegalAccessException; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_1

    .line 186
    :catch_0
    invoke-static {v1, v0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    goto :goto_0

    .line 184
    :catch_1
    invoke-static {v1, v0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    goto :goto_0

    .line 182
    :catch_2
    invoke-static {v1, v0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    goto :goto_0

    .line 180
    :catch_3
    invoke-static {v1, v0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    :goto_0
    const/4 p0, 0x0

    :goto_1
    return p0
.end method

.method private static final native_get_camcorder_profile(II)Landroid/media/CamcorderProfile;
    .locals 10

    const-string v0, "native_get_camcorder_profile error"

    const-string v1, "CamcorderProfileEx"

    const/4 v2, 0x0

    .line 241
    :try_start_0
    const-class v3, Landroid/media/CamcorderProfile;

    const-string v4, "native_get_camcorder_profile"

    const/4 v5, 0x2

    new-array v6, v5, [Ljava/lang/Class;

    sget-object v7, Ljava/lang/Integer;->TYPE:Ljava/lang/Class;

    const/4 v8, 0x0

    aput-object v7, v6, v8

    const/4 v9, 0x1

    aput-object v7, v6, v9

    invoke-virtual {v3, v4, v6}, Ljava/lang/Class;->getDeclaredMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object v3

    .line 242
    invoke-virtual {v3, v9}, Ljava/lang/reflect/Method;->setAccessible(Z)V

    new-array v4, v5, [Ljava/lang/Object;

    .line 243
    invoke-static {p0}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p0

    aput-object p0, v4, v8

    invoke-static {p1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p0

    aput-object p0, v4, v9

    invoke-virtual {v3, v2, v4}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Landroid/media/CamcorderProfile;
    :try_end_0
    .catch Ljava/lang/SecurityException; {:try_start_0 .. :try_end_0} :catch_4
    .catch Ljava/lang/NoSuchMethodException; {:try_start_0 .. :try_end_0} :catch_3
    .catch Ljava/lang/IllegalArgumentException; {:try_start_0 .. :try_end_0} :catch_2
    .catch Ljava/lang/IllegalAccessException; {:try_start_0 .. :try_end_0} :catch_1
    .catch Ljava/lang/reflect/InvocationTargetException; {:try_start_0 .. :try_end_0} :catch_0

    return-object p0

    .line 253
    :catch_0
    invoke-static {v1, v0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    goto :goto_0

    .line 251
    :catch_1
    invoke-static {v1, v0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    goto :goto_0

    .line 249
    :catch_2
    invoke-static {v1, v0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    goto :goto_0

    .line 247
    :catch_3
    invoke-static {v1, v0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    goto :goto_0

    .line 245
    :catch_4
    invoke-static {v1, v0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    :goto_0
    return-object v2
.end method
