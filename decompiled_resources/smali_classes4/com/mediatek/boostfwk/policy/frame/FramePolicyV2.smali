.class public Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;
.super Lcom/mediatek/boostfwk/policy/frame/BaseFramePolicy;
.source "FramePolicyV2.java"

# interfaces
.implements Lcom/mediatek/boostfwk/info/ScrollState$RefreshRateChangedListener;


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2$DisplayEventReceiverImpl;
    }
.end annotation


# static fields
.field private static final CHECK_POINT:D = 0.5

.field private static final CHECK_TIME_OFFSET_THRESHOLD_NS:J = 0x7a120L

.field private static final DEFAULT_FRAME_ID:J = -0x80000000L

.field private static final DEFAULT_FRAME_TIME:J = -0x1L

.field private static final ENBALE_FRAME_RESCUE:Z

.field private static final FRAME_STEP_BASIC:I = -0x1

.field private static final FRAME_STEP_DEFAULT:I = -0x1

.field private static final FRAME_STEP_DO_FRAME_ANIMATION:I = 0x3

.field private static final FRAME_STEP_DO_FRAME_INPUT:I = 0x2

.field private static final FRAME_STEP_DO_FRAME_TRAVERSAL:I = 0x4

.field private static final FRAME_STEP_VSYNC_FOR_APP_TO_INPUT:I = 0x1

.field private static final FRAME_STEP_VSYNC_FOR_SBE_TO_APP_VSYNC:I = 0x0

.field private static final LOCK:Ljava/lang/Object;

.field private static final MAX_WAITING_FRAME_COUNT:I = 0x5

.field public static final MSG_DELAY_STOP_HWUI_HINT:I = 0x9

.field public static final MSG_FRAME_BEGIN:I = 0x1

.field public static final MSG_FRAME_END:I = 0x2

.field public static final MSG_NO_DRAW:I = 0x4

.field public static final MSG_REQUEST_VSYNC:I = 0x8

.field public static final MSG_RESCUE_HALF_VSYNC_CHECK:I = 0x3

.field public static final MSG_RESCUE_TIME_OUT:I = 0x6

.field public static final MSG_RESUCE_ONE_VSYNC_CHECK:I = 0x5

.field public static final MSG_UPDATE_RESCUE_FRAME_ID:I = 0x7

.field private static final NANOS_PER_MS:J = 0xf4240L

.field private static final NON_RENDER_THREAD_TID:I = -0x1

.field private static final NO_DRAW_FRAME_VSYNC_RATIO:D = 0.1

.field private static final PERF_RES_FPS_FBT_RESCUE_SBE_RESCUE:I = 0x203ca00

.field private static final PERF_RES_FPS_FPSGO_STOP_BOOST:I = 0x2004200

.field private static final PERF_RES_UX_SBE_RESCUE_ENHANS:I = 0x3004300

.field private static final PREFETCHER_FRAME_ID:J = -0x1L

.field private static final RESCUE_COUNT_DOWN_THRESHOLD:I = 0x1

.field private static final RESCUE_TO_NEXT_FRAME:Z = true

.field private static mDelayStopHWUIHintTime:J

.field private static mFrameIntervalTime:F

.field private static mFrameStep:I

.field private static mInstance:Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;

.field private static mIsAnimationStepEnd:Z

.field private static mIsScrolling:Z

.field private static mIsTraversalStepEnd:Z

.field private static mLimitVsyncTime:F


# instance fields
.field private final SBE_RESUCE_MODE_END:I

.field private final SBE_RESUCE_MODE_START:I

.field private final SBE_RESUCE_MODE_TO_QUEUE_END:I

.field private mCurFrameId:J

.field private mCurFrameRescueMode:I

.field private mCurFrameStartTimeNanos:J

.field private mDisplayEventReceiver:Landroid/view/DisplayEventReceiver;

.field private mFrameHintMask:I

.field private mHasNextFrame:Z

.field private mLastFrameEndFrameId:J

.field private mRenderThreadTid:I

.field private mRescueDoFrame:Z

.field private mRescueNextFrame:Z

.field private mRescueStrength:I

.field private mRescueStrengthWhenHint:I

.field private mRescueWhenWaitNextVsync:Z

.field private mRescuingFrameId:J

.field private mScrollingFramePrefetcher:Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;

.field private mUnlockPowerHandle:I

.field private mUpdateStrength:Z

.field private mVsyncFrameId:J

.field private mVsyncTimeNanos:J

.field private volatile mWaitNextVsync:Z


# direct methods
.method static bridge synthetic -$$Nest$monVsyncInternal(Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;J)V
    .locals 0

    invoke-direct {p0, p1, p2}, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->onVsyncInternal(J)V

    return-void
.end method

.method static bridge synthetic -$$Nest$sfgetmInstance()Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;
    .locals 1

    sget-object v0, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->mInstance:Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;

    return-object v0
.end method

.method static constructor <clinit>()V
    .locals 2

    .line 73
    invoke-static {}, Lcom/mediatek/boostfwk/utils/Config;->isEnableFrameRescue()Z

    move-result v0

    sput-boolean v0, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->ENBALE_FRAME_RESCUE:Z

    .line 74
    new-instance v0, Ljava/lang/Object;

    invoke-direct {v0}, Ljava/lang/Object;-><init>()V

    sput-object v0, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->LOCK:Ljava/lang/Object;

    const/4 v0, 0x0

    .line 76
    sput-object v0, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->mInstance:Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;

    const/4 v0, 0x0

    .line 113
    sput v0, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->mFrameIntervalTime:F

    .line 114
    sput v0, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->mLimitVsyncTime:F

    const-wide/16 v0, 0x0

    .line 115
    sput-wide v0, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->mDelayStopHWUIHintTime:J

    const/4 v0, -0x1

    .line 116
    sput v0, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->mFrameStep:I

    const/4 v0, 0x0

    .line 117
    sput-boolean v0, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->mIsAnimationStepEnd:Z

    .line 118
    sput-boolean v0, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->mIsTraversalStepEnd:Z

    .line 119
    sput-boolean v0, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->mIsScrolling:Z

    return-void
.end method

