.class Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment$4;
.super Landroid/telephony/PhoneStateListener;
.source "InterPhoneTalkBackFragment.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;


# direct methods
.method constructor <init>(Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;)V
    .locals 0

    .line 560
    iput-object p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment$4;->this$0:Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;

    invoke-direct {p0}, Landroid/telephony/PhoneStateListener;-><init>()V

    return-void
.end method


# virtual methods
.method public onCallStateChanged(ILjava/lang/String;)V
    .locals 0

    .line 563
    invoke-super {p0, p1, p2}, Landroid/telephony/PhoneStateListener;->onCallStateChanged(ILjava/lang/String;)V

    const/4 p2, 0x1

    if-eq p1, p2, :cond_0

    const/4 p2, 0x2

    if-eq p1, p2, :cond_0

    .line 572
    iget-object p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment$4;->this$0:Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;

    invoke-static {p1}, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->-$$Nest$fgetmTalkBackStateMachine(Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;)Lcom/pri/prizeinterphone/state/TalkBackStateMachine;

    move-result-object p1

    if-eqz p1, :cond_1

    .line 573
    iget-object p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment$4;->this$0:Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;

    invoke-static {p1}, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->-$$Nest$fgetmTalkBackStateMachine(Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;)Lcom/pri/prizeinterphone/state/TalkBackStateMachine;

    move-result-object p1

    iget-object p0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment$4;->this$0:Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;

    invoke-static {p0}, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->-$$Nest$fgetmTalkBackStateMachine(Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;)Lcom/pri/prizeinterphone/state/TalkBackStateMachine;

    move-result-object p0

    const/16 p2, 0x7e3

    invoke-virtual {p0, p2}, Lcom/pri/prizeinterphone/state/StateMachine;->obtainMessage(I)Landroid/os/Message;

    move-result-object p0

    invoke-virtual {p1, p0}, Lcom/pri/prizeinterphone/state/StateMachine;->sendMessage(Landroid/os/Message;)V

    goto :goto_0

    .line 567
    :cond_0
    iget-object p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment$4;->this$0:Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;

    invoke-static {p1}, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->-$$Nest$fgetmTalkBackStateMachine(Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;)Lcom/pri/prizeinterphone/state/TalkBackStateMachine;

    move-result-object p1

    if-eqz p1, :cond_1

    .line 568
    iget-object p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment$4;->this$0:Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;

    invoke-static {p1}, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->-$$Nest$fgetmTalkBackStateMachine(Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;)Lcom/pri/prizeinterphone/state/TalkBackStateMachine;

    move-result-object p1

    iget-object p0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment$4;->this$0:Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;

    invoke-static {p0}, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->-$$Nest$fgetmTalkBackStateMachine(Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;)Lcom/pri/prizeinterphone/state/TalkBackStateMachine;

    move-result-object p0

    const/16 p2, 0x7e2

    invoke-virtual {p0, p2}, Lcom/pri/prizeinterphone/state/StateMachine;->obtainMessage(I)Landroid/os/Message;

    move-result-object p0

    invoke-virtual {p1, p0}, Lcom/pri/prizeinterphone/state/StateMachine;->sendMessage(Landroid/os/Message;)V

    :cond_1
    :goto_0
    return-void
.end method
