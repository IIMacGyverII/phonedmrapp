.class public Lcom/mediatek/powerhalwrapper/PowerHalWrapper;
.super Ljava/lang/Object;
.source "PowerHalWrapper.java"


# static fields
.field private static AMS_BOOST_ACT_SWITCH:Z = true

.field private static AMS_BOOST_PACK_SWITCH:Z = true

.field private static AMS_BOOST_PROCESS_CREATE:Z = true

.field private static AMS_BOOST_PROCESS_CREATE_BOOST:Z = true

.field private static final AMS_BOOST_TIME:I = 0x2710

.field private static final ENG:Z = true

.field private static EXT_PEAK_PERF_MODE:Z = false

.field public static final MAX_NETD_IP_FILTER_COUNT:I = 0x3

.field public static final MTKPOWER_CMD_GET_POWER_SCN_TYPE:I = 0x69

.field public static final MTKPOWER_CMD_GET_RILD_CAP:I = 0x28

.field private static final MTKPOWER_HINT_ACT_SWITCH:I = 0x17

.field private static final MTKPOWER_HINT_ALWAYS_ENABLE:I = 0xfffffff

.field private static final MTKPOWER_HINT_APP_ROTATE:I = 0x18

.field private static final MTKPOWER_HINT_EXT_LAUNCH:I = 0x1e

.field private static final MTKPOWER_HINT_GALLERY_BOOST:I = 0x1a

.field private static final MTKPOWER_HINT_PACK_SWITCH:I = 0x16

.field private static final MTKPOWER_HINT_PMS_INSTALL:I = 0x1d

.field private static final MTKPOWER_HINT_PROCESS_CREATE:I = 0x15

.field private static final MTKPOWER_HINT_WFD:I = 0x1c

.field private static final MTKPOWER_HINT_WIPHY_SPEED_DL:I = 0x20

.field private static final MTKPOWER_STATE_DEAD:I = 0x3

.field private static final MTKPOWER_STATE_DESTORYED:I = 0x2

.field private static final MTKPOWER_STATE_PAUSED:I = 0x0

.field private static final MTKPOWER_STATE_RESUMED:I = 0x1

.field private static final MTKPOWER_STATE_STOPPED:I = 0x4

.field public static final PERF_RES_NET_MD_CRASH_PID:I = 0x280c300

.field public static final PERF_RES_NET_WIFI_SMART_PREDICT:I = 0x2804100

.field public static final PERF_RES_POWERHAL_SCREEN_OFF_STATE:I = 0x3400000

.field public static final POWER_HIDL_SET_SYS_INFO:I = 0x0

.field public static final SCN_PERF_LOCK_HINT:I = 0x3

.field public static final SCN_USER_HINT:I = 0x2

.field public static final SCREEN_OFF_DISABLE:I = 0x0

.field public static final SCREEN_OFF_ENABLE:I = 0x1

.field public static final SCREEN_OFF_WAIT_RESTORE:I = 0x2

.field public static final SETSYS_FOREGROUND_SPORTS:I = 0x3

.field public static final SETSYS_INTERNET_STATUS:I = 0x5

.field public static final SETSYS_MANAGEMENT_PERIODIC:I = 0x4

.field public static final SETSYS_MANAGEMENT_PREDICT:I = 0x1

.field public static final SETSYS_NETD_BOOSTER_CONFIG:I = 0x12

.field public static final SETSYS_NETD_CLEAR_FASTPATH_RULES:I = 0x11

.field public static final SETSYS_NETD_DUPLICATE_PACKET_LINK:I = 0x8

.field public static final SETSYS_NETD_SET_FASTPATH_BY_LINKINFO:I = 0x10

.field public static final SETSYS_NETD_SET_FASTPATH_BY_UID:I = 0xf

.field public static final SETSYS_NETD_STATUS:I = 0x6

.field public static final SETSYS_PACKAGE_VERSION_NAME:I = 0x9

.field public static final SETSYS_PREDICT_INFO:I = 0x7

.field public static final SETSYS_SPORTS_APK:I = 0x2

.field private static final TAG:Ljava/lang/String; = "PowerHalWrapper"

.field private static final USER_DURATION_MAX:I = 0x7530

.field private static lock:Ljava/lang/Object;

.field private static mProcessCreatePack:Ljava/lang/String;

.field private static sInstance:Lcom/mediatek/powerhalwrapper/PowerHalWrapper;


# instance fields
.field private mLock:Ljava/util/concurrent/locks/Lock;

