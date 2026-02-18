.class public final Lcom/mediatek/boostfwk/BoostModuleDispatcher;
.super Ljava/lang/Object;
.source "BoostModuleDispatcher.java"


# static fields
.field private static final SCENARIO_DIENTIFY:Landroid/util/SparseArray;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Landroid/util/SparseArray<",
            "Lcom/mediatek/boostfwk/identify/BaseIdentify;",
            ">;"
        }
    .end annotation
.end field

.field private static final TAG:Ljava/lang/String; = "BoostModuleDispatcher"

.field private static sInstance:Lcom/mediatek/boostfwk/BoostModuleDispatcher;

.field private static sLock:Ljava/lang/Object;


# direct methods
.method static constructor <clinit>()V
    .locals 1

    .line 73
    new-instance v0, Ljava/lang/Object;

    invoke-direct {v0}, Ljava/lang/Object;-><init>()V

    sput-object v0, Lcom/mediatek/boostfwk/BoostModuleDispatcher;->sLock:Ljava/lang/Object;

    .line 75
    new-instance v0, Landroid/util/SparseArray;

    invoke-direct {v0}, Landroid/util/SparseArray;-><init>()V

    sput-object v0, Lcom/mediatek/boostfwk/BoostModuleDispatcher;->SCENARIO_DIENTIFY:Landroid/util/SparseArray;

    return-void
.end method

.method public constructor <init>()V
    .locals 2

    .line 88
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 89
    invoke-static {}, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->getInstance()Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;

    move-result-object v0

    const/4 v1, 0x1

    invoke-virtual {p0, v1, v0}, Lcom/mediatek/boostfwk/BoostModuleDispatcher;->rigisterScenarioCallback(ILcom/mediatek/boostfwk/identify/BaseIdentify;)Z

    .line 90
    invoke-static {}, Lcom/mediatek/boostfwk/identify/frame/FrameIdentify;->getInstance()Lcom/mediatek/boostfwk/identify/frame/FrameIdentify;

    move-result-object v0

    const/4 v1, 0x2

    invoke-virtual {p0, v1, v0}, Lcom/mediatek/boostfwk/BoostModuleDispatcher;->rigisterScenarioCallback(ILcom/mediatek/boostfwk/identify/BaseIdentify;)Z

    .line 91
    invoke-static {}, Lcom/mediatek/boostfwk/identify/launch/LaunchIdentify;->getInstance()Lcom/mediatek/boostfwk/identify/launch/LaunchIdentify;

    move-result-object v0

    const/4 v1, 0x3

    invoke-virtual {p0, v1, v0}, Lcom/mediatek/boostfwk/BoostModuleDispatcher;->rigisterScenarioCallback(ILcom/mediatek/boostfwk/identify/BaseIdentify;)Z

    .line 92
    invoke-static {}, Lcom/mediatek/boostfwk/identify/ime/IMEIdentify;->getInstance()Lcom/mediatek/boostfwk/identify/ime/IMEIdentify;

    move-result-object v0

    const/4 v1, 0x5

    invoke-virtual {p0, v1, v0}, Lcom/mediatek/boostfwk/BoostModuleDispatcher;->rigisterScenarioCallback(ILcom/mediatek/boostfwk/identify/BaseIdentify;)Z

    .line 93
    invoke-static {}, Lcom/mediatek/boostfwk/identify/message/MsgIdentify;->getInstance()Lcom/mediatek/boostfwk/identify/message/MsgIdentify;

    move-result-object v0

    const/4 v1, 0x4

    invoke-virtual {p0, v1, v0}, Lcom/mediatek/boostfwk/BoostModuleDispatcher;->rigisterScenarioCallback(ILcom/mediatek/boostfwk/identify/BaseIdentify;)Z

    .line 94
    invoke-static {}, Lcom/mediatek/boostfwk/identify/refreshrate/RefreshRateIdentify;->getInstance()Lcom/mediatek/boostfwk/identify/refreshrate/RefreshRateIdentify;

    move-result-object v0

    const/4 v1, 0x6

    invoke-virtual {p0, v1, v0}, Lcom/mediatek/boostfwk/BoostModuleDispatcher;->rigisterScenarioCallback(ILcom/mediatek/boostfwk/identify/BaseIdentify;)Z

    .line 95
    invoke-static {}, Lcom/mediatek/boostfwk/identify/refreshrate/RefreshRateIdentify;->getInstance()Lcom/mediatek/boostfwk/identify/refreshrate/RefreshRateIdentify;

    move-result-object v0

    const/4 v1, 0x7

    invoke-virtual {p0, v1, v0}, Lcom/mediatek/boostfwk/BoostModuleDispatcher;->rigisterScenarioCallback(ILcom/mediatek/boostfwk/identify/BaseIdentify;)Z

    return-void
