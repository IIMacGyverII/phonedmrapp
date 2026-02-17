.class public Lcom/mediatek/boostfwk/identify/launch/LaunchIdentify;
.super Lcom/mediatek/boostfwk/identify/BaseIdentify;
.source "LaunchIdentify.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/mediatek/boostfwk/identify/launch/LaunchIdentify$WorkerHandler;
    }
.end annotation


# static fields
.field public static final HOSTTYPE_ACTIVITY:Ljava/lang/String; = "activity"

.field private static final TAG:Ljava/lang/String; = "SBE-LaunchIdentify"

.field public static final THREAD_NAME:Ljava/lang/String; = "launch"

.field private static lock:Ljava/lang/Object;

.field private static sInstance:Lcom/mediatek/boostfwk/identify/launch/LaunchIdentify;


# instance fields
.field private mCount:I

.field private mIsBegin:Z

.field private mLaunchConfig:Lcom/mediatek/boostfwk/identify/launch/LaunchConfig;

.field private mLaunchPolicy:Lcom/mediatek/boostfwk/policy/launch/LaunchPolicy;

.field private mPkgName:Ljava/lang/String;

.field private mSpecialPkgNames:Ljava/util/List;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/List<",
            "Ljava/lang/String;",
            ">;"
        }
    .end annotation
.end field

.field private mWorkerHandler:Lcom/mediatek/boostfwk/identify/launch/LaunchIdentify$WorkerHandler;

.field private mWorkerThread:Landroid/os/HandlerThread;


# direct methods
.method static constructor <clinit>()V
    .locals 1

    .line 69
    new-instance v0, Ljava/lang/Object;

    invoke-direct {v0}, Ljava/lang/Object;-><init>()V

    sput-object v0, Lcom/mediatek/boostfwk/identify/launch/LaunchIdentify;->lock:Ljava/lang/Object;

    return-void
.end method

.method public constructor <init>()V
    .locals 1

    .line 109
    invoke-direct {p0}, Lcom/mediatek/boostfwk/identify/BaseIdentify;-><init>()V

    const/4 v0, 0x0

    .line 70
    iput-object v0, p0, Lcom/mediatek/boostfwk/identify/launch/LaunchIdentify;->mWorkerThread:Landroid/os/HandlerThread;

    .line 71
    iput-object v0, p0, Lcom/mediatek/boostfwk/identify/launch/LaunchIdentify;->mWorkerHandler:Lcom/mediatek/boostfwk/identify/launch/LaunchIdentify$WorkerHandler;

    const/4 v0, 0x0

    .line 76
    iput-boolean v0, p0, Lcom/mediatek/boostfwk/identify/launch/LaunchIdentify;->mIsBegin:Z

    .line 77
    iput v0, p0, Lcom/mediatek/boostfwk/identify/launch/LaunchIdentify;->mCount:I

    .line 78
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    iput-object v0, p0, Lcom/mediatek/boostfwk/identify/launch/LaunchIdentify;->mSpecialPkgNames:Ljava/util/List;

    .line 110
    new-instance v0, Lcom/mediatek/boostfwk/identify/launch/LaunchConfig;

    invoke-direct {v0}, Lcom/mediatek/boostfwk/identify/launch/LaunchConfig;-><init>()V

    iput-object v0, p0, Lcom/mediatek/boostfwk/identify/launch/LaunchIdentify;->mLaunchConfig:Lcom/mediatek/boostfwk/identify/launch/LaunchConfig;

    .line 111
    new-instance v0, Lcom/mediatek/boostfwk/policy/launch/LaunchPolicy;

    invoke-direct {v0}, Lcom/mediatek/boostfwk/policy/launch/LaunchPolicy;-><init>()V

    iput-object v0, p0, Lcom/mediatek/boostfwk/identify/launch/LaunchIdentify;->mLaunchPolicy:Lcom/mediatek/boostfwk/policy/launch/LaunchPolicy;

    .line 112
    invoke-virtual {p0}, Lcom/mediatek/boostfwk/identify/launch/LaunchIdentify;->initSpecialMap()V

    .line 113
    invoke-direct {p0}, Lcom/mediatek/boostfwk/identify/launch/LaunchIdentify;->initThread()V

    return-void
