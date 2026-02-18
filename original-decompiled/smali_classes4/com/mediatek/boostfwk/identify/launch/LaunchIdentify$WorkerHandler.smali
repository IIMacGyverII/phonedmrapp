.class public Lcom/mediatek/boostfwk/identify/launch/LaunchIdentify$WorkerHandler;
.super Landroid/os/Handler;
.source "LaunchIdentify.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/mediatek/boostfwk/identify/launch/LaunchIdentify;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x1
    name = "WorkerHandler"
.end annotation


# static fields
.field public static final MSG_ACTIVITY_IDLE:I = 0x3

.field public static final MSG_ACTIVITY_RESUME:I = 0x2

.field public static final MSG_PROCESS_START:I = 0x1


# instance fields
.field final synthetic this$0:Lcom/mediatek/boostfwk/identify/launch/LaunchIdentify;


# direct methods
.method constructor <init>(Lcom/mediatek/boostfwk/identify/launch/LaunchIdentify;Landroid/os/Looper;)V
    .locals 0

    .line 278
    iput-object p1, p0, Lcom/mediatek/boostfwk/identify/launch/LaunchIdentify$WorkerHandler;->this$0:Lcom/mediatek/boostfwk/identify/launch/LaunchIdentify;

    .line 279
    invoke-direct {p0, p2}, Landroid/os/Handler;-><init>(Landroid/os/Looper;)V

    return-void
.end method


# virtual methods
.method public handleMessage(Landroid/os/Message;)V
    .locals 2

    .line 284
    iget v0, p1, Landroid/os/Message;->what:I

    const/4 v1, 0x2

    if-eq v0, v1, :cond_0

    const/4 v1, 0x3

    if-eq v0, v1, :cond_0

    goto :goto_0

    .line 287
    :cond_0
    iget-object p0, p0, Lcom/mediatek/boostfwk/identify/launch/LaunchIdentify$WorkerHandler;->this$0:Lcom/mediatek/boostfwk/identify/launch/LaunchIdentify;

    iget-object p1, p1, Landroid/os/Message;->obj:Ljava/lang/Object;

    check-cast p1, Ljava/lang/String;

    invoke-virtual {p0, p1}, Lcom/mediatek/boostfwk/identify/launch/LaunchIdentify;->boostEnd(Ljava/lang/String;)V

    :goto_0
    return-void
.end method
