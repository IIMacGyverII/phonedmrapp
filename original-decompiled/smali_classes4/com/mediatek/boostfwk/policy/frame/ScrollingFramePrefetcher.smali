.class public Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;
.super Ljava/lang/Object;
.source "ScrollingFramePrefetcher.java"


# static fields
.field private static final ANIM_THRESHOLD:D = 1.0

.field private static final BUFFER_COUNT:I = 0x2

.field private static final DISPLAY_RATE_90:F = 90.0f

.field private static final ERROR_CODE:I = -0x16

.field public static final ESTIMATION_FRAME_ID:J = -0x1L

.field public static final ESTIMATION_FRAME_LIMIT:I = 0x5

.field public static final FEATURE_ENABLE:Z

.field private static final FRAME_THRESHOLD:D = 1.4

.field private static final MAX_BUFFER_SIZE:I = 0x5

.field private static final NO_CHANGED:I = -0x1

.field public static final PRE_ANIM_ENABLE:Z

.field private static final TAG:Ljava/lang/String; = "ScrollingFramePrefetcher"

.field private static final lock:Ljava/lang/Object;

.field public static mFeatureLocked:Z

.field private static sInstance:Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;


# instance fields
.field private final DROP_FRAME:I

.field private final FIRST_FRAME:I

.field private final RESET_FRAME:I

.field private mActivityChangeListener:Lcom/mediatek/boostfwk/info/ActivityInfo$ActivityChangeListener;

.field private mActivityInfo:Lcom/mediatek/boostfwk/info/ActivityInfo;

.field private mAppRequestVsync:Z

.field private mChoreographer:Ljava/lang/ref/WeakReference;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/lang/ref/WeakReference<",
            "Landroid/view/Choreographer;",
            ">;"
        }
    .end annotation
.end field

.field private mDefaultBufferSize:I

.field private mEstimationFrameCount:I

.field private mFirstFlingFrameTimeNano:J

.field private mFrameEndTimeNano:J

.field private mFrameIntervalNanos:J

.field private mIsAnimDrop:Z

.field private mIsEstimationFrame:Z

.field private mIsFling:Z

.field private mIsPreAnim:Z

.field private mIsPreAnimationRunning:Z

.field private mLastAnimFrameTimeNano:J

.field private mLastBufferSize:I

.field private mLastFrameTimeNano:J

.field private mLastOrigFrameTimeNano:J

.field private mNeedScheduleNextFrame:Z

.field private mPreAnimEndTimeNano:J

.field private mRefreshRateChangedListener:Lcom/mediatek/boostfwk/info/ScrollState$RefreshRateChangedListener;

.field private mScrollStateListener:Lcom/mediatek/boostfwk/info/ScrollState$ScrollStateListener;


# direct methods
.method static bridge synthetic -$$Nest$fgetmActivityInfo(Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;)Lcom/mediatek/boostfwk/info/ActivityInfo;
    .locals 0

    iget-object p0, p0, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->mActivityInfo:Lcom/mediatek/boostfwk/info/ActivityInfo;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$monRefreshRateChanged(Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;FF)V
    .locals 0

    invoke-direct {p0, p1, p2}, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->onRefreshRateChanged(FF)V

    return-void
.end method

.method static bridge synthetic -$$Nest$mresetStatusWhenScroll(Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;)V
    .locals 0

    invoke-direct {p0}, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->resetStatusWhenScroll()V

    return-void
.end method

.method static bridge synthetic -$$Nest$msetBufferSize(Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;Landroid/view/ThreadedRenderer;Z)V
    .locals 0

    invoke-direct {p0, p1, p2}, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->setBufferSize(Landroid/view/ThreadedRenderer;Z)V

    return-void
.end method

.method static constructor <clinit>()V
    .locals 1

    .line 60
    invoke-static {}, Lcom/mediatek/boostfwk/utils/Config;->isEnableFramePrefetcher()Z

    move-result v0

    sput-boolean v0, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->FEATURE_ENABLE:Z

    .line 61
    invoke-static {}, Lcom/mediatek/boostfwk/utils/Config;->isEnablePreAnimation()Z

    move-result v0

    sput-boolean v0, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->PRE_ANIM_ENABLE:Z

    const/4 v0, 0x0

    .line 62
    sput-boolean v0, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->mFeatureLocked:Z

    .line 67
    new-instance v0, Ljava/lang/Object;

    invoke-direct {v0}, Ljava/lang/Object;-><init>()V

    sput-object v0, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->lock:Ljava/lang/Object;

    const/4 v0, 0x0

    .line 68
    sput-object v0, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->sInstance:Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;

    return-void
.end method

