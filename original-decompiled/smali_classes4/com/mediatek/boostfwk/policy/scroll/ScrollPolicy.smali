.class public Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;
.super Ljava/lang/Object;
.source "ScrollPolicy.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy$WorkerHandler;
    }
.end annotation


# static fields
.field private static final ENABLE_SCROLL_COMMON_POLICY:Z

.field private static final FPSGO_CONTROL:I = 0x1

.field private static final FPSGO_GCC_DISABLE:I = 0x10

.field private static final FPSGO_MAX_TARGET_FPS:I = 0x2

.field private static final FPSGO_QUOTA_DISABLE:I = 0x20

.field private static final FPSGO_RESCUE_ENABLE:I = 0x4

.field private static final FPSGO_RL_ENABLE:I = 0x8

.field private static MTKPOWER_HINT_UX_MOVE_SCROLLING:I = 0x0

.field private static MTKPOWER_HINT_UX_SCROLLING:I = 0x0

.field private static MTKPOWER_HINT_UX_SCROLLING_COMMON:I = 0x0

.field private static NON_RENDER_THREAD_TID:I = 0x0

.field private static final PERF_RES_FPS_FBT_RESCUE_ENABLE_PID:I = 0x2000600

.field private static final PERF_RES_FPS_FPSGO_CTL:I = 0x2000300

.field private static final PERF_RES_FPS_FPSGO_NOCTL:I = 0x2000400

.field private static final PERF_RES_FPS_FPSGO_UBOOST:I = 0x2048700

.field private static final PERF_RES_FPS_FSTB_TARGET_FPS_PID:I = 0x2000200

.field private static final PERF_RES_POWERHAL_TOUCH_BOOST_ENABLE:I = 0x3408500

.field private static RENDER_TID_NON_CHECK:I = 0x0

.field private static final TAG:Ljava/lang/String; = "ScrollPolicy"

.field private static isCorrectFPS:Z = false

.field private static lock:Ljava/lang/Object; = null

.field private static mBoostHandle:I = 0x0

.field private static mCheckCommonPolicyTime:J = 0x0L

.field private static mCheckFPSTime:J = 0x0L

.field private static mDelayReleaseFpsTime:J = 0x0L

.field private static mFlingPolicyExeCount:I = 0x0

.field private static mFlutterRenderTid:I = 0x0

.field private static mPolicyExeCount:I = 0x0

.field private static mPowerHalService:Lcom/mediatek/powerhalmgr/PowerHalMgr; = null

.field private static mPowerHandle:I = 0x0

.field private static mReleaseFPSDuration:I = 0x0

.field private static mRenderThreadTid:I = 0x0

.field private static mSpecialAppDesign:I = 0x0

.field private static mWebviewRenderPid:I = 0x0

.field public static final sFINGER_MOVE:I = 0x0

.field public static final sFINGER_UP:I = 0x1

.field public static final sFLING_HORIZONTAL:I = 0x3

.field public static final sFLING_VERTICAL:I = 0x2

.field private static sInstance:Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy; = null

.field private static final sTHREAD_NAME:Ljava/lang/String; = "ScrollPolicy"

.field public static useFPSGo:Z


# instance fields
.field private final WEBVIEW_FLUTTER_FPSGO_CTRL_MASK:I

.field private fpsgoUnderCtrlWhenFling:Z

.field private mActivityInfo:Lcom/mediatek/boostfwk/info/ActivityInfo;

.field private mCommonPolicyEnabled:Z

.field private mCurrentScrollStep:I

.field private mDisableScrollPolicy:Z

.field private mIMEStateListener:Lcom/mediatek/boostfwk/identify/ime/IMEIdentify$IMEStateListener;

.field private mIsRealAOSPPage:Z

.field private mLastScrollTimeMS:J

.field private mPerfLockRscList:Ljava/util/ArrayList;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/ArrayList<",
            "Ljava/lang/Integer;",
            ">;"
        }
    .end annotation
.end field

.field private mPowerHalWrap:Lcom/mediatek/powerhalwrapper/PowerHalWrapper;

.field private mWorkerHandler:Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy$WorkerHandler;

.field private mWorkerThread:Landroid/os/HandlerThread;

.field private scrollingFingStep:I

.field private uboostEnable:Z

.field private waitingForReleaseFpsgo:Z

.field private waitingForReleaseFpsgoStep:I


# direct methods
.method static bridge synthetic -$$Nest$fgetmWorkerHandler(Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;)Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy$WorkerHandler;
    .locals 0

    iget-object p0, p0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->mWorkerHandler:Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy$WorkerHandler;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetscrollingFingStep(Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;)I
    .locals 0

    iget p0, p0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->scrollingFingStep:I

    return p0
.end method

.method static bridge synthetic -$$Nest$fgetwaitingForReleaseFpsgoStep(Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;)I
    .locals 0

    iget p0, p0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->waitingForReleaseFpsgoStep:I

    return p0
.end method

.method static bridge synthetic -$$Nest$fputmDisableScrollPolicy(Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;Z)V
    .locals 0

    iput-boolean p1, p0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->mDisableScrollPolicy:Z

    return-void
.end method

.method static bridge synthetic -$$Nest$fputwaitingForReleaseFpsgo(Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;Z)V
    .locals 0

    iput-boolean p1, p0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->waitingForReleaseFpsgo:Z

    return-void
.end method

.method static bridge synthetic -$$Nest$fputwaitingForReleaseFpsgoStep(Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;I)V
    .locals 0

    iput p1, p0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->waitingForReleaseFpsgoStep:I

    return-void
.end method

.method static bridge synthetic -$$Nest$mdelayReleaseTargetFPSInternal(Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;)V
    .locals 0

    invoke-direct {p0}, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->delayReleaseTargetFPSInternal()V

    return-void
.end method

.method static bridge synthetic -$$Nest$menableFPSGo(Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;ZI)V
    .locals 0

    invoke-direct {p0, p1, p2}, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->enableFPSGo(ZI)V

    return-void
.end method

.method static bridge synthetic -$$Nest$mmtkScrollingFlingPolicy(Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;Z)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->mtkScrollingFlingPolicy(Z)V

    return-void
.end method

.method static bridge synthetic -$$Nest$mmtkScrollingPolicy(Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;Z)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->mtkScrollingPolicy(Z)V

    return-void
.end method

.method static bridge synthetic -$$Nest$mreleaseTargetFPSInternel(Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;Z)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->releaseTargetFPSInternel(Z)V

    return-void
.end method

.method static bridge synthetic -$$Nest$mscrollCommonPolicyCheck(Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;)V
    .locals 0

    invoke-direct {p0}, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->scrollCommonPolicyCheck()V

    return-void
.end method

.method static bridge synthetic -$$Nest$sfgetmFlingPolicyExeCount()I
    .locals 1

    sget v0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->mFlingPolicyExeCount:I

    return v0
.end method

.method static bridge synthetic -$$Nest$sfgetmPolicyExeCount()I
    .locals 1

    sget v0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->mPolicyExeCount:I

    return v0
.end method

.method static bridge synthetic -$$Nest$sfputisCorrectFPS(Z)V
    .locals 0

    sput-boolean p0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->isCorrectFPS:Z

    return-void
.end method

.method static bridge synthetic -$$Nest$sfputmFlingPolicyExeCount(I)V
    .locals 0

    sput p0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->mFlingPolicyExeCount:I

    return-void
.end method

.method static bridge synthetic -$$Nest$sfputmPolicyExeCount(I)V
    .locals 0

    sput p0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->mPolicyExeCount:I

    return-void
.end method

