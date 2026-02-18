.class public Lcom/android/internal/telephony/data/DataNetwork$DisconnectedState;
.super Lcom/android/internal/telephony/State;
.source "DataNetwork.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/android/internal/telephony/data/DataNetwork;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x4
    name = "DisconnectedState"
.end annotation


# instance fields
.field final synthetic this$0:Lcom/android/internal/telephony/data/DataNetwork;


# direct methods
.method public static synthetic $r8$lambda$RLkTM8sSVuOY4q_rx8XfOL_rkNU(Lcom/android/internal/telephony/data/DataNetwork$DisconnectedState;)V
    .locals 0

    invoke-direct {p0}, Lcom/android/internal/telephony/data/DataNetwork$DisconnectedState;->lambda$enter$0()V

    return-void
.end method

.method public static synthetic $r8$lambda$zTpwxNesj_YWray_GohnsPmBukk(Lcom/android/internal/telephony/data/DataNetwork$DisconnectedState;Lcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/DataNetwork$DisconnectedState;->lambda$enter$1(Lcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;)V

    return-void
.end method

.method protected constructor <init>(Lcom/android/internal/telephony/data/DataNetwork;)V
    .locals 0

    .line 1507
    iput-object p1, p0, Lcom/android/internal/telephony/data/DataNetwork$DisconnectedState;->this$0:Lcom/android/internal/telephony/data/DataNetwork;

    invoke-direct {p0}, Lcom/android/internal/telephony/State;-><init>()V

    return-void
.end method

.method private synthetic lambda$enter$0()V
    .locals 2

    .line 1530
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataNetwork$DisconnectedState;->this$0:Lcom/android/internal/telephony/data/DataNetwork;

    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetwork;->mDataNetworkCallback:Lcom/android/internal/telephony/data/DataNetwork$DataNetworkCallback;

    iget v1, p0, Lcom/android/internal/telephony/data/DataNetwork;->mFailCause:I

    .line 1531
    invoke-virtual {v0, p0, v1}, Lcom/android/internal/telephony/data/DataNetwork$DataNetworkCallback;->onDisconnected(Lcom/android/internal/telephony/data/DataNetwork;I)V

    return-void
.end method

.method private synthetic lambda$enter$1(Lcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;)V
    .locals 6

    .line 1536
    iget-object v1, p0, Lcom/android/internal/telephony/data/DataNetwork$DisconnectedState;->this$0:Lcom/android/internal/telephony/data/DataNetwork;

    iget-object v0, v1, Lcom/android/internal/telephony/data/DataNetwork;->mDataNetworkCallback:Lcom/android/internal/telephony/data/DataNetwork$DataNetworkCallback;

    iget v3, v1, Lcom/android/internal/telephony/data/DataNetwork;->mFailCause:I

    invoke-static {v1}, Lcom/android/internal/telephony/data/DataNetwork;->-$$Nest$fgetmRetryDelayMillis(Lcom/android/internal/telephony/data/DataNetwork;)J

    move-result-wide v4

    move-object v2, p1

    .line 1537
    invoke-virtual/range {v0 .. v5}, Lcom/android/internal/telephony/data/DataNetwork$DataNetworkCallback;->onSetupDataFailed(Lcom/android/internal/telephony/data/DataNetwork;Lcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;IJ)V

    return-void
.end method


# virtual methods
.method public enter()V
    .locals 3

    .line 1510
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetwork$DisconnectedState;->this$0:Lcom/android/internal/telephony/data/DataNetwork;

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "Data network disconnected. mEverConnected="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v2, p0, Lcom/android/internal/telephony/data/DataNetwork$DisconnectedState;->this$0:Lcom/android/internal/telephony/data/DataNetwork;

    invoke-static {v2}, Lcom/android/internal/telephony/data/DataNetwork;->-$$Nest$fgetmEverConnected(Lcom/android/internal/telephony/data/DataNetwork;)Z

    move-result v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/data/DataNetwork;->logl(Ljava/lang/String;)V

    .line 1514
    new-instance v0, Lcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;

    iget-object v1, p0, Lcom/android/internal/telephony/data/DataNetwork$DisconnectedState;->this$0:Lcom/android/internal/telephony/data/DataNetwork;

    iget-object v1, v1, Lcom/android/internal/telephony/data/DataNetwork;->mAttachedNetworkRequestList:Lcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;

    invoke-direct {v0, v1}, Lcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;-><init>(Lcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;)V

    .line 1517
    iget-object v1, p0, Lcom/android/internal/telephony/data/DataNetwork$DisconnectedState;->this$0:Lcom/android/internal/telephony/data/DataNetwork;

    const/16 v2, 0xa

    invoke-virtual {v1, v2}, Lcom/android/internal/telephony/StateMachine;->sendMessage(I)V

    .line 1521
    iget-object v1, p0, Lcom/android/internal/telephony/data/DataNetwork$DisconnectedState;->this$0:Lcom/android/internal/telephony/data/DataNetwork;

    invoke-virtual {v1}, Lcom/android/internal/telephony/StateMachine;->quit()V

    .line 1529
    iget-object v1, p0, Lcom/android/internal/telephony/data/DataNetwork$DisconnectedState;->this$0:Lcom/android/internal/telephony/data/DataNetwork;

    invoke-static {v1}, Lcom/android/internal/telephony/data/DataNetwork;->-$$Nest$fgetmEverConnected(Lcom/android/internal/telephony/data/DataNetwork;)Z

    move-result v1

    if-eqz v1, :cond_0

    .line 1530
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetwork$DisconnectedState;->this$0:Lcom/android/internal/telephony/data/DataNetwork;

    iget-object v0, v0, Lcom/android/internal/telephony/data/DataNetwork;->mDataNetworkCallback:Lcom/android/internal/telephony/data/DataNetwork$DataNetworkCallback;

    new-instance v1, Lcom/android/internal/telephony/data/DataNetwork$DisconnectedState$$ExternalSyntheticLambda0;

    invoke-direct {v1, p0}, Lcom/android/internal/telephony/data/DataNetwork$DisconnectedState$$ExternalSyntheticLambda0;-><init>(Lcom/android/internal/telephony/data/DataNetwork$DisconnectedState;)V

    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/data/DataCallback;->invokeFromExecutor(Ljava/lang/Runnable;)V

    .line 1532
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetwork$DisconnectedState;->this$0:Lcom/android/internal/telephony/data/DataNetwork;

    iget v1, v0, Lcom/android/internal/telephony/data/DataNetwork;->mTransport:I

    const/4 v2, 0x1

    if-ne v1, v2, :cond_1

    .line 1533
    invoke-static {v0}, Lcom/android/internal/telephony/data/DataNetwork;->-$$Nest$munregisterForWwanEvents(Lcom/android/internal/telephony/data/DataNetwork;)V

    goto :goto_0

    .line 1536
    :cond_0
    iget-object v1, p0, Lcom/android/internal/telephony/data/DataNetwork$DisconnectedState;->this$0:Lcom/android/internal/telephony/data/DataNetwork;

    iget-object v1, v1, Lcom/android/internal/telephony/data/DataNetwork;->mDataNetworkCallback:Lcom/android/internal/telephony/data/DataNetwork$DataNetworkCallback;

    new-instance v2, Lcom/android/internal/telephony/data/DataNetwork$DisconnectedState$$ExternalSyntheticLambda1;

    invoke-direct {v2, p0, v0}, Lcom/android/internal/telephony/data/DataNetwork$DisconnectedState$$ExternalSyntheticLambda1;-><init>(Lcom/android/internal/telephony/data/DataNetwork$DisconnectedState;Lcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;)V

    invoke-virtual {v1, v2}, Lcom/android/internal/telephony/data/DataCallback;->invokeFromExecutor(Ljava/lang/Runnable;)V

    .line 1540
    :cond_1
    :goto_0
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetwork$DisconnectedState;->this$0:Lcom/android/internal/telephony/data/DataNetwork;

    invoke-virtual {v0}, Lcom/android/internal/telephony/data/DataNetwork;->notifyPreciseDataConnectionState()V

    .line 1541
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetwork$DisconnectedState;->this$0:Lcom/android/internal/telephony/data/DataNetwork;

    iget-object v0, v0, Lcom/android/internal/telephony/data/DataNetwork;->mNetworkAgent:Lcom/android/internal/telephony/data/TelephonyNetworkAgent;

    invoke-virtual {v0}, Landroid/net/NetworkAgent;->unregister()V

    .line 1542
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetwork$DisconnectedState;->this$0:Lcom/android/internal/telephony/data/DataNetwork;

    iget-object v1, v0, Lcom/android/internal/telephony/data/DataNetwork;->mDataNetworkController:Lcom/android/internal/telephony/data/DataNetworkController;

    invoke-static {v0}, Lcom/android/internal/telephony/data/DataNetwork;->-$$Nest$fgetmDataNetworkControllerCallback(Lcom/android/internal/telephony/data/DataNetwork;)Lcom/android/internal/telephony/data/DataNetworkController$DataNetworkControllerCallback;

    move-result-object v0

    invoke-virtual {v1, v0}, Lcom/android/internal/telephony/data/DataNetworkController;->unregisterDataNetworkControllerCallback(Lcom/android/internal/telephony/data/DataNetworkController$DataNetworkControllerCallback;)V

    .line 1544
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetwork$DisconnectedState;->this$0:Lcom/android/internal/telephony/data/DataNetwork;

    iget-object v1, v0, Lcom/android/internal/telephony/data/DataNetwork;->mDataCallSessionStats:Lcom/android/internal/telephony/metrics/DataCallSessionStats;

    iget v0, v0, Lcom/android/internal/telephony/data/DataNetwork;->mFailCause:I

    invoke-virtual {v1, v0}, Lcom/android/internal/telephony/metrics/DataCallSessionStats;->onDataCallDisconnected(I)V

    .line 1546
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetwork$DisconnectedState;->this$0:Lcom/android/internal/telephony/data/DataNetwork;

    iget v1, v0, Lcom/android/internal/telephony/data/DataNetwork;->mTransport:I

    const/4 v2, 0x2

    if-ne v1, v2, :cond_2

    invoke-static {v0}, Lcom/android/internal/telephony/data/DataNetwork;->-$$Nest$fgetmPduSessionId(Lcom/android/internal/telephony/data/DataNetwork;)I

    move-result v0

    if-eqz v0, :cond_2

    .line 1548
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetwork$DisconnectedState;->this$0:Lcom/android/internal/telephony/data/DataNetwork;

    invoke-static {v0}, Lcom/android/internal/telephony/data/DataNetwork;->-$$Nest$fgetmRil(Lcom/android/internal/telephony/data/DataNetwork;)Lcom/android/internal/telephony/CommandsInterface;

    move-result-object v0

    const/4 v1, 0x0

    iget-object v2, p0, Lcom/android/internal/telephony/data/DataNetwork$DisconnectedState;->this$0:Lcom/android/internal/telephony/data/DataNetwork;

    invoke-static {v2}, Lcom/android/internal/telephony/data/DataNetwork;->-$$Nest$fgetmPduSessionId(Lcom/android/internal/telephony/data/DataNetwork;)I

    move-result v2

    invoke-interface {v0, v1, v2}, Lcom/android/internal/telephony/CommandsInterface;->releasePduSessionId(Landroid/os/Message;I)V

    .line 1551
    :cond_2
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetwork$DisconnectedState;->this$0:Lcom/android/internal/telephony/data/DataNetwork;

    iget-object v1, v0, Lcom/android/internal/telephony/data/DataNetwork;->mVcnManager:Landroid/net/vcn/VcnManager;

    if-eqz v1, :cond_3

    invoke-static {v0}, Lcom/android/internal/telephony/data/DataNetwork;->-$$Nest$fgetmVcnPolicyChangeListener(Lcom/android/internal/telephony/data/DataNetwork;)Landroid/net/vcn/VcnManager$VcnNetworkPolicyChangeListener;

    move-result-object v0

    if-eqz v0, :cond_3

    .line 1552
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataNetwork$DisconnectedState;->this$0:Lcom/android/internal/telephony/data/DataNetwork;

    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetwork;->mVcnManager:Landroid/net/vcn/VcnManager;

    invoke-static {p0}, Lcom/android/internal/telephony/data/DataNetwork;->-$$Nest$fgetmVcnPolicyChangeListener(Lcom/android/internal/telephony/data/DataNetwork;)Landroid/net/vcn/VcnManager$VcnNetworkPolicyChangeListener;

    move-result-object p0

    invoke-virtual {v0, p0}, Landroid/net/vcn/VcnManager;->removeVcnNetworkPolicyChangeListener(Landroid/net/vcn/VcnManager$VcnNetworkPolicyChangeListener;)V

    :cond_3
    return-void
.end method

.method public processMessage(Landroid/os/Message;)Z
    .locals 2

    .line 1558
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataNetwork$DisconnectedState;->this$0:Lcom/android/internal/telephony/data/DataNetwork;

    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "event="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget p1, p1, Landroid/os/Message;->what:I

    invoke-static {p1}, Lcom/android/internal/telephony/data/DataNetwork;->eventToString(I)Ljava/lang/String;

    move-result-object p1

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/data/DataNetwork;->logv(Ljava/lang/String;)V

    const/4 p0, 0x0

    return p0
.end method
