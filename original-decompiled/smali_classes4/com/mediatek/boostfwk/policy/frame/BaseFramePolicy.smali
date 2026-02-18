.class public Lcom/mediatek/boostfwk/policy/frame/BaseFramePolicy;
.super Ljava/lang/Object;
.source "BaseFramePolicy.java"

# interfaces
.implements Lcom/mediatek/boostfwk/info/ActivityInfo$ActivityChangeListener;


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/mediatek/boostfwk/policy/frame/BaseFramePolicy$WorkerHandler;,
        Lcom/mediatek/boostfwk/policy/frame/BaseFramePolicy$ScrollListener;
    }
.end annotation


# static fields
.field static final TAG:Ljava/lang/String; = "FramePolicy"

.field static final THREAD_NAME:Ljava/lang/String; = "FramePolicy"

.field static mDisableFrameRescue:Z = true

.field static mListenFrameHint:Z = false


# instance fields
.field mActivityInfo:Lcom/mediatek/boostfwk/info/ActivityInfo;

.field mCoreServiceReady:Z

.field mPowerHalService:Lcom/mediatek/powerhalmgr/PowerHalMgr;

.field mPowerHalWrap:Lcom/mediatek/powerhalwrapper/PowerHalWrapper;

.field mPowerHandle:I

.field mScrollStateListener:Lcom/mediatek/boostfwk/info/ScrollState$ScrollStateListener;

.field mWorkerHandler:Lcom/mediatek/boostfwk/policy/frame/BaseFramePolicy$WorkerHandler;

.field mWorkerThread:Landroid/os/HandlerThread;


# direct methods
.method static constructor <clinit>()V
    .locals 0

    return-void
.end method

.method constructor <init>()V
    .locals 2

    .line 82
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    const/4 v0, 0x0

    .line 60
    iput-object v0, p0, Lcom/mediatek/boostfwk/policy/frame/BaseFramePolicy;->mPowerHalService:Lcom/mediatek/powerhalmgr/PowerHalMgr;

    .line 61
    iput-object v0, p0, Lcom/mediatek/boostfwk/policy/frame/BaseFramePolicy;->mPowerHalWrap:Lcom/mediatek/powerhalwrapper/PowerHalWrapper;

    const/4 v1, 0x0

    .line 62
    iput v1, p0, Lcom/mediatek/boostfwk/policy/frame/BaseFramePolicy;->mPowerHandle:I

    .line 65
    iput-object v0, p0, Lcom/mediatek/boostfwk/policy/frame/BaseFramePolicy;->mWorkerThread:Landroid/os/HandlerThread;

    .line 66
    iput-object v0, p0, Lcom/mediatek/boostfwk/policy/frame/BaseFramePolicy;->mWorkerHandler:Lcom/mediatek/boostfwk/policy/frame/BaseFramePolicy$WorkerHandler;

    .line 70
    iput-boolean v1, p0, Lcom/mediatek/boostfwk/policy/frame/BaseFramePolicy;->mCoreServiceReady:Z

    .line 72
    iput-object v0, p0, Lcom/mediatek/boostfwk/policy/frame/BaseFramePolicy;->mScrollStateListener:Lcom/mediatek/boostfwk/info/ScrollState$ScrollStateListener;

    .line 73
    iput-object v0, p0, Lcom/mediatek/boostfwk/policy/frame/BaseFramePolicy;->mActivityInfo:Lcom/mediatek/boostfwk/info/ActivityInfo;

    .line 83
    invoke-direct {p0}, Lcom/mediatek/boostfwk/policy/frame/BaseFramePolicy;->initThread()V

    .line 84
    new-instance v1, Lcom/mediatek/boostfwk/policy/frame/BaseFramePolicy$ScrollListener;

    invoke-direct {v1, p0, v0}, Lcom/mediatek/boostfwk/policy/frame/BaseFramePolicy$ScrollListener;-><init>(Lcom/mediatek/boostfwk/policy/frame/BaseFramePolicy;Lcom/mediatek/boostfwk/policy/frame/BaseFramePolicy$ScrollListener-IA;)V

    iput-object v1, p0, Lcom/mediatek/boostfwk/policy/frame/BaseFramePolicy;->mScrollStateListener:Lcom/mediatek/boostfwk/info/ScrollState$ScrollStateListener;

    .line 85
    invoke-static {}, Lcom/mediatek/boostfwk/info/ActivityInfo;->getInstance()Lcom/mediatek/boostfwk/info/ActivityInfo;

    move-result-object v0

    iput-object v0, p0, Lcom/mediatek/boostfwk/policy/frame/BaseFramePolicy;->mActivityInfo:Lcom/mediatek/boostfwk/info/ActivityInfo;

    .line 86
    invoke-virtual {v0, p0}, Lcom/mediatek/boostfwk/info/ActivityInfo;->registerActivityListener(Lcom/mediatek/boostfwk/info/ActivityInfo$ActivityChangeListener;)V

    return-void
