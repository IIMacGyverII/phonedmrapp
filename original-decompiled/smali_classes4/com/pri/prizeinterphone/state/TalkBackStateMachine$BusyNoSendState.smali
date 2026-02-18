.class Lcom/pri/prizeinterphone/state/TalkBackStateMachine$BusyNoSendState;
.super Lcom/pri/prizeinterphone/state/State;
.source "TalkBackStateMachine.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/pri/prizeinterphone/state/TalkBackStateMachine;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = "BusyNoSendState"
.end annotation


# instance fields
.field final synthetic this$0:Lcom/pri/prizeinterphone/state/TalkBackStateMachine;


# direct methods
.method constructor <init>(Lcom/pri/prizeinterphone/state/TalkBackStateMachine;)V
    .locals 0

    .line 548
    iput-object p1, p0, Lcom/pri/prizeinterphone/state/TalkBackStateMachine$BusyNoSendState;->this$0:Lcom/pri/prizeinterphone/state/TalkBackStateMachine;

    invoke-direct {p0}, Lcom/pri/prizeinterphone/state/State;-><init>()V

    return-void
.end method


# virtual methods
.method public enter()V
    .locals 1

    const-string p0, "TalkBackStateMachine"

    const-string v0, "############ enter BusyNoSendState ############"

    .line 551
    invoke-static {p0, v0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method

.method public exit()V
    .locals 1

    const-string p0, "TalkBackStateMachine"

    const-string v0, "############ exit BusyNoSendState ############"

    .line 556
    invoke-static {p0, v0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method

.method public processMessage(Landroid/os/Message;)Z
    .locals 2

    .line 561
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "BusyNoSendState  processMessage.....,msg.what="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v1, p1, Landroid/os/Message;->what:I

    invoke-static {v1}, Lcom/pri/prizeinterphone/state/TalkBackStateMachine;->msg2Str(I)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    const-string v1, "TalkBackStateMachine"

    invoke-static {v1, v0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    .line 562
    iget p1, p1, Landroid/os/Message;->what:I

    const/16 v0, 0x7db

    if-eq p1, v0, :cond_1

    const/16 v0, 0x7e1

    if-eq p1, v0, :cond_0

    const/16 v0, 0x4e8f

    if-eq p1, v0, :cond_1

    goto :goto_0

    .line 568
    :cond_0
    iget-object p1, p0, Lcom/pri/prizeinterphone/state/TalkBackStateMachine$BusyNoSendState;->this$0:Lcom/pri/prizeinterphone/state/TalkBackStateMachine;

    invoke-static {p1}, Lcom/pri/prizeinterphone/state/TalkBackStateMachine;->-$$Nest$fgetmReceiveSoundState(Lcom/pri/prizeinterphone/state/TalkBackStateMachine;)Lcom/pri/prizeinterphone/state/State;

    move-result-object v1

    invoke-virtual {p1, v1}, Lcom/pri/prizeinterphone/state/StateMachine;->transitionTo(Lcom/pri/prizeinterphone/state/IState;)V

    .line 569
    iget-object p0, p0, Lcom/pri/prizeinterphone/state/TalkBackStateMachine$BusyNoSendState;->this$0:Lcom/pri/prizeinterphone/state/TalkBackStateMachine;

    invoke-virtual {p0, v0}, Lcom/pri/prizeinterphone/state/StateMachine;->obtainMessage(I)Landroid/os/Message;

    move-result-object p1

    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/state/StateMachine;->sendMessage(Landroid/os/Message;)V

    goto :goto_0

    .line 565
    :cond_1
    iget-object p0, p0, Lcom/pri/prizeinterphone/state/TalkBackStateMachine$BusyNoSendState;->this$0:Lcom/pri/prizeinterphone/state/TalkBackStateMachine;

    invoke-static {p0}, Lcom/pri/prizeinterphone/state/TalkBackStateMachine;->-$$Nest$fgetfragment(Lcom/pri/prizeinterphone/state/TalkBackStateMachine;)Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;

    move-result-object p0

    const p1, 0x7f110113

    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->showToast(I)V

    :goto_0
    const/4 p0, 0x1

    return p0
.end method
