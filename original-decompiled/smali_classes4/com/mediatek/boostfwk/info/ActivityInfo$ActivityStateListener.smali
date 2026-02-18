.class public Lcom/mediatek/boostfwk/info/ActivityInfo$ActivityStateListener;
.super Ljava/lang/Object;
.source "ActivityInfo.java"

# interfaces
.implements Landroid/app/Application$ActivityLifecycleCallbacks;


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/mediatek/boostfwk/info/ActivityInfo;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x1
    name = "ActivityStateListener"
.end annotation


# instance fields
.field final synthetic this$0:Lcom/mediatek/boostfwk/info/ActivityInfo;


# direct methods
.method public constructor <init>(Lcom/mediatek/boostfwk/info/ActivityInfo;)V
    .locals 0

    .line 235
    iput-object p1, p0, Lcom/mediatek/boostfwk/info/ActivityInfo$ActivityStateListener;->this$0:Lcom/mediatek/boostfwk/info/ActivityInfo;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public onActivityCreated(Landroid/app/Activity;Landroid/os/Bundle;)V
    .locals 0

    return-void
.end method

.method public onActivityDestroyed(Landroid/app/Activity;)V
    .locals 0

    return-void
.end method

.method public onActivityPaused(Landroid/app/Activity;)V
    .locals 2

    .line 258
    iget-object v0, p0, Lcom/mediatek/boostfwk/info/ActivityInfo$ActivityStateListener;->this$0:Lcom/mediatek/boostfwk/info/ActivityInfo;

    invoke-static {v0}, Lcom/mediatek/boostfwk/info/ActivityInfo;->-$$Nest$fgetmActivityCount(Lcom/mediatek/boostfwk/info/ActivityInfo;)I

    move-result v1

    add-int/lit8 v1, v1, -0x1

    invoke-static {v0, v1}, Lcom/mediatek/boostfwk/info/ActivityInfo;->-$$Nest$fputmActivityCount(Lcom/mediatek/boostfwk/info/ActivityInfo;I)V

    if-nez v1, :cond_0

    .line 259
    iget-object p0, p0, Lcom/mediatek/boostfwk/info/ActivityInfo$ActivityStateListener;->this$0:Lcom/mediatek/boostfwk/info/ActivityInfo;

    invoke-static {p0, p1}, Lcom/mediatek/boostfwk/info/ActivityInfo;->-$$Nest$mnotifyAllActivityPause(Lcom/mediatek/boostfwk/info/ActivityInfo;Landroid/content/Context;)V

    :cond_0
    return-void
.end method

.method public onActivityResumed(Landroid/app/Activity;)V
    .locals 0

    .line 253
    iget-object p0, p0, Lcom/mediatek/boostfwk/info/ActivityInfo$ActivityStateListener;->this$0:Lcom/mediatek/boostfwk/info/ActivityInfo;

    invoke-static {p0}, Lcom/mediatek/boostfwk/info/ActivityInfo;->-$$Nest$fgetmActivityCount(Lcom/mediatek/boostfwk/info/ActivityInfo;)I

    move-result p1

    add-int/lit8 p1, p1, 0x1

    invoke-static {p0, p1}, Lcom/mediatek/boostfwk/info/ActivityInfo;->-$$Nest$fputmActivityCount(Lcom/mediatek/boostfwk/info/ActivityInfo;I)V

    return-void
.end method

.method public onActivitySaveInstanceState(Landroid/app/Activity;Landroid/os/Bundle;)V
    .locals 0

    return-void
.end method

.method public onActivityStarted(Landroid/app/Activity;)V
    .locals 0

    return-void
.end method

.method public onActivityStopped(Landroid/app/Activity;)V
    .locals 0

    return-void
.end method
