.class public Lcom/mediatek/powerhalmgr/PowerHalMgrImpl;
.super Lcom/mediatek/powerhalmgr/PowerHalMgr;
.source "PowerHalMgrImpl.java"


# static fields
.field private static final TAG:Ljava/lang/String; = "PowerHalMgrImpl"

.field private static lock:Ljava/lang/Object;

.field private static sInstance:Lcom/mediatek/powerhalmgr/PowerHalMgrImpl;


# instance fields
.field private inited:I

.field private mContext:Landroid/content/Context;

.field private mPreviousTime:J

.field private sService:Lcom/mediatek/powerhalmgr/IPowerHalMgr;

.field private setTid:I


# direct methods
.method static constructor <clinit>()V
    .locals 1

    .line 57
    new-instance v0, Ljava/lang/Object;

    invoke-direct {v0}, Ljava/lang/Object;-><init>()V

    sput-object v0, Lcom/mediatek/powerhalmgr/PowerHalMgrImpl;->lock:Ljava/lang/Object;

    return-void
.end method

.method public constructor <init>()V
    .locals 2

    .line 90
    invoke-direct {p0}, Lcom/mediatek/powerhalmgr/PowerHalMgr;-><init>()V

    const/4 v0, 0x0

    .line 56
    iput-object v0, p0, Lcom/mediatek/powerhalmgr/PowerHalMgrImpl;->sService:Lcom/mediatek/powerhalmgr/IPowerHalMgr;

    const/4 v0, 0x0

    .line 60
    iput v0, p0, Lcom/mediatek/powerhalmgr/PowerHalMgrImpl;->inited:I

    .line 62
    iput v0, p0, Lcom/mediatek/powerhalmgr/PowerHalMgrImpl;->setTid:I

    const-wide/16 v0, 0x0

    .line 63
    iput-wide v0, p0, Lcom/mediatek/powerhalmgr/PowerHalMgrImpl;->mPreviousTime:J

    return-void
.end method

.method public static getInstance()Lcom/mediatek/powerhalmgr/PowerHalMgrImpl;
    .locals 2

    .line 82
    sget-object v0, Lcom/mediatek/powerhalmgr/PowerHalMgrImpl;->lock:Ljava/lang/Object;

    monitor-enter v0

    .line 83
    :try_start_0
    sget-object v1, Lcom/mediatek/powerhalmgr/PowerHalMgrImpl;->sInstance:Lcom/mediatek/powerhalmgr/PowerHalMgrImpl;

    if-nez v1, :cond_0

    .line 84
    new-instance v1, Lcom/mediatek/powerhalmgr/PowerHalMgrImpl;

    invoke-direct {v1}, Lcom/mediatek/powerhalmgr/PowerHalMgrImpl;-><init>()V

    sput-object v1, Lcom/mediatek/powerhalmgr/PowerHalMgrImpl;->sInstance:Lcom/mediatek/powerhalmgr/PowerHalMgrImpl;

    .line 86
    :cond_0
    sget-object v1, Lcom/mediatek/powerhalmgr/PowerHalMgrImpl;->sInstance:Lcom/mediatek/powerhalmgr/PowerHalMgrImpl;

    monitor-exit v0

    return-object v1

    :catchall_0
    move-exception v1

    .line 87
    monitor-exit v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    throw v1
.end method

.method private init()V
    .locals 1

    .line 69
    iget v0, p0, Lcom/mediatek/powerhalmgr/PowerHalMgrImpl;->inited:I

    if-nez v0, :cond_1

    const-string v0, "power_hal_mgr_service"

    .line 70
    invoke-static {v0}, Landroid/os/ServiceManager;->checkService(Ljava/lang/String;)Landroid/os/IBinder;

    move-result-object v0

    if-eqz v0, :cond_1

    .line 72
    invoke-static {v0}, Lcom/mediatek/powerhalmgr/IPowerHalMgr$Stub;->asInterface(Landroid/os/IBinder;)Lcom/mediatek/powerhalmgr/IPowerHalMgr;

    move-result-object v0

    iput-object v0, p0, Lcom/mediatek/powerhalmgr/PowerHalMgrImpl;->sService:Lcom/mediatek/powerhalmgr/IPowerHalMgr;

    if-eqz v0, :cond_0

    const/4 v0, 0x1

    .line 74
    iput v0, p0, Lcom/mediatek/powerhalmgr/PowerHalMgrImpl;->inited:I

    goto :goto_0

    :cond_0
    const-string v0, "ERR: getService() sService is still null.."

    .line 76
    invoke-direct {p0, v0}, Lcom/mediatek/powerhalmgr/PowerHalMgrImpl;->loge(Ljava/lang/String;)V

    :cond_1
    :goto_0
    return-void
.end method

.method private log(Ljava/lang/String;)V
    .locals 0

    .line 458
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p1, " "

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    const-string p1, "PowerHalMgrImpl"

    invoke-static {p1, p0}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method