.method private constructor <init>()V
    .locals 7

    .line 205
    invoke-direct {p0}, Lcom/mediatek/boostfwk/policy/frame/BaseFramePolicy;-><init>()V

    const/4 v0, 0x0

    .line 100
    iput v0, p0, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->SBE_RESUCE_MODE_END:I

    const/4 v1, 0x1

    .line 101
    iput v1, p0, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->SBE_RESUCE_MODE_START:I

    const/4 v2, 0x2

    .line 102
    iput v2, p0, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->SBE_RESUCE_MODE_TO_QUEUE_END:I

    .line 103
    iput v1, p0, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->mCurFrameRescueMode:I

    const/4 v3, 0x3

    .line 105
    iput v3, p0, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->mFrameHintMask:I

    const/16 v3, 0x32

    .line 107
    iput v3, p0, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->mRescueStrength:I

    .line 108
    iput-boolean v0, p0, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->mUpdateStrength:Z

    const/4 v3, -0x1

    .line 109
    iput v3, p0, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->mRescueStrengthWhenHint:I

    .line 111
    iput v0, p0, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->mUnlockPowerHandle:I

    .line 122
    iput v3, p0, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->mRenderThreadTid:I

    const/4 v3, 0x0

    .line 124
    iput-object v3, p0, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->mDisplayEventReceiver:Landroid/view/DisplayEventReceiver;

    .line 125
    iput-object v3, p0, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->mScrollingFramePrefetcher:Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;

    .line 128
    iput-boolean v0, p0, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->mRescueDoFrame:Z

    .line 129
    iput-boolean v0, p0, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->mRescueNextFrame:Z

    .line 130
    iput-boolean v0, p0, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->mRescueWhenWaitNextVsync:Z

    .line 131
    iput-boolean v0, p0, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->mWaitNextVsync:Z

    .line 132
    iput-boolean v0, p0, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->mHasNextFrame:Z

    const-wide/16 v3, -0x1

    .line 133
    iput-wide v3, p0, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->mCurFrameStartTimeNanos:J

    const-wide/32 v5, -0x80000000

    .line 134
    iput-wide v5, p0, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->mCurFrameId:J

    .line 135
    iput-wide v5, p0, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->mLastFrameEndFrameId:J

    .line 136
    iput-wide v5, p0, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->mRescuingFrameId:J

    .line 139
    iput-wide v5, p0, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->mVsyncFrameId:J

    .line 140
    iput-wide v3, p0, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->mVsyncTimeNanos:J

    .line 206
    invoke-static {}, Lcom/mediatek/boostfwk/utils/Config;->getBoostFwkVersion()I

    move-result v0

    if-gt v0, v2, :cond_0

    .line 207
    iput v1, p0, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->mFrameHintMask:I

    :cond_0
    return-void
.end method

.method private adjustCheckTime(FF)F
    .locals 0

    const p0, 0x49742400    # 1000000.0f

    mul-float/2addr p1, p0

    sub-float/2addr p1, p2

    div-float/2addr p1, p0

    const/4 p0, 0x0

    cmpl-float p2, p1, p0

    if-lez p2, :cond_0

    goto :goto_0

    :cond_0
    move p1, p0

    :goto_0
    return p1
.end method

.method private clearRescueInfo()V
    .locals 2

    const-wide/32 v0, -0x80000000

    .line 581
    iput-wide v0, p0, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->mRescuingFrameId:J

    const/4 v0, 0x0

    .line 582
    iput-boolean v0, p0, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->mRescueWhenWaitNextVsync:Z

    .line 583
    iput-boolean v0, p0, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->mRescueDoFrame:Z

    .line 584
    iput-boolean v0, p0, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->mRescueNextFrame:Z

    .line 585
    iget-object p0, p0, Lcom/mediatek/boostfwk/policy/frame/BaseFramePolicy;->mWorkerHandler:Lcom/mediatek/boostfwk/policy/frame/BaseFramePolicy$WorkerHandler;

    const/4 v0, 0x6

    invoke-virtual {p0, v0}, Landroid/os/Handler;->removeMessages(I)V

    return-void
.end method

.method private dleayStopHwuiHint()V
    .locals 1

    .line 302
    invoke-virtual {p0}, Lcom/mediatek/boostfwk/policy/frame/BaseFramePolicy;->getThreadedRenderer()Landroid/view/ThreadedRenderer;

    move-result-object v0

    if-eqz v0, :cond_0

    .line 304
    iget p0, p0, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->mFrameHintMask:I

    const/4 v0, 0x0

    invoke-static {p0, v0}, Lcom/mediatek/boostfwk/info/ActivityInfo;->updateSBEMask(IZ)I

    move-result p0

    invoke-static {p0}, Landroid/view/ThreadedRenderer;->needFrameCompleteHint(I)V

    :cond_0
    return-void
.end method

.method private doSBERescue(Ljava/lang/String;)V
    .locals 4

    .line 555
    iget-wide v0, p0, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->mCurFrameId:J

    const-wide/32 v2, -0x80000000

    cmp-long v2, v0, v2

    if-nez v2, :cond_0

    .line 557
    sget v2, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->mFrameStep:I

    if-eqz v2, :cond_0

    const-string p0, "FramePolicy"

    const-string p1, "do not rescue beacause frameID=DEFAULT_FRAME_ID"

    .line 558
    invoke-static {p0, p1}, Lcom/mediatek/boostfwk/utils/LogUtil;->traceAndLog(Ljava/lang/String;Ljava/lang/String;)V

    return-void

    .line 561
    :cond_0
    iput-wide v0, p0, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->mRescuingFrameId:J

    .line 562
    iget-boolean v0, p0, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->mUpdateStrength:Z

    if-eqz v0, :cond_1

    const/4 v0, 0x0

    .line 563
    iput-boolean v0, p0, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->mUpdateStrength:Z

    const v0, 0x3004300

    .line 564
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "change to "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v2, p0, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->mRescueStrength:I

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-direct {p0, v0, v1}, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->powerHintForRender(ILjava/lang/String;)V

    :cond_1
    const/4 v0, 0x1

    .line 566
    iput v0, p0, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->mCurFrameRescueMode:I

    const v0, 0x203ca00

    .line 567
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p1, " curStep="

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    sget p1, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->mFrameStep:I

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p1, " mode="

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget p1, p0, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->mCurFrameRescueMode:I

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-direct {p0, v0, p1}, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->powerHintForRender(ILjava/lang/String;)V

    .line 569
    iget-object p1, p0, Lcom/mediatek/boostfwk/policy/frame/BaseFramePolicy;->mWorkerHandler:Lcom/mediatek/boostfwk/policy/frame/BaseFramePolicy$WorkerHandler;

    const/4 v0, 0x6

    .line 570
    invoke-direct {p0}, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->drawFrameDelayTime()D

    move-result-wide v1

    double-to-long v1, v1

    .line 569
    invoke-virtual {p1, v0, v1, v2}, Landroid/os/Handler;->sendEmptyMessageDelayed(IJ)Z

    return-void
.end method

.method private drawFrameDelayTime()D
    .locals 6

    .line 665
    sget p0, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->mFrameIntervalTime:F

    const/4 v0, 0x0

    cmpl-float p0, p0, v0

    if-nez p0, :cond_0

    const-wide/high16 v0, -0x4010000000000000L    # -1.0

    return-wide v0

    .line 668
    :cond_0
    invoke-static {}, Lcom/mediatek/boostfwk/utils/Util;->getRefreshRate()F

    move-result p0

    .line 669
    sget v0, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->mFrameIntervalTime:F

    float-to-double v0, v0

    float-to-double v2, p0

    const-wide v4, 0x3fb999999999999aL    # 0.1

    mul-double/2addr v2, v4

    mul-double/2addr v0, v2

    return-wide v0
.end method

