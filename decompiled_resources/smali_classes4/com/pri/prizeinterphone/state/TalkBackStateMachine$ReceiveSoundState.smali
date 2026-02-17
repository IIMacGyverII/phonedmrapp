.class Lcom/pri/prizeinterphone/state/TalkBackStateMachine$ReceiveSoundState;
.super Lcom/pri/prizeinterphone/state/State;
.source "TalkBackStateMachine.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/pri/prizeinterphone/state/TalkBackStateMachine;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = "ReceiveSoundState"
.end annotation


# static fields
.field private static final STATE_IDLE:I = 0x0

.field private static final STATE_RECORD_AGAIN:I = 0x1


# instance fields
.field final synthetic this$0:Lcom/pri/prizeinterphone/state/TalkBackStateMachine;


# direct methods
.method constructor <init>(Lcom/pri/prizeinterphone/state/TalkBackStateMachine;)V
    .locals 0

    .line 383
    iput-object p1, p0, Lcom/pri/prizeinterphone/state/TalkBackStateMachine$ReceiveSoundState;->this$0:Lcom/pri/prizeinterphone/state/TalkBackStateMachine;

    invoke-direct {p0}, Lcom/pri/prizeinterphone/state/State;-><init>()V

    return-void
.end method


# virtual methods
.method public enter()V
    .locals 1

    const-string p0, "TalkBackStateMachine"

    const-string v0, "############ enter ReceiveSoundState ############"

    .line 389
    invoke-static {p0, v0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method

.method public exit()V
    .locals 1

    const-string p0, "TalkBackStateMachine"

    const-string v0, "############ exit ReceiveSoundState ############"

    .line 394
    invoke-static {p0, v0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method

.method public processMessage(Landroid/os/Message;)Z
    .locals 6

    .line 399
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "ReceiveSoundState  processMessage.....,msg.what="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v1, p1, Landroid/os/Message;->what:I

    invoke-static {v1}, Lcom/pri/prizeinterphone/state/TalkBackStateMachine;->msg2Str(I)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    const-string v1, "TalkBackStateMachine"

    invoke-static {v1, v0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    .line 400
    iget v0, p1, Landroid/os/Message;->what:I

    const/16 v2, 0x7e1

    const/4 v3, 0x1

    const/16 v4, 0x7db

    if-eq v0, v4, :cond_1

    const/16 v5, 0x4e8f

    if-eq v0, v5, :cond_1

    const/4 v5, 0x2

    packed-switch v0, :pswitch_data_0

    goto/16 :goto_0

    .line 426
    :pswitch_0
    iget-object p0, p0, Lcom/pri/prizeinterphone/state/TalkBackStateMachine$ReceiveSoundState;->this$0:Lcom/pri/prizeinterphone/state/TalkBackStateMachine;

    invoke-virtual {p0, v2, v5}, Lcom/pri/prizeinterphone/state/StateMachine;->obtainMessage(II)Landroid/os/Message;

    move-result-object p1

    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/state/StateMachine;->sendMessage(Landroid/os/Message;)V

    goto/16 :goto_0

    .line 406
    :pswitch_1
    iget-object v0, p0, Lcom/pri/prizeinterphone/state/TalkBackStateMachine$ReceiveSoundState;->this$0:Lcom/pri/prizeinterphone/state/TalkBackStateMachine;

    invoke-static {v0}, Lcom/pri/prizeinterphone/state/TalkBackStateMachine;->-$$Nest$fgetfragment(Lcom/pri/prizeinterphone/state/TalkBackStateMachine;)Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;

    move-result-object v0

    invoke-virtual {v0}, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->stopPcmRead()V

    .line 407
    iget-object v0, p0, Lcom/pri/prizeinterphone/state/TalkBackStateMachine$ReceiveSoundState;->this$0:Lcom/pri/prizeinterphone/state/TalkBackStateMachine;

    invoke-static {v0}, Lcom/pri/prizeinterphone/state/TalkBackStateMachine;->-$$Nest$fgetfragment(Lcom/pri/prizeinterphone/state/TalkBackStateMachine;)Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;

    move-result-object v0

    invoke-virtual {v0}, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->setStopReceivePrepare()V

    .line 408
    iget-object v0, p0, Lcom/pri/prizeinterphone/state/TalkBackStateMachine$ReceiveSoundState;->this$0:Lcom/pri/prizeinterphone/state/TalkBackStateMachine;

    invoke-static {v0}, Lcom/pri/prizeinterphone/state/TalkBackStateMachine;->-$$Nest$fgetmIdleState(Lcom/pri/prizeinterphone/state/TalkBackStateMachine;)Lcom/pri/prizeinterphone/state/TalkBackStateMachine$IdleState;

    move-result-object v2

    invoke-virtual {v0, v2}, Lcom/pri/prizeinterphone/state/StateMachine;->transitionTo(Lcom/pri/prizeinterphone/state/IState;)V

    .line 409
    iget p1, p1, Landroid/os/Message;->arg1:I

    if-ne p1, v3, :cond_0

    const-string p1, "ReceiveSoundState  record again--------------"

    .line 410
    invoke-static {v1, p1}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    .line 411
    iget-object p0, p0, Lcom/pri/prizeinterphone/state/TalkBackStateMachine$ReceiveSoundState;->this$0:Lcom/pri/prizeinterphone/state/TalkBackStateMachine;

    invoke-virtual {p0, v4}, Lcom/pri/prizeinterphone/state/StateMachine;->obtainMessage(I)Landroid/os/Message;

    move-result-object p1

    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/state/StateMachine;->sendMessage(Landroid/os/Message;)V

    goto :goto_0

    :cond_0
    if-ne p1, v5, :cond_3

    .line 413
    iget-object p0, p0, Lcom/pri/prizeinterphone/state/TalkBackStateMachine$ReceiveSoundState;->this$0:Lcom/pri/prizeinterphone/state/TalkBackStateMachine;

    const/16 p1, 0x7e2

    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/state/StateMachine;->obtainMessage(I)Landroid/os/Message;

    move-result-object p1

    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/state/StateMachine;->sendMessage(Landroid/os/Message;)V

    goto :goto_0

    .line 402
    :pswitch_2
    iget-object p1, p0, Lcom/pri/prizeinterphone/state/TalkBackStateMachine$ReceiveSoundState;->this$0:Lcom/pri/prizeinterphone/state/TalkBackStateMachine;

    invoke-static {p1}, Lcom/pri/prizeinterphone/state/TalkBackStateMachine;->-$$Nest$fgetfragment(Lcom/pri/prizeinterphone/state/TalkBackStateMachine;)Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;

    move-result-object p1

    invoke-virtual {p1}, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->setStartReceivePrepare()V

    .line 403
    iget-object p0, p0, Lcom/pri/prizeinterphone/state/TalkBackStateMachine$ReceiveSoundState;->this$0:Lcom/pri/prizeinterphone/state/TalkBackStateMachine;

    invoke-static {p0}, Lcom/pri/prizeinterphone/state/TalkBackStateMachine;->-$$Nest$fgetfragment(Lcom/pri/prizeinterphone/state/TalkBackStateMachine;)Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;

    move-result-object p0

    invoke-virtual {p0}, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->startPcmRead()V

    goto :goto_0

    .line 418
    :cond_1
    iget-object p1, p0, Lcom/pri/prizeinterphone/state/TalkBackStateMachine$ReceiveSoundState;->this$0:Lcom/pri/prizeinterphone/state/TalkBackStateMachine;

    invoke-static {p1}, Lcom/pri/prizeinterphone/state/TalkBackStateMachine;->-$$Nest$fgetfragment(Lcom/pri/prizeinterphone/state/TalkBackStateMachine;)Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;

    move-result-object p1

    invoke-virtual {p1}, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->getBusyNoSend()Z

    move-result p1

    if-eqz p1, :cond_2

    .line 419
    iget-object p1, p0, Lcom/pri/prizeinterphone/state/TalkBackStateMachine$ReceiveSoundState;->this$0:Lcom/pri/prizeinterphone/state/TalkBackStateMachine;

    invoke-static {p1}, Lcom/pri/prizeinterphone/state/TalkBackStateMachine;->-$$Nest$fgetmBusyNoSendState(Lcom/pri/prizeinterphone/state/TalkBackStateMachine;)Lcom/pri/prizeinterphone/state/State;

    move-result-object v0

    invoke-virtual {p1, v0}, Lcom/pri/prizeinterphone/state/StateMachine;->transitionTo(Lcom/pri/prizeinterphone/state/IState;)V

    .line 420
    iget-object p0, p0, Lcom/pri/prizeinterphone/state/TalkBackStateMachine$ReceiveSoundState;->this$0:Lcom/pri/prizeinterphone/state/TalkBackStateMachine;

    invoke-virtual {p0, v4}, Lcom/pri/prizeinterphone/state/StateMachine;->obtainMessage(I)Landroid/os/Message;

    move-result-object p1

    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/state/StateMachine;->sendMessage(Landroid/os/Message;)V

    goto :goto_0

    .line 422
    :cond_2
    iget-object p0, p0, Lcom/pri/prizeinterphone/state/TalkBackStateMachine$ReceiveSoundState;->this$0:Lcom/pri/prizeinterphone/state/TalkBackStateMachine;

    invoke-virtual {p0, v2, v3}, Lcom/pri/prizeinterphone/state/StateMachine;->obtainMessage(II)Landroid/os/Message;

    move-result-object p1

    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/state/StateMachine;->sendMessage(Landroid/os/Message;)V

    :cond_3
    :goto_0
    return v3

    :pswitch_data_0
    .packed-switch 0x7e0
        :pswitch_2
        :pswitch_1
        :pswitch_0
    .end packed-switch
.end method
