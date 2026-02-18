.class public Lcom/mediatek/boostfwk/policy/frame/FramePolicy;
.super Lcom/mediatek/boostfwk/policy/frame/BaseFramePolicy;
.source "FramePolicy.java"


# static fields
.field private static final CHECK_POINT:D = 0.5

.field private static final FRAME_STEP_BASIC:I = -0x3e8

.field public static final MSG_FRAME_BEGIN:I = 0x1

.field public static final MSG_FRAME_END:I = 0x2

.field public static final MSG_NO_DRAW:I = 0x4

.field public static final MSG_STEP_CHECK:I = 0x3

.field public static final MSG_TRAVERSAL_RESUCE_CHECK:I = 0x5

.field private static final NON_FRAME_STEP:I = -0x3e8

.field private static final NON_RENDER_THREAD_TID:I = -0x1

.field private static final NO_DRAW_FRAME_VSYNC_RATIO:D = 0.1

.field private static final PERF_RES_FPS_FBT_RESCUE_SBE_RESCUE:I = 0x203ca00

.field private static final PERF_RES_FPS_FPSGO_STOP_BOOST:I = 0x2004200

.field private static final RECEIVE_VSYNC_TO_INPUT:I = -0x3e7

.field private static final RECUME_FRAME_ID:J = -0x2710L

.field private static isAnimationStepEnd:Z = false

.field private static isNoDraw:Z = true

.field private static isTranversalDraw:Z = false

.field private static isTraversalStepEnd:Z = false

.field private static mAnimAcquiredLock:Z = false

.field private static mFrameIntervalTime:F = 0.0f

.field private static mFrameStep:I = -0x3e8

.field private static mIsDoframeCheck:Z = false

.field private static mLimitVsyncTime:F = 0.0f

.field private static mTranversalAcquiredLock:Z = false

.field private static sInstance:Lcom/mediatek/boostfwk/policy/frame/FramePolicy; = null

.field private static sLock:Ljava/lang/Object; = null

.field private static final sTHREAD_NAME:Ljava/lang/String; = "FramePolicy"


# instance fields
.field private final SBE_RESUCE_MODE_END:I

.field private final SBE_RESUCE_MODE_START:I

.field private final SBE_RESUCE_MODE_TO_QUEUE_END:I

.field private curFrameRescueMode:I

.field private frameStartTime:J

.field private mFrameId:J

.field private mRenderThreadTid:I

.field private underRescue:Z


# direct methods
.method static constructor <clinit>()V
    .locals 1

    .line 66
    new-instance v0, Ljava/lang/Object;

    invoke-direct {v0}, Ljava/lang/Object;-><init>()V

    sput-object v0, Lcom/mediatek/boostfwk/policy/frame/FramePolicy;->sLock:Ljava/lang/Object;

    return-void
.end method

.method public constructor <init>()V
    .locals 4

    .line 150
    invoke-direct {p0}, Lcom/mediatek/boostfwk/policy/frame/BaseFramePolicy;-><init>()V

    const/4 v0, 0x0

    .line 80
    iput v0, p0, Lcom/mediatek/boostfwk/policy/frame/FramePolicy;->SBE_RESUCE_MODE_END:I

    const/4 v1, 0x1

    .line 81
    iput v1, p0, Lcom/mediatek/boostfwk/policy/frame/FramePolicy;->SBE_RESUCE_MODE_START:I

    const/4 v1, 0x2

    .line 82
    iput v1, p0, Lcom/mediatek/boostfwk/policy/frame/FramePolicy;->SBE_RESUCE_MODE_TO_QUEUE_END:I

    .line 83
    iput v1, p0, Lcom/mediatek/boostfwk/policy/frame/FramePolicy;->curFrameRescueMode:I

    const-wide/16 v1, -0x1

    .line 85
    iput-wide v1, p0, Lcom/mediatek/boostfwk/policy/frame/FramePolicy;->mFrameId:J

    const/4 v3, -0x1

    .line 99
    iput v3, p0, Lcom/mediatek/boostfwk/policy/frame/FramePolicy;->mRenderThreadTid:I

    .line 100
    iput-wide v1, p0, Lcom/mediatek/boostfwk/policy/frame/FramePolicy;->frameStartTime:J

    .line 101
    iput-boolean v0, p0, Lcom/mediatek/boostfwk/policy/frame/FramePolicy;->underRescue:Z

    return-void
