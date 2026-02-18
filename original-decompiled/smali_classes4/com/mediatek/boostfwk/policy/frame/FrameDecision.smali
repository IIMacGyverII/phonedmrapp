.class public Lcom/mediatek/boostfwk/policy/frame/FrameDecision;
.super Ljava/lang/Object;
.source "FrameDecision.java"

# interfaces
.implements Lcom/mediatek/boostfwk/info/ScrollState$ScrollStateListener;
.implements Lcom/mediatek/boostfwk/info/ActivityInfo$ActivityChangeListener;


# static fields
.field private static final LOCK:Ljava/lang/Object;

.field private static final TAG:Ljava/lang/String; = "FrameDecision"

.field private static mInstance:Lcom/mediatek/boostfwk/policy/frame/FrameDecision;


# instance fields
.field private final FRAME_BEGIN:I

.field private final FRAME_END:I

.field private final FRAME_MUTIL_BUFFER:I

.field private final FRAME_UNUSUAL:I

.field private final PAGE_TYPE_FLUTTER:I

.field private final PAGE_TYPE_HWUI:I

.field private final PAGE_TYPE_WEBVIEW:I

.field private mEnbaleFrameTracking:Z

.field private mForceCtrl:Z

.field private mFrameDrawnCount:I

.field private mFrameRequestTraversalCount:I

.field private mLastFrameBeginFrameId:J

.field private mLastHWUIDoFrameStep:I

.field private mPowerHalWrap:Lcom/mediatek/powerhalwrapper/PowerHalWrapper;

.field private mRenderThreadTid:I

.field private mStartListenFrameHint:Z


# direct methods
.method static constructor <clinit>()V
    .locals 1

    .line 65
    new-instance v0, Ljava/lang/Object;

    invoke-direct {v0}, Ljava/lang/Object;-><init>()V

    sput-object v0, Lcom/mediatek/boostfwk/policy/frame/FrameDecision;->LOCK:Ljava/lang/Object;

    return-void
.end method

.method private constructor <init>()V
    .locals 5

    .line 103
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    const/4 v0, 0x0

    .line 68
    iput-object v0, p0, Lcom/mediatek/boostfwk/policy/frame/FrameDecision;->mPowerHalWrap:Lcom/mediatek/powerhalwrapper/PowerHalWrapper;

    const/4 v0, -0x2

    .line 71
    iput v0, p0, Lcom/mediatek/boostfwk/policy/frame/FrameDecision;->FRAME_MUTIL_BUFFER:I

    const/4 v0, -0x1

    .line 72
    iput v0, p0, Lcom/mediatek/boostfwk/policy/frame/FrameDecision;->FRAME_UNUSUAL:I

    const/4 v1, 0x0

    .line 73
    iput v1, p0, Lcom/mediatek/boostfwk/policy/frame/FrameDecision;->FRAME_BEGIN:I

    const/4 v2, 0x1

    .line 74
    iput v2, p0, Lcom/mediatek/boostfwk/policy/frame/FrameDecision;->FRAME_END:I

    .line 76
    iput v1, p0, Lcom/mediatek/boostfwk/policy/frame/FrameDecision;->PAGE_TYPE_HWUI:I

    .line 77
    iput v2, p0, Lcom/mediatek/boostfwk/policy/frame/FrameDecision;->PAGE_TYPE_FLUTTER:I

    const/4 v2, 0x2

    .line 78
    iput v2, p0, Lcom/mediatek/boostfwk/policy/frame/FrameDecision;->PAGE_TYPE_WEBVIEW:I

    .line 80
    iput v1, p0, Lcom/mediatek/boostfwk/policy/frame/FrameDecision;->mFrameDrawnCount:I

    .line 81
    iput v1, p0, Lcom/mediatek/boostfwk/policy/frame/FrameDecision;->mFrameRequestTraversalCount:I

    .line 82
    iput v0, p0, Lcom/mediatek/boostfwk/policy/frame/FrameDecision;->mLastHWUIDoFrameStep:I

    const-wide/16 v3, -0x1

    .line 83
    iput-wide v3, p0, Lcom/mediatek/boostfwk/policy/frame/FrameDecision;->mLastFrameBeginFrameId:J

    .line 85
    iput-boolean v1, p0, Lcom/mediatek/boostfwk/policy/frame/FrameDecision;->mEnbaleFrameTracking:Z

    .line 86
    iput-boolean v1, p0, Lcom/mediatek/boostfwk/policy/frame/FrameDecision;->mStartListenFrameHint:Z

    .line 87
    iput-boolean v1, p0, Lcom/mediatek/boostfwk/policy/frame/FrameDecision;->mForceCtrl:Z

    const/high16 v0, -0x80000000

    .line 90
    iput v0, p0, Lcom/mediatek/boostfwk/policy/frame/FrameDecision;->mRenderThreadTid:I

    .line 104
    invoke-static {}, Lcom/mediatek/boostfwk/utils/Config;->getBoostFwkVersion()I

    move-result v0

    if-le v0, v2, :cond_0

    .line 105
    invoke-static {p0}, Lcom/mediatek/boostfwk/info/ScrollState;->registerScrollStateListener(Lcom/mediatek/boostfwk/info/ScrollState$ScrollStateListener;)V

    .line 106
    invoke-static {}, Lcom/mediatek/boostfwk/info/ActivityInfo;->getInstance()Lcom/mediatek/boostfwk/info/ActivityInfo;

    move-result-object v0

    invoke-virtual {v0, p0}, Lcom/mediatek/boostfwk/info/ActivityInfo;->registerActivityListener(Lcom/mediatek/boostfwk/info/ActivityInfo$ActivityChangeListener;)V

    const/16 p0, 0x8

    .line 107
    sget-boolean v0, Lcom/mediatek/boostfwk/utils/LogUtil;->DEBUG:Z

    invoke-static {p0, v0}, Lcom/mediatek/boostfwk/info/ActivityInfo;->updateSBEMask(IZ)I

    :cond_0
    return-void
