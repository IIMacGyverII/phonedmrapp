.class public Lcom/mediatek/boostfwk/identify/refreshrate/RefreshRateIdentify;
.super Lcom/mediatek/boostfwk/identify/BaseIdentify;
.source "RefreshRateIdentify.java"

# interfaces
.implements Lcom/mediatek/boostfwk/identify/ime/IMEIdentify$IMEStateListener;
.implements Lcom/mediatek/boostfwk/identify/message/MsgIdentify$AudioStateListener;
.implements Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify$TouchEventListener;


# static fields
.field private static final TAG:Ljava/lang/String; = "MSYNC3-VariableRefreshRate"

.field private static lock:Ljava/lang/Object;

.field private static sInstance:Lcom/mediatek/boostfwk/identify/refreshrate/RefreshRateIdentify;


# instance fields
.field private activityInfo:Lcom/mediatek/boostfwk/info/ActivityInfo;

.field private mIsConfigInited:Z

.field private mIsSmoothFlingEnabled:Z

.field private mIsVeriableRefreshRateSupported:Z

.field private mPackageName:Ljava/lang/String;

.field private mRefreshRatePolicy:Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;


# direct methods
.method static constructor <clinit>()V
    .locals 1

    .line 67
    new-instance v0, Ljava/lang/Object;

    invoke-direct {v0}, Ljava/lang/Object;-><init>()V

    sput-object v0, Lcom/mediatek/boostfwk/identify/refreshrate/RefreshRateIdentify;->lock:Ljava/lang/Object;

    return-void
.end method

.method private constructor <init>()V
    .locals 2

    .line 87
    invoke-direct {p0}, Lcom/mediatek/boostfwk/identify/BaseIdentify;-><init>()V

    const/4 v0, 0x0

    .line 68
    iput-object v0, p0, Lcom/mediatek/boostfwk/identify/refreshrate/RefreshRateIdentify;->activityInfo:Lcom/mediatek/boostfwk/info/ActivityInfo;

    const/4 v1, 0x0

    .line 71
    iput-boolean v1, p0, Lcom/mediatek/boostfwk/identify/refreshrate/RefreshRateIdentify;->mIsVeriableRefreshRateSupported:Z

    .line 72
    iput-boolean v1, p0, Lcom/mediatek/boostfwk/identify/refreshrate/RefreshRateIdentify;->mIsConfigInited:Z

    .line 73
    iput-boolean v1, p0, Lcom/mediatek/boostfwk/identify/refreshrate/RefreshRateIdentify;->mIsSmoothFlingEnabled:Z

    .line 74
    iput-object v0, p0, Lcom/mediatek/boostfwk/identify/refreshrate/RefreshRateIdentify;->mPackageName:Ljava/lang/String;

    .line 88
    invoke-static {}, Lcom/mediatek/boostfwk/utils/Config;->isVariableRefreshRateSupported()Z

    move-result v0

    iput-boolean v0, p0, Lcom/mediatek/boostfwk/identify/refreshrate/RefreshRateIdentify;->mIsVeriableRefreshRateSupported:Z

    .line 89
    invoke-static {}, Lcom/mediatek/boostfwk/utils/Config;->isMSync3SmoothFlingEnabled()Z

    move-result v0

    iput-boolean v0, p0, Lcom/mediatek/boostfwk/identify/refreshrate/RefreshRateIdentify;->mIsSmoothFlingEnabled:Z

    .line 91
    iget-boolean v0, p0, Lcom/mediatek/boostfwk/identify/refreshrate/RefreshRateIdentify;->mIsVeriableRefreshRateSupported:Z

    const-string v1, "MSYNC3-VariableRefreshRate"

    if-eqz v0, :cond_0

    const-string v0, "Variable refreshrate is enabled"

    .line 92
    invoke-static {v1, v0}, Lcom/mediatek/boostfwk/utils/LogUtil;->mLogi(Ljava/lang/String;Ljava/lang/String;)V

    .line 93
    new-instance v0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;

    invoke-direct {v0}, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;-><init>()V

    iput-object v0, p0, Lcom/mediatek/boostfwk/identify/refreshrate/RefreshRateIdentify;->mRefreshRatePolicy:Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;

    .line 94
    invoke-static {}, Lcom/mediatek/boostfwk/identify/ime/IMEIdentify;->getInstance()Lcom/mediatek/boostfwk/identify/ime/IMEIdentify;

    move-result-object v0

    invoke-virtual {v0, p0}, Lcom/mediatek/boostfwk/identify/ime/IMEIdentify;->registerIMEStateListener(Lcom/mediatek/boostfwk/identify/ime/IMEIdentify$IMEStateListener;)V

    .line 95
    invoke-static {}, Lcom/mediatek/boostfwk/identify/message/MsgIdentify;->getInstance()Lcom/mediatek/boostfwk/identify/message/MsgIdentify;

    move-result-object v0

    invoke-virtual {v0, p0}, Lcom/mediatek/boostfwk/identify/message/MsgIdentify;->registerAudioStateListener(Lcom/mediatek/boostfwk/identify/message/MsgIdentify$AudioStateListener;)V

    .line 96
    invoke-static {}, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->getInstance()Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;

    move-result-object v0

    invoke-virtual {v0, p0}, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->registerTouchEventListener(Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify$TouchEventListener;)V

    goto :goto_0

    :cond_0
    const-string p0, "Variable refreshrate is disabled"

    .line 98
    invoke-static {v1, p0}, Lcom/mediatek/boostfwk/utils/LogUtil;->mLogi(Ljava/lang/String;Ljava/lang/String;)V

    :goto_0
    return-void