.end method

.method private getActivityCount(Ljava/lang/String;)I
    .locals 0

    .line 327
    sget-object p0, Lcom/mediatek/boostfwk/identify/launch/LaunchConfig;->SPECIAL_MAP:Ljava/util/Map;

    invoke-interface {p0, p1}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p0

    if-eqz p0, :cond_0

    .line 328
    sget-object p0, Lcom/mediatek/boostfwk/identify/launch/LaunchConfig;->SPECIAL_MAP:Ljava/util/Map;

    invoke-interface {p0, p1}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Ljava/lang/String;

    invoke-static {p0}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I

    move-result p0

    return p0

    :cond_0
    const/4 p0, 0x1

    return p0
.end method

.method public static getInstance()Lcom/mediatek/boostfwk/identify/launch/LaunchIdentify;
    .locals 2

    .line 83
    sget-object v0, Lcom/mediatek/boostfwk/identify/launch/LaunchIdentify;->sInstance:Lcom/mediatek/boostfwk/identify/launch/LaunchIdentify;

    if-nez v0, :cond_1

    .line 84
    sget-object v0, Lcom/mediatek/boostfwk/identify/launch/LaunchIdentify;->lock:Ljava/lang/Object;

    monitor-enter v0

    .line 85
    :try_start_0
    sget-object v1, Lcom/mediatek/boostfwk/identify/launch/LaunchIdentify;->sInstance:Lcom/mediatek/boostfwk/identify/launch/LaunchIdentify;

    if-nez v1, :cond_0

    .line 86
    new-instance v1, Lcom/mediatek/boostfwk/identify/launch/LaunchIdentify;

    invoke-direct {v1}, Lcom/mediatek/boostfwk/identify/launch/LaunchIdentify;-><init>()V

    sput-object v1, Lcom/mediatek/boostfwk/identify/launch/LaunchIdentify;->sInstance:Lcom/mediatek/boostfwk/identify/launch/LaunchIdentify;

    .line 88
    :cond_0
    monitor-exit v0

    goto :goto_0

    :catchall_0
    move-exception v1

    monitor-exit v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    throw v1

    .line 90
    :cond_1
    :goto_0
    sget-object v0, Lcom/mediatek/boostfwk/identify/launch/LaunchIdentify;->sInstance:Lcom/mediatek/boostfwk/identify/launch/LaunchIdentify;

    return-object v0
.end method

