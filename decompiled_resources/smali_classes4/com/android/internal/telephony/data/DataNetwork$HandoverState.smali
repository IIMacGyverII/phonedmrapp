.class public Lcom/android/internal/telephony/data/DataNetwork$HandoverState;
.super Lcom/android/internal/telephony/State;
.source "DataNetwork.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/android/internal/telephony/data/DataNetwork;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x4
    name = "HandoverState"
.end annotation


# instance fields
.field final synthetic this$0:Lcom/android/internal/telephony/data/DataNetwork;


# direct methods
.method public static synthetic $r8$lambda$CZ3BN1LVU1spd2TKn6O-mGa49mk(Lcom/android/internal/telephony/data/DataNetwork$HandoverState;Landroid/telephony/data/DataCallResponse;)Z
    .locals 0

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/DataNetwork$HandoverState;->lambda$shouldDeferDataStateChangedEvent$1(Landroid/telephony/data/DataCallResponse;)Z

    move-result p0

    return p0
.end method

.method public static synthetic $r8$lambda$O-8Ive-khuk6zPbss0WHLtn7UxU(Lcom/android/internal/telephony/data/DataNetwork$HandoverState;JI)V
    .locals 0

    invoke-direct {p0, p1, p2, p3}, Lcom/android/internal/telephony/data/DataNetwork$HandoverState;->lambda$processMessage$0(JI)V

    return-void
.end method

.method protected constructor <init>(Lcom/android/internal/telephony/data/DataNetwork;)V
    .locals 0

    .line 1331
    iput-object p1, p0, Lcom/android/internal/telephony/data/DataNetwork$HandoverState;->this$0:Lcom/android/internal/telephony/data/DataNetwork;

    invoke-direct {p0}, Lcom/android/internal/telephony/State;-><init>()V

    return-void
.end method

.method private synthetic lambda$processMessage$0(JI)V
    .locals 6

    .line 1392
    iget-object v1, p0, Lcom/android/internal/telephony/data/DataNetwork$HandoverState;->this$0:Lcom/android/internal/telephony/data/DataNetwork;

    iget-object v0, v1, Lcom/android/internal/telephony/data/DataNetwork;->mDataNetworkCallback:Lcom/android/internal/telephony/data/DataNetwork$DataNetworkCallback;

    iget v2, v1, Lcom/android/internal/telephony/data/DataNetwork;->mFailCause:I

    move-wide v3, p1

    move v5, p3

    invoke-virtual/range {v0 .. v5}, Lcom/android/internal/telephony/data/DataNetwork$DataNetworkCallback;->onHandoverFailed(Lcom/android/internal/telephony/data/DataNetwork;IJI)V

    return-void
.end method