.end method

.method private configInit(Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;)V
    .locals 3

    if-eqz p1, :cond_5

    .line 105
    invoke-virtual {p1}, Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;->getScenarioContext()Landroid/content/Context;

    move-result-object v0

    const/4 v1, 0x0

    if-eqz v0, :cond_4

    .line 106
    invoke-virtual {p1}, Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;->getScenarioContext()Landroid/content/Context;

    move-result-object p1

    .line 113
    invoke-static {}, Lcom/mediatek/boostfwk/info/ActivityInfo;->getInstance()Lcom/mediatek/boostfwk/info/ActivityInfo;

    move-result-object v0

    invoke-virtual {v0}, Lcom/mediatek/boostfwk/info/ActivityInfo;->getPackageName()Ljava/lang/String;

    move-result-object v0

    iput-object v0, p0, Lcom/mediatek/boostfwk/identify/refreshrate/RefreshRateIdentify;->mPackageName:Ljava/lang/String;

    if-nez v0, :cond_0

    .line 115
    invoke-virtual {p1}, Landroid/content/Context;->getPackageName()Ljava/lang/String;

    move-result-object p1

    iput-object p1, p0, Lcom/mediatek/boostfwk/identify/refreshrate/RefreshRateIdentify;->mPackageName:Ljava/lang/String;

    .line 119
    :cond_0
    iget-object p1, p0, Lcom/mediatek/boostfwk/identify/refreshrate/RefreshRateIdentify;->mPackageName:Ljava/lang/String;

    const-string v0, "MSYNC3-VariableRefreshRate"

    if-eqz p1, :cond_1

    sget-object v2, Lcom/mediatek/boostfwk/utils/Config;->SYSTEM_PACKAGE_ARRAY:Ljava/util/ArrayList;

    .line 120
    invoke-virtual {v2, p1}, Ljava/util/ArrayList;->contains(Ljava/lang/Object;)Z

    move-result p1

    if-eqz p1, :cond_2

    .line 121
    :cond_1
    iput-boolean v1, p0, Lcom/mediatek/boostfwk/identify/refreshrate/RefreshRateIdentify;->mIsVeriableRefreshRateSupported:Z

    .line 122
    iget-object p1, p0, Lcom/mediatek/boostfwk/identify/refreshrate/RefreshRateIdentify;->mRefreshRatePolicy:Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;

    invoke-virtual {p1, v1}, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->setVeriableRefreshRateSupported(Z)V

    const-string p1, "App is not support"

    .line 123
    invoke-static {v0, p1}, Lcom/mediatek/boostfwk/utils/LogUtil;->mLogi(Ljava/lang/String;Ljava/lang/String;)V

    .line 127
    :cond_2
    iget-boolean p1, p0, Lcom/mediatek/boostfwk/identify/refreshrate/RefreshRateIdentify;->mIsVeriableRefreshRateSupported:Z

    if-eqz p1, :cond_3

    iget-object p1, p0, Lcom/mediatek/boostfwk/identify/refreshrate/RefreshRateIdentify;->mPackageName:Ljava/lang/String;

    invoke-static {p1}, Lcom/mediatek/boostfwk/utils/TasksUtil;->isGameAPP(Ljava/lang/String;)Z

    move-result p1

    if-eqz p1, :cond_3

    .line 128
    iput-boolean v1, p0, Lcom/mediatek/boostfwk/identify/refreshrate/RefreshRateIdentify;->mIsVeriableRefreshRateSupported:Z

    .line 129
    iget-object p1, p0, Lcom/mediatek/boostfwk/identify/refreshrate/RefreshRateIdentify;->mRefreshRatePolicy:Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;

    invoke-virtual {p1, v1}, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->setVeriableRefreshRateSupported(Z)V

    const-string p1, "Game is not support"

    .line 130
    invoke-static {v0, p1}, Lcom/mediatek/boostfwk/utils/LogUtil;->mLogi(Ljava/lang/String;Ljava/lang/String;)V

    :cond_3
    const/4 p1, 0x1

    .line 133
    iput-boolean p1, p0, Lcom/mediatek/boostfwk/identify/refreshrate/RefreshRateIdentify;->mIsConfigInited:Z

    goto :goto_0

    .line 108
    :cond_4
    iput-boolean v1, p0, Lcom/mediatek/boostfwk/identify/refreshrate/RefreshRateIdentify;->mIsConfigInited:Z

    :cond_5
    :goto_0
    return-void