.method private initThread()V
    .locals 3

    .line 94
    iget-object v0, p0, Lcom/mediatek/boostfwk/identify/launch/LaunchIdentify;->mWorkerThread:Landroid/os/HandlerThread;

    const-string v1, "SBE-LaunchIdentify"

    if-eqz v0, :cond_0

    invoke-virtual {v0}, Landroid/os/HandlerThread;->isAlive()Z

    move-result v0

    if-eqz v0, :cond_0

    iget-object v0, p0, Lcom/mediatek/boostfwk/identify/launch/LaunchIdentify;->mWorkerHandler:Lcom/mediatek/boostfwk/identify/launch/LaunchIdentify$WorkerHandler;

    if-eqz v0, :cond_0

    const-string p0, "re-init"

    .line 96
    invoke-static {v1, p0}, Lcom/mediatek/boostfwk/utils/LogUtil;->mLogi(Ljava/lang/String;Ljava/lang/String;)V

    goto :goto_0

    .line 98
    :cond_0
    new-instance v0, Landroid/os/HandlerThread;

    const-string v2, "launch"

    invoke-direct {v0, v2}, Landroid/os/HandlerThread;-><init>(Ljava/lang/String;)V

    iput-object v0, p0, Lcom/mediatek/boostfwk/identify/launch/LaunchIdentify;->mWorkerThread:Landroid/os/HandlerThread;

    .line 99
    invoke-virtual {v0}, Landroid/os/HandlerThread;->start()V

    .line 100
    iget-object v0, p0, Lcom/mediatek/boostfwk/identify/launch/LaunchIdentify;->mWorkerThread:Landroid/os/HandlerThread;

    invoke-virtual {v0}, Landroid/os/HandlerThread;->getLooper()Landroid/os/Looper;

    move-result-object v0

    if-nez v0, :cond_1

    const-string p0, "Thread looper is null"

    .line 102
    invoke-static {v1, p0}, Lcom/mediatek/boostfwk/utils/LogUtil;->mLogi(Ljava/lang/String;Ljava/lang/String;)V

    goto :goto_0

    .line 104
    :cond_1
    new-instance v1, Lcom/mediatek/boostfwk/identify/launch/LaunchIdentify$WorkerHandler;

    invoke-direct {v1, p0, v0}, Lcom/mediatek/boostfwk/identify/launch/LaunchIdentify$WorkerHandler;-><init>(Lcom/mediatek/boostfwk/identify/launch/LaunchIdentify;Landroid/os/Looper;)V

    iput-object v1, p0, Lcom/mediatek/boostfwk/identify/launch/LaunchIdentify;->mWorkerHandler:Lcom/mediatek/boostfwk/identify/launch/LaunchIdentify$WorkerHandler;

    :goto_0
    return-void
.end method

.method private isInSpecialList(Ljava/lang/String;)Z
    .locals 0

    .line 319
    iget-object p0, p0, Lcom/mediatek/boostfwk/identify/launch/LaunchIdentify;->mSpecialPkgNames:Ljava/util/List;

    if-eqz p0, :cond_0

    invoke-interface {p0, p1}, Ljava/util/List;->contains(Ljava/lang/Object;)Z

    move-result p0

    if-eqz p0, :cond_0

    const/4 p0, 0x1

    return p0

    :cond_0
    const/4 p0, 0x0

    return p0
.end method


# virtual methods
.method public boostEnd(Ljava/lang/String;)V
    .locals 2

    .line 296
    iget-boolean v0, p0, Lcom/mediatek/boostfwk/identify/launch/LaunchIdentify;->mIsBegin:Z

    if-eqz v0, :cond_0

    .line 297
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "SBE boost:"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, " end"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    const-string v1, "SBE-LaunchIdentify"

    invoke-static {v1, v0}, Lcom/mediatek/boostfwk/utils/LogUtil;->mLogd(Ljava/lang/String;Ljava/lang/String;)V

    .line 298
    iget-object v0, p0, Lcom/mediatek/boostfwk/identify/launch/LaunchIdentify;->mLaunchPolicy:Lcom/mediatek/boostfwk/policy/launch/LaunchPolicy;

    invoke-virtual {v0, p1}, Lcom/mediatek/boostfwk/policy/launch/LaunchPolicy;->boostEnd(Ljava/lang/String;)V

    const/4 p1, 0x0

    .line 299
    iput-boolean p1, p0, Lcom/mediatek/boostfwk/identify/launch/LaunchIdentify;->mIsBegin:Z

    const/4 v0, 0x0

    .line 300
    iput-object v0, p0, Lcom/mediatek/boostfwk/identify/launch/LaunchIdentify;->mPkgName:Ljava/lang/String;

    .line 301
    iput p1, p0, Lcom/mediatek/boostfwk/identify/launch/LaunchIdentify;->mCount:I

    :cond_0
    return-void
.end method

