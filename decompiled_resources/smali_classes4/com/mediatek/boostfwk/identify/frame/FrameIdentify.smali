.class public Lcom/mediatek/boostfwk/identify/frame/FrameIdentify;
.super Lcom/mediatek/boostfwk/identify/BaseIdentify;
.source "FrameIdentify.java"


# static fields
.field private static final BOOST_FWK_VERSION:I

.field private static final TAG:Ljava/lang/String; = "FrameIdentify"

.field private static mFrameIntervalMs:J = 0x0L

.field private static mIsDoFrameBegin:Z = false

.field private static mIsOnVsyncCheck:Z = false

.field private static mLimitVsyncTime:J

.field private static mRefreshRate:F

.field private static sInstance:Lcom/mediatek/boostfwk/identify/frame/FrameIdentify;

.field private static slock:Ljava/lang/Object;


# instance fields
.field private mFramePolicy:Lcom/mediatek/boostfwk/policy/frame/BaseFramePolicy;

.field private mScrollingFramePrefetcher:Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;


# direct methods
.method static constructor <clinit>()V
    .locals 1

    .line 69
    new-instance v0, Ljava/lang/Object;

    invoke-direct {v0}, Ljava/lang/Object;-><init>()V

    sput-object v0, Lcom/mediatek/boostfwk/identify/frame/FrameIdentify;->slock:Ljava/lang/Object;

    .line 76
    invoke-static {}, Lcom/mediatek/boostfwk/utils/Config;->getBoostFwkVersion()I

    move-result v0

    sput v0, Lcom/mediatek/boostfwk/identify/frame/FrameIdentify;->BOOST_FWK_VERSION:I

    return-void
.end method

.method private constructor <init>()V
    .locals 2

    .line 91
    invoke-direct {p0}, Lcom/mediatek/boostfwk/identify/BaseIdentify;-><init>()V

    const/4 v0, 0x0

    .line 77
    iput-object v0, p0, Lcom/mediatek/boostfwk/identify/frame/FrameIdentify;->mFramePolicy:Lcom/mediatek/boostfwk/policy/frame/BaseFramePolicy;

    .line 78
    iput-object v0, p0, Lcom/mediatek/boostfwk/identify/frame/FrameIdentify;->mScrollingFramePrefetcher:Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;

    .line 93
    sget v0, Lcom/mediatek/boostfwk/identify/frame/FrameIdentify;->BOOST_FWK_VERSION:I

    const/4 v1, 0x1

    if-le v0, v1, :cond_0

    .line 94
    invoke-static {}, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->getInstance()Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;

    move-result-object v0

    goto :goto_0

    :cond_0
    invoke-static {}, Lcom/mediatek/boostfwk/policy/frame/FramePolicy;->getInstance()Lcom/mediatek/boostfwk/policy/frame/FramePolicy;

    move-result-object v0

    :goto_0
    iput-object v0, p0, Lcom/mediatek/boostfwk/identify/frame/FrameIdentify;->mFramePolicy:Lcom/mediatek/boostfwk/policy/frame/BaseFramePolicy;

    .line 96
    iget-object v0, p0, Lcom/mediatek/boostfwk/identify/frame/FrameIdentify;->mScrollingFramePrefetcher:Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;

    if-nez v0, :cond_1

    .line 97
    invoke-static {}, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->getInstance()Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;

    move-result-object v0

    iput-object v0, p0, Lcom/mediatek/boostfwk/identify/frame/FrameIdentify;->mScrollingFramePrefetcher:Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;

    :cond_1
    return-void
.end method