.end method

.method public static getInstance()Lcom/mediatek/boostfwk/identify/refreshrate/RefreshRateIdentify;
    .locals 2

    .line 77
    sget-object v0, Lcom/mediatek/boostfwk/identify/refreshrate/RefreshRateIdentify;->sInstance:Lcom/mediatek/boostfwk/identify/refreshrate/RefreshRateIdentify;

    if-nez v0, :cond_1

    .line 78
    sget-object v0, Lcom/mediatek/boostfwk/identify/refreshrate/RefreshRateIdentify;->lock:Ljava/lang/Object;

    monitor-enter v0

    .line 79
    :try_start_0
    sget-object v1, Lcom/mediatek/boostfwk/identify/refreshrate/RefreshRateIdentify;->sInstance:Lcom/mediatek/boostfwk/identify/refreshrate/RefreshRateIdentify;

    if-nez v1, :cond_0

    .line 80
    new-instance v1, Lcom/mediatek/boostfwk/identify/refreshrate/RefreshRateIdentify;

    invoke-direct {v1}, Lcom/mediatek/boostfwk/identify/refreshrate/RefreshRateIdentify;-><init>()V

    sput-object v1, Lcom/mediatek/boostfwk/identify/refreshrate/RefreshRateIdentify;->sInstance:Lcom/mediatek/boostfwk/identify/refreshrate/RefreshRateIdentify;

    .line 82
    :cond_0
    monitor-exit v0

    goto :goto_0

    :catchall_0
    move-exception v1

    monitor-exit v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    throw v1

    .line 84
    :cond_1
    :goto_0
    sget-object v0, Lcom/mediatek/boostfwk/identify/refreshrate/RefreshRateIdentify;->sInstance:Lcom/mediatek/boostfwk/identify/refreshrate/RefreshRateIdentify;

    return-object v0
.end method