.method static constructor <clinit>()V
    .locals 5

    .line 66
    new-instance v0, Ljava/lang/Object;

    invoke-direct {v0}, Ljava/lang/Object;-><init>()V

    sput-object v0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->lock:Ljava/lang/Object;

    .line 69
    invoke-static {}, Lcom/mediatek/boostfwk/utils/Config;->getBoostFwkVersion()I

    move-result v0

    const/4 v1, 0x1

    const/4 v2, 0x0

    if-le v0, v1, :cond_0

    .line 70
    invoke-static {}, Lcom/mediatek/boostfwk/utils/Config;->isEnableScrollCommonPolicy()Z

    move-result v0

    if-eqz v0, :cond_0

    goto :goto_0

    :cond_0
    move v1, v2

    :goto_0
    sput-boolean v1, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->ENABLE_SCROLL_COMMON_POLICY:Z

    .line 74
    invoke-static {}, Lcom/mediatek/powerhalmgr/PowerHalMgrFactory;->getInstance()Lcom/mediatek/powerhalmgr/PowerHalMgrFactory;

    move-result-object v0

    invoke-virtual {v0}, Lcom/mediatek/powerhalmgr/PowerHalMgrFactory;->makePowerHalMgr()Lcom/mediatek/powerhalmgr/PowerHalMgr;

    move-result-object v0

    sput-object v0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->mPowerHalService:Lcom/mediatek/powerhalmgr/PowerHalMgr;

    .line 76
    sput v2, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->mPowerHandle:I

    .line 78
    sput v2, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->mBoostHandle:I

    .line 82
    invoke-static {}, Lcom/mediatek/boostfwk/utils/Config;->getVerticalScrollDuration()I

    move-result v0

    sput v0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->mReleaseFPSDuration:I

    const/high16 v0, -0x80000000

    .line 84
    sput v0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->RENDER_TID_NON_CHECK:I

    const/4 v1, -0x1

    .line 85
    sput v1, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->NON_RENDER_THREAD_TID:I

    .line 86
    sput v0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->mRenderThreadTid:I

    .line 87
    sput v0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->mWebviewRenderPid:I

    .line 88
    sput v0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->mFlutterRenderTid:I

    const/16 v0, 0x2b

    .line 96
    sput v0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->MTKPOWER_HINT_UX_SCROLLING:I

    const/16 v0, 0x2d

    .line 98
    sput v0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->MTKPOWER_HINT_UX_MOVE_SCROLLING:I

    const/16 v0, 0x31

    .line 100
    sput v0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->MTKPOWER_HINT_UX_SCROLLING_COMMON:I

    const-wide/16 v3, 0x64

    .line 121
    sput-wide v3, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->mCheckFPSTime:J

    const-wide/16 v3, 0x32

    .line 122
    sput-wide v3, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->mCheckCommonPolicyTime:J

    .line 123
    invoke-static {}, Lcom/mediatek/boostfwk/utils/Config;->getFpsgoReleaseTime()I

    move-result v0

    int-to-long v3, v0

    sput-wide v3, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->mDelayReleaseFpsTime:J

    .line 124
    sput-boolean v2, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->isCorrectFPS:Z

    .line 125
    sput v2, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->mPolicyExeCount:I

    .line 126
    sput v2, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->mFlingPolicyExeCount:I

    .line 127
    sput v1, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->mSpecialAppDesign:I

    .line 132
    sput-boolean v2, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->useFPSGo:Z

    return-void
.end method

.method public constructor <init>()V
    .locals 3

    .line 185
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    const/4 v0, 0x0

    .line 71
    iput-object v0, p0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->mWorkerThread:Landroid/os/HandlerThread;

    .line 72
    iput-object v0, p0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->mWorkerHandler:Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy$WorkerHandler;

    .line 75
    iput-object v0, p0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->mPowerHalWrap:Lcom/mediatek/powerhalwrapper/PowerHalWrapper;

    .line 79
    new-instance v0, Ljava/util/ArrayList;

    const/16 v1, 0xa

    invoke-direct {v0, v1}, Ljava/util/ArrayList;-><init>(I)V

    iput-object v0, p0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->mPerfLockRscList:Ljava/util/ArrayList;

    const/16 v0, 0x37

    .line 117
    iput v0, p0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->WEBVIEW_FLUTTER_FPSGO_CTRL_MASK:I

    const/4 v0, 0x0

    .line 133
    iput-boolean v0, p0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->waitingForReleaseFpsgo:Z

    const/4 v1, -0x1

    .line 134
    iput v1, p0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->waitingForReleaseFpsgoStep:I

    .line 135
    iput-boolean v0, p0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->fpsgoUnderCtrlWhenFling:Z

    .line 136
    iput-boolean v0, p0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->uboostEnable:Z

    .line 138
    iput-boolean v0, p0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->mDisableScrollPolicy:Z

    .line 139
    iput-boolean v0, p0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->mCommonPolicyEnabled:Z

    .line 140
    iput v1, p0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->mCurrentScrollStep:I

    .line 141
    iput v1, p0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->scrollingFingStep:I

    const-wide/16 v1, -0x1

    .line 142
    iput-wide v1, p0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->mLastScrollTimeMS:J

    .line 145
    iput-boolean v0, p0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->mIsRealAOSPPage:Z

    .line 150
    new-instance v0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy$1;

    invoke-direct {v0, p0}, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy$1;-><init>(Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;)V

    iput-object v0, p0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->mIMEStateListener:Lcom/mediatek/boostfwk/identify/ime/IMEIdentify$IMEStateListener;

    .line 186
    invoke-direct {p0}, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->initThread()V

    .line 187
    invoke-static {}, Lcom/mediatek/boostfwk/identify/ime/IMEIdentify;->getInstance()Lcom/mediatek/boostfwk/identify/ime/IMEIdentify;

    move-result-object v0

    iget-object v1, p0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->mIMEStateListener:Lcom/mediatek/boostfwk/identify/ime/IMEIdentify$IMEStateListener;

    invoke-virtual {v0, v1}, Lcom/mediatek/boostfwk/identify/ime/IMEIdentify;->registerIMEStateListener(Lcom/mediatek/boostfwk/identify/ime/IMEIdentify$IMEStateListener;)V

    .line 188
    invoke-static {}, Lcom/mediatek/boostfwk/info/ActivityInfo;->getInstance()Lcom/mediatek/boostfwk/info/ActivityInfo;

    move-result-object v0

    iput-object v0, p0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->mActivityInfo:Lcom/mediatek/boostfwk/info/ActivityInfo;

    return-void
.end method