.method public boostHintBegin(Ljava/lang/String;Ljava/lang/String;)V
    .locals 3

    .line 195
    invoke-static {}, Lcom/mediatek/boostfwk/utils/Config;->isBoostFwkLogEnable()Z

    move-result v0

    const-string v1, "SBE-LaunchIdentify"

    if-eqz v0, :cond_0

    .line 196
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "boostHintBegin for hostingType= "

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v2, "; pkgName= "

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v1, v0}, Lcom/mediatek/boostfwk/utils/LogUtil;->mLogd(Ljava/lang/String;Ljava/lang/String;)V

    :cond_0
    if-eqz p1, :cond_1

    const-string v0, "activity"

    .line 201
    invoke-virtual {p1, v0}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result p1

    if-eqz p1, :cond_1

    invoke-static {p2}, Lcom/mediatek/boostfwk/utils/Util;->isSystemApp(Ljava/lang/String;)Z

    move-result p1

    if-nez p1, :cond_1

    .line 202
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "SBE boost:"

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v0, " begin"

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-static {v1, p1}, Lcom/mediatek/boostfwk/utils/LogUtil;->mLogd(Ljava/lang/String;Ljava/lang/String;)V

    .line 203
    iput-object p2, p0, Lcom/mediatek/boostfwk/identify/launch/LaunchIdentify;->mPkgName:Ljava/lang/String;

    const/4 p1, 0x1

    .line 204
    iput-boolean p1, p0, Lcom/mediatek/boostfwk/identify/launch/LaunchIdentify;->mIsBegin:Z

    const/4 p1, 0x0

    .line 205
    iput p1, p0, Lcom/mediatek/boostfwk/identify/launch/LaunchIdentify;->mCount:I

    :cond_1
    return-void
.end method

