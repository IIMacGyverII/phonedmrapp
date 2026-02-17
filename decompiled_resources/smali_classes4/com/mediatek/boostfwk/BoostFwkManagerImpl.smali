.class public final Lcom/mediatek/boostfwk/BoostFwkManagerImpl;
.super Lcom/mediatek/boostfwk/BoostFwkManager;
.source "BoostFwkManagerImpl.java"


# static fields
.field private static sBoostDispatcher:Lcom/mediatek/boostfwk/BoostModuleDispatcher;

.field private static sInstance:Lcom/mediatek/boostfwk/BoostFwkManagerImpl;

.field private static sLock:Ljava/lang/Object;


# direct methods
.method static constructor <clinit>()V
    .locals 1

    .line 49
    invoke-static {}, Lcom/mediatek/boostfwk/BoostModuleDispatcher;->getInstance()Lcom/mediatek/boostfwk/BoostModuleDispatcher;

    move-result-object v0

    sput-object v0, Lcom/mediatek/boostfwk/BoostFwkManagerImpl;->sBoostDispatcher:Lcom/mediatek/boostfwk/BoostModuleDispatcher;

    .line 50
    new-instance v0, Ljava/lang/Object;

    invoke-direct {v0}, Ljava/lang/Object;-><init>()V

    sput-object v0, Lcom/mediatek/boostfwk/BoostFwkManagerImpl;->sLock:Ljava/lang/Object;

    return-void
.end method

.method public constructor <init>()V
    .locals 0

    .line 46
    invoke-direct {p0}, Lcom/mediatek/boostfwk/BoostFwkManager;-><init>()V

    return-void
.end method

.method public static getInstance()Lcom/mediatek/boostfwk/BoostFwkManagerImpl;
    .locals 2

    .line 53
    sget-object v0, Lcom/mediatek/boostfwk/BoostFwkManagerImpl;->sInstance:Lcom/mediatek/boostfwk/BoostFwkManagerImpl;

    if-nez v0, :cond_1

    .line 54
    sget-object v0, Lcom/mediatek/boostfwk/BoostFwkManagerImpl;->sLock:Ljava/lang/Object;

    monitor-enter v0

    .line 55
    :try_start_0
    sget-object v1, Lcom/mediatek/boostfwk/BoostFwkManagerImpl;->sInstance:Lcom/mediatek/boostfwk/BoostFwkManagerImpl;

    if-nez v1, :cond_0

    .line 56
    new-instance v1, Lcom/mediatek/boostfwk/BoostFwkManagerImpl;

    invoke-direct {v1}, Lcom/mediatek/boostfwk/BoostFwkManagerImpl;-><init>()V

    sput-object v1, Lcom/mediatek/boostfwk/BoostFwkManagerImpl;->sInstance:Lcom/mediatek/boostfwk/BoostFwkManagerImpl;

    .line 58
    :cond_0
    monitor-exit v0

    goto :goto_0

    :catchall_0
    move-exception v1

    monitor-exit v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    throw v1

    .line 60
    :cond_1
    :goto_0
    sget-object v0, Lcom/mediatek/boostfwk/BoostFwkManagerImpl;->sInstance:Lcom/mediatek/boostfwk/BoostFwkManagerImpl;

    return-object v0
.end method


# virtual methods
.method public perfHint(Lcom/mediatek/boostfwk/scenario/BasicScenario;)V
    .locals 0

    .line 66
    invoke-static {}, Lcom/mediatek/boostfwk/utils/Config;->disableSBE()Z

    move-result p0

    if-eqz p0, :cond_0

    return-void

    .line 69
    :cond_0
    sget-object p0, Lcom/mediatek/boostfwk/BoostFwkManagerImpl;->sBoostDispatcher:Lcom/mediatek/boostfwk/BoostModuleDispatcher;

    invoke-virtual {p0, p1}, Lcom/mediatek/boostfwk/BoostModuleDispatcher;->scenarioActionDispatcher(Lcom/mediatek/boostfwk/scenario/BasicScenario;)V

    return-void
.end method

.method public varargs perfHint([Lcom/mediatek/boostfwk/scenario/BasicScenario;)V
    .locals 3

    .line 75
    invoke-static {}, Lcom/mediatek/boostfwk/utils/Config;->disableSBE()Z

    move-result p0

    if-eqz p0, :cond_0

    return-void

    .line 79
    :cond_0
    array-length p0, p1

    const/4 v0, 0x0

    :goto_0
    if-ge v0, p0, :cond_2

    aget-object v1, p1, v0

    if-nez v1, :cond_1

    goto :goto_1

    .line 83
    :cond_1
    sget-object v2, Lcom/mediatek/boostfwk/BoostFwkManagerImpl;->sBoostDispatcher:Lcom/mediatek/boostfwk/BoostModuleDispatcher;

    invoke-virtual {v2, v1}, Lcom/mediatek/boostfwk/BoostModuleDispatcher;->scenarioActionDispatcher(Lcom/mediatek/boostfwk/scenario/BasicScenario;)V

    :goto_1
    add-int/lit8 v0, v0, 0x1

    goto :goto_0

    :cond_2
    return-void
.end method
