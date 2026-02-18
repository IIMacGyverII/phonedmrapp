.class Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher$3;
.super Ljava/lang/Object;
.source "ScrollingFramePrefetcher.java"

# interfaces
.implements Lcom/mediatek/boostfwk/info/ScrollState$ScrollStateListener;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;-><init>()V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;


# direct methods
.method constructor <init>(Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;)V
    .locals 0

    .line 134
    iput-object p1, p0, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher$3;->this$0:Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public onScroll(Z)V
    .locals 1

    .line 137
    sget-boolean v0, Lcom/mediatek/boostfwk/utils/Config;->mIncreaseBuffer:Z

    if-eqz v0, :cond_0

    .line 138
    invoke-static {}, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->getInstance()Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;

    move-result-object v0

    iget-object p0, p0, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher$3;->this$0:Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;

    invoke-static {p0}, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->-$$Nest$fgetmActivityInfo(Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;)Lcom/mediatek/boostfwk/info/ActivityInfo;

    move-result-object p0

    invoke-virtual {p0}, Lcom/mediatek/boostfwk/info/ActivityInfo;->getThreadedRenderer()Landroid/view/ThreadedRenderer;

    move-result-object p0

    invoke-static {v0, p0, p1}, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->-$$Nest$msetBufferSize(Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;Landroid/view/ThreadedRenderer;Z)V

    :cond_0
    return-void
.end method