.field public scnlist:Ljava/util/List;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/List<",
            "Lcom/mediatek/powerhalwrapper/ScnList;",
            ">;"
        }
    .end annotation
.end field


# direct methods
.method static constructor <clinit>()V
    .locals 1

    .line 123
    new-instance v0, Ljava/lang/Object;

    invoke-direct {v0}, Ljava/lang/Object;-><init>()V

    sput-object v0, Lcom/mediatek/powerhalwrapper/PowerHalWrapper;->lock:Ljava/lang/Object;

    const-string v0, "powerhalwrap_jni"

    .line 178
    invoke-static {v0}, Ljava/lang/System;->loadLibrary(Ljava/lang/String;)V

    return-void
.end method

.method private constructor <init>()V
    .locals 1

    .line 191
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 124
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    iput-object v0, p0, Lcom/mediatek/powerhalwrapper/PowerHalWrapper;->scnlist:Ljava/util/List;

    .line 173
    new-instance v0, Ljava/util/concurrent/locks/ReentrantLock;

    invoke-direct {v0}, Ljava/util/concurrent/locks/ReentrantLock;-><init>()V

    iput-object v0, p0, Lcom/mediatek/powerhalwrapper/PowerHalWrapper;->mLock:Ljava/util/concurrent/locks/Lock;

    return-void
.end method

.method public static getInstance()Lcom/mediatek/powerhalwrapper/PowerHalWrapper;
    .locals 2

    const-string v0, "PowerHalWrapper.getInstance"

    .line 182
    invoke-static {v0}, Lcom/mediatek/powerhalwrapper/PowerHalWrapper;->log(Ljava/lang/String;)V

    .line 183
    sget-object v0, Lcom/mediatek/powerhalwrapper/PowerHalWrapper;->lock:Ljava/lang/Object;

    monitor-enter v0

    .line 184
    :try_start_0
    sget-object v1, Lcom/mediatek/powerhalwrapper/PowerHalWrapper;->sInstance:Lcom/mediatek/powerhalwrapper/PowerHalWrapper;

    if-nez v1, :cond_0

    .line 185
    new-instance v1, Lcom/mediatek/powerhalwrapper/PowerHalWrapper;

    invoke-direct {v1}, Lcom/mediatek/powerhalwrapper/PowerHalWrapper;-><init>()V

    sput-object v1, Lcom/mediatek/powerhalwrapper/PowerHalWrapper;->sInstance:Lcom/mediatek/powerhalwrapper/PowerHalWrapper;

    .line 187
    :cond_0
    sget-object v1, Lcom/mediatek/powerhalwrapper/PowerHalWrapper;->sInstance:Lcom/mediatek/powerhalwrapper/PowerHalWrapper;

    monitor-exit v0

    return-object v1

    :catchall_0
    move-exception v1

    .line 188
    monitor-exit v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    throw v1
.end method

.method private static log(Ljava/lang/String;)V
    .locals 1

    .line 488
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p0, " "

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    const-string v0, "PowerHalWrapper"

    invoke-static {v0, p0}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method