.method private boostBeginEndCheck(I)Z
    .locals 0

    if-nez p1, :cond_0

    const/4 p0, 0x1

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method private checkStartFrameTracking(Ljava/lang/String;)V
    .locals 1

    .line 173
    invoke-static {}, Lcom/mediatek/boostfwk/policy/frame/FrameDecision;->getInstance()Lcom/mediatek/boostfwk/policy/frame/FrameDecision;

    move-result-object p0

    if-eqz p1, :cond_0

    const-string v0, ""

    if-eq p1, v0, :cond_0

    const-string v0, "android"

    .line 174
    invoke-virtual {v0, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-nez v0, :cond_0

    sget-object v0, Lcom/mediatek/boostfwk/utils/Config;->FRAME_TRACKING_LIST:Ljava/util/ArrayList;

    .line 175
    invoke-virtual {v0, p1}, Ljava/util/ArrayList;->contains(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_0

    const-string v0, "FrameIdentify"

    .line 176
    invoke-static {v0, p1}, Lcom/mediatek/boostfwk/utils/LogUtil;->mLogd(Ljava/lang/String;Ljava/lang/String;)V

    const/4 p1, 0x1

    .line 177
    invoke-virtual {p0, p1}, Lcom/mediatek/boostfwk/policy/frame/FrameDecision;->setStartFrameTracking(Z)V

    .line 178
    invoke-virtual {p0, p1}, Lcom/mediatek/boostfwk/policy/frame/FrameDecision;->setStartListenFrameHint(Z)V

    :cond_0
    return-void
.end method

.method private doFrameCheck(IJLcom/mediatek/boostfwk/scenario/frame/FrameScenario;)V
    .locals 5

    .line 183
    invoke-direct {p0}, Lcom/mediatek/boostfwk/identify/frame/FrameIdentify;->doFrameInit()Z

    move-result v0

    .line 184
    invoke-static {}, Lcom/mediatek/boostfwk/policy/frame/FrameDecision;->getInstance()Lcom/mediatek/boostfwk/policy/frame/FrameDecision;

    move-result-object v1

    .line 185
    sget v2, Lcom/mediatek/boostfwk/identify/frame/FrameIdentify;->BOOST_FWK_VERSION:I

    const/4 v3, 0x1

    if-le v2, v3, :cond_2

    if-nez v0, :cond_1

    .line 186
    invoke-virtual {v1}, Lcom/mediatek/boostfwk/policy/frame/FrameDecision;->isEnableFrameTracking()Z

    move-result v4

    if-eqz v4, :cond_0

    goto :goto_0

    :cond_0
    const/4 v3, 0x0

    :cond_1
    :goto_0
    invoke-virtual {p4, v3}, Lcom/mediatek/boostfwk/scenario/frame/FrameScenario;->setIsListenFrameHint(Z)V

    .line 187
    invoke-static {}, Lcom/mediatek/boostfwk/info/ScrollState;->getFling()Z

    move-result v3

    invoke-virtual {p4, v3}, Lcom/mediatek/boostfwk/scenario/frame/FrameScenario;->setFling(Z)Lcom/mediatek/boostfwk/scenario/frame/FrameScenario;

    .line 188
    sget-boolean v3, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->FEATURE_ENABLE:Z

    invoke-virtual {p4, v3}, Lcom/mediatek/boostfwk/scenario/frame/FrameScenario;->setSFPEnable(Z)Lcom/mediatek/boostfwk/scenario/frame/FrameScenario;

    move-result-object v3

    sget-boolean v4, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->PRE_ANIM_ENABLE:Z

    .line 189
    invoke-virtual {v3, v4}, Lcom/mediatek/boostfwk/scenario/frame/FrameScenario;->setPreAnimEnable(Z)Lcom/mediatek/boostfwk/scenario/frame/FrameScenario;

    .line 191
    :cond_2
    invoke-direct {p0, p1}, Lcom/mediatek/boostfwk/identify/frame/FrameIdentify;->boostBeginEndCheck(I)Z

    move-result p1

    sput-boolean p1, Lcom/mediatek/boostfwk/identify/frame/FrameIdentify;->mIsOnVsyncCheck:Z

    const/4 v3, 0x2

    if-le v2, v3, :cond_4

    if-nez p1, :cond_3

    .line 194
    invoke-virtual {p4}, Lcom/mediatek/boostfwk/scenario/frame/FrameScenario;->resetTraversalCallbackCount()V

    .line 196
    :cond_3
    sget-boolean p1, Lcom/mediatek/boostfwk/identify/frame/FrameIdentify;->mIsOnVsyncCheck:Z

    invoke-virtual {v1, p1, p2, p3}, Lcom/mediatek/boostfwk/policy/frame/FrameDecision;->onDoFrame(ZJ)V

    :cond_4
    if-nez v0, :cond_5

    return-void

    .line 202
    :cond_5
    iget-object p0, p0, Lcom/mediatek/boostfwk/identify/frame/FrameIdentify;->mFramePolicy:Lcom/mediatek/boostfwk/policy/frame/BaseFramePolicy;

    sget-boolean p1, Lcom/mediatek/boostfwk/identify/frame/FrameIdentify;->mIsOnVsyncCheck:Z

    invoke-virtual {p0, p1, p2, p3}, Lcom/mediatek/boostfwk/policy/frame/BaseFramePolicy;->doFrameHint(ZJ)V

    return-void
.end method

.method private doFrameInit()Z
    .locals 2

    .line 219
    invoke-static {}, Lcom/mediatek/boostfwk/info/ScrollState;->getRefreshRate()F

    move-result v0

    sput v0, Lcom/mediatek/boostfwk/identify/frame/FrameIdentify;->mRefreshRate:F

    const/high16 v1, 0x447a0000    # 1000.0f

    div-float/2addr v1, v0

    float-to-long v0, v1

    .line 220
    sput-wide v0, Lcom/mediatek/boostfwk/identify/frame/FrameIdentify;->mFrameIntervalMs:J

    .line 221
    iget-object p0, p0, Lcom/mediatek/boostfwk/identify/frame/FrameIdentify;->mFramePolicy:Lcom/mediatek/boostfwk/policy/frame/BaseFramePolicy;

    long-to-float v0, v0

    invoke-virtual {p0, v0}, Lcom/mediatek/boostfwk/policy/frame/BaseFramePolicy;->initLimitTime(F)Z

    move-result p0

    return p0
.end method

.method private doFrameRequestNextVsync()V
    .locals 1

    .line 214
    iget-object v0, p0, Lcom/mediatek/boostfwk/identify/frame/FrameIdentify;->mFramePolicy:Lcom/mediatek/boostfwk/policy/frame/BaseFramePolicy;

    invoke-virtual {v0}, Lcom/mediatek/boostfwk/policy/frame/BaseFramePolicy;->onRequestNextVsync()V

    .line 215
    iget-object p0, p0, Lcom/mediatek/boostfwk/identify/frame/FrameIdentify;->mScrollingFramePrefetcher:Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;

    invoke-virtual {p0}, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->onRequestNextVsync()V

    return-void
.end method

.method private doFrameStepCheck(IILcom/mediatek/boostfwk/scenario/frame/FrameScenario;)V
    .locals 2

    .line 206
    invoke-direct {p0}, Lcom/mediatek/boostfwk/identify/frame/FrameIdentify;->isBeginFrameAction()Z

    move-result v0

    if-nez v0, :cond_0

    return-void

    .line 209
    :cond_0
    invoke-static {}, Lcom/mediatek/boostfwk/policy/frame/FrameDecision;->getInstance()Lcom/mediatek/boostfwk/policy/frame/FrameDecision;

    move-result-object v0

    invoke-direct {p0, p1}, Lcom/mediatek/boostfwk/identify/frame/FrameIdentify;->boostBeginEndCheck(I)Z

    move-result v1

    invoke-virtual {v0, v1, p2, p3}, Lcom/mediatek/boostfwk/policy/frame/FrameDecision;->onDoFrameStep(ZILcom/mediatek/boostfwk/scenario/frame/FrameScenario;)V

    .line 210
    iget-object p3, p0, Lcom/mediatek/boostfwk/identify/frame/FrameIdentify;->mFramePolicy:Lcom/mediatek/boostfwk/policy/frame/BaseFramePolicy;

    invoke-direct {p0, p1}, Lcom/mediatek/boostfwk/identify/frame/FrameIdentify;->boostBeginEndCheck(I)Z

    move-result p0

    invoke-virtual {p3, p0, p2}, Lcom/mediatek/boostfwk/policy/frame/BaseFramePolicy;->doFrameStepHint(ZI)V

    return-void
.end method

.method private doScrollingFramePrefetcher(ILcom/mediatek/boostfwk/scenario/frame/FrameScenario;)V
    .locals 4

    .line 233
    invoke-direct {p0, p1}, Lcom/mediatek/boostfwk/identify/frame/FrameIdentify;->boostBeginEndCheck(I)Z

    move-result p1

    if-eqz p1, :cond_1

    const/4 p1, 0x1

    .line 235
    sput-boolean p1, Lcom/mediatek/boostfwk/identify/frame/FrameIdentify;->mIsDoFrameBegin:Z

    .line 238
    sget-boolean v0, Lcom/mediatek/boostfwk/identify/frame/FrameIdentify;->mIsOnVsyncCheck:Z

    if-nez v0, :cond_0

    invoke-virtual {p2}, Lcom/mediatek/boostfwk/scenario/frame/FrameScenario;->getFrameId()J

    move-result-wide v0

    const-wide/16 v2, -0x1

    cmp-long v0, v0, v2

    if-nez v0, :cond_0

    .line 240
    invoke-direct {p0}, Lcom/mediatek/boostfwk/identify/frame/FrameIdentify;->doFrameInit()Z

    move-result v0

    invoke-virtual {p2, v0}, Lcom/mediatek/boostfwk/scenario/frame/FrameScenario;->setIsListenFrameHint(Z)V

    .line 241
    sput-boolean p1, Lcom/mediatek/boostfwk/identify/frame/FrameIdentify;->mIsOnVsyncCheck:Z

    .line 242
    iget-object v0, p0, Lcom/mediatek/boostfwk/identify/frame/FrameIdentify;->mFramePolicy:Lcom/mediatek/boostfwk/policy/frame/BaseFramePolicy;

    invoke-virtual {p2}, Lcom/mediatek/boostfwk/scenario/frame/FrameScenario;->getFrameId()J

    move-result-wide v1

    invoke-virtual {v0, p1, v1, v2}, Lcom/mediatek/boostfwk/policy/frame/BaseFramePolicy;->doFrameHint(ZJ)V

    .line 243
    sget v0, Lcom/mediatek/boostfwk/identify/frame/FrameIdentify;->BOOST_FWK_VERSION:I

    const/4 v1, 0x2

    if-le v0, v1, :cond_0

    .line 244
    invoke-static {}, Lcom/mediatek/boostfwk/policy/frame/FrameDecision;->getInstance()Lcom/mediatek/boostfwk/policy/frame/FrameDecision;

    move-result-object v0

    invoke-virtual {p2}, Lcom/mediatek/boostfwk/scenario/frame/FrameScenario;->getFrameId()J

    move-result-wide v1

    invoke-virtual {v0, p1, v1, v2}, Lcom/mediatek/boostfwk/policy/frame/FrameDecision;->onDoFrame(ZJ)V

    .line 247
    :cond_0
    iget-object p0, p0, Lcom/mediatek/boostfwk/identify/frame/FrameIdentify;->mScrollingFramePrefetcher:Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;

    invoke-virtual {p0, p2}, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->doScrollingFramePrefetcher(Lcom/mediatek/boostfwk/scenario/frame/FrameScenario;)V

    goto :goto_0

    .line 248
    :cond_1
    sget-boolean v0, Lcom/mediatek/boostfwk/identify/frame/FrameIdentify;->mIsDoFrameBegin:Z

    if-eqz v0, :cond_2

    const/4 v0, 0x0

    .line 249
    sput-boolean v0, Lcom/mediatek/boostfwk/identify/frame/FrameIdentify;->mIsDoFrameBegin:Z

    .line 250
    iget-object p0, p0, Lcom/mediatek/boostfwk/identify/frame/FrameIdentify;->mScrollingFramePrefetcher:Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;

    invoke-virtual {p0, p1, p2}, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->onFrameEnd(ZLcom/mediatek/boostfwk/scenario/frame/FrameScenario;)V

    :cond_2
    :goto_0
    return-void
.end method

.method private doScrollingFramePrefetcherPreAnim(Lcom/mediatek/boostfwk/scenario/frame/FrameScenario;)V
    .locals 0

    .line 255
    iget-object p0, p0, Lcom/mediatek/boostfwk/identify/frame/FrameIdentify;->mScrollingFramePrefetcher:Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;

    invoke-virtual {p0}, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->isPreAnimation()Z

    move-result p0

    invoke-virtual {p1, p0}, Lcom/mediatek/boostfwk/scenario/frame/FrameScenario;->setPreAnim(Z)Lcom/mediatek/boostfwk/scenario/frame/FrameScenario;

    return-void
.end method

.method public static getInstance()Lcom/mediatek/boostfwk/identify/frame/FrameIdentify;
    .locals 2

    .line 81
    sget-object v0, Lcom/mediatek/boostfwk/identify/frame/FrameIdentify;->sInstance:Lcom/mediatek/boostfwk/identify/frame/FrameIdentify;

    if-nez v0, :cond_1

    .line 82
    sget-object v0, Lcom/mediatek/boostfwk/identify/frame/FrameIdentify;->slock:Ljava/lang/Object;

    monitor-enter v0

    .line 83
    :try_start_0
    sget-object v1, Lcom/mediatek/boostfwk/identify/frame/FrameIdentify;->sInstance:Lcom/mediatek/boostfwk/identify/frame/FrameIdentify;

    if-nez v1, :cond_0

    .line 84
    new-instance v1, Lcom/mediatek/boostfwk/identify/frame/FrameIdentify;

    invoke-direct {v1}, Lcom/mediatek/boostfwk/identify/frame/FrameIdentify;-><init>()V

    sput-object v1, Lcom/mediatek/boostfwk/identify/frame/FrameIdentify;->sInstance:Lcom/mediatek/boostfwk/identify/frame/FrameIdentify;

    .line 86
    :cond_0
    monitor-exit v0

    goto :goto_0

    :catchall_0
    move-exception v1

    monitor-exit v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    throw v1

    .line 88
    :cond_1
    :goto_0
    sget-object v0, Lcom/mediatek/boostfwk/identify/frame/FrameIdentify;->sInstance:Lcom/mediatek/boostfwk/identify/frame/FrameIdentify;

    return-object v0
.end method

.method private isBeginFrameAction()Z
    .locals 0

    .line 225
    sget-boolean p0, Lcom/mediatek/boostfwk/identify/frame/FrameIdentify;->mIsOnVsyncCheck:Z

    return p0
.end method

.method private notifyFramePerformDrawFinish(Lcom/mediatek/boostfwk/scenario/frame/FrameScenario;)V
    .locals 0

    .line 151
    sget p0, Lcom/mediatek/boostfwk/identify/frame/FrameIdentify;->BOOST_FWK_VERSION:I

    const/4 p1, 0x2

    if-le p0, p1, :cond_0

    .line 152
    invoke-static {}, Lcom/mediatek/boostfwk/policy/frame/FrameDecision;->getInstance()Lcom/mediatek/boostfwk/policy/frame/FrameDecision;

    move-result-object p0

    invoke-virtual {p0}, Lcom/mediatek/boostfwk/policy/frame/FrameDecision;->perfromDraw()V

    :cond_0
    return-void
.end method

.method private updateRenderInfo(Lcom/mediatek/boostfwk/scenario/frame/FrameScenario;)V
    .locals 3

    .line 157
    invoke-virtual {p1}, Lcom/mediatek/boostfwk/scenario/frame/FrameScenario;->getRenderThreadTid()I

    move-result v0

    if-lez v0, :cond_0

    .line 159
    invoke-static {}, Lcom/mediatek/boostfwk/info/ActivityInfo;->getInstance()Lcom/mediatek/boostfwk/info/ActivityInfo;

    move-result-object v1

    invoke-virtual {v1, v0}, Lcom/mediatek/boostfwk/info/ActivityInfo;->setRenderThreadTid(I)V

    .line 160
    sget v1, Lcom/mediatek/boostfwk/identify/frame/FrameIdentify;->BOOST_FWK_VERSION:I

    const/4 v2, 0x2

    if-le v1, v2, :cond_0

    .line 162
    invoke-virtual {p1}, Lcom/mediatek/boostfwk/scenario/frame/FrameScenario;->getPackageName()Ljava/lang/String;

    move-result-object v1

    invoke-direct {p0, v1}, Lcom/mediatek/boostfwk/identify/frame/FrameIdentify;->checkStartFrameTracking(Ljava/lang/String;)V

    .line 165
    :cond_0
    sget-boolean p0, Lcom/mediatek/boostfwk/utils/LogUtil;->DEBUG:Z

    if-eqz p0, :cond_1

    .line 166
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "init renderThreadTid="

    invoke-virtual {p0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    const-string v0, "FrameIdentify"

    invoke-static {v0, p0}, Lcom/mediatek/boostfwk/utils/LogUtil;->traceAndMLogd(Ljava/lang/String;Ljava/lang/String;)V

    .line 168
    :cond_1
    invoke-static {}, Lcom/mediatek/boostfwk/info/ActivityInfo;->getInstance()Lcom/mediatek/boostfwk/info/ActivityInfo;

    move-result-object p0

    invoke-virtual {p1}, Lcom/mediatek/boostfwk/scenario/frame/FrameScenario;->getThreadedRendererAndClear()Landroid/view/ThreadedRenderer;

    move-result-object p1

    invoke-virtual {p0, p1}, Lcom/mediatek/boostfwk/info/ActivityInfo;->setThreadedRenderer(Landroid/view/ThreadedRenderer;)V

    return-void
.end method


# virtual methods
.method public dispatchScenario(Lcom/mediatek/boostfwk/scenario/BasicScenario;)Z
    .locals 6

    .line 108
    invoke-static {}, Lcom/mediatek/boostfwk/utils/Config;->disableFrameIdentify()Z

    move-result v0

    if-nez v0, :cond_2

    if-nez p1, :cond_0

    goto :goto_1

    .line 111
    :cond_0
    check-cast p1, Lcom/mediatek/boostfwk/scenario/frame/FrameScenario;

    .line 113
    invoke-virtual {p1}, Lcom/mediatek/boostfwk/scenario/frame/FrameScenario;->getScenarioAction()I

    move-result v0

    .line 114
    invoke-virtual {p1}, Lcom/mediatek/boostfwk/scenario/frame/FrameScenario;->getBoostStatus()I

    move-result v1

    .line 115
    invoke-virtual {p1}, Lcom/mediatek/boostfwk/scenario/frame/FrameScenario;->getFrameStep()I

    move-result v2

    .line 116
    invoke-static {}, Lcom/mediatek/boostfwk/utils/Config;->isBoostFwkLogEnable()Z

    move-result v3

    const-string v4, "FrameIdentify"

    if-eqz v3, :cond_1

    .line 117
    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v5, "Frame action dispatcher to = "

    invoke-virtual {v3, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v5, " status = "

    invoke-virtual {v3, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v5, ", frame step = "

    invoke-virtual {v3, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-static {v4, v3}, Lcom/mediatek/boostfwk/utils/LogUtil;->mLogd(Ljava/lang/String;Ljava/lang/String;)V

    :cond_1
    packed-switch v0, :pswitch_data_0

    const-string p0, "Not found dispatcher frame action."

    .line 144
    invoke-static {v4, p0}, Lcom/mediatek/boostfwk/utils/LogUtil;->mLogw(Ljava/lang/String;Ljava/lang/String;)V

    goto :goto_0

    .line 141
    :pswitch_0
    invoke-direct {p0, p1}, Lcom/mediatek/boostfwk/identify/frame/FrameIdentify;->notifyFramePerformDrawFinish(Lcom/mediatek/boostfwk/scenario/frame/FrameScenario;)V

    goto :goto_0

    .line 138
    :pswitch_1
    invoke-direct {p0, p1}, Lcom/mediatek/boostfwk/identify/frame/FrameIdentify;->doScrollingFramePrefetcherPreAnim(Lcom/mediatek/boostfwk/scenario/frame/FrameScenario;)V

    goto :goto_0

    .line 135
    :pswitch_2
    invoke-direct {p0, v1, p1}, Lcom/mediatek/boostfwk/identify/frame/FrameIdentify;->doScrollingFramePrefetcher(ILcom/mediatek/boostfwk/scenario/frame/FrameScenario;)V

    goto :goto_0

    .line 132
    :pswitch_3
    invoke-direct {p0, p1}, Lcom/mediatek/boostfwk/identify/frame/FrameIdentify;->updateRenderInfo(Lcom/mediatek/boostfwk/scenario/frame/FrameScenario;)V

    goto :goto_0

    .line 129
    :pswitch_4
    invoke-direct {p0}, Lcom/mediatek/boostfwk/identify/frame/FrameIdentify;->doFrameRequestNextVsync()V

    goto :goto_0

    .line 126
    :pswitch_5
    invoke-direct {p0, v1, v2, p1}, Lcom/mediatek/boostfwk/identify/frame/FrameIdentify;->doFrameStepCheck(IILcom/mediatek/boostfwk/scenario/frame/FrameScenario;)V

    goto :goto_0

    .line 123
    :pswitch_6
    invoke-virtual {p1}, Lcom/mediatek/boostfwk/scenario/frame/FrameScenario;->getFrameId()J

    move-result-wide v2

    invoke-direct {p0, v1, v2, v3, p1}, Lcom/mediatek/boostfwk/identify/frame/FrameIdentify;->doFrameCheck(IJLcom/mediatek/boostfwk/scenario/frame/FrameScenario;)V

    :goto_0
    const/4 p0, 0x1

    return p0

    :cond_2
    :goto_1
    const/4 p0, 0x0

    return p0

    nop

    :pswitch_data_0
    .packed-switch 0x0
        :pswitch_6
        :pswitch_5
        :pswitch_4
        :pswitch_3
        :pswitch_2
        :pswitch_1
        :pswitch_0
    .end packed-switch
.end method
