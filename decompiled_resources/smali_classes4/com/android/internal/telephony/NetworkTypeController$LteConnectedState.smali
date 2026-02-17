.class final Lcom/android/internal/telephony/NetworkTypeController$LteConnectedState;
.super Lcom/android/internal/telephony/State;
.source "NetworkTypeController.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/android/internal/telephony/NetworkTypeController;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x12
    name = "LteConnectedState"
.end annotation


# instance fields
.field final synthetic this$0:Lcom/android/internal/telephony/NetworkTypeController;


# direct methods
.method private constructor <init>(Lcom/android/internal/telephony/NetworkTypeController;)V
    .locals 0

    .line 837
    iput-object p1, p0, Lcom/android/internal/telephony/NetworkTypeController$LteConnectedState;->this$0:Lcom/android/internal/telephony/NetworkTypeController;

    invoke-direct {p0}, Lcom/android/internal/telephony/State;-><init>()V

    return-void
.end method

.method synthetic constructor <init>(Lcom/android/internal/telephony/NetworkTypeController;Lcom/android/internal/telephony/NetworkTypeController$LteConnectedState-IA;)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/NetworkTypeController$LteConnectedState;-><init>(Lcom/android/internal/telephony/NetworkTypeController;)V

    return-void
.end method


# virtual methods
.method public enter()V
    .locals 2

    .line 840
    iget-object v0, p0, Lcom/android/internal/telephony/NetworkTypeController$LteConnectedState;->this$0:Lcom/android/internal/telephony/NetworkTypeController;

    const-string v1, "Entering LteConnectedState"

    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/NetworkTypeController;->log(Ljava/lang/String;)V

    .line 841
    iget-object v0, p0, Lcom/android/internal/telephony/NetworkTypeController$LteConnectedState;->this$0:Lcom/android/internal/telephony/NetworkTypeController;

    invoke-static {v0}, Lcom/android/internal/telephony/NetworkTypeController;->-$$Nest$mupdateTimers(Lcom/android/internal/telephony/NetworkTypeController;)V

    .line 842
    iget-object v0, p0, Lcom/android/internal/telephony/NetworkTypeController$LteConnectedState;->this$0:Lcom/android/internal/telephony/NetworkTypeController;

    invoke-virtual {v0}, Lcom/android/internal/telephony/NetworkTypeController;->updateOverrideNetworkType()V

    .line 843
    iget-object v0, p0, Lcom/android/internal/telephony/NetworkTypeController$LteConnectedState;->this$0:Lcom/android/internal/telephony/NetworkTypeController;

    invoke-static {v0}, Lcom/android/internal/telephony/NetworkTypeController;->-$$Nest$fgetmIsPrimaryTimerActive(Lcom/android/internal/telephony/NetworkTypeController;)Z

    move-result v0

    if-nez v0, :cond_0

    iget-object v0, p0, Lcom/android/internal/telephony/NetworkTypeController$LteConnectedState;->this$0:Lcom/android/internal/telephony/NetworkTypeController;

    invoke-static {v0}, Lcom/android/internal/telephony/NetworkTypeController;->-$$Nest$fgetmIsSecondaryTimerActive(Lcom/android/internal/telephony/NetworkTypeController;)Z

    move-result v0

    if-nez v0, :cond_0

    .line 844
    iget-object v0, p0, Lcom/android/internal/telephony/NetworkTypeController$LteConnectedState;->this$0:Lcom/android/internal/telephony/NetworkTypeController;

    invoke-virtual {p0}, Lcom/android/internal/telephony/NetworkTypeController$LteConnectedState;->getName()Ljava/lang/String;

    move-result-object p0

    invoke-static {v0, p0}, Lcom/android/internal/telephony/NetworkTypeController;->-$$Nest$fputmPreviousState(Lcom/android/internal/telephony/NetworkTypeController;Ljava/lang/String;)V

    :cond_0
    return-void
.end method

