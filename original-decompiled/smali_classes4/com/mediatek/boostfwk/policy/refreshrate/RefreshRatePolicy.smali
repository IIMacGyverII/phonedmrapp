.class public Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;
.super Ljava/lang/Object;
.source "RefreshRatePolicy.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy$WorkerHandler;
    }
.end annotation


# static fields
.field private static final DEFAULT_MIN_REFRESHRATE_CHANGE_VALUE:I = 0x3e8

.field private static final FLING_STOP_PROGRESS_THRESHOLED:F = 0.99f

.field private static final IDLE_DELAY_TIME:I = 0x7d0

.field private static final LIST_FINISH_THRESHOLED:I = 0x96

.field private static final LIST_STATE_FLING_FINISH:I = 0x2

.field private static final LIST_STATE_FLING_START:I = 0x0

.field private static final LIST_STATE_FLING_UPDATE:I = 0x1

.field private static final LIST_STATE_SCROLLER_INIT:I = 0x3

.field private static final MOTION_EVENT_ACTION_DEFAULT:I = -0x1

.field private static final MOTION_EVENT_ACTION_DOWN:I = 0x0

.field private static final MOTION_EVENT_ACTION_MOVE:I = 0x1

.field private static final MOTION_EVENT_ACTION_UP:I = 0x2

.field private static final MSG_ENTER_IDLE:I = 0x0

.field private static final REFRESH_RATE_IDLE:I = 0x3e8

.field private static final REFRESH_RATE_IME:I = 0x3eb

.field private static final REFRESH_RATE_INVALID:I = 0x270f

.field private static final REFRESH_RATE_TOUCH_SCROLL_DOWN:I = 0x3e9

.field private static final REFRESH_RATE_TOUCH_SCROLL_UP:I = 0x3e8

.field private static final SCENARIO_ACTION_DEFAULT:I = 0x0

.field private static final SCENARIO_ACTION_HIDE:I = 0x2

.field private static final SCENARIO_ACTION_SHOW:I = 0x1

.field private static final SCENARIO_TYPE_DEFAULT:I = 0x0

.field private static final SCENARIO_TYPE_IME:I = 0x1

.field private static final SCENARIO_TYPE_VOICE:I = 0x2

.field private static final TAG:Ljava/lang/String; = "MSYNC3-VariableRefreshRate"

.field private static final TOUCH_SCROLL_REFRESH_CHANGE_THRESHOLED:I = 0xc8

.field private static final TOUCH_SCROLL_REFRESH_DURATION_THRESHOLED:I = 0x12c

.field private static final TOUCH_SCROLL_REFRESH_VELOCITY_THRESHOLED:I = 0x64

.field private static final TOUCH_SCROLL_STATE_HIGH_SPEED:I = 0x0

.field private static final TOUCH_SCROLL_STATE_INVALID_SPEED:I = -0x1

.field private static final TOUCH_SCROLL_STATE_LOW_SPEED:I = 0x1

.field private static final TOUCH_SCROLL_VELOCITY_SAMPLE_COUNT:I = 0x5


# instance fields
.field private mActiveRefreshScenario:Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;

.field private mActivityHasVideoView:Z

.field private mClassLoader:Ldalvik/system/PathClassLoader;

.field private mCurrentMaxRefreshRate:I

.field private mCurrentTouchState:I

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

.field private mFlingRefreshRateVsyncTime:Ljava/util/ArrayList;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/ArrayList<",
            "Ljava/lang/Float;",
            ">;"
        }
    .end annotation
.end field

.field private mFlingSupportRefreshRateCount:I

.field private mFlingSupportedRefreshRate:Ljava/util/ArrayList;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/ArrayList<",
            "Ljava/lang/Integer;",
            ">;"
        }
    .end annotation
.end field

.field private mImeWindow:Ljava/lang/ref/WeakReference;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/lang/ref/WeakReference<",
            "Landroid/view/Window;",
            ">;"
        }
    .end annotation
.end field

.field private mIsDataInited:Z

.field private mLastRefreshChangeTime:J

.field private mLastTouchMovePointerY:F

.field private mMSyncSupportedByProcess:Z

.field private mRefreshRateInfo:Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRateInfo;

.field private mRefreshRatePolicyExt:Lcom/mediatek/boostfwk/policy/refreshrate/IRefreshRateEx;

.field private mSplinePositionCount:I

.field private mTouchDownPointerY:F

.field private mTouchDownTime:J

.field private mTouchDuration:J

.field private mTouchScrollSpeed:I

.field private mTouchScrollVelocityList:Ljava/util/ArrayList;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/ArrayList<",
            "Ljava/lang/Float;",
            ">;"
        }
    .end annotation
.end field

.field private mVelocityTracker:Landroid/view/VelocityTracker;

.field private mWorkerHandler:Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy$WorkerHandler;


# direct methods
.method static bridge synthetic -$$Nest$fgetmActiveRefreshScenario(Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;)Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;
    .locals 0

    iget-object p0, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->mActiveRefreshScenario:Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetmClassLoader(Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;)Ldalvik/system/PathClassLoader;
    .locals 0

    iget-object p0, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->mClassLoader:Ldalvik/system/PathClassLoader;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetmIsDataInited(Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;)Z
    .locals 0

    iget-boolean p0, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->mIsDataInited:Z

    return p0
.end method

.method static bridge synthetic -$$Nest$fgetmMSyncSupportedByProcess(Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;)Z
    .locals 0

    iget-boolean p0, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->mMSyncSupportedByProcess:Z

    return p0
.end method

.method static bridge synthetic -$$Nest$fgetmRefreshRateInfo(Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;)Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRateInfo;
    .locals 0

    iget-object p0, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->mRefreshRateInfo:Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRateInfo;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fputmActiveRefreshScenario(Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;)V
    .locals 0

    iput-object p1, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->mActiveRefreshScenario:Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;

    return-void
.end method

.method static bridge synthetic -$$Nest$fputmActivityHasVideoView(Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;Z)V
    .locals 0

    iput-boolean p1, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->mActivityHasVideoView:Z

    return-void
.end method

.method static bridge synthetic -$$Nest$fputmClassLoader(Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;Ldalvik/system/PathClassLoader;)V
    .locals 0

    iput-object p1, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->mClassLoader:Ldalvik/system/PathClassLoader;

    return-void
.end method

.method static bridge synthetic -$$Nest$fputmFlingRefreshRateChangeGap(Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;Ljava/util/ArrayList;)V
    .locals 0

    iput-object p1, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->mFlingRefreshRateChangeGap:Ljava/util/ArrayList;

    return-void
.end method

.method static bridge synthetic -$$Nest$fputmFlingRefreshRateChangeTimeOffset(Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;Ljava/util/ArrayList;)V
    .locals 0

    iput-object p1, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->mFlingRefreshRateChangeTimeOffset:Ljava/util/ArrayList;

    return-void
.end method

.method static bridge synthetic -$$Nest$fputmFlingRefreshRateVsyncTime(Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;Ljava/util/ArrayList;)V
    .locals 0

    iput-object p1, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->mFlingRefreshRateVsyncTime:Ljava/util/ArrayList;

    return-void
.end method

.method static bridge synthetic -$$Nest$fputmFlingSupportRefreshRateCount(Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;I)V
    .locals 0

    iput p1, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->mFlingSupportRefreshRateCount:I

    return-void
.end method

.method static bridge synthetic -$$Nest$fputmFlingSupportedRefreshRate(Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;Ljava/util/ArrayList;)V
    .locals 0

    iput-object p1, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->mFlingSupportedRefreshRate:Ljava/util/ArrayList;

    return-void
.end method

.method static bridge synthetic -$$Nest$fputmIsDataInited(Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;Z)V
    .locals 0

    iput-boolean p1, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->mIsDataInited:Z

    return-void
.end method

.method static bridge synthetic -$$Nest$fputmRefreshRatePolicyExt(Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;Lcom/mediatek/boostfwk/policy/refreshrate/IRefreshRateEx;)V
    .locals 0

    iput-object p1, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->mRefreshRatePolicyExt:Lcom/mediatek/boostfwk/policy/refreshrate/IRefreshRateEx;

    return-void
.end method

.method static bridge synthetic -$$Nest$mupdateRefreshRateWhenFling(Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;ILcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;)V
    .locals 0

    invoke-direct {p0, p1, p2}, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->updateRefreshRateWhenFling(ILcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;)V

    return-void
.end method

.method public constructor <init>()V
    .locals 5

    .line 150
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    const/4 v0, 0x0

    .line 76
    iput-object v0, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->mActiveRefreshScenario:Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;

    .line 77
    iput-object v0, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->mRefreshRateInfo:Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRateInfo;

    .line 78
    iput-object v0, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->mWorkerHandler:Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy$WorkerHandler;

    const/4 v1, 0x0

    .line 79
    iput-boolean v1, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->mIsDataInited:Z

    const/4 v2, 0x1

    .line 80
    iput-boolean v2, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->mMSyncSupportedByProcess:Z

    .line 81
    iput-boolean v1, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->mActivityHasVideoView:Z

    .line 82
    iput-object v0, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->mRefreshRatePolicyExt:Lcom/mediatek/boostfwk/policy/refreshrate/IRefreshRateEx;

    const/4 v2, -0x1

    .line 86
    iput v2, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->mCurrentMaxRefreshRate:I

    .line 103
    iput v1, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->mTouchScrollSpeed:I

    const-wide/16 v3, 0x0

    .line 104
    iput-wide v3, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->mLastRefreshChangeTime:J

    .line 105
    iput v2, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->mCurrentTouchState:I

    .line 106
    iput-object v0, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->mVelocityTracker:Landroid/view/VelocityTracker;

    .line 107
    iput-wide v3, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->mTouchDownTime:J

    .line 108
    iput-wide v3, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->mTouchDuration:J

    .line 122
    new-instance v0, Ljava/util/ArrayList;

    const/4 v1, 0x5

    invoke-direct {v0, v1}, Ljava/util/ArrayList;-><init>(I)V

    iput-object v0, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->mTouchScrollVelocityList:Ljava/util/ArrayList;

    .line 151
    new-instance v0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRateInfo;

    invoke-direct {v0}, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRateInfo;-><init>()V

    iput-object v0, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->mRefreshRateInfo:Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRateInfo;

    .line 152
    invoke-virtual {p0}, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->registerActivityListener()V

    .line 153
    new-instance v0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy$WorkerHandler;

    invoke-static {}, Landroid/os/Looper;->getMainLooper()Landroid/os/Looper;

    move-result-object v1

    invoke-direct {v0, p0, v1}, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy$WorkerHandler;-><init>(Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;Landroid/os/Looper;)V

    iput-object v0, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->mWorkerHandler:Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy$WorkerHandler;

    return-void
