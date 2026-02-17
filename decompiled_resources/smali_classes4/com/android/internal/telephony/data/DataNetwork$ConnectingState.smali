.class public Lcom/android/internal/telephony/data/DataNetwork$ConnectingState;
.super Lcom/android/internal/telephony/State;
.source "DataNetwork.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/android/internal/telephony/data/DataNetwork;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x4
    name = "ConnectingState"
.end annotation


# instance fields
.field final synthetic this$0:Lcom/android/internal/telephony/data/DataNetwork;


# direct methods
.method protected constructor <init>(Lcom/android/internal/telephony/data/DataNetwork;)V
    .locals 0

    .line 1132
    iput-object p1, p0, Lcom/android/internal/telephony/data/DataNetwork$ConnectingState;->this$0:Lcom/android/internal/telephony/data/DataNetwork;

    invoke-direct {p0}, Lcom/android/internal/telephony/State;-><init>()V

    return-void
.end method


# virtual methods
.method public enter()V
    .locals 4

    .line 1135
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetwork$ConnectingState;->this$0:Lcom/android/internal/telephony/data/DataNetwork;

    iget-object v1, v0, Lcom/android/internal/telephony/data/DataNetwork;->mDataConfigManager:Lcom/android/internal/telephony/data/DataConfigManager;

    .line 1136
    invoke-virtual {v1}, Lcom/android/internal/telephony/data/DataConfigManager;->getAnomalyNetworkConnectingTimeoutMs()I

    move-result v1

    int-to-long v1, v1

    const/16 v3, 0x14

    .line 1135
    invoke-virtual {v0, v3, v1, v2}, Lcom/android/internal/telephony/StateMachine;->sendMessageDelayed(IJ)V

    .line 1137
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetwork$ConnectingState;->this$0:Lcom/android/internal/telephony/data/DataNetwork;

    invoke-static {v0}, Lcom/android/internal/telephony/data/DataNetwork;->-$$Nest$mcreateNetworkAgent(Lcom/android/internal/telephony/data/DataNetwork;)Lcom/android/internal/telephony/data/TelephonyNetworkAgent;

    move-result-object v1

    iput-object v1, v0, Lcom/android/internal/telephony/data/DataNetwork;->mNetworkAgent:Lcom/android/internal/telephony/data/TelephonyNetworkAgent;

    .line 1138
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetwork$ConnectingState;->this$0:Lcom/android/internal/telephony/data/DataNetwork;

    iget-object v1, v0, Lcom/android/internal/telephony/data/DataNetwork;->mNetworkAgent:Lcom/android/internal/telephony/data/TelephonyNetworkAgent;

    invoke-virtual {v1}, Lcom/android/internal/telephony/data/TelephonyNetworkAgent;->getId()I

    move-result v1

    invoke-static {v0, v1}, Lcom/android/internal/telephony/data/DataNetwork;->-$$Nest$fputmInitialNetworkAgentId(Lcom/android/internal/telephony/data/DataNetwork;I)V

    .line 1139
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetwork$ConnectingState;->this$0:Lcom/android/internal/telephony/data/DataNetwork;

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "DN-"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v2, p0, Lcom/android/internal/telephony/data/DataNetwork$ConnectingState;->this$0:Lcom/android/internal/telephony/data/DataNetwork;

    invoke-static {v2}, Lcom/android/internal/telephony/data/DataNetwork;->-$$Nest$fgetmInitialNetworkAgentId(Lcom/android/internal/telephony/data/DataNetwork;)I

    move-result v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v2, "-"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 1140
    iget-object v2, p0, Lcom/android/internal/telephony/data/DataNetwork$ConnectingState;->this$0:Lcom/android/internal/telephony/data/DataNetwork;

    iget v2, v2, Lcom/android/internal/telephony/data/DataNetwork;->mTransport:I

    const/4 v3, 0x1

    if-ne v2, v3, :cond_0

    const-string v2, "C"

    goto :goto_0

    :cond_0
    const-string v2, "I"

    :goto_0
    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    iput-object v1, v0, Lcom/android/internal/telephony/data/DataNetwork;->mLogTag:Ljava/lang/String;

    .line 1144
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetwork$ConnectingState;->this$0:Lcom/android/internal/telephony/data/DataNetwork;

    iget-object v1, v0, Lcom/android/internal/telephony/data/DataNetwork;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v1}, Lcom/android/internal/telephony/Phone;->getCarrierPrivilegesTracker()Lcom/android/internal/telephony/CarrierPrivilegesTracker;

    move-result-object v1

    .line 1145
    invoke-virtual {v1}, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->getCarrierServicePackageUid()I

    move-result v1

    invoke-static {v0, v1}, Lcom/android/internal/telephony/data/DataNetwork;->-$$Nest$fputmCarrierServicePackageUid(Lcom/android/internal/telephony/data/DataNetwork;I)V

    .line 1147
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetwork$ConnectingState;->this$0:Lcom/android/internal/telephony/data/DataNetwork;

    invoke-virtual {v0}, Lcom/android/internal/telephony/data/DataNetwork;->notifyPreciseDataConnectionState()V

    .line 1148
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataNetwork$ConnectingState;->this$0:Lcom/android/internal/telephony/data/DataNetwork;

    iget v0, p0, Lcom/android/internal/telephony/data/DataNetwork;->mTransport:I

    const/4 v1, 0x2

    if-ne v0, v1, :cond_1

    .line 1150
    invoke-static {p0}, Lcom/android/internal/telephony/data/DataNetwork;->-$$Nest$mallocatePduSessionId(Lcom/android/internal/telephony/data/DataNetwork;)V

    return-void

    .line 1154
    :cond_1
    invoke-virtual {p0}, Lcom/android/internal/telephony/data/DataNetwork;->setupData()V

    return-void
