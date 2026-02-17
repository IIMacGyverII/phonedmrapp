.class public Lcom/android/internal/telephony/data/DataNetwork$DisconnectingState;
.super Lcom/android/internal/telephony/State;
.source "DataNetwork.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/android/internal/telephony/data/DataNetwork;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x4
    name = "DisconnectingState"
.end annotation


# instance fields
.field final synthetic this$0:Lcom/android/internal/telephony/data/DataNetwork;


# direct methods
.method protected constructor <init>(Lcom/android/internal/telephony/data/DataNetwork;)V
    .locals 0

    .line 1445
    iput-object p1, p0, Lcom/android/internal/telephony/data/DataNetwork$DisconnectingState;->this$0:Lcom/android/internal/telephony/data/DataNetwork;

    invoke-direct {p0}, Lcom/android/internal/telephony/State;-><init>()V

    return-void
.end method


# virtual methods
.method public enter()V
    .locals 4

    .line 1448
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetwork$DisconnectingState;->this$0:Lcom/android/internal/telephony/data/DataNetwork;

    iget-object v1, v0, Lcom/android/internal/telephony/data/DataNetwork;->mDataConfigManager:Lcom/android/internal/telephony/data/DataConfigManager;

    .line 1449
    invoke-virtual {v1}, Lcom/android/internal/telephony/data/DataConfigManager;->getAnomalyNetworkDisconnectingTimeoutMs()I

    move-result v1

    int-to-long v1, v1

    const/16 v3, 0x14

    .line 1448
    invoke-virtual {v0, v3, v1, v2}, Lcom/android/internal/telephony/StateMachine;->sendMessageDelayed(IJ)V

    .line 1450
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataNetwork$DisconnectingState;->this$0:Lcom/android/internal/telephony/data/DataNetwork;

    invoke-virtual {p0}, Lcom/android/internal/telephony/data/DataNetwork;->notifyPreciseDataConnectionState()V

    return-void
.end method

.method public exit()V
    .locals 1

    .line 1455
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataNetwork$DisconnectingState;->this$0:Lcom/android/internal/telephony/data/DataNetwork;

    const/16 v0, 0x14

    invoke-static {p0, v0}, Lcom/android/internal/telephony/data/DataNetwork;->access$400(Lcom/android/internal/telephony/data/DataNetwork;I)V

    return-void
.end method