.end method

.method private doFrameHintInternel(ZJ)V
    .locals 3

    const/4 v0, 0x5

    const/4 v1, 0x3

    if-eqz p1, :cond_1

    .line 238
    iput-wide p2, p0, Lcom/mediatek/boostfwk/policy/frame/FramePolicy;->mFrameId:J

    .line 240
    sget p1, Lcom/mediatek/boostfwk/policy/frame/FramePolicy;->mLimitVsyncTime:F

    const/4 p2, 0x0

    cmpl-float p1, p1, p2

    if-eqz p1, :cond_2

    .line 241
    invoke-static {}, Lcom/mediatek/boostfwk/utils/Config;->isBoostFwkLogEnable()Z

    move-result p1

    if-eqz p1, :cond_0

    const-string p1, "FramePolicy"

    const-string p2, "scrolling!! try check animation and draw state."

    .line 242
    invoke-static {p1, p2}, Lcom/mediatek/boostfwk/utils/LogUtil;->mLogd(Ljava/lang/String;Ljava/lang/String;)V

    .line 244
    :cond_0
    iget-object p1, p0, Lcom/mediatek/boostfwk/policy/frame/BaseFramePolicy;->mWorkerHandler:Lcom/mediatek/boostfwk/policy/frame/BaseFramePolicy$WorkerHandler;

    .line 245
    invoke-virtual {p1, v1}, Landroid/os/Handler;->obtainMessage(I)Landroid/os/Message;

    move-result-object p2

    sget p3, Lcom/mediatek/boostfwk/policy/frame/FramePolicy;->mLimitVsyncTime:F

    float-to-long v1, p3

    .line 244
    invoke-virtual {p1, p2, v1, v2}, Landroid/os/Handler;->sendMessageDelayed(Landroid/os/Message;J)Z

    .line 247
    iget-object p0, p0, Lcom/mediatek/boostfwk/policy/frame/BaseFramePolicy;->mWorkerHandler:Lcom/mediatek/boostfwk/policy/frame/BaseFramePolicy$WorkerHandler;

    .line 248
    invoke-virtual {p0, v0}, Landroid/os/Handler;->obtainMessage(I)Landroid/os/Message;

    move-result-object p1

    sget p2, Lcom/mediatek/boostfwk/policy/frame/FramePolicy;->mFrameIntervalTime:F

    float-to-long p2, p2

    .line 247
    invoke-virtual {p0, p1, p2, p3}, Landroid/os/Handler;->sendMessageDelayed(Landroid/os/Message;J)Z

    goto :goto_0

    .line 252
    :cond_1
    iget-object p1, p0, Lcom/mediatek/boostfwk/policy/frame/BaseFramePolicy;->mWorkerHandler:Lcom/mediatek/boostfwk/policy/frame/BaseFramePolicy$WorkerHandler;

    const/4 p2, 0x0

    invoke-virtual {p1, v1, p2}, Landroid/os/Handler;->removeMessages(ILjava/lang/Object;)V

    .line 253
    iget-object p1, p0, Lcom/mediatek/boostfwk/policy/frame/BaseFramePolicy;->mWorkerHandler:Lcom/mediatek/boostfwk/policy/frame/BaseFramePolicy$WorkerHandler;

    invoke-virtual {p1, v0, p2}, Landroid/os/Handler;->removeMessages(ILjava/lang/Object;)V

    const/4 p1, 0x0

    .line 254
    sput-boolean p1, Lcom/mediatek/boostfwk/policy/frame/FramePolicy;->mAnimAcquiredLock:Z

    .line 255
    sput-boolean p1, Lcom/mediatek/boostfwk/policy/frame/FramePolicy;->mTranversalAcquiredLock:Z

    .line 256
    sput-boolean p1, Lcom/mediatek/boostfwk/policy/frame/FramePolicy;->isTranversalDraw:Z

    .line 257
    sput-boolean p1, Lcom/mediatek/boostfwk/policy/frame/FramePolicy;->isAnimationStepEnd:Z

    const/16 p2, -0x3e8

    .line 258
    sput p2, Lcom/mediatek/boostfwk/policy/frame/FramePolicy;->mFrameStep:I

    const-wide/16 p2, -0x1

    .line 259
    iput-wide p2, p0, Lcom/mediatek/boostfwk/policy/frame/FramePolicy;->mFrameId:J

    .line 260
    iput-boolean p1, p0, Lcom/mediatek/boostfwk/policy/frame/FramePolicy;->underRescue:Z

    .line 261
    sput-boolean p1, Lcom/mediatek/boostfwk/policy/frame/FramePolicy;->isTraversalStepEnd:Z

    :cond_2
    :goto_0
    return-void
