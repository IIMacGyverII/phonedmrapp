.class public Lcom/mediatek/boostfwk/policy/frame/BaseFramePolicy$WorkerHandler;
.super Landroid/os/Handler;
.source "BaseFramePolicy.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/mediatek/boostfwk/policy/frame/BaseFramePolicy;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x4
    name = "WorkerHandler"
.end annotation


# static fields
.field public static final MSG_INIT_CORE_SERVICE:I = -0x3e8


# instance fields
.field final synthetic this$0:Lcom/mediatek/boostfwk/policy/frame/BaseFramePolicy;


# direct methods
.method constructor <init>(Lcom/mediatek/boostfwk/policy/frame/BaseFramePolicy;Landroid/os/Looper;)V
    .locals 0

    .line 143
    iput-object p1, p0, Lcom/mediatek/boostfwk/policy/frame/BaseFramePolicy$WorkerHandler;->this$0:Lcom/mediatek/boostfwk/policy/frame/BaseFramePolicy;

    .line 144
    invoke-direct {p0, p2}, Landroid/os/Handler;-><init>(Landroid/os/Looper;)V

    return-void
.end method


# virtual methods
.method public handleMessage(Landroid/os/Message;)V
    .locals 2

    .line 149
    iget v0, p1, Landroid/os/Message;->what:I

    const/16 v1, -0x3e8

    if-ne v0, v1, :cond_0

    .line 150
    iget-object p0, p0, Lcom/mediatek/boostfwk/policy/frame/BaseFramePolicy$WorkerHandler;->this$0:Lcom/mediatek/boostfwk/policy/frame/BaseFramePolicy;

    invoke-virtual {p0}, Lcom/mediatek/boostfwk/policy/frame/BaseFramePolicy;->initCoreServiceInternal()V

    goto :goto_0

    .line 152
    :cond_0
    iget-object p0, p0, Lcom/mediatek/boostfwk/policy/frame/BaseFramePolicy$WorkerHandler;->this$0:Lcom/mediatek/boostfwk/policy/frame/BaseFramePolicy;

    invoke-virtual {p0, p1}, Lcom/mediatek/boostfwk/policy/frame/BaseFramePolicy;->handleMessageInternal(Landroid/os/Message;)V

    :goto_0
    return-void
.end method