.method private static logd(Ljava/lang/String;)V
    .locals 1

    .line 493
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p0, " "

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    const-string v0, "PowerHalWrapper"

    invoke-static {v0, p0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method

.method private static loge(Ljava/lang/String;)V
    .locals 2

    .line 497
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "ERR: "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p0, " "

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    const-string v0, "PowerHalWrapper"

    invoke-static {v0, p0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method

.method public static native nativeMtkCusPowerHint(II)I
.end method

.method public static native nativeMtkPowerHint(II)I
.end method

.method public static native nativeNotifyAppState(Ljava/lang/String;Ljava/lang/String;III)I
.end method

.method public static native nativeNotifyFrame(IIJ)I
.end method

.method public static native nativeNotifySbeRescue(IIIJ)I
.end method

.method public static native nativePerfCusLockHint(II)I
.end method

.method public static varargs native nativePerfLockAcq(II[I)I
.end method

.method public static native nativePerfLockRel(I)I
.end method

.method public static native nativeQuerySysInfo(II)I
.end method

.method public static native nativeScnConfig(IIIIII)I
.end method

.method public static native nativeScnDisable(I)I
.end method

.method public static native nativeScnEnable(II)I
.end method

.method public static native nativeScnReg()I
.end method

.method public static native nativeScnUltraCfg(IIIIII)I
.end method

.method public static native nativeScnUnreg(I)I
.end method

.method public static native nativeSetSbePolicy(Ljava/lang/String;III)I
.end method

.method public static native nativeSetSysInfo(Ljava/lang/String;I)I
.end method

.method public static native nativeSetSysInfoAsync(Ljava/lang/String;I)I
.end method


# virtual methods
.method public NotifyAppCrash(IILjava/lang/String;)V
    .locals 2

    .line 360
    invoke-static {}, Landroid/os/Process;->myPid()I

    move-result v0

    if-ne v0, p1, :cond_0

    .line 364
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0}, Ljava/lang/StringBuilder;-><init>()V

    const-string p1, "<NotifyAppCrash> pack:"

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p1, " ,pid:"

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p1, " == myPid:"

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p0}, Lcom/mediatek/powerhalwrapper/PowerHalWrapper;->log(Ljava/lang/String;)V

    return-void

    :cond_0
    const/4 v0, 0x3

    .line 369
    invoke-static {p3, p3, p1, v0, p2}, Lcom/mediatek/powerhalwrapper/PowerHalWrapper;->nativeNotifyAppState(Ljava/lang/String;Ljava/lang/String;III)I

    .line 371
    iget-object p2, p0, Lcom/mediatek/powerhalwrapper/PowerHalWrapper;->mLock:Ljava/util/concurrent/locks/Lock;

    invoke-interface {p2}, Ljava/util/concurrent/locks/Lock;->lock()V

    .line 373
    iget-object p2, p0, Lcom/mediatek/powerhalwrapper/PowerHalWrapper;->scnlist:Ljava/util/List;

    if-eqz p2, :cond_2

    invoke-interface {p2}, Ljava/util/List;->size()I

    move-result p2

    if-lez p2, :cond_2

    .line 374
    iget-object p2, p0, Lcom/mediatek/powerhalwrapper/PowerHalWrapper;->scnlist:Ljava/util/List;

    invoke-interface {p2}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object p2

    .line 375
    :cond_1
    :goto_0
    invoke-interface {p2}, Ljava/util/Iterator;->hasNext()Z

    move-result p3

    if-eqz p3, :cond_2

    .line 376
    invoke-interface {p2}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object p3

    check-cast p3, Lcom/mediatek/powerhalwrapper/ScnList;

    .line 377
    invoke-virtual {p3}, Lcom/mediatek/powerhalwrapper/ScnList;->getpid()I

    move-result v0

    if-ne v0, p1, :cond_1

    .line 378
    invoke-virtual {p3}, Lcom/mediatek/powerhalwrapper/ScnList;->gethandle()I

    move-result v0

    invoke-static {v0}, Lcom/mediatek/powerhalwrapper/PowerHalWrapper;->nativePerfLockRel(I)I

    .line 379
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "<NotifyAppCrash> pid:"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p3}, Lcom/mediatek/powerhalwrapper/ScnList;->getpid()I

    move-result v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, " uid:"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 380
    invoke-virtual {p3}, Lcom/mediatek/powerhalwrapper/ScnList;->getuid()I

    move-result v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, " handle:"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p3}, Lcom/mediatek/powerhalwrapper/ScnList;->gethandle()I

    move-result p3

    invoke-virtual {v0, p3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p3

    .line 379
    invoke-static {p3}, Lcom/mediatek/powerhalwrapper/PowerHalWrapper;->log(Ljava/lang/String;)V

    .line 381
    invoke-interface {p2}, Ljava/util/Iterator;->remove()V

    goto :goto_0

    .line 386
    :cond_2
    iget-object p0, p0, Lcom/mediatek/powerhalwrapper/PowerHalWrapper;->mLock:Ljava/util/concurrent/locks/Lock;

    invoke-interface {p0}, Ljava/util/concurrent/locks/Lock;->unlock()V

    return-void
.end method

.method public UpdateManagementPkt(ILjava/lang/String;)V
    .locals 1

    .line 296
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "<UpdateManagementPkt> type:"

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v0, ", packet:"

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p0}, Lcom/mediatek/powerhalwrapper/PowerHalWrapper;->logd(Ljava/lang/String;)V

    const/4 p0, 0x1

    if-eq p1, p0, :cond_1

    const/4 p0, 0x4

    if-eq p1, p0, :cond_0

    goto :goto_0

    .line 305
    :cond_0
    invoke-static {p2, p0}, Lcom/mediatek/powerhalwrapper/PowerHalWrapper;->nativeSetSysInfo(Ljava/lang/String;I)I

    goto :goto_0

    .line 301
    :cond_1
    invoke-static {p2, p0}, Lcom/mediatek/powerhalwrapper/PowerHalWrapper;->nativeSetSysInfo(Ljava/lang/String;I)I

    :goto_0
    return-void