.method public processMessage(Landroid/os/Message;)Z
    .locals 4

    .line 1460
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetwork$DisconnectingState;->this$0:Lcom/android/internal/telephony/data/DataNetwork;

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "event="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v2, p1, Landroid/os/Message;->what:I

    invoke-static {v2}, Lcom/android/internal/telephony/data/DataNetwork;->eventToString(I)Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/data/DataNetwork;->logv(Ljava/lang/String;)V

    .line 1461
    iget v0, p1, Landroid/os/Message;->what:I

    const/4 v1, 0x7

    if-eq v0, v1, :cond_3

    const/16 v1, 0xd

    if-eq v0, v1, :cond_2

    const/16 v1, 0x13

    if-eq v0, v1, :cond_1

    const/16 p1, 0x14

    if-eq v0, p1, :cond_0

    packed-switch v0, :pswitch_data_0

    const/4 p0, 0x0

    return p0

    .line 1492
    :pswitch_0
    iget-object p1, p0, Lcom/android/internal/telephony/data/DataNetwork$DisconnectingState;->this$0:Lcom/android/internal/telephony/data/DataNetwork;

    invoke-virtual {p1}, Lcom/android/internal/telephony/data/DataNetwork;->updateSuspendState()V

    .line 1493
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataNetwork$DisconnectingState;->this$0:Lcom/android/internal/telephony/data/DataNetwork;

    invoke-virtual {p0}, Lcom/android/internal/telephony/data/DataNetwork;->updateNetworkCapabilities()V

    goto :goto_0

    .line 1478
    :cond_0
    iget-object p1, p0, Lcom/android/internal/telephony/data/DataNetwork$DisconnectingState;->this$0:Lcom/android/internal/telephony/data/DataNetwork;

    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "RIL did not send data call list changed event after deactivate data call request within "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    sget-object v1, Ljava/util/concurrent/TimeUnit;->MILLISECONDS:Ljava/util/concurrent/TimeUnit;

    iget-object v2, p0, Lcom/android/internal/telephony/data/DataNetwork$DisconnectingState;->this$0:Lcom/android/internal/telephony/data/DataNetwork;

    iget-object v2, v2, Lcom/android/internal/telephony/data/DataNetwork;->mDataConfigManager:Lcom/android/internal/telephony/data/DataConfigManager;

    .line 1481
    invoke-virtual {v2}, Lcom/android/internal/telephony/data/DataConfigManager;->getAnomalyNetworkDisconnectingTimeoutMs()I

    move-result v2

    int-to-long v2, v2

    .line 1480
    invoke-virtual {v1, v2, v3}, Ljava/util/concurrent/TimeUnit;->toSeconds(J)J

    move-result-wide v1

    invoke-virtual {v0, v1, v2}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    const-string v1, " seconds."

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    const-string v1, "d0e4fa1c-c57b-4ba5-b4b6-8955487012cc"

    .line 1478
    invoke-static {p1, v0, v1}, Lcom/android/internal/telephony/data/DataNetwork;->-$$Nest$mreportAnomaly(Lcom/android/internal/telephony/data/DataNetwork;Ljava/lang/String;Ljava/lang/String;)V

    .line 1483
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataNetwork$DisconnectingState;->this$0:Lcom/android/internal/telephony/data/DataNetwork;

    const p1, 0x10004

    iput p1, p0, Lcom/android/internal/telephony/data/DataNetwork;->mFailCause:I

    .line 1484
    invoke-static {p0}, Lcom/android/internal/telephony/data/DataNetwork;->-$$Nest$fgetmDisconnectedState(Lcom/android/internal/telephony/data/DataNetwork;)Lcom/android/internal/telephony/data/DataNetwork$DisconnectedState;

    move-result-object p1

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/StateMachine;->transitionTo(Lcom/android/internal/telephony/IState;)V

    goto :goto_0

    .line 1472
    :cond_1
    iget p1, p1, Landroid/os/Message;->arg1:I

    .line 1473
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataNetwork$DisconnectingState;->this$0:Lcom/android/internal/telephony/data/DataNetwork;

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/data/DataNetwork;->onDeactivateResponse(I)V

    goto :goto_0

    .line 1487
    :cond_2
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataNetwork$DisconnectingState;->this$0:Lcom/android/internal/telephony/data/DataNetwork;

    invoke-static {p0}, Lcom/android/internal/telephony/data/DataNetwork;->-$$Nest$monDisplayInfoChanged(Lcom/android/internal/telephony/data/DataNetwork;)V

    goto :goto_0

    .line 1463
    :cond_3
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetwork$DisconnectingState;->this$0:Lcom/android/internal/telephony/data/DataNetwork;

    iget-boolean v2, v0, Lcom/android/internal/telephony/data/DataNetwork;->mInvokedDataDeactivation:Z

    if-eqz v2, :cond_4

    const-string p0, "Ignore tear down request because network is being torn down."

    .line 1464
    invoke-virtual {v0, p0}, Lcom/android/internal/telephony/data/DataNetwork;->log(Ljava/lang/String;)V

    goto :goto_0

    .line 1467
    :cond_4
    invoke-static {v0, v1}, Lcom/android/internal/telephony/data/DataNetwork;->access$500(Lcom/android/internal/telephony/data/DataNetwork;I)V

    .line 1468
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetwork$DisconnectingState;->this$0:Lcom/android/internal/telephony/data/DataNetwork;

    invoke-static {v0, v1}, Lcom/android/internal/telephony/data/DataNetwork;->access$600(Lcom/android/internal/telephony/data/DataNetwork;I)V

    .line 1469
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataNetwork$DisconnectingState;->this$0:Lcom/android/internal/telephony/data/DataNetwork;

    iget p1, p1, Landroid/os/Message;->arg1:I

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/data/DataNetwork;->onTearDown(I)V

    :goto_0
    const/4 p0, 0x1

    return p0

    nop

    :pswitch_data_0
    .packed-switch 0x16
        :pswitch_0
        :pswitch_0
        :pswitch_0
    .end packed-switch
.end method
