.class Lcom/mediatek/boostfwk/policy/frame/BaseFramePolicy$ScrollListener;
.super Ljava/lang/Object;
.source "BaseFramePolicy.java"

# interfaces
.implements Lcom/mediatek/boostfwk/info/ScrollState$ScrollStateListener;


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/mediatek/boostfwk/policy/frame/BaseFramePolicy;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x2
    name = "ScrollListener"
.end annotation


# instance fields
.field final synthetic this$0:Lcom/mediatek/boostfwk/policy/frame/BaseFramePolicy;


# direct methods
.method private constructor <init>(Lcom/mediatek/boostfwk/policy/frame/BaseFramePolicy;)V
    .locals 0

    .line 75
    iput-object p1, p0, Lcom/mediatek/boostfwk/policy/frame/BaseFramePolicy$ScrollListener;->this$0:Lcom/mediatek/boostfwk/policy/frame/BaseFramePolicy;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method synthetic constructor <init>(Lcom/mediatek/boostfwk/policy/frame/BaseFramePolicy;Lcom/mediatek/boostfwk/policy/frame/BaseFramePolicy$ScrollListener-IA;)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/mediatek/boostfwk/policy/frame/BaseFramePolicy$ScrollListener;-><init>(Lcom/mediatek/boostfwk/policy/frame/BaseFramePolicy;)V

    return-void
.end method


# virtual methods
.method public onScroll(Z)V
    .locals 0

    .line 78
    iget-object p0, p0, Lcom/mediatek/boostfwk/policy/frame/BaseFramePolicy$ScrollListener;->this$0:Lcom/mediatek/boostfwk/policy/frame/BaseFramePolicy;

    invoke-virtual {p0, p1}, Lcom/mediatek/boostfwk/policy/frame/BaseFramePolicy;->onScrollStateChange(Z)V

    return-void
.end method
