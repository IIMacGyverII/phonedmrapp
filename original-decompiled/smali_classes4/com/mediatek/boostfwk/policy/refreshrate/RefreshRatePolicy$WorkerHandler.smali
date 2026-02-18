.class Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy$WorkerHandler;
.super Landroid/os/Handler;
.source "RefreshRatePolicy.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = "WorkerHandler"
.end annotation


# instance fields
.field final synthetic this$0:Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;


# direct methods
.method constructor <init>(Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;Landroid/os/Looper;)V
    .locals 0

    .line 205
    iput-object p1, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy$WorkerHandler;->this$0:Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;

    .line 206
    invoke-direct {p0, p2}, Landroid/os/Handler;-><init>(Landroid/os/Looper;)V

    return-void
.end method


# virtual methods
.method public handleMessage(Landroid/os/Message;)V
    .locals 1

    .line 211
    iget p1, p1, Landroid/os/Message;->what:I

    if-eqz p1, :cond_0

    goto :goto_0

    .line 213
    :cond_0
    iget-object p1, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy$WorkerHandler;->this$0:Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;

    invoke-static {p1}, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->-$$Nest$fgetmActiveRefreshScenario(Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;)Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;

    move-result-object p1

    if-eqz p1, :cond_1

    .line 214
    iget-object p0, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy$WorkerHandler;->this$0:Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;

    const/16 p1, 0x3e8

    invoke-static {p0}, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->-$$Nest$fgetmActiveRefreshScenario(Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;)Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;

    move-result-object v0

    invoke-static {p0, p1, v0}, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->-$$Nest$mupdateRefreshRateWhenFling(Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;ILcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;)V

    :cond_1
    :goto_0
    return-void
.end method