.end method

.method private adjustVelocity(F)F
    .locals 6

    .line 348
    invoke-static {}, Landroid/os/SystemClock;->uptimeMillis()J

    move-result-wide v0

    iget-wide v2, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->mTouchDownTime:J

    sub-long/2addr v0, v2

    .line 349
    iget v2, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->mTouchDownPointerY:F

    iget p0, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->mLastTouchMovePointerY:F

    sub-float/2addr v2, p0

    long-to-float p0, v0

    div-float p0, v2, p0

    const/high16 v3, 0x447a0000    # 1000.0f

    mul-float/2addr p0, v3

    div-float v3, p1, p0

    .line 352
    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    const-string v5, "adjustVelocity  velocity = "

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4, p1}, Ljava/lang/StringBuilder;->append(F)Ljava/lang/StringBuilder;

    const-string v5, " touchScrollTime = "

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4, v0, v1}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    const-string v5, " deltaY = "

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4, v2}, Ljava/lang/StringBuilder;->append(F)Ljava/lang/StringBuilder;

    const-string v5, " result = "

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4, v3}, Ljava/lang/StringBuilder;->append(F)Ljava/lang/StringBuilder;

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v4

    const-string v5, "MSYNC3-VariableRefreshRate"

    invoke-static {v5, v4}, Lcom/mediatek/boostfwk/utils/LogUtil;->mLogd(Ljava/lang/String;Ljava/lang/String;)V

    const-wide/16 v4, 0xc8

    cmp-long v0, v0, v4

    if-gez v0, :cond_0

    .line 357
    invoke-static {v2}, Ljava/lang/Math;->abs(F)F

    move-result v0

    const/high16 v1, 0x43c80000    # 400.0f

    cmpg-float v0, v0, v1

    if-gez v0, :cond_0

    invoke-static {v3}, Ljava/lang/Math;->abs(F)F

    move-result v0

    float-to-double v0, v0

    const-wide/high16 v2, 0x4004000000000000L    # 2.5

    cmpl-double v0, v0, v2

    if-lez v0, :cond_0

    float-to-double v0, p0

    mul-double/2addr v0, v2

    double-to-float p0, v0

    .line 358
    invoke-static {p1}, Ljava/lang/Math;->signum(F)F

    move-result p1

    mul-float/2addr p1, p0

    :cond_0
    return p1
.end method

.method private boostToMaxRefreshRate(Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;I)V
    .locals 2

    .line 550
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "boostToMaxRefreshRate change oldRefreshRate = "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 551
    invoke-virtual {p1}, Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;->getCurrentRefreshrate()I

    move-result v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, " New RefreshRate = "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    const-string v1, "MSYNC3-VariableRefreshRate"

    .line 550
    invoke-static {v1, v0}, Lcom/mediatek/boostfwk/utils/LogUtil;->mLogd(Ljava/lang/String;Ljava/lang/String;)V

    const/4 v0, 0x0

    .line 553
    invoke-direct {p0, p1, p2, v0, v0}, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->updateRefreshInternal(Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;III)Z

    return-void
.end method

.method private calculateAverage(Ljava/util/ArrayList;)F
    .locals 1
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/ArrayList<",
            "Ljava/lang/Float;",
            ">;)F"
        }
    .end annotation

    .line 640
    invoke-virtual {p1}, Ljava/util/ArrayList;->iterator()Ljava/util/Iterator;

    move-result-object p0

    const/4 p1, 0x0

    :goto_0
    invoke-interface {p0}, Ljava/util/Iterator;->hasNext()Z

    move-result v0

    if-eqz v0, :cond_0

    invoke-interface {p0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/lang/Float;

    invoke-virtual {v0}, Ljava/lang/Float;->floatValue()F

    move-result v0

    add-float/2addr p1, v0

    goto :goto_0

    :cond_0
    const/high16 p0, 0x40a00000    # 5.0f

    div-float/2addr p1, p0

    return p1
.end method

.method private getIMEWindow()Landroid/view/Window;
    .locals 0

    .line 815
    iget-object p0, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->mImeWindow:Ljava/lang/ref/WeakReference;

    if-nez p0, :cond_0

    const/4 p0, 0x0

    return-object p0

    .line 818
    :cond_0
    invoke-virtual {p0}, Ljava/lang/ref/WeakReference;->get()Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Landroid/view/Window;

    return-object p0
.end method

.method private getSplineDeceleration(Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;)D
    .locals 1

    .line 480
    iget-object p0, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->mRefreshRateInfo:Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRateInfo;

    invoke-virtual {p0}, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRateInfo;->getInflextion()F

    move-result p0

    .line 481
    invoke-virtual {p1}, Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;->getCurrentVelocity()F

    move-result v0

    invoke-static {v0}, Ljava/lang/Math;->abs(F)F

    move-result v0

    mul-float/2addr p0, v0

    .line 482
    invoke-virtual {p1}, Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;->getFlingFriction()F

    move-result v0

    invoke-virtual {p1}, Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;->getPhysicalCoeff()F

    move-result p1

    mul-float/2addr v0, p1

    div-float/2addr p0, v0

    float-to-double p0, p0

    .line 480
    invoke-static {p0, p1}, Ljava/lang/Math;->log(D)D

    move-result-wide p0

    return-wide p0
.end method

.method private getSplineFlingDistance(Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;)D
    .locals 10

    .line 486
    invoke-direct {p0, p1}, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->getSplineDeceleration(Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;)D

    move-result-wide v0

    .line 487
    sget v2, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRateInfo;->DECELERATION_RATE:F

    float-to-double v3, v2

    const-wide/high16 v5, 0x3ff0000000000000L    # 1.0

    sub-double/2addr v3, v5

    .line 490
    invoke-virtual {p1}, Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;->getCurrentVelocity()F

    move-result v7

    .line 489
    invoke-static {v7}, Ljava/lang/Math;->abs(F)F

    move-result v7

    iget-object v8, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->mRefreshRateInfo:Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRateInfo;

    .line 490
    invoke-virtual {v8}, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRateInfo;->getMaximumVelocity()F

    move-result v8

    div-float/2addr v7, v8

    .line 492
    iget p0, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->mSplinePositionCount:I

    int-to-float v8, p0

    mul-float/2addr v8, v7

    float-to-int v8, v8

    if-le v8, p0, :cond_0

    goto :goto_0

    :cond_0
    move p0, v8

    :goto_0
    const/high16 v8, 0x3f800000    # 1.0f

    .line 496
    invoke-virtual {p1}, Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;->getRealSplinePosition()[F

    move-result-object v9

    aget p0, v9, p0

    sub-float/2addr v8, p0

    const/high16 p0, 0x40600000    # 3.5f

    mul-float/2addr v8, p0

    const p0, 0x3fd33333    # 1.65f

    add-float/2addr v8, p0

    float-to-double v8, v8

    .line 499
    invoke-static {}, Lcom/mediatek/boostfwk/utils/Config;->isMSync3SmoothFlingEnabled()Z

    move-result p0

    if-nez p0, :cond_1

    goto :goto_1

    :cond_1
    move-wide v5, v8

    .line 502
    :goto_1
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v8, "getSplineFlingDistance tuningValue = "

    invoke-virtual {p0, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, v5, v6}, Ljava/lang/StringBuilder;->append(D)Ljava/lang/StringBuilder;

    const-string v8, " rate = "

    invoke-virtual {p0, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, v7}, Ljava/lang/StringBuilder;->append(F)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    const-string v7, "MSYNC3-VariableRefreshRate"

    invoke-static {v7, p0}, Lcom/mediatek/boostfwk/utils/LogUtil;->mLogd(Ljava/lang/String;Ljava/lang/String;)V

    .line 505
    invoke-virtual {p1}, Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;->getFlingFriction()F

    move-result p0

    float-to-double v7, p0

    mul-double/2addr v7, v5

    .line 506
    invoke-virtual {p1}, Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;->getPhysicalCoeff()F

    move-result p0

    float-to-double p0, p0

    mul-double/2addr v7, p0

    float-to-double p0, v2

    div-double/2addr p0, v3

    mul-double/2addr p0, v0

    .line 507
    invoke-static {p0, p1}, Ljava/lang/Math;->exp(D)D

    move-result-wide p0

    mul-double/2addr v7, p0

    return-wide v7
.end method

.method private getSplineFlingDuration(Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;)I
    .locals 8

    .line 512
    invoke-direct {p0, p1}, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->getSplineDeceleration(Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;)D

    move-result-wide v0

    .line 513
    sget v2, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRateInfo;->DECELERATION_RATE:F

    float-to-double v2, v2

    const-wide/high16 v4, 0x3ff0000000000000L    # 1.0

    sub-double/2addr v2, v4

    .line 516
    invoke-virtual {p1}, Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;->getCurrentVelocity()F

    move-result v6

    .line 515
    invoke-static {v6}, Ljava/lang/Math;->abs(F)F

    move-result v6

    iget-object v7, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->mRefreshRateInfo:Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRateInfo;

    .line 516
    invoke-virtual {v7}, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRateInfo;->getMaximumVelocity()F

    move-result v7

    div-float/2addr v6, v7

    .line 519
    iget p0, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->mSplinePositionCount:I

    int-to-float v7, p0

    mul-float/2addr v7, v6

    float-to-int v7, v7

    if-le v7, p0, :cond_0

    goto :goto_0

    :cond_0
    move p0, v7

    :goto_0
    const/high16 v7, 0x3f800000    # 1.0f

    .line 523
    invoke-virtual {p1}, Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;->getRealSplinePosition()[F

    move-result-object p1

    aget p0, p1, p0

    sub-float/2addr v7, p0

    const/high16 p0, 0x41100000    # 9.0f

    mul-float/2addr v7, p0

    const p0, 0x3fd33333    # 1.65f

    add-float/2addr v7, p0

    float-to-double p0, v7

    .line 526
    invoke-static {}, Lcom/mediatek/boostfwk/utils/Config;->isMSync3SmoothFlingEnabled()Z

    move-result v7

    if-nez v7, :cond_1

    goto :goto_1

    :cond_1
    move-wide v4, p0

    .line 530
    :goto_1
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0}, Ljava/lang/StringBuilder;-><init>()V

    const-string p1, "getSplineFlingDuration tuningValue = "

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, v4, v5}, Ljava/lang/StringBuilder;->append(D)Ljava/lang/StringBuilder;

    const-string p1, " rate = "

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, v6}, Ljava/lang/StringBuilder;->append(F)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    const-string p1, "MSYNC3-VariableRefreshRate"

    invoke-static {p1, p0}, Lcom/mediatek/boostfwk/utils/LogUtil;->mLogd(Ljava/lang/String;Ljava/lang/String;)V

    const-wide p0, 0x408f400000000000L    # 1000.0

    mul-double/2addr v4, p0

    div-double/2addr v0, v2

    .line 532
    invoke-static {v0, v1}, Ljava/lang/Math;->exp(D)D

    move-result-wide p0

    mul-double/2addr v4, p0

    double-to-int p0, v4

    return p0
