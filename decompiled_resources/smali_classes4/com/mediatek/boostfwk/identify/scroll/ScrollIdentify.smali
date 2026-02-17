.class public Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;
.super Lcom/mediatek/boostfwk/identify/BaseIdentify;
.source "ScrollIdentify.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify$TouchEventListener;,
        Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify$ScrollGestureListener;
    }
.end annotation


# static fields
.field private static final DISPLAY_RATE_60:F = 60.0f

.field protected static final MOVE_DISTANCE:F = 50.0f

.field public static final NO_CHECKED_STATUS:I = -0x1

.field private static final SCROLL_LOCK:Ljava/lang/Object;

.field private static final TAG:Ljava/lang/String; = "ScrollIdentify"

.field private static lock:Ljava/lang/Object; = null

.field private static mIsSpecialPageDesign:I = -0x1

.field private static final sAUTO_SWITCH_FPSGO:Z = true

.field private static sInstance:Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;


# instance fields
.field private final APP_TYPE_GAME:I

.field private final APP_TYPE_MAP:I

.field private final APP_TYPE_NORMAL:I

.field private final APP_TYPE_READER:I

.field private final APP_TYPE_STRICT_MODE:I

.field private final APP_TYPE_SYSTEM:I

.field protected final FLING_DISTANCE_HORIZONTAL_DP:I

.field protected final FLING_DISTANCE_VERTICAL_DP:F

.field protected final FLING_SPEED_HORIZONTAL_DP:I

.field protected final FLING_SPEED_VERTICAL_DP:I

.field private activityChangeListener:Lcom/mediatek/boostfwk/info/ActivityInfo$ActivityChangeListener;

.field private mActivityInfo:Lcom/mediatek/boostfwk/info/ActivityInfo;

.field private mApplicationType:I

.field private mCurrentMotionEvent:Landroid/view/MotionEvent;

.field private mDispatcherPkgName:Ljava/lang/String;

.field private mFrameIntervalMs:J

.field private mGestureDetector:Landroid/view/GestureDetector;

.field private mHaveMoveEvent:Z

.field private mInputPkgName:Ljava/lang/String;

.field private mIsInput:Z

.field private mIsInputLockAcquired:Z

.field private mIsScrollLockAcquired:Z

.field private mIsScrolling:Z

.field private mIsSystemApp:Z

.field private mIsUserTouched:Z

.field private mLastScrollerEnd:Z

.field private mLimitVsyncTime:J

.field private mRefreshRate:F

.field private mTouchEventListeners:Ljava/util/List;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/List<",
            "Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify$TouchEventListener;",
            ">;"
        }
    .end annotation
.end field

.field private mTouchPolicy:Lcom/mediatek/boostfwk/policy/touch/TouchPolicy;

.field private minTouchDistanceHorizontal:F

.field private minTouchDistanceVertical:F

.field private minVelocityHorizontal:F

.field private minVelocityVertical:F

.field private scrollerLock:Ljava/lang/Object;


# direct methods
.method static bridge synthetic -$$Nest$fgetmActivityInfo(Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;)Lcom/mediatek/boostfwk/info/ActivityInfo;
    .locals 0

    iget-object p0, p0, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->mActivityInfo:Lcom/mediatek/boostfwk/info/ActivityInfo;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetminTouchDistanceHorizontal(Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;)F
    .locals 0

    iget p0, p0, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->minTouchDistanceHorizontal:F

    return p0
.end method

.method static bridge synthetic -$$Nest$fgetminTouchDistanceVertical(Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;)F
    .locals 0

    iget p0, p0, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->minTouchDistanceVertical:F

    return p0
.end method

.method static bridge synthetic -$$Nest$fgetminVelocityHorizontal(Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;)F
    .locals 0

    iget p0, p0, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->minVelocityHorizontal:F

    return p0
.end method

.method static bridge synthetic -$$Nest$fgetminVelocityVertical(Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;)F
    .locals 0

    iget p0, p0, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->minVelocityVertical:F

    return p0
.end method

.method static bridge synthetic -$$Nest$fputmHaveMoveEvent(Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;Z)V
    .locals 0

    iput-boolean p1, p0, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->mHaveMoveEvent:Z

    return-void
.end method

.method static bridge synthetic -$$Nest$mcheckSpecialPageType(Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;)V
    .locals 0

    invoke-direct {p0}, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->checkSpecialPageType()V

    return-void
.end method

.method static bridge synthetic -$$Nest$minitMinValuesIfNeeded(Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;)V
    .locals 0

    invoke-direct {p0}, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->initMinValuesIfNeeded()V

    return-void
.end method

.method static bridge synthetic -$$Nest$msbeHint(Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;ILjava/lang/String;)V
    .locals 0

    invoke-direct {p0, p1, p2}, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->sbeHint(ILjava/lang/String;)V

    return-void
.end method

.method static bridge synthetic -$$Nest$sfgetmIsSpecialPageDesign()I
    .locals 1

    sget v0, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->mIsSpecialPageDesign:I

    return v0
.end method

.method static constructor <clinit>()V
    .locals 1

    .line 69
    new-instance v0, Ljava/lang/Object;

    invoke-direct {v0}, Ljava/lang/Object;-><init>()V

    sput-object v0, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->lock:Ljava/lang/Object;

    .line 70
    new-instance v0, Ljava/lang/Object;

    invoke-direct {v0}, Ljava/lang/Object;-><init>()V

    sput-object v0, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->SCROLL_LOCK:Ljava/lang/Object;

    return-void
.end method

