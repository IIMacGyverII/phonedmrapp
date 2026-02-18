.class public Lcom/mediatek/boostfwk/identify/ime/IMEIdentify;
.super Lcom/mediatek/boostfwk/identify/BaseIdentify;
.source "IMEIdentify.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/mediatek/boostfwk/identify/ime/IMEIdentify$IMEStateListener;
    }
.end annotation


# static fields
.field private static final LOCK:Ljava/lang/Object;

.field private static final TAG:Ljava/lang/String; = "IMEIdentify"

.field private static mInstance:Lcom/mediatek/boostfwk/identify/ime/IMEIdentify;


# instance fields
.field private mIMEStateListeners:Ljava/util/List;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/List<",
            "Lcom/mediatek/boostfwk/identify/ime/IMEIdentify$IMEStateListener;",
            ">;"
        }
    .end annotation
.end field

.field private mImeShow:Z


# direct methods
.method static constructor <clinit>()V
    .locals 1

    .line 54
    new-instance v0, Ljava/lang/Object;

    invoke-direct {v0}, Ljava/lang/Object;-><init>()V

    sput-object v0, Lcom/mediatek/boostfwk/identify/ime/IMEIdentify;->LOCK:Ljava/lang/Object;

    return-void
.end method

.method private constructor <init>()V
    .locals 1

    .line 72
    invoke-direct {p0}, Lcom/mediatek/boostfwk/identify/BaseIdentify;-><init>()V

    .line 58
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    iput-object v0, p0, Lcom/mediatek/boostfwk/identify/ime/IMEIdentify;->mIMEStateListeners:Ljava/util/List;

    const/4 v0, 0x0

    .line 59
    iput-boolean v0, p0, Lcom/mediatek/boostfwk/identify/ime/IMEIdentify;->mImeShow:Z

    return-void
.end method

.method public static getInstance()Lcom/mediatek/boostfwk/identify/ime/IMEIdentify;
    .locals 2

    .line 62
    sget-object v0, Lcom/mediatek/boostfwk/identify/ime/IMEIdentify;->mInstance:Lcom/mediatek/boostfwk/identify/ime/IMEIdentify;

    if-nez v0, :cond_1

    .line 63
    sget-object v0, Lcom/mediatek/boostfwk/identify/ime/IMEIdentify;->LOCK:Ljava/lang/Object;

    monitor-enter v0

    .line 64
    :try_start_0
    sget-object v1, Lcom/mediatek/boostfwk/identify/ime/IMEIdentify;->mInstance:Lcom/mediatek/boostfwk/identify/ime/IMEIdentify;

    if-nez v1, :cond_0

    .line 65
    new-instance v1, Lcom/mediatek/boostfwk/identify/ime/IMEIdentify;

    invoke-direct {v1}, Lcom/mediatek/boostfwk/identify/ime/IMEIdentify;-><init>()V

    sput-object v1, Lcom/mediatek/boostfwk/identify/ime/IMEIdentify;->mInstance:Lcom/mediatek/boostfwk/identify/ime/IMEIdentify;

    .line 67
    :cond_0
    monitor-exit v0

    goto :goto_0

    :catchall_0
    move-exception v1

    monitor-exit v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    throw v1

    .line 69
    :cond_1
    :goto_0
    sget-object v0, Lcom/mediatek/boostfwk/identify/ime/IMEIdentify;->mInstance:Lcom/mediatek/boostfwk/identify/ime/IMEIdentify;

    return-object v0
.end method