.method private commands2String([I)Ljava/lang/String;
    .locals 3

    const-string p0, ""

    if-eqz p1, :cond_1

    .line 635
    array-length v0, p1

    if-eqz v0, :cond_1

    sget-boolean v0, Lcom/mediatek/boostfwk/utils/LogUtil;->DEBUG:Z

    if-nez v0, :cond_0

    goto :goto_2

    .line 639
    :cond_0
    array-length v0, p1

    const/4 v1, 0x0

    :goto_0
    if-ge v1, v0, :cond_1

    .line 641
    aget v2, p1, v1

    sparse-switch v2, :sswitch_data_0

    .line 655
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v2, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    aget p0, p1, v1

    invoke-static {p0}, Ljava/lang/String;->valueOf(I)Ljava/lang/String;

    move-result-object p0

    invoke-virtual {v2, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p0, " "

    invoke-virtual {v2, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    goto :goto_1

    .line 652
    :sswitch_0
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v2, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p0, " PERF_RES_FPS_FBT_RESCUE_ENABLE_PID "

    invoke-virtual {v2, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    goto :goto_1

    .line 646
    :sswitch_1
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v2, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p0, " PERF_RES_FPS_FPSGO_NOCTL "

    invoke-virtual {v2, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    goto :goto_1

    .line 643
    :sswitch_2
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v2, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p0, " PERF_RES_FPS_FPSGO_CTL "

    invoke-virtual {v2, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    goto :goto_1

    .line 649
    :sswitch_3
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v2, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p0, " PERF_RES_FPS_FSTB_TARGET_FPS_PID "

    invoke-virtual {v2, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    :goto_1
    add-int/lit8 v1, v1, 0x1

    goto :goto_0

    :cond_1
    :goto_2
    return-object p0

    nop

    :sswitch_data_0
    .sparse-switch
        0x2000200 -> :sswitch_3
        0x2000300 -> :sswitch_2
        0x2000400 -> :sswitch_1
        0x2000600 -> :sswitch_0
    .end sparse-switch
.end method

.method private controlFpsgoInternal([ILjava/lang/String;)V
    .locals 1

    .line 623
    sget-boolean v0, Lcom/mediatek/boostfwk/utils/LogUtil;->DEBUG:Z

    if-eqz v0, :cond_0

    .line 624
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v0, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p2, " control Fpsgo "

    invoke-virtual {v0, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-direct {p0, p1}, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->commands2String([I)Ljava/lang/String;

    move-result-object p2

    invoke-virtual {v0, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    const-string v0, "ScrollPolicy"

    invoke-static {v0, p2}, Lcom/mediatek/boostfwk/utils/LogUtil;->traceBeginAndLog(Ljava/lang/String;Ljava/lang/String;)V

    .line 626
    :cond_0
    iget-object p2, p0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->mActivityInfo:Lcom/mediatek/boostfwk/info/ActivityInfo;

    invoke-virtual {p2}, Lcom/mediatek/boostfwk/info/ActivityInfo;->isSpecialPageDesign()Z

    move-result p2

    if-nez p2, :cond_1

    iget-object p2, p0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->mActivityInfo:Lcom/mediatek/boostfwk/info/ActivityInfo;

    .line 627
    invoke-virtual {p2}, Lcom/mediatek/boostfwk/info/ActivityInfo;->isAOSPPageDesign()Z

    move-result p2

    if-eqz p2, :cond_2

    .line 628
    invoke-static {}, Lcom/mediatek/boostfwk/utils/Config;->isDisableFrameDecision()Z

    move-result p2

    if-eqz p2, :cond_2

    .line 629
    :cond_1
    invoke-direct {p0, p1}, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->perfLockAcquire([I)V

    .line 631
    :cond_2
    invoke-static {}, Lcom/mediatek/boostfwk/utils/LogUtil;->traceEnd()V

    return-void
.end method

.method private delayControlFpsgo(IZ)V
    .locals 5

    const/4 v0, 0x0

    const/16 v1, 0xb

    if-nez p2, :cond_0

    .line 481
    iget-object p1, p0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->mWorkerHandler:Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy$WorkerHandler;

    invoke-virtual {p1, v1, v0}, Landroid/os/Handler;->removeMessages(ILjava/lang/Object;)V

    const/4 p1, -0x1

    .line 483
    iput p1, p0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->waitingForReleaseFpsgoStep:I

    goto :goto_0

    .line 484
    :cond_0
    iget-boolean v2, p0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->waitingForReleaseFpsgo:Z

    if-nez v2, :cond_1

    .line 488
    iget-object v2, p0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->mWorkerHandler:Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy$WorkerHandler;

    .line 489
    invoke-virtual {v2, v1, v0}, Landroid/os/Handler;->obtainMessage(ILjava/lang/Object;)Landroid/os/Message;

    move-result-object v0

    sget-wide v3, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->mDelayReleaseFpsTime:J

    .line 488
    invoke-virtual {v2, v0, v3, v4}, Landroid/os/Handler;->sendMessageDelayed(Landroid/os/Message;J)Z

    .line 491
    iput p1, p0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->waitingForReleaseFpsgoStep:I

    .line 493
    :cond_1
    :goto_0
    iput-boolean p2, p0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->waitingForReleaseFpsgo:Z

    return-void
.end method

.method private delayReleaseTargetFPSInternal()V
    .locals 6

    .line 704
    sget-boolean v0, Lcom/mediatek/boostfwk/utils/LogUtil;->DEBUG:Z

    if-eqz v0, :cond_0

    const-string v0, "ScrollPolicy"

    const-string v1, "delay release Target FPS"

    .line 705
    invoke-static {v0, v1}, Lcom/mediatek/boostfwk/utils/LogUtil;->traceBeginAndMLogd(Ljava/lang/String;Ljava/lang/String;)V

    .line 707
    :cond_0
    invoke-direct {p0}, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->getRenderThreadTid()I

    move-result v0

    const/4 v1, 0x2

    new-array v2, v1, [I

    .line 709
    invoke-static {}, Lcom/mediatek/boostfwk/utils/Config;->isDisableFrameDecision()Z

    move-result v3

    const/4 v4, 0x1

    const/4 v5, 0x0

    if-eqz v3, :cond_1

    const v3, 0x2000200

    aput v3, v2, v5

    neg-int v0, v0

    aput v0, v2, v4

    goto :goto_0

    :cond_1
    aput v5, v2, v4

    aput v5, v2, v5

    .line 715
    :goto_0
    invoke-direct {p0, v5, v1, v2}, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->releaseFPSGOControl(ZI[I)V

    .line 716
    invoke-static {}, Lcom/mediatek/boostfwk/utils/LogUtil;->traceEnd()V

    return-void
.end method

.method private disableTouchBoost()V
    .locals 1

    const/4 v0, 0x2

    new-array v0, v0, [I

    .line 830
    fill-array-data v0, :array_0

    .line 831
    invoke-direct {p0, v0}, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->perfLockAcquire([I)V

    return-void

    :array_0
    .array-data 4
        0x3408500
        0x0
    .end array-data
.end method

.method private enableFPSGo(ZI)V
    .locals 4

    .line 460
    sget-boolean v0, Lcom/mediatek/boostfwk/utils/LogUtil;->DEBUG:Z

    if-eqz v0, :cond_1

    .line 461
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "enableFPSGo "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    if-eqz p1, :cond_0

    const-string/jumbo v1, "start"

    goto :goto_0

    :cond_0
    const-string/jumbo v1, "stop"

    :goto_0
    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    const-string v1, "ScrollPolicy"

    invoke-static {v1, v0}, Lcom/mediatek/boostfwk/utils/LogUtil;->traceBeginAndLog(Ljava/lang/String;Ljava/lang/String;)V

    .line 463
    :cond_1
    iget-object v0, p0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->mWorkerHandler:Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy$WorkerHandler;

    const/16 v1, 0xc

    invoke-virtual {v0, v1}, Landroid/os/Handler;->removeMessages(I)V

    if-eqz p1, :cond_2

    const/4 p1, 0x1

    .line 465
    invoke-direct {p0, p1, p2}, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->releaseFPSGOControl(ZI)V

    .line 467
    sget-boolean p1, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->useFPSGo:Z

    if-eqz p1, :cond_3

    .line 468
    iget-object p0, p0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->mWorkerHandler:Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy$WorkerHandler;

    const/4 p1, 0x0

    .line 469
    invoke-virtual {p0, v1, p1}, Landroid/os/Handler;->obtainMessage(ILjava/lang/Object;)Landroid/os/Message;

    move-result-object p1

    .line 471
    invoke-static {}, Lcom/mediatek/boostfwk/utils/Config;->getVerticalScrollDuration()I

    move-result p2

    int-to-long v0, p2

    sget-wide v2, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->mCheckFPSTime:J

    sub-long/2addr v0, v2

    .line 468
    invoke-virtual {p0, p1, v0, v1}, Landroid/os/Handler;->sendMessageDelayed(Landroid/os/Message;J)Z

    goto :goto_1

    :cond_2
    const/4 p1, 0x0

    .line 474
    invoke-direct {p0, p1, p2}, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->releaseFPSGOControl(ZI)V

    .line 476
    :cond_3
    :goto_1
    invoke-static {}, Lcom/mediatek/boostfwk/utils/LogUtil;->traceEnd()V

    return-void
.end method

.method private enableScrollingCommonCMD(Z)V
    .locals 6

    .line 835
    sget-boolean v0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->ENABLE_SCROLL_COMMON_POLICY:Z

    if-nez v0, :cond_0

    return-void

    .line 839
    :cond_0
    iput-boolean p1, p0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->mCommonPolicyEnabled:Z

    .line 840
    iget-object v0, p0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->mWorkerHandler:Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy$WorkerHandler;

    const/16 v1, 0xd

    invoke-virtual {v0, v1}, Landroid/os/Handler;->removeMessages(I)V

    const-string v0, "ScrollPolicy"

    if-eqz p1, :cond_2

    const-string p1, "Enable MTKPOWER_HINT_UX_SCROLLING_COMMON"

    .line 842
    invoke-static {v0, p1}, Lcom/mediatek/boostfwk/utils/LogUtil;->traceAndMLogd(Ljava/lang/String;Ljava/lang/String;)V

    .line 843
    sget-object p1, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->mPowerHalService:Lcom/mediatek/powerhalmgr/PowerHalMgr;

    sget v0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->MTKPOWER_HINT_UX_SCROLLING_COMMON:I

    .line 844
    invoke-static {}, Lcom/mediatek/boostfwk/utils/Config;->getVerticalScrollDuration()I

    move-result v2

    .line 843
    invoke-virtual {p1, v0, v2}, Lcom/mediatek/powerhalmgr/PowerHalMgr;->mtkPowerHint(II)V

    .line 845
    iget-object p1, p0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->mActivityInfo:Lcom/mediatek/boostfwk/info/ActivityInfo;

    invoke-virtual {p1}, Lcom/mediatek/boostfwk/info/ActivityInfo;->isSpecialPageDesign()Z

    move-result p1

    if-nez p1, :cond_1

    iget-boolean p1, p0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->mIsRealAOSPPage:Z

    if-eqz p1, :cond_1

    sget-boolean p1, Lcom/mediatek/boostfwk/utils/Config;->checkCommonPolicyForALL:Z

    if-eqz p1, :cond_3

    .line 851
    :cond_1
    iget-object p0, p0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->mWorkerHandler:Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy$WorkerHandler;

    .line 853
    invoke-static {}, Lcom/mediatek/boostfwk/utils/Config;->getVerticalScrollDuration()I

    move-result p1

    int-to-long v2, p1

    sget-wide v4, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->mCheckCommonPolicyTime:J

    add-long/2addr v2, v4

    .line 851
    invoke-virtual {p0, v1, v2, v3}, Landroid/os/Handler;->sendEmptyMessageDelayed(IJ)Z

    goto :goto_0

    :cond_2
    const-string p0, "Disable MTKPOWER_HINT_UX_SCROLLING_COMMON"

    .line 856
    invoke-static {v0, p0}, Lcom/mediatek/boostfwk/utils/LogUtil;->traceAndMLogd(Ljava/lang/String;Ljava/lang/String;)V

    .line 857
    sget-object p0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->mPowerHalService:Lcom/mediatek/powerhalmgr/PowerHalMgr;

    sget p1, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->MTKPOWER_HINT_UX_SCROLLING_COMMON:I

    const/4 v0, 0x0

    invoke-virtual {p0, p1, v0}, Lcom/mediatek/powerhalmgr/PowerHalMgr;->mtkPowerHint(II)V

    :cond_3
    :goto_0
    return-void
.end method

.method private fpsgoCtrlPagesIfNeed(Z)V
    .locals 6

    .line 587
    sget-boolean v0, Lcom/mediatek/boostfwk/utils/Config;->enableScrollFloor:Z

    if-eqz v0, :cond_0

    return-void

    .line 590
    :cond_0
    iget-object v0, p0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->mPowerHalWrap:Lcom/mediatek/powerhalwrapper/PowerHalWrapper;

    if-nez v0, :cond_1

    .line 591
    invoke-static {}, Lcom/mediatek/powerhalwrapper/PowerHalWrapper;->getInstance()Lcom/mediatek/powerhalwrapper/PowerHalWrapper;

    move-result-object v0

    iput-object v0, p0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->mPowerHalWrap:Lcom/mediatek/powerhalwrapper/PowerHalWrapper;

    .line 594
    :cond_1
    iget-object v0, p0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->mActivityInfo:Lcom/mediatek/boostfwk/info/ActivityInfo;

    const/4 v1, 0x4

    invoke-virtual {v0, v1}, Lcom/mediatek/boostfwk/info/ActivityInfo;->isPage(I)Z

    move-result v0

    const-string v1, " "

    const-string v2, "ScrollPolicy"

    const/16 v3, 0x37

    if-eqz v0, :cond_4

    .line 595
    sget-boolean v0, Lcom/mediatek/boostfwk/utils/LogUtil;->DEBUG:Z

    if-eqz v0, :cond_2

    .line 596
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, " PAGE_TYPE_WEBVIEW for renderCrGpuMain Chrome_InProcGp"

    invoke-virtual {v0, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    sget v4, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->mWebviewRenderPid:I

    invoke-virtual {v0, v4}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v2, v0}, Lcom/mediatek/boostfwk/utils/LogUtil;->traceBeginAndLog(Ljava/lang/String;Ljava/lang/String;)V

    .line 600
    :cond_2
    invoke-direct {p0}, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->getWebViewRenderPid()I

    move-result v0

    if-lez v0, :cond_3

    .line 601
    iget-object v0, p0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->mPowerHalWrap:Lcom/mediatek/powerhalwrapper/PowerHalWrapper;

    sget v4, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->mWebviewRenderPid:I

    const-string v5, "CrGpuMain"

    invoke-virtual {v0, v5, v4, v3, p1}, Lcom/mediatek/powerhalwrapper/PowerHalWrapper;->mtkSetSbePolicy(Ljava/lang/String;III)V

    .line 604
    :cond_3
    iget-object v0, p0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->mPowerHalWrap:Lcom/mediatek/powerhalwrapper/PowerHalWrapper;

    .line 605
    invoke-static {}, Landroid/os/Process;->myPid()I

    move-result v4

    const-string v5, "Chrome_InProcGp"

    .line 604
    invoke-virtual {v0, v5, v4, v3, p1}, Lcom/mediatek/powerhalwrapper/PowerHalWrapper;->mtkSetSbePolicy(Ljava/lang/String;III)V

    .line 606
    invoke-static {}, Lcom/mediatek/boostfwk/utils/LogUtil;->traceEnd()V

    .line 608
    :cond_4
    iget-object v0, p0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->mActivityInfo:Lcom/mediatek/boostfwk/info/ActivityInfo;

    const/16 v4, 0x8

    invoke-virtual {v0, v4}, Lcom/mediatek/boostfwk/info/ActivityInfo;->isPage(I)Z

    move-result v0

    if-eqz v0, :cond_7

    .line 609
    sget-boolean v0, Lcom/mediatek/boostfwk/utils/LogUtil;->DEBUG:Z

    if-eqz v0, :cond_5

    .line 610
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, " PAGE_TYPE_FLUTTER "

    invoke-virtual {v0, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 611
    invoke-static {}, Landroid/os/Process;->myPid()I

    move-result v4

    invoke-virtual {v0, v4}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    .line 610
    invoke-static {v2, v0}, Lcom/mediatek/boostfwk/utils/LogUtil;->traceBeginAndLog(Ljava/lang/String;Ljava/lang/String;)V

    :cond_5
    const/4 v0, 0x0

    .line 613
    :goto_0
    sget-object v1, Lcom/mediatek/boostfwk/utils/TasksUtil;->FLUTTER_RENDER_TASK:[Ljava/lang/String;

    array-length v2, v1

    if-ge v0, v2, :cond_6

    .line 614
    iget-object v2, p0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->mPowerHalWrap:Lcom/mediatek/powerhalwrapper/PowerHalWrapper;

    aget-object v1, v1, v0

    .line 615
    invoke-static {}, Landroid/os/Process;->myPid()I

    move-result v4

    .line 614
    invoke-virtual {v2, v1, v4, v3, p1}, Lcom/mediatek/powerhalwrapper/PowerHalWrapper;->mtkSetSbePolicy(Ljava/lang/String;III)V

    add-int/lit8 v0, v0, 0x1

    goto :goto_0

    .line 618
    :cond_6
    invoke-static {}, Lcom/mediatek/boostfwk/utils/LogUtil;->traceEnd()V

    :cond_7
    return-void
.end method

.method private getFlutterRenderTid()I
    .locals 2

    .line 776
    sget v0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->mFlutterRenderTid:I

    sget v1, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->RENDER_TID_NON_CHECK:I

    if-ne v0, v1, :cond_1

    .line 777
    iget-object p0, p0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->mActivityInfo:Lcom/mediatek/boostfwk/info/ActivityInfo;

    invoke-virtual {p0}, Lcom/mediatek/boostfwk/info/ActivityInfo;->getFlutterRenderTid()I

    move-result p0

    if-lez p0, :cond_0

    goto :goto_0

    .line 778
    :cond_0
    sget p0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->NON_RENDER_THREAD_TID:I

    :goto_0
    sput p0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->mFlutterRenderTid:I

    .line 780
    :cond_1
    sget-boolean p0, Lcom/mediatek/boostfwk/utils/LogUtil;->DEBUG:Z

    if-eqz p0, :cond_2

    .line 781
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "mFlutterRenderTid= "

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    sget v0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->mFlutterRenderTid:I

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    const-string v0, "ScrollPolicy"

    invoke-static {v0, p0}, Lcom/mediatek/boostfwk/utils/LogUtil;->mLogd(Ljava/lang/String;Ljava/lang/String;)V

    .line 783
    :cond_2
    sget p0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->mFlutterRenderTid:I

    return p0
.end method

.method public static getInstance()Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;
    .locals 2

    .line 175
    sget-object v0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->sInstance:Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;

    if-nez v0, :cond_1

    .line 176
    sget-object v0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->lock:Ljava/lang/Object;

    monitor-enter v0

    .line 177
    :try_start_0
    sget-object v1, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->sInstance:Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;

    if-nez v1, :cond_0

    .line 178
    new-instance v1, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;

    invoke-direct {v1}, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;-><init>()V

    sput-object v1, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->sInstance:Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;

    .line 180
    :cond_0
    monitor-exit v0

    goto :goto_0

    :catchall_0
    move-exception v1

    monitor-exit v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    throw v1

    .line 182
    :cond_1
    :goto_0
    sget-object v0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->sInstance:Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;

    return-object v0
.end method

.method private getRenderThreadTid()I
    .locals 2

    .line 758
    sget v0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->mRenderThreadTid:I

    sget v1, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->RENDER_TID_NON_CHECK:I

    if-ne v0, v1, :cond_0

    .line 759
    iget-object p0, p0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->mActivityInfo:Lcom/mediatek/boostfwk/info/ActivityInfo;

    invoke-virtual {p0}, Lcom/mediatek/boostfwk/info/ActivityInfo;->getRenderThreadTid()I

    move-result p0

    sput p0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->mRenderThreadTid:I

    .line 761
    :cond_0
    sget p0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->mRenderThreadTid:I

    return p0
.end method

.method private getWebViewRenderPid()I
    .locals 2

    .line 765
    sget v0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->mWebviewRenderPid:I

    sget v1, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->RENDER_TID_NON_CHECK:I

    if-ne v0, v1, :cond_1

    .line 766
    iget-object p0, p0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->mActivityInfo:Lcom/mediatek/boostfwk/info/ActivityInfo;

    invoke-virtual {p0}, Lcom/mediatek/boostfwk/info/ActivityInfo;->getWebViewRenderPid()I

    move-result p0

    if-lez p0, :cond_0

    goto :goto_0

    .line 767
    :cond_0
    sget p0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->NON_RENDER_THREAD_TID:I

    :goto_0
    sput p0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->mWebviewRenderPid:I

    .line 769
    :cond_1
    sget-boolean p0, Lcom/mediatek/boostfwk/utils/LogUtil;->DEBUG:Z

    if-eqz p0, :cond_2

    .line 770
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "getWebViewRenderTid webviewPid= "

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    sget v0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->mWebviewRenderPid:I

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    const-string v0, "ScrollPolicy"

    invoke-static {v0, p0}, Lcom/mediatek/boostfwk/utils/LogUtil;->traceAndMLogd(Ljava/lang/String;Ljava/lang/String;)V

    .line 772
    :cond_2
    sget p0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->mWebviewRenderPid:I

    return p0
.end method

.method private initThread()V
    .locals 2

    .line 192
    iget-object v0, p0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->mWorkerThread:Landroid/os/HandlerThread;

    const-string v1, "ScrollPolicy"

    if-eqz v0, :cond_0

    invoke-virtual {v0}, Landroid/os/HandlerThread;->isAlive()Z

    move-result v0

    if-eqz v0, :cond_0

    iget-object v0, p0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->mWorkerHandler:Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy$WorkerHandler;

    if-eqz v0, :cond_0

    .line 194
    invoke-static {}, Lcom/mediatek/boostfwk/utils/Config;->isBoostFwkLogEnable()Z

    move-result p0

    if-eqz p0, :cond_2

    const-string p0, "re-init"

    .line 195
    invoke-static {v1, p0}, Lcom/mediatek/boostfwk/utils/LogUtil;->mLogi(Ljava/lang/String;Ljava/lang/String;)V

    goto :goto_0

    .line 198
    :cond_0
    new-instance v0, Landroid/os/HandlerThread;

    invoke-direct {v0, v1}, Landroid/os/HandlerThread;-><init>(Ljava/lang/String;)V

    iput-object v0, p0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->mWorkerThread:Landroid/os/HandlerThread;

    .line 199
    invoke-virtual {v0}, Landroid/os/HandlerThread;->start()V

    .line 200
    iget-object v0, p0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->mWorkerThread:Landroid/os/HandlerThread;

    invoke-virtual {v0}, Landroid/os/HandlerThread;->getLooper()Landroid/os/Looper;

    move-result-object v0

    if-nez v0, :cond_1

    const-string p0, "Thread looper is null"

    .line 202
    invoke-static {v1, p0}, Lcom/mediatek/boostfwk/utils/LogUtil;->mLogd(Ljava/lang/String;Ljava/lang/String;)V

    goto :goto_0

    .line 204
    :cond_1
    new-instance v1, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy$WorkerHandler;

    invoke-direct {v1, p0, v0}, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy$WorkerHandler;-><init>(Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;Landroid/os/Looper;)V

    iput-object v1, p0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->mWorkerHandler:Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy$WorkerHandler;

    :cond_2
    :goto_0
    return-void
.end method

.method private mtkScrollingFlingPolicy(Z)V
    .locals 5

    .line 425
    sget-object v0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->mPowerHalService:Lcom/mediatek/powerhalmgr/PowerHalMgr;

    const-string v1, "ScrollPolicy"

    if-nez v0, :cond_0

    const-string p0, "mPowerHalService is null"

    .line 426
    invoke-static {v1, p0}, Lcom/mediatek/boostfwk/utils/LogUtil;->mLogw(Ljava/lang/String;Ljava/lang/String;)V

    return-void

    .line 429
    :cond_0
    sget-boolean v0, Lcom/mediatek/boostfwk/utils/LogUtil;->DEBUG:Z

    if-eqz v0, :cond_2

    .line 430
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "mtkScrollingFlingPolicy "

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    if-eqz p1, :cond_1

    const-string/jumbo v2, "start"

    goto :goto_0

    :cond_1
    const-string/jumbo v2, "stop"

    :goto_0
    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v1, v0}, Lcom/mediatek/boostfwk/utils/LogUtil;->traceBeginAndLog(Ljava/lang/String;Ljava/lang/String;)V

    :cond_2
    const/4 v0, 0x0

    const/16 v1, 0xa

    const/4 v2, 0x0

    const/4 v3, 0x1

    if-eqz p1, :cond_4

    .line 433
    sget p1, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->mFlingPolicyExeCount:I

    if-nez p1, :cond_6

    sget-boolean p1, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->useFPSGo:Z

    if-nez p1, :cond_6

    .line 434
    iput-boolean v2, p0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->mIsRealAOSPPage:Z

    .line 435
    iget p1, p0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->scrollingFingStep:I

    const/4 v2, 0x3

    if-ne p1, v2, :cond_3

    .line 436
    invoke-static {}, Lcom/mediatek/boostfwk/utils/Config;->getHorizontalScrollDuration()I

    move-result p1

    goto :goto_1

    :cond_3
    invoke-static {}, Lcom/mediatek/boostfwk/utils/Config;->getVerticalScrollDuration()I

    move-result p1

    .line 437
    :goto_1
    sget v2, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->MTKPOWER_HINT_UX_SCROLLING:I

    invoke-direct {p0, v2, p1}, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->powerHintUxScrollPolicy(II)V

    .line 438
    iget v2, p0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->scrollingFingStep:I

    invoke-direct {p0, v3, v2}, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->enableFPSGo(ZI)V

    .line 439
    sget v2, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->mFlingPolicyExeCount:I

    add-int/2addr v2, v3

    sput v2, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->mFlingPolicyExeCount:I

    .line 440
    iget-object v2, p0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->mWorkerHandler:Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy$WorkerHandler;

    invoke-virtual {v2, v1, v0}, Landroid/os/Handler;->removeMessages(ILjava/lang/Object;)V

    .line 441
    iget-object p0, p0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->mWorkerHandler:Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy$WorkerHandler;

    .line 442
    invoke-virtual {p0, v1, v0}, Landroid/os/Handler;->obtainMessage(ILjava/lang/Object;)Landroid/os/Message;

    move-result-object v0

    int-to-long v1, p1

    sget-wide v3, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->mCheckFPSTime:J

    sub-long/2addr v1, v3

    .line 441
    invoke-virtual {p0, v0, v1, v2}, Landroid/os/Handler;->sendMessageDelayed(Landroid/os/Message;J)Z

    goto :goto_2

    .line 447
    :cond_4
    sput v2, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->mFlingPolicyExeCount:I

    .line 448
    iget-object p1, p0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->mWorkerHandler:Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy$WorkerHandler;

    invoke-virtual {p1, v1, v0}, Landroid/os/Handler;->removeMessages(ILjava/lang/Object;)V

    .line 449
    sget p1, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->MTKPOWER_HINT_UX_SCROLLING:I

    invoke-direct {p0, p1, v2}, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->powerHintUxScrollPolicy(II)V

    .line 450
    sget-boolean p1, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->useFPSGo:Z

    if-eqz p1, :cond_5

    .line 451
    iget p1, p0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->scrollingFingStep:I

    invoke-direct {p0, v3, p1}, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->enableFPSGo(ZI)V

    goto :goto_2

    .line 453
    :cond_5
    iget p1, p0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->scrollingFingStep:I

    invoke-direct {p0, p1, v3}, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->delayControlFpsgo(IZ)V

    .line 456
    :cond_6
    :goto_2
    invoke-static {}, Lcom/mediatek/boostfwk/utils/LogUtil;->traceEnd()V

    return-void
.end method

.method private mtkScrollingPolicy(Z)V
    .locals 5

    .line 370
    sget-object v0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->mPowerHalService:Lcom/mediatek/powerhalmgr/PowerHalMgr;

    const-string v1, "ScrollPolicy"

    if-nez v0, :cond_0

    const-string p0, "mPowerHalService is null"

    .line 371
    invoke-static {v1, p0}, Lcom/mediatek/boostfwk/utils/LogUtil;->mLogw(Ljava/lang/String;Ljava/lang/String;)V

    return-void

    .line 374
    :cond_0
    sget-boolean v0, Lcom/mediatek/boostfwk/utils/LogUtil;->DEBUG:Z

    if-eqz v0, :cond_2

    .line 375
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "mtkScrollingPolicy "

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    if-eqz p1, :cond_1

    const-string/jumbo v2, "start"

    goto :goto_0

    :cond_1
    const-string/jumbo v2, "stop"

    :goto_0
    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v1, v0}, Lcom/mediatek/boostfwk/utils/LogUtil;->traceBeginAndLog(Ljava/lang/String;Ljava/lang/String;)V

    :cond_2
    const/4 v0, 0x7

    const/4 v1, 0x0

    const/4 v2, 0x1

    const/4 v3, 0x0

    if-eqz p1, :cond_6

    .line 378
    sget p1, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->mPolicyExeCount:I

    if-nez p1, :cond_7

    .line 380
    iget-object p1, p0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->mActivityInfo:Lcom/mediatek/boostfwk/info/ActivityInfo;

    const/16 v4, 0x20

    invoke-virtual {p1, v4}, Lcom/mediatek/boostfwk/info/ActivityInfo;->isPage(I)Z

    move-result p1

    if-eqz p1, :cond_3

    .line 381
    sget p1, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->mPolicyExeCount:I

    add-int/2addr p1, v2

    sput p1, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->mPolicyExeCount:I

    const-string p1, "PAGE_TYPE_SPECIAL_DESIGN_WEB_ON_60"

    .line 382
    invoke-static {v3, p1}, Lcom/mediatek/boostfwk/info/ScrollState;->setScrolling(ZLjava/lang/String;)V

    .line 383
    invoke-direct {p0}, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->disableTouchBoost()V

    .line 384
    invoke-static {}, Lcom/mediatek/boostfwk/utils/LogUtil;->traceEnd()V

    return-void

    .line 389
    :cond_3
    sget p1, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->mFlingPolicyExeCount:I

    if-eqz p1, :cond_4

    .line 390
    iget-object p1, p0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->mWorkerHandler:Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy$WorkerHandler;

    const/16 v4, 0xa

    invoke-virtual {p1, v4, v1}, Landroid/os/Handler;->removeMessages(ILjava/lang/Object;)V

    .line 392
    sget p1, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->MTKPOWER_HINT_UX_SCROLLING:I

    invoke-direct {p0, p1, v3}, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->powerHintUxScrollPolicy(II)V

    .line 393
    sput v3, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->mFlingPolicyExeCount:I

    .line 395
    :cond_4
    iget-object p1, p0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->mActivityInfo:Lcom/mediatek/boostfwk/info/ActivityInfo;

    invoke-virtual {p1}, Lcom/mediatek/boostfwk/info/ActivityInfo;->isSpecialPageDesign()Z

    move-result p1

    if-eqz p1, :cond_5

    .line 396
    sget p1, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->MTKPOWER_HINT_UX_MOVE_SCROLLING:I

    .line 397
    invoke-static {}, Lcom/mediatek/boostfwk/utils/Config;->getVerticalScrollDuration()I

    move-result v4

    .line 396
    invoke-direct {p0, p1, v4}, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->powerHintUxScrollPolicy(II)V

    .line 399
    :cond_5
    invoke-direct {p0, v2, v3}, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->enableFPSGo(ZI)V

    .line 400
    sget p1, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->mPolicyExeCount:I

    add-int/2addr p1, v2

    sput p1, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->mPolicyExeCount:I

    .line 401
    invoke-direct {p0}, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->disableTouchBoost()V

    .line 402
    iget-object p0, p0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->mWorkerHandler:Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy$WorkerHandler;

    .line 403
    invoke-virtual {p0, v0, v1}, Landroid/os/Handler;->obtainMessage(ILjava/lang/Object;)Landroid/os/Message;

    move-result-object p1

    .line 405
    invoke-static {}, Lcom/mediatek/boostfwk/utils/Config;->getVerticalScrollDuration()I

    move-result v0

    int-to-long v0, v0

    sget-wide v2, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->mCheckFPSTime:J

    sub-long/2addr v0, v2

    .line 402
    invoke-virtual {p0, p1, v0, v1}, Landroid/os/Handler;->sendMessageDelayed(Landroid/os/Message;J)Z

    goto :goto_1

    .line 408
    :cond_6
    sput v3, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->mPolicyExeCount:I

    .line 409
    iget-object p1, p0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->mWorkerHandler:Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy$WorkerHandler;

    invoke-virtual {p1, v0, v1}, Landroid/os/Handler;->removeMessages(ILjava/lang/Object;)V

    .line 410
    sget p1, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->MTKPOWER_HINT_UX_MOVE_SCROLLING:I

    invoke-direct {p0, p1, v3}, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->powerHintUxScrollPolicy(II)V

    .line 411
    sget-boolean p1, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->useFPSGo:Z

    if-nez p1, :cond_7

    .line 413
    invoke-direct {p0, v3, v2}, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->delayControlFpsgo(IZ)V

    .line 416
    :cond_7
    :goto_1
    invoke-static {}, Lcom/mediatek/boostfwk/utils/LogUtil;->traceEnd()V

    return-void
.end method

.method private perfLockAcquire([I)V
    .locals 2

    .line 787
    sget-object p0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->mPowerHalService:Lcom/mediatek/powerhalmgr/PowerHalMgr;

    if-eqz p0, :cond_0

    .line 788
    sget v0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->mPowerHandle:I

    .line 789
    invoke-static {}, Lcom/mediatek/boostfwk/utils/Config;->getVerticalScrollDuration()I

    move-result v1

    .line 788
    invoke-virtual {p0, v0, v1, p1}, Lcom/mediatek/powerhalmgr/PowerHalMgr;->perfLockAcquire(II[I)I

    move-result p0

    sput p0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->mPowerHandle:I

    .line 790
    sget-object p1, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->mPowerHalService:Lcom/mediatek/powerhalmgr/PowerHalMgr;

    invoke-virtual {p1, p0}, Lcom/mediatek/powerhalmgr/PowerHalMgr;->perfLockRelease(I)V

    :cond_0
    return-void
.end method

.method private powerHintUxScrollPolicy(II)V
    .locals 0

    .line 795
    sget-boolean p0, Lcom/mediatek/boostfwk/utils/Config;->enableScrollFloor:Z

    if-eqz p0, :cond_0

    .line 796
    sget-object p0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->mPowerHalService:Lcom/mediatek/powerhalmgr/PowerHalMgr;

    invoke-virtual {p0, p1, p2}, Lcom/mediatek/powerhalmgr/PowerHalMgr;->mtkPowerHint(II)V

    :cond_0
    return-void
.end method

.method private releaseFPSGOControl(ZI)V
    .locals 1

    const/4 v0, 0x0

    .line 497
    invoke-direct {p0, p1, p2, v0}, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->releaseFPSGOControl(ZI[I)V

    return-void
.end method

.method private releaseFPSGOControl(ZI[I)V
    .locals 10

    .line 508
    invoke-direct {p0}, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->getRenderThreadTid()I

    move-result v0

    .line 510
    invoke-static {}, Lcom/mediatek/boostfwk/utils/Config;->isDisableFrameDecision()Z

    move-result v1

    const v2, 0x2000400

    .line 549
    invoke-static {v2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v2

    const/4 v3, 0x3

    const v4, 0x2000300

    .line 543
    invoke-static {v4}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v4

    const/4 v5, 0x1

    const/4 v6, 0x2

    const/4 v7, 0x0

    .line 528
    invoke-static {v7}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v8

    if-eqz p1, :cond_6

    .line 512
    invoke-direct {p0, v6, v7}, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->delayControlFpsgo(IZ)V

    if-eqz v1, :cond_0

    .line 514
    iget-object v9, p0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->mPerfLockRscList:Ljava/util/ArrayList;

    invoke-virtual {v9, v4}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    .line 515
    iget-object v4, p0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->mPerfLockRscList:Ljava/util/ArrayList;

    invoke-static {v0}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v9

    invoke-virtual {v4, v9}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    :cond_0
    if-eq p2, v6, :cond_1

    if-ne p2, v3, :cond_4

    .line 520
    :cond_1
    iget-boolean v3, p0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->fpsgoUnderCtrlWhenFling:Z

    if-nez v3, :cond_2

    .line 521
    invoke-static {}, Lcom/mediatek/boostfwk/utils/Config;->getBoostFwkVersion()I

    move-result v3

    if-gt v3, v6, :cond_2

    .line 523
    iget-object v1, p0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->mPerfLockRscList:Ljava/util/ArrayList;

    invoke-virtual {v1, v2}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    .line 524
    iget-object v1, p0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->mPerfLockRscList:Ljava/util/ArrayList;

    neg-int v0, v0

    invoke-static {v0}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v0

    invoke-virtual {v1, v0}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    goto :goto_0

    :cond_2
    if-eqz v1, :cond_3

    .line 528
    iget-object v0, p0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->mPerfLockRscList:Ljava/util/ArrayList;

    invoke-virtual {v0, v7, v8}, Ljava/util/ArrayList;->set(ILjava/lang/Object;)Ljava/lang/Object;

    .line 529
    iget-object v0, p0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->mPerfLockRscList:Ljava/util/ArrayList;

    invoke-virtual {v0, v5, v8}, Ljava/util/ArrayList;->set(ILjava/lang/Object;)Ljava/lang/Object;

    .line 532
    :cond_3
    :goto_0
    iput-boolean v5, p0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->fpsgoUnderCtrlWhenFling:Z

    .line 533
    invoke-direct {p0}, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->uBoostAcquire()V

    .line 535
    :cond_4
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v0

    iput-wide v0, p0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->mLastScrollTimeMS:J

    .line 537
    iget-boolean v0, p0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->mCommonPolicyEnabled:Z

    if-nez v0, :cond_5

    .line 538
    invoke-direct {p0, v5}, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->enableScrollingCommonCMD(Z)V

    .line 540
    :cond_5
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string/jumbo v1, "start "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    goto :goto_1

    :cond_6
    if-eqz v1, :cond_7

    .line 543
    iget-object v1, p0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->mPerfLockRscList:Ljava/util/ArrayList;

    invoke-virtual {v1, v4}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    .line 544
    iget-object v1, p0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->mPerfLockRscList:Ljava/util/ArrayList;

    neg-int v4, v0

    invoke-static {v4}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v4

    invoke-virtual {v1, v4}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    :cond_7
    if-eq p2, v6, :cond_8

    if-ne p2, v3, :cond_a

    .line 548
    :cond_8
    invoke-static {}, Lcom/mediatek/boostfwk/utils/Config;->getBoostFwkVersion()I

    move-result v1

    if-gt v1, v6, :cond_9

    .line 549
    iget-object v1, p0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->mPerfLockRscList:Ljava/util/ArrayList;

    invoke-virtual {v1, v2}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    .line 550
    iget-object v1, p0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->mPerfLockRscList:Ljava/util/ArrayList;

    invoke-static {v0}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v0

    invoke-virtual {v1, v0}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    .line 552
    :cond_9
    iput-boolean v7, p0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->fpsgoUnderCtrlWhenFling:Z

    .line 553
    invoke-direct {p0}, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->uBoostRelease()V

    .line 555
    :cond_a
    invoke-direct {p0, v7}, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->enableScrollingCommonCMD(Z)V

    const/4 v0, -0x1

    .line 556
    sput v0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->mSpecialAppDesign:I

    .line 557
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "end "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    .line 559
    :goto_1
    invoke-direct {p0, p1}, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->fpsgoCtrlPagesIfNeed(Z)V

    if-eqz p3, :cond_b

    move v0, v7

    .line 561
    :goto_2
    array-length v1, p3

    if-ge v0, v1, :cond_b

    .line 562
    iget-object v1, p0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->mPerfLockRscList:Ljava/util/ArrayList;

    aget v2, p3, v0

    invoke-static {v2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v2

    invoke-virtual {v1, v2}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    add-int/lit8 v0, v0, 0x1

    goto :goto_2

    .line 565
    :cond_b
    iget-object p3, p0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->mPerfLockRscList:Ljava/util/ArrayList;

    invoke-virtual {p3}, Ljava/util/ArrayList;->size()I

    move-result p3

    .line 566
    new-array v0, p3, [I

    move v1, v7

    :goto_3
    if-ge v7, p3, :cond_d

    .line 569
    iget-object v2, p0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->mPerfLockRscList:Ljava/util/ArrayList;

    invoke-virtual {v2, v7}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Ljava/lang/Integer;

    invoke-virtual {v2}, Ljava/lang/Integer;->intValue()I

    move-result v2

    aput v2, v0, v7

    if-eqz v2, :cond_c

    move v1, v5

    :cond_c
    add-int/lit8 v7, v7, 0x1

    goto :goto_3

    .line 574
    :cond_d
    invoke-static {}, Lcom/mediatek/boostfwk/utils/Config;->getBoostFwkVersion()I

    move-result p3

    if-le p3, v6, :cond_e

    if-eqz v1, :cond_f

    .line 577
    invoke-direct {p0, v0, p2}, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->controlFpsgoInternal([ILjava/lang/String;)V

    goto :goto_4

    .line 580
    :cond_e
    invoke-direct {p0, v0, p2}, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->controlFpsgoInternal([ILjava/lang/String;)V

    .line 582
    :cond_f
    :goto_4
    invoke-static {p1, p2}, Lcom/mediatek/boostfwk/info/ScrollState;->setScrolling(ZLjava/lang/String;)V

    .line 583
    iget-object p0, p0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->mPerfLockRscList:Ljava/util/ArrayList;

    invoke-virtual {p0}, Ljava/util/ArrayList;->clear()V

    return-void
.end method

.method private releaseTargetFPSInternel(Z)V
    .locals 6

    .line 721
    invoke-direct {p0}, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->getRenderThreadTid()I

    move-result v0

    const/4 v1, 0x2

    new-array v2, v1, [I

    .line 724
    invoke-static {}, Lcom/mediatek/boostfwk/utils/Config;->isDisableFrameDecision()Z

    move-result v3

    const/4 v4, 0x1

    const/4 v5, 0x0

    if-eqz v3, :cond_1

    const v3, 0x2000200

    aput v3, v2, v5

    if-eqz p1, :cond_0

    goto :goto_0

    :cond_0
    neg-int v0, v0

    :goto_0
    aput v0, v2, v4

    goto :goto_1

    :cond_1
    aput v5, v2, v4

    aput v5, v2, v5

    .line 730
    :goto_1
    sget-boolean v0, Lcom/mediatek/boostfwk/utils/LogUtil;->DEBUG:Z

    if-eqz v0, :cond_3

    .line 731
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "release Target FPS"

    invoke-virtual {v0, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    if-eqz p1, :cond_2

    const-string/jumbo v3, "start"

    goto :goto_2

    :cond_2
    const-string/jumbo v3, "stop"

    :goto_2
    invoke-virtual {v0, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    const-string v3, "ScrollPolicy"

    invoke-static {v3, v0}, Lcom/mediatek/boostfwk/utils/LogUtil;->traceBeginAndLog(Ljava/lang/String;Ljava/lang/String;)V

    .line 733
    :cond_3
    iget-object v0, p0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->mWorkerHandler:Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy$WorkerHandler;

    const/16 v3, 0xe

    invoke-virtual {v0, v3}, Landroid/os/Handler;->removeMessages(I)V

    .line 734
    sget-boolean v0, Lcom/mediatek/boostfwk/utils/Config;->dealyReleaseFPSGO:Z

    if-eqz v0, :cond_4

    if-nez p1, :cond_4

    iget v0, p0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->mCurrentScrollStep:I

    if-nez v0, :cond_4

    .line 737
    iget-object p1, p0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->mWorkerHandler:Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy$WorkerHandler;

    sget-wide v0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->mDelayReleaseFpsTime:J

    invoke-virtual {p1, v3, v0, v1}, Landroid/os/Handler;->sendEmptyMessageDelayed(IJ)Z

    .line 740
    invoke-direct {p0, v5}, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->enableScrollingCommonCMD(Z)V

    goto :goto_3

    .line 742
    :cond_4
    invoke-direct {p0, p1, v1, v2}, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->releaseFPSGOControl(ZI[I)V

    .line 744
    :goto_3
    invoke-static {}, Lcom/mediatek/boostfwk/utils/LogUtil;->traceEnd()V

    return-void
.end method

.method private scrollCommonPolicyCheck()V
    .locals 6

    .line 749
    iget-wide v0, p0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->mLastScrollTimeMS:J

    const-wide/16 v2, 0x0

    cmp-long v0, v0, v2

    if-lez v0, :cond_0

    .line 750
    invoke-static {}, Lcom/mediatek/boostfwk/utils/Config;->getVerticalScrollDuration()I

    move-result v0

    int-to-long v0, v0

    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v2

    iget-wide v4, p0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->mLastScrollTimeMS:J

    sub-long/2addr v2, v4

    cmp-long v0, v0, v2

    if-lez v0, :cond_0

    const/4 v0, 0x1

    .line 751
    invoke-direct {p0, v0}, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->enableScrollingCommonCMD(Z)V

    goto :goto_0

    .line 752
    :cond_0
    iget-boolean v0, p0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->mCommonPolicyEnabled:Z

    if-eqz v0, :cond_1

    const/4 v0, 0x0

    .line 753
    invoke-direct {p0, v0}, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->enableScrollingCommonCMD(Z)V

    :cond_1
    :goto_0
    return-void
.end method

.method private uBoostAcquire()V
    .locals 3

    .line 807
    invoke-static {}, Lcom/mediatek/boostfwk/utils/Config;->getBoostFwkVersion()I

    move-result v0

    const/4 v1, 0x1

    if-eq v0, v1, :cond_0

    return-void

    .line 810
    :cond_0
    sget-object v0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->mPowerHalService:Lcom/mediatek/powerhalmgr/PowerHalMgr;

    if-eqz v0, :cond_1

    iget-boolean v2, p0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->uboostEnable:Z

    if-nez v2, :cond_1

    .line 811
    iput-boolean v1, p0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->uboostEnable:Z

    const/4 p0, 0x2

    new-array p0, p0, [I

    .line 812
    fill-array-data p0, :array_0

    .line 813
    sget v1, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->mBoostHandle:I

    .line 814
    invoke-static {}, Lcom/mediatek/boostfwk/utils/Config;->getVerticalScrollDuration()I

    move-result v2

    .line 813
    invoke-virtual {v0, v1, v2, p0}, Lcom/mediatek/powerhalmgr/PowerHalMgr;->perfLockAcquire(II[I)I

    move-result p0

    sput p0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->mBoostHandle:I

    :cond_1
    return-void

    nop

    :array_0
    .array-data 4
        0x2048700
        0x1
    .end array-data
.end method

.method private uBoostRelease()V
    .locals 2

    .line 820
    invoke-static {}, Lcom/mediatek/boostfwk/utils/Config;->getBoostFwkVersion()I

    move-result v0

    const/4 v1, 0x1

    if-eq v0, v1, :cond_0

    return-void

    .line 823
    :cond_0
    sget-object v0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->mPowerHalService:Lcom/mediatek/powerhalmgr/PowerHalMgr;

    if-eqz v0, :cond_1

    iget-boolean v1, p0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->uboostEnable:Z

    if-eqz v1, :cond_1

    const/4 v1, 0x0

    .line 824
    iput-boolean v1, p0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->uboostEnable:Z

    .line 825
    sget p0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->mBoostHandle:I

    invoke-virtual {v0, p0}, Lcom/mediatek/powerhalmgr/PowerHalMgr;->perfLockRelease(I)V

    :cond_1
    return-void
.end method


# virtual methods
.method public disableMTKScrollingPolicy(Z)V
    .locals 1

    if-eqz p1, :cond_0

    .line 356
    sget p1, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->mPolicyExeCount:I

    if-nez p1, :cond_0

    return-void

    .line 359
    :cond_0
    iget-object p0, p0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->mWorkerHandler:Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy$WorkerHandler;

    const/16 p1, 0x9

    const/4 v0, 0x0

    .line 360
    invoke-virtual {p0, p1, v0}, Landroid/os/Handler;->obtainMessage(ILjava/lang/Object;)Landroid/os/Message;

    move-result-object p1

    .line 359
    invoke-virtual {p0, p1}, Landroid/os/Handler;->sendMessage(Landroid/os/Message;)Z

    return-void
.end method

.method public releaseTargetFPS(Z)V
    .locals 3

    .line 667
    iget-boolean v0, p0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->mDisableScrollPolicy:Z

    const-string v1, "ScrollPolicy"

    if-eqz v0, :cond_0

    const-string p0, "releaseTargetFPS scroll policy has been disable"

    .line 668
    invoke-static {v1, p0}, Lcom/mediatek/boostfwk/utils/LogUtil;->traceAndLog(Ljava/lang/String;Ljava/lang/String;)V

    return-void

    .line 671
    :cond_0
    invoke-direct {p0}, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->getRenderThreadTid()I

    move-result v0

    .line 672
    sget v2, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->NON_RENDER_THREAD_TID:I

    if-ne v0, v2, :cond_1

    const-string p0, "cannot found render thread"

    .line 673
    invoke-static {v1, p0}, Lcom/mediatek/boostfwk/utils/LogUtil;->mLogw(Ljava/lang/String;Ljava/lang/String;)V

    return-void

    :cond_1
    const/4 v0, 0x4

    const/4 v1, 0x0

    if-eqz p1, :cond_2

    const/4 p1, 0x0

    .line 680
    sput-boolean p1, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->isCorrectFPS:Z

    .line 681
    iget-object p1, p0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->mWorkerHandler:Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy$WorkerHandler;

    const/4 v2, 0x1

    .line 682
    invoke-virtual {p1, v2, v1}, Landroid/os/Handler;->obtainMessage(ILjava/lang/Object;)Landroid/os/Message;

    move-result-object v2

    .line 681
    invoke-virtual {p1, v2}, Landroid/os/Handler;->sendMessage(Landroid/os/Message;)Z

    .line 684
    iget-object p1, p0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->mWorkerHandler:Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy$WorkerHandler;

    invoke-virtual {p1, v0, v1}, Landroid/os/Handler;->removeMessages(ILjava/lang/Object;)V

    .line 685
    iget-object p0, p0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->mWorkerHandler:Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy$WorkerHandler;

    const/4 p1, 0x3

    .line 686
    invoke-virtual {p0, p1, v1}, Landroid/os/Handler;->obtainMessage(ILjava/lang/Object;)Landroid/os/Message;

    move-result-object p1

    sget-wide v0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->mCheckFPSTime:J

    .line 685
    invoke-virtual {p0, p1, v0, v1}, Landroid/os/Handler;->sendMessageDelayed(Landroid/os/Message;J)Z

    goto :goto_0

    .line 690
    :cond_2
    sget-boolean p1, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->isCorrectFPS:Z

    if-eqz p1, :cond_3

    .line 691
    iget-object p0, p0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->mWorkerHandler:Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy$WorkerHandler;

    const/4 p1, 0x2

    .line 692
    invoke-virtual {p0, p1, v1}, Landroid/os/Handler;->obtainMessage(ILjava/lang/Object;)Landroid/os/Message;

    move-result-object p1

    .line 691
    invoke-virtual {p0, p1}, Landroid/os/Handler;->sendMessage(Landroid/os/Message;)Z

    goto :goto_0

    .line 695
    :cond_3
    iget-object p0, p0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->mWorkerHandler:Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy$WorkerHandler;

    .line 696
    invoke-virtual {p0, v0, v1}, Landroid/os/Handler;->obtainMessage(ILjava/lang/Object;)Landroid/os/Message;

    move-result-object p1

    .line 698
    invoke-static {}, Lcom/mediatek/boostfwk/utils/Config;->getVerticalScrollDuration()I

    move-result v0

    int-to-long v0, v0

    .line 695
    invoke-virtual {p0, p1, v0, v1}, Landroid/os/Handler;->sendMessageDelayed(Landroid/os/Message;J)Z

    :goto_0
    return-void
.end method

.method public scrollHint(II)V
    .locals 3

    .line 290
    iget-boolean v0, p0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->mDisableScrollPolicy:Z

    const-string v1, "ScrollPolicy"

    if-eqz v0, :cond_0

    const-string p0, "scroll policy has been disable"

    .line 291
    invoke-static {v1, p0}, Lcom/mediatek/boostfwk/utils/LogUtil;->traceAndLog(Ljava/lang/String;Ljava/lang/String;)V

    return-void

    .line 294
    :cond_0
    sget-boolean v0, Lcom/mediatek/boostfwk/utils/LogUtil;->DEBUG:Z

    if-eqz v0, :cond_1

    .line 295
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "scrollHint step="

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v2, " pageType"

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v2, " mCurrentScrollStep"

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v2, p0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->mCurrentScrollStep:I

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v1, v0}, Lcom/mediatek/boostfwk/utils/LogUtil;->traceBeginAndLog(Ljava/lang/String;Ljava/lang/String;)V

    .line 298
    :cond_1
    iput p1, p0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->mCurrentScrollStep:I

    const/4 v0, 0x5

    const/4 v1, 0x0

    if-eqz p1, :cond_4

    const/4 p2, 0x1

    if-eq p1, p2, :cond_3

    const/4 p2, 0x2

    if-eq p1, p2, :cond_2

    const/4 p2, 0x3

    if-eq p1, p2, :cond_2

    goto :goto_0

    .line 322
    :cond_2
    iput p1, p0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->scrollingFingStep:I

    .line 323
    sget p1, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->mFlingPolicyExeCount:I

    if-nez p1, :cond_7

    .line 324
    iget-object p0, p0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->mWorkerHandler:Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy$WorkerHandler;

    const/16 p1, 0x8

    .line 325
    invoke-virtual {p0, p1, v1}, Landroid/os/Handler;->obtainMessage(ILjava/lang/Object;)Landroid/os/Message;

    move-result-object p1

    .line 324
    invoke-virtual {p0, p1}, Landroid/os/Handler;->sendMessage(Landroid/os/Message;)Z

    goto :goto_0

    .line 315
    :cond_3
    iget-object p1, p0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->mWorkerHandler:Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy$WorkerHandler;

    invoke-virtual {p1, v0, v1}, Landroid/os/Handler;->removeMessages(ILjava/lang/Object;)V

    .line 316
    iget-object p0, p0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->mWorkerHandler:Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy$WorkerHandler;

    const/4 p1, 0x6

    .line 317
    invoke-virtual {p0, p1, v1}, Landroid/os/Handler;->obtainMessage(ILjava/lang/Object;)Landroid/os/Message;

    move-result-object p1

    .line 316
    invoke-virtual {p0, p1}, Landroid/os/Handler;->sendMessage(Landroid/os/Message;)Z

    goto :goto_0

    .line 301
    :cond_4
    sget-boolean p1, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->useFPSGo:Z

    if-eqz p1, :cond_5

    const/4 p1, 0x0

    .line 303
    sput-boolean p1, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->useFPSGo:Z

    .line 305
    :cond_5
    sget p1, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->mSpecialAppDesign:I

    const/4 v2, -0x1

    if-ne p1, v2, :cond_6

    .line 306
    sput p2, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->mSpecialAppDesign:I

    .line 308
    :cond_6
    sget p1, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->mPolicyExeCount:I

    if-nez p1, :cond_7

    .line 309
    iget-object p0, p0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->mWorkerHandler:Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy$WorkerHandler;

    .line 310
    invoke-virtual {p0, v0, v1}, Landroid/os/Handler;->obtainMessage(ILjava/lang/Object;)Landroid/os/Message;

    move-result-object p1

    .line 309
    invoke-virtual {p0, p1}, Landroid/os/Handler;->sendMessage(Landroid/os/Message;)Z

    .line 332
    :cond_7
    :goto_0
    invoke-static {}, Lcom/mediatek/boostfwk/utils/LogUtil;->traceEnd()V

    return-void
.end method

.method public switchToFPSGo(Z)V
    .locals 3

    .line 336
    iget-boolean v0, p0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->mDisableScrollPolicy:Z

    const-string v1, "ScrollPolicy"

    if-eqz v0, :cond_0

    const-string/jumbo p0, "switchToFPSGo scroll policy has been disable"

    .line 337
    invoke-static {v1, p0}, Lcom/mediatek/boostfwk/utils/LogUtil;->traceAndLog(Ljava/lang/String;Ljava/lang/String;)V

    return-void

    .line 340
    :cond_0
    sput-boolean p1, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->useFPSGo:Z

    .line 343
    sget-boolean v0, Lcom/mediatek/boostfwk/utils/LogUtil;->DEBUG:Z

    if-eqz v0, :cond_2

    .line 344
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string/jumbo v2, "switchToFPSGo "

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    if-eqz p1, :cond_1

    const-string/jumbo v2, "start"

    goto :goto_0

    :cond_1
    const-string/jumbo v2, "stop"

    :goto_0
    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v1, v0}, Lcom/mediatek/boostfwk/utils/LogUtil;->traceBeginAndLog(Ljava/lang/String;Ljava/lang/String;)V

    .line 346
    :cond_2
    iget-boolean v0, p0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->mIsRealAOSPPage:Z

    if-nez v0, :cond_3

    iget-object v0, p0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->mActivityInfo:Lcom/mediatek/boostfwk/info/ActivityInfo;

    invoke-virtual {v0}, Lcom/mediatek/boostfwk/info/ActivityInfo;->isAOSPPageDesign()Z

    move-result v0

    if-eqz v0, :cond_3

    const/4 v0, 0x1

    .line 347
    iput-boolean v0, p0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->mIsRealAOSPPage:Z

    :cond_3
    if-eqz p1, :cond_4

    const/4 p1, 0x0

    .line 350
    invoke-virtual {p0, p1}, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->disableMTKScrollingPolicy(Z)V

    .line 352
    :cond_4
    invoke-static {}, Lcom/mediatek/boostfwk/utils/LogUtil;->traceEnd()V

    return-void
.end method