.method public getName()Ljava/lang/String;
    .locals 0

    const-string p0, "not_restricted_rrc_con"

    return-object p0
.end method

.method public processMessage(Landroid/os/Message;)Z
    .locals 4

    .line 850
    iget-object v0, p0, Lcom/android/internal/telephony/NetworkTypeController$LteConnectedState;->this$0:Lcom/android/internal/telephony/NetworkTypeController;

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "LteConnectedState: process "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v2, p0, Lcom/android/internal/telephony/NetworkTypeController$LteConnectedState;->this$0:Lcom/android/internal/telephony/NetworkTypeController;

    iget v3, p1, Landroid/os/Message;->what:I

    invoke-static {v2, v3}, Lcom/android/internal/telephony/NetworkTypeController;->-$$Nest$mgetEventName(Lcom/android/internal/telephony/NetworkTypeController;I)Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/NetworkTypeController;->log(Ljava/lang/String;)V

    .line 851
    iget-object v0, p0, Lcom/android/internal/telephony/NetworkTypeController$LteConnectedState;->this$0:Lcom/android/internal/telephony/NetworkTypeController;

    invoke-static {v0}, Lcom/android/internal/telephony/NetworkTypeController;->-$$Nest$mupdateTimers(Lcom/android/internal/telephony/NetworkTypeController;)V

    .line 852
    iget v0, p1, Landroid/os/Message;->what:I

    const/4 v1, 0x2

    if-eq v0, v1, :cond_7

    const/4 v1, 0x3

    if-eq v0, v1, :cond_5

    const/4 v2, 0x4

    if-eq v0, v2, :cond_a

    const/4 v2, 0x5

    const-string v3, "NR state changed. Sending EVENT_NR_STATE_CHANGED"

    if-eq v0, v2, :cond_3

    const/16 p1, 0xd

    if-eq v0, p1, :cond_0

    const/4 p0, 0x0

    return p0

    .line 872
    :cond_0
    iget-object p1, p0, Lcom/android/internal/telephony/NetworkTypeController$LteConnectedState;->this$0:Lcom/android/internal/telephony/NetworkTypeController;

    invoke-static {p1}, Lcom/android/internal/telephony/NetworkTypeController;->-$$Nest$misUsingPhysicalChannelConfigForRrcDetection(Lcom/android/internal/telephony/NetworkTypeController;)Z

    move-result p1

    if-eqz p1, :cond_2

    .line 873
    iget-object p1, p0, Lcom/android/internal/telephony/NetworkTypeController$LteConnectedState;->this$0:Lcom/android/internal/telephony/NetworkTypeController;

    invoke-static {p1}, Lcom/android/internal/telephony/NetworkTypeController;->-$$Nest$mgetPhysicalLinkStatusFromPhysicalChannelConfig(Lcom/android/internal/telephony/NetworkTypeController;)I

    move-result v0

    invoke-static {p1, v0}, Lcom/android/internal/telephony/NetworkTypeController;->-$$Nest$fputmPhysicalLinkStatus(Lcom/android/internal/telephony/NetworkTypeController;I)V

    .line 874
    iget-object p1, p0, Lcom/android/internal/telephony/NetworkTypeController$LteConnectedState;->this$0:Lcom/android/internal/telephony/NetworkTypeController;

    invoke-static {p1}, Lcom/android/internal/telephony/NetworkTypeController;->-$$Nest$misNrNotRestricted(Lcom/android/internal/telephony/NetworkTypeController;)Z

    move-result p1

    if-eqz p1, :cond_1

    .line 876
    iget-object p1, p0, Lcom/android/internal/telephony/NetworkTypeController$LteConnectedState;->this$0:Lcom/android/internal/telephony/NetworkTypeController;

    invoke-static {p1}, Lcom/android/internal/telephony/NetworkTypeController;->-$$Nest$misPhysicalLinkActive(Lcom/android/internal/telephony/NetworkTypeController;)Z

    move-result p1

    if-nez p1, :cond_2

    .line 877
    iget-object p1, p0, Lcom/android/internal/telephony/NetworkTypeController$LteConnectedState;->this$0:Lcom/android/internal/telephony/NetworkTypeController;

    invoke-static {p1}, Lcom/android/internal/telephony/NetworkTypeController;->-$$Nest$fgetmIdleState(Lcom/android/internal/telephony/NetworkTypeController;)Lcom/android/internal/telephony/NetworkTypeController$IdleState;

    move-result-object v0

    invoke-static {p1, v0}, Lcom/android/internal/telephony/NetworkTypeController;->-$$Nest$mtransitionWithTimerTo(Lcom/android/internal/telephony/NetworkTypeController;Lcom/android/internal/telephony/IState;)V

    goto/16 :goto_0

    .line 881
    :cond_1
    iget-object p1, p0, Lcom/android/internal/telephony/NetworkTypeController$LteConnectedState;->this$0:Lcom/android/internal/telephony/NetworkTypeController;

    invoke-virtual {p1, v3}, Lcom/android/internal/telephony/NetworkTypeController;->log(Ljava/lang/String;)V

    .line 882
    iget-object p1, p0, Lcom/android/internal/telephony/NetworkTypeController$LteConnectedState;->this$0:Lcom/android/internal/telephony/NetworkTypeController;

    invoke-virtual {p1, v1}, Lcom/android/internal/telephony/StateMachine;->sendMessage(I)V

    .line 886
    :cond_2
    iget-object p1, p0, Lcom/android/internal/telephony/NetworkTypeController$LteConnectedState;->this$0:Lcom/android/internal/telephony/NetworkTypeController;

    invoke-virtual {p1}, Lcom/android/internal/telephony/NetworkTypeController;->updateOverrideNetworkType()V

    goto/16 :goto_0

    .line 889
    :cond_3
    iget-object p1, p1, Landroid/os/Message;->obj:Ljava/lang/Object;

    check-cast p1, Landroid/os/AsyncResult;

    .line 890
    iget-object v0, p0, Lcom/android/internal/telephony/NetworkTypeController$LteConnectedState;->this$0:Lcom/android/internal/telephony/NetworkTypeController;

    iget-object p1, p1, Landroid/os/AsyncResult;->result:Ljava/lang/Object;

    check-cast p1, Ljava/lang/Integer;

    invoke-virtual {p1}, Ljava/lang/Integer;->intValue()I

    move-result p1

    invoke-static {v0, p1}, Lcom/android/internal/telephony/NetworkTypeController;->-$$Nest$fputmPhysicalLinkStatus(Lcom/android/internal/telephony/NetworkTypeController;I)V

    .line 891
    iget-object p1, p0, Lcom/android/internal/telephony/NetworkTypeController$LteConnectedState;->this$0:Lcom/android/internal/telephony/NetworkTypeController;

    invoke-static {p1}, Lcom/android/internal/telephony/NetworkTypeController;->-$$Nest$misNrNotRestricted(Lcom/android/internal/telephony/NetworkTypeController;)Z

    move-result p1

    if-eqz p1, :cond_4

    .line 893
    iget-object p1, p0, Lcom/android/internal/telephony/NetworkTypeController$LteConnectedState;->this$0:Lcom/android/internal/telephony/NetworkTypeController;

    invoke-static {p1}, Lcom/android/internal/telephony/NetworkTypeController;->-$$Nest$misPhysicalLinkActive(Lcom/android/internal/telephony/NetworkTypeController;)Z

    move-result p1

    if-nez p1, :cond_a

    .line 894
    iget-object p1, p0, Lcom/android/internal/telephony/NetworkTypeController$LteConnectedState;->this$0:Lcom/android/internal/telephony/NetworkTypeController;

    invoke-static {p1}, Lcom/android/internal/telephony/NetworkTypeController;->-$$Nest$fgetmIdleState(Lcom/android/internal/telephony/NetworkTypeController;)Lcom/android/internal/telephony/NetworkTypeController$IdleState;

    move-result-object v0

    invoke-static {p1, v0}, Lcom/android/internal/telephony/NetworkTypeController;->-$$Nest$mtransitionWithTimerTo(Lcom/android/internal/telephony/NetworkTypeController;Lcom/android/internal/telephony/IState;)V

    goto :goto_0

    .line 897
    :cond_4
    iget-object p1, p0, Lcom/android/internal/telephony/NetworkTypeController$LteConnectedState;->this$0:Lcom/android/internal/telephony/NetworkTypeController;

    invoke-virtual {p1, v3}, Lcom/android/internal/telephony/NetworkTypeController;->log(Ljava/lang/String;)V

    .line 898
    iget-object p1, p0, Lcom/android/internal/telephony/NetworkTypeController$LteConnectedState;->this$0:Lcom/android/internal/telephony/NetworkTypeController;

    invoke-virtual {p1, v1}, Lcom/android/internal/telephony/StateMachine;->sendMessage(I)V

    goto :goto_0

    .line 862
    :cond_5
    iget-object p1, p0, Lcom/android/internal/telephony/NetworkTypeController$LteConnectedState;->this$0:Lcom/android/internal/telephony/NetworkTypeController;

    invoke-static {p1}, Lcom/android/internal/telephony/NetworkTypeController;->-$$Nest$misNrConnected(Lcom/android/internal/telephony/NetworkTypeController;)Z

    move-result p1

    if-eqz p1, :cond_6

    .line 863
    iget-object p1, p0, Lcom/android/internal/telephony/NetworkTypeController$LteConnectedState;->this$0:Lcom/android/internal/telephony/NetworkTypeController;

    invoke-static {p1}, Lcom/android/internal/telephony/NetworkTypeController;->-$$Nest$fgetmNrConnectedState(Lcom/android/internal/telephony/NetworkTypeController;)Lcom/android/internal/telephony/NetworkTypeController$NrConnectedState;

    move-result-object v0

    invoke-virtual {p1, v0}, Lcom/android/internal/telephony/StateMachine;->transitionTo(Lcom/android/internal/telephony/IState;)V

    goto :goto_0

    .line 864
    :cond_6
    iget-object p1, p0, Lcom/android/internal/telephony/NetworkTypeController$LteConnectedState;->this$0:Lcom/android/internal/telephony/NetworkTypeController;

    invoke-static {p1}, Lcom/android/internal/telephony/NetworkTypeController;->-$$Nest$misNrNotRestricted(Lcom/android/internal/telephony/NetworkTypeController;)Z

    move-result p1

    if-nez p1, :cond_a

    .line 865
    iget-object p1, p0, Lcom/android/internal/telephony/NetworkTypeController$LteConnectedState;->this$0:Lcom/android/internal/telephony/NetworkTypeController;

    invoke-static {p1}, Lcom/android/internal/telephony/NetworkTypeController;->-$$Nest$fgetmLegacyState(Lcom/android/internal/telephony/NetworkTypeController;)Lcom/android/internal/telephony/NetworkTypeController$LegacyState;

    move-result-object v0

    invoke-static {p1, v0}, Lcom/android/internal/telephony/NetworkTypeController;->-$$Nest$mtransitionWithTimerTo(Lcom/android/internal/telephony/NetworkTypeController;Lcom/android/internal/telephony/IState;)V

    goto :goto_0

    .line 854
    :cond_7
    iget-object p1, p0, Lcom/android/internal/telephony/NetworkTypeController$LteConnectedState;->this$0:Lcom/android/internal/telephony/NetworkTypeController;

    invoke-static {p1}, Lcom/android/internal/telephony/NetworkTypeController;->-$$Nest$mgetDataNetworkType(Lcom/android/internal/telephony/NetworkTypeController;)I

    move-result p1

    const/16 v0, 0x14

    if-ne p1, v0, :cond_8

    .line 856
    iget-object p1, p0, Lcom/android/internal/telephony/NetworkTypeController$LteConnectedState;->this$0:Lcom/android/internal/telephony/NetworkTypeController;

    invoke-static {p1}, Lcom/android/internal/telephony/NetworkTypeController;->-$$Nest$fgetmNrConnectedState(Lcom/android/internal/telephony/NetworkTypeController;)Lcom/android/internal/telephony/NetworkTypeController$NrConnectedState;

    move-result-object v0

    invoke-virtual {p1, v0}, Lcom/android/internal/telephony/StateMachine;->transitionTo(Lcom/android/internal/telephony/IState;)V

    goto :goto_0

    .line 857
    :cond_8
    iget-object v0, p0, Lcom/android/internal/telephony/NetworkTypeController$LteConnectedState;->this$0:Lcom/android/internal/telephony/NetworkTypeController;

    invoke-static {v0, p1}, Lcom/android/internal/telephony/NetworkTypeController;->-$$Nest$misLte(Lcom/android/internal/telephony/NetworkTypeController;I)Z

    move-result p1

    if-eqz p1, :cond_9

    iget-object p1, p0, Lcom/android/internal/telephony/NetworkTypeController$LteConnectedState;->this$0:Lcom/android/internal/telephony/NetworkTypeController;

    invoke-static {p1}, Lcom/android/internal/telephony/NetworkTypeController;->-$$Nest$misNrNotRestricted(Lcom/android/internal/telephony/NetworkTypeController;)Z

    move-result p1

    if-nez p1, :cond_a

    .line 858
    :cond_9
    iget-object p1, p0, Lcom/android/internal/telephony/NetworkTypeController$LteConnectedState;->this$0:Lcom/android/internal/telephony/NetworkTypeController;

    invoke-static {p1}, Lcom/android/internal/telephony/NetworkTypeController;->-$$Nest$fgetmLegacyState(Lcom/android/internal/telephony/NetworkTypeController;)Lcom/android/internal/telephony/NetworkTypeController$LegacyState;

    move-result-object v0

    invoke-static {p1, v0}, Lcom/android/internal/telephony/NetworkTypeController;->-$$Nest$mtransitionWithTimerTo(Lcom/android/internal/telephony/NetworkTypeController;Lcom/android/internal/telephony/IState;)V

    .line 904
    :cond_a
    :goto_0
    iget-object p1, p0, Lcom/android/internal/telephony/NetworkTypeController$LteConnectedState;->this$0:Lcom/android/internal/telephony/NetworkTypeController;

    invoke-static {p1}, Lcom/android/internal/telephony/NetworkTypeController;->-$$Nest$fgetmIsPrimaryTimerActive(Lcom/android/internal/telephony/NetworkTypeController;)Z

    move-result p1

    if-nez p1, :cond_b

    iget-object p1, p0, Lcom/android/internal/telephony/NetworkTypeController$LteConnectedState;->this$0:Lcom/android/internal/telephony/NetworkTypeController;

    invoke-static {p1}, Lcom/android/internal/telephony/NetworkTypeController;->-$$Nest$fgetmIsSecondaryTimerActive(Lcom/android/internal/telephony/NetworkTypeController;)Z

    move-result p1

    if-nez p1, :cond_b

    .line 905
    iget-object p1, p0, Lcom/android/internal/telephony/NetworkTypeController$LteConnectedState;->this$0:Lcom/android/internal/telephony/NetworkTypeController;

    invoke-virtual {p0}, Lcom/android/internal/telephony/NetworkTypeController$LteConnectedState;->getName()Ljava/lang/String;

    move-result-object p0

    invoke-static {p1, p0}, Lcom/android/internal/telephony/NetworkTypeController;->-$$Nest$fputmPreviousState(Lcom/android/internal/telephony/NetworkTypeController;Ljava/lang/String;)V

    :cond_b
    const/4 p0, 0x1

    return p0
.end method