.end method

.method private doFrameStepHintInternel(I)V
    .locals 6

    .line 266
    sget-boolean v0, Lcom/mediatek/boostfwk/policy/frame/FramePolicy;->mIsDoframeCheck:Z

    if-nez v0, :cond_0

    const/16 v0, -0x3e8

    if-ne p1, v0, :cond_0

    return-void

    :cond_0
    const-string v0, "FramePolicy"

    const/16 v1, -0x3e7

    const/4 v2, 0x1

    if-eq p1, v1, :cond_1

    const/4 v3, 0x3

    if-eq p1, v3, :cond_4

    if-eqz p1, :cond_1

    if-eq p1, v2, :cond_1

    goto :goto_0

    .line 274
    :cond_1
    sget-boolean v3, Lcom/mediatek/boostfwk/policy/frame/FramePolicy;->isAnimationStepEnd:Z

    if-nez v3, :cond_2

    const v3, 0x203ca00

    .line 275
    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    const-string v5, "animation end, curStep="

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v4

    invoke-direct {p0, v3, v4}, Lcom/mediatek/boostfwk/policy/frame/FramePolicy;->powerHintForRender(ILjava/lang/String;)V

    .line 278
    :cond_2
    sget-boolean v3, Lcom/mediatek/boostfwk/policy/frame/FramePolicy;->mAnimAcquiredLock:Z

    if-nez v3, :cond_4

    if-eq p1, v1, :cond_4

    .line 279
    invoke-static {}, Lcom/mediatek/boostfwk/utils/Config;->isBoostFwkLogEnable()Z

    move-result p1

    if-eqz p1, :cond_3

    const-string p1, "input/anim hint drop, enable rescue!"

    .line 280
    invoke-static {v0, p1}, Lcom/mediatek/boostfwk/utils/LogUtil;->mLogd(Ljava/lang/String;Ljava/lang/String;)V

    .line 282
    :cond_3
    invoke-direct {p0, v2}, Lcom/mediatek/boostfwk/policy/frame/FramePolicy;->frameDraw(Z)V

    .line 283
    sput-boolean v2, Lcom/mediatek/boostfwk/policy/frame/FramePolicy;->mAnimAcquiredLock:Z

    goto :goto_0

    .line 287
    :cond_4
    sget-boolean p1, Lcom/mediatek/boostfwk/policy/frame/FramePolicy;->mTranversalAcquiredLock:Z

    if-eqz p1, :cond_6

    sget-boolean p1, Lcom/mediatek/boostfwk/policy/frame/FramePolicy;->mAnimAcquiredLock:Z

    if-nez p1, :cond_6

    .line 288
    invoke-static {}, Lcom/mediatek/boostfwk/utils/Config;->isBoostFwkLogEnable()Z

    move-result p1

    if-eqz p1, :cond_5

    const-string/jumbo p1, "traversal step, enable rescue!"

    .line 289
    invoke-static {v0, p1}, Lcom/mediatek/boostfwk/utils/LogUtil;->mLogd(Ljava/lang/String;Ljava/lang/String;)V

    .line 291
    :cond_5
    invoke-direct {p0, v2}, Lcom/mediatek/boostfwk/policy/frame/FramePolicy;->frameDraw(Z)V

    const/4 p0, 0x0

    .line 292
    sput-boolean p0, Lcom/mediatek/boostfwk/policy/frame/FramePolicy;->mTranversalAcquiredLock:Z

    .line 293
    sput-boolean v2, Lcom/mediatek/boostfwk/policy/frame/FramePolicy;->mAnimAcquiredLock:Z

    :cond_6
    :goto_0
    return-void
.end method

