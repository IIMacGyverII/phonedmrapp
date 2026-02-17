.class public Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRateInfo;
.super Ljava/lang/Object;
.source "RefreshRateInfo.java"


# static fields
.field public static final DECELERATION_RATE:F

.field private static final DEFAULT_MIN_SUPPORT_REFRESHRATE_NUMBER:I = 0x3

.field private static final DEFAULT_MIN_SUPPORT_WHEN_FLING:I = 0x1e

.field private static final DEFAULT_MIN_SUPPORT_WHEN_FLING_WITH_VIDEO:I = 0x3c

.field private static final DEFAULT_SUPPORT_REFRESHRATE_NUMBER:I = 0x4

.field private static final DEFAULT_TOUCH_SCROLL_VELOCITY_THRESHOLED:I = 0x96

.field public static final DISTANCE_M1:F = 3.5f

.field public static final DISTANCE_M2:F = 1.65f

.field public static final DURATION_M1:F = 9.0f

.field public static final DURATION_M2:F = 1.65f

.field private static final END_TENSION:F = 1.0f

.field private static final INFLEXION_DEFAULT:F = 0.35f

.field private static final INFLEXION_MSYNC:F = 0.26f

.field public static final NB_SAMPLES:I = 0x64

.field private static final START_TENSION:F = 0.5f

.field private static final TAG:Ljava/lang/String; = "MSYNC3-VariableRefreshRate"

.field private static final USER_CONFIG_DEFAULT_VALUE:Ljava/lang/String; = "-1"


# instance fields
.field private mCurrentActivityName:Ljava/lang/String;

.field private mFlingRefreshRateChangeGap:Ljava/util/ArrayList;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/ArrayList<",
            "Ljava/lang/Float;",
            ">;"
        }
    .end annotation
.end field

.field private mFlingRefreshRateChangeTimeOffset:Ljava/util/ArrayList;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/ArrayList<",
            "Ljava/lang/Float;",
            ">;"
        }
    .end annotation
.end field

.field private mFlingRefreshRateVSyncTime:Ljava/util/ArrayList;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/ArrayList<",
            "Ljava/lang/Float;",
            ">;"
        }
    .end annotation
.end field

.field private mFlingSupportedRefreshRate:Ljava/util/ArrayList;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/ArrayList<",
            "Ljava/lang/Integer;",
            ">;"
        }
    .end annotation
.end field

.field private mFlingSupportedRefreshRateSize:I

.field private mHardwareSupportedRefreshRate:Ljava/util/ArrayList;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/ArrayList<",
            "Ljava/lang/Integer;",
            ">;"
        }
    .end annotation
.end field

.field private mInflextion:F

.field private mIsDataInited:Z

.field private mMaximumVelocity:F

.field private mPackageName:Ljava/lang/String;