.end method

.method public static getInstance()Lcom/mediatek/boostfwk/policy/frame/FrameDecision;
    .locals 2

    .line 93
    sget-object v0, Lcom/mediatek/boostfwk/policy/frame/FrameDecision;->mInstance:Lcom/mediatek/boostfwk/policy/frame/FrameDecision;

    if-nez v0, :cond_1

    .line 94
    sget-object v0, Lcom/mediatek/boostfwk/policy/frame/FrameDecision;->LOCK:Ljava/lang/Object;

    monitor-enter v0

    .line 95
    :try_start_0
    sget-object v1, Lcom/mediatek/boostfwk/policy/frame/FrameDecision;->mInstance:Lcom/mediatek/boostfwk/policy/frame/FrameDecision;

    if-nez v1, :cond_0

    .line 96
    new-instance v1, Lcom/mediatek/boostfwk/policy/frame/FrameDecision;

    invoke-direct {v1}, Lcom/mediatek/boostfwk/policy/frame/FrameDecision;-><init>()V

    sput-object v1, Lcom/mediatek/boostfwk/policy/frame/FrameDecision;->mInstance:Lcom/mediatek/boostfwk/policy/frame/FrameDecision;

    .line 98
    :cond_0
    monitor-exit v0

    goto :goto_0

    :catchall_0
    move-exception v1

    monitor-exit v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    throw v1

    .line 100
    :cond_1
    :goto_0
    sget-object v0, Lcom/mediatek/boostfwk/policy/frame/FrameDecision;->mInstance:Lcom/mediatek/boostfwk/policy/frame/FrameDecision;

    return-object v0
.end method

.method private getRenderThreadTid()I
    .locals 2

    .line 207
    iget v0, p0, Lcom/mediatek/boostfwk/policy/frame/FrameDecision;->mRenderThreadTid:I

    const/high16 v1, -0x80000000

    if-ne v0, v1, :cond_0

    .line 208
    invoke-static {}, Lcom/mediatek/boostfwk/info/ActivityInfo;->getInstance()Lcom/mediatek/boostfwk/info/ActivityInfo;

    move-result-object v0

    invoke-virtual {v0}, Lcom/mediatek/boostfwk/info/ActivityInfo;->getRenderThreadTid()I

    move-result v0

    iput v0, p0, Lcom/mediatek/boostfwk/policy/frame/FrameDecision;->mRenderThreadTid:I

    .line 210
    :cond_0
    iget p0, p0, Lcom/mediatek/boostfwk/policy/frame/FrameDecision;->mRenderThreadTid:I

    return p0
