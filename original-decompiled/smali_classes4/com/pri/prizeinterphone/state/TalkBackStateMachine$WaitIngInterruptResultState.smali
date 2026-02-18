.class Lcom/pri/prizeinterphone/state/TalkBackStateMachine$WaitIngInterruptResultState;
.super Lcom/pri/prizeinterphone/state/State;
.source "TalkBackStateMachine.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/pri/prizeinterphone/state/TalkBackStateMachine;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = "WaitIngInterruptResultState"
.end annotation


# instance fields
.field final synthetic this$0:Lcom/pri/prizeinterphone/state/TalkBackStateMachine;


# direct methods
.method constructor <init>(Lcom/pri/prizeinterphone/state/TalkBackStateMachine;)V
    .locals 0

    .line 467
    iput-object p1, p0, Lcom/pri/prizeinterphone/state/TalkBackStateMachine$WaitIngInterruptResultState;->this$0:Lcom/pri/prizeinterphone/state/TalkBackStateMachine;

    invoke-direct {p0}, Lcom/pri/prizeinterphone/state/State;-><init>()V

    return-void
.end method


# virtual methods
.method public enter()V
    .locals 1

    const-string p0, "TalkBackStateMachine"

    const-string v0, "############ enter WaitIngInterruptResultState ############"

    .line 470
    invoke-static {p0, v0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method

.method public exit()V
    .locals 1

    const-string p0, "TalkBackStateMachine"

    const-string v0, "############ exit WaitIngInterruptResultState ############"

    .line 475
    invoke-static {p0, v0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method

.method public processMessage(Landroid/os/Message;)Z
    .locals 6

    .line 480
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "WaitIngInterruptResultState  processMessage.....,msg.what="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v1, p1, Landroid/os/Message;->what:I

    invoke-static {v1}, Lcom/pri/prizeinterphone/state/TalkBackStateMachine;->msg2Str(I)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    const-string v1, "TalkBackStateMachine"

    invoke-static {v1, v0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    .line 481
    iget v0, p1, Landroid/os/Message;->what:I

    const/4 v2, 0x1

    const/16 v3, 0x7db

    const/4 v4, 0x0

    packed-switch v0, :pswitch_data_0

    goto/16 :goto_0

    :pswitch_0
    const-string p1, "WaitIngInterruptResultState setInterrupt no result"

    .line 511
    invoke-static {v1, p1}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 513
    iget-object p1, p0, Lcom/pri/prizeinterphone/state/TalkBackStateMachine$WaitIngInterruptResultState;->this$0:Lcom/pri/prizeinterphone/state/TalkBackStateMachine;

    invoke-static {p1}, Lcom/pri/prizeinterphone/state/TalkBackStateMachine;->-$$Nest$fgetmRecordSoundState(Lcom/pri/prizeinterphone/state/TalkBackStateMachine;)Lcom/pri/prizeinterphone/state/State;

    move-result-object v0

    invoke-virtual {p1, v0}, Lcom/pri/prizeinterphone/state/StateMachine;->transitionTo(Lcom/pri/prizeinterphone/state/IState;)V

    .line 515
    iget-object p0, p0, Lcom/pri/prizeinterphone/state/TalkBackStateMachine$WaitIngInterruptResultState;->this$0:Lcom/pri/prizeinterphone/state/TalkBackStateMachine;

    invoke-virtual {p0, v3}, Lcom/pri/prizeinterphone/state/StateMachine;->obtainMessage(I)Landroid/os/Message;

    move-result-object p1

    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/state/StateMachine;->sendMessage(Landroid/os/Message;)V

    goto/16 :goto_0

    .line 484
    :pswitch_1
    iget-object v0, p0, Lcom/pri/prizeinterphone/state/TalkBackStateMachine$WaitIngInterruptResultState;->this$0:Lcom/pri/prizeinterphone/state/TalkBackStateMachine;

    const/16 v5, 0x7df

    invoke-virtual {v0, v5}, Lcom/pri/prizeinterphone/state/StateMachine;->removeMessages(I)V

    .line 486
    iget p1, p1, Landroid/os/Message;->arg1:I

    const/16 v0, 0x7dd

    if-nez p1, :cond_0

    const-string p1, "WaitIngInterruptResultState setInterrupt successfully"

    .line 487
    invoke-static {v1, p1}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 488
    iget-object p1, p0, Lcom/pri/prizeinterphone/state/TalkBackStateMachine$WaitIngInterruptResultState;->this$0:Lcom/pri/prizeinterphone/state/TalkBackStateMachine;

    invoke-static {p1}, Lcom/pri/prizeinterphone/state/TalkBackStateMachine;->-$$Nest$fgetmIdleState(Lcom/pri/prizeinterphone/state/TalkBackStateMachine;)Lcom/pri/prizeinterphone/state/TalkBackStateMachine$IdleState;

    move-result-object p1

    invoke-virtual {p1, v4}, Lcom/pri/prizeinterphone/state/TalkBackStateMachine$IdleState;->setInterruptSendAgain(Z)V

    .line 489
    iget-object p1, p0, Lcom/pri/prizeinterphone/state/TalkBackStateMachine$WaitIngInterruptResultState;->this$0:Lcom/pri/prizeinterphone/state/TalkBackStateMachine;

    invoke-virtual {p1, v0}, Lcom/pri/prizeinterphone/state/StateMachine;->removeMessages(I)V

    .line 490
    iget-object p1, p0, Lcom/pri/prizeinterphone/state/TalkBackStateMachine$WaitIngInterruptResultState;->this$0:Lcom/pri/prizeinterphone/state/TalkBackStateMachine;

    invoke-static {p1}, Lcom/pri/prizeinterphone/state/TalkBackStateMachine;->-$$Nest$fgetmRecordSoundState(Lcom/pri/prizeinterphone/state/TalkBackStateMachine;)Lcom/pri/prizeinterphone/state/State;

    move-result-object v0

    invoke-virtual {p1, v0}, Lcom/pri/prizeinterphone/state/StateMachine;->transitionTo(Lcom/pri/prizeinterphone/state/IState;)V

    .line 491
    iget-object p0, p0, Lcom/pri/prizeinterphone/state/TalkBackStateMachine$WaitIngInterruptResultState;->this$0:Lcom/pri/prizeinterphone/state/TalkBackStateMachine;

    invoke-virtual {p0, v3}, Lcom/pri/prizeinterphone/state/StateMachine;->obtainMessage(I)Landroid/os/Message;

    move-result-object p1

    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/state/StateMachine;->sendMessage(Landroid/os/Message;)V

    goto :goto_0

    :cond_0
    const-string p1, "WaitIngInterruptResultState setInterrupt failed"

    .line 493
    invoke-static {v1, p1}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 495
    iget-object p1, p0, Lcom/pri/prizeinterphone/state/TalkBackStateMachine$WaitIngInterruptResultState;->this$0:Lcom/pri/prizeinterphone/state/TalkBackStateMachine;

    invoke-static {p1}, Lcom/pri/prizeinterphone/state/TalkBackStateMachine;->-$$Nest$fgetmIdleState(Lcom/pri/prizeinterphone/state/TalkBackStateMachine;)Lcom/pri/prizeinterphone/state/TalkBackStateMachine$IdleState;

    move-result-object p1

    invoke-virtual {p1}, Lcom/pri/prizeinterphone/state/TalkBackStateMachine$IdleState;->isInterruptSendAgain()Z

    move-result p1

    if-nez p1, :cond_1

    .line 496
    iget-object p1, p0, Lcom/pri/prizeinterphone/state/TalkBackStateMachine$WaitIngInterruptResultState;->this$0:Lcom/pri/prizeinterphone/state/TalkBackStateMachine;

    invoke-static {p1}, Lcom/pri/prizeinterphone/state/TalkBackStateMachine;->-$$Nest$fgetmIdleState(Lcom/pri/prizeinterphone/state/TalkBackStateMachine;)Lcom/pri/prizeinterphone/state/TalkBackStateMachine$IdleState;

    move-result-object p1

    invoke-virtual {p1, v2}, Lcom/pri/prizeinterphone/state/TalkBackStateMachine$IdleState;->setInterruptSendAgain(Z)V

    .line 497
    iget-object p0, p0, Lcom/pri/prizeinterphone/state/TalkBackStateMachine$WaitIngInterruptResultState;->this$0:Lcom/pri/prizeinterphone/state/TalkBackStateMachine;

    invoke-virtual {p0, v0}, Lcom/pri/prizeinterphone/state/StateMachine;->obtainMessage(I)Landroid/os/Message;

    move-result-object p1

    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/state/StateMachine;->sendMessage(Landroid/os/Message;)V

    const-string p0, "WaitIngInterruptResultState setInterrupt again"

    .line 498
    invoke-static {v1, p0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    goto :goto_0

    .line 501
    :cond_1
    iget-object p1, p0, Lcom/pri/prizeinterphone/state/TalkBackStateMachine$WaitIngInterruptResultState;->this$0:Lcom/pri/prizeinterphone/state/TalkBackStateMachine;

    invoke-static {p1}, Lcom/pri/prizeinterphone/state/TalkBackStateMachine;->-$$Nest$fgetmIdleState(Lcom/pri/prizeinterphone/state/TalkBackStateMachine;)Lcom/pri/prizeinterphone/state/TalkBackStateMachine$IdleState;

    move-result-object p1

    invoke-virtual {p1, v4}, Lcom/pri/prizeinterphone/state/TalkBackStateMachine$IdleState;->setInterruptSendAgain(Z)V

    .line 502
    iget-object p1, p0, Lcom/pri/prizeinterphone/state/TalkBackStateMachine$WaitIngInterruptResultState;->this$0:Lcom/pri/prizeinterphone/state/TalkBackStateMachine;

    invoke-static {p1}, Lcom/pri/prizeinterphone/state/TalkBackStateMachine;->-$$Nest$fgetmRecordSoundState(Lcom/pri/prizeinterphone/state/TalkBackStateMachine;)Lcom/pri/prizeinterphone/state/State;

    move-result-object v0

    invoke-virtual {p1, v0}, Lcom/pri/prizeinterphone/state/StateMachine;->transitionTo(Lcom/pri/prizeinterphone/state/IState;)V

    .line 503
    iget-object p0, p0, Lcom/pri/prizeinterphone/state/TalkBackStateMachine$WaitIngInterruptResultState;->this$0:Lcom/pri/prizeinterphone/state/TalkBackStateMachine;

    invoke-virtual {p0, v3}, Lcom/pri/prizeinterphone/state/StateMachine;->obtainMessage(I)Landroid/os/Message;

    move-result-object p1

    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/state/StateMachine;->sendMessage(Landroid/os/Message;)V

    goto :goto_0

    :pswitch_2
    return v4

    :goto_0
    return v2

    :pswitch_data_0
    .packed-switch 0x7dd
        :pswitch_2
        :pswitch_1
        :pswitch_0
    .end packed-switch
.end method