# virtual methods
.method public dispatchScenario(Lcom/mediatek/boostfwk/scenario/BasicScenario;)Z
    .locals 3

    .line 139
    iget-boolean v0, p0, Lcom/mediatek/boostfwk/identify/refreshrate/RefreshRateIdentify;->mIsVeriableRefreshRateSupported:Z

    if-eqz v0, :cond_3

    const-string v0, "Dispatch refresh rate scenario"

    .line 140
    invoke-static {v0}, Lcom/mediatek/boostfwk/utils/LogUtil;->traceBegin(Ljava/lang/String;)V

    if-eqz p1, :cond_2

    .line 143
    invoke-virtual {p1}, Lcom/mediatek/boostfwk/scenario/BasicScenario;->getScenario()I

    move-result v0

    const/4 v1, 0x6

    const/4 v2, 0x1

    if-ne v0, v1, :cond_1

    .line 144
    check-cast p1, Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;

    .line 146
    iget-boolean v0, p0, Lcom/mediatek/boostfwk/identify/refreshrate/RefreshRateIdentify;->mIsConfigInited:Z

    if-nez v0, :cond_0

    .line 147
    invoke-direct {p0, p1}, Lcom/mediatek/boostfwk/identify/refreshrate/RefreshRateIdentify;->configInit(Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;)V

    .line 150
    :cond_0
    invoke-virtual {p1}, Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;->getScenarioContext()Landroid/content/Context;

    move-result-object v0

    if-eqz v0, :cond_2

    .line 151
    instance-of v0, v0, Landroid/app/Activity;

    if-eqz v0, :cond_2

    .line 152
    iget-object p0, p0, Lcom/mediatek/boostfwk/identify/refreshrate/RefreshRateIdentify;->mRefreshRatePolicy:Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;

    invoke-virtual {p0, p1}, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->dispatchScenario(Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;)V

    .line 153
    invoke-static {}, Lcom/mediatek/boostfwk/utils/LogUtil;->traceEnd()V

    return v2

    .line 156
    :cond_1
    invoke-virtual {p1}, Lcom/mediatek/boostfwk/scenario/BasicScenario;->getScenario()I

    move-result v0

    const/4 v1, 0x7

    if-ne v0, v1, :cond_2

    .line 157
    check-cast p1, Lcom/mediatek/boostfwk/scenario/refreshrate/EventScenario;

    .line 158
    iget-object p0, p0, Lcom/mediatek/boostfwk/identify/refreshrate/RefreshRateIdentify;->mRefreshRatePolicy:Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;

    invoke-virtual {p0, p1}, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->dispatchEvent(Lcom/mediatek/boostfwk/scenario/refreshrate/EventScenario;)V

    .line 159
    invoke-static {}, Lcom/mediatek/boostfwk/utils/LogUtil;->traceEnd()V

    return v2

    .line 164
    :cond_2
    invoke-static {}, Lcom/mediatek/boostfwk/utils/LogUtil;->traceEnd()V

    :cond_3
    const/4 p0, 0x0

    return p0
.end method

.method public onAudioMsgStatusUpdate(Z)V
    .locals 1

    .line 192
    iget-boolean v0, p0, Lcom/mediatek/boostfwk/identify/refreshrate/RefreshRateIdentify;->mIsVeriableRefreshRateSupported:Z

    if-eqz v0, :cond_0

    .line 193
    iget-object p0, p0, Lcom/mediatek/boostfwk/identify/refreshrate/RefreshRateIdentify;->mRefreshRatePolicy:Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;

    invoke-virtual {p0, p1}, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->onVoiceDialogEvent(Z)V

    :cond_0
    return-void
.end method

.method public onInit(Landroid/view/Window;)V
    .locals 1

    .line 178
    iget-boolean v0, p0, Lcom/mediatek/boostfwk/identify/refreshrate/RefreshRateIdentify;->mIsVeriableRefreshRateSupported:Z

    if-eqz v0, :cond_0

    .line 179
    iget-object p0, p0, Lcom/mediatek/boostfwk/identify/refreshrate/RefreshRateIdentify;->mRefreshRatePolicy:Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;

    invoke-virtual {p0, p1}, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->onIMEInit(Landroid/view/Window;)V

    :cond_0
    return-void
.end method

.method public onTouchEvent(Landroid/view/MotionEvent;)V
    .locals 1

    .line 171
    iget-boolean v0, p0, Lcom/mediatek/boostfwk/identify/refreshrate/RefreshRateIdentify;->mIsVeriableRefreshRateSupported:Z

    if-eqz v0, :cond_0

    .line 172
    iget-object p0, p0, Lcom/mediatek/boostfwk/identify/refreshrate/RefreshRateIdentify;->mRefreshRatePolicy:Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;

    invoke-virtual {p0, p1}, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->onTouchEvent(Landroid/view/MotionEvent;)V

    :cond_0
    return-void
.end method

.method public onVisibilityChange(Z)V
    .locals 1

    .line 185
    iget-boolean v0, p0, Lcom/mediatek/boostfwk/identify/refreshrate/RefreshRateIdentify;->mIsVeriableRefreshRateSupported:Z

    if-eqz v0, :cond_0

    .line 186
    iget-object p0, p0, Lcom/mediatek/boostfwk/identify/refreshrate/RefreshRateIdentify;->mRefreshRatePolicy:Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;

    invoke-virtual {p0, p1}, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->onIMEVisibilityChange(Z)V

    :cond_0
    return-void
.end method