.end method

.method public amsBoostNotify(ILjava/lang/String;Ljava/lang/String;II)V
    .locals 1

    .line 471
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "amsBoostNotify pid:"

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v0, ",activity:"

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v0, ", package:"

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v0, ", mProcessCreatePack"

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    sget-object v0, Lcom/mediatek/powerhalwrapper/PowerHalWrapper;->mProcessCreatePack:Ljava/lang/String;

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p0}, Lcom/mediatek/powerhalwrapper/PowerHalWrapper;->log(Ljava/lang/String;)V

    .line 473
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0}, Ljava/lang/StringBuilder;-><init>()V

    const-string/jumbo v0, "state: "

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, p5}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p0}, Lcom/mediatek/powerhalwrapper/PowerHalWrapper;->log(Ljava/lang/String;)V

    .line 474
    invoke-static {p3, p2, p1, p5, p4}, Lcom/mediatek/powerhalwrapper/PowerHalWrapper;->nativeNotifyAppState(Ljava/lang/String;Ljava/lang/String;III)I

    .line 477
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0}, Ljava/lang/StringBuilder;-><init>()V

    const-string p1, "amsBoostNotify AMS_BOOST_PROCESS_CREATE_BOOST:"

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    sget-boolean p1, Lcom/mediatek/powerhalwrapper/PowerHalWrapper;->AMS_BOOST_PROCESS_CREATE_BOOST:Z

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p0}, Lcom/mediatek/powerhalwrapper/PowerHalWrapper;->log(Ljava/lang/String;)V

    .line 478
    sget-object p0, Lcom/mediatek/powerhalwrapper/PowerHalWrapper;->mProcessCreatePack:Ljava/lang/String;

    if-eqz p0, :cond_0

    if-eqz p3, :cond_0

    .line 479
    sget-boolean p1, Lcom/mediatek/powerhalwrapper/PowerHalWrapper;->AMS_BOOST_PROCESS_CREATE_BOOST:Z

    if-eqz p1, :cond_0

    invoke-virtual {p0, p3}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p0

    if-nez p0, :cond_0

    const/4 p0, 0x1

    if-ne p5, p0, :cond_0

    const/4 p0, 0x0

    .line 482
    sput-boolean p0, Lcom/mediatek/powerhalwrapper/PowerHalWrapper;->AMS_BOOST_PROCESS_CREATE_BOOST:Z

    :cond_0
    return-void
.end method

.method public amsBoostProcessCreate(Ljava/lang/String;Ljava/lang/String;)V
    .locals 3

    if-eqz p1, :cond_0

    const-string p0, "activity"

    .line 432
    invoke-virtual {p1, p0}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result p0

    const/4 p1, 0x1

    if-ne p0, p1, :cond_0

    .line 433
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "amsBoostProcessCreate package:"

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p0}, Lcom/mediatek/powerhalwrapper/PowerHalWrapper;->log(Ljava/lang/String;)V

    const-wide/16 v0, 0x40

    const-string p0, "amPerfBoost"

    const/4 v2, 0x0

    .line 435
    invoke-static {v0, v1, p0, v2}, Landroid/os/Trace;->asyncTraceBegin(JLjava/lang/String;I)V

    .line 436
    sput-boolean p1, Lcom/mediatek/powerhalwrapper/PowerHalWrapper;->AMS_BOOST_PROCESS_CREATE:Z

    .line 437
    sput-boolean p1, Lcom/mediatek/powerhalwrapper/PowerHalWrapper;->AMS_BOOST_PROCESS_CREATE_BOOST:Z

    .line 438
    sput-object p2, Lcom/mediatek/powerhalwrapper/PowerHalWrapper;->mProcessCreatePack:Ljava/lang/String;

    const/16 p0, 0x1e

    .line 441
    invoke-static {p0, v2}, Lcom/mediatek/powerhalwrapper/PowerHalWrapper;->nativeMtkPowerHint(II)I

    const/16 p0, 0x15

    const/16 p1, 0x2710

    .line 443
    invoke-static {p0, p1}, Lcom/mediatek/powerhalwrapper/PowerHalWrapper;->nativeMtkPowerHint(II)I

    :cond_0
    return-void
.end method