.end method

.method public exit()V
    .locals 1

    .line 1159
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataNetwork$ConnectingState;->this$0:Lcom/android/internal/telephony/data/DataNetwork;

    const/16 v0, 0x14

    invoke-static {p0, v0}, Lcom/android/internal/telephony/data/DataNetwork;->access$000(Lcom/android/internal/telephony/data/DataNetwork;I)V

    return-void
.end method

.method public processMessage(Landroid/os/Message;)Z
    .locals 4

    .line 1164
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetwork$ConnectingState;->this$0:Lcom/android/internal/telephony/data/DataNetwork;

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

    .line 1165
    iget v0, p1, Landroid/os/Message;->what:I

    const/4 v1, 0x5

    if-eq v0, v1, :cond_3

    const/4 v1, 0x6

    if-eq v0, v1, :cond_2

    const/4 v1, 0x7

    if-eq v0, v1, :cond_1

    const/16 v1, 0xe

    if-eq v0, v1, :cond_1

    const/16 v1, 0x11

    if-eq v0, v1, :cond_1

    const/16 v1, 0x14

    if-eq v0, v1, :cond_0

    const/16 v1, 0x15

    if-eq v0, v1, :cond_1

    const/4 p0, 0x0

    return p0

    .line 1191
    :cond_0
    iget-object p1, p0, Lcom/android/internal/telephony/data/DataNetwork$ConnectingState;->this$0:Lcom/android/internal/telephony/data/DataNetwork;

    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "Data network stuck in connecting state for "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    sget-object v1, Ljava/util/concurrent/TimeUnit;->MILLISECONDS:Ljava/util/concurrent/TimeUnit;

    iget-object v2, p0, Lcom/android/internal/telephony/data/DataNetwork$ConnectingState;->this$0:Lcom/android/internal/telephony/data/DataNetwork;

    iget-object v2, v2, Lcom/android/internal/telephony/data/DataNetwork;->mDataConfigManager:Lcom/android/internal/telephony/data/DataConfigManager;

    .line 1193
    invoke-virtual {v2}, Lcom/android/internal/telephony/data/DataConfigManager;->getAnomalyNetworkConnectingTimeoutMs()I

    move-result v2

    int-to-long v2, v2

    .line 1192
    invoke-virtual {v1, v2, v3}, Ljava/util/concurrent/TimeUnit;->toSeconds(J)J

    move-result-wide v1

    invoke-virtual {v0, v1, v2}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    const-string v1, " seconds."

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    const-string v1, "58c56403-7ea7-4e56-a0c7-e467114d09b8"

    .line 1191
    invoke-static {p1, v0, v1}, Lcom/android/internal/telephony/data/DataNetwork;->-$$Nest$mreportAnomaly(Lcom/android/internal/telephony/data/DataNetwork;Ljava/lang/String;Ljava/lang/String;)V

    .line 1197
    iget-object p1, p0, Lcom/android/internal/telephony/data/DataNetwork$ConnectingState;->this$0:Lcom/android/internal/telephony/data/DataNetwork;

    const-wide/16 v0, -0x1

    invoke-static {p1, v0, v1}, Lcom/android/internal/telephony/data/DataNetwork;->-$$Nest$fputmRetryDelayMillis(Lcom/android/internal/telephony/data/DataNetwork;J)V

    .line 1198
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataNetwork$ConnectingState;->this$0:Lcom/android/internal/telephony/data/DataNetwork;

    const p1, 0x1000b

    iput p1, p0, Lcom/android/internal/telephony/data/DataNetwork;->mFailCause:I

    .line 1199
    invoke-static {p0}, Lcom/android/internal/telephony/data/DataNetwork;->-$$Nest$fgetmDisconnectedState(Lcom/android/internal/telephony/data/DataNetwork;)Lcom/android/internal/telephony/data/DataNetwork$DisconnectedState;

    move-result-object p1

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/StateMachine;->transitionTo(Lcom/android/internal/telephony/IState;)V

    goto/16 :goto_1

    .line 1187
    :cond_1
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetwork$ConnectingState;->this$0:Lcom/android/internal/telephony/data/DataNetwork;

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "Defer message "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v2, p1, Landroid/os/Message;->what:I

    invoke-static {v2}, Lcom/android/internal/telephony/data/DataNetwork;->eventToString(I)Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/data/DataNetwork;->log(Ljava/lang/String;)V

    .line 1188
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataNetwork$ConnectingState;->this$0:Lcom/android/internal/telephony/data/DataNetwork;

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/StateMachine;->deferMessage(Landroid/os/Message;)V

    goto :goto_1

    .line 1177
    :cond_2
    iget v0, p1, Landroid/os/Message;->arg1:I

    .line 1179
    invoke-virtual {p1}, Landroid/os/Message;->getData()Landroid/os/Bundle;

    move-result-object p1

    const-string v1, "data_call_response"

    invoke-virtual {p1, v1}, Landroid/os/Bundle;->getParcelable(Ljava/lang/String;)Landroid/os/Parcelable;

    move-result-object p1

    check-cast p1, Landroid/telephony/data/DataCallResponse;

    .line 1180
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataNetwork$ConnectingState;->this$0:Lcom/android/internal/telephony/data/DataNetwork;

    invoke-virtual {p0, v0, p1}, Lcom/android/internal/telephony/data/DataNetwork;->onSetupResponse(ILandroid/telephony/data/DataCallResponse;)V

    goto :goto_1

    .line 1167
    :cond_3
    iget-object p1, p1, Landroid/os/Message;->obj:Ljava/lang/Object;

    check-cast p1, Landroid/os/AsyncResult;

    .line 1168
    iget-object v0, p1, Landroid/os/AsyncResult;->exception:Ljava/lang/Throwable;

    if-nez v0, :cond_4

    .line 1169
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetwork$ConnectingState;->this$0:Lcom/android/internal/telephony/data/DataNetwork;

    iget-object p1, p1, Landroid/os/AsyncResult;->result:Ljava/lang/Object;

    check-cast p1, Ljava/lang/Integer;

    invoke-virtual {p1}, Ljava/lang/Integer;->intValue()I

    move-result p1

    invoke-static {v0, p1}, Lcom/android/internal/telephony/data/DataNetwork;->-$$Nest$fputmPduSessionId(Lcom/android/internal/telephony/data/DataNetwork;I)V

    .line 1170
    iget-object p1, p0, Lcom/android/internal/telephony/data/DataNetwork$ConnectingState;->this$0:Lcom/android/internal/telephony/data/DataNetwork;

    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "Set PDU session id to "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/android/internal/telephony/data/DataNetwork$ConnectingState;->this$0:Lcom/android/internal/telephony/data/DataNetwork;

    invoke-static {v1}, Lcom/android/internal/telephony/data/DataNetwork;->-$$Nest$fgetmPduSessionId(Lcom/android/internal/telephony/data/DataNetwork;)I

    move-result v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p1, v0}, Lcom/android/internal/telephony/data/DataNetwork;->log(Ljava/lang/String;)V

    goto :goto_0

    .line 1172
    :cond_4
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetwork$ConnectingState;->this$0:Lcom/android/internal/telephony/data/DataNetwork;

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "Failed to allocate PDU session id. e="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object p1, p1, Landroid/os/AsyncResult;->exception:Ljava/lang/Throwable;

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {v0, p1}, Lcom/android/internal/telephony/data/DataNetwork;->loge(Ljava/lang/String;)V

    .line 1174
    :goto_0
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataNetwork$ConnectingState;->this$0:Lcom/android/internal/telephony/data/DataNetwork;

    invoke-virtual {p0}, Lcom/android/internal/telephony/data/DataNetwork;->setupData()V

    :goto_1
    const/4 p0, 0x1

    return p0
.end method