.method private frameDraw(Z)V
    .locals 4

    if-eqz p1, :cond_0

    .line 546
    iget-object p1, p0, Lcom/mediatek/boostfwk/policy/frame/BaseFramePolicy;->mWorkerHandler:Lcom/mediatek/boostfwk/policy/frame/BaseFramePolicy$WorkerHandler;

    const/4 v0, 0x0

    const/4 v1, 0x4

    invoke-virtual {p1, v1, v0}, Landroid/os/Handler;->removeMessages(ILjava/lang/Object;)V

    .line 547
    iget-object p1, p0, Lcom/mediatek/boostfwk/policy/frame/BaseFramePolicy;->mWorkerHandler:Lcom/mediatek/boostfwk/policy/frame/BaseFramePolicy$WorkerHandler;

    .line 548
    invoke-direct {p0}, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->drawFrameDelayTime()D

    move-result-wide v2

    double-to-long v2, v2

    .line 547
    invoke-virtual {p1, v1, v2, v3}, Landroid/os/Handler;->sendEmptyMessageDelayed(IJ)Z

    goto :goto_0

    :cond_0
    const p1, 0x2004200

    const-string v0, "STOP: No draw"

    .line 550
    invoke-direct {p0, p1, v0}, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->powerHintForRender(ILjava/lang/String;)V

    :goto_0
    return-void
.end method

.method public static getInstance()Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;
    .locals 2

    .line 194
    sget-object v0, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->mInstance:Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;

    if-nez v0, :cond_1

    .line 195
    sget-object v0, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->LOCK:Ljava/lang/Object;

    monitor-enter v0

    .line 196
    :try_start_0
    sget-object v1, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->mInstance:Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;

    if-nez v1, :cond_0

    .line 197
    new-instance v1, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;

    invoke-direct {v1}, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;-><init>()V

    sput-object v1, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->mInstance:Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;

    .line 199
    :cond_0
    monitor-exit v0

    goto :goto_0

    :catchall_0
    move-exception v1

    monitor-exit v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    throw v1

    .line 201
    :cond_1
    :goto_0
    sget-object v0, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->mInstance:Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;

    return-object v0
.end method

.method private getRenderThreadTid()I
    .locals 2

    .line 674
    iget v0, p0, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->mRenderThreadTid:I

    const/4 v1, -0x1

    if-ne v0, v1, :cond_0

    .line 675
    invoke-static {}, Lcom/mediatek/boostfwk/info/ActivityInfo;->getInstance()Lcom/mediatek/boostfwk/info/ActivityInfo;

    move-result-object v0

    invoke-virtual {v0}, Lcom/mediatek/boostfwk/info/ActivityInfo;->getRenderThreadTid()I

    move-result v0

    iput v0, p0, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->mRenderThreadTid:I

    .line 677
    :cond_0
    iget p0, p0, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->mRenderThreadTid:I

    return p0
.end method

.method private halfVsyncRescueCheck()V
    .locals 3

    .line 487
    sget-boolean v0, Lcom/mediatek/boostfwk/utils/LogUtil;->DEBUG:Z

    if-eqz v0, :cond_0

    .line 488
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "halfVsyncRescueCheck="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    sget v1, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->mFrameStep:I

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, " frame="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-wide v1, p0, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->mCurFrameId:J

    invoke-virtual {v0, v1, v2}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    const-string v1, "FramePolicy"

    invoke-static {v1, v0}, Lcom/mediatek/boostfwk/utils/LogUtil;->traceBeginAndLog(Ljava/lang/String;Ljava/lang/String;)V

    .line 491
    :cond_0
    sget v0, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->mFrameStep:I

    const/4 v1, 0x1

    if-eqz v0, :cond_2

    if-eq v0, v1, :cond_1

    const/4 v2, 0x2

    if-eq v0, v2, :cond_1

    const/4 v2, 0x3

    if-eq v0, v2, :cond_1

    goto :goto_0

    .line 501
    :cond_1
    sget-boolean v0, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->mIsAnimationStepEnd:Z

    if-nez v0, :cond_3

    .line 502
    iput-boolean v1, p0, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->mRescueDoFrame:Z

    const-string v0, "animation end"

    .line 503
    invoke-direct {p0, v0}, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->doSBERescue(Ljava/lang/String;)V

    goto :goto_0

    .line 493
    :cond_2
    iput-boolean v1, p0, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->mRescueWhenWaitNextVsync:Z

    .line 494
    iget v0, p0, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->mRescueStrength:I

    add-int/lit8 v0, v0, 0xa

    iput v0, p0, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->mRescueStrengthWhenHint:I

    const-string/jumbo v0, "waiting vsync"

    .line 495
    invoke-direct {p0, v0}, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->doSBERescue(Ljava/lang/String;)V

    const/4 v0, -0x1

    .line 496
    iput v0, p0, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->mRescueStrengthWhenHint:I

    .line 509
    :cond_3
    :goto_0
    invoke-static {}, Lcom/mediatek/boostfwk/utils/LogUtil;->traceEnd()V

    return-void
.end method

.method private initialRescueStrengthOnce(F)V
    .locals 3

    .line 589
    iget v0, p0, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->mRescueStrength:I

    const/high16 v1, 0x42820000    # 65.0f

    cmpg-float v1, p1, v1

    const/16 v2, 0x32

    if-gtz v1, :cond_0

    goto :goto_0

    :cond_0
    const/high16 v1, 0x42be0000    # 95.0f

    cmpg-float p1, p1, v1

    if-gez p1, :cond_1

    goto :goto_0

    :cond_1
    move v2, v0

    :goto_0
    if-eq v2, v0, :cond_2

    .line 598
    iput v2, p0, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->mRescueStrength:I

    const/4 p1, 0x1

    .line 599
    iput-boolean p1, p0, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->mUpdateStrength:Z

    :cond_2
    return-void
.end method

.method private mappingStepForDoFrame(I)I
    .locals 1

    if-eqz p1, :cond_2

    const/4 p0, 0x1

    const/4 v0, 0x3

    if-eq p1, p0, :cond_1

    if-eq p1, v0, :cond_0

    const/4 p0, -0x1

    return p0

    :cond_0
    const/4 p0, 0x4

    return p0

    :cond_1
    return v0

    :cond_2
    const/4 p0, 0x2

    return p0
.end method

.method private onDoFrameBegin(J)V
    .locals 2

    .line 257
    sget-boolean v0, Lcom/mediatek/boostfwk/utils/LogUtil;->DEBUG:Z

    if-eqz v0, :cond_0

    .line 258
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "onDoFrameBegin="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1, p2}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/mediatek/boostfwk/utils/LogUtil;->traceBegin(Ljava/lang/String;)V

    .line 261
    :cond_0
    invoke-static {}, Landroid/os/SystemClock;->uptimeNanos()J

    move-result-wide v0

    invoke-direct {p0, p1, p2, v0, v1}, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->updateBasicFrameInfo(JJ)V

    const/4 p1, 0x1

    .line 262
    invoke-direct {p0, p1}, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->setFrameStep(I)V

    const-wide/32 p1, -0x80000000

    .line 263
    iput-wide p1, p0, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->mRescuingFrameId:J

    const/4 p1, 0x0

    .line 264
    iput-boolean p1, p0, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->mRescueDoFrame:Z

    .line 266
    iget-boolean p1, p0, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->mRescueWhenWaitNextVsync:Z

    if-nez p1, :cond_1

    iget-boolean p1, p0, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->mRescueNextFrame:Z

    if-eqz p1, :cond_2

    sget-boolean p1, Lcom/mediatek/boostfwk/policy/frame/BaseFramePolicy;->mDisableFrameRescue:Z

    if-nez p1, :cond_2

    .line 267
    :cond_1
    iget-object p0, p0, Lcom/mediatek/boostfwk/policy/frame/BaseFramePolicy;->mWorkerHandler:Lcom/mediatek/boostfwk/policy/frame/BaseFramePolicy$WorkerHandler;

    const/4 p1, 0x7

    invoke-virtual {p0, p1}, Landroid/os/Handler;->obtainMessage(I)Landroid/os/Message;

    move-result-object p1

    invoke-virtual {p0, p1}, Landroid/os/Handler;->sendMessageAtFrontOfQueue(Landroid/os/Message;)Z

    .line 271
    :cond_2
    invoke-static {}, Lcom/mediatek/boostfwk/utils/LogUtil;->traceEnd()V

    return-void