.method private logd(Ljava/lang/String;)V
    .locals 0

    .line 462
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p1, " "

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    const-string p1, "PowerHalMgrImpl"

    invoke-static {p1, p0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method

.method private loge(Ljava/lang/String;)V
    .locals 1

    .line 466
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "ERR: "

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p1, " "

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    const-string p1, "PowerHalMgrImpl"

    invoke-static {p1, p0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method

.method public static native nativeGetPid()I
.end method

.method public static native nativeGetTid()I
.end method


# virtual methods
.method public UpdateManagementPkt(ILjava/lang/String;)V
    .locals 1

    .line 194
    :try_start_0
    invoke-direct {p0}, Lcom/mediatek/powerhalmgr/PowerHalMgrImpl;->init()V

    .line 195
    iget-object v0, p0, Lcom/mediatek/powerhalmgr/PowerHalMgrImpl;->sService:Lcom/mediatek/powerhalmgr/IPowerHalMgr;

    if-eqz v0, :cond_0

    .line 196
    invoke-interface {v0, p1, p2}, Lcom/mediatek/powerhalmgr/IPowerHalMgr;->UpdateManagementPkt(ILjava/lang/String;)V
    :try_end_0
    .catch Landroid/os/RemoteException; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    :catch_0
    move-exception p1

    .line 198
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "ERR: RemoteException in UpdateManagementPkt:"

    invoke-virtual {p2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-direct {p0, p1}, Lcom/mediatek/powerhalmgr/PowerHalMgrImpl;->loge(Ljava/lang/String;)V

    :cond_0
    :goto_0
    return-void
.end method

.method public configBoosterInfo(Lcom/mediatek/powerhalmgr/BoosterInfo;)Z
    .locals 3

    const/4 v0, 0x0

    if-nez p1, :cond_0

    const-string p1, "[Booster]: info == null"

    .line 355
    invoke-direct {p0, p1}, Lcom/mediatek/powerhalmgr/PowerHalMgrImpl;->loge(Ljava/lang/String;)V

    return v0

    .line 359
    :cond_0
    invoke-virtual {p1}, Lcom/mediatek/powerhalmgr/BoosterInfo;->getGroup()I

    move-result v1

    sget v2, Lcom/mediatek/powerhalmgr/BoosterInfo;->BOOSTER_GROUP_MAX:I

    if-gt v1, v2, :cond_3

    .line 360
    invoke-virtual {p1}, Lcom/mediatek/powerhalmgr/BoosterInfo;->getGroup()I

    move-result v1

    sget v2, Lcom/mediatek/powerhalmgr/BoosterInfo;->BOOSTER_GROUP_BASE:I

    if-gt v1, v2, :cond_1

    goto :goto_1

    .line 366
    :cond_1
    :try_start_0
    invoke-direct {p0}, Lcom/mediatek/powerhalmgr/PowerHalMgrImpl;->init()V

    .line 367
    iget-object v1, p0, Lcom/mediatek/powerhalmgr/PowerHalMgrImpl;->sService:Lcom/mediatek/powerhalmgr/IPowerHalMgr;

    if-eqz v1, :cond_2

    .line 368
    invoke-interface {v1, p1}, Lcom/mediatek/powerhalmgr/IPowerHalMgr;->configBoosterInfo(Lcom/mediatek/powerhalmgr/BoosterInfo;)Z

    move-result p0
    :try_end_0
    .catch Landroid/os/RemoteException; {:try_start_0 .. :try_end_0} :catch_0

    move v0, p0

    goto :goto_0

    :catch_0
    move-exception p1

    .line 371
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "[Booster]: RemoteException in configBoosterInfo: "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-direct {p0, p1}, Lcom/mediatek/powerhalmgr/PowerHalMgrImpl;->loge(Ljava/lang/String;)V

    :cond_2
    :goto_0
    return v0

    .line 361
    :cond_3
    :goto_1
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "[Booster]: Unsupported group "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Lcom/mediatek/powerhalmgr/BoosterInfo;->getGroup()I

    move-result p1

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-direct {p0, p1}, Lcom/mediatek/powerhalmgr/PowerHalMgrImpl;->loge(Ljava/lang/String;)V

    return v0
.end method

.method public flushPriorityRules(I)Z
    .locals 3

    const/4 v0, 0x0

    .line 332
    :try_start_0
    invoke-direct {p0}, Lcom/mediatek/powerhalmgr/PowerHalMgrImpl;->init()V

    .line 333
    iget-object v1, p0, Lcom/mediatek/powerhalmgr/PowerHalMgrImpl;->sService:Lcom/mediatek/powerhalmgr/IPowerHalMgr;

    if-eqz v1, :cond_0

    .line 334
    invoke-interface {v1, p1}, Lcom/mediatek/powerhalmgr/IPowerHalMgr;->flushPriorityRules(I)Z

    move-result p0
    :try_end_0
    .catch Landroid/os/RemoteException; {:try_start_0 .. :try_end_0} :catch_0

    move v0, p0

    goto :goto_0

    :catch_0
    move-exception p1

    .line 336
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "ERR: RemoteException in flushPriorityRules:"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-direct {p0, p1}, Lcom/mediatek/powerhalmgr/PowerHalMgrImpl;->loge(Ljava/lang/String;)V

    :cond_0
    :goto_0
    return v0
.end method

.method public getCpuCap()V
    .locals 1

    const-string v0, "getCpuCap"

    .line 177
    invoke-direct {p0, v0}, Lcom/mediatek/powerhalmgr/PowerHalMgrImpl;->log(Ljava/lang/String;)V

    return-void
.end method

.method public getCpuRTInfo()V
    .locals 1

    const-string v0, "getCpuRTInfo"

    .line 189
    invoke-direct {p0, v0}, Lcom/mediatek/powerhalmgr/PowerHalMgrImpl;->log(Ljava/lang/String;)V

    return-void
.end method

.method public getGpuCap()V
    .locals 1

    const-string v0, "getGpuCap"

    .line 181
    invoke-direct {p0, v0}, Lcom/mediatek/powerhalmgr/PowerHalMgrImpl;->log(Ljava/lang/String;)V

    return-void
.end method

.method public getGpuRTInfo()V
    .locals 1

    const-string v0, "getGpuRTInfo"

    .line 185
    invoke-direct {p0, v0}, Lcom/mediatek/powerhalmgr/PowerHalMgrImpl;->log(Ljava/lang/String;)V

    return-void
.end method

.method public isDupPacketPredictionStarted()Z
    .locals 3

    .line 251
    :try_start_0
    invoke-direct {p0}, Lcom/mediatek/powerhalmgr/PowerHalMgrImpl;->init()V

    .line 252
    iget-object v0, p0, Lcom/mediatek/powerhalmgr/PowerHalMgrImpl;->sService:Lcom/mediatek/powerhalmgr/IPowerHalMgr;

    if-eqz v0, :cond_0

    .line 253
    invoke-interface {v0}, Lcom/mediatek/powerhalmgr/IPowerHalMgr;->isDupPacketPredictionStarted()Z

    move-result v0

    .line 254
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "isDupPacketPredictionStarted() enable:"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-direct {p0, v1}, Lcom/mediatek/powerhalmgr/PowerHalMgrImpl;->logd(Ljava/lang/String;)V
    :try_end_0
    .catch Landroid/os/RemoteException; {:try_start_0 .. :try_end_0} :catch_0

    return v0

    :catch_0
    move-exception v0

    .line 258
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "ERR: RemoteException in isDupPacketPredictionStarted:"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-direct {p0, v0}, Lcom/mediatek/powerhalmgr/PowerHalMgrImpl;->loge(Ljava/lang/String;)V

    :cond_0
    const/4 p0, 0x0

    return p0
.end method

.method public mtkCusPowerHint(II)V
    .locals 1

    .line 168
    :try_start_0
    invoke-direct {p0}, Lcom/mediatek/powerhalmgr/PowerHalMgrImpl;->init()V

    .line 169
    iget-object v0, p0, Lcom/mediatek/powerhalmgr/PowerHalMgrImpl;->sService:Lcom/mediatek/powerhalmgr/IPowerHalMgr;

    if-eqz v0, :cond_0

    .line 170
    invoke-interface {v0, p1, p2}, Lcom/mediatek/powerhalmgr/IPowerHalMgr;->mtkCusPowerHint(II)V
    :try_end_0
    .catch Landroid/os/RemoteException; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    :catch_0
    move-exception p1

    .line 172
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "ERR: RemoteException in mtkCusPowerHint:"

    invoke-virtual {p2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-direct {p0, p1}, Lcom/mediatek/powerhalmgr/PowerHalMgrImpl;->loge(Ljava/lang/String;)V

    :cond_0
    :goto_0
    return-void
.end method

.method public mtkPowerHint(II)V
    .locals 1

    .line 437
    :try_start_0
    invoke-direct {p0}, Lcom/mediatek/powerhalmgr/PowerHalMgrImpl;->init()V

    .line 438
    iget-object v0, p0, Lcom/mediatek/powerhalmgr/PowerHalMgrImpl;->sService:Lcom/mediatek/powerhalmgr/IPowerHalMgr;

    if-eqz v0, :cond_0

    .line 439
    invoke-interface {v0, p1, p2}, Lcom/mediatek/powerhalmgr/IPowerHalMgr;->mtkPowerHint(II)V
    :try_end_0
    .catch Landroid/os/RemoteException; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    :catch_0
    move-exception p1

    .line 441
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "ERR: RemoteException in mtkPowerHint:"

    invoke-virtual {p2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-direct {p0, p1}, Lcom/mediatek/powerhalmgr/PowerHalMgrImpl;->loge(Ljava/lang/String;)V

    :cond_0
    :goto_0
    return-void
.end method

.method public perfCusLockHint(II)I
    .locals 2

    const/4 v0, -0x1

    .line 412
    :try_start_0
    invoke-direct {p0}, Lcom/mediatek/powerhalmgr/PowerHalMgrImpl;->init()V

    .line 413
    iget-object v1, p0, Lcom/mediatek/powerhalmgr/PowerHalMgrImpl;->sService:Lcom/mediatek/powerhalmgr/IPowerHalMgr;

    if-eqz v1, :cond_0

    .line 414
    invoke-interface {v1, p1, p2}, Lcom/mediatek/powerhalmgr/IPowerHalMgr;->perfCusLockHint(II)I

    move-result p0
    :try_end_0
    .catch Landroid/os/RemoteException; {:try_start_0 .. :try_end_0} :catch_0

    move v0, p0

    goto :goto_0

    :catch_0
    move-exception p1

    .line 416
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "ERR: RemoteException in perfCusLockHint:"

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-direct {p0, p1}, Lcom/mediatek/powerhalmgr/PowerHalMgrImpl;->loge(Ljava/lang/String;)V

    :cond_0
    :goto_0
    return v0
.end method

.method public perfLockAcquire(II[I)I
    .locals 1

    .line 390
    :try_start_0
    invoke-direct {p0}, Lcom/mediatek/powerhalmgr/PowerHalMgrImpl;->init()V

    .line 391
    iget-object v0, p0, Lcom/mediatek/powerhalmgr/PowerHalMgrImpl;->sService:Lcom/mediatek/powerhalmgr/IPowerHalMgr;

    if-eqz v0, :cond_0

    .line 392
    invoke-interface {v0, p1, p2, p3}, Lcom/mediatek/powerhalmgr/IPowerHalMgr;->perfLockAcquire(II[I)I

    move-result p0
    :try_end_0
    .catch Landroid/os/RemoteException; {:try_start_0 .. :try_end_0} :catch_0

    move p1, p0

    goto :goto_0

    :catch_0
    move-exception p2

    .line 394
    new-instance p3, Ljava/lang/StringBuilder;

    invoke-direct {p3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "ERR: RemoteException in perfLockAcquire:"

    invoke-virtual {p3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p3, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-direct {p0, p2}, Lcom/mediatek/powerhalmgr/PowerHalMgrImpl;->loge(Ljava/lang/String;)V

    :cond_0
    :goto_0
    return p1
.end method

.method public perfLockRelease(I)V
    .locals 2

    .line 401
    :try_start_0
    invoke-direct {p0}, Lcom/mediatek/powerhalmgr/PowerHalMgrImpl;->init()V

    .line 402
    iget-object v0, p0, Lcom/mediatek/powerhalmgr/PowerHalMgrImpl;->sService:Lcom/mediatek/powerhalmgr/IPowerHalMgr;

    if-eqz v0, :cond_0

    .line 403
    invoke-interface {v0, p1}, Lcom/mediatek/powerhalmgr/IPowerHalMgr;->perfLockRelease(I)V
    :try_end_0
    .catch Landroid/os/RemoteException; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    :catch_0
    move-exception p1

    .line 405
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "ERR: RemoteException in perfLockRelease:"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-direct {p0, p1}, Lcom/mediatek/powerhalmgr/PowerHalMgrImpl;->loge(Ljava/lang/String;)V

    :cond_0
    :goto_0
    return-void
.end method

.method public querySysInfo(II)I
    .locals 2

    const/4 v0, -0x1

    .line 425
    :try_start_0
    invoke-direct {p0}, Lcom/mediatek/powerhalmgr/PowerHalMgrImpl;->init()V

    .line 426
    iget-object v1, p0, Lcom/mediatek/powerhalmgr/PowerHalMgrImpl;->sService:Lcom/mediatek/powerhalmgr/IPowerHalMgr;

    if-eqz v1, :cond_0

    .line 427
    invoke-interface {v1, p1, p2}, Lcom/mediatek/powerhalmgr/IPowerHalMgr;->querySysInfo(II)I

    move-result p0
    :try_end_0
    .catch Landroid/os/RemoteException; {:try_start_0 .. :try_end_0} :catch_0

    move v0, p0

    goto :goto_0

    :catch_0
    move-exception p1

    .line 429
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "ERR: RemoteException in perfLockAcquire:"

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-direct {p0, p1}, Lcom/mediatek/powerhalmgr/PowerHalMgrImpl;->loge(Ljava/lang/String;)V

    :cond_0
    :goto_0
    return v0
.end method

.method public registerDuplicatePacketPredictionEvent(Landroid/os/IRemoteCallback;)Z
    .locals 3

    .line 265
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "registerDuplicatePacketPredictionEvent() "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/Class;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-direct {p0, v0}, Lcom/mediatek/powerhalmgr/PowerHalMgrImpl;->logd(Ljava/lang/String;)V

    const/4 v0, 0x0

    .line 267
    :try_start_0
    invoke-direct {p0}, Lcom/mediatek/powerhalmgr/PowerHalMgrImpl;->init()V

    .line 268
    iget-object v1, p0, Lcom/mediatek/powerhalmgr/PowerHalMgrImpl;->sService:Lcom/mediatek/powerhalmgr/IPowerHalMgr;

    if-eqz v1, :cond_0

    .line 269
    invoke-interface {v1, p1}, Lcom/mediatek/powerhalmgr/IPowerHalMgr;->registerDuplicatePacketPredictionEvent(Landroid/os/IRemoteCallback;)Z

    move-result p0
    :try_end_0
    .catch Landroid/os/RemoteException; {:try_start_0 .. :try_end_0} :catch_0

    move v0, p0

    goto :goto_0

    :catch_0
    move-exception p1

    .line 271
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "ERR: RemoteException in registerDuplicatePacketPredictionEvent:"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-direct {p0, p1}, Lcom/mediatek/powerhalmgr/PowerHalMgrImpl;->loge(Ljava/lang/String;)V

    :cond_0
    :goto_0
    return v0
.end method

.method public scnConfig(IIIIII)V
    .locals 7

    .line 112
    :try_start_0
    invoke-direct {p0}, Lcom/mediatek/powerhalmgr/PowerHalMgrImpl;->init()V

    .line 113
    iget-object v0, p0, Lcom/mediatek/powerhalmgr/PowerHalMgrImpl;->sService:Lcom/mediatek/powerhalmgr/IPowerHalMgr;

    if-eqz v0, :cond_0

    move v1, p1

    move v2, p2

    move v3, p3

    move v4, p4

    move v5, p5

    move v6, p6

    .line 114
    invoke-interface/range {v0 .. v6}, Lcom/mediatek/powerhalmgr/IPowerHalMgr;->scnConfig(IIIIII)V
    :try_end_0
    .catch Landroid/os/RemoteException; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    :catch_0
    move-exception p1

    .line 116
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string p3, "ERR: RemoteException in scnConfig:"

    invoke-virtual {p2, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-direct {p0, p1}, Lcom/mediatek/powerhalmgr/PowerHalMgrImpl;->loge(Ljava/lang/String;)V

    :cond_0
    :goto_0
    return-void
.end method

.method public scnDisable(I)V
    .locals 2

    .line 145
    :try_start_0
    invoke-direct {p0}, Lcom/mediatek/powerhalmgr/PowerHalMgrImpl;->init()V

    .line 146
    iget-object v0, p0, Lcom/mediatek/powerhalmgr/PowerHalMgrImpl;->sService:Lcom/mediatek/powerhalmgr/IPowerHalMgr;

    if-eqz v0, :cond_0

    .line 147
    invoke-interface {v0, p1}, Lcom/mediatek/powerhalmgr/IPowerHalMgr;->scnDisable(I)V
    :try_end_0
    .catch Landroid/os/RemoteException; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    :catch_0
    move-exception p1

    .line 149
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "ERR: RemoteException in scnDisable:"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-direct {p0, p1}, Lcom/mediatek/powerhalmgr/PowerHalMgrImpl;->loge(Ljava/lang/String;)V

    :cond_0
    :goto_0
    return-void
.end method

.method public scnEnable(II)V
    .locals 1

    .line 134
    :try_start_0
    invoke-direct {p0}, Lcom/mediatek/powerhalmgr/PowerHalMgrImpl;->init()V

    .line 135
    iget-object v0, p0, Lcom/mediatek/powerhalmgr/PowerHalMgrImpl;->sService:Lcom/mediatek/powerhalmgr/IPowerHalMgr;

    if-eqz v0, :cond_0

    .line 136
    invoke-interface {v0, p1, p2}, Lcom/mediatek/powerhalmgr/IPowerHalMgr;->scnEnable(II)V
    :try_end_0
    .catch Landroid/os/RemoteException; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    :catch_0
    move-exception p1

    .line 138
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "ERR: RemoteException in scnEnable:"

    invoke-virtual {p2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-direct {p0, p1}, Lcom/mediatek/powerhalmgr/PowerHalMgrImpl;->loge(Ljava/lang/String;)V

    :cond_0
    :goto_0
    return-void
.end method

.method public scnReg()I
    .locals 4

    const/4 v0, -0x1

    .line 97
    :try_start_0
    invoke-direct {p0}, Lcom/mediatek/powerhalmgr/PowerHalMgrImpl;->init()V

    .line 100
    iget-object v1, p0, Lcom/mediatek/powerhalmgr/PowerHalMgrImpl;->sService:Lcom/mediatek/powerhalmgr/IPowerHalMgr;

    if-eqz v1, :cond_0

    .line 101
    invoke-interface {v1}, Lcom/mediatek/powerhalmgr/IPowerHalMgr;->scnReg()I

    move-result p0
    :try_end_0
    .catch Landroid/os/RemoteException; {:try_start_0 .. :try_end_0} :catch_0

    move v0, p0

    goto :goto_0

    :catch_0
    move-exception v1

    .line 103
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "ERR: RemoteException in scnReg:"

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-direct {p0, v1}, Lcom/mediatek/powerhalmgr/PowerHalMgrImpl;->loge(Ljava/lang/String;)V

    :cond_0
    :goto_0
    return v0
.end method

.method public scnUltraCfg(IIIIII)V
    .locals 7

    .line 157
    :try_start_0
    invoke-direct {p0}, Lcom/mediatek/powerhalmgr/PowerHalMgrImpl;->init()V

    .line 158
    iget-object v0, p0, Lcom/mediatek/powerhalmgr/PowerHalMgrImpl;->sService:Lcom/mediatek/powerhalmgr/IPowerHalMgr;

    if-eqz v0, :cond_0

    move v1, p1

    move v2, p2

    move v3, p3

    move v4, p4

    move v5, p5

    move v6, p6

    .line 159
    invoke-interface/range {v0 .. v6}, Lcom/mediatek/powerhalmgr/IPowerHalMgr;->scnUltraCfg(IIIIII)V
    :try_end_0
    .catch Landroid/os/RemoteException; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    :catch_0
    move-exception p1

    .line 161
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string p3, "ERR: RemoteException in scnConfig:"

    invoke-virtual {p2, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-direct {p0, p1}, Lcom/mediatek/powerhalmgr/PowerHalMgrImpl;->loge(Ljava/lang/String;)V

    :cond_0
    :goto_0
    return-void
.end method

.method public scnUnreg(I)V
    .locals 2

    .line 123
    :try_start_0
    invoke-direct {p0}, Lcom/mediatek/powerhalmgr/PowerHalMgrImpl;->init()V

    .line 124
    iget-object v0, p0, Lcom/mediatek/powerhalmgr/PowerHalMgrImpl;->sService:Lcom/mediatek/powerhalmgr/IPowerHalMgr;

    if-eqz v0, :cond_0

    .line 125
    invoke-interface {v0, p1}, Lcom/mediatek/powerhalmgr/IPowerHalMgr;->scnUnreg(I)V
    :try_end_0
    .catch Landroid/os/RemoteException; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    :catch_0
    move-exception p1

    .line 127
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "ERR: RemoteException in scnUnreg:"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-direct {p0, p1}, Lcom/mediatek/powerhalmgr/PowerHalMgrImpl;->loge(Ljava/lang/String;)V

    :cond_0
    :goto_0
    return-void
.end method

.method public setForegroundSports()V
    .locals 3

    .line 204
    :try_start_0
    invoke-direct {p0}, Lcom/mediatek/powerhalmgr/PowerHalMgrImpl;->init()V

    .line 205
    iget-object v0, p0, Lcom/mediatek/powerhalmgr/PowerHalMgrImpl;->sService:Lcom/mediatek/powerhalmgr/IPowerHalMgr;

    if-eqz v0, :cond_0

    .line 206
    invoke-interface {v0}, Lcom/mediatek/powerhalmgr/IPowerHalMgr;->setForegroundSports()V
    :try_end_0
    .catch Landroid/os/RemoteException; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    :catch_0
    move-exception v0

    .line 208
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "ERR: RemoteException in setForegroundSports:"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-direct {p0, v0}, Lcom/mediatek/powerhalmgr/PowerHalMgrImpl;->loge(Ljava/lang/String;)V

    :cond_0
    :goto_0
    return-void
.end method

.method public setPredictInfo(Ljava/lang/String;I)V
    .locals 1

    .line 380
    :try_start_0
    invoke-direct {p0}, Lcom/mediatek/powerhalmgr/PowerHalMgrImpl;->init()V

    .line 381
    iget-object v0, p0, Lcom/mediatek/powerhalmgr/PowerHalMgrImpl;->sService:Lcom/mediatek/powerhalmgr/IPowerHalMgr;

    if-eqz v0, :cond_0

    .line 382
    invoke-interface {v0, p1, p2}, Lcom/mediatek/powerhalmgr/IPowerHalMgr;->setPredictInfo(Ljava/lang/String;I)V
    :try_end_0
    .catch Landroid/os/RemoteException; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    :catch_0
    move-exception p1

    .line 384
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "ERR: RemoteException in setPredictInfo:"

    invoke-virtual {p2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-direct {p0, p1}, Lcom/mediatek/powerhalmgr/PowerHalMgrImpl;->loge(Ljava/lang/String;)V

    :cond_0
    :goto_0
    return-void
.end method

.method public setPriorityByLinkinfo(ILcom/mediatek/powerhalmgr/DupLinkInfo;)Z
    .locals 2

    const/4 v0, 0x0

    .line 319
    :try_start_0
    invoke-direct {p0}, Lcom/mediatek/powerhalmgr/PowerHalMgrImpl;->init()V

    .line 320
    iget-object v1, p0, Lcom/mediatek/powerhalmgr/PowerHalMgrImpl;->sService:Lcom/mediatek/powerhalmgr/IPowerHalMgr;

    if-eqz v1, :cond_0

    .line 321
    invoke-interface {v1, p1, p2}, Lcom/mediatek/powerhalmgr/IPowerHalMgr;->setPriorityByLinkinfo(ILcom/mediatek/powerhalmgr/DupLinkInfo;)Z

    move-result p0
    :try_end_0
    .catch Landroid/os/RemoteException; {:try_start_0 .. :try_end_0} :catch_0

    move v0, p0

    goto :goto_0

    :catch_0
    move-exception p1

    .line 323
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "ERR: RemoteException in setPriorityByLinkinfo:"

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-direct {p0, p1}, Lcom/mediatek/powerhalmgr/PowerHalMgrImpl;->loge(Ljava/lang/String;)V

    :cond_0
    :goto_0
    return v0
.end method

.method public setPriorityByUid(II)Z
    .locals 2

    const/4 v0, 0x0

    .line 306
    :try_start_0
    invoke-direct {p0}, Lcom/mediatek/powerhalmgr/PowerHalMgrImpl;->init()V

    .line 307
    iget-object v1, p0, Lcom/mediatek/powerhalmgr/PowerHalMgrImpl;->sService:Lcom/mediatek/powerhalmgr/IPowerHalMgr;

    if-eqz v1, :cond_0

    .line 308
    invoke-interface {v1, p1, p2}, Lcom/mediatek/powerhalmgr/IPowerHalMgr;->setPriorityByUid(II)Z

    move-result p0
    :try_end_0
    .catch Landroid/os/RemoteException; {:try_start_0 .. :try_end_0} :catch_0

    move v0, p0

    goto :goto_0

    :catch_0
    move-exception p1

    .line 310
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "ERR: RemoteException in setPriorityByUid:"

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-direct {p0, p1}, Lcom/mediatek/powerhalmgr/PowerHalMgrImpl;->loge(Ljava/lang/String;)V

    :cond_0
    :goto_0
    return v0
.end method

.method public setSysInfo(ILjava/lang/String;)V
    .locals 1

    .line 214
    :try_start_0
    invoke-direct {p0}, Lcom/mediatek/powerhalmgr/PowerHalMgrImpl;->init()V

    .line 215
    iget-object v0, p0, Lcom/mediatek/powerhalmgr/PowerHalMgrImpl;->sService:Lcom/mediatek/powerhalmgr/IPowerHalMgr;

    if-eqz v0, :cond_0

    .line 216
    invoke-interface {v0, p1, p2}, Lcom/mediatek/powerhalmgr/IPowerHalMgr;->setSysInfo(ILjava/lang/String;)V
    :try_end_0
    .catch Landroid/os/RemoteException; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    :catch_0
    move-exception p1

    .line 218
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "ERR: RemoteException in setSysInfo:"

    invoke-virtual {p2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-direct {p0, p1}, Lcom/mediatek/powerhalmgr/PowerHalMgrImpl;->loge(Ljava/lang/String;)V

    :cond_0
    :goto_0
    return-void
.end method

.method public setSysInfoSync(ILjava/lang/String;)I
    .locals 2

    const/4 v0, -0x1

    .line 448
    :try_start_0
    invoke-direct {p0}, Lcom/mediatek/powerhalmgr/PowerHalMgrImpl;->init()V

    .line 449
    iget-object v1, p0, Lcom/mediatek/powerhalmgr/PowerHalMgrImpl;->sService:Lcom/mediatek/powerhalmgr/IPowerHalMgr;

    if-eqz v1, :cond_0

    .line 450
    invoke-interface {v1, p1, p2}, Lcom/mediatek/powerhalmgr/IPowerHalMgr;->setSysInfoSync(ILjava/lang/String;)I

    move-result p0
    :try_end_0
    .catch Landroid/os/RemoteException; {:try_start_0 .. :try_end_0} :catch_0

    move v0, p0

    goto :goto_0

    :catch_0
    move-exception p1

    .line 452
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "ERR: RemoteException in setPredictInfo:"

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-direct {p0, p1}, Lcom/mediatek/powerhalmgr/PowerHalMgrImpl;->loge(Ljava/lang/String;)V

    :cond_0
    :goto_0
    return v0
.end method

.method public startDuplicatePacketPrediction()Z
    .locals 4

    const-string/jumbo v0, "startDuplicatePacketPrediction()"

    .line 225
    invoke-direct {p0, v0}, Lcom/mediatek/powerhalmgr/PowerHalMgrImpl;->logd(Ljava/lang/String;)V

    const/4 v0, 0x0

    .line 227
    :try_start_0
    invoke-direct {p0}, Lcom/mediatek/powerhalmgr/PowerHalMgrImpl;->init()V

    .line 228
    iget-object v1, p0, Lcom/mediatek/powerhalmgr/PowerHalMgrImpl;->sService:Lcom/mediatek/powerhalmgr/IPowerHalMgr;

    if-eqz v1, :cond_0

    .line 229
    invoke-interface {v1}, Lcom/mediatek/powerhalmgr/IPowerHalMgr;->startDuplicatePacketPrediction()Z

    move-result p0
    :try_end_0
    .catch Landroid/os/RemoteException; {:try_start_0 .. :try_end_0} :catch_0

    move v0, p0

    goto :goto_0

    :catch_0
    move-exception v1

    .line 231
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "ERR: RemoteException in startDuplicatePacketPrediction:"

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-direct {p0, v1}, Lcom/mediatek/powerhalmgr/PowerHalMgrImpl;->loge(Ljava/lang/String;)V

    :cond_0
    :goto_0
    return v0
.end method

.method public stopDuplicatePacketPrediction()Z
    .locals 4

    const-string/jumbo v0, "stopDuplicatePacketPrediction()"

    .line 238
    invoke-direct {p0, v0}, Lcom/mediatek/powerhalmgr/PowerHalMgrImpl;->logd(Ljava/lang/String;)V

    const/4 v0, 0x0

    .line 240
    :try_start_0
    invoke-direct {p0}, Lcom/mediatek/powerhalmgr/PowerHalMgrImpl;->init()V

    .line 241
    iget-object v1, p0, Lcom/mediatek/powerhalmgr/PowerHalMgrImpl;->sService:Lcom/mediatek/powerhalmgr/IPowerHalMgr;

    if-eqz v1, :cond_0

    .line 242
    invoke-interface {v1}, Lcom/mediatek/powerhalmgr/IPowerHalMgr;->stopDuplicatePacketPrediction()Z

    move-result p0
    :try_end_0
    .catch Landroid/os/RemoteException; {:try_start_0 .. :try_end_0} :catch_0

    move v0, p0

    goto :goto_0

    :catch_0
    move-exception v1

    .line 244
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "ERR: RemoteException in stopDuplicatePacketPrediction:"

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-direct {p0, v1}, Lcom/mediatek/powerhalmgr/PowerHalMgrImpl;->loge(Ljava/lang/String;)V

    :cond_0
    :goto_0
    return v0
.end method

.method public unregisterDuplicatePacketPredictionEvent(Landroid/os/IRemoteCallback;)Z
    .locals 3

    .line 278
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string/jumbo v1, "unregisterDuplicatePacketPredictionEvent() "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/Class;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-direct {p0, v0}, Lcom/mediatek/powerhalmgr/PowerHalMgrImpl;->logd(Ljava/lang/String;)V

    const/4 v0, 0x0

    .line 280
    :try_start_0
    invoke-direct {p0}, Lcom/mediatek/powerhalmgr/PowerHalMgrImpl;->init()V

    .line 281
    iget-object v1, p0, Lcom/mediatek/powerhalmgr/PowerHalMgrImpl;->sService:Lcom/mediatek/powerhalmgr/IPowerHalMgr;

    if-eqz v1, :cond_0

    .line 282
    invoke-interface {v1, p1}, Lcom/mediatek/powerhalmgr/IPowerHalMgr;->unregisterDuplicatePacketPredictionEvent(Landroid/os/IRemoteCallback;)Z

    move-result p0
    :try_end_0
    .catch Landroid/os/RemoteException; {:try_start_0 .. :try_end_0} :catch_0

    move v0, p0

    goto :goto_0

    :catch_0
    move-exception p1

    .line 284
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "ERR: RemoteException in unregisterDuplicatePacketPredictionEvent:"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-direct {p0, p1}, Lcom/mediatek/powerhalmgr/PowerHalMgrImpl;->loge(Ljava/lang/String;)V

    :cond_0
    :goto_0
    return v0
.end method

.method public updateMultiDuplicatePacketLink([Lcom/mediatek/powerhalmgr/DupLinkInfo;)Z
    .locals 3

    const/4 v0, 0x0

    .line 293
    :try_start_0
    invoke-direct {p0}, Lcom/mediatek/powerhalmgr/PowerHalMgrImpl;->init()V

    .line 294
    iget-object v1, p0, Lcom/mediatek/powerhalmgr/PowerHalMgrImpl;->sService:Lcom/mediatek/powerhalmgr/IPowerHalMgr;

    if-eqz v1, :cond_0

    .line 295
    invoke-interface {v1, p1}, Lcom/mediatek/powerhalmgr/IPowerHalMgr;->updateMultiDuplicatePacketLink([Lcom/mediatek/powerhalmgr/DupLinkInfo;)Z

    move-result p0
    :try_end_0
    .catch Landroid/os/RemoteException; {:try_start_0 .. :try_end_0} :catch_0

    move v0, p0

    goto :goto_0

    :catch_0
    move-exception p1

    .line 297
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "ERR: RemoteException in updateMultiDuplicatePacketLink:"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-direct {p0, p1}, Lcom/mediatek/powerhalmgr/PowerHalMgrImpl;->loge(Ljava/lang/String;)V

    :cond_0
    :goto_0
    return v0
.end method
