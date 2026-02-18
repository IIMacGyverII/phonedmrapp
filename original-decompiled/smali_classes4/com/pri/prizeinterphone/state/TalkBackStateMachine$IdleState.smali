.class Lcom/pri/prizeinterphone/state/TalkBackStateMachine$IdleState;
.super Lcom/pri/prizeinterphone/state/State;
.source "TalkBackStateMachine.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/pri/prizeinterphone/state/TalkBackStateMachine;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = "IdleState"
.end annotation


# instance fields
.field private isInterruptSendAgain:Z

.field final synthetic this$0:Lcom/pri/prizeinterphone/state/TalkBackStateMachine;


# direct methods
.method constructor <init>(Lcom/pri/prizeinterphone/state/TalkBackStateMachine;)V
    .locals 0

    .line 166
    iput-object p1, p0, Lcom/pri/prizeinterphone/state/TalkBackStateMachine$IdleState;->this$0:Lcom/pri/prizeinterphone/state/TalkBackStateMachine;

    invoke-direct {p0}, Lcom/pri/prizeinterphone/state/State;-><init>()V

    const/4 p1, 0x0

    .line 170
    iput-boolean p1, p0, Lcom/pri/prizeinterphone/state/TalkBackStateMachine$IdleState;->isInterruptSendAgain:Z

    return-void
.end method


