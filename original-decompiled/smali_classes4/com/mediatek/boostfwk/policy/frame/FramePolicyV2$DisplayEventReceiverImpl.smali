.class Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2$DisplayEventReceiverImpl;
.super Landroid/view/DisplayEventReceiver;
.source "FramePolicyV2.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0xa
    name = "DisplayEventReceiverImpl"
.end annotation


# direct methods
.method public constructor <init>(Landroid/os/Looper;I)V
    .locals 1

    const/4 v0, 0x0

    .line 696
    invoke-direct {p0, p1, p2, v0}, Landroid/view/DisplayEventReceiver;-><init>(Landroid/os/Looper;II)V

    return-void
.end method


# virtual methods
.method public onVsync(JJILandroid/view/DisplayEventReceiver$VsyncEventData;)V
    .locals 0

    .line 702
    invoke-static {}, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->-$$Nest$sfgetmInstance()Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;

    move-result-object p0

    if-eqz p0, :cond_0

    .line 703
    invoke-static {}, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->-$$Nest$sfgetmInstance()Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;

    move-result-object p0

    invoke-virtual {p6}, Landroid/view/DisplayEventReceiver$VsyncEventData;->preferredFrameTimeline()Landroid/view/DisplayEventReceiver$VsyncEventData$FrameTimeline;

    move-result-object p1

    iget-wide p1, p1, Landroid/view/DisplayEventReceiver$VsyncEventData$FrameTimeline;->vsyncId:J

    invoke-static {p0, p1, p2}, Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;->-$$Nest$monVsyncInternal(Lcom/mediatek/boostfwk/policy/frame/FramePolicyV2;J)V

    :cond_0
    return-void
.end method