.method public amsBoostResume(Ljava/lang/String;Ljava/lang/String;)V
    .locals 3

    .line 407
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "<amsBoostResume> last:"

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v0, ", next:"

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p0}, Lcom/mediatek/powerhalwrapper/PowerHalWrapper;->log(Ljava/lang/String;)V

    const-wide/16 v0, 0x40

    const-string p0, "amPerfBoost"

    const/4 v2, 0x0

    .line 410
    invoke-static {v0, v1, p0, v2}, Landroid/os/Trace;->asyncTraceBegin(JLjava/lang/String;I)V

    const/16 p0, 0x1e

    .line 412
    invoke-static {p0, v2}, Lcom/mediatek/powerhalwrapper/PowerHalWrapper;->nativeMtkPowerHint(II)I

    const/16 p0, 0x2710

    const/4 v0, 0x1

    if-eqz p1, :cond_1

    .line 415
    invoke-virtual {p1, p2}, Ljava/lang/String;->equalsIgnoreCase(Ljava/lang/String;)Z

    move-result p1

    if-nez p1, :cond_0

    goto :goto_0

    .line 423
    :cond_0
    sput-boolean v0, Lcom/mediatek/powerhalwrapper/PowerHalWrapper;->AMS_BOOST_ACT_SWITCH:Z

    const/16 p1, 0x17

    .line 426
    invoke-static {p1, p0}, Lcom/mediatek/powerhalwrapper/PowerHalWrapper;->nativeMtkPowerHint(II)I

    goto :goto_1

    .line 416
    :cond_1
    :goto_0
    sput-boolean v0, Lcom/mediatek/powerhalwrapper/PowerHalWrapper;->AMS_BOOST_PACK_SWITCH:Z

    const/16 p1, 0x16

    .line 419
    invoke-static {p1, p0}, Lcom/mediatek/powerhalwrapper/PowerHalWrapper;->nativeMtkPowerHint(II)I

    :goto_1
    return-void
.end method

.method public amsBoostStop()V
    .locals 3

    .line 448
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "amsBoostStop AMS_BOOST_PACK_SWITCH:"

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    sget-boolean v0, Lcom/mediatek/powerhalwrapper/PowerHalWrapper;->AMS_BOOST_PACK_SWITCH:Z

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v0, ", AMS_BOOST_ACT_SWITCH:"

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    sget-boolean v0, Lcom/mediatek/powerhalwrapper/PowerHalWrapper;->AMS_BOOST_ACT_SWITCH:Z

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v0, ", AMS_BOOST_PROCESS_CREATE:"

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    sget-boolean v0, Lcom/mediatek/powerhalwrapper/PowerHalWrapper;->AMS_BOOST_PROCESS_CREATE:Z

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p0}, Lcom/mediatek/powerhalwrapper/PowerHalWrapper;->log(Ljava/lang/String;)V

    .line 452
    sget-boolean p0, Lcom/mediatek/powerhalwrapper/PowerHalWrapper;->AMS_BOOST_PACK_SWITCH:Z

    const/4 v0, 0x0

    if-eqz p0, :cond_0

    .line 453
    sput-boolean v0, Lcom/mediatek/powerhalwrapper/PowerHalWrapper;->AMS_BOOST_PACK_SWITCH:Z

    const/16 p0, 0x16

    .line 454
    invoke-static {p0, v0}, Lcom/mediatek/powerhalwrapper/PowerHalWrapper;->nativeMtkPowerHint(II)I

    .line 457
    :cond_0
    sget-boolean p0, Lcom/mediatek/powerhalwrapper/PowerHalWrapper;->AMS_BOOST_ACT_SWITCH:Z

    if-eqz p0, :cond_1

    .line 458
    sput-boolean v0, Lcom/mediatek/powerhalwrapper/PowerHalWrapper;->AMS_BOOST_ACT_SWITCH:Z

    const/16 p0, 0x17

    .line 459
    invoke-static {p0, v0}, Lcom/mediatek/powerhalwrapper/PowerHalWrapper;->nativeMtkPowerHint(II)I

    .line 462
    :cond_1
    sget-boolean p0, Lcom/mediatek/powerhalwrapper/PowerHalWrapper;->AMS_BOOST_PROCESS_CREATE:Z

    if-eqz p0, :cond_2

    .line 463
    sput-boolean v0, Lcom/mediatek/powerhalwrapper/PowerHalWrapper;->AMS_BOOST_PROCESS_CREATE:Z

    const/16 p0, 0x15

    .line 464
    invoke-static {p0, v0}, Lcom/mediatek/powerhalwrapper/PowerHalWrapper;->nativeMtkPowerHint(II)I

    :cond_2
    const-wide/16 v1, 0x40

    const-string p0, "amPerfBoost"

    .line 467
    invoke-static {v1, v2, p0, v0}, Landroid/os/Trace;->asyncTraceEnd(JLjava/lang/String;I)V

    return-void
