.class Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher$1;
.super Ljava/lang/Object;
.source "ScrollingFramePrefetcher.java"

# interfaces
.implements Lcom/mediatek/boostfwk/info/ScrollState$RefreshRateChangedListener;


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

    .line 120
    iput-object p1, p0, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher$1;->this$0:Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public onDisplayRefreshRateChanged(IFF)V
    .locals 0

    .line 124
    iget-object p0, p0, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher$1;->this$0:Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;

    invoke-static {p0, p2, p3}, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->-$$Nest$monRefreshRateChanged(Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;FF)V

    return-void
.end method