.method private constructor <init>()V
    .locals 4

    .line 141
    invoke-direct {p0}, Lcom/mediatek/boostfwk/identify/BaseIdentify;-><init>()V

    const/4 v0, 0x0

    .line 71
    iput-object v0, p0, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->scrollerLock:Ljava/lang/Object;

    const/4 v1, 0x0

    .line 73
    iput-boolean v1, p0, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->mIsInput:Z

    .line 74
    iput-object v0, p0, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->mDispatcherPkgName:Ljava/lang/String;

    .line 75
    iput-boolean v1, p0, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->mIsSystemApp:Z

    const-string v2, ""

    .line 76
    iput-object v2, p0, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->mInputPkgName:Ljava/lang/String;

    const/4 v2, 0x0

    .line 77
    iput v2, p0, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->mRefreshRate:F

    const-wide/16 v2, 0x0

    .line 78
    iput-wide v2, p0, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->mFrameIntervalMs:J

    .line 79
    iput-wide v2, p0, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->mLimitVsyncTime:J

    const/high16 v2, 0x428c0000    # 70.0f

    .line 82
    iput v2, p0, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->FLING_DISTANCE_VERTICAL_DP:F

    const/16 v2, 0x30

    .line 84
    iput v2, p0, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->FLING_DISTANCE_HORIZONTAL_DP:I

    const/16 v2, 0x15e

    .line 85
    iput v2, p0, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->FLING_SPEED_VERTICAL_DP:I

    const/16 v2, 0x190

    .line 87
    iput v2, p0, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->FLING_SPEED_HORIZONTAL_DP:I

    const/high16 v2, -0x40800000    # -1.0f

    .line 89
    iput v2, p0, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->minVelocityHorizontal:F

    .line 90
    iput v2, p0, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->minVelocityVertical:F

    .line 91
    iput v2, p0, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->minTouchDistanceHorizontal:F

    .line 92
    iput v2, p0, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->minTouchDistanceVertical:F

    .line 95
    iput-boolean v1, p0, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->mHaveMoveEvent:Z

    .line 97
    iput-boolean v1, p0, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->mIsInputLockAcquired:Z

    .line 99
    iput-boolean v1, p0, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->mIsScrollLockAcquired:Z

    .line 100
    iput-boolean v1, p0, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->mIsScrolling:Z

    .line 101
    iput-boolean v1, p0, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->mIsUserTouched:Z

    .line 102
    iput-boolean v1, p0, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->mLastScrollerEnd:Z

    const/4 v1, -0x1

    .line 109
    iput v1, p0, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->mApplicationType:I

    const/4 v1, 0x1

    .line 110
    iput v1, p0, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->APP_TYPE_GAME:I

    const/4 v1, 0x2

    .line 111
    iput v1, p0, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->APP_TYPE_READER:I

    const/4 v1, 0x3

    .line 112
    iput v1, p0, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->APP_TYPE_MAP:I

    const/4 v1, 0x4

    .line 113
    iput v1, p0, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->APP_TYPE_SYSTEM:I

    const/4 v1, 0x5

    .line 114
    iput v1, p0, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->APP_TYPE_STRICT_MODE:I

    const/4 v1, 0x6

    .line 115
    iput v1, p0, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->APP_TYPE_NORMAL:I

    .line 117
    iput-object v0, p0, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->mActivityInfo:Lcom/mediatek/boostfwk/info/ActivityInfo;

    .line 118
    iput-object v0, p0, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->mTouchPolicy:Lcom/mediatek/boostfwk/policy/touch/TouchPolicy;

    .line 120
    iput-object v0, p0, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->mCurrentMotionEvent:Landroid/view/MotionEvent;

    .line 127
    iput-object v0, p0, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->activityChangeListener:Lcom/mediatek/boostfwk/info/ActivityInfo$ActivityChangeListener;

    .line 128
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    iput-object v0, p0, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->mTouchEventListeners:Ljava/util/List;

    return-void
.end method

.method private boostBeginEndCheck(I)Z
    .locals 1

    const/4 p0, 0x1

    const/4 v0, 0x0

    if-eqz p1, :cond_1

    if-eq p1, p0, :cond_0

    const-string p0, "ScrollIdentify"

    const-string p1, "Unknown define action inputed, exit now."

    .line 550
    invoke-static {p0, p1}, Lcom/mediatek/boostfwk/utils/LogUtil;->mLoge(Ljava/lang/String;Ljava/lang/String;)V

    :cond_0
    move p0, v0

    :cond_1
    return p0
.end method