.end method

.method public static getInstance()Lcom/mediatek/boostfwk/BoostModuleDispatcher;
    .locals 2

    .line 78
    sget-object v0, Lcom/mediatek/boostfwk/BoostModuleDispatcher;->sInstance:Lcom/mediatek/boostfwk/BoostModuleDispatcher;

    if-nez v0, :cond_1

    .line 79
    sget-object v0, Lcom/mediatek/boostfwk/BoostModuleDispatcher;->sLock:Ljava/lang/Object;

    monitor-enter v0

    .line 80
    :try_start_0
    sget-object v1, Lcom/mediatek/boostfwk/BoostModuleDispatcher;->sInstance:Lcom/mediatek/boostfwk/BoostModuleDispatcher;

    if-nez v1, :cond_0

    .line 81
    new-instance v1, Lcom/mediatek/boostfwk/BoostModuleDispatcher;

    invoke-direct {v1}, Lcom/mediatek/boostfwk/BoostModuleDispatcher;-><init>()V

    sput-object v1, Lcom/mediatek/boostfwk/BoostModuleDispatcher;->sInstance:Lcom/mediatek/boostfwk/BoostModuleDispatcher;

    .line 83
    :cond_0
    monitor-exit v0

    goto :goto_0

    :catchall_0
    move-exception v1

    monitor-exit v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    throw v1

    .line 85
    :cond_1
    :goto_0
    sget-object v0, Lcom/mediatek/boostfwk/BoostModuleDispatcher;->sInstance:Lcom/mediatek/boostfwk/BoostModuleDispatcher;

    return-object v0
.end method


# virtual methods
.method public rigisterScenarioCallback(ILcom/mediatek/boostfwk/identify/BaseIdentify;)Z
    .locals 0

    if-eqz p2, :cond_0

    .line 120
    sget-object p0, Lcom/mediatek/boostfwk/BoostModuleDispatcher;->SCENARIO_DIENTIFY:Landroid/util/SparseArray;

    invoke-virtual {p0, p1, p2}, Landroid/util/SparseArray;->put(ILjava/lang/Object;)V

    const/4 p0, 0x1

    return p0

    :cond_0
    const/4 p0, 0x0

    return p0
.end method

.method public scenarioActionDispatcher(Lcom/mediatek/boostfwk/scenario/BasicScenario;)V
    .locals 2

    const-string p0, "BoostModuleDispatcher"

    if-nez p1, :cond_0

    const-string p1, "No scenario to dispatcher."

    .line 100
    invoke-static {p0, p1}, Lcom/mediatek/boostfwk/utils/LogUtil;->mLogw(Ljava/lang/String;Ljava/lang/String;)V

    return-void

    .line 104
    :cond_0
    invoke-virtual {p1}, Lcom/mediatek/boostfwk/scenario/BasicScenario;->getScenario()I

    move-result v0

    .line 105
    sget-object v1, Lcom/mediatek/boostfwk/BoostModuleDispatcher;->SCENARIO_DIENTIFY:Landroid/util/SparseArray;

    invoke-virtual {v1, v0}, Landroid/util/SparseArray;->get(I)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lcom/mediatek/boostfwk/identify/BaseIdentify;

    if-nez v0, :cond_1

    const-string p1, "Not found identify scenario."

    .line 107
    invoke-static {p0, p1}, Lcom/mediatek/boostfwk/utils/LogUtil;->mLogw(Ljava/lang/String;Ljava/lang/String;)V

    return-void

    .line 111
    :cond_1
    invoke-virtual {v0}, Lcom/mediatek/boostfwk/identify/BaseIdentify;->isMainThreadOnly()Z

    move-result p0

    if-eqz p0, :cond_2

    invoke-static {}, Lcom/mediatek/boostfwk/utils/Util;->isMainThread()Z

    move-result p0

    if-nez p0, :cond_2

    return-void

    .line 115
    :cond_2
    invoke-virtual {v0, p1}, Lcom/mediatek/boostfwk/identify/BaseIdentify;->dispatchScenario(Lcom/mediatek/boostfwk/scenario/BasicScenario;)Z

    return-void
.end method
