.class public Lcom/android/internal/telephony/data/DataNetwork$ConnectedState;
.super Lcom/android/internal/telephony/State;
.source "DataNetwork.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/android/internal/telephony/data/DataNetwork;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x4
    name = "ConnectedState"
.end annotation


# instance fields
.field final synthetic this$0:Lcom/android/internal/telephony/data/DataNetwork;


# direct methods
.method public static synthetic $r8$lambda$kp69Z_WSRxvNLdJr6X8CrLXntOw(Lcom/android/internal/telephony/data/DataNetwork$ConnectedState;)V
    .locals 0

    invoke-direct {p0}, Lcom/android/internal/telephony/data/DataNetwork$ConnectedState;->lambda$enter$0()V

    return-void
.end method

.method public static synthetic $r8$lambda$xc9TRpGgqa3yy_IPyWEAOS2t6OU(Lcom/android/internal/telephony/data/DataNetwork$ConnectedState;)V
    .locals 0

    invoke-direct {p0}, Lcom/android/internal/telephony/data/DataNetwork$ConnectedState;->lambda$enter$1()V

    return-void
.end method

.method protected constructor <init>(Lcom/android/internal/telephony/data/DataNetwork;)V
    .locals 0

    .line 1213
    iput-object p1, p0, Lcom/android/internal/telephony/data/DataNetwork$ConnectedState;->this$0:Lcom/android/internal/telephony/data/DataNetwork;

    invoke-direct {p0}, Lcom/android/internal/telephony/State;-><init>()V

    return-void
.end method

.method private synthetic lambda$enter$0()V
    .locals 1

    .line 1224
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataNetwork$ConnectedState;->this$0:Lcom/android/internal/telephony/data/DataNetwork;

    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetwork;->mDataNetworkCallback:Lcom/android/internal/telephony/data/DataNetwork$DataNetworkCallback;

    invoke-virtual {v0, p0}, Lcom/android/internal/telephony/data/DataNetwork$DataNetworkCallback;->onConnected(Lcom/android/internal/telephony/data/DataNetwork;)V

    return-void
.end method

.method private synthetic lambda$enter$1()V
    .locals 3

    .line 1238
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetwork$ConnectedState;->this$0:Lcom/android/internal/telephony/data/DataNetwork;

    const-string v1, "VCN policy changed."

    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/data/DataNetwork;->log(Ljava/lang/String;)V

    .line 1239
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetwork$ConnectedState;->this$0:Lcom/android/internal/telephony/data/DataNetwork;

    iget-object v1, v0, Lcom/android/internal/telephony/data/DataNetwork;->mVcnManager:Landroid/net/vcn/VcnManager;

    iget-object v2, v0, Lcom/android/internal/telephony/data/DataNetwork;->mNetworkCapabilities:Landroid/net/NetworkCapabilities;

    invoke-static {v0}, Lcom/android/internal/telephony/data/DataNetwork;->-$$Nest$fgetmLinkProperties(Lcom/android/internal/telephony/data/DataNetwork;)Landroid/net/LinkProperties;

    move-result-object v0

    invoke-virtual {v1, v2, v0}, Landroid/net/vcn/VcnManager;->applyVcnNetworkPolicy(Landroid/net/NetworkCapabilities;Landroid/net/LinkProperties;)Landroid/net/vcn/VcnNetworkPolicyResult;

    move-result-object v0

    .line 1240
    invoke-virtual {v0}, Landroid/net/vcn/VcnNetworkPolicyResult;->isTeardownRequested()Z

    move-result v0

    if-eqz v0, :cond_0

    .line 1241
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataNetwork$ConnectedState;->this$0:Lcom/android/internal/telephony/data/DataNetwork;

    const/16 v0, 0xf

    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/data/DataNetwork;->tearDown(I)V

    goto :goto_0

    .line 1243
    :cond_0
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataNetwork$ConnectedState;->this$0:Lcom/android/internal/telephony/data/DataNetwork;

    invoke-virtual {p0}, Lcom/android/internal/telephony/data/DataNetwork;->updateNetworkCapabilities()V

    :goto_0
    return-void
.end method