.method private constructor <init>()V
    .locals 4

    .line 118
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    const/4 v0, 0x0

    .line 74
    iput-object v0, p0, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->mChoreographer:Ljava/lang/ref/WeakReference;

    const-wide/16 v1, -0x1

    .line 75
    iput-wide v1, p0, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->mFirstFlingFrameTimeNano:J

    .line 76
    iput-wide v1, p0, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->mLastFrameTimeNano:J

    .line 77
    iput-wide v1, p0, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->mLastOrigFrameTimeNano:J

    .line 78
    iput-wide v1, p0, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->mLastAnimFrameTimeNano:J

    .line 79
    iput-wide v1, p0, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->mFrameEndTimeNano:J

    .line 80
    iput-wide v1, p0, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->mPreAnimEndTimeNano:J

    const/4 v3, 0x0

    .line 81
    iput-boolean v3, p0, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->mIsEstimationFrame:Z

    .line 82
    iput-boolean v3, p0, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->mIsFling:Z

    .line 83
    iput-boolean v3, p0, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->mIsPreAnim:Z

    .line 84
    iput-boolean v3, p0, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->mIsAnimDrop:Z

    .line 85
    iput-boolean v3, p0, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->mAppRequestVsync:Z

    .line 86
    iput-boolean v3, p0, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->mIsPreAnimationRunning:Z

    .line 87
    iput-boolean v3, p0, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->mNeedScheduleNextFrame:Z

    .line 88
    iput v3, p0, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->mEstimationFrameCount:I

    .line 89
    iput-wide v1, p0, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->mFrameIntervalNanos:J

    .line 91
    iput v3, p0, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->FIRST_FRAME:I

    const/4 v1, 0x1

    .line 92
    iput v1, p0, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->DROP_FRAME:I

    const/4 v1, 0x2

    .line 93
    iput v1, p0, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->RESET_FRAME:I

    const/4 v1, -0x1

    .line 99
    iput v1, p0, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->mDefaultBufferSize:I

    .line 100
    iput v1, p0, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->mLastBufferSize:I

    .line 101
    iput-object v0, p0, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->mActivityInfo:Lcom/mediatek/boostfwk/info/ActivityInfo;

    .line 103
    iput-object v0, p0, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->mRefreshRateChangedListener:Lcom/mediatek/boostfwk/info/ScrollState$RefreshRateChangedListener;

    .line 104
    iput-object v0, p0, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->mScrollStateListener:Lcom/mediatek/boostfwk/info/ScrollState$ScrollStateListener;

    .line 105
    iput-object v0, p0, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->mActivityChangeListener:Lcom/mediatek/boostfwk/info/ActivityInfo$ActivityChangeListener;

    .line 119
    invoke-static {}, Lcom/mediatek/boostfwk/info/ActivityInfo;->getInstance()Lcom/mediatek/boostfwk/info/ActivityInfo;

    move-result-object v0

    iput-object v0, p0, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->mActivityInfo:Lcom/mediatek/boostfwk/info/ActivityInfo;

    .line 120
    new-instance v0, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher$1;

    invoke-direct {v0, p0}, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher$1;-><init>(Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;)V

    iput-object v0, p0, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->mRefreshRateChangedListener:Lcom/mediatek/boostfwk/info/ScrollState$RefreshRateChangedListener;

    .line 127
    new-instance v0, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher$2;

    invoke-direct {v0, p0}, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher$2;-><init>(Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;)V

    iput-object v0, p0, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->mActivityChangeListener:Lcom/mediatek/boostfwk/info/ActivityInfo$ActivityChangeListener;

    .line 134
    new-instance v0, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher$3;

    invoke-direct {v0, p0}, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher$3;-><init>(Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;)V

    iput-object v0, p0, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->mScrollStateListener:Lcom/mediatek/boostfwk/info/ScrollState$ScrollStateListener;

    .line 142
    invoke-static {v0}, Lcom/mediatek/boostfwk/info/ScrollState;->registerScrollStateListener(Lcom/mediatek/boostfwk/info/ScrollState$ScrollStateListener;)V

    .line 143
    iget-object v0, p0, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->mActivityInfo:Lcom/mediatek/boostfwk/info/ActivityInfo;

    iget-object v1, p0, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->mActivityChangeListener:Lcom/mediatek/boostfwk/info/ActivityInfo$ActivityChangeListener;

    invoke-virtual {v0, v1}, Lcom/mediatek/boostfwk/info/ActivityInfo;->registerActivityListener(Lcom/mediatek/boostfwk/info/ActivityInfo$ActivityChangeListener;)V

    .line 144
    iget-object p0, p0, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->mRefreshRateChangedListener:Lcom/mediatek/boostfwk/info/ScrollState$RefreshRateChangedListener;

    invoke-static {p0}, Lcom/mediatek/boostfwk/info/ScrollState;->registerRefreshRateChangedListener(Lcom/mediatek/boostfwk/info/ScrollState$RefreshRateChangedListener;)V

    return-void
.end method

.method private correctionFrameTime(JJ)J
    .locals 5

    .line 449
    iget-wide v0, p0, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->mFrameIntervalNanos:J

    add-long/2addr v0, p3

    sub-long v2, p1, v0

    .line 451
    sget-boolean p0, Lcom/mediatek/boostfwk/utils/LogUtil;->DEBUG:Z

    if-eqz p0, :cond_0

    .line 452
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "ScrollingFramePrefetcher#correctionFrameTime, frameTimeNano = "

    invoke-virtual {p0, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, p1, p2}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    const-string v4, ", lastFrameTimeNano = "

    invoke-virtual {p0, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, p3, p4}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    const-string p3, ", targetFrameTime = "

    invoke-virtual {p0, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, v0, v1}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    const-string p3, ", diff = "

    invoke-virtual {p0, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, v2, v3}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p0}, Lcom/mediatek/boostfwk/utils/LogUtil;->trace(Ljava/lang/String;)V

    :cond_0
    const-wide/16 p3, 0x0

    cmp-long p0, v2, p3

    if-lez p0, :cond_1

    goto :goto_0

    :cond_1
    move-wide p1, v0

    :goto_0
    return-wide p1
.end method

.method private disableSFP()Z
    .locals 1

    .line 152
    sget-boolean v0, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->FEATURE_ENABLE:Z

    if-eqz v0, :cond_1

    iget-boolean p0, p0, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->mIsFling:Z

    if-eqz p0, :cond_1

    .line 153
    invoke-static {}, Lcom/mediatek/boostfwk/info/ScrollState;->getRefreshRate()F

    move-result p0

    const/high16 v0, 0x42b40000    # 90.0f

    cmpg-float p0, p0, v0

    if-ltz p0, :cond_1

    sget-boolean p0, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->mFeatureLocked:Z

    if-eqz p0, :cond_0

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    goto :goto_1

    :cond_1
    :goto_0
    const/4 p0, 0x1

    :goto_1
    return p0
.end method

.method private doEstimationFrameHook(J)V
    .locals 2

    .line 462
    iget-object v0, p0, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->mChoreographer:Ljava/lang/ref/WeakReference;

    if-eqz v0, :cond_2

    invoke-virtual {v0}, Ljava/lang/ref/WeakReference;->get()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/view/Choreographer;

    if-nez v0, :cond_0

    goto :goto_0

    .line 465
    :cond_0
    invoke-virtual {v0}, Landroid/view/Choreographer;->isEmptyCallback()Z

    move-result v1

    if-eqz v1, :cond_1

    const-string p0, "ScrollingFramePrefetcher#no draw at this time, skip."

    .line 466
    invoke-static {p0}, Lcom/mediatek/boostfwk/utils/LogUtil;->trace(Ljava/lang/String;)V

    return-void

    .line 470
    :cond_1
    invoke-virtual {v0}, Landroid/view/Choreographer;->forceFrameScheduled()V

    .line 471
    invoke-virtual {v0, p1, p2}, Landroid/view/Choreographer;->doEstimationFrame(J)V

    .line 474
    iget-boolean p1, p0, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->mAppRequestVsync:Z

    if-eqz p1, :cond_2

    const/4 p1, 0x0

    .line 475
    iput-boolean p1, p0, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->mAppRequestVsync:Z

    .line 476
    invoke-virtual {v0}, Landroid/view/Choreographer;->forceFrameScheduled()V

    :cond_2
    :goto_0
    return-void