.end method

.method private notifyFPSGoFrame(JII)V
    .locals 5

    .line 184
    iget-object v0, p0, Lcom/mediatek/boostfwk/policy/frame/FrameDecision;->mPowerHalWrap:Lcom/mediatek/powerhalwrapper/PowerHalWrapper;

    if-nez v0, :cond_0

    .line 185
    invoke-static {}, Lcom/mediatek/powerhalwrapper/PowerHalWrapper;->getInstance()Lcom/mediatek/powerhalwrapper/PowerHalWrapper;

    move-result-object v0

    iput-object v0, p0, Lcom/mediatek/boostfwk/policy/frame/FrameDecision;->mPowerHalWrap:Lcom/mediatek/powerhalwrapper/PowerHalWrapper;

    .line 187
    :cond_0
    invoke-direct {p0}, Lcom/mediatek/boostfwk/policy/frame/FrameDecision;->getRenderThreadTid()I

    move-result v0

    const/high16 v1, -0x80000000

    const-string v2, "FrameDecision"

    if-ne v0, v1, :cond_2

    .line 189
    sget-boolean p0, Lcom/mediatek/boostfwk/utils/LogUtil;->DEBUG:Z

    if-eqz p0, :cond_1

    const-string p0, "invalid renderThreadTid"

    .line 190
    invoke-static {v2, p0}, Lcom/mediatek/boostfwk/utils/LogUtil;->traceAndMLogd(Ljava/lang/String;Ljava/lang/String;)V

    :cond_1
    return-void

    :cond_2
    const-wide/16 v3, 0x0

    cmp-long v1, p1, v3

    if-gez v1, :cond_3

    .line 194
    sget-boolean v1, Lcom/mediatek/boostfwk/utils/LogUtil;->DEBUG:Z

    if-eqz v1, :cond_3

    .line 195
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "mRenderThread "

    invoke-virtual {v1, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v3, "hint for prefetch frame"

    invoke-virtual {v1, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {v2, v1}, Lcom/mediatek/boostfwk/utils/LogUtil;->traceAndMLogd(Ljava/lang/String;Ljava/lang/String;)V

    .line 197
    :cond_3
    sget-boolean v1, Lcom/mediatek/boostfwk/utils/LogUtil;->DEBUG:Z

    if-eqz v1, :cond_4

    .line 198
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "hint for frame ["

    invoke-virtual {v1, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p4}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p4, "] frameId="

    invoke-virtual {v1, p4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p1, p2}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    const-string p4, " status="

    invoke-virtual {v1, p4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p4, " renderThreadTid="

    invoke-virtual {v1, p4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p4

    invoke-static {v2, p4}, Lcom/mediatek/boostfwk/utils/LogUtil;->traceBeginAndMLogd(Ljava/lang/String;Ljava/lang/String;)V

    .line 202
    :cond_4
    iget-object p0, p0, Lcom/mediatek/boostfwk/policy/frame/FrameDecision;->mPowerHalWrap:Lcom/mediatek/powerhalwrapper/PowerHalWrapper;

    invoke-virtual {p0, v0, p3, p1, p2}, Lcom/mediatek/powerhalwrapper/PowerHalWrapper;->mtkNotifyFrame(IIJ)V

    .line 203
    invoke-static {}, Lcom/mediatek/boostfwk/utils/LogUtil;->traceEnd()V

    return-void
.end method

.method private onDoFrameBegin(J)V
    .locals 1

    .line 128
    iput-wide p1, p0, Lcom/mediatek/boostfwk/policy/frame/FrameDecision;->mLastFrameBeginFrameId:J

    const/4 v0, 0x0

    .line 129
    invoke-direct {p0, p1, p2, v0, v0}, Lcom/mediatek/boostfwk/policy/frame/FrameDecision;->notifyFPSGoFrame(JII)V

    return-void
.end method

.method private onDoFrameEnd(J)V
    .locals 4

    .line 133
    iget v0, p0, Lcom/mediatek/boostfwk/policy/frame/FrameDecision;->mLastHWUIDoFrameStep:I

    const/4 v1, -0x1

    const/4 v2, 0x0

    const/4 v3, 0x3

    if-lt v0, v3, :cond_1

    iget v0, p0, Lcom/mediatek/boostfwk/policy/frame/FrameDecision;->mFrameDrawnCount:I

    if-nez v0, :cond_0

    goto :goto_0

    .line 136
    :cond_0
    iget v3, p0, Lcom/mediatek/boostfwk/policy/frame/FrameDecision;->mFrameRequestTraversalCount:I

    if-ge v0, v3, :cond_2

    const/4 v0, 0x1

    if-le v3, v0, :cond_2

    .line 139
    invoke-direct {p0, p1, p2, v0, v2}, Lcom/mediatek/boostfwk/policy/frame/FrameDecision;->notifyFPSGoFrame(JII)V

    goto :goto_1

    .line 135
    :cond_1
    :goto_0
    invoke-direct {p0, p1, p2, v1, v2}, Lcom/mediatek/boostfwk/policy/frame/FrameDecision;->notifyFPSGoFrame(JII)V

    .line 141
    :cond_2
    :goto_1
    iput v2, p0, Lcom/mediatek/boostfwk/policy/frame/FrameDecision;->mFrameDrawnCount:I

    .line 142
    iput v1, p0, Lcom/mediatek/boostfwk/policy/frame/FrameDecision;->mLastHWUIDoFrameStep:I

    const-wide/16 p1, -0x1

    .line 143
    iput-wide p1, p0, Lcom/mediatek/boostfwk/policy/frame/FrameDecision;->mLastFrameBeginFrameId:J

    const/4 p0, 0x4

    .line 144
    invoke-static {p0, v2}, Lcom/mediatek/boostfwk/info/ActivityInfo;->updateSBEMask(IZ)I

    .line 145
    invoke-static {}, Lcom/mediatek/boostfwk/info/ActivityInfo;->clearTraversalCount()V

    return-void
.end method

.method private updateSBEMask(ZI)V
    .locals 0

    .line 254
    invoke-static {}, Lcom/mediatek/boostfwk/info/ActivityInfo;->getInstance()Lcom/mediatek/boostfwk/info/ActivityInfo;

    move-result-object p0

    invoke-virtual {p0}, Lcom/mediatek/boostfwk/info/ActivityInfo;->getThreadedRenderer()Landroid/view/ThreadedRenderer;

    move-result-object p0

    if-eqz p0, :cond_0

    .line 257
    invoke-static {p2, p1}, Lcom/mediatek/boostfwk/info/ActivityInfo;->updateSBEMask(IZ)I

    move-result p0

    .line 256
    invoke-static {p0}, Landroid/view/ThreadedRenderer;->needFrameCompleteHint(I)V

    :cond_0
    return-void
.end method


# virtual methods
.method public isEnableFrameTracking()Z
    .locals 0

    .line 250
    iget-boolean p0, p0, Lcom/mediatek/boostfwk/policy/frame/FrameDecision;->mEnbaleFrameTracking:Z

    return p0
.end method

.method public onChange(Landroid/content/Context;)V
    .locals 1

    const/4 p1, 0x1

    .line 228
    iput-boolean p1, p0, Lcom/mediatek/boostfwk/policy/frame/FrameDecision;->mStartListenFrameHint:Z

    .line 229
    invoke-static {}, Lcom/mediatek/boostfwk/utils/Config;->isFrameDecisionForAll()Z

    move-result v0

    if-eqz v0, :cond_0

    .line 230
    iput-boolean p1, p0, Lcom/mediatek/boostfwk/policy/frame/FrameDecision;->mEnbaleFrameTracking:Z

    goto :goto_0

    .line 231
    :cond_0
    invoke-static {}, Lcom/mediatek/boostfwk/utils/Config;->isDisableFrameDecision()Z

    move-result p1

    if-eqz p1, :cond_1

    const/4 p1, 0x0

    .line 232
    iput-boolean p1, p0, Lcom/mediatek/boostfwk/policy/frame/FrameDecision;->mEnbaleFrameTracking:Z

    .line 234
    :cond_1
    :goto_0
    iget-boolean p1, p0, Lcom/mediatek/boostfwk/policy/frame/FrameDecision;->mEnbaleFrameTracking:Z

    const/4 v0, 0x2

    invoke-direct {p0, p1, v0}, Lcom/mediatek/boostfwk/policy/frame/FrameDecision;->updateSBEMask(ZI)V

    const/high16 p1, -0x80000000

    .line 236
    iput p1, p0, Lcom/mediatek/boostfwk/policy/frame/FrameDecision;->mRenderThreadTid:I

    return-void
.end method

.method public onDoFrame(ZJ)V
    .locals 2

    .line 113
    sget-boolean v0, Lcom/mediatek/boostfwk/utils/LogUtil;->DEBUG:Z

    if-eqz v0, :cond_0

    .line 114
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "begin="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v1, " mEnableDecision="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-boolean v1, p0, Lcom/mediatek/boostfwk/policy/frame/FrameDecision;->mEnbaleFrameTracking:Z

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v1, " mStartListenFrameHint="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-boolean v1, p0, Lcom/mediatek/boostfwk/policy/frame/FrameDecision;->mStartListenFrameHint:Z

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    const-string v1, "FrameDecision"

    invoke-static {v1, v0}, Lcom/mediatek/boostfwk/utils/LogUtil;->traceAndMLogd(Ljava/lang/String;Ljava/lang/String;)V

    .line 117
    :cond_0
    iget-boolean v0, p0, Lcom/mediatek/boostfwk/policy/frame/FrameDecision;->mEnbaleFrameTracking:Z

    if-eqz v0, :cond_3

    iget-boolean v0, p0, Lcom/mediatek/boostfwk/policy/frame/FrameDecision;->mStartListenFrameHint:Z

    if-nez v0, :cond_1

    goto :goto_0

    :cond_1
    if-eqz p1, :cond_2

    .line 121
    invoke-direct {p0, p2, p3}, Lcom/mediatek/boostfwk/policy/frame/FrameDecision;->onDoFrameBegin(J)V

    goto :goto_0

    .line 123
    :cond_2
    invoke-direct {p0, p2, p3}, Lcom/mediatek/boostfwk/policy/frame/FrameDecision;->onDoFrameEnd(J)V

    :cond_3
    :goto_0
    return-void
.end method

.method public onDoFrameStep(ZILcom/mediatek/boostfwk/scenario/frame/FrameScenario;)V
    .locals 1

    .line 156
    iget-boolean v0, p0, Lcom/mediatek/boostfwk/policy/frame/FrameDecision;->mEnbaleFrameTracking:Z

    if-eqz v0, :cond_4

    iget-boolean v0, p0, Lcom/mediatek/boostfwk/policy/frame/FrameDecision;->mStartListenFrameHint:Z

    if-nez v0, :cond_0

    goto :goto_0

    :cond_0
    if-eqz p1, :cond_3

    const/4 p1, 0x3

    if-ne p2, p1, :cond_4

    .line 161
    invoke-virtual {p3}, Lcom/mediatek/boostfwk/scenario/frame/FrameScenario;->getTraversalCallbackCount()I

    move-result p1

    iput p1, p0, Lcom/mediatek/boostfwk/policy/frame/FrameDecision;->mFrameRequestTraversalCount:I

    .line 162
    sget-boolean p1, Lcom/mediatek/boostfwk/utils/LogUtil;->DEBUG:Z

    if-eqz p1, :cond_1

    .line 163
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string/jumbo p2, "updateSBEMask SBE_MASK_SKIP_FRAME_END_HINT"

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget p2, p0, Lcom/mediatek/boostfwk/policy/frame/FrameDecision;->mFrameRequestTraversalCount:I

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-static {p1}, Lcom/mediatek/boostfwk/utils/LogUtil;->traceBegin(Ljava/lang/String;)V

    .line 166
    :cond_1
    iget p1, p0, Lcom/mediatek/boostfwk/policy/frame/FrameDecision;->mFrameRequestTraversalCount:I

    const/4 p2, 0x1

    if-le p1, p2, :cond_2

    sub-int/2addr p1, p2

    shl-int/lit8 p1, p1, 0x10

    or-int/lit8 p1, p1, 0x4

    .line 170
    invoke-direct {p0, p2, p1}, Lcom/mediatek/boostfwk/policy/frame/FrameDecision;->updateSBEMask(ZI)V

    .line 173
    :cond_2
    invoke-static {}, Lcom/mediatek/boostfwk/utils/LogUtil;->traceEnd()V

    goto :goto_0

    .line 176
    :cond_3
    iput p2, p0, Lcom/mediatek/boostfwk/policy/frame/FrameDecision;->mLastHWUIDoFrameStep:I

    .line 177
    sget-boolean p1, Lcom/mediatek/boostfwk/utils/LogUtil;->DEBUG:Z

    if-eqz p1, :cond_4

    .line 178
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string p2, "mLastHWUIDoFrameStep="

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget p0, p0, Lcom/mediatek/boostfwk/policy/frame/FrameDecision;->mLastHWUIDoFrameStep:I

    invoke-virtual {p1, p0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    const-string p1, "FrameDecision"

    invoke-static {p1, p0}, Lcom/mediatek/boostfwk/utils/LogUtil;->traceAndMLogd(Ljava/lang/String;Ljava/lang/String;)V

    :cond_4
    :goto_0
    return-void
.end method

.method public onScroll(Z)V
    .locals 1

    .line 216
    iget-boolean v0, p0, Lcom/mediatek/boostfwk/policy/frame/FrameDecision;->mForceCtrl:Z

    if-nez v0, :cond_0

    invoke-static {}, Lcom/mediatek/boostfwk/utils/Config;->isFrameDecisionForScrolling()Z

    move-result v0

    if-eqz v0, :cond_0

    .line 217
    iput-boolean p1, p0, Lcom/mediatek/boostfwk/policy/frame/FrameDecision;->mEnbaleFrameTracking:Z

    .line 219
    invoke-static {}, Lcom/mediatek/boostfwk/utils/Config;->isEnableFrameRescue()Z

    move-result p1

    if-nez p1, :cond_0

    .line 220
    iget-boolean p1, p0, Lcom/mediatek/boostfwk/policy/frame/FrameDecision;->mEnbaleFrameTracking:Z

    const/4 v0, 0x2

    invoke-direct {p0, p1, v0}, Lcom/mediatek/boostfwk/policy/frame/FrameDecision;->updateSBEMask(ZI)V

    :cond_0
    return-void
.end method

.method public perfromDraw()V
    .locals 1

    .line 149
    iget-boolean v0, p0, Lcom/mediatek/boostfwk/policy/frame/FrameDecision;->mEnbaleFrameTracking:Z

    if-eqz v0, :cond_1

    iget-boolean v0, p0, Lcom/mediatek/boostfwk/policy/frame/FrameDecision;->mStartListenFrameHint:Z

    if-nez v0, :cond_0

    goto :goto_0

    .line 152
    :cond_0
    iget v0, p0, Lcom/mediatek/boostfwk/policy/frame/FrameDecision;->mFrameDrawnCount:I

    add-int/lit8 v0, v0, 0x1

    iput v0, p0, Lcom/mediatek/boostfwk/policy/frame/FrameDecision;->mFrameDrawnCount:I

    :cond_1
    :goto_0
    return-void
.end method

.method public setStartFrameTracking(Z)V
    .locals 1

    .line 240
    iput-boolean p1, p0, Lcom/mediatek/boostfwk/policy/frame/FrameDecision;->mForceCtrl:Z

    .line 241
    iput-boolean p1, p0, Lcom/mediatek/boostfwk/policy/frame/FrameDecision;->mEnbaleFrameTracking:Z

    const/4 v0, 0x2

    .line 242
    invoke-direct {p0, p1, v0}, Lcom/mediatek/boostfwk/policy/frame/FrameDecision;->updateSBEMask(ZI)V

    return-void
.end method

.method public setStartListenFrameHint(Z)V
    .locals 0

    .line 246
    iput-boolean p1, p0, Lcom/mediatek/boostfwk/policy/frame/FrameDecision;->mStartListenFrameHint:Z

    return-void
.end method