.method private checkAppType(Ljava/lang/String;)V
    .locals 1

    .line 577
    invoke-static {p1}, Lcom/mediatek/boostfwk/utils/TasksUtil;->isAPPInStrictMode(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_0

    const/4 p1, 0x5

    .line 578
    iput p1, p0, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->mApplicationType:I

    const-string p0, "APP_TYPE_STRICT_MODE"

    goto :goto_0

    .line 580
    :cond_0
    invoke-static {p1}, Lcom/mediatek/boostfwk/utils/TasksUtil;->isGameAPP(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_1

    const/4 p1, 0x1

    .line 581
    iput p1, p0, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->mApplicationType:I

    const-string p0, "APP_TYPE_GAME"

    goto :goto_0

    .line 583
    :cond_1
    invoke-direct {p0, p1}, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->isSystemApp(Ljava/lang/String;)Z

    move-result p1

    if-eqz p1, :cond_2

    const/4 p1, 0x4

    .line 584
    iput p1, p0, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->mApplicationType:I

    const-string p0, "APP_TYPE_SYSTEM"

    goto :goto_0

    :cond_2
    const/4 p1, 0x6

    .line 592
    iput p1, p0, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->mApplicationType:I

    const-string p0, "APP_TYPE_NORMAL"

    .line 594
    :goto_0
    invoke-static {}, Lcom/mediatek/boostfwk/utils/Config;->isBoostFwkLogEnable()Z

    move-result p1

    if-eqz p1, :cond_3

    .line 595
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "onScroll -- "

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    const-string p1, "ScrollIdentify"

    invoke-static {p1, p0}, Lcom/mediatek/boostfwk/utils/LogUtil;->mLogd(Ljava/lang/String;Ljava/lang/String;)V

    :cond_3
    return-void
.end method

.method private checkScroller(ZLjava/lang/Object;)Z
    .locals 2

    const/4 v0, 0x0

    if-nez p2, :cond_0

    return v0

    :cond_0
    const/4 v1, 0x1

    if-eqz p1, :cond_1

    .line 615
    iget-object p1, p0, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->scrollerLock:Ljava/lang/Object;

    if-nez p1, :cond_2

    .line 616
    iput-object p2, p0, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->scrollerLock:Ljava/lang/Object;

    return v1

    .line 620
    :cond_1
    iget-object p1, p0, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->scrollerLock:Ljava/lang/Object;

    if-eqz p1, :cond_2

    if-ne p1, p2, :cond_2

    const/4 p1, 0x0

    .line 621
    iput-object p1, p0, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->scrollerLock:Ljava/lang/Object;

    return v1

    :cond_2
    return v0
.end method

.method private checkSpecialPageType()V
    .locals 2

    .line 561
    iget-object v0, p0, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->mActivityInfo:Lcom/mediatek/boostfwk/info/ActivityInfo;

    invoke-virtual {v0}, Lcom/mediatek/boostfwk/info/ActivityInfo;->getPageType()I

    move-result v0

    sput v0, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->mIsSpecialPageDesign:I

    const/4 v1, 0x2

    if-eq v0, v1, :cond_0

    const/16 v1, 0x20

    if-eq v0, v1, :cond_0

    const/16 v1, 0x40

    if-eq v0, v1, :cond_0

    goto :goto_0

    :cond_0
    const/4 v0, 0x1

    .line 568
    iput-boolean v0, p0, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->mIsInputLockAcquired:Z

    :goto_0
    return-void
.end method

.method private checkSystemAPP(Ljava/lang/String;)Z
    .locals 1

    .line 630
    iget-object v0, p0, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->mDispatcherPkgName:Ljava/lang/String;

    if-nez v0, :cond_0

    if-eq v0, p1, :cond_0

    .line 631
    invoke-static {p1}, Lcom/mediatek/boostfwk/utils/Util;->isSystemApp(Ljava/lang/String;)Z

    move-result p1

    iput-boolean p1, p0, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->mIsSystemApp:Z

    .line 634
    :cond_0
    iget-boolean p0, p0, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->mIsSystemApp:Z

    return p0
.end method

.method public static getInstance()Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;
    .locals 2

    .line 131
    sget-object v0, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->sInstance:Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;

    if-nez v0, :cond_1

    .line 132
    sget-object v0, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->lock:Ljava/lang/Object;

    monitor-enter v0

    .line 133
    :try_start_0
    sget-object v1, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->sInstance:Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;

    if-nez v1, :cond_0

    .line 134
    new-instance v1, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;

    invoke-direct {v1}, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;-><init>()V

    sput-object v1, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->sInstance:Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;

    .line 136
    :cond_0
    monitor-exit v0

    goto :goto_0

    :catchall_0
    move-exception v1

    monitor-exit v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    throw v1

    .line 138
    :cond_1
    :goto_0
    sget-object v0, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->sInstance:Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;

    return-object v0
.end method

.method private inertialScrollHint(ZLjava/lang/String;)V
    .locals 3

    .line 512
    iget-boolean v0, p0, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->mIsInput:Z

    const/4 v1, 0x1

    if-nez v0, :cond_0

    iget-object v0, p0, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->mInputPkgName:Ljava/lang/String;

    const-string v2, ""

    invoke-virtual {v0, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_0

    iget-object v0, p0, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->mInputPkgName:Ljava/lang/String;

    invoke-virtual {v0, p2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p2

    if-nez p2, :cond_0

    sget p2, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->mIsSpecialPageDesign:I

    if-ne p2, v1, :cond_0

    .line 514
    invoke-direct {p0, v1}, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->resetInputFlag(Z)V

    return-void

    .line 519
    :cond_0
    invoke-static {}, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->getInstance()Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;

    move-result-object p2

    invoke-virtual {p2, p1}, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->switchToFPSGo(Z)V

    .line 521
    sget-boolean p2, Lcom/mediatek/boostfwk/utils/LogUtil;->DEBUG:Z

    if-eqz p2, :cond_2

    .line 522
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string/jumbo v0, "update state to "

    invoke-virtual {p2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    if-eqz p1, :cond_1

    const-string v0, "fling"

    goto :goto_0

    :cond_1
    const-string v0, "finish"

    :goto_0
    invoke-virtual {p2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    const-string v0, "ScrollIdentify"

    invoke-static {v0, p2}, Lcom/mediatek/boostfwk/utils/LogUtil;->mLogd(Ljava/lang/String;Ljava/lang/String;)V

    .line 524
    :cond_2
    invoke-static {p1}, Lcom/mediatek/boostfwk/info/ScrollState;->setFling(Z)V

    .line 525
    invoke-static {}, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->getInstance()Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;

    move-result-object p2

    invoke-virtual {p2, p1}, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->setFling(Z)V

    .line 526
    invoke-static {}, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->getInstance()Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;

    move-result-object p2

    invoke-virtual {p2, p1}, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->releaseTargetFPS(Z)V

    xor-int/2addr p1, v1

    .line 527
    invoke-direct {p0, p1}, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->resetInputFlag(Z)V

    return-void
.end method

.method private initMinValuesIfNeeded()V
    .locals 3

    .line 344
    iget v0, p0, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->minVelocityHorizontal:F

    const/high16 v1, -0x40800000    # -1.0f

    cmpl-float v0, v0, v1

    if-eqz v0, :cond_0

    iget v0, p0, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->minTouchDistanceHorizontal:F

    cmpl-float v0, v0, v1

    if-eqz v0, :cond_0

    iget v0, p0, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->minTouchDistanceVertical:F

    cmpl-float v0, v0, v1

    if-eqz v0, :cond_0

    iget v0, p0, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->minVelocityVertical:F

    cmpl-float v0, v0, v1

    if-nez v0, :cond_5

    .line 346
    :cond_0
    iget-object v0, p0, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->mActivityInfo:Lcom/mediatek/boostfwk/info/ActivityInfo;

    invoke-virtual {v0}, Lcom/mediatek/boostfwk/info/ActivityInfo;->getDensity()F

    move-result v0

    const/4 v1, 0x0

    cmpl-float v1, v0, v1

    if-lez v1, :cond_1

    const/high16 v2, 0x43c80000    # 400.0f

    mul-float/2addr v2, v0

    goto :goto_0

    :cond_1
    const/high16 v2, 0x44960000    # 1200.0f

    .line 347
    :goto_0
    iput v2, p0, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->minVelocityHorizontal:F

    if-lez v1, :cond_2

    const/high16 v2, 0x42400000    # 48.0f

    mul-float/2addr v2, v0

    goto :goto_1

    :cond_2
    const/high16 v2, 0x43160000    # 150.0f

    .line 349
    :goto_1
    iput v2, p0, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->minTouchDistanceHorizontal:F

    if-lez v1, :cond_3

    const/high16 v2, 0x43af0000    # 350.0f

    mul-float/2addr v2, v0

    goto :goto_2

    :cond_3
    const/high16 v2, 0x447a0000    # 1000.0f

    .line 350
    :goto_2
    iput v2, p0, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->minVelocityVertical:F

    if-lez v1, :cond_4

    const/high16 v1, 0x428c0000    # 70.0f

    mul-float/2addr v1, v0

    goto :goto_3

    :cond_4
    const/high16 v1, 0x43480000    # 200.0f

    .line 351
    :goto_3
    iput v1, p0, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->minTouchDistanceVertical:F

    .line 352
    invoke-static {}, Lcom/mediatek/boostfwk/utils/Config;->isBoostFwkLogEnable()Z

    move-result v1

    if-eqz v1, :cond_5

    .line 353
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "onFling density="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(F)Ljava/lang/StringBuilder;

    const-string v0, " minTouchDistanceVertical="

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v0, p0, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->minTouchDistanceVertical:F

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(F)Ljava/lang/StringBuilder;

    const-string v0, " minVelocityVertical="

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v0, p0, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->minVelocityVertical:F

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(F)Ljava/lang/StringBuilder;

    const-string v0, " minVelocityHorizontal="

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v0, p0, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->minVelocityHorizontal:F

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(F)Ljava/lang/StringBuilder;

    const-string v0, "minTouchDistanceHorizontal="

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget p0, p0, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->minTouchDistanceHorizontal:F

    invoke-virtual {v1, p0}, Ljava/lang/StringBuilder;->append(F)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    const-string v0, "ScrollIdentify"

    invoke-static {v0, p0}, Lcom/mediatek/boostfwk/utils/LogUtil;->mLogd(Ljava/lang/String;Ljava/lang/String;)V

    :cond_5
    return-void
.end method

.method private inputDrawCheck(ILjava/lang/String;)V
    .locals 3

    .line 447
    iget-boolean v0, p0, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->mLastScrollerEnd:Z

    if-nez v0, :cond_0

    iget-boolean v0, p0, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->mHaveMoveEvent:Z

    if-eqz v0, :cond_2

    iget-boolean v0, p0, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->mIsInputLockAcquired:Z

    if-nez v0, :cond_2

    .line 448
    :cond_0
    iget-wide v0, p0, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->mFrameIntervalMs:J

    const/4 v2, 0x1

    shr-long/2addr v0, v2

    iput-wide v0, p0, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->mLimitVsyncTime:J

    .line 449
    invoke-direct {p0, p1}, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->boostBeginEndCheck(I)Z

    move-result p1

    iput-boolean p1, p0, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->mIsInput:Z

    .line 450
    iput-object p2, p0, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->mInputPkgName:Ljava/lang/String;

    .line 451
    invoke-static {}, Lcom/mediatek/boostfwk/utils/Config;->isBoostFwkLogEnable()Z

    move-result p1

    if-eqz p1, :cond_1

    .line 452
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "Vendor::inputDrawCheck begin, pkgName = "

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p2, ", refresh rate = "

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget p2, p0, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->mRefreshRate:F

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(F)Ljava/lang/StringBuilder;

    const-string p2, ", mFrameIntervalMs = "

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-wide v0, p0, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->mFrameIntervalMs:J

    invoke-virtual {p1, v0, v1}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    const-string p2, "ScrollIdentify"

    invoke-static {p2, p1}, Lcom/mediatek/boostfwk/utils/LogUtil;->mLogd(Ljava/lang/String;Ljava/lang/String;)V

    .line 456
    :cond_1
    iput-boolean v2, p0, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->mIsInputLockAcquired:Z

    .line 457
    iput-boolean v2, p0, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->mIsUserTouched:Z

    :cond_2
    return-void
.end method

.method private inputEventCheck(ILandroid/view/MotionEvent;)V
    .locals 6

    .line 369
    invoke-direct {p0, p1}, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->boostBeginEndCheck(I)Z

    move-result p1

    const/4 v0, 0x1

    if-eqz p1, :cond_0

    .line 373
    invoke-virtual {p2}, Landroid/view/MotionEvent;->copy()Landroid/view/MotionEvent;

    move-result-object p1

    iput-object p1, p0, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->mCurrentMotionEvent:Landroid/view/MotionEvent;

    .line 374
    invoke-virtual {p2}, Landroid/view/MotionEvent;->getActionMasked()I

    move-result p1

    if-nez p1, :cond_b

    .line 375
    iput-boolean v0, p0, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->mIsUserTouched:Z

    goto/16 :goto_2

    .line 381
    :cond_0
    invoke-virtual {p2}, Landroid/view/MotionEvent;->getActionMasked()I

    move-result p1

    .line 382
    iget-object v1, p0, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->mCurrentMotionEvent:Landroid/view/MotionEvent;

    const/4 v2, 0x3

    if-eqz v1, :cond_1

    .line 383
    invoke-virtual {v1}, Landroid/view/MotionEvent;->getActionMasked()I

    move-result v1

    if-eq p1, v1, :cond_1

    if-ne p1, v2, :cond_1

    .line 385
    iget-object p2, p0, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->mCurrentMotionEvent:Landroid/view/MotionEvent;

    move p1, v1

    :cond_1
    const/4 v1, 0x0

    const/4 v3, 0x0

    if-eqz p1, :cond_5

    if-eq p1, v0, :cond_2

    if-eq p1, v2, :cond_2

    goto :goto_0

    .line 402
    :cond_2
    invoke-static {}, Lcom/mediatek/boostfwk/utils/Config;->isBoostFwkLogEnable()Z

    move-result v4

    if-eqz v4, :cond_3

    const-string v4, "ScrollIdentify"

    const-string/jumbo v5, "touch up/cancel "

    .line 403
    invoke-static {v4, v5}, Lcom/mediatek/boostfwk/utils/LogUtil;->mLogd(Ljava/lang/String;Ljava/lang/String;)V

    .line 405
    :cond_3
    iget-boolean v4, p0, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->mHaveMoveEvent:Z

    if-eqz v4, :cond_4

    .line 406
    iput-boolean v3, p0, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->mHaveMoveEvent:Z

    .line 407
    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    const-string v5, "Boost when up/cancel "

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v4

    invoke-direct {p0, v0, v4}, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->sbeHint(ILjava/lang/String;)V

    .line 409
    :cond_4
    iput-boolean v3, p0, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->mIsInputLockAcquired:Z

    .line 410
    invoke-static {}, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->getInstance()Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;

    move-result-object v4

    invoke-virtual {v4, v3}, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->disableAndLockSFP(Z)V

    goto :goto_0

    .line 391
    :cond_5
    iput-boolean v3, p0, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->mLastScrollerEnd:Z

    .line 392
    iget-boolean v4, p0, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->mIsScrollLockAcquired:Z

    if-eqz v4, :cond_6

    iget-object v4, p0, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->scrollerLock:Ljava/lang/Object;

    if-eqz v4, :cond_6

    .line 395
    iput-object v1, p0, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->scrollerLock:Ljava/lang/Object;

    .line 396
    iput-boolean v3, p0, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->mIsScrollLockAcquired:Z

    .line 398
    :cond_6
    iput-boolean v0, p0, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->mIsUserTouched:Z

    .line 416
    :goto_0
    iget-object v3, p0, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->mGestureDetector:Landroid/view/GestureDetector;

    if-eqz v3, :cond_7

    .line 417
    invoke-virtual {v3, p2}, Landroid/view/GestureDetector;->onTouchEvent(Landroid/view/MotionEvent;)Z

    .line 420
    :cond_7
    iget-object v3, p0, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->mTouchPolicy:Lcom/mediatek/boostfwk/policy/touch/TouchPolicy;

    if-nez v3, :cond_8

    .line 421
    invoke-static {}, Lcom/mediatek/boostfwk/policy/touch/TouchPolicy;->getInstance()Lcom/mediatek/boostfwk/policy/touch/TouchPolicy;

    move-result-object v3

    iput-object v3, p0, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->mTouchPolicy:Lcom/mediatek/boostfwk/policy/touch/TouchPolicy;

    .line 425
    :cond_8
    iget-object v3, p0, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->mTouchEventListeners:Ljava/util/List;

    invoke-interface {v3}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v3

    :goto_1
    invoke-interface {v3}, Ljava/util/Iterator;->hasNext()Z

    move-result v4

    if-eqz v4, :cond_9

    invoke-interface {v3}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v4

    check-cast v4, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify$TouchEventListener;

    .line 426
    invoke-interface {v4, p2}, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify$TouchEventListener;->onTouchEvent(Landroid/view/MotionEvent;)V

    goto :goto_1

    :cond_9
    if-eq p1, v0, :cond_a

    if-ne p1, v2, :cond_b

    .line 432
    :cond_a
    iput-object v1, p0, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->mCurrentMotionEvent:Landroid/view/MotionEvent;

    :cond_b
    :goto_2
    return-void
.end method

.method private isSystemApp(Ljava/lang/String;)Z
    .locals 3

    .line 600
    invoke-static {}, Lcom/mediatek/boostfwk/utils/Config;->getBoostFwkVersion()I

    move-result v0

    const/4 v1, 0x0

    const/4 v2, 0x1

    if-le v0, v2, :cond_2

    .line 602
    sget-object p0, Lcom/mediatek/boostfwk/utils/Config;->SYSTEM_PACKAGE_ARRAY:Ljava/util/ArrayList;

    invoke-virtual {p0, p1}, Ljava/util/ArrayList;->contains(Ljava/lang/Object;)Z

    move-result p0

    if-nez p0, :cond_0

    .line 603
    invoke-static {}, Landroid/os/Process;->myProcessName()Ljava/lang/String;

    move-result-object p0

    const-string/jumbo p1, "system_server"

    invoke-virtual {p1, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p0

    if-eqz p0, :cond_1

    :cond_0
    move v1, v2

    :cond_1
    return v1

    :cond_2
    const-string v0, "android"

    .line 605
    invoke-virtual {p1, v0}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v0

    if-eqz v0, :cond_3

    .line 606
    invoke-direct {p0, p1}, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->checkSystemAPP(Ljava/lang/String;)Z

    move-result p0

    if-eqz p0, :cond_3

    move v1, v2

    :cond_3
    return v1
.end method

.method private resetInputFlag(Z)V
    .locals 2

    if-eqz p1, :cond_0

    const/4 v0, 0x0

    .line 533
    iput-boolean v0, p0, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->mIsInput:Z

    const-string v1, ""

    .line 534
    iput-object v1, p0, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->mInputPkgName:Ljava/lang/String;

    .line 535
    iput-boolean v0, p0, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->mIsUserTouched:Z

    .line 537
    :cond_0
    iput-boolean p1, p0, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->mLastScrollerEnd:Z

    return-void
.end method

.method private sbeHint(ILjava/lang/String;)V
    .locals 2

    .line 639
    invoke-static {}, Lcom/mediatek/boostfwk/utils/Config;->isBoostFwkLogEnable()Z

    move-result v0

    if-eqz v0, :cond_0

    if-eqz p2, :cond_0

    .line 640
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string/jumbo v1, "step="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, " "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    const-string v0, "ScrollIdentify"

    invoke-static {v0, p2}, Lcom/mediatek/boostfwk/utils/LogUtil;->mLogd(Ljava/lang/String;Ljava/lang/String;)V

    :cond_0
    const/4 p2, 0x2

    if-eq p1, p2, :cond_1

    const/4 p2, 0x3

    if-ne p1, p2, :cond_2

    .line 642
    :cond_1
    sget p2, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->mIsSpecialPageDesign:I

    if-eqz p2, :cond_2

    const/16 v0, 0x80

    if-eq p2, v0, :cond_2

    .line 646
    invoke-static {}, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->getInstance()Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;

    move-result-object p0

    sget p2, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->mIsSpecialPageDesign:I

    invoke-virtual {p0, p1, p2}, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->scrollHint(II)V

    return-void

    .line 650
    :cond_2
    iget-boolean p0, p0, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->mIsInputLockAcquired:Z

    if-eqz p0, :cond_3

    .line 651
    invoke-static {}, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->getInstance()Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;

    move-result-object p0

    sget p2, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->mIsSpecialPageDesign:I

    invoke-virtual {p0, p1, p2}, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->scrollHint(II)V

    :cond_3
    return-void
.end method

.method private updateRefreshRate()V
    .locals 2

    .line 255
    invoke-static {}, Lcom/mediatek/boostfwk/info/ScrollState;->getRefreshRate()F

    move-result v0

    .line 256
    iget v1, p0, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->mRefreshRate:F

    cmpl-float v1, v0, v1

    if-nez v1, :cond_0

    return-void

    .line 259
    :cond_0
    iput v0, p0, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->mRefreshRate:F

    const/high16 v1, 0x447a0000    # 1000.0f

    div-float/2addr v1, v0

    float-to-long v0, v1

    .line 260
    iput-wide v0, p0, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->mFrameIntervalMs:J

    return-void
.end method


# virtual methods
.method public disableForSpecialRate()Z
    .locals 3

    .line 267
    invoke-static {}, Lcom/mediatek/boostfwk/utils/Config;->isBoostFwkScrollIdentifyOn60hz()Z

    move-result v0

    if-eqz v0, :cond_0

    iget v0, p0, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->mRefreshRate:F

    const/high16 v1, 0x42700000    # 60.0f

    cmpl-float v0, v0, v1

    if-nez v0, :cond_0

    const/4 v0, 0x1

    goto :goto_0

    :cond_0
    const/4 v0, 0x0

    .line 269
    :goto_0
    invoke-static {}, Lcom/mediatek/boostfwk/utils/Config;->isBoostFwkLogEnable()Z

    move-result v1

    if-eqz v1, :cond_1

    if-eqz v0, :cond_1

    .line 270
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "filter specila rate when scrolling: "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget p0, p0, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->mRefreshRate:F

    invoke-virtual {v1, p0}, Ljava/lang/StringBuilder;->append(F)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    const-string v1, "ScrollIdentify"

    invoke-static {v1, p0}, Lcom/mediatek/boostfwk/utils/LogUtil;->mLogd(Ljava/lang/String;Ljava/lang/String;)V

    :cond_1
    return v0
.end method

.method public dispatchScenario(Lcom/mediatek/boostfwk/scenario/BasicScenario;)Z
    .locals 12

    .line 152
    invoke-static {}, Lcom/mediatek/boostfwk/utils/Config;->isBoostFwkScrollIdentify()Z

    move-result v0

    const/4 v1, 0x0

    if-eqz v0, :cond_13

    if-eqz p1, :cond_13

    .line 153
    check-cast p1, Lcom/mediatek/boostfwk/scenario/scroll/ScrollScenario;

    .line 154
    invoke-virtual {p1}, Lcom/mediatek/boostfwk/scenario/scroll/ScrollScenario;->getScenarioAction()I

    move-result v0

    .line 155
    invoke-virtual {p1}, Lcom/mediatek/boostfwk/scenario/scroll/ScrollScenario;->getBoostStatus()I

    move-result v2

    .line 156
    invoke-virtual {p1}, Lcom/mediatek/boostfwk/scenario/scroll/ScrollScenario;->getScenarioInputEvent()Landroid/view/MotionEvent;

    move-result-object v3

    .line 157
    invoke-virtual {p1}, Lcom/mediatek/boostfwk/scenario/scroll/ScrollScenario;->getScenarioObj()Ljava/lang/Object;

    move-result-object v4

    .line 161
    invoke-virtual {p1}, Lcom/mediatek/boostfwk/scenario/scroll/ScrollScenario;->getScenarioContext()Landroid/content/Context;

    move-result-object v5

    const/4 v6, 0x0

    if-eqz v5, :cond_0

    .line 162
    invoke-virtual {p1}, Lcom/mediatek/boostfwk/scenario/scroll/ScrollScenario;->getScenarioContext()Landroid/content/Context;

    move-result-object v5

    goto :goto_0

    :cond_0
    move-object v5, v6

    :goto_0
    if-nez v5, :cond_1

    return v1

    .line 168
    :cond_1
    iget-object v7, p0, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->mActivityInfo:Lcom/mediatek/boostfwk/info/ActivityInfo;

    if-nez v7, :cond_2

    .line 169
    invoke-static {}, Lcom/mediatek/boostfwk/info/ActivityInfo;->getInstance()Lcom/mediatek/boostfwk/info/ActivityInfo;

    move-result-object v7

    iput-object v7, p0, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->mActivityInfo:Lcom/mediatek/boostfwk/info/ActivityInfo;

    .line 172
    :cond_2
    iget-object v7, p0, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->mActivityInfo:Lcom/mediatek/boostfwk/info/ActivityInfo;

    invoke-virtual {v7}, Lcom/mediatek/boostfwk/info/ActivityInfo;->getPackageName()Ljava/lang/String;

    move-result-object v7

    if-nez v7, :cond_3

    .line 174
    invoke-virtual {v5}, Landroid/content/Context;->getPackageName()Ljava/lang/String;

    move-result-object v7

    :cond_3
    if-nez v7, :cond_4

    return v1

    .line 182
    :cond_4
    iget-object v8, p0, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->mDispatcherPkgName:Ljava/lang/String;

    const/4 v9, -0x1

    if-eqz v8, :cond_5

    invoke-virtual {v8, v7}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v8

    if-nez v8, :cond_6

    .line 183
    :cond_5
    iput v9, p0, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->mApplicationType:I

    .line 186
    :cond_6
    iget v8, p0, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->mApplicationType:I

    if-ne v8, v9, :cond_7

    .line 187
    invoke-direct {p0, v7}, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->checkAppType(Ljava/lang/String;)V

    .line 190
    :cond_7
    iget v8, p0, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->mApplicationType:I

    const/4 v9, 0x1

    if-eq v8, v9, :cond_12

    const/4 v10, 0x4

    if-eq v8, v10, :cond_12

    const/4 v10, 0x5

    if-ne v8, v10, :cond_8

    goto/16 :goto_3

    .line 198
    :cond_8
    iget-object v8, p0, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->mGestureDetector:Landroid/view/GestureDetector;

    const-string v10, "ScrollIdentify"

    if-nez v8, :cond_a

    .line 200
    :try_start_0
    new-instance v8, Landroid/view/GestureDetector;

    new-instance v11, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify$ScrollGestureListener;

    invoke-direct {v11, p0}, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify$ScrollGestureListener;-><init>(Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;)V

    invoke-direct {v8, v5, v11}, Landroid/view/GestureDetector;-><init>(Landroid/content/Context;Landroid/view/GestureDetector$OnGestureListener;)V

    iput-object v8, p0, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->mGestureDetector:Landroid/view/GestureDetector;
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_1

    .line 203
    :catch_0
    invoke-static {}, Lcom/mediatek/boostfwk/utils/Config;->isBoostFwkLogEnable()Z

    move-result p1

    if-eqz p1, :cond_9

    const-string p1, "layout not inflate, cannot create GestureDetector,try to next time."

    .line 204
    invoke-static {v10, p1}, Lcom/mediatek/boostfwk/utils/LogUtil;->mLoge(Ljava/lang/String;Ljava/lang/String;)V

    .line 207
    :cond_9
    iput-object v6, p0, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->mGestureDetector:Landroid/view/GestureDetector;

    return v1

    .line 213
    :cond_a
    :goto_1
    invoke-direct {p0}, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->updateRefreshRate()V

    .line 214
    iput-object v7, p0, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->mDispatcherPkgName:Ljava/lang/String;

    .line 216
    invoke-static {}, Lcom/mediatek/boostfwk/utils/Config;->isBoostFwkLogEnable()Z

    move-result v1

    if-eqz v1, :cond_b

    .line 217
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v1, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v6, ", Scroll action dispatcher to = "

    invoke-virtual {v1, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v6, " status = "

    invoke-virtual {v1, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v6, ", viewContext = "

    invoke-virtual {v1, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {v10, v1}, Lcom/mediatek/boostfwk/utils/LogUtil;->mLogd(Ljava/lang/String;Ljava/lang/String;)V

    .line 221
    :cond_b
    sget-boolean v1, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->PRE_ANIM_ENABLE:Z

    invoke-virtual {p1, v1}, Lcom/mediatek/boostfwk/scenario/scroll/ScrollScenario;->setSFPEnable(Z)Lcom/mediatek/boostfwk/scenario/scroll/ScrollScenario;

    if-eqz v0, :cond_10

    if-eq v0, v9, :cond_f

    const/4 p1, 0x2

    if-eq v0, p1, :cond_e

    const/4 p1, 0x3

    if-eq v0, p1, :cond_c

    const-string p0, "Not found dispatcher scroll action."

    .line 246
    invoke-static {v10, p0}, Lcom/mediatek/boostfwk/utils/LogUtil;->mLogw(Ljava/lang/String;Ljava/lang/String;)V

    goto :goto_2

    .line 236
    :cond_c
    iget-boolean p1, p0, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->mHaveMoveEvent:Z

    if-eqz p1, :cond_11

    .line 237
    invoke-static {}, Lcom/mediatek/boostfwk/utils/Config;->isBoostFwkLogEnable()Z

    move-result p1

    if-eqz p1, :cond_d

    const-string/jumbo p1, "using scroller when HORIZONTAL scroll"

    .line 238
    invoke-static {v10, p1}, Lcom/mediatek/boostfwk/utils/LogUtil;->mLogd(Ljava/lang/String;Ljava/lang/String;)V

    :cond_d
    const/4 p1, -0x2

    .line 242
    invoke-virtual {p0, p1, v7, v4}, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->inertialScrollCheck(ILjava/lang/String;Ljava/lang/Object;)V

    goto :goto_2

    .line 233
    :cond_e
    invoke-virtual {p0, v2, v7, v4}, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->inertialScrollCheck(ILjava/lang/String;Ljava/lang/Object;)V

    goto :goto_2

    .line 230
    :cond_f
    invoke-direct {p0, v2, v7}, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->inputDrawCheck(ILjava/lang/String;)V

    goto :goto_2

    :cond_10
    if-eqz v3, :cond_11

    .line 226
    invoke-direct {p0, v2, v3}, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->inputEventCheck(ILandroid/view/MotionEvent;)V

    :cond_11
    :goto_2
    return v9

    .line 193
    :cond_12
    :goto_3
    iput-object v7, p0, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->mDispatcherPkgName:Ljava/lang/String;

    :cond_13
    return v1
.end method

.method public inertialScrollCheck(ILjava/lang/String;Ljava/lang/Object;)V
    .locals 5

    .line 469
    iget-boolean v0, p0, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->mIsUserTouched:Z

    const-string v1, "ScrollIdentify"

    if-eqz v0, :cond_6

    iget-object v0, p0, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->mActivityInfo:Lcom/mediatek/boostfwk/info/ActivityInfo;

    const/16 v2, 0x80

    invoke-virtual {v0, v2}, Lcom/mediatek/boostfwk/info/ActivityInfo;->isPage(I)Z

    move-result v0

    if-eqz v0, :cond_0

    goto :goto_1

    :cond_0
    const/4 v0, -0x2

    const/4 v2, 0x0

    const/4 v3, 0x1

    if-ne p1, v0, :cond_1

    .line 479
    invoke-static {}, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->getInstance()Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;

    move-result-object p1

    invoke-virtual {p1, v3}, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->switchToFPSGo(Z)V

    .line 481
    iput-boolean v2, p0, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->mIsScrollLockAcquired:Z

    return-void

    .line 485
    :cond_1
    invoke-static {}, Lcom/mediatek/boostfwk/utils/Config;->isBoostFwkLogEnable()Z

    move-result v0

    if-eqz v0, :cond_2

    .line 486
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "inertialScrollCheck action="

    invoke-virtual {v0, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v4, " pkgName="

    invoke-virtual {v0, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v4, " obj="

    invoke-virtual {v0, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string v4, " "

    invoke-virtual {v0, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v4, p0, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->scrollerLock:Ljava/lang/Object;

    invoke-virtual {v0, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v1, v0}, Lcom/mediatek/boostfwk/utils/LogUtil;->mLogd(Ljava/lang/String;Ljava/lang/String;)V

    .line 489
    :cond_2
    invoke-direct {p0, p1}, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->boostBeginEndCheck(I)Z

    move-result p1

    .line 491
    invoke-direct {p0, p1, p3}, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->checkScroller(ZLjava/lang/Object;)Z

    move-result p3

    if-nez p3, :cond_3

    return-void

    .line 495
    :cond_3
    iget-boolean p3, p0, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->mIsScrollLockAcquired:Z

    if-nez p3, :cond_4

    if-eqz p1, :cond_4

    .line 496
    invoke-direct {p0, v3, p2}, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->inertialScrollHint(ZLjava/lang/String;)V

    .line 497
    iput-boolean v3, p0, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->mIsScrollLockAcquired:Z

    goto :goto_0

    :cond_4
    if-eqz p3, :cond_5

    if-nez p1, :cond_5

    .line 499
    invoke-direct {p0, v2, p2}, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->inertialScrollHint(ZLjava/lang/String;)V

    .line 500
    iput-boolean v2, p0, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->mIsScrollLockAcquired:Z

    :cond_5
    :goto_0
    return-void

    .line 470
    :cond_6
    :goto_1
    invoke-static {}, Lcom/mediatek/boostfwk/utils/Config;->isBoostFwkLogEnable()Z

    move-result p1

    if-eqz p1, :cond_7

    .line 471
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string p2, "inertialScrollCheck mIsUserTouched="

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-boolean p0, p0, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->mIsUserTouched:Z

    invoke-virtual {p1, p0}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string p0, " mIsSpecialPageDesign="

    invoke-virtual {p1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    sget p0, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->mIsSpecialPageDesign:I

    invoke-virtual {p1, p0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {v1, p0}, Lcom/mediatek/boostfwk/utils/LogUtil;->mLogd(Ljava/lang/String;Ljava/lang/String;)V

    :cond_7
    return-void
.end method

.method public isScroll()Z
    .locals 1

    .line 657
    sget-object v0, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->SCROLL_LOCK:Ljava/lang/Object;

    monitor-enter v0

    .line 658
    :try_start_0
    iget-boolean p0, p0, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->mIsScrolling:Z

    monitor-exit v0

    return p0

    :catchall_0
    move-exception p0

    .line 659
    monitor-exit v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    throw p0
.end method

.method public registerTouchEventListener(Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify$TouchEventListener;)V
    .locals 0

    if-nez p1, :cond_0

    return-void

    .line 681
    :cond_0
    iget-object p0, p0, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->mTouchEventListeners:Ljava/util/List;

    invoke-interface {p0, p1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    return-void
.end method

.method public setScrolling(ZLjava/lang/String;)V
    .locals 1

    .line 663
    sget-object v0, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->SCROLL_LOCK:Ljava/lang/Object;

    monitor-enter v0

    .line 664
    :try_start_0
    iput-boolean p1, p0, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->mIsScrolling:Z

    .line 665
    invoke-static {}, Lcom/mediatek/boostfwk/utils/Config;->isBoostFwkLogEnable()Z

    move-result p1

    if-eqz p1, :cond_0

    .line 666
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p2, " curScrollingState="

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-boolean p0, p0, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->mIsScrolling:Z

    .line 667
    invoke-static {p0}, Ljava/lang/String;->valueOf(Z)Ljava/lang/String;

    move-result-object p0

    invoke-virtual {p1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    const-wide/16 p1, 0x8

    .line 666
    invoke-static {p1, p2, p0}, Landroid/os/Trace;->traceBegin(JLjava/lang/String;)V

    .line 668
    invoke-static {p1, p2}, Landroid/os/Trace;->traceEnd(J)V

    .line 670
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