.end method

.method private onDoFrameEnd()V
    .locals 4

    .line 275
    sget-boolean v0, Lcom/mediatek/boostfwk/utils/LogUtil;->DEBUG:Z

    if-eqz v0, :cond_0

    .line 276
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "onDoFrameEnd="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-wide v1, p0, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->mCurFrameId:J

    invoke-virtual {v0, v1, v2}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/mediatek/boostfwk/utils/LogUtil;->traceBegin(Ljava/lang/String;)V

    :cond_0
    const/4 v0, -0x1

    .line 278
    sput v0, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->mFrameStep:I

    .line 279
    iget-wide v0, p0, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->mCurFrameId:J

    iput-wide v0, p0, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->mLastFrameEndFrameId:J

    const-wide/32 v0, -0x80000000

    const-wide/16 v2, -0x1

    .line 280
    invoke-direct {p0, v0, v1, v2, v3}, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->updateBasicFrameInfo(JJ)V

    .line 282
    iget-object v0, p0, Lcom/mediatek/boostfwk/policy/frame/BaseFramePolicy;->mWorkerHandler:Lcom/mediatek/boostfwk/policy/frame/BaseFramePolicy$WorkerHandler;

    const/4 v1, 0x3

    invoke-virtual {v0, v1}, Landroid/os/Handler;->removeMessages(I)V

    .line 283
    iget-object v0, p0, Lcom/mediatek/boostfwk/policy/frame/BaseFramePolicy;->mWorkerHandler:Lcom/mediatek/boostfwk/policy/frame/BaseFramePolicy$WorkerHandler;

    const/4 v1, 0x5

    invoke-virtual {v0, v1}, Landroid/os/Handler;->removeMessages(I)V

    .line 285
    iget-object v0, p0, Lcom/mediatek/boostfwk/policy/frame/BaseFramePolicy;->mWorkerHandler:Lcom/mediatek/boostfwk/policy/frame/BaseFramePolicy$WorkerHandler;

    const/4 v1, 0x2

    invoke-virtual {v0, v1}, Landroid/os/Handler;->obtainMessage(I)Landroid/os/Message;

    move-result-object v1

    invoke-virtual {v0, v1}, Landroid/os/Handler;->sendMessageAtFrontOfQueue(Landroid/os/Message;)Z

    const/4 v0, 0x0

    .line 287
    iput-boolean v0, p0, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->mWaitNextVsync:Z

    .line 288
    iget-boolean v1, p0, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->mHasNextFrame:Z

    if-eqz v1, :cond_1

    sget-boolean v1, Lcom/mediatek/boostfwk/policy/frame/BaseFramePolicy;->mDisableFrameRescue:Z

    if-nez v1, :cond_1

    .line 289
    invoke-virtual {p0}, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->requestVsync()V

    const/4 v1, 0x1

    .line 290
    sput-boolean v1, Lcom/mediatek/boostfwk/policy/frame/BaseFramePolicy;->mListenFrameHint:Z

    .line 292
    :cond_1
    iput-boolean v0, p0, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->mHasNextFrame:Z

    .line 293
    sget-boolean v1, Lcom/mediatek/boostfwk/policy/frame/BaseFramePolicy;->mDisableFrameRescue:Z

    if-eqz v1, :cond_2

    .line 294
    sput-boolean v0, Lcom/mediatek/boostfwk/policy/frame/BaseFramePolicy;->mListenFrameHint:Z

    .line 295
    iget-object p0, p0, Lcom/mediatek/boostfwk/policy/frame/BaseFramePolicy;->mWorkerHandler:Lcom/mediatek/boostfwk/policy/frame/BaseFramePolicy$WorkerHandler;

    const/16 v0, 0x9

    sget-wide v1, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->mDelayStopHWUIHintTime:J

    invoke-virtual {p0, v0, v1, v2}, Landroid/os/Handler;->sendEmptyMessageDelayed(IJ)Z

    .line 298
    :cond_2
    invoke-static {}, Lcom/mediatek/boostfwk/utils/LogUtil;->traceEnd()V

    return-void
.end method

.method private onDoFrameEndInternal(J)V
    .locals 2

    .line 398
    sget-boolean v0, Lcom/mediatek/boostfwk/utils/LogUtil;->DEBUG:Z

    if-eqz v0, :cond_0

    .line 399
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "onDoFrameEndInternal frameId= "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1, p2}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-static {p1}, Lcom/mediatek/boostfwk/utils/LogUtil;->traceBegin(Ljava/lang/String;)V

    :cond_0
    const/4 p1, 0x0

    .line 401
    sput-boolean p1, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->mIsAnimationStepEnd:Z

    .line 403
    sget-boolean p2, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->mIsTraversalStepEnd:Z

    if-nez p2, :cond_2

    iget-boolean p2, p0, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->mRescueDoFrame:Z

    if-nez p2, :cond_1

    iget-boolean p2, p0, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->mRescueWhenWaitNextVsync:Z

    if-eqz p2, :cond_2

    :cond_1
    const-string p2, "frame end-no draw"

    .line 406
    invoke-direct {p0, p2}, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->shutdownSBERescue(Ljava/lang/String;)V

    .line 409
    :cond_2
    iput-boolean p1, p0, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->mRescueWhenWaitNextVsync:Z

    .line 410
    sput-boolean p1, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->mIsTraversalStepEnd:Z

    .line 412
    invoke-static {}, Lcom/mediatek/boostfwk/utils/LogUtil;->traceEnd()V

    return-void
.end method

.method private onVsyncInternal(J)V
    .locals 2

    .line 427
    iget-boolean v0, p0, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->mWaitNextVsync:Z

    if-nez v0, :cond_1

    .line 428
    sget-boolean p0, Lcom/mediatek/boostfwk/utils/LogUtil;->DEBUG:Z

    if-eqz p0, :cond_0

    const-string/jumbo p0, "this vsync is later than doframe, the doframe is end"

    .line 429
    invoke-static {p0}, Lcom/mediatek/boostfwk/utils/LogUtil;->trace(Ljava/lang/String;)V

    :cond_0
    return-void

    .line 433
    :cond_1
    sget-boolean v0, Lcom/mediatek/boostfwk/utils/LogUtil;->DEBUG:Z

    if-eqz v0, :cond_2

    .line 434
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "onVsyncInternal frameId= "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1, p2}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    const-string v1, " "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    sget v1, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->mFrameStep:I

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/mediatek/boostfwk/utils/LogUtil;->traceBegin(Ljava/lang/String;)V

    .line 436
    :cond_2
    iput-wide p1, p0, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->mVsyncFrameId:J

    .line 437
    invoke-static {}, Landroid/os/SystemClock;->uptimeNanos()J

    move-result-wide p1

    iput-wide p1, p0, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->mVsyncTimeNanos:J

    .line 439
    sget p1, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->mFrameStep:I

    const/4 p2, 0x0

    if-eqz p1, :cond_3

    .line 440
    invoke-direct {p0, p2}, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->setFrameStep(I)V

    .line 441
    invoke-direct {p0}, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->rescueCheck()V

    .line 443
    :cond_3
    iput-boolean p2, p0, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->mWaitNextVsync:Z

    .line 444
    invoke-static {}, Lcom/mediatek/boostfwk/utils/LogUtil;->traceEnd()V

    return-void
