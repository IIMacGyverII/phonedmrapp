.class public Lcom/mediatek/boostfwk/policy/touch/TouchPolicy;
.super Ljava/lang/Object;
.source "TouchPolicy.java"

# interfaces
.implements Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify$TouchEventListener;
.implements Lcom/mediatek/boostfwk/info/ScrollState$ScrollStateListener;
.implements Lcom/mediatek/boostfwk/info/ActivityInfo$ActivityChangeListener;


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/mediatek/boostfwk/policy/touch/TouchPolicy$WorkerHandler;
    }
.end annotation


# static fields
.field private static final ENABLE_TOUCH_POLICY_FOR_ALL:Z = false

.field private static final LOCK:Ljava/lang/Object;

.field public static final LONG_TIME_PAGES:Ljava/util/Map;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/Map<",
            "Ljava/lang/String;",
            "Ljava/lang/Long;",
            ">;"
        }
    .end annotation
.end field

.field private static final PERF_RES_SCHED_SBB_ACTIVE_RATIO:I = 0x1444600

.field private static final PERF_RES_SCHED_SBB_GROUP_SET:I = 0x1444200

.field private static final PERF_RES_SCHED_SBB_GROUP_UNSET:I = 0x1444300

.field private static final PERF_RES_SCHED_UCLAMP_MIN_TA:I = 0x1408300

.field private static final TAG:Ljava/lang/String; = "TouchPolicy"

.field private static final THREAD_NAME:Ljava/lang/String; = "TouchPolicy"

.field private static mInstance:Lcom/mediatek/boostfwk/policy/touch/TouchPolicy; = null

.field private static final sDEFAULT_ACTIVE_RATIO:I = 0x46

.field private static final sDEFAULT_UCLAMP_TA:I = 0x19


# instance fields
.field private mActivityInfo:Lcom/mediatek/boostfwk/info/ActivityInfo;

.field private mActivityStr:Ljava/lang/String;

.field private mIsLongTimePages:Z

.field private mIsSBBTrigger:Z

.field private mLastTouchDownTime:J

.field private mLastTriggerTime:J

.field private mPid:I

.field private mPowerHalService:Lcom/mediatek/powerhalmgr/PowerHalMgr;

.field private mPowerHandle:I

.field private mReleaseDuration:I

.field private final mResetBufferTimeMS:J

.field private mWorkerHandler:Lcom/mediatek/boostfwk/policy/touch/TouchPolicy$WorkerHandler;

.field private mWorkerThread:Landroid/os/HandlerThread;


# direct methods
.method static bridge synthetic -$$Nest$menableSBBInternal(Lcom/mediatek/boostfwk/policy/touch/TouchPolicy;I)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/mediatek/boostfwk/policy/touch/TouchPolicy;->enableSBBInternal(I)V

    return-void
.end method

.method static bridge synthetic -$$Nest$mresetSBBInternal(Lcom/mediatek/boostfwk/policy/touch/TouchPolicy;Z)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/mediatek/boostfwk/policy/touch/TouchPolicy;->resetSBBInternal(Z)V

    return-void
.end method

.method static constructor <clinit>()V
    .locals 1

    .line 88
    new-instance v0, Lcom/mediatek/boostfwk/policy/touch/TouchPolicy$1;

    invoke-direct {v0}, Lcom/mediatek/boostfwk/policy/touch/TouchPolicy$1;-><init>()V

    sput-object v0, Lcom/mediatek/boostfwk/policy/touch/TouchPolicy;->LONG_TIME_PAGES:Ljava/util/Map;

    const/4 v0, 0x0

    .line 94
    sput-object v0, Lcom/mediatek/boostfwk/policy/touch/TouchPolicy;->mInstance:Lcom/mediatek/boostfwk/policy/touch/TouchPolicy;

    .line 95
    new-instance v0, Ljava/lang/Object;

    invoke-direct {v0}, Ljava/lang/Object;-><init>()V

    sput-object v0, Lcom/mediatek/boostfwk/policy/touch/TouchPolicy;->LOCK:Ljava/lang/Object;

    return-void
.end method