.end method

.method private getTouchScrollState()I
    .locals 2

    .line 757
    invoke-static {}, Lcom/mediatek/boostfwk/utils/Util;->getRefreshRate()F

    move-result v0

    float-to-int v0, v0

    .line 758
    iget-object v1, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->mRefreshRateInfo:Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRateInfo;

    invoke-virtual {v1}, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRateInfo;->getMaxFlingSupportedRefreshRate()I

    move-result v1

    if-ne v0, v1, :cond_0

    const/4 p0, 0x0

    return p0

    .line 760
    :cond_0
    iget-object p0, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->mRefreshRateInfo:Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRateInfo;

    invoke-virtual {p0}, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRateInfo;->getSlowScrollRefreshRate()I

    move-result p0

    if-ne v0, p0, :cond_1

    const/4 p0, 0x1

    return p0

    :cond_1
    const/4 p0, -0x1

    return p0
.end method

.method private onListFlingFinished(Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;)V
    .locals 9

    .line 435
    invoke-virtual {p1}, Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;->getCurrentFlingState()I

    move-result v0

    const/4 v1, 0x2

    const/4 v2, 0x1

    if-eq v0, v2, :cond_0

    .line 436
    invoke-virtual {p1, v1}, Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;->setCurrentFlingState(I)Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;

    return-void

    .line 440
    :cond_0
    invoke-static {}, Landroid/os/SystemClock;->uptimeMillis()J

    move-result-wide v3

    invoke-virtual {p1, v3, v4}, Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;->setLastFlingFinishTime(J)Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;

    .line 441
    invoke-virtual {p1}, Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;->getDistanceCoef()F

    move-result v0

    const v3, 0x3f7d70a4    # 0.99f

    cmpl-float v0, v0, v3

    const-string v3, "MSYNC3-VariableRefreshRate"

    const/4 v4, 0x0

    if-lez v0, :cond_1

    const/16 v0, 0x3e8

    .line 442
    invoke-direct {p0, v0, p1}, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->updateRefreshRateWhenFling(ILcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;)V

    .line 444
    invoke-virtual {p1, v4}, Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;->setTouchScrollEnabled(Z)Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;

    const-string p0, "onListFlingFinished List stop by self"

    .line 445
    invoke-static {v3, p0}, Lcom/mediatek/boostfwk/utils/LogUtil;->mLogd(Ljava/lang/String;Ljava/lang/String;)V

    goto :goto_0

    .line 446
    :cond_1
    invoke-static {}, Landroid/os/SystemClock;->uptimeMillis()J

    move-result-wide v5

    invoke-virtual {p1}, Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;->getLastTouchDownTime()J

    move-result-wide v7

    sub-long/2addr v5, v7

    const-wide/16 v7, 0x96

    cmp-long v0, v5, v7

    if-gez v0, :cond_2

    .line 449
    invoke-virtual {p1, v2}, Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;->setTouchScrollEnabled(Z)Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;

    const-string p0, "onListFlingFinished List stop by touch event"

    .line 450
    invoke-static {v3, p0}, Lcom/mediatek/boostfwk/utils/LogUtil;->mLogd(Ljava/lang/String;Ljava/lang/String;)V

    goto :goto_0

    .line 453
    :cond_2
    iget-object v0, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->mWorkerHandler:Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy$WorkerHandler;

    invoke-virtual {v0, v4}, Landroid/os/Handler;->removeMessages(I)V

    .line 454
    invoke-virtual {p1, v4}, Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;->setTouchScrollEnabled(Z)Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;

    .line 455
    iget-object p0, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->mWorkerHandler:Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy$WorkerHandler;

    invoke-virtual {p0, v4, v7, v8}, Landroid/os/Handler;->sendEmptyMessageDelayed(IJ)Z

    const-string p0, "onListFlingFinished List stop by other reason"

    .line 456
    invoke-static {v3, p0}, Lcom/mediatek/boostfwk/utils/LogUtil;->mLogd(Ljava/lang/String;Ljava/lang/String;)V

    .line 459
    :goto_0
    invoke-virtual {p1, v1}, Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;->setCurrentFlingState(I)Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;

    move-result-object p0

    .line 460
    invoke-virtual {p0, v4}, Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;->setFlingRefreshRateChangeIndex(I)Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;

    move-result-object p0

    .line 461
    invoke-virtual {p0, v4}, Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;->setRefreshRateChangeEnabledWhenFling(Z)Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;

    move-result-object p0

    const/4 p1, 0x0

    .line 462
    invoke-virtual {p0, p1}, Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;->setDistanceCoef(F)Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;

    return-void
.end method

