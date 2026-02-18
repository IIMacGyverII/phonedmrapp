.class public Lcom/mediatek/view/impl/SurfaceExtimpl;
.super Lcom/mediatek/view/SurfaceExt;
.source "SurfaceExtimpl.java"


# static fields
.field private static final APP_RESOLUTION_TUNING_AI_ENABLE:Z

.field private static final ENABLE_RESOLUTION_TUNING:I

.field private static final ENABLE_WHITE_LIST:Z

.field private static final TAG:Ljava/lang/String; = "SurfaceExt"

.field private static final WHITE_LIST:[Ljava/lang/String;

.field private static mApplist:Lcom/mediatek/appresolutiontuner/ResolutionTunerAppList;


# instance fields
.field private mIsContainPackageName:Z

.field private mIsScaledByGameMode:Z

.field private mPackageName:Ljava/lang/String;

.field private mXScaleValue:F

.field private mYScaleValue:F


# direct methods
.method static constructor <clinit>()V
    .locals 2

    const-string v0, "debug.enable.whitelist"

    const/4 v1, 0x0

    .line 18
    invoke-static {v0, v1}, Landroid/os/SystemProperties;->getBoolean(Ljava/lang/String;Z)Z

    move-result v0

    sput-boolean v0, Lcom/mediatek/view/impl/SurfaceExtimpl;->ENABLE_WHITE_LIST:Z

    const-string v0, "ro.vendor.app_resolution_tuner"

    .line 20
    invoke-static {v0, v1}, Landroid/os/SystemProperties;->getInt(Ljava/lang/String;I)I

    move-result v0

    sput v0, Lcom/mediatek/view/impl/SurfaceExtimpl;->ENABLE_RESOLUTION_TUNING:I

    const-string v0, "com.tencent.qqlive"

    .line 22
    filled-new-array {v0}, [Ljava/lang/String;

    move-result-object v0

    sput-object v0, Lcom/mediatek/view/impl/SurfaceExtimpl;->WHITE_LIST:[Ljava/lang/String;

    const/4 v0, 0x0

    .line 28
    sput-object v0, Lcom/mediatek/view/impl/SurfaceExtimpl;->mApplist:Lcom/mediatek/appresolutiontuner/ResolutionTunerAppList;

    const-string v0, "ro.vendor.game_aisr_enable"

    .line 30
    invoke-static {v0}, Landroid/os/SystemProperties;->get(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    const-string v1, "1"

    .line 29
    invoke-virtual {v1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    sput-boolean v0, Lcom/mediatek/view/impl/SurfaceExtimpl;->APP_RESOLUTION_TUNING_AI_ENABLE:Z

    return-void
.end method

.method public constructor <init>()V
    .locals 1

    .line 32
    invoke-direct {p0}, Lcom/mediatek/view/SurfaceExt;-><init>()V

    const/4 v0, 0x0

    .line 24
    iput-boolean v0, p0, Lcom/mediatek/view/impl/SurfaceExtimpl;->mIsContainPackageName:Z

    .line 25
    iput-boolean v0, p0, Lcom/mediatek/view/impl/SurfaceExtimpl;->mIsScaledByGameMode:Z

    const/high16 v0, 0x3f800000    # 1.0f

    .line 26
    iput v0, p0, Lcom/mediatek/view/impl/SurfaceExtimpl;->mXScaleValue:F

    .line 27
    iput v0, p0, Lcom/mediatek/view/impl/SurfaceExtimpl;->mYScaleValue:F

    return-void
.end method

.method private getCallerProcessName()Ljava/lang/String;
    .locals 2

    .line 101
    invoke-static {}, Landroid/os/Binder;->getCallingUid()I

    move-result p0

    const-string v0, "package"

    .line 102
    invoke-static {v0}, Landroid/os/ServiceManager;->getService(Ljava/lang/String;)Landroid/os/IBinder;

    move-result-object v0

    invoke-static {v0}, Landroid/content/pm/IPackageManager$Stub;->asInterface(Landroid/os/IBinder;)Landroid/content/pm/IPackageManager;

    move-result-object v0

    if-eqz v0, :cond_0

    .line 105
    :try_start_0
    invoke-interface {v0, p0}, Landroid/content/pm/IPackageManager;->getNameForUid(I)Ljava/lang/String;

    move-result-object p0
    :try_end_0
    .catch Landroid/os/RemoteException; {:try_start_0 .. :try_end_0} :catch_0

    return-object p0

    :catch_0
    move-exception p0

    .line 109
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "getCallerProcessName exception :"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    const-string v0, "SurfaceExt"

    invoke-static {v0, p0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    :cond_0
    const/4 p0, 0x0

    return-object p0
.end method

.method private getTunerList()Lcom/mediatek/appresolutiontuner/ResolutionTunerAppList;
    .locals 0

    .line 95
    invoke-static {}, Lcom/mediatek/appresolutiontuner/ResolutionTunerAppList;->getInstance()Lcom/mediatek/appresolutiontuner/ResolutionTunerAppList;

    move-result-object p0

    .line 96
    invoke-virtual {p0}, Lcom/mediatek/appresolutiontuner/ResolutionTunerAppList;->loadTunerAppList()Ljava/util/ArrayList;

    return-object p0
.end method


# virtual methods
.method public getXScale()F
    .locals 0

    .line 86
    iget p0, p0, Lcom/mediatek/view/impl/SurfaceExtimpl;->mXScaleValue:F

    return p0
.end method

.method public getYScale()F
    .locals 0

    .line 91
    iget p0, p0, Lcom/mediatek/view/impl/SurfaceExtimpl;->mYScaleValue:F

    return p0
.end method

.method public initResolutionTunner()V
    .locals 3

    .line 55
    sget v0, Lcom/mediatek/view/impl/SurfaceExtimpl;->ENABLE_RESOLUTION_TUNING:I

    const/4 v1, 0x1

    if-ne v0, v1, :cond_2

    sget-object v0, Lcom/mediatek/view/impl/SurfaceExtimpl;->mApplist:Lcom/mediatek/appresolutiontuner/ResolutionTunerAppList;

    if-nez v0, :cond_2

    .line 56
    invoke-direct {p0}, Lcom/mediatek/view/impl/SurfaceExtimpl;->getCallerProcessName()Ljava/lang/String;

    move-result-object v0

    iput-object v0, p0, Lcom/mediatek/view/impl/SurfaceExtimpl;->mPackageName:Ljava/lang/String;

    .line 57
    invoke-direct {p0}, Lcom/mediatek/view/impl/SurfaceExtimpl;->getTunerList()Lcom/mediatek/appresolutiontuner/ResolutionTunerAppList;

    move-result-object v0

    sput-object v0, Lcom/mediatek/view/impl/SurfaceExtimpl;->mApplist:Lcom/mediatek/appresolutiontuner/ResolutionTunerAppList;

    .line 58
    iget-object v1, p0, Lcom/mediatek/view/impl/SurfaceExtimpl;->mPackageName:Ljava/lang/String;

    invoke-virtual {v0, v1}, Lcom/mediatek/appresolutiontuner/ResolutionTunerAppList;->isScaledBySurfaceView(Ljava/lang/String;)Z

    move-result v0

    iput-boolean v0, p0, Lcom/mediatek/view/impl/SurfaceExtimpl;->mIsContainPackageName:Z

    .line 59
    sget-object v0, Lcom/mediatek/view/impl/SurfaceExtimpl;->mApplist:Lcom/mediatek/appresolutiontuner/ResolutionTunerAppList;

    iget-object v1, p0, Lcom/mediatek/view/impl/SurfaceExtimpl;->mPackageName:Ljava/lang/String;

    invoke-virtual {v0, v1}, Lcom/mediatek/appresolutiontuner/ResolutionTunerAppList;->isScaledByGameMode(Ljava/lang/String;)Z

    move-result v0

    iput-boolean v0, p0, Lcom/mediatek/view/impl/SurfaceExtimpl;->mIsScaledByGameMode:Z

    .line 60
    sget-object v0, Lcom/mediatek/view/impl/SurfaceExtimpl;->mApplist:Lcom/mediatek/appresolutiontuner/ResolutionTunerAppList;

    iget-object v1, p0, Lcom/mediatek/view/impl/SurfaceExtimpl;->mPackageName:Ljava/lang/String;

    invoke-virtual {v0, v1}, Lcom/mediatek/appresolutiontuner/ResolutionTunerAppList;->getScaleWidth(Ljava/lang/String;)F

    move-result v0

    const/4 v1, 0x0

    cmpl-float v0, v0, v1

    if-eqz v0, :cond_1

    sget-object v0, Lcom/mediatek/view/impl/SurfaceExtimpl;->mApplist:Lcom/mediatek/appresolutiontuner/ResolutionTunerAppList;

    iget-object v2, p0, Lcom/mediatek/view/impl/SurfaceExtimpl;->mPackageName:Ljava/lang/String;

    invoke-virtual {v0, v2}, Lcom/mediatek/appresolutiontuner/ResolutionTunerAppList;->getScaleHeight(Ljava/lang/String;)F

    move-result v0

    cmpl-float v0, v0, v1

    if-nez v0, :cond_0

    goto :goto_0

    .line 64
    :cond_0
    sget-object v0, Lcom/mediatek/view/impl/SurfaceExtimpl;->mApplist:Lcom/mediatek/appresolutiontuner/ResolutionTunerAppList;

    iget-object v1, p0, Lcom/mediatek/view/impl/SurfaceExtimpl;->mPackageName:Ljava/lang/String;

    invoke-virtual {v0, v1}, Lcom/mediatek/appresolutiontuner/ResolutionTunerAppList;->getScaleWidth(Ljava/lang/String;)F

    move-result v0

    iput v0, p0, Lcom/mediatek/view/impl/SurfaceExtimpl;->mXScaleValue:F

    .line 65
    sget-object v0, Lcom/mediatek/view/impl/SurfaceExtimpl;->mApplist:Lcom/mediatek/appresolutiontuner/ResolutionTunerAppList;

    iget-object v1, p0, Lcom/mediatek/view/impl/SurfaceExtimpl;->mPackageName:Ljava/lang/String;

    invoke-virtual {v0, v1}, Lcom/mediatek/appresolutiontuner/ResolutionTunerAppList;->getScaleHeight(Ljava/lang/String;)F

    move-result v0

    iput v0, p0, Lcom/mediatek/view/impl/SurfaceExtimpl;->mYScaleValue:F

    goto :goto_1

    .line 61
    :cond_1
    :goto_0
    sget-object v0, Lcom/mediatek/view/impl/SurfaceExtimpl;->mApplist:Lcom/mediatek/appresolutiontuner/ResolutionTunerAppList;

    iget-object v1, p0, Lcom/mediatek/view/impl/SurfaceExtimpl;->mPackageName:Ljava/lang/String;

    invoke-virtual {v0, v1}, Lcom/mediatek/appresolutiontuner/ResolutionTunerAppList;->getScaleValue(Ljava/lang/String;)F

    move-result v0

    iput v0, p0, Lcom/mediatek/view/impl/SurfaceExtimpl;->mXScaleValue:F

    .line 62
    iput v0, p0, Lcom/mediatek/view/impl/SurfaceExtimpl;->mYScaleValue:F

    .line 67
    :goto_1
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "initResolutionTunner, mPackageName:"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/mediatek/view/impl/SurfaceExtimpl;->mPackageName:Ljava/lang/String;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, ",mContainPackageName:"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-boolean v1, p0, Lcom/mediatek/view/impl/SurfaceExtimpl;->mIsContainPackageName:Z

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v1, "mXScaleValue:"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v1, p0, Lcom/mediatek/view/impl/SurfaceExtimpl;->mXScaleValue:F

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(F)Ljava/lang/StringBuilder;

    const-string v1, ",mYScaleValue:"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget p0, p0, Lcom/mediatek/view/impl/SurfaceExtimpl;->mYScaleValue:F

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(F)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    const-string v0, "SurfaceExt"

    invoke-static {v0, p0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    :cond_2
    return-void
.end method

.method public isInWhiteList()Z
    .locals 6

    .line 37
    sget-boolean v0, Lcom/mediatek/view/impl/SurfaceExtimpl;->ENABLE_WHITE_LIST:Z

    const/4 v1, 0x1

    if-eqz v0, :cond_0

    return v1

    .line 41
    :cond_0
    invoke-direct {p0}, Lcom/mediatek/view/impl/SurfaceExtimpl;->getCallerProcessName()Ljava/lang/String;

    move-result-object p0

    .line 42
    sget-object v0, Lcom/mediatek/view/impl/SurfaceExtimpl;->WHITE_LIST:[Ljava/lang/String;

    const/4 v2, 0x0

    if-eqz v0, :cond_2

    if-eqz p0, :cond_2

    .line 43
    array-length v3, v0

    move v4, v2

    :goto_0
    if-ge v4, v3, :cond_2

    aget-object v5, v0, v4

    .line 44
    invoke-virtual {v5, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v5

    if-eqz v5, :cond_1

    goto :goto_1

    :cond_1
    add-int/lit8 v4, v4, 0x1

    goto :goto_0

    :cond_2
    move v1, v2

    :goto_1
    return v1
.end method

.method public isResolutionTuningPackage()Z
    .locals 0

    .line 76
    iget-boolean p0, p0, Lcom/mediatek/view/impl/SurfaceExtimpl;->mIsContainPackageName:Z

    return p0
.end method

.method public isScaledByGameMode()Z
    .locals 0

    .line 81
    iget-boolean p0, p0, Lcom/mediatek/view/impl/SurfaceExtimpl;->mIsScaledByGameMode:Z

    return p0
.end method
