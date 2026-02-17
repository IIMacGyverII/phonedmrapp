.class Lcom/android/internal/telephony/dataconnection/DataConnection$DcInactiveState;
.super Lcom/android/internal/telephony/State;
.source "DataConnection.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/android/internal/telephony/dataconnection/DataConnection;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x2
    name = "DcInactiveState"
.end annotation


# instance fields
.field final synthetic this$0:Lcom/android/internal/telephony/dataconnection/DataConnection;


# direct methods
.method private constructor <init>(Lcom/android/internal/telephony/dataconnection/DataConnection;)V
    .locals 0

    .line 2482
    iput-object p1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$DcInactiveState;->this$0:Lcom/android/internal/telephony/dataconnection/DataConnection;

    invoke-direct {p0}, Lcom/android/internal/telephony/State;-><init>()V

    return-void
.end method

.method synthetic constructor <init>(Lcom/android/internal/telephony/dataconnection/DataConnection;Lcom/android/internal/telephony/dataconnection/DataConnection$DcInactiveState-IA;)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/dataconnection/DataConnection$DcInactiveState;-><init>(Lcom/android/internal/telephony/dataconnection/DataConnection;)V

    return-void
.end method


# virtual methods
.method public enter()V
    .locals 10

    .line 2510
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$DcInactiveState;->this$0:Lcom/android/internal/telephony/dataconnection/DataConnection;

    iget v1, v0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mTag:I

    const/4 v2, 0x1

    add-int/2addr v1, v2

    iput v1, v0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mTag:I

    .line 2511
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "DcInactiveState: enter() mTag="

    invoke-virtual {v1, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v3, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$DcInactiveState;->this$0:Lcom/android/internal/telephony/dataconnection/DataConnection;

    iget v3, v3, Lcom/android/internal/telephony/dataconnection/DataConnection;->mTag:I

    invoke-virtual {v1, v3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/dataconnection/DataConnection;->log(Ljava/lang/String;)V

    .line 2512
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$DcInactiveState;->this$0:Lcom/android/internal/telephony/dataconnection/DataConnection;

    invoke-static {v0}, Lcom/android/internal/telephony/dataconnection/DataConnection;->-$$Nest$fgetmPhone(Lcom/android/internal/telephony/dataconnection/DataConnection;)Lcom/android/internal/telephony/Phone;

    move-result-object v0

    .line 2514
    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getPhoneId()I

    move-result v5

    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$DcInactiveState;->this$0:Lcom/android/internal/telephony/dataconnection/DataConnection;

    invoke-static {v0}, Lcom/android/internal/telephony/dataconnection/DataConnection;->-$$Nest$fgetmId(Lcom/android/internal/telephony/dataconnection/DataConnection;)I

    move-result v6

    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$DcInactiveState;->this$0:Lcom/android/internal/telephony/dataconnection/DataConnection;

    invoke-static {v0}, Lcom/android/internal/telephony/dataconnection/DataConnection;->-$$Nest$mgetApnTypeBitmask(Lcom/android/internal/telephony/dataconnection/DataConnection;)I

    move-result v0

    int-to-long v7, v0

    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$DcInactiveState;->this$0:Lcom/android/internal/telephony/dataconnection/DataConnection;

    invoke-static {v0}, Lcom/android/internal/telephony/dataconnection/DataConnection;->-$$Nest$mcanHandleDefault(Lcom/android/internal/telephony/dataconnection/DataConnection;)Z

    move-result v9

    const/16 v3, 0x4b

    const/4 v4, 0x1

    .line 2512
    invoke-static/range {v3 .. v9}, Lcom/android/internal/telephony/TelephonyStatsLog;->write(IIIIJZ)V

    .line 2515
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$DcInactiveState;->this$0:Lcom/android/internal/telephony/dataconnection/DataConnection;

    invoke-static {v0}, Lcom/android/internal/telephony/dataconnection/DataConnection;->-$$Nest$fgetmDataCallSessionStats(Lcom/android/internal/telephony/dataconnection/DataConnection;)Lcom/android/internal/telephony/metrics/DataCallSessionStats;

    move-result-object v0

    iget-object v1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$DcInactiveState;->this$0:Lcom/android/internal/telephony/dataconnection/DataConnection;

    invoke-static {v1}, Lcom/android/internal/telephony/dataconnection/DataConnection;->-$$Nest$fgetmDcFailCause(Lcom/android/internal/telephony/dataconnection/DataConnection;)I

    move-result v1

    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/metrics/DataCallSessionStats;->onDataCallDisconnected(I)V

    .line 2516
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$DcInactiveState;->this$0:Lcom/android/internal/telephony/dataconnection/DataConnection;

    invoke-static {v0}, Lcom/android/internal/telephony/dataconnection/DataConnection;->-$$Nest$fgetmHandoverState(Lcom/android/internal/telephony/dataconnection/DataConnection;)I

    move-result v0

    const/4 v1, 0x2

    if-ne v0, v1, :cond_0

    .line 2518
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$DcInactiveState;->this$0:Lcom/android/internal/telephony/dataconnection/DataConnection;

    const/4 v1, 0x3

    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/dataconnection/DataConnection;->setHandoverState(I)V

    .line 2525
    :cond_0
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$DcInactiveState;->this$0:Lcom/android/internal/telephony/dataconnection/DataConnection;

    invoke-static {v0}, Lcom/android/internal/telephony/dataconnection/DataConnection;->-$$Nest$fgetmHandoverSourceNetworkAgent(Lcom/android/internal/telephony/dataconnection/DataConnection;)Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;

    move-result-object v0

    const/4 v1, 0x0

    if-eqz v0, :cond_2

    .line 2526
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$DcInactiveState;->this$0:Lcom/android/internal/telephony/dataconnection/DataConnection;

    invoke-static {v0}, Lcom/android/internal/telephony/dataconnection/DataConnection;->-$$Nest$fgetmHandoverSourceNetworkAgent(Lcom/android/internal/telephony/dataconnection/DataConnection;)Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;

    move-result-object v0

    invoke-virtual {v0}, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;->getDataConnection()Lcom/android/internal/telephony/dataconnection/DataConnection;

    move-result-object v0

    if-eqz v0, :cond_1

    .line 2530
    iget-object v3, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$DcInactiveState;->this$0:Lcom/android/internal/telephony/dataconnection/DataConnection;

    invoke-static {v3}, Lcom/android/internal/telephony/dataconnection/DataConnection;->-$$Nest$fgetmHandoverLocalLog(Lcom/android/internal/telephony/dataconnection/DataConnection;)Lcom/android/internal/telephony/LocalLog;

    move-result-object v3

    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    const-string v5, "Handover failed. Reset the source dc "

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 2531
    invoke-virtual {v0}, Lcom/android/internal/telephony/StateMachine;->getName()Ljava/lang/String;

    move-result-object v5

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v5, " state to idle"

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v4

    .line 2530
    invoke-virtual {v3, v4}, Lcom/android/internal/telephony/LocalLog;->log(Ljava/lang/String;)V

    .line 2533
    invoke-static {v0}, Lcom/android/internal/telephony/dataconnection/DataConnection;->-$$Nest$mcancelHandover(Lcom/android/internal/telephony/dataconnection/DataConnection;)V

    goto :goto_0

    .line 2537
    :cond_1
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$DcInactiveState;->this$0:Lcom/android/internal/telephony/dataconnection/DataConnection;

    invoke-static {v0}, Lcom/android/internal/telephony/dataconnection/DataConnection;->-$$Nest$fgetmHandoverLocalLog(Lcom/android/internal/telephony/dataconnection/DataConnection;)Lcom/android/internal/telephony/LocalLog;

    move-result-object v0

    const-string v3, "Handover failed and dangling agent found."

    invoke-virtual {v0, v3}, Lcom/android/internal/telephony/LocalLog;->log(Ljava/lang/String;)V

    .line 2539
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$DcInactiveState;->this$0:Lcom/android/internal/telephony/dataconnection/DataConnection;

    invoke-static {v0}, Lcom/android/internal/telephony/dataconnection/DataConnection;->-$$Nest$fgetmHandoverSourceNetworkAgent(Lcom/android/internal/telephony/dataconnection/DataConnection;)Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;

    move-result-object v0

    iget-object v3, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$DcInactiveState;->this$0:Lcom/android/internal/telephony/dataconnection/DataConnection;

    invoke-static {v3}, Lcom/android/internal/telephony/dataconnection/DataConnection;->-$$Nest$fgetmTransportType(Lcom/android/internal/telephony/dataconnection/DataConnection;)I

    move-result v4

    invoke-virtual {v0, v3, v4}, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;->acquireOwnership(Lcom/android/internal/telephony/dataconnection/DataConnection;I)V

    .line 2541
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$DcInactiveState;->this$0:Lcom/android/internal/telephony/dataconnection/DataConnection;

    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "Cleared dangling network agent. "

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v4, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$DcInactiveState;->this$0:Lcom/android/internal/telephony/dataconnection/DataConnection;

    invoke-static {v4}, Lcom/android/internal/telephony/dataconnection/DataConnection;->-$$Nest$fgetmHandoverSourceNetworkAgent(Lcom/android/internal/telephony/dataconnection/DataConnection;)Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;

    move-result-object v4

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v0, v3}, Lcom/android/internal/telephony/dataconnection/DataConnection;->log(Ljava/lang/String;)V

    .line 2542
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$DcInactiveState;->this$0:Lcom/android/internal/telephony/dataconnection/DataConnection;

    invoke-static {v0}, Lcom/android/internal/telephony/dataconnection/DataConnection;->-$$Nest$fgetmHandoverSourceNetworkAgent(Lcom/android/internal/telephony/dataconnection/DataConnection;)Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;

    move-result-object v0

    iget-object v3, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$DcInactiveState;->this$0:Lcom/android/internal/telephony/dataconnection/DataConnection;

    invoke-virtual {v0, v3}, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;->unregister(Lcom/android/internal/telephony/dataconnection/DataConnection;)V

    .line 2543
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$DcInactiveState;->this$0:Lcom/android/internal/telephony/dataconnection/DataConnection;

    invoke-static {v0}, Lcom/android/internal/telephony/dataconnection/DataConnection;->-$$Nest$fgetmHandoverSourceNetworkAgent(Lcom/android/internal/telephony/dataconnection/DataConnection;)Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;

    move-result-object v0

    iget-object v3, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$DcInactiveState;->this$0:Lcom/android/internal/telephony/dataconnection/DataConnection;

    invoke-virtual {v0, v3}, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;->releaseOwnership(Lcom/android/internal/telephony/dataconnection/DataConnection;)V

    .line 2545
    :goto_0
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$DcInactiveState;->this$0:Lcom/android/internal/telephony/dataconnection/DataConnection;

    invoke-static {v0, v1}, Lcom/android/internal/telephony/dataconnection/DataConnection;->-$$Nest$fputmHandoverSourceNetworkAgent(Lcom/android/internal/telephony/dataconnection/DataConnection;Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;)V

    .line 2548
    :cond_2
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$DcInactiveState;->this$0:Lcom/android/internal/telephony/dataconnection/DataConnection;

    invoke-static {v0}, Lcom/android/internal/telephony/dataconnection/DataConnection;->-$$Nest$fgetmConnectionParams(Lcom/android/internal/telephony/dataconnection/DataConnection;)Lcom/android/internal/telephony/dataconnection/DataConnection$ConnectionParams;

    move-result-object v0

    if-eqz v0, :cond_3

    .line 2550
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$DcInactiveState;->this$0:Lcom/android/internal/telephony/dataconnection/DataConnection;

    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "DcInactiveState: enter notifyConnectCompleted +ALL failCause="

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v4, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$DcInactiveState;->this$0:Lcom/android/internal/telephony/dataconnection/DataConnection;

    invoke-static {v4}, Lcom/android/internal/telephony/dataconnection/DataConnection;->-$$Nest$fgetmDcFailCause(Lcom/android/internal/telephony/dataconnection/DataConnection;)I

    move-result v4

    .line 2551
    invoke-static {v4}, Landroid/telephony/DataFailCause;->toString(I)Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    .line 2550
    invoke-virtual {v0, v3}, Lcom/android/internal/telephony/dataconnection/DataConnection;->log(Ljava/lang/String;)V

    .line 2553
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$DcInactiveState;->this$0:Lcom/android/internal/telephony/dataconnection/DataConnection;

    invoke-static {v0}, Lcom/android/internal/telephony/dataconnection/DataConnection;->-$$Nest$fgetmConnectionParams(Lcom/android/internal/telephony/dataconnection/DataConnection;)Lcom/android/internal/telephony/dataconnection/DataConnection$ConnectionParams;

    move-result-object v3

    iget-object v4, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$DcInactiveState;->this$0:Lcom/android/internal/telephony/dataconnection/DataConnection;

    invoke-static {v4}, Lcom/android/internal/telephony/dataconnection/DataConnection;->-$$Nest$fgetmDcFailCause(Lcom/android/internal/telephony/dataconnection/DataConnection;)I

    move-result v4

    iget-object v5, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$DcInactiveState;->this$0:Lcom/android/internal/telephony/dataconnection/DataConnection;

    invoke-static {v5}, Lcom/android/internal/telephony/dataconnection/DataConnection;->-$$Nest$fgetmHandoverFailureMode(Lcom/android/internal/telephony/dataconnection/DataConnection;)I

    move-result v5

    invoke-static {v0, v3, v4, v5, v2}, Lcom/android/internal/telephony/dataconnection/DataConnection;->-$$Nest$mnotifyConnectCompleted(Lcom/android/internal/telephony/dataconnection/DataConnection;Lcom/android/internal/telephony/dataconnection/DataConnection$ConnectionParams;IIZ)V

    .line 2556
    :cond_3
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$DcInactiveState;->this$0:Lcom/android/internal/telephony/dataconnection/DataConnection;

    invoke-static {v0}, Lcom/android/internal/telephony/dataconnection/DataConnection;->-$$Nest$fgetmDisconnectParams(Lcom/android/internal/telephony/dataconnection/DataConnection;)Lcom/android/internal/telephony/dataconnection/DataConnection$DisconnectParams;

    move-result-object v0

    if-eqz v0, :cond_4

    .line 2558
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$DcInactiveState;->this$0:Lcom/android/internal/telephony/dataconnection/DataConnection;

    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "DcInactiveState: enter notifyDisconnectCompleted +ALL failCause="

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v4, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$DcInactiveState;->this$0:Lcom/android/internal/telephony/dataconnection/DataConnection;

    invoke-static {v4}, Lcom/android/internal/telephony/dataconnection/DataConnection;->-$$Nest$fgetmDcFailCause(Lcom/android/internal/telephony/dataconnection/DataConnection;)I

    move-result v4

    .line 2559
    invoke-static {v4}, Landroid/telephony/DataFailCause;->toString(I)Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    .line 2558
    invoke-virtual {v0, v3}, Lcom/android/internal/telephony/dataconnection/DataConnection;->log(Ljava/lang/String;)V

    .line 2561
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$DcInactiveState;->this$0:Lcom/android/internal/telephony/dataconnection/DataConnection;

    invoke-static {v0}, Lcom/android/internal/telephony/dataconnection/DataConnection;->-$$Nest$fgetmDisconnectParams(Lcom/android/internal/telephony/dataconnection/DataConnection;)Lcom/android/internal/telephony/dataconnection/DataConnection$DisconnectParams;

    move-result-object v3

    invoke-static {v0, v3, v2}, Lcom/android/internal/telephony/dataconnection/DataConnection;->-$$Nest$mnotifyDisconnectCompleted(Lcom/android/internal/telephony/dataconnection/DataConnection;Lcom/android/internal/telephony/dataconnection/DataConnection$DisconnectParams;Z)V

    .line 2563
    :cond_4
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$DcInactiveState;->this$0:Lcom/android/internal/telephony/dataconnection/DataConnection;

    invoke-static {v0}, Lcom/android/internal/telephony/dataconnection/DataConnection;->-$$Nest$fgetmDisconnectParams(Lcom/android/internal/telephony/dataconnection/DataConnection;)Lcom/android/internal/telephony/dataconnection/DataConnection$DisconnectParams;

    move-result-object v0

    if-nez v0, :cond_5

    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$DcInactiveState;->this$0:Lcom/android/internal/telephony/dataconnection/DataConnection;

    invoke-static {v0}, Lcom/android/internal/telephony/dataconnection/DataConnection;->-$$Nest$fgetmConnectionParams(Lcom/android/internal/telephony/dataconnection/DataConnection;)Lcom/android/internal/telephony/dataconnection/DataConnection$ConnectionParams;

    move-result-object v0

    if-nez v0, :cond_5

    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$DcInactiveState;->this$0:Lcom/android/internal/telephony/dataconnection/DataConnection;

    invoke-static {v0}, Lcom/android/internal/telephony/dataconnection/DataConnection;->-$$Nest$fgetmDcFailCause(Lcom/android/internal/telephony/dataconnection/DataConnection;)I

    move-result v0

    if-eqz v0, :cond_5

    .line 2566
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$DcInactiveState;->this$0:Lcom/android/internal/telephony/dataconnection/DataConnection;

    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "DcInactiveState: enter notifyAllDisconnectCompleted failCause="

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v3, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$DcInactiveState;->this$0:Lcom/android/internal/telephony/dataconnection/DataConnection;

    invoke-static {v3}, Lcom/android/internal/telephony/dataconnection/DataConnection;->-$$Nest$fgetmDcFailCause(Lcom/android/internal/telephony/dataconnection/DataConnection;)I

    move-result v3

    .line 2567
    invoke-static {v3}, Landroid/telephony/DataFailCause;->toString(I)Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    .line 2566
    invoke-virtual {v0, v2}, Lcom/android/internal/telephony/dataconnection/DataConnection;->log(Ljava/lang/String;)V

    .line 2569
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$DcInactiveState;->this$0:Lcom/android/internal/telephony/dataconnection/DataConnection;

    const v2, 0x4200f

    invoke-static {v0}, Lcom/android/internal/telephony/dataconnection/DataConnection;->-$$Nest$fgetmDcFailCause(Lcom/android/internal/telephony/dataconnection/DataConnection;)I

    move-result v3

    .line 2570
    invoke-static {v3}, Landroid/telephony/DataFailCause;->toString(I)Ljava/lang/String;

    move-result-object v3

    .line 2569
    invoke-static {v0, v1, v2, v3}, Lcom/android/internal/telephony/dataconnection/DataConnection;->-$$Nest$mnotifyAllWithEvent(Lcom/android/internal/telephony/dataconnection/DataConnection;Lcom/android/internal/telephony/dataconnection/ApnContext;ILjava/lang/String;)V

    .line 2574
    :cond_5
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$DcInactiveState;->this$0:Lcom/android/internal/telephony/dataconnection/DataConnection;

    invoke-static {v0}, Lcom/android/internal/telephony/dataconnection/DataConnection;->-$$Nest$fgetmDcController(Lcom/android/internal/telephony/dataconnection/DataConnection;)Lcom/android/internal/telephony/dataconnection/DcController;

    move-result-object v0

    iget-object v1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$DcInactiveState;->this$0:Lcom/android/internal/telephony/dataconnection/DataConnection;

    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/dataconnection/DcController;->removeActiveDcByCid(Lcom/android/internal/telephony/dataconnection/DataConnection;)V

    .line 2580
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$DcInactiveState;->this$0:Lcom/android/internal/telephony/dataconnection/DataConnection;

    invoke-static {v0}, Lcom/android/internal/telephony/dataconnection/DataConnection;->-$$Nest$fgetmApnSetting(Lcom/android/internal/telephony/dataconnection/DataConnection;)Landroid/telephony/data/ApnSetting;

    move-result-object v0

    if-eqz v0, :cond_6

    .line 2581
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$DcInactiveState;->this$0:Lcom/android/internal/telephony/dataconnection/DataConnection;

    invoke-static {v0}, Lcom/android/internal/telephony/dataconnection/DataConnection;->-$$Nest$mnotifyDataConnectionState(Lcom/android/internal/telephony/dataconnection/DataConnection;)V

    .line 2583
    :cond_6
    iget-object p0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$DcInactiveState;->this$0:Lcom/android/internal/telephony/dataconnection/DataConnection;

    invoke-static {p0}, Lcom/android/internal/telephony/dataconnection/DataConnection;->-$$Nest$mclearSettings(Lcom/android/internal/telephony/dataconnection/DataConnection;)V

    return-void
.end method

.method public exit()V
    .locals 0

    return-void
.end method

.method public processMessage(Landroid/os/Message;)Z
    .locals 6

    .line 2592
    iget v0, p1, Landroid/os/Message;->what:I

    const/4 v1, 0x0

    const/4 v2, 0x1

    sparse-switch v0, :sswitch_data_0

    .line 2637
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$DcInactiveState;->this$0:Lcom/android/internal/telephony/dataconnection/DataConnection;

    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "DcInactiveState not handled msg.what="

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object p0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$DcInactiveState;->this$0:Lcom/android/internal/telephony/dataconnection/DataConnection;

    iget p1, p1, Landroid/os/Message;->what:I

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/dataconnection/DataConnection;->getWhatToString(I)Ljava/lang/String;

    move-result-object p0

    invoke-virtual {v2, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-virtual {v0, p0}, Lcom/android/internal/telephony/dataconnection/DataConnection;->log(Ljava/lang/String;)V

    return v1

    .line 2596
    :sswitch_0
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$DcInactiveState;->this$0:Lcom/android/internal/telephony/dataconnection/DataConnection;

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "DcInactiveState: msg.what="

    invoke-virtual {v1, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object p0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$DcInactiveState;->this$0:Lcom/android/internal/telephony/dataconnection/DataConnection;

    iget p1, p1, Landroid/os/Message;->what:I

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/dataconnection/DataConnection;->getWhatToString(I)Ljava/lang/String;

    move-result-object p0

    invoke-virtual {v1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p0, ", ignore we\'re already done"

    invoke-virtual {v1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-virtual {v0, p0}, Lcom/android/internal/telephony/dataconnection/DataConnection;->log(Ljava/lang/String;)V

    return v2

    .line 2632
    :sswitch_1
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$DcInactiveState;->this$0:Lcom/android/internal/telephony/dataconnection/DataConnection;

    const-string v3, "DcInactiveState: msg.what=EVENT_DISCONNECT_ALL"

    invoke-virtual {v0, v3}, Lcom/android/internal/telephony/dataconnection/DataConnection;->log(Ljava/lang/String;)V

    .line 2633
    iget-object p0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$DcInactiveState;->this$0:Lcom/android/internal/telephony/dataconnection/DataConnection;

    iget-object p1, p1, Landroid/os/Message;->obj:Ljava/lang/Object;

    check-cast p1, Lcom/android/internal/telephony/dataconnection/DataConnection$DisconnectParams;

    invoke-static {p0, p1, v1}, Lcom/android/internal/telephony/dataconnection/DataConnection;->-$$Nest$mnotifyDisconnectCompleted(Lcom/android/internal/telephony/dataconnection/DataConnection;Lcom/android/internal/telephony/dataconnection/DataConnection$DisconnectParams;Z)V

    return v2

    .line 2628
    :sswitch_2
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$DcInactiveState;->this$0:Lcom/android/internal/telephony/dataconnection/DataConnection;

    const-string v3, "DcInactiveState: msg.what=EVENT_DISCONNECT"

    invoke-virtual {v0, v3}, Lcom/android/internal/telephony/dataconnection/DataConnection;->log(Ljava/lang/String;)V

    .line 2629
    iget-object p0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$DcInactiveState;->this$0:Lcom/android/internal/telephony/dataconnection/DataConnection;

    iget-object p1, p1, Landroid/os/Message;->obj:Ljava/lang/Object;

    check-cast p1, Lcom/android/internal/telephony/dataconnection/DataConnection$DisconnectParams;

    invoke-static {p0, p1, v1}, Lcom/android/internal/telephony/dataconnection/DataConnection;->-$$Nest$mnotifyDisconnectCompleted(Lcom/android/internal/telephony/dataconnection/DataConnection;Lcom/android/internal/telephony/dataconnection/DataConnection$DisconnectParams;Z)V

    return v2

    .line 2601
    :sswitch_3
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$DcInactiveState;->this$0:Lcom/android/internal/telephony/dataconnection/DataConnection;

    const-string v3, "DcInactiveState: mag.what=EVENT_CONNECT"

    invoke-virtual {v0, v3}, Lcom/android/internal/telephony/dataconnection/DataConnection;->log(Ljava/lang/String;)V

    .line 2602
    iget-object p1, p1, Landroid/os/Message;->obj:Ljava/lang/Object;

    check-cast p1, Lcom/android/internal/telephony/dataconnection/DataConnection$ConnectionParams;

    .line 2604
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$DcInactiveState;->this$0:Lcom/android/internal/telephony/dataconnection/DataConnection;

    invoke-static {v0, p1}, Lcom/android/internal/telephony/dataconnection/DataConnection;->-$$Nest$minitConnection(Lcom/android/internal/telephony/dataconnection/DataConnection;Lcom/android/internal/telephony/dataconnection/DataConnection$ConnectionParams;)Z

    move-result v0

    const/4 v3, -0x1

    if-nez v0, :cond_0

    .line 2605
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$DcInactiveState;->this$0:Lcom/android/internal/telephony/dataconnection/DataConnection;

    const-string v4, "DcInactiveState: msg.what=EVENT_CONNECT initConnection failed"

    invoke-virtual {v0, v4}, Lcom/android/internal/telephony/dataconnection/DataConnection;->log(Ljava/lang/String;)V

    .line 2606
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$DcInactiveState;->this$0:Lcom/android/internal/telephony/dataconnection/DataConnection;

    const v4, 0x10002

    invoke-static {v0, p1, v4, v3, v1}, Lcom/android/internal/telephony/dataconnection/DataConnection;->-$$Nest$mnotifyConnectCompleted(Lcom/android/internal/telephony/dataconnection/DataConnection;Lcom/android/internal/telephony/dataconnection/DataConnection$ConnectionParams;IIZ)V

    .line 2608
    iget-object p0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$DcInactiveState;->this$0:Lcom/android/internal/telephony/dataconnection/DataConnection;

    invoke-static {p0}, Lcom/android/internal/telephony/dataconnection/DataConnection;->-$$Nest$fgetmInactiveState(Lcom/android/internal/telephony/dataconnection/DataConnection;)Lcom/android/internal/telephony/dataconnection/DataConnection$DcInactiveState;

    move-result-object p1

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/StateMachine;->transitionTo(Lcom/android/internal/telephony/IState;)V

    return v2

    .line 2612
    :cond_0
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$DcInactiveState;->this$0:Lcom/android/internal/telephony/dataconnection/DataConnection;

    invoke-static {v0, p1}, Lcom/android/internal/telephony/dataconnection/DataConnection;->-$$Nest$mconnect(Lcom/android/internal/telephony/dataconnection/DataConnection;Lcom/android/internal/telephony/dataconnection/DataConnection$ConnectionParams;)I

    move-result v0

    if-eqz v0, :cond_1

    .line 2614
    iget-object v4, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$DcInactiveState;->this$0:Lcom/android/internal/telephony/dataconnection/DataConnection;

    const-string v5, "DcInactiveState: msg.what=EVENT_CONNECT connect failed"

    invoke-virtual {v4, v5}, Lcom/android/internal/telephony/dataconnection/DataConnection;->log(Ljava/lang/String;)V

    .line 2615
    iget-object v4, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$DcInactiveState;->this$0:Lcom/android/internal/telephony/dataconnection/DataConnection;

    invoke-static {v4, p1, v0, v3, v1}, Lcom/android/internal/telephony/dataconnection/DataConnection;->-$$Nest$mnotifyConnectCompleted(Lcom/android/internal/telephony/dataconnection/DataConnection;Lcom/android/internal/telephony/dataconnection/DataConnection$ConnectionParams;IIZ)V

    .line 2617
    iget-object p0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$DcInactiveState;->this$0:Lcom/android/internal/telephony/dataconnection/DataConnection;

    invoke-static {p0}, Lcom/android/internal/telephony/dataconnection/DataConnection;->-$$Nest$fgetmInactiveState(Lcom/android/internal/telephony/dataconnection/DataConnection;)Lcom/android/internal/telephony/dataconnection/DataConnection$DcInactiveState;

    move-result-object p1

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/StateMachine;->transitionTo(Lcom/android/internal/telephony/IState;)V

    return v2

    .line 2621
    :cond_1
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$DcInactiveState;->this$0:Lcom/android/internal/telephony/dataconnection/DataConnection;

    invoke-static {v0}, Lcom/android/internal/telephony/dataconnection/DataConnection;->-$$Nest$fgetmSubId(Lcom/android/internal/telephony/dataconnection/DataConnection;)I

    move-result v0

    if-ne v0, v3, :cond_2

    .line 2622
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$DcInactiveState;->this$0:Lcom/android/internal/telephony/dataconnection/DataConnection;

    iget p1, p1, Lcom/android/internal/telephony/dataconnection/DataConnection$ConnectionParams;->mSubId:I

    invoke-static {v0, p1}, Lcom/android/internal/telephony/dataconnection/DataConnection;->-$$Nest$fputmSubId(Lcom/android/internal/telephony/dataconnection/DataConnection;I)V

    .line 2625
    :cond_2
    iget-object p0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$DcInactiveState;->this$0:Lcom/android/internal/telephony/dataconnection/DataConnection;

    invoke-static {p0}, Lcom/android/internal/telephony/dataconnection/DataConnection;->-$$Nest$fgetmActivatingState(Lcom/android/internal/telephony/dataconnection/DataConnection;)Lcom/android/internal/telephony/dataconnection/DataConnection$DcActivatingState;

    move-result-object p1

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/StateMachine;->transitionTo(Lcom/android/internal/telephony/IState;)V

    return v2

    :sswitch_data_0
    .sparse-switch
        0x40000 -> :sswitch_3
        0x40004 -> :sswitch_2
        0x40006 -> :sswitch_1
        0x40018 -> :sswitch_0
        0x40019 -> :sswitch_0
    .end sparse-switch
.end method

.method public setEnterNotificationParams(I)V
    .locals 2

    .line 2503
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$DcInactiveState;->this$0:Lcom/android/internal/telephony/dataconnection/DataConnection;

    const/4 v1, 0x0

    invoke-static {v0, v1}, Lcom/android/internal/telephony/dataconnection/DataConnection;->-$$Nest$fputmConnectionParams(Lcom/android/internal/telephony/dataconnection/DataConnection;Lcom/android/internal/telephony/dataconnection/DataConnection$ConnectionParams;)V

    .line 2504
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$DcInactiveState;->this$0:Lcom/android/internal/telephony/dataconnection/DataConnection;

    invoke-static {v0, v1}, Lcom/android/internal/telephony/dataconnection/DataConnection;->-$$Nest$fputmDisconnectParams(Lcom/android/internal/telephony/dataconnection/DataConnection;Lcom/android/internal/telephony/dataconnection/DataConnection$DisconnectParams;)V

    .line 2505
    iget-object p0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$DcInactiveState;->this$0:Lcom/android/internal/telephony/dataconnection/DataConnection;

    invoke-static {p0, p1}, Lcom/android/internal/telephony/dataconnection/DataConnection;->-$$Nest$fputmDcFailCause(Lcom/android/internal/telephony/dataconnection/DataConnection;I)V

    return-void
.end method

.method public setEnterNotificationParams(Lcom/android/internal/telephony/dataconnection/DataConnection$ConnectionParams;II)V
    .locals 2

    .line 2486
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$DcInactiveState;->this$0:Lcom/android/internal/telephony/dataconnection/DataConnection;

    const-string v1, "DcInactiveState: setEnterNotificationParams cp,cause"

    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/dataconnection/DataConnection;->log(Ljava/lang/String;)V

    .line 2487
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$DcInactiveState;->this$0:Lcom/android/internal/telephony/dataconnection/DataConnection;

    invoke-static {v0, p1}, Lcom/android/internal/telephony/dataconnection/DataConnection;->-$$Nest$fputmConnectionParams(Lcom/android/internal/telephony/dataconnection/DataConnection;Lcom/android/internal/telephony/dataconnection/DataConnection$ConnectionParams;)V

    .line 2488
    iget-object p1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$DcInactiveState;->this$0:Lcom/android/internal/telephony/dataconnection/DataConnection;

    const/4 v0, 0x0

    invoke-static {p1, v0}, Lcom/android/internal/telephony/dataconnection/DataConnection;->-$$Nest$fputmDisconnectParams(Lcom/android/internal/telephony/dataconnection/DataConnection;Lcom/android/internal/telephony/dataconnection/DataConnection$DisconnectParams;)V

    .line 2489
    iget-object p1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$DcInactiveState;->this$0:Lcom/android/internal/telephony/dataconnection/DataConnection;

    invoke-static {p1, p2}, Lcom/android/internal/telephony/dataconnection/DataConnection;->-$$Nest$fputmDcFailCause(Lcom/android/internal/telephony/dataconnection/DataConnection;I)V

    .line 2490
    iget-object p0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$DcInactiveState;->this$0:Lcom/android/internal/telephony/dataconnection/DataConnection;

    invoke-static {p0, p3}, Lcom/android/internal/telephony/dataconnection/DataConnection;->-$$Nest$fputmHandoverFailureMode(Lcom/android/internal/telephony/dataconnection/DataConnection;I)V

    return-void
.end method

.method public setEnterNotificationParams(Lcom/android/internal/telephony/dataconnection/DataConnection$DisconnectParams;)V
    .locals 2

    .line 2495
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$DcInactiveState;->this$0:Lcom/android/internal/telephony/dataconnection/DataConnection;

    const-string v1, "DcInactiveState: setEnterNotificationParams dp"

    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/dataconnection/DataConnection;->log(Ljava/lang/String;)V

    .line 2496
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$DcInactiveState;->this$0:Lcom/android/internal/telephony/dataconnection/DataConnection;

    const/4 v1, 0x0

    invoke-static {v0, v1}, Lcom/android/internal/telephony/dataconnection/DataConnection;->-$$Nest$fputmConnectionParams(Lcom/android/internal/telephony/dataconnection/DataConnection;Lcom/android/internal/telephony/dataconnection/DataConnection$ConnectionParams;)V

    .line 2497
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$DcInactiveState;->this$0:Lcom/android/internal/telephony/dataconnection/DataConnection;

    invoke-static {v0, p1}, Lcom/android/internal/telephony/dataconnection/DataConnection;->-$$Nest$fputmDisconnectParams(Lcom/android/internal/telephony/dataconnection/DataConnection;Lcom/android/internal/telephony/dataconnection/DataConnection$DisconnectParams;)V

    .line 2498
    iget-object p0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$DcInactiveState;->this$0:Lcom/android/internal/telephony/dataconnection/DataConnection;

    const/4 p1, 0x0

    invoke-static {p0, p1}, Lcom/android/internal/telephony/dataconnection/DataConnection;->-$$Nest$fputmDcFailCause(Lcom/android/internal/telephony/dataconnection/DataConnection;I)V

    return-void
.end method