.end method

.method private initThread()V
    .locals 2

    .line 90
    iget-object v0, p0, Lcom/mediatek/boostfwk/policy/frame/BaseFramePolicy;->mWorkerThread:Landroid/os/HandlerThread;

    const-string v1, "FramePolicy"

    if-eqz v0, :cond_0

    invoke-virtual {v0}, Landroid/os/HandlerThread;->isAlive()Z

    move-result v0

    if-eqz v0, :cond_0

    iget-object v0, p0, Lcom/mediatek/boostfwk/policy/frame/BaseFramePolicy;->mWorkerHandler:Lcom/mediatek/boostfwk/policy/frame/BaseFramePolicy$WorkerHandler;

    if-eqz v0, :cond_0

    const-string p0, "re-init"

    .line 92
    invoke-static {v1, p0}, Lcom/mediatek/boostfwk/utils/LogUtil;->mLogd(Ljava/lang/String;Ljava/lang/String;)V

    goto :goto_0

    .line 94
    :cond_0
    new-instance v0, Landroid/os/HandlerThread;

    invoke-direct {v0, v1}, Landroid/os/HandlerThread;-><init>(Ljava/lang/String;)V

    iput-object v0, p0, Lcom/mediatek/boostfwk/policy/frame/BaseFramePolicy;->mWorkerThread:Landroid/os/HandlerThread;

    .line 95
    invoke-virtual {v0}, Landroid/os/HandlerThread;->start()V

    .line 96
    iget-object v0, p0, Lcom/mediatek/boostfwk/policy/frame/BaseFramePolicy;->mWorkerThread:Landroid/os/HandlerThread;

    invoke-virtual {v0}, Landroid/os/HandlerThread;->getLooper()Landroid/os/Looper;

    move-result-object v0

    if-nez v0, :cond_1

    const-string p0, "Thread looper is null"

    .line 98
    invoke-static {v1, p0}, Lcom/mediatek/boostfwk/utils/LogUtil;->mLogd(Ljava/lang/String;Ljava/lang/String;)V

    goto :goto_0

    .line 100
    :cond_1
    new-instance v1, Lcom/mediatek/boostfwk/policy/frame/BaseFramePolicy$WorkerHandler;

    invoke-direct {v1, p0, v0}, Lcom/mediatek/boostfwk/policy/frame/BaseFramePolicy$WorkerHandler;-><init>(Lcom/mediatek/boostfwk/policy/frame/BaseFramePolicy;Landroid/os/Looper;)V

    iput-object v1, p0, Lcom/mediatek/boostfwk/policy/frame/BaseFramePolicy;->mWorkerHandler:Lcom/mediatek/boostfwk/policy/frame/BaseFramePolicy$WorkerHandler;

    :goto_0
    return-void
.end method


# virtual methods
.method public doFrameHint(ZJ)V
    .locals 0

    return-void
.end method

.method public doFrameStepHint(ZI)V
    .locals 0

    return-void
.end method