.method private notifyIMEInit(Landroid/view/Window;)V
    .locals 1

    if-eqz p1, :cond_0

    .line 113
    iget-object p0, p0, Lcom/mediatek/boostfwk/identify/ime/IMEIdentify;->mIMEStateListeners:Ljava/util/List;

    invoke-interface {p0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object p0

    :goto_0
    invoke-interface {p0}, Ljava/util/Iterator;->hasNext()Z

    move-result v0

    if-eqz v0, :cond_0

    invoke-interface {p0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lcom/mediatek/boostfwk/identify/ime/IMEIdentify$IMEStateListener;

    .line 114
    invoke-interface {v0, p1}, Lcom/mediatek/boostfwk/identify/ime/IMEIdentify$IMEStateListener;->onInit(Landroid/view/Window;)V

    goto :goto_0

    :cond_0
    return-void
.end method

.method private notifyVisibilityChange(Z)V
    .locals 1

    .line 120
    iget-boolean v0, p0, Lcom/mediatek/boostfwk/identify/ime/IMEIdentify;->mImeShow:Z

    if-ne v0, p1, :cond_0

    return-void

    .line 123
    :cond_0
    iput-boolean p1, p0, Lcom/mediatek/boostfwk/identify/ime/IMEIdentify;->mImeShow:Z

    .line 124
    iget-object p0, p0, Lcom/mediatek/boostfwk/identify/ime/IMEIdentify;->mIMEStateListeners:Ljava/util/List;

    invoke-interface {p0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object p0

    :goto_0
    invoke-interface {p0}, Ljava/util/Iterator;->hasNext()Z

    move-result v0

    if-eqz v0, :cond_1

    invoke-interface {p0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lcom/mediatek/boostfwk/identify/ime/IMEIdentify$IMEStateListener;

    .line 125
    invoke-interface {v0, p1}, Lcom/mediatek/boostfwk/identify/ime/IMEIdentify$IMEStateListener;->onVisibilityChange(Z)V

    goto :goto_0

    :cond_1
    return-void
.end method


# virtual methods
.method public dispatchScenario(Lcom/mediatek/boostfwk/scenario/BasicScenario;)Z
    .locals 4

    const/4 v0, 0x0

    if-nez p1, :cond_0

    return v0

    .line 90
    :cond_0
    check-cast p1, Lcom/mediatek/boostfwk/scenario/ime/IMEScenario;

    .line 91
    invoke-virtual {p1}, Lcom/mediatek/boostfwk/scenario/ime/IMEScenario;->getScenarioAction()I

    move-result v1

    const/4 v2, 0x1

    if-eq v1, v2, :cond_3

    const/4 v3, 0x2

    if-eq v1, v3, :cond_2

    const/4 v0, 0x3

    if-eq v1, v0, :cond_1

    .line 103
    invoke-static {}, Lcom/mediatek/boostfwk/utils/Config;->isBoostFwkLogEnable()Z

    move-result p0

    if-eqz p0, :cond_4

    const-string p0, "IMEIdentify"

    const-string p1, "not support scnario action"

    .line 104
    invoke-static {p0, p1}, Lcom/mediatek/boostfwk/utils/LogUtil;->mLogd(Ljava/lang/String;Ljava/lang/String;)V

    goto :goto_0

    .line 100
    :cond_1
    invoke-virtual {p1}, Lcom/mediatek/boostfwk/scenario/ime/IMEScenario;->getWindowAndClear()Landroid/view/Window;

    move-result-object p1

    invoke-direct {p0, p1}, Lcom/mediatek/boostfwk/identify/ime/IMEIdentify;->notifyIMEInit(Landroid/view/Window;)V

    goto :goto_0

    .line 97
    :cond_2
    invoke-direct {p0, v0}, Lcom/mediatek/boostfwk/identify/ime/IMEIdentify;->notifyVisibilityChange(Z)V

    goto :goto_0

    .line 94
    :cond_3
    invoke-direct {p0, v2}, Lcom/mediatek/boostfwk/identify/ime/IMEIdentify;->notifyVisibilityChange(Z)V

    :cond_4
    :goto_0
    return v2
.end method

.method public isMainThreadOnly()Z
    .locals 0

    const/4 p0, 0x0

    return p0
.end method

.method public registerIMEStateListener(Lcom/mediatek/boostfwk/identify/ime/IMEIdentify$IMEStateListener;)V
    .locals 0

    if-nez p1, :cond_0

    return-void

    .line 133
    :cond_0
    iget-object p0, p0, Lcom/mediatek/boostfwk/identify/ime/IMEIdentify;->mIMEStateListeners:Ljava/util/List;

    invoke-interface {p0, p1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    return-void
.end method