.end method

.method private oneVsyncRescueCheck()V
    .locals 4

    .line 513
    iget-boolean v0, p0, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->mRescueDoFrame:Z

    const/4 v1, 0x4

    const/4 v2, 0x1

    if-nez v0, :cond_0

    sget v3, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->mFrameStep:I

    if-ne v3, v1, :cond_0

    sget-boolean v3, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->mIsTraversalStepEnd:Z

    if-nez v3, :cond_0

    .line 515
    iput-boolean v2, p0, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->mRescueDoFrame:Z

    const-string/jumbo v0, "traversal over vsync"

    .line 516
    invoke-direct {p0, v0}, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->doSBERescue(Ljava/lang/String;)V

    .line 517
    iput-boolean v2, p0, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->mRescueNextFrame:Z

    goto :goto_0

    :cond_0
    if-eqz v0, :cond_1

    .line 518
    sget v0, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->mFrameStep:I

    if-gt v0, v1, :cond_1

    const/4 v1, -0x1

    if-le v0, v1, :cond_1

    .line 522
    iput-boolean v2, p0, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->mRescueNextFrame:Z

    .line 524
    :cond_1
    :goto_0
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "oneVsyncRescueCheck mFrameStep="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    sget v1, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->mFrameStep:I

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, " mRescueNextFrame="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-boolean v1, p0, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->mRescueNextFrame:Z

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v1, " mRescueDoFrame="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-boolean v1, p0, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->mRescueDoFrame:Z

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v1, " frameId="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-wide v1, p0, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->mCurFrameId:J

    invoke-virtual {v0, v1, v2}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    const-string v0, "FramePolicy"

    invoke-static {v0, p0}, Lcom/mediatek/boostfwk/utils/LogUtil;->mLogd(Ljava/lang/String;Ljava/lang/String;)V

    return-void
.end method