# virtual methods
.method public enter()V
    .locals 7

    .line 1218
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetwork$ConnectedState;->this$0:Lcom/android/internal/telephony/data/DataNetwork;

    invoke-static {v0}, Lcom/android/internal/telephony/data/DataNetwork;->-$$Nest$fgetmEverConnected(Lcom/android/internal/telephony/data/DataNetwork;)Z

    move-result v0

    if-nez v0, :cond_1

    .line 1220
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetwork$ConnectedState;->this$0:Lcom/android/internal/telephony/data/DataNetwork;

    const-string v1, "network connected."

    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/data/DataNetwork;->log(Ljava/lang/String;)V

    .line 1221
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetwork$ConnectedState;->this$0:Lcom/android/internal/telephony/data/DataNetwork;

    const/4 v1, 0x1

    invoke-static {v0, v1}, Lcom/android/internal/telephony/data/DataNetwork;->-$$Nest$fputmEverConnected(Lcom/android/internal/telephony/data/DataNetwork;Z)V

    .line 1222
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetwork$ConnectedState;->this$0:Lcom/android/internal/telephony/data/DataNetwork;

    iget-object v0, v0, Lcom/android/internal/telephony/data/DataNetwork;->mNetworkAgent:Lcom/android/internal/telephony/data/TelephonyNetworkAgent;

    invoke-virtual {v0}, Landroid/net/NetworkAgent;->markConnected()V

    .line 1223
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetwork$ConnectedState;->this$0:Lcom/android/internal/telephony/data/DataNetwork;

    iget-object v0, v0, Lcom/android/internal/telephony/data/DataNetwork;->mDataNetworkCallback:Lcom/android/internal/telephony/data/DataNetwork$DataNetworkCallback;

    new-instance v2, Lcom/android/internal/telephony/data/DataNetwork$ConnectedState$$ExternalSyntheticLambda0;

    invoke-direct {v2, p0}, Lcom/android/internal/telephony/data/DataNetwork$ConnectedState$$ExternalSyntheticLambda0;-><init>(Lcom/android/internal/telephony/data/DataNetwork$ConnectedState;)V

    invoke-virtual {v0, v2}, Lcom/android/internal/telephony/data/DataCallback;->invokeFromExecutor(Ljava/lang/Runnable;)V

    .line 1226
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetwork$ConnectedState;->this$0:Lcom/android/internal/telephony/data/DataNetwork;

    new-instance v2, Lcom/android/internal/telephony/data/QosCallbackTracker;

    iget-object v3, p0, Lcom/android/internal/telephony/data/DataNetwork$ConnectedState;->this$0:Lcom/android/internal/telephony/data/DataNetwork;

    iget-object v4, v3, Lcom/android/internal/telephony/data/DataNetwork;->mNetworkAgent:Lcom/android/internal/telephony/data/TelephonyNetworkAgent;

    iget-object v3, v3, Lcom/android/internal/telephony/data/DataNetwork;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-direct {v2, v4, v3}, Lcom/android/internal/telephony/data/QosCallbackTracker;-><init>(Lcom/android/internal/telephony/data/NotifyQosSessionInterface;Lcom/android/internal/telephony/Phone;)V

    invoke-static {v0, v2}, Lcom/android/internal/telephony/data/DataNetwork;->-$$Nest$fputmQosCallbackTracker(Lcom/android/internal/telephony/data/DataNetwork;Lcom/android/internal/telephony/data/QosCallbackTracker;)V

    .line 1227
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetwork$ConnectedState;->this$0:Lcom/android/internal/telephony/data/DataNetwork;

    invoke-static {v0}, Lcom/android/internal/telephony/data/DataNetwork;->-$$Nest$fgetmQosCallbackTracker(Lcom/android/internal/telephony/data/DataNetwork;)Lcom/android/internal/telephony/data/QosCallbackTracker;

    move-result-object v0

    iget-object v2, p0, Lcom/android/internal/telephony/data/DataNetwork$ConnectedState;->this$0:Lcom/android/internal/telephony/data/DataNetwork;

    invoke-static {v2}, Lcom/android/internal/telephony/data/DataNetwork;->-$$Nest$fgetmQosBearerSessions(Lcom/android/internal/telephony/data/DataNetwork;)Ljava/util/List;

    move-result-object v2

    invoke-virtual {v0, v2}, Lcom/android/internal/telephony/data/QosCallbackTracker;->updateSessions(Ljava/util/List;)V

    .line 1228
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetwork$ConnectedState;->this$0:Lcom/android/internal/telephony/data/DataNetwork;

    new-instance v2, Lcom/android/internal/telephony/data/KeepaliveTracker;

    iget-object v3, p0, Lcom/android/internal/telephony/data/DataNetwork$ConnectedState;->this$0:Lcom/android/internal/telephony/data/DataNetwork;

    iget-object v4, v3, Lcom/android/internal/telephony/data/DataNetwork;->mPhone:Lcom/android/internal/telephony/Phone;

    .line 1229
    invoke-virtual {v3}, Lcom/android/internal/telephony/StateMachine;->getHandler()Landroid/os/Handler;

    move-result-object v3

    invoke-virtual {v3}, Landroid/os/Handler;->getLooper()Landroid/os/Looper;

    move-result-object v3

    iget-object v5, p0, Lcom/android/internal/telephony/data/DataNetwork$ConnectedState;->this$0:Lcom/android/internal/telephony/data/DataNetwork;

    iget-object v6, v5, Lcom/android/internal/telephony/data/DataNetwork;->mNetworkAgent:Lcom/android/internal/telephony/data/TelephonyNetworkAgent;

    invoke-direct {v2, v4, v3, v5, v6}, Lcom/android/internal/telephony/data/KeepaliveTracker;-><init>(Lcom/android/internal/telephony/Phone;Landroid/os/Looper;Lcom/android/internal/telephony/data/DataNetwork;Lcom/android/internal/telephony/data/TelephonyNetworkAgent;)V

    invoke-static {v0, v2}, Lcom/android/internal/telephony/data/DataNetwork;->-$$Nest$fputmKeepaliveTracker(Lcom/android/internal/telephony/data/DataNetwork;Lcom/android/internal/telephony/data/KeepaliveTracker;)V

    .line 1230
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetwork$ConnectedState;->this$0:Lcom/android/internal/telephony/data/DataNetwork;

    iget v2, v0, Lcom/android/internal/telephony/data/DataNetwork;->mTransport:I

    if-ne v2, v1, :cond_0

    .line 1231
    invoke-static {v0}, Lcom/android/internal/telephony/data/DataNetwork;->-$$Nest$mregisterForWwanEvents(Lcom/android/internal/telephony/data/DataNetwork;)V

    .line 1236
    :cond_0
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetwork$ConnectedState;->this$0:Lcom/android/internal/telephony/data/DataNetwork;

    iget-object v1, v0, Lcom/android/internal/telephony/data/DataNetwork;->mVcnManager:Landroid/net/vcn/VcnManager;

    if-eqz v1, :cond_1

    .line 1237
    new-instance v1, Lcom/android/internal/telephony/data/DataNetwork$ConnectedState$$ExternalSyntheticLambda1;

    invoke-direct {v1, p0}, Lcom/android/internal/telephony/data/DataNetwork$ConnectedState$$ExternalSyntheticLambda1;-><init>(Lcom/android/internal/telephony/data/DataNetwork$ConnectedState;)V

    invoke-static {v0, v1}, Lcom/android/internal/telephony/data/DataNetwork;->-$$Nest$fputmVcnPolicyChangeListener(Lcom/android/internal/telephony/data/DataNetwork;Landroid/net/vcn/VcnManager$VcnNetworkPolicyChangeListener;)V

    .line 1246
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetwork$ConnectedState;->this$0:Lcom/android/internal/telephony/data/DataNetwork;

    iget-object v1, v0, Lcom/android/internal/telephony/data/DataNetwork;->mVcnManager:Landroid/net/vcn/VcnManager;

    .line 1247
    invoke-virtual {v0}, Lcom/android/internal/telephony/StateMachine;->getHandler()Landroid/os/Handler;

    move-result-object v0

    invoke-static {v0}, Ljava/util/Objects;->requireNonNull(Ljava/lang/Object;)Ljava/lang/Object;

    new-instance v2, Landroidx/emoji2/text/ConcurrencyHelpers$$ExternalSyntheticLambda1;

    invoke-direct {v2, v0}, Landroidx/emoji2/text/ConcurrencyHelpers$$ExternalSyntheticLambda1;-><init>(Landroid/os/Handler;)V

    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetwork$ConnectedState;->this$0:Lcom/android/internal/telephony/data/DataNetwork;

    invoke-static {v0}, Lcom/android/internal/telephony/data/DataNetwork;->-$$Nest$fgetmVcnPolicyChangeListener(Lcom/android/internal/telephony/data/DataNetwork;)Landroid/net/vcn/VcnManager$VcnNetworkPolicyChangeListener;

    move-result-object v0

    .line 1246
    invoke-virtual {v1, v2, v0}, Landroid/net/vcn/VcnManager;->addVcnNetworkPolicyChangeListener(Ljava/util/concurrent/Executor;Landroid/net/vcn/VcnManager$VcnNetworkPolicyChangeListener;)V

    .line 1251
    :cond_1
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetwork$ConnectedState;->this$0:Lcom/android/internal/telephony/data/DataNetwork;

    invoke-virtual {v0}, Lcom/android/internal/telephony/data/DataNetwork;->notifyPreciseDataConnectionState()V

    .line 1252
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataNetwork$ConnectedState;->this$0:Lcom/android/internal/telephony/data/DataNetwork;

    invoke-virtual {p0}, Lcom/android/internal/telephony/data/DataNetwork;->updateSuspendState()V

    return-void