.method private onListFlingStart(Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;)V
    .locals 8

    const-string v0, "MSYNC3-VariableRefreshRate"

    const-string v1, "List fling start"

    .line 300
    invoke-static {v0, v1}, Lcom/mediatek/boostfwk/utils/LogUtil;->mLogi(Ljava/lang/String;Ljava/lang/String;)V

    .line 301
    iput-object p1, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->mActiveRefreshScenario:Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;

    .line 303
    invoke-virtual {p1}, Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;->getCurrentVelocity()F

    move-result v1

    .line 304
    invoke-static {}, Lcom/mediatek/boostfwk/utils/Util;->getRefreshRate()F

    const/4 v2, 0x1

    .line 306
    invoke-virtual {p1, v2}, Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;->setTouchScrollEnabled(Z)Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;

    const/4 v3, 0x0

    .line 307
    invoke-virtual {p1, v3}, Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;->setCurrentFlingState(I)Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;

    .line 309
    invoke-direct {p0}, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->getTouchScrollState()I

    move-result v4

    const/4 v5, -0x1

    if-eq v4, v5, :cond_1

    .line 311
    invoke-static {v1}, Ljava/lang/Math;->abs(F)F

    move-result v5

    const/high16 v6, 0x447a0000    # 1000.0f

    cmpg-float v5, v5, v6

    if-gez v5, :cond_0

    goto :goto_0

    .line 317
    :cond_0
    invoke-virtual {p1, v4}, Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;->setFlingRefreshRateChangeIndex(I)Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;

    move-result-object v3

    iget-object v5, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->mFlingSupportedRefreshRate:Ljava/util/ArrayList;

    .line 319
    invoke-virtual {v5, v4}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v5

    check-cast v5, Ljava/lang/Integer;

    invoke-virtual {v5}, Ljava/lang/Integer;->intValue()I

    move-result v5

    .line 318
    invoke-virtual {v3, v5}, Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;->setCurrentRefreshrate(I)Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;

    move-result-object v3

    .line 320
    invoke-virtual {v3, v2}, Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;->setRefreshRateChangeEnabledWhenFling(Z)Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;

    .line 321
    iget-object v2, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->mRefreshRateInfo:Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRateInfo;

    invoke-virtual {v2}, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRateInfo;->getMaxFlingSupportedRefreshRate()I

    move-result v2

    iput v2, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->mCurrentMaxRefreshRate:I

    .line 322
    iget-object v2, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->mFlingSupportedRefreshRate:Ljava/util/ArrayList;

    .line 323
    invoke-virtual {v2, v4}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Ljava/lang/Integer;

    invoke-virtual {v2}, Ljava/lang/Integer;->intValue()I

    move-result v2

    .line 322
    invoke-direct {p0, p1, v2}, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->boostToMaxRefreshRate(Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;I)V

    goto :goto_1

    .line 312
    :cond_1
    :goto_0
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "Current refresh rate not match  Current device refresh rate = "

    invoke-virtual {v2, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 313
    invoke-static {}, Lcom/mediatek/boostfwk/utils/Util;->getRefreshRate()F

    move-result v4

    invoke-virtual {v2, v4}, Ljava/lang/StringBuilder;->append(F)Ljava/lang/StringBuilder;

    const-string v4, " Max refresh rate = "

    invoke-virtual {v2, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v4, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->mRefreshRateInfo:Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRateInfo;

    .line 314
    invoke-virtual {v4}, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRateInfo;->getMaxFlingSupportedRefreshRate()I

    move-result v4

    invoke-virtual {v2, v4}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    .line 312
    invoke-static {v0, v2}, Lcom/mediatek/boostfwk/utils/LogUtil;->mLogd(Ljava/lang/String;Ljava/lang/String;)V

    .line 315
    invoke-virtual {p1, v3}, Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;->setRefreshRateChangeEnabledWhenFling(Z)Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;

    :goto_1
    const/4 v2, 0x0

    cmpl-float v3, v1, v2

    if-eqz v3, :cond_2

    .line 327
    invoke-direct {p0, v1}, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->adjustVelocity(F)F

    move-result v3

    invoke-virtual {p1, v3}, Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;->setCurrentVelocity(F)Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;

    .line 329
    invoke-direct {p0, p1}, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->getSplineFlingDuration(Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;)I

    move-result v3

    .line 330
    invoke-direct {p0, p1}, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->getSplineFlingDistance(Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;)D

    move-result-wide v4

    invoke-static {v4, v5}, Ljava/lang/Double;->valueOf(D)Ljava/lang/Double;

    move-result-object p0

    .line 331
    invoke-virtual {p0}, Ljava/lang/Double;->doubleValue()D

    move-result-wide v4

    invoke-static {v1}, Ljava/lang/Math;->signum(F)F

    move-result v6

    float-to-double v6, v6

    mul-double/2addr v4, v6

    double-to-int v4, v4

    .line 333
    invoke-virtual {p1, v3}, Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;->setSplineDuration(I)Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;

    move-result-object v3

    .line 334
    invoke-virtual {p0}, Ljava/lang/Double;->doubleValue()D

    move-result-wide v5

    invoke-virtual {v3, v5, v6}, Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;->setSplineFlingDistance(D)Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;

    move-result-object p0

    .line 335
    invoke-virtual {p0, v4}, Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;->setSplineDistance(I)Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;

    move-result-object p0

    .line 336
    invoke-virtual {p0, v2}, Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;->setDistanceCoef(F)Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;

    .line 339
    :cond_2
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "onListFlingStart action = FLING_START velocity = "

    invoke-virtual {p0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, v1}, Ljava/lang/StringBuilder;->append(F)Ljava/lang/StringBuilder;

    const-string v1, " mSplineDuration = "

    invoke-virtual {p0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 341
    invoke-virtual {p1}, Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;->getSplineDuration()I

    move-result v1

    invoke-virtual {p0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, " mSplineFlingDistance = "

    invoke-virtual {p0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 342
    invoke-virtual {p1}, Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;->getSplineFlingDistance()D

    move-result-wide v1

    invoke-virtual {p0, v1, v2}, Ljava/lang/StringBuilder;->append(D)Ljava/lang/StringBuilder;

    const-string v1, " mSplineDistance = "

    invoke-virtual {p0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 343
    invoke-virtual {p1}, Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;->getSplineDistance()I

    move-result p1

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    .line 339
    invoke-static {v0, p0}, Lcom/mediatek/boostfwk/utils/LogUtil;->mLogd(Ljava/lang/String;Ljava/lang/String;)V

    return-void
.end method

.method private onListFlingUpdate(Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;)V
    .locals 20

    move-object/from16 v0, p0

    move-object/from16 v1, p1

    const/4 v2, 0x1

    .line 364
    invoke-virtual {v1, v2}, Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;->setCurrentFlingState(I)Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;

    .line 366
    invoke-virtual/range {p1 .. p1}, Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;->getCurrentTime()J

    move-result-wide v4

    .line 367
    invoke-virtual/range {p1 .. p1}, Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;->getSplineDuration()I

    move-result v13

    .line 368
    invoke-virtual/range {p1 .. p1}, Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;->getSplineDistance()I

    move-result v14

    .line 369
    invoke-virtual/range {p1 .. p1}, Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;->getRealSplinePosition()[F

    move-result-object v16

    .line 370
    invoke-virtual/range {p1 .. p1}, Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;->getFlingRefreshRateChangeIndex()I

    move-result v15

    .line 371
    invoke-virtual/range {p1 .. p1}, Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;->getCurrentRefreshrate()I

    move-result v3

    long-to-float v6, v4

    int-to-float v7, v13

    div-float/2addr v6, v7

    .line 375
    iget v8, v0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->mSplinePositionCount:I

    int-to-float v9, v8

    mul-float/2addr v9, v6

    float-to-int v9, v9

    if-ge v9, v8, :cond_0

    int-to-float v10, v9

    int-to-float v11, v8

    div-float/2addr v10, v11

    add-int/lit8 v11, v9, 0x1

    int-to-float v12, v11

    int-to-float v8, v8

    div-float/2addr v12, v8

    .line 381
    aget v8, v16, v9

    .line 382
    aget v11, v16, v11

    sub-float/2addr v11, v8

    sub-float/2addr v12, v10

    div-float/2addr v11, v12

    sub-float/2addr v6, v10

    mul-float/2addr v6, v11

    add-float/2addr v8, v6

    goto :goto_0

    :cond_0
    const/high16 v8, 0x3f800000    # 1.0f

    const/4 v11, 0x0

    :goto_0
    int-to-float v6, v14

    mul-float v10, v8, v6

    move v12, v3

    float-to-double v2, v10

    mul-float/2addr v11, v6

    div-float/2addr v11, v7

    const/high16 v6, 0x447a0000    # 1000.0f

    mul-float/2addr v11, v6

    .line 389
    invoke-virtual {v1, v2, v3}, Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;->setCurrentDistance(D)Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;

    move-result-object v6

    .line 390
    invoke-virtual {v6, v11}, Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;->setCurrentVelocity(F)Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;

    move-result-object v6

    .line 391
    invoke-virtual {v6, v8}, Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;->setDistanceCoef(F)Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;

    .line 393
    new-instance v6, Ljava/lang/StringBuilder;

    invoke-direct {v6}, Ljava/lang/StringBuilder;-><init>()V

    const-string v7, "onListFlingUpdate  flingRefreshRateChangeIndex = "

    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v6, v15}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v7, " currentRefreshRate = "

    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v6, v12}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v7, " distanceCoef = "

    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v6, v8}, Ljava/lang/StringBuilder;->append(F)Ljava/lang/StringBuilder;

    const-string v7, " currentDistance = "

    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v6, v2, v3}, Ljava/lang/StringBuilder;->append(D)Ljava/lang/StringBuilder;

    const-string v2, " index = "

    invoke-virtual {v6, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v6, v9}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v6}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    const-string v11, "MSYNC3-VariableRefreshRate"

    invoke-static {v11, v2}, Lcom/mediatek/boostfwk/utils/LogUtil;->mLogd(Ljava/lang/String;Ljava/lang/String;)V

    .line 400
    invoke-virtual/range {p1 .. p1}, Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;->getRefreshRateChangeEnabledWhenFling()Z

    move-result v2

    if-eqz v2, :cond_4

    iget v2, v0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->mFlingSupportRefreshRateCount:I

    const/4 v3, 0x1

    sub-int/2addr v2, v3

    if-lt v15, v2, :cond_1

    goto/16 :goto_1

    .line 404
    :cond_1
    invoke-virtual/range {p1 .. p1}, Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;->hasVideo()Z

    move-result v2

    if-nez v2, :cond_2

    iget-boolean v2, v0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->mActivityHasVideoView:Z

    if-eqz v2, :cond_3

    .line 405
    :cond_2
    iget-object v2, v0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->mFlingSupportedRefreshRate:Ljava/util/ArrayList;

    add-int/lit8 v3, v15, 0x1

    invoke-virtual {v2, v3}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Ljava/lang/Integer;

    invoke-virtual {v2}, Ljava/lang/Integer;->intValue()I

    move-result v2

    iget-object v3, v0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->mRefreshRateInfo:Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRateInfo;

    .line 406
    invoke-virtual {v3}, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRateInfo;->getVideoFloorRefreshRate()I

    move-result v3

    if-ge v2, v3, :cond_3

    .line 407
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "List with video, min support refresh rate is "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v0, v0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->mRefreshRateInfo:Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRateInfo;

    .line 408
    invoke-virtual {v0}, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRateInfo;->getVideoFloorRefreshRate()I

    move-result v0

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    .line 407
    invoke-static {v11, v0}, Lcom/mediatek/boostfwk/utils/LogUtil;->mLogd(Ljava/lang/String;Ljava/lang/String;)V

    return-void

    .line 413
    :cond_3
    iget-object v3, v0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->mRefreshRatePolicyExt:Lcom/mediatek/boostfwk/policy/refreshrate/IRefreshRateEx;

    if-eqz v3, :cond_4

    .line 416
    invoke-virtual/range {p1 .. p1}, Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;->getCurrentRefreshrate()I

    move-result v6

    invoke-static {}, Lcom/mediatek/boostfwk/utils/Util;->getRefreshRate()F

    move-result v2

    float-to-int v7, v2

    iget-object v2, v0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->mFlingSupportedRefreshRate:Ljava/util/ArrayList;

    .line 417
    invoke-virtual {v2, v15}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Ljava/lang/Integer;

    invoke-virtual {v2}, Ljava/lang/Integer;->intValue()I

    move-result v8

    iget-object v2, v0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->mFlingRefreshRateVsyncTime:Ljava/util/ArrayList;

    .line 418
    invoke-virtual {v2, v15}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Ljava/lang/Float;

    invoke-virtual {v2}, Ljava/lang/Float;->doubleValue()D

    move-result-wide v9

    iget-object v2, v0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->mFlingRefreshRateChangeTimeOffset:Ljava/util/ArrayList;

    .line 419
    invoke-virtual {v2, v15}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Ljava/lang/Float;

    invoke-virtual {v2}, Ljava/lang/Float;->doubleValue()D

    move-result-wide v17

    iget v2, v0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->mSplinePositionCount:I

    move-object v1, v11

    move-wide/from16 v11, v17

    move/from16 v19, v15

    move v15, v2

    .line 415
    invoke-interface/range {v3 .. v16}, Lcom/mediatek/boostfwk/policy/refreshrate/IRefreshRateEx;->calculateGap(JIIIDDIII[F)D

    move-result-wide v2

    .line 422
    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    const-string v5, "onListFlingUpdate stepGap = "

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4, v2, v3}, Ljava/lang/StringBuilder;->append(D)Ljava/lang/StringBuilder;

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v4

    invoke-static {v1, v4}, Lcom/mediatek/boostfwk/utils/LogUtil;->mLogd(Ljava/lang/String;Ljava/lang/String;)V

    .line 424
    iget v1, v0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->mFlingSupportRefreshRateCount:I

    move/from16 v4, v19

    if-ge v4, v1, :cond_4

    iget-object v1, v0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->mFlingRefreshRateChangeGap:Ljava/util/ArrayList;

    .line 425
    invoke-virtual {v1, v4}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Ljava/lang/Float;

    invoke-virtual {v1}, Ljava/lang/Float;->floatValue()F

    move-result v1

    float-to-double v5, v1

    cmpg-double v1, v2, v5

    if-gtz v1, :cond_4

    const-wide/high16 v5, -0x4010000000000000L    # -1.0

    cmpl-double v1, v2, v5

    if-eqz v1, :cond_4

    .line 427
    iget-object v1, v0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->mFlingSupportedRefreshRate:Ljava/util/ArrayList;

    const/4 v2, 0x1

    add-int/lit8 v15, v4, 0x1

    .line 428
    invoke-virtual {v1, v15}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Ljava/lang/Integer;

    invoke-virtual {v1}, Ljava/lang/Integer;->intValue()I

    move-result v1

    move-object/from16 v2, p1

    .line 427
    invoke-direct {v0, v1, v2}, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->updateRefreshRateWhenFling(ILcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;)V

    :cond_4
    :goto_1
    return-void
.end method

.method private onListScrollerInit(Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;)V
    .locals 2

    const/4 v0, 0x3

    .line 277
    invoke-virtual {p1, v0}, Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;->setCurrentFlingState(I)Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;

    move-result-object v0

    .line 278
    invoke-static {}, Lcom/mediatek/boostfwk/utils/Config;->isVariableRefreshRateSupported()Z

    move-result v1

    invoke-virtual {v0, v1}, Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;->setVariableRefreshRateEnabled(Z)Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;

    move-result-object v0

    .line 279
    invoke-static {}, Lcom/mediatek/boostfwk/utils/Config;->isMSync3SmoothFlingEnabled()Z

    move-result v1

    invoke-virtual {v0, v1}, Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;->setSmoothFlingEnabled(Z)Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;

    move-result-object v0

    const/4 v1, 0x1

    .line 280
    invoke-virtual {v0, v1}, Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;->setListScrollStateListening(Z)Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;

    .line 284
    invoke-static {}, Lcom/mediatek/boostfwk/utils/Config;->isMSync3SmoothFlingEnabled()Z

    move-result v0

    if-eqz v0, :cond_0

    .line 285
    iget-object v0, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->mRefreshRateInfo:Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRateInfo;

    .line 286
    invoke-virtual {v0}, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRateInfo;->getSmoothFlingSplinePosition()[F

    move-result-object v0

    .line 285
    invoke-virtual {p1, v0}, Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;->setRealSplinePosition([F)Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;

    .line 287
    iget-object v0, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->mRefreshRateInfo:Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRateInfo;

    invoke-virtual {v0}, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRateInfo;->getSmoothFlingSplineTime()[F

    move-result-object v0

    invoke-virtual {p1, v0}, Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;->setRealSplineTime([F)Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;

    .line 288
    iget-object p1, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->mRefreshRateInfo:Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRateInfo;

    invoke-virtual {p1}, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRateInfo;->getSmoothFlingSplinePositionCount()I

    move-result p1

    iput p1, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->mSplinePositionCount:I

    goto :goto_0

    .line 291
    :cond_0
    invoke-virtual {p1}, Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;->getOriginalSplinePosition()[F

    move-result-object v0

    .line 290
    invoke-virtual {p1, v0}, Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;->setRealSplinePosition([F)Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;

    .line 292
    invoke-virtual {p1}, Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;->getOriginalSplineTime()[F

    move-result-object v0

    invoke-virtual {p1, v0}, Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;->setRealSplineTime([F)Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;

    .line 293
    invoke-virtual {p1}, Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;->getOriginalSplinePosition()[F

    move-result-object p1

    array-length p1, p1

    sub-int/2addr p1, v1

    iput p1, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->mSplinePositionCount:I

    :goto_0
    const-string p0, "MSYNC3-VariableRefreshRate"

    const-string p1, "onListScrollerInit action = SCROLL_INIT"

    .line 296
    invoke-static {p0, p1}, Lcom/mediatek/boostfwk/utils/LogUtil;->mLogd(Ljava/lang/String;Ljava/lang/String;)V

    return-void
.end method

.method private onViewEventUpdate(Lcom/mediatek/boostfwk/scenario/refreshrate/EventScenario;)V
    .locals 2

    .line 467
    iget-object v0, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->mActiveRefreshScenario:Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;

    if-eqz v0, :cond_0

    .line 468
    invoke-virtual {v0}, Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;->getCurrentFlingState()I

    move-result v0

    const/4 v1, 0x1

    if-ne v0, v1, :cond_0

    .line 469
    iget-object v0, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->mActiveRefreshScenario:Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;

    invoke-virtual {v0, v1}, Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;->setHasVideo(Z)Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;

    .line 470
    invoke-virtual {p1, v1}, Lcom/mediatek/boostfwk/scenario/refreshrate/EventScenario;->setIsMarked(Z)Lcom/mediatek/boostfwk/scenario/refreshrate/EventScenario;

    .line 471
    iput-boolean v1, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->mActivityHasVideoView:Z

    :cond_0
    return-void
.end method

.method private updateIMERefreshRate(ILandroid/view/Window;)V
    .locals 1

    .line 834
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0}, Ljava/lang/StringBuilder;-><init>()V

    const-string/jumbo v0, "updateIMERefreshRate action = "

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    const-string v0, "MSYNC3-VariableRefreshRate"

    invoke-static {v0, p0}, Lcom/mediatek/boostfwk/utils/LogUtil;->mLogd(Ljava/lang/String;Ljava/lang/String;)V

    const-string p0, "Refreshrate Change : IME"

    .line 835
    invoke-static {p0}, Lcom/mediatek/boostfwk/utils/LogUtil;->traceBegin(Ljava/lang/String;)V

    .line 837
    invoke-virtual {p2}, Landroid/view/Window;->getAttributes()Landroid/view/WindowManager$LayoutParams;

    move-result-object p0

    const/4 v0, 0x1

    .line 838
    iput v0, p0, Landroid/view/WindowManager$LayoutParams;->mMSyncScenarioType:I

    .line 839
    iput p1, p0, Landroid/view/WindowManager$LayoutParams;->mMSyncScenarioAction:I

    .line 840
    invoke-virtual {p2, p0}, Landroid/view/Window;->setAttributes(Landroid/view/WindowManager$LayoutParams;)V

    .line 842
    invoke-static {}, Lcom/mediatek/boostfwk/utils/LogUtil;->traceEnd()V

    return-void
.end method

.method private updateRefreshInternal(Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;III)Z
    .locals 9

    .line 708
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string/jumbo v1, "updateRefreshInternal RefreshRate = "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    const-string v1, "MSYNC3-VariableRefreshRate"

    invoke-static {v1, v0}, Lcom/mediatek/boostfwk/utils/LogUtil;->mLogd(Ljava/lang/String;Ljava/lang/String;)V

    .line 710
    invoke-virtual {p1}, Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;->getScenarioContext()Landroid/content/Context;

    move-result-object p1

    const/4 v0, 0x0

    if-nez p1, :cond_0

    .line 712
    invoke-static {}, Lcom/mediatek/boostfwk/info/ActivityInfo;->getInstance()Lcom/mediatek/boostfwk/info/ActivityInfo;

    move-result-object p1

    invoke-virtual {p1}, Lcom/mediatek/boostfwk/info/ActivityInfo;->getContext()Landroid/content/Context;

    move-result-object p1

    if-nez p1, :cond_0

    return v0

    .line 716
    :cond_0
    instance-of v2, p1, Landroid/app/Activity;

    if-eqz v2, :cond_3

    .line 718
    :try_start_0
    check-cast p1, Landroid/app/Activity;

    invoke-virtual {p1}, Landroid/app/Activity;->getWindow()Landroid/view/Window;

    move-result-object p1

    .line 719
    invoke-virtual {p1}, Landroid/view/Window;->getDecorView()Landroid/view/View;

    move-result-object p1

    invoke-virtual {p1}, Landroid/view/View;->getViewRootImpl()Landroid/view/ViewRootImpl;

    move-result-object p1

    if-eqz p1, :cond_2

    .line 721
    invoke-virtual {p1}, Landroid/view/ViewRootImpl;->getSurfaceControl()Landroid/view/SurfaceControl;

    move-result-object v3

    .line 722
    invoke-virtual {v3}, Landroid/view/SurfaceControl;->isValid()Z

    move-result p1

    if-eqz p1, :cond_1

    .line 723
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "Update RefreshRate = "

    invoke-virtual {p1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v2, " scenarioAction = "

    invoke-virtual {p1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1, p3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v2, " scenarioType = "

    invoke-virtual {p1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1, p4}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-static {v1, p1}, Lcom/mediatek/boostfwk/utils/LogUtil;->mLogd(Ljava/lang/String;Ljava/lang/String;)V

    .line 727
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "Refreshrate Change ="

    invoke-virtual {p1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v2, " action = "

    invoke-virtual {p1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1, p3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v2, " type = "

    invoke-virtual {p1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1, p4}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-static {p1}, Lcom/mediatek/boostfwk/utils/LogUtil;->traceBegin(Ljava/lang/String;)V

    .line 731
    invoke-static {}, Landroid/view/WindowManagerGlobal;->getWindowSession()Landroid/view/IWindowSession;

    move-result-object v2

    int-to-float v4, p2

    iget-object p1, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->mRefreshRateInfo:Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRateInfo;

    .line 736
    invoke-virtual {p1}, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRateInfo;->getCurrentActivityName()Ljava/lang/String;

    move-result-object v7

    iget-object p0, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->mRefreshRateInfo:Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRateInfo;

    .line 737
    invoke-virtual {p0}, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRateInfo;->getPackageName()Ljava/lang/String;

    move-result-object v8

    move v5, p3

    move v6, p4

    .line 731
    invoke-interface/range {v2 .. v8}, Landroid/view/IWindowSession;->setRefreshRate(Landroid/view/SurfaceControl;FIILjava/lang/String;Ljava/lang/String;)V

    .line 739
    invoke-static {}, Lcom/mediatek/boostfwk/utils/LogUtil;->traceEnd()V

    const/4 p0, 0x1

    return p0

    :cond_1
    const-string p0, "Refreshrate change failed : SurfaceControl is invalid"

    .line 742
    invoke-static {v1, p0}, Lcom/mediatek/boostfwk/utils/LogUtil;->mLogd(Ljava/lang/String;Ljava/lang/String;)V

    goto :goto_0

    :cond_2
    const-string p0, "Refreshrate change failed : ViewRootImpl == null "

    .line 745
    invoke-static {v1, p0}, Lcom/mediatek/boostfwk/utils/LogUtil;->mLogd(Ljava/lang/String;Ljava/lang/String;)V
    :try_end_0
    .catch Landroid/os/RemoteException; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    :catch_0
    move-exception p0

    .line 748
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string p2, "Refreshrate change failed, e = "

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Landroid/os/RemoteException;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-virtual {p1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {v1, p0}, Lcom/mediatek/boostfwk/utils/LogUtil;->mLogd(Ljava/lang/String;Ljava/lang/String;)V

    goto :goto_0

    :cond_3
    const-string p0, "Refreshrate change failed : ActivityContext == null"

    .line 751
    invoke-static {v1, p0}, Lcom/mediatek/boostfwk/utils/LogUtil;->mLogd(Ljava/lang/String;Ljava/lang/String;)V

    :goto_0
    return v0
.end method

.method private updateRefreshRateWhenFling(ILcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;)V
    .locals 2

    .line 537
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string/jumbo v1, "updateRefreshRateWhenFling change oldRefreshRate = "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 538
    invoke-virtual {p2}, Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;->getCurrentRefreshrate()I

    move-result v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, " New RefreshRate = "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    const-string v1, "MSYNC3-VariableRefreshRate"

    .line 537
    invoke-static {v1, v0}, Lcom/mediatek/boostfwk/utils/LogUtil;->mLogd(Ljava/lang/String;Ljava/lang/String;)V

    .line 540
    invoke-virtual {p2}, Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;->getCurrentRefreshrate()I

    move-result v0

    if-ne v0, p1, :cond_0

    return-void

    :cond_0
    const/4 v0, 0x0

    .line 542
    invoke-direct {p0, p2, p1, v0, v0}, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->updateRefreshInternal(Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;III)Z

    move-result p0

    if-eqz p0, :cond_1

    .line 543
    invoke-virtual {p2, p1}, Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;->setCurrentRefreshrate(I)Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;

    .line 544
    invoke-virtual {p2}, Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;->increaseFlingRefreshRateChangeIndex()Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;

    :cond_1
    return-void
.end method

.method private updateRefreshRateWhenScroll(Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;I)V
    .locals 2

    .line 648
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string/jumbo v1, "updateRefreshRateWhenScroll oldRefreshRate = "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 649
    invoke-virtual {p1}, Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;->getCurrentRefreshrate()I

    move-result v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, " New RefreshRate = "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    const-string v1, "MSYNC3-VariableRefreshRate"

    .line 648
    invoke-static {v1, v0}, Lcom/mediatek/boostfwk/utils/LogUtil;->mLogd(Ljava/lang/String;Ljava/lang/String;)V

    const/4 v0, 0x0

    .line 651
    invoke-direct {p0, p1, p2, v0, v0}, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->updateRefreshInternal(Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;III)Z

    move-result p0

    if-eqz p0, :cond_0

    .line 652
    invoke-virtual {p1, p2}, Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;->setCurrentRefreshrate(I)Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;

    :cond_0
    return-void
.end method

.method private updateScrollAction(Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;I)V
    .locals 1

    const/4 v0, 0x0

    .line 703
    invoke-direct {p0, p1, p2, v0, v0}, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->updateRefreshInternal(Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;III)Z

    return-void
.end method

.method private updateVoiceDialogRefreshRate(I)V
    .locals 2

    .line 783
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0}, Ljava/lang/StringBuilder;-><init>()V

    const-string/jumbo v0, "updateVoiceDialogRefreshRate action = "

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    const-string v0, "MSYNC3-VariableRefreshRate"

    invoke-static {v0, p0}, Lcom/mediatek/boostfwk/utils/LogUtil;->mLogd(Ljava/lang/String;Ljava/lang/String;)V

    .line 784
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "Voice Action="

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p0}, Lcom/mediatek/boostfwk/utils/LogUtil;->traceBegin(Ljava/lang/String;)V

    .line 786
    invoke-static {}, Lcom/mediatek/boostfwk/info/ActivityInfo;->getInstance()Lcom/mediatek/boostfwk/info/ActivityInfo;

    move-result-object p0

    invoke-virtual {p0}, Lcom/mediatek/boostfwk/info/ActivityInfo;->getContext()Landroid/content/Context;

    move-result-object p0

    if-eqz p0, :cond_0

    .line 787
    instance-of v0, p0, Landroid/app/Activity;

    if-eqz v0, :cond_0

    .line 788
    check-cast p0, Landroid/app/Activity;

    invoke-virtual {p0}, Landroid/app/Activity;->getWindow()Landroid/view/Window;

    move-result-object p0

    if-eqz p0, :cond_0

    .line 790
    invoke-virtual {p0}, Landroid/view/Window;->getAttributes()Landroid/view/WindowManager$LayoutParams;

    move-result-object v0

    const/4 v1, 0x2

    .line 791
    iput v1, v0, Landroid/view/WindowManager$LayoutParams;->mMSyncScenarioType:I

    .line 792
    iput p1, v0, Landroid/view/WindowManager$LayoutParams;->mMSyncScenarioAction:I

    .line 793
    invoke-virtual {p0, v0}, Landroid/view/Window;->setAttributes(Landroid/view/WindowManager$LayoutParams;)V

    .line 796
    :cond_0
    invoke-static {}, Lcom/mediatek/boostfwk/utils/LogUtil;->traceEnd()V

    return-void
.end method


# virtual methods
.method public dispatchEvent(Lcom/mediatek/boostfwk/scenario/refreshrate/EventScenario;)V
    .locals 4

    .line 257
    invoke-virtual {p1}, Lcom/mediatek/boostfwk/scenario/refreshrate/EventScenario;->getScenarioAction()I

    move-result v0

    .line 259
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "dispatchEvent action = "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    const-string v2, "MSYNC3-VariableRefreshRate"

    invoke-static {v2, v1}, Lcom/mediatek/boostfwk/utils/LogUtil;->mLogd(Ljava/lang/String;Ljava/lang/String;)V

    .line 260
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "Dispatch Event Action="

    invoke-virtual {v1, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {v1}, Lcom/mediatek/boostfwk/utils/LogUtil;->traceBegin(Ljava/lang/String;)V

    const/4 v1, 0x1

    if-eqz v0, :cond_0

    if-eq v0, v1, :cond_0

    const-string p0, "RefreshRatePolicy dispatchEvent error"

    .line 269
    invoke-static {v2, p0}, Lcom/mediatek/boostfwk/utils/LogUtil;->mLoge(Ljava/lang/String;Ljava/lang/String;)V

    goto :goto_0

    .line 265
    :cond_0
    invoke-direct {p0, p1}, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->onViewEventUpdate(Lcom/mediatek/boostfwk/scenario/refreshrate/EventScenario;)V

    .line 266
    invoke-virtual {p1, v1}, Lcom/mediatek/boostfwk/scenario/refreshrate/EventScenario;->setVariableRefreshRateEnabled(Z)Lcom/mediatek/boostfwk/scenario/refreshrate/EventScenario;

    .line 273
    :goto_0
    invoke-static {}, Lcom/mediatek/boostfwk/utils/LogUtil;->traceEnd()V

    return-void
.end method

.method public dispatchScenario(Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;)V
    .locals 4

    .line 226
    invoke-virtual {p1}, Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;->getScenarioAction()I

    move-result v0

    .line 228
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "dispatchScenario action = "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v2, " mCurrentTouchState = "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v2, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->mCurrentTouchState:I

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    const-string v2, "MSYNC3-VariableRefreshRate"

    invoke-static {v2, v1}, Lcom/mediatek/boostfwk/utils/LogUtil;->mLogd(Ljava/lang/String;Ljava/lang/String;)V

    .line 230
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "Dispatch Scenario Action="

    invoke-virtual {v1, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {v1}, Lcom/mediatek/boostfwk/utils/LogUtil;->traceBegin(Ljava/lang/String;)V

    if-eqz v0, :cond_5

    const/4 v1, 0x1

    if-eq v0, v1, :cond_3

    const/4 v1, 0x2

    if-eq v0, v1, :cond_1

    const/4 v1, 0x3

    if-eq v0, v1, :cond_0

    const-string p0, "RefreshRatePolicy dispatchScenario error"

    .line 249
    invoke-static {v2, p0}, Lcom/mediatek/boostfwk/utils/LogUtil;->mLoge(Ljava/lang/String;Ljava/lang/String;)V

    goto :goto_0

    .line 234
    :cond_0
    invoke-direct {p0, p1}, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->onListScrollerInit(Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;)V

    goto :goto_0

    .line 241
    :cond_1
    iget-boolean v0, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->mIsDataInited:Z

    if-nez v0, :cond_2

    return-void

    .line 242
    :cond_2
    invoke-direct {p0, p1}, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->onListFlingFinished(Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;)V

    goto :goto_0

    .line 245
    :cond_3
    iget-boolean v0, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->mIsDataInited:Z

    if-nez v0, :cond_4

    return-void

    .line 246
    :cond_4
    invoke-direct {p0, p1}, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->onListFlingUpdate(Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;)V

    goto :goto_0

    .line 237
    :cond_5
    iget-boolean v0, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->mIsDataInited:Z

    if-nez v0, :cond_6

    return-void

    .line 238
    :cond_6
    invoke-direct {p0, p1}, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->onListFlingStart(Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;)V

    .line 253
    :goto_0
    invoke-static {}, Lcom/mediatek/boostfwk/utils/LogUtil;->traceEnd()V

    return-void
.end method

.method public onIMEInit(Landroid/view/Window;)V
    .locals 1

    if-nez p1, :cond_0

    return-void

    .line 806
    :cond_0
    iget-object v0, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->mImeWindow:Ljava/lang/ref/WeakReference;

    if-eqz v0, :cond_1

    .line 807
    invoke-virtual {v0}, Ljava/lang/ref/WeakReference;->clear()V

    .line 809
    :cond_1
    new-instance v0, Ljava/lang/ref/WeakReference;

    invoke-direct {v0, p1}, Ljava/lang/ref/WeakReference;-><init>(Ljava/lang/Object;)V

    iput-object v0, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->mImeWindow:Ljava/lang/ref/WeakReference;

    const-string p0, "MSYNC3-VariableRefreshRate"

    const-string p1, "ime init"

    .line 811
    invoke-static {p0, p1}, Lcom/mediatek/boostfwk/utils/LogUtil;->mLogd(Ljava/lang/String;Ljava/lang/String;)V

    return-void
.end method

.method public onIMEVisibilityChange(Z)V
    .locals 3

    .line 822
    invoke-direct {p0}, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->getIMEWindow()Landroid/view/Window;

    move-result-object v0

    if-eqz v0, :cond_1

    .line 824
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "IME show = "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    const-string v2, "MSYNC3-VariableRefreshRate"

    invoke-static {v2, v1}, Lcom/mediatek/boostfwk/utils/LogUtil;->mLogi(Ljava/lang/String;Ljava/lang/String;)V

    if-eqz p1, :cond_0

    const/4 p1, 0x1

    .line 826
    invoke-direct {p0, p1, v0}, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->updateIMERefreshRate(ILandroid/view/Window;)V

    goto :goto_0

    :cond_0
    const/4 p1, 0x2

    .line 828
    invoke-direct {p0, p1, v0}, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->updateIMERefreshRate(ILandroid/view/Window;)V

    :cond_1
    :goto_0
    return-void
.end method

.method public onScrollStateChange(IF)V
    .locals 5

    .line 657
    iget-object v0, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->mActiveRefreshScenario:Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;

    if-nez v0, :cond_0

    return-void

    .line 659
    :cond_0
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "onScrollStateChange velocity = "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p2}, Ljava/lang/StringBuilder;->append(F)Ljava/lang/StringBuilder;

    const-string v1, " scrollState = "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    const-string v1, "MSYNC3-VariableRefreshRate"

    invoke-static {v1, v0}, Lcom/mediatek/boostfwk/utils/LogUtil;->mLogd(Ljava/lang/String;Ljava/lang/String;)V

    const/4 v0, 0x1

    const/4 v2, 0x0

    if-eqz p1, :cond_2

    if-eq p1, v0, :cond_1

    const/4 v0, 0x3

    if-eq p1, v0, :cond_1

    goto :goto_1

    .line 691
    :cond_1
    invoke-static {p2}, Ljava/lang/Math;->abs(F)F

    move-result p1

    const/high16 p2, 0x42c80000    # 100.0f

    cmpg-float p1, p1, p2

    if-gtz p1, :cond_4

    .line 692
    iget-object p1, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->mActiveRefreshScenario:Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;

    const/16 p2, 0x3e8

    invoke-direct {p0, p1, p2}, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->updateScrollAction(Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;I)V

    .line 693
    iget-object p1, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->mActiveRefreshScenario:Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;

    invoke-virtual {p1, v2}, Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;->setTouchScrollEnabled(Z)Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;

    const/4 p1, 0x0

    .line 694
    iput-object p1, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->mActiveRefreshScenario:Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;

    goto :goto_1

    .line 664
    :cond_2
    iget-object p1, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->mActiveRefreshScenario:Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;

    invoke-static {}, Landroid/os/SystemClock;->uptimeMillis()J

    move-result-wide v3

    invoke-virtual {p1, v3, v4}, Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;->setLastTouchDownTime(J)Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;

    .line 666
    invoke-static {}, Landroid/os/SystemClock;->uptimeMillis()J

    move-result-wide p1

    iget-object v3, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->mActiveRefreshScenario:Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;

    .line 667
    invoke-virtual {v3}, Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;->getLastFlingFinishTime()J

    move-result-wide v3

    sub-long/2addr p1, v3

    const-wide/16 v3, 0x96

    cmp-long p1, p1, v3

    if-gez p1, :cond_3

    .line 670
    iget-object p1, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->mActiveRefreshScenario:Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;

    invoke-virtual {p1, v0}, Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;->setTouchScrollEnabled(Z)Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;

    const-string p1, "onScrollStateChange List stop by touch event"

    .line 671
    invoke-static {v1, p1}, Lcom/mediatek/boostfwk/utils/LogUtil;->mLogd(Ljava/lang/String;Ljava/lang/String;)V

    goto :goto_0

    .line 674
    :cond_3
    iget-object p1, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->mActiveRefreshScenario:Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;

    invoke-virtual {p1, v2}, Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;->setTouchScrollEnabled(Z)Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;

    const-string p1, "onScrollStateChange List stop by other reason"

    .line 675
    invoke-static {v1, p1}, Lcom/mediatek/boostfwk/utils/LogUtil;->mLogd(Ljava/lang/String;Ljava/lang/String;)V

    .line 677
    :goto_0
    iget-object p1, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->mWorkerHandler:Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy$WorkerHandler;

    invoke-virtual {p1, v2}, Landroid/os/Handler;->removeMessages(I)V

    .line 679
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string p2, "onScrollStateChange List touch scroll state = "

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object p2, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->mActiveRefreshScenario:Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;

    .line 680
    invoke-virtual {p2}, Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;->getTouchScrollEnabled()Z

    move-result p2

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    .line 679
    invoke-static {v1, p1}, Lcom/mediatek/boostfwk/utils/LogUtil;->mLogd(Ljava/lang/String;Ljava/lang/String;)V

    const-wide/16 p1, 0x0

    .line 682
    iput-wide p1, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->mLastRefreshChangeTime:J

    .line 683
    iput v2, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->mTouchScrollSpeed:I

    .line 684
    iget-object p1, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->mActiveRefreshScenario:Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;

    const/16 p2, 0x3e9

    invoke-direct {p0, p1, p2}, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->updateScrollAction(Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;I)V

    :cond_4
    :goto_1
    return-void
.end method

.method public onTouchEvent(Landroid/view/MotionEvent;)V
    .locals 6

    .line 560
    iget-object v0, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->mVelocityTracker:Landroid/view/VelocityTracker;

    if-nez v0, :cond_0

    .line 562
    invoke-static {}, Landroid/view/VelocityTracker;->obtain()Landroid/view/VelocityTracker;

    move-result-object v0

    iput-object v0, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->mVelocityTracker:Landroid/view/VelocityTracker;

    .line 564
    :cond_0
    invoke-virtual {p1}, Landroid/view/MotionEvent;->getActionMasked()I

    move-result v0

    if-eqz v0, :cond_3

    const/16 v1, 0x64

    const/4 v2, 0x2

    const/4 v3, 0x1

    if-eq v0, v3, :cond_2

    if-eq v0, v2, :cond_1

    const/4 v4, 0x3

    if-eq v0, v4, :cond_2

    goto :goto_0

    .line 578
    :cond_1
    iget-object v0, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->mVelocityTracker:Landroid/view/VelocityTracker;

    invoke-virtual {v0, p1}, Landroid/view/VelocityTracker;->addMovement(Landroid/view/MotionEvent;)V

    .line 579
    iget-object v0, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->mVelocityTracker:Landroid/view/VelocityTracker;

    invoke-virtual {v0, v1}, Landroid/view/VelocityTracker;->computeCurrentVelocity(I)V

    .line 580
    invoke-static {}, Landroid/os/SystemClock;->uptimeMillis()J

    move-result-wide v0

    iget-wide v4, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->mTouchDownTime:J

    sub-long/2addr v0, v4

    iput-wide v0, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->mTouchDuration:J

    .line 581
    iget-object v0, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->mVelocityTracker:Landroid/view/VelocityTracker;

    invoke-virtual {v0}, Landroid/view/VelocityTracker;->getYVelocity()F

    move-result v0

    iget-wide v1, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->mTouchDuration:J

    invoke-virtual {p0, v0, v1, v2}, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->onVelocityChange(FJ)V

    .line 582
    iput v3, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->mCurrentTouchState:I

    .line 583
    invoke-virtual {p1}, Landroid/view/MotionEvent;->getY()F

    move-result p1

    iput p1, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->mLastTouchMovePointerY:F

    goto :goto_0

    .line 587
    :cond_2
    iget-object v0, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->mVelocityTracker:Landroid/view/VelocityTracker;

    invoke-virtual {v0, p1}, Landroid/view/VelocityTracker;->addMovement(Landroid/view/MotionEvent;)V

    .line 588
    iget-object v0, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->mVelocityTracker:Landroid/view/VelocityTracker;

    invoke-virtual {v0, v1}, Landroid/view/VelocityTracker;->computeCurrentVelocity(I)V

    .line 589
    iget-object v0, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->mVelocityTracker:Landroid/view/VelocityTracker;

    invoke-virtual {v0}, Landroid/view/VelocityTracker;->getYVelocity()F

    move-result v0

    invoke-virtual {p0, v3, v0}, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->onScrollStateChange(IF)V

    .line 590
    iput v2, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->mCurrentTouchState:I

    const/4 v0, -0x1

    .line 591
    iput v0, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->mTouchScrollSpeed:I

    .line 592
    invoke-virtual {p1}, Landroid/view/MotionEvent;->getY()F

    move-result p1

    iput p1, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->mLastTouchMovePointerY:F

    goto :goto_0

    .line 567
    :cond_3
    iget-object v0, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->mVelocityTracker:Landroid/view/VelocityTracker;

    invoke-virtual {v0}, Landroid/view/VelocityTracker;->clear()V

    .line 569
    iget-object v0, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->mVelocityTracker:Landroid/view/VelocityTracker;

    invoke-virtual {v0, p1}, Landroid/view/VelocityTracker;->addMovement(Landroid/view/MotionEvent;)V

    .line 570
    invoke-static {}, Landroid/os/SystemClock;->uptimeMillis()J

    move-result-wide v0

    iput-wide v0, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->mTouchDownTime:J

    .line 571
    invoke-virtual {p1}, Landroid/view/MotionEvent;->getY()F

    move-result p1

    iput p1, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->mTouchDownPointerY:F

    const/4 p1, 0x0

    .line 572
    iput p1, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->mLastTouchMovePointerY:F

    .line 573
    iget-object p1, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->mVelocityTracker:Landroid/view/VelocityTracker;

    invoke-virtual {p1}, Landroid/view/VelocityTracker;->getYVelocity()F

    move-result p1

    const/4 v0, 0x0

    invoke-virtual {p0, v0, p1}, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->onScrollStateChange(IF)V

    .line 574
    iput v0, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->mCurrentTouchState:I

    .line 575
    iput v0, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->mTouchScrollSpeed:I

    :goto_0
    return-void
.end method

.method public onVelocityChange(FJ)V
    .locals 6

    .line 600
    iget-object v0, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->mActiveRefreshScenario:Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;

    if-nez v0, :cond_0

    return-void

    .line 603
    :cond_0
    iget-object v0, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->mTouchScrollVelocityList:Ljava/util/ArrayList;

    invoke-virtual {v0}, Ljava/util/ArrayList;->size()I

    move-result v0

    const/4 v1, 0x5

    if-lt v0, v1, :cond_3

    .line 605
    iget-object v0, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->mTouchScrollVelocityList:Ljava/util/ArrayList;

    const/4 v1, 0x0

    invoke-virtual {v0, v1}, Ljava/util/ArrayList;->remove(I)Ljava/lang/Object;

    .line 606
    iget-object v0, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->mTouchScrollVelocityList:Ljava/util/ArrayList;

    invoke-static {p1}, Ljava/lang/Math;->abs(F)F

    move-result p1

    invoke-static {p1}, Ljava/lang/Float;->valueOf(F)Ljava/lang/Float;

    move-result-object p1

    invoke-virtual {v0, p1}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    const-wide/16 v2, 0x12c

    cmp-long p1, p2, v2

    if-lez p1, :cond_2

    .line 612
    iget-wide v2, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->mLastRefreshChangeTime:J

    sub-long v2, p2, v2

    const-wide/16 v4, 0xc8

    cmp-long p1, v2, v4

    if-lez p1, :cond_2

    .line 614
    iget-object p1, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->mTouchScrollVelocityList:Ljava/util/ArrayList;

    invoke-direct {p0, p1}, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->calculateAverage(Ljava/util/ArrayList;)F

    move-result p1

    .line 615
    iget-object v0, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->mRefreshRateInfo:Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRateInfo;

    invoke-virtual {v0}, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRateInfo;->getTouchScrollVelocityThreshold()I

    move-result v0

    int-to-float v0, v0

    cmpg-float v0, p1, v0

    const-string v2, "MSYNC3-VariableRefreshRate"

    if-gtz v0, :cond_1

    iget v0, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->mTouchScrollSpeed:I

    if-nez v0, :cond_1

    iget-object v0, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->mActiveRefreshScenario:Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;

    .line 617
    invoke-virtual {v0}, Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;->getTouchScrollEnabled()Z

    move-result v0

    if-eqz v0, :cond_1

    .line 618
    iget-object p1, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->mActiveRefreshScenario:Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;

    iget-object v0, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->mRefreshRateInfo:Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRateInfo;

    .line 619
    invoke-virtual {v0}, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRateInfo;->getSlowScrollRefreshRate()I

    move-result v0

    .line 618
    invoke-direct {p0, p1, v0}, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->updateRefreshRateWhenScroll(Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;I)V

    const/4 p1, 0x1

    .line 620
    iput p1, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->mTouchScrollSpeed:I

    .line 621
    iput-wide p2, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->mLastRefreshChangeTime:J

    .line 622
    iget-object p1, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->mActiveRefreshScenario:Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;

    iget-object p0, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->mRefreshRateInfo:Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRateInfo;

    .line 623
    invoke-virtual {p0}, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRateInfo;->getSlowScrollRefreshRate()I

    move-result p0

    .line 622
    invoke-virtual {p1, p0}, Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;->setCurrentRefreshrate(I)Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;

    const-string p0, "Touch scroll speed change : High -> Low"

    .line 624
    invoke-static {v2, p0}, Lcom/mediatek/boostfwk/utils/LogUtil;->mLogi(Ljava/lang/String;Ljava/lang/String;)V

    goto :goto_0

    .line 625
    :cond_1
    iget-object v0, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->mRefreshRateInfo:Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRateInfo;

    invoke-virtual {v0}, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRateInfo;->getTouchScrollVelocityThreshold()I

    move-result v0

    int-to-float v0, v0

    cmpl-float p1, p1, v0

    if-lez p1, :cond_2

    .line 626
    iget-object p1, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->mActiveRefreshScenario:Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;

    iget-object v0, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->mRefreshRateInfo:Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRateInfo;

    .line 627
    invoke-virtual {v0}, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRateInfo;->getMaxFlingSupportedRefreshRate()I

    move-result v0

    .line 626
    invoke-direct {p0, p1, v0}, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->updateRefreshRateWhenScroll(Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;I)V

    .line 628
    iput v1, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->mTouchScrollSpeed:I

    .line 629
    iget-object p1, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->mActiveRefreshScenario:Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;

    iget-object v0, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->mRefreshRateInfo:Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRateInfo;

    .line 630
    invoke-virtual {v0}, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRateInfo;->getMaxFlingSupportedRefreshRate()I

    move-result v0

    .line 629
    invoke-virtual {p1, v0}, Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;->setCurrentRefreshrate(I)Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;

    .line 631
    iput-wide p2, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->mLastRefreshChangeTime:J

    const-string p0, "Touch scroll speed change : Low -> High"

    .line 632
    invoke-static {v2, p0}, Lcom/mediatek/boostfwk/utils/LogUtil;->mLogi(Ljava/lang/String;Ljava/lang/String;)V

    :cond_2
    :goto_0
    return-void

    .line 608
    :cond_3
    iget-object p0, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->mTouchScrollVelocityList:Ljava/util/ArrayList;

    invoke-static {p1}, Ljava/lang/Math;->abs(F)F

    move-result p1

    invoke-static {p1}, Ljava/lang/Float;->valueOf(F)Ljava/lang/Float;

    move-result-object p1

    invoke-virtual {p0, p1}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    return-void
.end method

.method public onVoiceDialogEvent(Z)V
    .locals 2

    .line 773
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "Voice Dialog Show = "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    const-string v1, "MSYNC3-VariableRefreshRate"

    invoke-static {v1, v0}, Lcom/mediatek/boostfwk/utils/LogUtil;->mLogi(Ljava/lang/String;Ljava/lang/String;)V

    if-eqz p1, :cond_0

    const/4 p1, 0x1

    .line 776
    invoke-direct {p0, p1}, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->updateVoiceDialogRefreshRate(I)V

    goto :goto_0

    :cond_0
    const/4 p1, 0x2

    .line 778
    invoke-direct {p0, p1}, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->updateVoiceDialogRefreshRate(I)V

    :goto_0
    return-void
.end method

.method public registerActivityListener()V
    .locals 2

    .line 157
    invoke-static {}, Lcom/mediatek/boostfwk/info/ActivityInfo;->getInstance()Lcom/mediatek/boostfwk/info/ActivityInfo;

    move-result-object v0

    new-instance v1, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy$1;

    invoke-direct {v1, p0}, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy$1;-><init>(Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;)V

    invoke-virtual {v0, v1}, Lcom/mediatek/boostfwk/info/ActivityInfo;->registerActivityListener(Lcom/mediatek/boostfwk/info/ActivityInfo$ActivityChangeListener;)V

    return-void
.end method

.method public setVeriableRefreshRateSupported(Z)V
    .locals 0

    .line 198
    iput-boolean p1, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->mMSyncSupportedByProcess:Z

    return-void
.end method
