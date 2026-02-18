.class Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy$1;
.super Ljava/lang/Object;
.source "ScrollPolicy.java"

# interfaces
.implements Lcom/mediatek/boostfwk/identify/ime/IMEIdentify$IMEStateListener;


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;


# direct methods
.method constructor <init>(Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;)V
    .locals 0

    .line 151
    iput-object p1, p0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy$1;->this$0:Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public onInit(Landroid/view/Window;)V
    .locals 0

    return-void
.end method

.method public onVisibilityChange(Z)V
    .locals 1

    .line 158
    iget-object v0, p0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy$1;->this$0:Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;

    invoke-static {v0, p1}, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->-$$Nest$fputmDisableScrollPolicy(Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;Z)V

    if-eqz p1, :cond_2

    .line 159
    invoke-static {}, Lcom/mediatek/boostfwk/info/ScrollState;->isScrolling()Z

    move-result p1

    if-eqz p1, :cond_2

    const/4 p1, 0x0

    const-string v0, "ime show"

    .line 160
    invoke-static {p1, v0}, Lcom/mediatek/boostfwk/info/ScrollState;->setScrolling(ZLjava/lang/String;)V

    .line 161
    sget-boolean v0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->useFPSGo:Z

    if-eqz v0, :cond_0

    .line 162
    sput-boolean p1, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->useFPSGo:Z

    .line 164
    :cond_0
    invoke-static {}, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->-$$Nest$sfgetmPolicyExeCount()I

    move-result p1

    if-lez p1, :cond_1

    .line 165
    iget-object p1, p0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy$1;->this$0:Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;

    invoke-static {p1}, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->-$$Nest$fgetmWorkerHandler(Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;)Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy$WorkerHandler;

    move-result-object p1

    const/4 v0, 0x6

    invoke-virtual {p1, v0}, Landroid/os/Handler;->sendEmptyMessage(I)Z

    .line 167
    :cond_1
    invoke-static {}, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->-$$Nest$sfgetmFlingPolicyExeCount()I

    move-result p1

    if-lez p1, :cond_2

    .line 168
    iget-object p0, p0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy$1;->this$0:Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;

    invoke-static {p0}, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->-$$Nest$fgetmWorkerHandler(Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;)Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy$WorkerHandler;

    move-result-object p0

    const/16 p1, 0x9

    invoke-virtual {p0, p1}, Landroid/os/Handler;->sendEmptyMessage(I)Z

    :cond_2
    return-void
.end method
