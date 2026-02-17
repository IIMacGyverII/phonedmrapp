.class Lcom/mediatek/res/AsyncDrawableCache$2;
.super Ljava/util/TimerTask;
.source "AsyncDrawableCache.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/mediatek/res/AsyncDrawableCache;->clearCacheAfterPreload()V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/mediatek/res/AsyncDrawableCache;


# direct methods
.method constructor <init>(Lcom/mediatek/res/AsyncDrawableCache;)V
    .locals 0

    .line 298
    iput-object p1, p0, Lcom/mediatek/res/AsyncDrawableCache$2;->this$0:Lcom/mediatek/res/AsyncDrawableCache;

    invoke-direct {p0}, Ljava/util/TimerTask;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .locals 0

    .line 301
    iget-object p0, p0, Lcom/mediatek/res/AsyncDrawableCache$2;->this$0:Lcom/mediatek/res/AsyncDrawableCache;

    invoke-static {p0}, Lcom/mediatek/res/AsyncDrawableCache;->-$$Nest$mclearCache(Lcom/mediatek/res/AsyncDrawableCache;)V

    const/4 p0, 0x0

    .line 302
    invoke-static {p0}, Lcom/mediatek/res/AsyncDrawableCache;->-$$Nest$sfputisPreloaded(Z)V

    return-void
.end method