.end method

.method public galleryBoostEnable(I)V
    .locals 1

    .line 329
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "<galleryBoostEnable> do boost with "

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v0, "ms"

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p0}, Lcom/mediatek/powerhalwrapper/PowerHalWrapper;->log(Ljava/lang/String;)V

    const/16 p0, 0x1a

    .line 330
    invoke-static {p0, p1}, Lcom/mediatek/powerhalwrapper/PowerHalWrapper;->nativeMtkPowerHint(II)I

    return-void
.end method

.method public getCpuCap()V
    .locals 0

    const-string p0, "getCpuCap"

    .line 280
    invoke-static {p0}, Lcom/mediatek/powerhalwrapper/PowerHalWrapper;->log(Ljava/lang/String;)V

    return-void
.end method

.method public getCpuRTInfo()V
    .locals 0

    const-string p0, "mCpuRTInfo"

    .line 292
    invoke-static {p0}, Lcom/mediatek/powerhalwrapper/PowerHalWrapper;->log(Ljava/lang/String;)V

    return-void
.end method

.method public getGpuCap()V
    .locals 0

    const-string p0, "mGpuCap"

    .line 284
    invoke-static {p0}, Lcom/mediatek/powerhalwrapper/PowerHalWrapper;->log(Ljava/lang/String;)V

    return-void
.end method

.method public getGpuRTInfo()V
    .locals 0

    const-string p0, "getGpuCap"

    .line 288
    invoke-static {p0}, Lcom/mediatek/powerhalwrapper/PowerHalWrapper;->log(Ljava/lang/String;)V

    return-void
.end method

.method public getRildCap(I)Z
    .locals 0

    const/16 p0, 0x28

    .line 390
    invoke-static {p0, p1}, Lcom/mediatek/powerhalwrapper/PowerHalWrapper;->nativeQuerySysInfo(II)I

    move-result p0

    const/4 p1, 0x1

    if-ne p0, p1, :cond_0

    return p1

    :cond_0
    const/4 p0, 0x0

    return p0
.end method

.method public mtkCusPowerHint(II)V
    .locals 0

    .line 200
    invoke-static {p1, p2}, Lcom/mediatek/powerhalwrapper/PowerHalWrapper;->nativeMtkCusPowerHint(II)I

    return-void
.end method

.method public mtkNotifyFrame(IIJ)V
    .locals 0

    .line 208
    invoke-static {p1, p2, p3, p4}, Lcom/mediatek/powerhalwrapper/PowerHalWrapper;->nativeNotifyFrame(IIJ)I

    return-void
.end method

.method public mtkNotifySbeRescue(IIIJ)V
    .locals 0

    .line 204
    invoke-static {p1, p2, p3, p4, p5}, Lcom/mediatek/powerhalwrapper/PowerHalWrapper;->nativeNotifySbeRescue(IIIJ)I

    return-void
.end method

.method public mtkPowerHint(II)V
    .locals 0

    .line 196
    invoke-static {p1, p2}, Lcom/mediatek/powerhalwrapper/PowerHalWrapper;->nativeMtkPowerHint(II)I

    return-void
.end method

.method public mtkSetSbePolicy(Ljava/lang/String;III)V
    .locals 0

    .line 212
    invoke-static {p1, p2, p3, p4}, Lcom/mediatek/powerhalwrapper/PowerHalWrapper;->nativeSetSbePolicy(Ljava/lang/String;III)I

    return-void
.end method

.method public perfCusLockHint(II)I
    .locals 0

    .line 244
    invoke-static {p1, p2}, Lcom/mediatek/powerhalwrapper/PowerHalWrapper;->nativePerfCusLockHint(II)I

    move-result p0

    return p0
.end method

