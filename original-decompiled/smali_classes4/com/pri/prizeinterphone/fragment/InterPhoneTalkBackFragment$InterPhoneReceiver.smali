.class public Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment$InterPhoneReceiver;
.super Landroid/content/BroadcastReceiver;
.source "InterPhoneTalkBackFragment.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x1
    name = "InterPhoneReceiver"
.end annotation


# instance fields
.field final synthetic this$0:Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;


# direct methods
.method public constructor <init>(Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;)V
    .locals 0

    .line 534
    iput-object p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment$InterPhoneReceiver;->this$0:Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;

    invoke-direct {p0}, Landroid/content/BroadcastReceiver;-><init>()V

    return-void
.end method


# virtual methods
.method public onReceive(Landroid/content/Context;Landroid/content/Intent;)V
    .locals 2

    .line 538
    invoke-virtual {p2}, Landroid/content/Intent;->getAction()Ljava/lang/String;

    move-result-object p1

    .line 539
    sget-object p2, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->PTTDOWNINTER:Ljava/lang/String;

    invoke-virtual {p1, p2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p2

    const/16 v0, 0x4e8f

    if-eqz p2, :cond_1

    .line 540
    iget-object p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment$InterPhoneReceiver;->this$0:Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;

    iget-boolean p2, p1, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->isButtonRecord:Z

    if-eqz p2, :cond_0

    return-void

    :cond_0
    const/4 p2, 0x1

    .line 543
    iput-boolean p2, p1, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->isPTTRecord:Z

    .line 546
    invoke-static {p1}, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->-$$Nest$fgetmTalkBackStateMachine(Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;)Lcom/pri/prizeinterphone/state/TalkBackStateMachine;

    move-result-object p1

    invoke-virtual {p1, v0}, Lcom/pri/prizeinterphone/state/StateMachine;->removeMessages(I)V

    .line 547
    iget-object p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment$InterPhoneReceiver;->this$0:Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;

    invoke-static {p1}, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->-$$Nest$fgetmTalkBackStateMachine(Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;)Lcom/pri/prizeinterphone/state/TalkBackStateMachine;

    move-result-object p1

    iget-object p0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment$InterPhoneReceiver;->this$0:Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;

    invoke-static {p0}, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->-$$Nest$fgetmTalkBackStateMachine(Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;)Lcom/pri/prizeinterphone/state/TalkBackStateMachine;

    move-result-object p0

    invoke-virtual {p0, v0}, Lcom/pri/prizeinterphone/state/StateMachine;->obtainMessage(I)Landroid/os/Message;

    move-result-object p0

    const-wide/16 v0, 0xc8

    invoke-virtual {p1, p0, v0, v1}, Lcom/pri/prizeinterphone/state/StateMachine;->sendMessageDelayed(Landroid/os/Message;J)V

    goto :goto_0

    .line 549
    :cond_1
    sget-object p2, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->PTTUPINTER:Ljava/lang/String;

    invoke-virtual {p1, p2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p1

    if-eqz p1, :cond_2

    .line 550
    iget-object p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment$InterPhoneReceiver;->this$0:Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;

    iget-boolean p2, p1, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->isPTTRecord:Z

    if-eqz p2, :cond_2

    .line 552
    invoke-static {p1}, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->-$$Nest$fgetmTalkBackStateMachine(Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;)Lcom/pri/prizeinterphone/state/TalkBackStateMachine;

    move-result-object p1

    invoke-virtual {p1, v0}, Lcom/pri/prizeinterphone/state/StateMachine;->removeMessages(I)V

    .line 553
    iget-object p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment$InterPhoneReceiver;->this$0:Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;

    invoke-static {p1}, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->-$$Nest$fgetmTalkBackStateMachine(Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;)Lcom/pri/prizeinterphone/state/TalkBackStateMachine;

    move-result-object p1

    iget-object p2, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment$InterPhoneReceiver;->this$0:Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;

    invoke-static {p2}, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->-$$Nest$fgetmTalkBackStateMachine(Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;)Lcom/pri/prizeinterphone/state/TalkBackStateMachine;

    move-result-object p2

    const/16 v0, 0x7dc

    invoke-virtual {p2, v0}, Lcom/pri/prizeinterphone/state/StateMachine;->obtainMessage(I)Landroid/os/Message;

    move-result-object p2

    invoke-virtual {p1, p2}, Lcom/pri/prizeinterphone/state/StateMachine;->sendMessage(Landroid/os/Message;)V

    .line 554
    iget-object p0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment$InterPhoneReceiver;->this$0:Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;

    const/4 p1, 0x0

    iput-boolean p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->isPTTRecord:Z

    :cond_2
    :goto_0
    return-void
.end method