.method public getThreadedRenderer()Landroid/view/ThreadedRenderer;
    .locals 0

    .line 119
    iget-object p0, p0, Lcom/mediatek/boostfwk/policy/frame/BaseFramePolicy;->mActivityInfo:Lcom/mediatek/boostfwk/info/ActivityInfo;

    if-nez p0, :cond_0

    const/4 p0, 0x0

    goto :goto_0

    :cond_0
    invoke-virtual {p0}, Lcom/mediatek/boostfwk/info/ActivityInfo;->getThreadedRenderer()Landroid/view/ThreadedRenderer;

    move-result-object p0

    :goto_0
    return-object p0
.end method

.method protected handleMessageInternal(Landroid/os/Message;)V
    .locals 0

    return-void
.end method

.method protected initCoreServiceInternal()V
    .locals 1

    .line 130
    invoke-static {}, Lcom/mediatek/powerhalmgr/PowerHalMgrFactory;->getInstance()Lcom/mediatek/powerhalmgr/PowerHalMgrFactory;

    move-result-object v0

    invoke-virtual {v0}, Lcom/mediatek/powerhalmgr/PowerHalMgrFactory;->makePowerHalMgr()Lcom/mediatek/powerhalmgr/PowerHalMgr;

    move-result-object v0

    iput-object v0, p0, Lcom/mediatek/boostfwk/policy/frame/BaseFramePolicy;->mPowerHalService:Lcom/mediatek/powerhalmgr/PowerHalMgr;

    .line 131
    invoke-static {}, Lcom/mediatek/powerhalwrapper/PowerHalWrapper;->getInstance()Lcom/mediatek/powerhalwrapper/PowerHalWrapper;

    move-result-object v0

    iput-object v0, p0, Lcom/mediatek/boostfwk/policy/frame/BaseFramePolicy;->mPowerHalWrap:Lcom/mediatek/powerhalwrapper/PowerHalWrapper;

    .line 132
    iget-object v0, p0, Lcom/mediatek/boostfwk/policy/frame/BaseFramePolicy;->mScrollStateListener:Lcom/mediatek/boostfwk/info/ScrollState$ScrollStateListener;

    invoke-static {v0}, Lcom/mediatek/boostfwk/info/ScrollState;->registerScrollStateListener(Lcom/mediatek/boostfwk/info/ScrollState$ScrollStateListener;)V

    const/4 v0, 0x1

    .line 133
    iput-boolean v0, p0, Lcom/mediatek/boostfwk/policy/frame/BaseFramePolicy;->mCoreServiceReady:Z

    return-void
.end method

.method public initLimitTime(F)Z
    .locals 0

    const/4 p0, 0x0

    return p0
.end method

.method public onAllActivityPaused(Landroid/content/Context;)V
    .locals 0

    return-void
.end method

.method public onChange(Landroid/content/Context;)V
    .locals 0

    .line 160
    iget-boolean p1, p0, Lcom/mediatek/boostfwk/policy/frame/BaseFramePolicy;->mCoreServiceReady:Z

    if-nez p1, :cond_0

    iget-object p0, p0, Lcom/mediatek/boostfwk/policy/frame/BaseFramePolicy;->mWorkerHandler:Lcom/mediatek/boostfwk/policy/frame/BaseFramePolicy$WorkerHandler;

    if-eqz p0, :cond_0

    const/16 p1, -0x3e8

    .line 161
    invoke-virtual {p0, p1}, Landroid/os/Handler;->sendEmptyMessage(I)Z

    :cond_0
    return-void
.end method

.method public onRequestNextVsync()V
    .locals 0

    return-void
.end method

.method protected onScrollStateChange(Z)V
    .locals 0

    const/4 p0, 0x1

    xor-int/2addr p1, p0

    .line 123
    sput-boolean p1, Lcom/mediatek/boostfwk/policy/frame/BaseFramePolicy;->mDisableFrameRescue:Z

    if-nez p1, :cond_0

    .line 125
    sput-boolean p0, Lcom/mediatek/boostfwk/policy/frame/BaseFramePolicy;->mListenFrameHint:Z

    :cond_0
    return-void
.end method