.method private perfLockAcquire([I)V
    .locals 3

    .line 681
    iget-object v0, p0, Lcom/mediatek/boostfwk/policy/frame/BaseFramePolicy;->mPowerHalService:Lcom/mediatek/powerhalmgr/PowerHalMgr;

    if-eqz v0, :cond_0

    .line 682
    iget v1, p0, Lcom/mediatek/boostfwk/policy/frame/BaseFramePolicy;->mPowerHandle:I

    const/4 v2, 0x0

    invoke-virtual {v0, v1, v2, p1}, Lcom/mediatek/powerhalmgr/PowerHalMgr;->perfLockAcquire(II[I)I

    move-result p1

    iput p1, p0, Lcom/mediatek/boostfwk/policy/frame/BaseFramePolicy;->mPowerHandle:I

    .line 683
    iget-object p0, p0, Lcom/mediatek/boostfwk/policy/frame/BaseFramePolicy;->mPowerHalService:Lcom/mediatek/powerhalmgr/PowerHalMgr;

    invoke-virtual {p0, p1}, Lcom/mediatek/powerhalmgr/PowerHalMgr;->perfLockRelease(I)V

    :cond_0
    return-void
.end method

.method private perfLockAcquireUnlock([I)V
    .locals 3

    .line 688
    iget-object v0, p0, Lcom/mediatek/boostfwk/policy/frame/BaseFramePolicy;->mPowerHalService:Lcom/mediatek/powerhalmgr/PowerHalMgr;

    if-eqz v0, :cond_0

    .line 689
    iget v1, p0, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->mUnlockPowerHandle:I

    const/4 v2, 0x0

    invoke-virtual {v0, v1, v2, p1}, Lcom/mediatek/powerhalmgr/PowerHalMgr;->perfLockAcquire(II[I)I

    move-result p1

    iput p1, p0, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->mUnlockPowerHandle:I

    :cond_0
    return-void
.end method

.method private powerHintForRender(ILjava/lang/String;)V
    .locals 10

    .line 610
    invoke-direct {p0}, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->getRenderThreadTid()I

    move-result v1

    const-string v0, "FramePolicy"

    const/high16 v2, -0x80000000

    if-ne v1, v2, :cond_1

    .line 612
    invoke-direct {p0}, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->clearRescueInfo()V

    .line 613
    sget-boolean p1, Lcom/mediatek/boostfwk/utils/LogUtil;->DEBUG:Z

    if-eqz p1, :cond_0

    .line 614
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    iget-wide v2, p0, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->mCurFrameId:J

    invoke-virtual {p1, v2, v3}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    const-string p0, "cancel rescue: "

    invoke-virtual {p1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {v0, p0}, Lcom/mediatek/boostfwk/utils/LogUtil;->traceAndLog(Ljava/lang/String;Ljava/lang/String;)V

    :cond_0
    return-void

    .line 618
    :cond_1
    sget-boolean v2, Lcom/mediatek/boostfwk/utils/LogUtil;->DEBUG:Z

    if-eqz v2, :cond_2

    .line 619
    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "hint for ["

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p2, "] renderId="

    invoke-virtual {v3, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p2, " frameId="

    invoke-virtual {v3, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-wide v4, p0, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->mRescuingFrameId:J

    invoke-virtual {v3, v4, v5}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    const-string p2, " strength="

    invoke-virtual {v3, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget p2, p0, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->mRescueStrengthWhenHint:I

    invoke-virtual {v3, p2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-static {v0, p2}, Lcom/mediatek/boostfwk/utils/LogUtil;->traceBeginAndMLogd(Ljava/lang/String;Ljava/lang/String;)V

    :cond_2
    const p2, 0x2004200

    const/4 v3, 0x0

    const/4 v4, 0x2

    const/4 v5, 0x1

    if-eq p1, p2, :cond_7

    const p2, 0x203ca00

    if-eq p1, p2, :cond_4

    const p2, 0x3004300

    if-eq p1, p2, :cond_3

    if-eqz v2, :cond_8

    .line 657
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0}, Ljava/lang/StringBuilder;-><init>()V

    const-string p2, "not surpport for cmd = "

    invoke-virtual {p0, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {v0, p0}, Lcom/mediatek/boostfwk/utils/LogUtil;->mLogd(Ljava/lang/String;Ljava/lang/String;)V

    goto/16 :goto_1

    :cond_3
    new-array p1, v4, [I

    aput p2, p1, v3

    .line 647
    iget p2, p0, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->mRescueStrength:I

    aput p2, p1, v5

    .line 648
    invoke-direct {p0, p1}, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->perfLockAcquireUnlock([I)V

    goto :goto_1

    .line 624
    :cond_4
    iget-wide p1, p0, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->mRescuingFrameId:J

    const-wide/32 v6, -0x80000000

    cmp-long v0, p1, v6

    if-eqz v0, :cond_5

    const-wide/16 v6, -0x1

    cmp-long v0, p1, v6

    if-nez v0, :cond_5

    .line 625
    iget-wide v8, p0, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->mCurFrameId:J

    cmp-long v0, v8, v6

    if-eqz v0, :cond_5

    iget-wide v6, p0, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->mLastFrameEndFrameId:J

    cmp-long v0, p1, v6

    if-gtz v0, :cond_5

    iget v0, p0, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->mCurFrameRescueMode:I

    if-ne v0, v5, :cond_5

    .line 633
    invoke-direct {p0}, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->clearRescueInfo()V

    if-eqz v2, :cond_8

    .line 635
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string p2, "do not rescue frameEndFrameId="

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-wide v0, p0, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->mLastFrameEndFrameId:J

    invoke-virtual {p1, v0, v1}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p0}, Lcom/mediatek/boostfwk/utils/LogUtil;->trace(Ljava/lang/String;)V

    goto :goto_1

    .line 639
    :cond_5
    invoke-static {}, Lcom/mediatek/boostfwk/utils/Config;->getBoostFwkVersion()I

    move-result v0

    if-le v0, v4, :cond_6

    .line 640
    iget v0, p0, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->mRescueStrengthWhenHint:I

    goto :goto_0

    :cond_6
    const/16 v0, 0x32

    :goto_0
    move v3, v0

    .line 642
    iget-object v0, p0, Lcom/mediatek/boostfwk/policy/frame/BaseFramePolicy;->mPowerHalWrap:Lcom/mediatek/powerhalwrapper/PowerHalWrapper;

    iget v2, p0, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->mCurFrameRescueMode:I

    move-wide v4, p1

    invoke-virtual/range {v0 .. v5}, Lcom/mediatek/powerhalwrapper/PowerHalWrapper;->mtkNotifySbeRescue(IIIJ)V

    goto :goto_1

    :cond_7
    new-array p2, v4, [I

    aput p1, p2, v3

    aput v1, p2, v5

    .line 652
    invoke-direct {p0, p2}, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->perfLockAcquire([I)V

    .line 653
    invoke-static {}, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->getInstance()Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;

    move-result-object p0

    invoke-virtual {p0, v5}, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->disableMTKScrollingPolicy(Z)V

    .line 661
    :cond_8
    :goto_1
    invoke-static {}, Lcom/mediatek/boostfwk/utils/LogUtil;->traceEnd()V

    return-void
.end method

.method private requestVsyncInternal()V
    .locals 3

    .line 416
    sget-boolean v0, Lcom/mediatek/boostfwk/utils/LogUtil;->DEBUG:Z

    if-eqz v0, :cond_0

    .line 417
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "requestVsyncInternal frameId= "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-wide v1, p0, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->mCurFrameId:J

    invoke-virtual {v0, v1, v2}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/mediatek/boostfwk/utils/LogUtil;->traceBegin(Ljava/lang/String;)V

    .line 419
    :cond_0
    iget-object v0, p0, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->mDisplayEventReceiver:Landroid/view/DisplayEventReceiver;

    if-eqz v0, :cond_1

    .line 420
    invoke-virtual {v0}, Landroid/view/DisplayEventReceiver;->scheduleVsync()V

    const/4 v0, 0x1

    .line 421
    iput-boolean v0, p0, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->mWaitNextVsync:Z

    .line 423
    :cond_1
    invoke-static {}, Lcom/mediatek/boostfwk/utils/LogUtil;->traceEnd()V

    return-void
.end method

.method private rescueCheck()V
    .locals 8

    .line 448
    sget-boolean v0, Lcom/mediatek/boostfwk/utils/LogUtil;->DEBUG:Z

    if-eqz v0, :cond_0

    .line 449
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "rescueCheck frameId= "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-wide v1, p0, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->mVsyncFrameId:J

    invoke-virtual {v0, v1, v2}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    const-string v1, " vsyncTime="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-wide v1, p0, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->mVsyncTimeNanos:J

    invoke-virtual {v0, v1, v2}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    const-string v1, " frameStartTime="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-wide v1, p0, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->mCurFrameStartTimeNanos:J

    invoke-virtual {v0, v1, v2}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/mediatek/boostfwk/utils/LogUtil;->traceBegin(Ljava/lang/String;)V

    .line 453
    :cond_0
    iget-wide v0, p0, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->mVsyncTimeNanos:J

    .line 454
    iget-wide v2, p0, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->mCurFrameStartTimeNanos:J

    .line 456
    sget v4, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->mLimitVsyncTime:F

    .line 457
    sget v5, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->mFrameIntervalTime:F

    const-wide/16 v6, 0x0

    cmp-long v6, v2, v6

    if-lez v6, :cond_1

    sub-long/2addr v0, v2

    const-wide/32 v2, 0x7a120

    cmp-long v2, v0, v2

    if-lez v2, :cond_1

    long-to-float v0, v0

    .line 463
    invoke-direct {p0, v4, v0}, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->adjustCheckTime(FF)F

    move-result v4

    .line 464
    invoke-direct {p0, v5, v0}, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->adjustCheckTime(FF)F

    move-result v5

    .line 467
    :cond_1
    iget-boolean v0, p0, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->mWaitNextVsync:Z

    if-eqz v0, :cond_2

    .line 469
    iget-object v0, p0, Lcom/mediatek/boostfwk/policy/frame/BaseFramePolicy;->mWorkerHandler:Lcom/mediatek/boostfwk/policy/frame/BaseFramePolicy$WorkerHandler;

    const/4 v1, 0x3

    .line 470
    invoke-virtual {v0, v1}, Landroid/os/Handler;->obtainMessage(I)Landroid/os/Message;

    move-result-object v1

    float-to-long v2, v4

    .line 469
    invoke-virtual {v0, v1, v2, v3}, Landroid/os/Handler;->sendMessageDelayed(Landroid/os/Message;J)Z

    .line 473
    iget-object v0, p0, Lcom/mediatek/boostfwk/policy/frame/BaseFramePolicy;->mWorkerHandler:Lcom/mediatek/boostfwk/policy/frame/BaseFramePolicy$WorkerHandler;

    const/4 v1, 0x5

    .line 474
    invoke-virtual {v0, v1}, Landroid/os/Handler;->obtainMessage(I)Landroid/os/Message;

    move-result-object v1

    float-to-long v2, v5

    .line 473
    invoke-virtual {v0, v1, v2, v3}, Landroid/os/Handler;->sendMessageDelayed(Landroid/os/Message;J)Z

    .line 477
    :cond_2
    iget-object p0, p0, Lcom/mediatek/boostfwk/policy/frame/BaseFramePolicy;->mWorkerHandler:Lcom/mediatek/boostfwk/policy/frame/BaseFramePolicy$WorkerHandler;

    const/4 v0, 0x6

    invoke-virtual {p0, v0}, Landroid/os/Handler;->removeMessages(I)V

    .line 478
    invoke-static {}, Lcom/mediatek/boostfwk/utils/LogUtil;->traceEnd()V

    return-void
.end method

.method private setFrameStep(I)V
    .locals 2

    .line 349
    sget v0, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->mFrameStep:I

    if-le p1, v0, :cond_0

    .line 350
    sput p1, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->mFrameStep:I

    .line 351
    sget-boolean v0, Lcom/mediatek/boostfwk/utils/LogUtil;->DEBUG:Z

    if-eqz v0, :cond_0

    .line 352
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "new step="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p1, " frameId="

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-wide p0, p0, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->mCurFrameId:J

    invoke-virtual {v0, p0, p1}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p0}, Lcom/mediatek/boostfwk/utils/LogUtil;->trace(Ljava/lang/String;)V

    :cond_0
    return-void
.end method

.method private shutdownSBERescue(Ljava/lang/String;)V
    .locals 2

    const/4 v0, 0x0

    .line 574
    iput v0, p0, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->mCurFrameRescueMode:I

    .line 575
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string/jumbo v1, "shutdown "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p1, " curStep="

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    sget p1, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->mFrameStep:I

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p1, " mode="

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget p1, p0, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->mCurFrameRescueMode:I

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    const v0, 0x203ca00

    invoke-direct {p0, v0, p1}, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->powerHintForRender(ILjava/lang/String;)V

    .line 577
    invoke-direct {p0}, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->clearRescueInfo()V

    return-void
.end method

.method private updateBasicFrameInfo(JJ)V
    .locals 0

    .line 309
    iput-wide p1, p0, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->mCurFrameId:J

    .line 310
    iput-wide p3, p0, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->mCurFrameStartTimeNanos:J

    return-void
.end method

.method private updateRescueFrameId()V
    .locals 4

    .line 530
    iget-boolean v0, p0, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->mRescueWhenWaitNextVsync:Z

    const/4 v1, 0x1

    const-string/jumbo v2, "update frame id"

    const/4 v3, 0x0

    if-eqz v0, :cond_0

    .line 531
    iput-boolean v3, p0, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->mRescueWhenWaitNextVsync:Z

    .line 532
    invoke-direct {p0, v2}, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->doSBERescue(Ljava/lang/String;)V

    .line 533
    iput-boolean v1, p0, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->mRescueDoFrame:Z

    goto :goto_0

    .line 534
    :cond_0
    iget-boolean v0, p0, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->mRescueNextFrame:Z

    if-eqz v0, :cond_1

    .line 535
    iput-boolean v3, p0, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->mRescueNextFrame:Z

    .line 536
    invoke-direct {p0, v2}, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->doSBERescue(Ljava/lang/String;)V

    .line 537
    iput-boolean v1, p0, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->mRescueDoFrame:Z

    :cond_1
    :goto_0
    return-void
.end method


# virtual methods
.method public doFrameHint(ZJ)V
    .locals 2

    .line 243
    iget-boolean v0, p0, Lcom/mediatek/boostfwk/policy/frame/BaseFramePolicy;->mCoreServiceReady:Z

    if-nez v0, :cond_0

    return-void

    .line 246
    :cond_0
    sget-boolean v0, Lcom/mediatek/boostfwk/utils/LogUtil;->DEBUG:Z

    if-eqz v0, :cond_1

    .line 247
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string/jumbo v1, "vsync is begin = "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v1, " frame="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p2, p3}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    const-string v1, "FramePolicy"

    invoke-static {v1, v0}, Lcom/mediatek/boostfwk/utils/LogUtil;->mLogd(Ljava/lang/String;Ljava/lang/String;)V

    :cond_1
    if-eqz p1, :cond_2

    .line 250
    invoke-direct {p0, p2, p3}, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->onDoFrameBegin(J)V

    goto :goto_0

    .line 252
    :cond_2
    invoke-direct {p0}, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->onDoFrameEnd()V

    :goto_0
    return-void
.end method

.method public doFrameStepHint(ZI)V
    .locals 1

    .line 319
    iget-boolean v0, p0, Lcom/mediatek/boostfwk/policy/frame/BaseFramePolicy;->mCoreServiceReady:Z

    if-nez v0, :cond_0

    return-void

    :cond_0
    if-eqz p1, :cond_1

    .line 324
    invoke-direct {p0, p2}, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->mappingStepForDoFrame(I)I

    move-result p1

    invoke-direct {p0, p1}, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->setFrameStep(I)V

    goto :goto_0

    :cond_1
    const/4 p0, 0x1

    if-ne p2, p0, :cond_2

    .line 327
    sput-boolean p0, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->mIsAnimationStepEnd:Z

    goto :goto_0

    :cond_2
    const/4 p1, 0x3

    if-ne p2, p1, :cond_3

    .line 329
    sput-boolean p0, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->mIsTraversalStepEnd:Z

    :cond_3
    :goto_0
    return-void
.end method

.method protected handleMessageInternal(Landroid/os/Message;)V
    .locals 2

    .line 162
    iget p1, p1, Landroid/os/Message;->what:I

    packed-switch p1, :pswitch_data_0

    :pswitch_0
    goto :goto_0

    .line 186
    :pswitch_1
    invoke-direct {p0}, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->dleayStopHwuiHint()V

    goto :goto_0

    .line 180
    :pswitch_2
    invoke-direct {p0}, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->requestVsyncInternal()V

    goto :goto_0

    .line 177
    :pswitch_3
    invoke-direct {p0}, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->updateRescueFrameId()V

    goto :goto_0

    :pswitch_4
    const-string/jumbo p1, "time out"

    .line 183
    invoke-direct {p0, p1}, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->shutdownSBERescue(Ljava/lang/String;)V

    goto :goto_0

    .line 174
    :pswitch_5
    invoke-direct {p0}, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->oneVsyncRescueCheck()V

    goto :goto_0

    .line 169
    :pswitch_6
    invoke-direct {p0}, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->halfVsyncRescueCheck()V

    goto :goto_0

    .line 166
    :pswitch_7
    iget-wide v0, p0, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->mLastFrameEndFrameId:J

    invoke-direct {p0, v0, v1}, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->onDoFrameEndInternal(J)V

    :goto_0
    return-void

    nop

    :pswitch_data_0
    .packed-switch 0x2
        :pswitch_7
        :pswitch_6
        :pswitch_0
        :pswitch_5
        :pswitch_4
        :pswitch_3
        :pswitch_2
        :pswitch_1
    .end packed-switch
.end method

.method protected initCoreServiceInternal()V
    .locals 3

    .line 213
    invoke-static {}, Lcom/mediatek/boostfwk/info/ActivityInfo;->getInstance()Lcom/mediatek/boostfwk/info/ActivityInfo;

    move-result-object v0

    invoke-virtual {v0}, Lcom/mediatek/boostfwk/info/ActivityInfo;->getPackageName()Ljava/lang/String;

    .line 214
    new-instance v0, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2$DisplayEventReceiverImpl;

    iget-object v1, p0, Lcom/mediatek/boostfwk/policy/frame/BaseFramePolicy;->mWorkerHandler:Lcom/mediatek/boostfwk/policy/frame/BaseFramePolicy$WorkerHandler;

    .line 215
    invoke-virtual {v1}, Landroid/os/Handler;->getLooper()Landroid/os/Looper;

    move-result-object v1

    const/4 v2, 0x0

    invoke-direct {v0, v1, v2}, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2$DisplayEventReceiverImpl;-><init>(Landroid/os/Looper;I)V

    iput-object v0, p0, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->mDisplayEventReceiver:Landroid/view/DisplayEventReceiver;

    .line 216
    invoke-super {p0}, Lcom/mediatek/boostfwk/policy/frame/BaseFramePolicy;->initCoreServiceInternal()V

    return-void
.end method

.method public initLimitTime(F)Z
    .locals 5

    const/4 v0, 0x0

    cmpl-float v1, p1, v0

    if-lez v1, :cond_0

    .line 224
    sget v1, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->mFrameIntervalTime:F

    cmpl-float v1, p1, v1

    if-eqz v1, :cond_0

    .line 225
    sput p1, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->mFrameIntervalTime:F

    float-to-double v1, p1

    const-wide/high16 v3, 0x3fe0000000000000L    # 0.5

    mul-double/2addr v1, v3

    sub-double/2addr v1, v3

    double-to-float v1, v1

    .line 232
    sput v1, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->mLimitVsyncTime:F

    const/high16 v1, 0x40a00000    # 5.0f

    mul-float/2addr p1, v1

    float-to-long v1, p1

    .line 233
    sput-wide v1, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->mDelayStopHWUIHintTime:J

    .line 234
    invoke-static {}, Lcom/mediatek/boostfwk/info/ScrollState;->getRefreshRate()F

    move-result p1

    invoke-direct {p0, p1}, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->initialRescueStrengthOnce(F)V

    .line 238
    :cond_0
    sget-boolean p0, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->ENBALE_FRAME_RESCUE:Z

    if-eqz p0, :cond_1

    sget-boolean p0, Lcom/mediatek/boostfwk/policy/frame/BaseFramePolicy;->mListenFrameHint:Z

    if-eqz p0, :cond_1

    sget p0, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->mFrameIntervalTime:F

    cmpl-float p0, p0, v0

    if-eqz p0, :cond_1

    const/4 p0, 0x1

    goto :goto_0

    :cond_1
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method public onAllActivityPaused(Landroid/content/Context;)V
    .locals 0

    .line 710
    iget-object p1, p0, Lcom/mediatek/boostfwk/policy/frame/BaseFramePolicy;->mPowerHalService:Lcom/mediatek/powerhalmgr/PowerHalMgr;

    if-eqz p1, :cond_0

    .line 711
    iget p0, p0, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->mUnlockPowerHandle:I

    invoke-virtual {p1, p0}, Lcom/mediatek/powerhalmgr/PowerHalMgr;->perfLockRelease(I)V

    :cond_0
    return-void
.end method

.method public onDisplayRefreshRateChanged(IFF)V
    .locals 0

    .line 606
    invoke-direct {p0, p2}, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->initialRescueStrengthOnce(F)V

    return-void
.end method

.method public onRequestNextVsync()V
    .locals 2

    .line 359
    sget-boolean v0, Lcom/mediatek/boostfwk/policy/frame/BaseFramePolicy;->mListenFrameHint:Z

    if-eqz v0, :cond_3

    iget-boolean v0, p0, Lcom/mediatek/boostfwk/policy/frame/BaseFramePolicy;->mCoreServiceReady:Z

    if-nez v0, :cond_0

    goto :goto_0

    .line 362
    :cond_0
    iget-object v0, p0, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->mScrollingFramePrefetcher:Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;

    if-nez v0, :cond_1

    .line 363
    invoke-static {}, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->getInstance()Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;

    move-result-object v0

    iput-object v0, p0, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->mScrollingFramePrefetcher:Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;

    .line 366
    :cond_1
    sget v0, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->mFrameStep:I

    const/4 v1, 0x1

    if-ge v0, v1, :cond_2

    iget-object v0, p0, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->mScrollingFramePrefetcher:Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;

    .line 367
    invoke-virtual {v0}, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->isPreAnimationRunning()Z

    move-result v0

    if-nez v0, :cond_2

    .line 368
    invoke-virtual {p0}, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->requestVsync()V

    goto :goto_0

    .line 370
    :cond_2
    iput-boolean v1, p0, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->mHasNextFrame:Z

    :cond_3
    :goto_0
    return-void
.end method

.method public onScrollStateChange(Z)V
    .locals 3

    .line 384
    invoke-super {p0, p1}, Lcom/mediatek/boostfwk/policy/frame/BaseFramePolicy;->onScrollStateChange(Z)V

    .line 385
    sget-object v0, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->mInstance:Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;

    invoke-virtual {v0}, Lcom/mediatek/boostfwk/policy/frame/BaseFramePolicy;->getThreadedRenderer()Landroid/view/ThreadedRenderer;

    move-result-object v0

    .line 386
    sget-boolean v1, Lcom/mediatek/boostfwk/utils/LogUtil;->DEBUG:Z

    if-eqz v1, :cond_0

    .line 387
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "onScrollStateChange scroll="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string p1, " "

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    const-string v1, "FramePolicy"

    invoke-static {v1, p1}, Lcom/mediatek/boostfwk/utils/LogUtil;->mLogd(Ljava/lang/String;Ljava/lang/String;)V

    .line 389
    :cond_0
    sget-boolean p1, Lcom/mediatek/boostfwk/policy/frame/BaseFramePolicy;->mListenFrameHint:Z

    if-eqz p1, :cond_1

    .line 390
    iget-object p1, p0, Lcom/mediatek/boostfwk/policy/frame/BaseFramePolicy;->mWorkerHandler:Lcom/mediatek/boostfwk/policy/frame/BaseFramePolicy$WorkerHandler;

    const/16 v1, 0x9

    invoke-virtual {p1, v1}, Landroid/os/Handler;->removeMessages(I)V

    if-eqz v0, :cond_1

    .line 392
    iget p0, p0, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->mFrameHintMask:I

    const/4 p1, 0x1

    invoke-static {p0, p1}, Lcom/mediatek/boostfwk/info/ActivityInfo;->updateSBEMask(IZ)I

    move-result p0

    invoke-static {p0}, Landroid/view/ThreadedRenderer;->needFrameCompleteHint(I)V

    :cond_1
    return-void
.end method

.method public requestVsync()V
    .locals 2

    .line 375
    iget-boolean v0, p0, Lcom/mediatek/boostfwk/policy/frame/BaseFramePolicy;->mCoreServiceReady:Z

    if-nez v0, :cond_0

    return-void

    .line 378
    :cond_0
    iget-object v0, p0, Lcom/mediatek/boostfwk/policy/frame/BaseFramePolicy;->mWorkerHandler:Lcom/mediatek/boostfwk/policy/frame/BaseFramePolicy$WorkerHandler;

    const/16 v1, 0x8

    invoke-virtual {v0, v1}, Landroid/os/Handler;->removeMessages(I)V

    .line 379
    iget-object p0, p0, Lcom/mediatek/boostfwk/policy/frame/BaseFramePolicy;->mWorkerHandler:Lcom/mediatek/boostfwk/policy/frame/BaseFramePolicy$WorkerHandler;

    invoke-virtual {p0, v1}, Landroid/os/Handler;->sendEmptyMessage(I)Z

    return-void
.end method
