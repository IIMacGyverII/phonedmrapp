.class public Lcom/pri/prizeinterphone/manager/PCMReceiveManager$WorkHandler;
.super Landroid/os/Handler;
.source "PCMReceiveManager.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/pri/prizeinterphone/manager/PCMReceiveManager;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x1
    name = "WorkHandler"
.end annotation


# instance fields
.field final synthetic this$0:Lcom/pri/prizeinterphone/manager/PCMReceiveManager;


# direct methods
.method public constructor <init>(Lcom/pri/prizeinterphone/manager/PCMReceiveManager;Landroid/os/Looper;)V
    .locals 0

    .line 103
    iput-object p1, p0, Lcom/pri/prizeinterphone/manager/PCMReceiveManager$WorkHandler;->this$0:Lcom/pri/prizeinterphone/manager/PCMReceiveManager;

    .line 104
    invoke-direct {p0, p2}, Landroid/os/Handler;-><init>(Landroid/os/Looper;)V

    return-void
.end method


# virtual methods
.method public handleMessage(Landroid/os/Message;)V
    .locals 2

    .line 109
    iget v0, p1, Landroid/os/Message;->what:I

    const/4 v1, 0x1

    if-eq v0, v1, :cond_0

    goto :goto_0

    .line 111
    :cond_0
    iget-object v0, p1, Landroid/os/Message;->obj:Ljava/lang/Object;

    check-cast v0, [B

    .line 112
    iget p1, p1, Landroid/os/Message;->arg1:I

    .line 113
    iget-object p0, p0, Lcom/pri/prizeinterphone/manager/PCMReceiveManager$WorkHandler;->this$0:Lcom/pri/prizeinterphone/manager/PCMReceiveManager;

    invoke-static {p0, v0, p1}, Lcom/pri/prizeinterphone/manager/PCMReceiveManager;->-$$Nest$mwriteAudioTrack(Lcom/pri/prizeinterphone/manager/PCMReceiveManager;[BI)V

    :goto_0
    return-void
.end method
