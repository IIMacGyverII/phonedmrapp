.class Lcom/android/internal/telephony/NetworkTypeController$3;
.super Lcom/android/internal/telephony/data/DataNetworkController$DataNetworkControllerCallback;
.source "NetworkTypeController.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/android/internal/telephony/NetworkTypeController;->parseCarrierConfigs()V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/android/internal/telephony/NetworkTypeController;


# direct methods
.method constructor <init>(Lcom/android/internal/telephony/NetworkTypeController;Ljava/util/concurrent/Executor;)V
    .locals 0

    .line 336
    iput-object p1, p0, Lcom/android/internal/telephony/NetworkTypeController$3;->this$0:Lcom/android/internal/telephony/NetworkTypeController;

    invoke-direct {p0, p2}, Lcom/android/internal/telephony/data/DataNetworkController$DataNetworkControllerCallback;-><init>(Ljava/util/concurrent/Executor;)V

    return-void
.end method


# virtual methods
.method public onPhysicalLinkStatusChanged(I)V
    .locals 2

    .line 340
    iget-object p0, p0, Lcom/android/internal/telephony/NetworkTypeController$3;->this$0:Lcom/android/internal/telephony/NetworkTypeController;

    new-instance v0, Landroid/os/AsyncResult;

    .line 342
    invoke-static {p1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p1

    const/4 v1, 0x0

    invoke-direct {v0, v1, p1, v1}, Landroid/os/AsyncResult;-><init>(Ljava/lang/Object;Ljava/lang/Object;Ljava/lang/Throwable;)V

    const/4 p1, 0x5

    .line 340
    invoke-virtual {p0, p1, v0}, Lcom/android/internal/telephony/StateMachine;->obtainMessage(ILjava/lang/Object;)Landroid/os/Message;

    move-result-object p1

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/StateMachine;->sendMessage(Landroid/os/Message;)V

    return-void
.end method