.method private constructor <init>()V
    .locals 3

    .line 108
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    const/4 v0, 0x0

    .line 66
    iput-object v0, p0, Lcom/mediatek/boostfwk/policy/touch/TouchPolicy;->mWorkerThread:Landroid/os/HandlerThread;

    .line 67
    iput-object v0, p0, Lcom/mediatek/boostfwk/policy/touch/TouchPolicy;->mWorkerHandler:Lcom/mediatek/boostfwk/policy/touch/TouchPolicy$WorkerHandler;

    .line 69
    iput-object v0, p0, Lcom/mediatek/boostfwk/policy/touch/TouchPolicy;->mActivityInfo:Lcom/mediatek/boostfwk/info/ActivityInfo;

    const/4 v0, 0x0

    .line 70
    iput-boolean v0, p0, Lcom/mediatek/boostfwk/policy/touch/TouchPolicy;->mIsSBBTrigger:Z

    .line 71
    invoke-static {}, Lcom/mediatek/powerhalmgr/PowerHalMgrFactory;->getInstance()Lcom/mediatek/powerhalmgr/PowerHalMgrFactory;

    move-result-object v1

    invoke-virtual {v1}, Lcom/mediatek/powerhalmgr/PowerHalMgrFactory;->makePowerHalMgr()Lcom/mediatek/powerhalmgr/PowerHalMgr;

    move-result-object v1

    iput-object v1, p0, Lcom/mediatek/boostfwk/policy/touch/TouchPolicy;->mPowerHalService:Lcom/mediatek/powerhalmgr/PowerHalMgr;

    .line 72
    iput v0, p0, Lcom/mediatek/boostfwk/policy/touch/TouchPolicy;->mPowerHandle:I

    const-string v1, ""

    .line 73
    iput-object v1, p0, Lcom/mediatek/boostfwk/policy/touch/TouchPolicy;->mActivityStr:Ljava/lang/String;

    const-wide/16 v1, -0x1

    .line 74
    iput-wide v1, p0, Lcom/mediatek/boostfwk/policy/touch/TouchPolicy;->mLastTriggerTime:J

    .line 75
    iput-wide v1, p0, Lcom/mediatek/boostfwk/policy/touch/TouchPolicy;->mLastTouchDownTime:J

    const/4 v1, -0x1

    .line 76
    iput v1, p0, Lcom/mediatek/boostfwk/policy/touch/TouchPolicy;->mReleaseDuration:I

    const-wide/16 v1, 0x64

    .line 77
    iput-wide v1, p0, Lcom/mediatek/boostfwk/policy/touch/TouchPolicy;->mResetBufferTimeMS:J

    const/high16 v1, -0x80000000

    .line 79
    iput v1, p0, Lcom/mediatek/boostfwk/policy/touch/TouchPolicy;->mPid:I

    .line 87
    iput-boolean v0, p0, Lcom/mediatek/boostfwk/policy/touch/TouchPolicy;->mIsLongTimePages:Z

    .line 109
    invoke-direct {p0}, Lcom/mediatek/boostfwk/policy/touch/TouchPolicy;->initThread()V

    .line 110
    invoke-static {}, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->getInstance()Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;

    move-result-object v0

    invoke-virtual {v0, p0}, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->registerTouchEventListener(Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify$TouchEventListener;)V

    .line 111
    invoke-static {p0}, Lcom/mediatek/boostfwk/info/ScrollState;->registerScrollStateListener(Lcom/mediatek/boostfwk/info/ScrollState$ScrollStateListener;)V

    return-void
.end method