# virtual methods
.method public enter()V
    .locals 1

    const-string p0, "TalkBackStateMachine"

    const-string v0, "############ enter IdleState ############"

    .line 174
    invoke-static {p0, v0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method

.method public exit()V
    .locals 1

    const-string p0, "TalkBackStateMachine"

    const-string v0, "############ exit IdleState ############"

    .line 179
    invoke-static {p0, v0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method

.method public isInterruptSendAgain()Z
    .locals 0

    .line 187
    iget-boolean p0, p0, Lcom/pri/prizeinterphone/state/TalkBackStateMachine$IdleState;->isInterruptSendAgain:Z

    return p0
.end method

.method public processMessage(Landroid/os/Message;)Z
    .locals 4

    .line 192
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "IdleState  processMessage.....,msg.what="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v1, p1, Landroid/os/Message;->what:I

    invoke-static {v1}, Lcom/pri/prizeinterphone/state/TalkBackStateMachine;->msg2Str(I)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    const-string v1, "TalkBackStateMachine"

    invoke-static {v1, v0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    .line 193
    iget v0, p1, Landroid/os/Message;->what:I

    const/16 v2, 0x7db

    const/16 v3, 0x7dd

    if-eq v0, v2, :cond_5

    if-eq v0, v3, :cond_3

    const/16 v1, 0x7e0

    if-eq v0, v1, :cond_2

    const/16 v1, 0x4e8f

    if-eq v0, v1, :cond_0

    packed-switch v0, :pswitch_data_0

    goto/16 :goto_0

    .line 239
    :pswitch_0
    iget-object p0, p0, Lcom/pri/prizeinterphone/state/TalkBackStateMachine$IdleState;->this$0:Lcom/pri/prizeinterphone/state/TalkBackStateMachine;

    invoke-static {p0}, Lcom/pri/prizeinterphone/state/TalkBackStateMachine;->-$$Nest$fgetfragment(Lcom/pri/prizeinterphone/state/TalkBackStateMachine;)Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;

    move-result-object p0

    iget-object p1, p1, Landroid/os/Message;->obj:Ljava/lang/Object;

    check-cast p1, Ljava/lang/Boolean;

    invoke-virtual {p1}, Ljava/lang/Boolean;->booleanValue()Z

    move-result p1

    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->updateChannelId(Z)V

    goto/16 :goto_0

    .line 242
    :pswitch_1
    iget-object p1, p0, Lcom/pri/prizeinterphone/state/TalkBackStateMachine$IdleState;->this$0:Lcom/pri/prizeinterphone/state/TalkBackStateMachine;

    invoke-static {p1}, Lcom/pri/prizeinterphone/state/TalkBackStateMachine;->-$$Nest$fgetmRelayConnectionFailedState(Lcom/pri/prizeinterphone/state/TalkBackStateMachine;)Lcom/pri/prizeinterphone/state/State;

    move-result-object v0

    invoke-virtual {p1, v0}, Lcom/pri/prizeinterphone/state/StateMachine;->transitionTo(Lcom/pri/prizeinterphone/state/IState;)V

    .line 243
    iget-object p0, p0, Lcom/pri/prizeinterphone/state/TalkBackStateMachine$IdleState;->this$0:Lcom/pri/prizeinterphone/state/TalkBackStateMachine;

    const/16 p1, 0x7e4

    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/state/StateMachine;->obtainMessage(I)Landroid/os/Message;

    move-result-object p1

    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/state/StateMachine;->deferMessage(Landroid/os/Message;)V

    goto/16 :goto_0

    .line 236
    :pswitch_2
    iget-object p0, p0, Lcom/pri/prizeinterphone/state/TalkBackStateMachine$IdleState;->this$0:Lcom/pri/prizeinterphone/state/TalkBackStateMachine;

    invoke-static {p0}, Lcom/pri/prizeinterphone/state/TalkBackStateMachine;->-$$Nest$fgetmIdleState(Lcom/pri/prizeinterphone/state/TalkBackStateMachine;)Lcom/pri/prizeinterphone/state/TalkBackStateMachine$IdleState;

    move-result-object p1

    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/state/StateMachine;->transitionTo(Lcom/pri/prizeinterphone/state/IState;)V

    goto/16 :goto_0

    .line 232
    :pswitch_3
    iget-object p1, p0, Lcom/pri/prizeinterphone/state/TalkBackStateMachine$IdleState;->this$0:Lcom/pri/prizeinterphone/state/TalkBackStateMachine;

    invoke-static {p1}, Lcom/pri/prizeinterphone/state/TalkBackStateMachine;->-$$Nest$fgetmPhoneCallingState(Lcom/pri/prizeinterphone/state/TalkBackStateMachine;)Lcom/pri/prizeinterphone/state/State;

    move-result-object v0

    invoke-virtual {p1, v0}, Lcom/pri/prizeinterphone/state/StateMachine;->transitionTo(Lcom/pri/prizeinterphone/state/IState;)V

    .line 233
    iget-object p0, p0, Lcom/pri/prizeinterphone/state/TalkBackStateMachine$IdleState;->this$0:Lcom/pri/prizeinterphone/state/TalkBackStateMachine;

    const/16 p1, 0x7e2

    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/state/StateMachine;->obtainMessage(I)Landroid/os/Message;

    move-result-object p1

    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/state/StateMachine;->sendMessage(Landroid/os/Message;)V

    goto/16 :goto_0

    .line 219
    :cond_0
    iget-object p1, p0, Lcom/pri/prizeinterphone/state/TalkBackStateMachine$IdleState;->this$0:Lcom/pri/prizeinterphone/state/TalkBackStateMachine;

    invoke-static {p1}, Lcom/pri/prizeinterphone/state/TalkBackStateMachine;->-$$Nest$fgetfragment(Lcom/pri/prizeinterphone/state/TalkBackStateMachine;)Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;

    move-result-object p1

    invoke-virtual {p1}, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->isInterruptTransport()Z

    move-result p1

    if-eqz p1, :cond_1

    .line 220
    iget-object p0, p0, Lcom/pri/prizeinterphone/state/TalkBackStateMachine$IdleState;->this$0:Lcom/pri/prizeinterphone/state/TalkBackStateMachine;

    invoke-virtual {p0, v3}, Lcom/pri/prizeinterphone/state/StateMachine;->sendMessage(I)V

    goto/16 :goto_0

    .line 222
    :cond_1
    iget-object p1, p0, Lcom/pri/prizeinterphone/state/TalkBackStateMachine$IdleState;->this$0:Lcom/pri/prizeinterphone/state/TalkBackStateMachine;

    invoke-static {p1}, Lcom/pri/prizeinterphone/state/TalkBackStateMachine;->-$$Nest$fgetmRecordSoundState(Lcom/pri/prizeinterphone/state/TalkBackStateMachine;)Lcom/pri/prizeinterphone/state/State;

    move-result-object v0

    invoke-virtual {p1, v0}, Lcom/pri/prizeinterphone/state/StateMachine;->transitionTo(Lcom/pri/prizeinterphone/state/IState;)V

    .line 223
    iget-object p0, p0, Lcom/pri/prizeinterphone/state/TalkBackStateMachine$IdleState;->this$0:Lcom/pri/prizeinterphone/state/TalkBackStateMachine;

    invoke-virtual {p0, v1}, Lcom/pri/prizeinterphone/state/StateMachine;->sendMessage(I)V

    goto/16 :goto_0

    .line 227
    :cond_2
    iget-object p1, p0, Lcom/pri/prizeinterphone/state/TalkBackStateMachine$IdleState;->this$0:Lcom/pri/prizeinterphone/state/TalkBackStateMachine;

    invoke-static {p1}, Lcom/pri/prizeinterphone/state/TalkBackStateMachine;->-$$Nest$fgetmReceiveSoundState(Lcom/pri/prizeinterphone/state/TalkBackStateMachine;)Lcom/pri/prizeinterphone/state/State;

    move-result-object v0

    invoke-virtual {p1, v0}, Lcom/pri/prizeinterphone/state/StateMachine;->transitionTo(Lcom/pri/prizeinterphone/state/IState;)V

    .line 228
    iget-object p0, p0, Lcom/pri/prizeinterphone/state/TalkBackStateMachine$IdleState;->this$0:Lcom/pri/prizeinterphone/state/TalkBackStateMachine;

    invoke-virtual {p0, v1}, Lcom/pri/prizeinterphone/state/StateMachine;->sendMessage(I)V

    goto/16 :goto_0

    .line 196
    :cond_3
    iget-object p1, p0, Lcom/pri/prizeinterphone/state/TalkBackStateMachine$IdleState;->this$0:Lcom/pri/prizeinterphone/state/TalkBackStateMachine;

    invoke-virtual {p1}, Lcom/pri/prizeinterphone/state/StateMachine;->getCurrentState()Lcom/pri/prizeinterphone/state/IState;

    move-result-object p1

    iget-object v0, p0, Lcom/pri/prizeinterphone/state/TalkBackStateMachine$IdleState;->this$0:Lcom/pri/prizeinterphone/state/TalkBackStateMachine;

    invoke-static {v0}, Lcom/pri/prizeinterphone/state/TalkBackStateMachine;->-$$Nest$fgetmWaitIngInterruptResultState(Lcom/pri/prizeinterphone/state/TalkBackStateMachine;)Lcom/pri/prizeinterphone/state/State;

    move-result-object v0

    if-eq p1, v0, :cond_4

    .line 197
    iget-object p1, p0, Lcom/pri/prizeinterphone/state/TalkBackStateMachine$IdleState;->this$0:Lcom/pri/prizeinterphone/state/TalkBackStateMachine;

    invoke-static {p1}, Lcom/pri/prizeinterphone/state/TalkBackStateMachine;->-$$Nest$fgetmWaitIngInterruptResultState(Lcom/pri/prizeinterphone/state/TalkBackStateMachine;)Lcom/pri/prizeinterphone/state/State;

    move-result-object v0

    invoke-virtual {p1, v0}, Lcom/pri/prizeinterphone/state/StateMachine;->transitionTo(Lcom/pri/prizeinterphone/state/IState;)V

    .line 199
    :cond_4
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "IdleState --- start sendInterrupt,isInterruptSendAgain="

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-boolean v0, p0, Lcom/pri/prizeinterphone/state/TalkBackStateMachine$IdleState;->isInterruptSendAgain:Z

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-static {v1, p1}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 201
    iget-object p1, p0, Lcom/pri/prizeinterphone/state/TalkBackStateMachine$IdleState;->this$0:Lcom/pri/prizeinterphone/state/TalkBackStateMachine;

    invoke-static {p1}, Lcom/pri/prizeinterphone/state/TalkBackStateMachine;->-$$Nest$fgetfragment(Lcom/pri/prizeinterphone/state/TalkBackStateMachine;)Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;

    move-result-object p1

    invoke-virtual {p1}, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->sendInterrupt()V

    .line 203
    iget-object p1, p0, Lcom/pri/prizeinterphone/state/TalkBackStateMachine$IdleState;->this$0:Lcom/pri/prizeinterphone/state/TalkBackStateMachine;

    const/16 v0, 0x7df

    invoke-virtual {p1, v0}, Lcom/pri/prizeinterphone/state/StateMachine;->obtainMessage(I)Landroid/os/Message;

    move-result-object v0

    const-wide/16 v1, 0x258

    invoke-virtual {p1, v0, v1, v2}, Lcom/pri/prizeinterphone/state/StateMachine;->sendMessageDelayed(Landroid/os/Message;J)V

    .line 205
    iget-boolean p1, p0, Lcom/pri/prizeinterphone/state/TalkBackStateMachine$IdleState;->isInterruptSendAgain:Z

    if-eqz p1, :cond_7

    .line 206
    iget-object p1, p0, Lcom/pri/prizeinterphone/state/TalkBackStateMachine$IdleState;->this$0:Lcom/pri/prizeinterphone/state/TalkBackStateMachine;

    invoke-virtual {p1, v3}, Lcom/pri/prizeinterphone/state/StateMachine;->removeMessages(I)V

    .line 207
    iget-object p0, p0, Lcom/pri/prizeinterphone/state/TalkBackStateMachine$IdleState;->this$0:Lcom/pri/prizeinterphone/state/TalkBackStateMachine;

    invoke-virtual {p0, v3}, Lcom/pri/prizeinterphone/state/StateMachine;->obtainMessage(I)Landroid/os/Message;

    move-result-object p1

    const-wide/16 v0, 0x1f4

    invoke-virtual {p0, p1, v0, v1}, Lcom/pri/prizeinterphone/state/StateMachine;->sendMessageDelayed(Landroid/os/Message;J)V

    goto :goto_0

    .line 211
    :cond_5
    iget-object p1, p0, Lcom/pri/prizeinterphone/state/TalkBackStateMachine$IdleState;->this$0:Lcom/pri/prizeinterphone/state/TalkBackStateMachine;

    invoke-static {p1}, Lcom/pri/prizeinterphone/state/TalkBackStateMachine;->-$$Nest$fgetfragment(Lcom/pri/prizeinterphone/state/TalkBackStateMachine;)Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;

    move-result-object p1

    invoke-virtual {p1}, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->isInterruptTransport()Z

    move-result p1

    if-eqz p1, :cond_6

    .line 212
    iget-object p0, p0, Lcom/pri/prizeinterphone/state/TalkBackStateMachine$IdleState;->this$0:Lcom/pri/prizeinterphone/state/TalkBackStateMachine;

    invoke-virtual {p0, v3}, Lcom/pri/prizeinterphone/state/StateMachine;->sendMessage(I)V

    goto :goto_0

    .line 214
    :cond_6
    iget-object p1, p0, Lcom/pri/prizeinterphone/state/TalkBackStateMachine$IdleState;->this$0:Lcom/pri/prizeinterphone/state/TalkBackStateMachine;

    invoke-static {p1}, Lcom/pri/prizeinterphone/state/TalkBackStateMachine;->-$$Nest$fgetmRecordSoundState(Lcom/pri/prizeinterphone/state/TalkBackStateMachine;)Lcom/pri/prizeinterphone/state/State;

    move-result-object v0

    invoke-virtual {p1, v0}, Lcom/pri/prizeinterphone/state/StateMachine;->transitionTo(Lcom/pri/prizeinterphone/state/IState;)V

    .line 215
    iget-object p0, p0, Lcom/pri/prizeinterphone/state/TalkBackStateMachine$IdleState;->this$0:Lcom/pri/prizeinterphone/state/TalkBackStateMachine;

    invoke-virtual {p0, v2}, Lcom/pri/prizeinterphone/state/StateMachine;->sendMessage(I)V

    :cond_7
    :goto_0
    const/4 p0, 0x1

    return p0

    :pswitch_data_0
    .packed-switch 0x7e2
        :pswitch_3
        :pswitch_2
        :pswitch_1
        :pswitch_0
    .end packed-switch
.end method

.method public setInterruptSendAgain(Z)V
    .locals 0

    .line 183
    iput-boolean p1, p0, Lcom/pri/prizeinterphone/state/TalkBackStateMachine$IdleState;->isInterruptSendAgain:Z

    return-void
.end method