.method public boostHintEnd(Ljava/lang/String;Landroid/view/WindowManager$LayoutParams;)V
    .locals 2

    .line 234
    invoke-static {}, Lcom/mediatek/boostfwk/utils/Config;->isBoostFwkLogEnable()Z

    move-result v0

    if-eqz v0, :cond_0

    .line 235
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "boostHintEnd for pkgName = "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, ", mPkgName = "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/mediatek/boostfwk/identify/launch/LaunchIdentify;->mPkgName:Ljava/lang/String;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, ", isGameApp = "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 237
    invoke-static {p1}, Lcom/mediatek/boostfwk/utils/Util;->isGameApp(Ljava/lang/String;)Z

    move-result v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v1, ", isSpecialApp = "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 238
    invoke-direct {p0, p1}, Lcom/mediatek/boostfwk/identify/launch/LaunchIdentify;->isInSpecialList(Ljava/lang/String;)Z

    move-result v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v1, ", isFullScreen = "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 239
    invoke-static {p2}, Lcom/mediatek/boostfwk/utils/Util;->IsFullScreen(Landroid/view/WindowManager$LayoutParams;)Z

    move-result v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    const-string v1, "SBE-LaunchIdentify"

    .line 235
    invoke-static {v1, v0}, Lcom/mediatek/boostfwk/utils/LogUtil;->mLogd(Ljava/lang/String;Ljava/lang/String;)V

    .line 245
    :cond_0
    iget-object v0, p0, Lcom/mediatek/boostfwk/identify/launch/LaunchIdentify;->mPkgName:Ljava/lang/String;

    if-eqz v0, :cond_3

    invoke-virtual {v0, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_3

    invoke-static {p1}, Lcom/mediatek/boostfwk/utils/Util;->isSystemApp(Ljava/lang/String;)Z

    move-result v0

    if-nez v0, :cond_3

    .line 247
    invoke-direct {p0, p1}, Lcom/mediatek/boostfwk/identify/launch/LaunchIdentify;->isInSpecialList(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_1

    return-void

    .line 253
    :cond_1
    invoke-static {p1}, Lcom/mediatek/boostfwk/utils/Util;->isGameApp(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_2

    return-void

    .line 260
    :cond_2
    invoke-static {p2}, Lcom/mediatek/boostfwk/utils/Util;->IsFullScreen(Landroid/view/WindowManager$LayoutParams;)Z

    move-result p2

    if-nez p2, :cond_3

    .line 262
    iget-object p2, p0, Lcom/mediatek/boostfwk/identify/launch/LaunchIdentify;->mWorkerHandler:Lcom/mediatek/boostfwk/identify/launch/LaunchIdentify$WorkerHandler;

    const/4 v0, 0x3

    invoke-virtual {p2, v0, p1}, Landroid/os/Handler;->removeMessages(ILjava/lang/Object;)V

    .line 265
    iget-object p0, p0, Lcom/mediatek/boostfwk/identify/launch/LaunchIdentify;->mWorkerHandler:Lcom/mediatek/boostfwk/identify/launch/LaunchIdentify$WorkerHandler;

    .line 266
    invoke-virtual {p0, v0, p1}, Landroid/os/Handler;->obtainMessage(ILjava/lang/Object;)Landroid/os/Message;

    move-result-object p1

    const-wide/16 v0, 0x3e8

    .line 265
    invoke-virtual {p0, p1, v0, v1}, Landroid/os/Handler;->sendMessageDelayed(Landroid/os/Message;J)Z

    :cond_3
    return-void
.end method

.method public boostHintEndForSpecial(Ljava/lang/String;Ljava/lang/String;)V
    .locals 2

    .line 210
    invoke-static {}, Lcom/mediatek/boostfwk/utils/Config;->isBoostFwkLogEnable()Z

    move-result v0

    if-eqz v0, :cond_0

    .line 211
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "boostHintResume for pkgName= "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, ", activityName= "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p2, ", mLaunchConfig.isInSpecialList(pkgName) = "

    invoke-virtual {v0, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 214
    invoke-direct {p0, p1}, Lcom/mediatek/boostfwk/identify/launch/LaunchIdentify;->isInSpecialList(Ljava/lang/String;)Z

    move-result p2

    invoke-virtual {v0, p2}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    const-string v0, "SBE-LaunchIdentify"

    .line 211
    invoke-static {v0, p2}, Lcom/mediatek/boostfwk/utils/LogUtil;->mLogd(Ljava/lang/String;Ljava/lang/String;)V

    .line 217
    :cond_0
    iget-object p2, p0, Lcom/mediatek/boostfwk/identify/launch/LaunchIdentify;->mPkgName:Ljava/lang/String;

    if-eqz p2, :cond_1

    invoke-virtual {p2, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p2

    if-eqz p2, :cond_1

    invoke-direct {p0, p1}, Lcom/mediatek/boostfwk/identify/launch/LaunchIdentify;->isInSpecialList(Ljava/lang/String;)Z

    move-result p2

    if-eqz p2, :cond_1

    .line 219
    iget p2, p0, Lcom/mediatek/boostfwk/identify/launch/LaunchIdentify;->mCount:I

    add-int/lit8 p2, p2, 0x1

    iput p2, p0, Lcom/mediatek/boostfwk/identify/launch/LaunchIdentify;->mCount:I

    .line 220
    invoke-direct {p0, p1}, Lcom/mediatek/boostfwk/identify/launch/LaunchIdentify;->getActivityCount(Ljava/lang/String;)I

    move-result p2

    .line 222
    iget v0, p0, Lcom/mediatek/boostfwk/identify/launch/LaunchIdentify;->mCount:I

    if-ne v0, p2, :cond_1

    .line 224
    iget-object p2, p0, Lcom/mediatek/boostfwk/identify/launch/LaunchIdentify;->mWorkerHandler:Lcom/mediatek/boostfwk/identify/launch/LaunchIdentify$WorkerHandler;

    const/4 v0, 0x2

    .line 225
    invoke-virtual {p2, v0, p1}, Landroid/os/Handler;->obtainMessage(ILjava/lang/Object;)Landroid/os/Message;

    move-result-object p1

    const-wide/16 v0, 0x3e8

    .line 224
    invoke-virtual {p2, p1, v0, v1}, Landroid/os/Handler;->sendMessageDelayed(Landroid/os/Message;J)Z

    const/4 p1, 0x0

    .line 228
    iput p1, p0, Lcom/mediatek/boostfwk/identify/launch/LaunchIdentify;->mCount:I

    :cond_1
    return-void
.end method

.method public dispatchScenario(Lcom/mediatek/boostfwk/scenario/BasicScenario;)Z
    .locals 10

    const-string v0, "SBE-LaunchIdentify"

    if-nez p1, :cond_0

    const-string p0, "No Launch scenario to dispatcher."

    .line 129
    invoke-static {v0, p0}, Lcom/mediatek/boostfwk/utils/LogUtil;->mLogw(Ljava/lang/String;Ljava/lang/String;)V

    const/4 p0, 0x0

    return p0

    .line 132
    :cond_0
    check-cast p1, Lcom/mediatek/boostfwk/scenario/launch/LaunchScenario;

    .line 133
    invoke-virtual {p1}, Lcom/mediatek/boostfwk/scenario/launch/LaunchScenario;->getScenarioAction()I

    move-result v1

    .line 134
    invoke-static {}, Lcom/mediatek/boostfwk/utils/Config;->isBoostFwkLogEnable()Z

    move-result v2

    if-eqz v2, :cond_1

    .line 135
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "Launch action dispatcher to = "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-static {v0, v2}, Lcom/mediatek/boostfwk/utils/LogUtil;->mLogd(Ljava/lang/String;Ljava/lang/String;)V

    :cond_1
    const/4 v2, 0x1

    if-eq v1, v2, :cond_4

    const/4 p0, 0x3

    if-eq v1, p0, :cond_2

    const-string p0, "Not found dispatcher launch action."

    .line 156
    invoke-static {v0, p0}, Lcom/mediatek/boostfwk/utils/LogUtil;->mLogw(Ljava/lang/String;Ljava/lang/String;)V

    goto :goto_0

    .line 146
    :cond_2
    invoke-virtual {p1}, Lcom/mediatek/boostfwk/scenario/launch/LaunchScenario;->getActivity()Ljava/lang/ref/WeakReference;

    move-result-object p0

    if-eqz p0, :cond_5

    .line 147
    invoke-virtual {p0}, Ljava/lang/ref/WeakReference;->get()Ljava/lang/Object;

    move-result-object p1

    if-eqz p1, :cond_5

    .line 148
    invoke-static {}, Lcom/mediatek/boostfwk/utils/Config;->isBoostFwkLogEnable()Z

    move-result p1

    if-eqz p1, :cond_3

    .line 149
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "ACTIVITY_SWITCH set new context -->"

    invoke-virtual {p1, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/ref/WeakReference;->get()Ljava/lang/Object;

    move-result-object v1

    invoke-virtual {p1, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-static {v0, p1}, Lcom/mediatek/boostfwk/utils/LogUtil;->mLogd(Ljava/lang/String;Ljava/lang/String;)V

    .line 151
    :cond_3
    invoke-static {}, Lcom/mediatek/boostfwk/info/ActivityInfo;->getInstance()Lcom/mediatek/boostfwk/info/ActivityInfo;

    move-result-object p1

    invoke-virtual {p0}, Ljava/lang/ref/WeakReference;->get()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/content/Context;

    invoke-virtual {p1, v0}, Lcom/mediatek/boostfwk/info/ActivityInfo;->setContext(Landroid/content/Context;)V

    .line 152
    invoke-virtual {p0}, Ljava/lang/ref/WeakReference;->clear()V

    goto :goto_0

    .line 140
    :cond_4
    invoke-virtual {p1}, Lcom/mediatek/boostfwk/scenario/launch/LaunchScenario;->getBoostStatus()I

    move-result v4

    .line 141
    invoke-virtual {p1}, Lcom/mediatek/boostfwk/scenario/launch/LaunchScenario;->getHostingType()Ljava/lang/String;

    move-result-object v5

    invoke-virtual {p1}, Lcom/mediatek/boostfwk/scenario/launch/LaunchScenario;->getPackageName()Ljava/lang/String;

    move-result-object v6

    .line 142
    invoke-virtual {p1}, Lcom/mediatek/boostfwk/scenario/launch/LaunchScenario;->getAttrs()Landroid/view/WindowManager$LayoutParams;

    move-result-object v7

    invoke-virtual {p1}, Lcom/mediatek/boostfwk/scenario/launch/LaunchScenario;->getActivityName()Ljava/lang/String;

    move-result-object v8

    .line 143
    invoke-virtual {p1}, Lcom/mediatek/boostfwk/scenario/launch/LaunchScenario;->getIsComeFromIdle()Z

    move-result v9

    move-object v3, p0

    .line 140
    invoke-virtual/range {v3 .. v9}, Lcom/mediatek/boostfwk/identify/launch/LaunchIdentify;->launchHintCheck(ILjava/lang/String;Ljava/lang/String;Landroid/view/WindowManager$LayoutParams;Ljava/lang/String;Z)V

    :cond_5
    :goto_0
    return v2
.end method

.method public initSpecialMap()V
    .locals 3

    .line 307
    sget-object v0, Lcom/mediatek/boostfwk/identify/launch/LaunchConfig;->SPECIAL_MAP:Ljava/util/Map;

    invoke-interface {v0}, Ljava/util/Map;->entrySet()Ljava/util/Set;

    move-result-object v0

    invoke-interface {v0}, Ljava/util/Set;->iterator()Ljava/util/Iterator;

    move-result-object v0

    .line 308
    :goto_0
    invoke-interface {v0}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    if-eqz v1, :cond_0

    .line 309
    invoke-interface {v0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Ljava/util/Map$Entry;

    .line 312
    iget-object v2, p0, Lcom/mediatek/boostfwk/identify/launch/LaunchIdentify;->mSpecialPkgNames:Ljava/util/List;

    invoke-interface {v1}, Ljava/util/Map$Entry;->getKey()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Ljava/lang/String;

    invoke-interface {v2, v1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    goto :goto_0

    :cond_0
    return-void
.end method

.method public isMainThreadOnly()Z
    .locals 0

    const/4 p0, 0x0

    return p0
.end method

.method public launchHintCheck(ILjava/lang/String;Ljava/lang/String;Landroid/view/WindowManager$LayoutParams;Ljava/lang/String;Z)V
    .locals 0

    if-eqz p1, :cond_2

    const/4 p2, 0x1

    if-eq p1, p2, :cond_0

    const-string p0, "SBE-LaunchIdentify"

    const-string p1, "Not found dispatcher launch action."

    .line 189
    invoke-static {p0, p1}, Lcom/mediatek/boostfwk/utils/LogUtil;->mLogw(Ljava/lang/String;Ljava/lang/String;)V

    goto :goto_0

    :cond_0
    if-eqz p6, :cond_1

    .line 183
    invoke-virtual {p0, p3, p4}, Lcom/mediatek/boostfwk/identify/launch/LaunchIdentify;->boostHintEnd(Ljava/lang/String;Landroid/view/WindowManager$LayoutParams;)V

    goto :goto_0

    .line 185
    :cond_1
    invoke-virtual {p0, p3, p5}, Lcom/mediatek/boostfwk/identify/launch/LaunchIdentify;->boostHintEndForSpecial(Ljava/lang/String;Ljava/lang/String;)V

    goto :goto_0

    .line 179
    :cond_2
    invoke-virtual {p0, p2, p3}, Lcom/mediatek/boostfwk/identify/launch/LaunchIdentify;->boostHintBegin(Ljava/lang/String;Ljava/lang/String;)V

    :goto_0
    return-void
.end method