.end method

.method public processMessage(Landroid/os/Message;)Z
    .locals 5

    .line 1257
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetwork$ConnectedState;->this$0:Lcom/android/internal/telephony/data/DataNetwork;

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

    .line 1258
    iget v0, p1, Landroid/os/Message;->what:I

    const/4 v1, 0x1

    const/4 v2, 0x7

    packed-switch v0, :pswitch_data_0

    :pswitch_0
    const/4 p0, 0x0

    return p0

    .line 1316
    :pswitch_1
    iget-object p1, p0, Lcom/android/internal/telephony/data/DataNetwork$ConnectedState;->this$0:Lcom/android/internal/telephony/data/DataNetwork;

    invoke-virtual {p1}, Lcom/android/internal/telephony/data/DataNetwork;->updateSuspendState()V

    .line 1317
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataNetwork$ConnectedState;->this$0:Lcom/android/internal/telephony/data/DataNetwork;

    invoke-virtual {p0}, Lcom/android/internal/telephony/data/DataNetwork;->updateNetworkCapabilities()V

    goto/16 :goto_0

    .line 1310
    :pswitch_2
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetwork$ConnectedState;->this$0:Lcom/android/internal/telephony/data/DataNetwork;

    iget-object v3, v0, Lcom/android/internal/telephony/data/DataNetwork;->mDisconnectingState:Lcom/android/internal/telephony/data/DataNetwork$DisconnectingState;

    invoke-virtual {v0, v3}, Lcom/android/internal/telephony/StateMachine;->transitionTo(Lcom/android/internal/telephony/IState;)V

    .line 1311
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataNetwork$ConnectedState;->this$0:Lcom/android/internal/telephony/data/DataNetwork;

    iget v0, p1, Landroid/os/Message;->arg1:I

    iget p1, p1, Landroid/os/Message;->arg2:I

    int-to-long v3, p1

    invoke-virtual {p0, v2, v0, v3, v4}, Lcom/android/internal/telephony/StateMachine;->sendMessageDelayed(IIJ)V

    goto/16 :goto_0

    .line 1306
    :pswitch_3
    iget p1, p1, Landroid/os/Message;->arg1:I

    .line 1307
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataNetwork$ConnectedState;->this$0:Lcom/android/internal/telephony/data/DataNetwork;

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/data/DataNetwork;->onDeactivateResponse(I)V

    goto/16 :goto_0

    .line 1302
    :pswitch_4
    iget-object p1, p1, Landroid/os/Message;->obj:Ljava/lang/Object;

    check-cast p1, Landroid/os/AsyncResult;

    .line 1303
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataNetwork$ConnectedState;->this$0:Lcom/android/internal/telephony/data/DataNetwork;

    iget-object p1, p1, Landroid/os/AsyncResult;->result:Ljava/lang/Object;

    check-cast p1, Landroid/telephony/PcoData;

    invoke-static {p0, p1}, Lcom/android/internal/telephony/data/DataNetwork;->-$$Nest$monPcoDataReceived(Lcom/android/internal/telephony/data/DataNetwork;Landroid/telephony/PcoData;)V

    goto/16 :goto_0

    .line 1299
    :pswitch_5
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataNetwork$ConnectedState;->this$0:Lcom/android/internal/telephony/data/DataNetwork;

    invoke-static {p0}, Lcom/android/internal/telephony/data/DataNetwork;->-$$Nest$mupdateMeteredAndCongested(Lcom/android/internal/telephony/data/DataNetwork;)V

    goto/16 :goto_0

    .line 1296
    :pswitch_6
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataNetwork$ConnectedState;->this$0:Lcom/android/internal/telephony/data/DataNetwork;

    iget v0, p1, Landroid/os/Message;->arg1:I

    iget-object p1, p1, Landroid/os/Message;->obj:Ljava/lang/Object;

    check-cast p1, Lcom/android/internal/telephony/data/DataRetryManager$DataHandoverRetryEntry;

    invoke-static {p0, v0, p1}, Lcom/android/internal/telephony/data/DataNetwork;->-$$Nest$monStartHandover(Lcom/android/internal/telephony/data/DataNetwork;ILcom/android/internal/telephony/data/DataRetryManager$DataHandoverRetryEntry;)V

    goto/16 :goto_0

    .line 1293
    :pswitch_7
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataNetwork$ConnectedState;->this$0:Lcom/android/internal/telephony/data/DataNetwork;

    invoke-static {p0}, Lcom/android/internal/telephony/data/DataNetwork;->-$$Nest$monDisplayInfoChanged(Lcom/android/internal/telephony/data/DataNetwork;)V

    goto/16 :goto_0

    .line 1284
    :pswitch_8
    iget-object p1, p1, Landroid/os/Message;->obj:Ljava/lang/Object;

    check-cast p1, Landroid/os/AsyncResult;

    .line 1285
    iget-object v0, p1, Landroid/os/AsyncResult;->exception:Ljava/lang/Throwable;

    if-eqz v0, :cond_0

    .line 1286
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataNetwork$ConnectedState;->this$0:Lcom/android/internal/telephony/data/DataNetwork;

    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "EVENT_BANDWIDTH_ESTIMATE_FROM_MODEM_CHANGED: error ignoring, e="

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object p1, p1, Landroid/os/AsyncResult;->exception:Ljava/lang/Throwable;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/data/DataNetwork;->log(Ljava/lang/String;)V

    goto :goto_0

    .line 1290
    :cond_0
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataNetwork$ConnectedState;->this$0:Lcom/android/internal/telephony/data/DataNetwork;

    iget-object p1, p1, Landroid/os/AsyncResult;->result:Ljava/lang/Object;

    check-cast p1, Ljava/util/List;

    invoke-static {p0, p1}, Lcom/android/internal/telephony/data/DataNetwork;->-$$Nest$monBandwidthUpdatedFromModem(Lcom/android/internal/telephony/data/DataNetwork;Ljava/util/List;)V

    goto :goto_0

    .line 1260
    :pswitch_9
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetwork$ConnectedState;->this$0:Lcom/android/internal/telephony/data/DataNetwork;

    iget-boolean v3, v0, Lcom/android/internal/telephony/data/DataNetwork;->mInvokedDataDeactivation:Z

    if-eqz v3, :cond_1

    const-string p0, "Ignore tear down request because network is being torn down."

    .line 1261
    invoke-virtual {v0, p0}, Lcom/android/internal/telephony/data/DataNetwork;->log(Ljava/lang/String;)V

    goto :goto_0

    .line 1265
    :cond_1
    iget p1, p1, Landroid/os/Message;->arg1:I

    if-eq p1, v1, :cond_2

    .line 1272
    invoke-virtual {v0}, Lcom/android/internal/telephony/data/DataNetwork;->shouldDelayImsTearDown()Z

    move-result v0

    if-eqz v0, :cond_2

    .line 1273
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataNetwork$ConnectedState;->this$0:Lcom/android/internal/telephony/data/DataNetwork;

    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "Delay IMS tear down until call ends. reason="

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 1274
    invoke-static {p1}, Lcom/android/internal/telephony/data/DataNetwork;->tearDownReasonToString(I)Ljava/lang/String;

    move-result-object p1

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    .line 1273
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/data/DataNetwork;->logl(Ljava/lang/String;)V

    goto :goto_0

    .line 1278
    :cond_2
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetwork$ConnectedState;->this$0:Lcom/android/internal/telephony/data/DataNetwork;

    invoke-static {v0, v2}, Lcom/android/internal/telephony/data/DataNetwork;->access$100(Lcom/android/internal/telephony/data/DataNetwork;I)V

    .line 1279
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetwork$ConnectedState;->this$0:Lcom/android/internal/telephony/data/DataNetwork;

    invoke-static {v0, v2}, Lcom/android/internal/telephony/data/DataNetwork;->access$200(Lcom/android/internal/telephony/data/DataNetwork;I)V

    .line 1280
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetwork$ConnectedState;->this$0:Lcom/android/internal/telephony/data/DataNetwork;

    iget-object v2, v0, Lcom/android/internal/telephony/data/DataNetwork;->mDisconnectingState:Lcom/android/internal/telephony/data/DataNetwork$DisconnectingState;

    invoke-virtual {v0, v2}, Lcom/android/internal/telephony/StateMachine;->transitionTo(Lcom/android/internal/telephony/IState;)V

    .line 1281
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataNetwork$ConnectedState;->this$0:Lcom/android/internal/telephony/data/DataNetwork;

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/data/DataNetwork;->onTearDown(I)V

    :goto_0
    return v1

    :pswitch_data_0
    .packed-switch 0x7
        :pswitch_9
        :pswitch_0
        :pswitch_0
        :pswitch_0
        :pswitch_8
        :pswitch_0
        :pswitch_7
        :pswitch_6
        :pswitch_0
        :pswitch_5
        :pswitch_4
        :pswitch_0
        :pswitch_3
        :pswitch_0
        :pswitch_2
        :pswitch_1
        :pswitch_1
        :pswitch_1
    .end packed-switch
.end method
