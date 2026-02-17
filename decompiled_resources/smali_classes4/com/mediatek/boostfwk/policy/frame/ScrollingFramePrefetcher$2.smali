.class Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher$2;
.super Ljava/lang/Object;
.source "ScrollingFramePrefetcher.java"

# interfaces
.implements Lcom/mediatek/boostfwk/info/ActivityInfo$ActivityChangeListener;


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

    .line 127
    iput-object p1, p0, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher$2;->this$0:Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public onChange(Landroid/content/Context;)V
    .locals 0

    .line 131
    iget-object p0, p0, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher$2;->this$0:Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;

    invoke-static {p0}, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->-$$Nest$mresetStatusWhenScroll(Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;)V

    return-void
.end method