.end method

.method private doPreAnimation(J)V
    .locals 11

    .line 307
    sget-boolean v0, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->PRE_ANIM_ENABLE:Z

    const/4 v1, 0x0

    if-eqz v0, :cond_3

    iget-object v0, p0, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->mChoreographer:Ljava/lang/ref/WeakReference;

    if-nez v0, :cond_0

    goto :goto_0

    .line 311
    :cond_0
    iget-wide v2, p0, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->mFrameIntervalNanos:J

    invoke-direct {p0, p1, p2, v2, v3}, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->predictPreAnimTime(JJ)J

    move-result-wide v2

    .line 312
    sget-boolean v0, Lcom/mediatek/boostfwk/utils/LogUtil;->DEBUG:Z

    if-eqz v0, :cond_1

    .line 313
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "ScrollingFramePrefetcher#doPreAnimation, pre anim frame time = "

    invoke-virtual {v0, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-wide/32 v4, 0xf4240

    div-long v6, v2, v4

    invoke-virtual {v0, v6, v7}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    const-string v6, ", mLastAnimFrameTimeNano = "

    invoke-virtual {v0, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-wide v6, p0, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->mLastAnimFrameTimeNano:J

    div-long/2addr v6, v4

    invoke-virtual {v0, v6, v7}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/mediatek/boostfwk/utils/LogUtil;->trace(Ljava/lang/String;)V

    :cond_1
    const/4 v0, 0x1

    .line 317
    iput-boolean v0, p0, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->mIsPreAnimationRunning:Z

    .line 318
    invoke-static {}, Ljava/lang/System;->nanoTime()J

    move-result-wide v5

    .line 319
    invoke-direct {p0, v2, v3}, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->doPreAnimationHook(J)V

    .line 320
    invoke-static {}, Ljava/lang/System;->nanoTime()J

    move-result-wide v7

    .line 321
    iput-boolean v1, p0, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->mIsPreAnimationRunning:Z

    .line 322
    iput-wide v7, p0, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->mPreAnimEndTimeNano:J

    .line 323
    iput-wide v2, p0, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->mLastAnimFrameTimeNano:J

    const-wide/high16 v9, 0x3ff0000000000000L    # 1.0

    move-object v4, p0

    .line 324
    invoke-direct/range {v4 .. v10}, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->isDropFrame(JJD)Z

    move-result v1

    iput-boolean v1, p0, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->mIsAnimDrop:Z

    if-eqz v1, :cond_2

    .line 326
    iget-wide v1, p0, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->mLastAnimFrameTimeNano:J

    invoke-direct {p0, v1, v2}, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->doEstimationFrameHook(J)V

    .line 327
    invoke-direct {p0, v0, p1, p2}, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->updateDynaFrameStatus(IJ)V

    :cond_2
    return-void

    .line 308
    :cond_3
    :goto_0
    iput-boolean v1, p0, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->mIsPreAnim:Z

    return-void
.end method

.method private doPreAnimationHook(J)V
    .locals 3

    .line 482
    iget-object v0, p0, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->mChoreographer:Ljava/lang/ref/WeakReference;

    if-eqz v0, :cond_1

    invoke-virtual {v0}, Ljava/lang/ref/WeakReference;->get()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/view/Choreographer;

    if-nez v0, :cond_0

    goto :goto_0

    .line 485
    :cond_0
    iget-wide v1, p0, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->mFrameIntervalNanos:J

    invoke-virtual {v0, p1, p2, v1, v2}, Landroid/view/Choreographer;->doPreAnimation(JJ)V

    :cond_1
    :goto_0
    return-void
.end method

.method private dropFrameStatus(J)V
    .locals 3

    .line 410
    sget-object v0, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->lock:Ljava/lang/Object;

    monitor-enter v0

    .line 411
    :try_start_0
    iput-wide p1, p0, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->mLastFrameTimeNano:J

    .line 412
    iput-wide p1, p0, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->mLastAnimFrameTimeNano:J

    const/4 p1, 0x1

    .line 413
    iput-boolean p1, p0, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->mIsEstimationFrame:Z

    const/4 p1, 0x0

    .line 414
    iput-boolean p1, p0, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->mIsPreAnim:Z

    .line 415
    iput-boolean p1, p0, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->mIsAnimDrop:Z

    .line 416
    sget-boolean p1, Lcom/mediatek/boostfwk/utils/LogUtil;->DEBUG:Z

    if-eqz p1, :cond_0

    .line 417
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string p2, "ScrollingFramePrefetcher#dropFrameStatus, mFirstFlingFrameTimeNano = "

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-wide v1, p0, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->mFirstFlingFrameTimeNano:J

    invoke-virtual {p1, v1, v2}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    const-string p2, ", mIsEstimationFrame = "

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-boolean p0, p0, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->mIsEstimationFrame:Z

    invoke-virtual {p1, p0}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p0}, Lcom/mediatek/boostfwk/utils/LogUtil;->trace(Ljava/lang/String;)V

    .line 420
    :cond_0
    monitor-exit v0

    return-void

    :catchall_0
    move-exception p0

    monitor-exit v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    throw p0
.end method

.method private estimationFrameTime(JLandroid/view/Choreographer$FrameData;Lcom/mediatek/boostfwk/scenario/frame/FrameScenario;)V
    .locals 4

    .line 162
    invoke-virtual {p3}, Landroid/view/Choreographer$FrameData;->getFrameTimeNanos()J

    move-result-wide v0

    .line 163
    invoke-virtual {p4}, Lcom/mediatek/boostfwk/scenario/frame/FrameScenario;->getChoreographer()Landroid/view/Choreographer;

    move-result-object v2

    .line 165
    invoke-direct {p0}, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->disableSFP()Z

    move-result v3

    if-nez v3, :cond_1

    if-nez v2, :cond_0

    goto :goto_0

    .line 176
    :cond_0
    new-instance v0, Ljava/lang/ref/WeakReference;

    invoke-direct {v0, v2}, Ljava/lang/ref/WeakReference;-><init>(Ljava/lang/Object;)V

    iput-object v0, p0, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->mChoreographer:Ljava/lang/ref/WeakReference;

    .line 177
    invoke-direct {p0}, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->updateFrameIntervalNanos()V

    .line 178
    invoke-direct {p0, p1, p2, p3}, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->estimationFrameTimeInternel(JLandroid/view/Choreographer$FrameData;)J

    move-result-wide p0

    .line 179
    invoke-virtual {p4, p0, p1}, Lcom/mediatek/boostfwk/scenario/frame/FrameScenario;->setFrameTimeResult(J)Lcom/mediatek/boostfwk/scenario/frame/FrameScenario;

    return-void

    :cond_1
    :goto_0
    const/4 p1, 0x0

    .line 166
    iput-boolean p1, p0, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->mIsPreAnim:Z

    .line 167
    invoke-virtual {p4, v0, v1}, Lcom/mediatek/boostfwk/scenario/frame/FrameScenario;->setFrameTimeResult(J)Lcom/mediatek/boostfwk/scenario/frame/FrameScenario;

    .line 168
    sget-boolean p1, Lcom/mediatek/boostfwk/utils/LogUtil;->DEBUG:Z

    if-eqz p1, :cond_2

    .line 169
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string p2, "ScrollingFramePrefetcher#disableSFP-because, feature:"

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    sget-boolean p2, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->FEATURE_ENABLE:Z

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string p2, "isFling= "

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-boolean p0, p0, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->mIsFling:Z

    invoke-virtual {p1, p0}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string p0, "featureLocked= "

    invoke-virtual {p1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    sget-boolean p0, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->mFeatureLocked:Z

    invoke-virtual {p1, p0}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string p0, "refreshRate: "

    invoke-virtual {p1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 172
    invoke-static {}, Lcom/mediatek/boostfwk/info/ScrollState;->getRefreshRate()F

    move-result p0

    invoke-virtual {p1, p0}, Ljava/lang/StringBuilder;->append(F)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    .line 169
    invoke-static {p0}, Lcom/mediatek/boostfwk/utils/LogUtil;->trace(Ljava/lang/String;)V

    :cond_2
    return-void
.end method

.method private estimationFrameTimeInternel(JLandroid/view/Choreographer$FrameData;)J
    .locals 7

    .line 184
    invoke-virtual {p3}, Landroid/view/Choreographer$FrameData;->getFrameTimeNanos()J

    move-result-wide v0

    .line 187
    iget-wide v2, p0, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->mFirstFlingFrameTimeNano:J

    const-wide/16 v4, -0x1

    cmp-long p3, v2, v4

    const-string v2, ", last frame time = "

    if-nez p3, :cond_0

    const/4 p3, 0x0

    .line 188
    invoke-direct {p0, p3, v0, v1}, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->updateDynaFrameStatus(IJ)V

    move-wide v3, v0

    goto :goto_1

    .line 191
    :cond_0
    sget-boolean p3, Lcom/mediatek/boostfwk/utils/LogUtil;->DEBUG:Z

    if-eqz p3, :cond_1

    .line 192
    new-instance p3, Ljava/lang/StringBuilder;

    invoke-direct {p3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "ScrollingFramePrefetcher#estimationFrameTimeInternel-before, orig frame time = "

    invoke-virtual {p3, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p3, p1, p2}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    const-string v3, ", last orig frame time = "

    invoke-virtual {p3, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-wide v3, p0, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->mLastOrigFrameTimeNano:J

    invoke-virtual {p3, v3, v4}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    invoke-virtual {p3, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-wide v3, p0, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->mLastFrameTimeNano:J

    invoke-virtual {p3, v3, v4}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    invoke-virtual {p3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p3

    invoke-static {p3}, Lcom/mediatek/boostfwk/utils/LogUtil;->trace(Ljava/lang/String;)V

    .line 201
    :cond_1
    invoke-virtual {p0}, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->isPreAnimation()Z

    move-result p3

    if-eqz p3, :cond_2

    .line 202
    iget-wide v3, p0, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->mLastAnimFrameTimeNano:J

    iput-wide v3, p0, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->mLastFrameTimeNano:J

    goto :goto_0

    .line 204
    :cond_2
    iget-wide v3, p0, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->mLastFrameTimeNano:J

    invoke-direct {p0, v0, v1, v3, v4}, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->correctionFrameTime(JJ)J

    move-result-wide v3

    iput-wide v3, p0, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->mLastFrameTimeNano:J

    .line 206
    :goto_0
    iget-wide v3, p0, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->mLastFrameTimeNano:J

    .line 208
    :goto_1
    iput-wide p1, p0, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->mLastOrigFrameTimeNano:J

    .line 209
    sget-boolean p3, Lcom/mediatek/boostfwk/utils/LogUtil;->DEBUG:Z

    if-eqz p3, :cond_3

    .line 210
    new-instance p3, Ljava/lang/StringBuilder;

    invoke-direct {p3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v5, "ScrollingFramePrefetcher#estimationFrameTimeInternel, orig frame time = "

    invoke-virtual {p3, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-wide/32 v5, 0xf4240

    div-long/2addr p1, v5

    invoke-virtual {p3, p1, p2}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    const-string p1, ", frame time = "

    invoke-virtual {p3, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    div-long/2addr v0, v5

    invoke-virtual {p3, v0, v1}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    invoke-virtual {p3, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-wide p1, p0, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->mLastFrameTimeNano:J

    div-long/2addr p1, v5

    invoke-virtual {p3, p1, p2}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    const-string p1, ", last anim frame time = "

    invoke-virtual {p3, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-wide p0, p0, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->mLastAnimFrameTimeNano:J

    div-long/2addr p0, v5

    invoke-virtual {p3, p0, p1}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    const-string p0, ", result = "

    invoke-virtual {p3, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    div-long p0, v3, v5

    invoke-virtual {p3, p0, p1}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    invoke-virtual {p3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p0}, Lcom/mediatek/boostfwk/utils/LogUtil;->trace(Ljava/lang/String;)V

    :cond_3
    return-wide v3
.end method

.method private firstFrameStatus(J)V
    .locals 2

    .line 395
    sget-object v0, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->lock:Ljava/lang/Object;

    monitor-enter v0

    .line 397
    :try_start_0
    iput-wide p1, p0, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->mFirstFlingFrameTimeNano:J

    const/4 v1, 0x1

    .line 398
    iput-boolean v1, p0, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->mIsEstimationFrame:Z

    .line 399
    iput-wide p1, p0, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->mLastFrameTimeNano:J

    .line 400
    iput-wide p1, p0, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->mLastAnimFrameTimeNano:J

    const/4 p1, 0x0

    .line 401
    iput-boolean p1, p0, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->mIsPreAnim:Z

    .line 402
    iput-boolean p1, p0, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->mIsAnimDrop:Z

    .line 403
    sget-boolean p1, Lcom/mediatek/boostfwk/utils/LogUtil;->DEBUG:Z

    if-eqz p1, :cond_0

    .line 404
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string p2, "ScrollingFramePrefetcher#firstFrameStatus, mIsEstimationFrame = "

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-boolean p0, p0, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->mIsEstimationFrame:Z

    invoke-virtual {p1, p0}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p0}, Lcom/mediatek/boostfwk/utils/LogUtil;->trace(Ljava/lang/String;)V

    .line 406
    :cond_0
    monitor-exit v0

    return-void

    :catchall_0
    move-exception p0

    monitor-exit v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    throw p0
.end method

.method private forceScheduleNexFrame()V
    .locals 1

    .line 525
    iget-object p0, p0, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->mChoreographer:Ljava/lang/ref/WeakReference;

    if-eqz p0, :cond_2

    invoke-virtual {p0}, Ljava/lang/ref/WeakReference;->get()Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Landroid/view/Choreographer;

    if-nez p0, :cond_0

    goto :goto_0

    .line 528
    :cond_0
    sget-boolean v0, Lcom/mediatek/boostfwk/utils/LogUtil;->DEBUG:Z

    if-eqz v0, :cond_1

    const-string v0, "forceScheduleNexFrame"

    .line 529
    invoke-static {v0}, Lcom/mediatek/boostfwk/utils/LogUtil;->traceBegin(Ljava/lang/String;)V

    .line 531
    :cond_1
    invoke-virtual {p0}, Landroid/view/Choreographer;->forceScheduleNexFrame()V

    .line 532
    invoke-static {}, Lcom/mediatek/boostfwk/utils/LogUtil;->traceEnd()V

    :cond_2
    :goto_0
    return-void
.end method

.method public static getInstance()Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;
    .locals 2

    .line 108
    sget-object v0, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->sInstance:Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;

    if-nez v0, :cond_1

    .line 109
    sget-object v0, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->lock:Ljava/lang/Object;

    monitor-enter v0

    .line 110
    :try_start_0
    sget-object v1, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->sInstance:Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;

    if-nez v1, :cond_0

    .line 111
    new-instance v1, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;

    invoke-direct {v1}, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;-><init>()V

    sput-object v1, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->sInstance:Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;

    .line 113
    :cond_0
    monitor-exit v0

    goto :goto_0

    :catchall_0
    move-exception v1

    monitor-exit v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    throw v1

    .line 115
    :cond_1
    :goto_0
    sget-object v0, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->sInstance:Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;

    return-object v0
.end method

.method private isDropFrame(JJD)Z
    .locals 4

    const-wide/16 v0, -0x1

    cmp-long v0, p1, v0

    const/4 v1, 0x0

    if-nez v0, :cond_0

    return v1

    .line 337
    :cond_0
    iget-wide v2, p0, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->mFrameIntervalNanos:J

    long-to-double v2, v2

    mul-double/2addr v2, p5

    double-to-long p5, v2

    sub-long/2addr p3, p1

    cmp-long p0, p3, p5

    if-lez p0, :cond_1

    const/4 v1, 0x1

    :cond_1
    return v1
.end method

.method private onRefreshRateChanged(FF)V
    .locals 1

    .line 510
    invoke-static {}, Lcom/mediatek/boostfwk/utils/Config;->isVariableRefreshRateSupported()Z

    move-result p2

    if-eqz p2, :cond_2

    iget-boolean p2, p0, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->mIsFling:Z

    if-eqz p2, :cond_2

    sget-boolean p2, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->PRE_ANIM_ENABLE:Z

    if-eqz p2, :cond_2

    sget-boolean p2, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->FEATURE_ENABLE:Z

    if-eqz p2, :cond_2

    const/high16 p2, 0x42680000    # 58.0f

    cmpg-float p2, p1, p2

    if-gez p2, :cond_0

    return-void

    .line 515
    :cond_0
    sget-boolean p2, Lcom/mediatek/boostfwk/utils/LogUtil;->DEBUG:Z

    if-eqz p2, :cond_1

    .line 516
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "#onRefreshRateChanged mark NeedScheduleNextFrame whenchange to refreshRate="

    invoke-virtual {p2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2, p1}, Ljava/lang/StringBuilder;->append(F)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    const-string p2, "ScrollingFramePrefetcher"

    invoke-static {p2, p1}, Lcom/mediatek/boostfwk/utils/LogUtil;->traceAndMLogd(Ljava/lang/String;Ljava/lang/String;)V

    :cond_1
    const/4 p1, 0x1

    .line 519
    iput-boolean p1, p0, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->mNeedScheduleNextFrame:Z

    :cond_2
    return-void
.end method

.method private predictPreAnimTime(JJ)J
    .locals 4

    add-long v0, p1, p3

    .line 222
    sget-boolean p0, Lcom/mediatek/boostfwk/utils/LogUtil;->DEBUG:Z

    if-eqz p0, :cond_0

    .line 223
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "ScrollingFramePrefetcher#predictPreAnimTime, orig frame Time = "

    invoke-virtual {p0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-wide/32 v2, 0xf4240

    div-long/2addr p1, v2

    invoke-virtual {p0, p1, p2}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    const-string p1, ", frameIntervalNanos = "

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    div-long/2addr p3, v2

    invoke-virtual {p0, p3, p4}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    const-string p1, ", next frame time = "

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    div-long p1, v0, v2

    invoke-virtual {p0, p1, p2}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p0}, Lcom/mediatek/boostfwk/utils/LogUtil;->trace(Ljava/lang/String;)V

    :cond_0
    return-wide v0
.end method

.method private resetStatus()V
    .locals 4

    .line 424
    sget-object v0, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->lock:Ljava/lang/Object;

    monitor-enter v0

    const-wide/16 v1, -0x1

    .line 425
    :try_start_0
    iput-wide v1, p0, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->mFirstFlingFrameTimeNano:J

    .line 426
    iput-wide v1, p0, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->mLastFrameTimeNano:J

    .line 427
    iput-wide v1, p0, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->mLastOrigFrameTimeNano:J

    .line 428
    iput-wide v1, p0, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->mLastAnimFrameTimeNano:J

    .line 429
    iput-wide v1, p0, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->mFrameEndTimeNano:J

    .line 430
    iput-wide v1, p0, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->mPreAnimEndTimeNano:J

    const/4 v1, 0x0

    .line 431
    iput-boolean v1, p0, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->mIsEstimationFrame:Z

    .line 432
    iput-boolean v1, p0, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->mIsPreAnim:Z

    .line 433
    iput-boolean v1, p0, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->mIsAnimDrop:Z

    .line 434
    sget-boolean v1, Lcom/mediatek/boostfwk/utils/LogUtil;->DEBUG:Z

    if-eqz v1, :cond_0

    .line 435
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "ScrollingFramePrefetcher#resetStatus, mFirstFlingFrameTimeNano = "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-wide v2, p0, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->mFirstFlingFrameTimeNano:J

    invoke-virtual {v1, v2, v3}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p0}, Lcom/mediatek/boostfwk/utils/LogUtil;->trace(Ljava/lang/String;)V

    .line 438
    :cond_0
    monitor-exit v0

    return-void

    :catchall_0
    move-exception p0

    monitor-exit v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    throw p0
.end method

.method private resetStatusWhenScroll()V
    .locals 1

    const/4 v0, 0x0

    .line 496
    invoke-virtual {p0, v0}, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->setFling(Z)V

    .line 497
    invoke-virtual {p0, v0}, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->setPreAnimation(Z)V

    return-void
.end method

.method private setBufferSize(Landroid/view/ThreadedRenderer;Z)V
    .locals 6

    .line 537
    sget-boolean v0, Lcom/mediatek/boostfwk/utils/Config;->mIncreaseBuffer:Z

    const-string v1, "ScrollingFramePrefetcher"

    if-eqz v0, :cond_6

    if-eqz p1, :cond_6

    const-string v0, ", render = "

    const-string v2, ", isScrolling = "

    const/4 v3, -0x1

    if-eqz p2, :cond_4

    .line 540
    iget v4, p0, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->mDefaultBufferSize:I

    if-ne v4, v3, :cond_3

    .line 541
    invoke-virtual {p1}, Landroid/view/ThreadedRenderer;->getSurface()Landroid/view/Surface;

    move-result-object v4

    invoke-virtual {v4}, Landroid/view/Surface;->getBufferSize()I

    move-result v4

    const/16 v5, -0x16

    if-ne v4, v5, :cond_0

    const-string p0, "get buffer size error."

    .line 546
    invoke-static {v1, p0}, Lcom/mediatek/boostfwk/utils/LogUtil;->mLoge(Ljava/lang/String;Ljava/lang/String;)V

    return-void

    :cond_0
    const/4 v5, 0x5

    if-ge v4, v5, :cond_7

    .line 549
    iget v5, p0, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->mDefaultBufferSize:I

    if-ne v5, v3, :cond_7

    .line 550
    iput v4, p0, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->mDefaultBufferSize:I

    .line 554
    iget v5, p0, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->mLastBufferSize:I

    if-eq v5, v3, :cond_1

    if-eq v4, v5, :cond_1

    .line 556
    iput v5, p0, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->mDefaultBufferSize:I

    .line 557
    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "reset buffer size to last "

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v4, p0, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->mDefaultBufferSize:I

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-static {v1, v3}, Lcom/mediatek/boostfwk/utils/LogUtil;->mLogd(Ljava/lang/String;Ljava/lang/String;)V

    .line 560
    :cond_1
    sget-boolean v3, Lcom/mediatek/boostfwk/utils/LogUtil;->DEBUG:Z

    if-eqz v3, :cond_2

    .line 561
    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "set buffer size = "

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v4, p0, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->mDefaultBufferSize:I

    add-int/lit8 v4, v4, 0x2

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v3, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3, p2}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {v3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-static {v1, p2}, Lcom/mediatek/boostfwk/utils/LogUtil;->mLogd(Ljava/lang/String;Ljava/lang/String;)V

    .line 564
    :cond_2
    invoke-virtual {p1}, Landroid/view/ThreadedRenderer;->getSurface()Landroid/view/Surface;

    move-result-object p1

    iget p0, p0, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->mDefaultBufferSize:I

    add-int/lit8 p0, p0, 0x2

    invoke-virtual {p1, p0}, Landroid/view/Surface;->setBufferSize(I)V

    goto :goto_0

    :cond_3
    return-void

    .line 567
    :cond_4
    iget v4, p0, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->mDefaultBufferSize:I

    if-eq v4, v3, :cond_7

    .line 568
    invoke-virtual {p1}, Landroid/view/ThreadedRenderer;->getSurface()Landroid/view/Surface;

    move-result-object v4

    iget v5, p0, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->mDefaultBufferSize:I

    invoke-virtual {v4, v5}, Landroid/view/Surface;->setBufferSize(I)V

    .line 569
    iget v4, p0, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->mDefaultBufferSize:I

    iput v4, p0, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->mLastBufferSize:I

    .line 570
    sget-boolean v4, Lcom/mediatek/boostfwk/utils/LogUtil;->DEBUG:Z

    if-eqz v4, :cond_5

    .line 571
    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    const-string v5, "reset buffer size = "

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v5, p0, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->mDefaultBufferSize:I

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v4, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4, p2}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {v4, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-static {v1, p1}, Lcom/mediatek/boostfwk/utils/LogUtil;->mLogd(Ljava/lang/String;Ljava/lang/String;)V

    .line 574
    :cond_5
    iput v3, p0, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->mDefaultBufferSize:I

    goto :goto_0

    :cond_6
    const-string p0, "render=null, set buffer size error"

    .line 578
    invoke-static {v1, p0}, Lcom/mediatek/boostfwk/utils/LogUtil;->mLogd(Ljava/lang/String;Ljava/lang/String;)V

    :cond_7
    :goto_0
    return-void
.end method

.method private updateDynaFrameStatus(IJ)V
    .locals 1

    if-eqz p1, :cond_2

    const/4 v0, 0x1

    if-eq p1, v0, :cond_1

    const/4 p2, 0x2

    if-eq p1, p2, :cond_0

    goto :goto_0

    .line 387
    :cond_0
    invoke-direct {p0}, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->resetStatus()V

    goto :goto_0

    .line 384
    :cond_1
    invoke-direct {p0, p2, p3}, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->dropFrameStatus(J)V

    goto :goto_0

    .line 381
    :cond_2
    invoke-direct {p0, p2, p3}, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->firstFrameStatus(J)V

    :goto_0
    return-void
.end method

.method private updateFlingStatus(ZJ)V
    .locals 0

    .line 361
    iget-boolean p2, p0, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->mIsFling:Z

    if-eq p2, p1, :cond_1

    .line 362
    sget-boolean p2, Lcom/mediatek/boostfwk/utils/LogUtil;->DEBUG:Z

    if-eqz p2, :cond_0

    .line 363
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string p3, "ScrollingFramePrefetcher#updateFlingStatus, mIsFling = "

    invoke-virtual {p2, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-boolean p3, p0, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->mIsFling:Z

    invoke-virtual {p2, p3}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string p3, ", isFling = "

    invoke-virtual {p2, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2, p1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-static {p2}, Lcom/mediatek/boostfwk/utils/LogUtil;->trace(Ljava/lang/String;)V

    .line 366
    :cond_0
    iput-boolean p1, p0, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->mIsFling:Z

    const/4 p1, 0x2

    const-wide/16 p2, 0x0

    .line 367
    invoke-direct {p0, p1, p2, p3}, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->updateDynaFrameStatus(IJ)V

    .line 368
    iget-boolean p1, p0, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->mIsFling:Z

    if-nez p1, :cond_1

    const/4 p1, 0x0

    .line 369
    iput-object p1, p0, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->mChoreographer:Ljava/lang/ref/WeakReference;

    :cond_1
    return-void
.end method

.method private updateFrameIntervalNanos()V
    .locals 4

    .line 442
    invoke-static {}, Lcom/mediatek/boostfwk/info/ScrollState;->getRefreshRate()F

    move-result v0

    const v1, 0x4e6e6b28    # 1.0E9f

    div-float/2addr v1, v0

    float-to-long v0, v1

    .line 443
    iget-wide v2, p0, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->mFrameIntervalNanos:J

    cmp-long v2, v2, v0

    if-eqz v2, :cond_0

    .line 444
    iput-wide v0, p0, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->mFrameIntervalNanos:J

    :cond_0
    return-void
.end method


# virtual methods
.method public disableAndLockSFP(Z)V
    .locals 1

    const-string v0, "resetAndLockSFP"

    .line 489
    invoke-static {v0}, Lcom/mediatek/boostfwk/utils/LogUtil;->traceBegin(Ljava/lang/String;)V

    .line 490
    sput-boolean p1, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->mFeatureLocked:Z

    .line 491
    invoke-direct {p0}, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->resetStatusWhenScroll()V

    .line 492
    invoke-static {}, Lcom/mediatek/boostfwk/utils/LogUtil;->traceEnd()V

    return-void
.end method

.method public doScrollingFramePrefetcher(Lcom/mediatek/boostfwk/scenario/frame/FrameScenario;)V
    .locals 3

    .line 148
    invoke-virtual {p1}, Lcom/mediatek/boostfwk/scenario/frame/FrameScenario;->getOrigFrameTime()J

    move-result-wide v0

    invoke-virtual {p1}, Lcom/mediatek/boostfwk/scenario/frame/FrameScenario;->getFrameData()Landroid/view/Choreographer$FrameData;

    move-result-object v2

    invoke-direct {p0, v0, v1, v2, p1}, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->estimationFrameTime(JLandroid/view/Choreographer$FrameData;Lcom/mediatek/boostfwk/scenario/frame/FrameScenario;)V

    return-void
.end method

.method public isPreAnimation()Z
    .locals 1

    .line 347
    sget-boolean v0, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->PRE_ANIM_ENABLE:Z

    if-nez v0, :cond_0

    const/4 p0, 0x0

    return p0

    .line 350
    :cond_0
    iget-boolean p0, p0, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->mIsPreAnim:Z

    return p0
.end method

.method public isPreAnimationRunning()Z
    .locals 0

    .line 505
    iget-boolean p0, p0, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->mIsPreAnimationRunning:Z

    return p0
.end method

.method public onFrameEnd(ZLcom/mediatek/boostfwk/scenario/frame/FrameScenario;)V
    .locals 13

    .line 232
    invoke-direct {p0}, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->disableSFP()Z

    move-result v0

    if-nez v0, :cond_b

    if-nez p1, :cond_b

    iget-object v0, p0, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->mChoreographer:Ljava/lang/ref/WeakReference;

    if-nez v0, :cond_0

    goto/16 :goto_2

    .line 240
    :cond_0
    invoke-static {}, Lcom/mediatek/boostfwk/info/ScrollState;->getRefreshRate()F

    move-result p1

    const/high16 v0, 0x42b40000    # 90.0f

    cmpg-float p1, p1, v0

    const/4 v0, 0x0

    if-gez p1, :cond_2

    .line 241
    iget-boolean p1, p0, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->mNeedScheduleNextFrame:Z

    if-eqz p1, :cond_1

    .line 242
    iput-boolean v0, p0, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->mNeedScheduleNextFrame:Z

    .line 243
    invoke-direct {p0}, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->forceScheduleNexFrame()V

    :cond_1
    return-void

    .line 249
    :cond_2
    invoke-static {}, Ljava/lang/System;->nanoTime()J

    move-result-wide v8

    .line 250
    iget-wide v2, p0, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->mLastFrameTimeNano:J

    const-wide v6, 0x3ff6666666666666L    # 1.4

    move-object v1, p0

    move-wide v4, v8

    invoke-direct/range {v1 .. v7}, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->isDropFrame(JJD)Z

    move-result p1

    if-eqz p1, :cond_3

    .line 252
    sget-boolean v1, Lcom/mediatek/boostfwk/utils/LogUtil;->DEBUG:Z

    if-eqz v1, :cond_3

    const-string v1, "drop frame because this frame too long, will insert new frame when this frame end."

    goto :goto_0

    :cond_3
    const-string v1, ""

    :goto_0
    move-object v10, v1

    const-wide/16 v11, -0x1

    if-nez p1, :cond_4

    .line 257
    iget-wide v2, p0, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->mFrameEndTimeNano:J

    cmp-long v1, v2, v11

    if-eqz v1, :cond_4

    const-wide v6, 0x3ff6666666666666L    # 1.4

    move-object v1, p0

    move-wide v4, v8

    .line 258
    invoke-direct/range {v1 .. v7}, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->isDropFrame(JJD)Z

    move-result p1

    if-eqz p1, :cond_4

    .line 259
    sget-boolean v1, Lcom/mediatek/boostfwk/utils/LogUtil;->DEBUG:Z

    if-eqz v1, :cond_4

    const-string v10, "drop frame because time too long between last frame end with this,will insert new frame when this frame end."

    :cond_4
    const/4 v1, 0x1

    if-eqz p1, :cond_5

    .line 264
    iget-boolean v2, p0, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->mIsAnimDrop:Z

    if-nez v2, :cond_5

    .line 265
    iget-wide v2, p0, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->mLastFrameTimeNano:J

    .line 266
    invoke-direct {p0, v1, v2, v3}, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->updateDynaFrameStatus(IJ)V

    .line 268
    :cond_5
    sget-boolean v2, Lcom/mediatek/boostfwk/utils/LogUtil;->DEBUG:Z

    if-eqz v2, :cond_6

    .line 269
    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "ScrollingFramePrefetcher#onFrameEnd, is drop frame = "

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3, p1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string p1, ", mIsEstimationFrame = "

    invoke-virtual {v3, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-boolean p1, p0, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->mIsEstimationFrame:Z

    invoke-virtual {v3, p1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string p1, ", drop reason = "

    invoke-virtual {v3, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-static {p1}, Lcom/mediatek/boostfwk/utils/LogUtil;->trace(Ljava/lang/String;)V

    .line 272
    :cond_6
    iput-wide v8, p0, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->mFrameEndTimeNano:J

    .line 274
    invoke-virtual {p2}, Lcom/mediatek/boostfwk/scenario/frame/FrameScenario;->getFrameId()J

    move-result-wide p1

    cmp-long p1, p1, v11

    if-nez p1, :cond_7

    .line 277
    iget p1, p0, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->mEstimationFrameCount:I

    add-int/2addr p1, v1

    iput p1, p0, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->mEstimationFrameCount:I

    goto :goto_1

    .line 279
    :cond_7
    iput v0, p0, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->mEstimationFrameCount:I

    .line 284
    :goto_1
    iget-boolean p1, p0, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->mIsEstimationFrame:Z

    if-eqz p1, :cond_9

    .line 285
    iput-boolean v0, p0, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->mIsEstimationFrame:Z

    if-eqz v2, :cond_8

    .line 287
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string p2, "ScrollingFramePrefetcher#onFrameEnd, estimation frame time = "

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-wide v2, p0, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->mLastFrameTimeNano:J

    const-wide/32 v4, 0xf4240

    div-long/2addr v2, v4

    invoke-virtual {p1, v2, v3}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-static {p1}, Lcom/mediatek/boostfwk/utils/LogUtil;->trace(Ljava/lang/String;)V

    .line 290
    :cond_8
    iget p1, p0, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->mEstimationFrameCount:I

    const/4 p2, 0x5

    if-ge p1, p2, :cond_9

    iget-boolean p1, p0, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->mIsAnimDrop:Z

    if-nez p1, :cond_9

    .line 292
    iput-boolean v0, p0, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->mIsPreAnim:Z

    .line 293
    iput-boolean v0, p0, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->mAppRequestVsync:Z

    .line 294
    iget-wide p1, p0, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->mLastFrameTimeNano:J

    invoke-direct {p0, p1, p2}, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->doEstimationFrameHook(J)V

    .line 295
    iget-wide p1, p0, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->mLastFrameTimeNano:J

    invoke-direct {p0, p1, p2}, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->doPreAnimation(J)V

    .line 296
    iput-boolean v1, p0, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->mIsPreAnim:Z

    return-void

    .line 301
    :cond_9
    iget-boolean p1, p0, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->mIsPreAnim:Z

    if-eqz p1, :cond_a

    iget-boolean p1, p0, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->mIsAnimDrop:Z

    if-nez p1, :cond_a

    .line 302
    iget-wide p1, p0, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->mLastAnimFrameTimeNano:J

    invoke-direct {p0, p1, p2}, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->doPreAnimation(J)V

    :cond_a
    return-void

    .line 233
    :cond_b
    :goto_2
    sget-boolean p2, Lcom/mediatek/boostfwk/utils/LogUtil;->DEBUG:Z

    if-eqz p2, :cond_c

    .line 234
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "ScrollingFramePrefetcher#onFrameEnd, isFrameBegin = "

    invoke-virtual {p2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2, p1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string p1, ", mIsFling = "

    invoke-virtual {p2, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-boolean p1, p0, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->mIsFling:Z

    invoke-virtual {p2, p1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string p1, ", mChoreographer = "

    invoke-virtual {p2, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object p0, p0, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->mChoreographer:Ljava/lang/ref/WeakReference;

    invoke-virtual {p2, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p0}, Lcom/mediatek/boostfwk/utils/LogUtil;->trace(Ljava/lang/String;)V

    :cond_c
    return-void
.end method

.method public onRequestNextVsync()V
    .locals 1

    const/4 v0, 0x1

    .line 501
    iput-boolean v0, p0, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->mAppRequestVsync:Z

    return-void
.end method

.method public setFling(Z)V
    .locals 2

    const-wide/16 v0, 0x0

    .line 375
    invoke-direct {p0, p1, v0, v1}, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->updateFlingStatus(ZJ)V

    return-void
.end method

.method public setPreAnimation(Z)V
    .locals 1

    .line 354
    sget-boolean v0, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->PRE_ANIM_ENABLE:Z

    if-nez v0, :cond_0

    const/4 v0, 0x0

    .line 355
    iput-boolean v0, p0, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->mIsPreAnim:Z

    .line 357
    :cond_0
    iput-boolean p1, p0, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->mIsPreAnim:Z

    return-void
.end method