.method private acquirePowerhal([II)V
    .locals 2

    .line 304
    iget-object v0, p0, Lcom/mediatek/boostfwk/policy/touch/TouchPolicy;->mPowerHalService:Lcom/mediatek/powerhalmgr/PowerHalMgr;

    if-eqz v0, :cond_0

    .line 305
    iget v1, p0, Lcom/mediatek/boostfwk/policy/touch/TouchPolicy;->mPowerHandle:I

    invoke-virtual {v0, v1, p2, p1}, Lcom/mediatek/powerhalmgr/PowerHalMgr;->perfLockAcquire(II[I)I

    move-result p1

    iput p1, p0, Lcom/mediatek/boostfwk/policy/touch/TouchPolicy;->mPowerHandle:I

    :cond_0
    return-void
.end method

.method private enableSBB()V
    .locals 3

    .line 191
    iget v0, p0, Lcom/mediatek/boostfwk/policy/touch/TouchPolicy;->mPid:I

    const/high16 v1, -0x80000000

    if-ne v0, v1, :cond_0

    .line 192
    invoke-static {}, Landroid/os/Process;->myPid()I

    move-result v0

    iput v0, p0, Lcom/mediatek/boostfwk/policy/touch/TouchPolicy;->mPid:I

    .line 194
    :cond_0
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v0

    iput-wide v0, p0, Lcom/mediatek/boostfwk/policy/touch/TouchPolicy;->mLastTriggerTime:J

    .line 195
    iget-object v0, p0, Lcom/mediatek/boostfwk/policy/touch/TouchPolicy;->mWorkerHandler:Lcom/mediatek/boostfwk/policy/touch/TouchPolicy$WorkerHandler;

    const/4 v1, 0x0

    const/4 v2, 0x1

    invoke-virtual {v0, v2, v1}, Landroid/os/Handler;->removeMessages(ILjava/lang/Object;)V

    .line 196
    iget-object p0, p0, Lcom/mediatek/boostfwk/policy/touch/TouchPolicy;->mWorkerHandler:Lcom/mediatek/boostfwk/policy/touch/TouchPolicy$WorkerHandler;

    invoke-virtual {p0, v2}, Landroid/os/Handler;->sendEmptyMessage(I)Z

    return-void
.end method

.method private enableSBBInternal(I)V
    .locals 9

    .line 200
    iget v0, p0, Lcom/mediatek/boostfwk/policy/touch/TouchPolicy;->mReleaseDuration:I

    if-gez v0, :cond_0

    .line 201
    invoke-direct {p0}, Lcom/mediatek/boostfwk/policy/touch/TouchPolicy;->generateNewDuration()J

    move-result-wide v0

    long-to-int v0, v0

    iput v0, p0, Lcom/mediatek/boostfwk/policy/touch/TouchPolicy;->mReleaseDuration:I

    :cond_0
    if-gtz p1, :cond_1

    .line 203
    iget p1, p0, Lcom/mediatek/boostfwk/policy/touch/TouchPolicy;->mReleaseDuration:I

    :cond_1
    const/4 v0, 0x1

    .line 204
    iput-boolean v0, p0, Lcom/mediatek/boostfwk/policy/touch/TouchPolicy;->mIsSBBTrigger:Z

    .line 205
    sget-boolean v1, Lcom/mediatek/boostfwk/utils/LogUtil;->DEBUG:Z

    if-eqz v1, :cond_2

    .line 206
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "enableSBB for "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v2, p0, Lcom/mediatek/boostfwk/policy/touch/TouchPolicy;->mActivityStr:Ljava/lang/String;

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v2, " with duration="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v2, p0, Lcom/mediatek/boostfwk/policy/touch/TouchPolicy;->mReleaseDuration:I

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v2, " pid="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v2, p0, Lcom/mediatek/boostfwk/policy/touch/TouchPolicy;->mPid:I

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    const-string v2, "TouchPolicy"

    invoke-static {v2, v1}, Lcom/mediatek/boostfwk/utils/LogUtil;->traceAndMLogd(Ljava/lang/String;Ljava/lang/String;)V

    .line 210
    :cond_2
    iget-boolean v1, p0, Lcom/mediatek/boostfwk/policy/touch/TouchPolicy;->mIsLongTimePages:Z

    const/16 v2, 0x46

    const/4 v3, 0x3

    const v4, 0x1444600

    const v5, 0x1444200

    const/4 v6, 0x0

    const/4 v7, 0x4

    const/4 v8, 0x2

    if-eqz v1, :cond_3

    const/4 v1, 0x6

    new-array v1, v1, [I

    aput v5, v1, v6

    .line 211
    iget v5, p0, Lcom/mediatek/boostfwk/policy/touch/TouchPolicy;->mPid:I

    aput v5, v1, v0

    aput v4, v1, v8

    aput v2, v1, v3

    const v0, 0x1408300

    aput v0, v1, v7

    const/4 v0, 0x5

    const/16 v2, 0x19

    aput v2, v1, v0

    goto :goto_0

    :cond_3
    new-array v1, v7, [I

    aput v5, v1, v6

    .line 215
    iget v5, p0, Lcom/mediatek/boostfwk/policy/touch/TouchPolicy;->mPid:I

    aput v5, v1, v0

    aput v4, v1, v8

    aput v2, v1, v3

    .line 218
    :goto_0
    invoke-direct {p0, v1, p1}, Lcom/mediatek/boostfwk/policy/touch/TouchPolicy;->acquirePowerhal([II)V

    .line 220
    iget-object v0, p0, Lcom/mediatek/boostfwk/policy/touch/TouchPolicy;->mWorkerHandler:Lcom/mediatek/boostfwk/policy/touch/TouchPolicy$WorkerHandler;

    const/4 v1, 0x0

    invoke-virtual {v0, v8, v1}, Landroid/os/Handler;->removeMessages(ILjava/lang/Object;)V

    .line 221
    iget-object p0, p0, Lcom/mediatek/boostfwk/policy/touch/TouchPolicy;->mWorkerHandler:Lcom/mediatek/boostfwk/policy/touch/TouchPolicy$WorkerHandler;

    .line 222
    sget-object v0, Ljava/lang/Boolean;->TRUE:Ljava/lang/Boolean;

    invoke-virtual {p0, v8, v0}, Landroid/os/Handler;->obtainMessage(ILjava/lang/Object;)Landroid/os/Message;

    move-result-object v0

    int-to-long v1, p1

    .line 221
    invoke-virtual {p0, v0, v1, v2}, Landroid/os/Handler;->sendMessageDelayed(Landroid/os/Message;J)Z

    return-void
.end method

.method private generateNewDuration()J
    .locals 5

    .line 226
    invoke-static {}, Lcom/mediatek/boostfwk/utils/Config;->getTouchDuration()I

    move-result v0

    int-to-long v0, v0

    .line 227
    sget-object v2, Lcom/mediatek/boostfwk/policy/touch/TouchPolicy;->LONG_TIME_PAGES:Ljava/util/Map;

    invoke-interface {v2}, Ljava/util/Map;->keySet()Ljava/util/Set;

    move-result-object v2

    .line 228
    invoke-interface {v2}, Ljava/util/Set;->iterator()Ljava/util/Iterator;

    move-result-object v2

    :cond_0
    invoke-interface {v2}, Ljava/util/Iterator;->hasNext()Z

    move-result v3

    if-eqz v3, :cond_1

    invoke-interface {v2}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Ljava/lang/String;

    .line 229
    iget-object v4, p0, Lcom/mediatek/boostfwk/policy/touch/TouchPolicy;->mActivityStr:Ljava/lang/String;

    invoke-virtual {v4, v3}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v4

    if-eqz v4, :cond_0

    .line 230
    sget-object v0, Lcom/mediatek/boostfwk/policy/touch/TouchPolicy;->LONG_TIME_PAGES:Ljava/util/Map;

    invoke-interface {v0, v3}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/lang/Long;

    invoke-virtual {v0}, Ljava/lang/Long;->longValue()J

    move-result-wide v0

    const/4 v2, 0x1

    .line 231
    iput-boolean v2, p0, Lcom/mediatek/boostfwk/policy/touch/TouchPolicy;->mIsLongTimePages:Z

    :cond_1
    return-wide v0
.end method

.method public static getInstance()Lcom/mediatek/boostfwk/policy/touch/TouchPolicy;
    .locals 2

    .line 98
    sget-object v0, Lcom/mediatek/boostfwk/policy/touch/TouchPolicy;->mInstance:Lcom/mediatek/boostfwk/policy/touch/TouchPolicy;

    if-nez v0, :cond_1

    .line 99
    sget-object v0, Lcom/mediatek/boostfwk/policy/touch/TouchPolicy;->LOCK:Ljava/lang/Object;

    monitor-enter v0

    .line 100
    :try_start_0
    sget-object v1, Lcom/mediatek/boostfwk/policy/touch/TouchPolicy;->mInstance:Lcom/mediatek/boostfwk/policy/touch/TouchPolicy;

    if-nez v1, :cond_0

    .line 101
    new-instance v1, Lcom/mediatek/boostfwk/policy/touch/TouchPolicy;

    invoke-direct {v1}, Lcom/mediatek/boostfwk/policy/touch/TouchPolicy;-><init>()V

    sput-object v1, Lcom/mediatek/boostfwk/policy/touch/TouchPolicy;->mInstance:Lcom/mediatek/boostfwk/policy/touch/TouchPolicy;

    .line 103
    :cond_0
    monitor-exit v0

    goto :goto_0

    :catchall_0
    move-exception v1

    monitor-exit v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    throw v1

    .line 105
    :cond_1
    :goto_0
    sget-object v0, Lcom/mediatek/boostfwk/policy/touch/TouchPolicy;->mInstance:Lcom/mediatek/boostfwk/policy/touch/TouchPolicy;

    return-object v0
.end method

.method private initThread()V
    .locals 2

    .line 115
    iget-object v0, p0, Lcom/mediatek/boostfwk/policy/touch/TouchPolicy;->mWorkerThread:Landroid/os/HandlerThread;

    const-string v1, "TouchPolicy"

    if-eqz v0, :cond_0

    invoke-virtual {v0}, Landroid/os/HandlerThread;->isAlive()Z

    move-result v0

    if-eqz v0, :cond_0

    iget-object v0, p0, Lcom/mediatek/boostfwk/policy/touch/TouchPolicy;->mWorkerHandler:Lcom/mediatek/boostfwk/policy/touch/TouchPolicy$WorkerHandler;

    if-eqz v0, :cond_0

    .line 117
    invoke-static {}, Lcom/mediatek/boostfwk/utils/Config;->isBoostFwkLogEnable()Z

    move-result p0

    if-eqz p0, :cond_2

    const-string p0, "re-init"

    .line 118
    invoke-static {v1, p0}, Lcom/mediatek/boostfwk/utils/LogUtil;->mLogi(Ljava/lang/String;Ljava/lang/String;)V

    goto :goto_0

    .line 121
    :cond_0
    new-instance v0, Landroid/os/HandlerThread;

    invoke-direct {v0, v1}, Landroid/os/HandlerThread;-><init>(Ljava/lang/String;)V

    iput-object v0, p0, Lcom/mediatek/boostfwk/policy/touch/TouchPolicy;->mWorkerThread:Landroid/os/HandlerThread;

    .line 122
    invoke-virtual {v0}, Landroid/os/HandlerThread;->start()V

    .line 123
    iget-object v0, p0, Lcom/mediatek/boostfwk/policy/touch/TouchPolicy;->mWorkerThread:Landroid/os/HandlerThread;

    invoke-virtual {v0}, Landroid/os/HandlerThread;->getLooper()Landroid/os/Looper;

    move-result-object v0

    if-nez v0, :cond_1

    const-string p0, "Thread looper is null"

    .line 125
    invoke-static {v1, p0}, Lcom/mediatek/boostfwk/utils/LogUtil;->mLogd(Ljava/lang/String;Ljava/lang/String;)V

    goto :goto_0

    .line 127
    :cond_1
    new-instance v1, Lcom/mediatek/boostfwk/policy/touch/TouchPolicy$WorkerHandler;

    invoke-direct {v1, p0, v0}, Lcom/mediatek/boostfwk/policy/touch/TouchPolicy$WorkerHandler;-><init>(Lcom/mediatek/boostfwk/policy/touch/TouchPolicy;Landroid/os/Looper;)V

    iput-object v1, p0, Lcom/mediatek/boostfwk/policy/touch/TouchPolicy;->mWorkerHandler:Lcom/mediatek/boostfwk/policy/touch/TouchPolicy$WorkerHandler;

    :cond_2
    :goto_0
    return-void
.end method

.method private releasePowerHandle()V
    .locals 4

    .line 311
    iget-object v0, p0, Lcom/mediatek/boostfwk/policy/touch/TouchPolicy;->mPowerHalService:Lcom/mediatek/powerhalmgr/PowerHalMgr;

    if-eqz v0, :cond_0

    iget v0, p0, Lcom/mediatek/boostfwk/policy/touch/TouchPolicy;->mPid:I

    const/high16 v1, -0x80000000

    if-eq v0, v1, :cond_0

    const/4 v1, 0x2

    new-array v1, v1, [I

    const/4 v2, 0x0

    const v3, 0x1444300

    aput v3, v1, v2

    const/4 v2, 0x1

    aput v0, v1, v2

    .line 313
    invoke-direct {p0, v1, v2}, Lcom/mediatek/boostfwk/policy/touch/TouchPolicy;->acquirePowerhal([II)V

    .line 314
    iget-object v0, p0, Lcom/mediatek/boostfwk/policy/touch/TouchPolicy;->mPowerHalService:Lcom/mediatek/powerhalmgr/PowerHalMgr;

    iget p0, p0, Lcom/mediatek/boostfwk/policy/touch/TouchPolicy;->mPowerHandle:I

    invoke-virtual {v0, p0}, Lcom/mediatek/powerhalmgr/PowerHalMgr;->perfLockRelease(I)V

    :cond_0
    return-void
.end method

.method private resetSBB()V
    .locals 3

    .line 271
    iget-boolean v0, p0, Lcom/mediatek/boostfwk/policy/touch/TouchPolicy;->mIsSBBTrigger:Z

    if-eqz v0, :cond_0

    .line 272
    iget-object v0, p0, Lcom/mediatek/boostfwk/policy/touch/TouchPolicy;->mWorkerHandler:Lcom/mediatek/boostfwk/policy/touch/TouchPolicy$WorkerHandler;

    const/4 v1, 0x0

    const/4 v2, 0x2

    invoke-virtual {v0, v2, v1}, Landroid/os/Handler;->removeMessages(ILjava/lang/Object;)V

    .line 273
    iget-object p0, p0, Lcom/mediatek/boostfwk/policy/touch/TouchPolicy;->mWorkerHandler:Lcom/mediatek/boostfwk/policy/touch/TouchPolicy$WorkerHandler;

    .line 274
    invoke-virtual {p0, v2}, Landroid/os/Handler;->obtainMessage(I)Landroid/os/Message;

    move-result-object v0

    .line 273
    invoke-virtual {p0, v0}, Landroid/os/Handler;->sendMessageAtFrontOfQueue(Landroid/os/Message;)Z

    :cond_0
    return-void
.end method

.method private resetSBBInternal(Z)V
    .locals 9

    const-string v0, "TouchPolicy"

    const-wide/16 v1, 0x0

    if-eqz p1, :cond_1

    .line 241
    iget-boolean p1, p0, Lcom/mediatek/boostfwk/policy/touch/TouchPolicy;->mIsLongTimePages:Z

    if-nez p1, :cond_0

    iget-wide v3, p0, Lcom/mediatek/boostfwk/policy/touch/TouchPolicy;->mLastTouchDownTime:J

    cmp-long p1, v3, v1

    if-lez p1, :cond_1

    .line 243
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v3

    iget-wide v5, p0, Lcom/mediatek/boostfwk/policy/touch/TouchPolicy;->mLastTouchDownTime:J

    sub-long/2addr v3, v5

    iget p1, p0, Lcom/mediatek/boostfwk/policy/touch/TouchPolicy;->mReleaseDuration:I

    int-to-long v5, p1

    const-wide/16 v7, 0x64

    sub-long/2addr v5, v7

    cmp-long p1, v3, v5

    if-gez p1, :cond_1

    move-wide v1, v3

    :cond_0
    const-string p1, "continueSBB"

    .line 245
    invoke-static {v0, p1}, Lcom/mediatek/boostfwk/utils/LogUtil;->traceAndMLogd(Ljava/lang/String;Ljava/lang/String;)V

    .line 246
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v3

    iput-wide v3, p0, Lcom/mediatek/boostfwk/policy/touch/TouchPolicy;->mLastTriggerTime:J

    .line 247
    iget p1, p0, Lcom/mediatek/boostfwk/policy/touch/TouchPolicy;->mReleaseDuration:I

    int-to-long v3, p1

    sub-long/2addr v3, v1

    long-to-int p1, v3

    invoke-direct {p0, p1}, Lcom/mediatek/boostfwk/policy/touch/TouchPolicy;->enableSBBInternal(I)V

    goto :goto_0

    .line 249
    :cond_1
    sget-boolean p1, Lcom/mediatek/boostfwk/utils/LogUtil;->DEBUG:Z

    if-eqz p1, :cond_2

    .line 250
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "resetSBB for "

    invoke-virtual {p1, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v3, p0, Lcom/mediatek/boostfwk/policy/touch/TouchPolicy;->mActivityStr:Ljava/lang/String;

    invoke-virtual {p1, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-static {v0, p1}, Lcom/mediatek/boostfwk/utils/LogUtil;->traceAndMLogd(Ljava/lang/String;Ljava/lang/String;)V

    .line 252
    :cond_2
    invoke-direct {p0}, Lcom/mediatek/boostfwk/policy/touch/TouchPolicy;->releasePowerHandle()V

    .line 253
    iput-wide v1, p0, Lcom/mediatek/boostfwk/policy/touch/TouchPolicy;->mLastTriggerTime:J

    const/4 p1, 0x0

    .line 254
    iput-boolean p1, p0, Lcom/mediatek/boostfwk/policy/touch/TouchPolicy;->mIsSBBTrigger:Z

    .line 255
    iput-boolean p1, p0, Lcom/mediatek/boostfwk/policy/touch/TouchPolicy;->mIsLongTimePages:Z

    :goto_0
    return-void
.end method


# virtual methods
.method public onAllActivityPaused(Landroid/content/Context;)V
    .locals 2

    .line 296
    sget-boolean v0, Lcom/mediatek/boostfwk/utils/LogUtil;->DEBUG:Z

    if-eqz v0, :cond_0

    .line 297
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "onAllActivityPause for "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string p1, " "

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object p1, p0, Lcom/mediatek/boostfwk/policy/touch/TouchPolicy;->mActivityStr:Ljava/lang/String;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    const-string v0, "TouchPolicy"

    invoke-static {v0, p1}, Lcom/mediatek/boostfwk/utils/LogUtil;->traceAndMLogd(Ljava/lang/String;Ljava/lang/String;)V

    .line 299
    :cond_0
    invoke-direct {p0}, Lcom/mediatek/boostfwk/policy/touch/TouchPolicy;->resetSBB()V

    const-string p1, ""

    .line 300
    iput-object p1, p0, Lcom/mediatek/boostfwk/policy/touch/TouchPolicy;->mActivityStr:Ljava/lang/String;

    return-void
.end method

.method public onChange(Landroid/content/Context;)V
    .locals 2

    .line 280
    sget-boolean v0, Lcom/mediatek/boostfwk/utils/LogUtil;->DEBUG:Z

    if-eqz v0, :cond_0

    .line 281
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "onChange for "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string v1, " "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/mediatek/boostfwk/policy/touch/TouchPolicy;->mActivityStr:Ljava/lang/String;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    const-string v1, "TouchPolicy"

    invoke-static {v1, v0}, Lcom/mediatek/boostfwk/utils/LogUtil;->traceAndMLogd(Ljava/lang/String;Ljava/lang/String;)V

    :cond_0
    if-eqz p1, :cond_1

    .line 283
    invoke-virtual {p1}, Ljava/lang/Object;->toString()Ljava/lang/String;

    move-result-object v0

    iget-object v1, p0, Lcom/mediatek/boostfwk/policy/touch/TouchPolicy;->mActivityStr:Ljava/lang/String;

    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-nez v0, :cond_1

    .line 284
    invoke-virtual {p1}, Ljava/lang/Object;->toString()Ljava/lang/String;

    move-result-object p1

    iput-object p1, p0, Lcom/mediatek/boostfwk/policy/touch/TouchPolicy;->mActivityStr:Ljava/lang/String;

    .line 285
    invoke-direct {p0}, Lcom/mediatek/boostfwk/policy/touch/TouchPolicy;->resetSBB()V

    const/4 p1, -0x1

    .line 286
    iput p1, p0, Lcom/mediatek/boostfwk/policy/touch/TouchPolicy;->mReleaseDuration:I

    .line 287
    invoke-direct {p0}, Lcom/mediatek/boostfwk/policy/touch/TouchPolicy;->generateNewDuration()J

    .line 288
    iget-boolean p1, p0, Lcom/mediatek/boostfwk/policy/touch/TouchPolicy;->mIsLongTimePages:Z

    if-eqz p1, :cond_1

    .line 289
    invoke-direct {p0}, Lcom/mediatek/boostfwk/policy/touch/TouchPolicy;->enableSBB()V

    :cond_1
    return-void
.end method

.method public onScroll(Z)V
    .locals 2

    if-eqz p1, :cond_1

    .line 261
    iget-boolean v0, p0, Lcom/mediatek/boostfwk/policy/touch/TouchPolicy;->mIsLongTimePages:Z

    if-nez v0, :cond_1

    .line 262
    sget-boolean v0, Lcom/mediatek/boostfwk/utils/LogUtil;->DEBUG:Z

    if-eqz v0, :cond_0

    .line 263
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "onScroll for "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/mediatek/boostfwk/policy/touch/TouchPolicy;->mActivityStr:Ljava/lang/String;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, " with scrolling="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    const-string v0, "TouchPolicy"

    invoke-static {v0, p1}, Lcom/mediatek/boostfwk/utils/LogUtil;->traceAndMLogd(Ljava/lang/String;Ljava/lang/String;)V

    .line 266
    :cond_0
    invoke-direct {p0}, Lcom/mediatek/boostfwk/policy/touch/TouchPolicy;->resetSBB()V

    :cond_1
    return-void
.end method

.method public onTouchEvent(Landroid/view/MotionEvent;)V
    .locals 4

    .line 157
    invoke-static {}, Lcom/mediatek/boostfwk/utils/Config;->isEnableTouchPolicy()Z

    move-result v0

    if-eqz v0, :cond_5

    .line 158
    invoke-static {}, Lcom/mediatek/boostfwk/utils/Config;->getBoostFwkVersion()I

    move-result v0

    const/4 v1, 0x1

    if-gt v0, v1, :cond_0

    goto :goto_0

    .line 162
    :cond_0
    invoke-static {}, Lcom/mediatek/boostfwk/info/ScrollState;->getRefreshRate()F

    move-result v0

    const/high16 v1, 0x42740000    # 61.0f

    cmpg-float v0, v0, v1

    if-lez v0, :cond_5

    .line 163
    invoke-virtual {p1}, Landroid/view/MotionEvent;->getAction()I

    move-result p1

    if-nez p1, :cond_5

    invoke-static {}, Lcom/mediatek/boostfwk/utils/Util;->isMainThread()Z

    move-result p1

    if-nez p1, :cond_1

    goto :goto_0

    .line 167
    :cond_1
    iget-object p1, p0, Lcom/mediatek/boostfwk/policy/touch/TouchPolicy;->mActivityInfo:Lcom/mediatek/boostfwk/info/ActivityInfo;

    if-nez p1, :cond_2

    .line 168
    invoke-static {}, Lcom/mediatek/boostfwk/info/ActivityInfo;->getInstance()Lcom/mediatek/boostfwk/info/ActivityInfo;

    move-result-object p1

    iput-object p1, p0, Lcom/mediatek/boostfwk/policy/touch/TouchPolicy;->mActivityInfo:Lcom/mediatek/boostfwk/info/ActivityInfo;

    .line 169
    invoke-virtual {p1, p0}, Lcom/mediatek/boostfwk/info/ActivityInfo;->registerActivityListener(Lcom/mediatek/boostfwk/info/ActivityInfo$ActivityChangeListener;)V

    .line 173
    :cond_2
    iget-object p1, p0, Lcom/mediatek/boostfwk/policy/touch/TouchPolicy;->mActivityInfo:Lcom/mediatek/boostfwk/info/ActivityInfo;

    invoke-virtual {p1}, Lcom/mediatek/boostfwk/info/ActivityInfo;->getPageType()I

    .line 175
    iget-object p1, p0, Lcom/mediatek/boostfwk/policy/touch/TouchPolicy;->mActivityInfo:Lcom/mediatek/boostfwk/info/ActivityInfo;

    const/16 v0, 0x80

    invoke-virtual {p1, v0}, Lcom/mediatek/boostfwk/info/ActivityInfo;->isPage(I)Z

    iget-object p1, p0, Lcom/mediatek/boostfwk/policy/touch/TouchPolicy;->mActivityInfo:Lcom/mediatek/boostfwk/info/ActivityInfo;

    .line 176
    invoke-virtual {p1}, Lcom/mediatek/boostfwk/info/ActivityInfo;->isSpecialPageDesign()Z

    move-result p1

    if-eqz p1, :cond_5

    iget-boolean p1, p0, Lcom/mediatek/boostfwk/policy/touch/TouchPolicy;->mIsLongTimePages:Z

    if-nez p1, :cond_5

    .line 178
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v0

    iget-wide v2, p0, Lcom/mediatek/boostfwk/policy/touch/TouchPolicy;->mLastTriggerTime:J

    sub-long/2addr v0, v2

    .line 179
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v2

    iput-wide v2, p0, Lcom/mediatek/boostfwk/policy/touch/TouchPolicy;->mLastTouchDownTime:J

    .line 180
    iget p1, p0, Lcom/mediatek/boostfwk/policy/touch/TouchPolicy;->mReleaseDuration:I

    int-to-long v2, p1

    cmp-long p1, v0, v2

    if-gez p1, :cond_4

    .line 181
    sget-boolean p0, Lcom/mediatek/boostfwk/utils/LogUtil;->DEBUG:Z

    if-eqz p0, :cond_3

    .line 182
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0}, Ljava/lang/StringBuilder;-><init>()V

    const-string p1, "onTouchEvent for return"

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, v0, v1}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    const-string p1, "TouchPolicy"

    invoke-static {p1, p0}, Lcom/mediatek/boostfwk/utils/LogUtil;->traceAndMLogd(Ljava/lang/String;Ljava/lang/String;)V

    :cond_3
    return-void

    .line 186
    :cond_4
    invoke-direct {p0}, Lcom/mediatek/boostfwk/policy/touch/TouchPolicy;->enableSBB()V

    :cond_5
    :goto_0
    return-void
.end method