.method private synthetic lambda$shouldDeferDataStateChangedEvent$1(Landroid/telephony/data/DataCallResponse;)Z
    .locals 1

    .line 1427
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataNetwork$HandoverState;->this$0:Lcom/android/internal/telephony/data/DataNetwork;

    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetwork;->mCid:Landroid/util/SparseIntArray;

    iget p0, p0, Lcom/android/internal/telephony/data/DataNetwork;->mTransport:I

    invoke-virtual {v0, p0}, Landroid/util/SparseIntArray;->get(I)I

    move-result p0

    invoke-virtual {p1}, Landroid/telephony/data/DataCallResponse;->getId()I

    move-result p1

    if-ne p0, p1, :cond_0

    const/4 p0, 0x1

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method private shouldDeferDataStateChangedEvent(Landroid/os/Message;)Z
    .locals 3

    .line 1416
    iget-object p1, p1, Landroid/os/Message;->obj:Ljava/lang/Object;

    check-cast p1, Landroid/os/AsyncResult;

    .line 1417
    iget-object v0, p1, Landroid/os/AsyncResult;->userObj:Ljava/lang/Object;

    check-cast v0, Ljava/lang/Integer;

    invoke-virtual {v0}, Ljava/lang/Integer;->intValue()I

    move-result v0

    .line 1418
    iget-object p1, p1, Landroid/os/AsyncResult;->result:Ljava/lang/Object;

    check-cast p1, Ljava/util/List;

    .line 1419
    iget-object v1, p0, Lcom/android/internal/telephony/data/DataNetwork$HandoverState;->this$0:Lcom/android/internal/telephony/data/DataNetwork;

    iget v2, v1, Lcom/android/internal/telephony/data/DataNetwork;->mTransport:I

    if-eq v0, v2, :cond_0

    .line 1420
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "Dropped unrelated "

    invoke-virtual {p0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-static {v0}, Landroid/telephony/AccessNetworkConstants;->transportTypeToString(I)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v0, " data call list changed event. "

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-virtual {v1, p0}, Lcom/android/internal/telephony/data/DataNetwork;->log(Ljava/lang/String;)V

    const/4 p0, 0x0

    return p0

    .line 1426
    :cond_0
    invoke-interface {p1}, Ljava/util/List;->stream()Ljava/util/stream/Stream;

    move-result-object v0

    new-instance v1, Lcom/android/internal/telephony/data/DataNetwork$HandoverState$$ExternalSyntheticLambda0;

    invoke-direct {v1, p0}, Lcom/android/internal/telephony/data/DataNetwork$HandoverState$$ExternalSyntheticLambda0;-><init>(Lcom/android/internal/telephony/data/DataNetwork$HandoverState;)V

    invoke-interface {v0, v1}, Ljava/util/stream/Stream;->anyMatch(Ljava/util/function/Predicate;)Z

    move-result v0

    if-eqz v0, :cond_1

    .line 1429
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataNetwork$HandoverState;->this$0:Lcom/android/internal/telephony/data/DataNetwork;

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "Deferred the related data call list changed event."

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/data/DataNetwork;->log(Ljava/lang/String;)V

    goto :goto_0

    .line 1431
    :cond_1
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataNetwork$HandoverState;->this$0:Lcom/android/internal/telephony/data/DataNetwork;

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "Dropped unrelated data call list changed event. "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/data/DataNetwork;->log(Ljava/lang/String;)V

    :goto_0
    return v0
.end method


# virtual methods
.method public enter()V
    .locals 4

    .line 1334
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetwork$HandoverState;->this$0:Lcom/android/internal/telephony/data/DataNetwork;

    iget-object v1, v0, Lcom/android/internal/telephony/data/DataNetwork;->mDataConfigManager:Lcom/android/internal/telephony/data/DataConfigManager;

    .line 1335
    invoke-virtual {v1}, Lcom/android/internal/telephony/data/DataConfigManager;->getNetworkHandoverTimeoutMs()I

    move-result v1

    int-to-long v1, v1

    const/16 v3, 0x14

    .line 1334
    invoke-virtual {v0, v3, v1, v2}, Lcom/android/internal/telephony/StateMachine;->sendMessageDelayed(IJ)V

    .line 1336
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataNetwork$HandoverState;->this$0:Lcom/android/internal/telephony/data/DataNetwork;

    invoke-virtual {p0}, Lcom/android/internal/telephony/data/DataNetwork;->notifyPreciseDataConnectionState()V

    return-void
.end method

.method public exit()V
    .locals 1

    .line 1341
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataNetwork$HandoverState;->this$0:Lcom/android/internal/telephony/data/DataNetwork;

    const/16 v0, 0x14

    invoke-static {p0, v0}, Lcom/android/internal/telephony/data/DataNetwork;->access$300(Lcom/android/internal/telephony/data/DataNetwork;I)V

    return-void
.end method

.method public processMessage(Landroid/os/Message;)Z
    .locals 4

    .line 1346
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetwork$HandoverState;->this$0:Lcom/android/internal/telephony/data/DataNetwork;

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

    .line 1347
    iget v0, p1, Landroid/os/Message;->what:I

    const/4 v1, 0x7

    const-string v2, "Defer message "

    if-eq v0, v1, :cond_3

    const/16 v1, 0x8

    if-eq v0, v1, :cond_2

    const/16 v1, 0xd

    if-eq v0, v1, :cond_3

    const/16 v1, 0xf

    if-eq v0, v1, :cond_1

    const/16 v1, 0x11

    if-eq v0, v1, :cond_0

    packed-switch v0, :pswitch_data_0

    const/4 p0, 0x0

    return p0

    .line 1380
    :pswitch_0
    iget-object p1, p0, Lcom/android/internal/telephony/data/DataNetwork$HandoverState;->this$0:Lcom/android/internal/telephony/data/DataNetwork;

    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "Data service did not respond the handover request within "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    sget-object v1, Ljava/util/concurrent/TimeUnit;->MILLISECONDS:Ljava/util/concurrent/TimeUnit;

    iget-object v2, p0, Lcom/android/internal/telephony/data/DataNetwork$HandoverState;->this$0:Lcom/android/internal/telephony/data/DataNetwork;

    iget-object v2, v2, Lcom/android/internal/telephony/data/DataNetwork;->mDataConfigManager:Lcom/android/internal/telephony/data/DataConfigManager;

    .line 1382
    invoke-virtual {v2}, Lcom/android/internal/telephony/data/DataConfigManager;->getNetworkHandoverTimeoutMs()I

    move-result v2

    int-to-long v2, v2

    .line 1381
    invoke-virtual {v1, v2, v3}, Ljava/util/concurrent/TimeUnit;->toSeconds(J)J

    move-result-wide v1

    invoke-virtual {v0, v1, v2}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    const-string v1, " seconds."

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    const-string v1, "1afe68cb-8b41-4964-a737-4f34372429ea"

    .line 1380
    invoke-static {p1, v0, v1}, Lcom/android/internal/telephony/data/DataNetwork;->-$$Nest$mreportAnomaly(Lcom/android/internal/telephony/data/DataNetwork;Ljava/lang/String;Ljava/lang/String;)V

    const-wide/16 v0, -0x1

    const/4 p1, 0x3

    .line 1390
    iget-object v2, p0, Lcom/android/internal/telephony/data/DataNetwork$HandoverState;->this$0:Lcom/android/internal/telephony/data/DataNetwork;

    const v3, 0xffff

    iput v3, v2, Lcom/android/internal/telephony/data/DataNetwork;->mFailCause:I

    .line 1391
    iget-object v2, v2, Lcom/android/internal/telephony/data/DataNetwork;->mDataNetworkCallback:Lcom/android/internal/telephony/data/DataNetwork$DataNetworkCallback;

    new-instance v3, Lcom/android/internal/telephony/data/DataNetwork$HandoverState$$ExternalSyntheticLambda1;

    invoke-direct {v3, p0, v0, v1, p1}, Lcom/android/internal/telephony/data/DataNetwork$HandoverState$$ExternalSyntheticLambda1;-><init>(Lcom/android/internal/telephony/data/DataNetwork$HandoverState;JI)V

    invoke-virtual {v2, v3}, Lcom/android/internal/telephony/data/DataCallback;->invokeFromExecutor(Ljava/lang/Runnable;)V

    .line 1395
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataNetwork$HandoverState;->this$0:Lcom/android/internal/telephony/data/DataNetwork;

    iget-object p1, p0, Lcom/android/internal/telephony/data/DataNetwork;->mConnectedState:Lcom/android/internal/telephony/data/DataNetwork$ConnectedState;

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/StateMachine;->transitionTo(Lcom/android/internal/telephony/IState;)V

    goto :goto_0

    .line 1376
    :cond_0
    iget-object p1, p1, Landroid/os/Message;->obj:Ljava/lang/Object;

    check-cast p1, Landroid/os/AsyncResult;

    .line 1377
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataNetwork$HandoverState;->this$0:Lcom/android/internal/telephony/data/DataNetwork;

    iget-object p1, p1, Landroid/os/AsyncResult;->result:Ljava/lang/Object;

    check-cast p1, Landroid/telephony/PcoData;

    invoke-static {p0, p1}, Lcom/android/internal/telephony/data/DataNetwork;->-$$Nest$monPcoDataReceived(Lcom/android/internal/telephony/data/DataNetwork;Landroid/telephony/PcoData;)V

    goto :goto_0

    .line 1369
    :cond_1
    iget v0, p1, Landroid/os/Message;->arg1:I

    .line 1371
    invoke-virtual {p1}, Landroid/os/Message;->getData()Landroid/os/Bundle;

    move-result-object v1

    const-string v2, "data_call_response"

    invoke-virtual {v1, v2}, Landroid/os/Bundle;->getParcelable(Ljava/lang/String;)Landroid/os/Parcelable;

    move-result-object v1

    check-cast v1, Landroid/telephony/data/DataCallResponse;

    .line 1372
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataNetwork$HandoverState;->this$0:Lcom/android/internal/telephony/data/DataNetwork;

    iget-object p1, p1, Landroid/os/Message;->obj:Ljava/lang/Object;

    check-cast p1, Lcom/android/internal/telephony/data/DataRetryManager$DataHandoverRetryEntry;

    invoke-static {p0, v0, v1, p1}, Lcom/android/internal/telephony/data/DataNetwork;->-$$Nest$monHandoverResponse(Lcom/android/internal/telephony/data/DataNetwork;ILandroid/telephony/data/DataCallResponse;Lcom/android/internal/telephony/data/DataRetryManager$DataHandoverRetryEntry;)V

    goto :goto_0

    .line 1353
    :cond_2
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/DataNetwork$HandoverState;->shouldDeferDataStateChangedEvent(Landroid/os/Message;)Z

    move-result v0

    if-eqz v0, :cond_4

    .line 1354
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetwork$HandoverState;->this$0:Lcom/android/internal/telephony/data/DataNetwork;

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v2, p1, Landroid/os/Message;->what:I

    invoke-static {v2}, Lcom/android/internal/telephony/data/DataNetwork;->eventToString(I)Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/data/DataNetwork;->log(Ljava/lang/String;)V

    .line 1355
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataNetwork$HandoverState;->this$0:Lcom/android/internal/telephony/data/DataNetwork;

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/StateMachine;->deferMessage(Landroid/os/Message;)V

    goto :goto_0

    .line 1365
    :cond_3
    :pswitch_1
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetwork$HandoverState;->this$0:Lcom/android/internal/telephony/data/DataNetwork;

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v2, p1, Landroid/os/Message;->what:I

    invoke-static {v2}, Lcom/android/internal/telephony/data/DataNetwork;->eventToString(I)Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/data/DataNetwork;->log(Ljava/lang/String;)V

    .line 1366
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataNetwork$HandoverState;->this$0:Lcom/android/internal/telephony/data/DataNetwork;

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/StateMachine;->deferMessage(Landroid/os/Message;)V

    :cond_4
    :goto_0
    const/4 p0, 0x1

    return p0

    nop

    :pswitch_data_0
    .packed-switch 0x14
        :pswitch_0
        :pswitch_1
        :pswitch_1
        :pswitch_1
        :pswitch_1
    .end packed-switch
.end method