.field private mSplinePosition:[F

.field private mSplinePositionSpecial:[F

.field private mSplineTime:[F

.field private mTouchScrollSpeedLow:I

.field private mTouchScrollVelocityThreshold:I

.field private mVideoFloorRefreshRate:I

.field private p1:F

.field private p2:F


# direct methods
.method static constructor <clinit>()V
    .locals 4

    const-wide v0, 0x3fe8f5c28f5c28f6L    # 0.78

    .line 86
    invoke-static {v0, v1}, Ljava/lang/Math;->log(D)D

    move-result-wide v0

    const-wide v2, 0x3feccccccccccccdL    # 0.9

    invoke-static {v2, v3}, Ljava/lang/Math;->log(D)D

    move-result-wide v2

    div-double/2addr v0, v2

    double-to-float v0, v0

    sput v0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRateInfo;->DECELERATION_RATE:F

    return-void
.end method

.method public constructor <init>()V
    .locals 3

    .line 124
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 65
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    iput-object v0, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRateInfo;->mHardwareSupportedRefreshRate:Ljava/util/ArrayList;

    .line 66
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    iput-object v0, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRateInfo;->mFlingSupportedRefreshRate:Ljava/util/ArrayList;

    .line 67
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    iput-object v0, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRateInfo;->mFlingRefreshRateChangeGap:Ljava/util/ArrayList;

    .line 68
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    iput-object v0, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRateInfo;->mFlingRefreshRateChangeTimeOffset:Ljava/util/ArrayList;

    .line 69
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    iput-object v0, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRateInfo;->mFlingRefreshRateVSyncTime:Ljava/util/ArrayList;

    const/16 v0, 0x65

    new-array v1, v0, [F

    .line 79
    iput-object v1, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRateInfo;->mSplinePosition:[F

    new-array v0, v0, [F

    .line 80
    iput-object v0, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRateInfo;->mSplineTime:[F

    const/4 v0, 0x0

    .line 95
    iput-boolean v0, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRateInfo;->mIsDataInited:Z

    .line 96
    iput v0, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRateInfo;->mFlingSupportedRefreshRateSize:I

    const/4 v0, -0x1

    .line 97
    iput v0, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRateInfo;->mTouchScrollSpeedLow:I

    .line 98
    iput v0, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRateInfo;->mVideoFloorRefreshRate:I

    .line 99
    iput v0, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRateInfo;->mTouchScrollVelocityThreshold:I

    const/16 v0, 0x78

    new-array v0, v0, [F

    .line 101
    fill-array-data v0, :array_0

    iput-object v0, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRateInfo;->mSplinePositionSpecial:[F

    .line 125
    invoke-static {}, Lcom/mediatek/boostfwk/utils/Config;->isMSync3SmoothFlingEnabled()Z

    move-result v0

    if-eqz v0, :cond_0

    const v0, 0x3e851eb8    # 0.26f

    goto :goto_0

    :cond_0
    const v0, 0x3eb33333    # 0.35f

    :goto_0
    iput v0, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRateInfo;->mInflextion:F

    const/high16 v1, 0x3f000000    # 0.5f

    mul-float/2addr v1, v0

    .line 126
    iput v1, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRateInfo;->p1:F

    const/high16 v2, 0x3f800000    # 1.0f

    sub-float v0, v2, v0

    mul-float/2addr v0, v2

    sub-float/2addr v2, v0

    .line 127
    iput v2, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRateInfo;->p2:F

    .line 128
    invoke-direct {p0, v1, v2}, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRateInfo;->initSmoothFlingInfo(FF)V

    return-void

    nop

    :array_0
    .array-data 4
        0x0
        0x3cccea14
        0x3d9c34fc
        0x3dfb4c2c
        0x3e2af16b
        0x3e5613dc
        0x3e7f241c
        0x3e931c16
        0x3ea5b2b2
        0x3eb7603a
        0x3ec82eb5
        0x3ed827d4
        0x3ee754fe
        0x3ef5bf47
        0x3f01b7bc
        0x3f083708
        0x3f0e619e
        0x3f143b74
        0x3f19c85b
        0x3f1f0bff
        0x3f2409eb
        0x3f28c588
        0x3f2d421e
        0x3f3182d4
        0x3f358ab1
        0x3f395c9d
        0x3f3cfb62
        0x3f4069ab
        0x3f43aa09
        0x3f46beec
        0x3f49aaaa
        0x3f4c6f80
        0x3f4f0f8e
        0x3f518cdc
        0x3f53e956
        0x3f5626d4
        0x3f584712
        0x3f5a4bb8
        0x3f5c3657
        0x3f5e0868
        0x3f5fc351
        0x3f616866
        0x3f62f8e1
        0x3f6475f0
        0x3f65e0aa
        0x3f673a15
        0x3f688329
        0x3f69bcca
        0x3f6ae7ce
        0x3f6c04fc
        0x3f6d150e
        0x3f6e18ae
        0x3f6f107b
        0x3f6ffd07
        0x3f70ded8
        0x3f71b66a
        0x3f72842e
        0x3f73488d
        0x3f7403e6
        0x3f74b68f
        0x3f7560d8
        0x3f760309
        0x3f769d66
        0x3f77302c
        0x3f77bb92
        0x3f783fcc
        0x3f78bd0d
        0x3f793381
        0x3f79a354
        0x3f7a0cb2
        0x3f7a6fc3
        0x3f7accb2
        0x3f7b23aa
        0x3f7b74d5
        0x3f7bc062
        0x3f7c0681
        0x3f7c4766
        0x3f7c8349
        0x3f7cba65
        0x3f7cecfd
        0x3f7d1b59
        0x3f7d45c7
        0x3f7d6c9d
        0x3f7d903a
        0x3f7db103
        0x3f7dcf6a
        0x3f7debe9
        0x3f7e0705
        0x3f7e214e
        0x3f7e3b61
        0x3f7e55e9
        0x3f7e719b
        0x3f7e8f3d
        0x3f7ea915
        0x3f7ec15f
        0x3f7ed571
        0x3f7eeafd
        0x3f7f06c0
        0x3f7f1003
        0x3f7f1d88
        0x3f7f2b36
        0x3f7f39a1
        0x3f7f465e
        0x3f7f5035
        0x3f7f5ea8
        0x3f7f6c2d
        0x3f7f79da
        0x3f7f8846
        0x3f7f9503
        0x3f7f9eda
        0x3f7fad4d
        0x3f7fbb64
        0x3f7fc844
        0x3f7fd567
        0x3f7fdf3b    # 0.9995f
        0x3f7fe76d
        0x3f7feea2
        0x3f7ff530
        0x3f7fff58    # 0.99999f
        0x3f800000    # 1.0f
    .end array-data
.end method

.method private initSmoothFlingInfo(FF)V
    .locals 18

    move-object/from16 v0, p0

    const/4 v1, 0x0

    const/4 v2, 0x0

    move v3, v2

    move v2, v1

    :goto_0
    const/16 v4, 0x64

    const/high16 v5, 0x3f800000    # 1.0f

    if-ge v3, v4, :cond_4

    int-to-float v4, v3

    const/high16 v6, 0x42c80000    # 100.0f

    div-float v6, v4, v6

    move v4, v5

    :goto_1
    sub-float v7, v4, v1

    const/high16 v8, 0x40000000    # 2.0f

    div-float/2addr v7, v8

    add-float/2addr v7, v1

    const/high16 v9, 0x40600000    # 3.5f

    mul-float v10, v7, v9

    sub-float v11, v5, v7

    mul-float/2addr v10, v11

    mul-float v12, v11, p1

    mul-float v13, v7, p2

    add-float/2addr v12, v13

    mul-float/2addr v12, v10

    mul-float v13, v7, v7

    mul-float/2addr v13, v7

    add-float/2addr v12, v13

    sub-float v14, v12, v6

    .line 154
    invoke-static {v14}, Ljava/lang/Math;->abs(F)F

    move-result v14

    float-to-double v14, v14

    const-wide v16, 0x3ee4f8b588e368f1L    # 1.0E-5

    cmpg-double v14, v14, v16

    if-gez v14, :cond_2

    .line 163
    iget-object v4, v0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRateInfo;->mSplinePosition:[F

    const/high16 v14, 0x3f000000    # 0.5f

    mul-float/2addr v11, v14

    add-float/2addr v11, v7

    mul-float/2addr v11, v10

    add-float/2addr v11, v13

    aput v11, v4, v3

    move v4, v5

    :goto_2
    sub-float v7, v4, v2

    div-float/2addr v7, v8

    add-float/2addr v7, v2

    mul-float v10, v7, v9

    sub-float v11, v5, v7

    mul-float/2addr v10, v11

    mul-float v12, v11, v14

    add-float/2addr v12, v7

    mul-float/2addr v12, v10

    mul-float v13, v7, v7

    mul-float/2addr v13, v7

    add-float/2addr v12, v13

    sub-float v15, v12, v6

    .line 169
    invoke-static {v15}, Ljava/lang/Math;->abs(F)F

    move-result v15

    float-to-double v8, v15

    cmpg-double v8, v8, v16

    if-gez v8, :cond_0

    .line 177
    iget-object v4, v0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRateInfo;->mSplineTime:[F

    mul-float v11, v11, p1

    mul-float v7, v7, p2

    add-float/2addr v11, v7

    mul-float/2addr v10, v11

    add-float/2addr v10, v13

    aput v10, v4, v3

    add-int/lit8 v3, v3, 0x1

    goto :goto_0

    :cond_0
    cmpl-float v8, v12, v6

    if-lez v8, :cond_1

    move v4, v7

    goto :goto_3

    :cond_1
    move v2, v7

    :goto_3
    const/high16 v8, 0x40000000    # 2.0f

    const/high16 v9, 0x40600000    # 3.5f

    goto :goto_2

    :cond_2
    cmpl-float v8, v12, v6

    if-lez v8, :cond_3

    move v4, v7

    goto :goto_1

    :cond_3
    move v1, v7

    goto :goto_1

    .line 180
    :cond_4
    iget-object v1, v0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRateInfo;->mSplinePosition:[F

    iget-object v0, v0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRateInfo;->mSplineTime:[F

    aput v5, v0, v4

    aput v5, v1, v4

    return-void
.end method


# virtual methods
.method public getCurrentActivityName()Ljava/lang/String;
    .locals 0

    .line 314
    iget-object p0, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRateInfo;->mCurrentActivityName:Ljava/lang/String;

    return-object p0
.end method

.method public getFlingRefreshRateChangeGap()Ljava/util/ArrayList;
    .locals 0

    .line 330
    iget-object p0, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRateInfo;->mFlingRefreshRateChangeGap:Ljava/util/ArrayList;

    return-object p0
.end method

.method public getFlingRefreshRateChangeTimeOffset()Ljava/util/ArrayList;
    .locals 0

    .line 334
    iget-object p0, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRateInfo;->mFlingRefreshRateChangeTimeOffset:Ljava/util/ArrayList;

    return-object p0
.end method

.method public getFlingRefreshRateVSyncTime()Ljava/util/ArrayList;
    .locals 0

    .line 338
    iget-object p0, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRateInfo;->mFlingRefreshRateVSyncTime:Ljava/util/ArrayList;

    return-object p0
.end method

.method public getFlingSupportedRefreshRate()Ljava/util/ArrayList;
    .locals 0

    .line 326
    iget-object p0, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRateInfo;->mFlingSupportedRefreshRate:Ljava/util/ArrayList;

    return-object p0
.end method

.method public getFlingSupportedRefreshRateCount()I
    .locals 0

    .line 358
    iget p0, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRateInfo;->mFlingSupportedRefreshRateSize:I

    return p0
.end method

.method public getInflextion()F
    .locals 0

    .line 371
    iget p0, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRateInfo;->mInflextion:F

    return p0
.end method

.method public getIsDataInited()Z
    .locals 0

    .line 367
    iget-boolean p0, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRateInfo;->mIsDataInited:Z

    return p0
.end method

.method public getMaxFlingSupportedRefreshRate()I
    .locals 2

    .line 342
    iget-object v0, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRateInfo;->mFlingSupportedRefreshRate:Ljava/util/ArrayList;

    invoke-virtual {v0}, Ljava/util/ArrayList;->size()I

    move-result v0

    const/4 v1, 0x3

    if-ge v0, v1, :cond_0

    const/4 p0, -0x1

    return p0

    .line 343
    :cond_0
    iget-object p0, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRateInfo;->mFlingSupportedRefreshRate:Ljava/util/ArrayList;

    const/4 v0, 0x0

    invoke-virtual {p0, v0}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Ljava/lang/Integer;

    invoke-virtual {p0}, Ljava/lang/Integer;->intValue()I

    move-result p0

    return p0
.end method

.method public getMaximumVelocity()F
    .locals 0

    .line 306
    iget p0, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRateInfo;->mMaximumVelocity:F

    return p0
.end method

.method public getPackageName()Ljava/lang/String;
    .locals 0

    .line 310
    iget-object p0, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRateInfo;->mPackageName:Ljava/lang/String;

    return-object p0
.end method

.method public getSlowScrollRefreshRate()I
    .locals 3

    .line 347
    iget-object v0, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRateInfo;->mFlingSupportedRefreshRate:Ljava/util/ArrayList;

    invoke-virtual {v0}, Ljava/util/ArrayList;->size()I

    move-result v0

    const/4 v1, -0x1

    const/4 v2, 0x3

    if-ge v0, v2, :cond_0

    return v1

    .line 348
    :cond_0
    iget v0, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRateInfo;->mTouchScrollSpeedLow:I

    if-eq v0, v1, :cond_1

    goto :goto_0

    .line 349
    :cond_1
    iget-object p0, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRateInfo;->mFlingSupportedRefreshRate:Ljava/util/ArrayList;

    const/4 v0, 0x1

    invoke-virtual {p0, v0}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Ljava/lang/Integer;

    invoke-virtual {p0}, Ljava/lang/Integer;->intValue()I

    move-result v0

    :goto_0
    return v0
.end method

.method public getSmoothFlingSplinePosition()[F
    .locals 0

    .line 318
    iget-object p0, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRateInfo;->mSplinePositionSpecial:[F

    return-object p0
.end method

.method public getSmoothFlingSplinePositionCount()I
    .locals 0

    .line 375
    iget-object p0, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRateInfo;->mSplinePositionSpecial:[F

    array-length p0, p0

    add-int/lit8 p0, p0, -0x1

    return p0
.end method

.method public getSmoothFlingSplineTime()[F
    .locals 0

    .line 322
    iget-object p0, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRateInfo;->mSplineTime:[F

    return-object p0
.end method

.method public getSmoothFlingSplineTimeCount()I
    .locals 0

    const/16 p0, 0x64

    return p0
.end method

.method public getTouchScrollVelocityThreshold()I
    .locals 1

    .line 362
    iget p0, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRateInfo;->mTouchScrollVelocityThreshold:I

    const/4 v0, -0x1

    if-eq p0, v0, :cond_0

    goto :goto_0

    :cond_0
    const/16 p0, 0x96

    :goto_0
    return p0
.end method

.method public getVideoFloorRefreshRate()I
    .locals 1

    .line 353
    iget p0, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRateInfo;->mVideoFloorRefreshRate:I

    const/4 v0, -0x1

    if-eq p0, v0, :cond_0

    goto :goto_0

    :cond_0
    const/16 p0, 0x3c

    :goto_0
    return p0
.end method

.method public initHardwareSupportRefreshRate(Landroid/content/Context;)V
    .locals 4

    .line 194
    check-cast p1, Landroid/app/Activity;

    invoke-virtual {p1}, Landroid/app/Activity;->getWindowManager()Landroid/view/WindowManager;

    move-result-object p1

    invoke-interface {p1}, Landroid/view/WindowManager;->getDefaultDisplay()Landroid/view/Display;

    move-result-object p1

    .line 195
    invoke-virtual {p1}, Landroid/view/Display;->getSupportedModes()[Landroid/view/Display$Mode;

    move-result-object p1

    const/4 v0, 0x0

    .line 196
    :goto_0
    array-length v1, p1

    if-ge v0, v1, :cond_1

    .line 197
    aget-object v1, p1, v0

    invoke-virtual {v1}, Landroid/view/Display$Mode;->getRefreshRate()F

    move-result v1

    float-to-int v1, v1

    .line 198
    iget-object v2, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRateInfo;->mHardwareSupportedRefreshRate:Ljava/util/ArrayList;

    invoke-static {v1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v3

    invoke-virtual {v2, v3}, Ljava/util/ArrayList;->contains(Ljava/lang/Object;)Z

    move-result v2

    if-nez v2, :cond_0

    .line 199
    iget-object v2, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRateInfo;->mHardwareSupportedRefreshRate:Ljava/util/ArrayList;

    invoke-static {v1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v1

    invoke-virtual {v2, v1}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    :cond_0
    add-int/lit8 v0, v0, 0x1

    goto :goto_0

    .line 202
    :cond_1
    iget-object p1, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRateInfo;->mHardwareSupportedRefreshRate:Ljava/util/ArrayList;

    invoke-static {}, Ljava/util/Comparator;->reverseOrder()Ljava/util/Comparator;

    move-result-object v0

    invoke-virtual {p1, v0}, Ljava/util/ArrayList;->sort(Ljava/util/Comparator;)V

    .line 203
    sget-boolean p1, Lcom/mediatek/boostfwk/utils/LogUtil;->DEBUG:Z

    if-eqz p1, :cond_2

    .line 204
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "mHardwareSupportedRefreshRate = "

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object p0, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRateInfo;->mHardwareSupportedRefreshRate:Ljava/util/ArrayList;

    .line 205
    invoke-virtual {p0}, Ljava/util/ArrayList;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-virtual {p1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    const-string p1, "MSYNC3-VariableRefreshRate"

    .line 204
    invoke-static {p1, p0}, Lcom/mediatek/boostfwk/utils/LogUtil;->mLogd(Ljava/lang/String;Ljava/lang/String;)V

    :cond_2
    return-void
.end method

.method public initMSync3SupportRefreshRate()Z
    .locals 10

    .line 213
    sget-object v0, Lcom/mediatek/boostfwk/utils/Config;->MSYNC3_FLING_SUPPORT_REFRESHRATE:Ljava/lang/String;

    .line 214
    sget-object v1, Lcom/mediatek/boostfwk/utils/Config;->MSYNC3_FLING_REFRESHRATE_CHANGE_GAP:Ljava/lang/String;

    .line 215
    sget-boolean v2, Lcom/mediatek/boostfwk/utils/LogUtil;->DEBUG:Z

    const-string v3, "MSYNC3-VariableRefreshRate"

    if-eqz v2, :cond_0

    .line 216
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string/jumbo v4, "userConfigRefreshRate = "

    invoke-virtual {v2, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v4, " userConfigRefreshChangeGap = "

    invoke-virtual {v2, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-static {v3, v2}, Lcom/mediatek/boostfwk/utils/LogUtil;->mLogd(Ljava/lang/String;Ljava/lang/String;)V

    :cond_0
    const-string v2, "-1"

    .line 220
    invoke-virtual {v2, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v4

    const-string v5, " isInitSuccess = "

    const/4 v6, 0x3

    const/4 v7, 0x0

    const/4 v8, 0x1

    if-nez v4, :cond_4

    .line 221
    invoke-virtual {v2, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v2

    if-nez v2, :cond_4

    const-string v2, ","

    .line 222
    invoke-virtual {v0, v2}, Ljava/lang/String;->split(Ljava/lang/String;)[Ljava/lang/String;

    move-result-object v0

    .line 223
    invoke-virtual {v1, v2}, Ljava/lang/String;->split(Ljava/lang/String;)[Ljava/lang/String;

    move-result-object v1

    .line 224
    array-length v2, v0

    if-ge v2, v6, :cond_1

    move v0, v7

    goto :goto_2

    :cond_1
    move v2, v7

    .line 227
    :goto_0
    array-length v4, v0

    if-ge v2, v4, :cond_2

    .line 228
    iget-object v4, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRateInfo;->mFlingSupportedRefreshRate:Ljava/util/ArrayList;

    aget-object v9, v0, v2

    invoke-static {v9}, Ljava/lang/Integer;->valueOf(Ljava/lang/String;)Ljava/lang/Integer;

    move-result-object v9

    invoke-virtual {v4, v9}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    add-int/lit8 v2, v2, 0x1

    goto :goto_0

    :cond_2
    move v0, v7

    .line 231
    :goto_1
    array-length v2, v1

    if-ge v0, v2, :cond_3

    .line 232
    iget-object v2, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRateInfo;->mFlingRefreshRateChangeGap:Ljava/util/ArrayList;

    aget-object v4, v1, v0

    invoke-static {v4}, Ljava/lang/Float;->valueOf(Ljava/lang/String;)Ljava/lang/Float;

    move-result-object v4

    invoke-virtual {v2, v4}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    add-int/lit8 v0, v0, 0x1

    goto :goto_1

    :cond_3
    move v0, v8

    .line 236
    :goto_2
    sget-boolean v1, Lcom/mediatek/boostfwk/utils/LogUtil;->DEBUG:Z

    if-eqz v1, :cond_5

    .line 237
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "Userconfig mMSyncSupportedRefreshRate = "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v2, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRateInfo;->mFlingSupportedRefreshRate:Ljava/util/ArrayList;

    .line 238
    invoke-virtual {v2}, Ljava/util/ArrayList;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v2, " mFlingRefreshRateChangeGap = "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v2, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRateInfo;->mFlingRefreshRateChangeGap:Ljava/util/ArrayList;

    .line 239
    invoke-virtual {v2}, Ljava/util/ArrayList;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    .line 237
    invoke-static {v3, v1}, Lcom/mediatek/boostfwk/utils/LogUtil;->mLogd(Ljava/lang/String;Ljava/lang/String;)V

    goto :goto_3

    :cond_4
    move v0, v7

    .line 245
    :cond_5
    :goto_3
    sget-object v1, Lcom/mediatek/boostfwk/utils/Config;->MSYNC3_TOUCHSCROLL_REFRESHRATE_SPEED_LOW:Ljava/lang/String;

    invoke-static {v1}, Ljava/lang/Integer;->valueOf(Ljava/lang/String;)Ljava/lang/Integer;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/Integer;->intValue()I

    move-result v1

    iput v1, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRateInfo;->mTouchScrollSpeedLow:I

    .line 246
    sget-object v1, Lcom/mediatek/boostfwk/utils/Config;->MSYNC3_VIDEO_FLOOR_FPS:Ljava/lang/String;

    invoke-static {v1}, Ljava/lang/Integer;->valueOf(Ljava/lang/String;)Ljava/lang/Integer;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/Integer;->intValue()I

    move-result v1

    iput v1, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRateInfo;->mVideoFloorRefreshRate:I

    .line 247
    sget-object v1, Lcom/mediatek/boostfwk/utils/Config;->MSYNC3_TOUCH_SCROLL_VELOCITY:Ljava/lang/String;

    invoke-static {v1}, Ljava/lang/Integer;->valueOf(Ljava/lang/String;)Ljava/lang/Integer;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/Integer;->intValue()I

    move-result v1

    iput v1, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRateInfo;->mTouchScrollVelocityThreshold:I

    .line 249
    sget-boolean v1, Lcom/mediatek/boostfwk/utils/LogUtil;->DEBUG:Z

    if-eqz v1, :cond_6

    .line 250
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "Userconfig  = mTouchScrollSpeedLow = "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v2, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRateInfo;->mTouchScrollSpeedLow:I

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v2, " mVideoFloorRefreshRate = "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v2, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRateInfo;->mVideoFloorRefreshRate:I

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v2, " mTouchScrollVelocityThreshold = "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v2, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRateInfo;->mTouchScrollVelocityThreshold:I

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {v3, v1}, Lcom/mediatek/boostfwk/utils/LogUtil;->mLogd(Ljava/lang/String;Ljava/lang/String;)V

    :cond_6
    if-nez v0, :cond_b

    .line 257
    iget-object v1, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRateInfo;->mHardwareSupportedRefreshRate:Ljava/util/ArrayList;

    invoke-virtual {v1}, Ljava/util/ArrayList;->size()I

    move-result v1

    if-ge v1, v6, :cond_7

    move v0, v7

    goto :goto_6

    :cond_7
    const v2, 0x3fea3d71    # 1.83f

    const/4 v4, 0x4

    if-eq v1, v6, :cond_8

    if-ne v1, v4, :cond_a

    .line 260
    :cond_8
    iget-object v6, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRateInfo;->mHardwareSupportedRefreshRate:Ljava/util/ArrayList;

    add-int/lit8 v9, v1, -0x1

    .line 262
    invoke-virtual {v6, v9}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v6

    check-cast v6, Ljava/lang/Integer;

    invoke-virtual {v6}, Ljava/lang/Integer;->intValue()I

    move-result v6

    const/16 v9, 0x1e

    if-lt v6, v9, :cond_a

    .line 264
    iget-object v0, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRateInfo;->mFlingSupportedRefreshRate:Ljava/util/ArrayList;

    iget-object v4, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRateInfo;->mHardwareSupportedRefreshRate:Ljava/util/ArrayList;

    invoke-virtual {v0, v4}, Ljava/util/ArrayList;->addAll(Ljava/util/Collection;)Z

    move v0, v7

    :goto_4
    if-ge v0, v1, :cond_9

    .line 266
    iget-object v4, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRateInfo;->mFlingRefreshRateChangeGap:Ljava/util/ArrayList;

    invoke-static {v2}, Ljava/lang/Float;->valueOf(F)Ljava/lang/Float;

    move-result-object v6

    invoke-virtual {v4, v6}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    add-int/lit8 v0, v0, 0x1

    goto :goto_4

    :cond_9
    move v0, v8

    goto :goto_6

    :cond_a
    if-le v1, v4, :cond_b

    move v0, v7

    :goto_5
    if-ge v0, v4, :cond_9

    .line 272
    iget-object v1, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRateInfo;->mFlingSupportedRefreshRate:Ljava/util/ArrayList;

    iget-object v6, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRateInfo;->mHardwareSupportedRefreshRate:Ljava/util/ArrayList;

    invoke-virtual {v6, v0}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v6

    check-cast v6, Ljava/lang/Integer;

    invoke-virtual {v1, v6}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    .line 273
    iget-object v1, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRateInfo;->mFlingRefreshRateChangeGap:Ljava/util/ArrayList;

    invoke-static {v2}, Ljava/lang/Float;->valueOf(F)Ljava/lang/Float;

    move-result-object v6

    invoke-virtual {v1, v6}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    add-int/lit8 v0, v0, 0x1

    goto :goto_5

    :cond_b
    :goto_6
    if-eqz v0, :cond_d

    .line 281
    iget-object v1, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRateInfo;->mFlingSupportedRefreshRate:Ljava/util/ArrayList;

    invoke-virtual {v1}, Ljava/util/ArrayList;->size()I

    move-result v1

    iput v1, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRateInfo;->mFlingSupportedRefreshRateSize:I

    .line 282
    :goto_7
    iget v1, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRateInfo;->mFlingSupportedRefreshRateSize:I

    add-int/lit8 v2, v1, -0x1

    const/high16 v4, 0x447a0000    # 1000.0f

    const/high16 v6, 0x3f800000    # 1.0f

    if-ge v7, v2, :cond_c

    .line 283
    iget-object v1, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRateInfo;->mFlingSupportedRefreshRate:Ljava/util/ArrayList;

    .line 284
    invoke-virtual {v1, v7}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Ljava/lang/Integer;

    invoke-virtual {v1}, Ljava/lang/Integer;->intValue()I

    move-result v1

    int-to-float v1, v1

    invoke-static {v1}, Ljava/lang/Float;->valueOf(F)Ljava/lang/Float;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/Float;->floatValue()F

    move-result v1

    div-float v1, v6, v1

    mul-float/2addr v1, v4

    .line 285
    iget-object v2, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRateInfo;->mFlingSupportedRefreshRate:Ljava/util/ArrayList;

    add-int/lit8 v7, v7, 0x1

    .line 286
    invoke-virtual {v2, v7}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Ljava/lang/Integer;

    invoke-virtual {v2}, Ljava/lang/Integer;->intValue()I

    move-result v2

    int-to-float v2, v2

    invoke-static {v2}, Ljava/lang/Float;->valueOf(F)Ljava/lang/Float;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/Float;->floatValue()F

    move-result v2

    div-float/2addr v6, v2

    mul-float/2addr v6, v4

    .line 287
    iget-object v2, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRateInfo;->mFlingRefreshRateChangeTimeOffset:Ljava/util/ArrayList;

    sub-float/2addr v6, v1

    .line 288
    invoke-static {v6}, Ljava/lang/Float;->valueOf(F)Ljava/lang/Float;

    move-result-object v4

    .line 287
    invoke-virtual {v2, v4}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    .line 289
    iget-object v2, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRateInfo;->mFlingRefreshRateVSyncTime:Ljava/util/ArrayList;

    invoke-static {v1}, Ljava/lang/Float;->valueOf(F)Ljava/lang/Float;

    move-result-object v1

    invoke-virtual {v2, v1}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    goto :goto_7

    .line 291
    :cond_c
    iget-object v2, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRateInfo;->mFlingRefreshRateVSyncTime:Ljava/util/ArrayList;

    iget-object v7, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRateInfo;->mFlingSupportedRefreshRate:Ljava/util/ArrayList;

    sub-int/2addr v1, v8

    .line 292
    invoke-virtual {v7, v1}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Ljava/lang/Integer;

    invoke-virtual {v1}, Ljava/lang/Integer;->intValue()I

    move-result v1

    int-to-float v1, v1

    .line 291
    invoke-static {v1}, Ljava/lang/Float;->valueOf(F)Ljava/lang/Float;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/Float;->floatValue()F

    move-result v1

    div-float/2addr v6, v1

    mul-float/2addr v6, v4

    invoke-static {v6}, Ljava/lang/Float;->valueOf(F)Ljava/lang/Float;

    move-result-object v1

    invoke-virtual {v2, v1}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    .line 294
    :cond_d
    sget-boolean v1, Lcom/mediatek/boostfwk/utils/LogUtil;->DEBUG:Z

    if-eqz v1, :cond_e

    .line 295
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "SupportedRefreshRate = "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v2, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRateInfo;->mFlingSupportedRefreshRate:Ljava/util/ArrayList;

    invoke-virtual {v2}, Ljava/util/ArrayList;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v2, " mFlingChangeGap = "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v2, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRateInfo;->mFlingRefreshRateChangeGap:Ljava/util/ArrayList;

    .line 296
    invoke-virtual {v2}, Ljava/util/ArrayList;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v2, " mFlingChangeTimeOffset = "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v2, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRateInfo;->mFlingRefreshRateChangeTimeOffset:Ljava/util/ArrayList;

    .line 297
    invoke-virtual {v2}, Ljava/util/ArrayList;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v2, " mFlingRefreshRateVSyncTime = "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object p0, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRateInfo;->mFlingRefreshRateVSyncTime:Ljava/util/ArrayList;

    .line 298
    invoke-virtual {p0}, Ljava/util/ArrayList;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-virtual {v1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    .line 295
    invoke-static {v3, p0}, Lcom/mediatek/boostfwk/utils/LogUtil;->mLogd(Ljava/lang/String;Ljava/lang/String;)V

    :cond_e
    return v0
.end method

.method public initPackageInfo(Landroid/content/Context;)V
    .locals 1

    .line 184
    invoke-static {p1}, Landroid/view/ViewConfiguration;->get(Landroid/content/Context;)Landroid/view/ViewConfiguration;

    move-result-object v0

    .line 185
    invoke-virtual {v0}, Landroid/view/ViewConfiguration;->getScaledMaximumFlingVelocity()I

    move-result v0

    int-to-float v0, v0

    iput v0, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRateInfo;->mMaximumVelocity:F

    .line 186
    invoke-virtual {p1}, Landroid/content/Context;->getApplicationInfo()Landroid/content/pm/ApplicationInfo;

    move-result-object p1

    iget-object p1, p1, Landroid/content/pm/ApplicationInfo;->packageName:Ljava/lang/String;

    iput-object p1, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRateInfo;->mPackageName:Ljava/lang/String;

    return-void
.end method

.method public updateCurrentActivityName(Landroid/content/Context;)V
    .locals 1

    .line 132
    check-cast p1, Landroid/app/Activity;

    .line 133
    invoke-virtual {p1}, Landroid/app/Activity;->getLocalClassName()Ljava/lang/String;

    move-result-object p1

    iput-object p1, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRateInfo;->mCurrentActivityName:Ljava/lang/String;

    .line 134
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "mCurrentActivityName = "

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object p0, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRateInfo;->mCurrentActivityName:Ljava/lang/String;

    invoke-virtual {p1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    const-string p1, "MSYNC3-VariableRefreshRate"

    invoke-static {p1, p0}, Lcom/mediatek/boostfwk/utils/LogUtil;->mLogd(Ljava/lang/String;Ljava/lang/String;)V

    return-void
.end method