.method private drawFrameDelayTime()D
    .locals 6

    .line 363
    sget p0, Lcom/mediatek/boostfwk/policy/frame/FramePolicy;->mFrameIntervalTime:F

    const/4 v0, 0x0

    cmpl-float p0, p0, v0

    if-nez p0, :cond_0

    const-wide/high16 v0, -0x4010000000000000L    # -1.0

    return-wide v0

    .line 366
    :cond_0
    invoke-static {}, Lcom/mediatek/boostfwk/info/ScrollState;->getRefreshRate()F

    move-result p0

    .line 367
    sget v0, Lcom/mediatek/boostfwk/policy/frame/FramePolicy;->mFrameIntervalTime:F

    float-to-double v0, v0

    float-to-double v2, p0

    const-wide v4, 0x3fb999999999999aL    # 0.1

    mul-double/2addr v2, v4

    mul-double/2addr v0, v2

    return-wide v0
.end method

.method private frameDraw(Z)V
    .locals 4

    if-eqz p1, :cond_1

    .line 310
    iget-wide v0, p0, Lcom/mediatek/boostfwk/policy/frame/FramePolicy;->mFrameId:J

    const-wide/16 v2, -0x1

    cmp-long v0, v0, v2

    if-nez v0, :cond_1

    .line 311
    sget-boolean p1, Lcom/mediatek/boostfwk/utils/LogUtil;->DEBUG:Z

    if-eqz p1, :cond_0

    .line 312
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "frame clear when rescue. mFrameId = "

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-wide v0, p0, Lcom/mediatek/boostfwk/policy/frame/FramePolicy;->mFrameId:J

    invoke-virtual {p1, v0, v1}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    const-string p1, "FramePolicy"

    invoke-static {p1, p0}, Lcom/mediatek/boostfwk/utils/LogUtil;->mLogd(Ljava/lang/String;Ljava/lang/String;)V

    :cond_0
    return-void

    :cond_1
    const/4 v0, 0x1

    if-eqz p1, :cond_3

    .line 318
    sget-boolean p1, Lcom/mediatek/boostfwk/policy/frame/FramePolicy;->isNoDraw:Z

    if-eqz p1, :cond_2

    .line 319
    sget-boolean p1, Lcom/mediatek/boostfwk/utils/LogUtil;->DEBUG:Z

    if-eqz p1, :cond_2

    .line 320
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "Draw, notify FPSGO draw"

    invoke-virtual {p1, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-wide v1, p0, Lcom/mediatek/boostfwk/policy/frame/FramePolicy;->mFrameId:J

    invoke-virtual {p1, v1, v2}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-static {p1}, Lcom/mediatek/boostfwk/utils/LogUtil;->trace(Ljava/lang/String;)V

    .line 323
    :cond_2
    iget-object p0, p0, Lcom/mediatek/boostfwk/policy/frame/BaseFramePolicy;->mWorkerHandler:Lcom/mediatek/boostfwk/policy/frame/BaseFramePolicy$WorkerHandler;

    const/4 p1, 0x4

    const/4 v1, 0x0

    invoke-virtual {p0, p1, v1}, Landroid/os/Handler;->removeMessages(ILjava/lang/Object;)V

    const/4 p0, 0x0

    .line 324
    sput-boolean p0, Lcom/mediatek/boostfwk/policy/frame/FramePolicy;->isNoDraw:Z

    .line 325
    sput-boolean v0, Lcom/mediatek/boostfwk/policy/frame/FramePolicy;->isTranversalDraw:Z

    goto :goto_0

    :cond_3
    const p1, 0x2004200

    const-string v1, "STOP: No draw"

    .line 327
    invoke-direct {p0, p1, v1}, Lcom/mediatek/boostfwk/policy/frame/FramePolicy;->powerHintForRender(ILjava/lang/String;)V

    .line 328
    sput-boolean v0, Lcom/mediatek/boostfwk/policy/frame/FramePolicy;->isNoDraw:Z

    :goto_0
    return-void
.end method

.method public static getInstance()Lcom/mediatek/boostfwk/policy/frame/FramePolicy;
    .locals 2

    .line 139
    sget-object v0, Lcom/mediatek/boostfwk/policy/frame/FramePolicy;->sInstance:Lcom/mediatek/boostfwk/policy/frame/FramePolicy;

    if-nez v0, :cond_1

    .line 140
    sget-object v0, Lcom/mediatek/boostfwk/policy/frame/FramePolicy;->sLock:Ljava/lang/Object;

    monitor-enter v0

    .line 141
    :try_start_0
    sget-object v1, Lcom/mediatek/boostfwk/policy/frame/FramePolicy;->sInstance:Lcom/mediatek/boostfwk/policy/frame/FramePolicy;

    if-nez v1, :cond_0

    .line 142
    new-instance v1, Lcom/mediatek/boostfwk/policy/frame/FramePolicy;

    invoke-direct {v1}, Lcom/mediatek/boostfwk/policy/frame/FramePolicy;-><init>()V

    sput-object v1, Lcom/mediatek/boostfwk/policy/frame/FramePolicy;->sInstance:Lcom/mediatek/boostfwk/policy/frame/FramePolicy;

    .line 144
    :cond_0
    monitor-exit v0

    goto :goto_0

    :catchall_0
    move-exception v1

    monitor-exit v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    throw v1

    .line 146
    :cond_1
    :goto_0
    sget-object v0, Lcom/mediatek/boostfwk/policy/frame/FramePolicy;->sInstance:Lcom/mediatek/boostfwk/policy/frame/FramePolicy;

    return-object v0
.end method

.method private getRenderThreadTid()I
    .locals 2

    .line 372
    iget v0, p0, Lcom/mediatek/boostfwk/policy/frame/FramePolicy;->mRenderThreadTid:I

    const/4 v1, -0x1

    if-ne v0, v1, :cond_0

    .line 373
    invoke-static {}, Lcom/mediatek/boostfwk/info/ActivityInfo;->getInstance()Lcom/mediatek/boostfwk/info/ActivityInfo;

    move-result-object v0

    invoke-virtual {v0}, Lcom/mediatek/boostfwk/info/ActivityInfo;->getRenderThreadTid()I

    move-result v0

    iput v0, p0, Lcom/mediatek/boostfwk/policy/frame/FramePolicy;->mRenderThreadTid:I

    .line 375
    :cond_0
    iget p0, p0, Lcom/mediatek/boostfwk/policy/frame/FramePolicy;->mRenderThreadTid:I

    return p0
.end method

.method private perfLockAcquire([I)V
    .locals 3

    .line 379
    iget-object v0, p0, Lcom/mediatek/boostfwk/policy/frame/BaseFramePolicy;->mPowerHalService:Lcom/mediatek/powerhalmgr/PowerHalMgr;

    if-eqz v0, :cond_0

    .line 380
    iget v1, p0, Lcom/mediatek/boostfwk/policy/frame/BaseFramePolicy;->mPowerHandle:I

    const/4 v2, 0x0

    invoke-virtual {v0, v1, v2, p1}, Lcom/mediatek/powerhalmgr/PowerHalMgr;->perfLockAcquire(II[I)I

    move-result p1

    iput p1, p0, Lcom/mediatek/boostfwk/policy/frame/BaseFramePolicy;->mPowerHandle:I

    .line 381
    iget-object p0, p0, Lcom/mediatek/boostfwk/policy/frame/BaseFramePolicy;->mPowerHalService:Lcom/mediatek/powerhalmgr/PowerHalMgr;

    invoke-virtual {p0, p1}, Lcom/mediatek/powerhalmgr/PowerHalMgr;->perfLockRelease(I)V

    :cond_0
    return-void
.end method

.method private powerHintForRender(ILjava/lang/String;)V
    .locals 8

    .line 333
    invoke-direct {p0}, Lcom/mediatek/boostfwk/policy/frame/FramePolicy;->getRenderThreadTid()I

    move-result v1

    .line 334
    sget-boolean v0, Lcom/mediatek/boostfwk/utils/LogUtil;->DEBUG:Z

    const-wide/16 v6, 0x8

    if-eqz v0, :cond_0

    .line 335
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "hint for ["

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p2, "] render id = "

    invoke-virtual {v0, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-static {v6, v7, p2}, Landroid/os/Trace;->traceBegin(JLjava/lang/String;)V

    :cond_0
    const p2, 0x2004200

    const/4 v0, 0x1

    if-eq p1, p2, :cond_2

    const p2, 0x203ca00

    if-eq p1, p2, :cond_1

    .line 352
    invoke-static {}, Lcom/mediatek/boostfwk/utils/Config;->isBoostFwkLogEnable()Z

    move-result p0

    if-eqz p0, :cond_3

    .line 353
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0}, Ljava/lang/StringBuilder;-><init>()V

    const-string p2, "not surpport for cmd = "

    invoke-virtual {p0, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    const-string p1, "FramePolicy"

    invoke-static {p1, p0}, Lcom/mediatek/boostfwk/utils/LogUtil;->mLogd(Ljava/lang/String;Ljava/lang/String;)V

    goto :goto_0

    .line 340
    :cond_1
    iput-boolean v0, p0, Lcom/mediatek/boostfwk/policy/frame/FramePolicy;->underRescue:Z

    .line 342
    iget-object v0, p0, Lcom/mediatek/boostfwk/policy/frame/BaseFramePolicy;->mPowerHalWrap:Lcom/mediatek/powerhalwrapper/PowerHalWrapper;

    iget v2, p0, Lcom/mediatek/boostfwk/policy/frame/FramePolicy;->curFrameRescueMode:I

    const/16 v3, 0x32

    const-wide/16 v4, -0x2710

    invoke-virtual/range {v0 .. v5}, Lcom/mediatek/powerhalwrapper/PowerHalWrapper;->mtkNotifySbeRescue(IIIJ)V

    goto :goto_0

    :cond_2
    const/4 p2, 0x2

    new-array p2, p2, [I

    const/4 v2, 0x0

    aput p1, p2, v2

    aput v1, p2, v0

    .line 348
    invoke-direct {p0, p2}, Lcom/mediatek/boostfwk/policy/frame/FramePolicy;->perfLockAcquire([I)V

    .line 349
    invoke-static {}, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->getInstance()Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;

    move-result-object p0

    invoke-virtual {p0, v0}, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->disableMTKScrollingPolicy(Z)V

    .line 357
    :cond_3
    :goto_0
    invoke-static {}, Lcom/mediatek/boostfwk/utils/Config;->isBoostFwkLogEnable()Z

    move-result p0

    if-eqz p0, :cond_4

    .line 358
    invoke-static {v6, v7}, Landroid/os/Trace;->traceEnd(J)V

    :cond_4
    return-void
.end method

.method private setFrameStep(I)V
    .locals 0

    .line 231
    sget p0, Lcom/mediatek/boostfwk/policy/frame/FramePolicy;->mFrameStep:I

    if-le p1, p0, :cond_0

    .line 232
    sput p1, Lcom/mediatek/boostfwk/policy/frame/FramePolicy;->mFrameStep:I

    :cond_0
    return-void
.end method

.method private traversalRescueChecker()V
    .locals 3

    .line 302
    iget-boolean v0, p0, Lcom/mediatek/boostfwk/policy/frame/FramePolicy;->underRescue:Z

    if-nez v0, :cond_0

    sget v0, Lcom/mediatek/boostfwk/policy/frame/FramePolicy;->mFrameStep:I

    const/4 v1, 0x3

    if-ne v0, v1, :cond_0

    sget-boolean v0, Lcom/mediatek/boostfwk/policy/frame/FramePolicy;->isTraversalStepEnd:Z

    if-nez v0, :cond_0

    const v0, 0x203ca00

    .line 304
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string/jumbo v2, "traversal over vsync, curStep="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    sget v2, Lcom/mediatek/boostfwk/policy/frame/FramePolicy;->mFrameStep:I

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-direct {p0, v0, v1}, Lcom/mediatek/boostfwk/policy/frame/FramePolicy;->powerHintForRender(ILjava/lang/String;)V

    :cond_0
    return-void
.end method


# virtual methods
.method public doFrameHint(ZJ)V
    .locals 3

    .line 175
    iget-boolean v0, p0, Lcom/mediatek/boostfwk/policy/frame/BaseFramePolicy;->mCoreServiceReady:Z

    if-nez v0, :cond_0

    return-void

    .line 179
    :cond_0
    invoke-static {}, Lcom/mediatek/boostfwk/utils/Config;->isBoostFwkLogEnable()Z

    move-result v0

    if-eqz v0, :cond_1

    .line 180
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string/jumbo v1, "vsync is begin = "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    const-string v1, "FramePolicy"

    invoke-static {v1, v0}, Lcom/mediatek/boostfwk/utils/LogUtil;->mLogd(Ljava/lang/String;Ljava/lang/String;)V

    .line 183
    :cond_1
    sput-boolean p1, Lcom/mediatek/boostfwk/policy/frame/FramePolicy;->mIsDoframeCheck:Z

    if-eqz p1, :cond_2

    const/16 p1, -0x3e7

    .line 185
    invoke-direct {p0, p1}, Lcom/mediatek/boostfwk/policy/frame/FramePolicy;->setFrameStep(I)V

    .line 186
    iget-object p0, p0, Lcom/mediatek/boostfwk/policy/frame/BaseFramePolicy;->mWorkerHandler:Lcom/mediatek/boostfwk/policy/frame/BaseFramePolicy$WorkerHandler;

    const/4 p1, 0x1

    .line 187
    invoke-static {p2, p3}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object p2

    invoke-virtual {p0, p1, p2}, Landroid/os/Handler;->obtainMessage(ILjava/lang/Object;)Landroid/os/Message;

    move-result-object p1

    .line 186
    invoke-virtual {p0, p1}, Landroid/os/Handler;->sendMessage(Landroid/os/Message;)Z

    goto :goto_0

    .line 189
    :cond_2
    sget-boolean p1, Lcom/mediatek/boostfwk/policy/frame/FramePolicy;->isNoDraw:Z

    if-nez p1, :cond_3

    sget-boolean p1, Lcom/mediatek/boostfwk/policy/frame/FramePolicy;->isTranversalDraw:Z

    if-eqz p1, :cond_3

    .line 190
    iget-object p1, p0, Lcom/mediatek/boostfwk/policy/frame/BaseFramePolicy;->mWorkerHandler:Lcom/mediatek/boostfwk/policy/frame/BaseFramePolicy$WorkerHandler;

    const/4 v0, 0x4

    const/4 v1, 0x0

    .line 191
    invoke-virtual {p1, v0, v1}, Landroid/os/Handler;->obtainMessage(ILjava/lang/Object;)Landroid/os/Message;

    move-result-object v0

    invoke-direct {p0}, Lcom/mediatek/boostfwk/policy/frame/FramePolicy;->drawFrameDelayTime()D

    move-result-wide v1

    double-to-long v1, v1

    .line 190
    invoke-virtual {p1, v0, v1, v2}, Landroid/os/Handler;->sendMessageDelayed(Landroid/os/Message;J)Z

    .line 193
    :cond_3
    iget-object p0, p0, Lcom/mediatek/boostfwk/policy/frame/BaseFramePolicy;->mWorkerHandler:Lcom/mediatek/boostfwk/policy/frame/BaseFramePolicy$WorkerHandler;

    const/4 p1, 0x2

    .line 194
    invoke-static {p2, p3}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object p2

    invoke-virtual {p0, p1, p2}, Landroid/os/Handler;->obtainMessage(ILjava/lang/Object;)Landroid/os/Message;

    move-result-object p1

    .line 193
    invoke-virtual {p0, p1}, Landroid/os/Handler;->sendMessage(Landroid/os/Message;)Z

    .line 196
    sget-boolean p0, Lcom/mediatek/boostfwk/policy/frame/BaseFramePolicy;->mDisableFrameRescue:Z

    if-eqz p0, :cond_4

    const/4 p0, 0x0

    .line 197
    sput-boolean p0, Lcom/mediatek/boostfwk/policy/frame/BaseFramePolicy;->mListenFrameHint:Z

    :cond_4
    :goto_0
    return-void
.end method

.method public doFrameStepHint(ZI)V
    .locals 2

    .line 208
    iget-boolean v0, p0, Lcom/mediatek/boostfwk/policy/frame/BaseFramePolicy;->mCoreServiceReady:Z

    if-nez v0, :cond_0

    return-void

    :cond_0
    const/4 v0, 0x3

    const/4 v1, 0x1

    if-eqz p1, :cond_1

    .line 213
    invoke-direct {p0, p2}, Lcom/mediatek/boostfwk/policy/frame/FramePolicy;->setFrameStep(I)V

    if-ne p2, v0, :cond_3

    .line 215
    sput-boolean v1, Lcom/mediatek/boostfwk/policy/frame/FramePolicy;->mTranversalAcquiredLock:Z

    .line 216
    iget-object p0, p0, Lcom/mediatek/boostfwk/policy/frame/BaseFramePolicy;->mWorkerHandler:Lcom/mediatek/boostfwk/policy/frame/BaseFramePolicy$WorkerHandler;

    const/4 p1, 0x0

    .line 217
    invoke-virtual {p0, v0, p1}, Landroid/os/Handler;->obtainMessage(ILjava/lang/Object;)Landroid/os/Message;

    move-result-object p1

    .line 216
    invoke-virtual {p0, p1}, Landroid/os/Handler;->sendMessage(Landroid/os/Message;)Z

    goto :goto_0

    :cond_1
    if-ne p2, v1, :cond_2

    .line 221
    sput-boolean v1, Lcom/mediatek/boostfwk/policy/frame/FramePolicy;->isAnimationStepEnd:Z

    :cond_2
    if-ne p2, v0, :cond_3

    .line 224
    sput-boolean v1, Lcom/mediatek/boostfwk/policy/frame/FramePolicy;->isTraversalStepEnd:Z

    :cond_3
    :goto_0
    return-void
.end method

.method protected handleMessageInternal(Landroid/os/Message;)V
    .locals 4

    .line 117
    iget v0, p1, Landroid/os/Message;->what:I

    const/4 v1, 0x1

    if-eq v0, v1, :cond_4

    const/4 v1, 0x2

    const/4 v2, 0x0

    if-eq v0, v1, :cond_3

    const/4 p1, 0x3

    if-eq v0, p1, :cond_2

    const/4 p1, 0x4

    if-eq v0, p1, :cond_1

    const/4 p1, 0x5

    if-eq v0, p1, :cond_0

    goto :goto_0

    .line 131
    :cond_0
    invoke-direct {p0}, Lcom/mediatek/boostfwk/policy/frame/FramePolicy;->traversalRescueChecker()V

    goto :goto_0

    .line 128
    :cond_1
    invoke-direct {p0, v2}, Lcom/mediatek/boostfwk/policy/frame/FramePolicy;->frameDraw(Z)V

    goto :goto_0

    .line 125
    :cond_2
    sget p1, Lcom/mediatek/boostfwk/policy/frame/FramePolicy;->mFrameStep:I

    invoke-direct {p0, p1}, Lcom/mediatek/boostfwk/policy/frame/FramePolicy;->doFrameStepHintInternel(I)V

    goto :goto_0

    .line 122
    :cond_3
    iget-object p1, p1, Landroid/os/Message;->obj:Ljava/lang/Object;

    check-cast p1, Ljava/lang/Long;

    invoke-virtual {p1}, Ljava/lang/Long;->longValue()J

    move-result-wide v0

    invoke-direct {p0, v2, v0, v1}, Lcom/mediatek/boostfwk/policy/frame/FramePolicy;->doFrameHintInternel(ZJ)V

    goto :goto_0

    .line 119
    :cond_4
    iget-object p1, p1, Landroid/os/Message;->obj:Ljava/lang/Object;

    check-cast p1, Ljava/lang/Long;

    invoke-virtual {p1}, Ljava/lang/Long;->longValue()J

    move-result-wide v2

    invoke-direct {p0, v1, v2, v3}, Lcom/mediatek/boostfwk/policy/frame/FramePolicy;->doFrameHintInternel(ZJ)V

    :goto_0
    return-void
.end method

.method public initLimitTime(F)Z
    .locals 4

    const/4 p0, 0x0

    cmpl-float v0, p1, p0

    if-lez v0, :cond_0

    .line 158
    sget v0, Lcom/mediatek/boostfwk/policy/frame/FramePolicy;->mFrameIntervalTime:F

    cmpl-float v0, p1, v0

    if-eqz v0, :cond_0

    .line 159
    sput p1, Lcom/mediatek/boostfwk/policy/frame/FramePolicy;->mFrameIntervalTime:F

    float-to-double v0, p1

    const-wide/high16 v2, 0x3fe0000000000000L    # 0.5

    mul-double/2addr v0, v2

    sub-double/2addr v0, v2

    double-to-float p1, v0

    .line 166
    sput p1, Lcom/mediatek/boostfwk/policy/frame/FramePolicy;->mLimitVsyncTime:F

    .line 170
    :cond_0
    sget-boolean p1, Lcom/mediatek/boostfwk/policy/frame/BaseFramePolicy;->mListenFrameHint:Z

    if-eqz p1, :cond_1

    sget p1, Lcom/mediatek/boostfwk/policy/frame/FramePolicy;->mFrameIntervalTime:F

    cmpl-float p0, p1, p0

    if-eqz p0, :cond_1

    const/4 p0, 0x1

    goto :goto_0

    :cond_1
    const/4 p0, 0x0

    :goto_0
    return p0
.end method
