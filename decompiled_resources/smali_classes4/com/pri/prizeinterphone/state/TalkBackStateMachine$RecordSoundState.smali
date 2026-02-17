.class Lcom/pri/prizeinterphone/state/TalkBackStateMachine$RecordSoundState;
.super Lcom/pri/prizeinterphone/state/State;
.source "TalkBackStateMachine.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/pri/prizeinterphone/state/TalkBackStateMachine;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = "RecordSoundState"
.end annotation


# static fields
.field public static final NEED_SEND_RECEIVE_SOUND_START:I = 0x4

.field public static final NEED_SEND_RELAY_CONNECTION_FAILED:I = 0x3


# instance fields
.field final synthetic this$0:Lcom/pri/prizeinterphone/state/TalkBackStateMachine;


# direct methods
.method constructor <init>(Lcom/pri/prizeinterphone/state/TalkBackStateMachine;)V
    .locals 0

    .line 253
    iput-object p1, p0, Lcom/pri/prizeinterphone/state/TalkBackStateMachine$RecordSoundState;->this$0:Lcom/pri/prizeinterphone/state/TalkBackStateMachine;

    invoke-direct {p0}, Lcom/pri/prizeinterphone/state/State;-><init>()V

    return-void
.end method


# virtual methods
.method public enter()V
    .locals 1

    const-string p0, "TalkBackStateMachine"

    const-string v0, "############ enter RecordSoundState ############"

    .line 259
    invoke-static {p0, v0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method

.method public exit()V
    .locals 1

    const-string p0, "TalkBackStateMachine"

    const-string v0, "############ exit RecordSoundState ############"

    .line 264
    invoke-static {p0, v0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method

.method public processMessage(Landroid/os/Message;)Z
    .locals 13

    .line 269
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "RecordSoundState  processMessage.....,msg.what="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v1, p1, Landroid/os/Message;->what:I

    invoke-static {v1}, Lcom/pri/prizeinterphone/state/TalkBackStateMachine;->msg2Str(I)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    const-string v1, "TalkBackStateMachine"

    invoke-static {v1, v0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    .line 270
    iget v0, p1, Landroid/os/Message;->what:I

    const/16 v1, 0x7db

    const v2, 0x7f110118

    const/4 v3, 0x0

    const/4 v4, 0x1

    if-eq v0, v1, :cond_d

    const/16 v1, 0x7e4

    const/4 v5, 0x3

    const/4 v6, 0x2

    const/4 v7, 0x4

    const/16 v8, 0x4e90

    const/16 v9, 0x7e2

    const/16 v10, 0x7e0

    const/16 v11, 0x7dc

    if-eq v0, v11, :cond_9

    if-eq v0, v10, :cond_8

    if-eq v0, v9, :cond_7

    const/16 v12, 0x4e8f

    if-eq v0, v12, :cond_4

    if-eq v0, v8, :cond_3

    packed-switch v0, :pswitch_data_0

    goto/16 :goto_0

    .line 349
    :pswitch_0
    iget-object v0, p0, Lcom/pri/prizeinterphone/state/TalkBackStateMachine$RecordSoundState;->this$0:Lcom/pri/prizeinterphone/state/TalkBackStateMachine;

    invoke-static {v0}, Lcom/pri/prizeinterphone/state/TalkBackStateMachine;->-$$Nest$fgetfragment(Lcom/pri/prizeinterphone/state/TalkBackStateMachine;)Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;

    move-result-object v0

    invoke-virtual {v0}, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->stopPcmRecord()V

    .line 350
    iget-object v0, p0, Lcom/pri/prizeinterphone/state/TalkBackStateMachine$RecordSoundState;->this$0:Lcom/pri/prizeinterphone/state/TalkBackStateMachine;

    invoke-static {v0}, Lcom/pri/prizeinterphone/state/TalkBackStateMachine;->-$$Nest$fgetfragment(Lcom/pri/prizeinterphone/state/TalkBackStateMachine;)Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;

    move-result-object v0

    invoke-virtual {v0}, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->setStopRecordPrepare()V

    .line 351
    iget-object v0, p0, Lcom/pri/prizeinterphone/state/TalkBackStateMachine$RecordSoundState;->this$0:Lcom/pri/prizeinterphone/state/TalkBackStateMachine;

    invoke-static {v0}, Lcom/pri/prizeinterphone/state/TalkBackStateMachine;->-$$Nest$fgetfragment(Lcom/pri/prizeinterphone/state/TalkBackStateMachine;)Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;

    move-result-object v0

    invoke-virtual {v0, v3}, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->setSendStatus(I)V

    .line 352
    iget-object v0, p0, Lcom/pri/prizeinterphone/state/TalkBackStateMachine$RecordSoundState;->this$0:Lcom/pri/prizeinterphone/state/TalkBackStateMachine;

    invoke-static {v0}, Lcom/pri/prizeinterphone/state/TalkBackStateMachine;->-$$Nest$fgetmIdleState(Lcom/pri/prizeinterphone/state/TalkBackStateMachine;)Lcom/pri/prizeinterphone/state/TalkBackStateMachine$IdleState;

    move-result-object v2

    invoke-virtual {v0, v2}, Lcom/pri/prizeinterphone/state/StateMachine;->transitionTo(Lcom/pri/prizeinterphone/state/IState;)V

    .line 353
    iget p1, p1, Landroid/os/Message;->arg1:I

    if-ne p1, v6, :cond_0

    .line 354
    iget-object p0, p0, Lcom/pri/prizeinterphone/state/TalkBackStateMachine$RecordSoundState;->this$0:Lcom/pri/prizeinterphone/state/TalkBackStateMachine;

    invoke-virtual {p0, v9}, Lcom/pri/prizeinterphone/state/StateMachine;->obtainMessage(I)Landroid/os/Message;

    move-result-object p1

    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/state/StateMachine;->sendMessage(Landroid/os/Message;)V

    goto/16 :goto_0

    :cond_0
    if-ne p1, v5, :cond_1

    .line 356
    iget-object p1, p0, Lcom/pri/prizeinterphone/state/TalkBackStateMachine$RecordSoundState;->this$0:Lcom/pri/prizeinterphone/state/TalkBackStateMachine;

    invoke-static {p1}, Lcom/pri/prizeinterphone/state/TalkBackStateMachine;->-$$Nest$fgetmRelayConnectionFailedState(Lcom/pri/prizeinterphone/state/TalkBackStateMachine;)Lcom/pri/prizeinterphone/state/State;

    move-result-object v0

    invoke-virtual {p1, v0}, Lcom/pri/prizeinterphone/state/StateMachine;->transitionTo(Lcom/pri/prizeinterphone/state/IState;)V

    .line 357
    iget-object p0, p0, Lcom/pri/prizeinterphone/state/TalkBackStateMachine$RecordSoundState;->this$0:Lcom/pri/prizeinterphone/state/TalkBackStateMachine;

    invoke-virtual {p0, v1}, Lcom/pri/prizeinterphone/state/StateMachine;->obtainMessage(I)Landroid/os/Message;

    move-result-object p1

    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/state/StateMachine;->sendMessage(Landroid/os/Message;)V

    goto/16 :goto_0

    :cond_1
    if-ne p1, v7, :cond_10

    .line 359
    iget-object p1, p0, Lcom/pri/prizeinterphone/state/TalkBackStateMachine$RecordSoundState;->this$0:Lcom/pri/prizeinterphone/state/TalkBackStateMachine;

    invoke-static {p1}, Lcom/pri/prizeinterphone/state/TalkBackStateMachine;->-$$Nest$fgetmReceiveSoundState(Lcom/pri/prizeinterphone/state/TalkBackStateMachine;)Lcom/pri/prizeinterphone/state/State;

    move-result-object v0

    invoke-virtual {p1, v0}, Lcom/pri/prizeinterphone/state/StateMachine;->transitionTo(Lcom/pri/prizeinterphone/state/IState;)V

    .line 360
    iget-object p0, p0, Lcom/pri/prizeinterphone/state/TalkBackStateMachine$RecordSoundState;->this$0:Lcom/pri/prizeinterphone/state/TalkBackStateMachine;

    invoke-virtual {p0, v10}, Lcom/pri/prizeinterphone/state/StateMachine;->obtainMessage(I)Landroid/os/Message;

    move-result-object p1

    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/state/StateMachine;->sendMessage(Landroid/os/Message;)V

    goto/16 :goto_0

    .line 314
    :pswitch_1
    iget-object p1, p0, Lcom/pri/prizeinterphone/state/TalkBackStateMachine$RecordSoundState;->this$0:Lcom/pri/prizeinterphone/state/TalkBackStateMachine;

    invoke-static {p1}, Lcom/pri/prizeinterphone/state/TalkBackStateMachine;->-$$Nest$fgetfragment(Lcom/pri/prizeinterphone/state/TalkBackStateMachine;)Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;

    move-result-object p1

    invoke-virtual {p1}, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->createRecordFile()V

    .line 315
    iget-object p1, p0, Lcom/pri/prizeinterphone/state/TalkBackStateMachine$RecordSoundState;->this$0:Lcom/pri/prizeinterphone/state/TalkBackStateMachine;

    invoke-static {p1}, Lcom/pri/prizeinterphone/state/TalkBackStateMachine;->-$$Nest$fgetfragment(Lcom/pri/prizeinterphone/state/TalkBackStateMachine;)Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;

    move-result-object p1

    invoke-virtual {p1}, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->startPcmRecord()I

    move-result p1

    if-gez p1, :cond_2

    .line 318
    iget-object p1, p0, Lcom/pri/prizeinterphone/state/TalkBackStateMachine$RecordSoundState;->this$0:Lcom/pri/prizeinterphone/state/TalkBackStateMachine;

    invoke-static {p1}, Lcom/pri/prizeinterphone/state/TalkBackStateMachine;->-$$Nest$fgetfragment(Lcom/pri/prizeinterphone/state/TalkBackStateMachine;)Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;

    move-result-object p1

    invoke-virtual {p1, v2}, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->showToast(I)V

    .line 319
    iget-object p1, p0, Lcom/pri/prizeinterphone/state/TalkBackStateMachine$RecordSoundState;->this$0:Lcom/pri/prizeinterphone/state/TalkBackStateMachine;

    invoke-static {p1}, Lcom/pri/prizeinterphone/state/TalkBackStateMachine;->-$$Nest$fgetfragment(Lcom/pri/prizeinterphone/state/TalkBackStateMachine;)Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;

    move-result-object p1

    invoke-virtual {p1, v3}, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->setTalkbackRecordBg(I)V

    .line 320
    iget-object p1, p0, Lcom/pri/prizeinterphone/state/TalkBackStateMachine$RecordSoundState;->this$0:Lcom/pri/prizeinterphone/state/TalkBackStateMachine;

    invoke-static {p1}, Lcom/pri/prizeinterphone/state/TalkBackStateMachine;->-$$Nest$fgetfragment(Lcom/pri/prizeinterphone/state/TalkBackStateMachine;)Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;

    move-result-object p1

    invoke-virtual {p1}, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->stopPcmRecord()V

    .line 321
    iget-object p0, p0, Lcom/pri/prizeinterphone/state/TalkBackStateMachine$RecordSoundState;->this$0:Lcom/pri/prizeinterphone/state/TalkBackStateMachine;

    invoke-static {p0}, Lcom/pri/prizeinterphone/state/TalkBackStateMachine;->-$$Nest$fgetmSendExceptionState(Lcom/pri/prizeinterphone/state/TalkBackStateMachine;)Lcom/pri/prizeinterphone/state/State;

    move-result-object p1

    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/state/StateMachine;->transitionTo(Lcom/pri/prizeinterphone/state/IState;)V

    return v4

    .line 324
    :cond_2
    iget-object p1, p0, Lcom/pri/prizeinterphone/state/TalkBackStateMachine$RecordSoundState;->this$0:Lcom/pri/prizeinterphone/state/TalkBackStateMachine;

    invoke-static {p1}, Lcom/pri/prizeinterphone/state/TalkBackStateMachine;->-$$Nest$fgetfragment(Lcom/pri/prizeinterphone/state/TalkBackStateMachine;)Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;

    move-result-object p1

    invoke-virtual {p1}, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->setStartRecordPrepare()V

    .line 325
    iget-object p1, p0, Lcom/pri/prizeinterphone/state/TalkBackStateMachine$RecordSoundState;->this$0:Lcom/pri/prizeinterphone/state/TalkBackStateMachine;

    invoke-static {p1}, Lcom/pri/prizeinterphone/state/TalkBackStateMachine;->-$$Nest$fgetfragment(Lcom/pri/prizeinterphone/state/TalkBackStateMachine;)Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;

    move-result-object p1

    invoke-virtual {p1}, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->showLimitRecordTime()V

    .line 326
    iget-object p0, p0, Lcom/pri/prizeinterphone/state/TalkBackStateMachine$RecordSoundState;->this$0:Lcom/pri/prizeinterphone/state/TalkBackStateMachine;

    invoke-static {p0}, Lcom/pri/prizeinterphone/state/TalkBackStateMachine;->-$$Nest$fgetfragment(Lcom/pri/prizeinterphone/state/TalkBackStateMachine;)Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;

    move-result-object p0

    invoke-virtual {p0, v4}, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->setSendStatus(I)V

    goto/16 :goto_0

    .line 373
    :pswitch_2
    iget-object p0, p0, Lcom/pri/prizeinterphone/state/TalkBackStateMachine$RecordSoundState;->this$0:Lcom/pri/prizeinterphone/state/TalkBackStateMachine;

    invoke-static {p0}, Lcom/pri/prizeinterphone/state/TalkBackStateMachine;->-$$Nest$fgetfragment(Lcom/pri/prizeinterphone/state/TalkBackStateMachine;)Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;

    move-result-object p0

    const p1, 0x7f11011c

    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->showToast(I)V

    goto/16 :goto_0

    .line 370
    :pswitch_3
    iget-object p0, p0, Lcom/pri/prizeinterphone/state/TalkBackStateMachine$RecordSoundState;->this$0:Lcom/pri/prizeinterphone/state/TalkBackStateMachine;

    invoke-virtual {p0, v11, v5}, Lcom/pri/prizeinterphone/state/StateMachine;->obtainMessage(II)Landroid/os/Message;

    move-result-object p1

    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/state/StateMachine;->sendMessage(Landroid/os/Message;)V

    goto/16 :goto_0

    .line 310
    :cond_3
    iget-object p1, p0, Lcom/pri/prizeinterphone/state/TalkBackStateMachine$RecordSoundState;->this$0:Lcom/pri/prizeinterphone/state/TalkBackStateMachine;

    invoke-static {p1}, Lcom/pri/prizeinterphone/state/TalkBackStateMachine;->-$$Nest$fgetfragment(Lcom/pri/prizeinterphone/state/TalkBackStateMachine;)Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;

    move-result-object p1

    invoke-virtual {p1}, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->setStartRecordPrepare()V

    .line 311
    iget-object p0, p0, Lcom/pri/prizeinterphone/state/TalkBackStateMachine$RecordSoundState;->this$0:Lcom/pri/prizeinterphone/state/TalkBackStateMachine;

    invoke-static {p0}, Lcom/pri/prizeinterphone/state/TalkBackStateMachine;->-$$Nest$fgetfragment(Lcom/pri/prizeinterphone/state/TalkBackStateMachine;)Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;

    move-result-object p0

    invoke-virtual {p0}, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->showLimitRecordTime()V

    goto/16 :goto_0

    .line 291
    :cond_4
    iget-object p1, p0, Lcom/pri/prizeinterphone/state/TalkBackStateMachine$RecordSoundState;->this$0:Lcom/pri/prizeinterphone/state/TalkBackStateMachine;

    invoke-static {p1}, Lcom/pri/prizeinterphone/state/TalkBackStateMachine;->-$$Nest$fgetfragment(Lcom/pri/prizeinterphone/state/TalkBackStateMachine;)Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;

    move-result-object p1

    invoke-virtual {p1}, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->isSendStatus()Z

    move-result p1

    if-eqz p1, :cond_5

    return v4

    .line 294
    :cond_5
    iget-object p1, p0, Lcom/pri/prizeinterphone/state/TalkBackStateMachine$RecordSoundState;->this$0:Lcom/pri/prizeinterphone/state/TalkBackStateMachine;

    invoke-static {p1}, Lcom/pri/prizeinterphone/state/TalkBackStateMachine;->-$$Nest$fgetfragment(Lcom/pri/prizeinterphone/state/TalkBackStateMachine;)Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;

    move-result-object p1

    invoke-virtual {p1}, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->launchCommand()V

    .line 295
    iget-object p1, p0, Lcom/pri/prizeinterphone/state/TalkBackStateMachine$RecordSoundState;->this$0:Lcom/pri/prizeinterphone/state/TalkBackStateMachine;

    invoke-static {p1}, Lcom/pri/prizeinterphone/state/TalkBackStateMachine;->-$$Nest$fgetfragment(Lcom/pri/prizeinterphone/state/TalkBackStateMachine;)Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;

    move-result-object p1

    invoke-virtual {p1}, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->createRecordFile()V

    .line 296
    iget-object p1, p0, Lcom/pri/prizeinterphone/state/TalkBackStateMachine$RecordSoundState;->this$0:Lcom/pri/prizeinterphone/state/TalkBackStateMachine;

    invoke-static {p1}, Lcom/pri/prizeinterphone/state/TalkBackStateMachine;->-$$Nest$fgetfragment(Lcom/pri/prizeinterphone/state/TalkBackStateMachine;)Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;

    move-result-object p1

    invoke-virtual {p1}, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->startPcmRecord()I

    move-result p1

    if-gez p1, :cond_6

    .line 299
    iget-object p1, p0, Lcom/pri/prizeinterphone/state/TalkBackStateMachine$RecordSoundState;->this$0:Lcom/pri/prizeinterphone/state/TalkBackStateMachine;

    invoke-static {p1}, Lcom/pri/prizeinterphone/state/TalkBackStateMachine;->-$$Nest$fgetfragment(Lcom/pri/prizeinterphone/state/TalkBackStateMachine;)Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;

    move-result-object p1

    invoke-virtual {p1, v2}, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->showToast(I)V

    .line 300
    iget-object p1, p0, Lcom/pri/prizeinterphone/state/TalkBackStateMachine$RecordSoundState;->this$0:Lcom/pri/prizeinterphone/state/TalkBackStateMachine;

    invoke-static {p1}, Lcom/pri/prizeinterphone/state/TalkBackStateMachine;->-$$Nest$fgetfragment(Lcom/pri/prizeinterphone/state/TalkBackStateMachine;)Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;

    move-result-object p1

    invoke-virtual {p1, v3}, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->setTalkbackRecordBg(I)V

    .line 301
    iget-object p1, p0, Lcom/pri/prizeinterphone/state/TalkBackStateMachine$RecordSoundState;->this$0:Lcom/pri/prizeinterphone/state/TalkBackStateMachine;

    invoke-static {p1}, Lcom/pri/prizeinterphone/state/TalkBackStateMachine;->-$$Nest$fgetfragment(Lcom/pri/prizeinterphone/state/TalkBackStateMachine;)Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;

    move-result-object p1

    invoke-virtual {p1}, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->stopPcmRecord()V

    .line 302
    iget-object p0, p0, Lcom/pri/prizeinterphone/state/TalkBackStateMachine$RecordSoundState;->this$0:Lcom/pri/prizeinterphone/state/TalkBackStateMachine;

    invoke-static {p0}, Lcom/pri/prizeinterphone/state/TalkBackStateMachine;->-$$Nest$fgetmSendExceptionState(Lcom/pri/prizeinterphone/state/TalkBackStateMachine;)Lcom/pri/prizeinterphone/state/State;

    move-result-object p1

    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/state/StateMachine;->transitionTo(Lcom/pri/prizeinterphone/state/IState;)V

    return v4

    .line 305
    :cond_6
    iget-object p1, p0, Lcom/pri/prizeinterphone/state/TalkBackStateMachine$RecordSoundState;->this$0:Lcom/pri/prizeinterphone/state/TalkBackStateMachine;

    invoke-static {p1}, Lcom/pri/prizeinterphone/state/TalkBackStateMachine;->-$$Nest$fgetfragment(Lcom/pri/prizeinterphone/state/TalkBackStateMachine;)Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;

    move-result-object p1

    invoke-virtual {p1, v4}, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->setSendStatus(I)V

    .line 306
    iget-object p1, p0, Lcom/pri/prizeinterphone/state/TalkBackStateMachine$RecordSoundState;->this$0:Lcom/pri/prizeinterphone/state/TalkBackStateMachine;

    invoke-static {p1}, Lcom/pri/prizeinterphone/state/TalkBackStateMachine;->-$$Nest$fgetfragment(Lcom/pri/prizeinterphone/state/TalkBackStateMachine;)Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;

    move-result-object p1

    invoke-virtual {p1, v4}, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->setTalkbackRecordBg(I)V

    .line 307
    iget-object p0, p0, Lcom/pri/prizeinterphone/state/TalkBackStateMachine$RecordSoundState;->this$0:Lcom/pri/prizeinterphone/state/TalkBackStateMachine;

    invoke-virtual {p0, v8}, Lcom/pri/prizeinterphone/state/StateMachine;->obtainMessage(I)Landroid/os/Message;

    move-result-object p1

    const-wide/16 v0, 0x1f4

    invoke-virtual {p0, p1, v0, v1}, Lcom/pri/prizeinterphone/state/StateMachine;->sendMessageDelayed(Landroid/os/Message;J)V

    goto/16 :goto_0

    .line 367
    :cond_7
    iget-object p0, p0, Lcom/pri/prizeinterphone/state/TalkBackStateMachine$RecordSoundState;->this$0:Lcom/pri/prizeinterphone/state/TalkBackStateMachine;

    invoke-virtual {p0, v11, v6}, Lcom/pri/prizeinterphone/state/StateMachine;->obtainMessage(II)Landroid/os/Message;

    move-result-object p1

    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/state/StateMachine;->sendMessage(Landroid/os/Message;)V

    goto/16 :goto_0

    .line 364
    :cond_8
    iget-object p0, p0, Lcom/pri/prizeinterphone/state/TalkBackStateMachine$RecordSoundState;->this$0:Lcom/pri/prizeinterphone/state/TalkBackStateMachine;

    invoke-virtual {p0, v11, v7}, Lcom/pri/prizeinterphone/state/StateMachine;->obtainMessage(II)Landroid/os/Message;

    move-result-object p1

    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/state/StateMachine;->sendMessage(Landroid/os/Message;)V

    goto/16 :goto_0

    .line 329
    :cond_9
    iget-object v0, p0, Lcom/pri/prizeinterphone/state/TalkBackStateMachine$RecordSoundState;->this$0:Lcom/pri/prizeinterphone/state/TalkBackStateMachine;

    invoke-virtual {v0, v8}, Lcom/pri/prizeinterphone/state/StateMachine;->removeMessages(I)V

    .line 330
    iget-object v0, p0, Lcom/pri/prizeinterphone/state/TalkBackStateMachine$RecordSoundState;->this$0:Lcom/pri/prizeinterphone/state/TalkBackStateMachine;

    invoke-static {v0}, Lcom/pri/prizeinterphone/state/TalkBackStateMachine;->-$$Nest$fgetfragment(Lcom/pri/prizeinterphone/state/TalkBackStateMachine;)Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;

    move-result-object v0

    invoke-virtual {v0}, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->isSendStatus()Z

    move-result v0

    if-nez v0, :cond_a

    return v4

    .line 333
    :cond_a
    iget-object v0, p0, Lcom/pri/prizeinterphone/state/TalkBackStateMachine$RecordSoundState;->this$0:Lcom/pri/prizeinterphone/state/TalkBackStateMachine;

    invoke-static {v0}, Lcom/pri/prizeinterphone/state/TalkBackStateMachine;->-$$Nest$fgetfragment(Lcom/pri/prizeinterphone/state/TalkBackStateMachine;)Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;

    move-result-object v0

    invoke-virtual {v0}, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->launchEnd()V

    .line 334
    iget-object v0, p0, Lcom/pri/prizeinterphone/state/TalkBackStateMachine$RecordSoundState;->this$0:Lcom/pri/prizeinterphone/state/TalkBackStateMachine;

    invoke-static {v0}, Lcom/pri/prizeinterphone/state/TalkBackStateMachine;->-$$Nest$fgetfragment(Lcom/pri/prizeinterphone/state/TalkBackStateMachine;)Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;

    move-result-object v0

    invoke-virtual {v0}, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->stopPcmRecord()V

    .line 335
    iget-object v0, p0, Lcom/pri/prizeinterphone/state/TalkBackStateMachine$RecordSoundState;->this$0:Lcom/pri/prizeinterphone/state/TalkBackStateMachine;

    invoke-static {v0}, Lcom/pri/prizeinterphone/state/TalkBackStateMachine;->-$$Nest$fgetfragment(Lcom/pri/prizeinterphone/state/TalkBackStateMachine;)Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;

    move-result-object v0

    invoke-virtual {v0}, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->setStopRecordPrepare()V

    .line 336
    iget-object v0, p0, Lcom/pri/prizeinterphone/state/TalkBackStateMachine$RecordSoundState;->this$0:Lcom/pri/prizeinterphone/state/TalkBackStateMachine;

    invoke-static {v0}, Lcom/pri/prizeinterphone/state/TalkBackStateMachine;->-$$Nest$fgetfragment(Lcom/pri/prizeinterphone/state/TalkBackStateMachine;)Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;

    move-result-object v0

    invoke-virtual {v0, v3}, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->setSendStatus(I)V

    .line 337
    iget-object v0, p0, Lcom/pri/prizeinterphone/state/TalkBackStateMachine$RecordSoundState;->this$0:Lcom/pri/prizeinterphone/state/TalkBackStateMachine;

    invoke-static {v0}, Lcom/pri/prizeinterphone/state/TalkBackStateMachine;->-$$Nest$fgetmIdleState(Lcom/pri/prizeinterphone/state/TalkBackStateMachine;)Lcom/pri/prizeinterphone/state/TalkBackStateMachine$IdleState;

    move-result-object v2

    invoke-virtual {v0, v2}, Lcom/pri/prizeinterphone/state/StateMachine;->transitionTo(Lcom/pri/prizeinterphone/state/IState;)V

    .line 338
    iget p1, p1, Landroid/os/Message;->arg1:I

    if-ne p1, v6, :cond_b

    .line 339
    iget-object p0, p0, Lcom/pri/prizeinterphone/state/TalkBackStateMachine$RecordSoundState;->this$0:Lcom/pri/prizeinterphone/state/TalkBackStateMachine;

    invoke-virtual {p0, v9}, Lcom/pri/prizeinterphone/state/StateMachine;->obtainMessage(I)Landroid/os/Message;

    move-result-object p1

    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/state/StateMachine;->sendMessage(Landroid/os/Message;)V

    goto/16 :goto_0

    :cond_b
    if-ne p1, v5, :cond_c

    .line 341
    iget-object p1, p0, Lcom/pri/prizeinterphone/state/TalkBackStateMachine$RecordSoundState;->this$0:Lcom/pri/prizeinterphone/state/TalkBackStateMachine;

    invoke-static {p1}, Lcom/pri/prizeinterphone/state/TalkBackStateMachine;->-$$Nest$fgetmRelayConnectionFailedState(Lcom/pri/prizeinterphone/state/TalkBackStateMachine;)Lcom/pri/prizeinterphone/state/State;

    move-result-object v0

    invoke-virtual {p1, v0}, Lcom/pri/prizeinterphone/state/StateMachine;->transitionTo(Lcom/pri/prizeinterphone/state/IState;)V

    .line 342
    iget-object p0, p0, Lcom/pri/prizeinterphone/state/TalkBackStateMachine$RecordSoundState;->this$0:Lcom/pri/prizeinterphone/state/TalkBackStateMachine;

    invoke-virtual {p0, v1}, Lcom/pri/prizeinterphone/state/StateMachine;->sendMessage(I)V

    goto/16 :goto_0

    :cond_c
    if-ne p1, v7, :cond_10

    .line 344
    iget-object p1, p0, Lcom/pri/prizeinterphone/state/TalkBackStateMachine$RecordSoundState;->this$0:Lcom/pri/prizeinterphone/state/TalkBackStateMachine;

    invoke-static {p1}, Lcom/pri/prizeinterphone/state/TalkBackStateMachine;->-$$Nest$fgetmReceiveSoundState(Lcom/pri/prizeinterphone/state/TalkBackStateMachine;)Lcom/pri/prizeinterphone/state/State;

    move-result-object v0

    invoke-virtual {p1, v0}, Lcom/pri/prizeinterphone/state/StateMachine;->transitionTo(Lcom/pri/prizeinterphone/state/IState;)V

    .line 345
    iget-object p0, p0, Lcom/pri/prizeinterphone/state/TalkBackStateMachine$RecordSoundState;->this$0:Lcom/pri/prizeinterphone/state/TalkBackStateMachine;

    invoke-virtual {p0, v10}, Lcom/pri/prizeinterphone/state/StateMachine;->obtainMessage(I)Landroid/os/Message;

    move-result-object p1

    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/state/StateMachine;->sendMessage(Landroid/os/Message;)V

    goto :goto_0

    .line 272
    :cond_d
    iget-object p1, p0, Lcom/pri/prizeinterphone/state/TalkBackStateMachine$RecordSoundState;->this$0:Lcom/pri/prizeinterphone/state/TalkBackStateMachine;

    invoke-static {p1}, Lcom/pri/prizeinterphone/state/TalkBackStateMachine;->-$$Nest$fgetfragment(Lcom/pri/prizeinterphone/state/TalkBackStateMachine;)Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;

    move-result-object p1

    invoke-virtual {p1}, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->isSendStatus()Z

    move-result p1

    if-eqz p1, :cond_e

    return v4

    .line 275
    :cond_e
    iget-object p1, p0, Lcom/pri/prizeinterphone/state/TalkBackStateMachine$RecordSoundState;->this$0:Lcom/pri/prizeinterphone/state/TalkBackStateMachine;

    invoke-static {p1}, Lcom/pri/prizeinterphone/state/TalkBackStateMachine;->-$$Nest$fgetfragment(Lcom/pri/prizeinterphone/state/TalkBackStateMachine;)Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;

    move-result-object p1

    invoke-virtual {p1}, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->launchCommand()V

    .line 276
    iget-object p1, p0, Lcom/pri/prizeinterphone/state/TalkBackStateMachine$RecordSoundState;->this$0:Lcom/pri/prizeinterphone/state/TalkBackStateMachine;

    invoke-static {p1}, Lcom/pri/prizeinterphone/state/TalkBackStateMachine;->-$$Nest$fgetfragment(Lcom/pri/prizeinterphone/state/TalkBackStateMachine;)Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;

    move-result-object p1

    invoke-virtual {p1}, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->createRecordFile()V

    .line 277
    iget-object p1, p0, Lcom/pri/prizeinterphone/state/TalkBackStateMachine$RecordSoundState;->this$0:Lcom/pri/prizeinterphone/state/TalkBackStateMachine;

    invoke-static {p1}, Lcom/pri/prizeinterphone/state/TalkBackStateMachine;->-$$Nest$fgetfragment(Lcom/pri/prizeinterphone/state/TalkBackStateMachine;)Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;

    move-result-object p1

    invoke-virtual {p1}, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->startPcmRecord()I

    move-result p1

    if-gez p1, :cond_f

    .line 280
    iget-object p1, p0, Lcom/pri/prizeinterphone/state/TalkBackStateMachine$RecordSoundState;->this$0:Lcom/pri/prizeinterphone/state/TalkBackStateMachine;

    invoke-static {p1}, Lcom/pri/prizeinterphone/state/TalkBackStateMachine;->-$$Nest$fgetfragment(Lcom/pri/prizeinterphone/state/TalkBackStateMachine;)Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;

    move-result-object p1

    invoke-virtual {p1, v2}, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->showToast(I)V

    .line 281
    iget-object p1, p0, Lcom/pri/prizeinterphone/state/TalkBackStateMachine$RecordSoundState;->this$0:Lcom/pri/prizeinterphone/state/TalkBackStateMachine;

    invoke-static {p1}, Lcom/pri/prizeinterphone/state/TalkBackStateMachine;->-$$Nest$fgetfragment(Lcom/pri/prizeinterphone/state/TalkBackStateMachine;)Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;

    move-result-object p1

    invoke-virtual {p1, v3}, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->setTalkbackRecordBg(I)V

    .line 282
    iget-object p1, p0, Lcom/pri/prizeinterphone/state/TalkBackStateMachine$RecordSoundState;->this$0:Lcom/pri/prizeinterphone/state/TalkBackStateMachine;

    invoke-static {p1}, Lcom/pri/prizeinterphone/state/TalkBackStateMachine;->-$$Nest$fgetfragment(Lcom/pri/prizeinterphone/state/TalkBackStateMachine;)Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;

    move-result-object p1

    invoke-virtual {p1}, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->stopPcmRecord()V

    .line 283
    iget-object p0, p0, Lcom/pri/prizeinterphone/state/TalkBackStateMachine$RecordSoundState;->this$0:Lcom/pri/prizeinterphone/state/TalkBackStateMachine;

    invoke-static {p0}, Lcom/pri/prizeinterphone/state/TalkBackStateMachine;->-$$Nest$fgetmSendExceptionState(Lcom/pri/prizeinterphone/state/TalkBackStateMachine;)Lcom/pri/prizeinterphone/state/State;

    move-result-object p1

    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/state/StateMachine;->transitionTo(Lcom/pri/prizeinterphone/state/IState;)V

    return v4

    .line 286
    :cond_f
    iget-object p1, p0, Lcom/pri/prizeinterphone/state/TalkBackStateMachine$RecordSoundState;->this$0:Lcom/pri/prizeinterphone/state/TalkBackStateMachine;

    invoke-static {p1}, Lcom/pri/prizeinterphone/state/TalkBackStateMachine;->-$$Nest$fgetfragment(Lcom/pri/prizeinterphone/state/TalkBackStateMachine;)Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;

    move-result-object p1

    invoke-virtual {p1}, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->setStartRecordPrepare()V

    .line 287
    iget-object p1, p0, Lcom/pri/prizeinterphone/state/TalkBackStateMachine$RecordSoundState;->this$0:Lcom/pri/prizeinterphone/state/TalkBackStateMachine;

    invoke-static {p1}, Lcom/pri/prizeinterphone/state/TalkBackStateMachine;->-$$Nest$fgetfragment(Lcom/pri/prizeinterphone/state/TalkBackStateMachine;)Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;

    move-result-object p1

    invoke-virtual {p1}, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->showLimitRecordTime()V

    .line 288
    iget-object p0, p0, Lcom/pri/prizeinterphone/state/TalkBackStateMachine$RecordSoundState;->this$0:Lcom/pri/prizeinterphone/state/TalkBackStateMachine;

    invoke-static {p0}, Lcom/pri/prizeinterphone/state/TalkBackStateMachine;->-$$Nest$fgetfragment(Lcom/pri/prizeinterphone/state/TalkBackStateMachine;)Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;

    move-result-object p0

    invoke-virtual {p0, v4}, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->setSendStatus(I)V

    :cond_10
    :goto_0
    return v4

    :pswitch_data_0
    .packed-switch 0x7e4
        :pswitch_3
        :pswitch_2
        :pswitch_1
        :pswitch_0
    .end packed-switch
.end method