.method public varargs perfLockAcquire(II[I)I
    .locals 2

    .line 217
    invoke-static {}, Landroid/os/Binder;->getCallingPid()I

    move-result v0

    .line 218
    invoke-static {}, Landroid/os/Binder;->getCallingUid()I

    move-result v1

    .line 219
    invoke-static {p1, p2, p3}, Lcom/mediatek/powerhalwrapper/PowerHalWrapper;->nativePerfLockAcq(II[I)I

    move-result p3

    if-lez p3, :cond_1

    if-eq p3, p1, :cond_1

    const/16 p1, 0x7530

    if-gt p2, p1, :cond_0

    if-nez p2, :cond_1

    .line 221
    :cond_0
    iget-object p1, p0, Lcom/mediatek/powerhalwrapper/PowerHalWrapper;->mLock:Ljava/util/concurrent/locks/Lock;

    invoke-interface {p1}, Ljava/util/concurrent/locks/Lock;->lock()V

    .line 222
    new-instance p1, Lcom/mediatek/powerhalwrapper/ScnList;

    invoke-direct {p1, p3, v0, v1}, Lcom/mediatek/powerhalwrapper/ScnList;-><init>(III)V

    .line 223
    iget-object p2, p0, Lcom/mediatek/powerhalwrapper/PowerHalWrapper;->scnlist:Ljava/util/List;

    invoke-interface {p2, p1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 224
    iget-object p0, p0, Lcom/mediatek/powerhalwrapper/PowerHalWrapper;->mLock:Ljava/util/concurrent/locks/Lock;

    invoke-interface {p0}, Ljava/util/concurrent/locks/Lock;->unlock()V

    :cond_1
    return p3
.end method

.method public perfLockRelease(I)V
    .locals 2

    .line 230
    iget-object v0, p0, Lcom/mediatek/powerhalwrapper/PowerHalWrapper;->mLock:Ljava/util/concurrent/locks/Lock;

    invoke-interface {v0}, Ljava/util/concurrent/locks/Lock;->lock()V

    .line 231
    iget-object v0, p0, Lcom/mediatek/powerhalwrapper/PowerHalWrapper;->scnlist:Ljava/util/List;

    if-eqz v0, :cond_1

    invoke-interface {v0}, Ljava/util/List;->size()I

    move-result v0

    if-lez v0, :cond_1

    .line 232
    iget-object v0, p0, Lcom/mediatek/powerhalwrapper/PowerHalWrapper;->scnlist:Ljava/util/List;

    invoke-interface {v0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v0

    .line 233
    :cond_0
    :goto_0
    invoke-interface {v0}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    if-eqz v1, :cond_1

    .line 234
    invoke-interface {v0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lcom/mediatek/powerhalwrapper/ScnList;

    .line 235
    invoke-virtual {v1}, Lcom/mediatek/powerhalwrapper/ScnList;->gethandle()I

    move-result v1

    if-ne v1, p1, :cond_0

    .line 236
    invoke-interface {v0}, Ljava/util/Iterator;->remove()V

    goto :goto_0

    .line 239
    :cond_1
    iget-object p0, p0, Lcom/mediatek/powerhalwrapper/PowerHalWrapper;->mLock:Ljava/util/concurrent/locks/Lock;

    invoke-interface {p0}, Ljava/util/concurrent/locks/Lock;->unlock()V

    .line 240
    invoke-static {p1}, Lcom/mediatek/powerhalwrapper/PowerHalWrapper;->nativePerfLockRel(I)I

    return-void
.end method

.method public querySysInfo(II)I
    .locals 1

    .line 324
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "<querySysInfo> cmd:"

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v0, " param:"

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, p2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p0}, Lcom/mediatek/powerhalwrapper/PowerHalWrapper;->logd(Ljava/lang/String;)V

    .line 325
    invoke-static {p1, p2}, Lcom/mediatek/powerhalwrapper/PowerHalWrapper;->nativeQuerySysInfo(II)I

    move-result p0

    return p0
.end method

.method public scnConfig(IIIIII)I
    .locals 0

    const-string p0, "scnConfig not support!!!"

    .line 254
    invoke-static {p0}, Lcom/mediatek/powerhalwrapper/PowerHalWrapper;->loge(Ljava/lang/String;)V

    const/4 p0, 0x0

    return p0
.end method

.method public scnDisable(I)I
    .locals 0

    const-string p0, "scnDisable not support!!!"

    .line 269
    invoke-static {p0}, Lcom/mediatek/powerhalwrapper/PowerHalWrapper;->loge(Ljava/lang/String;)V

    const/4 p0, 0x0

    return p0
.end method

.method public scnEnable(II)I
    .locals 0

    const-string p0, "scnEnable not support!!!"

    .line 264
    invoke-static {p0}, Lcom/mediatek/powerhalwrapper/PowerHalWrapper;->loge(Ljava/lang/String;)V

    const/4 p0, 0x0

    return p0
.end method

.method public scnReg()I
    .locals 0

    const-string p0, "scnReg not support!!!"

    .line 248
    invoke-static {p0}, Lcom/mediatek/powerhalwrapper/PowerHalWrapper;->loge(Ljava/lang/String;)V

    const/4 p0, -0x1

    return p0
.end method

.method public scnUltraCfg(IIIIII)I
    .locals 0

    const-string p0, "scnUltraCfg not support!!!"

    .line 275
    invoke-static {p0}, Lcom/mediatek/powerhalwrapper/PowerHalWrapper;->loge(Ljava/lang/String;)V

    const/4 p0, 0x0

    return p0
.end method

.method public scnUnreg(I)I
    .locals 0

    const-string p0, "scnUnreg not support!!!"

    .line 259
    invoke-static {p0}, Lcom/mediatek/powerhalwrapper/PowerHalWrapper;->loge(Ljava/lang/String;)V

    const/4 p0, 0x0

    return p0
.end method

.method public setInstallationBoost(Z)V
    .locals 1

    .line 397
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "<setInstallationBoost> enable:"

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p0}, Lcom/mediatek/powerhalwrapper/PowerHalWrapper;->log(Ljava/lang/String;)V

    const/16 p0, 0x1d

    if-eqz p1, :cond_0

    const/16 p1, 0x3a98

    .line 399
    invoke-static {p0, p1}, Lcom/mediatek/powerhalwrapper/PowerHalWrapper;->nativeMtkPowerHint(II)I

    goto :goto_0

    :cond_0
    const/4 p1, 0x0

    .line 401
    invoke-static {p0, p1}, Lcom/mediatek/powerhalwrapper/PowerHalWrapper;->nativeMtkPowerHint(II)I

    :goto_0
    return-void
.end method

.method public setRotationBoost(I)V
    .locals 1

    .line 334
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "<setRotation> do boost with "

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v0, "ms"

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p0}, Lcom/mediatek/powerhalwrapper/PowerHalWrapper;->log(Ljava/lang/String;)V

    const/16 p0, 0x18

    .line 335
    invoke-static {p0, p1}, Lcom/mediatek/powerhalwrapper/PowerHalWrapper;->nativeMtkPowerHint(II)I

    return-void
.end method

.method public setSpeedDownload(I)V
    .locals 1

    .line 339
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "<setSpeedDownload> do boost with "

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v0, "ms"

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p0}, Lcom/mediatek/powerhalwrapper/PowerHalWrapper;->log(Ljava/lang/String;)V

    const/16 p0, 0x20

    .line 340
    invoke-static {p0, p1}, Lcom/mediatek/powerhalwrapper/PowerHalWrapper;->nativeMtkPowerHint(II)I

    return-void
.end method

.method public setSportsApk(Ljava/lang/String;)V
    .locals 1

    .line 353
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "<setSportsApk> pack:"

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p0}, Lcom/mediatek/powerhalwrapper/PowerHalWrapper;->log(Ljava/lang/String;)V

    const/4 p0, 0x2

    .line 354
    invoke-static {p1, p0}, Lcom/mediatek/powerhalwrapper/PowerHalWrapper;->nativeSetSysInfo(Ljava/lang/String;I)I

    return-void
.end method

.method public setSysInfo(ILjava/lang/String;)I
    .locals 0

    .line 315
    invoke-static {p2, p1}, Lcom/mediatek/powerhalwrapper/PowerHalWrapper;->nativeSetSysInfo(Ljava/lang/String;I)I

    move-result p0

    return p0
.end method

.method public setSysInfoAsync(ILjava/lang/String;)V
    .locals 0

    .line 320
    invoke-static {p2, p1}, Lcom/mediatek/powerhalwrapper/PowerHalWrapper;->nativeSetSysInfoAsync(Ljava/lang/String;I)I

    return-void
.end method

.method public setWFD(Z)V
    .locals 1

    .line 344
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "<setWFD> enable:"

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p0}, Lcom/mediatek/powerhalwrapper/PowerHalWrapper;->log(Ljava/lang/String;)V

    const/16 p0, 0x1c

    if-eqz p1, :cond_0

    const p1, 0xfffffff

    .line 346
    invoke-static {p0, p1}, Lcom/mediatek/powerhalwrapper/PowerHalWrapper;->nativeMtkPowerHint(II)I

    goto :goto_0

    :cond_0
    const/4 p1, 0x0

    .line 349
    invoke-static {p0, p1}, Lcom/mediatek/powerhalwrapper/PowerHalWrapper;->nativeMtkPowerHint(II)I

    :goto_0
    return-void
.end method
